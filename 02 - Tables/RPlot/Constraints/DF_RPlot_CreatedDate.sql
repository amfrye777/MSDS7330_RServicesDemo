USE RServicesDemo
GO

IF EXISTS(SELECT * FROM sys.objects WHERE parent_object_id = OBJECT_ID('dbo.RPlot') AND type = 'D')
    ALTER TABLE dbo.RPlot    DROP CONSTRAINT     DF_RPlot_CreatedDate
GO

ALTER TABLE dbo.RPlot    ADD CONSTRAINT     DF_RPlot_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate
GO
