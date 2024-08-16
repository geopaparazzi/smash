import 'l10n.dart';

/// The translations for French (`fr`).
class SLFr extends SL {
  SLFr([String locale = 'fr']) : super(locale);

  @override
  String get main_welcome => 'Bienvenue dans SMASH !';

  @override
  String get main_check_location_permission => 'Vérification de l’autorisation de localisation…';

  @override
  String get main_location_permission_granted => 'Autorisation de localisation accordée.';

  @override
  String get main_checkingStoragePermission => 'Vérification de l’autorisation de stockage…';

  @override
  String get main_storagePermissionGranted => 'Autorisation de stockage accordée.';

  @override
  String get main_loadingPreferences => 'Chargement des préférences…';

  @override
  String get main_preferencesLoaded => 'Préférences chargées.';

  @override
  String get main_loadingWorkspace => 'Chargement de l’espace de travail…';

  @override
  String get main_workspaceLoaded => 'Espace de travail chargé.';

  @override
  String get main_loadingTagsList => 'Chargement de la liste des étiquettes…';

  @override
  String get main_tagsListLoaded => 'Liste des étiquettes chargée.';

  @override
  String get main_loadingKnownProjections => 'Chargement des projections connues…';

  @override
  String get main_knownProjectionsLoaded => 'Projections connues chargées.';

  @override
  String get main_loadingFences => 'Chargement des barrières…';

  @override
  String get main_fencesLoaded => 'Barrières chargées.';

  @override
  String get main_loadingLayersList => 'Chargement de la liste des calques…';

  @override
  String get main_layersListLoaded => 'Liste des calques chargée.';

  @override
  String get main_locationBackgroundWarning => 'Autoriser la permission de localisation dans l\'étape suivante permet la récupération des données GPS en arrière-plan. (Sinon, ça ne fonctionne que quand l\'application est en premier plan.)\nAucune de ces données ne sera partagée, elles seront uniquement sauvegardées localement sur l\'appareil.';

  @override
  String get main_StorageIsInternalWarning => 'Veuillez lire attentivement !\nSous Android 11 et plus récent, le dossier de projet SMASH doit être placé dans le dossier\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\ndans l\'espace de stockage à utiliser.\nSi l\'application est désinstallée, le système le supprimera, veillez donc à faire une copie dans ce cas.\n\nUne meilleure solution est prévue.';

  @override
  String get main_locationPermissionIsMandatoryToOpenSmash => 'La permission de localisation est obligatoire pour ouvrir SMASH.';

  @override
  String get main_storagePermissionIsMandatoryToOpenSmash => 'La permission de stockage est obligatoire pour ouvrir SMASH.';

  @override
  String get main_anErrorOccurredTapToView => 'Une erreur est survenue. Tapez pour voir.';

  @override
  String get mainView_loadingData => 'Chargement des données…';

  @override
  String get mainView_turnGpsOn => 'Activer le GPS';

  @override
  String get mainView_turnGpsOff => 'Désactiver le GPS';

  @override
  String get mainView_exit => 'Quitter';

  @override
  String get mainView_areYouSureCloseTheProject => 'Fermer le projet ?';

  @override
  String get mainView_activeOperationsWillBeStopped => 'Tous les opérations en cours seront arrêtées.';

  @override
  String get mainView_showInteractiveCoachMarks => 'Show interactive coach marks.';

  @override
  String get mainView_openToolsDrawer => 'Ouvrir la barre d\'outils.';

  @override
  String get mainView_zoomIn => 'Zoom avant';

  @override
  String get mainView_zoomOut => 'Zoom arrière';

  @override
  String get mainView_formNotes => 'Notes du formulaire';

  @override
  String get mainView_simpleNotes => 'Notes simples';

  @override
  String get mainviewUtils_projects => 'Projets';

  @override
  String get mainviewUtils_import => 'Importer';

  @override
  String get mainviewUtils_export => 'Exporter';

  @override
  String get mainviewUtils_settings => 'Paramètres';

  @override
  String get mainviewUtils_onlineHelp => 'Aide en ligne';

  @override
  String get mainviewUtils_about => 'À propos';

  @override
  String get mainviewUtils_projectInfo => 'Infos sur le projet';

  @override
  String get mainviewUtils_project => 'Projet';

  @override
  String get mainviewUtils_database => 'Base de données';

  @override
  String get mainviewUtils_extras => 'Suppléments';

  @override
  String get mainviewUtils_availableIcons => 'Icônes disponibles';

  @override
  String get mainviewUtils_offlineMaps => 'Cartes hors ligne';

  @override
  String get mainviewUtils_positionTools => 'Outils de positionnement';

  @override
  String get mainviewUtils_goTo => 'Aller à';

  @override
  String get mainviewUtils_goToCoordinate => 'Go to coordinate';

  @override
  String get mainviewUtils_enterLonLat => 'Enter longitude, latitude';

  @override
  String get mainviewUtils_goToCoordinateWrongFormat => 'Wrong coordinate format. Should be: 11.18463, 46.12345';

