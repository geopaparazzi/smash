import 'l10n.dart';

/// The translations for Norwegian Bokmål (`nb`).
class SLNb extends SL {
  SLNb([String locale = 'nb']) : super(locale);

  @override
  String get main_welcome => 'Welcome to SMASH!';

  @override
  String get main_check_location_permission => 'Checking location permission…';

  @override
  String get main_location_permission_granted => 'Location permission granted.';

  @override
  String get main_checkingStoragePermission => 'Checking storage permission…';

  @override
  String get main_storagePermissionGranted => 'Storage permission granted.';

  @override
  String get main_loadingPreferences => 'Loading preferences…';

  @override
  String get main_preferencesLoaded => 'Preferences loaded.';

  @override
  String get main_loadingWorkspace => 'Loading workspace…';

  @override
  String get main_workspaceLoaded => 'Workspace loaded.';

  @override
  String get main_loadingTagsList => 'Loading tags list…';

  @override
  String get main_tagsListLoaded => 'Tags list loaded.';

  @override
  String get main_loadingKnownProjections => 'Loading known projections…';

  @override
  String get main_knownProjectionsLoaded => 'Known projections loaded.';

  @override
  String get main_loadingFences => 'Loading fences…';

  @override
  String get main_fencesLoaded => 'Fences loaded.';

  @override
  String get main_loadingLayersList => 'Loading layers list…';

  @override
  String get main_layersListLoaded => 'Layers list loaded.';

  @override
  String get main_locationBackgroundWarning => 'Grant location permission in the next step to allow GPS logging in the background. (Otherwise it only works in the foreground.)\nNo data is shared, and only saved locally on the device.';

  @override
  String get main_StorageIsInternalWarning => 'Please read carefully!\nOn Android 11 and above, the SMASH project folder must be placed in the\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\nfolder in your storage to be used.\nIf the app is uninstalled, the system removes it, so back up your data if you do.\n\nA better solution is in the works.';

  @override
  String get main_locationPermissionIsMandatoryToOpenSmash => 'Location permission is mandatory to open SMASH.';

  @override
  String get main_storagePermissionIsMandatoryToOpenSmash => 'Storage permission is mandatory to open SMASH.';

  @override
  String get main_anErrorOccurredTapToView => 'An error occurred. Tap to view.';

  @override
  String get mainView_loadingData => 'Loading data…';

  @override
  String get mainView_turnGpsOn => 'Turn GPS on';

  @override
  String get mainView_turnGpsOff => 'Turn GPS off';

  @override
  String get mainView_exit => 'Exit';

  @override
  String get mainView_areYouSureCloseTheProject => 'Close the project?';

  @override
  String get mainView_activeOperationsWillBeStopped => 'Active operations will be stopped.';

  @override
  String get mainView_showInteractiveCoachMarks => 'Show interactive coach marks.';

  @override
  String get mainView_openToolsDrawer => 'Open tools drawer.';

  @override
  String get mainView_zoomIn => 'Zoom in';

  @override
  String get mainView_zoomOut => 'Zoom out';

  @override
  String get mainView_formNotes => 'Form Notes';

  @override
  String get mainView_simpleNotes => 'Simple Notes';

  @override
  String get mainviewUtils_projects => 'Projects';

  @override
  String get mainviewUtils_import => 'Import';

  @override
  String get mainviewUtils_export => 'Export';

  @override
  String get mainviewUtils_settings => 'Settings';

  @override
  String get mainviewUtils_onlineHelp => 'Online Help';

  @override
  String get mainviewUtils_about => 'About';

  @override
  String get mainviewUtils_projectInfo => 'Project Info';

  @override
  String get mainviewUtils_project => 'Project';

  @override
  String get mainviewUtils_database => 'Database';

  @override
  String get mainviewUtils_extras => 'Extras';

  @override
  String get mainviewUtils_availableIcons => 'Available icons';

  @override
  String get mainviewUtils_offlineMaps => 'Offline maps';

  @override
  String get mainviewUtils_positionTools => 'Position Tools';

  @override
  String get mainviewUtils_goTo => 'Go to';

  @override
  String get mainviewUtils_goToCoordinate => 'Go to coordinate';

  @override
  String get mainviewUtils_enterLonLat => 'Enter longitude, latitude';

  @override
  String get mainviewUtils_goToCoordinateWrongFormat => 'Wrong coordinate format. Should be: 11.18463, 46.12345';

  @override
  String get mainviewUtils_goToCoordinateEmpty => 'This can\'t be empty.';

  @override
  String get mainviewUtils_sharePosition => 'Share position';

  @override
  String get mainviewUtils_rotateMapWithGps => 'Rotate map with GPS';

  @override
  String get exportWidget_export => 'Export';

  @override
  String get exportWidget_pdfExported => 'PDF exported';

  @override
  String get exportWidget_exportToPortableDocumentFormat => 'Export project to Portable Document Format';

  @override
  String get exportWidget_gpxExported => 'GPX exported';

  @override
  String get exportWidget_exportToGpx => 'Export project to GPX';

  @override
  String get exportWidget_kmlExported => 'KML exported';

  @override
  String get exportWidget_exportToKml => 'Export project to KML';

  @override
  String get exportWidget_imagesToFolderExported => 'Images exported';

  @override
  String get exportWidget_exportImagesToFolder => 'Export project images to folder';

  @override
  String get exportWidget_exportImagesToFolderTitle => 'Images';

  @override
  String get exportWidget_geopackageExported => 'Geopackage exported';

  @override
  String get exportWidget_exportToGeopackage => 'Export project to Geopackage';

  @override
  String get exportWidget_exportToGSS => 'Export to Geopaparazzi Survey Server';

  @override
  String get gssExport_gssExport => 'GSS Export';

  @override
  String get gssExport_setProjectDirty => 'Set project to DIRTY?';

  @override
  String get gssExport_thisCantBeUndone => 'This can\'t be undone!';

  @override
  String get gssExport_restoreProjectAsDirty => 'Restore project as all dirty.';

  @override
  String get gssExport_setProjectClean => 'Set project to CLEAN?';

  @override
  String get gssExport_restoreProjectAsClean => 'Restore project as all clean.';

  @override
  String get gssExport_nothingToSync => 'Nothing to sync.';

  @override
  String get gssExport_collectingSyncStats => 'Collecting sync stats…';

  @override
  String get gssExport_unableToSyncDueToError => 'Unable to sync due to an error, check diagnostics.';

  @override
  String get gssExport_noGssUrlSet => 'No GSS server URL has been set. Check your settings.';

  @override
  String get gssExport_noGssPasswordSet => 'No GSS server password has been set. Check your settings.';

  @override
  String get gssExport_synStats => 'Sync Stats';

  @override
  String get gssExport_followingDataWillBeUploaded => 'The following data will be uploaded upon sync.';

  @override
  String get gssExport_gpsLogs => 'GPS Logs:';

  @override
  String get gssExport_simpleNotes => 'Simple Notes:';

  @override
  String get gssExport_formNotes => 'Form Notes:';

  @override
  String get gssExport_images => 'Images:';

  @override
  String get gssExport_shouldNotHappen => 'Should not happen';

  @override
  String get gssExport_upload => 'Upload';

  @override
  String get geocoding_geocoding => 'Geocoding';

  @override
  String get geocoding_nothingToLookFor => 'Nothing to look for. Insert an address.';

  @override
  String get geocoding_launchGeocoding => 'Launch Geocoding';

  @override
  String get geocoding_searching => 'Searching…';

  @override
  String get gps_smashIsActive => 'SMASH is active';

  @override
  String get gps_smashIsLogging => 'SMASH is logging';

  @override
  String get gps_locationTracking => 'Location tracking';

  @override
  String get gps_smashLocServiceIsActive => 'SMASH location service is active.';

  @override
  String get gps_backgroundLocIsOnToKeepRegistering => 'Background location is on to keep the app registering the location even when the app is in background.';

  @override
  String get gssImport_gssImport => 'GSS Import';

  @override
  String get gssImport_downloadingDataList => 'Downloading data list…';

  @override
  String get gssImport_unableDownloadDataList => 'Unable to download data list due to an error. Check your settings and the log.';

  @override
  String get gssImport_noGssUrlSet => 'No GSS server URL has been set. Check your settings.';

  @override
  String get gssImport_noGssPasswordSet => 'No GSS server password has been set. Check your settings.';

  @override
  String get gssImport_noPermToAccessServer => 'No permission to access the server. Check your credentials.';

  @override
  String get gssImport_data => 'Data';

  @override
  String get gssImport_dataSetsDownloadedMapsFolder => 'Datasets are downloaded into the maps folder.';

  @override
  String get gssImport_noDataAvailable => 'No data available.';

  @override
  String get gssImport_projects => 'Projects';

  @override
  String get gssImport_projectsDownloadedProjectFolder => 'Projects are downloaded into the projects folder.';

  @override
  String get gssImport_noProjectsAvailable => 'No projects available.';

  @override
  String get gssImport_forms => 'Forms';

  @override
  String get gssImport_tagsDownloadedFormsFolder => 'Tags files are downloaded into the forms folder.';

  @override
  String get gssImport_noTagsAvailable => 'No tags available.';

  @override
  String get importWidget_import => 'Import';

  @override
  String get importWidget_importFromGeopaparazzi => 'Import from Geopaparazzi Survey Server';

  @override
  String get layersView_layerList => 'Layer List';

  @override
  String get layersView_loadRemoteDatabase => 'Load remote database';

  @override
  String get layersView_loadOnlineSources => 'Load online sources';

  @override
  String get layersView_loadLocalDatasets => 'Load local datasets';

  @override
  String get layersView_loading => 'Loading…';

  @override
  String get layersView_zoomTo => 'Zoom to';

  @override
  String get layersView_properties => 'Properties';

  @override
  String get layersView_delete => 'Delete';

  @override
  String get layersView_projCouldNotBeRecognized => 'The proj could not be recognised. Tap to enter epsg manually.';

  @override
  String get layersView_projNotSupported => 'The proj is not supported. Tap to solve.';

  @override
  String get layersView_onlyImageFilesWithWorldDef => 'Only image files with world file definition are supported.';

