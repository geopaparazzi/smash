import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class SLZh extends SL {
  SLZh([String locale = 'zh']) : super(locale);

  @override
  String get main_welcome => '欢迎使用SMASH！';

  @override
  String get main_check_location_permission => '正在检测位置权限…';

  @override
  String get main_location_permission_granted => '位置权限已授予。';

  @override
  String get main_checkingStoragePermission => '正在检测存储权限…';

  @override
  String get main_storagePermissionGranted => '存储权限已授予。';

  @override
  String get main_loadingPreferences => '正在载入配置文件…';

  @override
  String get main_preferencesLoaded => '配置文件载入完毕。';

  @override
  String get main_loadingWorkspace => '正在载入工作空间…';

  @override
  String get main_workspaceLoaded => '工作空间已载入。';

  @override
  String get main_loadingTagsList => '正在载入Tag列表…';

  @override
  String get main_tagsListLoaded => 'Tag列表载入完毕。';

  @override
  String get main_loadingKnownProjections => '正在载入已知投影…';

  @override
  String get main_knownProjectionsLoaded => '投影载入完毕。';

  @override
  String get main_loadingFences => '正在载入地理围栏…';

  @override
  String get main_fencesLoaded => '地理围栏载入完毕。';

  @override
  String get main_loadingLayersList => '正在载入图层列表…';

  @override
  String get main_layersListLoaded => '图层列表加载完毕。';

  @override
  String get main_locationBackgroundWarning => '下一步授予位置权限将允许GPS在后台记录日志(否则GPS日志将在前台运行)\n提示：日志数据只存放在设备本地，不会进行数据上传。';

  @override
  String get main_StorageIsInternalWarning => '请仔细阅读！\n在 Android 11及以上版本环境下，项目文件夹必须放在\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\n文件夹中。\n如果APP被卸载后，系统将会移除此文件夹，所以请在卸载前备份好你的数据。\n\n关于这个问题，我们正在寻找更夹解决方案。';

  @override
  String get main_locationPermissionIsMandatoryToOpenSmash => 'SMASH要求必须打开位置权限。';

  @override
  String get main_storagePermissionIsMandatoryToOpenSmash => 'SMASH要求必须打开存储权限。';

  @override
  String get main_anErrorOccurredTapToView => '有错误发生，请单击查看。';

  @override
  String get mainView_loadingData => '正在加载数据…';

  @override
  String get mainView_turnGpsOn => 'GPS开';

  @override
  String get mainView_turnGpsOff => 'GPS关';

  @override
  String get mainView_exit => '退出';

  @override
  String get mainView_areYouSureCloseTheProject => '关闭工程？';

  @override
  String get mainView_activeOperationsWillBeStopped => '活动操作将会停止。';

  @override
  String get mainView_showInteractiveCoachMarks => '显示交互式向导标签。';

  @override
  String get mainView_openToolsDrawer => '打开工具箱。';

  @override
  String get mainView_zoomIn => '放大';

  @override
  String get mainView_zoomOut => '缩小';

  @override
  String get mainView_formNotes => '表单式注记';

  @override
  String get mainView_simpleNotes => '简单注记';

  @override
  String get mainviewUtils_projects => '工程';

  @override
  String get mainviewUtils_import => '导入';

  @override
  String get mainviewUtils_export => '导出';

  @override
  String get mainviewUtils_settings => '设置';

  @override
  String get mainviewUtils_onlineHelp => '在线帮助';

  @override
  String get mainviewUtils_about => '关于';

  @override
  String get mainviewUtils_projectInfo => '工程信息';

  @override
  String get mainviewUtils_projectStats => 'Project Stats';

  @override
  String get mainviewUtils_project => '工程';

  @override
  String get mainviewUtils_database => '数据库';

  @override
  String get mainviewUtils_extras => '其他';

  @override
  String get mainviewUtils_availableIcons => '可用图标';

  @override
  String get mainviewUtils_offlineMaps => '离线地图';

  @override
  String get mainviewUtils_positionTools => '位置工具';

  @override
  String get mainviewUtils_goTo => '转到';

  @override
  String get mainviewUtils_goToCoordinate => '转到坐标';

  @override
  String get mainviewUtils_enterLonLat => '输入经度，纬度';

  @override
  String get mainviewUtils_goToCoordinateWrongFormat => '坐标格式错误。 应为 11.18463, 46.12345';

  @override
  String get mainviewUtils_goToCoordinateEmpty => '此项不能为空。';

  @override
  String get mainviewUtils_sharePosition => '分享位置';

  @override
  String get mainviewUtils_rotateMapWithGps => '通过 GPS 旋转地图';

  @override
  String get exportWidget_export => '导出';

  @override
  String get exportWidget_pdfExported => '已导出的PDF';

  @override
  String get exportWidget_exportToPortableDocumentFormat => '将项目导出为PDF';

  @override
  String get exportWidget_gpxExported => '已导出的GPX';

  @override
  String get exportWidget_exportToGpx => '将工程导出为GPX';

  @override
  String get exportWidget_kmlExported => '已导出的KML';

  @override
  String get exportWidget_exportToKml => '将工程导出为KML';

  @override
  String get exportWidget_imagesToFolderExported => '已导出的图片';

  @override
  String get exportWidget_exportImagesToFolder => '将项目图片导出到文件夹';

  @override
  String get exportWidget_exportImagesToFolderTitle => '图片';

  @override
  String get exportWidget_geopackageExported => '已导出的Geopakage';

  @override
  String get exportWidget_exportToGeopackage => '将项目导出为GPKG';

  @override
  String get exportWidget_exportToGSS => '导出到Geopaparazzi勘测服务器';

  @override
  String get gssExport_gssExport => 'GSS导出';

  @override
  String get gssExport_setProjectDirty => '设置项目到DIRTY么？';

  @override
  String get gssExport_thisCantBeUndone => '该操作无法撤销！';

  @override
  String get gssExport_restoreProjectAsDirty => '恢复项目为混杂的。';

  @override
  String get gssExport_setProjectClean => '设置项目到清空么？';

  @override
  String get gssExport_restoreProjectAsClean => '恢复项目为清空。';

  @override
  String get gssExport_nothingToSync => '没有需要同步。';

  @override
  String get gssExport_collectingSyncStats => '正在收集同步统计…';

  @override
  String get gssExport_unableToSyncDueToError => '由于错误不能同步，检查诊断信息。';

  @override
  String get gssExport_noGssUrlSet => '未设置GSS服务端URL，检查你的设置。';

  @override
  String get gssExport_noGssPasswordSet => '未设置GSS服务端密码，检查你的设置。';

  @override
  String get gssExport_synStats => '同步统计';

  @override
  String get gssExport_followingDataWillBeUploaded => '以下数据将会被上传到服务端进行同步。';

  @override
  String get gssExport_gpsLogs => 'GPS日志：';

  @override
  String get gssExport_simpleNotes => '简单笔记：';

  @override
  String get gssExport_formNotes => '表单笔记：';

  @override
  String get gssExport_images => '图片：';

  @override
  String get gssExport_shouldNotHappen => '不应该发生';

  @override
  String get gssExport_upload => '上传';

  @override
  String get geocoding_geocoding => '地理编码';

  @override
  String get geocoding_nothingToLookFor => '未找到相关信息。插入一个地址。';

  @override
  String get geocoding_launchGeocoding => '启动地理编码';

  @override
  String get geocoding_searching => '查找中…';

  @override
  String get gps_smashIsActive => 'SMASH 正在运行';

  @override
  String get gps_smashIsLogging => 'SMASH 正在记录';

  @override
  String get gps_locationTracking => '位置跟踪';

  @override
  String get gps_smashLocServiceIsActive => 'SMASH 位置服务已激活。';

  @override
  String get gps_backgroundLocIsOnToKeepRegistering => '后台定位功能开启后，即使应用程序处于后台，也能继续注册位置信息。';

  @override
  String get gssImport_gssImport => 'GSS导入';

  @override
  String get gssImport_downloadingDataList => '正在下载数据列表…';

  @override
  String get gssImport_unableDownloadDataList => '由于错误，无法下载数据列表。检查你的设置和日志。';

  @override
  String get gssImport_noGssUrlSet => '未设置 GSS 服务器 URL，检查你的设置。';

  @override
  String get gssImport_noGssPasswordSet => '没有设置 GSS 服务器密码，检查你的设置。';

  @override
  String get gssImport_noPermToAccessServer => '无权限访问服务器，检查你的证书。';

  @override
  String get gssImport_data => '数据';

  @override
  String get gssImport_dataSetsDownloadedMapsFolder => '数据集被下载到地图文件夹中。';

  @override
  String get gssImport_noDataAvailable => '无可用数据。';

  @override
  String get gssImport_projects => '项目';

  @override
  String get gssImport_projectsDownloadedProjectFolder => '项目数据被下载到projects文件夹。';

  @override
  String get gssImport_noProjectsAvailable => '无可用项目。';

  @override
  String get gssImport_forms => '表单';

  @override
  String get gssImport_tagsDownloadedFormsFolder => '标记文件被下载到表单文件夹。';

  @override
  String get gssImport_noTagsAvailable => '无可用标记。';

  @override
  String get importWidget_import => '导入';

  @override
  String get importWidget_importFromGeopaparazzi => '从Geopaparazzi勘测服务器导入';

  @override
  String get layersView_layerList => '图层列表';

  @override
  String get layersView_loadRemoteDatabase => '载入远程数据库';

  @override
  String get layersView_loadOnlineSources => '加载在线数据源';

  @override
  String get layersView_loadLocalDatasets => '加载本地数据集';

  @override
  String get layersView_loading => '加载中…';

  @override
  String get layersView_zoomTo => '放大';

  @override
  String get layersView_properties => '属性';

  @override
  String get layersView_delete => '删除';

  @override
  String get layersView_projCouldNotBeRecognized => '无法识别的项目。点击手动输入epsg代码。';

  @override
  String get layersView_projNotSupported => '不支持的项目。单击解决。';

  @override
  String get layersView_onlyImageFilesWithWorldDef => '只支持具有世界文件定义的图像文件。';

  @override
  String get layersView_onlyImageFileWithPrjDef => '仅支持带有 prj 文件定义的图像文件。';

  @override
  String get layersView_selectTableToLoad => '选择要加载的表格。';

  @override
  String get layersView_fileFormatNotSUpported => '文件格式不支持。';

  @override
  String get onlineSourcesPage_onlineSourcesCatalog => '在线数据源分类';

  @override
  String get onlineSourcesPage_loadingTmsLayers => '正在载入TMS图层…';

  @override
  String get onlineSourcesPage_loadingWmsLayers => '正在加载WMS图层…';

  @override
  String get onlineSourcesPage_importFromFile => '从文件导入';

  @override
  String get onlineSourcesPage_theFile => '文件';

  @override
  String get onlineSourcesPage_doesntExist => '不存在';

  @override
  String get onlineSourcesPage_onlineSourcesImported => '在线数据源已导入。';

  @override
  String get onlineSourcesPage_exportToFile => '导出到文件';

  @override
  String get onlineSourcesPage_exportedTo => '导出到：';

  @override
  String get onlineSourcesPage_delete => '删除';

  @override
  String get onlineSourcesPage_addToLayers => '添加到图层';

  @override
  String get onlineSourcesPage_setNameTmsService => '设置TMS服务名称';

  @override
  String get onlineSourcesPage_enterName => '输入名称';

  @override
  String get onlineSourcesPage_pleaseEnterValidName => '请输入可用名称';

  @override
  String get onlineSourcesPage_insertUrlOfService => '插入服务URL。';

  @override
  String get onlineSourcesPage_placeXyzBetBrackets => '在小括弧中输入x,y,z.';

  @override
  String get onlineSourcesPage_pleaseEnterValidTmsUrl => '请输入可用的TMS URL';

  @override
  String get onlineSourcesPage_enterUrl => '输入URL';

  @override
  String get onlineSourcesPage_enterSubDomains => '输入子域名';

  @override
  String get onlineSourcesPage_addAttribution => '添加所有权信息。';

  @override
  String get onlineSourcesPage_enterAttribution => '输入所有者';

  @override
  String get onlineSourcesPage_setMinMaxZoom => '设置最大最小缩放级别。';

  @override
  String get onlineSourcesPage_minZoom => '最小缩放级别';

  @override
  String get onlineSourcesPage_maxZoom => '最大缩放级别';

  @override
  String get onlineSourcesPage_pleaseCheckYourData => '请检查你的数据';

  @override
  String get onlineSourcesPage_details => '详细信息';

  @override
  String get onlineSourcesPage_name => '名称： ';

  @override
  String get onlineSourcesPage_subDomains => '子域名： ';

  @override
  String get onlineSourcesPage_attribution => '所有权： ';

  @override
  String get onlineSourcesPage_cancel => '取消';

  @override
  String get onlineSourcesPage_ok => '确定';

  @override
  String get onlineSourcesPage_newTmsOnlineService => '新建TMS在线服务';

  @override
  String get onlineSourcesPage_save => '保存';

  @override
  String get onlineSourcesPage_theBaseUrlWithQuestionMark => '基本URL以?结尾。';

  @override
  String get onlineSourcesPage_pleaseEnterValidWmsUrl => '请输入可用WMS URL';

  @override
  String get onlineSourcesPage_setWmsLayerName => '设置WMS层名';

  @override
  String get onlineSourcesPage_enterLayerToLoad => '输入要加载图层';

  @override
  String get onlineSourcesPage_pleaseEnterValidLayer => '请输入可用图层';

  @override
  String get onlineSourcesPage_setWmsImageFormat => '设置WMS图片格式';

  @override
  String get onlineSourcesPage_addAnAttribution => '增加所有权信息。';

  @override
  String get onlineSourcesPage_layer => '图层： ';

  @override
  String get onlineSourcesPage_url => 'URL： ';

  @override
  String get onlineSourcesPage_format => '格式';

  @override
  String get onlineSourcesPage_newWmsOnlineService => '新建WMS在线服务';

  @override
  String get remoteDbPage_remoteDatabases => '远程数据库';

  @override
  String get remoteDbPage_delete => '删除';

  @override
  String get remoteDbPage_areYouSureDeleteDatabase => '删除数据库配置？';

  @override
  String get remoteDbPage_edit => '编辑';

  @override
  String get remoteDbPage_table => '表格';

  @override
  String get remoteDbPage_user => '用户';

  @override
  String get remoteDbPage_loadInMap => '载入到地图中。';

  @override
  String get remoteDbPage_databaseParameters => '数据库参数';

  @override
  String get remoteDbPage_cancel => '取消';

  @override
  String get remoteDbPage_ok => '确定';

  @override
  String get remoteDbPage_theUrlNeedsToBeDefined => '必须定义URL。格式如(postgis:host:port/databasename)';

  @override
  String get remoteDbPage_theUserNeedsToBeDefined => '必须定义用户。';

  @override
  String get remoteDbPage_password => '密码';

  @override
  String get remoteDbPage_thePasswordNeedsToBeDefined => '必须设置密码。';

  @override
  String get remoteDbPage_loadingTables => '正在加载表格…';

  @override
  String get remoteDbPage_theTableNeedsToBeDefined => '必须定义表格名称。';

  @override
  String get remoteDbPage_unableToConnectToDatabase => '未能连接到数据库，请检查参数和网络。';

  @override
  String get remoteDbPage_optionalWhereCondition => '选项 “where” 条件';

  @override
  String get geoImage_tiffProperties => 'TIFF属性';

  @override
  String get geoImage_opacity => '不透明度';

  @override
  String get geoImage_colorToHide => '隐藏的颜色';

  @override
  String get gpx_gpxProperties => 'GPX属性';

  @override
  String get gpx_wayPoints => '航迹点';

  @override
  String get gpx_color => '颜色';

  @override
  String get gpx_size => '大小';

  @override
  String get gpx_viewLabelsIfAvailable => '如果可用，则显示标记？';

  @override
  String get gpx_tracksRoutes => '轨迹/路径';

  @override
  String get gpx_width => '宽度';

  @override
  String get gpx_palette => '调色板';

  @override
  String get tiles_tileProperties => '瓦片属性';

  @override
  String get tiles_opacity => '不透明度';

  @override
  String get tiles_loadGeoPackageAsOverlay => '加载GPKG瓦片作为叠加图像和瓦片层对比（最好是GDAL库生成的数据和不同的投影）。';

  @override
  String get tiles_colorToHide => '隐藏的颜色';

  @override
  String get wms_wmsProperties => 'WMS属性';

  @override
  String get wms_opacity => '不透明度';

  @override
  String get featureAttributesViewer_loadingData => '加载数据…';

  @override
  String get featureAttributesViewer_setNewValue => '设定新值';

  @override
  String get featureAttributesViewer_field => '字段';

  @override
  String get featureAttributesViewer_value => '值';

  @override
  String get projectsView_projectsView => '项目视图';

  @override
  String get projectsView_openExistingProject => '打开一个已存在的项目';

  @override
  String get projectsView_createNewProject => '新建一个项目';

  @override
  String get projectsView_recentProjects => '最近项目';

  @override
  String get projectsView_newProject => '新项目';

  @override
  String get projectsView_enterNameForNewProject => '输入一个新项目名称或者使用建议的。';

  @override
  String get dataLoader_note => '笔记';

  @override
  String get dataLoader_Note => '笔记';

  @override
  String get dataLoader_hasForm => '有格式';

  @override
  String get dataLoader_POI => '兴趣点';

  @override
  String get dataLoader_savingImageToDB => '保存图片到数据库…';

  @override
  String get dataLoader_removeNote => '移除笔记';

  @override
  String get dataLoader_areYouSureRemoveNote => '移除笔记么？';

  @override
  String get dataLoader_image => '图片';

  @override
  String get dataLoader_longitude => '经度';

  @override
  String get dataLoader_latitude => '纬度';

  @override
  String get dataLoader_altitude => '海拔';

  @override
  String get dataLoader_timestamp => '时间戳';

  @override
  String get dataLoader_removeImage => '移除图片';

  @override
  String get dataLoader_areYouSureRemoveImage => '移除图片么？';

  @override
  String get images_loadingImage => '加载图片中…';

  @override
  String get about_loadingInformation => '加载信息中…';

  @override
  String get about_ABOUT => '关于 ';

  @override
  String get about_smartMobileAppForSurveyor => '令测量员高兴的智能移动应用';

  @override
  String get about_applicationVersion => '版本';

  @override
  String get about_license => '协议';

  @override
  String get about_isAvailableUnderGPL3 => ' 是遵循协议GPLv3+并非盈利的自由软件。';

  @override
  String get about_sourceCode => '源码';

  @override
  String get about_tapHereToVisitRepo => '点按这里查看该源码仓库';

  @override
  String get about_legalInformation => '法律信息';

  @override
  String get about_copyright2020HydroloGIS => '版权©2020，HydroloGIS S.r.l. — 一些权力保留，点按查看。';

  @override
  String get about_supportedBy => '被支持';

  @override
  String get about_partiallySupportedByUniversityTrento => '部分由意大利特兰托大学（University of Trento）的Steep Stream项目支持。';

  @override
  String get about_privacyPolicy => '隐私政策';

  @override
  String get about_tapHereToSeePrivacyPolicy => '点按这里查看涵盖用户和位置数据的隐私政策。';

  @override
  String get gpsInfoButton_noGpsInfoAvailable => '没有GPS信息可用…';

  @override
  String get gpsInfoButton_timestamp => '时间戳';

  @override
  String get gpsInfoButton_speed => '速度';

  @override
  String get gpsInfoButton_heading => '航向';

  @override
  String get gpsInfoButton_accuracy => '精度';

  @override
  String get gpsInfoButton_altitude => '海报';

  @override
  String get gpsInfoButton_latitude => '纬度';

  @override
  String get gpsInfoButton_copyLatitudeToClipboard => '复制纬度到剪切板。';

  @override
  String get gpsInfoButton_longitude => '经度';

  @override
  String get gpsInfoButton_copyLongitudeToClipboard => '复制经度到剪切板。';

  @override
  String get gpsLogButton_stopLogging => '停止记录么？';

  @override
  String get gpsLogButton_stopLoggingAndCloseLog => '停止记录并关闭当前GPS记录么？';

  @override
  String get gpsLogButton_newLog => '新记录';

  @override
  String get gpsLogButton_enterNameForNewLog => '为新记录键入名称';

  @override
  String get gpsLogButton_couldNotStartLogging => '不能开始记录： ';

  @override
  String get imageWidgets_loadingImage => '加载图片中…';

  @override
  String get logList_gpsLogsList => 'GPS记录文件列表';

  @override
  String get logList_selectAll => '全选';

  @override
  String get logList_unSelectAll => '全不选';

  @override
  String get logList_invertSelection => '反选';

  @override
  String get logList_mergeSelected => '合并选择';

  @override
  String get logList_loadingLogs => '加载记录文件中…';

  @override
  String get logList_zoomTo => '缩放至';

  @override
  String get logList_properties => '属性';

  @override
  String get logList_profileView => '配置视图';

  @override
  String get logList_toGPX => '到GPX';

  @override
  String get logList_gpsSavedInExportFolder => 'GPX保存在输出文件夹。';

  @override
  String get logList_errorOccurredExportingLogGPX => '不能输出记录到GPX中。';

  @override
  String get logList_delete => '删除';

  @override
  String get logList_DELETE => '删除';

  @override
  String get logList_areYouSureDeleteTheLog => '删除记录么？';

  @override
  String get logList_hours => '小时';

  @override
  String get logList_hour => '小时';

  @override
  String get logList_minutes => '分钟';

  @override
  String get logProperties_gpsLogProperties => 'GPS记录属性';

  @override
  String get logProperties_logName => '日志名称';

  @override
  String get logProperties_start => '开始';

  @override
  String get logProperties_end => '结束';

  @override
  String get logProperties_duration => '持续';

  @override
  String get logProperties_color => '颜色';

  @override
  String get logProperties_palette => '调色板';

  @override
  String get logProperties_width => '宽度';

  @override
  String get logProperties_distanceAtPosition => '到位置的距离：';

  @override
  String get logProperties_totalDistance => '总距离：';

  @override
  String get logProperties_gpsLogView => 'GPS记录视图';

  @override
  String get logProperties_disableStats => '关闭卫星';

  @override
  String get logProperties_enableStats => '打开卫星';

  @override
  String get logProperties_totalDuration => '总共持续：';

  @override
  String get logProperties_timestamp => '时间戳：';

  @override
  String get logProperties_durationAtPosition => '在位置持续时间：';

  @override
  String get logProperties_speed => '速度：';

  @override
  String get logProperties_elevation => '高程：';

  @override
  String get noteList_simpleNotesList => '简单的笔记列表';

  @override
  String get noteList_formNotesList => '表单式笔记列表';

  @override
  String get noteList_loadingNotes => '加载笔记中…';

  @override
  String get noteList_zoomTo => '缩放至';

  @override
  String get noteList_edit => '编辑';

  @override
  String get noteList_properties => '属性';

  @override
  String get noteList_delete => '删除';

  @override
  String get noteList_DELETE => '删除';

  @override
  String get noteList_areYouSureDeleteNote => '删除该笔记？';

  @override
  String get settings_settings => '设置';

  @override
  String get settings_camera => '相机';

  @override
  String get settings_cameraResolution => '相机分辨率';

  @override
  String get settings_resolution => '分辨率';

  @override
  String get settings_theCameraResolution => '该相机分辨率';

  @override
  String get settings_screen => '屏幕';

  @override
  String get settings_screenScaleBarIconSize => '屏幕，比例尺和图标大小';

  @override
  String get settings_keepScreenOn => '保持屏幕开启';

  @override
  String get settings_retinaScreenMode => '高分辨率屏幕模式';

  @override
  String get settings_toApplySettingEnterExitLayerView => '输入并退出图层视图以应用设置。';

  @override
  String get settings_colorPickerToUse => '颜色拾取使用';

  @override
  String get settings_mapCenterCross => '地图中心十字丝';

  @override
  String get settings_color => '颜色';

  @override
  String get settings_size => '大小';

  @override
  String get settings_width => '宽度';

  @override
  String get settings_mapToolsIconSize => '地图工具的图标大小';

  @override
  String get settings_gps => 'GPS';

  @override
  String get settings_gpsFiltersAndMockLoc => 'GPS过滤器和模拟位置';

  @override
  String get settings_livePreview => '动态预览';

  @override
  String get settings_noPointAvailableYet => '没有可用点。';

  @override
  String get settings_longitudeDeg => '经度（度）';

  @override
  String get settings_latitudeDeg => '纬度（度）';

  @override
  String get settings_accuracyM => '精度（米）';

  @override
  String get settings_altitudeM => '海拔（米）';

  @override
  String get settings_headingDeg => '航向（度）';

  @override
  String get settings_speedMS => '速度（米每秒）';

  @override
  String get settings_isLogging => '记录日记么？';

  @override
  String get settings_mockLocations => '模拟位置么？';

  @override
  String get settings_minDistFilterBlocks => '过滤模拟的最小距离';

  @override
  String get settings_minDistFilterPasses => '过滤通过的最小距离';

  @override
  String get settings_minTimeFilterBlocks => '过滤模拟的最小时间';

  @override
  String get settings_minTimeFilterPasses => '过滤通过最小时间';

  @override
  String get settings_hasBeenBlocked => '已被屏蔽';

  @override
  String get settings_distanceFromPrevM => '到前一个的距离';

  @override
  String get settings_timeFromPrevS => '到前一个的时间';

  @override
  String get settings_locationInfo => '位置信息';

  @override
  String get settings_filters => '过滤器';

  @override
  String get settings_disableFilters => '关闭过滤器。';

  @override
  String get settings_enableFilters => '打开过滤器。';

  @override
  String get settings_zoomIn => '放大';

  @override
  String get settings_zoomOut => '缩小';

  @override
  String get settings_activatePointFlow => '激活点流。';

  @override
  String get settings_pausePointsFlow => '暂停点流。';

  @override
  String get settings_visualizePointCount => '可视化点数';

  @override
  String get settings_showGpsPointsValidPoints => '显示可用的GPS点数。';

  @override
  String get settings_showGpsPointsAllPoints => '显示所有的GPS点数。';

  @override
  String get settings_logFilters => '日志过滤器';

  @override
  String get settings_minDistanceBetween2Points => '2点间最小距离。';

  @override
  String get settings_minTimespanBetween2Points => '2点间最小时间差。';

  @override
  String get settings_gpsFilter => 'GPS过滤器';

  @override
  String get settings_disable => '关闭';

  @override
  String get settings_enable => '打开';

  @override
  String get settings_theUseOfTheGps => '过滤的GPS的使用。';

  @override
  String get settings_warningThisWillAffectGpsPosition => '警告：这将会影响GPS位置，笔记插入，日志统计和制图。';

  @override
  String get settings_MockLocations => '模拟的位置';

  @override
  String get settings_testGpsLogDemoUse => '用于演示的GPS测试日志。';

  @override
  String get settings_setDurationGpsPointsInMilli => '设置GPS点间的时间间隔（毫秒）。';

  @override
  String get settings_SETTING => '设置';

  @override
  String get settings_setMockedGpsDuration => '设置模拟的GPS时间间隔';

  @override
  String get settings_theValueHasToBeInt => '该值必须为完整的数字。';

  @override
  String get settings_milliseconds => '毫秒';

  @override
  String get settings_useGoogleToImproveLoc => '使用谷歌服务来提升位置精度';

  @override
  String get settings_useOfGoogleServicesRestart => '谷歌服务的使用（应用需要重启）。';

  @override
  String get settings_gpsLogsViewMode => 'GPS日志视图模式';

  @override
  String get settings_logViewModeForOrigData => '用于原始数据的日志视图模式。';

  @override
  String get settings_logViewModeFilteredData => '用于过滤数据的日志视图模式。';

  @override
  String get settings_cancel => '取消';

  @override
  String get settings_ok => '确定';

  @override
  String get settings_notesViewModes => '笔记视图模式';

  @override
  String get settings_selectNotesViewMode => '选择一个模式来可视笔记。';

  @override
  String get settings_mapPlugins => '地图插件';

  @override
  String get settings_vectorLayers => '矢量图层';

  @override
  String get settings_loadingOptionsInfoTool => '加载选项和信息工具';

  @override
  String get settings_dataLoading => '数据加载';

  @override
  String get settings_maxNumberFeatures => '最大的要素数量。';

  @override
  String get settings_maxNumFeaturesPerLayer => '每个图层的最大要素数量。移除和添加该图层并应用。';

  @override
  String get settings_all => '所有';

  @override
  String get settings_loadMapArea => '加载地图区域。';

  @override
  String get settings_loadOnlyLastVisibleArea => '仅加载最后可视的地图区域。移除和再次添加该图层并应用。';

  @override
  String get settings_infoTool => '信息工具';

  @override
  String get settings_tapSizeInfoToolPixels => '信息工具在像素尺度中点按大小。';

  @override
  String get settings_editingTool => '编辑的工具';

  @override
  String get settings_editingDragIconSize => '编辑拖放处理图标大小。';

  @override
  String get settings_editingIntermediateDragIconSize => '编辑中中间拖放处理的图标大小。';

  @override
  String get settings_diagnostics => '诊断';

  @override
  String get settings_diagnosticsDebugLog => '诊断和调试日志';

  @override
  String get settings_openFullDebugLog => '打开全部的调试日志';

  @override
  String get settings_debugLogView => '调试日志视图';

  @override
  String get settings_viewAllMessages => '查看所有消息';

  @override
  String get settings_viewOnlyErrorsWarnings => '仅看错误和警告';

  @override
  String get settings_clearDebugLog => '清除调试日志';

  @override
  String get settings_loadingData => '加载数据…';

  @override
  String get settings_device => '设备';

  @override
  String get settings_deviceIdentifier => '设备识别器';

  @override
  String get settings_deviceId => '设备ID';

  @override
  String get settings_overrideDeviceId => '覆盖设备ID';

  @override
  String get settings_overrideId => '覆盖ID';

  @override
  String get settings_pleaseEnterValidPassword => '请输入一个有效的服务器密码。';

  @override
  String get settings_gss => 'GSS';

  @override
  String get settings_geopaparazziSurveyServer => 'Geopaparazzi勘测服务器';

  @override
  String get settings_serverUrl => '服务器URL';

  @override
  String get settings_serverUrlStartWithHttp => '服务器URL需要以HTTP或者HTTPS开始。';

  @override
  String get settings_serverPassword => '服务器密码';

  @override
  String get settings_allowSelfSignedCert => '允许自签名证书';

  @override
  String get toolbarTools_zoomOut => '缩小';

  @override
  String get toolbarTools_zoomIn => '放大';

  @override
  String get toolbarTools_cancelCurrentEdit => '取消当前编辑。';

  @override
  String get toolbarTools_saveCurrentEdit => '保存当前编辑。';

  @override
  String get toolbarTools_insertPointMapCenter => '在地图中心插入点。';

  @override
  String get toolbarTools_insertPointGpsPos => '在GPS位置上插入点。';

  @override
  String get toolbarTools_removeSelectedFeature => '移除选择的要素。';

  @override
  String get toolbarTools_showFeatureAttributes => '显示要素的属性。';

  @override
  String get toolbarTools_featureDoesNotHavePrimaryKey => '该要素没有主键，故不允许编辑。';

  @override
  String get toolbarTools_queryFeaturesVectorLayers => '从加载的矢量层中查询要素。';

  @override
  String get toolbarTools_measureDistanceWithFinger => '在地图上使用你的手指测量距离。';

  @override
  String get toolbarTools_modifyGeomVectorLayers => '修改编辑矢量图层的几何形状。';

  @override
  String get coachMarks_singleTap => '单按： ';

  @override
  String get coachMarks_longTap => '长按： ';

  @override
  String get coachMarks_doubleTap => '双击： ';

  @override
  String get coachMarks_simpleNoteButton => '简单的笔记按钮';

  @override
  String get coachMarks_addNewNote => '增加一个新的笔记';

  @override
  String get coachMarks_viewNotesList => '查看笔记列表';

  @override
  String get coachMarks_viewNotesSettings => '查看笔记的设置';

  @override
  String get coachMarks_formNotesButton => '表单笔记按钮';

  @override
  String get coachMarks_addNewFormNote => '增加一个表单笔记';

  @override
  String get coachMarks_viewFormNoteList => '查看表单笔记列表';

  @override
  String get coachMarks_gpsLogButton => 'GPS日志按钮';

  @override
  String get coachMarks_startStopLogging => '开始记录日志/停止记录日志';

  @override
  String get coachMarks_viewLogsList => '查看日志列表';

  @override
  String get coachMarks_viewLogsSettings => '查看日志设置';

  @override
  String get coachMarks_gpsInfoButton => 'GPS信息按钮（如果合适）';

  @override
  String get coachMarks_centerMapOnGpsPos => '在GPS位置居中地图';

  @override
  String get coachMarks_showGpsInfo => '显示GPS信息';

  @override
  String get coachMarks_toggleAutoCenterGps => '自动固定GPS中心';

  @override
  String get coachMarks_layersViewButton => '图层视图按钮';

  @override
  String get coachMarks_openLayersView => '打开一个图层视图';

  @override
  String get coachMarks_openLayersPluginDialog => '打开该图层的插件对话框';

  @override
  String get coachMarks_zoomInButton => '放大按钮';

  @override
  String get coachMarks_zoomImMapOneLevel => '放大地图一个级别';

  @override
  String get coachMarks_zoomOutButton => '缩小按钮';

  @override
  String get coachMarks_zoomOutMapOneLevel => '缩小地图一个级别';

  @override
  String get coachMarks_bottomToolsButton => '底部工具按钮';

  @override
  String get coachMarks_toggleBottomToolsBar => '固定底部工具条';

  @override
  String get coachMarks_toolsButton => '工具按钮';

  @override
  String get coachMarks_openEndDrawerToAccessProject => '打开最后的折叠来获取项目的信息和共享选项和地图插件，要素工具和额外工具一样';

  @override
  String get coachMarks_interactiveCoackMarksButton => '交互的指导标记按钮';

  @override
  String get coachMarks_openInteractiveCoachMarks => '打开该交互的指导标记来阐述主要地图视图中的全部动作。';

  @override
  String get coachMarks_mainMenuButton => '主要菜单按钮';

  @override
  String get coachMarks_openDrawerToLoadProject => '打开折叠来加载或者创建一个项目，导入和导出数据，与服务器同步，进行设置和退出该应用/关闭GPS。';

  @override
  String get coachMarks_skip => '跳过';

  @override
  String get network_cancelledByUser => '已被用户取消。';

  @override
  String get network_completed => '完成。';

  @override
  String get network_buildingBaseCachePerformance => '构建基本的缓存用于提高性能（可能需要一会）…';

  @override
  String get network_thisFIleAlreadyBeingDownloaded => '该文件已被下载了。';

  @override
  String get network_download => '下载';

  @override
  String get network_downloadFile => '下载文件';

  @override
  String get network_toTheDeviceTakeTime => '到该设备么？这要花费一会。';

  @override
  String get network_availableMaps => '可用的地图';

  @override
  String get network_searchMapByName => '以名字搜索地图';

  @override
  String get network_uploading => '上传中…';

  @override
  String get network_pleaseWait => '请稍等…';

  @override
  String get network_permissionOnServerDenied => '在服务器中权限被拒。';

  @override
  String get network_couldNotConnectToServer => '不能连接到服务器，它在线么？检查你的地址。';

  @override
  String get form_smash_cantSaveImageDb => '不能将图片保存到数据库。';

  @override
  String get formbuilder => '表单构造器';

  @override
  String get layersView_selectGssLayers => '选择GSS图层';

  @override
  String get layersView_noGssLayersFound => '未发现GSS图层。';

  @override
  String get layersView_noGssLayersAvailable => '没有可用图层（已载入的未显示）。';

  @override
  String get layersView_selectGssLayersToLoad => '选择GSS图层用于加载。';

  @override
  String get layersView_unableToLoadGssLayers => '不能加载：';

  @override
  String get layersView_layerExists => '存在的图层';

  @override
  String get layersView_layerAlreadyExists => '该图层已存在，是否覆盖？';

  @override
  String get gss_layerview_upload_changes => '上传变更';

  @override
  String get allGpsPointsCount => 'GPS点';

  @override
  String get filteredGpsPointsCount => '过滤的点';

  @override
  String get addTmsFromDefaults => '增加默认的TMS';

  @override
  String get form_smash_noCameraDesktop => '桌面没有相机选项可用。';

  @override
  String get settings_BottombarCustomization => '底部栏自定义';

  @override
  String get settings_Bottombar_showAddNote => '显示增加笔记的按钮';

  @override
  String get settings_Bottombar_showAddFormNote => '显示增加表单笔记的按钮';

  @override
  String get settings_Bottombar_showAddGpsLog => '显示增加GPS日志按钮';

  @override
  String get settings_Bottombar_showGpsButton => '显示GPS按钮';

  @override
  String get settings_Bottombar_showLayers => '显示图层按钮';

  @override
  String get settings_Bottombar_showZoom => '显示缩放按钮';

  @override
  String get settings_Bottombar_showEditing => '显示编辑按钮';

  @override
  String get gss_layerview_filter => '过滤器';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class SLZhHans extends SLZh {
  SLZhHans(): super('zh_Hans');

  @override
  String get main_welcome => '欢迎使用SMASH!';

  @override
  String get main_check_location_permission => '正在检测位置权限…';

  @override
  String get main_location_permission_granted => '位置权限已授予.';

  @override
  String get main_checkingStoragePermission => '正在检测存储权限…';

  @override
  String get main_storagePermissionGranted => '存储权限已授予.';

  @override
  String get main_loadingPreferences => '正在载入配置文件…';

  @override
  String get main_preferencesLoaded => '配置文件载入完毕.';

  @override
  String get main_loadingWorkspace => '正在载入工作空间…';

  @override
  String get main_workspaceLoaded => '工作空间载入完毕.';

  @override
  String get main_loadingTagsList => '正在载入Tag列表…';

  @override
  String get main_tagsListLoaded => 'Tag列表载入完毕.';

  @override
  String get main_loadingKnownProjections => '正在载入已知投影…';

  @override
  String get main_knownProjectionsLoaded => '投影载入完毕.';

  @override
  String get main_loadingFences => '正在载入地理围栏…';

  @override
  String get main_fencesLoaded => '地理围栏载入完毕.';

  @override
  String get main_loadingLayersList => '正在载入图层列表…';

  @override
  String get main_layersListLoaded => '图层列表加载完毕.';

  @override
  String get main_locationBackgroundWarning => '下一步授予位置权限将允许GPS在后台记录日志(否则GPS日志将在前台运行)，提示：日志数据只存放在设备本地，不会进行数据上传。';

  @override
  String get main_StorageIsInternalWarning => '请仔细阅读！\n在 Android 11及以上版本环境下，项目文件夹必须放在\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\n文件夹中。\n如果APP被卸载后，系统将会移除此文件夹，所以请在卸载前备份好你的数据。\n\n关于这个问题，我们正在寻找更夹解决方案。';

  @override
  String get main_locationPermissionIsMandatoryToOpenSmash => 'SMASH要求必须打开位置权限。';

  @override
  String get main_storagePermissionIsMandatoryToOpenSmash => 'SMASH要求必须打开存储权限。';

  @override
  String get main_anErrorOccurredTapToView => '有错误发生，请单击查看。';

  @override
  String get mainView_loadingData => '正在加载数据…';

  @override
  String get mainView_turnGpsOn => 'GPS开';

  @override
  String get mainView_turnGpsOff => 'GPS关';

  @override
  String get mainView_exit => '退出';

  @override
  String get mainView_areYouSureCloseTheProject => '关闭工程？';

  @override
  String get mainView_activeOperationsWillBeStopped => '活动操作将会停止。';

  @override
  String get mainView_showInteractiveCoachMarks => '显示交互式向导标签。';

  @override
  String get mainView_openToolsDrawer => '打开工具箱。';

  @override
  String get mainView_zoomIn => '放大';

  @override
  String get mainView_zoomOut => '缩小';

  @override
  String get mainView_formNotes => '表单式注记';

  @override
  String get mainView_simpleNotes => '简单注记';

  @override
  String get mainviewUtils_projects => '工程';

  @override
  String get mainviewUtils_import => '导入';

  @override
  String get mainviewUtils_export => '导出';

  @override
  String get mainviewUtils_settings => '设置';

  @override
  String get mainviewUtils_onlineHelp => '在线帮助';

  @override
  String get mainviewUtils_about => '关于';

  @override
  String get mainviewUtils_projectInfo => '工程信息';

  @override
  String get mainviewUtils_project => '工程';

  @override
  String get mainviewUtils_database => '数据库';

  @override
  String get mainviewUtils_extras => '其他';

  @override
  String get mainviewUtils_availableIcons => '可用图标';

  @override
  String get mainviewUtils_offlineMaps => '离线地图';

  @override
  String get mainviewUtils_positionTools => '位置工具';

  @override
  String get mainviewUtils_goTo => '转到';

  @override
  String get mainviewUtils_sharePosition => '共享位置';

  @override
  String get mainviewUtils_rotateMapWithGps => '随着GPS旋转地图';

  @override
  String get exportWidget_export => '导出';

  @override
  String get exportWidget_pdfExported => 'PDF导出';

  @override
  String get exportWidget_exportToPortableDocumentFormat => '导出工程到PDF文档';

  @override
  String get exportWidget_gpxExported => 'GPX已导出';

  @override
  String get exportWidget_exportToGpx => '导出工程到GPX';

  @override
  String get exportWidget_kmlExported => '已导出到KML';

  @override
  String get exportWidget_exportToKml => '导出工程到KML';

  @override
  String get exportWidget_imagesToFolderExported => '照片已导出';

  @override
  String get exportWidget_exportImagesToFolder => '导出工程照片';

  @override
  String get exportWidget_exportImagesToFolderTitle => '照片列表';

  @override
  String get exportWidget_geopackageExported => '已导出到Geopakage';

  @override
  String get exportWidget_exportToGeopackage => '导出工程到Geopackage';

  @override
  String get exportWidget_exportToGSS => '导出到GSS';

  @override
  String get gssExport_gssExport => '导出到GSS';

  @override
  String get gssExport_setProjectDirty => '设置工程为DIRTY？';

  @override
  String get gssExport_thisCantBeUndone => '此操作无法撤销！';

  @override
  String get gssExport_restoreProjectAsDirty => '重置工程为dirty。';

  @override
  String get gssExport_setProjectClean => '设置工程为CLEAN?';

  @override
  String get gssExport_restoreProjectAsClean => '已重置工程为CLEAN。';

  @override
  String get gssExport_nothingToSync => '无可同步数据。';

  @override
  String get gssExport_collectingSyncStats => '正在收集同步状态…';

  @override
  String get gssExport_unableToSyncDueToError => '同步过程出错，请点击诊断。';

  @override
  String get gssExport_noGssUrlSet => '未设置GSS服务端IP，请检查设置。';

  @override
  String get gssExport_noGssPasswordSet => '未设置GSS服务端密码，请检查设置。';

  @override
  String get gssExport_synStats => '同步状态';

  @override
  String get gssExport_followingDataWillBeUploaded => '以下数据将同步到服务端。';

  @override
  String get gssExport_gpsLogs => 'GPS日志：';

  @override
  String get gssExport_simpleNotes => '建筑注记：';

  @override
  String get gssExport_formNotes => '表单注记：';

  @override
  String get gssExport_images => '照片列表：';

  @override
  String get gssExport_shouldNotHappen => '不应该发生';

  @override
  String get gssExport_upload => '上传';

  @override
  String get geocoding_geocoding => '地理编码';

  @override
  String get geocoding_nothingToLookFor => '没找到相关信息，插入一个地址。';

  @override
  String get geocoding_launchGeocoding => '启动地理编码';

  @override
  String get geocoding_searching => '查找中…';

  @override
  String get gps_smashIsActive => 'SMASH 已处于活动状态';

  @override
  String get gps_smashIsLogging => 'SMASH 正在记录日志';

  @override
  String get gps_locationTracking => '位置跟踪';

  @override
  String get gps_smashLocServiceIsActive => 'SMASH 位置服务已激活。';

  @override
  String get gps_backgroundLocIsOnToKeepRegistering => '后台位置服务一直开启，以保证APP能记录位置信息。';

  @override
  String get gssImport_gssImport => 'GSS导入';

  @override
  String get gssImport_downloadingDataList => '正在下载数据列表…';

  @override
  String get gssImport_unableDownloadDataList => '下载数据列表时出错，请检查你的设置和日志。';

  @override
  String get gssImport_noGssUrlSet => '未设置GSS服务器URL，请检查设置。';

  @override
  String get gssImport_noGssPasswordSet => '未设置GSS密码，请检查设置。';

  @override
  String get gssImport_noPermToAccessServer => '无权访问服务器，请检查你的认证信息。';

  @override
  String get gssImport_data => '数据';

  @override
  String get gssImport_dataSetsDownloadedMapsFolder => '数据集已下载到地图文件夹中。';

  @override
  String get gssImport_noDataAvailable => '无可用数据。';

  @override
  String get gssImport_projects => '工程';

  @override
  String get gssImport_projectsDownloadedProjectFolder => '工程数据已下载到 projects文件夹。';

  @override
  String get gssImport_noProjectsAvailable => '无可用工程。';

  @override
  String get gssImport_forms => '表单';

  @override
  String get gssImport_tagsDownloadedFormsFolder => 'tag文件已下载到 forms文件夹。';

  @override
  String get gssImport_noTagsAvailable => '无tag可用。';

  @override
  String get importWidget_import => '导入';

  @override
  String get importWidget_importFromGeopaparazzi => '从GSS服务器导入';

  @override
  String get layersView_layerList => '图层列表';

  @override
  String get layersView_loadRemoteDatabase => '载入远程数据库';

  @override
  String get layersView_loadOnlineSources => '加载在线数据源';

  @override
  String get layersView_loadLocalDatasets => '加载本地数据集';

  @override
  String get layersView_loading => '加载中…';

  @override
  String get layersView_zoomTo => '放大';

  @override
  String get layersView_properties => '属性';

  @override
  String get layersView_delete => '删除';

  @override
  String get layersView_projCouldNotBeRecognized => '无法识别的投影，单击手动输入epsg代码。';

  @override
  String get layersView_projNotSupported => '不支持的投影，单击解决。';

  @override
  String get layersView_onlyImageFilesWithWorldDef => '仅支持有world文件定义的影像文件。';

  @override
  String get layersView_onlyImageFileWithPrjDef => '仅支持有投影文件定义的影像数据。';

  @override
  String get layersView_selectTableToLoad => '选择要加载的表格。';

  @override
  String get layersView_fileFormatNotSUpported => '文件格式不支持。';

  @override
  String get onlineSourcesPage_onlineSourcesCatalog => '在线数据源分类';

  @override
  String get onlineSourcesPage_loadingTmsLayers => '正在载入TMS图层…';

  @override
  String get onlineSourcesPage_loadingWmsLayers => '正在加载WMS图层…';

  @override
  String get onlineSourcesPage_importFromFile => '从文件导入';

  @override
  String get onlineSourcesPage_theFile => '文件';

  @override
  String get onlineSourcesPage_doesntExist => '不存在';

  @override
  String get onlineSourcesPage_onlineSourcesImported => '在线数据源已导入。';

  @override
  String get onlineSourcesPage_exportToFile => '导出到文件';

  @override
  String get onlineSourcesPage_exportedTo => '导出到：';

  @override
  String get onlineSourcesPage_delete => '删除';

  @override
  String get onlineSourcesPage_addToLayers => '添加到图层';

  @override
  String get onlineSourcesPage_setNameTmsService => '设置TMS服务名称';

  @override
  String get onlineSourcesPage_enterName => '输入名称';

  @override
  String get onlineSourcesPage_pleaseEnterValidName => '请输入可用名称';

  @override
  String get onlineSourcesPage_insertUrlOfService => '插入服务URL。';

  @override
  String get onlineSourcesPage_placeXyzBetBrackets => '在小括弧中输入x,y,z.';

  @override
  String get onlineSourcesPage_pleaseEnterValidTmsUrl => '请输入可用的TMS URL';

  @override
  String get onlineSourcesPage_enterUrl => '输入URL';

  @override
  String get onlineSourcesPage_enterSubDomains => '输入子域名';

  @override
  String get onlineSourcesPage_addAttribution => '添加所有权信息。';

  @override
  String get onlineSourcesPage_enterAttribution => '输入所有者';

  @override
  String get onlineSourcesPage_setMinMaxZoom => '设置最大最小缩放级别。';

  @override
  String get onlineSourcesPage_minZoom => '最小缩放级别';

  @override
  String get onlineSourcesPage_maxZoom => '最大缩放级别';

  @override
  String get onlineSourcesPage_pleaseCheckYourData => '请检查你的数据';

  @override
  String get onlineSourcesPage_details => '详细信息';

  @override
  String get onlineSourcesPage_name => '名称： ';

  @override
  String get onlineSourcesPage_subDomains => '子域名： ';

  @override
  String get onlineSourcesPage_attribution => '所有权： ';

  @override
  String get onlineSourcesPage_cancel => '取消';

  @override
  String get onlineSourcesPage_ok => '确定';

  @override
  String get onlineSourcesPage_newTmsOnlineService => '新建TMS在线服务';

  @override
  String get onlineSourcesPage_save => '保存';

  @override
  String get onlineSourcesPage_theBaseUrlWithQuestionMark => '基本URL以?结尾。';

  @override
  String get onlineSourcesPage_pleaseEnterValidWmsUrl => '请输入可用WMS URL';

  @override
  String get onlineSourcesPage_setWmsLayerName => '设置WMS层名';

  @override
  String get onlineSourcesPage_enterLayerToLoad => '输入要加载图层';

  @override
  String get onlineSourcesPage_pleaseEnterValidLayer => '请输入可用图层';

  @override
  String get onlineSourcesPage_setWmsImageFormat => '设置WMS图片格式';

  @override
  String get onlineSourcesPage_addAnAttribution => '增加所有权信息。';

  @override
  String get onlineSourcesPage_layer => '图层： ';

  @override
  String get onlineSourcesPage_url => 'URL： ';

  @override
  String get onlineSourcesPage_format => '格式';

  @override
  String get onlineSourcesPage_newWmsOnlineService => '新建WMS在线服务';

  @override
  String get remoteDbPage_remoteDatabases => '远程数据库';

  @override
  String get remoteDbPage_delete => '删除';

  @override
  String get remoteDbPage_areYouSureDeleteDatabase => '删除数据库配置？';

  @override
  String get remoteDbPage_edit => '编辑';

  @override
  String get remoteDbPage_table => '表格';

  @override
  String get remoteDbPage_user => '用户';

  @override
  String get remoteDbPage_loadInMap => '载入到地图中。';

  @override
  String get remoteDbPage_databaseParameters => '数据库参数';

  @override
  String get remoteDbPage_cancel => '取消';

  @override
  String get remoteDbPage_ok => '确定';

  @override
  String get remoteDbPage_theUrlNeedsToBeDefined => '必须定义URL。格式如(postgis:host:port/databasename)';

  @override
  String get remoteDbPage_theUserNeedsToBeDefined => '必须定义用户。';

  @override
  String get remoteDbPage_password => '密码';

  @override
  String get remoteDbPage_thePasswordNeedsToBeDefined => '必须设置密码。';

  @override
  String get remoteDbPage_loadingTables => '正在加载表格…';

  @override
  String get remoteDbPage_theTableNeedsToBeDefined => '必须定义表格名称。';

  @override
  String get remoteDbPage_unableToConnectToDatabase => '无法连接数据库。请检查你的参数及网络。';

  @override
  String get remoteDbPage_optionalWhereCondition => '\"where\" 条件';

  @override
  String get geoImage_tiffProperties => 'TIFF属性';

  @override
  String get geoImage_opacity => '透明度';

  @override
  String get geoImage_colorToHide => '要隐藏的颜色';

  @override
  String get gpx_gpxProperties => 'GPX属性';

  @override
  String get gpx_wayPoints => '方向点';

  @override
  String get gpx_color => '颜色';

  @override
  String get gpx_size => '尺寸';

  @override
  String get gpx_viewLabelsIfAvailable => '如果可能则查看标签？';

  @override
  String get gpx_tracksRoutes => '航迹/航线';

  @override
  String get gpx_width => '宽';

  @override
  String get gpx_palette => '调色板';

  @override
  String get tiles_tileProperties => '瓦片属性';

  @override
  String get tiles_opacity => '透明度';

  @override
  String get tiles_loadGeoPackageAsOverlay => '将geopackage 瓦片当做普通图像进行加载，而不是作为瓦片图层（最好是由gdal生成的数据，并且有不同的投影）。';

  @override
  String get tiles_colorToHide => '要隐藏的颜色';

  @override
  String get wms_wmsProperties => 'WMS属性';

  @override
  String get wms_opacity => '透明度';

  @override
  String get featureAttributesViewer_loadingData => '正在加载数据…';

  @override
  String get featureAttributesViewer_setNewValue => '设置新值';

  @override
  String get featureAttributesViewer_field => '字段';

  @override
  String get featureAttributesViewer_value => '值';

  @override
  String get projectsView_projectsView => '工程视图';

  @override
  String get projectsView_openExistingProject => '打开已存在工程';

  @override
  String get projectsView_createNewProject => '创建新工程';

  @override
  String get projectsView_recentProjects => '最近工程';

  @override
  String get projectsView_newProject => '新建工程';

  @override
  String get projectsView_enterNameForNewProject => '输入新工程名称或者采取建议默认工程名。';

  @override
  String get dataLoader_note => '注意';

  @override
  String get dataLoader_Note => '注意事项';

  @override
  String get dataLoader_hasForm => '存在表单';

  @override
  String get dataLoader_POI => 'POI';

  @override
  String get dataLoader_savingImageToDB => '保存照片到数据库…';

  @override
  String get dataLoader_removeNote => '移除注记';

  @override
  String get dataLoader_areYouSureRemoveNote => '移除注记？';

  @override
  String get dataLoader_image => '照片';

  @override
  String get dataLoader_longitude => '经度';

  @override
  String get dataLoader_latitude => '纬度';

  @override
  String get dataLoader_altitude => '高程';

  @override
  String get dataLoader_timestamp => '时间戳';

  @override
  String get dataLoader_removeImage => '移除图片';

  @override
  String get dataLoader_areYouSureRemoveImage => '移除此图片？';

  @override
  String get images_loadingImage => '正在加载图片…';

  @override
  String get about_loadingInformation => '正在加载信息…';

  @override
  String get about_ABOUT => '关于： ';

  @override
  String get about_smartMobileAppForSurveyor => '让调绘者愉快的智能移动APP';

  @override
  String get about_applicationVersion => '版本';

  @override
  String get about_license => '授权文件';

  @override
  String get about_isAvailableUnderGPL3 => ' 基于 GPLv3+.';

  @override
  String get about_sourceCode => '源码';

  @override
  String get about_tapHereToVisitRepo => '单击此处查看源码';

  @override
  String get about_legalInformation => '法律信息';

  @override
  String get about_copyright2020HydroloGIS => '版权所有方：© 2020, HydroloGIS S.r.l。保留部分权利。单击查看。';

  @override
  String get about_supportedBy => '支持方';

  @override
  String get about_partiallySupportedByUniversityTrento => '特伦托大学 Steep Stream 项目部分支持。';

  @override
  String get about_privacyPolicy => '隐私政策';

  @override
  String get about_tapHereToSeePrivacyPolicy => '单击此处查看包含用户及位置数据的隐私政策。';

  @override
  String get gpsInfoButton_noGpsInfoAvailable => '无可用GPS信息…';

  @override
  String get gpsInfoButton_timestamp => '时间戳';

  @override
  String get gpsInfoButton_speed => '速度';

  @override
  String get gpsInfoButton_heading => '方向';

  @override
  String get gpsInfoButton_accuracy => '精度';

  @override
  String get gpsInfoButton_altitude => '海拔';

  @override
  String get gpsInfoButton_latitude => '纬度';

  @override
  String get gpsInfoButton_copyLatitudeToClipboard => '拷贝纬度到粘贴板。';

  @override
  String get gpsInfoButton_longitude => '经度';

  @override
  String get gpsInfoButton_copyLongitudeToClipboard => '拷贝经度到粘贴板。';

  @override
  String get gpsLogButton_stopLogging => '停止记录？';

  @override
  String get gpsLogButton_stopLoggingAndCloseLog => '停止记录并关闭当前GPS日志？';

  @override
  String get gpsLogButton_newLog => '新建日志';

  @override
  String get gpsLogButton_enterNameForNewLog => '输入新日志名称';

  @override
  String get gpsLogButton_couldNotStartLogging => '无法启动日志记录： ';

  @override
  String get imageWidgets_loadingImage => '正在加载图像…';

  @override
  String get logList_gpsLogsList => 'GPS日志列表';

  @override
  String get logList_selectAll => '全选';

  @override
  String get logList_unSelectAll => '全不选';

  @override
  String get logList_invertSelection => '反选';

  @override
  String get logList_mergeSelected => '合并选择';

  @override
  String get logList_loadingLogs => '正在加载日志…';

  @override
  String get logList_zoomTo => '缩放到';

  @override
  String get logList_properties => '属性';

  @override
  String get logList_profileView => '配置文件视图';

  @override
  String get logList_toGPX => '转为GPX';

  @override
  String get logList_gpsSavedInExportFolder => 'GPX已保存到export文件夹。';

  @override
  String get logList_errorOccurredExportingLogGPX => '无法导出日志到GPX。';

  @override
  String get logList_delete => '删除';

  @override
  String get logList_DELETE => '删除';

  @override
  String get logList_areYouSureDeleteTheLog => '删除日志？';

  @override
  String get logList_hours => '小时数';

  @override
  String get logList_hour => '小时';

  @override
  String get logList_minutes => '最小';

  @override
  String get logProperties_gpsLogProperties => 'GPS日志属性';

  @override
  String get logProperties_logName => '日志名称';

  @override
  String get logProperties_start => '开始';

  @override
  String get logProperties_end => '结束';

  @override
  String get logProperties_duration => '期间';

  @override
  String get logProperties_color => '颜色';

  @override
  String get logProperties_palette => '调色板';

  @override
  String get logProperties_width => '宽';

  @override
  String get logProperties_distanceAtPosition => '当前点距离：';

  @override
  String get logProperties_totalDistance => '总距离：';

  @override
  String get logProperties_gpsLogView => 'GPS日志视图';

  @override
  String get logProperties_disableStats => '关闭状态';

  @override
  String get logProperties_enableStats => '打开状态';

  @override
  String get logProperties_totalDuration => '全部时间：';

  @override
  String get logProperties_timestamp => '时间戳：';

  @override
  String get logProperties_durationAtPosition => '在当前位置时间：';

  @override
  String get logProperties_speed => '速度：';

  @override
  String get logProperties_elevation => '高程：';

  @override
  String get noteList_simpleNotesList => '简单标注列表';

  @override
  String get noteList_formNotesList => '表单标注列表';

  @override
  String get noteList_loadingNotes => '正在加载标注…';

  @override
  String get noteList_zoomTo => '缩放到';

  @override
  String get noteList_edit => '编辑';

  @override
  String get noteList_properties => '属性';

  @override
  String get noteList_delete => '删除';

  @override
  String get noteList_DELETE => '删除';

  @override
  String get noteList_areYouSureDeleteNote => '删除此标注？';

  @override
  String get settings_settings => '设置';

  @override
  String get settings_camera => '照相机';

  @override
  String get settings_cameraResolution => '照相机分辨率';

  @override
  String get settings_resolution => '分辨率';

  @override
  String get settings_theCameraResolution => '此相机分辨率';

  @override
  String get settings_screen => '屏幕';

  @override
  String get settings_screenScaleBarIconSize => '屏幕，比例尺以及图标尺寸';

  @override
  String get settings_keepScreenOn => '保持屏幕开启';

  @override
  String get settings_retinaScreenMode => 'HiDP屏幕模式';

  @override
  String get settings_toApplySettingEnterExitLayerView => '输入并退出图层视图以应用到设置。';

  @override
  String get settings_colorPickerToUse => '颜色拾取器';

  @override
  String get settings_mapCenterCross => '地图中心十字';

  @override
  String get settings_color => '颜色';

  @override
  String get settings_size => '尺寸';

  @override
  String get settings_width => '宽';

  @override
  String get settings_mapToolsIconSize => '地图工具图标尺寸';

  @override
  String get settings_gps => 'GPS';

  @override
  String get settings_gpsFiltersAndMockLoc => 'GPS过滤器和位置模拟';

  @override
  String get settings_livePreview => '现场预览';

  @override
  String get settings_noPointAvailableYet => '至今无可以点。';

  @override
  String get settings_longitudeDeg => '经度[deg]';

  @override
  String get settings_latitudeDeg => '纬度[deg]';

  @override
  String get settings_accuracyM => '精度 [米]';

  @override
  String get settings_altitudeM => '海拔 [m]';

  @override
  String get settings_headingDeg => '方向 [deg]';

  @override
  String get settings_speedMS => '速度[m/s]';

  @override
  String get settings_isLogging => '记录日志？';

  @override
  String get settings_mockLocations => '模拟位置？';

  @override
  String get settings_minDistFilterBlocks => '最小距离过滤块';

  @override
  String get settings_minDistFilterPasses => '最小距离过滤通过';

  @override
  String get settings_minTimeFilterBlocks => '最少时间过滤块';

  @override
  String get settings_minTimeFilterPasses => '最小时间过滤通过数';

  @override
  String get settings_hasBeenBlocked => '未通过数量';

  @override
  String get settings_distanceFromPrevM => '与前一个点距离[m]';

  @override
  String get settings_timeFromPrevS => '与前一时间点相差[s]';

  @override
  String get settings_locationInfo => '位置信息';

  @override
  String get settings_filters => '过滤器';

  @override
  String get settings_disableFilters => '关闭过滤器。';

  @override
  String get settings_enableFilters => '打开过滤器。';

  @override
  String get settings_zoomIn => '放大';

  @override
  String get settings_zoomOut => '缩小';

  @override
  String get settings_activatePointFlow => '激活点流。';

  @override
  String get settings_pausePointsFlow => '暂停点流。';

  @override
  String get settings_visualizePointCount => '可视化点数量';

  @override
  String get settings_showGpsPointsValidPoints => '显示可用GPS点数量。';

  @override
  String get settings_showGpsPointsAllPoints => '显示所有GPS点数量。';

  @override
  String get settings_logFilters => '日志过滤器';

  @override
  String get settings_minDistanceBetween2Points => '两点间最小距离。';

  @override
  String get settings_minTimespanBetween2Points => '两点间最小时间差。';

  @override
  String get settings_gpsFilter => 'GPS过滤器';

  @override
  String get settings_disable => '关闭';

  @override
  String get settings_enable => '打开';

  @override
  String get settings_theUseOfTheGps => '使用滤波GPS。';

  @override
  String get settings_warningThisWillAffectGpsPosition => '警告：这将会影响GPS位置，标记插入，日志统计和图表。';

  @override
  String get settings_MockLocations => '模拟位置';

  @override
  String get settings_testGpsLogDemoUse => '为演示用的测试GPS日志。';

  @override
  String get settings_setDurationGpsPointsInMilli => '设置GPS点间隔时间(毫秒数)。';

  @override
  String get settings_SETTING => '设置';

  @override
  String get settings_setMockedGpsDuration => '设置GPS模拟时间间隔';

  @override
  String get settings_theValueHasToBeInt => '此值必须是个完整数值。';

  @override
  String get settings_milliseconds => '毫秒数';

  @override
  String get settings_useGoogleToImproveLoc => '使用Google服务改进位置';

  @override
  String get settings_useOfGoogleServicesRestart => '使用Google服务（需要重启app）。';
}
