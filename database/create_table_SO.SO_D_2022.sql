USE [SEAN_Staging_TEST_2017]
GO

/****** Object:  Table [SO].[SO_D_2022]    Script Date: 1/4/2024 2:06:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [SO].[SO_D_2022](
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