  @override
  String get mainviewUtils_goToCoordinateEmpty => 'This can\'t be empty.';

  @override
  String get mainviewUtils_sharePosition => 'Position de l\'action';

  @override
  String get mainviewUtils_rotateMapWithGps => 'Pivoter la carte grâce au GPS';

  @override
  String get exportWidget_export => 'Exporter';

  @override
  String get exportWidget_pdfExported => 'PDF exporté';

  @override
  String get exportWidget_exportToPortableDocumentFormat => 'Exporter le projet en Portable Document Format (PDF)';

  @override
  String get exportWidget_gpxExported => 'GPX exporté';

  @override
  String get exportWidget_exportToGpx => 'Exporter le projet au format GPX';

  @override
  String get exportWidget_kmlExported => 'KML exporté';

  @override
  String get exportWidget_exportToKml => 'Exporter le projet au format KML';

  @override
  String get exportWidget_imagesToFolderExported => 'Images exportées';

  @override
  String get exportWidget_exportImagesToFolder => 'Exporter les images du projet dans un dossier';

  @override
  String get exportWidget_exportImagesToFolderTitle => 'Images';

  @override
  String get exportWidget_geopackageExported => 'Geopackage exporté';

  @override
  String get exportWidget_exportToGeopackage => 'Exporter le projets vers Geopackage';

  @override
  String get exportWidget_exportToGSS => 'Exporter vers Geopaparazzi Survey Server';

  @override
  String get gssExport_gssExport => 'Export en GSS';

  @override
  String get gssExport_setProjectDirty => 'Set project to DIRTY?';

  @override
  String get gssExport_thisCantBeUndone => 'Cela ne peut être annulé !';

  @override
  String get gssExport_restoreProjectAsDirty => 'Restore project as all dirty.';

  @override
  String get gssExport_setProjectClean => 'Set project to CLEAN?';

  @override
  String get gssExport_restoreProjectAsClean => 'Restore project as all clean.';

  @override
  String get gssExport_nothingToSync => 'Rien à synchroniser.';

  @override
  String get gssExport_collectingSyncStats => 'Récupération des statistiques de synchronisation…';

  @override
  String get gssExport_unableToSyncDueToError => 'Échec de la synchronisation, veuillez analyser le diagnostique.';

  @override
  String get gssExport_noGssUrlSet => 'Aucune URL vers un serveur GSS n\'a été spécifiée. Veuillez vérifier vos préférences.';

  @override
  String get gssExport_noGssPasswordSet => 'Aucun mot de passe pour le serveur GSS n\'a été spécifié. Veuillez vérifier vos préférences.';

  @override
  String get gssExport_synStats => 'Statistiques de synchronisation';

  @override
  String get gssExport_followingDataWillBeUploaded => 'Les données suivantes seront envoyées lors de la synchronisation.';

  @override
  String get gssExport_gpsLogs => 'Journal GPS :';

  @override
  String get gssExport_simpleNotes => 'Notes simples :';

  @override
  String get gssExport_formNotes => 'Notes de formulaire :';

  @override
  String get gssExport_images => 'Images :';

  @override
  String get gssExport_shouldNotHappen => 'Ceci ne devrait pas arriver';

  @override
  String get gssExport_upload => 'Envoyer';

  @override
  String get geocoding_geocoding => 'Geocoding';

  @override
  String get geocoding_nothingToLookFor => 'Rien a rechercher. Veuillez préciser une adresse.';

  @override
  String get geocoding_launchGeocoding => 'Lancer Geocoding';

  @override
  String get geocoding_searching => 'Recherche…';

  @override
  String get gps_smashIsActive => 'SMASH est actif';

  @override
  String get gps_smashIsLogging => 'SMASH enregistre';

  @override
  String get gps_locationTracking => 'Suivi de la localisation';

  @override
  String get gps_smashLocServiceIsActive => 'Le service de localisation de SMASH est actif.';

  @override
  String get gps_backgroundLocIsOnToKeepRegistering => 'La localisation en arrière-plan est active pour permettre à l\'application d\'enregistrer la position même quand elle est en arrière-plan.';

  @override
  String get gssImport_gssImport => 'Importer en GSS';

  @override
  String get gssImport_downloadingDataList => 'Téléchargement de la liste des données…';

  @override
  String get gssImport_unableDownloadDataList => 'Le téléchargement de la liste des données à échoué. Veuillez vérifier vos préférences et le journal.';

  @override
  String get gssImport_noGssUrlSet => 'Aucune URL de serveur GSS n\'a été spécifiée. Veuillez vérifier vos préférences.';

  @override
  String get gssImport_noGssPasswordSet => 'Aucun mot de passe pour le serveur GSS n\'a été spécifié. Veuillez vérifier vos préférences.';

  @override
  String get gssImport_noPermToAccessServer => 'Aucune permission pour l\'accès au serveur. Veuillez vérifier vos identifiants.';

