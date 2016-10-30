USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.TumorDiag#Build') AND type in (N'P', N'PC'))
    DROP PROCEDURE dbo.TumorDiag#Build
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************************
Created By    : Alex Frye / Chris Boomhower / Lindsay Vitovsky
Create Date   : 10/24/2016 
Course #      : MSDS7330
Description   : Builds the prediction model for TumorDiagnosis based on data in the 
                TumorStatistics Table
******************************************************************************************/
/******************************************************************************************
Modified By   : 
modified Date : 
Work Request  : 
Description   : 
******************************************************************************************/
/******************************************************************************************

    DECLARE @Debug      TINYINT = 0

    EXEC dbo.TumorDiag#Build @Debug         = @Debug
    
    SELECT * FROM dbo.RModel WHERE RModelTypeID = 1
       
******************************************************************************************/
CREATE PROCEDURE dbo.TumorDiag#Build
    @Debug      TINYINT = 0
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

BEGIN TRY

    DECLARE @DAModel            VARBINARY(MAX),
            @RModelName         VARCHAR(150),
            @RModelDesc         VARCHAR(MAX),
            @Input_Data_1_SQL   NVARCHAR(MAX)   = N'',
            @script             NVARCHAR(MAX)   = N'',
            @ErrorMessage       VARCHAR(500)

    SELECT @Input_Data_1_SQL = N'SELECT ID,Diagnosis,radius_mean,texture_mean,perimeter_mean,area_mean,smoothness_mean,compactness_mean,'                                                   + CHAR(13) + CHAR(10) + 
                               N'       concavity_mean,concave_mean,symmetry_mean,fractal_dimension_mean,radius_se,texture_se,perimeter_se,'                                                + CHAR(13) + CHAR(10) + 
                               N'       area_se,smoothness_se,compactness_se,concavity_se,concave_se,symmetry_se,fractal_dimension_se,radius_worst,'                                        + CHAR(13) + CHAR(10) + 
                               N'       texture_worst,perimeter_worst,area_worst,smoothness_worst,compactness_worst,concavity_worst,concave_worst,symmetry_worst,fractal_dimension_worst'   + CHAR(13) + CHAR(10) +  
                               N'FROM TumorStatistics'                                                                                                                                      + CHAR(13) + CHAR(10) + 
                               N'WHERE Diagnosis IS NOT NULL'


    SELECT @script = N'
    library(MASS)
    library(klaR)

    train <- TumorStats[sample(nrow(TumorStats), round(nrow(TumorStats)/2 ,0)), ]

    testRows <- !(TumorStats$ID %in% train$ID)
    test <- TumorStats[testRows,]

    # run wilkes lambda stepwise variable selection
    VariableSelect <- greedy.wilks(Diagnosis ~  radius_mean  + 
                                     texture_mean            + 
                                     perimeter_mean          + 
                                     area_mean               + 
                                     smoothness_mean         + 
                                     compactness_mean        +
                                     concavity_mean          +
                                     concave_mean            +
                                     symmetry_mean           +
                                     fractal_dimension_mean  +
                                     radius_se               +
                                     texture_se              +
                                     perimeter_se            +
                                     area_se                 +
                                     smoothness_se           +
                                     compactness_se          +
                                     concavity_se            +
                                     concave_se              +
                                     symmetry_se             +
                                     fractal_dimension_se    +
                                     radius_worst            +
                                     texture_worst           +
                                     perimeter_worst         +
                                     area_worst              +
                                     smoothness_worst        +
                                     compactness_worst       +
                                     concavity_worst         +
                                     concave_worst           +
                                     symmetry_worst          +
                                     fractal_dimension_worst
                                   ,data = TumorStats
                                   ,niveau = 0.05)

    ## LDA fit
    LDA.fit <- lda(VariableSelect$formula, data=train)

    ## LDA predict class
    LDA.class <- predict(LDA.fit, test)$class

    ## Identify LDA Accuracy
    LDA.Accuracy <- mean(LDA.class==test$Diagnosis)

    ## QDA fit
    QDA.fit <- qda(VariableSelect$formula, data=train)

    ## QDA predict class
    QDA.class <- predict(QDA.fit, test)$class

    ## Identify QDA Accuracy
    QDA.Accuracy <- mean(QDA.class == test$Diagnosis)

    if (LDA.Accuracy > QDA.Accuracy) {
        DAModel     <- LDA.fit
        RModelName  <- "Tumor Diagnosis LDA Model"
        RModelDesc  <- paste("LDA Fit Model with the given formula: 
",VariableSelect$formula[2],VariableSelect$formula[1],VariableSelect$formula[3])
    } else {
        DAModel     <- QDA.fit
        RModelName  <- "Tumor Diagnosis QDA Model"
        RModelDesc  <- paste("QDA Fit Model with the given formula: 
",VariableSelect$formula[2],VariableSelect$formula[1],VariableSelect$formula[3])
    }
    
    DAModel <-as.raw(serialize(DAModel,connection = NULL))
    '


    IF @debug = 1
    BEGIN
        SELECT @Input_Data_1_SQL
        SELECT @script
    END
    ELSE
    BEGIN
        EXECUTE sys.sp_execute_external_script
		          @language = N'R'
		         ,@script               = @script
		         ,@input_data_1		    = @Input_Data_1_SQL
		         ,@input_data_1_name    = N'TumorStats'
                 ,@params               = N'@DAModel    VARBINARY(MAX) OUTPUT,
                                            @RModelName VARCHAR(150)   OUTPUT,
                                            @RModelDesc VARCHAR(MAX)   OUTPUT'  
                 ,@DAModel              = @DAModel      OUTPUT
                 ,@RModelName           = @RModelName   OUTPUT
                 ,@RModelDesc           = @RModelDesc   OUTPUT; 
    END

    -- Inactivate all models for Tumor Diagnosis if name is different than chosen model during execution
        -- Activate model if present
UPDATE RM
SET RModelDesc      = CASE WHEN RModel = @RModelName THEN @RModelDesc
                           ELSE RModelDesc
                      END,
    StatusCodeID    = CASE WHEN RModel = @RModelName THEN 0
                           ELSE 1
                      END,
    SerialValue     = CASE WHEN RModel = @RModelName THEN @DAModel
                           ELSE SerialValue
                      END,
        
    BuildProcName   = CASE WHEN RModel = @RModelName THEN OBJECT_NAME(@@PROCID)
                           ELSE BuildProcName
                    END,
    ModifiedDate = GETDATE()
FROM dbo.RModel RM
WHERE RModelTypeID =    1
  AND StatusCodeID =    CASE WHEN RModel = @RModelName THEN StatusCodeID
                             ELSE 0
                        END

    -- Insert Model into table if does not already exist
IF NOT EXISTS(SELECT 1 FROM dbo.RModel WHERE RModel = @RModelName)
BEGIN
    INSERT INTO dbo.RModel
        (RModel,        RModelDesc,     RModelTypeID,   StatusCodeID,   SerialValue,    BuildProcName) VALUES
        (@RModelName,   @RModelDesc,    1,              0,              @DAModel,       OBJECT_NAME(@@PROCID))
END

    -- ReBuild BoxPlots to keep in sync with data used to build the models.
EXEC dbo.TumorStatBoxPlot#Build @Debug 

END TRY
BEGIN CATCH
    SELECT @ErrorMessage = ERROR_MEssage()

    RAISERROR(@ErrorMessage,18,1)
END CATCH

GO
