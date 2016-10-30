USE RServicesDemo
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

:On Error exit

PRINT 'Building Initial Tumor Diagnosis Model'
    Exec dbo.TumorDiag#Build

PRINT 'This Manifest Deployment script has completed.  Please check for errors.'
GO