  @override
  String get layersView_onlyImageFileWithPrjDef => 'Only image files with prj file definition are supported.';

  @override
  String get layersView_selectTableToLoad => 'Select table to load.';

  @override
  String get layersView_fileFormatNotSUpported => 'File format not supported.';

  @override
  String get onlineSourcesPage_onlineSourcesCatalog => 'Online Sources Catalog';

  @override
  String get onlineSourcesPage_loadingTmsLayers => 'Loading TMS layers…';

  @override
  String get onlineSourcesPage_loadingWmsLayers => 'Loading WMS layers…';

  @override
  String get onlineSourcesPage_importFromFile => 'Import from file';

  @override
  String get onlineSourcesPage_theFile => 'The file';

  @override
  String get onlineSourcesPage_doesntExist => 'doesn\'t exist';

  @override
  String get onlineSourcesPage_onlineSourcesImported => 'Online sources imported.';

  @override
  String get onlineSourcesPage_exportToFile => 'Export to file';

  @override
  String get onlineSourcesPage_exportedTo => 'Exported to:';

  @override
  String get onlineSourcesPage_delete => 'Delete';

  @override
  String get onlineSourcesPage_addToLayers => 'Add to layers';

  @override
  String get onlineSourcesPage_setNameTmsService => 'Set a name for the TMS service';

  @override
  String get onlineSourcesPage_enterName => 'enter name';

  @override
  String get onlineSourcesPage_pleaseEnterValidName => 'Please enter a valid name';

  @override
  String get onlineSourcesPage_insertUrlOfService => 'Insert the URL of the service.';

  @override
  String get onlineSourcesPage_placeXyzBetBrackets => 'Place the x, y, z between curly brackets.';

  @override
  String get onlineSourcesPage_pleaseEnterValidTmsUrl => 'Please enter a valid TMS URL';

  @override
  String get onlineSourcesPage_enterUrl => 'enter URL';

  @override
  String get onlineSourcesPage_enterSubDomains => 'enter subdomains';

  @override
  String get onlineSourcesPage_addAttribution => 'Add an attribution.';

  @override
  String get onlineSourcesPage_enterAttribution => 'enter attribution';

  @override
  String get onlineSourcesPage_setMinMaxZoom => 'Set min and max zoom.';

  @override
  String get onlineSourcesPage_minZoom => 'Min zoom';

  @override
  String get onlineSourcesPage_maxZoom => 'Max zoom';

  @override
  String get onlineSourcesPage_pleaseCheckYourData => 'Please check your data';

  @override
  String get onlineSourcesPage_details => 'Details';

  @override
  String get onlineSourcesPage_name => 'Name: ';

  @override
  String get onlineSourcesPage_subDomains => 'Subdomains: ';

  @override
  String get onlineSourcesPage_attribution => 'Attribution: ';

  @override
  String get onlineSourcesPage_cancel => 'Cancel';

  @override
  String get onlineSourcesPage_ok => 'OK';

  @override
  String get onlineSourcesPage_newTmsOnlineService => 'New TMS Online Service';

  @override
  String get onlineSourcesPage_save => 'Save';

  @override
  String get onlineSourcesPage_theBaseUrlWithQuestionMark => 'The base URL-ending with question mark.';

  @override
  String get onlineSourcesPage_pleaseEnterValidWmsUrl => 'Please enter a valid WMS URL';

  @override
  String get onlineSourcesPage_setWmsLayerName => 'Set WMS layer name';

  @override
  String get onlineSourcesPage_enterLayerToLoad => 'enter layer to load';

  @override
  String get onlineSourcesPage_pleaseEnterValidLayer => 'Please enter a valid layer';

  @override
  String get onlineSourcesPage_setWmsImageFormat => 'Set WMS image format';

  @override
  String get onlineSourcesPage_addAnAttribution => 'Add an attribution.';

  @override
  String get onlineSourcesPage_layer => 'Layer: ';

  @override
  String get onlineSourcesPage_url => 'URL: ';

  @override
  String get onlineSourcesPage_format => 'Format';

  @override
  String get onlineSourcesPage_newWmsOnlineService => 'New WMS Online Service';

  @override
  String get remoteDbPage_remoteDatabases => 'Remote Databases';

  @override
  String get remoteDbPage_delete => 'Delete';

  @override
  String get remoteDbPage_areYouSureDeleteDatabase => 'Delete the database configuration?';

  @override
  String get remoteDbPage_edit => 'Edit';

  @override
  String get remoteDbPage_table => 'table';

  @override
  String get remoteDbPage_user => 'user';

  @override
  String get remoteDbPage_loadInMap => 'Load in map.';

  @override
  String get remoteDbPage_databaseParameters => 'Database Parameters';

  @override
  String get remoteDbPage_cancel => 'Cancel';

  @override
  String get remoteDbPage_ok => 'OK';

  @override
  String get remoteDbPage_theUrlNeedsToBeDefined => 'The URL must be defined (postgis:host:port/databasename)';

  @override
  String get remoteDbPage_theUserNeedsToBeDefined => 'A user must be defined.';

  @override
  String get remoteDbPage_password => 'password';

  @override
  String get remoteDbPage_thePasswordNeedsToBeDefined => 'A password must be defined.';

  @override
  String get remoteDbPage_loadingTables => 'Loading tables…';

  @override
  String get remoteDbPage_theTableNeedsToBeDefined => 'The table name must be defined.';

  @override
  String get remoteDbPage_unableToConnectToDatabase => 'Unable to connect to the database. Check parameters and network.';

  @override
  String get remoteDbPage_optionalWhereCondition => 'optional \"where\" condition';

  @override
  String get geoImage_tiffProperties => 'TIFF Properties';

  @override
  String get geoImage_opacity => 'Opacity';

  @override
  String get geoImage_colorToHide => 'Color to hide';

  @override
  String get gpx_gpxProperties => 'GPX Properties';

  @override
  String get gpx_wayPoints => 'Waypoints';

  @override
  String get gpx_color => 'Color';

  @override
  String get gpx_size => 'Size';

  @override
  String get gpx_viewLabelsIfAvailable => 'View labels if available?';

  @override
  String get gpx_tracksRoutes => 'Tracks/routes';

  @override
  String get gpx_width => 'Width';

  @override
  String get gpx_palette => 'Palette';

  @override
  String get tiles_tileProperties => 'Tile Properties';

  @override
  String get tiles_opacity => 'Opacity';

  @override
  String get tiles_loadGeoPackageAsOverlay => 'Load geopackage tiles as overlay image as opposed to tile layer (best for gdal generated data and different projections).';

  @override
  String get tiles_colorToHide => 'Color to hide';

  @override
  String get wms_wmsProperties => 'WMS Properties';

  @override
  String get wms_opacity => 'Opacity';

  @override
  String get featureAttributesViewer_loadingData => 'Loading data…';

  @override
  String get featureAttributesViewer_setNewValue => 'Set new value';

  @override
  String get featureAttributesViewer_field => 'Field';

  @override
  String get featureAttributesViewer_value => 'VALUE';

  @override
  String get projectsView_projectsView => 'Projects View';

  @override
  String get projectsView_openExistingProject => 'Open an existing project';

  @override
  String get projectsView_createNewProject => 'Create a new project';

  @override
  String get projectsView_recentProjects => 'Recent projects';

  @override
  String get projectsView_newProject => 'New Project';

  @override
  String get projectsView_enterNameForNewProject => 'Enter a name for the new project or accept the proposed.';

  @override
  String get dataLoader_note => 'note';

  @override
  String get dataLoader_Note => 'Note';

  @override
  String get dataLoader_hasForm => 'Has Form';

  @override
  String get dataLoader_POI => 'POI';

  @override
  String get dataLoader_savingImageToDB => 'Saving image to database…';

  @override
  String get dataLoader_removeNote => 'Remove Note';

  @override
  String get dataLoader_areYouSureRemoveNote => 'Remove note?';

  @override
  String get dataLoader_image => 'Image';

  @override
  String get dataLoader_longitude => 'Longitude';

  @override
  String get dataLoader_latitude => 'Latitude';

  @override
  String get dataLoader_altitude => 'Altitude';

  @override
  String get dataLoader_timestamp => 'Timestamp';

  @override
  String get dataLoader_removeImage => 'Remove Image';

  @override
  String get dataLoader_areYouSureRemoveImage => 'Remove the image?';

  @override
  String get images_loadingImage => 'Loading image…';

  @override
  String get about_loadingInformation => 'Loading info…';

  @override
  String get about_ABOUT => 'About ';

  @override
  String get about_smartMobileAppForSurveyor => 'Smart Mobile App for Surveyor Happiness';

  @override
  String get about_applicationVersion => 'Version';

  @override
  String get about_license => 'License';

  @override
  String get about_isAvailableUnderGPL3 => ' is copylefted libre software, licensed GPLv3+.';

  @override
  String get about_sourceCode => 'Source Code';

  @override
  String get about_tapHereToVisitRepo => 'Tap here to visit the source code repository';

  @override
  String get about_legalInformation => 'Legal Info';

  @override
  String get about_copyright2020HydroloGIS => 'Copyright © 2020, HydroloGIS S.r.l. — some rights reserved. Tap to visit.';

  @override
  String get about_supportedBy => 'Supported by';

  @override
  String get about_partiallySupportedByUniversityTrento => 'Partially supported by the project Steep Stream of the University of Trento.';

  @override
  String get about_privacyPolicy => 'Privacy Policy';

  @override
  String get about_tapHereToSeePrivacyPolicy => 'Tap here to see the privacy policy that covers user and location data.';

  @override
  String get gpsInfoButton_noGpsInfoAvailable => 'No GPS info available…';

  @override
  String get gpsInfoButton_timestamp => 'Timestamp';

  @override
  String get gpsInfoButton_speed => 'Speed';

  @override
  String get gpsInfoButton_heading => 'Heading';

  @override
  String get gpsInfoButton_accuracy => 'Accuracy';

  @override
  String get gpsInfoButton_altitude => 'Altitude';

  @override
  String get gpsInfoButton_latitude => 'Latitude';

  @override
  String get gpsInfoButton_copyLatitudeToClipboard => 'Copy latitude to clipboard.';

