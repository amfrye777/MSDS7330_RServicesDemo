USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.StatusCode') and [name] = 'PK_StatusCode')
    ALTER TABLE dbo.StatusCode DROP CONSTRAINT PK_StatusCode 
GO

ALTER TABLE dbo.StatusCode ADD CONSTRAINT PK_StatusCode PRIMARY KEY CLUSTERED
(
    StatusCodeID
) WITH (FILLFACTOR = 80) ON [Primary]
GO
