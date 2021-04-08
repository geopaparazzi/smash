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

  /// `Checking location permission...`
  String get main_check_location_permission {
    return Intl.message(
      'Checking location permission...',
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

  /// `Checking storage permission...`
  String get main_checkingStoragePermission {
    return Intl.message(
      'Checking storage permission...',
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

  /// `Loading preferences...`
  String get main_loadingPreferences {
    return Intl.message(
      'Loading preferences...',
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

  /// `Loading workspace...`
  String get main_loadingWorkspace {
    return Intl.message(
      'Loading workspace...',
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

  /// `Loading tags list...`
  String get main_loadingTagsList {
    return Intl.message(
      'Loading tags list...',
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

  /// `Loading known projections...`
  String get main_loadingKnownProjections {
    return Intl.message(
      'Loading known projections...',
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

  /// `Loading fences...`
  String get main_loadingFences {
    return Intl.message(
      'Loading fences...',
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

  /// `Loading layers list...`
  String get main_loadingLayersList {
    return Intl.message(
      'Loading layers list...',
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

  /// `This app collects location data to your device to enable gps logs recording even when the app is placed in background. No data is shared, it is only saved locally to the device.\n\nIf you do not give permission to the background location service in the next dialog, you will still be able to collect data with SMASH, but will need to keep the app always in foreground to do so.\n`
  String get main_locationBackgroundWarning {
    return Intl.message(
      'This app collects location data to your device to enable gps logs recording even when the app is placed in background. No data is shared, it is only saved locally to the device.\n\nIf you do not give permission to the background location service in the next dialog, you will still be able to collect data with SMASH, but will need to keep the app always in foreground to do so.\n',
      name: 'main_locationBackgroundWarning',
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

  /// `Loading data...`
  String get mainView_loadingData {
    return Intl.message(
      'Loading data...',
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

  /// `Are you sure you want to close the project?`
  String get mainView_areYouSureCloseTheProject {
    return Intl.message(
      'Are you sure you want to close the project?',
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

  /// `Saving image to db...`
  String get dataLoader_savingImageToDB {
    return Intl.message(
      'Saving image to db...',
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

  /// `Are you sure you want to remove note`
  String get dataLoader_areYouSureRemoveNote {
    return Intl.message(
      'Are you sure you want to remove note',
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

  /// `Are you sure you want to remove image`
  String get dataLoader_areYouSureRemoveImage {
    return Intl.message(
      'Are you sure you want to remove image',
      name: 'dataLoader_areYouSureRemoveImage',
      desc: '',
      args: [],
    );
  }

  /// `Loading image...`
  String get images_loadingImage {
    return Intl.message(
      'Loading image...',
      name: 'images_loadingImage',
      desc: '',
      args: [],
    );
  }

  /// `Loading information...`
  String get about_loadingInformation {
    return Intl.message(
      'Loading information...',
      name: 'about_loadingInformation',
      desc: '',
      args: [],
    );
  }

  /// `ABOUT `
  String get about_ABOUT {
    return Intl.message(
      'ABOUT ',
      name: 'about_ABOUT',
      desc: '',
      args: [],
    );
  }

  /// `Smart Mobile App for Surveyor's Happiness`
  String get about_smartMobileAppForSurveyor {
    return Intl.message(
      'Smart Mobile App for Surveyor\'s Happiness',
      name: 'about_smartMobileAppForSurveyor',
      desc: '',
      args: [],
    );
  }

  /// `Application version`
  String get about_applicationVersion {
    return Intl.message(
      'Application version',
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

  /// ` is available under the General Public License, version 3.`
  String get about_isAvailableUnderGPL3 {
    return Intl.message(
      ' is available under the General Public License, version 3.',
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

  /// `Legal Information`
  String get about_legalInformation {
    return Intl.message(
      'Legal Information',
      name: 'about_legalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Copyright 2020, HydroloGIS S.r.l. -  some rights reserved. Tap to visit.`
  String get about_copyright2020HydroloGIS {
    return Intl.message(
      'Copyright 2020, HydroloGIS S.r.l. -  some rights reserved. Tap to visit.',
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

  /// `No GPS info available...`
  String get gpsInfoButton_noGpsInfoAvailable {
    return Intl.message(
      'No GPS info available...',
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

  /// `Loading image...`
  String get imageWidgets_loadingImage {
    return Intl.message(
      'Loading image...',
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

  /// `Loading logs...`
  String get logList_loadingLogs {
    return Intl.message(
      'Loading logs...',
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

  /// `An error occurred while exporting log to GPX.`
  String get logList_errorOccurredExportingLogGPX {
    return Intl.message(
      'An error occurred while exporting log to GPX.',
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

  /// `DELETE`
  String get logList_DELETE {
    return Intl.message(
      'DELETE',
      name: 'logList_DELETE',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the log?`
  String get logList_areYouSureDeleteTheLog {
    return Intl.message(
      'Are you sure you want to delete the log?',
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

  /// `Disable stats`
  String get logProperties_disableStats {
    return Intl.message(
      'Disable stats',
      name: 'logProperties_disableStats',
      desc: '',
      args: [],
    );
  }

  /// `Enable stats`
  String get logProperties_enableStats {
    return Intl.message(
      'Enable stats',
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

  /// `Simple Notes List`
  String get noteList_simpleNotesList {
    return Intl.message(
      'Simple Notes List',
      name: 'noteList_simpleNotesList',
      desc: '',
      args: [],
    );
  }

  /// `Form Notes List`
  String get noteList_formNotesList {
    return Intl.message(
      'Form Notes List',
      name: 'noteList_formNotesList',
      desc: '',
      args: [],
    );
  }

  /// `Loading Notes...`
  String get noteList_loadingNotes {
    return Intl.message(
      'Loading Notes...',
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

  /// `DELETE`
  String get noteList_DELETE {
    return Intl.message(
      'DELETE',
      name: 'noteList_DELETE',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete the note?`
  String get noteList_areYouSureDeleteNote {
    return Intl.message(
      'Are you sure you want to delete the note?',
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

  /// `Retina screen mode`
  String get settings_retinaScreenMode {
    return Intl.message(
      'Retina screen mode',
      name: 'settings_retinaScreenMode',
      desc: '',
      args: [],
    );
  }

  /// `To apply this setting you need to enter and exit the layer view.`
  String get settings_toApplySettingEnterExitLayerView {
    return Intl.message(
      'To apply this setting you need to enter and exit the layer view.',
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

  /// `Map Tools Icon Size`
  String get settings_mapToolsIconSize {
    return Intl.message(
      'Map Tools Icon Size',
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

  /// `MIN DIST FILTER BLOCKS`
  String get settings_minDistFilterBlocks {
    return Intl.message(
      'MIN DIST FILTER BLOCKS',
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

  /// `MIN TIME FILTER BLOCKS`
  String get settings_minTimeFilterBlocks {
    return Intl.message(
      'MIN TIME FILTER BLOCKS',
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

  /// `HAS BEEN BLOCKED`
  String get settings_hasBeenBlocked {
    return Intl.message(
      'HAS BEEN BLOCKED',
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

  /// `Time from prev [s]`
  String get settings_timeFromPrevS {
    return Intl.message(
      'Time from prev [s]',
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

  /// `Disable Filters.`
  String get settings_disableFilters {
    return Intl.message(
      'Disable Filters.',
      name: 'settings_disableFilters',
      desc: '',
      args: [],
    );
  }

  /// `Enable Filters.`
  String get settings_enableFilters {
    return Intl.message(
      'Enable Filters.',
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

  /// `Disable`
  String get settings_disable {
    return Intl.message(
      'Disable',
      name: 'settings_disable',
      desc: '',
      args: [],
    );
  }

  /// `Enable`
  String get settings_enable {
    return Intl.message(
      'Enable',
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

  /// `WARNING: This will affect GPS position, notes insertion, log statistics and charting.`
  String get settings_warningThisWillAffectGpsPosition {
    return Intl.message(
      'WARNING: This will affect GPS position, notes insertion, log statistics and charting.',
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

  /// `test gps log for demo use.`
  String get settings_testGpsLogDemoUse {
    return Intl.message(
      'test gps log for demo use.',
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

  /// `SETTING`
  String get settings_SETTING {
    return Intl.message(
      'SETTING',
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

  /// `The value has to be an integer.`
  String get settings_theValueHasToBeInt {
    return Intl.message(
      'The value has to be an integer.',
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

  /// `use of google services (needs an app restart).`
  String get settings_useOfGoogleServicesRestart {
    return Intl.message(
      'use of google services (needs an app restart).',
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

  /// `CANCEL`
  String get settings_cancel {
    return Intl.message(
      'CANCEL',
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

  /// `Select a notes view mode.`
  String get settings_selectNotesViewMode {
    return Intl.message(
      'Select a notes view mode.',
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

  /// `Max number of features to load per layer. To apply remove and add layer back.`
  String get settings_maxNumFeaturesPerLayer {
    return Intl.message(
      'Max number of features to load per layer. To apply remove and add layer back.',
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

  /// `Load only on the last visible map area. To apply remove and add layer back.`
  String get settings_loadOnlyLastVisibleArea {
    return Intl.message(
      'Load only on the last visible map area. To apply remove and add layer back.',
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

  /// `Diagnostics & Debug Log`
  String get settings_diagnosticsDebugLog {
    return Intl.message(
      'Diagnostics & Debug Log',
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

  /// `Loading data...`
  String get settings_loadingData {
    return Intl.message(
      'Loading data...',
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

  /// `Device Id`
  String get settings_deviceId {
    return Intl.message(
      'Device Id',
      name: 'settings_deviceId',
      desc: '',
      args: [],
    );
  }

  /// `Override Device Id`
  String get settings_overrideDeviceId {
    return Intl.message(
      'Override Device Id',
      name: 'settings_overrideDeviceId',
      desc: '',
      args: [],
    );
  }

  /// `Override Id`
  String get settings_overrideId {
    return Intl.message(
      'Override Id',
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

  /// `Server url needs to start with http or https.`
  String get settings_serverUrlStartWithHttp {
    return Intl.message(
      'Server url needs to start with http or https.',
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

  /// `Modify geometries in editable vector layers.`
  String get toolbarTools_modifyGeomVectorLayers {
    return Intl.message(
      'Modify geometries in editable vector layers.',
      name: 'toolbarTools_modifyGeomVectorLayers',
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
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
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