  @override
  String get gpsInfoButton_longitude => 'Longitude';

  @override
  String get gpsInfoButton_copyLongitudeToClipboard => 'Copy longitude to clipboard.';

  @override
  String get gpsLogButton_stopLogging => 'Stop Logging?';

  @override
  String get gpsLogButton_stopLoggingAndCloseLog => 'Stop logging and close the current GPS log?';

  @override
  String get gpsLogButton_newLog => 'New Log';

  @override
  String get gpsLogButton_enterNameForNewLog => 'Enter a name for the new log';

  @override
  String get gpsLogButton_couldNotStartLogging => 'Could not start logging: ';

  @override
  String get imageWidgets_loadingImage => 'Loading image…';

  @override
  String get logList_gpsLogsList => 'GPS Logs list';

  @override
  String get logList_selectAll => 'Select all';

  @override
  String get logList_unSelectAll => 'Unselect all';

  @override
  String get logList_invertSelection => 'Invert selection';

  @override
  String get logList_mergeSelected => 'Merge selected';

  @override
  String get logList_loadingLogs => 'Loading logs…';

  @override
  String get logList_zoomTo => 'Zoom to';

  @override
  String get logList_properties => 'Properties';

  @override
  String get logList_profileView => 'Profile View';

  @override
  String get logList_toGPX => 'To GPX';

  @override
  String get logList_gpsSavedInExportFolder => 'GPX saved in export folder.';

  @override
  String get logList_errorOccurredExportingLogGPX => 'Could not export log to GPX.';

  @override
  String get logList_delete => 'Delete';

  @override
  String get logList_DELETE => 'Delete';

  @override
  String get logList_areYouSureDeleteTheLog => 'Delete the log?';

  @override
  String get logList_hours => 'hours';

  @override
  String get logList_hour => 'hour';

  @override
  String get logList_minutes => 'min';

  @override
  String get logProperties_gpsLogProperties => 'GPS Log Properties';

  @override
  String get logProperties_logName => 'Log Name';

  @override
  String get logProperties_start => 'Start';

  @override
  String get logProperties_end => 'End';

  @override
  String get logProperties_duration => 'Duration';

  @override
  String get logProperties_color => 'Color';

  @override
  String get logProperties_palette => 'Palette';

  @override
  String get logProperties_width => 'Width';

  @override
  String get logProperties_distanceAtPosition => 'Distance at position:';

  @override
  String get logProperties_totalDistance => 'Total distance:';

  @override
  String get logProperties_gpsLogView => 'GPS Log View';

  @override
  String get logProperties_disableStats => 'Turn off stats';

  @override
  String get logProperties_enableStats => 'Turn on stats';

  @override
  String get logProperties_totalDuration => 'Total duration:';

  @override
  String get logProperties_timestamp => 'Timestamp:';

  @override
  String get logProperties_durationAtPosition => 'Duration at position:';

  @override
  String get logProperties_speed => 'Speed:';

  @override
  String get logProperties_elevation => 'Elevation:';

  @override
  String get noteList_simpleNotesList => 'Simple List of Notes';

  @override
  String get noteList_formNotesList => 'List of Form Notes';

  @override
  String get noteList_loadingNotes => 'Loading notes…';

  @override
  String get noteList_zoomTo => 'Zoom to';

  @override
  String get noteList_edit => 'Edit';

  @override
  String get noteList_properties => 'Properties';

  @override
  String get noteList_delete => 'Delete';

  @override
  String get noteList_DELETE => 'Delete';

  @override
  String get noteList_areYouSureDeleteNote => 'Delete the note?';

  @override
  String get settings_settings => 'Settings';

  @override
  String get settings_camera => 'Camera';

  @override
  String get settings_cameraResolution => 'Camera Resolution';

  @override
  String get settings_resolution => 'Resolution';

  @override
  String get settings_theCameraResolution => 'The camera resolution';

  @override
  String get settings_screen => 'Screen';

  @override
  String get settings_screenScaleBarIconSize => 'Screen, Scalebar and Icon Size';

  @override
  String get settings_keepScreenOn => 'Keep Screen On';

  @override
  String get settings_retinaScreenMode => 'HiDPI screen-mode';

  @override
  String get settings_toApplySettingEnterExitLayerView => 'Enter and exit the layer view to apply this setting.';

  @override
  String get settings_colorPickerToUse => 'Color Picker to use';

  @override
  String get settings_mapCenterCross => 'Map Center Cross';

  @override
  String get settings_color => 'Color';

  @override
  String get settings_size => 'Size';

  @override
  String get settings_width => 'Width';

  @override
  String get settings_mapToolsIconSize => 'Icon Size for Map Tools';

  @override
  String get settings_gps => 'GPS';

  @override
  String get settings_gpsFiltersAndMockLoc => 'GPS filters and mock locations';

  @override
  String get settings_livePreview => 'Live Preview';

  @override
  String get settings_noPointAvailableYet => 'No point available yet.';

  @override
  String get settings_longitudeDeg => 'longitude [deg]';

  @override
  String get settings_latitudeDeg => 'latitude [deg]';

  @override
  String get settings_accuracyM => 'accuracy [m]';

  @override
  String get settings_altitudeM => 'altitude [m]';

  @override
  String get settings_headingDeg => 'heading [deg]';

  @override
  String get settings_speedMS => 'speed [m/s]';

  @override
  String get settings_isLogging => 'is logging?';

  @override
  String get settings_mockLocations => 'mock locations?';

  @override
  String get settings_minDistFilterBlocks => 'Min dist filter blocks';

  @override
  String get settings_minDistFilterPasses => 'Min dist filter passes';

  @override
  String get settings_minTimeFilterBlocks => 'Min time filter blocks';

  @override
  String get settings_minTimeFilterPasses => 'Min time filter passes';

  @override
  String get settings_hasBeenBlocked => 'Has been blocked';

  @override
  String get settings_distanceFromPrevM => 'Distance from prev [m]';

  @override
  String get settings_timeFromPrevS => 'Time since prev [s]';

  @override
  String get settings_locationInfo => 'Location Info';

  @override
  String get settings_filters => 'Filters';

  @override
  String get settings_disableFilters => 'Turn off Filters.';

  @override
  String get settings_enableFilters => 'Turn on Filters.';

  @override
  String get settings_zoomIn => 'Zoom in';

  @override
  String get settings_zoomOut => 'Zoom out';

  @override
  String get settings_activatePointFlow => 'Activate point flow.';

  @override
  String get settings_pausePointsFlow => 'Pause points flow.';

  @override
  String get settings_visualizePointCount => 'Visualize point count';

  @override
  String get settings_showGpsPointsValidPoints => 'Show the GPS points count for VALID points.';

  @override
  String get settings_showGpsPointsAllPoints => 'Show the GPS points count for ALL points.';

  @override
  String get settings_logFilters => 'Log filters';

  @override
  String get settings_minDistanceBetween2Points => 'Min distance between 2 points.';

  @override
  String get settings_minTimespanBetween2Points => 'Min timespan between 2 points.';

  @override
  String get settings_gpsFilter => 'GPS Filter';

  @override
  String get settings_disable => 'Turn off';

  @override
  String get settings_enable => 'Turn on';

  @override
  String get settings_theUseOfTheGps => 'the use of filtered GPS.';

  @override
  String get settings_warningThisWillAffectGpsPosition => 'Warning: This will affect GPS position, notes insertion, log statistics and charting.';

  @override
  String get settings_MockLocations => 'Mock locations';

  @override
  String get settings_testGpsLogDemoUse => 'test GPS log for demo use.';

  @override
  String get settings_setDurationGpsPointsInMilli => 'Set duration for GPS points in milliseconds.';

  @override
  String get settings_SETTING => 'Setting';

  @override
  String get settings_setMockedGpsDuration => 'Set Mocked GPS duration';

  @override
  String get settings_theValueHasToBeInt => 'The value has to be a whole number.';

  @override
  String get settings_milliseconds => 'milliseconds';

  @override
  String get settings_useGoogleToImproveLoc => 'Use Google Services to improve location';

  @override
  String get settings_useOfGoogleServicesRestart => 'use of Google services (app restart needed).';

  @override
  String get settings_gpsLogsViewMode => 'GPS Logs view mode';

  @override
  String get settings_logViewModeForOrigData => 'Log view mode for original data.';

  @override
  String get settings_logViewModeFilteredData => 'Log view mode for filtered data.';

  @override
  String get settings_cancel => 'Cancel';

  @override
  String get settings_ok => 'OK';

  @override
  String get settings_notesViewModes => 'Notes view modes';

  @override
  String get settings_selectNotesViewMode => 'Select a mode to view notes in.';

  @override
  String get settings_mapPlugins => 'Map Plugins';

  @override
  String get settings_vectorLayers => 'Vector Layers';

  @override
  String get settings_loadingOptionsInfoTool => 'Loading Options and Info Tool';

  @override
  String get settings_dataLoading => 'Data loading';

  @override
  String get settings_maxNumberFeatures => 'Max number of features.';

  @override
  String get settings_maxNumFeaturesPerLayer => 'Max features per layer. Remove and add the layer to apply.';

  @override
  String get settings_all => 'all';

  @override
  String get settings_loadMapArea => 'Load map area.';

  @override
  String get settings_loadOnlyLastVisibleArea => 'Load only on the last visible map area. Remove and add the layer again to apply.';

  @override
  String get settings_infoTool => 'Info Tool';

  @override
  String get settings_tapSizeInfoToolPixels => 'Tap size of the info tool in pixels.';

  @override
  String get settings_editingTool => 'Editing tool';

  @override
  String get settings_editingDragIconSize => 'Editing drag handler icon size.';

  @override
  String get settings_editingIntermediateDragIconSize => 'Editing intermediate drag handler icon size.';

  @override
  String get settings_diagnostics => 'Diagnostics';

  @override
  String get settings_diagnosticsDebugLog => 'Diagnostics and Debug Log';

  @override
  String get settings_openFullDebugLog => 'Open full debug log';

  @override
  String get settings_debugLogView => 'Debug Log View';

  @override
  String get settings_viewAllMessages => 'View all messages';

  @override
  String get settings_viewOnlyErrorsWarnings => 'View only errors and warnings';

