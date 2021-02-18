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

  /// `key_did_show_main_view_coach_marks`
  String get mainview_keyDidShowMainViewCoachMarks {
    return Intl.message(
      'key_did_show_main_view_coach_marks',
      name: 'mainview_keyDidShowMainViewCoachMarks',
      desc: '',
      args: [],
    );
  }

  /// `Loading data...`
  String get mainview_loadingData {
    return Intl.message(
      'Loading data...',
      name: 'mainview_loadingData',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to close the project?`
  String get mainview_areYouSureYouWantToCloseTheProject {
    return Intl.message(
      'Are you sure you want to close the project?',
      name: 'mainview_areYouSureYouWantToCloseTheProject',
      desc: '',
      args: [],
    );
  }

  /// `Active operations will be stopped.`
  String get mainview_activeOperationsWillBeStopped {
    return Intl.message(
      'Active operations will be stopped.',
      name: 'mainview_activeOperationsWillBeStopped',
      desc: '',
      args: [],
    );
  }

  /// `Show interactive coach marks.`
  String get mainview_showInteractiveCoachMarks {
    return Intl.message(
      'Show interactive coach marks.',
      name: 'mainview_showInteractiveCoachMarks',
      desc: '',
      args: [],
    );
  }

  /// `Open tools drawer.`
  String get mainview_openToolsDrawer {
    return Intl.message(
      'Open tools drawer.',
      name: 'mainview_openToolsDrawer',
      desc: '',
      args: [],
    );
  }

  /// `Zoom in`
  String get mainview_zoomIn {
    return Intl.message(
      'Zoom in',
      name: 'mainview_zoomIn',
      desc: '',
      args: [],
    );
  }

  /// `Zoom out`
  String get mainview_zoomOut {
    return Intl.message(
      'Zoom out',
      name: 'mainview_zoomOut',
      desc: '',
      args: [],
    );
  }

  /// `Simple Form`
  String get mainview_simpleForm {
    return Intl.message(
      'Simple Form',
      name: 'mainview_simpleForm',
      desc: '',
      args: [],
    );
  }

  /// `Simple Notes`
  String get mainview_simpleNotes {
    return Intl.message(
      'Simple Notes',
      name: 'mainview_simpleNotes',
      desc: '',
      args: [],
    );
  }

  /// `note`
  String get mainview_note {
    return Intl.message(
      'note',
      name: 'mainview_note',
      desc: '',
      args: [],
    );
  }

  /// `image`
  String get mainview_image {
    return Intl.message(
      'image',
      name: 'mainview_image',
      desc: '',
      args: [],
    );
  }

  /// `Turn GPS on`
  String get mainview_turnGPSon {
    return Intl.message(
      'Turn GPS on',
      name: 'mainview_turnGPSon',
      desc: '',
      args: [],
    );
  }

  /// `Turn GPS off`
  String get mainview_turnGPSoff {
    return Intl.message(
      'Turn GPS off',
      name: 'mainview_turnGPSoff',
      desc: '',
      args: [],
    );
  }

  /// `Enter note in the map center.`
  String get mainview_enterNoteInTheMapCenter {
    return Intl.message(
      'Enter note in the map center.',
      name: 'mainview_enterNoteInTheMapCenter',
      desc: '',
      args: [],
    );
  }

  /// `Enter note in GPS position.`
  String get mainview_enterNoteInGPSPosition {
    return Intl.message(
      'Enter note in GPS position.',
      name: 'mainview_enterNoteInGPSPosition',
      desc: '',
      args: [],
    );
  }

  /// `Projects`
  String get mainview_utils_projects {
    return Intl.message(
      'Projects',
      name: 'mainview_utils_projects',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get mainview_utils_import {
    return Intl.message(
      'Import',
      name: 'mainview_utils_import',
      desc: '',
      args: [],
    );
  }

  /// `Export`
  String get mainview_utils_export {
    return Intl.message(
      'Export',
      name: 'mainview_utils_export',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get mainview_utils_settings {
    return Intl.message(
      'Settings',
      name: 'mainview_utils_settings',
      desc: '',
      args: [],
    );
  }

  /// `Online Help`
  String get mainview_utils_onlineHelp {
    return Intl.message(
      'Online Help',
      name: 'mainview_utils_onlineHelp',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get mainview_utils_about {
    return Intl.message(
      'About',
      name: 'mainview_utils_about',
      desc: '',
      args: [],
    );
  }

  /// `Project Info`
  String get mainview_utils_projectInfo {
    return Intl.message(
      'Project Info',
      name: 'mainview_utils_projectInfo',
      desc: '',
      args: [],
    );
  }

  /// `Extras`
  String get mainview_utils_extras {
    return Intl.message(
      'Extras',
      name: 'mainview_utils_extras',
      desc: '',
      args: [],
    );
  }

  /// `Available icons`
  String get mainview_utils_availableIcons {
    return Intl.message(
      'Available icons',
      name: 'mainview_utils_availableIcons',
      desc: '',
      args: [],
    );
  }

  /// `Offline maps`
  String get mainview_utils_offlineMaps {
    return Intl.message(
      'Offline maps',
      name: 'mainview_utils_offlineMaps',
      desc: '',
      args: [],
    );
  }

  /// `Position Tools`
  String get mainview_utils_positionTools {
    return Intl.message(
      'Position Tools',
      name: 'mainview_utils_positionTools',
      desc: '',
      args: [],
    );
  }

  /// `Go to`
  String get mainview_utils_goTo {
    return Intl.message(
      'Go to',
      name: 'mainview_utils_goTo',
      desc: '',
      args: [],
    );
  }

  /// `Share position`
  String get mainview_utils_sharePosition {
    return Intl.message(
      'Share position',
      name: 'mainview_utils_sharePosition',
      desc: '',
      args: [],
    );
  }

  /// `Latitude`
  String get mainview_utils_latitude {
    return Intl.message(
      'Latitude',
      name: 'mainview_utils_latitude',
      desc: '',
      args: [],
    );
  }

  /// `Longitude`
  String get mainview_utils_longitude {
    return Intl.message(
      'Longitude',
      name: 'mainview_utils_longitude',
      desc: '',
      args: [],
    );
  }

  /// `Altitude`
  String get mainview_utils_altitude {
    return Intl.message(
      'Altitude',
      name: 'mainview_utils_altitude',
      desc: '',
      args: [],
    );
  }

  /// `Accuracy`
  String get mainview_utils_accuracy {
    return Intl.message(
      'Accuracy',
      name: 'mainview_utils_accuracy',
      desc: '',
      args: [],
    );
  }

  /// `Timestamp`
  String get mainview_utils_timestamp {
    return Intl.message(
      'Timestamp',
      name: 'mainview_utils_timestamp',
      desc: '',
      args: [],
    );
  }

  /// `Rotate map with GPS`
  String get mainview_utils_rotateMapWithGPS {
    return Intl.message(
      'Rotate map with GPS',
      name: 'mainview_utils_rotateMapWithGPS',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get mainview_utils_project {
    return Intl.message(
      'Project',
      name: 'mainview_utils_project',
      desc: '',
      args: [],
    );
  }

  /// `Database`
  String get mainview_utils_database {
    return Intl.message(
      'Database',
      name: 'mainview_utils_database',
      desc: '',
      args: [],
    );
  }

  /// `Could not save image in database.`
  String get form_smash_utils_couldNotSaveImageInDatabase {
    return Intl.message(
      'Could not save image in database.',
      name: 'form_smash_utils_couldNotSaveImageInDatabase',
      desc: '',
      args: [],
    );
  }

  /// `POI`
  String get form_smash_utils_POI {
    return Intl.message(
      'POI',
      name: 'form_smash_utils_POI',
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

  /// `ABOUT {appName}`
  String about_titleBar(Object appName) {
    return Intl.message(
      'ABOUT $appName',
      name: 'about_titleBar',
      desc: '',
      args: [appName],
    );
  }

  /// `Smart Mobile App for Surveyor's Happyness`
  String get about_subtitle {
    return Intl.message(
      'Smart Mobile App for Surveyor\'s Happyness',
      name: 'about_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Application version`
  String get about_version {
    return Intl.message(
      'Application version',
      name: 'about_version',
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

  /// `{appName} is available under the General Public License, version 3.`
  String about_licenseText(Object appName) {
    return Intl.message(
      '$appName is available under the General Public License, version 3.',
      name: 'about_licenseText',
      desc: '',
      args: [appName],
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
  String get about_tapHereVisitRepository {
    return Intl.message(
      'Tap here to visit the source code repository',
      name: 'about_tapHereVisitRepository',
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
  String get about_copyright {
    return Intl.message(
      'Copyright 2020, HydroloGIS S.r.l. -  some rights reserved. Tap to visit.',
      name: 'about_copyright',
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
  String get about_supportedByText {
    return Intl.message(
      'Partially supported by the project Steep Stream of the University of Trento.',
      name: 'about_supportedByText',
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
  String get about_privacyPolicyText {
    return Intl.message(
      'Tap here to see the privacy policy that covers user and location data.',
      name: 'about_privacyPolicyText',
      desc: '',
      args: [],
    );
  }

  /// `Zoom out`
  String get toolbar_tools_zoomOut {
    return Intl.message(
      'Zoom out',
      name: 'toolbar_tools_zoomOut',
      desc: '',
      args: [],
    );
  }

  /// `Zoom in`
  String get toolbar_tools_zoomIn {
    return Intl.message(
      'Zoom in',
      name: 'toolbar_tools_zoomIn',
      desc: '',
      args: [],
    );
  }

  /// `Cancel current edit.`
  String get toolbar_tools_cancelEdits {
    return Intl.message(
      'Cancel current edit.',
      name: 'toolbar_tools_cancelEdits',
      desc: '',
      args: [],
    );
  }

  /// `Save current edit.`
  String get toolbar_tools_saveEdits {
    return Intl.message(
      'Save current edit.',
      name: 'toolbar_tools_saveEdits',
      desc: '',
      args: [],
    );
  }

  /// `Remove selected feature.`
  String get toolbar_tools_removeFeature {
    return Intl.message(
      'Remove selected feature.',
      name: 'toolbar_tools_removeFeature',
      desc: '',
      args: [],
    );
  }

  /// `Show feature attributes.`
  String get toolbar_tools_showAttributes {
    return Intl.message(
      'Show feature attributes.',
      name: 'toolbar_tools_showAttributes',
      desc: '',
      args: [],
    );
  }

  /// `The feature does not have a primary key. Editing is not allowed.`
  String get toolbar_tools_noPrimaryKey {
    return Intl.message(
      'The feature does not have a primary key. Editing is not allowed.',
      name: 'toolbar_tools_noPrimaryKey',
      desc: '',
      args: [],
    );
  }

  /// `Query features from loaded vector layers.`
  String get toolbar_tools_queryFeatures {
    return Intl.message(
      'Query features from loaded vector layers.',
      name: 'toolbar_tools_queryFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Measure distances on the map with your finger.`
  String get toolbar_tools_measureDistance {
    return Intl.message(
      'Measure distances on the map with your finger.',
      name: 'toolbar_tools_measureDistance',
      desc: '',
      args: [],
    );
  }

  /// `Toggle fence in map center.`
  String get toolbar_tools_toggleFence {
    return Intl.message(
      'Toggle fence in map center.',
      name: 'toolbar_tools_toggleFence',
      desc: '',
      args: [],
    );
  }

  /// `Modify geometries in editable vector layers.`
  String get toolbar_tools_modifyGeometries {
    return Intl.message(
      'Modify geometries in editable vector layers.',
      name: 'toolbar_tools_modifyGeometries',
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