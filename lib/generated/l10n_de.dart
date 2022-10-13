import 'l10n.dart';

/// The translations for German (`de`).
class SLDe extends SL {
  SLDe([String locale = 'de']) : super(locale);

  @override
  String get main_welcome => 'Willkommen bei SMASH!';

  @override
  String get main_check_location_permission => 'Standortbestimmung prüfen…';

  @override
  String get main_location_permission_granted => 'Erlaubnis zur Lokalisierung erteilt.';

  @override
  String get main_checkingStoragePermission => 'Speicherberechtigung prüfen…';

  @override
  String get main_storagePermissionGranted => 'Speichererlaubnis erteilt.';

  @override
  String get main_loadingPreferences => 'Laden der Einstellungen…';

  @override
  String get main_preferencesLoaded => 'Einstellungen geladen.';

  @override
  String get main_loadingWorkspace => 'Arbeitsbereich laden…';

  @override
  String get main_workspaceLoaded => 'Arbeitsbereich geladen.';

  @override
  String get main_loadingTagsList => 'Liste der Tags laden…';

  @override
  String get main_tagsListLoaded => 'Liste der Tags geladen.';

  @override
  String get main_loadingKnownProjections => 'Bekannte Projektionen laden…';

  @override
  String get main_knownProjectionsLoaded => 'Bekannte Projektionen geladen.';

  @override
  String get main_loadingFences => 'Lade Begrenzung…';

  @override
  String get main_fencesLoaded => 'Begrenzungen geladen.';

  @override
  String get main_loadingLayersList => 'Laden der Layerliste…';

  @override
  String get main_layersListLoaded => 'Layerliste geladen.';

  @override
  String get main_locationBackgroundWarning => 'Erteilen Sie im nächsten Schritt die Standortfreigabe, um die GPS-Aufzeichnung im Hintergrund zu ermöglichen. ( Andernfalls funktioniert das System nur im Vordergrund.)\nEs werden keine Daten weitergegeben, sondern nur lokal auf dem Gerät gespeichert.';

  @override
  String get main_StorageIsInternalWarning => 'Bitte aufmerksam lesen!\nUnter Android 11 und höher muss sich der SMASH-Projektordner im Verzeichnis\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\nbefinden.\nBei Deinstallation der App wird er vom System entfernt, daher sollten Sie Ihre Daten sichern.\n\nEine bessere Lösung ist in Arbeit.';

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
  String get mainviewUtils_sharePosition => 'Share position';

  @override
  String get mainviewUtils_rotateMapWithGps => 'Rotate map with GPS';

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
  String get noteList_edit => '\'Edit\'';

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