  @override
  String get settings_clearDebugLog => 'Clear debug log';

  @override
  String get settings_loadingData => 'Loading data…';

  @override
  String get settings_device => 'Device';

  @override
  String get settings_deviceIdentifier => 'Device identifier';

  @override
  String get settings_deviceId => 'Device ID';

  @override
  String get settings_overrideDeviceId => 'Override Device ID';

  @override
  String get settings_overrideId => 'Override ID';

  @override
  String get settings_pleaseEnterValidPassword => 'Please enter a valid server password.';

  @override
  String get settings_gss => 'GSS';

  @override
  String get settings_geopaparazziSurveyServer => 'Geopaparazzi Survey Server';

  @override
  String get settings_serverUrl => 'Server URL';

  @override
  String get settings_serverUrlStartWithHttp => 'The server URL needs to start with HTTP or HTTPS.';

  @override
  String get settings_serverPassword => 'Server Password';

  @override
  String get settings_allowSelfSignedCert => 'Allow self signed certificates';

  @override
  String get toolbarTools_zoomOut => 'Zoom out';

  @override
  String get toolbarTools_zoomIn => 'Zoom in';

  @override
  String get toolbarTools_cancelCurrentEdit => 'Cancel current edit.';

  @override
  String get toolbarTools_saveCurrentEdit => 'Save current edit.';

  @override
  String get toolbarTools_insertPointMapCenter => 'Insert point in map center.';

  @override
  String get toolbarTools_insertPointGpsPos => 'Insert point in GPS position.';

  @override
  String get toolbarTools_removeSelectedFeature => 'Remove selected feature.';

  @override
  String get toolbarTools_showFeatureAttributes => 'Show feature attributes.';

  @override
  String get toolbarTools_featureDoesNotHavePrimaryKey => 'The feature does not have a primary key. Editing is not allowed.';

  @override
  String get toolbarTools_queryFeaturesVectorLayers => 'Query features from loaded vector layers.';

  @override
  String get toolbarTools_measureDistanceWithFinger => 'Measure distances on the map with your finger.';

  @override
  String get toolbarTools_toggleFenceMapCenter => 'Toggle fence in map center.';

  @override
  String get toolbarTools_modifyGeomVectorLayers => 'Modify the geometry of editable vector layers.';

  @override
  String get coachMarks_singleTap => 'Single tap: ';

  @override
  String get coachMarks_longTap => 'Long tap: ';

  @override
  String get coachMarks_doubleTap => 'Double tap: ';

  @override
  String get coachMarks_simpleNoteButton => 'Simple Notes Button';

  @override
  String get coachMarks_addNewNote => 'add a new note';

  @override
  String get coachMarks_viewNotesList => 'view list of notes';

  @override
  String get coachMarks_viewNotesSettings => 'view settings for notes';

  @override
  String get coachMarks_formNotesButton => 'Form Notes Button';

  @override
  String get coachMarks_addNewFormNote => 'add new form note';

  @override
  String get coachMarks_viewFormNoteList => 'view list of form notes';

  @override
  String get coachMarks_gpsLogButton => 'GPS Log Button';

  @override
  String get coachMarks_startStopLogging => 'start logging/stop logging';

  @override
  String get coachMarks_viewLogsList => 'view list of logs';

  @override
  String get coachMarks_viewLogsSettings => 'view log settings';

  @override
  String get coachMarks_gpsInfoButton => 'GPS Info Button (if applicable)';

  @override
  String get coachMarks_centerMapOnGpsPos => 'center map on GPS position';

  @override
  String get coachMarks_showGpsInfo => 'show GPS info';

  @override
  String get coachMarks_toggleAutoCenterGps => 'toggle automatic center on GPS';

  @override
  String get coachMarks_layersViewButton => 'Layer View Button';

  @override
  String get coachMarks_openLayersView => 'Open the layers view';

  @override
  String get coachMarks_openLayersPluginDialog => 'Open the layer plugins dialog';

  @override
  String get coachMarks_zoomInButton => 'Zoom-in Button';

  @override
  String get coachMarks_zoomImMapOneLevel => 'Zoom in the map by one level';

  @override
  String get coachMarks_zoomOutButton => 'Zoom-out Button';

  @override
  String get coachMarks_zoomOutMapOneLevel => 'Zoom out the map by one level';

  @override
  String get coachMarks_bottomToolsButton => 'Bottom Tools Button';

  @override
  String get coachMarks_toggleBottomToolsBar => 'Toggle bottom tools bar. ';

  @override
  String get coachMarks_toolsButton => 'Tools Button';

  @override
  String get coachMarks_openEndDrawerToAccessProject => 'Open the end drawer to access project info and sharing options as well as map plugins, feature tools and extras.';

  @override
  String get coachMarks_interactiveCoackMarksButton => 'Interactive coach-marks button';

  @override
  String get coachMarks_openInteractiveCoachMarks => 'Open the interactice coach marks explaining all the actions of the main map view.';

  @override
  String get coachMarks_mainMenuButton => 'Main-menu Button';

  @override
  String get coachMarks_openDrawerToLoadProject => 'Open the drawer to load or create a project, import and export data, sync with servers, access settings and exit the app/turn off the GPS.';

  @override
  String get coachMarks_skip => 'Skip';

  @override
  String get fence_fenceProperties => 'Fence Properties';

  @override
  String get fence_delete => 'Delete';

  @override
  String get fence_removeFence => 'Remove fence';

  @override
  String get fence_areYouSureRemoveFence => 'Remove the fence?';

  @override
  String get fence_cancel => 'Cancel';

  @override
  String get fence_ok => 'OK';

  @override
  String get fence_aNewFence => 'a new fence';

  @override
  String get fence_label => 'Label';

  @override
  String get fence_aNameForFence => 'A name for the fence.';

  @override
  String get fence_theNameNeedsToBeDefined => 'The name must be defined.';

  @override
  String get fence_radius => 'Radius';

  @override
  String get fence_theFenceRadiusMeters => 'The fence radius in meters.';

  @override
  String get fence_radiusNeedsToBePositive => 'The radius must be a positive number in meters.';

  @override
  String get fence_onEnter => 'On enter';

  @override
  String get fence_onExit => 'On exit';

  @override
  String get network_cancelledByUser => 'Cancelled by user.';

  @override
  String get network_completed => 'Completed.';

  @override
  String get network_buildingBaseCachePerformance => 'Building base cache for improved performance (might take a while)…';

  @override
  String get network_thisFIleAlreadyBeingDownloaded => 'This file is already being downloaded.';

  @override
  String get network_download => 'Download';

  @override
  String get network_downloadFile => 'Download file';

  @override
  String get network_toTheDeviceTakeTime => 'to the device? This can take a while.';

  @override
  String get network_availableMaps => 'Available maps';

  @override
  String get network_searchMapByName => 'Search map by name';

  @override
  String get network_uploading => 'Uploading';

  @override
  String get network_pleaseWait => 'please wait…';

  @override
  String get network_permissionOnServerDenied => 'Permission on server denied.';

  @override
  String get network_couldNotConnectToServer => 'Could not connect to the server. Is it online? Check your address.';

  @override
  String get form_sketch_newSketch => 'New Sketch';

  @override
  String get form_sketch_undo => 'Undo';

  @override
  String get form_sketch_noUndo => 'Nothing to undo';

  @override
  String get form_sketch_clear => 'Clear';

  @override
  String get form_sketch_save => 'Save';

  @override
  String get form_sketch_sketcher => 'Sketcher';

  @override
  String get form_sketch_enableDrawing => 'Turn on drawing';

  @override
  String get form_sketch_enableEraser => 'Turn on eraser';

  @override
  String get form_sketch_backColor => 'Background color';

  @override
  String get form_sketch_strokeColor => 'Stroke color';

  @override
  String get form_sketch_pickColor => 'Pick color';

  @override
  String get form_smash_cantSaveImageDb => 'Could not save image in database.';
}

/// The translations for Norwegian Bokmål, as used in Norway (`nb_NO`).
class SLNbNo extends SLNb {
  SLNbNo(): super('nb_NO');

  @override
  String get main_welcome => 'Velkommen til SMASH.';

  @override
  String get main_check_location_permission => 'Sjekker posisjonstilgang …';

  @override
  String get main_location_permission_granted => 'Posisjonstilgang innvilget.';

  @override
  String get main_checkingStoragePermission => 'Sjekker lagringstilgang …';

  @override
  String get main_storagePermissionGranted => 'Lagringstilgang innvilget.';

  @override
  String get main_loadingPreferences => 'Laster inn innstillinger …';

  @override
  String get main_preferencesLoaded => 'Innstillinger innlastet.';

  @override
  String get main_loadingWorkspace => 'Laster inn arbeidsområde.';

  @override
  String get main_workspaceLoaded => 'Arbeidsområde innlastet.';

  @override
  String get main_loadingTagsList => 'Laster inn etikettliste …';

  @override
  String get main_tagsListLoaded => 'Etikettliste innlastet.';

  @override
  String get main_loadingKnownProjections => 'Laster inn kjente projeksjoner …';

  @override
  String get main_knownProjectionsLoaded => 'Kjente projeksjoner innlastet.';

  @override
  String get main_loadingFences => 'Laster inn gjerder …';

  @override
  String get main_fencesLoaded => 'Gjerder innlastet.';

  @override
  String get main_loadingLayersList => 'Laster inn lagliste …';

  @override
  String get main_layersListLoaded => 'Lagliste innlastet.';

  @override
  String get main_locationBackgroundWarning => 'Innvilg posisjonstilgang i neste steg for å tillate GPS-logging i bakgrunnen. (Ellers virker det kun i forgrunnen.)\nIngen data deles, og lagres kun lokalt på enheten.';

  @override
  String get main_StorageIsInternalWarning => 'Les dette nøye.\nPå Android 11 og videre må SMASH-prosjektmappen lagres i\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\n-mappen i lagringen din for å brukes. Hvis programmet avinstalleres vil systemet fjerne denne.\nHvis dette er tilfelle må du sikkerhetskopiere dataen din først.\n\nEn bedre løsning er underveis.';

