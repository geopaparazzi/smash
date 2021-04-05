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