  @override
  String get gssImport_data => 'Données';

  @override
  String get gssImport_dataSetsDownloadedMapsFolder => 'Les jeux de données sont téléchargés dans le dossier des cartes.';

  @override
  String get gssImport_noDataAvailable => 'Aucune donnée disponible.';

  @override
  String get gssImport_projects => 'Projets';

  @override
  String get gssImport_projectsDownloadedProjectFolder => 'Les projets sont téléchargés dans le dossier des projets.';

  @override
  String get gssImport_noProjectsAvailable => 'Aucun projet disponible.';

  @override
  String get gssImport_forms => 'Formulaires';

  @override
  String get gssImport_tagsDownloadedFormsFolder => 'Les fichiers de marquage sont téléchargés dans le dossier des formulaires.';

  @override
  String get gssImport_noTagsAvailable => 'Aucun marquage disponible.';

  @override
  String get importWidget_import => 'Importer';

  @override
  String get importWidget_importFromGeopaparazzi => 'Importer depuis Geopaparazzi Survey Server';

  @override
  String get layersView_layerList => 'Liste des calques';

  @override
  String get layersView_loadRemoteDatabase => 'Charger une base de données distante';

  @override
  String get layersView_loadOnlineSources => 'Charger des sources en ligne';

  @override
  String get layersView_loadLocalDatasets => 'Charger des jeux de données locaux';

  @override
  String get layersView_loading => 'Chargement…';

  @override
  String get layersView_zoomTo => 'Zoomer sur';

  @override
  String get layersView_properties => 'Propriétés';

  @override
  String get layersView_delete => 'Supprimer';

  @override
  String get layersView_projCouldNotBeRecognized => 'Le « proj » n\'a pu être reconnu. Tapez pour entrer le « epsg » manuellement.';

  @override
  String get layersView_projNotSupported => 'Le « proj » n\'est pas supporté. Tapez pour résoudre.';

  @override
  String get layersView_onlyImageFilesWithWorldDef => 'Only image files with world file definition are supported.';

  @override
  String get layersView_onlyImageFileWithPrjDef => 'Seules les fichiers d\'image avec le fichier de définition « prj » sont supportés.';

  @override
  String get layersView_selectTableToLoad => 'Sélectionnez le tableau à charger.';

  @override
  String get layersView_fileFormatNotSUpported => 'Ce format de fichier n\'est pas supporté.';

  @override
  String get onlineSourcesPage_onlineSourcesCatalog => 'Online Sources Catalog';

  @override
  String get onlineSourcesPage_loadingTmsLayers => 'Chargement des calques TMS…';

  @override
  String get onlineSourcesPage_loadingWmsLayers => 'Chargement des calques WMS…';

  @override
  String get onlineSourcesPage_importFromFile => 'Importer depuis un fichier';

  @override
  String get onlineSourcesPage_theFile => 'Le fichier';

  @override
  String get onlineSourcesPage_doesntExist => 'n\'existe pas';

  @override
  String get onlineSourcesPage_onlineSourcesImported => 'Online sources imported.';

  @override
  String get onlineSourcesPage_exportToFile => 'Exporter dans le fichier';

  @override
  String get onlineSourcesPage_exportedTo => 'Exporter dans :';

  @override
  String get onlineSourcesPage_delete => 'Supprimer';

  @override
  String get onlineSourcesPage_addToLayers => 'Ajouter aux calques';

  @override
  String get onlineSourcesPage_setNameTmsService => 'Spécifiez un nom pour le service TMS';

  @override
  String get onlineSourcesPage_enterName => 'entrer nom';

  @override
  String get onlineSourcesPage_pleaseEnterValidName => 'Veuillez entrer un nom valide';

  @override
  String get onlineSourcesPage_insertUrlOfService => 'Insérez l\'URL du service.';

  @override
  String get onlineSourcesPage_placeXyzBetBrackets => 'Placer les x, y, z entre les accolades.';

  @override
  String get onlineSourcesPage_pleaseEnterValidTmsUrl => 'Veuillez entrer une URL TMS valide';

  @override
  String get onlineSourcesPage_enterUrl => 'entrez l\'URL';

  @override
  String get onlineSourcesPage_enterSubDomains => 'entrez les sous-domaines';

  @override
  String get onlineSourcesPage_addAttribution => 'Ajouter un attribut.';

  @override
  String get onlineSourcesPage_enterAttribution => 'entrez un attribut';

  @override
  String get onlineSourcesPage_setMinMaxZoom => 'Définir le zoom min et max.';

  @override
  String get onlineSourcesPage_minZoom => 'Zoom min';

  @override
  String get onlineSourcesPage_maxZoom => 'Zoom max';

  @override
  String get onlineSourcesPage_pleaseCheckYourData => 'Veuillez vérifier vos données';

  @override
  String get onlineSourcesPage_details => 'Détails';

  @override
  String get onlineSourcesPage_name => 'Nom : ';

  @override
  String get onlineSourcesPage_subDomains => 'Sous-domaines : ';

