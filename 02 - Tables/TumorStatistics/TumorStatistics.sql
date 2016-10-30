USE RServicesDemo
GO

IF OBJECT_ID('dbo.TumorStatistics') IS NOT NULL 
    DROP TABLE dbo.TumorStatistics

CREATE TABLE dbo.TumorStatistics (
    ID                          BIGINT              NOT NULL,
    Diagnosis                   CHAR(1)                 NULL,
    radius_mean                 DECIMAL(18,4)           NULL,
    texture_mean                DECIMAL(18,4)           NULL,
    perimeter_mean              DECIMAL(18,4)           NULL,
    area_mean                   DECIMAL(18,4)           NULL,
    smoothness_mean             DECIMAL(18,4)           NULL,
    compactness_mean            DECIMAL(18,4)           NULL,
    concavity_mean              DECIMAL(18,4)           NULL,
    concave_mean                DECIMAL(18,4)           NULL,
    symmetry_mean               DECIMAL(18,4)           NULL,
    fractal_dimension_mean      DECIMAL(18,4)           NULL,
    radius_se                   DECIMAL(18,4)           NULL,
    texture_se                  DECIMAL(18,4)           NULL,
    perimeter_se                DECIMAL(18,4)           NULL,
    area_se                     DECIMAL(18,4)           NULL,
    smoothness_se               DECIMAL(18,4)           NULL,
    compactness_se              DECIMAL(18,4)           NULL,
    concavity_se                DECIMAL(18,4)           NULL,
    concave_se                  DECIMAL(18,4)           NULL,
    symmetry_se                 DECIMAL(18,4)           NULL,
    fractal_dimension_se        DECIMAL(18,4)           NULL,
    radius_worst                DECIMAL(18,4)           NULL,
    texture_worst               DECIMAL(18,4)           NULL,
    perimeter_worst             DECIMAL(18,4)           NULL,
    area_worst                  DECIMAL(18,4)           NULL,
    smoothness_worst            DECIMAL(18,4)           NULL,
    compactness_worst           DECIMAL(18,4)           NULL,
    concavity_worst             DECIMAL(18,4)           NULL,
    concave_worst               DECIMAL(18,4)           NULL,
    symmetry_worst              DECIMAL(18,4)           NULL,
    fractal_dimension_worst     DECIMAL(18,4)           NULL
)

GO
