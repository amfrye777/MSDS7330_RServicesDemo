USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.RModel') and [name] = 'PK_RModel')
    ALTER TABLE dbo.RModel DROP CONSTRAINT PK_RModel 
GO

ALTER TABLE dbo.RModel ADD CONSTRAINT PK_RModel PRIMARY KEY CLUSTERED
(
    RModelID
) WITH (FILLFACTOR = 80) ON [Primary]
GO
