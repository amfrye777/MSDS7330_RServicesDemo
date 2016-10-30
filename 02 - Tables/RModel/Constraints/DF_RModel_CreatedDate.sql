USE RServicesDemo
GO

IF EXISTS(SELECT * FROM sys.objects WHERE parent_object_id = OBJECT_ID('dbo.RModel') AND type = 'D')
    ALTER TABLE dbo.RModel    DROP CONSTRAINT     DF_RModel_CreatedDate
GO

ALTER TABLE dbo.RModel    ADD CONSTRAINT     DF_RModel_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate
GO
