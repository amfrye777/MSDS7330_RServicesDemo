USE RServicesDemo
GO

IF EXISTS(SELECT * FROM sys.objects WHERE parent_object_id = OBJECT_ID('dbo.StatusCode') AND type = 'D')
    ALTER TABLE dbo.StatusCode    DROP CONSTRAINT     DF_StatusCode_CreatedDate
GO

ALTER TABLE dbo.StatusCode    ADD CONSTRAINT     DF_StatusCode_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate
GO
