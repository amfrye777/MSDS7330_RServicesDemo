USE RServicesDemo
GO

IF OBJECT_ID('dbo.RModel') IS NOT NULL 
    DROP TABLE dbo.RModel

CREATE TABLE dbo.RModel (
    RModelID                    INT               IDENTITY(1,1)  NOT NULL,
    RModel                      VARCHAR(150)                     NOT NULL,
    RModelDesc                  VARCHAR(MAX)                         NULL,
    RModelTypeID                INT                              NOT NULL,
    StatusCodeID                TINYINT                          NOT NULL,
    SerialValue                 VARBINARY(MAX)                       NULL,
    BuildProcName               SYSNAME                              NULL,
    CreatedDate                 DATETIME2                        NOT NULL,
    ModifiedDate                DATETIME2                            NULL
)

GO