  @override
  String get onlineSourcesPage_attribution => 'Attribution : ';

  @override
  String get onlineSourcesPage_cancel => 'Annuler';

  @override
  String get onlineSourcesPage_ok => 'OK';

  @override
  String get onlineSourcesPage_newTmsOnlineService => 'Nouveau service TMS en ligne';

  @override
  String get onlineSourcesPage_save => 'Enregistrer';

  @override
  String get onlineSourcesPage_theBaseUrlWithQuestionMark => 'L\'URL de base finissant par « ? ».';

  @override
  String get onlineSourcesPage_pleaseEnterValidWmsUrl => 'Veuillez entrer une URL WMS valide';

  @override
  String get onlineSourcesPage_setWmsLayerName => 'Définir le nom du calque WMS';

  @override
  String get onlineSourcesPage_enterLayerToLoad => 'entrez le calque à charger';

  @override
  String get onlineSourcesPage_pleaseEnterValidLayer => 'Please enter a valid layer';

  @override
  String get onlineSourcesPage_setWmsImageFormat => 'Set WMS image format';

  @override
  String get onlineSourcesPage_addAnAttribution => 'Add an attribution.';

  @override
  String get onlineSourcesPage_layer => 'Calque : ';

  @override
  String get onlineSourcesPage_url => 'URL : ';

  @override
  String get onlineSourcesPage_format => 'Format';

  @override
  String get onlineSourcesPage_newWmsOnlineService => 'New WMS Online Service';

  @override
  String get remoteDbPage_remoteDatabases => 'Bases de données distantes';

  @override
  String get remoteDbPage_delete => 'Supprimer';

  @override
  String get remoteDbPage_areYouSureDeleteDatabase => 'Supprimer la configuration de la base de données ?';

  @override
  String get remoteDbPage_edit => 'Modifier';

  @override
  String get remoteDbPage_table => 'tableau';

  @override
  String get remoteDbPage_user => 'utilisateur';

  @override
  String get remoteDbPage_loadInMap => 'Load in map.';

  @override
  String get remoteDbPage_databaseParameters => 'Database Parameters';

  @override
  String get remoteDbPage_cancel => 'Annuler';

  @override
  String get remoteDbPage_ok => 'OK';

  @override
  String get remoteDbPage_theUrlNeedsToBeDefined => 'The URL must be defined (postgis:host:port/databasename)';

  @override
  String get remoteDbPage_theUserNeedsToBeDefined => 'A user must be defined.';

  @override
  String get remoteDbPage_password => 'mot de passe';

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
  String get geoImage_opacity => 'Opacité';

  @override
  String get geoImage_colorToHide => 'Color to hide';

  @override
  String get gpx_gpxProperties => 'GPX Properties';

  @override
  String get gpx_wayPoints => 'Waypoints';

  @override
  String get gpx_color => 'Couleur';

  @override
  String get gpx_size => 'Taille';

  @override
  String get gpx_viewLabelsIfAvailable => 'View labels if available?';

  @override
  String get gpx_tracksRoutes => 'Tracks/routes';

  @override
  String get gpx_width => 'Largeur';

  @override
  String get gpx_palette => 'Palette';

  @override
  String get tiles_tileProperties => 'Tile Properties';

  @override
  String get tiles_opacity => 'Opacité';

  @override
  String get tiles_loadGeoPackageAsOverlay => 'Load geopackage tiles as overlay image as opposed to tile layer (best for gdal generated data and different projections).';

  @override
  String get tiles_colorToHide => 'Color to hide';

  @override
  String get wms_wmsProperties => 'WMS Properties';

  @override
  String get wms_opacity => 'Opacité';

  @override
  String get featureAttributesViewer_loadingData => 'Loading data…';

  @override
  String get featureAttributesViewer_setNewValue => 'Set new value';

  @override
  String get featureAttributesViewer_field => 'Champ';

  @override
  String get featureAttributesViewer_value => 'VALEUR';

  @override
  String get projectsView_projectsView => 'Projects View';

  @override
  String get projectsView_openExistingProject => 'Ouvrir un projet existant';

  @override
  String get projectsView_createNewProject => 'Créer un nouveau projet';

  @override
  String get projectsView_recentProjects => 'Recent projects';

  @override
  String get projectsView_newProject => 'Nouveau projet';

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
  String get dataLoader_savingImageToDB => 'Enregistrement de l\'image dans la base de données…';

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
  String get dataLoader_timestamp => 'Horodatage';

  @override
  String get dataLoader_removeImage => 'Remove Image';

  @override
  String get dataLoader_areYouSureRemoveImage => 'Remove the image?';

  @override
  String get images_loadingImage => 'Loading image…';

  @override
  String get about_loadingInformation => 'Chargement des informations…';

  @override
  String get about_ABOUT => 'À propos ';

  @override
  String get about_smartMobileAppForSurveyor => 'Smart Mobile App for Surveyor Happiness';

