USE [SEAN_Staging_TEST_2017]
GO

EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION'
GO

EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION', @level2type=N'COLUMN',@level2name=N'ERROR_DETAILS'
GO

EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION', @level2type=N'COLUMN',@level2name=N'ERROR_TYPE'
GO

/****** Object:  Table [SO].[SO_D_VALIDATION]    Script Date: 2/21/2024 11:44:32 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[SO].[SO_D_VALIDATION]') AND type in (N'U'))
DROP TABLE [SO].[SO_D_VALIDATION]
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

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Either ''Mandatory'' or ''Optional'' error type is expected here.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION', @level2type=N'COLUMN',@level2name=N'ERROR_TYPE'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Details of what validation criteria did not pass QC.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION', @level2type=N'COLUMN',@level2name=N'ERROR_DETAILS'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stores results of the validation stored procedure.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_D_VALIDATION'
GO


