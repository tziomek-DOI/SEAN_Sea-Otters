/****** Object:  View [SO].[view_SO_D_allrecs_w_lookups]    Script Date: 2/21/2024 4:19:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER   VIEW [SO].[view_SO_D_allrecs_w_lookups]
AS
SELECT        sod.PHOTO_FILE_NAME, FORMAT(sod.PHOTO_TIMESTAMP_UTC, 'yyyy-MM-dd HH:mm:ss') AS PHOTO_TIMESTAMP_UTC, FORMAT(sod.PHOTO_TIMESTAMP_AK_LOCAL, 'yyyy-MM-dd HH:mm:ss') 
                         AS PHOTO_TIMESTAMP_AK_LOCAL, sod.LATITUDE_WGS84, sod.LONGITUDE_WGS84, sod.ALTITUDE, st.SURVEY_TYPE, sod.COUNT_ADULT, sod.COUNT_PUP, k.KELP_PRESENT, l.LAND_PRESENT, i.IMAGE_QUALITY, 
                         (CASE WHEN e.INITIALS = 'SO' THEN (e.FULL_NAME + ' ' + e.AFFILIATION) ELSE e.INITIALS END) AS COUNTED_BY, FORMAT(sod.COUNTED_DATE, 'yyyy-MM-dd') AS COUNTED_DATE, p.protocol AS PROTOCOL, q.QUALITY_FLAG, 
                         sod.ORIGINAL_FILENAME, f.INITIALS AS FLOWN_BY, c.MAKE + ' ' + c.MODEL AS CAMERA_SYSTEM, sod.TRANSECT, v.INITIALS AS VALIDATED_BY, FORMAT(sod.DATE_CREATED, 'yyyy-MM-dd HH:mm:ss') AS DATE_CREATED, 
                         cr.INITIALS AS CREATED_BY, FORMAT(sod.DATE_LAST_UPDATED, 'yyyy-MM-dd HH:mm:ss') AS DATE_LAST_UPDATED, up.INITIALS AS LAST_UPDATED_BY
FROM            SO.SO_D AS sod INNER JOIN
                         SO.SURVEY_TYPE AS st ON sod.SURVEY_TYPE_ID = st.ID INNER JOIN
                         SO.EMPLOYEE AS e ON sod.COUNTED_BY_ID = e.ID INNER JOIN
                         SEAN.tbl_protocol AS p ON sod.PROTOCOL_ID = p.id INNER JOIN
                         SO.QUALITY_FLAG AS q ON sod.QUALITY_FLAG_ID = q.ID LEFT OUTER JOIN
                         SO.EMPLOYEE AS f ON sod.FLOWN_BY_ID = f.ID LEFT OUTER JOIN
                         SO.CAMERA AS c ON sod.CAMERA_ID = c.ID LEFT OUTER JOIN
                         SO.EMPLOYEE AS v ON sod.VALIDATED_BY_ID = v.ID INNER JOIN
                         SO.EMPLOYEE AS cr ON sod.CREATED_BY_ID = cr.ID INNER JOIN
                         SO.EMPLOYEE AS up ON sod.LAST_UPDATED_BY_ID = up.ID LEFT OUTER JOIN
                         SO.KELP_PRESENT AS k ON sod.KELP_PRESENT_ID = k.ID LEFT OUTER JOIN
                         SO.LAND_PRESENT AS l ON sod.LAND_PRESENT_ID = l.ID LEFT OUTER JOIN
                         SO.IMAGE_QUALITY AS i ON sod.IMAGE_QUALITY_ID = i.ID
GO

IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane1' , N'SCHEMA',N'SO', N'VIEW',N'view_SO_D_allrecs_w_lookups', NULL,NULL))
	EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "sod"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "st"
            Begin Extent = 
               Top = 6
               Left = 297
               Bottom = 119
               Right = 467
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 505
               Bottom = 136
               Right = 675
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 713
               Bottom = 136
               Right = 883
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "q"
            Begin Extent = 
               Top = 6
               Left = 921
               Bottom = 163
               Right = 1091
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 6
               Left = 1129
               Bottom = 136
               Right = 1299
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 1337
               Bottom = 136
               Right = 1507
            End
            DisplayFlags = 280
            TopColumn = 0
         End
' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'VIEW',@level1name=N'view_SO_D_allrecs_w_lookups'
ELSE
BEGIN
	EXEC sys.sp_updateextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "sod"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "st"
            Begin Extent = 
               Top = 6
               Left = 297
               Bottom = 119
               Right = 467
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 6
               Left = 505
               Bottom = 136
               Right = 675
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 713
               Bottom = 136
               Right = 883
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "q"
            Begin Extent = 
               Top = 6
               Left = 921
               Bottom = 163
               Right = 1091
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 6
               Left = 1129
               Bottom = 136
               Right = 1299
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 1337
               Bottom = 136
               Right = 1507
            End
            DisplayFlags = 280
            TopColumn = 0
         End
' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'VIEW',@level1name=N'view_SO_D_allrecs_w_lookups'
END
GO

IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPane2' , N'SCHEMA',N'SO', N'VIEW',N'view_SO_D_allrecs_w_lookups', NULL,NULL))
	EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         Begin Table = "v"
            Begin Extent = 
               Top = 188
               Left = 915
               Bottom = 318
               Right = 1085
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cr"
            Begin Extent = 
               Top = 120
               Left = 297
               Bottom = 250
               Right = 467
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "up"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "k"
            Begin Extent = 
               Top = 138
               Left = 505
               Bottom = 251
               Right = 675
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "l"
            Begin Extent = 
               Top = 138
               Left = 713
               Bottom = 251
               Right = 885
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 138
               Left = 1129
               Bottom = 251
               Right = 1306
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 26
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'VIEW',@level1name=N'view_SO_D_allrecs_w_lookups'
ELSE
BEGIN
	EXEC sys.sp_updateextendedproperty @name=N'MS_DiagramPane2', @value=N'         Begin Table = "v"
            Begin Extent = 
               Top = 188
               Left = 915
               Bottom = 318
               Right = 1085
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cr"
            Begin Extent = 
               Top = 120
               Left = 297
               Bottom = 250
               Right = 467
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "up"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "k"
            Begin Extent = 
               Top = 138
               Left = 505
               Bottom = 251
               Right = 675
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "l"
            Begin Extent = 
               Top = 138
               Left = 713
               Bottom = 251
               Right = 885
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 138
               Left = 1129
               Bottom = 251
               Right = 1306
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 26
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'VIEW',@level1name=N'view_SO_D_allrecs_w_lookups'
END
GO

IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'MS_DiagramPaneCount' , N'SCHEMA',N'SO', N'VIEW',N'view_SO_D_allrecs_w_lookups', NULL,NULL))
	EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'VIEW',@level1name=N'view_SO_D_allrecs_w_lookups'
ELSE
BEGIN
	EXEC sys.sp_updateextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'SO', @level1type=N'VIEW',@level1name=N'view_SO_D_allrecs_w_lookups'
END
GO