  @override
  String get about_applicationVersion => 'Version';

  @override
  String get about_license => 'Licence';

  @override
  String get about_isAvailableUnderGPL3 => ' is copylefted libre software, licensed GPLv3+.';

  @override
  String get about_sourceCode => 'Source Code';

  @override
  String get about_tapHereToVisitRepo => 'Tap here to visit the source code repository';

  @override
  String get about_legalInformation => 'Informations légales';

  @override
  String get about_copyright2020HydroloGIS => 'Copyright © 2020, HydroloGIS S.r.l. — certains droits réservés. Tapez pour visiter.';

  @override
  String get about_supportedBy => 'Soutenu par';

  @override
  String get about_partiallySupportedByUniversityTrento => 'En partie supporté dans le cadre du projet Steep Stream de l\'Université de Trento.';

  @override
  String get about_privacyPolicy => 'Privacy Policy';

  @override
  String get about_tapHereToSeePrivacyPolicy => 'Tapez ici pour accéder à la politique de confidentialité couvrant la gestion des données utilisateur et de localisation.';

  @override
  String get gpsInfoButton_noGpsInfoAvailable => 'Aucune donnée GPS disponible…';

  @override
  String get gpsInfoButton_timestamp => 'Horodatage';

  @override
  String get gpsInfoButton_speed => 'Vitesse';

  @override
  String get gpsInfoButton_heading => 'Direction';

  @override
  String get gpsInfoButton_accuracy => 'Précision';

  @override
  String get gpsInfoButton_altitude => 'Altitude';

  @override
  String get gpsInfoButton_latitude => 'Latitude';

  @override
  String get gpsInfoButton_copyLatitudeToClipboard => 'Copier la latitude dans le presse-papier.';

  @override
  String get gpsInfoButton_longitude => 'Longitude';

  @override
  String get gpsInfoButton_copyLongitudeToClipboard => 'Copier la longitude dans le presse-papier.';

  @override
  String get gpsLogButton_stopLogging => 'Stop Logging?';

  @override
  String get gpsLogButton_stopLoggingAndCloseLog => 'Stop logging and close the current GPS log?';

  @override
  String get gpsLogButton_newLog => 'Nouveau journal';

  @override
  String get gpsLogButton_enterNameForNewLog => 'Enter a name for the new log';

  @override
  String get gpsLogButton_couldNotStartLogging => 'Could not start logging: ';

  @override
  String get imageWidgets_loadingImage => 'Chargement de l\'image…';

  @override
  String get logList_gpsLogsList => 'GPS Logs list';

  @override
  String get logList_selectAll => 'Tout sélectionner';

  @override
  String get logList_unSelectAll => 'Tout désélectionner';

  @override
  String get logList_invertSelection => 'Inverser la sélection';

  @override
  String get logList_mergeSelected => 'Fusionner la sélection';

  @override
  String get logList_loadingLogs => 'Chargement des journaux…';

  @override
  String get logList_zoomTo => 'Zoomer sur';

  @override
  String get logList_properties => 'Propriétés';

  @override
  String get logList_profileView => 'Profile View';

  @override
  String get logList_toGPX => 'Vers GPX';

  @override
  String get logList_gpsSavedInExportFolder => 'GPX saved in export folder.';

  @override
  String get logList_errorOccurredExportingLogGPX => 'Could not export log to GPX.';

  @override
  String get logList_delete => 'Supprimer';

  @override
  String get logList_DELETE => 'Supprimer';

  @override
  String get logList_areYouSureDeleteTheLog => 'Delete the log?';

  @override
  String get logList_hours => 'heures';

  @override
  String get logList_hour => 'heure';

  @override
  String get logList_minutes => 'min';

  @override
  String get logProperties_gpsLogProperties => 'GPS Log Properties';

  @override
  String get logProperties_logName => 'Nom du journal';

  @override
  String get logProperties_start => 'Départ';

  @override
  String get logProperties_end => 'Arrivée';

  @override
  String get logProperties_duration => 'Durée';

  @override
  String get logProperties_color => 'Couleur';

  @override
  String get logProperties_palette => 'Palette';

  @override
  String get logProperties_width => 'Largeur';

  @override
  String get logProperties_distanceAtPosition => 'Distance at position:';

  @override
  String get logProperties_totalDistance => 'Distance totale :';

  @override
  String get logProperties_gpsLogView => 'GPS Log View';

  @override
  String get logProperties_disableStats => 'Turn off stats';

  @override
  String get logProperties_enableStats => 'Turn on stats';

  @override
  String get logProperties_totalDuration => 'Durée totale :';

  @override
  String get logProperties_timestamp => 'Timestamp:';

  @override
  String get logProperties_durationAtPosition => 'Durée à la position :';

  @override
  String get logProperties_speed => 'Vitesse :';

  @override
  String get logProperties_elevation => 'Élévation :';

  @override
  String get noteList_simpleNotesList => 'Une simple liste de notes';

  @override
  String get noteList_formNotesList => 'List of Form Notes';

