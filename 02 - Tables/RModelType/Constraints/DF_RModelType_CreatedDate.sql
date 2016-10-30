USE RServicesDemo
GO

IF EXISTS(SELECT * FROM sys.objects WHERE parent_object_id = OBJECT_ID('dbo.RModelType') AND type = 'D')
    ALTER TABLE dbo.RModelType    DROP CONSTRAINT     DF_RModelType_CreatedDate
GO

ALTER TABLE dbo.RModelType    ADD CONSTRAINT     DF_RModelType_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate
GO
