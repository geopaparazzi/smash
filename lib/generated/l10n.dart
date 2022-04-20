// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class SL {
  SL();
  
  static SL current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<SL> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      SL.current = SL();
      
      return SL.current;
    });
  } 

  static SL of(BuildContext context) {
    return Localizations.of<SL>(context, SL);
  }

  /// `Welcome to SMASH!`
  String get main_welcome {
    return Intl.message(
      'Welcome to SMASH!',
      name: 'main_welcome',
      desc: '',
      args: [],
    );
  }

  /// `Checking location permission…`
  String get main_check_location_permission {
    return Intl.message(
      'Checking location permission…',
      name: 'main_check_location_permission',
      desc: '',
      args: [],
    );
  }

  /// `Location permission granted.`
  String get main_location_permission_granted {
    return Intl.message(
      'Location permission granted.',
      name: 'main_location_permission_granted',
      desc: '',
      args: [],
    );
  }

  /// `Checking storage permission…`
  String get main_checkingStoragePermission {
    return Intl.message(
      'Checking storage permission…',
      name: 'main_checkingStoragePermission',
      desc: '',
      args: [],
    );
  }

  /// `Storage permission granted.`
  String get main_storagePermissionGranted {
    return Intl.message(
      'Storage permission granted.',
      name: 'main_storagePermissionGranted',
      desc: '',
      args: [],
    );
  }

  /// `Loading preferences…`
  String get main_loadingPreferences {
    return Intl.message(
      'Loading preferences…',
      name: 'main_loadingPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Preferences loaded.`
  String get main_preferencesLoaded {
    return Intl.message(
      'Preferences loaded.',
      name: 'main_preferencesLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Loading workspace…`
  String get main_loadingWorkspace {
    return Intl.message(
      'Loading workspace…',
      name: 'main_loadingWorkspace',
      desc: '',
      args: [],
    );
  }

  /// `Workspace loaded.`
  String get main_workspaceLoaded {
    return Intl.message(
      'Workspace loaded.',
      name: 'main_workspaceLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Loading tags list…`
  String get main_loadingTagsList {
    return Intl.message(
      'Loading tags list…',
      name: 'main_loadingTagsList',
      desc: '',
      args: [],
    );
  }

  /// `Tags list loaded.`
  String get main_tagsListLoaded {
    return Intl.message(
      'Tags list loaded.',
      name: 'main_tagsListLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Loading known projections…`
  String get main_loadingKnownProjections {
    return Intl.message(
      'Loading known projections…',
      name: 'main_loadingKnownProjections',
      desc: '',
      args: [],
    );
  }

  /// `Known projections loaded.`
  String get main_knownProjectionsLoaded {
    return Intl.message(
      'Known projections loaded.',
      name: 'main_knownProjectionsLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Loading fences…`
  String get main_loadingFences {
    return Intl.message(
      'Loading fences…',
      name: 'main_loadingFences',
      desc: '',
      args: [],
    );
  }

  /// `Fences loaded.`
  String get main_fencesLoaded {
    return Intl.message(
      'Fences loaded.',
      name: 'main_fencesLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Loading layers list…`
  String get main_loadingLayersList {
    return Intl.message(
      'Loading layers list…',
      name: 'main_loadingLayersList',
      desc: '',
      args: [],
    );
  }

  /// `Layers list loaded.`
  String get main_layersListLoaded {
    return Intl.message(
      'Layers list loaded.',
      name: 'main_layersListLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Grant location permission in the next step to allow GPS logging in the background. (Otherwise it only works in the foreground.)\nNo data is shared, and only saved locally on the device.`
  String get main_locationBackgroundWarning {
    return Intl.message(
      'Grant location permission in the next step to allow GPS logging in the background. (Otherwise it only works in the foreground.)\nNo data is shared, and only saved locally on the device.',
      name: 'main_locationBackgroundWarning',
      desc: '',
      args: [],
    );
  }

  /// `Please read carefully!\nOn Android 11 and above, the SMASH project folder must be placed in the\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\nfolder in your storage to be used.\nIf the app is uninstalled, the system removes it, so back up your data if you do.\n\nA better solution is in the works.`
  String get main_StorageIsInternalWarning {
    return Intl.message(
      'Please read carefully!\nOn Android 11 and above, the SMASH project folder must be placed in the\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\nfolder in your storage to be used.\nIf the app is uninstalled, the system removes it, so back up your data if you do.\n\nA better solution is in the works.',
      name: 'main_StorageIsInternalWarning',
      desc: '',
      args: [],
    );
  }

  /// `Location permission is mandatory to open SMASH.`
  String get main_locationPermissionIsMandatoryToOpenSmash {
    return Intl.message(
      'Location permission is mandatory to open SMASH.',
      name: 'main_locationPermissionIsMandatoryToOpenSmash',
      desc: '',
      args: [],
    );
  }

  /// `Storage permission is mandatory to open SMASH.`
  String get main_storagePermissionIsMandatoryToOpenSmash {
    return Intl.message(
      'Storage permission is mandatory to open SMASH.',
      name: 'main_storagePermissionIsMandatoryToOpenSmash',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Tap to view.`
  String get main_anErrorOccurredTapToView {
    return Intl.message(
      'An error occurred. Tap to view.',
      name: 'main_anErrorOccurredTapToView',
      desc: '',
      args: [],
    );
  }

  /// `Loading data…`
  String get mainView_loadingData {
    return Intl.message(
      'Loading data…',
      name: 'mainView_loadingData',
      desc: '',
      args: [],
    );
  }

  /// `Turn GPS on`
  String get mainView_turnGpsOn {
    return Intl.message(
      'Turn GPS on',
      name: 'mainView_turnGpsOn',
      desc: '',
      args: [],
    );
  }

  /// `Turn GPS off`
  String get mainView_turnGpsOff {
    return Intl.message(
      'Turn GPS off',
      name: 'mainView_turnGpsOff',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get mainView_exit {
    return Intl.message(
      'Exit',
      name: 'mainView_exit',
      desc: '',
      args: [],
    );
  }

  /// `Close the project?`
  String get mainView_areYouSureCloseTheProject {
    return Intl.message(
      'Close the project?',
      name: 'mainView_areYouSureCloseTheProject',
      desc: '',
      args: [],
    );
  }

  /// `Active operations will be stopped.`
  String get mainView_activeOperationsWillBeStopped {
    return Intl.message(
      'Active operations will be stopped.',
      name: 'mainView_activeOperationsWillBeStopped',
      desc: '',
      args: [],
    );
  }

  /// `Show interactive coach marks.`
  String get mainView_showInteractiveCoachMarks {
    return Intl.message(
      'Show interactive coach marks.',
      name: 'mainView_showInteractiveCoachMarks',
      desc: '',
      args: [],
    );
  }

  /// `Open tools drawer.`
  String get mainView_openToolsDrawer {
    return Intl.message(
      'Open tools drawer.',
      name: 'mainView_openToolsDrawer',
      desc: '',
      args: [],
    );
  }

  /// `Zoom in`
  String get mainView_zoomIn {
    return Intl.message(
      'Zoom in',
      name: 'mainView_zoomIn',
      desc: '',
      args: [],
    );
  }

  /// `Zoom out`
  String get mainView_zoomOut {
    return Intl.message(
      'Zoom out',
      name: 'mainView_zoomOut',
      desc: '',
      args: [],
    );
  }

  /// `Form Notes`
  String get mainView_formNotes {
    return Intl.message(
      'Form Notes',
      name: 'mainView_formNotes',
      desc: '',
      args: [],
    );
  }

  /// `Simple Notes`
  String get mainView_simpleNotes {
    return Intl.message(
      'Simple Notes',
      name: 'mainView_simpleNotes',
      desc: '',
      args: [],
    );
  }

  /// `Projects`
  String get mainviewUtils_projects {
    return Intl.message(
      'Projects',
      name: 'mainviewUtils_projects',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get mainviewUtils_import {
    return Intl.message(
      'Import',
      name: 'mainviewUtils_import',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get mainviewUtils_export {
    return Intl.message(
      'Export',
      name: 'mainviewUtils_export',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get mainviewUtils_settings {
    return Intl.message(
      'Settings',
      name: 'mainviewUtils_settings',
      desc: '',
      args: [],
    );
  }

  /// `Online Help`
  String get mainviewUtils_onlineHelp {
    return Intl.message(
      'Online Help',
      name: 'mainviewUtils_onlineHelp',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get mainviewUtils_about {
    return Intl.message(
      'About',
      name: 'mainviewUtils_about',
      desc: '',
      args: [],
    );
  }

  /// `Project Info`
  String get mainviewUtils_projectInfo {
    return Intl.message(
      'Project Info',
      name: 'mainviewUtils_projectInfo',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get mainviewUtils_project {
    return Intl.message(
      'Project',
      name: 'mainviewUtils_project',
      desc: '',
      args: [],
    );
  }

  /// `Database`
  String get mainviewUtils_database {
    return Intl.message(
      'Database',
      name: 'mainviewUtils_database',
      desc: '',
      args: [],
    );
  }

  /// `Extras`
  String get mainviewUtils_extras {
    return Intl.message(
      'Extras',
      name: 'mainviewUtils_extras',
      desc: '',
      args: [],
    );
  }

  /// `Available icons`
  String get mainviewUtils_availableIcons {
    return Intl.message(
      'Available icons',
      name: 'mainviewUtils_availableIcons',
      desc: '',
      args: [],
    );
  }

  /// `Offline maps`
  String get mainviewUtils_offlineMaps {
    return Intl.message(
      'Offline maps',
      name: 'mainviewUtils_offlineMaps',
      desc: '',
      args: [],
    );
  }

  /// `Position Tools`
  String get mainviewUtils_positionTools {
    return Intl.message(
      'Position Tools',
      name: 'mainviewUtils_positionTools',
      desc: '',
      args: [],
    );
  }

  /// `Go to`
  String get mainviewUtils_goTo {
    return Intl.message(
      'Go to',
      name: 'mainviewUtils_goTo',
      desc: '',
      args: [],
    );
  }

  /// `Share position`
  String get mainviewUtils_sharePosition {
    return Intl.message(
      'Share position',
      name: 'mainviewUtils_sharePosition',
      desc: '',
      args: [],
    );
  }

  /// `Rotate map with GPS`
  String get mainviewUtils_rotateMapWithGps {
    return Intl.message(
      'Rotate map with GPS',
      name: 'mainviewUtils_rotateMapWithGps',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get exportWidget_export {
    return Intl.message(
      'Export',
      name: 'exportWidget_export',
      desc: '',
      args: [],
    );
  }

  /// `PDF exported`
  String get exportWidget_pdfExported {
    return Intl.message(
      'PDF exported',
      name: 'exportWidget_pdfExported',
      desc: '',
      args: [],
    );
  }

  /// `Export project to Portable Document Format`
  String get exportWidget_exportToPortableDocumentFormat {
    return Intl.message(
      'Export project to Portable Document Format',
      name: 'exportWidget_exportToPortableDocumentFormat',
      desc: '',
      args: [],
    );
  }

  /// `GPX exported`
  String get exportWidget_gpxExported {
    return Intl.message(
      'GPX exported',
      name: 'exportWidget_gpxExported',
      desc: '',
      args: [],
    );
  }

  /// `Export project to GPX`
  String get exportWidget_exportToGpx {
    return Intl.message(
      'Export project to GPX',
      name: 'exportWidget_exportToGpx',
      desc: '',
      args: [],
    );
  }

  /// `KML exported`
  String get exportWidget_kmlExported {
    return Intl.message(
      'KML exported',
      name: 'exportWidget_kmlExported',
      desc: '',
      args: [],
    );
  }

  /// `Export project to KML`
  String get exportWidget_exportToKml {
    return Intl.message(
      'Export project to KML',
      name: 'exportWidget_exportToKml',
      desc: '',
      args: [],
    );
  }

  /// `Images exported`
  String get exportWidget_imagesToFolderExported {
    return Intl.message(
      'Images exported',
      name: 'exportWidget_imagesToFolderExported',
      desc: '',
      args: [],
    );
  }

  /// `Export project images to folder`
  String get exportWidget_exportImagesToFolder {
    return Intl.message(
      'Export project images to folder',
      name: 'exportWidget_exportImagesToFolder',
      desc: '',
      args: [],
    );
  }

  /// `Images`
  String get exportWidget_exportImagesToFolderTitle {
    return Intl.message(
      'Images',
      name: 'exportWidget_exportImagesToFolderTitle',
      desc: '',
      args: [],
    );
  }

  /// `Geopackage exported`
  String get exportWidget_geopackageExported {
    return Intl.message(
      'Geopackage exported',
      name: 'exportWidget_geopackageExported',
      desc: '',
      args: [],
    );
  }

  /// `Export project to Geopackage`
  String get exportWidget_exportToGeopackage {
    return Intl.message(
      'Export project to Geopackage',
      name: 'exportWidget_exportToGeopackage',
      desc: '',
      args: [],
    );
  }

  /// `Export to Geopaparazzi Survey Server`
  String get exportWidget_exportToGSS {
    return Intl.message(
      'Export to Geopaparazzi Survey Server',
      name: 'exportWidget_exportToGSS',
      desc: '',
      args: [],
    );
  }

  /// `GSS Export`
  String get gssExport_gssExport {
    return Intl.message(
      'GSS Export',
      name: 'gssExport_gssExport',
      desc: '',
      args: [],
    );
  }

  /// `Set project to DIRTY?`
  String get gssExport_setProjectDirty {
    return Intl.message(
      'Set project to DIRTY?',
      name: 'gssExport_setProjectDirty',
      desc: '',
      args: [],
    );
  }

  /// `This can't be undone!`
  String get gssExport_thisCantBeUndone {
    return Intl.message(
      'This can\'t be undone!',
      name: 'gssExport_thisCantBeUndone',
      desc: '',
      args: [],
    );
  }

  /// `Restore project as all dirty.`
  String get gssExport_restoreProjectAsDirty {
    return Intl.message(
      'Restore project as all dirty.',
      name: 'gssExport_restoreProjectAsDirty',
      desc: '',
      args: [],
    );
  }

  /// `Set project to CLEAN?`
  String get gssExport_setProjectClean {
    return Intl.message(
      'Set project to CLEAN?',
      name: 'gssExport_setProjectClean',
      desc: '',
      args: [],
    );
  }

  /// `Restore project as all clean.`
  String get gssExport_restoreProjectAsClean {
    return Intl.message(
      'Restore project as all clean.',
      name: 'gssExport_restoreProjectAsClean',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to sync.`
  String get gssExport_nothingToSync {
    return Intl.message(
      'Nothing to sync.',
      name: 'gssExport_nothingToSync',
      desc: '',
      args: [],
    );
  }

  /// `Collecting sync stats…`
  String get gssExport_collectingSyncStats {
    return Intl.message(
      'Collecting sync stats…',
      name: 'gssExport_collectingSyncStats',
      desc: '',
      args: [],
    );
  }

  /// `Unable to sync due to an error, check diagnostics.`
  String get gssExport_unableToSyncDueToError {
    return Intl.message(
      'Unable to sync due to an error, check diagnostics.',
      name: 'gssExport_unableToSyncDueToError',
      desc: '',
      args: [],
    );
  }

  /// `No GSS server URL has been set. Check your settings.`
  String get gssExport_noGssUrlSet {
    return Intl.message(
      'No GSS server URL has been set. Check your settings.',
      name: 'gssExport_noGssUrlSet',
      desc: '',
      args: [],
    );
  }

  /// `No GSS server password has been set. Check your settings.`
  String get gssExport_noGssPasswordSet {
    return Intl.message(
      'No GSS server password has been set. Check your settings.',
      name: 'gssExport_noGssPasswordSet',
      desc: '',
      args: [],
    );
  }

  /// `Sync Stats`
  String get gssExport_synStats {
    return Intl.message(
      'Sync Stats',
      name: 'gssExport_synStats',
      desc: '',
      args: [],
    );
  }

  /// `The following data will be uploaded upon sync.`
  String get gssExport_followingDataWillBeUploaded {
    return Intl.message(
      'The following data will be uploaded upon sync.',
      name: 'gssExport_followingDataWillBeUploaded',
      desc: '',
      args: [],
    );
  }

  /// `GPS Logs:`
  String get gssExport_gpsLogs {
    return Intl.message(
      'GPS Logs:',
      name: 'gssExport_gpsLogs',
      desc: '',
      args: [],
    );
  }

  /// `Simple Notes:`
  String get gssExport_simpleNotes {
    return Intl.message(
      'Simple Notes:',
      name: 'gssExport_simpleNotes',
      desc: '',
      args: [],
    );
  }

  /// `Form Notes:`
  String get gssExport_formNotes {
    return Intl.message(
      'Form Notes:',
      name: 'gssExport_formNotes',
      desc: '',
      args: [],
    );
  }

  /// `Images:`
  String get gssExport_images {
    return Intl.message(
      'Images:',
      name: 'gssExport_images',
      desc: '',
      args: [],
    );
  }

  /// `Should not happen`
  String get gssExport_shouldNotHappen {
    return Intl.message(
      'Should not happen',
      name: 'gssExport_shouldNotHappen',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get gssExport_upload {
    return Intl.message(
      'Upload',
      name: 'gssExport_upload',
      desc: '',
      args: [],
    );
  }

  /// `Geocoding`
  String get geocoding_geocoding {
    return Intl.message(
      'Geocoding',
      name: 'geocoding_geocoding',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to look for. Insert an address.`
  String get geocoding_nothingToLookFor {
    return Intl.message(
      'Nothing to look for. Insert an address.',
      name: 'geocoding_nothingToLookFor',
      desc: '',
      args: [],
    );
  }

  /// `Launch Geocoding`
  String get geocoding_launchGeocoding {
    return Intl.message(
      'Launch Geocoding',
      name: 'geocoding_launchGeocoding',
      desc: '',
      args: [],
    );
  }

  /// `Searching…`
  String get geocoding_searching {
    return Intl.message(
      'Searching…',
      name: 'geocoding_searching',
      desc: '',
      args: [],
    );
  }

  /// `SMASH is active`
  String get gps_smashIsActive {
    return Intl.message(
      'SMASH is active',
      name: 'gps_smashIsActive',
      desc: '',
      args: [],
    );
  }

  /// `SMASH is logging`
  String get gps_smashIsLogging {
    return Intl.message(
      'SMASH is logging',
      name: 'gps_smashIsLogging',
      desc: '',
      args: [],
    );
  }

  /// `Location tracking`
  String get gps_locationTracking {
    return Intl.message(
      'Location tracking',
      name: 'gps_locationTracking',
      desc: '',
      args: [],
    );
  }

  /// `SMASH location service is active.`
  String get gps_smashLocServiceIsActive {
    return Intl.message(
      'SMASH location service is active.',
      name: 'gps_smashLocServiceIsActive',
      desc: '',
      args: [],
    );
  }

  /// `Background location is on to keep the app registering the location even when the app is in background.`
  String get gps_backgroundLocIsOnToKeepRegistering {
    return Intl.message(
      'Background location is on to keep the app registering the location even when the app is in background.',
      name: 'gps_backgroundLocIsOnToKeepRegistering',
      desc: '',
      args: [],
    );
  }

  /// `GSS Import`
  String get gssImport_gssImport {
    return Intl.message(
      'GSS Import',
      name: 'gssImport_gssImport',
      desc: '',
      args: [],
    );
  }

  /// `Downloading data list…`
  String get gssImport_downloadingDataList {
    return Intl.message(
      'Downloading data list…',
      name: 'gssImport_downloadingDataList',
      desc: '',
      args: [],
    );
  }

  /// `Unable to download data list due to an error. Check your settings and the log.`
  String get gssImport_unableDownloadDataList {
    return Intl.message(
      'Unable to download data list due to an error. Check your settings and the log.',
      name: 'gssImport_unableDownloadDataList',
      desc: '',
      args: [],
    );
  }

  /// `No GSS server URL has been set. Check your settings.`
  String get gssImport_noGssUrlSet {
    return Intl.message(
      'No GSS server URL has been set. Check your settings.',
      name: 'gssImport_noGssUrlSet',
      desc: '',
      args: [],
    );
  }

  /// `No GSS server password has been set. Check your settings.`
  String get gssImport_noGssPasswordSet {
    return Intl.message(
      'No GSS server password has been set. Check your settings.',
      name: 'gssImport_noGssPasswordSet',
      desc: '',
      args: [],
    );
  }

  /// `No permission to access the server. Check your credentials.`
  String get gssImport_noPermToAccessServer {
    return Intl.message(
      'No permission to access the server. Check your credentials.',
      name: 'gssImport_noPermToAccessServer',
      desc: '',
      args: [],
    );
  }

  /// `Data`
  String get gssImport_data {
    return Intl.message(
      'Data',
      name: 'gssImport_data',
      desc: '',
      args: [],
    );
  }

  /// `Datasets are downloaded into the maps folder.`
  String get gssImport_dataSetsDownloadedMapsFolder {
    return Intl.message(
      'Datasets are downloaded into the maps folder.',
      name: 'gssImport_dataSetsDownloadedMapsFolder',
      desc: '',
      args: [],
    );
  }

  /// `No data available.`
  String get gssImport_noDataAvailable {
    return Intl.message(
      'No data available.',
      name: 'gssImport_noDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Projects`
  String get gssImport_projects {
    return Intl.message(
      'Projects',
      name: 'gssImport_projects',
      desc: '',
      args: [],
    );
  }

  /// `Projects are downloaded into the projects folder.`
  String get gssImport_projectsDownloadedProjectFolder {
    return Intl.message(
      'Projects are downloaded into the projects folder.',
      name: 'gssImport_projectsDownloadedProjectFolder',
      desc: '',
      args: [],
    );
  }

  /// `No projects available.`
  String get gssImport_noProjectsAvailable {
    return Intl.message(
      'No projects available.',
      name: 'gssImport_noProjectsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Forms`
  String get gssImport_forms {
    return Intl.message(
      'Forms',
      name: 'gssImport_forms',
      desc: '',
      args: [],
    );
  }

  /// `Tags files are downloaded into the forms folder.`
  String get gssImport_tagsDownloadedFormsFolder {
    return Intl.message(
      'Tags files are downloaded into the forms folder.',
      name: 'gssImport_tagsDownloadedFormsFolder',
      desc: '',
      args: [],
    );
  }

  /// `No tags available.`
  String get gssImport_noTagsAvailable {
    return Intl.message(
      'No tags available.',
      name: 'gssImport_noTagsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get importWidget_import {
    return Intl.message(
      'Import',
      name: 'importWidget_import',
      desc: '',
      args: [],
    );
  }

  /// `Import from Geopaparazzi Survey Server`
  String get importWidget_importFromGeopaparazzi {
    return Intl.message(
      'Import from Geopaparazzi Survey Server',
      name: 'importWidget_importFromGeopaparazzi',
      desc: '',
      args: [],
    );
  }

  /// `Layer List`
  String get layersView_layerList {
    return Intl.message(
      'Layer List',
      name: 'layersView_layerList',
      desc: '',
      args: [],
    );
  }

  /// `Load remote database`
  String get layersView_loadRemoteDatabase {
    return Intl.message(
      'Load remote database',
      name: 'layersView_loadRemoteDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Load online sources`
  String get layersView_loadOnlineSources {
    return Intl.message(
      'Load online sources',
      name: 'layersView_loadOnlineSources',
      desc: '',
      args: [],
    );
  }

  /// `Load local datasets`
  String get layersView_loadLocalDatasets {
    return Intl.message(
      'Load local datasets',
      name: 'layersView_loadLocalDatasets',
      desc: '',
      args: [],
    );
  }

  /// `Loading…`
  String get layersView_loading {
    return Intl.message(
      'Loading…',
      name: 'layersView_loading',
      desc: '',
      args: [],
    );
  }

  /// `Zoom to`
  String get layersView_zoomTo {
    return Intl.message(
      'Zoom to',
      name: 'layersView_zoomTo',
      desc: '',
      args: [],
    );
  }

  /// `Properties`
  String get layersView_properties {
    return Intl.message(
      'Properties',
      name: 'layersView_properties',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get layersView_delete {
    return Intl.message(
      'Delete',
      name: 'layersView_delete',
      desc: '',
      args: [],
    );
  }

  /// `The proj could not be recognised. Tap to enter epsg manually.`
  String get layersView_projCouldNotBeRecognized {
    return Intl.message(
      'The proj could not be recognised. Tap to enter epsg manually.',
      name: 'layersView_projCouldNotBeRecognized',
      desc: '',
      args: [],
    );
  }

  /// `The proj is not supported. Tap to solve.`
  String get layersView_projNotSupported {
    return Intl.message(
      'The proj is not supported. Tap to solve.',
      name: 'layersView_projNotSupported',
      desc: '',
      args: [],
    );
  }

  /// `Only image files with world file definition are supported.`
  String get layersView_onlyImageFilesWithWorldDef {
    return Intl.message(
      'Only image files with world file definition are supported.',
      name: 'layersView_onlyImageFilesWithWorldDef',
      desc: '',
      args: [],
    );
  }

  /// `Only image files with prj file definition are supported.`
  String get layersView_onlyImageFileWithPrjDef {
    return Intl.message(
      'Only image files with prj file definition are supported.',
      name: 'layersView_onlyImageFileWithPrjDef',
      desc: '',
      args: [],
    );
  }

  /// `Select table to load.`
  String get layersView_selectTableToLoad {
    return Intl.message(
      'Select table to load.',
      name: 'layersView_selectTableToLoad',
      desc: '',
      args: [],
    );
  }

  /// `File format not supported.`
  String get layersView_fileFormatNotSUpported {
    return Intl.message(
      'File format not supported.',
      name: 'layersView_fileFormatNotSUpported',
      desc: '',
      args: [],
    );
  }

  /// `Online Sources Catalog`
  String get onlineSourcesPage_onlineSourcesCatalog {
    return Intl.message(
      'Online Sources Catalog',
      name: 'onlineSourcesPage_onlineSourcesCatalog',
      desc: '',
      args: [],
    );
  }

  /// `Loading TMS layers…`
  String get onlineSourcesPage_loadingTmsLayers {
    return Intl.message(
      'Loading TMS layers…',
      name: 'onlineSourcesPage_loadingTmsLayers',
      desc: '',
      args: [],
    );
  }

  /// `Loading WMS layers…`
  String get onlineSourcesPage_loadingWmsLayers {
    return Intl.message(
      'Loading WMS layers…',
      name: 'onlineSourcesPage_loadingWmsLayers',
      desc: '',
      args: [],
    );
  }

  /// `Import from file`
  String get onlineSourcesPage_importFromFile {
    return Intl.message(
      'Import from file',
      name: 'onlineSourcesPage_importFromFile',
      desc: '',
      args: [],
    );
  }

  /// `The file`
  String get onlineSourcesPage_theFile {
    return Intl.message(
      'The file',
      name: 'onlineSourcesPage_theFile',
      desc: '',
      args: [],
    );
  }

  /// `doesn't exist`
  String get onlineSourcesPage_doesntExist {
    return Intl.message(
      'doesn\'t exist',
      name: 'onlineSourcesPage_doesntExist',
      desc: '',
      args: [],
    );
  }

  /// `Online sources imported.`
  String get onlineSourcesPage_onlineSourcesImported {
    return Intl.message(
      'Online sources imported.',
      name: 'onlineSourcesPage_onlineSourcesImported',
      desc: '',
      args: [],
    );
  }

  /// `Export to file`
  String get onlineSourcesPage_exportToFile {
    return Intl.message(
      'Export to file',
      name: 'onlineSourcesPage_exportToFile',
      desc: '',
      args: [],
    );
  }

  /// `Exported to:`
  String get onlineSourcesPage_exportedTo {
    return Intl.message(
      'Exported to:',
      name: 'onlineSourcesPage_exportedTo',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get onlineSourcesPage_delete {
    return Intl.message(
      'Delete',
      name: 'onlineSourcesPage_delete',
      desc: '',
      args: [],
    );
  }

  /// `Add to layers`
  String get onlineSourcesPage_addToLayers {
    return Intl.message(
      'Add to layers',
      name: 'onlineSourcesPage_addToLayers',
      desc: '',
      args: [],
    );
  }

  /// `Set a name for the TMS service`
  String get onlineSourcesPage_setNameTmsService {
    return Intl.message(
      'Set a name for the TMS service',
      name: 'onlineSourcesPage_setNameTmsService',
      desc: '',
      args: [],
    );
  }

  /// `enter name`
  String get onlineSourcesPage_enterName {
    return Intl.message(
      'enter name',
      name: 'onlineSourcesPage_enterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid name`
  String get onlineSourcesPage_pleaseEnterValidName {
    return Intl.message(
      'Please enter a valid name',
      name: 'onlineSourcesPage_pleaseEnterValidName',
      desc: '',
      args: [],
    );
  }

  /// `Insert the URL of the service.`
  String get onlineSourcesPage_insertUrlOfService {
    return Intl.message(
      'Insert the URL of the service.',
      name: 'onlineSourcesPage_insertUrlOfService',
      desc: '',
      args: [],
    );
  }

  /// `Place the x, y, z between curly brackets.`
  String get onlineSourcesPage_placeXyzBetBrackets {
    return Intl.message(
      'Place the x, y, z between curly brackets.',
      name: 'onlineSourcesPage_placeXyzBetBrackets',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid TMS URL`
  String get onlineSourcesPage_pleaseEnterValidTmsUrl {
    return Intl.message(
      'Please enter a valid TMS URL',
      name: 'onlineSourcesPage_pleaseEnterValidTmsUrl',
      desc: '',
      args: [],
    );
  }

  /// `enter URL`
  String get onlineSourcesPage_enterUrl {
    return Intl.message(
      'enter URL',
      name: 'onlineSourcesPage_enterUrl',
      desc: '',
      args: [],
    );
  }

  /// `enter subdomains`
  String get onlineSourcesPage_enterSubDomains {
    return Intl.message(
      'enter subdomains',
      name: 'onlineSourcesPage_enterSubDomains',
      desc: '',
      args: [],
    );
  }

  /// `Add an attribution.`
  String get onlineSourcesPage_addAttribution {
    return Intl.message(
      'Add an attribution.',
      name: 'onlineSourcesPage_addAttribution',
      desc: '',
      args: [],
    );
  }

  /// `enter attribution`
  String get onlineSourcesPage_enterAttribution {
    return Intl.message(
      'enter attribution',
      name: 'onlineSourcesPage_enterAttribution',
      desc: '',
      args: [],
    );
  }

  /// `Set min and max zoom.`
  String get onlineSourcesPage_setMinMaxZoom {
    return Intl.message(
      'Set min and max zoom.',
      name: 'onlineSourcesPage_setMinMaxZoom',
      desc: '',
      args: [],
    );
  }

  /// `Min zoom`
  String get onlineSourcesPage_minZoom {
    return Intl.message(
      'Min zoom',
      name: 'onlineSourcesPage_minZoom',
      desc: '',
      args: [],
    );
  }

  /// `Max zoom`
  String get onlineSourcesPage_maxZoom {
    return Intl.message(
      'Max zoom',
      name: 'onlineSourcesPage_maxZoom',
      desc: '',
      args: [],
    );
  }

  /// `Please check your data`
  String get onlineSourcesPage_pleaseCheckYourData {
    return Intl.message(
      'Please check your data',
      name: 'onlineSourcesPage_pleaseCheckYourData',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get onlineSourcesPage_details {
    return Intl.message(
      'Details',
      name: 'onlineSourcesPage_details',
      desc: '',
      args: [],
    );
  }

  /// `Name: `
  String get onlineSourcesPage_name {
    return Intl.message(
      'Name: ',
      name: 'onlineSourcesPage_name',
      desc: '',
      args: [],
    );
  }

  /// `Subdomains: `
  String get onlineSourcesPage_subDomains {
    return Intl.message(
      'Subdomains: ',
      name: 'onlineSourcesPage_subDomains',
      desc: '',
      args: [],
    );
  }

  /// `Attribution: `
  String get onlineSourcesPage_attribution {
    return Intl.message(
      'Attribution: ',
      name: 'onlineSourcesPage_attribution',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get onlineSourcesPage_cancel {
    return Intl.message(
      'Cancel',
      name: 'onlineSourcesPage_cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get onlineSourcesPage_ok {
    return Intl.message(
      'OK',
      name: 'onlineSourcesPage_ok',
      desc: '',
      args: [],
    );
  }

  /// `New TMS Online Service`
  String get onlineSourcesPage_newTmsOnlineService {
    return Intl.message(
      'New TMS Online Service',
      name: 'onlineSourcesPage_newTmsOnlineService',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get onlineSourcesPage_save {
    return Intl.message(
      'Save',
      name: 'onlineSourcesPage_save',
      desc: '',
      args: [],
    );
  }

  /// `The base URL-ending with question mark.`
  String get onlineSourcesPage_theBaseUrlWithQuestionMark {
    return Intl.message(
      'The base URL-ending with question mark.',
      name: 'onlineSourcesPage_theBaseUrlWithQuestionMark',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid WMS URL`
  String get onlineSourcesPage_pleaseEnterValidWmsUrl {
    return Intl.message(
      'Please enter a valid WMS URL',
      name: 'onlineSourcesPage_pleaseEnterValidWmsUrl',
      desc: '',
      args: [],
    );
  }

  /// `Set WMS layer name`
  String get onlineSourcesPage_setWmsLayerName {
    return Intl.message(
      'Set WMS layer name',
      name: 'onlineSourcesPage_setWmsLayerName',
      desc: '',
      args: [],
    );
  }

  /// `enter layer to load`
  String get onlineSourcesPage_enterLayerToLoad {
    return Intl.message(
      'enter layer to load',
      name: 'onlineSourcesPage_enterLayerToLoad',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid layer`
  String get onlineSourcesPage_pleaseEnterValidLayer {
    return Intl.message(
      'Please enter a valid layer',
      name: 'onlineSourcesPage_pleaseEnterValidLayer',
      desc: '',
      args: [],
    );
  }

  /// `Set WMS image format`
  String get onlineSourcesPage_setWmsImageFormat {
    return Intl.message(
      'Set WMS image format',
      name: 'onlineSourcesPage_setWmsImageFormat',
      desc: '',
      args: [],
    );
  }

  /// `Add an attribution.`
  String get onlineSourcesPage_addAnAttribution {
    return Intl.message(
      'Add an attribution.',
      name: 'onlineSourcesPage_addAnAttribution',
      desc: '',
      args: [],
    );
  }

  /// `Layer: `
  String get onlineSourcesPage_layer {
    return Intl.message(
      'Layer: ',
      name: 'onlineSourcesPage_layer',
      desc: '',
      args: [],
    );
  }

  /// `URL: `
  String get onlineSourcesPage_url {
    return Intl.message(
      'URL: ',
      name: 'onlineSourcesPage_url',
      desc: '',
      args: [],
    );
  }

  /// `Format`
  String get onlineSourcesPage_format {
    return Intl.message(
      'Format',
      name: 'onlineSourcesPage_format',
      desc: '',
      args: [],
    );
  }

  /// `New WMS Online Service`
  String get onlineSourcesPage_newWmsOnlineService {
    return Intl.message(
      'New WMS Online Service',
      name: 'onlineSourcesPage_newWmsOnlineService',
      desc: '',
      args: [],
    );
  }

  /// `Remote Databases`
  String get remoteDbPage_remoteDatabases {
    return Intl.message(
      'Remote Databases',
      name: 'remoteDbPage_remoteDatabases',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get remoteDbPage_delete {
    return Intl.message(
      'Delete',
      name: 'remoteDbPage_delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete the database configuration?`
  String get remoteDbPage_areYouSureDeleteDatabase {
    return Intl.message(
      'Delete the database configuration?',
      name: 'remoteDbPage_areYouSureDeleteDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get remoteDbPage_edit {
    return Intl.message(
      'Edit',
      name: 'remoteDbPage_edit',
      desc: '',
      args: [],
    );
  }

  /// `table`
  String get remoteDbPage_table {
    return Intl.message(
      'table',
      name: 'remoteDbPage_table',
      desc: '',
      args: [],
    );
  }

  /// `user`
  String get remoteDbPage_user {
    return Intl.message(
      'user',
      name: 'remoteDbPage_user',
      desc: '',
      args: [],
    );
  }

  /// `Load in map.`
  String get remoteDbPage_loadInMap {
    return Intl.message(
      'Load in map.',
      name: 'remoteDbPage_loadInMap',
      desc: '',
      args: [],
    );
  }

  /// `Database Parameters`
  String get remoteDbPage_databaseParameters {
    return Intl.message(
      'Database Parameters',
      name: 'remoteDbPage_databaseParameters',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get remoteDbPage_cancel {
    return Intl.message(
      'Cancel',
      name: 'remoteDbPage_cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get remoteDbPage_ok {
    return Intl.message(
      'OK',
      name: 'remoteDbPage_ok',
      desc: '',
      args: [],
    );
  }

  /// `The URL must be defined (postgis:host:port/databasename)`
  String get remoteDbPage_theUrlNeedsToBeDefined {
    return Intl.message(
      'The URL must be defined (postgis:host:port/databasename)',
      name: 'remoteDbPage_theUrlNeedsToBeDefined',
      desc: '',
      args: [],
    );
  }

  /// `A user must be defined.`
  String get remoteDbPage_theUserNeedsToBeDefined {
    return Intl.message(
      'A user must be defined.',
      name: 'remoteDbPage_theUserNeedsToBeDefined',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get remoteDbPage_password {
    return Intl.message(
      'password',
      name: 'remoteDbPage_password',
      desc: '',
      args: [],
    );
  }

  /// `A password must be defined.`
  String get remoteDbPage_thePasswordNeedsToBeDefined {
    return Intl.message(
      'A password must be defined.',
      name: 'remoteDbPage_thePasswordNeedsToBeDefined',
      desc: '',
      args: [],
    );
  }

  /// `Loading tables…`
  String get remoteDbPage_loadingTables {
    return Intl.message(
      'Loading tables…',
      name: 'remoteDbPage_loadingTables',
      desc: '',
      args: [],
    );
  }

  /// `The table name must be defined.`
  String get remoteDbPage_theTableNeedsToBeDefined {
    return Intl.message(
      'The table name must be defined.',
      name: 'remoteDbPage_theTableNeedsToBeDefined',
      desc: '',
      args: [],
    );
  }

  /// `Unable to connect to the database. Check parameters and network.`
  String get remoteDbPage_unableToConnectToDatabase {
    return Intl.message(
      'Unable to connect to the database. Check parameters and network.',
      name: 'remoteDbPage_unableToConnectToDatabase',
      desc: '',
      args: [],
    );
  }

  /// `optional "where" condition`
  String get remoteDbPage_optionalWhereCondition {
    return Intl.message(
      'optional "where" condition',
      name: 'remoteDbPage_optionalWhereCondition',
      desc: '',
      args: [],
    );
  }

  /// `TIFF Properties`
  String get geoImage_tiffProperties {
    return Intl.message(
      'TIFF Properties',
      name: 'geoImage_tiffProperties',
      desc: '',
      args: [],
    );
  }

  /// `Opacity`
  String get geoImage_opacity {
    return Intl.message(
      'Opacity',
      name: 'geoImage_opacity',
      desc: '',
      args: [],
    );
  }

  /// `Color to hide`
  String get geoImage_colorToHide {
    return Intl.message(
      'Color to hide',
      name: 'geoImage_colorToHide',
      desc: '',
      args: [],
    );
  }

  /// `GPX Properties`
  String get gpx_gpxProperties {
    return Intl.message(
      'GPX Properties',
      name: 'gpx_gpxProperties',
      desc: '',
      args: [],
    );
  }

  /// `Waypoints`
  String get gpx_wayPoints {
    return Intl.message(
      'Waypoints',
      name: 'gpx_wayPoints',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get gpx_color {
    return Intl.message(
      'Color',
      name: 'gpx_color',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get gpx_size {
    return Intl.message(
      'Size',
      name: 'gpx_size',
      desc: '',
      args: [],
    );
  }

  /// `View labels if available?`
  String get gpx_viewLabelsIfAvailable {
    return Intl.message(
      'View labels if available?',
      name: 'gpx_viewLabelsIfAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Tracks/routes`
  String get gpx_tracksRoutes {
    return Intl.message(
      'Tracks/routes',
      name: 'gpx_tracksRoutes',
      desc: '',
      args: [],
    );
  }

  /// `Width`
  String get gpx_width {
    return Intl.message(
      'Width',
      name: 'gpx_width',
      desc: '',
      args: [],
    );
  }

  /// `Palette`
  String get gpx_palette {
    return Intl.message(
      'Palette',
      name: 'gpx_palette',
      desc: '',
      args: [],
    );
  }

  /// `Tile Properties`
  String get tiles_tileProperties {
    return Intl.message(
      'Tile Properties',
      name: 'tiles_tileProperties',
      desc: '',
      args: [],
    );
  }

  /// `Opacity`
  String get tiles_opacity {
    return Intl.message(
      'Opacity',
      name: 'tiles_opacity',
      desc: '',
      args: [],
    );
  }

  /// `Load geopackage tiles as overlay image as opposed to tile layer (best for gdal generated data and different projections).`
  String get tiles_loadGeoPackageAsOverlay {
    return Intl.message(
      'Load geopackage tiles as overlay image as opposed to tile layer (best for gdal generated data and different projections).',
      name: 'tiles_loadGeoPackageAsOverlay',
      desc: '',
      args: [],
    );
  }

  /// `Color to hide`
  String get tiles_colorToHide {
    return Intl.message(
      'Color to hide',
      name: 'tiles_colorToHide',
      desc: '',
      args: [],
    );
  }

  /// `WMS Properties`
  String get wms_wmsProperties {
    return Intl.message(
      'WMS Properties',
      name: 'wms_wmsProperties',
      desc: '',
      args: [],
    );
  }

  /// `Opacity`
  String get wms_opacity {
    return Intl.message(
      'Opacity',
      name: 'wms_opacity',
      desc: '',
      args: [],
    );
  }

  /// `Loading data…`
  String get featureAttributesViewer_loadingData {
    return Intl.message(
      'Loading data…',
      name: 'featureAttributesViewer_loadingData',
      desc: '',
      args: [],
    );
  }

  /// `Set new value`
  String get featureAttributesViewer_setNewValue {
    return Intl.message(
      'Set new value',
      name: 'featureAttributesViewer_setNewValue',
      desc: '',
      args: [],
    );
  }

  /// `Field`
  String get featureAttributesViewer_field {
    return Intl.message(
      'Field',
      name: 'featureAttributesViewer_field',
      desc: '',
      args: [],
    );
  }

  /// `VALUE`
  String get featureAttributesViewer_value {
    return Intl.message(
      'VALUE',
      name: 'featureAttributesViewer_value',
      desc: '',
      args: [],
    );
  }

  /// `Projects View`
  String get projectsView_projectsView {
    return Intl.message(
      'Projects View',
      name: 'projectsView_projectsView',
      desc: '',
      args: [],
    );
  }

  /// `Open an existing project`
  String get projectsView_openExistingProject {
    return Intl.message(
      'Open an existing project',
      name: 'projectsView_openExistingProject',
      desc: '',
      args: [],
    );
  }

  /// `Create a new project`
  String get projectsView_createNewProject {
    return Intl.message(
      'Create a new project',
      name: 'projectsView_createNewProject',
      desc: '',
      args: [],
    );
  }

  /// `Recent projects`
  String get projectsView_recentProjects {
    return Intl.message(
      'Recent projects',
      name: 'projectsView_recentProjects',
      desc: '',
      args: [],
    );
  }

  /// `New Project`
  String get projectsView_newProject {
    return Intl.message(
      'New Project',
      name: 'projectsView_newProject',
      desc: '',
      args: [],
    );
  }

  /// `Enter a name for the new project or accept the proposed.`
  String get projectsView_enterNameForNewProject {
    return Intl.message(
      'Enter a name for the new project or accept the proposed.',
      name: 'projectsView_enterNameForNewProject',
      desc: '',
      args: [],
    );
  }

  /// `note`
  String get dataLoader_note {
    return Intl.message(
      'note',
      name: 'dataLoader_note',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get dataLoader_Note {
    return Intl.message(
      'Note',
      name: 'dataLoader_Note',
      desc: '',
      args: [],
    );
  }

  /// `Has Form`
  String get dataLoader_hasForm {
    return Intl.message(
      'Has Form',
      name: 'dataLoader_hasForm',
      desc: '',
      args: [],
    );
  }

  /// `POI`
  String get dataLoader_POI {
    return Intl.message(
      'POI',
      name: 'dataLoader_POI',
      desc: '',
      args: [],
    );
  }

  /// `Saving image to database…`
  String get dataLoader_savingImageToDB {
    return Intl.message(
      'Saving image to database…',
      name: 'dataLoader_savingImageToDB',
      desc: '',
      args: [],
    );
  }

  /// `Remove Note`
  String get dataLoader_removeNote {
    return Intl.message(
      'Remove Note',
      name: 'dataLoader_removeNote',
      desc: '',
      args: [],
    );
  }

  /// `Remove note?`
  String get dataLoader_areYouSureRemoveNote {
    return Intl.message(
      'Remove note?',
      name: 'dataLoader_areYouSureRemoveNote',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get dataLoader_image {
    return Intl.message(
      'Image',
      name: 'dataLoader_image',
      desc: '',
      args: [],
    );
  }

  /// `Longitude`
  String get dataLoader_longitude {
    return Intl.message(
      'Longitude',
      name: 'dataLoader_longitude',
      desc: '',
      args: [],
    );
  }

  /// `Latitude`
  String get dataLoader_latitude {
    return Intl.message(
      'Latitude',
      name: 'dataLoader_latitude',
      desc: '',
      args: [],
    );
  }

  /// `Altitude`
  String get dataLoader_altitude {
    return Intl.message(
      'Altitude',
      name: 'dataLoader_altitude',
      desc: '',
      args: [],
    );
  }

  /// `Timestamp`
  String get dataLoader_timestamp {
    return Intl.message(
      'Timestamp',
      name: 'dataLoader_timestamp',
      desc: '',
      args: [],
    );
  }

  /// `Remove Image`
  String get dataLoader_removeImage {
    return Intl.message(
      'Remove Image',
      name: 'dataLoader_removeImage',
      desc: '',
      args: [],
    );
  }

  /// `Remove the image?`
  String get dataLoader_areYouSureRemoveImage {
    return Intl.message(
      'Remove the image?',
      name: 'dataLoader_areYouSureRemoveImage',
      desc: '',
      args: [],
    );
  }

  /// `Loading image…`
  String get images_loadingImage {
    return Intl.message(
      'Loading image…',
      name: 'images_loadingImage',
      desc: '',
      args: [],
    );
  }

  /// `Loading info…`
  String get about_loadingInformation {
    return Intl.message(
      'Loading info…',
      name: 'about_loadingInformation',
      desc: '',
      args: [],
    );
  }

  /// `About `
  String get about_ABOUT {
    return Intl.message(
      'About ',
      name: 'about_ABOUT',
      desc: '',
      args: [],
    );
  }

  /// `Smart Mobile App for Surveyor Happiness`
  String get about_smartMobileAppForSurveyor {
    return Intl.message(
      'Smart Mobile App for Surveyor Happiness',
      name: 'about_smartMobileAppForSurveyor',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get about_applicationVersion {
    return Intl.message(
      'Version',
      name: 'about_applicationVersion',
      desc: '',
      args: [],
    );
  }

  /// `License`
  String get about_license {
    return Intl.message(
      'License',
      name: 'about_license',
      desc: '',
      args: [],
    );
  }

  /// ` is copylefted libre software, licensed GPLv3+.`
  String get about_isAvailableUnderGPL3 {
    return Intl.message(
      ' is copylefted libre software, licensed GPLv3+.',
      name: 'about_isAvailableUnderGPL3',
      desc: '',
      args: [],
    );
  }

  /// `Source Code`
  String get about_sourceCode {
    return Intl.message(
      'Source Code',
      name: 'about_sourceCode',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to visit the source code repository`
  String get about_tapHereToVisitRepo {
    return Intl.message(
      'Tap here to visit the source code repository',
      name: 'about_tapHereToVisitRepo',
      desc: '',
      args: [],
    );
  }

  /// `Legal Info`
  String get about_legalInformation {
    return Intl.message(
      'Legal Info',
      name: 'about_legalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Copyright © 2020, HydroloGIS S.r.l. — some rights reserved. Tap to visit.`
  String get about_copyright2020HydroloGIS {
    return Intl.message(
      'Copyright © 2020, HydroloGIS S.r.l. — some rights reserved. Tap to visit.',
      name: 'about_copyright2020HydroloGIS',
      desc: '',
      args: [],
    );
  }

  /// `Supported by`
  String get about_supportedBy {
    return Intl.message(
      'Supported by',
      name: 'about_supportedBy',
      desc: '',
      args: [],
    );
  }

  /// `Partially supported by the project Steep Stream of the University of Trento.`
  String get about_partiallySupportedByUniversityTrento {
    return Intl.message(
      'Partially supported by the project Steep Stream of the University of Trento.',
      name: 'about_partiallySupportedByUniversityTrento',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get about_privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'about_privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to see the privacy policy that covers user and location data.`
  String get about_tapHereToSeePrivacyPolicy {
    return Intl.message(
      'Tap here to see the privacy policy that covers user and location data.',
      name: 'about_tapHereToSeePrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `No GPS info available…`
  String get gpsInfoButton_noGpsInfoAvailable {
    return Intl.message(
      'No GPS info available…',
      name: 'gpsInfoButton_noGpsInfoAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Timestamp`
  String get gpsInfoButton_timestamp {
    return Intl.message(
      'Timestamp',
      name: 'gpsInfoButton_timestamp',
      desc: '',
      args: [],
    );
  }

  /// `Speed`
  String get gpsInfoButton_speed {
    return Intl.message(
      'Speed',
      name: 'gpsInfoButton_speed',
      desc: '',
      args: [],
    );
  }

  /// `Heading`
  String get gpsInfoButton_heading {
    return Intl.message(
      'Heading',
      name: 'gpsInfoButton_heading',
      desc: '',
      args: [],
    );
  }

  /// `Accuracy`
  String get gpsInfoButton_accuracy {
    return Intl.message(
      'Accuracy',
      name: 'gpsInfoButton_accuracy',
      desc: '',
      args: [],
    );
  }

  /// `Altitude`
  String get gpsInfoButton_altitude {
    return Intl.message(
      'Altitude',
      name: 'gpsInfoButton_altitude',
      desc: '',
      args: [],
    );
  }

  /// `Latitude`
  String get gpsInfoButton_latitude {
    return Intl.message(
      'Latitude',
      name: 'gpsInfoButton_latitude',
      desc: '',
      args: [],
    );
  }

  /// `Copy latitude to clipboard.`
  String get gpsInfoButton_copyLatitudeToClipboard {
    return Intl.message(
      'Copy latitude to clipboard.',
      name: 'gpsInfoButton_copyLatitudeToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Longitude`
  String get gpsInfoButton_longitude {
    return Intl.message(
      'Longitude',
      name: 'gpsInfoButton_longitude',
      desc: '',
      args: [],
    );
  }

  /// `Copy longitude to clipboard.`
  String get gpsInfoButton_copyLongitudeToClipboard {
    return Intl.message(
      'Copy longitude to clipboard.',
      name: 'gpsInfoButton_copyLongitudeToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Stop Logging?`
  String get gpsLogButton_stopLogging {
    return Intl.message(
      'Stop Logging?',
      name: 'gpsLogButton_stopLogging',
      desc: '',
      args: [],
    );
  }

  /// `Stop logging and close the current GPS log?`
  String get gpsLogButton_stopLoggingAndCloseLog {
    return Intl.message(
      'Stop logging and close the current GPS log?',
      name: 'gpsLogButton_stopLoggingAndCloseLog',
      desc: '',
      args: [],
    );
  }

  /// `New Log`
  String get gpsLogButton_newLog {
    return Intl.message(
      'New Log',
      name: 'gpsLogButton_newLog',
      desc: '',
      args: [],
    );
  }

  /// `Enter a name for the new log`
  String get gpsLogButton_enterNameForNewLog {
    return Intl.message(
      'Enter a name for the new log',
      name: 'gpsLogButton_enterNameForNewLog',
      desc: '',
      args: [],
    );
  }

  /// `Could not start logging: `
  String get gpsLogButton_couldNotStartLogging {
    return Intl.message(
      'Could not start logging: ',
      name: 'gpsLogButton_couldNotStartLogging',
      desc: '',
      args: [],
    );
  }

  /// `Loading image…`
  String get imageWidgets_loadingImage {
    return Intl.message(
      'Loading image…',
      name: 'imageWidgets_loadingImage',
      desc: '',
      args: [],
    );
  }

  /// `GPS Logs list`
  String get logList_gpsLogsList {
    return Intl.message(
      'GPS Logs list',
      name: 'logList_gpsLogsList',
      desc: '',
      args: [],
    );
  }

  /// `Select all`
  String get logList_selectAll {
    return Intl.message(
      'Select all',
      name: 'logList_selectAll',
      desc: '',
      args: [],
    );
  }

  /// `Unselect all`
  String get logList_unSelectAll {
    return Intl.message(
      'Unselect all',
      name: 'logList_unSelectAll',
      desc: '',
      args: [],
    );
  }

  /// `Invert selection`
  String get logList_invertSelection {
    return Intl.message(
      'Invert selection',
      name: 'logList_invertSelection',
      desc: '',
      args: [],
    );
  }

  /// `Merge selected`
  String get logList_mergeSelected {
    return Intl.message(
      'Merge selected',
      name: 'logList_mergeSelected',
      desc: '',
      args: [],
    );
  }

  /// `Loading logs…`
  String get logList_loadingLogs {
    return Intl.message(
      'Loading logs…',
      name: 'logList_loadingLogs',
      desc: '',
      args: [],
    );
  }

  /// `Zoom to`
  String get logList_zoomTo {
    return Intl.message(
      'Zoom to',
      name: 'logList_zoomTo',
      desc: '',
      args: [],
    );
  }

  /// `Properties`
  String get logList_properties {
    return Intl.message(
      'Properties',
      name: 'logList_properties',
      desc: '',
      args: [],
    );
  }

  /// `Profile View`
  String get logList_profileView {
    return Intl.message(
      'Profile View',
      name: 'logList_profileView',
      desc: '',
      args: [],
    );
  }

  /// `To GPX`
  String get logList_toGPX {
    return Intl.message(
      'To GPX',
      name: 'logList_toGPX',
      desc: '',
      args: [],
    );
  }

  /// `GPX saved in export folder.`
  String get logList_gpsSavedInExportFolder {
    return Intl.message(
      'GPX saved in export folder.',
      name: 'logList_gpsSavedInExportFolder',
      desc: '',
      args: [],
    );
  }

  /// `Could not export log to GPX.`
  String get logList_errorOccurredExportingLogGPX {
    return Intl.message(
      'Could not export log to GPX.',
      name: 'logList_errorOccurredExportingLogGPX',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get logList_delete {
    return Intl.message(
      'Delete',
      name: 'logList_delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get logList_DELETE {
    return Intl.message(
      'Delete',
      name: 'logList_DELETE',
      desc: '',
      args: [],
    );
  }

  /// `Delete the log?`
  String get logList_areYouSureDeleteTheLog {
    return Intl.message(
      'Delete the log?',
      name: 'logList_areYouSureDeleteTheLog',
      desc: '',
      args: [],
    );
  }

  /// `hours`
  String get logList_hours {
    return Intl.message(
      'hours',
      name: 'logList_hours',
      desc: '',
      args: [],
    );
  }

  /// `hour`
  String get logList_hour {
    return Intl.message(
      'hour',
      name: 'logList_hour',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get logList_minutes {
    return Intl.message(
      'min',
      name: 'logList_minutes',
      desc: '',
      args: [],
    );
  }

  /// `GPS Log Properties`
  String get logProperties_gpsLogProperties {
    return Intl.message(
      'GPS Log Properties',
      name: 'logProperties_gpsLogProperties',
      desc: '',
      args: [],
    );
  }

  /// `Log Name`
  String get logProperties_logName {
    return Intl.message(
      'Log Name',
      name: 'logProperties_logName',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get logProperties_start {
    return Intl.message(
      'Start',
      name: 'logProperties_start',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get logProperties_end {
    return Intl.message(
      'End',
      name: 'logProperties_end',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get logProperties_duration {
    return Intl.message(
      'Duration',
      name: 'logProperties_duration',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get logProperties_color {
    return Intl.message(
      'Color',
      name: 'logProperties_color',
      desc: '',
      args: [],
    );
  }

  /// `Palette`
  String get logProperties_palette {
    return Intl.message(
      'Palette',
      name: 'logProperties_palette',
      desc: '',
      args: [],
    );
  }

  /// `Width`
  String get logProperties_width {
    return Intl.message(
      'Width',
      name: 'logProperties_width',
      desc: '',
      args: [],
    );
  }

  /// `Distance at position:`
  String get logProperties_distanceAtPosition {
    return Intl.message(
      'Distance at position:',
      name: 'logProperties_distanceAtPosition',
      desc: '',
      args: [],
    );
  }

  /// `Total distance:`
  String get logProperties_totalDistance {
    return Intl.message(
      'Total distance:',
      name: 'logProperties_totalDistance',
      desc: '',
      args: [],
    );
  }

  /// `GPS Log View`
  String get logProperties_gpsLogView {
    return Intl.message(
      'GPS Log View',
      name: 'logProperties_gpsLogView',
      desc: '',
      args: [],
    );
  }

  /// `Turn off stats`
  String get logProperties_disableStats {
    return Intl.message(
      'Turn off stats',
      name: 'logProperties_disableStats',
      desc: '',
      args: [],
    );
  }

  /// `Turn on stats`
  String get logProperties_enableStats {
    return Intl.message(
      'Turn on stats',
      name: 'logProperties_enableStats',
      desc: '',
      args: [],
    );
  }

  /// `Total duration:`
  String get logProperties_totalDuration {
    return Intl.message(
      'Total duration:',
      name: 'logProperties_totalDuration',
      desc: '',
      args: [],
    );
  }

  /// `Timestamp:`
  String get logProperties_timestamp {
    return Intl.message(
      'Timestamp:',
      name: 'logProperties_timestamp',
      desc: '',
      args: [],
    );
  }

  /// `Duration at position:`
  String get logProperties_durationAtPosition {
    return Intl.message(
      'Duration at position:',
      name: 'logProperties_durationAtPosition',
      desc: '',
      args: [],
    );
  }

  /// `Speed:`
  String get logProperties_speed {
    return Intl.message(
      'Speed:',
      name: 'logProperties_speed',
      desc: '',
      args: [],
    );
  }

  /// `Elevation:`
  String get logProperties_elevation {
    return Intl.message(
      'Elevation:',
      name: 'logProperties_elevation',
      desc: '',
      args: [],
    );
  }

  /// `Simple List of Notes`
  String get noteList_simpleNotesList {
    return Intl.message(
      'Simple List of Notes',
      name: 'noteList_simpleNotesList',
      desc: '',
      args: [],
    );
  }

  /// `List of Form Notes`
  String get noteList_formNotesList {
    return Intl.message(
      'List of Form Notes',
      name: 'noteList_formNotesList',
      desc: '',
      args: [],
    );
  }

  /// `Loading notes…`
  String get noteList_loadingNotes {
    return Intl.message(
      'Loading notes…',
      name: 'noteList_loadingNotes',
      desc: '',
      args: [],
    );
  }

  /// `Zoom to`
  String get noteList_zoomTo {
    return Intl.message(
      'Zoom to',
      name: 'noteList_zoomTo',
      desc: '',
      args: [],
    );
  }

  /// `'Edit'`
  String get noteList_edit {
    return Intl.message(
      '\'Edit\'',
      name: 'noteList_edit',
      desc: '',
      args: [],
    );
  }

  /// `Properties`
  String get noteList_properties {
    return Intl.message(
      'Properties',
      name: 'noteList_properties',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get noteList_delete {
    return Intl.message(
      'Delete',
      name: 'noteList_delete',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get noteList_DELETE {
    return Intl.message(
      'Delete',
      name: 'noteList_DELETE',
      desc: '',
      args: [],
    );
  }

  /// `Delete the note?`
  String get noteList_areYouSureDeleteNote {
    return Intl.message(
      'Delete the note?',
      name: 'noteList_areYouSureDeleteNote',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_settings {
    return Intl.message(
      'Settings',
      name: 'settings_settings',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get settings_camera {
    return Intl.message(
      'Camera',
      name: 'settings_camera',
      desc: '',
      args: [],
    );
  }

  /// `Camera Resolution`
  String get settings_cameraResolution {
    return Intl.message(
      'Camera Resolution',
      name: 'settings_cameraResolution',
      desc: '',
      args: [],
    );
  }

  /// `Resolution`
  String get settings_resolution {
    return Intl.message(
      'Resolution',
      name: 'settings_resolution',
      desc: '',
      args: [],
    );
  }

  /// `The camera resolution`
  String get settings_theCameraResolution {
    return Intl.message(
      'The camera resolution',
      name: 'settings_theCameraResolution',
      desc: '',
      args: [],
    );
  }

  /// `Screen`
  String get settings_screen {
    return Intl.message(
      'Screen',
      name: 'settings_screen',
      desc: '',
      args: [],
    );
  }

  /// `Screen, Scalebar and Icon Size`
  String get settings_screenScaleBarIconSize {
    return Intl.message(
      'Screen, Scalebar and Icon Size',
      name: 'settings_screenScaleBarIconSize',
      desc: '',
      args: [],
    );
  }

  /// `Keep Screen On`
  String get settings_keepScreenOn {
    return Intl.message(
      'Keep Screen On',
      name: 'settings_keepScreenOn',
      desc: '',
      args: [],
    );
  }

  /// `HiDPI screen-mode`
  String get settings_retinaScreenMode {
    return Intl.message(
      'HiDPI screen-mode',
      name: 'settings_retinaScreenMode',
      desc: '',
      args: [],
    );
  }

  /// `Enter and exit the layer view to apply this setting.`
  String get settings_toApplySettingEnterExitLayerView {
    return Intl.message(
      'Enter and exit the layer view to apply this setting.',
      name: 'settings_toApplySettingEnterExitLayerView',
      desc: '',
      args: [],
    );
  }

  /// `Color Picker to use`
  String get settings_colorPickerToUse {
    return Intl.message(
      'Color Picker to use',
      name: 'settings_colorPickerToUse',
      desc: '',
      args: [],
    );
  }

  /// `Map Center Cross`
  String get settings_mapCenterCross {
    return Intl.message(
      'Map Center Cross',
      name: 'settings_mapCenterCross',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get settings_color {
    return Intl.message(
      'Color',
      name: 'settings_color',
      desc: '',
      args: [],
    );
  }

  /// `Size`
  String get settings_size {
    return Intl.message(
      'Size',
      name: 'settings_size',
      desc: '',
      args: [],
    );
  }

  /// `Width`
  String get settings_width {
    return Intl.message(
      'Width',
      name: 'settings_width',
      desc: '',
      args: [],
    );
  }

  /// `Icon Size for Map Tools`
  String get settings_mapToolsIconSize {
    return Intl.message(
      'Icon Size for Map Tools',
      name: 'settings_mapToolsIconSize',
      desc: '',
      args: [],
    );
  }

  /// `GPS`
  String get settings_gps {
    return Intl.message(
      'GPS',
      name: 'settings_gps',
      desc: '',
      args: [],
    );
  }

  /// `GPS filters and mock locations`
  String get settings_gpsFiltersAndMockLoc {
    return Intl.message(
      'GPS filters and mock locations',
      name: 'settings_gpsFiltersAndMockLoc',
      desc: '',
      args: [],
    );
  }

  /// `Live Preview`
  String get settings_livePreview {
    return Intl.message(
      'Live Preview',
      name: 'settings_livePreview',
      desc: '',
      args: [],
    );
  }

  /// `No point available yet.`
  String get settings_noPointAvailableYet {
    return Intl.message(
      'No point available yet.',
      name: 'settings_noPointAvailableYet',
      desc: '',
      args: [],
    );
  }

  /// `longitude [deg]`
  String get settings_longitudeDeg {
    return Intl.message(
      'longitude [deg]',
      name: 'settings_longitudeDeg',
      desc: '',
      args: [],
    );
  }

  /// `latitude [deg]`
  String get settings_latitudeDeg {
    return Intl.message(
      'latitude [deg]',
      name: 'settings_latitudeDeg',
      desc: '',
      args: [],
    );
  }

  /// `accuracy [m]`
  String get settings_accuracyM {
    return Intl.message(
      'accuracy [m]',
      name: 'settings_accuracyM',
      desc: '',
      args: [],
    );
  }

  /// `altitude [m]`
  String get settings_altitudeM {
    return Intl.message(
      'altitude [m]',
      name: 'settings_altitudeM',
      desc: '',
      args: [],
    );
  }

  /// `heading [deg]`
  String get settings_headingDeg {
    return Intl.message(
      'heading [deg]',
      name: 'settings_headingDeg',
      desc: '',
      args: [],
    );
  }

  /// `speed [m/s]`
  String get settings_speedMS {
    return Intl.message(
      'speed [m/s]',
      name: 'settings_speedMS',
      desc: '',
      args: [],
    );
  }

  /// `is logging?`
  String get settings_isLogging {
    return Intl.message(
      'is logging?',
      name: 'settings_isLogging',
      desc: '',
      args: [],
    );
  }

  /// `mock locations?`
  String get settings_mockLocations {
    return Intl.message(
      'mock locations?',
      name: 'settings_mockLocations',
      desc: '',
      args: [],
    );
  }

  /// `Min dist filter blocks`
  String get settings_minDistFilterBlocks {
    return Intl.message(
      'Min dist filter blocks',
      name: 'settings_minDistFilterBlocks',
      desc: '',
      args: [],
    );
  }

  /// `Min dist filter passes`
  String get settings_minDistFilterPasses {
    return Intl.message(
      'Min dist filter passes',
      name: 'settings_minDistFilterPasses',
      desc: '',
      args: [],
    );
  }

  /// `Min time filter blocks`
  String get settings_minTimeFilterBlocks {
    return Intl.message(
      'Min time filter blocks',
      name: 'settings_minTimeFilterBlocks',
      desc: '',
      args: [],
    );
  }

  /// `Min time filter passes`
  String get settings_minTimeFilterPasses {
    return Intl.message(
      'Min time filter passes',
      name: 'settings_minTimeFilterPasses',
      desc: '',
      args: [],
    );
  }

  /// `Has been blocked`
  String get settings_hasBeenBlocked {
    return Intl.message(
      'Has been blocked',
      name: 'settings_hasBeenBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Distance from prev [m]`
  String get settings_distanceFromPrevM {
    return Intl.message(
      'Distance from prev [m]',
      name: 'settings_distanceFromPrevM',
      desc: '',
      args: [],
    );
  }

  /// `Time since prev [s]`
  String get settings_timeFromPrevS {
    return Intl.message(
      'Time since prev [s]',
      name: 'settings_timeFromPrevS',
      desc: '',
      args: [],
    );
  }

  /// `Location Info`
  String get settings_locationInfo {
    return Intl.message(
      'Location Info',
      name: 'settings_locationInfo',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get settings_filters {
    return Intl.message(
      'Filters',
      name: 'settings_filters',
      desc: '',
      args: [],
    );
  }

  /// `Turn off Filters.`
  String get settings_disableFilters {
    return Intl.message(
      'Turn off Filters.',
      name: 'settings_disableFilters',
      desc: '',
      args: [],
    );
  }

  /// `Turn on Filters.`
  String get settings_enableFilters {
    return Intl.message(
      'Turn on Filters.',
      name: 'settings_enableFilters',
      desc: '',
      args: [],
    );
  }

  /// `Zoom in`
  String get settings_zoomIn {
    return Intl.message(
      'Zoom in',
      name: 'settings_zoomIn',
      desc: '',
      args: [],
    );
  }

  /// `Zoom out`
  String get settings_zoomOut {
    return Intl.message(
      'Zoom out',
      name: 'settings_zoomOut',
      desc: '',
      args: [],
    );
  }

  /// `Activate point flow.`
  String get settings_activatePointFlow {
    return Intl.message(
      'Activate point flow.',
      name: 'settings_activatePointFlow',
      desc: '',
      args: [],
    );
  }

  /// `Pause points flow.`
  String get settings_pausePointsFlow {
    return Intl.message(
      'Pause points flow.',
      name: 'settings_pausePointsFlow',
      desc: '',
      args: [],
    );
  }

  /// `Visualize point count`
  String get settings_visualizePointCount {
    return Intl.message(
      'Visualize point count',
      name: 'settings_visualizePointCount',
      desc: '',
      args: [],
    );
  }

  /// `Show the GPS points count for VALID points.`
  String get settings_showGpsPointsValidPoints {
    return Intl.message(
      'Show the GPS points count for VALID points.',
      name: 'settings_showGpsPointsValidPoints',
      desc: '',
      args: [],
    );
  }

  /// `Show the GPS points count for ALL points.`
  String get settings_showGpsPointsAllPoints {
    return Intl.message(
      'Show the GPS points count for ALL points.',
      name: 'settings_showGpsPointsAllPoints',
      desc: '',
      args: [],
    );
  }

  /// `Log filters`
  String get settings_logFilters {
    return Intl.message(
      'Log filters',
      name: 'settings_logFilters',
      desc: '',
      args: [],
    );
  }

  /// `Min distance between 2 points.`
  String get settings_minDistanceBetween2Points {
    return Intl.message(
      'Min distance between 2 points.',
      name: 'settings_minDistanceBetween2Points',
      desc: '',
      args: [],
    );
  }

  /// `Min timespan between 2 points.`
  String get settings_minTimespanBetween2Points {
    return Intl.message(
      'Min timespan between 2 points.',
      name: 'settings_minTimespanBetween2Points',
      desc: '',
      args: [],
    );
  }

  /// `GPS Filter`
  String get settings_gpsFilter {
    return Intl.message(
      'GPS Filter',
      name: 'settings_gpsFilter',
      desc: '',
      args: [],
    );
  }

  /// `Turn off`
  String get settings_disable {
    return Intl.message(
      'Turn off',
      name: 'settings_disable',
      desc: '',
      args: [],
    );
  }

  /// `Turn on`
  String get settings_enable {
    return Intl.message(
      'Turn on',
      name: 'settings_enable',
      desc: '',
      args: [],
    );
  }

  /// `the use of filtered GPS.`
  String get settings_theUseOfTheGps {
    return Intl.message(
      'the use of filtered GPS.',
      name: 'settings_theUseOfTheGps',
      desc: '',
      args: [],
    );
  }

  /// `Warning: This will affect GPS position, notes insertion, log statistics and charting.`
  String get settings_warningThisWillAffectGpsPosition {
    return Intl.message(
      'Warning: This will affect GPS position, notes insertion, log statistics and charting.',
      name: 'settings_warningThisWillAffectGpsPosition',
      desc: '',
      args: [],
    );
  }

  /// `Mock locations`
  String get settings_MockLocations {
    return Intl.message(
      'Mock locations',
      name: 'settings_MockLocations',
      desc: '',
      args: [],
    );
  }

  /// `test GPS log for demo use.`
  String get settings_testGpsLogDemoUse {
    return Intl.message(
      'test GPS log for demo use.',
      name: 'settings_testGpsLogDemoUse',
      desc: '',
      args: [],
    );
  }

  /// `Set duration for GPS points in milliseconds.`
  String get settings_setDurationGpsPointsInMilli {
    return Intl.message(
      'Set duration for GPS points in milliseconds.',
      name: 'settings_setDurationGpsPointsInMilli',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get settings_SETTING {
    return Intl.message(
      'Setting',
      name: 'settings_SETTING',
      desc: '',
      args: [],
    );
  }

  /// `Set Mocked GPS duration`
  String get settings_setMockedGpsDuration {
    return Intl.message(
      'Set Mocked GPS duration',
      name: 'settings_setMockedGpsDuration',
      desc: '',
      args: [],
    );
  }

  /// `The value has to be a whole number.`
  String get settings_theValueHasToBeInt {
    return Intl.message(
      'The value has to be a whole number.',
      name: 'settings_theValueHasToBeInt',
      desc: '',
      args: [],
    );
  }

  /// `milliseconds`
  String get settings_milliseconds {
    return Intl.message(
      'milliseconds',
      name: 'settings_milliseconds',
      desc: '',
      args: [],
    );
  }

  /// `Use Google Services to improve location`
  String get settings_useGoogleToImproveLoc {
    return Intl.message(
      'Use Google Services to improve location',
      name: 'settings_useGoogleToImproveLoc',
      desc: '',
      args: [],
    );
  }

  /// `use of Google services (app restart needed).`
  String get settings_useOfGoogleServicesRestart {
    return Intl.message(
      'use of Google services (app restart needed).',
      name: 'settings_useOfGoogleServicesRestart',
      desc: '',
      args: [],
    );
  }

  /// `GPS Logs view mode`
  String get settings_gpsLogsViewMode {
    return Intl.message(
      'GPS Logs view mode',
      name: 'settings_gpsLogsViewMode',
      desc: '',
      args: [],
    );
  }

  /// `Log view mode for original data.`
  String get settings_logViewModeForOrigData {
    return Intl.message(
      'Log view mode for original data.',
      name: 'settings_logViewModeForOrigData',
      desc: '',
      args: [],
    );
  }

  /// `Log view mode for filtered data.`
  String get settings_logViewModeFilteredData {
    return Intl.message(
      'Log view mode for filtered data.',
      name: 'settings_logViewModeFilteredData',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get settings_cancel {
    return Intl.message(
      'Cancel',
      name: 'settings_cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get settings_ok {
    return Intl.message(
      'OK',
      name: 'settings_ok',
      desc: '',
      args: [],
    );
  }

  /// `Notes view modes`
  String get settings_notesViewModes {
    return Intl.message(
      'Notes view modes',
      name: 'settings_notesViewModes',
      desc: '',
      args: [],
    );
  }

  /// `Select a mode to view notes in.`
  String get settings_selectNotesViewMode {
    return Intl.message(
      'Select a mode to view notes in.',
      name: 'settings_selectNotesViewMode',
      desc: '',
      args: [],
    );
  }

  /// `Map Plugins`
  String get settings_mapPlugins {
    return Intl.message(
      'Map Plugins',
      name: 'settings_mapPlugins',
      desc: '',
      args: [],
    );
  }

  /// `Vector Layers`
  String get settings_vectorLayers {
    return Intl.message(
      'Vector Layers',
      name: 'settings_vectorLayers',
      desc: '',
      args: [],
    );
  }

  /// `Loading Options and Info Tool`
  String get settings_loadingOptionsInfoTool {
    return Intl.message(
      'Loading Options and Info Tool',
      name: 'settings_loadingOptionsInfoTool',
      desc: '',
      args: [],
    );
  }

  /// `Data loading`
  String get settings_dataLoading {
    return Intl.message(
      'Data loading',
      name: 'settings_dataLoading',
      desc: '',
      args: [],
    );
  }

  /// `Max number of features.`
  String get settings_maxNumberFeatures {
    return Intl.message(
      'Max number of features.',
      name: 'settings_maxNumberFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Max features per layer. Remove and add the layer to apply.`
  String get settings_maxNumFeaturesPerLayer {
    return Intl.message(
      'Max features per layer. Remove and add the layer to apply.',
      name: 'settings_maxNumFeaturesPerLayer',
      desc: '',
      args: [],
    );
  }

  /// `all`
  String get settings_all {
    return Intl.message(
      'all',
      name: 'settings_all',
      desc: '',
      args: [],
    );
  }

  /// `Load map area.`
  String get settings_loadMapArea {
    return Intl.message(
      'Load map area.',
      name: 'settings_loadMapArea',
      desc: '',
      args: [],
    );
  }

  /// `Load only on the last visible map area. Remove and add the layer again to apply.`
  String get settings_loadOnlyLastVisibleArea {
    return Intl.message(
      'Load only on the last visible map area. Remove and add the layer again to apply.',
      name: 'settings_loadOnlyLastVisibleArea',
      desc: '',
      args: [],
    );
  }

  /// `Info Tool`
  String get settings_infoTool {
    return Intl.message(
      'Info Tool',
      name: 'settings_infoTool',
      desc: '',
      args: [],
    );
  }

  /// `Tap size of the info tool in pixels.`
  String get settings_tapSizeInfoToolPixels {
    return Intl.message(
      'Tap size of the info tool in pixels.',
      name: 'settings_tapSizeInfoToolPixels',
      desc: '',
      args: [],
    );
  }

  /// `Editing tool`
  String get settings_editingTool {
    return Intl.message(
      'Editing tool',
      name: 'settings_editingTool',
      desc: '',
      args: [],
    );
  }

  /// `Editing drag handler icon size.`
  String get settings_editingDragIconSize {
    return Intl.message(
      'Editing drag handler icon size.',
      name: 'settings_editingDragIconSize',
      desc: '',
      args: [],
    );
  }

  /// `Editing intermediate drag handler icon size.`
  String get settings_editingIntermediateDragIconSize {
    return Intl.message(
      'Editing intermediate drag handler icon size.',
      name: 'settings_editingIntermediateDragIconSize',
      desc: '',
      args: [],
    );
  }

  /// `Diagnostics`
  String get settings_diagnostics {
    return Intl.message(
      'Diagnostics',
      name: 'settings_diagnostics',
      desc: '',
      args: [],
    );
  }

  /// `Diagnostics and Debug Log`
  String get settings_diagnosticsDebugLog {
    return Intl.message(
      'Diagnostics and Debug Log',
      name: 'settings_diagnosticsDebugLog',
      desc: '',
      args: [],
    );
  }

  /// `Open full debug log`
  String get settings_openFullDebugLog {
    return Intl.message(
      'Open full debug log',
      name: 'settings_openFullDebugLog',
      desc: '',
      args: [],
    );
  }

  /// `Debug Log View`
  String get settings_debugLogView {
    return Intl.message(
      'Debug Log View',
      name: 'settings_debugLogView',
      desc: '',
      args: [],
    );
  }

  /// `View all messages`
  String get settings_viewAllMessages {
    return Intl.message(
      'View all messages',
      name: 'settings_viewAllMessages',
      desc: '',
      args: [],
    );
  }

  /// `View only errors and warnings`
  String get settings_viewOnlyErrorsWarnings {
    return Intl.message(
      'View only errors and warnings',
      name: 'settings_viewOnlyErrorsWarnings',
      desc: '',
      args: [],
    );
  }

  /// `Clear debug log`
  String get settings_clearDebugLog {
    return Intl.message(
      'Clear debug log',
      name: 'settings_clearDebugLog',
      desc: '',
      args: [],
    );
  }

  /// `Loading data…`
  String get settings_loadingData {
    return Intl.message(
      'Loading data…',
      name: 'settings_loadingData',
      desc: '',
      args: [],
    );
  }

  /// `Device`
  String get settings_device {
    return Intl.message(
      'Device',
      name: 'settings_device',
      desc: '',
      args: [],
    );
  }

  /// `Device identifier`
  String get settings_deviceIdentifier {
    return Intl.message(
      'Device identifier',
      name: 'settings_deviceIdentifier',
      desc: '',
      args: [],
    );
  }

  /// `Device ID`
  String get settings_deviceId {
    return Intl.message(
      'Device ID',
      name: 'settings_deviceId',
      desc: '',
      args: [],
    );
  }

  /// `Override Device ID`
  String get settings_overrideDeviceId {
    return Intl.message(
      'Override Device ID',
      name: 'settings_overrideDeviceId',
      desc: '',
      args: [],
    );
  }

  /// `Override ID`
  String get settings_overrideId {
    return Intl.message(
      'Override ID',
      name: 'settings_overrideId',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid server password.`
  String get settings_pleaseEnterValidPassword {
    return Intl.message(
      'Please enter a valid server password.',
      name: 'settings_pleaseEnterValidPassword',
      desc: '',
      args: [],
    );
  }

  /// `GSS`
  String get settings_gss {
    return Intl.message(
      'GSS',
      name: 'settings_gss',
      desc: '',
      args: [],
    );
  }

  /// `Geopaparazzi Survey Server`
  String get settings_geopaparazziSurveyServer {
    return Intl.message(
      'Geopaparazzi Survey Server',
      name: 'settings_geopaparazziSurveyServer',
      desc: '',
      args: [],
    );
  }

  /// `Server URL`
  String get settings_serverUrl {
    return Intl.message(
      'Server URL',
      name: 'settings_serverUrl',
      desc: '',
      args: [],
    );
  }

  /// `The server URL needs to start with HTTP or HTTPS.`
  String get settings_serverUrlStartWithHttp {
    return Intl.message(
      'The server URL needs to start with HTTP or HTTPS.',
      name: 'settings_serverUrlStartWithHttp',
      desc: '',
      args: [],
    );
  }

  /// `Server Password`
  String get settings_serverPassword {
    return Intl.message(
      'Server Password',
      name: 'settings_serverPassword',
      desc: '',
      args: [],
    );
  }

  /// `Allow self signed certificates`
  String get settings_allowSelfSignedCert {
    return Intl.message(
      'Allow self signed certificates',
      name: 'settings_allowSelfSignedCert',
      desc: '',
      args: [],
    );
  }

  /// `Zoom out`
  String get toolbarTools_zoomOut {
    return Intl.message(
      'Zoom out',
      name: 'toolbarTools_zoomOut',
      desc: '',
      args: [],
    );
  }

  /// `Zoom in`
  String get toolbarTools_zoomIn {
    return Intl.message(
      'Zoom in',
      name: 'toolbarTools_zoomIn',
      desc: '',
      args: [],
    );
  }

  /// `Cancel current edit.`
  String get toolbarTools_cancelCurrentEdit {
    return Intl.message(
      'Cancel current edit.',
      name: 'toolbarTools_cancelCurrentEdit',
      desc: '',
      args: [],
    );
  }

  /// `Save current edit.`
  String get toolbarTools_saveCurrentEdit {
    return Intl.message(
      'Save current edit.',
      name: 'toolbarTools_saveCurrentEdit',
      desc: '',
      args: [],
    );
  }

  /// `Insert point in map center.`
  String get toolbarTools_insertPointMapCenter {
    return Intl.message(
      'Insert point in map center.',
      name: 'toolbarTools_insertPointMapCenter',
      desc: '',
      args: [],
    );
  }

  /// `Insert point in GPS position.`
  String get toolbarTools_insertPointGpsPos {
    return Intl.message(
      'Insert point in GPS position.',
      name: 'toolbarTools_insertPointGpsPos',
      desc: '',
      args: [],
    );
  }

  /// `Remove selected feature.`
  String get toolbarTools_removeSelectedFeature {
    return Intl.message(
      'Remove selected feature.',
      name: 'toolbarTools_removeSelectedFeature',
      desc: '',
      args: [],
    );
  }

  /// `Show feature attributes.`
  String get toolbarTools_showFeatureAttributes {
    return Intl.message(
      'Show feature attributes.',
      name: 'toolbarTools_showFeatureAttributes',
      desc: '',
      args: [],
    );
  }

  /// `The feature does not have a primary key. Editing is not allowed.`
  String get toolbarTools_featureDoesNotHavePrimaryKey {
    return Intl.message(
      'The feature does not have a primary key. Editing is not allowed.',
      name: 'toolbarTools_featureDoesNotHavePrimaryKey',
      desc: '',
      args: [],
    );
  }

  /// `Query features from loaded vector layers.`
  String get toolbarTools_queryFeaturesVectorLayers {
    return Intl.message(
      'Query features from loaded vector layers.',
      name: 'toolbarTools_queryFeaturesVectorLayers',
      desc: '',
      args: [],
    );
  }

  /// `Measure distances on the map with your finger.`
  String get toolbarTools_measureDistanceWithFinger {
    return Intl.message(
      'Measure distances on the map with your finger.',
      name: 'toolbarTools_measureDistanceWithFinger',
      desc: '',
      args: [],
    );
  }

  /// `Toggle fence in map center.`
  String get toolbarTools_toggleFenceMapCenter {
    return Intl.message(
      'Toggle fence in map center.',
      name: 'toolbarTools_toggleFenceMapCenter',
      desc: '',
      args: [],
    );
  }

  /// `Modify the geometry of editable vector layers.`
  String get toolbarTools_modifyGeomVectorLayers {
    return Intl.message(
      'Modify the geometry of editable vector layers.',
      name: 'toolbarTools_modifyGeomVectorLayers',
      desc: '',
      args: [],
    );
  }

  /// `Single tap: `
  String get coachMarks_singleTap {
    return Intl.message(
      'Single tap: ',
      name: 'coachMarks_singleTap',
      desc: '',
      args: [],
    );
  }

  /// `Long tap: `
  String get coachMarks_longTap {
    return Intl.message(
      'Long tap: ',
      name: 'coachMarks_longTap',
      desc: '',
      args: [],
    );
  }

  /// `Double tap: `
  String get coachMarks_doubleTap {
    return Intl.message(
      'Double tap: ',
      name: 'coachMarks_doubleTap',
      desc: '',
      args: [],
    );
  }

  /// `Simple Notes Button`
  String get coachMarks_simpleNoteButton {
    return Intl.message(
      'Simple Notes Button',
      name: 'coachMarks_simpleNoteButton',
      desc: '',
      args: [],
    );
  }

  /// `add a new note`
  String get coachMarks_addNewNote {
    return Intl.message(
      'add a new note',
      name: 'coachMarks_addNewNote',
      desc: '',
      args: [],
    );
  }

  /// `view list of notes`
  String get coachMarks_viewNotesList {
    return Intl.message(
      'view list of notes',
      name: 'coachMarks_viewNotesList',
      desc: '',
      args: [],
    );
  }

  /// `view settings for notes`
  String get coachMarks_viewNotesSettings {
    return Intl.message(
      'view settings for notes',
      name: 'coachMarks_viewNotesSettings',
      desc: '',
      args: [],
    );
  }

  /// `Form Notes Button`
  String get coachMarks_formNotesButton {
    return Intl.message(
      'Form Notes Button',
      name: 'coachMarks_formNotesButton',
      desc: '',
      args: [],
    );
  }

  /// `add new form note`
  String get coachMarks_addNewFormNote {
    return Intl.message(
      'add new form note',
      name: 'coachMarks_addNewFormNote',
      desc: '',
      args: [],
    );
  }

  /// `view list of form notes`
  String get coachMarks_viewFormNoteList {
    return Intl.message(
      'view list of form notes',
      name: 'coachMarks_viewFormNoteList',
      desc: '',
      args: [],
    );
  }

  /// `GPS Log Button`
  String get coachMarks_gpsLogButton {
    return Intl.message(
      'GPS Log Button',
      name: 'coachMarks_gpsLogButton',
      desc: '',
      args: [],
    );
  }

  /// `start logging/stop logging`
  String get coachMarks_startStopLogging {
    return Intl.message(
      'start logging/stop logging',
      name: 'coachMarks_startStopLogging',
      desc: '',
      args: [],
    );
  }

  /// `view list of logs`
  String get coachMarks_viewLogsList {
    return Intl.message(
      'view list of logs',
      name: 'coachMarks_viewLogsList',
      desc: '',
      args: [],
    );
  }

  /// `view log settings`
  String get coachMarks_viewLogsSettings {
    return Intl.message(
      'view log settings',
      name: 'coachMarks_viewLogsSettings',
      desc: '',
      args: [],
    );
  }

  /// `GPS Info Button (if applicable)`
  String get coachMarks_gpsInfoButton {
    return Intl.message(
      'GPS Info Button (if applicable)',
      name: 'coachMarks_gpsInfoButton',
      desc: '',
      args: [],
    );
  }

  /// `center map on GPS position`
  String get coachMarks_centerMapOnGpsPos {
    return Intl.message(
      'center map on GPS position',
      name: 'coachMarks_centerMapOnGpsPos',
      desc: '',
      args: [],
    );
  }

  /// `show GPS info`
  String get coachMarks_showGpsInfo {
    return Intl.message(
      'show GPS info',
      name: 'coachMarks_showGpsInfo',
      desc: '',
      args: [],
    );
  }

  /// `toggle automatic center on GPS`
  String get coachMarks_toggleAutoCenterGps {
    return Intl.message(
      'toggle automatic center on GPS',
      name: 'coachMarks_toggleAutoCenterGps',
      desc: '',
      args: [],
    );
  }

  /// `Layer View Button`
  String get coachMarks_layersViewButton {
    return Intl.message(
      'Layer View Button',
      name: 'coachMarks_layersViewButton',
      desc: '',
      args: [],
    );
  }

  /// `Open the layers view`
  String get coachMarks_openLayersView {
    return Intl.message(
      'Open the layers view',
      name: 'coachMarks_openLayersView',
      desc: '',
      args: [],
    );
  }

  /// `Open the layer plugins dialog`
  String get coachMarks_openLayersPluginDialog {
    return Intl.message(
      'Open the layer plugins dialog',
      name: 'coachMarks_openLayersPluginDialog',
      desc: '',
      args: [],
    );
  }

  /// `Zoom-in Button`
  String get coachMarks_zoomInButton {
    return Intl.message(
      'Zoom-in Button',
      name: 'coachMarks_zoomInButton',
      desc: '',
      args: [],
    );
  }

  /// `Zoom in the map by one level`
  String get coachMarks_zoomImMapOneLevel {
    return Intl.message(
      'Zoom in the map by one level',
      name: 'coachMarks_zoomImMapOneLevel',
      desc: '',
      args: [],
    );
  }

  /// `Zoom-out Button`
  String get coachMarks_zoomOutButton {
    return Intl.message(
      'Zoom-out Button',
      name: 'coachMarks_zoomOutButton',
      desc: '',
      args: [],
    );
  }

  /// `Zoom out the map by one level`
  String get coachMarks_zoomOutMapOneLevel {
    return Intl.message(
      'Zoom out the map by one level',
      name: 'coachMarks_zoomOutMapOneLevel',
      desc: '',
      args: [],
    );
  }

  /// `Bottom Tools Button`
  String get coachMarks_bottomToolsButton {
    return Intl.message(
      'Bottom Tools Button',
      name: 'coachMarks_bottomToolsButton',
      desc: '',
      args: [],
    );
  }

  /// `Toggle bottom tools bar. `
  String get coachMarks_toggleBottomToolsBar {
    return Intl.message(
      'Toggle bottom tools bar. ',
      name: 'coachMarks_toggleBottomToolsBar',
      desc: '',
      args: [],
    );
  }

  /// `Tools Button`
  String get coachMarks_toolsButton {
    return Intl.message(
      'Tools Button',
      name: 'coachMarks_toolsButton',
      desc: '',
      args: [],
    );
  }

  /// `Open the end drawer to access project info and sharing options as well as map plugins, feature tools and extras.`
  String get coachMarks_openEndDrawerToAccessProject {
    return Intl.message(
      'Open the end drawer to access project info and sharing options as well as map plugins, feature tools and extras.',
      name: 'coachMarks_openEndDrawerToAccessProject',
      desc: '',
      args: [],
    );
  }

  /// `Interactive coach-marks button`
  String get coachMarks_interactiveCoackMarksButton {
    return Intl.message(
      'Interactive coach-marks button',
      name: 'coachMarks_interactiveCoackMarksButton',
      desc: '',
      args: [],
    );
  }

  /// `Open the interactice coach marks explaining all the actions of the main map view.`
  String get coachMarks_openInteractiveCoachMarks {
    return Intl.message(
      'Open the interactice coach marks explaining all the actions of the main map view.',
      name: 'coachMarks_openInteractiveCoachMarks',
      desc: '',
      args: [],
    );
  }

  /// `Main-menu Button`
  String get coachMarks_mainMenuButton {
    return Intl.message(
      'Main-menu Button',
      name: 'coachMarks_mainMenuButton',
      desc: '',
      args: [],
    );
  }

  /// `Open the drawer to load or create a project, import and export data, sync with servers, access settings and exit the app/turn off the GPS.`
  String get coachMarks_openDrawerToLoadProject {
    return Intl.message(
      'Open the drawer to load or create a project, import and export data, sync with servers, access settings and exit the app/turn off the GPS.',
      name: 'coachMarks_openDrawerToLoadProject',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get coachMarks_skip {
    return Intl.message(
      'Skip',
      name: 'coachMarks_skip',
      desc: '',
      args: [],
    );
  }

  /// `Fence Properties`
  String get fence_fenceProperties {
    return Intl.message(
      'Fence Properties',
      name: 'fence_fenceProperties',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get fence_delete {
    return Intl.message(
      'Delete',
      name: 'fence_delete',
      desc: '',
      args: [],
    );
  }

  /// `Remove fence`
  String get fence_removeFence {
    return Intl.message(
      'Remove fence',
      name: 'fence_removeFence',
      desc: '',
      args: [],
    );
  }

  /// `Remove the fence?`
  String get fence_areYouSureRemoveFence {
    return Intl.message(
      'Remove the fence?',
      name: 'fence_areYouSureRemoveFence',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get fence_cancel {
    return Intl.message(
      'Cancel',
      name: 'fence_cancel',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get fence_ok {
    return Intl.message(
      'OK',
      name: 'fence_ok',
      desc: '',
      args: [],
    );
  }

  /// `a new fence`
  String get fence_aNewFence {
    return Intl.message(
      'a new fence',
      name: 'fence_aNewFence',
      desc: '',
      args: [],
    );
  }

  /// `Label`
  String get fence_label {
    return Intl.message(
      'Label',
      name: 'fence_label',
      desc: '',
      args: [],
    );
  }

  /// `A name for the fence.`
  String get fence_aNameForFence {
    return Intl.message(
      'A name for the fence.',
      name: 'fence_aNameForFence',
      desc: '',
      args: [],
    );
  }

  /// `The name must be defined.`
  String get fence_theNameNeedsToBeDefined {
    return Intl.message(
      'The name must be defined.',
      name: 'fence_theNameNeedsToBeDefined',
      desc: '',
      args: [],
    );
  }

  /// `Radius`
  String get fence_radius {
    return Intl.message(
      'Radius',
      name: 'fence_radius',
      desc: '',
      args: [],
    );
  }

  /// `The fence radius in meters.`
  String get fence_theFenceRadiusMeters {
    return Intl.message(
      'The fence radius in meters.',
      name: 'fence_theFenceRadiusMeters',
      desc: '',
      args: [],
    );
  }

  /// `The radius must be a positive number in meters.`
  String get fence_radiusNeedsToBePositive {
    return Intl.message(
      'The radius must be a positive number in meters.',
      name: 'fence_radiusNeedsToBePositive',
      desc: '',
      args: [],
    );
  }

  /// `On enter`
  String get fence_onEnter {
    return Intl.message(
      'On enter',
      name: 'fence_onEnter',
      desc: '',
      args: [],
    );
  }

  /// `On exit`
  String get fence_onExit {
    return Intl.message(
      'On exit',
      name: 'fence_onExit',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled by user.`
  String get network_cancelledByUser {
    return Intl.message(
      'Cancelled by user.',
      name: 'network_cancelledByUser',
      desc: '',
      args: [],
    );
  }

  /// `Completed.`
  String get network_completed {
    return Intl.message(
      'Completed.',
      name: 'network_completed',
      desc: '',
      args: [],
    );
  }

  /// `Building base cache for improved performance (might take a while)…`
  String get network_buildingBaseCachePerformance {
    return Intl.message(
      'Building base cache for improved performance (might take a while)…',
      name: 'network_buildingBaseCachePerformance',
      desc: '',
      args: [],
    );
  }

  /// `This file is already being downloaded.`
  String get network_thisFIleAlreadyBeingDownloaded {
    return Intl.message(
      'This file is already being downloaded.',
      name: 'network_thisFIleAlreadyBeingDownloaded',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get network_download {
    return Intl.message(
      'Download',
      name: 'network_download',
      desc: '',
      args: [],
    );
  }

  /// `Download file`
  String get network_downloadFile {
    return Intl.message(
      'Download file',
      name: 'network_downloadFile',
      desc: '',
      args: [],
    );
  }

  /// `to the device? This can take a while.`
  String get network_toTheDeviceTakeTime {
    return Intl.message(
      'to the device? This can take a while.',
      name: 'network_toTheDeviceTakeTime',
      desc: '',
      args: [],
    );
  }

  /// `Available maps`
  String get network_availableMaps {
    return Intl.message(
      'Available maps',
      name: 'network_availableMaps',
      desc: '',
      args: [],
    );
  }

  /// `Search map by name`
  String get network_searchMapByName {
    return Intl.message(
      'Search map by name',
      name: 'network_searchMapByName',
      desc: '',
      args: [],
    );
  }

  /// `Uploading`
  String get network_uploading {
    return Intl.message(
      'Uploading',
      name: 'network_uploading',
      desc: '',
      args: [],
    );
  }

  /// `please wait…`
  String get network_pleaseWait {
    return Intl.message(
      'please wait…',
      name: 'network_pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Permission on server denied.`
  String get network_permissionOnServerDenied {
    return Intl.message(
      'Permission on server denied.',
      name: 'network_permissionOnServerDenied',
      desc: '',
      args: [],
    );
  }

  /// `Could not connect to the server. Is it online? Check your address.`
  String get network_couldNotConnectToServer {
    return Intl.message(
      'Could not connect to the server. Is it online? Check your address.',
      name: 'network_couldNotConnectToServer',
      desc: '',
      args: [],
    );
  }

  /// `New Sketch`
  String get form_sketch_newSketch {
    return Intl.message(
      'New Sketch',
      name: 'form_sketch_newSketch',
      desc: '',
      args: [],
    );
  }

  /// `Undo`
  String get form_sketch_undo {
    return Intl.message(
      'Undo',
      name: 'form_sketch_undo',
      desc: '',
      args: [],
    );
  }

  /// `Nothing to undo`
  String get form_sketch_noUndo {
    return Intl.message(
      'Nothing to undo',
      name: 'form_sketch_noUndo',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get form_sketch_clear {
    return Intl.message(
      'Clear',
      name: 'form_sketch_clear',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get form_sketch_save {
    return Intl.message(
      'Save',
      name: 'form_sketch_save',
      desc: '',
      args: [],
    );
  }

  /// `Sketcher`
  String get form_sketch_sketcher {
    return Intl.message(
      'Sketcher',
      name: 'form_sketch_sketcher',
      desc: '',
      args: [],
    );
  }

  /// `Turn on drawing`
  String get form_sketch_enableDrawing {
    return Intl.message(
      'Turn on drawing',
      name: 'form_sketch_enableDrawing',
      desc: '',
      args: [],
    );
  }

  /// `Turn on eraser`
  String get form_sketch_enableEraser {
    return Intl.message(
      'Turn on eraser',
      name: 'form_sketch_enableEraser',
      desc: '',
      args: [],
    );
  }

  /// `Background color`
  String get form_sketch_backColor {
    return Intl.message(
      'Background color',
      name: 'form_sketch_backColor',
      desc: '',
      args: [],
    );
  }

  /// `Stroke color`
  String get form_sketch_strokeColor {
    return Intl.message(
      'Stroke color',
      name: 'form_sketch_strokeColor',
      desc: '',
      args: [],
    );
  }

  /// `Pick color`
  String get form_sketch_pickColor {
    return Intl.message(
      'Pick color',
      name: 'form_sketch_pickColor',
      desc: '',
      args: [],
    );
  }

  /// `Could not save image in database.`
  String get form_smash_cantSaveImageDb {
    return Intl.message(
      'Could not save image in database.',
      name: 'form_smash_cantSaveImageDb',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<SL> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'cs'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'nb', countryCode: 'NO'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<SL> load(Locale locale) => SL.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}