  @override
  String get noteList_loadingNotes => 'Chargement des notes…';

  @override
  String get noteList_zoomTo => 'Zoomer sur';

  @override
  String get noteList_edit => '\'Modifier\'';

  @override
  String get noteList_properties => 'Propriétés';

  @override
  String get noteList_delete => 'Supprimer';

  @override
  String get noteList_DELETE => 'Supprimer';

  @override
  String get noteList_areYouSureDeleteNote => 'Supprimer la note ?';

  @override
  String get settings_settings => 'Préférences';

  @override
  String get settings_camera => 'Caméra';

  @override
  String get settings_cameraResolution => 'Résolution de la caméra';

  @override
  String get settings_resolution => 'Résolution';

  @override
  String get settings_theCameraResolution => 'La résolution de la caméra';

  @override
  String get settings_screen => 'L\'écran';

  @override
  String get settings_screenScaleBarIconSize => 'Screen, Scalebar and Icon Size';

  @override
  String get settings_keepScreenOn => 'Garder l\'écran allumé';

  @override
  String get settings_retinaScreenMode => 'Mode d\'écran HiDPI';

  @override
  String get settings_toApplySettingEnterExitLayerView => 'Entrez puis quitter la vue des calques pour appliquer cette préférence.';

  @override
  String get settings_colorPickerToUse => 'Color Picker to use';

  @override
  String get settings_mapCenterCross => 'La croix au centre de la carte';

  @override
  String get settings_color => 'Couleur';

  @override
  String get settings_size => 'Taille';

  @override
  String get settings_width => 'Largeur';

  @override
  String get settings_mapToolsIconSize => 'La taille des icônes d\'outils de la carte';

  @override
  String get settings_gps => 'GPS';

  @override
  String get settings_gpsFiltersAndMockLoc => 'GPS filters and mock locations';

  @override
  String get settings_livePreview => 'Aperçu direct';

  @override
  String get settings_noPointAvailableYet => 'Aucun point n\'est disponible encore.';

  @override
  String get settings_longitudeDeg => 'longitude [deg]';

  @override
  String get settings_latitudeDeg => 'latitude [deg]';

  @override
  String get settings_accuracyM => 'précision [m]';

  @override
  String get settings_altitudeM => 'altitude [m]';

  @override
  String get settings_headingDeg => 'direction [deg]';

  @override
  String get settings_speedMS => 'vitesse [m/s]';

  @override
  String get settings_isLogging => 'enregistre ?';

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
  String get settings_enable => 'Activer';

  @override
  String get settings_theUseOfTheGps => 'l\'utilisation de données GPS filtrées.';

  @override
  String get settings_warningThisWillAffectGpsPosition => 'Warning: This will affect GPS position, notes insertion, log statistics and charting.';

  @override
  String get settings_MockLocations => 'Locations fictives';

  @override
  String get settings_testGpsLogDemoUse => 'journal GPS de test pour démonstration.';

  @override
  String get settings_setDurationGpsPointsInMilli => 'Définir la durée des points du GPS en millisecondes.';

  @override
  String get settings_SETTING => 'Préférence';

  @override
  String get settings_setMockedGpsDuration => 'Set Mocked GPS duration';

  @override
  String get settings_theValueHasToBeInt => 'Cette valeur doit être un nombre entier.';

  @override
  String get settings_milliseconds => 'millisecondes';

  @override
  String get settings_useGoogleToImproveLoc => 'Utiliser les Services Google pour améliorer la localisation';

  @override
  String get settings_useOfGoogleServicesRestart => 'utiliser les services Google (requiert un redémarrage de l\'application).';

  @override
  String get settings_gpsLogsViewMode => 'Mode d\'aperçu des journaux de GPS';

  @override
  String get settings_logViewModeForOrigData => 'Log view mode for original data.';

  @override
  String get settings_logViewModeFilteredData => 'Log view mode for filtered data.';

  @override
  String get settings_cancel => 'Annuler';

  @override
  String get settings_ok => 'OK';

  @override
  String get settings_notesViewModes => 'Notes view modes';

  @override
  String get settings_selectNotesViewMode => 'Sélectionnez un mode pour voir les notes.';

  @override
  String get settings_mapPlugins => 'Greffons de la carte';

  @override
  String get settings_vectorLayers => 'Calques vectoriels';

  @override
  String get settings_loadingOptionsInfoTool => 'Loading Options and Info Tool';

  @override
  String get settings_dataLoading => 'Chargement des données';

  @override
  String get settings_maxNumberFeatures => 'Le nombre maximum de fonctionnalités.';

  @override
  String get settings_maxNumFeaturesPerLayer => 'Max features per layer. Remove and add the layer to apply.';

  @override
  String get settings_all => 'tous';

  @override
  String get settings_loadMapArea => 'Load map area.';

  @override
  String get settings_loadOnlyLastVisibleArea => 'Ne charger que la dernière partie visible de la carte. Veuillez retirer pour ajouter à nouveau le calque pour que ça s\'applique.';

