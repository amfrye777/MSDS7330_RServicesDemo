USE RServicesDemo
GO

IF OBJECT_ID('dbo.RModelType') IS NOT NULL 
    DROP TABLE dbo.RModelType

CREATE TABLE dbo.RModelType (
    RModelTypeID                    INT                 NOT NULL,
    RModelType                      VARCHAR(150)        NOT NULL,
    RModelTypeDesc                  VARCHAR(250)            NULL,
    CreatedDate                     DATETIME2           NOT NULL,
    ModifiedDate                    DATETIME2               NULL
)

GO