  @override
  String get main_locationPermissionIsMandatoryToOpenSmash => 'Posisjonstilgang kreves for å åpne SMASH.';

  @override
  String get main_storagePermissionIsMandatoryToOpenSmash => 'Lagringstilgang kreves for å åpne SMASH.';

  @override
  String get main_anErrorOccurredTapToView => 'Noe gikk galt. Trykk for å vise.';

  @override
  String get mainView_loadingData => 'Laster inn data …';

  @override
  String get mainView_turnGpsOn => 'Skru på GPS';

  @override
  String get mainView_turnGpsOff => 'Skru av GPS';

  @override
  String get mainView_exit => 'Avslutt';

  @override
  String get mainView_areYouSureCloseTheProject => 'Lukk prosjektet?';

  @override
  String get mainView_activeOperationsWillBeStopped => 'Aktive operasjoner vil bli stoppet';

  @override
  String get mainView_showInteractiveCoachMarks => 'Vis interaktive veiledningsmerker.';

  @override
  String get mainView_openToolsDrawer => 'Åpne verktøysskuff.';

  @override
  String get mainView_zoomIn => 'Forstørr';

  @override
  String get mainView_zoomOut => 'Forminsk';

  @override
  String get mainView_formNotes => 'Skjemanotater';

  @override
  String get mainView_simpleNotes => 'Enkle notater';

  @override
  String get mainviewUtils_projects => 'Prosjekter';

  @override
  String get mainviewUtils_import => 'Importer';

  @override
  String get mainviewUtils_export => 'Eksporter';

  @override
  String get mainviewUtils_settings => 'Innstillinger';

  @override
  String get mainviewUtils_onlineHelp => 'Nettbasert hjelp';

  @override
  String get mainviewUtils_about => 'Om';

  @override
  String get mainviewUtils_projectInfo => 'Prosjektinfo';

  @override
  String get mainviewUtils_project => 'Prosjekt';

  @override
  String get mainviewUtils_database => 'Database';

  @override
  String get mainviewUtils_extras => 'Ekstra';

  @override
  String get mainviewUtils_availableIcons => 'Tilgjengelige ikoner';

  @override
  String get mainviewUtils_offlineMaps => 'Frakoblede kart';

  @override
  String get mainviewUtils_positionTools => 'Posisjoneringsverktøy';

  @override
  String get mainviewUtils_goTo => 'Gå til';

  @override
  String get mainviewUtils_sharePosition => 'Del posisjon';

  @override
  String get mainviewUtils_rotateMapWithGps => 'Roter kartet med GPS';

  @override
  String get exportWidget_export => 'Eksporter';

  @override
  String get exportWidget_pdfExported => 'PDF eksportert';

  @override
  String get exportWidget_exportToPortableDocumentFormat => 'Eksporter prosjekt til PDF';

  @override
  String get exportWidget_gpxExported => 'GPX eksportert';

  @override
  String get exportWidget_exportToGpx => 'Eksporter prosjekt til GPX';

  @override
  String get exportWidget_kmlExported => 'KML eksportert';

  @override
  String get exportWidget_exportToKml => 'Eksporter prosjekt til KML';

  @override
  String get exportWidget_imagesToFolderExported => 'Bilder eksportert';

  @override
  String get exportWidget_exportImagesToFolder => 'Eksporter prosjektbilder til mappe';

  @override
  String get exportWidget_exportImagesToFolderTitle => 'Bilder';

  @override
  String get exportWidget_geopackageExported => 'Geopakke eksportert';

  @override
  String get exportWidget_exportToGeopackage => 'Eksporter prosjekt til Geopakke';

  @override
  String get exportWidget_exportToGSS => 'Eksporter til Geopaparazzi-undersøkelsestjener';

  @override
  String get gssExport_gssExport => 'GSS-eksport';

  @override
  String get gssExport_setProjectDirty => 'Sett prosjekt som skittent?';

  @override
  String get gssExport_thisCantBeUndone => 'Dette kan ikke angres.';

  @override
  String get gssExport_restoreProjectAsDirty => 'Gjenopprett prosjekt der alt er skittent?';

  @override
  String get gssExport_setProjectClean => 'Sett prosjekt som rent?';

  @override
  String get gssExport_restoreProjectAsClean => 'Gjenopprett prosjekt der alt er rent?';

  @override
  String get gssExport_nothingToSync => 'Ingenting å synkronisere.';

  @override
  String get gssExport_collectingSyncStats => 'Samler inn synkroniseringsstatistikk …';

  @override
  String get gssExport_unableToSyncDueToError => 'Kunne ikke synkronisere som følge av feil. Sjekk diagnostikk.';

  @override
  String get gssExport_noGssUrlSet => 'Ingen GSS-tjenernettadresse har blitt satt. Sjekk innstillingene dine.';

  @override
  String get gssExport_noGssPasswordSet => 'Inget GSS-tjenerpasssord har blitt satt. Sjekk innstillingene dine.';

  @override
  String get gssExport_synStats => 'Synkroniser statistikk';

  @override
  String get gssExport_followingDataWillBeUploaded => 'Følgende data vil bli opplastet ved synkronisering.';

  @override
  String get gssExport_gpsLogs => 'GPS-logger:';

  @override
  String get gssExport_simpleNotes => 'Enkle notater:';

  @override
  String get gssExport_formNotes => 'Skjemanotater:';

  @override
  String get gssExport_images => 'Bilder:';

  @override
  String get gssExport_shouldNotHappen => 'Skal ikke skje';

  @override
  String get gssExport_upload => 'Last opp';

  @override
  String get geocoding_geocoding => 'Geokoding';

  @override
  String get geocoding_nothingToLookFor => 'Ingenting å se etter. Sett inn en adresse.';

  @override
  String get geocoding_launchGeocoding => 'Start geokoding';

  @override
  String get geocoding_searching => 'Søker …';

  @override
  String get gps_smashIsActive => 'SMASH er aktivt';

  @override
  String get gps_smashIsLogging => 'SMASH logger';

  @override
  String get gps_locationTracking => 'Posisjonssporing';

  @override
  String get gps_smashLocServiceIsActive => 'SMASH-posisjonstjenesten er aktiv.';

  @override
  String get gps_backgroundLocIsOnToKeepRegistering => 'Bakgrunnsposisjon er på for at programme skal kunne registrere posisjon selv i bakgrunnen.';

  @override
  String get gssImport_gssImport => 'GSS-import';

  @override
  String get gssImport_downloadingDataList => 'Laster ned dataliste …';

  @override
  String get gssImport_unableDownloadDataList => 'Kunne ikke laste ned data. Sjekk innstillingene dine og loggen.';

  @override
  String get gssImport_noGssUrlSet => 'Ingen GSS-tjenernettadresse har blitt satt. Sjekk innstillingene dine.';

  @override
  String get gssImport_noGssPasswordSet => 'Inget GSS-tjenerpassord har blitt satt. Sjekk innstillingene dine.';

  @override
  String get gssImport_noPermToAccessServer => 'Ingen tilgang til tjeneren. Sjekk identitetsdetaljene dine.';

  @override
  String get gssImport_data => 'Data';

  @override
  String get gssImport_dataSetsDownloadedMapsFolder => 'Datasett lastes ned til kartmappen.';

  @override
  String get gssImport_noDataAvailable => 'Ingen tilgjengelig data.';

  @override
  String get gssImport_projects => 'Prosjekter';

  @override
  String get gssImport_projectsDownloadedProjectFolder => 'Prosjekter lastes ned til prosjektmappen.';

  @override
  String get gssImport_noProjectsAvailable => 'Ingen tilgjengelige prosjekter.';

  @override
  String get gssImport_forms => 'Skjemaer';

  @override
  String get gssImport_tagsDownloadedFormsFolder => 'Etiketter lastes ned til skjemamappen.';

  @override
  String get gssImport_noTagsAvailable => 'Ingen tilgjengelige etiketter.';

  @override
  String get importWidget_import => 'Importer';

  @override
  String get importWidget_importFromGeopaparazzi => 'Importer fra Geopaparazzi-undersøkelsestjener';

  @override
  String get layersView_layerList => 'Lagliste';

  @override
  String get layersView_loadRemoteDatabase => 'Last inn database annensteds fra';

  @override
  String get layersView_loadOnlineSources => 'Last inn nettbasert ressurser';

  @override
  String get layersView_loadLocalDatasets => 'Last inn lokale datasett';

  @override
  String get layersView_loading => 'Laster inn …';

  @override
  String get layersView_zoomTo => 'Forstørr til';

  @override
  String get layersView_properties => 'Egenskaper';

  @override
  String get layersView_delete => 'Slett';

  @override
  String get layersView_projCouldNotBeRecognized => 'Kunne ikke gjenkjenne proj. Trykk for å skrive inn epsg manuelt.';

  @override
  String get layersView_projNotSupported => 'Ustøttet proj. Trykk for å løse.';

  @override
  String get layersView_onlyImageFilesWithWorldDef => 'Kun bildefiler med verdensfildefinisjon støttes.';

  @override
  String get layersView_onlyImageFileWithPrjDef => 'Kun bildefiler med prj-fildefinisjon støttes.';

  @override
  String get layersView_selectTableToLoad => 'Velg tabell å laste inn.';

  @override
  String get layersView_fileFormatNotSUpported => 'Filformatet støttes ikke.';

  @override
  String get onlineSourcesPage_onlineSourcesCatalog => 'Katalog over nettbaserte kilder';

  @override
  String get onlineSourcesPage_loadingTmsLayers => 'Laster inn TMS-lag …';

  @override
  String get onlineSourcesPage_loadingWmsLayers => 'Laster inn WMS-lag …';

  @override
  String get onlineSourcesPage_importFromFile => 'Importer fra fil';

  @override
  String get onlineSourcesPage_theFile => 'Filen';

  @override
  String get onlineSourcesPage_doesntExist => 'finnes ikke';

  @override
  String get onlineSourcesPage_onlineSourcesImported => 'Nettbaserte kilder importert.';

  @override
  String get onlineSourcesPage_exportToFile => 'Eksporter til fil';

  @override
  String get onlineSourcesPage_exportedTo => 'Eksportert til:';

  @override
  String get onlineSourcesPage_delete => 'Slett';