  @override
  String get settings_infoTool => 'Information de l\'outil';

  @override
  String get settings_tapSizeInfoToolPixels => 'La taille en pixels de la zone de tape des outils d\'info';

  @override
  String get settings_editingTool => 'Editing tool';

  @override
  String get settings_editingDragIconSize => 'Editing drag handler icon size.';

  @override
  String get settings_editingIntermediateDragIconSize => 'Editing intermediate drag handler icon size.';

  @override
  String get settings_diagnostics => 'Diagnostiques';

  @override
  String get settings_diagnosticsDebugLog => 'Diagnostiques et journal de débogage';

  @override
  String get settings_openFullDebugLog => 'Ouvrir le journal de débogage en entier';

  @override
  String get settings_debugLogView => 'Vue du journal de débogage';

  @override
  String get settings_viewAllMessages => 'Afficher tous les messages';

  @override
  String get settings_viewOnlyErrorsWarnings => 'N\'afficher que les erreurs et les avertissements';

  @override
  String get settings_clearDebugLog => 'Clear debug log';

  @override
  String get settings_loadingData => 'Chargement des données…';

  @override
  String get settings_device => 'Appareil';

  @override
  String get settings_deviceIdentifier => 'Identifiant de l\'appareil';

  @override
  String get settings_deviceId => 'ID de l\'appareil';

  @override
  String get settings_overrideDeviceId => 'Override Device ID';

  @override
  String get settings_overrideId => 'Override ID';

  @override
  String get settings_pleaseEnterValidPassword => 'Veuillez entrer un mot de passe de serveur valide.';

  @override
  String get settings_gss => 'GSS';

  @override
  String get settings_geopaparazziSurveyServer => 'Geopaparazzi Survey Server';

  @override
  String get settings_serverUrl => 'L\'URL du serveur';

  @override
  String get settings_serverUrlStartWithHttp => 'L\'URL du serveur doit commencer par HTTP ou HTTPS.';

  @override
  String get settings_serverPassword => 'Mot de passe du serveur';

  @override
  String get settings_allowSelfSignedCert => 'Autoriser les certificats auto-signés';

  @override
  String get toolbarTools_zoomOut => 'Dézoomer';

  @override
  String get toolbarTools_zoomIn => 'Zoomer';

  @override
  String get toolbarTools_cancelCurrentEdit => 'Annuler la modification actuelle.';

  @override
  String get toolbarTools_saveCurrentEdit => 'Enregistrer la modification actuelle.';

  @override
  String get toolbarTools_insertPointMapCenter => 'Insérer un point au centre de la carte.';

  @override
  String get toolbarTools_insertPointGpsPos => 'Insérer un point sur la position GPS.';

  @override
  String get toolbarTools_removeSelectedFeature => 'Retirer les fonctionnalités sélectionnées.';

  @override
  String get toolbarTools_showFeatureAttributes => 'Show feature attributes.';

  @override
  String get toolbarTools_featureDoesNotHavePrimaryKey => 'The feature does not have a primary key. Editing is not allowed.';

  @override
  String get toolbarTools_queryFeaturesVectorLayers => 'Query features from loaded vector layers.';

  @override
  String get toolbarTools_measureDistanceWithFinger => 'Mesurer les distances sur la carte avec votre doigt.';

  @override
  String get toolbarTools_toggleFenceMapCenter => 'Toggle fence in map center.';

  @override
  String get toolbarTools_modifyGeomVectorLayers => 'Modifier la géométrie des calques vectoriels modifiables.';

  @override
  String get coachMarks_singleTap => 'Simple tape : ';

  @override
  String get coachMarks_longTap => 'Tape prolongé : ';

  @override
  String get coachMarks_doubleTap => 'Double-tape : ';

  @override
  String get coachMarks_simpleNoteButton => 'Le bouton des notes simples';

  @override
  String get coachMarks_addNewNote => 'ajouter une nouvelle note';

  @override
  String get coachMarks_viewNotesList => 'afficher la liste des notes';

  @override
  String get coachMarks_viewNotesSettings => 'afficher les préférences des notes';

  @override
  String get coachMarks_formNotesButton => 'Form Notes Button';

  @override
  String get coachMarks_addNewFormNote => 'add new form note';

  @override
  String get coachMarks_viewFormNoteList => 'view list of form notes';

  @override
  String get coachMarks_gpsLogButton => 'GPS Log Button';

  @override
  String get coachMarks_startStopLogging => 'démarrer/arrêter l\'enregistrement';

  @override
  String get coachMarks_viewLogsList => 'afficher la liste des journaux';

  @override
  String get coachMarks_viewLogsSettings => 'afficher les préférences du journal';

  @override
  String get coachMarks_gpsInfoButton => 'GPS Info Button (if applicable)';

  @override
  String get coachMarks_centerMapOnGpsPos => 'centrer la carte sur la position GPS';

