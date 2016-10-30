USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.TumorStatBoxPlot#Build') AND type in (N'P', N'PC'))
    DROP PROCEDURE dbo.TumorStatBoxPlot#Build
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************************
Created By    : Alex Frye / Chris Boomhower / Lindsay Vitovsky
Create Date   : 10/24/2016
Work Request  : MSDS7330
Description   : Create and Save BoxPlots for all explanatory variables from TumorStatistics.
                The boxplot will utilize ALL the data from TumorStatistics.
******************************************************************************************/
/******************************************************************************************
Modified By   : 
modified Date : 
Work Request  : 
Description   : 
******************************************************************************************/
/******************************************************************************************

DECLARE
    @Debug                  TINYINT     = 0

EXEC dbo.TumorStatBoxPlot#Build @Debug 

Select * from RPlot
   

******************************************************************************************/
CREATE PROCEDURE dbo.TumorStatBoxPlot#Build
    @Debug                  TINYINT                         = 0 
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

BEGIN TRY

    IF OBJECT_ID('tempdb..#PlotTemp')       IS NOT NULL     DROP TABLE #PlotTemp

    CREATE TABLE #PlotTemp (
        RPlot           VARCHAR(150), 
        RPlotDesc       VARCHAR(250),
        SerialValue     VARBINARY(MAX)
    )
 
    DECLARE @Input_Data_1_SQL   NVARCHAR(MAX)   = N'',
            @SQLStatement       NVARCHAR(MAX)   = N'',
            @SaveToDFScript     NVARCHAR(MAX)   = N'',
            @BoxPlotScript      NVARCHAR(MAX)   = N'',
            @PlotSerial         VARBINARY(MAX),
            @ErrorMessage       VARCHAR(500)

    
    SELECT @Input_Data_1_SQL = 'SELECT * FROM dbo.TumorStatistics'


    SELECT @SQLStatement    = @SQLStatement + '

SELECT @BoxPlotScript = ''
' + [name] + 'Plot = tempfile(); #create a temporary file
jpeg(filename = ' + [name] + 'Plot, width=500, height=500);
boxplot(' + [name] + ' ~ Diagnosis, 
        data        = TumorStats,
        main        = "' + [name] + ' by Diagnosis", 
        xlab        = "Diagnosis", 
        ylab        = "' + [name] + '",
        col         = c("blue","green")
       )
dev.off();

PlotSerial <- readBin(file(' + [name] + 'Plot,"rb"),what=raw(),n=1e6)
''

IF @Debug = 1
BEGIN
    SELECT @BoxPlotScript
END
ELSE -- @Debug  != 1
BEGIN
    EXECUTE sys.sp_execute_external_script
                @language             = N''R''
               ,@script               = @BoxPlotScript
               ,@input_data_1         = @Input_Data_1_SQL
               ,@Input_data_1_name    = N''TumorStats''
               ,@params               = N''@PlotSerial VARBINARY(MAX) OUTPUT''
               ,@PlotSerial           = @PlotSerial OUTPUT

    INSERT INTO #PlotTemp 
        (RPlot, RPlotDesc, SerialValue) VALUES
    (''TumorStat ' + [name] + ' BoxPlot'', ''BoxPlot of ' + [name] + ' by Diagnosis, created from full TumorStatistics Table'', @PlotSerial) 
END
' 
    FROM sys.columns 
    WHERE [object_id] = OBJECT_ID('TumorStatistics')
      AND [name] NOT IN ('ID', 'Diagnosis') 


    IF @Debug = 1
    BEGIN
        SELECT @SQLStatement
    END
    ELSE    -- @Debug != 1
    BEGIN
        EXEC sys.sp_executesql @SQLStatement,
                               @params              = N'@Input_Data_1_SQL   NVARCHAR(MAX),
                                                        @BoxPlotScript      NVARCHAR(MAX),
                                                        @PlotSerial         VARBINARY(MAX),
                                                        @Debug              TINYINT',
                               @Input_Data_1_SQL    = @Input_Data_1_SQL,
                               @BoxPlotScript       = @BoxPlotScript,
                               @PlotSerial          = @PlotSerial,
                               @Debug               = @Debug
    END

        -- Update RPlot if already exists 
    UPDATE RP
    SET RPlot           = PT.RPlot,
        RPlotDesc       = PT.RPlotDesc,
        SerialValue     = PT.SerialValue,
        ModifiedDate    = GETDATE()
    FROM #PlotTemp PT
    INNER JOIN dbo.RPlot RP         ON PT.RPlot = RP.RPlot

        -- Insert Plots into table if does not already exist
    INSERT INTO dbo.RPlot
        (RPlot,RPlotDesc,SerialValue,CreatedDate)
    SELECT PT.RPlot, PT.RPlotDesc, PT.SerialValue, GETDATE()
    FROM #PlotTemp PT
    LEFT OUTER JOIN dbo.RPlot RP    ON PT.RPlot = RP.RPlot
    WHERE RP.RPlot IS NULL

END TRY
BEGIN CATCH
    SELECT @ErrorMessage = ERROR_MESSAGE()

    RAISERROR(@ErrorMessage,18,1)
END CATCH

GO
