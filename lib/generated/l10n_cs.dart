import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class SLCs extends SL {
  SLCs([String locale = 'cs']) : super(locale);

  @override
  String get main_welcome => 'Vítejte ve SMASH!';

  @override
  String get main_check_location_permission => 'Kontrola oprávnění k poloze…';

  @override
  String get main_location_permission_granted => 'Uděleno povolení k umístění.';

  @override
  String get main_checkingStoragePermission => 'Kontrola oprávnění k ukládání…';

  @override
  String get main_storagePermissionGranted => 'Povolení k ukládání je uděleno.';

  @override
  String get main_loadingPreferences => 'Načítání předvoleb…';

  @override
  String get main_preferencesLoaded => 'Předvolby načteny.';

  @override
  String get main_loadingWorkspace => 'Načítání pracovního prostoru…';

  @override
  String get main_workspaceLoaded => 'Pracovní prostor je načten.';

  @override
  String get main_loadingTagsList => 'Načítání seznamu štítků…';

  @override
  String get main_tagsListLoaded => 'Seznam štítků načten.';

  @override
  String get main_loadingKnownProjections => 'Načítání známých projekcí…';

  @override
  String get main_knownProjectionsLoaded => 'Známé projekce načteny.';

  @override
  String get main_loadingFences => 'Načítání plotů…';

  @override
  String get main_fencesLoaded => 'Ploty jsou načteny.';

  @override
  String get main_loadingLayersList => 'Načítání seznamu vrstev…';

  @override
  String get main_layersListLoaded => 'Seznam vrstev načten.';

  @override
  String get main_locationBackgroundWarning => 'V dalším kroku udělíte oprávnění k poloze, abyste umožnili záznam GPS na pozadí. (Jinak bude fungovat pouze na popředí.)\nŽádná data nejsou sdílena a ukládají se pouze lokálně v zařízení.';

  @override
  String get main_StorageIsInternalWarning => 'Čtěte prosím pozorně!\nV systému Android 11 a novějším musí být složka projektu SMASH umístěna ve složce\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\nve vašem úložišti, aby mohl být použit.\nPokud aplikaci odinstalujete, systém ji odstraní, takže v takovém případě si data zálohujte.\n\nNa lepším řešení se pracuje.';

  @override
  String get main_locationPermissionIsMandatoryToOpenSmash => 'Povolení k umístění je pro otevření SMASH povinné.';

  @override
  String get main_storagePermissionIsMandatoryToOpenSmash => 'Oprávnění k ukládání je pro otevření SMASH povinné.';

  @override
  String get main_anErrorOccurredTapToView => 'Došlo k chybě. Klepněte pro zobrazení.';

  @override
  String get mainView_loadingData => 'Načítání dat…';

  @override
  String get mainView_turnGpsOn => 'Zapnout GPS';

  @override
  String get mainView_turnGpsOff => 'Vypnout GPS';

  @override
  String get mainView_exit => 'Odejít';

  @override
  String get mainView_areYouSureCloseTheProject => 'Ukončit projekt?';

  @override
  String get mainView_activeOperationsWillBeStopped => 'Aktivní operace budou zastaveny.';

  @override
  String get mainView_showInteractiveCoachMarks => 'Zobrazit interaktivní značky trenérů.';

  @override
  String get mainView_openToolsDrawer => 'Otevřít zásuvku s nástroji.';

  @override
  String get mainView_zoomIn => 'Přiblížit';

  @override
  String get mainView_zoomOut => 'Oddálit';

  @override
  String get mainView_formNotes => 'Poznámky k formuláři';

  @override
  String get mainView_simpleNotes => 'Jednoduché poznámky';

  @override
  String get mainviewUtils_projects => 'Projekty';

  @override
  String get mainviewUtils_import => 'Import';

  @override
  String get mainviewUtils_export => 'Export';

  @override
  String get mainviewUtils_settings => 'Nastavení';

  @override
  String get mainviewUtils_onlineHelp => 'Online Nápověda';

  @override
  String get mainviewUtils_about => 'O aplikaci';

  @override
  String get mainviewUtils_projectInfo => 'Info o projektu';

  @override
  String get mainviewUtils_projectStats => 'Project Stats';

  @override
  String get mainviewUtils_project => 'Projekt';

  @override
  String get mainviewUtils_database => 'Databáze';

  @override
  String get mainviewUtils_extras => 'Doplňky';

  @override
  String get mainviewUtils_availableIcons => 'Dostupné ikony';

  @override
  String get mainviewUtils_offlineMaps => 'Offline mapy';

  @override
  String get mainviewUtils_positionTools => 'Poziční nástroje';

  @override
  String get mainviewUtils_goTo => 'Přejít na';

  @override
  String get mainviewUtils_goToCoordinate => 'Přejít na souřadnice';

  @override
  String get mainviewUtils_enterLonLat => 'Zadejte zeměpisnou délku, šířku';

  @override
  String get mainviewUtils_goToCoordinateWrongFormat => 'Špatný formát souřadnic. Mělo by být: 11.18463, 46.12345';

  @override
  String get mainviewUtils_goToCoordinateEmpty => 'Nemůže být prázdný.';

  @override
  String get mainviewUtils_sharePosition => 'Sdílet pozici';

  @override
  String get mainviewUtils_rotateMapWithGps => 'Otočení mapy pomocí GPS';

  @override
  String get exportWidget_export => 'Export';

  @override
  String get exportWidget_pdfExported => 'PDF exportováno';

  @override
  String get exportWidget_exportToPortableDocumentFormat => 'Export projektu do formátu Portable Document Format';

  @override
  String get exportWidget_gpxExported => 'GPX exportováno';

  @override
  String get exportWidget_exportToGpx => 'Export projektu do GPX';

  @override
  String get exportWidget_kmlExported => 'KML exportováno';

  @override
  String get exportWidget_exportToKml => 'Export projektu do KML';

  @override
  String get exportWidget_imagesToFolderExported => 'Obrázky exportované';

  @override
  String get exportWidget_exportImagesToFolder => 'Export obrázků projektu do složky';

  @override
  String get exportWidget_exportImagesToFolderTitle => 'Obrázky';

  @override
  String get exportWidget_geopackageExported => 'Geopackage exportován';

  @override
  String get exportWidget_exportToGeopackage => 'Export projektu do Geopackage';

  @override
  String get exportWidget_exportToGSS => 'Export do Geopaparazzi Survey Server';

  @override
  String get gssExport_gssExport => 'Export GSS';

  @override
  String get gssExport_setProjectDirty => 'Nastavit projekt na DIRTY?';

  @override
  String get gssExport_thisCantBeUndone => 'To se nedá vrátit!';

  @override
  String get gssExport_restoreProjectAsDirty => 'Obnovit projekt jako celý špinavý.';

  @override
  String get gssExport_setProjectClean => 'Nastavit projekt na ČISTÝ?';

  @override
  String get gssExport_restoreProjectAsClean => 'Obnovit projekt jako čistý.';

  @override
  String get gssExport_nothingToSync => 'Není co synchronizovat.';

  @override
  String get gssExport_collectingSyncStats => 'Sbírání statistik synchronizace…';

  @override
  String get gssExport_unableToSyncDueToError => 'Synchronizaci nelze provést z důvodu chyby, zkontrolujte diagnostiku.';

  @override
  String get gssExport_noGssUrlSet => 'Nebyla nastavena žádná adresa URL serveru GSS. Zkontrolujte nastavení.';

  @override
  String get gssExport_noGssPasswordSet => 'Nebylo nastaveno žádné heslo serveru GSS. Zkontrolujte nastavení.';

  @override
  String get gssExport_synStats => 'Statistiky synchronizace';

  @override
  String get gssExport_followingDataWillBeUploaded => 'Při synchronizaci se nahrají následující data.';

  @override
  String get gssExport_gpsLogs => 'Protokoly GPS:';

  @override
  String get gssExport_simpleNotes => 'Jednoduché poznámky:';

  @override
  String get gssExport_formNotes => 'Poznámky k formuláři:';

  @override
  String get gssExport_images => 'Obrázky:';

  @override
  String get gssExport_shouldNotHappen => 'Nemělo by se to stát';

  @override
  String get gssExport_upload => 'Nahrát';

  @override
  String get geocoding_geocoding => 'Geokódování';

  @override
  String get geocoding_nothingToLookFor => 'Nic, co by stálo za to hledat. Vložte adresu.';

  @override
  String get geocoding_launchGeocoding => 'Spustit geokódování';

  @override
  String get geocoding_searching => 'Hledání…';

  @override
  String get gps_smashIsActive => 'SMASH je aktivní';

  @override
  String get gps_smashIsLogging => 'SMASH se přihlašuje';

  @override
  String get gps_locationTracking => 'Sledování polohy';

  @override
  String get gps_smashLocServiceIsActive => 'Lokalizační služba SMASH je aktivní.';

  @override
  String get gps_backgroundLocIsOnToKeepRegistering => 'Poloha na pozadí je zapnutá, aby aplikace registrovala polohu, i když je na pozadí.';

  @override
  String get gssImport_gssImport => 'Import GSS';

  @override
  String get gssImport_downloadingDataList => 'Stahování seznamu dat…';

  @override
  String get gssImport_unableDownloadDataList => 'Seznam dat nelze stáhnout z důvodu chyby. Zkontrolujte nastavení a protokol.';

  @override
  String get gssImport_noGssUrlSet => 'Nebyla nastavena žádná adresa URL serveru GSS. Zkontrolujte nastavení.';

  @override
  String get gssImport_noGssPasswordSet => 'Nebylo nastaveno žádné heslo serveru GSS. Zkontrolujte nastavení.';

  @override
  String get gssImport_noPermToAccessServer => 'Nemáte oprávnění k přístupu na server. Zkontrolujte své pověření.';

  @override
  String get gssImport_data => 'Data';

  @override
  String get gssImport_dataSetsDownloadedMapsFolder => 'Datové sady se stahují do složky map.';

  @override
  String get gssImport_noDataAvailable => 'Nejsou k dispozici žádné údaje.';

  @override
  String get gssImport_projects => 'Projekty';

  @override
  String get gssImport_projectsDownloadedProjectFolder => 'Projekty se stahují do složky projects.';

  @override
  String get gssImport_noProjectsAvailable => 'Žádné projekty nejsou k dispozici.';

  @override
  String get gssImport_forms => 'Formuláře';

  @override
  String get gssImport_tagsDownloadedFormsFolder => 'Soubory značek jsou staženy do složky formulářů.';

  @override
  String get gssImport_noTagsAvailable => 'Nejsou k dispozici žádné štítky.';

  @override
  String get importWidget_import => 'Import';

  @override
  String get importWidget_importFromGeopaparazzi => 'Import z Geopaparazzi Survey Serveru';

  @override
  String get layersView_layerList => 'Seznam vrstev';

  @override
  String get layersView_loadRemoteDatabase => 'Načíst vzdálenou databázi';

  @override
  String get layersView_loadOnlineSources => 'Načíst online zdroje';

  @override
  String get layersView_loadLocalDatasets => 'Načíst místní datové sady';

  @override
  String get layersView_loading => 'Načítání…';

  @override
  String get layersView_zoomTo => 'Přiblížit na';

  @override
  String get layersView_properties => 'Vlastnosti';

  @override
  String get layersView_delete => 'Smazat';

  @override
  String get layersView_projCouldNotBeRecognized => 'Proj nebylo možné rozpoznat. Klepněte a zadejte epsg ručně.';

  @override
  String get layersView_projNotSupported => 'Proj není podporován. Klepněte a vyřešte to.';

  @override
  String get layersView_onlyImageFilesWithWorldDef => 'Podporovány jsou pouze obrazové soubory s definicí světa.';

  @override
  String get layersView_onlyImageFileWithPrjDef => 'Podporovány jsou pouze obrazové soubory s definicí souboru prj.';

  @override
  String get layersView_selectTableToLoad => 'Vyberte tabulku, která se má načíst.';

  @override
  String get layersView_fileFormatNotSUpported => 'Formát souboru není podporován.';

  @override
  String get onlineSourcesPage_onlineSourcesCatalog => 'Katalog online zdrojů';

  @override
  String get onlineSourcesPage_loadingTmsLayers => 'Načítání vrstev TMS…';

  @override
  String get onlineSourcesPage_loadingWmsLayers => 'Načítání vrstev WMS…';

  @override
  String get onlineSourcesPage_importFromFile => 'Import ze souboru';

  @override
  String get onlineSourcesPage_theFile => 'Soubor';

  @override
  String get onlineSourcesPage_doesntExist => 'neexistuje';

  @override
  String get onlineSourcesPage_onlineSourcesImported => 'Importované online zdroje.';

  @override
  String get onlineSourcesPage_exportToFile => 'Export do souboru';

  @override
  String get onlineSourcesPage_exportedTo => 'Exportováno do:';

  @override
  String get onlineSourcesPage_delete => 'Smazat';

  @override
  String get onlineSourcesPage_addToLayers => 'Přidat k vrstvám';

  @override
  String get onlineSourcesPage_setNameTmsService => 'Nastavení názvu služby TMS';

  @override
  String get onlineSourcesPage_enterName => 'zadejte název';

  @override
  String get onlineSourcesPage_pleaseEnterValidName => 'Zadejte prosím platný název';

  @override
  String get onlineSourcesPage_insertUrlOfService => 'Vložte URL služby.';

  @override
  String get onlineSourcesPage_placeXyzBetBrackets => 'Údaje x, y, z umístěte do složených závorek.';

  @override
  String get onlineSourcesPage_pleaseEnterValidTmsUrl => 'Zadejte platnou adresu URL TMS';

  @override
  String get onlineSourcesPage_enterUrl => 'Zadejte URL';

  @override
  String get onlineSourcesPage_enterSubDomains => 'zadejte subdomény';

  @override
  String get onlineSourcesPage_addAttribution => 'Přidejte připsání autorství.';

  @override
  String get onlineSourcesPage_enterAttribution => 'zadejte autorství';

  @override
  String get onlineSourcesPage_setMinMaxZoom => 'Nastavení min. a max. přiblížení.';

  @override
  String get onlineSourcesPage_minZoom => 'Minimální přiblížení';

  @override
  String get onlineSourcesPage_maxZoom => 'Maximální přiblížení';

  @override
  String get onlineSourcesPage_pleaseCheckYourData => 'Zkontrolujte svá data';

  @override
  String get onlineSourcesPage_details => 'Detaily';

  @override
  String get onlineSourcesPage_name => 'Název: ';

  @override
  String get onlineSourcesPage_subDomains => 'Poddomény: ';

  @override
  String get onlineSourcesPage_attribution => 'Autorství: ';

  @override
  String get onlineSourcesPage_cancel => 'Zrušit';

  @override
  String get onlineSourcesPage_ok => 'OK';

  @override
  String get onlineSourcesPage_newTmsOnlineService => 'Nová online služba TMS';

  @override
  String get onlineSourcesPage_save => 'Uložit';

  @override
  String get onlineSourcesPage_theBaseUrlWithQuestionMark => 'Základní adresa URL končící otazníkem.';

  @override
  String get onlineSourcesPage_pleaseEnterValidWmsUrl => 'Zadejte platnou URL systému WMS';

  @override
  String get onlineSourcesPage_setWmsLayerName => 'Nastavení názvu vrstvy WMS';

  @override
  String get onlineSourcesPage_enterLayerToLoad => 'zadejte vrstvu, která se má načíst';

  @override
  String get onlineSourcesPage_pleaseEnterValidLayer => 'Zadejte platnou vrstvu';

  @override
  String get onlineSourcesPage_setWmsImageFormat => 'Nastavte formát obrázku WMS';

  @override
  String get onlineSourcesPage_addAnAttribution => 'Přidejte autorství.';

  @override
  String get onlineSourcesPage_layer => 'Vrstva: ';

  @override
  String get onlineSourcesPage_url => 'URL: ';

  @override
  String get onlineSourcesPage_format => 'Formát';

  @override
  String get onlineSourcesPage_newWmsOnlineService => 'Nová online služba WMS';

  @override
  String get remoteDbPage_remoteDatabases => 'Vzdálené databáze';

  @override
  String get remoteDbPage_delete => 'Smazat';

  @override
  String get remoteDbPage_areYouSureDeleteDatabase => 'Smazat konfiguraci databáze?';

  @override
  String get remoteDbPage_edit => 'Upravit';

  @override
  String get remoteDbPage_table => 'tabulka';

  @override
  String get remoteDbPage_user => 'uživatel';

  @override
  String get remoteDbPage_loadInMap => 'Načtení do mapy.';

  @override
  String get remoteDbPage_databaseParameters => 'Parametry databáze';

  @override
  String get remoteDbPage_cancel => 'Zrušit';

  @override
  String get remoteDbPage_ok => 'OK';

  @override
  String get remoteDbPage_theUrlNeedsToBeDefined => 'Musí být definována adresa URL (postgis:host:port/databasename)';

  @override
  String get remoteDbPage_theUserNeedsToBeDefined => 'Musí být definován uživatel.';

  @override
  String get remoteDbPage_password => 'heslo';

  @override
  String get remoteDbPage_thePasswordNeedsToBeDefined => 'Musí být definováno heslo.';

  @override
  String get remoteDbPage_loadingTables => 'Načítání tabulek…';

  @override
  String get remoteDbPage_theTableNeedsToBeDefined => 'Název tabulky musí být definován.';

  @override
  String get remoteDbPage_unableToConnectToDatabase => 'Nelze se připojit k databázi. Zkontrolujte parametry a síť.';

  @override
  String get remoteDbPage_optionalWhereCondition => 'volitelná podmínka \"kde\"';

  @override
  String get geoImage_tiffProperties => 'Vlastnosti TIFF';

  @override
  String get geoImage_opacity => 'Průhlednost';

  @override
  String get geoImage_colorToHide => 'Barva, kterou chcete skrýt';

  @override
  String get gpx_gpxProperties => 'GPX Vlastnosti';

  @override
  String get gpx_wayPoints => 'Body trasy';

  @override
  String get gpx_color => 'Barva';

  @override
  String get gpx_size => 'Velikost';

  @override
  String get gpx_viewLabelsIfAvailable => 'Zobrazit štítky, pokud jsou k dispozici?';

  @override
  String get gpx_tracksRoutes => 'Trasy/cesty';

  @override
  String get gpx_width => 'Šířka';

  @override
  String get gpx_palette => 'Paleta';

  @override
  String get tiles_tileProperties => 'Vlastnosti dlaždic';

  @override
  String get tiles_opacity => 'Průhlednost';

  @override
  String get tiles_loadGeoPackageAsOverlay => 'Načíst dlaždice geopackage jako překryvný obrázek namísto vrstvy dlaždic (nejlepší pro data generovaná gdal a různé projekce).';

  @override
  String get tiles_colorToHide => 'Barva pro skrytí';

  @override
  String get wms_wmsProperties => 'Vlastnosti WMS';

  @override
  String get wms_opacity => 'Průhlednost';

  @override
  String get featureAttributesViewer_loadingData => 'Načítání dat…';

  @override
  String get featureAttributesViewer_setNewValue => 'Nastavení nové hodnoty';

  @override
  String get featureAttributesViewer_field => 'Pole';

  @override
  String get featureAttributesViewer_value => 'HODNOTA';

  @override
  String get projectsView_projectsView => 'Zobrazení Projektů';

  @override
  String get projectsView_openExistingProject => 'Otevřít existující projekt';

  @override
  String get projectsView_createNewProject => 'Vytvořit nový projekt';

  @override
  String get projectsView_recentProjects => 'Nedávné projekty';

  @override
  String get projectsView_newProject => 'Nový projekt';

  @override
  String get projectsView_enterNameForNewProject => 'Zadejte název nového projektu nebo přijměte navržený.';

  @override
  String get dataLoader_note => 'poznámka';

  @override
  String get dataLoader_Note => 'Poznámka';

  @override
  String get dataLoader_hasForm => 'Má formulář';

  @override
  String get dataLoader_POI => 'POI';

  @override
  String get dataLoader_savingImageToDB => 'Uložení obrázku do databáze…';

  @override
  String get dataLoader_removeNote => 'Odstranit poznámku';

  @override
  String get dataLoader_areYouSureRemoveNote => 'Odstranit poznámku?';

  @override
  String get dataLoader_image => 'Obrázek';

  @override
  String get dataLoader_longitude => 'Zeměpisná délka';

  @override
  String get dataLoader_latitude => 'Zeměpisná šířka';

  @override
  String get dataLoader_altitude => 'Nadmořská výška';

  @override
  String get dataLoader_timestamp => 'Časové razítko';

  @override
  String get dataLoader_removeImage => 'Odstranit obrázek';

  @override
  String get dataLoader_areYouSureRemoveImage => 'Odstranit obrázek?';

  @override
  String get images_loadingImage => 'Načítání obrázku…';

  @override
  String get about_loadingInformation => 'Načítání informací…';

  @override
  String get about_ABOUT => 'O aplikaci ';

  @override
  String get about_smartMobileAppForSurveyor => 'Chytrá mobilní aplikace pro šťastné geodety';

  @override
  String get about_applicationVersion => 'Verze';

  @override
  String get about_license => 'Licence';

  @override
  String get about_isAvailableUnderGPL3 => ' je copyleftový svobodný software s licencí GPLv3+.';

  @override
  String get about_sourceCode => 'Zdrojový kód';

  @override
  String get about_tapHereToVisitRepo => 'Klepnutím sem navštivte úložiště zdrojového kódu';

  @override
  String get about_legalInformation => 'Právní informace';

  @override
  String get about_copyright2020HydroloGIS => 'Copyright © 2020, HydroloGIS S.r.l. - některá práva vyhrazena. Klepněte pro návštěvu.';

  @override
  String get about_supportedBy => 'Podporováno';

  @override
  String get about_partiallySupportedByUniversityTrento => 'Částečně podpořeno projektem Steep Stream univerzity v Trentu.';

  @override
  String get about_privacyPolicy => 'Zásady ochrany osobních údajů';

  @override
  String get about_tapHereToSeePrivacyPolicy => 'Klepnutím sem zobrazíte zásady ochrany osobních údajů, které se týkají údajů o uživateli a poloze.';

  @override
  String get gpsInfoButton_noGpsInfoAvailable => 'Žádné informace o GPS nejsou k dispozici…';

  @override
  String get gpsInfoButton_timestamp => 'Časové razítko';

  @override
  String get gpsInfoButton_speed => 'Rychlost';

  @override
  String get gpsInfoButton_heading => 'Záhlaví';

  @override
  String get gpsInfoButton_accuracy => 'Přesnost';

  @override
  String get gpsInfoButton_altitude => 'Nadmořská výška';

  @override
  String get gpsInfoButton_latitude => 'Zeměpisná šířka';

  @override
  String get gpsInfoButton_copyLatitudeToClipboard => 'Kopírování zeměpisné šířky do schránky.';

  @override
  String get gpsInfoButton_longitude => 'Zeměpisná délka';

  @override
  String get gpsInfoButton_copyLongitudeToClipboard => 'Zkopírujte zeměpisnou délku do schránky.';

  @override
  String get gpsLogButton_stopLogging => 'Přestat zaznamenávat?';

  @override
  String get gpsLogButton_stopLoggingAndCloseLog => 'Zastavit záznam a zavřít aktuální záznam GPS?';

  @override
  String get gpsLogButton_newLog => 'Nový záznam';

  @override
  String get gpsLogButton_enterNameForNewLog => 'Zadejte název nového záznamu';

  @override
  String get gpsLogButton_couldNotStartLogging => 'Nelze spustit zaznamenávání: ';

  @override
  String get imageWidgets_loadingImage => 'Načítání obrázku…';

  @override
  String get logList_gpsLogsList => 'Seznam záznamů GPS';

  @override
  String get logList_selectAll => 'Vybrat vše';

  @override
  String get logList_unSelectAll => 'Zrušit výběr všeho';

  @override
  String get logList_invertSelection => 'Invertovat výběr';

  @override
  String get logList_mergeSelected => 'Sloučení vybraných';

  @override
  String get logList_loadingLogs => 'Načítání záznamů…';

  @override
  String get logList_zoomTo => 'Přiblížení';

  @override
  String get logList_properties => 'Vlastnosti';

  @override
  String get logList_profileView => 'Zobrazení profilu';

  @override
  String get logList_toGPX => 'Na GPX';

  @override
  String get logList_gpsSavedInExportFolder => 'GPX uložený ve složce pro export.';

  @override
  String get logList_errorOccurredExportingLogGPX => 'Nelze exportovat záznam do GPX.';

  @override
  String get logList_delete => 'Smazat';

  @override
  String get logList_DELETE => 'Smazat';

  @override
  String get logList_areYouSureDeleteTheLog => 'Smazat záznam?';

  @override
  String get logList_hours => 'hodiny';

  @override
  String get logList_hour => 'hodina';

  @override
  String get logList_minutes => 'min';

  @override
  String get logProperties_gpsLogProperties => 'Vlastnosti záznamu GPS';

  @override
  String get logProperties_logName => 'Název záznamu';

  @override
  String get logProperties_start => 'Spustit';

  @override
  String get logProperties_end => 'Konec';

  @override
  String get logProperties_duration => 'Trvání';

  @override
  String get logProperties_color => 'Barva';

  @override
  String get logProperties_palette => 'Paleta';

  @override
  String get logProperties_width => 'Šířka';

  @override
  String get logProperties_distanceAtPosition => 'Vzdálenost v pozici:';

  @override
  String get logProperties_totalDistance => 'Celková vzdálenost:';

  @override
  String get logProperties_gpsLogView => 'Zobrazení záznamu GPS';

  @override
  String get logProperties_disableStats => 'Vypnutí statistik';

  @override
  String get logProperties_enableStats => 'Zapnutí statistik';

  @override
  String get logProperties_totalDuration => 'Celková doba trvání:';

  @override
  String get logProperties_timestamp => 'Časové razítko:';

  @override
  String get logProperties_durationAtPosition => 'Doba trvání na pozici:';

  @override
  String get logProperties_speed => 'Rychlost:';

  @override
  String get logProperties_elevation => 'Výška:';

  @override
  String get noteList_simpleNotesList => 'Jednoduchý seznam poznámek';

  @override
  String get noteList_formNotesList => 'Seznam poznámek k formuláři';

  @override
  String get noteList_loadingNotes => 'Načítání poznámek…';

  @override
  String get noteList_zoomTo => 'Přiblížit na';

  @override
  String get noteList_edit => 'Upravit';

  @override
  String get noteList_properties => 'Vlastnosti';

  @override
  String get noteList_delete => 'Smazat';

  @override
  String get noteList_DELETE => 'Smazat';

  @override
  String get noteList_areYouSureDeleteNote => 'Smazat poznámku?';

  @override
  String get settings_settings => 'Nastavení';

  @override
  String get settings_camera => 'Fotoaparát';

  @override
  String get settings_cameraResolution => 'Rozlišení fotoaparátu';

  @override
  String get settings_resolution => 'Rozlišení';

  @override
  String get settings_theCameraResolution => 'Rozlišení kamery';

  @override
  String get settings_screen => 'Obrazovka';

  @override
  String get settings_screenScaleBarIconSize => 'Velikost obrazovky, panelu měřítek a ikon';

  @override
  String get settings_keepScreenOn => 'Ponechat obrazovku zapnutou';

  @override
  String get settings_retinaScreenMode => 'Režim obrazovky HiDPI';

  @override
  String get settings_toApplySettingEnterExitLayerView => 'Pro použití tohoto nastavení vstupte do zobrazení vrstvy a ukončete je.';

  @override
  String get settings_colorPickerToUse => 'Použití nástroje pro výběr barev';

  @override
  String get settings_mapCenterCross => 'Kříž středu mapy';

  @override
  String get settings_color => 'Barva';

  @override
  String get settings_size => 'Velikost';

  @override
  String get settings_width => 'Šířka';

  @override
  String get settings_mapToolsIconSize => 'Velikost ikony pro mapové nástroje';

  @override
  String get settings_gps => 'GPS';

  @override
  String get settings_gpsFiltersAndMockLoc => 'Filtry GPS a zkušební lokality';

  @override
  String get settings_livePreview => 'Náhled v reálném čase';

  @override
  String get settings_noPointAvailableYet => 'Zatím není k dispozici žádný bod.';

  @override
  String get settings_longitudeDeg => 'zeměpisná délka [deg]';

  @override
  String get settings_latitudeDeg => 'zeměpisná šířka [stupňů]';

  @override
  String get settings_accuracyM => 'přesnost [m]';

  @override
  String get settings_altitudeM => 'nadmořská výška [m]';

  @override
  String get settings_headingDeg => 'směr [deg]';

  @override
  String get settings_speedMS => 'rychlost [m/s]';

  @override
  String get settings_isLogging => 'je záznam?';

  @override
  String get settings_mockLocations => 'zkušební místa?';

  @override
  String get settings_minDistFilterBlocks => 'Filtr minimální vzdálenosti blokuje';

  @override
  String get settings_minDistFilterPasses => 'Filtr min. vzdálenosti prošel';

  @override
  String get settings_minTimeFilterBlocks => 'Filtr minimálního času blokuje';

  @override
  String get settings_minTimeFilterPasses => 'Filtr minimálního času prošel';

  @override
  String get settings_hasBeenBlocked => 'Byl blokován';

  @override
  String get settings_distanceFromPrevM => 'Vzdálenost od předchozího [m]';

  @override
  String get settings_timeFromPrevS => 'Čas od předchozího [s]';

  @override
  String get settings_locationInfo => 'Informace o poloze';

  @override
  String get settings_filters => 'Filtry';

  @override
  String get settings_disableFilters => 'Vypnout filtry.';

  @override
  String get settings_enableFilters => 'Zapnout filtry.';

  @override
  String get settings_zoomIn => 'Přiblížení';

  @override
  String get settings_zoomOut => 'Oddálení';

  @override
  String get settings_activatePointFlow => 'Aktivovat bodový tok.';

  @override
  String get settings_pausePointsFlow => 'Pozastavení toku bodů.';

  @override
  String get settings_visualizePointCount => 'Vizualizace počtu bodů';

  @override
  String get settings_showGpsPointsValidPoints => 'Zobrazit počet bodů GPS pro VALIDNÍ body.';

  @override
  String get settings_showGpsPointsAllPoints => 'Zobrazení počtu bodů GPS pro VŠECHNY body.';

  @override
  String get settings_logFilters => 'Filtry záznamu';

  @override
  String get settings_minDistanceBetween2Points => 'Minimální vzdálenost mezi 2 body.';

  @override
  String get settings_minTimespanBetween2Points => 'Minimální časový interval mezi 2 body.';

  @override
  String get settings_gpsFilter => 'GPS filtr';

  @override
  String get settings_disable => 'Vypnout';

  @override
  String get settings_enable => 'Zapnout';

  @override
  String get settings_theUseOfTheGps => 'použití filtrované GPS.';

  @override
  String get settings_warningThisWillAffectGpsPosition => 'Varování: To ovlivní polohu GPS, vkládání poznámek, statistiky záznamů a tvorbu grafů.';

  @override
  String get settings_MockLocations => 'Zkušební lokality';

  @override
  String get settings_testGpsLogDemoUse => 'testovací záznam GPS pro demonstrační použití.';

  @override
  String get settings_setDurationGpsPointsInMilli => 'Nastavení doby trvání bodů GPS v milisekundách.';

  @override
  String get settings_SETTING => 'Nastavení';

  @override
  String get settings_setMockedGpsDuration => 'Nastavení doby trvání simulovaného systému GPS';

  @override
  String get settings_theValueHasToBeInt => 'Hodnota musí být celé číslo.';

  @override
  String get settings_milliseconds => 'milisekundy';

  @override
  String get settings_useGoogleToImproveLoc => 'Využití služeb Google ke zlepšení polohy';

  @override
  String get settings_useOfGoogleServicesRestart => 'používání služeb Google (nutný restart aplikace).';

  @override
  String get settings_gpsLogsViewMode => 'Režim zobrazení záznamů GPS';

  @override
  String get settings_logViewModeForOrigData => 'Režim zobrazení záznamu pro původní data.';

  @override
  String get settings_logViewModeFilteredData => 'Režim zobrazení záznamu pro filtrovaná data.';

  @override
  String get settings_cancel => 'Zrušit';

  @override
  String get settings_ok => 'OK';

  @override
  String get settings_notesViewModes => 'Režimy zobrazení poznámek';

  @override
  String get settings_selectNotesViewMode => 'Vyberte režim, ve kterém chcete poznámky zobrazit.';

  @override
  String get settings_mapPlugins => 'Zásuvné moduly mapy';

  @override
  String get settings_vectorLayers => 'Vektorové vrstvy';

  @override
  String get settings_loadingOptionsInfoTool => 'Možnosti načítání a informační nástroj';

  @override
  String get settings_dataLoading => 'Načítání dat';

  @override
  String get settings_maxNumberFeatures => 'Maximální počet funkcí.';

  @override
  String get settings_maxNumFeaturesPerLayer => 'Maximální počet funkcí na vrstvu. Odeberte a přidejte vrstvu, kterou chcete použít.';

  @override
  String get settings_all => 'vše';

  @override
  String get settings_loadMapArea => 'Načtení oblasti mapy.';

  @override
  String get settings_loadOnlyLastVisibleArea => 'Načtení pouze v poslední viditelné oblasti mapy. Pro použití vrstvu odeberte a znovu přidejte.';

  @override
  String get settings_infoTool => 'Nástroj Info';

  @override
  String get settings_tapSizeInfoToolPixels => 'Velikost nástroje Info klepnutím, v pixelech.';

  @override
  String get settings_editingTool => 'Nástroj Úpravy';

  @override
  String get settings_editingDragIconSize => 'Úprava velikosti ikony obsluhy přetahování.';

  @override
  String get settings_editingIntermediateDragIconSize => 'Úprava velikosti prostřední ikony obsluhy přetahování.';

  @override
  String get settings_diagnostics => 'Diagnostika';

  @override
  String get settings_diagnosticsDebugLog => 'Diagnostika a protokol ladění';

  @override
  String get settings_openFullDebugLog => 'Otevřít úplný protokol ladění';

  @override
  String get settings_debugLogView => 'Zobrazení protokolu ladění';

  @override
  String get settings_viewAllMessages => 'Zobrazit všechny zprávy';

  @override
  String get settings_viewOnlyErrorsWarnings => 'Zobrazit pouze chyby a varování';

  @override
  String get settings_clearDebugLog => 'Vymazat protokol ladění';

  @override
  String get settings_loadingData => 'Načítání dat…';

  @override
  String get settings_device => 'Zařízení';

  @override
  String get settings_deviceIdentifier => 'Identifikátor zařízení';

  @override
  String get settings_deviceId => 'ID zařízení';

  @override
  String get settings_overrideDeviceId => 'Přepsat ID zařízení';

  @override
  String get settings_overrideId => 'Přepsat ID';

  @override
  String get settings_pleaseEnterValidPassword => 'Zadejte platné heslo serveru.';

  @override
  String get settings_gss => 'GSS';

  @override
  String get settings_geopaparazziSurveyServer => 'Geopaparazzi Survey Server';

  @override
  String get settings_serverUrl => 'Server URL';

  @override
  String get settings_serverUrlStartWithHttp => 'Adresa URL serveru musí začínat HTTP nebo HTTPS.';

  @override
  String get settings_serverPassword => 'Heslo serveru';

  @override
  String get settings_allowSelfSignedCert => 'Povolení vlastnoručně podepsaných certifikátů';

  @override
  String get toolbarTools_zoomOut => 'Oddálit';

  @override
  String get toolbarTools_zoomIn => 'Přiblížit';

  @override
  String get toolbarTools_cancelCurrentEdit => 'Zrušit aktuální úpravu.';

  @override
  String get toolbarTools_saveCurrentEdit => 'Uložit aktuální úpravu.';

  @override
  String get toolbarTools_insertPointMapCenter => 'Vložit bod do středu mapy.';

  @override
  String get toolbarTools_insertPointGpsPos => 'Vložit bod do polohy GPS.';

  @override
  String get toolbarTools_removeSelectedFeature => 'Odebrat vybrané prvky.';

  @override
  String get toolbarTools_showFeatureAttributes => 'Zobrazit atributy prvků.';

  @override
  String get toolbarTools_featureDoesNotHavePrimaryKey => 'Funkce nemá primární klíč. Editace není povolena.';

  @override
  String get toolbarTools_queryFeaturesVectorLayers => 'Dotazování na prvky z načtených vektorových vrstev.';

  @override
  String get toolbarTools_measureDistanceWithFinger => 'Měření vzdáleností na mapě prstem.';

  @override
  String get toolbarTools_modifyGeomVectorLayers => 'Úprava geometrie upravitelných vektorových vrstev.';

  @override
  String get coachMarks_singleTap => 'Jedno klepnutí: ';

  @override
  String get coachMarks_longTap => 'Dlouhé poklepání: ';

  @override
  String get coachMarks_doubleTap => 'Dvojité poklepání: ';

  @override
  String get coachMarks_simpleNoteButton => 'Tlačítko Jednoduché poznámky';

  @override
  String get coachMarks_addNewNote => 'přidat novou poznámku';

  @override
  String get coachMarks_viewNotesList => 'zobrazit seznam poznámek';

  @override
  String get coachMarks_viewNotesSettings => 'zobrazit nastavení poznámek';

  @override
  String get coachMarks_formNotesButton => 'Tlačítko Poznámky k formuláři';

  @override
  String get coachMarks_addNewFormNote => 'přidat novou poznámku k formuláři';

  @override
  String get coachMarks_viewFormNoteList => 'zobrazit seznam poznámek k formuláři';

  @override
  String get coachMarks_gpsLogButton => 'Tlačítko záznamu GPS';

  @override
  String get coachMarks_startStopLogging => 'začít záznam/ukončit záznam';

  @override
  String get coachMarks_viewLogsList => 'zobrazit seznam záznamů';

  @override
  String get coachMarks_viewLogsSettings => 'zobrazit nastavení záznamu';

  @override
  String get coachMarks_gpsInfoButton => 'Informační tlačítko GPS (pokud je k dispozici)';

  @override
  String get coachMarks_centerMapOnGpsPos => 'vystředit mapu na pozici GPS';

  @override
  String get coachMarks_showGpsInfo => 'zobrazit informace GPS';

  @override
  String get coachMarks_toggleAutoCenterGps => 'přepnout automatické centrování na GPS';

  @override
  String get coachMarks_layersViewButton => 'Tlačítko zobrazení vrstev';

  @override
  String get coachMarks_openLayersView => 'Otevřít zobrazení vrstev';

  @override
  String get coachMarks_openLayersPluginDialog => 'Otevřít dialogové okno zásuvných modulů vrstvy';

  @override
  String get coachMarks_zoomInButton => 'Tlačítko přiblížení';

  @override
  String get coachMarks_zoomImMapOneLevel => 'Přiblížení mapy o jednu úroveň';

  @override
  String get coachMarks_zoomOutButton => 'Tlačítko oddálení';

  @override
  String get coachMarks_zoomOutMapOneLevel => 'Oddálení mapy o jednu úroveň';

  @override
  String get coachMarks_bottomToolsButton => 'Tlačítko nástrojů dole';

  @override
  String get coachMarks_toggleBottomToolsBar => 'Přepínání spodního panelu nástrojů';

  @override
  String get coachMarks_toolsButton => 'Tlačítko nástrojů';

  @override
  String get coachMarks_openEndDrawerToAccessProject => 'Otevřením konce zásuvky získáte přístup k informacím o projektu a možnostem sdílení, stejně jako k mapovým zásuvným modulům, nástrojům funkcí a doplňkům';

  @override
  String get coachMarks_interactiveCoackMarksButton => 'Interaktivní tlačítko coach-marks';

  @override
  String get coachMarks_openInteractiveCoachMarks => 'Otevřete interaktivní značky trenéra, které vysvětlují všechny akce hlavního zobrazení mapy.';

  @override
  String get coachMarks_mainMenuButton => 'Tlačítko hlavní nabídky';

  @override
  String get coachMarks_openDrawerToLoadProject => 'Otevřením zásuvky můžete načíst nebo vytvořit projekt, importovat a exportovat data, synchronizovat se servery, přistupovat k nastavení a ukončit aplikaci/vypnout GPS.';

  @override
  String get coachMarks_skip => 'Přeskočit';

  @override
  String get network_cancelledByUser => 'Zrušeno uživatelem.';

  @override
  String get network_completed => 'Dokončeno.';

  @override
  String get network_buildingBaseCachePerformance => 'Vytvoření základní mezipaměti pro zvýšení výkonu (může chvíli trvat)…';

  @override
  String get network_thisFIleAlreadyBeingDownloaded => 'Tento soubor je již stažen.';

  @override
  String get network_download => 'Stáhnout';

  @override
  String get network_downloadFile => 'Stáhnout soubor';

  @override
  String get network_toTheDeviceTakeTime => 'do zařízení? To může chvíli trvat.';

  @override
  String get network_availableMaps => 'Dostupné mapy';

  @override
  String get network_searchMapByName => 'Hledání mapy podle názvu';

  @override
  String get network_uploading => 'Nahrávání…';

  @override
  String get network_pleaseWait => 'prosím, počkejte…';

  @override
  String get network_permissionOnServerDenied => 'Oprávnění na serveru odepřeno.';

  @override
  String get network_couldNotConnectToServer => 'Nepodařilo se připojit k serveru. Je online? Zkontrolujte svou adresu.';

  @override
  String get form_smash_cantSaveImageDb => 'Obrázek se nepodařilo uložit do databáze.';

  @override
  String get formbuilder => 'Tvůrce formulářů';

  @override
  String get layersView_selectGssLayers => 'Vybrat vrstvy GSS';

  @override
  String get layersView_noGssLayersFound => 'Nenalezeny žádné vrstvy GSS.';

  @override
  String get layersView_noGssLayersAvailable => 'Nejsou k dispozici žádné vrstvy (načtené se nezobrazují).';

  @override
  String get layersView_selectGssLayersToLoad => 'Vyberte vrstvy GSS k načtení.';

  @override
  String get layersView_unableToLoadGssLayers => 'Nelze načíst:';

  @override
  String get layersView_layerExists => 'Vrstva existuje';

  @override
  String get layersView_layerAlreadyExists => 'Vrstva již existuje, chcete ji přepsat?';

  @override
  String get gss_layerview_upload_changes => 'Nahrát změny';

  @override
  String get allGpsPointsCount => 'Gps body';

  @override
  String get filteredGpsPointsCount => 'Filtrované body';

  @override
  String get addTmsFromDefaults => 'Přidat TMS z výchozích nastavení';

  @override
  String get form_smash_noCameraDesktop => 'Na desktopu není k dispozici žádná možnost fotoaparátu.';

  @override
  String get settings_BottombarCustomization => 'Přizpůsobení spodní lišty';

  @override
  String get settings_Bottombar_showAddNote => 'Zobrazit tlačítko PŘIDAT POZNÁMKU';

  @override
  String get settings_Bottombar_showAddFormNote => 'Zobrazit tlačítko PŘIDAT POZNÁMKU K FORMULÁŘI';

  @override
  String get settings_Bottombar_showAddGpsLog => 'Zobrazit tlačítko PŘIDAT ZÁZNAM GPS';

  @override
  String get settings_Bottombar_showGpsButton => 'Zobrazit tlačítko gps';

  @override
  String get settings_Bottombar_showLayers => 'Zobrazit tlačítko vrstev';

  @override
  String get settings_Bottombar_showZoom => 'Zobrazit tlačítka přiblížení';

  @override
  String get settings_Bottombar_showEditing => 'Zobrazit tlačítko pro úpravy';

  @override
  String get gss_layerview_filter => 'Filtr';
}