  @override
  String get coachMarks_showGpsInfo => 'afficher les infos du GPS';

  @override
  String get coachMarks_toggleAutoCenterGps => 'dés/activer la centrage auto du GPS';

  @override
  String get coachMarks_layersViewButton => 'Layers View Button';

  @override
  String get coachMarks_openLayersView => 'Ouvrir la vue des calques';

  @override
  String get coachMarks_openLayersPluginDialog => 'Ouvrir le dialogue des greffons des calques';

  @override
  String get coachMarks_zoomInButton => 'Bouton de zoom avant';

  @override
  String get coachMarks_zoomImMapOneLevel => 'Zoom la carte un niveau en avant';

  @override
  String get coachMarks_zoomOutButton => 'Bouton de zoom arrière';

  @override
  String get coachMarks_zoomOutMapOneLevel => 'Zoom la carte un niveau en arrière';

  @override
  String get coachMarks_bottomToolsButton => 'Bottom Tools Button';

  @override
  String get coachMarks_toggleBottomToolsBar => 'Toggle bottom tools bar';

  @override
  String get coachMarks_toolsButton => 'Tools Button';

  @override
  String get coachMarks_openEndDrawerToAccessProject => 'Open the end drawer to access project info and sharing options as well as map plugins, feature tools and extras';

  @override
  String get coachMarks_interactiveCoackMarksButton => 'Interactive coach-marks button';

  @override
  String get coachMarks_openInteractiveCoachMarks => 'Open the interactice coach marks explaining all the actions of the main map view.';

  @override
  String get coachMarks_mainMenuButton => 'Main-menu Button';

  @override
  String get coachMarks_openDrawerToLoadProject => 'Ouvrez le menu pour charger ou créer un projet, importer ou exporter les données, synchroniser avec un serveur, accéder aux préférences, quitter l\'application ou désactiver le GPS.';

  @override
  String get coachMarks_skip => 'Skip';

  @override
  String get fence_fenceProperties => 'Fence Properties';

  @override
  String get fence_delete => 'Supprimer';

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
  String get network_cancelledByUser => 'Annulé par l’utilisateur.';

  @override
  String get network_completed => 'Terminé.';

  @override
  String get network_buildingBaseCachePerformance => 'Building base cache for improved performance (might take a while)…';

  @override
  String get network_thisFIleAlreadyBeingDownloaded => 'This file is already being downloaded.';

  @override
  String get network_download => 'Télécharger';

  @override
  String get network_downloadFile => 'Télécharger le fichier';

  @override
  String get network_toTheDeviceTakeTime => 'sur l’appareil ? Ceci peut prendre un certain temps.';

  @override
  String get network_availableMaps => 'Cartes disponibles';

  @override
  String get network_searchMapByName => 'Recherche de carte par nom';

  @override
  String get network_uploading => 'Téléversement';

  @override
  String get network_pleaseWait => 'veuillez patienter…';

  @override
  String get network_permissionOnServerDenied => 'Permission on server denied.';

  @override
  String get network_couldNotConnectToServer => 'Could not connect to the server. Is it online? Check your address.';

  @override
  String get form_smash_cantSaveImageDb => 'Impossible d’enregistrer l’image dans la base de données.';

  @override
  String get formbuilder => 'Form builder';

  @override
  String get layersView_selectGssLayers => 'Select GSS Layers';

  @override
  String get layersView_noGssLayersFound => 'No GSS layers found.';

  @override
  String get layersView_noGssLayersAvailable => 'No layers available (loaded ones are not shown).';

  @override
  String get layersView_selectGssLayersToLoad => 'Select GSS layers to load.';

  @override
  String get layersView_unableToLoadGssLayers => 'Unable to load:';

  @override
  String get layersView_layerExists => 'Layer exists';

  @override
  String get layersView_layerAlreadyExists => 'Layer already exists, do you want to overwrite it?';

  @override
  String get gss_layerview_upload_changes => 'Upload changes';

  @override
  String get allGpsPointsCount => 'Gps points';

  @override
  String get filteredGpsPointsCount => 'Filtered points';

  @override
  String get addTmsFromDefaults => 'Add TMS from defaults';

  @override
  String get form_smash_noCameraDesktop => 'No camera option available on desktop.';

  @override
  String get settings_BottombarCustomization => 'Bottombar Customization';

  @override
  String get settings_Bottombar_showAddNote => 'Show the ADD NOTE button';

  @override
  String get settings_Bottombar_showAddFormNote => 'Show the ADD FORM NOTE button';

  @override
  String get settings_Bottombar_showAddGpsLog => 'Show the ADD GPS LOG button';

  @override
  String get settings_Bottombar_showGpsButton => 'Show the gps button';

  @override
  String get settings_Bottombar_showLayers => 'Show the layers button';

  @override
  String get settings_Bottombar_showZoom => 'Show the zoom buttons';

  @override
  String get settings_Bottombar_showEditing => 'Show the editing button';

  @override
  String get gss_layerview_filter => 'Filter';
}
