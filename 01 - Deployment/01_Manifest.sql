USE master
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

:On Error exit

--:SETVAR path "D:\Documents\School\SMU\2016 FALL\MSDS 7330 - DB Mgmt\Projects\Research Project - R Services\DemoProjectCode\RServicesDemo"


PRINT 'Deploying DB'
GO
:r $(path)"\RServicesDemo.DBCreation.sql"
GO


PRINT 'Deploying PreScripts'
GO
:r $(path)"\02 - Tables\RModelType\_PreScript\RModelType.PreScript.sql"
:r $(path)"\02 - Tables\StatusCode\_PreScript\StatusCode.PreScript.sql"
:r $(path)"\03 - User Defined Table Types\TumorDiagPredictTableType\TumorDiagPredictTableType.PreScript.sql"
GO


PRINT 'Deploying Tables'
GO
:r $(path)"\02 - Tables\RModel\RModel.sql"
:r $(path)"\02 - Tables\RModelType\RModelType.sql"
:r $(path)"\02 - Tables\RPlot\RPlot.sql"
:r $(path)"\02 - Tables\StatusCode\StatusCode.sql"
:r $(path)"\02 - Tables\TumorStatistics\TumorStatistics.sql"
GO

PRINT 'Deploying User Defined Table Types'
GO
:r $(path)"\03 - User Defined Table Types\TumorDiagPredictTableType\TumorDiagPredictTableType.sql"
GO

PRINT 'Deploying Constraints'
GO
:r $(path)"\02 - Tables\RModel\Constraints\DF_RModel_CreatedDate.sql"
:r $(path)"\02 - Tables\RModelType\Constraints\DF_RModelType_CreatedDate.sql"
:r $(path)"\02 - Tables\RPlot\Constraints\DF_RPlot_CreatedDate.sql"
:r $(path)"\02 - Tables\StatusCode\Constraints\DF_StatusCode_CreatedDate.sql"
GO


PRINT 'Deploying Primary Keys'
GO
:r $(path)"\02 - Tables\RModel\Keys\PK_RModel.sql"
:r $(path)"\02 - Tables\RModelType\Keys\PK_RModelType.sql"
:r $(path)"\02 - Tables\RPlot\Keys\PK_RPlot.sql"
:r $(path)"\02 - Tables\StatusCode\Keys\PK_StatusCode.sql"
:r $(path)"\02 - Tables\TumorStatistics\Keys\PK_TumorStatistics.sql"
GO

PRINT 'Deploying Foreign Keys'
GO
:r $(path)"\02 - Tables\RModel\Keys\FK_RModel_RModelType_RModelTypeID.sql"
:r $(path)"\02 - Tables\RModel\Keys\FK_RModel_StatusCode_StatusCodeID.sql"
GO

PRINT 'Deploying Post Scripts'
GO
:r $(path)"\02 - Tables\RModelType\z_PostScript\RModelType.PostScript.sql"
:r $(path)"\02 - Tables\StatusCode\z_PostScript\StatusCode.PostScript.sql"
GO


PRINT 'Deploying Procedures'
GO
:r $(path)"\04 - Procedures\TumorStatBoxPlot#Build.sql"
:r $(path)"\04 - Procedures\TumorDiag#Build.sql"
:r $(path)"\04 - Procedures\TumorDiag#Predict.sql"
GO


PRINT 'Deploying Populate Scripts'
GO
:r $(path)"\05 - Scripts\Population Scripts\RModelType.Populate.sql"
:r $(path)"\05 - Scripts\Population Scripts\StatusCode.Populate.sql"
:r $(path)"\05 - Scripts\Population Scripts\TumorStatistics.Populate.sql"
GO


PRINT 'This Manifest Deployment script has completed.  Please check for errors.'
GO
