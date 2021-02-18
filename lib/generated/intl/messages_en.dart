// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(appName) => "${appName} is available under the General Public License, version 3.";

  static m1(appName) => "ABOUT ${appName}";

  static m2(latitude, longitude) => "Lat: ${latitude} Lon: ${longitude}";

  static m3(query) => "Unable to geocode ${query}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "about_copyright" : MessageLookupByLibrary.simpleMessage("Copyright 2020, HydroloGIS S.r.l. -  some rights reserved. Tap to visit."),
    "about_legalInformation" : MessageLookupByLibrary.simpleMessage("Legal Information"),
    "about_license" : MessageLookupByLibrary.simpleMessage("License"),
    "about_licenseText" : m0,
    "about_loadingInformation" : MessageLookupByLibrary.simpleMessage("Loading information..."),
    "about_privacyPolicy" : MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "about_privacyPolicyText" : MessageLookupByLibrary.simpleMessage("Tap here to see the privacy policy that covers user and location data."),
    "about_sourceCode" : MessageLookupByLibrary.simpleMessage("Source Code"),
    "about_subtitle" : MessageLookupByLibrary.simpleMessage("Smart Mobile App for Surveyor\'s Happyness"),
    "about_supportedBy" : MessageLookupByLibrary.simpleMessage("Supported by"),
    "about_supportedByText" : MessageLookupByLibrary.simpleMessage("Partially supported by the project Steep Stream of the University of Trento."),
    "about_tapHereVisitRepository" : MessageLookupByLibrary.simpleMessage("Tap here to visit the source code repository"),
    "about_titleBar" : m1,
    "about_version" : MessageLookupByLibrary.simpleMessage("Application version"),
    "form_smash_utils_POI" : MessageLookupByLibrary.simpleMessage("POI"),
    "form_smash_utils_couldNotSaveImageInDatabase" : MessageLookupByLibrary.simpleMessage("Could not save image in database."),
    "geocoding_addressExample" : MessageLookupByLibrary.simpleMessage("Via Ipazia, 2"),
    "geocoding_enterAddress" : MessageLookupByLibrary.simpleMessage("Enter search address"),
    "geocoding_latLon" : m2,
    "geocoding_launchGeocoding" : MessageLookupByLibrary.simpleMessage("Launch Geocoding"),
    "geocoding_noAddressFound" : MessageLookupByLibrary.simpleMessage("Could not find any address."),
    "geocoding_nothingToSearch" : MessageLookupByLibrary.simpleMessage("Nothing to look for. Insert an address."),
    "geocoding_searching" : MessageLookupByLibrary.simpleMessage("Searching..."),
    "geocoding_title" : MessageLookupByLibrary.simpleMessage("Geocoding"),
    "geocoding_unableGeocode" : m3,
    "gss_import_credentialsError" : MessageLookupByLibrary.simpleMessage("No permission to access the server. Check your credentials."),
    "gss_import_data" : MessageLookupByLibrary.simpleMessage("Data"),
    "gss_import_dataDownload" : MessageLookupByLibrary.simpleMessage("Datasets are downloaded into the maps folder."),
    "gss_import_dataDownloadError" : MessageLookupByLibrary.simpleMessage("No data available."),
    "gss_import_downloadData" : MessageLookupByLibrary.simpleMessage("Downloading data list..."),
    "gss_import_downloadDataError" : MessageLookupByLibrary.simpleMessage("Unable to download data list due to an error. Check your settings and the log."),
    "gss_import_forms" : MessageLookupByLibrary.simpleMessage("Forms"),
    "gss_import_formsDownload" : MessageLookupByLibrary.simpleMessage("Tags files are downloaded into the forms folder."),
    "gss_import_formsDownloadError" : MessageLookupByLibrary.simpleMessage("No tags available."),
    "gss_import_gssImport" : MessageLookupByLibrary.simpleMessage("GSS Import"),
    "gss_import_noServerPassword" : MessageLookupByLibrary.simpleMessage("No GSS server password has been set. Check your settings."),
    "gss_import_noServerURL" : MessageLookupByLibrary.simpleMessage("No GSS server url has been set. Check your settings."),
    "gss_import_projects" : MessageLookupByLibrary.simpleMessage("Projects"),
    "gss_import_projectsDownload" : MessageLookupByLibrary.simpleMessage("Projects are downloaded into the projects folder."),
    "gss_import_projectsDownloadError" : MessageLookupByLibrary.simpleMessage("No projects available."),
    "import_widget_GSS" : MessageLookupByLibrary.simpleMessage("GSS"),
    "import_widget_import" : MessageLookupByLibrary.simpleMessage("Import"),
    "import_widget_importFromGSS" : MessageLookupByLibrary.simpleMessage("Import from Geopaparazzi Survey Server"),
    "main_anErrorOccurredTapToView" : MessageLookupByLibrary.simpleMessage("An error occurred. Tap to view."),
    "main_check_location_permission" : MessageLookupByLibrary.simpleMessage("Checking location permission..."),
    "main_checkingStoragePermission" : MessageLookupByLibrary.simpleMessage("Checking storage permission..."),
    "main_fencesLoaded" : MessageLookupByLibrary.simpleMessage("Fences loaded."),
    "main_knownProjectionsLoaded" : MessageLookupByLibrary.simpleMessage("Known projections loaded."),
    "main_layersListLoaded" : MessageLookupByLibrary.simpleMessage("Layers list loaded."),
    "main_loadingFences" : MessageLookupByLibrary.simpleMessage("Loading fences..."),
    "main_loadingKnownProjections" : MessageLookupByLibrary.simpleMessage("Loading known projections..."),
    "main_loadingLayersList" : MessageLookupByLibrary.simpleMessage("Loading layers list..."),
    "main_loadingPreferences" : MessageLookupByLibrary.simpleMessage("Loading preferences..."),
    "main_loadingTagsList" : MessageLookupByLibrary.simpleMessage("Loading tags list..."),
    "main_loadingWorkspace" : MessageLookupByLibrary.simpleMessage("Loading workspace..."),
    "main_locationBackgroundWarning" : MessageLookupByLibrary.simpleMessage("This app collects location data to your device to enable gps logs recording even when the app is placed in background. No data is shared, it is only saved locally to the device.\n\nIf you do not give permission to the background location service in the next dialog, you will still be able to collect data with SMASH, but will need to keep the app always in foreground to do so.\n"),
    "main_locationPermissionIsMandatoryToOpenSmash" : MessageLookupByLibrary.simpleMessage("Location permission is mandatory to open SMASH."),
    "main_location_permission_granted" : MessageLookupByLibrary.simpleMessage("Location permission granted."),
    "main_preferencesLoaded" : MessageLookupByLibrary.simpleMessage("Preferences loaded."),
    "main_storagePermissionGranted" : MessageLookupByLibrary.simpleMessage("Storage permission granted."),
    "main_storagePermissionIsMandatoryToOpenSmash" : MessageLookupByLibrary.simpleMessage("Storage permission is mandatory to open SMASH."),
    "main_tagsListLoaded" : MessageLookupByLibrary.simpleMessage("Tags list loaded."),
    "main_welcome" : MessageLookupByLibrary.simpleMessage("Welcome to SMASH!"),
    "main_workspaceLoaded" : MessageLookupByLibrary.simpleMessage("Workspace loaded."),
    "mainview_activeOperationsWillBeStopped" : MessageLookupByLibrary.simpleMessage("Active operations will be stopped."),
    "mainview_areYouSureYouWantToCloseTheProject" : MessageLookupByLibrary.simpleMessage("Are you sure you want to close the project?"),
    "mainview_enterNoteInGPSPosition" : MessageLookupByLibrary.simpleMessage("Enter note in GPS position."),
    "mainview_enterNoteInTheMapCenter" : MessageLookupByLibrary.simpleMessage("Enter note in the map center."),
    "mainview_image" : MessageLookupByLibrary.simpleMessage("image"),
    "mainview_keyDidShowMainViewCoachMarks" : MessageLookupByLibrary.simpleMessage("key_did_show_main_view_coach_marks"),
    "mainview_loadingData" : MessageLookupByLibrary.simpleMessage("Loading data..."),
    "mainview_note" : MessageLookupByLibrary.simpleMessage("note"),
    "mainview_openToolsDrawer" : MessageLookupByLibrary.simpleMessage("Open tools drawer."),
    "mainview_showInteractiveCoachMarks" : MessageLookupByLibrary.simpleMessage("Show interactive coach marks."),
    "mainview_simpleForm" : MessageLookupByLibrary.simpleMessage("Simple Form"),
    "mainview_simpleNotes" : MessageLookupByLibrary.simpleMessage("Simple Notes"),
    "mainview_turnGPSoff" : MessageLookupByLibrary.simpleMessage("Turn GPS off"),
    "mainview_turnGPSon" : MessageLookupByLibrary.simpleMessage("Turn GPS on"),
    "mainview_utils_about" : MessageLookupByLibrary.simpleMessage("About"),
    "mainview_utils_accuracy" : MessageLookupByLibrary.simpleMessage("Accuracy"),
    "mainview_utils_altitude" : MessageLookupByLibrary.simpleMessage("Altitude"),
    "mainview_utils_availableIcons" : MessageLookupByLibrary.simpleMessage("Available icons"),
    "mainview_utils_database" : MessageLookupByLibrary.simpleMessage("Database"),
    "mainview_utils_export" : MessageLookupByLibrary.simpleMessage("Export"),
    "mainview_utils_extras" : MessageLookupByLibrary.simpleMessage("Extras"),
    "mainview_utils_goTo" : MessageLookupByLibrary.simpleMessage("Go to"),
    "mainview_utils_import" : MessageLookupByLibrary.simpleMessage("Import"),
    "mainview_utils_latitude" : MessageLookupByLibrary.simpleMessage("Latitude"),
    "mainview_utils_longitude" : MessageLookupByLibrary.simpleMessage("Longitude"),
    "mainview_utils_offlineMaps" : MessageLookupByLibrary.simpleMessage("Offline maps"),
    "mainview_utils_onlineHelp" : MessageLookupByLibrary.simpleMessage("Online Help"),
    "mainview_utils_positionTools" : MessageLookupByLibrary.simpleMessage("Position Tools"),
    "mainview_utils_project" : MessageLookupByLibrary.simpleMessage("Project"),
    "mainview_utils_projectInfo" : MessageLookupByLibrary.simpleMessage("Project Info"),
    "mainview_utils_projects" : MessageLookupByLibrary.simpleMessage("Projects"),
    "mainview_utils_rotateMapWithGPS" : MessageLookupByLibrary.simpleMessage("Rotate map with GPS"),
    "mainview_utils_settings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "mainview_utils_sharePosition" : MessageLookupByLibrary.simpleMessage("Share position"),
    "mainview_utils_timestamp" : MessageLookupByLibrary.simpleMessage("Timestamp"),
    "mainview_zoomIn" : MessageLookupByLibrary.simpleMessage("Zoom in"),
    "mainview_zoomOut" : MessageLookupByLibrary.simpleMessage("Zoom out"),
    "toolbar_tools_cancelEdits" : MessageLookupByLibrary.simpleMessage("Cancel current edit."),
    "toolbar_tools_measureDistance" : MessageLookupByLibrary.simpleMessage("Measure distances on the map with your finger."),
    "toolbar_tools_modifyGeometries" : MessageLookupByLibrary.simpleMessage("Modify geometries in editable vector layers."),
    "toolbar_tools_noPrimaryKey" : MessageLookupByLibrary.simpleMessage("The feature does not have a primary key. Editing is not allowed."),
    "toolbar_tools_queryFeatures" : MessageLookupByLibrary.simpleMessage("Query features from loaded vector layers."),
    "toolbar_tools_removeFeature" : MessageLookupByLibrary.simpleMessage("Remove selected feature."),
    "toolbar_tools_saveEdits" : MessageLookupByLibrary.simpleMessage("Save current edit."),
    "toolbar_tools_showAttributes" : MessageLookupByLibrary.simpleMessage("Show feature attributes."),
    "toolbar_tools_toggleFence" : MessageLookupByLibrary.simpleMessage("Toggle fence in map center."),
    "toolbar_tools_zoomIn" : MessageLookupByLibrary.simpleMessage("Zoom in"),
    "toolbar_tools_zoomOut" : MessageLookupByLibrary.simpleMessage("Zoom out")
  };
}