  @override
  String get onlineSourcesPage_addToLayers => 'Legg til i lag';

  @override
  String get onlineSourcesPage_setNameTmsService => 'Sett et navn for TMS-tjenesten';

  @override
  String get onlineSourcesPage_enterName => 'skriv inn navn';

  @override
  String get onlineSourcesPage_pleaseEnterValidName => 'Skriv inn et gyldig navn';

  @override
  String get onlineSourcesPage_insertUrlOfService => 'Sett inn nettadressen til tjenesten.';

  @override
  String get onlineSourcesPage_placeXyzBetBrackets => 'Plasser x,y,z i klammeparenteser';

  @override
  String get onlineSourcesPage_pleaseEnterValidTmsUrl => 'Skriv inn en gyldig TMS-nettadresse';

  @override
  String get onlineSourcesPage_enterUrl => 'skriv inn nettadresse';

  @override
  String get onlineSourcesPage_enterSubDomains => 'skriv inn underdomener';

  @override
  String get onlineSourcesPage_addAttribution => 'Legg til en henvisning.';

  @override
  String get onlineSourcesPage_enterAttribution => 'skriv inn henvisning';

  @override
  String get onlineSourcesPage_setMinMaxZoom => 'Sett minste og høyeste forstørrelse.';

  @override
  String get onlineSourcesPage_minZoom => 'Minste forstørrelse';

  @override
  String get onlineSourcesPage_maxZoom => 'Høyeste forstørrelse';

  @override
  String get onlineSourcesPage_pleaseCheckYourData => 'Sjekk dataen din';

  @override
  String get onlineSourcesPage_details => 'Detaljer';

  @override
  String get onlineSourcesPage_name => 'Navn: ';

  @override
  String get onlineSourcesPage_subDomains => 'Underdomener: ';

  @override
  String get onlineSourcesPage_attribution => 'Henvisning: ';

  @override
  String get onlineSourcesPage_cancel => 'Avbryt';

  @override
  String get onlineSourcesPage_ok => 'OK';

  @override
  String get onlineSourcesPage_newTmsOnlineService => 'Ny nettbasert TMS-tjeneste';

  @override
  String get onlineSourcesPage_save => 'Lagre';

  @override
  String get onlineSourcesPage_theBaseUrlWithQuestionMark => 'Grunn-nettadresse som slutter med spørsmålstegn';

  @override
  String get onlineSourcesPage_pleaseEnterValidWmsUrl => 'Skriv inn en gyldig WMS-nettadresse';

  @override
  String get onlineSourcesPage_setWmsLayerName => 'Sett WMS-lagnavn';

  @override
  String get onlineSourcesPage_enterLayerToLoad => 'skriv inn lag å laste inn';

  @override
  String get onlineSourcesPage_pleaseEnterValidLayer => 'Skriv inn et gyldig lag';

  @override
  String get onlineSourcesPage_setWmsImageFormat => 'Sett WMS-bildeformat';

  @override
  String get onlineSourcesPage_addAnAttribution => 'Legg til en henvisning.';

  @override
  String get onlineSourcesPage_layer => 'Lag: ';

  @override
  String get onlineSourcesPage_url => 'Nettadresse: ';

  @override
  String get onlineSourcesPage_format => 'Format';

  @override
  String get onlineSourcesPage_newWmsOnlineService => 'Ny nettbasert WMS-tjeneste';

  @override
  String get remoteDbPage_remoteDatabases => 'Databaser annensteds hen';

  @override
  String get remoteDbPage_delete => 'Slett';

  @override
  String get remoteDbPage_areYouSureDeleteDatabase => 'Slett databaseoppsettet?';

  @override
  String get remoteDbPage_edit => 'Rediger';

  @override
  String get remoteDbPage_table => 'tabell';

  @override
  String get remoteDbPage_user => 'bruker';

  @override
  String get remoteDbPage_loadInMap => 'Last inn i kart.';

  @override
  String get remoteDbPage_databaseParameters => 'Database-parametre';

  @override
  String get remoteDbPage_cancel => 'Avbryt';

  @override
  String get remoteDbPage_ok => 'OK';

  @override
  String get remoteDbPage_theUrlNeedsToBeDefined => 'Nettadressen må defineres (postgis:vert:port/databasenavn)';

  @override
  String get remoteDbPage_theUserNeedsToBeDefined => 'En bruker må defineres.';

  @override
  String get remoteDbPage_password => 'passord';

  @override
  String get remoteDbPage_thePasswordNeedsToBeDefined => 'Et passord må defineres.';

  @override
  String get remoteDbPage_loadingTables => 'Laster inn tabeller …';

  @override
  String get remoteDbPage_theTableNeedsToBeDefined => 'Tabellnavnet må defineres.';

  @override
  String get remoteDbPage_unableToConnectToDatabase => 'Kunne ikke koble til databasen. Sjekk parametre og nettverkstilgang.';

  @override
  String get remoteDbPage_optionalWhereCondition => 'valgfritt «hvor»-vilkår';

  @override
  String get geoImage_tiffProperties => 'TIFF-egenskaper';

  @override
  String get geoImage_opacity => 'Dekkevne';

  @override
  String get geoImage_colorToHide => 'Farge å skjule';

  @override
  String get gpx_gpxProperties => 'GPX-egenskaper';

  @override
  String get gpx_wayPoints => 'Veipunkter';

  @override
  String get gpx_color => 'Farge';

  @override
  String get gpx_size => 'Størrelse';

  @override
  String get gpx_viewLabelsIfAvailable => 'Vis etiketter hvis tilgjengelig?';

  @override
  String get gpx_tracksRoutes => 'Spor/ruter';

  @override
  String get gpx_width => 'Bredde';

  @override
  String get gpx_palette => 'Palett';

  @override
  String get tiles_tileProperties => 'Flisegenskaper';

  @override
  String get tiles_opacity => 'Dekkevne';

  @override
  String get tiles_loadGeoPackageAsOverlay => 'Last inn geopakke-flis som overleggsbilde, til forskjell fra flislag (best for gdat-generert data og forskjellige projeksjoner).';

  @override
  String get tiles_colorToHide => 'Farge å skjule';

  @override
  String get wms_wmsProperties => 'WMS-egenskaper';

  @override
  String get wms_opacity => 'Dekkevne';

  @override
  String get featureAttributesViewer_loadingData => 'Laster inn data …';

  @override
  String get featureAttributesViewer_setNewValue => 'Sett ny verdi';

  @override
  String get featureAttributesViewer_field => 'Felt';

  @override
  String get featureAttributesViewer_value => 'Verdi';

  @override
  String get projectsView_projectsView => 'Prosjektvisning';

  @override
  String get projectsView_openExistingProject => 'Åpne et eksisterende prosjekt';

  @override
  String get projectsView_createNewProject => 'Opprett et nytt prosjekt';

  @override
  String get projectsView_recentProjects => 'Nylige prosjekter';

  @override
  String get projectsView_newProject => 'Nytt prosjekt';

  @override
  String get projectsView_enterNameForNewProject => 'Skriv inn et navn på det nye prosjektet eller godta det som er foreslått.';

  @override
  String get dataLoader_note => 'notat';

  @override
  String get dataLoader_Note => 'Notat';

  @override
  String get dataLoader_hasForm => 'Har skjema';

  @override
  String get dataLoader_POI => 'Interessepunkt';

  @override
  String get dataLoader_savingImageToDB => 'Lagrer bilde i database …';

  @override
  String get dataLoader_removeNote => 'Fjern notat';

  @override
  String get dataLoader_areYouSureRemoveNote => 'Fjern notat?';

  @override
  String get dataLoader_image => 'Bilde';

  @override
  String get dataLoader_longitude => 'Lengdegrad';

  @override
  String get dataLoader_latitude => 'Breddegrad';

  @override
  String get dataLoader_altitude => 'Høyde';

  @override
  String get dataLoader_timestamp => 'Tidsstempel';

  @override
  String get dataLoader_removeImage => 'Fjern bilde';

  @override
  String get dataLoader_areYouSureRemoveImage => 'Fjern bildet?';

  @override
  String get images_loadingImage => 'Laster inn bilde …';

  @override
  String get about_loadingInformation => 'Laster inn info …';

  @override
  String get about_ABOUT => 'Om ';

  @override
  String get about_smartMobileAppForSurveyor => 'Smart mobilprogram for landmålerlykke';

  @override
  String get about_applicationVersion => 'Programversjon';

  @override
  String get about_license => 'Lisens';

  @override
  String get about_isAvailableUnderGPL3 => ' er lisensiert GPLv3+.';

  @override
  String get about_sourceCode => 'Kildekode';

  @override
  String get about_tapHereToVisitRepo => 'Trykk her for å besøke kodelageret';

  @override
  String get about_legalInformation => 'Juridisk info';

  @override
  String get about_copyright2020HydroloGIS => 'Opphavsrett © 2020, HydroloGIS S.r.l. — noen rettigheter reservert. Trykk for å besøke.';

  @override
  String get about_supportedBy => 'Støttet av';

  @override
  String get about_partiallySupportedByUniversityTrento => 'Delvis støttet av Steep Steam-prosjektet fra Universitetet i Trento.';

  @override
  String get about_privacyPolicy => 'Personvernspraksis';

  @override
  String get about_tapHereToSeePrivacyPolicy => 'Trykk her for å vise personvernspraksis som omhandler bruker- og posisjonsdata.';

  @override
  String get gpsInfoButton_noGpsInfoAvailable => 'Ingen tilgjengelig GPS-info …';

  @override
  String get gpsInfoButton_timestamp => 'Tidsstempel';

  @override
  String get gpsInfoButton_speed => 'Hastighet';

  @override
  String get gpsInfoButton_heading => 'Retning';

  @override
  String get gpsInfoButton_accuracy => 'Nøyaktighet';

  @override
  String get gpsInfoButton_altitude => 'Høyde';

  @override
  String get gpsInfoButton_latitude => 'Breddegrad';

  @override
  String get gpsInfoButton_copyLatitudeToClipboard => 'Kopier breddegrad til utklippstavlen.';

  @override
  String get gpsInfoButton_longitude => 'Lengdegrad';

