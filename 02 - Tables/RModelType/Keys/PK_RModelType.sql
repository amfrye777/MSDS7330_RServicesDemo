USE RServicesDemo
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = object_id('dbo.RModelType') and [name] = 'PK_RModelType')
    ALTER TABLE dbo.RModelType DROP CONSTRAINT PK_RModelType 
GO

ALTER TABLE dbo.RModelType ADD CONSTRAINT PK_RModelType PRIMARY KEY CLUSTERED
(
    RModelTypeID
) WITH (FILLFACTOR = 80) ON [Primary]
GO
