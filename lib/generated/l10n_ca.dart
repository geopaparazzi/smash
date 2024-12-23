import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class SLCa extends SL {
  SLCa([String locale = 'ca']) : super(locale);

  @override
  String get main_welcome => 'Benvingut a SMASH!';

  @override
  String get main_check_location_permission => 'S\'està comprovant el permís d\'ubicació…';

  @override
  String get main_location_permission_granted => 'Permís d\'ubicació concedit.';

  @override
  String get main_checkingStoragePermission => 'S\'està comprovant el permís d\'emmagatzematge…';

  @override
  String get main_storagePermissionGranted => 'Permís d\'emmagatzematge concedit.';

  @override
  String get main_loadingPreferences => 'Carregant les preferències…';

  @override
  String get main_preferencesLoaded => 'Preferències carregades.';

  @override
  String get main_loadingWorkspace => 'Carregant espai de treball…';

  @override
  String get main_workspaceLoaded => 'Espai de treball carregat.';

  @override
  String get main_loadingTagsList => 'Carregant llista d\'etiquetes…';

  @override
  String get main_tagsListLoaded => 'Llista d\'etiquetes carregada.';

  @override
  String get main_loadingKnownProjections => 'Carregant projeccions conegudes…';

  @override
  String get main_knownProjectionsLoaded => 'Projeccions conegudes carregades.';

  @override
  String get main_loadingFences => 'Carregant les tanques…';

  @override
  String get main_fencesLoaded => 'Tanques carregades.';

  @override
  String get main_loadingLayersList => 'Carregant la llista de capes…';

  @override
  String get main_layersListLoaded => 'Llista de capes carregada.';

  @override
  String get main_locationBackgroundWarning => 'Doneu permís d\'ubicació al pas següent per permetre el registre GPS en segon pla. (En cas contrari, només funciona en primer pla.)\nNo es comparteixen dades i només es desaran localment al dispositiu.';

  @override
  String get main_StorageIsInternalWarning => 'Si us plau, llegiu atentament!\nA Android 11 i superior, la carpeta del projecte SMASH s\'ha de col·locar a la\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\ncarpeta del vostre emmagatzematge per utilitzar-la.\nSi l\'aplicació es desintal·la, el sistema l\'elimina, així que feu una còpia de seguretat de les vostres dades si ho feu.\n\nEstem preparant una solució millor.';

  @override
  String get main_locationPermissionIsMandatoryToOpenSmash => 'El permís d\'ubicació és obligatori per obrir SMASH.';

  @override
  String get main_storagePermissionIsMandatoryToOpenSmash => 'El permís d\'emmagatzematge és obligatori per obrir SMASH.';

  @override
  String get main_anErrorOccurredTapToView => 'Hi ha hagut un error. Toca per veure\'l.';

  @override
  String get mainView_loadingData => 'Carregant dades…';

  @override
  String get mainView_turnGpsOn => 'Activeu el GPS';

  @override
  String get mainView_turnGpsOff => 'Desactiveu el GPS';

  @override
  String get mainView_exit => 'Sortir';

  @override
  String get mainView_areYouSureCloseTheProject => 'Tancar projecte?';

  @override
  String get mainView_activeOperationsWillBeStopped => 'S\'aturaran les operacions actives.';

  @override
  String get mainView_showInteractiveCoachMarks => 'Mostra les marques interactives de l\'entrenador.';

  @override
  String get mainView_openToolsDrawer => 'Obriu el calaix d\'eines.';

  @override
  String get mainView_zoomIn => 'Ampliar';

  @override
  String get mainView_zoomOut => 'Reduïr';

  @override
  String get mainView_formNotes => 'Notes de formulari';

  @override
  String get mainView_simpleNotes => 'Notes simples';

  @override
  String get mainviewUtils_projects => 'Projectes';

  @override
  String get mainviewUtils_import => 'Importar';

  @override
  String get mainviewUtils_export => 'Exportar';

  @override
  String get mainviewUtils_settings => 'Configuració';

  @override
  String get mainviewUtils_onlineHelp => 'Ajuda en línia';

  @override
  String get mainviewUtils_about => 'Sobre';

  @override
  String get mainviewUtils_projectInfo => 'Informació del projecte';

  @override
  String get mainviewUtils_projectStats => 'Project Stats';

  @override
  String get mainviewUtils_project => 'Projecte';

  @override
  String get mainviewUtils_database => 'Base de dades';

  @override
  String get mainviewUtils_extras => 'Extres';

  @override
  String get mainviewUtils_availableIcons => 'Icones disponibles';

  @override
  String get mainviewUtils_offlineMaps => 'Mapes fora de línia';

  @override
  String get mainviewUtils_positionTools => 'Eines de posicionament';

  @override
  String get mainviewUtils_goTo => 'Anar a';

  @override
  String get mainviewUtils_goToCoordinate => 'Anar a coordenades';

  @override
  String get mainviewUtils_enterLonLat => 'Introduïu longitud, latitud';

  @override
  String get mainviewUtils_goToCoordinateWrongFormat => 'Format de coordenades incorrecte. Hauria de ser: 11.18463, 46.12345';

  @override
  String get mainviewUtils_goToCoordinateEmpty => 'Això no pot estar buit.';

  @override
  String get mainviewUtils_sharePosition => 'Compartir posició';

  @override
  String get mainviewUtils_rotateMapWithGps => 'Gira el mapa amb GPS';

  @override
  String get exportWidget_export => 'Exportar';

  @override
  String get exportWidget_pdfExported => 'PDF exportat';

  @override
  String get exportWidget_exportToPortableDocumentFormat => 'Exportar projecte a Portable Document Format (PDF)';

  @override
  String get exportWidget_gpxExported => 'GPX exportat';

  @override
  String get exportWidget_exportToGpx => 'Exportar projecte a GPX';

  @override
  String get exportWidget_kmlExported => 'KML exportat';

  @override
  String get exportWidget_exportToKml => 'Exportar projecte a KML';

  @override
  String get exportWidget_imagesToFolderExported => 'Imatges exportades';

  @override
  String get exportWidget_exportImagesToFolder => 'Exportar les imatges del projecte a una carpeta';

  @override
  String get exportWidget_exportImagesToFolderTitle => 'Imatges';

  @override
  String get exportWidget_geopackageExported => 'Geopackage exportat';

  @override
  String get exportWidget_exportToGeopackage => 'Exportar projecte a Geopackage';

  @override
  String get exportWidget_exportToGSS => 'Exportar a Geopaparazzi Survey Server';

  @override
  String get gssExport_gssExport => 'Exportar GSS';

  @override
  String get gssExport_setProjectDirty => 'Marcar projecte com Brut?';

  @override
  String get gssExport_thisCantBeUndone => 'Això no es pot desfer!';

  @override
  String get gssExport_restoreProjectAsDirty => 'Restaura el projecte com a Brut.';

  @override
  String get gssExport_setProjectClean => 'Marcar el projecte com Net?';

  @override
  String get gssExport_restoreProjectAsClean => 'Restaura el projecte com Net.';

  @override
  String get gssExport_nothingToSync => 'Res a sincronitzar.';

  @override
  String get gssExport_collectingSyncStats => 'S\'estan recopilant estadístiques de sincronització…';

  @override
  String get gssExport_unableToSyncDueToError => 'No es pot sincronitzar a causa d\'un error, comproveu els diagnòstics.';

  @override
  String get gssExport_noGssUrlSet => 'No s\'ha definit cap URL del servidor GSS. Comproveu la vostra configuració.';

  @override
  String get gssExport_noGssPasswordSet => 'No s\'ha definit cap contrasenya del servidor GSS. Comproveu la vostra configuració.';

  @override
  String get gssExport_synStats => 'Estadístiques de sincronització';

  @override
  String get gssExport_followingDataWillBeUploaded => 'Les dades següents s\'enviaran quan la sincronització.';

  @override
  String get gssExport_gpsLogs => 'Registres GPS:';

  @override
  String get gssExport_simpleNotes => 'Notes simples:';

  @override
  String get gssExport_formNotes => 'Notes de formulari:';

  @override
  String get gssExport_images => 'Imatges:';

  @override
  String get gssExport_shouldNotHappen => 'No hauria de passar';

  @override
  String get gssExport_upload => 'Enviar';

  @override
  String get geocoding_geocoding => 'Geocodificar';

  @override
  String get geocoding_nothingToLookFor => 'Res a cercar. Entra una adreça.';

  @override
  String get geocoding_launchGeocoding => 'Inicieu la geocodificació';

  @override
  String get geocoding_searching => 'Cercant…';

  @override
  String get gps_smashIsActive => 'SMASH està actiu';

  @override
  String get gps_smashIsLogging => 'SMASH està registrant';

  @override
  String get gps_locationTracking => 'Seguiment de la ubicació';

  @override
  String get gps_smashLocServiceIsActive => 'El servei d\'ubicació SMASH està actiu.';

  @override
  String get gps_backgroundLocIsOnToKeepRegistering => 'La ubicació en segon pla està activada per mantenir l\'aplicació registrant la ubicació fins i tot quan l\'aplicació està en segon pla.';

  @override
  String get gssImport_gssImport => 'Importar GSS';

  @override
  String get gssImport_downloadingDataList => 'S\'està baixant la llista de dades…';

  @override
  String get gssImport_unableDownloadDataList => 'No es pot baixar la llista de dades a causa d\'un error. Comproveu la vostra configuració i el registre.';

  @override
  String get gssImport_noGssUrlSet => 'No s\'ha definit cap URL del servidor GSS. Comproveu la vostra configuració.';

  @override
  String get gssImport_noGssPasswordSet => 'No s\'ha definit cap contrasenya del servidor GSS. Comproveu la vostra configuració.';

  @override
  String get gssImport_noPermToAccessServer => 'No teniu permís per accedir al servidor. Comproveu les vostres credencials.';

  @override
  String get gssImport_data => 'Dades';

  @override
  String get gssImport_dataSetsDownloadedMapsFolder => 'Els conjunts de dades es descarreguen a la carpeta de mapes.';

  @override
  String get gssImport_noDataAvailable => 'No hi ha dades disponibles.';

  @override
  String get gssImport_projects => 'Projectes';

  @override
  String get gssImport_projectsDownloadedProjectFolder => 'Els projectes es descarreguen a la carpeta de projectes.';

  @override
  String get gssImport_noProjectsAvailable => 'No hi ha projectes disponibles.';

  @override
  String get gssImport_forms => 'Formularis';

  @override
  String get gssImport_tagsDownloadedFormsFolder => 'Els fitxers d\'etiquetes es descarreguen a la carpeta de formularis.';

  @override
  String get gssImport_noTagsAvailable => 'No hi ha etiquetes disponibles.';

  @override
  String get importWidget_import => 'Importar';

  @override
  String get importWidget_importFromGeopaparazzi => 'Importar de Geopaparazzi Survey Server';

  @override
  String get layersView_layerList => 'Llista de capes';

  @override
  String get layersView_loadRemoteDatabase => 'Carregueu una base de dades remota';

  @override
  String get layersView_loadOnlineSources => 'Carregueu fonts en línia';

  @override
  String get layersView_loadLocalDatasets => 'Carregueu conjunts de dades locals';

  @override
  String get layersView_loading => 'Carregant…';

  @override
  String get layersView_zoomTo => 'Zoom a';

  @override
  String get layersView_properties => 'Propietats';

  @override
  String get layersView_delete => 'Suprimeix';

  @override
  String get layersView_projCouldNotBeRecognized => 'No es reconeix el \"proj\". Toqueu per definir EPSG manualment.';

  @override
  String get layersView_projNotSupported => 'No s\'admet el \"proj\". Toqueu per resoldre-ho.';

  @override
  String get layersView_onlyImageFilesWithWorldDef => 'Només s\'admeten fitxers d\'imatge amb fitxer mundial de definició.';

  @override
  String get layersView_onlyImageFileWithPrjDef => 'Només s\'admeten fitxers d\'imatge amb fitxer prj de definició.';

  @override
  String get layersView_selectTableToLoad => 'Seleccioneu la taula per carregar.';

  @override
  String get layersView_fileFormatNotSUpported => 'Format de fitxer no compatible.';

  @override
  String get onlineSourcesPage_onlineSourcesCatalog => 'Catàleg de fonts en línia';

  @override
  String get onlineSourcesPage_loadingTmsLayers => 'Carregant capes TMS…';

  @override
  String get onlineSourcesPage_loadingWmsLayers => 'Carregant capes WMS…';

  @override
  String get onlineSourcesPage_importFromFile => 'Importa des d\'un fitxer';

  @override
  String get onlineSourcesPage_theFile => 'L\'arxiu';

  @override
  String get onlineSourcesPage_doesntExist => 'no existeix';

  @override
  String get onlineSourcesPage_onlineSourcesImported => 'Fonts en línia importades.';

  @override
  String get onlineSourcesPage_exportToFile => 'Exporta al fitxer';

  @override
  String get onlineSourcesPage_exportedTo => 'Exportat a:';

  @override
  String get onlineSourcesPage_delete => 'Suprimeix';

  @override
  String get onlineSourcesPage_addToLayers => 'Afegeix a les capes';

  @override
  String get onlineSourcesPage_setNameTmsService => 'Doneu un nom al servei TMS';

  @override
  String get onlineSourcesPage_enterName => 'introduïu el nom';

  @override
  String get onlineSourcesPage_pleaseEnterValidName => 'Introduïu un nom vàlid';

  @override
  String get onlineSourcesPage_insertUrlOfService => 'Afegiu l\'URL del servei.';

  @override
  String get onlineSourcesPage_placeXyzBetBrackets => 'Poseu la x, y, z entre claudàtors.';

  @override
  String get onlineSourcesPage_pleaseEnterValidTmsUrl => 'Introduïu un URL de TMS vàlid';

  @override
  String get onlineSourcesPage_enterUrl => 'introduïu URL';

  @override
  String get onlineSourcesPage_enterSubDomains => 'poseu subdominis';

  @override
  String get onlineSourcesPage_addAttribution => 'Afegiu una atribució.';

  @override
  String get onlineSourcesPage_enterAttribution => 'introduir atribució';

  @override
  String get onlineSourcesPage_setMinMaxZoom => 'Definiu el zoom mínim i màxim.';

  @override
  String get onlineSourcesPage_minZoom => 'Zoom mínim';

  @override
  String get onlineSourcesPage_maxZoom => 'Zoom màxim';

  @override
  String get onlineSourcesPage_pleaseCheckYourData => 'Si us plau, comproveu les vostres dades';

  @override
  String get onlineSourcesPage_details => 'Detalls';

  @override
  String get onlineSourcesPage_name => 'Nom: · ';

  @override
  String get onlineSourcesPage_subDomains => 'Subdominis: · ';

  @override
  String get onlineSourcesPage_attribution => 'Atribució: · ';

  @override
  String get onlineSourcesPage_cancel => 'Cancel·lar';

  @override
  String get onlineSourcesPage_ok => 'D\'acord';

  @override
  String get onlineSourcesPage_newTmsOnlineService => 'Nou servei TMS en línia';

  @override
  String get onlineSourcesPage_save => 'Desar';

  @override
  String get onlineSourcesPage_theBaseUrlWithQuestionMark => 'L\'URL base que acaba amb un signe d\'interrogació.';

  @override
  String get onlineSourcesPage_pleaseEnterValidWmsUrl => 'Introduïu un URL WMS vàlid';

  @override
  String get onlineSourcesPage_setWmsLayerName => 'Definiu el nom de la capa WMS';

  @override
  String get onlineSourcesPage_enterLayerToLoad => 'introduïu la capa per carregar';

  @override
  String get onlineSourcesPage_pleaseEnterValidLayer => 'Introduïu una capa vàlida';

  @override
  String get onlineSourcesPage_setWmsImageFormat => 'Definiu el format d\'imatge WMS';

  @override
  String get onlineSourcesPage_addAnAttribution => 'Afegiu una atribució.';

  @override
  String get onlineSourcesPage_layer => 'Capa: · ';

  @override
  String get onlineSourcesPage_url => 'URL: · ';

  @override
  String get onlineSourcesPage_format => 'Format';

  @override
  String get onlineSourcesPage_newWmsOnlineService => 'Nou servei WMS en línia';

  @override
  String get remoteDbPage_remoteDatabases => 'Bases de dades remotes';

  @override
  String get remoteDbPage_delete => 'Suprimir';

  @override
  String get remoteDbPage_areYouSureDeleteDatabase => 'Suprimir la configuració de la base de dades?';

  @override
  String get remoteDbPage_edit => 'Editar';

  @override
  String get remoteDbPage_table => 'taula';

  @override
  String get remoteDbPage_user => 'usuari';

  @override
  String get remoteDbPage_loadInMap => 'Carregar al mapa.';

  @override
  String get remoteDbPage_databaseParameters => 'Paràmetres de la base de dades';

  @override
  String get remoteDbPage_cancel => 'Cancel·lar';

  @override
  String get remoteDbPage_ok => 'D\'acord';

  @override
  String get remoteDbPage_theUrlNeedsToBeDefined => 'S\'ha de definir l\'URL (postgis:host:port/databasename)';

  @override
  String get remoteDbPage_theUserNeedsToBeDefined => 'S\'ha de definir un usuari.';

  @override
  String get remoteDbPage_password => 'contrasenya';

  @override
  String get remoteDbPage_thePasswordNeedsToBeDefined => 'S\'ha de definir una contrasenya.';

  @override
  String get remoteDbPage_loadingTables => 'Carregant taules…';

  @override
  String get remoteDbPage_theTableNeedsToBeDefined => 'S\'ha de definir el nom de la taula.';

  @override
  String get remoteDbPage_unableToConnectToDatabase => 'No es pot connectar a la base de dades. Comproveu els paràmetres i la xarxa.';

  @override
  String get remoteDbPage_optionalWhereCondition => 'condició opcional \"where\"';

  @override
  String get geoImage_tiffProperties => 'Propietats TIFF';

  @override
  String get geoImage_opacity => 'Opacitat';

  @override
  String get geoImage_colorToHide => 'Color per amagar';

  @override
  String get gpx_gpxProperties => 'Propietats GPX';

  @override
  String get gpx_wayPoints => 'Punts de pas';

  @override
  String get gpx_color => 'Color';

  @override
  String get gpx_size => 'Mida';

  @override
  String get gpx_viewLabelsIfAvailable => 'Veure les etiquetes si estan disponibles?';

  @override
  String get gpx_tracksRoutes => 'Traces/rutes';

  @override
  String get gpx_width => 'Amplada';

  @override
  String get gpx_palette => 'Paleta';

  @override
  String get tiles_tileProperties => 'Propietats de tessel·la';

  @override
  String get tiles_opacity => 'Opacitat';

  @override
  String get tiles_loadGeoPackageAsOverlay => 'Carregueu les tessel·les del Geopackage com a imatge de superposició en lloc de la capa de mosaic (el millor per a dades generades amb GDAL i diferents projeccions).';

  @override
  String get tiles_colorToHide => 'Color per amagar';

  @override
  String get wms_wmsProperties => 'Propietats WMS';

  @override
  String get wms_opacity => 'Opacitat';

  @override
  String get featureAttributesViewer_loadingData => 'Carregant dades…';

  @override
  String get featureAttributesViewer_setNewValue => 'Definiu nou valor';

  @override
  String get featureAttributesViewer_field => 'Camp';

  @override
  String get featureAttributesViewer_value => 'VALOR';

  @override
  String get projectsView_projectsView => 'Vista de projectes';

  @override
  String get projectsView_openExistingProject => 'Obre un projecte existent';

  @override
  String get projectsView_createNewProject => 'Crea un projecte nou';

  @override
  String get projectsView_recentProjects => 'Projectes recents';

  @override
  String get projectsView_newProject => 'Projecte nou';

  @override
  String get projectsView_enterNameForNewProject => 'Introduïu un nom per al nou projecte o accepteu la proposta.';

  @override
  String get dataLoader_note => 'nota';

  @override
  String get dataLoader_Note => 'Nota';

  @override
  String get dataLoader_hasForm => 'Té formulari';

  @override
  String get dataLoader_POI => 'POI';

  @override
  String get dataLoader_savingImageToDB => 'S\'està desant la imatge a la base de dades…';

  @override
  String get dataLoader_removeNote => 'Elimina la nota';

  @override
  String get dataLoader_areYouSureRemoveNote => 'Voleu eliminar la nota?';

  @override
  String get dataLoader_image => 'Imatge';

  @override
  String get dataLoader_longitude => 'Longitud';

  @override
  String get dataLoader_latitude => 'Latitud';

  @override
  String get dataLoader_altitude => 'Altitud';

  @override
  String get dataLoader_timestamp => 'Marca de temps';

  @override
  String get dataLoader_removeImage => 'Elimina la imatge';

  @override
  String get dataLoader_areYouSureRemoveImage => 'Voleu eliminar la imatge?';

  @override
  String get images_loadingImage => 'S\'està carregant la imatge…';

  @override
  String get about_loadingInformation => 'S\'està carregant la informació…';

  @override
  String get about_ABOUT => 'Sobre · ';

  @override
  String get about_smartMobileAppForSurveyor => 'Aplicació mòbil intel·ligent per a la felicitat del topògraf';

  @override
  String get about_applicationVersion => 'Versió';

  @override
  String get about_license => 'Llicència';

  @override
  String get about_isAvailableUnderGPL3 => ' · és un programari lliure copyleft, amb llicència GPLv3+.';

  @override
  String get about_sourceCode => 'Codi font';

  @override
  String get about_tapHereToVisitRepo => 'Toqueu aquí per visitar el dipòsit de codi font';

  @override
  String get about_legalInformation => 'Informació legal';

  @override
  String get about_copyright2020HydroloGIS => 'Copyright © 2020, HydroloGIS S.r.l. - alguns drets reservats. Toqueu per visitar-nos.';

  @override
  String get about_supportedBy => 'Recolzat per';

  @override
  String get about_partiallySupportedByUniversityTrento => 'Amb el suport parcial del projecte Steep Stream de la Universitat de Trento.';

  @override
  String get about_privacyPolicy => 'Política de privacitat';

  @override
  String get about_tapHereToSeePrivacyPolicy => 'Toqueu aquí per veure la política de privadesa que cobreix les dades d\'usuari i d\'ubicació.';

  @override
  String get gpsInfoButton_noGpsInfoAvailable => 'No hi ha informació disponibel del GPS…';

  @override
  String get gpsInfoButton_timestamp => 'Marca de temps';

  @override
  String get gpsInfoButton_speed => 'Velocitat';

  @override
  String get gpsInfoButton_heading => 'Rumb';

  @override
  String get gpsInfoButton_accuracy => 'Precisió';

  @override
  String get gpsInfoButton_altitude => 'Altitud';

  @override
  String get gpsInfoButton_latitude => 'Latitud';

  @override
  String get gpsInfoButton_copyLatitudeToClipboard => 'Copia latitud al porta-retalls.';

  @override
  String get gpsInfoButton_longitude => 'Longitud';

  @override
  String get gpsInfoButton_copyLongitudeToClipboard => 'Copia longitud al porta-retalls.';

  @override
  String get gpsLogButton_stopLogging => 'Aturar el registre?';

  @override
  String get gpsLogButton_stopLoggingAndCloseLog => 'Aturar el registre i tancar el registre GPS actual?';

  @override
  String get gpsLogButton_newLog => 'Nou registre';

  @override
  String get gpsLogButton_enterNameForNewLog => 'Introduïu un nom per al registre nou';

  @override
  String get gpsLogButton_couldNotStartLogging => 'No s\'ha pogut iniciar el registre: · ';

  @override
  String get imageWidgets_loadingImage => 'S\'està carregant la imatge…';

  @override
  String get logList_gpsLogsList => 'Llista de registres GPS';

  @override
  String get logList_selectAll => 'Seleccionar-ho tot';

  @override
  String get logList_unSelectAll => 'No seleccionar res';

  @override
  String get logList_invertSelection => 'Capgirar la selecció';

  @override
  String get logList_mergeSelected => 'Fusionar la selecció';

  @override
  String get logList_loadingLogs => 'S\'estan carregant els registres…';

  @override
  String get logList_zoomTo => 'Zoom a';

  @override
  String get logList_properties => 'Propietats';

  @override
  String get logList_profileView => 'Vista de perfil';

  @override
  String get logList_toGPX => 'A GPX';

  @override
  String get logList_gpsSavedInExportFolder => 'GPX desat a la carpeta d\'exportació.';

  @override
  String get logList_errorOccurredExportingLogGPX => 'No s\'ha pogut exportar el registre a GPX.';

  @override
  String get logList_delete => 'Suprimeix';

  @override
  String get logList_DELETE => 'Suprimeix';

  @override
  String get logList_areYouSureDeleteTheLog => 'Esborrar el registre?';

  @override
  String get logList_hours => 'hores';

  @override
  String get logList_hour => 'hora';

  @override
  String get logList_minutes => 'minuts';

  @override
  String get logProperties_gpsLogProperties => 'Propietats del registre del GPS';

  @override
  String get logProperties_logName => 'Nom del registre';

  @override
  String get logProperties_start => 'Començar';

  @override
  String get logProperties_end => 'Acabar';

  @override
  String get logProperties_duration => 'Durada';

  @override
  String get logProperties_color => 'Color';

  @override
  String get logProperties_palette => 'Paleta';

  @override
  String get logProperties_width => 'Amplada';

  @override
  String get logProperties_distanceAtPosition => 'Distància a la posició:';

  @override
  String get logProperties_totalDistance => 'Distància total:';

  @override
  String get logProperties_gpsLogView => 'Vista de registre de GPS';

  @override
  String get logProperties_disableStats => 'Desactiva les estadístiques';

  @override
  String get logProperties_enableStats => 'Activa les estadístiques';

  @override
  String get logProperties_totalDuration => 'Durada total:';

  @override
  String get logProperties_timestamp => 'Marca de temps:';

  @override
  String get logProperties_durationAtPosition => 'Durada a la posició:';

  @override
  String get logProperties_speed => 'Velocitat:';

  @override
  String get logProperties_elevation => 'Elevació:';

  @override
  String get noteList_simpleNotesList => 'Llista simple de notes';

  @override
  String get noteList_formNotesList => 'Llista de notes de formulari';

  @override
  String get noteList_loadingNotes => 'S\'està carregant les notes…';

  @override
  String get noteList_zoomTo => 'Zoom a';

  @override
  String get noteList_edit => 'Editar';

  @override
  String get noteList_properties => 'Propietats';

  @override
  String get noteList_delete => 'Suprimeix';

  @override
  String get noteList_DELETE => 'Suprimeix';

  @override
  String get noteList_areYouSureDeleteNote => 'Voleu esborrar la nota?';

  @override
  String get settings_settings => 'Configuració';

  @override
  String get settings_camera => 'Càmera';

  @override
  String get settings_cameraResolution => 'Resolució de la càmera';

  @override
  String get settings_resolution => 'Resolució';

  @override
  String get settings_theCameraResolution => 'La resolució de la càmera';

  @override
  String get settings_screen => 'Pantalla';

  @override
  String get settings_screenScaleBarIconSize => 'Mides de la pantalla, la barra d\'escala i la icona';

  @override
  String get settings_keepScreenOn => 'Mantenir la pantalla encesa';

  @override
  String get settings_retinaScreenMode => 'Mode de pantalla HiDPI';

  @override
  String get settings_toApplySettingEnterExitLayerView => 'Entreu i sortiu de la vista de capa per aplicar aquesta configuració.';

  @override
  String get settings_colorPickerToUse => 'Selector de colors per utilitzar';

  @override
  String get settings_mapCenterCross => 'Creu de centre de mapa';

  @override
  String get settings_color => 'Color';

  @override
  String get settings_size => 'Mida';

  @override
  String get settings_width => 'Amplada';

  @override
  String get settings_mapToolsIconSize => 'Mida de la icona per a les eines de mapa';

  @override
  String get settings_gps => 'GPS';

  @override
  String get settings_gpsFiltersAndMockLoc => 'Filtres GPS i ubicacions simulades';

  @override
  String get settings_livePreview => 'Vista prèvia en directe';

  @override
  String get settings_noPointAvailableYet => 'Encara no hi ha cap punt disponible.';

  @override
  String get settings_longitudeDeg => 'longitud [deg]';

  @override
  String get settings_latitudeDeg => 'latitud [deg]';

  @override
  String get settings_accuracyM => 'precisió [m]';

  @override
  String get settings_altitudeM => 'altitud [m]';

  @override
  String get settings_headingDeg => 'rumb [deg]';

  @override
  String get settings_speedMS => 'velocitat [m/s]';

  @override
  String get settings_isLogging => 'està registrant?';

  @override
  String get settings_mockLocations => 'simular ubicacions?';

  @override
  String get settings_minDistFilterBlocks => 'Blocs de filtre de distància mínima';

  @override
  String get settings_minDistFilterPasses => 'Passades del filtre de distància mínima';

  @override
  String get settings_minTimeFilterBlocks => 'Blocs de filtre de temps mínim';

  @override
  String get settings_minTimeFilterPasses => 'Passades del filtre de temps mínim';

  @override
  String get settings_hasBeenBlocked => 'S\'ha bloquejat';

  @override
  String get settings_distanceFromPrevM => 'Distància des de l\'anterior [m]';

  @override
  String get settings_timeFromPrevS => 'Temps des de l\'anterior [s]';

  @override
  String get settings_locationInfo => 'Informació d\'ubicació';

  @override
  String get settings_filters => 'Filtres';

  @override
  String get settings_disableFilters => 'Desactiveu els filtres.';

  @override
  String get settings_enableFilters => 'Activeu els filtres.';

  @override
  String get settings_zoomIn => 'Ampliar';

  @override
  String get settings_zoomOut => 'Reduïr';

  @override
  String get settings_activatePointFlow => 'Activa el flux de punts.';

  @override
  String get settings_pausePointsFlow => 'Pausa el flux de punts.';

  @override
  String get settings_visualizePointCount => 'Visualitza el recompte de punts';

  @override
  String get settings_showGpsPointsValidPoints => 'Mostra el recompte de punts GPS per als punts VÀLIDS.';

  @override
  String get settings_showGpsPointsAllPoints => 'Mostra el recompte de punts GPS per a TOTS els punts.';

  @override
  String get settings_logFilters => 'Filtres de registre';

  @override
  String get settings_minDistanceBetween2Points => 'Distància mínima entre 2 punts.';

  @override
  String get settings_minTimespanBetween2Points => 'Interval de temps mínim entre 2 punts.';

  @override
  String get settings_gpsFilter => 'Filtre GPS';

  @override
  String get settings_disable => 'Tancar';

  @override
  String get settings_enable => 'Encendre';

  @override
  String get settings_theUseOfTheGps => 'l\'ús de GPS filtrat.';

  @override
  String get settings_warningThisWillAffectGpsPosition => 'Avís: això afectarà la posició GPS, la inserció de notes, les estadístiques de registre i els gràfics.';

  @override
  String get settings_MockLocations => 'Ubicacions simulades';

  @override
  String get settings_testGpsLogDemoUse => 'proveu el registre del GPS per a ús de demostració.';

  @override
  String get settings_setDurationGpsPointsInMilli => 'Definiu la durada dels punts GPS en mil·lisegons.';

  @override
  String get settings_SETTING => 'Paràmetre';

  @override
  String get settings_setMockedGpsDuration => 'Estableix la durada del GPS simulat';

  @override
  String get settings_theValueHasToBeInt => 'El valor ha de ser un nombre sencer.';

  @override
  String get settings_milliseconds => 'mil·lisegons';

  @override
  String get settings_useGoogleToImproveLoc => 'Utilitzeu els serveis de Google per millorar la ubicació';

  @override
  String get settings_useOfGoogleServicesRestart => 'ús dels serveis de Google (cal reiniciar l\'aplicació).';

  @override
  String get settings_gpsLogsViewMode => 'Mode de visualització de registres del GPS';

  @override
  String get settings_logViewModeForOrigData => 'Mode de visualització de registre de les dades originals.';

  @override
  String get settings_logViewModeFilteredData => 'Mode de visualització de registre per a les dades filtrades.';

  @override
  String get settings_cancel => 'Cancel·lar';

  @override
  String get settings_ok => 'D\'acord';

  @override
  String get settings_notesViewModes => 'Modes de visualització de notes';

  @override
  String get settings_selectNotesViewMode => 'Seleccioneu un mode per veure les notes.';

  @override
  String get settings_mapPlugins => 'Connectors de mapes';

  @override
  String get settings_vectorLayers => 'Capes vector';

  @override
  String get settings_loadingOptionsInfoTool => 'Opcions de càrrega i eina d\'informació';

  @override
  String get settings_dataLoading => 'Càrrega de dades';

  @override
  String get settings_maxNumberFeatures => 'Nombre màxim de funcions.';

  @override
  String get settings_maxNumFeaturesPerLayer => 'Característiques màximes per capa. Traieu i afegiu la capa per aplicar.';

  @override
  String get settings_all => 'totes';

  @override
  String get settings_loadMapArea => 'Carrega l\'àrea del mapa.';

  @override
  String get settings_loadOnlyLastVisibleArea => 'Carregueu només a l\'última àrea del mapa visible. Traieu i torneu a afegir la capa per aplicar-la.';

  @override
  String get settings_infoTool => 'Eina d\'informació';

  @override
  String get settings_tapSizeInfoToolPixels => 'Toqueu la mida de l\'eina d\'informació en píxels.';

  @override
  String get settings_editingTool => 'Eina d\'edició';

  @override
  String get settings_editingDragIconSize => 'Edició de la mida de la icona del gestor d\'arrossegament.';

  @override
  String get settings_editingIntermediateDragIconSize => 'Edició de la mida de la icona del gestor d\'arrossegament intermedi.';

  @override
  String get settings_diagnostics => 'Diagnòstics';

  @override
  String get settings_diagnosticsDebugLog => 'Diagnòstic i registre de depuració';

  @override
  String get settings_openFullDebugLog => 'Obriu el registre de depuració complet';

  @override
  String get settings_debugLogView => 'Vista de registre de depuració';

  @override
  String get settings_viewAllMessages => 'Veure tots els missatges';

  @override
  String get settings_viewOnlyErrorsWarnings => 'Veure només errors i avisos';

  @override
  String get settings_clearDebugLog => 'Esborra el registre de depuració';

  @override
  String get settings_loadingData => 'Carregant dades…';

  @override
  String get settings_device => 'Dispositiu';

  @override
  String get settings_deviceIdentifier => 'Identificador del dispositiu';

  @override
  String get settings_deviceId => 'ID dispositiu';

  @override
  String get settings_overrideDeviceId => 'Anul·la l\'identificador del dispositiu';

  @override
  String get settings_overrideId => 'Anul·la ID';

  @override
  String get settings_pleaseEnterValidPassword => 'Introduïu una contrasenya de servidor vàlida.';

  @override
  String get settings_gss => 'GSS';

  @override
  String get settings_geopaparazziSurveyServer => 'Geopaparazzi Survey Server';

  @override
  String get settings_serverUrl => 'URL del servidor';

  @override
  String get settings_serverUrlStartWithHttp => 'L\'URL del servidor ha de començar per HTTP o HTTPS.';

  @override
  String get settings_serverPassword => 'Contrasenya del servidor';

  @override
  String get settings_allowSelfSignedCert => 'Permet certificats autofirmats';

  @override
  String get toolbarTools_zoomOut => 'Reduïr';

  @override
  String get toolbarTools_zoomIn => 'Ampliar';

  @override
  String get toolbarTools_cancelCurrentEdit => 'Cancel·la l\'edició actual.';

  @override
  String get toolbarTools_saveCurrentEdit => 'Desa l\'edició actual.';

  @override
  String get toolbarTools_insertPointMapCenter => 'Afegeix un punt al centre del mapa.';

  @override
  String get toolbarTools_insertPointGpsPos => 'Afegeix un punt a la posició GPS.';

  @override
  String get toolbarTools_removeSelectedFeature => 'Elimina la funció seleccionada.';

  @override
  String get toolbarTools_showFeatureAttributes => 'Mostra els atributs de les característiques.';

  @override
  String get toolbarTools_featureDoesNotHavePrimaryKey => 'La funció no té una clau primària. No se\'n permet l\'edició.';

  @override
  String get toolbarTools_queryFeaturesVectorLayers => 'Consulta característiques de capes vectorials carregades.';

  @override
  String get toolbarTools_measureDistanceWithFinger => 'Mesureu distàncies al mapa amb el dit.';

  @override
  String get toolbarTools_modifyGeomVectorLayers => 'Modificar la geometria de les capes vectorials editables.';

  @override
  String get coachMarks_singleTap => 'Toc simple: · ';

  @override
  String get coachMarks_longTap => 'Toc llarg: · ';

  @override
  String get coachMarks_doubleTap => 'Doble toc: · ';

  @override
  String get coachMarks_simpleNoteButton => 'Botó de notes simples';

  @override
  String get coachMarks_addNewNote => 'afegir una nota nova';

  @override
  String get coachMarks_viewNotesList => 'veure la llista de notes';

  @override
  String get coachMarks_viewNotesSettings => 'veure la configuració de les notes';

  @override
  String get coachMarks_formNotesButton => 'Botó de notes del formulari';

  @override
  String get coachMarks_addNewFormNote => 'afegir una nova nota de formulari';

  @override
  String get coachMarks_viewFormNoteList => 'veure la llista de notes del formulari';

  @override
  String get coachMarks_gpsLogButton => 'Botó de registre del GPS';

  @override
  String get coachMarks_startStopLogging => 'iniciar/aturar el registre';

  @override
  String get coachMarks_viewLogsList => 'veure la llista de registres';

  @override
  String get coachMarks_viewLogsSettings => 'veure la configuració del registre';

  @override
  String get coachMarks_gpsInfoButton => 'Botó d\'informació del GPS (si s\'escau)';

  @override
  String get coachMarks_centerMapOnGpsPos => 'centra el mapa a la posició GPS';

  @override
  String get coachMarks_showGpsInfo => 'mostra la informació GPS';

  @override
  String get coachMarks_toggleAutoCenterGps => 'commuta el centrat automàtic al GPS';

  @override
  String get coachMarks_layersViewButton => 'Botó de visualització de capes';

  @override
  String get coachMarks_openLayersView => 'Obriu la vista de capes';

  @override
  String get coachMarks_openLayersPluginDialog => 'Obriu el diàleg de complements de capa';

  @override
  String get coachMarks_zoomInButton => 'Botó d\'ampliar';

  @override
  String get coachMarks_zoomImMapOneLevel => 'Amplieu el mapa un nivell';

  @override
  String get coachMarks_zoomOutButton => 'Botó de reduïr';

  @override
  String get coachMarks_zoomOutMapOneLevel => 'Reduïr el mapa un nivell';

  @override
  String get coachMarks_bottomToolsButton => 'Botó d\'eines inferior';

  @override
  String get coachMarks_toggleBottomToolsBar => 'Commuta la barra d\'eines inferior';

  @override
  String get coachMarks_toolsButton => 'Botó d\'eines';

  @override
  String get coachMarks_openEndDrawerToAccessProject => 'Obriu el calaix final per accedir a la informació del projecte i a les opcions per compartir, així com a complements de mapes, eines de funcions i extres';

  @override
  String get coachMarks_interactiveCoackMarksButton => 'Botó interactiu de marques guia';

  @override
  String get coachMarks_openInteractiveCoachMarks => 'Obriu les marques guia interactives que expliquen totes les accions de la vista del mapa principal.';

  @override
  String get coachMarks_mainMenuButton => 'Botó del menú principal';

  @override
  String get coachMarks_openDrawerToLoadProject => 'Obriu el calaix per carregar o crear un projecte, importar i exportar dades, sincronitzar amb servidors, accedir a la configuració i sortir de l\'aplicació/apagar el GPS.';

  @override
  String get coachMarks_skip => 'Omet';

  @override
  String get network_cancelledByUser => 'Cancel·lat per l\'usuari.';

  @override
  String get network_completed => 'Fet.';

  @override
  String get network_buildingBaseCachePerformance => 'Preparant la memòria cau bàsica per millorar el rendiment (pot trigar una estona)…';

  @override
  String get network_thisFIleAlreadyBeingDownloaded => 'Aquest fitxer ja s\'està baixant.';

  @override
  String get network_download => 'Descarregar';

  @override
  String get network_downloadFile => 'Descarregar arxiu';

  @override
  String get network_toTheDeviceTakeTime => 'al dispositiu? Pot trigar una estona.';

  @override
  String get network_availableMaps => 'Mapes disponibles';

  @override
  String get network_searchMapByName => 'Cerca el mapa per nom';

  @override
  String get network_uploading => 'Pujant…';

  @override
  String get network_pleaseWait => 'si us plau, espereu…';

  @override
  String get network_permissionOnServerDenied => 'S\'ha denegat el permís al servidor.';

  @override
  String get network_couldNotConnectToServer => 'No s\'ha pogut connectar amb el servidor. Està en línia? Comproveu la vostra adreça.';

  @override
  String get form_smash_cantSaveImageDb => 'No s\'ha pogut desar la imatge a la base de dades.';

  @override
  String get formbuilder => 'Constructor de formularis';

  @override
  String get layersView_selectGssLayers => 'Seleccioneu capes GSS';

  @override
  String get layersView_noGssLayersFound => 'No s\'han trobat capes GSS.';

  @override
  String get layersView_noGssLayersAvailable => 'No hi ha capes disponibles (no es mostren les ja carregades).';

  @override
  String get layersView_selectGssLayersToLoad => 'Seleccioneu les capes GSS per carregar.';

  @override
  String get layersView_unableToLoadGssLayers => 'No es pot carregar:';

  @override
  String get layersView_layerExists => 'La capa existeix';

  @override
  String get layersView_layerAlreadyExists => 'La capa ja existeix, la voleu sobreescriure?';

  @override
  String get gss_layerview_upload_changes => 'Pugeu els canvis';

  @override
  String get allGpsPointsCount => 'Punts GPS';

  @override
  String get filteredGpsPointsCount => 'Punts filtrats';

  @override
  String get addTmsFromDefaults => 'Afegeix TMS des dels valors predeterminats';

  @override
  String get form_smash_noCameraDesktop => 'No hi ha cap opció de càmera disponible a l\'escriptori.';

  @override
  String get settings_BottombarCustomization => 'Personalització de la barra inferior';

  @override
  String get settings_Bottombar_showAddNote => 'Mostra el botó AFEGEIX UNA NOTA';

  @override
  String get settings_Bottombar_showAddFormNote => 'Mostra el botó AFEGEIX UNA NOTA DE FORMULARI';

  @override
  String get settings_Bottombar_showAddGpsLog => 'Mostra el botó AFEGIR REGISTRE GPS';

  @override
  String get settings_Bottombar_showGpsButton => 'Mostra el botó del GPS';

  @override
  String get settings_Bottombar_showLayers => 'Mostra el botó de capes';

  @override
  String get settings_Bottombar_showZoom => 'Mostra els botons de zoom';

  @override
  String get settings_Bottombar_showEditing => 'Mostra el botó d\'edició';

  @override
  String get gss_layerview_filter => 'Filtre';
}