  @override
  String get gpsInfoButton_copyLongitudeToClipboard => 'Kopier breddegrad til utklippstavlen.';

  @override
  String get gpsLogButton_stopLogging => 'Stopp loggføring?';

  @override
  String get gpsLogButton_stopLoggingAndCloseLog => 'Stopp logging og lukk nåværende GPS-logg?';

  @override
  String get gpsLogButton_newLog => 'Ny logg';

  @override
  String get gpsLogButton_enterNameForNewLog => 'Skriv inn et navn på den nye loggen';

  @override
  String get gpsLogButton_couldNotStartLogging => 'Kunne ikke starte loggføring: ';

  @override
  String get imageWidgets_loadingImage => 'Laster inn bilde …';

  @override
  String get logList_gpsLogsList => 'GPS-loggliste';

  @override
  String get logList_selectAll => 'Velg alt';

  @override
  String get logList_unSelectAll => 'Fravelg alt';

  @override
  String get logList_invertSelection => 'Inverter utvalg';

  @override
  String get logList_mergeSelected => 'Flett valgte';

  @override
  String get logList_loadingLogs => 'Laster inn logger …';

  @override
  String get logList_zoomTo => 'Forstørr til';

  @override
  String get logList_properties => 'Egenskaper';

  @override
  String get logList_profileView => 'Profilvisning';

  @override
  String get logList_toGPX => 'Til GPS';

  @override
  String get logList_gpsSavedInExportFolder => 'GPX lagret i eksportmappe.';

  @override
  String get logList_errorOccurredExportingLogGPX => 'Kunne ikke ekspoertere logg til GPX.';

  @override
  String get logList_delete => 'Slett';

  @override
  String get logList_DELETE => 'Slett';

  @override
  String get logList_areYouSureDeleteTheLog => 'Slett loggen?';

  @override
  String get logList_hours => 'timer';

  @override
  String get logList_hour => 'time';

  @override
  String get logList_minutes => 'min';

  @override
  String get logProperties_gpsLogProperties => 'Egenskaper for GPS-logg';

  @override
  String get logProperties_logName => 'Loggnavn';

  @override
  String get logProperties_start => 'Start';

  @override
  String get logProperties_end => 'Slutt';

  @override
  String get logProperties_duration => 'Varighet';

  @override
  String get logProperties_color => 'Farge';

  @override
  String get logProperties_palette => 'Palett';

  @override
  String get logProperties_width => 'Bredde';

  @override
  String get logProperties_distanceAtPosition => 'Distanse ved posisjon:';

  @override
  String get logProperties_totalDistance => 'Total distanse:';

  @override
  String get logProperties_gpsLogView => 'GPS-loggvisning';

  @override
  String get logProperties_disableStats => 'Skru av statistikk';

  @override
  String get logProperties_enableStats => 'Skru på statistikk';

  @override
  String get logProperties_totalDuration => 'Total varighet:';

  @override
  String get logProperties_timestamp => 'Tidsstempel:';

  @override
  String get logProperties_durationAtPosition => 'Varighet ved posisjon:';

  @override
  String get logProperties_speed => 'Hastighet:';

  @override
  String get logProperties_elevation => 'Høyde:';

  @override
  String get noteList_simpleNotesList => 'Enkel notatliste';

  @override
  String get noteList_formNotesList => 'Skjemanotatliste';

  @override
  String get noteList_loadingNotes => 'Laster inn notater …';

  @override
  String get noteList_zoomTo => 'Forstørr til';

  @override
  String get noteList_edit => '«Rediger»';

  @override
  String get noteList_properties => 'Egenskaper';

  @override
  String get noteList_delete => 'Slett';

  @override
  String get noteList_DELETE => 'Slett';

  @override
  String get noteList_areYouSureDeleteNote => 'Slett notatet?';

  @override
  String get settings_settings => 'Innstillinger';

  @override
  String get settings_camera => 'Kamera';

  @override
  String get settings_cameraResolution => 'Kameraoppløsning';

  @override
  String get settings_resolution => 'Oppløsning';

  @override
  String get settings_theCameraResolution => 'Kameraoppløsningen';

  @override
  String get settings_screen => 'Skjerm';

  @override
  String get settings_screenScaleBarIconSize => 'Skjerm, skaleringsfelt og ikonstørrelse';

  @override
  String get settings_keepScreenOn => 'Behold skjerm påslått';

  @override
  String get settings_retinaScreenMode => 'HiDPI-skjermmodus';

  @override
  String get settings_toApplySettingEnterExitLayerView => 'Åpne og avslutt lagvisningen for å bruke denne innstillingen.';

  @override
  String get settings_colorPickerToUse => 'Fargevelger å bruke';

  @override
  String get settings_mapCenterCross => 'Kartsenterkryss';

  @override
  String get settings_color => 'Farge';

  @override
  String get settings_size => 'Størrelse';

  @override
  String get settings_width => 'Bredde';

  @override
  String get settings_mapToolsIconSize => 'Ikonstørrelse for kartverktøy';

  @override
  String get settings_gps => 'GPS';

  @override
  String get settings_gpsFiltersAndMockLoc => 'GPS-filtre og jukseposisjoner';

  @override
  String get settings_livePreview => 'Sanntidsforhåndsvisning';

  @override
  String get settings_noPointAvailableYet => 'Ingen tilgjengelige punkter enda.';

  @override
  String get settings_longitudeDeg => 'lengdegrad [deg]';

  @override
  String get settings_latitudeDeg => 'breddegrad [deg]';

  @override
  String get settings_accuracyM => 'nøyaktighet [m]';

  @override
  String get settings_altitudeM => 'høyde [m]';

  @override
  String get settings_headingDeg => 'retning [deg]';

  @override
  String get settings_speedMS => 'hastighet [m/s]';

  @override
  String get settings_isLogging => 'loggfører?';

  @override
  String get settings_mockLocations => 'jukseposisjoner?';

  @override
  String get settings_minDistFilterBlocks => 'Min. avstand for filterblokker';

  @override
  String get settings_minDistFilterPasses => 'Min. avstand for filtreringer';

  @override
  String get settings_minTimeFilterBlocks => 'Min. tid for filtreringsblokker';

  @override
  String get settings_minTimeFilterPasses => 'Min. tid for filtreringer';

  @override
  String get settings_hasBeenBlocked => 'Har blitt blokkert';

  @override
  String get settings_distanceFromPrevM => 'Avstand fra forrige [m]';

  @override
  String get settings_timeFromPrevS => 'Tid siden forrige [s]';

  @override
  String get settings_locationInfo => 'Posisjonsinfo';

  @override
  String get settings_filters => 'Filtre';

  @override
  String get settings_disableFilters => 'Skru av filtre.';

  @override
  String get settings_enableFilters => 'Skru på filtre.';

  @override
  String get settings_zoomIn => 'Forstørr';

  @override
  String get settings_zoomOut => 'Forminsk';

  @override
  String get settings_activatePointFlow => 'Aktiver punktflyt.';

  @override
  String get settings_pausePointsFlow => 'Sett punktflyt på pause.';

  @override
  String get settings_visualizePointCount => 'Visualiser punktantall';

  @override
  String get settings_showGpsPointsValidPoints => 'Vis GPS-punktantall for GYLDIGE punkter.';

  @override
  String get settings_showGpsPointsAllPoints => 'Vis GPS-punktantall for ALLE punkter.';

  @override
  String get settings_logFilters => 'Logg-filtre';

  @override
  String get settings_minDistanceBetween2Points => 'Minste avstand mellom to punkter.';

  @override
  String get settings_minTimespanBetween2Points => 'Minste tidsforløp mellom to punkter.';

  @override
  String get settings_gpsFilter => 'GPS-filter';

  @override
  String get settings_disable => 'Skru av';

  @override
  String get settings_enable => 'Skru på';

  @override
  String get settings_theUseOfTheGps => 'bruk av filtrert GPS.';

  @override
  String get settings_warningThisWillAffectGpsPosition => 'Advarsel: Dette har innvirkning på GPS-posisjon, notatinnsetting, loggføringsstatistikk og diagramplotting.';

  @override
  String get settings_MockLocations => 'Jukseposisjoner';

  @override
  String get settings_testGpsLogDemoUse => 'test-GPS-logg for demobruk.';

  @override
  String get settings_setDurationGpsPointsInMilli => 'Sett varighet for GPS-punkter i millisekunder.';

  @override
  String get settings_SETTING => 'Innstilling';

  @override
  String get settings_setMockedGpsDuration => 'Sett varighet for jukse-GPS';

  @override
  String get settings_theValueHasToBeInt => 'Verdien må være et heltall.';

  @override
  String get settings_milliseconds => 'millisekunder';

  @override
  String get settings_useGoogleToImproveLoc => 'Bruk Google-tjenester for å forbedre posisjon';

  @override
  String get settings_useOfGoogleServicesRestart => 'bruk av Google-tjenester (programomstart kreves).';

  @override
  String get settings_gpsLogsViewMode => 'GPS-loggvisningsmodus';

  @override
  String get settings_logViewModeForOrigData => 'Loggvisningsmodus for opprinnelig data.';

  @override
  String get settings_logViewModeFilteredData => 'Loggvisningsmodus for filtrert data.';

  @override
  String get settings_cancel => 'Avbryt';

  @override
  String get settings_ok => 'OK';

  @override
  String get settings_notesViewModes => 'Notatvisningsmodus';

  @override
  String get settings_selectNotesViewMode => 'Velg modus å vise notater i.';

  @override
  String get settings_mapPlugins => 'Kartprogramtillegg';

  @override
  String get settings_vectorLayers => 'Vektorielle lag';

  @override
  String get settings_loadingOptionsInfoTool => 'Innlasting av innstillinger og infoverktøy';

  @override
  String get settings_dataLoading => 'Datainnlasting';

  @override
  String get settings_maxNumberFeatures => 'Maksimalt antall funksjoner.';

  @override
  String get settings_maxNumFeaturesPerLayer => 'Maksimalt antall funksjoner å laste inn per lag. Fjern og legg til laget for å bruke.';

  @override
  String get settings_all => 'alle';

  @override
  String get settings_loadMapArea => 'Last inn kartområde.';

