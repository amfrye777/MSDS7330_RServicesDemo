USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.TumorDiag#Predict') AND type in (N'P', N'PC'))
    DROP PROCEDURE dbo.TumorDiag#Predict
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************************
Created By    : Alex Frye / Chris Boomhower / Lindsay Vitovsky
Create Date   : 10/24/2016
Course #      : MSDS7330
Description   : Calls the Prediction Model from the RModel Table for Tumor Diagnosis and applies 
                to inputted data parameters.
******************************************************************************************/
/******************************************************************************************
Modified By   : 
modified Date : 
Work Request  : 
Description   : 
******************************************************************************************/
/******************************************************************************************

DECLARE @Debug TINYINT = 0,
        @TumorDiagPredict TumorDiagPredictTableType,
        @PredictionResult   CHAR(1),
        @PctConfident       DECIMAL(18,4)

INSERT INTO @TumorDiagPredict
    (radius_mean,texture_mean,perimeter_mean,area_mean,smoothness_mean,compactness_mean,concavity_mean,concave_mean,symmetry_mean,fractal_dimension_mean,radius_se,texture_se,perimeter_se,area_se,smoothness_se,compactness_se,concavity_se,concave_se,symmetry_se,fractal_dimension_se,radius_worst,texture_worst,perimeter_worst,area_worst,smoothness_worst,compactness_worst,concavity_worst,concave_worst,symmetry_worst,fractal_dimension_worst)
SELECT  radius_mean             = NULL,
        texture_mean            = NULL,
        perimeter_mean          = NULL,
        area_mean               = NULL,
        smoothness_mean         = NULL,
        compactness_mean        = .11,
        concavity_mean          = NULL,
        concave_mean            = .04,
        symmetry_mean           = NULL,
        fractal_dimension_mean  = .065,
        radius_se               = .35,
        texture_se              = NULL,
        perimeter_se            = NULL,
        area_se                 = 40,
        smoothness_se           = .007,
        compactness_se          = 0.03,
        concavity_se            = .03,
        concave_se              = NULL,
        symmetry_se             = NULL,
        fractal_dimension_se    = NULL,
        radius_worst            = 17.5,
        texture_worst           = 26.5,
        perimeter_worst         = NULL,
        area_worst              = 900,
        smoothness_worst        = NULL,
        compactness_worst       = NULL,
        concavity_worst         = .25,
        concave_worst           = .06,
        symmetry_worst          = .0285,
        fractal_dimension_worst = .088

--SELECT  TOP 1
--         radius_mean             = radius_mean             
--        ,texture_mean            = texture_mean            
--        ,perimeter_mean          = perimeter_mean          
--        ,area_mean               = area_mean               
--        ,smoothness_mean         = smoothness_mean         
--        ,compactness_mean        = compactness_mean        
--        ,concavity_mean          = concavity_mean          
--        ,concave_mean            = concave_mean            
--        ,symmetry_mean           = symmetry_mean           
--        ,fractal_dimension_mean  = fractal_dimension_mean  
--        ,radius_se               = radius_se               
--        ,texture_se              = texture_se              
--        ,perimeter_se            = perimeter_se            
--        ,area_se                 = area_se                 
--        ,smoothness_se           = smoothness_se           
--        ,compactness_se          = compactness_se          
--        ,concavity_se            = concavity_se            
--        ,concave_se              = concave_se              
--        ,symmetry_se             = symmetry_se             
--        ,fractal_dimension_se    = fractal_dimension_se    
--        ,radius_worst            = radius_worst            
--        ,texture_worst           = texture_worst           
--        ,perimeter_worst         = perimeter_worst         
--        ,area_worst              = area_worst              
--        ,smoothness_worst        = smoothness_worst        
--        ,compactness_worst       = compactness_worst       
--        ,concavity_worst         = concavity_worst         
--        ,concave_worst           = concave_worst           
--        ,symmetry_worst          = symmetry_worst          
--        ,fractal_dimension_worst = fractal_dimension_worst 
--from TumorStatistics
--where Diagnosis = 'B'

SELECT * FROM @TumorDiagPredict

EXEC dbo.TumorDiag#Predict @TumorDiagPredict = @TumorDiagPredict, 
                           @PredictionResult = @PredictionResult OUTPUT,
                           @PctConfident     = @PctConfident OUTPUT--, 
                           --@Debug = @Debug

SELECT @PredictionResult
SELECT @PctConfident 
******************************************************************************************/
CREATE PROCEDURE dbo.TumorDiag#Predict
    @TumorDiagPredict TumorDiagPredictTableType READONLY,
    @PredictionResult   CHAR(1)                 OUTPUT,
    @PctConfident       DECIMAL(18,4)         OUTPUT,
    @Debug  TINYINT = 0 
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

