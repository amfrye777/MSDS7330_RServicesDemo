USE RServicesDemo
GO

IF OBJECT_ID('dbo.RPlot') IS NOT NULL 
    DROP TABLE dbo.RPlot

CREATE TABLE dbo.RPlot (
    RPlotID                    INT               IDENTITY(1,1)  NOT NULL,
    RPlot                      VARCHAR(150)                     NOT NULL,
    RPlotDesc                  VARCHAR(250)                         NULL,
    SerialValue                VARBINARY(MAX)                       NULL,
    CreatedDate                DATETIME2                        NOT NULL,
    ModifiedDate               DATETIME2                            NULL
)

GO
