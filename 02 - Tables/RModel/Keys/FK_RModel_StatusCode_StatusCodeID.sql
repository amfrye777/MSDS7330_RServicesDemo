USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE parent_object_id = OBJECT_ID('dbo.RModel') AND type = 'F' AND name = 'FK_RModel_StatusCode_StatusCodeID')
    ALTER TABLE dbo.RModel DROP CONSTRAINT FK_RModel_StatusCode_StatusCodeID 
GO    

ALTER TABLE dbo.RModel ADD CONSTRAINT FK_RModel_StatusCode_StatusCodeID 
FOREIGN KEY (StatusCodeID)
REFERENCES dbo.StatusCode(StatusCodeID)

GO