BEGIN TRY

    DECLARE @DAModel            VARBINARY(MAX),
            @Input_Data_1_SQL   NVARCHAR(MAX)   = N'',
            @script             NVARCHAR(MAX)   = N'',
            @ErrorMessage       VARCHAR(500)


    SELECT @DAModel     =   SerialValue
    FROM dbo.RModel
    WHERE RModelTypeID = 1
      AND StatusCodeID = 0


    SELECT @Input_Data_1_SQL = N'SELECT '                                                                                      
                                + 'radius_mean = '                + ISNULL(CAST(radius_mean               AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'texture_mean = '               + ISNULL(CAST(texture_mean              AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'perimeter_mean = '             + ISNULL(CAST(perimeter_mean            AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'area_mean = '                  + ISNULL(CAST(area_mean                 AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'smoothness_mean = '            + ISNULL(CAST(smoothness_mean           AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'compactness_mean = '           + ISNULL(CAST(compactness_mean          AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'concavity_mean = '             + ISNULL(CAST(concavity_mean            AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'concave_mean = '               + ISNULL(CAST(concave_mean              AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'symmetry_mean = '              + ISNULL(CAST(symmetry_mean             AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'fractal_dimension_mean = '     + ISNULL(CAST(fractal_dimension_mean    AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'radius_se = '                  + ISNULL(CAST(radius_se                 AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'texture_se = '                 + ISNULL(CAST(texture_se                AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'perimeter_se = '               + ISNULL(CAST(perimeter_se              AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'area_se = '                    + ISNULL(CAST(area_se                   AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'smoothness_se = '              + ISNULL(CAST(smoothness_se             AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'compactness_se = '             + ISNULL(CAST(compactness_se            AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'concavity_se = '               + ISNULL(CAST(concavity_se              AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'concave_se = '                 + ISNULL(CAST(concave_se                AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'symmetry_se = '                + ISNULL(CAST(symmetry_se               AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'fractal_dimension_se = '       + ISNULL(CAST(fractal_dimension_se      AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'radius_worst = '               + ISNULL(CAST(radius_worst              AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'texture_worst = '              + ISNULL(CAST(texture_worst             AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'perimeter_worst = '            + ISNULL(CAST(perimeter_worst           AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'area_worst = '                 + ISNULL(CAST(area_worst                AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'smoothness_worst = '           + ISNULL(CAST(smoothness_worst          AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'compactness_worst = '          + ISNULL(CAST(compactness_worst         AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'concavity_worst = '            + ISNULL(CAST(concavity_worst           AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'concave_worst = '              + ISNULL(CAST(concave_worst             AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10)
                                + 'symmetry_worst = '             + ISNULL(CAST(symmetry_worst            AS VARCHAR(20)),'NULL') + ', '     + CHAR(13) + CHAR(10) 
                                + 'fractal_dimension_worst = '    + ISNULL(CAST(fractal_dimension_worst   AS VARCHAR(20)),'NULL')
    FROM @TumorDiagPredict


    EXECUTE sys.sp_execute_external_script
		              @language = N'R'
		             ,@script               = N'

DAModel <-unserialize(DAModelSerialized)

predict          <- predict(DAModel, TumorDiagPredict)

PredictionResult <- predict$class[1]

if (PredictionResult == "B"){
    PctConfident     <- round(predict$posterior[1] * 100,4)
} else {
    PctConfident     <- round(predict$posterior[2] * 100,4)
}
'
                     ,@input_data_1         = @Input_Data_1_SQL
		             ,@Input_data_1_name    = N'TumorDiagPredict'
                     ,@params               = N'@DAModelSerialized    VARBINARY(MAX),
                                                @PredictionResult     CHAR(1)             OUTPUT,
                                                @PctConfident         DECIMAL(18,4)       OUTPUT'  
                     ,@DAModelSerialized    = @DAModel
                     ,@PredictionResult     = @PredictionResult     OUTPUT
                     ,@PctConfident         = @PctConfident         OUTPUT



END TRY
BEGIN CATCH
    SELECT @ErrorMessage = ERROR_MESSAGE()

    RAISERROR(@ErrorMessage,18,1)
END CATCH

GO
