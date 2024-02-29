/****** Object:  Table [SO].[SO_C_PHOTO_INFO]    Script Date: 2/28/2024 12:45:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [SO].[SO_C_PHOTO_INFO](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PHOTO_FILENAME] [nvarchar](25) NOT NULL,
	[SURVEY_YEAR] [int] NOT NULL,
	[SURVEY_TYPE] [int] NOT NULL,
	[EXIF_PHOTO_DATE] [datetime] NOT NULL,
	[NOTES] [nvarchar](255) NULL,
 CONSTRAINT [PK_SO_C_PHOTO_INFO] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Load of the SO_C photo information, used in validation to ensure the correct number and survey type of photos is correct.' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'TABLE',@level1name=N'SO_C_PHOTO_INFO'
GO


