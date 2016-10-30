USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.RPlot') and [name] = 'PK_RPlot')
    ALTER TABLE dbo.RPlot DROP CONSTRAINT PK_RPlot 
GO

ALTER TABLE dbo.RPlot ADD CONSTRAINT PK_RPlot PRIMARY KEY CLUSTERED
(
    RPlotID
) WITH (FILLFACTOR = 80) ON [Primary]
GO