  @override
  String get settings_loadOnlyLastVisibleArea => 'Kun last inn på sist synlige kartområde. Fjern og legg til igjen laget for å bruke.';

  @override
  String get settings_infoTool => 'Infoverktøy';

  @override
  String get settings_tapSizeInfoToolPixels => 'Trykkingsstørrelse for infoverktøyet i piksler.';

  @override
  String get settings_editingTool => 'Redigeringsverktøy';

  @override
  String get settings_editingDragIconSize => 'Rediger ikonstørrelse for dragningshåndterer.';

  @override
  String get settings_editingIntermediateDragIconSize => 'Redigering av ikonstørrelse for mellomliggende dragningshåndterer.';

  @override
  String get settings_diagnostics => 'Diagnostikk';

  @override
  String get settings_diagnosticsDebugLog => 'Diagnostikk og avlusningslogg';

  @override
  String get settings_openFullDebugLog => 'Åpne full avlusningslogg';

  @override
  String get settings_debugLogView => 'Avlusningsloggvisning';

  @override
  String get settings_viewAllMessages => 'Vis alle meldinger';

  @override
  String get settings_viewOnlyErrorsWarnings => 'Vis kun feil og advarsler';

  @override
  String get settings_clearDebugLog => 'Tøm avlusningslogg';

  @override
  String get settings_loadingData => 'Laster inn data …';

  @override
  String get settings_device => 'Enhet';

  @override
  String get settings_deviceIdentifier => 'Enhetsidentifikator';

  @override
  String get settings_deviceId => 'Enhets-ID';

  @override
  String get settings_overrideDeviceId => 'Overstyr enhets-ID';

  @override
  String get settings_overrideId => 'Overstyr ID';

  @override
  String get settings_pleaseEnterValidPassword => 'Skriv inn et gyldig tjenerpassord.';

  @override
  String get settings_gss => 'GSS';

  @override
  String get settings_geopaparazziSurveyServer => 'Geopaparazzi-undersøkelsestjener';

  @override
  String get settings_serverUrl => 'Tjenernettadresse';

  @override
  String get settings_serverUrlStartWithHttp => 'Tjenernettadressen må starte med HTTP eller HTTPS.';

  @override
  String get settings_serverPassword => 'Tjenerpassord';

  @override
  String get settings_allowSelfSignedCert => 'Tillat selvsignerte sertifikater.';

  @override
  String get toolbarTools_zoomOut => 'Forminsk';

  @override
  String get toolbarTools_zoomIn => 'Forstørr';

  @override
  String get toolbarTools_cancelCurrentEdit => 'Avbryt pågående redigering.';

  @override
  String get toolbarTools_saveCurrentEdit => 'Lagre nåværende redigering.';

  @override
  String get toolbarTools_insertPointMapCenter => 'Sett inn punkt i kartsenter.';

  @override
  String get toolbarTools_insertPointGpsPos => 'Sett inn punkt på GPS-posisjon.';

  @override
  String get toolbarTools_removeSelectedFeature => 'Fjern valgt funksjon.';

  @override
  String get toolbarTools_showFeatureAttributes => 'Vis funksjonsattributter.';

  @override
  String get toolbarTools_featureDoesNotHavePrimaryKey => 'Funksjonen har ingen hovednøkkel. Redigering tillates ikke.';

  @override
  String get toolbarTools_queryFeaturesVectorLayers => 'Utfør spørring av funksjoner innlastet fra vektorielle lag.';

  @override
  String get toolbarTools_measureDistanceWithFinger => 'Mål avstander i kartet med fingeren din.';

  @override
  String get toolbarTools_toggleFenceMapCenter => 'Veksle gjerde i kartsenter.';

  @override
  String get toolbarTools_modifyGeomVectorLayers => 'Endre geometri for redigerbare vektorielle lag.';

  @override
  String get coachMarks_singleTap => 'Enkelt trykk: ';

  @override
  String get coachMarks_longTap => 'Lang-trykk: ';

  @override
  String get coachMarks_doubleTap => 'Dobbelttrykk: ';

  @override
  String get coachMarks_simpleNoteButton => 'Knapp for enkle notater';

  @override
  String get coachMarks_addNewNote => 'legg til et nytt notat';

  @override
  String get coachMarks_viewNotesList => 'vis notatliste';

  @override
  String get coachMarks_viewNotesSettings => 'vis notatinnstillinger';

  @override
  String get coachMarks_formNotesButton => 'Knapp for skjemanotater';

  @override
  String get coachMarks_addNewFormNote => 'legg til nytt skjemanotat';

  @override
  String get coachMarks_viewFormNoteList => 'vis liste over skjemanotater';

  @override
  String get coachMarks_gpsLogButton => 'GPS-loggingsnkapp';

  @override
  String get coachMarks_startStopLogging => 'start logging/stopp logging';

  @override
  String get coachMarks_viewLogsList => 'vis loggliste';

  @override
  String get coachMarks_viewLogsSettings => 'vis logginnstillinger';

  @override
  String get coachMarks_gpsInfoButton => 'GPS-infoknapp (hvis relevant)';

  @override
  String get coachMarks_centerMapOnGpsPos => 'sentrer kart på GPS-posisjon';

  @override
  String get coachMarks_showGpsInfo => 'vis GPS-info';

  @override
  String get coachMarks_toggleAutoCenterGps => 'veksle automatisk sentrering på GPS';

  @override
  String get coachMarks_layersViewButton => 'Lagvisningsknapp';

  @override
  String get coachMarks_openLayersView => 'Åpne lagvisningen';

  @override
  String get coachMarks_openLayersPluginDialog => 'Åpne lag-programtilleggsdialogen';

  @override
  String get coachMarks_zoomInButton => 'Forstørrelsesknapp';

  @override
  String get coachMarks_zoomImMapOneLevel => 'Forstørr kartet ett nivå';

  @override
  String get coachMarks_zoomOutButton => 'Forminskningsknapp';

  @override
  String get coachMarks_zoomOutMapOneLevel => 'Forminsk kartet ett nivå';

  @override
  String get coachMarks_bottomToolsButton => 'Bunnverktøy-knapp';

  @override
  String get coachMarks_toggleBottomToolsBar => 'Veksle bunnverktøyknappen. ';

  @override
  String get coachMarks_toolsButton => 'Verktøyknapp';

  @override
  String get coachMarks_openEndDrawerToAccessProject => 'Åpne sluttskuffen for å få tilgang til prosjektinfo og delingsvalg, samt kartprogramtillegg, funksjonsverktøy og ekstrating.';

  @override
  String get coachMarks_interactiveCoackMarksButton => 'Interaktiv veiledningsmerke-knapp';

  @override
  String get coachMarks_openInteractiveCoachMarks => 'Åpne de interaktive veiledningsmerkene som forklarer alle handlinger i hovedkartsvisningen.';

  @override
  String get coachMarks_mainMenuButton => 'Hovedmeny-knapp';

  @override
  String get coachMarks_openDrawerToLoadProject => 'Åpne skuffen for å laste inn eller opprette et prosjekt, importere og ekspoertere data, synkronisere data med tjenere, endre innstillinger, og avslutte programmet/skru av GPS.';

  @override
  String get coachMarks_skip => 'Hopp over';

  @override
  String get fence_fenceProperties => 'Gjerdeegenskaper';

  @override
  String get fence_delete => 'Slett';

  @override
  String get fence_removeFence => 'Fjern gjerde';

  @override
  String get fence_areYouSureRemoveFence => 'Fjern gjerdet?';

  @override
  String get fence_cancel => 'Avbryt';

  @override
  String get fence_ok => 'OK';

  @override
  String get fence_aNewFence => 'et nytt gjerde';

  @override
  String get fence_label => 'Etikett';

  @override
  String get fence_aNameForFence => 'Et navn på gjerdet.';

  @override
  String get fence_theNameNeedsToBeDefined => 'Navnet må defineres.';

  @override
  String get fence_radius => 'Radius';

  @override
  String get fence_theFenceRadiusMeters => 'Gjerderadius i meter.';

  @override
  String get fence_radiusNeedsToBePositive => 'Radiusen må være et positivt tall i meter.';

  @override
  String get fence_onEnter => 'Ved inngang';

  @override
  String get fence_onExit => 'Ved utgang';

  @override
  String get network_cancelledByUser => 'Avbrutt av bruker.';

  @override
  String get network_completed => 'Fullført.';

  @override
  String get network_buildingBaseCachePerformance => 'Bygger grunnhurtiglager for bedre ytelse (kan ta en stund)…';

  @override
  String get network_thisFIleAlreadyBeingDownloaded => 'Filen blir allerede lastet ned.';

  @override
  String get network_download => 'Last ned';

  @override
  String get network_downloadFile => 'Last ned fil';

  @override
  String get network_toTheDeviceTakeTime => 'til enheten? Dette kan ta lang tid.';

  @override
  String get network_availableMaps => 'Tilgjengelige kart';

  @override
  String get network_searchMapByName => 'Søk etter kart ved navn';

  @override
  String get network_uploading => 'Opplasting';

  @override
  String get network_pleaseWait => 'vent …';

  @override
  String get network_permissionOnServerDenied => 'Tilgang på tjener avslått.';

  @override
  String get network_couldNotConnectToServer => 'Kunne ikke koble til tjeneren. Er den på nett? Sjekk adressen din.';

  @override
  String get form_sketch_newSketch => 'Ny skisse';

  @override
  String get form_sketch_undo => 'Angre';

  @override
  String get form_sketch_noUndo => 'Ingenting å angre';

  @override
  String get form_sketch_clear => 'Tøm';

  @override
  String get form_sketch_save => 'Lagre';

  @override
  String get form_sketch_sketcher => 'Skissemaker';

  @override
  String get form_sketch_enableDrawing => 'Skru på tegning';

  @override
  String get form_sketch_enableEraser => 'Skru på viskelær';

  @override
  String get form_sketch_backColor => 'Bakgrunnsfarge';

  @override
  String get form_sketch_strokeColor => 'Strøkfarge';

  @override
  String get form_sketch_pickColor => 'Velg farge';

  @override
  String get form_smash_cantSaveImageDb => 'Kunne ikke lagre bilde i databasen.';
}
