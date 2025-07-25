IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D_VALIDATION', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D_VALIDATION', N'COLUMN',N'ERROR_DETAILS'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION', @level2type=N'COLUMN',@level2name=N'ERROR_DETAILS'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D_VALIDATION', N'COLUMN',N'ERROR_TYPE'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION', @level2type=N'COLUMN',@level2name=N'ERROR_TYPE'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SURVEY_TYPE', N'COLUMN',N'DESCRIPTION'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SURVEY_TYPE', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SURVEY_TYPE', N'COLUMN',N'SURVEY_TYPE'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SURVEY_TYPE', @level2type=N'COLUMN',@level2name=N'SURVEY_TYPE'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'CONSTRAINT',N'FK_SO_D_UPDATED_BY'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'CONSTRAINT',@level2name=N'FK_SO_D_UPDATED_BY'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'CONSTRAINT',N'FK_SO_D_CREATED_BY'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'CONSTRAINT',@level2name=N'FK_SO_D_CREATED_BY'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'LAST_UPDATED_BY_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'LAST_UPDATED_BY_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'DATE_LAST_UPDATED'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'DATE_LAST_UPDATED'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'CREATED_BY_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'CREATED_BY_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'DATE_CREATED'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'DATE_CREATED'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'VALIDATED_BY_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'VALIDATED_BY_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'TRANSECT'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'TRANSECT'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'CAMERA_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'CAMERA_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'FLOWN_BY_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'FLOWN_BY_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'ORIGINAL_FILENAME'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'ORIGINAL_FILENAME'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'QUALITY_FLAG_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'QUALITY_FLAG_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'PROTOCOL_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'PROTOCOL_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'COUNTED_DATE'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'COUNTED_DATE'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'COUNTED_BY_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'COUNTED_BY_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'IMAGE_QUALITY_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'IMAGE_QUALITY_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'LAND_PRESENT_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'LAND_PRESENT_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'KELP_PRESENT_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'KELP_PRESENT_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'COUNT_PUP'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'COUNT_PUP'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'COUNT_ADULT'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'COUNT_ADULT'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'SURVEY_TYPE_ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'SURVEY_TYPE_ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'ALTITUDE'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'ALTITUDE'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'LONGITUDE_WGS84'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'LONGITUDE_WGS84'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'LATITUDE_WGS84'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'LATITUDE_WGS84'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'PHOTO_TIMESTAMP_AK_LOCAL'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'PHOTO_TIMESTAMP_AK_LOCAL'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'PHOTO_TIMESTAMP_UTC'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'PHOTO_TIMESTAMP_UTC'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'SO_D', N'COLUMN',N'PHOTO_FILE_NAME'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'PHOTO_FILE_NAME'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'LAND_PRESENT', N'COLUMN',N'DEFINITION'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'LAND_PRESENT', @level2type=N'COLUMN',@level2name=N'DEFINITION'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'LAND_PRESENT', N'COLUMN',N'LAND_PRESENT'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'LAND_PRESENT', @level2type=N'COLUMN',@level2name=N'LAND_PRESENT'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'LAND_PRESENT', N'COLUMN',N'ID'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'LAND_PRESENT', @level2type=N'COLUMN',@level2name=N'ID'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'KELP_PRESENT', N'COLUMN',N'DEFINITION'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'KELP_PRESENT', @level2type=N'COLUMN',@level2name=N'DEFINITION'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'KELP_PRESENT', N'COLUMN',N'KELP_PRESENT'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'KELP_PRESENT', @level2type=N'COLUMN',@level2name=N'KELP_PRESENT'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'EMPLOYEE', N'COLUMN',N'USERNAME'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'EMPLOYEE', @level2type=N'COLUMN',@level2name=N'USERNAME'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'EMPLOYEE', N'COLUMN',N'INITIALS'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'EMPLOYEE', @level2type=N'COLUMN',@level2name=N'INITIALS'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'EMPLOYEE', N'COLUMN',N'FULL_NAME'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'EMPLOYEE', @level2type=N'COLUMN',@level2name=N'FULL_NAME'
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'SO', N'TABLE',N'CAMERA', N'COLUMN',N'DESCRIPTION'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'CAMERA', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_VALIDATED_BY_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_UPDATED_BY]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_SURVEY_TYPE_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_QUALITY_FLAG_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_PROTOCOL_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_LAND_PRESENT_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_KELP_PRESENT_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_IMAGE_QUALITY_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_FLOWN_BY_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_EMPLOYEE_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_CREATED_BY]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [FK_SO_D_CAMERA_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [DF_SO_D_LAST_UPDATED_BY_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [DF_SO_D_DATE_LAST_UPDATED]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [DF_SO_D_CREATED_BY_ID]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [DF_SO_D_DATE_CREATED]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D]') AND type in (N'U'))
ALTER TABLE [SO].[SO_D] DROP CONSTRAINT IF EXISTS [DF_SO_D_MARKED_FOR_DELETION]
GO
/****** Object:  Table [SO].[SO_D_SeeOtter]    Script Date: 2/21/2024 11:44:32 AM ******/
DROP TABLE IF EXISTS [SO].[SO_D_SeeOtter]
GO
/****** Object:  Table [SO].[SO_D_VALIDATION]    Script Date: 2/21/2024 11:44:32 AM ******/
DROP TABLE IF EXISTS [SO].[SO_D_VALIDATION]
GO
/****** Object:  Table [SO].[SURVEY_TYPE]    Script Date: 1/16/2024 2:08:08 PM ******/
DROP TABLE IF EXISTS [SO].[SURVEY_TYPE]
GO
/****** Object:  Table [SO].[SO_D]    Script Date: 1/16/2024 2:08:08 PM ******/
DROP TABLE IF EXISTS [SO].[SO_D]
GO
/****** Object:  Table [SO].[QUALITY_FLAG]    Script Date: 1/16/2024 2:08:08 PM ******/
DROP TABLE IF EXISTS [SO].[QUALITY_FLAG]
GO
/****** Object:  Table [SO].[LAND_PRESENT]    Script Date: 1/16/2024 2:08:08 PM ******/
DROP TABLE IF EXISTS [SO].[LAND_PRESENT]
GO
/****** Object:  Table [SO].[KELP_PRESENT]    Script Date: 1/16/2024 2:08:08 PM ******/
DROP TABLE IF EXISTS [SO].[KELP_PRESENT]
GO
/****** Object:  Table [SO].[IMAGE_QUALITY]    Script Date: 1/16/2024 2:08:08 PM ******/
DROP TABLE IF EXISTS [SO].[IMAGE_QUALITY]
GO
/****** Object:  Table [SO].[FLIGHT]    Script Date: 1/16/2024 2:08:08 PM ******/
DROP TABLE IF EXISTS [SO].[FLIGHT]
GO
/****** Object:  Table [SO].[EMPLOYEE]    Script Date: 1/16/2024 2:08:08 PM ******/
DROP TABLE IF EXISTS [SO].[EMPLOYEE]
GO
/****** Object:  Table [SO].[CAMERA]    Script Date: 1/16/2024 2:08:08 PM ******/
DROP TABLE IF EXISTS [SO].[CAMERA]
GO
/****** Object:  Table [SO].[SO_D_VALIDATION]    Script Date: 2/21/2024 11:44:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[SO_D_VALIDATION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PHOTO_FILE_NAME] [nvarchar](30) NOT NULL,
	[PHOTO_TIMESTAMP_AK_LOCAL] [datetime] NOT NULL,
	[ERROR_TYPE] [nvarchar](20) NOT NULL,
	[ERROR_DETAILS] [nvarchar](4000) NOT NULL,
 CONSTRAINT [PK_SO_D_VALIDATION] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [SO].[CAMERA]    Script Date: 1/16/2024 2:08:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[CAMERA](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MAKE] [nvarchar](50) NOT NULL,
	[MODEL] [nvarchar](50) NOT NULL,
	[FORMAT] [nvarchar](50) NULL,
	[LENS] [nvarchar](50) NULL,
	[SETTINGS] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](255) NULL,
 CONSTRAINT [PK_SO_CAMERA] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SO].[EMPLOYEE]    Script Date: 1/16/2024 2:08:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[EMPLOYEE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FULL_NAME] [nvarchar](100) NOT NULL,
	[INITIALS] [nvarchar](3) NOT NULL,
	[AFFILIATION] [nvarchar](100) NULL,
	[USERNAME] [nvarchar](50) NULL,
	[DESCRIPTION] [nvarchar](255) NULL,
 CONSTRAINT [PK_ltbl_COUNTED_BY] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SO].[FLIGHT]    Script Date: 1/16/2024 2:08:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[FLIGHT](
	[ID] [int] NOT NULL,
	[DATE] [date] NOT NULL,
	[AIRCRAFT] [nvarchar](50) NOT NULL,
	[TAIL_NUMBER] [nvarchar](10) NOT NULL,
	[PILOT] [nvarchar](50) NOT NULL,
	[OBSERVER] [nvarchar](50) NOT NULL,
	[CREW1] [nvarchar](50) NULL,
	[CREW2] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [SO].[IMAGE_QUALITY]    Script Date: 1/16/2024 2:08:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[IMAGE_QUALITY](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IMAGE_QUALITY] [nvarchar](10) NOT NULL,
	[DEFINITION] [nvarchar](255) NULL,
 CONSTRAINT [PK_ltbl_IMAGE_QUALITY] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SO].[KELP_PRESENT]    Script Date: 1/16/2024 2:08:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[KELP_PRESENT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KELP_PRESENT] [nvarchar](3) NOT NULL,
	[DEFINITION] [nvarchar](255) NULL,
 CONSTRAINT [PK_KELP_PRESENT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SO].[LAND_PRESENT]    Script Date: 1/16/2024 2:08:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[LAND_PRESENT](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LAND_PRESENT] [nvarchar](3) NOT NULL,
	[DEFINITION] [nvarchar](255) NULL,
 CONSTRAINT [PK_LAND_PRESENT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SO].[QUALITY_FLAG]    Script Date: 1/16/2024 2:08:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[QUALITY_FLAG](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[QUALITY_FLAG] [nvarchar](20) NOT NULL,
	[DEFINITION] [nvarchar](255) NOT NULL,
	[DESCRIPTION] [nvarchar](255) NULL
 CONSTRAINT [PK_QUALITY_FLAG] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SO].[SO_D]    Script Date: 1/16/2024 2:08:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[SO_D](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PHOTO_FILE_NAME] [nvarchar](30) NOT NULL,
	[PHOTO_TIMESTAMP_UTC] [datetime] NULL,
	[PHOTO_TIMESTAMP_AK_LOCAL] [datetime] NULL,
	[LATITUDE_WGS84] [decimal](10, 8) NULL,
	[LONGITUDE_WGS84] [decimal](11, 8) NULL,
	[ALTITUDE] [int] NULL,
	[SURVEY_TYPE_ID] [int] NULL,
	[COUNT_ADULT] [int] NULL,
	[COUNT_PUP] [int] NULL,
	[KELP_PRESENT_ID] [int] NULL,
	[LAND_PRESENT_ID] [int] NULL,
	[IMAGE_QUALITY_ID] [int] NULL,
	[COUNTED_BY_ID] [int] NULL,
	[COUNTED_DATE] [date] NULL,
	[PROTOCOL_ID] [smallint] NOT NULL,
	[QUALITY_FLAG_ID] [int] NOT NULL,
	[MARKED_FOR_DELETION] [bit] NOT NULL,
	[ORIGINAL_FILENAME] [nvarchar](30) NULL,
	[FLOWN_BY_ID] [int] NULL,
	[CAMERA_ID] [int] NULL,
	[TRANSECT] [nvarchar](10) NULL,
	[VALIDATED_BY_ID] [int] NULL,
	[DATE_CREATED] [datetime] NOT NULL,
	[CREATED_BY_ID] [int] NOT NULL,
	[DATE_LAST_UPDATED] [datetime] NOT NULL,
	[LAST_UPDATED_BY_ID] [int] NOT NULL,
 CONSTRAINT [PK_SO_D] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SO].[SURVEY_TYPE]    Script Date: 1/16/2024 2:08:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[SURVEY_TYPE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SURVEY_TYPE] [varchar](9) NOT NULL,
	[DESCRIPTION] [varchar](250) NULL,
 CONSTRAINT [PK_SURVEY_TYPE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SO].[SO_D_SeeOtter]    Script Date: 1/4/2024 2:06:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SO].[SO_D_SeeOtter](
	[ImageID] [int] NOT NULL,
	[PHOTO_TIMESTAMP] [datetime] NOT NULL,
	[FilePath] [nvarchar](128) NOT NULL,
	[LATITUDE_WGS84] [float] NOT NULL,
	[LONGITUDE_WGS84] [float] NOT NULL,
	[ALTITUDE] [int] NOT NULL,
	[ImageCorner1Lat] [float] NULL,
	[ImageCorner1Lon] [float] NULL,
	[ImageCorner2Lat] [float] NULL,
	[ImageCorner2Lon] [float] NULL,
	[ImageCorner3Lat] [float] NULL,
	[ImageCorner3Lon] [float] NULL,
	[ImageCorner4Lat] [float] NULL,
	[ImageCorner4Lon] [float] NULL,
	[VALIDATED_BY] [nvarchar](3) NOT NULL,
	[COUNT_ADULT] [int] NOT NULL,
	[COUNT_PUP] [int] NOT NULL,
	[GSD] [float] NULL,
	[Width_m] [float] NULL,
	[Height_m] [float] NULL,
	[Coverage_sqkm] [float] NULL,
	[Transect] [nvarchar](20) NULL,
	[FLOWN_BY] [nvarchar](3) NOT NULL,
	[SeeOtter_VERSION] [nvarchar](10) NOT NULL,
	[SURVEY_TYPE] [nvarchar](10) NOT NULL,
	[CAMERA_SYSTEM] [nvarchar](16) NOT NULL,
	[IMAGE_QUALITY] [nvarchar](10) NULL
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [SO].[CAMERA] ON 

INSERT [SO].[CAMERA] ([ID], [MAKE], [MODEL], [FORMAT], [LENS], [SETTINGS], [DESCRIPTION]) VALUES (1, N'WALDO', N'XCAMUltra50', NULL, NULL, NULL, N'WaldoXCAMUltra50')
INSERT [SO].[CAMERA] ([ID], [MAKE], [MODEL], [FORMAT], [LENS], [SETTINGS], [DESCRIPTION]) VALUES (2, N'NIKON', N'D810', NULL, '85mm', 'F1.4', N'Used in surveys prior to 2022.')
SET IDENTITY_INSERT [SO].[CAMERA] OFF
GO
SET IDENTITY_INSERT [SO].[EMPLOYEE] ON 

INSERT [SO].[EMPLOYEE] ([ID], [FULL_NAME], [INITIALS], [AFFILIATION], [USERNAME], [DESCRIPTION]) VALUES (1, N'Louise Faris Taylor', N'LFT', N'NPS', NULL, NULL)
INSERT [SO].[EMPLOYEE] ([ID], [FULL_NAME], [INITIALS], [AFFILIATION], [USERNAME], [DESCRIPTION]) VALUES (2, N'Jamie N Womble', N'JNW', N'NPS', 'nps\jwomble', NULL)
INSERT [SO].[EMPLOYEE] ([ID], [FULL_NAME], [INITIALS], [AFFILIATION], [USERNAME], [DESCRIPTION]) VALUES (3, N'Linnea E Pearson', N'LEP', N'NPS', 'nps\lepearson', NULL)
INSERT [SO].[EMPLOYEE] ([ID], [FULL_NAME], [INITIALS], [AFFILIATION], [USERNAME], [DESCRIPTION]) VALUES (4, N'Dennis Lozier', N'DL', N'Ward Air', NULL, NULL)
INSERT [SO].[EMPLOYEE] ([ID], [FULL_NAME], [INITIALS], [AFFILIATION], [USERNAME], [DESCRIPTION]) VALUES (5, N'Michelle L Kissling', N'MLK', N'USFWS', NULL, NULL)
INSERT [SO].[EMPLOYEE] ([ID], [FULL_NAME], [INITIALS], [AFFILIATION], [USERNAME], [DESCRIPTION]) VALUES (6, N'Thomas R Ziomek', N'TRZ', N'NPS', 'nps\tziomek', NULL)
INSERT [SO].[EMPLOYEE] ([ID], [FULL_NAME], [INITIALS], [AFFILIATION], [USERNAME], [DESCRIPTION]) VALUES (7, N'SeeOtter', N'SO', N'3.5.1', NULL, NULL)
SET IDENTITY_INSERT [SO].[EMPLOYEE] OFF
GO
INSERT [SO].[FLIGHT] ([ID], [DATE], [AIRCRAFT], [TAIL_NUMBER], [PILOT], [OBSERVER], [CREW1], [CREW2]) VALUES (1, CAST(N'2017-07-19' AS Date), N'De Havilland Canada DHC-2 Beaver', N'N62353', N'Dennis Lozier', N'Jamie N Womble', N'Louise Faris Taylor', NULL)
INSERT [SO].[FLIGHT] ([ID], [DATE], [AIRCRAFT], [TAIL_NUMBER], [PILOT], [OBSERVER], [CREW1], [CREW2]) VALUES (2, CAST(N'2017-07-21' AS Date), N'De Havilland Canada DHC-2 Beaver', N'N62353', N'Dennis Lozier', N'Jamie N Womble', N'Louise Faris Taylor', NULL)
INSERT [SO].[FLIGHT] ([ID], [DATE], [AIRCRAFT], [TAIL_NUMBER], [PILOT], [OBSERVER], [CREW1], [CREW2]) VALUES (3, CAST(N'2017-07-28' AS Date), N'De Havilland Canada DHC-2 Beaver', N'N62353', N'Dennis Lozier', N'Jamie N Womble', N'Louise Faris Taylor', N'Michelle Kissling')
INSERT [SO].[FLIGHT] ([ID], [DATE], [AIRCRAFT], [TAIL_NUMBER], [PILOT], [OBSERVER], [CREW1], [CREW2]) VALUES (4, CAST(N'2018-07-18' AS Date), N'De Havilland Canada DHC-2 Beaver', N'N62353', N'Dennis Lozier', N'Jamie N Womble', N'Louise Faris Taylor', NULL)
INSERT [SO].[FLIGHT] ([ID], [DATE], [AIRCRAFT], [TAIL_NUMBER], [PILOT], [OBSERVER], [CREW1], [CREW2]) VALUES (5, CAST(N'2018-07-19' AS Date), N'De Havilland Canada DHC-2 Beaver', N'N62353', N'Dennis Lozier', N'Louise Faris Taylor', N'Jamie N Womble', NULL)
INSERT [SO].[FLIGHT] ([ID], [DATE], [AIRCRAFT], [TAIL_NUMBER], [PILOT], [OBSERVER], [CREW1], [CREW2]) VALUES (6, CAST(N'2018-07-20' AS Date), N'De Havilland Canada DHC-2 Beaver', N'N62353', N'Dennis Lozier', N'Louise Faris Taylor', N'Jamie N Womble', NULL)
INSERT [SO].[FLIGHT] ([ID], [DATE], [AIRCRAFT], [TAIL_NUMBER], [PILOT], [OBSERVER], [CREW1], [CREW2]) VALUES (7, CAST(N'2018-07-27' AS Date), N'De Havilland Canada DHC-2 Beaver', N'N62353', N'Dennis Lozier', N'Jamie N Womble', N'Linnea Pearson', NULL)
INSERT [SO].[FLIGHT] ([ID], [DATE], [AIRCRAFT], [TAIL_NUMBER], [PILOT], [OBSERVER], [CREW1], [CREW2]) VALUES (8, CAST(N'2019-07-10' AS Date), N'De Havilland Canada DHC-2 Beaver', N'N62353', N'Dennis Lozier', N'Louise Faris Taylor', N'Jamie N Womble', NULL)
INSERT [SO].[FLIGHT] ([ID], [DATE], [AIRCRAFT], [TAIL_NUMBER], [PILOT], [OBSERVER], [CREW1], [CREW2]) VALUES (9, CAST(N'2019-07-12' AS Date), N'De Havilland Canada DHC-2 Beaver', N'N62353', N'Dennis Lozier', N'Louise Faris Taylor', N'Jamie N Womble', NULL)
INSERT [SO].[FLIGHT] ([ID], [DATE], [AIRCRAFT], [TAIL_NUMBER], [PILOT], [OBSERVER], [CREW1], [CREW2]) VALUES (10, CAST(N'2019-08-01' AS Date), N'De Havilland Canada DHC-2 Beaver', N'N62353', N'Dennis Lozier', N'Louise Faris Taylor', N'Jamie N Womble', NULL)
GO
SET IDENTITY_INSERT [SO].[IMAGE_QUALITY] ON 

INSERT [SO].[IMAGE_QUALITY] ([ID], [IMAGE_QUALITY], [DEFINITION]) VALUES (1, N'Good', N'Image quality is typical')
INSERT [SO].[IMAGE_QUALITY] ([ID], [IMAGE_QUALITY], [DEFINITION]) VALUES (2, N'Reduced', N'Image quality is reduced by issues such as blurry focus that makes exact count of sea otters difficult')
INSERT [SO].[IMAGE_QUALITY] ([ID], [IMAGE_QUALITY], [DEFINITION]) VALUES (3, N'Unusable', N'Image quality is affected by an issue such as file corruption that prevents the image from being at all recognizable')
SET IDENTITY_INSERT [SO].[IMAGE_QUALITY] OFF
GO
SET IDENTITY_INSERT [SO].[KELP_PRESENT] ON 

INSERT [SO].[KELP_PRESENT] ([ID], [KELP_PRESENT], [DEFINITION]) VALUES (0, N'No', N'No kelp present in photo')
INSERT [SO].[KELP_PRESENT] ([ID], [KELP_PRESENT], [DEFINITION]) VALUES (1, N'Yes', N'Kelp present in photo')
SET IDENTITY_INSERT [SO].[KELP_PRESENT] OFF
GO
SET IDENTITY_INSERT [SO].[LAND_PRESENT] ON 

INSERT [SO].[LAND_PRESENT] ([ID], [LAND_PRESENT], [DEFINITION]) VALUES (0, N'No', N'No land present in photo')
INSERT [SO].[LAND_PRESENT] ([ID], [LAND_PRESENT], [DEFINITION]) VALUES (1, N'Yes', N'Land present in photo')
SET IDENTITY_INSERT [SO].[LAND_PRESENT] OFF
GO
SET IDENTITY_INSERT [SO].[QUALITY_FLAG] ON 

INSERT [SO].[QUALITY_FLAG] ([ID], [QUALITY_FLAG], [DEFINITION]) VALUES (0, N'Accepted', N'Every attribute in the record meets QC standards.')
INSERT [SO].[QUALITY_FLAG] ([ID], [QUALITY_FLAG], [DEFINITION],[DESCRIPTION]) VALUES (1, N'Provisional', N'At least one required attribute is missing.',N'Deprecated - not used starting with 2022 (SeeOtter) process.')
INSERT [SO].[QUALITY_FLAG] ([ID], [QUALITY_FLAG], [DEFINITION],[DESCRIPTION]) VALUES (2, N'Provisional', N'Photo file name or timestamp is not unique.',N'Deprecated - not used starting with 2022 (SeeOtter) process.')
INSERT [SO].[QUALITY_FLAG] ([ID], [QUALITY_FLAG], [DEFINITION],[DESCRIPTION]) VALUES (3, N'Provisional', N'A mandatory quality requirement other than timestamp and file name was violated.',N'Deprecated - not used starting with 2022 (SeeOtter) process.')
INSERT [SO].[QUALITY_FLAG] ([ID], [QUALITY_FLAG], [DEFINITION],[DESCRIPTION]) VALUES (4, N'Provisional', N'One or more attributes did not meet QC standards.',N'Use for when data must be published, but QC issues could not be resolved. Change record to Accepted if data is later corrected.')
INSERT [SO].[QUALITY_FLAG] ([ID], [QUALITY_FLAG], [DEFINITION]) VALUES (5, N'Raw', 'Record has not yet been validated or subject to official QC.')

SET IDENTITY_INSERT [SO].[QUALITY_FLAG] OFF
GO
SET IDENTITY_INSERT [SO].[SURVEY_TYPE] ON 

INSERT [SO].[SURVEY_TYPE] ([ID], [SURVEY_TYPE], [DESCRIPTION]) VALUES (1, N'Abundance', N'Survey consisting of transects selected to cover the areas of greatest predicted abundance')
INSERT [SO].[SURVEY_TYPE] ([ID], [SURVEY_TYPE], [DESCRIPTION]) VALUES (2, N'Optimal', N'Survey consisting of transects selected to minimize model-based prediction variance')
INSERT [SO].[SURVEY_TYPE] ([ID], [SURVEY_TYPE], [DESCRIPTION]) VALUES (3, N'Random', N'Survey consisting of randomly selected transects')
INSERT [SO].[SURVEY_TYPE] ([ID], [SURVEY_TYPE], [DESCRIPTION]) VALUES (4, N'External', N'')
SET IDENTITY_INSERT [SO].[SURVEY_TYPE] OFF
GO
ALTER TABLE [SO].[SO_D] ADD  CONSTRAINT [DF_SO_D_MARKED_FOR_DELETION]  DEFAULT ((0)) FOR [MARKED_FOR_DELETION]
GO
ALTER TABLE [SO].[SO_D] ADD  CONSTRAINT [DF_SO_D_DATE_CREATED]  DEFAULT (getdate()) FOR [DATE_CREATED]
GO
ALTER TABLE [SO].[SO_D] ADD  CONSTRAINT [DF_SO_D_CREATED_BY_ID]  DEFAULT ((6)) FOR [CREATED_BY_ID]
GO
ALTER TABLE [SO].[SO_D] ADD  CONSTRAINT [DF_SO_D_DATE_LAST_UPDATED]  DEFAULT (getdate()) FOR [DATE_LAST_UPDATED]
GO
ALTER TABLE [SO].[SO_D] ADD  CONSTRAINT [DF_SO_D_LAST_UPDATED_BY_ID]  DEFAULT ((6)) FOR [LAST_UPDATED_BY_ID]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_CAMERA_ID] FOREIGN KEY([CAMERA_ID])
REFERENCES [SO].[CAMERA] ([ID])
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_CAMERA_ID]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_CREATED_BY] FOREIGN KEY([CREATED_BY_ID])
REFERENCES [SO].[EMPLOYEE] ([ID])
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_CREATED_BY]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_EMPLOYEE_ID] FOREIGN KEY([COUNTED_BY_ID])
REFERENCES [SO].[EMPLOYEE] ([ID])
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_EMPLOYEE_ID]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_FLOWN_BY_ID] FOREIGN KEY([FLOWN_BY_ID])
REFERENCES [SO].[EMPLOYEE] ([ID])
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_FLOWN_BY_ID]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_IMAGE_QUALITY_ID] FOREIGN KEY([IMAGE_QUALITY_ID])
REFERENCES [SO].[IMAGE_QUALITY] ([ID])
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_IMAGE_QUALITY_ID]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_KELP_PRESENT_ID] FOREIGN KEY([KELP_PRESENT_ID])
REFERENCES [SO].[KELP_PRESENT] ([ID])
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_KELP_PRESENT_ID]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_LAND_PRESENT_ID] FOREIGN KEY([LAND_PRESENT_ID])
REFERENCES [SO].[LAND_PRESENT] ([ID])
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_LAND_PRESENT_ID]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_PROTOCOL_ID] FOREIGN KEY([PROTOCOL_ID])
REFERENCES [SEAN].[tbl_protocol] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_PROTOCOL_ID]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_QUALITY_FLAG_ID] FOREIGN KEY([QUALITY_FLAG_ID])
REFERENCES [SO].[QUALITY_FLAG] ([ID])
ON DELETE CASCADE
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_QUALITY_FLAG_ID]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_SURVEY_TYPE_ID] FOREIGN KEY([SURVEY_TYPE_ID])
REFERENCES [SO].[SURVEY_TYPE] ([ID])
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_SURVEY_TYPE_ID]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_UPDATED_BY] FOREIGN KEY([LAST_UPDATED_BY_ID])
REFERENCES [SO].[EMPLOYEE] ([ID])
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_UPDATED_BY]
GO
ALTER TABLE [SO].[SO_D]  WITH CHECK ADD  CONSTRAINT [FK_SO_D_VALIDATED_BY_ID] FOREIGN KEY([VALIDATED_BY_ID])
REFERENCES [SO].[EMPLOYEE] ([ID])
GO
ALTER TABLE [SO].[SO_D] CHECK CONSTRAINT [FK_SO_D_VALIDATED_BY_ID]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Either ''Mandatory'' or ''Optional'' error type is expected here.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION', @level2type=N'COLUMN',@level2name=N'ERROR_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Details of what validation criteria did not pass QC.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION', @level2type=N'COLUMN',@level2name=N'ERROR_DETAILS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stores results of the validation stored procedure.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Owner, date purchased, other accessories, etc.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'CAMERA', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Full name of the employee.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'EMPLOYEE', @level2type=N'COLUMN',@level2name=N'FULL_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initials of the employee.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'EMPLOYEE', @level2type=N'COLUMN',@level2name=N'INITIALS'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Employee network username if applicable.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'EMPLOYEE', @level2type=N'COLUMN',@level2name=N'USERNAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'KELP_PRESENT code' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'KELP_PRESENT', @level2type=N'COLUMN',@level2name=N'KELP_PRESENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Definition of KELP_PRESENT code' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'KELP_PRESENT', @level2type=N'COLUMN',@level2name=N'DEFINITION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'code for LAND_PRESENT attribute' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'LAND_PRESENT', @level2type=N'COLUMN',@level2name=N'ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'text equivalent of land present code' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'LAND_PRESENT', @level2type=N'COLUMN',@level2name=N'LAND_PRESENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Definition of LAND_PRESENT code' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'LAND_PRESENT', @level2type=N'COLUMN',@level2name=N'DEFINITION'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of the SO_C photo image file that was examined' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'PHOTO_FILE_NAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date and time the photo was taken; in UTC time zone using the 24-hour clock' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'PHOTO_TIMESTAMP_UTC'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date and time the photo was taken; in the local Alaska time zone using the 24-hour clock' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'PHOTO_TIMESTAMP_AK_LOCAL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Latitude of the camera when photo was taken in decimal degrees using the WGS84 datum' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'LATITUDE_WGS84'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Longitude of the camera in decimal degrees using the WGS84 datum' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'LONGITUDE_WGS84'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Altitude of the camera above sea level in meters' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'ALTITUDE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Type of survey purpose a particular flight was made for' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'SURVEY_TYPE_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The number of adult sea otters present in the photo' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'COUNT_ADULT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The number of immature sea otters present in the photo' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'COUNT_PUP'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Whether or not surface kelp is visible in the photo' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'KELP_PRESENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Whether or not dry land is visible in the photo' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'LAND_PRESENT_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reader''s evaluation of image quality' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'IMAGE_QUALITY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initials of the technician who read this photo' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'COUNTED_BY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date the photo was read; in the local Alaska time zone using the 24-hour clock' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'COUNTED_DATE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The SEAN sea otter monitoring program protocol package ID that was followed when creating this deliverable' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'PROTOCOL_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This attribute indicates whether there is a technical fault in the data row making it unsuitable for analysis purposes' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'QUALITY_FLAG_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contains the image filename (without the path) from the SeeOtter "FilePath" column' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'ORIGINAL_FILENAME'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lookup for initials of the employee who conducted the mission.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'FLOWN_BY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lookup for Camera System used in the survey.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'CAMERA_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transect number (or NA or NULL or empty if not available).' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'TRANSECT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lookup for initials of the employee who conducted the data validation.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'VALIDATED_BY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The datetime when this record was first loaded into this table.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'DATE_CREATED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of the user who loaded this record. Defaults to Data Manager.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'CREATED_BY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The datetime of the most recent update to this record.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'DATE_LAST_UPDATED'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ID of the user who last updated this record. Defaults to Data Manager.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'COLUMN',@level2name=N'LAST_UPDATED_BY_ID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FK to EMPLOYEE table' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'CONSTRAINT',@level2name=N'FK_SO_D_CREATED_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'FK to EMPLOYEE table' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D', @level2type=N'CONSTRAINT',@level2name=N'FK_SO_D_UPDATED_BY'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'SURVEY_TYPE code' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SURVEY_TYPE', @level2type=N'COLUMN',@level2name=N'SURVEY_TYPE'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Description of survey type' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SURVEY_TYPE', @level2type=N'COLUMN',@level2name=N'DESCRIPTION'
GO
