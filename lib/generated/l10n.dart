import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_cs.dart';
import 'l10n_de.dart';
import 'l10n_en.dart';
import 'l10n_fr.dart';
import 'l10n_it.dart';
import 'l10n_ja.dart';
import 'l10n_nb.dart';
import 'l10n_ru.dart';
import 'l10n_zh.dart';

/// Callers can lookup localized strings with an instance of SL
/// returned by `SL.of(context)`.
///
/// Applications need to include `SL.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SL.localizationsDelegates,
///   supportedLocales: SL.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the SL.supportedLocales
/// property.
abstract class SL {
  SL(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SL of(BuildContext context) {
    return Localizations.of<SL>(context, SL)!;
  }

  static const LocalizationsDelegate<SL> delegate = _SLDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('cs'),
    Locale('de'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('nb'),
    Locale('nb', 'NO'),
    Locale('ru'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')
  ];

  /// No description provided for @main_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to SMASH!'**
  String get main_welcome;

  /// No description provided for @main_check_location_permission.
  ///
  /// In en, this message translates to:
  /// **'Checking location permission…'**
  String get main_check_location_permission;

  /// No description provided for @main_location_permission_granted.
  ///
  /// In en, this message translates to:
  /// **'Location permission granted.'**
  String get main_location_permission_granted;

  /// No description provided for @main_checkingStoragePermission.
  ///
  /// In en, this message translates to:
  /// **'Checking storage permission…'**
  String get main_checkingStoragePermission;

  /// No description provided for @main_storagePermissionGranted.
  ///
  /// In en, this message translates to:
  /// **'Storage permission granted.'**
  String get main_storagePermissionGranted;

  /// No description provided for @main_loadingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Loading preferences…'**
  String get main_loadingPreferences;

  /// No description provided for @main_preferencesLoaded.
  ///
  /// In en, this message translates to:
  /// **'Preferences loaded.'**
  String get main_preferencesLoaded;

  /// No description provided for @main_loadingWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Loading workspace…'**
  String get main_loadingWorkspace;

  /// No description provided for @main_workspaceLoaded.
  ///
  /// In en, this message translates to:
  /// **'Workspace loaded.'**
  String get main_workspaceLoaded;

  /// No description provided for @main_loadingTagsList.
  ///
  /// In en, this message translates to:
  /// **'Loading tags list…'**
  String get main_loadingTagsList;

  /// No description provided for @main_tagsListLoaded.
  ///
  /// In en, this message translates to:
  /// **'Tags list loaded.'**
  String get main_tagsListLoaded;

  /// No description provided for @main_loadingKnownProjections.
  ///
  /// In en, this message translates to:
  /// **'Loading known projections…'**
  String get main_loadingKnownProjections;

  /// No description provided for @main_knownProjectionsLoaded.
  ///
  /// In en, this message translates to:
  /// **'Known projections loaded.'**
  String get main_knownProjectionsLoaded;

  /// No description provided for @main_loadingFences.
  ///
  /// In en, this message translates to:
  /// **'Loading fences…'**
  String get main_loadingFences;

  /// No description provided for @main_fencesLoaded.
  ///
  /// In en, this message translates to:
  /// **'Fences loaded.'**
  String get main_fencesLoaded;

  /// No description provided for @main_loadingLayersList.
  ///
  /// In en, this message translates to:
  /// **'Loading layers list…'**
  String get main_loadingLayersList;

  /// No description provided for @main_layersListLoaded.
  ///
  /// In en, this message translates to:
  /// **'Layers list loaded.'**
  String get main_layersListLoaded;

  /// No description provided for @main_locationBackgroundWarning.
  ///
  /// In en, this message translates to:
  /// **'Grant location permission in the next step to allow GPS logging in the background. (Otherwise it only works in the foreground.)\nNo data is shared, and only saved locally on the device.'**
  String get main_locationBackgroundWarning;

  /// No description provided for @main_StorageIsInternalWarning.
  ///
  /// In en, this message translates to:
  /// **'Please read carefully!\nOn Android 11 and above, the SMASH project folder must be placed in the\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\nfolder in your storage to be used.\nIf the app is uninstalled, the system removes it, so back up your data if you do.\n\nA better solution is in the works.'**
  String get main_StorageIsInternalWarning;

  /// No description provided for @main_locationPermissionIsMandatoryToOpenSmash.
  ///
  /// In en, this message translates to:
  /// **'Location permission is mandatory to open SMASH.'**
  String get main_locationPermissionIsMandatoryToOpenSmash;

  /// No description provided for @main_storagePermissionIsMandatoryToOpenSmash.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is mandatory to open SMASH.'**
  String get main_storagePermissionIsMandatoryToOpenSmash;

  /// No description provided for @main_anErrorOccurredTapToView.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Tap to view.'**
  String get main_anErrorOccurredTapToView;

  /// No description provided for @mainView_loadingData.
  ///
  /// In en, this message translates to:
  /// **'Loading data…'**
  String get mainView_loadingData;

  /// No description provided for @mainView_turnGpsOn.
  ///
  /// In en, this message translates to:
  /// **'Turn GPS on'**
  String get mainView_turnGpsOn;

  /// No description provided for @mainView_turnGpsOff.
  ///
  /// In en, this message translates to:
  /// **'Turn GPS off'**
  String get mainView_turnGpsOff;

  /// No description provided for @mainView_exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get mainView_exit;

  /// No description provided for @mainView_areYouSureCloseTheProject.
  ///
  /// In en, this message translates to:
  /// **'Close the project?'**
  String get mainView_areYouSureCloseTheProject;

  /// No description provided for @mainView_activeOperationsWillBeStopped.
  ///
  /// In en, this message translates to:
  /// **'Active operations will be stopped.'**
  String get mainView_activeOperationsWillBeStopped;

  /// No description provided for @mainView_showInteractiveCoachMarks.
  ///
  /// In en, this message translates to:
  /// **'Show interactive coach marks.'**
  String get mainView_showInteractiveCoachMarks;

  /// No description provided for @mainView_openToolsDrawer.
  ///
  /// In en, this message translates to:
  /// **'Open tools drawer.'**
  String get mainView_openToolsDrawer;

  /// No description provided for @mainView_zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get mainView_zoomIn;

  /// No description provided for @mainView_zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get mainView_zoomOut;

  /// No description provided for @mainView_formNotes.
  ///
  /// In en, this message translates to:
  /// **'Form Notes'**
  String get mainView_formNotes;

  /// No description provided for @mainView_simpleNotes.
  ///
  /// In en, this message translates to:
  /// **'Simple Notes'**
  String get mainView_simpleNotes;

  /// No description provided for @mainviewUtils_projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get mainviewUtils_projects;

  /// No description provided for @mainviewUtils_import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get mainviewUtils_import;

  /// No description provided for @mainviewUtils_export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get mainviewUtils_export;

  /// No description provided for @mainviewUtils_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get mainviewUtils_settings;

  /// No description provided for @mainviewUtils_onlineHelp.
  ///
  /// In en, this message translates to:
  /// **'Online Help'**
  String get mainviewUtils_onlineHelp;

  /// No description provided for @mainviewUtils_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get mainviewUtils_about;

  /// No description provided for @mainviewUtils_projectInfo.
  ///
  /// In en, this message translates to:
  /// **'Project Info'**
  String get mainviewUtils_projectInfo;

  /// No description provided for @mainviewUtils_project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get mainviewUtils_project;

  /// No description provided for @mainviewUtils_database.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get mainviewUtils_database;

  /// No description provided for @mainviewUtils_extras.
  ///
  /// In en, this message translates to:
  /// **'Extras'**
  String get mainviewUtils_extras;

  /// No description provided for @mainviewUtils_availableIcons.
  ///
  /// In en, this message translates to:
  /// **'Available icons'**
  String get mainviewUtils_availableIcons;

  /// No description provided for @mainviewUtils_offlineMaps.
  ///
  /// In en, this message translates to:
  /// **'Offline maps'**
  String get mainviewUtils_offlineMaps;

  /// No description provided for @mainviewUtils_positionTools.
  ///
  /// In en, this message translates to:
  /// **'Position Tools'**
  String get mainviewUtils_positionTools;

  /// No description provided for @mainviewUtils_goTo.
  ///
  /// In en, this message translates to:
  /// **'Go to'**
  String get mainviewUtils_goTo;

  /// No description provided for @mainviewUtils_goToCoordinate.
  ///
  /// In en, this message translates to:
  /// **'Go to coordinate'**
  String get mainviewUtils_goToCoordinate;

  /// No description provided for @mainviewUtils_enterLonLat.
  ///
  /// In en, this message translates to:
  /// **'Enter longitude, latitude'**
  String get mainviewUtils_enterLonLat;

  /// No description provided for @mainviewUtils_goToCoordinateWrongFormat.
  ///
  /// In en, this message translates to:
  /// **'Wrong coordinate format. Should be: 11.18463, 46.12345'**
  String get mainviewUtils_goToCoordinateWrongFormat;

  /// No description provided for @mainviewUtils_goToCoordinateEmpty.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be empty.'**
  String get mainviewUtils_goToCoordinateEmpty;

  /// No description provided for @mainviewUtils_sharePosition.
  ///
  /// In en, this message translates to:
  /// **'Share position'**
  String get mainviewUtils_sharePosition;

  /// No description provided for @mainviewUtils_rotateMapWithGps.
  ///
  /// In en, this message translates to:
  /// **'Rotate map with GPS'**
  String get mainviewUtils_rotateMapWithGps;

  /// No description provided for @exportWidget_export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportWidget_export;

  /// No description provided for @exportWidget_pdfExported.
  ///
  /// In en, this message translates to:
  /// **'PDF exported'**
  String get exportWidget_pdfExported;

  /// No description provided for @exportWidget_exportToPortableDocumentFormat.
  ///
  /// In en, this message translates to:
  /// **'Export project to Portable Document Format'**
  String get exportWidget_exportToPortableDocumentFormat;

  /// No description provided for @exportWidget_gpxExported.
  ///
  /// In en, this message translates to:
  /// **'GPX exported'**
  String get exportWidget_gpxExported;

  /// No description provided for @exportWidget_exportToGpx.
  ///
  /// In en, this message translates to:
  /// **'Export project to GPX'**
  String get exportWidget_exportToGpx;

  /// No description provided for @exportWidget_kmlExported.
  ///
  /// In en, this message translates to:
  /// **'KML exported'**
  String get exportWidget_kmlExported;

  /// No description provided for @exportWidget_exportToKml.
  ///
  /// In en, this message translates to:
  /// **'Export project to KML'**
  String get exportWidget_exportToKml;

  /// No description provided for @exportWidget_imagesToFolderExported.
  ///
  /// In en, this message translates to:
  /// **'Images exported'**
  String get exportWidget_imagesToFolderExported;

  /// No description provided for @exportWidget_exportImagesToFolder.
  ///
  /// In en, this message translates to:
  /// **'Export project images to folder'**
  String get exportWidget_exportImagesToFolder;

  /// No description provided for @exportWidget_exportImagesToFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get exportWidget_exportImagesToFolderTitle;

  /// No description provided for @exportWidget_geopackageExported.
  ///
  /// In en, this message translates to:
  /// **'Geopackage exported'**
  String get exportWidget_geopackageExported;

  /// No description provided for @exportWidget_exportToGeopackage.
  ///
  /// In en, this message translates to:
  /// **'Export project to Geopackage'**
  String get exportWidget_exportToGeopackage;

  /// No description provided for @exportWidget_exportToGSS.
  ///
  /// In en, this message translates to:
  /// **'Export to Geopaparazzi Survey Server'**
  String get exportWidget_exportToGSS;

  /// No description provided for @gssExport_gssExport.
  ///
  /// In en, this message translates to:
  /// **'GSS Export'**
  String get gssExport_gssExport;

  /// No description provided for @gssExport_setProjectDirty.
  ///
  /// In en, this message translates to:
  /// **'Set project to DIRTY?'**
  String get gssExport_setProjectDirty;

  /// No description provided for @gssExport_thisCantBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone!'**
  String get gssExport_thisCantBeUndone;

  /// No description provided for @gssExport_restoreProjectAsDirty.
  ///
  /// In en, this message translates to:
  /// **'Restore project as all dirty.'**
  String get gssExport_restoreProjectAsDirty;

  /// No description provided for @gssExport_setProjectClean.
  ///
  /// In en, this message translates to:
  /// **'Set project to CLEAN?'**
  String get gssExport_setProjectClean;

  /// No description provided for @gssExport_restoreProjectAsClean.
  ///
  /// In en, this message translates to:
  /// **'Restore project as all clean.'**
  String get gssExport_restoreProjectAsClean;

  /// No description provided for @gssExport_nothingToSync.
  ///
  /// In en, this message translates to:
  /// **'Nothing to sync.'**
  String get gssExport_nothingToSync;

  /// No description provided for @gssExport_collectingSyncStats.
  ///
  /// In en, this message translates to:
  /// **'Collecting sync stats…'**
  String get gssExport_collectingSyncStats;

  /// No description provided for @gssExport_unableToSyncDueToError.
  ///
  /// In en, this message translates to:
  /// **'Unable to sync due to an error, check diagnostics.'**
  String get gssExport_unableToSyncDueToError;

  /// No description provided for @gssExport_noGssUrlSet.
  ///
  /// In en, this message translates to:
  /// **'No GSS server URL has been set. Check your settings.'**
  String get gssExport_noGssUrlSet;

  /// No description provided for @gssExport_noGssPasswordSet.
  ///
  /// In en, this message translates to:
  /// **'No GSS server password has been set. Check your settings.'**
  String get gssExport_noGssPasswordSet;

  /// No description provided for @gssExport_synStats.
  ///
  /// In en, this message translates to:
  /// **'Sync Stats'**
  String get gssExport_synStats;

  /// No description provided for @gssExport_followingDataWillBeUploaded.
  ///
  /// In en, this message translates to:
  /// **'The following data will be uploaded upon sync.'**
  String get gssExport_followingDataWillBeUploaded;

  /// No description provided for @gssExport_gpsLogs.
  ///
  /// In en, this message translates to:
  /// **'GPS Logs:'**
  String get gssExport_gpsLogs;

  /// No description provided for @gssExport_simpleNotes.
  ///
  /// In en, this message translates to:
  /// **'Simple Notes:'**
  String get gssExport_simpleNotes;

  /// No description provided for @gssExport_formNotes.
  ///
  /// In en, this message translates to:
  /// **'Form Notes:'**
  String get gssExport_formNotes;

  /// No description provided for @gssExport_images.
  ///
  /// In en, this message translates to:
  /// **'Images:'**
  String get gssExport_images;

  /// No description provided for @gssExport_shouldNotHappen.
  ///
  /// In en, this message translates to:
  /// **'Should not happen'**
  String get gssExport_shouldNotHappen;

  /// No description provided for @gssExport_upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get gssExport_upload;

  /// No description provided for @geocoding_geocoding.
  ///
  /// In en, this message translates to:
  /// **'Geocoding'**
  String get geocoding_geocoding;

  /// No description provided for @geocoding_nothingToLookFor.
  ///
  /// In en, this message translates to:
  /// **'Nothing to look for. Insert an address.'**
  String get geocoding_nothingToLookFor;

  /// No description provided for @geocoding_launchGeocoding.
  ///
  /// In en, this message translates to:
  /// **'Launch Geocoding'**
  String get geocoding_launchGeocoding;

  /// No description provided for @geocoding_searching.
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get geocoding_searching;

  /// No description provided for @gps_smashIsActive.
  ///
  /// In en, this message translates to:
  /// **'SMASH is active'**
  String get gps_smashIsActive;

  /// No description provided for @gps_smashIsLogging.
  ///
  /// In en, this message translates to:
  /// **'SMASH is logging'**
  String get gps_smashIsLogging;

  /// No description provided for @gps_locationTracking.
  ///
  /// In en, this message translates to:
  /// **'Location tracking'**
  String get gps_locationTracking;

  /// No description provided for @gps_smashLocServiceIsActive.
  ///
  /// In en, this message translates to:
  /// **'SMASH location service is active.'**
  String get gps_smashLocServiceIsActive;

  /// No description provided for @gps_backgroundLocIsOnToKeepRegistering.
  ///
  /// In en, this message translates to:
  /// **'Background location is on to keep the app registering the location even when the app is in background.'**
  String get gps_backgroundLocIsOnToKeepRegistering;

  /// No description provided for @gssImport_gssImport.
  ///
  /// In en, this message translates to:
  /// **'GSS Import'**
  String get gssImport_gssImport;

  /// No description provided for @gssImport_downloadingDataList.
  ///
  /// In en, this message translates to:
  /// **'Downloading data list…'**
  String get gssImport_downloadingDataList;

  /// No description provided for @gssImport_unableDownloadDataList.
  ///
  /// In en, this message translates to:
  /// **'Unable to download data list due to an error. Check your settings and the log.'**
  String get gssImport_unableDownloadDataList;

  /// No description provided for @gssImport_noGssUrlSet.
  ///
  /// In en, this message translates to:
  /// **'No GSS server URL has been set. Check your settings.'**
  String get gssImport_noGssUrlSet;

  /// No description provided for @gssImport_noGssPasswordSet.
  ///
  /// In en, this message translates to:
  /// **'No GSS server password has been set. Check your settings.'**
  String get gssImport_noGssPasswordSet;

  /// No description provided for @gssImport_noPermToAccessServer.
  ///
  /// In en, this message translates to:
  /// **'No permission to access the server. Check your credentials.'**
  String get gssImport_noPermToAccessServer;

  /// No description provided for @gssImport_data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get gssImport_data;

  /// No description provided for @gssImport_dataSetsDownloadedMapsFolder.
  ///
  /// In en, this message translates to:
  /// **'Datasets are downloaded into the maps folder.'**
  String get gssImport_dataSetsDownloadedMapsFolder;

  /// No description provided for @gssImport_noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available.'**
  String get gssImport_noDataAvailable;

  /// No description provided for @gssImport_projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get gssImport_projects;

  /// No description provided for @gssImport_projectsDownloadedProjectFolder.
  ///
  /// In en, this message translates to:
  /// **'Projects are downloaded into the projects folder.'**
  String get gssImport_projectsDownloadedProjectFolder;

  /// No description provided for @gssImport_noProjectsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No projects available.'**
  String get gssImport_noProjectsAvailable;

  /// No description provided for @gssImport_forms.
  ///
  /// In en, this message translates to:
  /// **'Forms'**
  String get gssImport_forms;

  /// No description provided for @gssImport_tagsDownloadedFormsFolder.
  ///
  /// In en, this message translates to:
  /// **'Tags files are downloaded into the forms folder.'**
  String get gssImport_tagsDownloadedFormsFolder;

  /// No description provided for @gssImport_noTagsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No tags available.'**
  String get gssImport_noTagsAvailable;

  /// No description provided for @importWidget_import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importWidget_import;

  /// No description provided for @importWidget_importFromGeopaparazzi.
  ///
  /// In en, this message translates to:
  /// **'Import from Geopaparazzi Survey Server'**
  String get importWidget_importFromGeopaparazzi;

  /// No description provided for @layersView_layerList.
  ///
  /// In en, this message translates to:
  /// **'Layers List'**
  String get layersView_layerList;

  /// No description provided for @layersView_loadRemoteDatabase.
  ///
  /// In en, this message translates to:
  /// **'Load remote database'**
  String get layersView_loadRemoteDatabase;

  /// No description provided for @layersView_loadOnlineSources.
  ///
  /// In en, this message translates to:
  /// **'Load online sources'**
  String get layersView_loadOnlineSources;

  /// No description provided for @layersView_loadLocalDatasets.
  ///
  /// In en, this message translates to:
  /// **'Load local datasets'**
  String get layersView_loadLocalDatasets;

  /// No description provided for @layersView_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get layersView_loading;

  /// No description provided for @layersView_zoomTo.
  ///
  /// In en, this message translates to:
  /// **'Zoom to'**
  String get layersView_zoomTo;

  /// No description provided for @layersView_properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get layersView_properties;

  /// No description provided for @layersView_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get layersView_delete;

  /// No description provided for @layersView_projCouldNotBeRecognized.
  ///
  /// In en, this message translates to:
  /// **'The proj could not be recognised. Tap to enter epsg manually.'**
  String get layersView_projCouldNotBeRecognized;

  /// No description provided for @layersView_projNotSupported.
  ///
  /// In en, this message translates to:
  /// **'The proj is not supported. Tap to solve.'**
  String get layersView_projNotSupported;

  /// No description provided for @layersView_onlyImageFilesWithWorldDef.
  ///
  /// In en, this message translates to:
  /// **'Only image files with world file definition are supported.'**
  String get layersView_onlyImageFilesWithWorldDef;

  /// No description provided for @layersView_onlyImageFileWithPrjDef.
  ///
  /// In en, this message translates to:
  /// **'Only image files with prj file definition are supported.'**
  String get layersView_onlyImageFileWithPrjDef;

  /// No description provided for @layersView_selectTableToLoad.
  ///
  /// In en, this message translates to:
  /// **'Select table to load.'**
  String get layersView_selectTableToLoad;

  /// No description provided for @layersView_fileFormatNotSUpported.
  ///
  /// In en, this message translates to:
  /// **'File format not supported.'**
  String get layersView_fileFormatNotSUpported;

  /// No description provided for @onlineSourcesPage_onlineSourcesCatalog.
  ///
  /// In en, this message translates to:
  /// **'Online Sources Catalog'**
  String get onlineSourcesPage_onlineSourcesCatalog;

  /// No description provided for @onlineSourcesPage_loadingTmsLayers.
  ///
  /// In en, this message translates to:
  /// **'Loading TMS layers…'**
  String get onlineSourcesPage_loadingTmsLayers;

  /// No description provided for @onlineSourcesPage_loadingWmsLayers.
  ///
  /// In en, this message translates to:
  /// **'Loading WMS layers…'**
  String get onlineSourcesPage_loadingWmsLayers;

  /// No description provided for @onlineSourcesPage_importFromFile.
  ///
  /// In en, this message translates to:
  /// **'Import from file'**
  String get onlineSourcesPage_importFromFile;

  /// No description provided for @onlineSourcesPage_theFile.
  ///
  /// In en, this message translates to:
  /// **'The file'**
  String get onlineSourcesPage_theFile;

  /// No description provided for @onlineSourcesPage_doesntExist.
  ///
  /// In en, this message translates to:
  /// **'doesn\'t exist'**
  String get onlineSourcesPage_doesntExist;

  /// No description provided for @onlineSourcesPage_onlineSourcesImported.
  ///
  /// In en, this message translates to:
  /// **'Online sources imported.'**
  String get onlineSourcesPage_onlineSourcesImported;

  /// No description provided for @onlineSourcesPage_exportToFile.
  ///
  /// In en, this message translates to:
  /// **'Export to file'**
  String get onlineSourcesPage_exportToFile;

  /// No description provided for @onlineSourcesPage_exportedTo.
  ///
  /// In en, this message translates to:
  /// **'Exported to:'**
  String get onlineSourcesPage_exportedTo;

  /// No description provided for @onlineSourcesPage_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get onlineSourcesPage_delete;

  /// No description provided for @onlineSourcesPage_addToLayers.
  ///
  /// In en, this message translates to:
  /// **'Add to layers'**
  String get onlineSourcesPage_addToLayers;

  /// No description provided for @onlineSourcesPage_setNameTmsService.
  ///
  /// In en, this message translates to:
  /// **'Set a name for the TMS service'**
  String get onlineSourcesPage_setNameTmsService;

  /// No description provided for @onlineSourcesPage_enterName.
  ///
  /// In en, this message translates to:
  /// **'enter name'**
  String get onlineSourcesPage_enterName;

  /// No description provided for @onlineSourcesPage_pleaseEnterValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name'**
  String get onlineSourcesPage_pleaseEnterValidName;

  /// No description provided for @onlineSourcesPage_insertUrlOfService.
  ///
  /// In en, this message translates to:
  /// **'Insert the URL of the service.'**
  String get onlineSourcesPage_insertUrlOfService;

  /// No description provided for @onlineSourcesPage_placeXyzBetBrackets.
  ///
  /// In en, this message translates to:
  /// **'Place the x, y, z between curly brackets.'**
  String get onlineSourcesPage_placeXyzBetBrackets;

  /// No description provided for @onlineSourcesPage_pleaseEnterValidTmsUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid TMS URL'**
  String get onlineSourcesPage_pleaseEnterValidTmsUrl;

  /// No description provided for @onlineSourcesPage_enterUrl.
  ///
  /// In en, this message translates to:
  /// **'enter URL'**
  String get onlineSourcesPage_enterUrl;

  /// No description provided for @onlineSourcesPage_enterSubDomains.
  ///
  /// In en, this message translates to:
  /// **'enter subdomains'**
  String get onlineSourcesPage_enterSubDomains;

  /// No description provided for @onlineSourcesPage_addAttribution.
  ///
  /// In en, this message translates to:
  /// **'Add an attribution.'**
  String get onlineSourcesPage_addAttribution;

  /// No description provided for @onlineSourcesPage_enterAttribution.
  ///
  /// In en, this message translates to:
  /// **'enter attribution'**
  String get onlineSourcesPage_enterAttribution;

  /// No description provided for @onlineSourcesPage_setMinMaxZoom.
  ///
  /// In en, this message translates to:
  /// **'Set min and max zoom.'**
  String get onlineSourcesPage_setMinMaxZoom;

  /// No description provided for @onlineSourcesPage_minZoom.
  ///
  /// In en, this message translates to:
  /// **'Min zoom'**
  String get onlineSourcesPage_minZoom;

  /// No description provided for @onlineSourcesPage_maxZoom.
  ///
  /// In en, this message translates to:
  /// **'Max zoom'**
  String get onlineSourcesPage_maxZoom;

  /// No description provided for @onlineSourcesPage_pleaseCheckYourData.
  ///
  /// In en, this message translates to:
  /// **'Please check your data'**
  String get onlineSourcesPage_pleaseCheckYourData;

  /// No description provided for @onlineSourcesPage_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get onlineSourcesPage_details;

  /// No description provided for @onlineSourcesPage_name.
  ///
  /// In en, this message translates to:
  /// **'Name: '**
  String get onlineSourcesPage_name;

  /// No description provided for @onlineSourcesPage_subDomains.
  ///
  /// In en, this message translates to:
  /// **'Subdomains: '**
  String get onlineSourcesPage_subDomains;

  /// No description provided for @onlineSourcesPage_attribution.
  ///
  /// In en, this message translates to:
  /// **'Attribution: '**
  String get onlineSourcesPage_attribution;

  /// No description provided for @onlineSourcesPage_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get onlineSourcesPage_cancel;

  /// No description provided for @onlineSourcesPage_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get onlineSourcesPage_ok;

  /// No description provided for @onlineSourcesPage_newTmsOnlineService.
  ///
  /// In en, this message translates to:
  /// **'New TMS Online Service'**
  String get onlineSourcesPage_newTmsOnlineService;

  /// No description provided for @onlineSourcesPage_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get onlineSourcesPage_save;

  /// No description provided for @onlineSourcesPage_theBaseUrlWithQuestionMark.
  ///
  /// In en, this message translates to:
  /// **'The base URL-ending with question mark.'**
  String get onlineSourcesPage_theBaseUrlWithQuestionMark;

  /// No description provided for @onlineSourcesPage_pleaseEnterValidWmsUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid WMS URL'**
  String get onlineSourcesPage_pleaseEnterValidWmsUrl;

  /// No description provided for @onlineSourcesPage_setWmsLayerName.
  ///
  /// In en, this message translates to:
  /// **'Set WMS layer name'**
  String get onlineSourcesPage_setWmsLayerName;

  /// No description provided for @onlineSourcesPage_enterLayerToLoad.
  ///
  /// In en, this message translates to:
  /// **'enter layer to load'**
  String get onlineSourcesPage_enterLayerToLoad;

  /// No description provided for @onlineSourcesPage_pleaseEnterValidLayer.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid layer'**
  String get onlineSourcesPage_pleaseEnterValidLayer;

  /// No description provided for @onlineSourcesPage_setWmsImageFormat.
  ///
  /// In en, this message translates to:
  /// **'Set WMS image format'**
  String get onlineSourcesPage_setWmsImageFormat;

  /// No description provided for @onlineSourcesPage_addAnAttribution.
  ///
  /// In en, this message translates to:
  /// **'Add an attribution.'**
  String get onlineSourcesPage_addAnAttribution;

  /// No description provided for @onlineSourcesPage_layer.
  ///
  /// In en, this message translates to:
  /// **'Layer: '**
  String get onlineSourcesPage_layer;

  /// No description provided for @onlineSourcesPage_url.
  ///
  /// In en, this message translates to:
  /// **'URL: '**
  String get onlineSourcesPage_url;

  /// No description provided for @onlineSourcesPage_format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get onlineSourcesPage_format;

  /// No description provided for @onlineSourcesPage_newWmsOnlineService.
  ///
  /// In en, this message translates to:
  /// **'New WMS Online Service'**
  String get onlineSourcesPage_newWmsOnlineService;

  /// No description provided for @remoteDbPage_remoteDatabases.
  ///
  /// In en, this message translates to:
  /// **'Remote Databases'**
  String get remoteDbPage_remoteDatabases;

  /// No description provided for @remoteDbPage_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get remoteDbPage_delete;

  /// No description provided for @remoteDbPage_areYouSureDeleteDatabase.
  ///
  /// In en, this message translates to:
  /// **'Delete the database configuration?'**
  String get remoteDbPage_areYouSureDeleteDatabase;

  /// No description provided for @remoteDbPage_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get remoteDbPage_edit;

  /// No description provided for @remoteDbPage_table.
  ///
  /// In en, this message translates to:
  /// **'table'**
  String get remoteDbPage_table;

  /// No description provided for @remoteDbPage_user.
  ///
  /// In en, this message translates to:
  /// **'user'**
  String get remoteDbPage_user;

  /// No description provided for @remoteDbPage_loadInMap.
  ///
  /// In en, this message translates to:
  /// **'Load in map.'**
  String get remoteDbPage_loadInMap;

  /// No description provided for @remoteDbPage_databaseParameters.
  ///
  /// In en, this message translates to:
  /// **'Database Parameters'**
  String get remoteDbPage_databaseParameters;

  /// No description provided for @remoteDbPage_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get remoteDbPage_cancel;

  /// No description provided for @remoteDbPage_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get remoteDbPage_ok;

  /// No description provided for @remoteDbPage_theUrlNeedsToBeDefined.
  ///
  /// In en, this message translates to:
  /// **'The URL must be defined (postgis:host:port/databasename)'**
  String get remoteDbPage_theUrlNeedsToBeDefined;

  /// No description provided for @remoteDbPage_theUserNeedsToBeDefined.
  ///
  /// In en, this message translates to:
  /// **'A user must be defined.'**
  String get remoteDbPage_theUserNeedsToBeDefined;

  /// No description provided for @remoteDbPage_password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get remoteDbPage_password;

  /// No description provided for @remoteDbPage_thePasswordNeedsToBeDefined.
  ///
  /// In en, this message translates to:
  /// **'A password must be defined.'**
  String get remoteDbPage_thePasswordNeedsToBeDefined;

  /// No description provided for @remoteDbPage_loadingTables.
  ///
  /// In en, this message translates to:
  /// **'Loading tables…'**
  String get remoteDbPage_loadingTables;

  /// No description provided for @remoteDbPage_theTableNeedsToBeDefined.
  ///
  /// In en, this message translates to:
  /// **'The table name must be defined.'**
  String get remoteDbPage_theTableNeedsToBeDefined;

  /// No description provided for @remoteDbPage_unableToConnectToDatabase.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the database. Check parameters and network.'**
  String get remoteDbPage_unableToConnectToDatabase;

  /// No description provided for @remoteDbPage_optionalWhereCondition.
  ///
  /// In en, this message translates to:
  /// **'optional \"where\" condition'**
  String get remoteDbPage_optionalWhereCondition;

  /// No description provided for @geoImage_tiffProperties.
  ///
  /// In en, this message translates to:
  /// **'TIFF Properties'**
  String get geoImage_tiffProperties;

  /// No description provided for @geoImage_opacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get geoImage_opacity;

  /// No description provided for @geoImage_colorToHide.
  ///
  /// In en, this message translates to:
  /// **'Color to hide'**
  String get geoImage_colorToHide;

  /// No description provided for @gpx_gpxProperties.
  ///
  /// In en, this message translates to:
  /// **'GPX Properties'**
  String get gpx_gpxProperties;

  /// No description provided for @gpx_wayPoints.
  ///
  /// In en, this message translates to:
  /// **'Waypoints'**
  String get gpx_wayPoints;

  /// No description provided for @gpx_color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get gpx_color;

  /// No description provided for @gpx_size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get gpx_size;

  /// No description provided for @gpx_viewLabelsIfAvailable.
  ///
  /// In en, this message translates to:
  /// **'View labels if available?'**
  String get gpx_viewLabelsIfAvailable;

  /// No description provided for @gpx_tracksRoutes.
  ///
  /// In en, this message translates to:
  /// **'Tracks/routes'**
  String get gpx_tracksRoutes;

  /// No description provided for @gpx_width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get gpx_width;

  /// No description provided for @gpx_palette.
  ///
  /// In en, this message translates to:
  /// **'Palette'**
  String get gpx_palette;

  /// No description provided for @tiles_tileProperties.
  ///
  /// In en, this message translates to:
  /// **'Tile Properties'**
  String get tiles_tileProperties;

  /// No description provided for @tiles_opacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get tiles_opacity;

  /// No description provided for @tiles_loadGeoPackageAsOverlay.
  ///
  /// In en, this message translates to:
  /// **'Load geopackage tiles as overlay image as opposed to tile layer (best for gdal generated data and different projections).'**
  String get tiles_loadGeoPackageAsOverlay;

  /// No description provided for @tiles_colorToHide.
  ///
  /// In en, this message translates to:
  /// **'Color to hide'**
  String get tiles_colorToHide;

  /// No description provided for @wms_wmsProperties.
  ///
  /// In en, this message translates to:
  /// **'WMS Properties'**
  String get wms_wmsProperties;

  /// No description provided for @wms_opacity.
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get wms_opacity;

  /// No description provided for @featureAttributesViewer_loadingData.
  ///
  /// In en, this message translates to:
  /// **'Loading data…'**
  String get featureAttributesViewer_loadingData;

  /// No description provided for @featureAttributesViewer_setNewValue.
  ///
  /// In en, this message translates to:
  /// **'Set new value'**
  String get featureAttributesViewer_setNewValue;

  /// No description provided for @featureAttributesViewer_field.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get featureAttributesViewer_field;

  /// No description provided for @featureAttributesViewer_value.
  ///
  /// In en, this message translates to:
  /// **'VALUE'**
  String get featureAttributesViewer_value;

  /// No description provided for @projectsView_projectsView.
  ///
  /// In en, this message translates to:
  /// **'Projects View'**
  String get projectsView_projectsView;

  /// No description provided for @projectsView_openExistingProject.
  ///
  /// In en, this message translates to:
  /// **'Open an existing project'**
  String get projectsView_openExistingProject;

  /// No description provided for @projectsView_createNewProject.
  ///
  /// In en, this message translates to:
  /// **'Create a new project'**
  String get projectsView_createNewProject;

  /// No description provided for @projectsView_recentProjects.
  ///
  /// In en, this message translates to:
  /// **'Recent projects'**
  String get projectsView_recentProjects;

  /// No description provided for @projectsView_newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get projectsView_newProject;

  /// No description provided for @projectsView_enterNameForNewProject.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for the new project or accept the proposed.'**
  String get projectsView_enterNameForNewProject;

  /// No description provided for @dataLoader_note.
  ///
  /// In en, this message translates to:
  /// **'note'**
  String get dataLoader_note;

  /// No description provided for @dataLoader_Note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get dataLoader_Note;

  /// No description provided for @dataLoader_hasForm.
  ///
  /// In en, this message translates to:
  /// **'Has Form'**
  String get dataLoader_hasForm;

  /// No description provided for @dataLoader_POI.
  ///
  /// In en, this message translates to:
  /// **'POI'**
  String get dataLoader_POI;

  /// No description provided for @dataLoader_savingImageToDB.
  ///
  /// In en, this message translates to:
  /// **'Saving image to database…'**
  String get dataLoader_savingImageToDB;

  /// No description provided for @dataLoader_removeNote.
  ///
  /// In en, this message translates to:
  /// **'Remove Note'**
  String get dataLoader_removeNote;

  /// No description provided for @dataLoader_areYouSureRemoveNote.
  ///
  /// In en, this message translates to:
  /// **'Remove note?'**
  String get dataLoader_areYouSureRemoveNote;

  /// No description provided for @dataLoader_image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get dataLoader_image;

  /// No description provided for @dataLoader_longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get dataLoader_longitude;

  /// No description provided for @dataLoader_latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get dataLoader_latitude;

  /// No description provided for @dataLoader_altitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get dataLoader_altitude;

  /// No description provided for @dataLoader_timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get dataLoader_timestamp;

  /// No description provided for @dataLoader_removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get dataLoader_removeImage;

  /// No description provided for @dataLoader_areYouSureRemoveImage.
  ///
  /// In en, this message translates to:
  /// **'Remove the image?'**
  String get dataLoader_areYouSureRemoveImage;

  /// No description provided for @images_loadingImage.
  ///
  /// In en, this message translates to:
  /// **'Loading image…'**
  String get images_loadingImage;

  /// No description provided for @about_loadingInformation.
  ///
  /// In en, this message translates to:
  /// **'Loading info…'**
  String get about_loadingInformation;

  /// No description provided for @about_ABOUT.
  ///
  /// In en, this message translates to:
  /// **'About '**
  String get about_ABOUT;

  /// No description provided for @about_smartMobileAppForSurveyor.
  ///
  /// In en, this message translates to:
  /// **'Smart Mobile App for Surveyor Happiness'**
  String get about_smartMobileAppForSurveyor;

  /// No description provided for @about_applicationVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get about_applicationVersion;

  /// No description provided for @about_license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get about_license;

  /// No description provided for @about_isAvailableUnderGPL3.
  ///
  /// In en, this message translates to:
  /// **' is copylefted libre software, licensed GPLv3+.'**
  String get about_isAvailableUnderGPL3;

  /// No description provided for @about_sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source Code'**
  String get about_sourceCode;

  /// No description provided for @about_tapHereToVisitRepo.
  ///
  /// In en, this message translates to:
  /// **'Tap here to visit the source code repository'**
  String get about_tapHereToVisitRepo;

  /// No description provided for @about_legalInformation.
  ///
  /// In en, this message translates to:
  /// **'Legal Info'**
  String get about_legalInformation;

  /// No description provided for @about_copyright2020HydroloGIS.
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2020, HydroloGIS S.r.l. — some rights reserved. Tap to visit.'**
  String get about_copyright2020HydroloGIS;

  /// No description provided for @about_supportedBy.
  ///
  /// In en, this message translates to:
  /// **'Supported by'**
  String get about_supportedBy;

  /// No description provided for @about_partiallySupportedByUniversityTrento.
  ///
  /// In en, this message translates to:
  /// **'Partially supported by the project Steep Stream of the University of Trento.'**
  String get about_partiallySupportedByUniversityTrento;

  /// No description provided for @about_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get about_privacyPolicy;

  /// No description provided for @about_tapHereToSeePrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Tap here to see the privacy policy that covers user and location data.'**
  String get about_tapHereToSeePrivacyPolicy;

  /// No description provided for @gpsInfoButton_noGpsInfoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No GPS info available…'**
  String get gpsInfoButton_noGpsInfoAvailable;

  /// No description provided for @gpsInfoButton_timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp'**
  String get gpsInfoButton_timestamp;

  /// No description provided for @gpsInfoButton_speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get gpsInfoButton_speed;

  /// No description provided for @gpsInfoButton_heading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get gpsInfoButton_heading;

  /// No description provided for @gpsInfoButton_accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get gpsInfoButton_accuracy;

  /// No description provided for @gpsInfoButton_altitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude'**
  String get gpsInfoButton_altitude;

  /// No description provided for @gpsInfoButton_latitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get gpsInfoButton_latitude;

  /// No description provided for @gpsInfoButton_copyLatitudeToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy latitude to clipboard.'**
  String get gpsInfoButton_copyLatitudeToClipboard;

  /// No description provided for @gpsInfoButton_longitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get gpsInfoButton_longitude;

  /// No description provided for @gpsInfoButton_copyLongitudeToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy longitude to clipboard.'**
  String get gpsInfoButton_copyLongitudeToClipboard;

  /// No description provided for @gpsLogButton_stopLogging.
  ///
  /// In en, this message translates to:
  /// **'Stop Logging?'**
  String get gpsLogButton_stopLogging;

  /// No description provided for @gpsLogButton_stopLoggingAndCloseLog.
  ///
  /// In en, this message translates to:
  /// **'Stop logging and close the current GPS log?'**
  String get gpsLogButton_stopLoggingAndCloseLog;

  /// No description provided for @gpsLogButton_newLog.
  ///
  /// In en, this message translates to:
  /// **'New Log'**
  String get gpsLogButton_newLog;

  /// No description provided for @gpsLogButton_enterNameForNewLog.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for the new log'**
  String get gpsLogButton_enterNameForNewLog;

  /// No description provided for @gpsLogButton_couldNotStartLogging.
  ///
  /// In en, this message translates to:
  /// **'Could not start logging: '**
  String get gpsLogButton_couldNotStartLogging;

  /// No description provided for @imageWidgets_loadingImage.
  ///
  /// In en, this message translates to:
  /// **'Loading image…'**
  String get imageWidgets_loadingImage;

  /// No description provided for @logList_gpsLogsList.
  ///
  /// In en, this message translates to:
  /// **'GPS Logs list'**
  String get logList_gpsLogsList;

  /// No description provided for @logList_selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get logList_selectAll;

  /// No description provided for @logList_unSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Unselect all'**
  String get logList_unSelectAll;

  /// No description provided for @logList_invertSelection.
  ///
  /// In en, this message translates to:
  /// **'Invert selection'**
  String get logList_invertSelection;

  /// No description provided for @logList_mergeSelected.
  ///
  /// In en, this message translates to:
  /// **'Merge selected'**
  String get logList_mergeSelected;

  /// No description provided for @logList_loadingLogs.
  ///
  /// In en, this message translates to:
  /// **'Loading logs…'**
  String get logList_loadingLogs;

  /// No description provided for @logList_zoomTo.
  ///
  /// In en, this message translates to:
  /// **'Zoom to'**
  String get logList_zoomTo;

  /// No description provided for @logList_properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get logList_properties;

  /// No description provided for @logList_profileView.
  ///
  /// In en, this message translates to:
  /// **'Profile View'**
  String get logList_profileView;

  /// No description provided for @logList_toGPX.
  ///
  /// In en, this message translates to:
  /// **'To GPX'**
  String get logList_toGPX;

  /// No description provided for @logList_gpsSavedInExportFolder.
  ///
  /// In en, this message translates to:
  /// **'GPX saved in export folder.'**
  String get logList_gpsSavedInExportFolder;

  /// No description provided for @logList_errorOccurredExportingLogGPX.
  ///
  /// In en, this message translates to:
  /// **'Could not export log to GPX.'**
  String get logList_errorOccurredExportingLogGPX;

  /// No description provided for @logList_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get logList_delete;

  /// No description provided for @logList_DELETE.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get logList_DELETE;

  /// No description provided for @logList_areYouSureDeleteTheLog.
  ///
  /// In en, this message translates to:
  /// **'Delete the log?'**
  String get logList_areYouSureDeleteTheLog;

  /// No description provided for @logList_hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get logList_hours;

  /// No description provided for @logList_hour.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get logList_hour;

  /// No description provided for @logList_minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get logList_minutes;

  /// No description provided for @logProperties_gpsLogProperties.
  ///
  /// In en, this message translates to:
  /// **'GPS Log Properties'**
  String get logProperties_gpsLogProperties;

  /// No description provided for @logProperties_logName.
  ///
  /// In en, this message translates to:
  /// **'Log Name'**
  String get logProperties_logName;

  /// No description provided for @logProperties_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get logProperties_start;

  /// No description provided for @logProperties_end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get logProperties_end;

  /// No description provided for @logProperties_duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get logProperties_duration;

  /// No description provided for @logProperties_color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get logProperties_color;

  /// No description provided for @logProperties_palette.
  ///
  /// In en, this message translates to:
  /// **'Palette'**
  String get logProperties_palette;

  /// No description provided for @logProperties_width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get logProperties_width;

  /// No description provided for @logProperties_distanceAtPosition.
  ///
  /// In en, this message translates to:
  /// **'Distance at position:'**
  String get logProperties_distanceAtPosition;

  /// No description provided for @logProperties_totalDistance.
  ///
  /// In en, this message translates to:
  /// **'Total distance:'**
  String get logProperties_totalDistance;

  /// No description provided for @logProperties_gpsLogView.
  ///
  /// In en, this message translates to:
  /// **'GPS Log View'**
  String get logProperties_gpsLogView;

  /// No description provided for @logProperties_disableStats.
  ///
  /// In en, this message translates to:
  /// **'Turn off stats'**
  String get logProperties_disableStats;

  /// No description provided for @logProperties_enableStats.
  ///
  /// In en, this message translates to:
  /// **'Turn on stats'**
  String get logProperties_enableStats;

  /// No description provided for @logProperties_totalDuration.
  ///
  /// In en, this message translates to:
  /// **'Total duration:'**
  String get logProperties_totalDuration;

  /// No description provided for @logProperties_timestamp.
  ///
  /// In en, this message translates to:
  /// **'Timestamp:'**
  String get logProperties_timestamp;

  /// No description provided for @logProperties_durationAtPosition.
  ///
  /// In en, this message translates to:
  /// **'Duration at position:'**
  String get logProperties_durationAtPosition;

  /// No description provided for @logProperties_speed.
  ///
  /// In en, this message translates to:
  /// **'Speed:'**
  String get logProperties_speed;

  /// No description provided for @logProperties_elevation.
  ///
  /// In en, this message translates to:
  /// **'Elevation:'**
  String get logProperties_elevation;

  /// No description provided for @noteList_simpleNotesList.
  ///
  /// In en, this message translates to:
  /// **'Simple List of Notes'**
  String get noteList_simpleNotesList;

  /// No description provided for @noteList_formNotesList.
  ///
  /// In en, this message translates to:
  /// **'List of Form Notes'**
  String get noteList_formNotesList;

  /// No description provided for @noteList_loadingNotes.
  ///
  /// In en, this message translates to:
  /// **'Loading notes…'**
  String get noteList_loadingNotes;

  /// No description provided for @noteList_zoomTo.
  ///
  /// In en, this message translates to:
  /// **'Zoom to'**
  String get noteList_zoomTo;

  /// No description provided for @noteList_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get noteList_edit;

  /// No description provided for @noteList_properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get noteList_properties;

  /// No description provided for @noteList_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get noteList_delete;

  /// No description provided for @noteList_DELETE.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get noteList_DELETE;

  /// No description provided for @noteList_areYouSureDeleteNote.
  ///
  /// In en, this message translates to:
  /// **'Delete the note?'**
  String get noteList_areYouSureDeleteNote;

  /// No description provided for @settings_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_settings;

  /// No description provided for @settings_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get settings_camera;

  /// No description provided for @settings_cameraResolution.
  ///
  /// In en, this message translates to:
  /// **'Camera Resolution'**
  String get settings_cameraResolution;

  /// No description provided for @settings_resolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get settings_resolution;

  /// No description provided for @settings_theCameraResolution.
  ///
  /// In en, this message translates to:
  /// **'The camera resolution'**
  String get settings_theCameraResolution;

  /// No description provided for @settings_screen.
  ///
  /// In en, this message translates to:
  /// **'Screen'**
  String get settings_screen;

  /// No description provided for @settings_screenScaleBarIconSize.
  ///
  /// In en, this message translates to:
  /// **'Screen, Scalebar and Icon Size'**
  String get settings_screenScaleBarIconSize;

  /// No description provided for @settings_keepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On'**
  String get settings_keepScreenOn;

  /// No description provided for @settings_retinaScreenMode.
  ///
  /// In en, this message translates to:
  /// **'HiDPI screen-mode'**
  String get settings_retinaScreenMode;

  /// No description provided for @settings_toApplySettingEnterExitLayerView.
  ///
  /// In en, this message translates to:
  /// **'Enter and exit the layer view to apply this setting.'**
  String get settings_toApplySettingEnterExitLayerView;

  /// No description provided for @settings_colorPickerToUse.
  ///
  /// In en, this message translates to:
  /// **'Color Picker to use'**
  String get settings_colorPickerToUse;

  /// No description provided for @settings_mapCenterCross.
  ///
  /// In en, this message translates to:
  /// **'Map Center Cross'**
  String get settings_mapCenterCross;

  /// No description provided for @settings_color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get settings_color;

  /// No description provided for @settings_size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get settings_size;

  /// No description provided for @settings_width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get settings_width;

  /// No description provided for @settings_mapToolsIconSize.
  ///
  /// In en, this message translates to:
  /// **'Icon Size for Map Tools'**
  String get settings_mapToolsIconSize;

  /// No description provided for @settings_gps.
  ///
  /// In en, this message translates to:
  /// **'GPS'**
  String get settings_gps;

  /// No description provided for @settings_gpsFiltersAndMockLoc.
  ///
  /// In en, this message translates to:
  /// **'GPS filters and mock locations'**
  String get settings_gpsFiltersAndMockLoc;

  /// No description provided for @settings_livePreview.
  ///
  /// In en, this message translates to:
  /// **'Live Preview'**
  String get settings_livePreview;

  /// No description provided for @settings_noPointAvailableYet.
  ///
  /// In en, this message translates to:
  /// **'No point available yet.'**
  String get settings_noPointAvailableYet;

  /// No description provided for @settings_longitudeDeg.
  ///
  /// In en, this message translates to:
  /// **'longitude [deg]'**
  String get settings_longitudeDeg;

  /// No description provided for @settings_latitudeDeg.
  ///
  /// In en, this message translates to:
  /// **'latitude [deg]'**
  String get settings_latitudeDeg;

  /// No description provided for @settings_accuracyM.
  ///
  /// In en, this message translates to:
  /// **'accuracy [m]'**
  String get settings_accuracyM;

  /// No description provided for @settings_altitudeM.
  ///
  /// In en, this message translates to:
  /// **'altitude [m]'**
  String get settings_altitudeM;

  /// No description provided for @settings_headingDeg.
  ///
  /// In en, this message translates to:
  /// **'heading [deg]'**
  String get settings_headingDeg;

  /// No description provided for @settings_speedMS.
  ///
  /// In en, this message translates to:
  /// **'speed [m/s]'**
  String get settings_speedMS;

  /// No description provided for @settings_isLogging.
  ///
  /// In en, this message translates to:
  /// **'is logging?'**
  String get settings_isLogging;

  /// No description provided for @settings_mockLocations.
  ///
  /// In en, this message translates to:
  /// **'mock locations?'**
  String get settings_mockLocations;

  /// No description provided for @settings_minDistFilterBlocks.
  ///
  /// In en, this message translates to:
  /// **'Min dist filter blocks'**
  String get settings_minDistFilterBlocks;

  /// No description provided for @settings_minDistFilterPasses.
  ///
  /// In en, this message translates to:
  /// **'Min dist filter passes'**
  String get settings_minDistFilterPasses;

  /// No description provided for @settings_minTimeFilterBlocks.
  ///
  /// In en, this message translates to:
  /// **'Min time filter blocks'**
  String get settings_minTimeFilterBlocks;

  /// No description provided for @settings_minTimeFilterPasses.
  ///
  /// In en, this message translates to:
  /// **'Min time filter passes'**
  String get settings_minTimeFilterPasses;

  /// No description provided for @settings_hasBeenBlocked.
  ///
  /// In en, this message translates to:
  /// **'Has been blocked'**
  String get settings_hasBeenBlocked;

  /// No description provided for @settings_distanceFromPrevM.
  ///
  /// In en, this message translates to:
  /// **'Distance from prev [m]'**
  String get settings_distanceFromPrevM;

  /// No description provided for @settings_timeFromPrevS.
  ///
  /// In en, this message translates to:
  /// **'Time since prev [s]'**
  String get settings_timeFromPrevS;

  /// No description provided for @settings_locationInfo.
  ///
  /// In en, this message translates to:
  /// **'Location Info'**
  String get settings_locationInfo;

  /// No description provided for @settings_filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get settings_filters;

  /// No description provided for @settings_disableFilters.
  ///
  /// In en, this message translates to:
  /// **'Turn off Filters.'**
  String get settings_disableFilters;

  /// No description provided for @settings_enableFilters.
  ///
  /// In en, this message translates to:
  /// **'Turn on Filters.'**
  String get settings_enableFilters;

  /// No description provided for @settings_zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get settings_zoomIn;

  /// No description provided for @settings_zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get settings_zoomOut;

  /// No description provided for @settings_activatePointFlow.
  ///
  /// In en, this message translates to:
  /// **'Activate point flow.'**
  String get settings_activatePointFlow;

  /// No description provided for @settings_pausePointsFlow.
  ///
  /// In en, this message translates to:
  /// **'Pause points flow.'**
  String get settings_pausePointsFlow;

  /// No description provided for @settings_visualizePointCount.
  ///
  /// In en, this message translates to:
  /// **'Visualize point count'**
  String get settings_visualizePointCount;

  /// No description provided for @settings_showGpsPointsValidPoints.
  ///
  /// In en, this message translates to:
  /// **'Show the GPS points count for VALID points.'**
  String get settings_showGpsPointsValidPoints;

  /// No description provided for @settings_showGpsPointsAllPoints.
  ///
  /// In en, this message translates to:
  /// **'Show the GPS points count for ALL points.'**
  String get settings_showGpsPointsAllPoints;

  /// No description provided for @settings_logFilters.
  ///
  /// In en, this message translates to:
  /// **'Log filters'**
  String get settings_logFilters;

  /// No description provided for @settings_minDistanceBetween2Points.
  ///
  /// In en, this message translates to:
  /// **'Min distance between 2 points.'**
  String get settings_minDistanceBetween2Points;

  /// No description provided for @settings_minTimespanBetween2Points.
  ///
  /// In en, this message translates to:
  /// **'Min timespan between 2 points.'**
  String get settings_minTimespanBetween2Points;

  /// No description provided for @settings_gpsFilter.
  ///
  /// In en, this message translates to:
  /// **'GPS Filter'**
  String get settings_gpsFilter;

  /// No description provided for @settings_disable.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get settings_disable;

  /// No description provided for @settings_enable.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get settings_enable;

  /// No description provided for @settings_theUseOfTheGps.
  ///
  /// In en, this message translates to:
  /// **'the use of filtered GPS.'**
  String get settings_theUseOfTheGps;

  /// No description provided for @settings_warningThisWillAffectGpsPosition.
  ///
  /// In en, this message translates to:
  /// **'Warning: This will affect GPS position, notes insertion, log statistics and charting.'**
  String get settings_warningThisWillAffectGpsPosition;

  /// No description provided for @settings_MockLocations.
  ///
  /// In en, this message translates to:
  /// **'Mock locations'**
  String get settings_MockLocations;

  /// No description provided for @settings_testGpsLogDemoUse.
  ///
  /// In en, this message translates to:
  /// **'test GPS log for demo use.'**
  String get settings_testGpsLogDemoUse;

  /// No description provided for @settings_setDurationGpsPointsInMilli.
  ///
  /// In en, this message translates to:
  /// **'Set duration for GPS points in milliseconds.'**
  String get settings_setDurationGpsPointsInMilli;

  /// No description provided for @settings_SETTING.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get settings_SETTING;

  /// No description provided for @settings_setMockedGpsDuration.
  ///
  /// In en, this message translates to:
  /// **'Set Mocked GPS duration'**
  String get settings_setMockedGpsDuration;

  /// No description provided for @settings_theValueHasToBeInt.
  ///
  /// In en, this message translates to:
  /// **'The value has to be a whole number.'**
  String get settings_theValueHasToBeInt;

  /// No description provided for @settings_milliseconds.
  ///
  /// In en, this message translates to:
  /// **'milliseconds'**
  String get settings_milliseconds;

  /// No description provided for @settings_useGoogleToImproveLoc.
  ///
  /// In en, this message translates to:
  /// **'Use Google Services to improve location'**
  String get settings_useGoogleToImproveLoc;

  /// No description provided for @settings_useOfGoogleServicesRestart.
  ///
  /// In en, this message translates to:
  /// **'use of Google services (app restart needed).'**
  String get settings_useOfGoogleServicesRestart;

  /// No description provided for @settings_gpsLogsViewMode.
  ///
  /// In en, this message translates to:
  /// **'GPS Logs view mode'**
  String get settings_gpsLogsViewMode;

  /// No description provided for @settings_logViewModeForOrigData.
  ///
  /// In en, this message translates to:
  /// **'Log view mode for original data.'**
  String get settings_logViewModeForOrigData;

  /// No description provided for @settings_logViewModeFilteredData.
  ///
  /// In en, this message translates to:
  /// **'Log view mode for filtered data.'**
  String get settings_logViewModeFilteredData;

  /// No description provided for @settings_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settings_cancel;

  /// No description provided for @settings_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get settings_ok;

  /// No description provided for @settings_notesViewModes.
  ///
  /// In en, this message translates to:
  /// **'Notes view modes'**
  String get settings_notesViewModes;

  /// No description provided for @settings_selectNotesViewMode.
  ///
  /// In en, this message translates to:
  /// **'Select a mode to view notes in.'**
  String get settings_selectNotesViewMode;

  /// No description provided for @settings_mapPlugins.
  ///
  /// In en, this message translates to:
  /// **'Map Plugins'**
  String get settings_mapPlugins;

  /// No description provided for @settings_vectorLayers.
  ///
  /// In en, this message translates to:
  /// **'Vector Layers'**
  String get settings_vectorLayers;

  /// No description provided for @settings_loadingOptionsInfoTool.
  ///
  /// In en, this message translates to:
  /// **'Loading Options and Info Tool'**
  String get settings_loadingOptionsInfoTool;

  /// No description provided for @settings_dataLoading.
  ///
  /// In en, this message translates to:
  /// **'Data loading'**
  String get settings_dataLoading;

  /// No description provided for @settings_maxNumberFeatures.
  ///
  /// In en, this message translates to:
  /// **'Max number of features.'**
  String get settings_maxNumberFeatures;

  /// No description provided for @settings_maxNumFeaturesPerLayer.
  ///
  /// In en, this message translates to:
  /// **'Max features per layer. Remove and add the layer to apply.'**
  String get settings_maxNumFeaturesPerLayer;

  /// No description provided for @settings_all.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get settings_all;

  /// No description provided for @settings_loadMapArea.
  ///
  /// In en, this message translates to:
  /// **'Load map area.'**
  String get settings_loadMapArea;

  /// No description provided for @settings_loadOnlyLastVisibleArea.
  ///
  /// In en, this message translates to:
  /// **'Load only on the last visible map area. Remove and add the layer again to apply.'**
  String get settings_loadOnlyLastVisibleArea;

  /// No description provided for @settings_infoTool.
  ///
  /// In en, this message translates to:
  /// **'Info Tool'**
  String get settings_infoTool;

  /// No description provided for @settings_tapSizeInfoToolPixels.
  ///
  /// In en, this message translates to:
  /// **'Tap size of the info tool in pixels.'**
  String get settings_tapSizeInfoToolPixels;

  /// No description provided for @settings_editingTool.
  ///
  /// In en, this message translates to:
  /// **'Editing tool'**
  String get settings_editingTool;

  /// No description provided for @settings_editingDragIconSize.
  ///
  /// In en, this message translates to:
  /// **'Editing drag handler icon size.'**
  String get settings_editingDragIconSize;

  /// No description provided for @settings_editingIntermediateDragIconSize.
  ///
  /// In en, this message translates to:
  /// **'Editing intermediate drag handler icon size.'**
  String get settings_editingIntermediateDragIconSize;

  /// No description provided for @settings_diagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get settings_diagnostics;

  /// No description provided for @settings_diagnosticsDebugLog.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics and Debug Log'**
  String get settings_diagnosticsDebugLog;

  /// No description provided for @settings_openFullDebugLog.
  ///
  /// In en, this message translates to:
  /// **'Open full debug log'**
  String get settings_openFullDebugLog;

  /// No description provided for @settings_debugLogView.
  ///
  /// In en, this message translates to:
  /// **'Debug Log View'**
  String get settings_debugLogView;

  /// No description provided for @settings_viewAllMessages.
  ///
  /// In en, this message translates to:
  /// **'View all messages'**
  String get settings_viewAllMessages;

  /// No description provided for @settings_viewOnlyErrorsWarnings.
  ///
  /// In en, this message translates to:
  /// **'View only errors and warnings'**
  String get settings_viewOnlyErrorsWarnings;

  /// No description provided for @settings_clearDebugLog.
  ///
  /// In en, this message translates to:
  /// **'Clear debug log'**
  String get settings_clearDebugLog;

  /// No description provided for @settings_loadingData.
  ///
  /// In en, this message translates to:
  /// **'Loading data…'**
  String get settings_loadingData;

  /// No description provided for @settings_device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get settings_device;

  /// No description provided for @settings_deviceIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Device identifier'**
  String get settings_deviceIdentifier;

  /// No description provided for @settings_deviceId.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get settings_deviceId;

  /// No description provided for @settings_overrideDeviceId.
  ///
  /// In en, this message translates to:
  /// **'Override Device ID'**
  String get settings_overrideDeviceId;

  /// No description provided for @settings_overrideId.
  ///
  /// In en, this message translates to:
  /// **'Override ID'**
  String get settings_overrideId;

  /// No description provided for @settings_pleaseEnterValidPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid server password.'**
  String get settings_pleaseEnterValidPassword;

  /// No description provided for @settings_gss.
  ///
  /// In en, this message translates to:
  /// **'GSS'**
  String get settings_gss;

  /// No description provided for @settings_geopaparazziSurveyServer.
  ///
  /// In en, this message translates to:
  /// **'Geopaparazzi Survey Server'**
  String get settings_geopaparazziSurveyServer;

  /// No description provided for @settings_serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get settings_serverUrl;

  /// No description provided for @settings_serverUrlStartWithHttp.
  ///
  /// In en, this message translates to:
  /// **'The server URL needs to start with HTTP or HTTPS.'**
  String get settings_serverUrlStartWithHttp;

  /// No description provided for @settings_serverPassword.
  ///
  /// In en, this message translates to:
  /// **'Server Password'**
  String get settings_serverPassword;

  /// No description provided for @settings_allowSelfSignedCert.
  ///
  /// In en, this message translates to:
  /// **'Allow self signed certificates'**
  String get settings_allowSelfSignedCert;

  /// No description provided for @toolbarTools_zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get toolbarTools_zoomOut;

  /// No description provided for @toolbarTools_zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get toolbarTools_zoomIn;

  /// No description provided for @toolbarTools_cancelCurrentEdit.
  ///
  /// In en, this message translates to:
  /// **'Cancel current edit.'**
  String get toolbarTools_cancelCurrentEdit;

  /// No description provided for @toolbarTools_saveCurrentEdit.
  ///
  /// In en, this message translates to:
  /// **'Save current edit.'**
  String get toolbarTools_saveCurrentEdit;

  /// No description provided for @toolbarTools_insertPointMapCenter.
  ///
  /// In en, this message translates to:
  /// **'Insert point in map center.'**
  String get toolbarTools_insertPointMapCenter;

  /// No description provided for @toolbarTools_insertPointGpsPos.
  ///
  /// In en, this message translates to:
  /// **'Insert point in GPS position.'**
  String get toolbarTools_insertPointGpsPos;

  /// No description provided for @toolbarTools_removeSelectedFeature.
  ///
  /// In en, this message translates to:
  /// **'Remove selected feature.'**
  String get toolbarTools_removeSelectedFeature;

  /// No description provided for @toolbarTools_showFeatureAttributes.
  ///
  /// In en, this message translates to:
  /// **'Show feature attributes.'**
  String get toolbarTools_showFeatureAttributes;

  /// No description provided for @toolbarTools_featureDoesNotHavePrimaryKey.
  ///
  /// In en, this message translates to:
  /// **'The feature does not have a primary key. Editing is not allowed.'**
  String get toolbarTools_featureDoesNotHavePrimaryKey;

  /// No description provided for @toolbarTools_queryFeaturesVectorLayers.
  ///
  /// In en, this message translates to:
  /// **'Query features from loaded vector layers.'**
  String get toolbarTools_queryFeaturesVectorLayers;

  /// No description provided for @toolbarTools_measureDistanceWithFinger.
  ///
  /// In en, this message translates to:
  /// **'Measure distances on the map with your finger.'**
  String get toolbarTools_measureDistanceWithFinger;

  /// No description provided for @toolbarTools_toggleFenceMapCenter.
  ///
  /// In en, this message translates to:
  /// **'Toggle fence in map center.'**
  String get toolbarTools_toggleFenceMapCenter;

  /// No description provided for @toolbarTools_modifyGeomVectorLayers.
  ///
  /// In en, this message translates to:
  /// **'Modify the geometry of editable vector layers.'**
  String get toolbarTools_modifyGeomVectorLayers;

  /// No description provided for @coachMarks_singleTap.
  ///
  /// In en, this message translates to:
  /// **'Single tap: '**
  String get coachMarks_singleTap;

  /// No description provided for @coachMarks_longTap.
  ///
  /// In en, this message translates to:
  /// **'Long tap: '**
  String get coachMarks_longTap;

  /// No description provided for @coachMarks_doubleTap.
  ///
  /// In en, this message translates to:
  /// **'Double tap: '**
  String get coachMarks_doubleTap;

  /// No description provided for @coachMarks_simpleNoteButton.
  ///
  /// In en, this message translates to:
  /// **'Simple Notes Button'**
  String get coachMarks_simpleNoteButton;

  /// No description provided for @coachMarks_addNewNote.
  ///
  /// In en, this message translates to:
  /// **'add a new note'**
  String get coachMarks_addNewNote;

  /// No description provided for @coachMarks_viewNotesList.
  ///
  /// In en, this message translates to:
  /// **'view list of notes'**
  String get coachMarks_viewNotesList;

  /// No description provided for @coachMarks_viewNotesSettings.
  ///
  /// In en, this message translates to:
  /// **'view settings for notes'**
  String get coachMarks_viewNotesSettings;

  /// No description provided for @coachMarks_formNotesButton.
  ///
  /// In en, this message translates to:
  /// **'Form Notes Button'**
  String get coachMarks_formNotesButton;

  /// No description provided for @coachMarks_addNewFormNote.
  ///
  /// In en, this message translates to:
  /// **'add new form note'**
  String get coachMarks_addNewFormNote;

  /// No description provided for @coachMarks_viewFormNoteList.
  ///
  /// In en, this message translates to:
  /// **'view list of form notes'**
  String get coachMarks_viewFormNoteList;

  /// No description provided for @coachMarks_gpsLogButton.
  ///
  /// In en, this message translates to:
  /// **'GPS Log Button'**
  String get coachMarks_gpsLogButton;

  /// No description provided for @coachMarks_startStopLogging.
  ///
  /// In en, this message translates to:
  /// **'start logging/stop logging'**
  String get coachMarks_startStopLogging;

  /// No description provided for @coachMarks_viewLogsList.
  ///
  /// In en, this message translates to:
  /// **'view list of logs'**
  String get coachMarks_viewLogsList;

  /// No description provided for @coachMarks_viewLogsSettings.
  ///
  /// In en, this message translates to:
  /// **'view log settings'**
  String get coachMarks_viewLogsSettings;

  /// No description provided for @coachMarks_gpsInfoButton.
  ///
  /// In en, this message translates to:
  /// **'GPS Info Button (if applicable)'**
  String get coachMarks_gpsInfoButton;

  /// No description provided for @coachMarks_centerMapOnGpsPos.
  ///
  /// In en, this message translates to:
  /// **'center map on GPS position'**
  String get coachMarks_centerMapOnGpsPos;

  /// No description provided for @coachMarks_showGpsInfo.
  ///
  /// In en, this message translates to:
  /// **'show GPS info'**
  String get coachMarks_showGpsInfo;

  /// No description provided for @coachMarks_toggleAutoCenterGps.
  ///
  /// In en, this message translates to:
  /// **'toggle automatic center on GPS'**
  String get coachMarks_toggleAutoCenterGps;

  /// No description provided for @coachMarks_layersViewButton.
  ///
  /// In en, this message translates to:
  /// **'Layers View Button'**
  String get coachMarks_layersViewButton;

  /// No description provided for @coachMarks_openLayersView.
  ///
  /// In en, this message translates to:
  /// **'Open the layers view'**
  String get coachMarks_openLayersView;

  /// No description provided for @coachMarks_openLayersPluginDialog.
  ///
  /// In en, this message translates to:
  /// **'Open the layer plugins dialog'**
  String get coachMarks_openLayersPluginDialog;

  /// No description provided for @coachMarks_zoomInButton.
  ///
  /// In en, this message translates to:
  /// **'Zoom-in Button'**
  String get coachMarks_zoomInButton;

  /// No description provided for @coachMarks_zoomImMapOneLevel.
  ///
  /// In en, this message translates to:
  /// **'Zoom in the map by one level'**
  String get coachMarks_zoomImMapOneLevel;

  /// No description provided for @coachMarks_zoomOutButton.
  ///
  /// In en, this message translates to:
  /// **'Zoom-out Button'**
  String get coachMarks_zoomOutButton;

  /// No description provided for @coachMarks_zoomOutMapOneLevel.
  ///
  /// In en, this message translates to:
  /// **'Zoom out the map by one level'**
  String get coachMarks_zoomOutMapOneLevel;

  /// No description provided for @coachMarks_bottomToolsButton.
  ///
  /// In en, this message translates to:
  /// **'Bottom Tools Button'**
  String get coachMarks_bottomToolsButton;

  /// No description provided for @coachMarks_toggleBottomToolsBar.
  ///
  /// In en, this message translates to:
  /// **'Toggle bottom tools bar'**
  String get coachMarks_toggleBottomToolsBar;

  /// No description provided for @coachMarks_toolsButton.
  ///
  /// In en, this message translates to:
  /// **'Tools Button'**
  String get coachMarks_toolsButton;

  /// No description provided for @coachMarks_openEndDrawerToAccessProject.
  ///
  /// In en, this message translates to:
  /// **'Open the end drawer to access project info and sharing options as well as map plugins, feature tools and extras'**
  String get coachMarks_openEndDrawerToAccessProject;

  /// No description provided for @coachMarks_interactiveCoackMarksButton.
  ///
  /// In en, this message translates to:
  /// **'Interactive coach-marks button'**
  String get coachMarks_interactiveCoackMarksButton;

  /// No description provided for @coachMarks_openInteractiveCoachMarks.
  ///
  /// In en, this message translates to:
  /// **'Open the interactice coach marks explaining all the actions of the main map view.'**
  String get coachMarks_openInteractiveCoachMarks;

  /// No description provided for @coachMarks_mainMenuButton.
  ///
  /// In en, this message translates to:
  /// **'Main-menu Button'**
  String get coachMarks_mainMenuButton;

  /// No description provided for @coachMarks_openDrawerToLoadProject.
  ///
  /// In en, this message translates to:
  /// **'Open the drawer to load or create a project, import and export data, sync with servers, access settings and exit the app/turn off the GPS.'**
  String get coachMarks_openDrawerToLoadProject;

  /// No description provided for @coachMarks_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get coachMarks_skip;

  /// No description provided for @fence_fenceProperties.
  ///
  /// In en, this message translates to:
  /// **'Fence Properties'**
  String get fence_fenceProperties;

  /// No description provided for @fence_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get fence_delete;

  /// No description provided for @fence_removeFence.
  ///
  /// In en, this message translates to:
  /// **'Remove fence'**
  String get fence_removeFence;

  /// No description provided for @fence_areYouSureRemoveFence.
  ///
  /// In en, this message translates to:
  /// **'Remove the fence?'**
  String get fence_areYouSureRemoveFence;

  /// No description provided for @fence_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get fence_cancel;

  /// No description provided for @fence_ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get fence_ok;

  /// No description provided for @fence_aNewFence.
  ///
  /// In en, this message translates to:
  /// **'a new fence'**
  String get fence_aNewFence;

  /// No description provided for @fence_label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get fence_label;

  /// No description provided for @fence_aNameForFence.
  ///
  /// In en, this message translates to:
  /// **'A name for the fence.'**
  String get fence_aNameForFence;

  /// No description provided for @fence_theNameNeedsToBeDefined.
  ///
  /// In en, this message translates to:
  /// **'The name must be defined.'**
  String get fence_theNameNeedsToBeDefined;

  /// No description provided for @fence_radius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get fence_radius;

  /// No description provided for @fence_theFenceRadiusMeters.
  ///
  /// In en, this message translates to:
  /// **'The fence radius in meters.'**
  String get fence_theFenceRadiusMeters;

  /// No description provided for @fence_radiusNeedsToBePositive.
  ///
  /// In en, this message translates to:
  /// **'The radius must be a positive number in meters.'**
  String get fence_radiusNeedsToBePositive;

  /// No description provided for @fence_onEnter.
  ///
  /// In en, this message translates to:
  /// **'On enter'**
  String get fence_onEnter;

  /// No description provided for @fence_onExit.
  ///
  /// In en, this message translates to:
  /// **'On exit'**
  String get fence_onExit;

  /// No description provided for @network_cancelledByUser.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by user.'**
  String get network_cancelledByUser;

  /// No description provided for @network_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed.'**
  String get network_completed;

  /// No description provided for @network_buildingBaseCachePerformance.
  ///
  /// In en, this message translates to:
  /// **'Building base cache for improved performance (might take a while)…'**
  String get network_buildingBaseCachePerformance;

  /// No description provided for @network_thisFIleAlreadyBeingDownloaded.
  ///
  /// In en, this message translates to:
  /// **'This file is already being downloaded.'**
  String get network_thisFIleAlreadyBeingDownloaded;

  /// No description provided for @network_download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get network_download;

  /// No description provided for @network_downloadFile.
  ///
  /// In en, this message translates to:
  /// **'Download file'**
  String get network_downloadFile;

  /// No description provided for @network_toTheDeviceTakeTime.
  ///
  /// In en, this message translates to:
  /// **'to the device? This can take a while.'**
  String get network_toTheDeviceTakeTime;

  /// No description provided for @network_availableMaps.
  ///
  /// In en, this message translates to:
  /// **'Available maps'**
  String get network_availableMaps;

  /// No description provided for @network_searchMapByName.
  ///
  /// In en, this message translates to:
  /// **'Search map by name'**
  String get network_searchMapByName;

  /// No description provided for @network_uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get network_uploading;

  /// No description provided for @network_pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'please wait…'**
  String get network_pleaseWait;

  /// No description provided for @network_permissionOnServerDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission on server denied.'**
  String get network_permissionOnServerDenied;

  /// No description provided for @network_couldNotConnectToServer.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server. Is it online? Check your address.'**
  String get network_couldNotConnectToServer;

  /// No description provided for @form_smash_cantSaveImageDb.
  ///
  /// In en, this message translates to:
  /// **'Could not save image in database.'**
  String get form_smash_cantSaveImageDb;

  /// No description provided for @gss_settings.
  ///
  /// In en, this message translates to:
  /// **'Geopaparazzi Survey Server Settings'**
  String get gss_settings;

  /// No description provided for @gss_settings_connection.
  ///
  /// In en, this message translates to:
  /// **'GSS Connection Settings'**
  String get gss_settings_connection;

  /// No description provided for @gss_settings_server_url.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get gss_settings_server_url;

  /// No description provided for @gss_settings_server_url_start_http.
  ///
  /// In en, this message translates to:
  /// **'Server url needs to start with http or https.'**
  String get gss_settings_server_url_start_http;

  /// No description provided for @gss_settings_project.
  ///
  /// In en, this message translates to:
  /// **'GSS Project'**
  String get gss_settings_project;

  /// No description provided for @gss_settings_server_username.
  ///
  /// In en, this message translates to:
  /// **'Server Username'**
  String get gss_settings_server_username;

  /// No description provided for @gss_settings_server_username_valid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid server username.'**
  String get gss_settings_server_username_valid;

  /// No description provided for @gss_settings_password.
  ///
  /// In en, this message translates to:
  /// **'Server Password'**
  String get gss_settings_password;

  /// No description provided for @gss_settings_password_valid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid server password.'**
  String get gss_settings_password_valid;

  /// No description provided for @gss_settings_certificates_self.
  ///
  /// In en, this message translates to:
  /// **'Allow self signed certificates'**
  String get gss_settings_certificates_self;

  /// No description provided for @gss_settings_upload_position.
  ///
  /// In en, this message translates to:
  /// **'Upload device position to server in regular time intervals.'**
  String get gss_settings_upload_position;

  /// No description provided for @gss_settings_data_missing.
  ///
  /// In en, this message translates to:
  /// **'User, password, url and project are necessary to login'**
  String get gss_settings_data_missing;

  /// No description provided for @gss_settings_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get gss_settings_login;

  /// No description provided for @gss_settings_no_token.
  ///
  /// In en, this message translates to:
  /// **'No token available, please login.'**
  String get gss_settings_no_token;

  /// No description provided for @layersView_selectGssLayers.
  ///
  /// In en, this message translates to:
  /// **'Select GSS Layers'**
  String get layersView_selectGssLayers;

  /// No description provided for @layersView_noGssLayersFound.
  ///
  /// In en, this message translates to:
  /// **'No GSS layers found.'**
  String get layersView_noGssLayersFound;

  /// No description provided for @layersView_selectGssLayersToLoad.
  ///
  /// In en, this message translates to:
  /// **'Select GSS layers to load.'**
  String get layersView_selectGssLayersToLoad;

  /// No description provided for @layersView_unableToLoadGssLayers.
  ///
  /// In en, this message translates to:
  /// **'Unable to load:'**
  String get layersView_unableToLoadGssLayers;

  /// No description provided for @layersView_layerExists.
  ///
  /// In en, this message translates to:
  /// **'Layer exists'**
  String get layersView_layerExists;

  /// No description provided for @layersView_layerAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Layer already exists, do you want to overwrite it?'**
  String get layersView_layerAlreadyExists;

  /// No description provided for @gss_layerview_upload_changes.
  ///
  /// In en, this message translates to:
  /// **'Upload changes'**
  String get gss_layerview_upload_changes;

  /// No description provided for @allGpsPointsCount.
  ///
  /// In en, this message translates to:
  /// **'Gps points'**
  String get allGpsPointsCount;

  /// No description provided for @filteredGpsPointsCount.
  ///
  /// In en, this message translates to:
  /// **'Filtered points'**
  String get filteredGpsPointsCount;

  /// No description provided for @addTmsFromDefaults.
  ///
  /// In en, this message translates to:
  /// **'Add TMS from defaults'**
  String get addTmsFromDefaults;

  /// No description provided for @form_smash_noCameraDesktop.
  ///
  /// In en, this message translates to:
  /// **'No camera option available on desktop.'**
  String get form_smash_noCameraDesktop;

  /// No description provided for @settings_BottombarCustomization.
  ///
  /// In en, this message translates to:
  /// **'Bottombar Customization'**
  String get settings_BottombarCustomization;

  /// No description provided for @settings_Bottombar_showAddNote.
  ///
  /// In en, this message translates to:
  /// **'Show the ADD NOTE button'**
  String get settings_Bottombar_showAddNote;

  /// No description provided for @settings_Bottombar_showAddFormNote.
  ///
  /// In en, this message translates to:
  /// **'Show the ADD FORM NOTE button'**
  String get settings_Bottombar_showAddFormNote;

  /// No description provided for @settings_Bottombar_showAddGpsLog.
  ///
  /// In en, this message translates to:
  /// **'Show the ADD GPS LOG button'**
  String get settings_Bottombar_showAddGpsLog;

  /// No description provided for @settings_Bottombar_showGpsButton.
  ///
  /// In en, this message translates to:
  /// **'Show the gps button'**
  String get settings_Bottombar_showGpsButton;

  /// No description provided for @settings_Bottombar_showLayers.
  ///
  /// In en, this message translates to:
  /// **'Show the layers button'**
  String get settings_Bottombar_showLayers;

  /// No description provided for @settings_Bottombar_showZoom.
  ///
  /// In en, this message translates to:
  /// **'Show the zoom buttons'**
  String get settings_Bottombar_showZoom;

  /// No description provided for @settings_Bottombar_showEditing.
  ///
  /// In en, this message translates to:
  /// **'Show the editing button'**
  String get settings_Bottombar_showEditing;
}

class _SLDelegate extends LocalizationsDelegate<SL> {
  const _SLDelegate();

  @override
  Future<SL> load(Locale locale) {
    return SynchronousFuture<SL>(lookupSL(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['cs', 'de', 'en', 'fr', 'it', 'ja', 'nb', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_SLDelegate old) => false;
}

SL lookupSL(Locale locale) {

  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.scriptCode) {
    case 'Hans': return SLZhHans();
   }
  break;
   }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'nb': {
  switch (locale.countryCode) {
    case 'NO': return SLNbNo();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs': return SLCs();
    case 'de': return SLDe();
    case 'en': return SLEn();
    case 'fr': return SLFr();
    case 'it': return SLIt();
    case 'ja': return SLJa();
    case 'nb': return SLNb();
    case 'ru': return SLRu();
    case 'zh': return SLZh();
  }

  throw FlutterError(
    'SL.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
