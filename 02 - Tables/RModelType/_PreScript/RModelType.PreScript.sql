USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID('dbo.RModel') AND type = 'F' AND name = 'FK_RModel_RModelType_RModelTypeID')
    ALTER TABLE dbo.RModel DROP CONSTRAINT FK_RModel_RModelType_RModelTypeID 
GO    
