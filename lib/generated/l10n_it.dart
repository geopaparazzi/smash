import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class SLIt extends SL {
  SLIt([String locale = 'it']) : super(locale);

  @override
  String get main_welcome => 'Benvenuto in SMASH!';

  @override
  String get main_check_location_permission => 'Controllo permessi geolocalizzazione…';

  @override
  String get main_location_permission_granted => 'Permesso geolocalizzazione concesso.';

  @override
  String get main_checkingStoragePermission => 'Controllo permesso spazio archiviazione…';

  @override
  String get main_storagePermissionGranted => 'Permesso spazio archiviazione concesso.';

  @override
  String get main_loadingPreferences => 'Caricamento preferenze…';

  @override
  String get main_preferencesLoaded => 'Preferenze caricate.';

  @override
  String get main_loadingWorkspace => 'Caricamento spazio di lavoro…';

  @override
  String get main_workspaceLoaded => 'Spazio di lavoro caricato.';

  @override
  String get main_loadingTagsList => 'Caricamento lista delle etichette…';

  @override
  String get main_tagsListLoaded => 'Lista delle etichette caricata.';

  @override
  String get main_loadingKnownProjections => 'Caricamento proiezioni note…';

  @override
  String get main_knownProjectionsLoaded => 'Proiezioni note caricate.';

  @override
  String get main_loadingFences => 'Caricamento recinti virtuali…';

  @override
  String get main_fencesLoaded => 'Recinti virtuali caricati.';

  @override
  String get main_loadingLayersList => 'Caricamento lista layers…';

  @override
  String get main_layersListLoaded => 'Lista layers caricati.';

  @override
  String get main_locationBackgroundWarning => 'Concedere l\'autorizzazione al passo successivo per permettere la registrazione della posizione in background (in caso contrario la registrazione avviene solo quando l\'applicazione è in primo piano).\nNessun dato verrà condiviso, ma esclusivamente salvato localmente sul dispositivo.';

  @override
  String get main_StorageIsInternalWarning => 'Si prega di leggere attentamente:\nIn ambiente Android 11 e successivi la cartella dei progetti (/project) deve essere posizionata nella cartella:\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\ndel proprio spazio di archiviazione per poter essere utilizzata correttamente.\nSe l\'app viene disinstallata il sistema rimuoverà tale cartella, quindi, se lo fate, eseguite prima una copia dei vostri dati per non perderli.\n\nSi sta studiando una soluzione migliore per evitare questo problema.';

  @override
  String get main_locationPermissionIsMandatoryToOpenSmash => 'Il permesso di geolocalizzazzione è obbligatorio per utilizzare SMASH.';

  @override
  String get main_storagePermissionIsMandatoryToOpenSmash => 'Il permesso di archiviazione è obbligatorio per utilizzare SMASH.';

  @override
  String get main_anErrorOccurredTapToView => 'È avvenuto un errore. Tocca per informazioni.';

  @override
  String get mainView_loadingData => 'Caricamento dati…';

  @override
  String get mainView_turnGpsOn => 'Attiva GPS';

  @override
  String get mainView_turnGpsOff => 'Spegni GPS';

  @override
  String get mainView_exit => 'Esci';

  @override
  String get mainView_areYouSureCloseTheProject => 'Chiudi il progetto?';

  @override
  String get mainView_activeOperationsWillBeStopped => 'Le operazioni attive verranno terminate.';

  @override
  String get mainView_showInteractiveCoachMarks => 'Mostra guida interattiva.';

  @override
  String get mainView_openToolsDrawer => 'Apri il cassetto strumenti.';

  @override
  String get mainView_zoomIn => 'Ingrandisci';

  @override
  String get mainView_zoomOut => 'Rimpicciolisci';

  @override
  String get mainView_formNotes => 'Note complesse';

  @override
  String get mainView_simpleNotes => 'Note semplici';

  @override
  String get mainviewUtils_projects => 'Progetti';

  @override
  String get mainviewUtils_import => 'Importa';

  @override
  String get mainviewUtils_export => 'Esporta';

  @override
  String get mainviewUtils_settings => 'Impostazioni';

  @override
  String get mainviewUtils_onlineHelp => 'Aiuto in linea';

  @override
  String get mainviewUtils_about => 'Informazioni';

  @override
  String get mainviewUtils_projectInfo => 'Informazioni progetto';

  @override
  String get mainviewUtils_projectStats => 'Project Stats';

  @override
  String get mainviewUtils_project => 'Progetto';

  @override
  String get mainviewUtils_database => 'Database';

  @override
  String get mainviewUtils_extras => 'Funzioni Aggiuntive';

  @override
  String get mainviewUtils_availableIcons => 'Icone disponibili';

  @override
  String get mainviewUtils_offlineMaps => 'Mappe offline';

  @override
  String get mainviewUtils_positionTools => 'Strumenti di posizione';

  @override
  String get mainviewUtils_goTo => 'Vai a';

  @override
  String get mainviewUtils_goToCoordinate => 'Vai a coordinata';

  @override
  String get mainviewUtils_enterLonLat => 'Inserisci longitudine e latitudine';

  @override
  String get mainviewUtils_goToCoordinateWrongFormat => 'Formato non supportato. Formato richiesto: 11.18463, 46.12345';

  @override
  String get mainviewUtils_goToCoordinateEmpty => 'Non può essere vuoto.';

  @override
  String get mainviewUtils_sharePosition => 'Condividi la posizione';

  @override
  String get mainviewUtils_rotateMapWithGps => 'Ruota la mappa con il GPS';

  @override
  String get exportWidget_export => 'Esporta';

  @override
  String get exportWidget_pdfExported => 'PDF esportato';

  @override
  String get exportWidget_exportToPortableDocumentFormat => 'Esporta il progetto in Portable Document Format (PDF)';

  @override
  String get exportWidget_gpxExported => 'GPX esportato';

  @override
  String get exportWidget_exportToGpx => 'Esporta il progetto in GPS Exchange Format (GPX)';

  @override
  String get exportWidget_kmlExported => 'KML esportato';

  @override
  String get exportWidget_exportToKml => 'Esporta il progetto in Keyhole Markup Language (KML)';

  @override
  String get exportWidget_imagesToFolderExported => 'Immagini esportate';

  @override
  String get exportWidget_exportImagesToFolder => 'Esporta immagini del progetto nella cartella';

  @override
  String get exportWidget_exportImagesToFolderTitle => 'Immagini';

  @override
  String get exportWidget_geopackageExported => 'GeoPackage esportato';

  @override
  String get exportWidget_exportToGeopackage => 'Esporta il progetto in GeoPackage (GPKG)';

  @override
  String get exportWidget_exportToGSS => 'Esporta su Geopaparazzi Survey Server (GSS)';

  @override
  String get gssExport_gssExport => 'Esporta su GSS';

  @override
  String get gssExport_setProjectDirty => 'Imposta progetto a DIRTY?';

  @override
  String get gssExport_thisCantBeUndone => 'Questa azione non può essere annullata!';

  @override
  String get gssExport_restoreProjectAsDirty => 'Ripristina progetto come tutto \'dirty\'.';

  @override
  String get gssExport_setProjectClean => 'Imposta progetto a CLEAN?';

  @override
  String get gssExport_restoreProjectAsClean => 'Ripristina progetto come tutto \'clean\'.';

  @override
  String get gssExport_nothingToSync => 'Nulla da sincronizzare.';

  @override
  String get gssExport_collectingSyncStats => 'Recupero delle statistiche di sincronizzazione…';

  @override
  String get gssExport_unableToSyncDueToError => 'Sincronizzazione fallita a causa di un errore, controllare la diagnostica.';

  @override
  String get gssExport_noGssUrlSet => 'Non è stato impostato nessun URL per il server GSS. Verificare le impostazioni.';

  @override
  String get gssExport_noGssPasswordSet => 'Non è stata impostata nessuna password per il server GSS. Verificare le impostazioni.';

  @override
  String get gssExport_synStats => 'Statistiche di sincronizzazione';

  @override
  String get gssExport_followingDataWillBeUploaded => 'I seguenti dati verranno caricati nel corso della sincronizzazione.';

  @override
  String get gssExport_gpsLogs => 'Registrazioni GPS:';

  @override
  String get gssExport_simpleNotes => 'Note semplici:';

  @override
  String get gssExport_formNotes => 'Note complesse:';

  @override
  String get gssExport_images => 'Immagini:';

  @override
  String get gssExport_shouldNotHappen => 'Ciò non avrebbe dovuto succedere';

  @override
  String get gssExport_upload => 'Carica';

  @override
  String get geocoding_geocoding => 'Geocodifica';

  @override
  String get geocoding_nothingToLookFor => 'Nulla da ricercare. Inserire un indirizzo.';

  @override
  String get geocoding_launchGeocoding => 'Lancia il servizio di geocodifica';

  @override
  String get geocoding_searching => 'Ricerca in corso…';

  @override
  String get gps_smashIsActive => 'SMASH è attivo';

  @override
  String get gps_smashIsLogging => 'SMASH sta registrando';

  @override
  String get gps_locationTracking => 'Tracciamento posizione';

  @override
  String get gps_smashLocServiceIsActive => 'Il servizio di localizzazione di SMASH è attivo.';

  @override
  String get gps_backgroundLocIsOnToKeepRegistering => 'La localizzazione in background è attiva in modo che l\'app possa continuare a registrare la posizione anche quando l\'app è in background.';

  @override
  String get gssImport_gssImport => 'Importa da GSS';

  @override
  String get gssImport_downloadingDataList => 'Scaricamento della lista dati…';

  @override
  String get gssImport_unableDownloadDataList => 'Impossibile scaricare la lista dati a causa di un errore. Verificare le impostazioni ed il registro.';

  @override
  String get gssImport_noGssUrlSet => 'Non è stato impostato nessun URL per il server GSS. Verificare le impostazioni.';

  @override
  String get gssImport_noGssPasswordSet => 'Non è stata impostata nessuna password per il server GSS. Verificare le impostazioni.';

  @override
  String get gssImport_noPermToAccessServer => 'Nessun permesso per l\'accesso al server. Verificare le credenziali.';

  @override
  String get gssImport_data => 'Dati';

  @override
  String get gssImport_dataSetsDownloadedMapsFolder => 'I set di dati sono scaricati nella cartella maps.';

  @override
  String get gssImport_noDataAvailable => 'Nessun dato disponibile.';

  @override
  String get gssImport_projects => 'Progetti';

  @override
  String get gssImport_projectsDownloadedProjectFolder => 'I progetti sono scaricati nella cartella dei progetti.';

  @override
  String get gssImport_noProjectsAvailable => 'Nessun progetto disponibile.';

  @override
  String get gssImport_forms => 'Moduli';

  @override
  String get gssImport_tagsDownloadedFormsFolder => 'I files delle etichette sono scaricati nella cartella forms.';

  @override
  String get gssImport_noTagsAvailable => 'Nessuna etichetta disponibile.';

  @override
  String get importWidget_import => 'Importa';

  @override
  String get importWidget_importFromGeopaparazzi => 'Importa da GSS (Geopaparazzi Survey Server)';

  @override
  String get layersView_layerList => 'Lista layers';

  @override
  String get layersView_loadRemoteDatabase => 'Carica database remoto';

  @override
  String get layersView_loadOnlineSources => 'Carica sorgenti dati online';

  @override
  String get layersView_loadLocalDatasets => 'Carica set di dati locali';

  @override
  String get layersView_loading => 'Caricamento…';

  @override
  String get layersView_zoomTo => 'Zoom a';

  @override
  String get layersView_properties => 'Proprietà';

  @override
  String get layersView_delete => 'Elimina';

  @override
  String get layersView_projCouldNotBeRecognized => 'La proiezione (proj) non è stata riconosciuta. Tocca per inserire il codice EPSG manualmente.';

  @override
  String get layersView_projNotSupported => 'La proiezione (proj) non è supportata. Tocca per risolvere.';

  @override
  String get layersView_onlyImageFilesWithWorldDef => 'Sono supportati solo files immagine con definizione world file.';

  @override
  String get layersView_onlyImageFileWithPrjDef => 'Sono supportati solo files immagine con definizione del sistema di riferimento.';

  @override
  String get layersView_selectTableToLoad => 'Seleziona la tabella da caricare.';

  @override
  String get layersView_fileFormatNotSUpported => 'Formato file non supportato.';

  @override
  String get onlineSourcesPage_onlineSourcesCatalog => 'Catalogo Risorse Online';

  @override
  String get onlineSourcesPage_loadingTmsLayers => 'Caricamento layers TMS…';

  @override
  String get onlineSourcesPage_loadingWmsLayers => 'Caricamento layers WMS…';

  @override
  String get onlineSourcesPage_importFromFile => 'Importa da file';

  @override
  String get onlineSourcesPage_theFile => 'Il file';

  @override
  String get onlineSourcesPage_doesntExist => 'non esiste';

  @override
  String get onlineSourcesPage_onlineSourcesImported => 'Sorgenti online importate.';

  @override
  String get onlineSourcesPage_exportToFile => 'Esporta in file';

  @override
  String get onlineSourcesPage_exportedTo => 'Esportato in:';

  @override
  String get onlineSourcesPage_delete => 'Elimina';

  @override
  String get onlineSourcesPage_addToLayers => 'Aggiungi ai layers';

  @override
  String get onlineSourcesPage_setNameTmsService => 'Assegnare un nome al servizio TMS';

  @override
  String get onlineSourcesPage_enterName => 'inserire nome';

  @override
  String get onlineSourcesPage_pleaseEnterValidName => 'Si prega di inserire un nome valido';

  @override
  String get onlineSourcesPage_insertUrlOfService => 'Inserire l\'URL del servizio.';

  @override
  String get onlineSourcesPage_placeXyzBetBrackets => 'Mettere le x, y, z tra parentesi graffe.';

  @override
  String get onlineSourcesPage_pleaseEnterValidTmsUrl => 'Si prega di inserire un URL TMS valido';

  @override
  String get onlineSourcesPage_enterUrl => 'inserire URL';

  @override
  String get onlineSourcesPage_enterSubDomains => 'inserire sottodomini';

  @override
  String get onlineSourcesPage_addAttribution => 'Aggiungi un\'attribuzione.';

  @override
  String get onlineSourcesPage_enterAttribution => 'inserire attribuzione';

  @override
  String get onlineSourcesPage_setMinMaxZoom => 'Definire i livelli di zoom minimo e massimo.';

  @override
  String get onlineSourcesPage_minZoom => 'Zoom min';

  @override
  String get onlineSourcesPage_maxZoom => 'Zoom max';

  @override
  String get onlineSourcesPage_pleaseCheckYourData => 'Si prega di verificare i dati inseriti';

  @override
  String get onlineSourcesPage_details => 'Dettagli';

  @override
  String get onlineSourcesPage_name => 'Nome: ';

  @override
  String get onlineSourcesPage_subDomains => 'Sottodomini: ';

  @override
  String get onlineSourcesPage_attribution => 'Attribuzione: ';

  @override
  String get onlineSourcesPage_cancel => 'Annulla';

  @override
  String get onlineSourcesPage_ok => 'OK';

  @override
  String get onlineSourcesPage_newTmsOnlineService => 'Nuovo servizio TMS';

  @override
  String get onlineSourcesPage_save => 'Salva';

  @override
  String get onlineSourcesPage_theBaseUrlWithQuestionMark => 'L\'URL di base deve finire con « ? ».';

  @override
  String get onlineSourcesPage_pleaseEnterValidWmsUrl => 'Si prega di inserire un URL WMS valido';

  @override
  String get onlineSourcesPage_setWmsLayerName => 'Impostare il nome del layer WMS';

  @override
  String get onlineSourcesPage_enterLayerToLoad => 'inserire il layer da caricare';

  @override
  String get onlineSourcesPage_pleaseEnterValidLayer => 'Si prega di inserire un layer valido';

  @override
  String get onlineSourcesPage_setWmsImageFormat => 'Impostare il formato immagine del WMS';

  @override
  String get onlineSourcesPage_addAnAttribution => 'Aggiungi un\'attribuzione.';

  @override
  String get onlineSourcesPage_layer => 'Piano: ';

  @override
  String get onlineSourcesPage_url => 'URL: ';

  @override
  String get onlineSourcesPage_format => 'Formato';

  @override
  String get onlineSourcesPage_newWmsOnlineService => 'Nuovo servizio WMS';

  @override
  String get remoteDbPage_remoteDatabases => 'Database remoti';

  @override
  String get remoteDbPage_delete => 'Elimina';

  @override
  String get remoteDbPage_areYouSureDeleteDatabase => 'Elimina la configurazione del database?';

  @override
  String get remoteDbPage_edit => 'Modifica';

  @override
  String get remoteDbPage_table => 'tabella';

  @override
  String get remoteDbPage_user => 'utente';

  @override
  String get remoteDbPage_loadInMap => 'Carica nella mappa.';

  @override
  String get remoteDbPage_databaseParameters => 'Parametri del database';

  @override
  String get remoteDbPage_cancel => 'Annulla';

  @override
  String get remoteDbPage_ok => 'OK';

  @override
  String get remoteDbPage_theUrlNeedsToBeDefined => 'L\'URL deve essere definito (postgis:host:port/databasename)';

  @override
  String get remoteDbPage_theUserNeedsToBeDefined => 'Deve essere definito un utente.';

  @override
  String get remoteDbPage_password => 'password';

  @override
  String get remoteDbPage_thePasswordNeedsToBeDefined => 'Deve essere definita una password.';

  @override
  String get remoteDbPage_loadingTables => 'Caricamento tabelle…';

  @override
  String get remoteDbPage_theTableNeedsToBeDefined => 'Deve essere definito il nome della tabella.';

  @override
  String get remoteDbPage_unableToConnectToDatabase => 'Impossibile collegarsi al database. Verificare i parametri e la rete.';

  @override
  String get remoteDbPage_optionalWhereCondition => 'clausola \"where\" opzionale';

  @override
  String get geoImage_tiffProperties => 'Proprietà TIFF';

  @override
  String get geoImage_opacity => 'Opacità';

  @override
  String get geoImage_colorToHide => 'Colore da nascondere';

  @override
  String get gpx_gpxProperties => 'Proprietà GPX';

  @override
  String get gpx_wayPoints => 'Waypoints';

  @override
  String get gpx_color => 'Colore';

  @override
  String get gpx_size => 'Dimensione';

  @override
  String get gpx_viewLabelsIfAvailable => 'Visualizza etichette se disponibili?';

  @override
  String get gpx_tracksRoutes => 'Tracce/rotte';

  @override
  String get gpx_width => 'Larghezza';

  @override
  String get gpx_palette => 'Tavolozza';

  @override
  String get tiles_tileProperties => 'Proprietà Tile';

  @override
  String get tiles_opacity => 'Opacità';

  @override
  String get tiles_loadGeoPackageAsOverlay => 'Carica i tiles del geopackage come immagine sovrapposta invece che come tile layer (opzione migliore per dati generati con gdal e proiezioni diverse).';

  @override
  String get tiles_colorToHide => 'Colore da nascondere';

  @override
  String get wms_wmsProperties => 'Proprietà WMS';

  @override
  String get wms_opacity => 'Opacità';

  @override
  String get featureAttributesViewer_loadingData => 'Caricamento dati…';

  @override
  String get featureAttributesViewer_setNewValue => 'Impostare nuovo valore';

  @override
  String get featureAttributesViewer_field => 'Campo';

  @override
  String get featureAttributesViewer_value => 'VALORE';

  @override
  String get projectsView_projectsView => 'Vista progetti';

  @override
  String get projectsView_openExistingProject => 'Apri un progetto esistente';

  @override
  String get projectsView_createNewProject => 'Crea un nuovo progetto';

  @override
  String get projectsView_recentProjects => 'Progetti recenti';

  @override
  String get projectsView_newProject => 'Nuovo progetto';

  @override
  String get projectsView_enterNameForNewProject => 'Inserire un nome per il nuovo progetto o accettare quello proposto.';

  @override
  String get dataLoader_note => 'nota';

  @override
  String get dataLoader_Note => 'Nota';

  @override
  String get dataLoader_hasForm => 'Ha Modulo';

  @override
  String get dataLoader_POI => 'POI';

  @override
  String get dataLoader_savingImageToDB => 'Salvataggio immagine nel database…';

  @override
  String get dataLoader_removeNote => 'Rimuovi Nota';

  @override
  String get dataLoader_areYouSureRemoveNote => 'Rimuovi nota?';

  @override
  String get dataLoader_image => 'Immagine';

  @override
  String get dataLoader_longitude => 'Longitudine';

  @override
  String get dataLoader_latitude => 'Latitudine';

  @override
  String get dataLoader_altitude => 'Altitudine';

  @override
  String get dataLoader_timestamp => 'Marca temporale';

  @override
  String get dataLoader_removeImage => 'Rimuovere Immagine';

  @override
  String get dataLoader_areYouSureRemoveImage => 'Rimuovere l\'immagine?';

  @override
  String get images_loadingImage => 'Caricamento immagine…';

  @override
  String get about_loadingInformation => 'Caricamento informazioni…';

  @override
  String get about_ABOUT => 'Info ';

  @override
  String get about_smartMobileAppForSurveyor => 'Smart Mobile App for Surveyor Happiness (Applicazione mobile per la felicità del rilevatore)';

  @override
  String get about_applicationVersion => 'Versione';

  @override
  String get about_license => 'Licenza';

  @override
  String get about_isAvailableUnderGPL3 => ' è software libero copylefted, licenziato GPLv3+.';

  @override
  String get about_sourceCode => 'Codice Sorgente';

  @override
  String get about_tapHereToVisitRepo => 'Tocca qui per visitare il repository del codice sorgente';

  @override
  String get about_legalInformation => 'Informazioni legali';

  @override
  String get about_copyright2020HydroloGIS => 'Copyright © 2020, HydroloGIS S.r.l. — alcuni diritti riservati. Tocca qui per visitare.';

  @override
  String get about_supportedBy => 'Sostenuto da';

  @override
  String get about_partiallySupportedByUniversityTrento => 'Parzialmente sostenuto dal progetto Steep Stream dell\'Università di Trento.';

  @override
  String get about_privacyPolicy => 'Politica sulla riservatezza';

  @override
  String get about_tapHereToSeePrivacyPolicy => 'Tocca qui per vedere la politica sulla riservatezza che copre l\'utente ed i dati di localizzazione.';

  @override
  String get gpsInfoButton_noGpsInfoAvailable => 'Nessun dato GPS disponibile…';

  @override
  String get gpsInfoButton_timestamp => 'Marca temporale';

  @override
  String get gpsInfoButton_speed => 'Velocità';

  @override
  String get gpsInfoButton_heading => 'Direzione';

  @override
  String get gpsInfoButton_accuracy => 'Precisione';

  @override
  String get gpsInfoButton_altitude => 'Altitudine';

  @override
  String get gpsInfoButton_latitude => 'Latitudine';

  @override
  String get gpsInfoButton_copyLatitudeToClipboard => 'Copia latitudine negli appunti.';

  @override
  String get gpsInfoButton_longitude => 'Longitudine';

  @override
  String get gpsInfoButton_copyLongitudeToClipboard => 'Copia longitudine negli appunti.';

  @override
  String get gpsLogButton_stopLogging => 'Interrompi registrazione?';

  @override
  String get gpsLogButton_stopLoggingAndCloseLog => 'Interrompi la registrazione e chiudi l\'attuale registrazione GPS?';

  @override
  String get gpsLogButton_newLog => 'Nuova registrazione';

  @override
  String get gpsLogButton_enterNameForNewLog => 'Inserire un nome per la nuova registrazione';

  @override
  String get gpsLogButton_couldNotStartLogging => 'Non è stato possibile avviare la registrazione: ';

  @override
  String get imageWidgets_loadingImage => 'Caricamento dell\'immagine…';

  @override
  String get logList_gpsLogsList => 'Lista registrazioni GPS';

  @override
  String get logList_selectAll => 'Seleziona tutto';

  @override
  String get logList_unSelectAll => 'Deseleziona tutto';

  @override
  String get logList_invertSelection => 'Inverti selezione';

  @override
  String get logList_mergeSelected => 'Unisci selezionati';

  @override
  String get logList_loadingLogs => 'Caricamento logs…';

  @override
  String get logList_zoomTo => 'Zoom a';

  @override
  String get logList_properties => 'Proprietà';

  @override
  String get logList_profileView => 'Vista Profilo';

  @override
  String get logList_toGPX => 'A GPX';

  @override
  String get logList_gpsSavedInExportFolder => 'GPX salvato nella cartella export.';

  @override
  String get logList_errorOccurredExportingLogGPX => 'Impossibile esportare la traccia a GPX.';

  @override
  String get logList_delete => 'Elimina';

  @override
  String get logList_DELETE => 'Elimina';

  @override
  String get logList_areYouSureDeleteTheLog => 'Elimina la traccia?';

  @override
  String get logList_hours => 'ore';

  @override
  String get logList_hour => 'ora';

  @override
  String get logList_minutes => 'min';

  @override
  String get logProperties_gpsLogProperties => 'Proprietà Traccia GPS';

  @override
  String get logProperties_logName => 'Nome Traccia';

  @override
  String get logProperties_start => 'Inizio';

  @override
  String get logProperties_end => 'Fine';

  @override
  String get logProperties_duration => 'Durata';

  @override
  String get logProperties_color => 'Colore';

  @override
  String get logProperties_palette => 'Tavolozza';

  @override
  String get logProperties_width => 'Larghezza';

  @override
  String get logProperties_distanceAtPosition => 'Distanza alla posizione:';

  @override
  String get logProperties_totalDistance => 'Distanza totale:';

  @override
  String get logProperties_gpsLogView => 'Vista Traccia GPS';

  @override
  String get logProperties_disableStats => 'Chiudi statistiche';

  @override
  String get logProperties_enableStats => 'Apri statistiche';

  @override
  String get logProperties_totalDuration => 'Durata totale:';

  @override
  String get logProperties_timestamp => 'Marca temporale:';

  @override
  String get logProperties_durationAtPosition => 'Durata alla posizione:';

  @override
  String get logProperties_speed => 'Velocità:';

  @override
  String get logProperties_elevation => 'Quota:';

  @override
  String get noteList_simpleNotesList => 'Lista Note Semplici';

  @override
  String get noteList_formNotesList => 'Lista Note Complesse';

  @override
  String get noteList_loadingNotes => 'Caricamento note…';

  @override
  String get noteList_zoomTo => 'Zoom a';

  @override
  String get noteList_edit => 'Modifica';

  @override
  String get noteList_properties => 'Proprietà';

  @override
  String get noteList_delete => 'Elimina';

  @override
  String get noteList_DELETE => 'Elimina';

  @override
  String get noteList_areYouSureDeleteNote => 'Elimina la nota?';

  @override
  String get settings_settings => 'Impostazioni';

  @override
  String get settings_camera => 'Fotocamera';

  @override
  String get settings_cameraResolution => 'Risoluzione Fotocamera';

  @override
  String get settings_resolution => 'Risoluzione';

  @override
  String get settings_theCameraResolution => 'La risoluzione della fotocamera';

  @override
  String get settings_screen => 'Schermo';

  @override
  String get settings_screenScaleBarIconSize => 'Schermo, barra di scala e dimensioni icone';

  @override
  String get settings_keepScreenOn => 'Mantieni lo schermo acceso';

  @override
  String get settings_retinaScreenMode => 'Modalità schermo HiDPI';

  @override
  String get settings_toApplySettingEnterExitLayerView => 'Per applicare questa impostazione entrare ed uscire dalla vista layer.';

  @override
  String get settings_colorPickerToUse => 'Selettore colore da utilizzare';

  @override
  String get settings_mapCenterCross => 'Croce Centro Mappa';

  @override
  String get settings_color => 'Colore';

  @override
  String get settings_size => 'Dimensione';

  @override
  String get settings_width => 'Spessore';

  @override
  String get settings_mapToolsIconSize => 'Dimensione Icone Strumenti Mappa';

  @override
  String get settings_gps => 'GPS';

  @override
  String get settings_gpsFiltersAndMockLoc => 'Filtri GPS e posizioni fittizie';

  @override
  String get settings_livePreview => 'Anteprima';

  @override
  String get settings_noPointAvailableYet => 'Nessun punto ancora disponibile.';

  @override
  String get settings_longitudeDeg => 'longitudine [°]';

  @override
  String get settings_latitudeDeg => 'latitudine [°]';

  @override
  String get settings_accuracyM => 'precisione [m]';

  @override
  String get settings_altitudeM => 'altitudine [m]';

  @override
  String get settings_headingDeg => 'direzione [°]';

  @override
  String get settings_speedMS => 'velocità [m/s]';

  @override
  String get settings_isLogging => 'sta registrando?';

  @override
  String get settings_mockLocations => 'posizioni fittizie?';

  @override
  String get settings_minDistFilterBlocks => 'Bloccato da filtro su distanza minima';

  @override
  String get settings_minDistFilterPasses => 'Passa filtro su distanza minima';

  @override
  String get settings_minTimeFilterBlocks => 'Bloccato da filtro su intervallo minimo';

  @override
  String get settings_minTimeFilterPasses => 'Passa filtro su intervallo minimo';

  @override
  String get settings_hasBeenBlocked => 'E\' stato bloccato';

  @override
  String get settings_distanceFromPrevM => 'Distanza dal prec [m]';

  @override
  String get settings_timeFromPrevS => 'Tempo dal prec [s]';

  @override
  String get settings_locationInfo => 'Informazioni Posizione';

  @override
  String get settings_filters => 'Filtri';

  @override
  String get settings_disableFilters => 'Disabilita Filtri.';

  @override
  String get settings_enableFilters => 'Abilita Filtri.';

  @override
  String get settings_zoomIn => 'Ingrandisci';

  @override
  String get settings_zoomOut => 'Rimpicciolisci';

  @override
  String get settings_activatePointFlow => 'Attiva flusso puntuale.';

  @override
  String get settings_pausePointsFlow => 'Pausa flusso puntuale.';

  @override
  String get settings_visualizePointCount => 'Visualizza conteggio puntuale';

  @override
  String get settings_showGpsPointsValidPoints => 'Visualizza conteggio punti GPS per i punti VALIDI.';

  @override
  String get settings_showGpsPointsAllPoints => 'Visualizza conteggio punti GPS per TUTTI i punti.';

  @override
  String get settings_logFilters => 'Filtri Registrazione';

  @override
  String get settings_minDistanceBetween2Points => 'Distanza minima tra 2 punti.';

  @override
  String get settings_minTimespanBetween2Points => 'Intervallo di tempo minimo tra 2 punti.';

  @override
  String get settings_gpsFilter => 'Filtro GPS';

  @override
  String get settings_disable => 'Spegni';

  @override
  String get settings_enable => 'Accendi';

  @override
  String get settings_theUseOfTheGps => 'l\'utilizzo di dati GPS filtrati.';

  @override
  String get settings_warningThisWillAffectGpsPosition => 'Attenzione: ciò influenzerà la posizione GPS, l\'inserimento delle note, le statistiche della registrazione ed i grafici.';

  @override
  String get settings_MockLocations => 'Posizioni fittizie';

  @override
  String get settings_testGpsLogDemoUse => 'registro GPS di test a fini dimostrativi.';

  @override
  String get settings_setDurationGpsPointsInMilli => 'Imposta la durata per i punti GPS in millisecondi.';

  @override
  String get settings_SETTING => 'Impostazione';

  @override
  String get settings_setMockedGpsDuration => 'Imposta durata GPS fittizio';

  @override
  String get settings_theValueHasToBeInt => 'Il valore deve essere un numero intero.';

  @override
  String get settings_milliseconds => 'millisecondi';

  @override
  String get settings_useGoogleToImproveLoc => 'Utilizza i servizi Google per migliorare la posizione';

  @override
  String get settings_useOfGoogleServicesRestart => 'Utilizza i servizi Google (richiede riavvio dell\'app).';

  @override
  String get settings_gpsLogsViewMode => 'Modalità vista registrazioni GPS';

  @override
  String get settings_logViewModeForOrigData => 'Modalità vista registrazione dati originali.';

  @override
  String get settings_logViewModeFilteredData => 'Modalità vista registrazione dati filtrati.';

  @override
  String get settings_cancel => 'Annulla';

  @override
  String get settings_ok => 'OK';

  @override
  String get settings_notesViewModes => 'Modalità vista note';

  @override
  String get settings_selectNotesViewMode => 'Seleziona una modalità vista note.';

  @override
  String get settings_mapPlugins => 'Plugins mappa';

  @override
  String get settings_vectorLayers => 'Layers vettoriali';

  @override
  String get settings_loadingOptionsInfoTool => 'Opzioni caricamento e strumento informazioni';

  @override
  String get settings_dataLoading => 'Caricamento dati';

  @override
  String get settings_maxNumberFeatures => 'Numero massimo di elementi.';

  @override
  String get settings_maxNumFeaturesPerLayer => 'Numero massimo di elementi per layer. Rimuovi ed aggiungi di nuovo il layer per applicare.';

  @override
  String get settings_all => 'tutti';

  @override
  String get settings_loadMapArea => 'Carica area mappa.';

  @override
  String get settings_loadOnlyLastVisibleArea => 'Carica solo sull\'ultima area mappa visibile. Rimuovi ed aggiungi di nuovo il layer per applicare.';

  @override
  String get settings_infoTool => 'Strumento Informazioni';

  @override
  String get settings_tapSizeInfoToolPixels => 'Dimensione tocco dello strumento informazioni in pixels.';

  @override
  String get settings_editingTool => 'Strumento Modifica';

  @override
  String get settings_editingDragIconSize => 'Dimensione icona dei vertici di trascinamento.';

  @override
  String get settings_editingIntermediateDragIconSize => 'DImensione dei vertici intermedi di trascinamento.';

  @override
  String get settings_diagnostics => 'Diagnostica';

  @override
  String get settings_diagnosticsDebugLog => 'Diagnostica e registro di debug';

  @override
  String get settings_openFullDebugLog => 'Apri l\'intero registro di debug';

  @override
  String get settings_debugLogView => 'Vista Registro di Debug';

  @override
  String get settings_viewAllMessages => 'Vedi tutti i messaggi';

  @override
  String get settings_viewOnlyErrorsWarnings => 'Vedi solo errori ed avvisi';

  @override
  String get settings_clearDebugLog => 'Cancella registro di debug';

  @override
  String get settings_loadingData => 'Caricamento dati…';

  @override
  String get settings_device => 'Dispositivo';

  @override
  String get settings_deviceIdentifier => 'Identificativo del dispositivo';

  @override
  String get settings_deviceId => 'Identificativo del dispositivo';

  @override
  String get settings_overrideDeviceId => 'Sovrascrivi ID Dispositivo';

  @override
  String get settings_overrideId => 'Sovrascrivi ID';

  @override
  String get settings_pleaseEnterValidPassword => 'Si prega di inserire una password valida per il server.';

  @override
  String get settings_gss => 'GSS';

  @override
  String get settings_geopaparazziSurveyServer => 'Geopaparazzi Survey Server';

  @override
  String get settings_serverUrl => 'URL del server';

  @override
  String get settings_serverUrlStartWithHttp => 'L\'URL del server deve iniziare con HTTP o HTTPS.';

  @override
  String get settings_serverPassword => 'Password del server';

  @override
  String get settings_allowSelfSignedCert => 'Permetti certificati autofirmati';

  @override
  String get toolbarTools_zoomOut => 'Rimpicciolisci';

  @override
  String get toolbarTools_zoomIn => 'Ingrandisci';

  @override
  String get toolbarTools_cancelCurrentEdit => 'Cancella modifiche attuali.';

  @override
  String get toolbarTools_saveCurrentEdit => 'Salva modifiche attuali.';

  @override
  String get toolbarTools_insertPointMapCenter => 'Inserisci punto nel centro mappa.';

  @override
  String get toolbarTools_insertPointGpsPos => 'Inserisci punto nella posizione GPS.';

  @override
  String get toolbarTools_removeSelectedFeature => 'Rimuovi l\'elemento selezionato.';

  @override
  String get toolbarTools_showFeatureAttributes => 'Mostra attributi elemento.';

  @override
  String get toolbarTools_featureDoesNotHavePrimaryKey => 'L\'elemento non ha una chiave primaria. Non è permessa la modifica.';

  @override
  String get toolbarTools_queryFeaturesVectorLayers => 'Interroga elementi dai layers vettoriali caricati.';

  @override
  String get toolbarTools_measureDistanceWithFinger => 'Misura le distanze sulla mappa con il dito.';

  @override
  String get toolbarTools_modifyGeomVectorLayers => 'Modifica la geometria dei layers vettoriali modificabili.';

  @override
  String get coachMarks_singleTap => 'Tocco singolo: ';

  @override
  String get coachMarks_longTap => 'Tocco prolungato: ';

  @override
  String get coachMarks_doubleTap => 'Tocco doppio: ';

  @override
  String get coachMarks_simpleNoteButton => 'Pulsante Note Semplici';

  @override
  String get coachMarks_addNewNote => 'aggiungi una nuova nota';

  @override
  String get coachMarks_viewNotesList => 'vedi lista delle note semplici';

  @override
  String get coachMarks_viewNotesSettings => 'vedi impostazioni delle note';

  @override
  String get coachMarks_formNotesButton => 'Pulsante Note Complesse';

  @override
  String get coachMarks_addNewFormNote => 'aggiungi una nuova nota complessa';

  @override
  String get coachMarks_viewFormNoteList => 'vedi lista delle note complesse';

  @override
  String get coachMarks_gpsLogButton => 'Pulsante registrazioni GPS';

  @override
  String get coachMarks_startStopLogging => 'inizia/interrompi registrazione';

  @override
  String get coachMarks_viewLogsList => 'vedi lista registrazioni';

  @override
  String get coachMarks_viewLogsSettings => 'vedi impostazioni registrazione';

  @override
  String get coachMarks_gpsInfoButton => 'Pulsante info GPS (se applicabile)';

  @override
  String get coachMarks_centerMapOnGpsPos => 'centra la mappa sulla posizione GPS';

  @override
  String get coachMarks_showGpsInfo => 'mostra informazioni GPS';

  @override
  String get coachMarks_toggleAutoCenterGps => 'attiva/disattiva centra automaticamente su posizione GPS';

  @override
  String get coachMarks_layersViewButton => 'Pulsante vista layers';

  @override
  String get coachMarks_openLayersView => 'Apri vista layers';

  @override
  String get coachMarks_openLayersPluginDialog => 'Apre la finestra plugins dei layers';

  @override
  String get coachMarks_zoomInButton => 'Pulsante ingrandisci';

  @override
  String get coachMarks_zoomImMapOneLevel => 'Ingrandisci la mappa di un livello';

  @override
  String get coachMarks_zoomOutButton => 'Pulsante rimpicciolisci';

  @override
  String get coachMarks_zoomOutMapOneLevel => 'Rimpicciolisci la mappa di un livello';

  @override
  String get coachMarks_bottomToolsButton => 'Pulsante strumenti lato inferiore';

  @override
  String get coachMarks_toggleBottomToolsBar => 'Attiva/disattiva barra strumenti inferiore ';

  @override
  String get coachMarks_toolsButton => 'Pulsante Strumenti';

  @override
  String get coachMarks_openEndDrawerToAccessProject => 'Apre il cassetto per accedere alle informazioni del progetto, alle opzioni di condivisione, ai plugins mappa, agli strumenti e funzioni aggiuntive.';

  @override
  String get coachMarks_interactiveCoackMarksButton => 'Pulsante tutorial interattivo';

  @override
  String get coachMarks_openInteractiveCoachMarks => 'Apre il tutorial interattivo che spiega tutte le azioni relative alla vista mappa pincipale.';

  @override
  String get coachMarks_mainMenuButton => 'Pulsante menu principale';

  @override
  String get coachMarks_openDrawerToLoadProject => 'Apre il cassetto per caricare o creare un progetto, importare ed esportare dati, sincronizzarli su server, accedere alle preferenze, uscire dall\'app/spegnere il GPS.';

  @override
  String get coachMarks_skip => 'Salta';

  @override
  String get network_cancelledByUser => 'Annullato dall\'utente.';

  @override
  String get network_completed => 'Completato.';

  @override
  String get network_buildingBaseCachePerformance => 'Costruendo la cache di base per prestazioni migliorate (potrebbe volerci un po\')…';

  @override
  String get network_thisFIleAlreadyBeingDownloaded => 'Questo file è già stato scaricato.';

  @override
  String get network_download => 'Scarica';

  @override
  String get network_downloadFile => 'Scarica file';

  @override
  String get network_toTheDeviceTakeTime => 'sul dispositivo? Ciò può richiedere del tempo.';

  @override
  String get network_availableMaps => 'Mappe disponibili';

  @override
  String get network_searchMapByName => 'Ricerca mappa per nome';

  @override
  String get network_uploading => 'Caricamento';

  @override
  String get network_pleaseWait => 'attendere prego…';

  @override
  String get network_permissionOnServerDenied => 'Autorizzazione sul server negata.';

  @override
  String get network_couldNotConnectToServer => 'Impossibile connettersi al server. E\' online? Verifica l\'indirizzo.';

  @override
  String get form_smash_cantSaveImageDb => 'Non ho potuto salvare l\'immagine nella base dati.';

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
