import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class SLJa extends SL {
  SLJa([String locale = 'ja']) : super(locale);

  @override
  String get main_welcome => 'SMASHにようこそ!';

  @override
  String get main_check_location_permission => '位置情報の権限を確認しています…';

  @override
  String get main_location_permission_granted => '位置情報の権限が付与されました。';

  @override
  String get main_checkingStoragePermission => 'ストレージ権限を確認しています…';

  @override
  String get main_storagePermissionGranted => 'ストレージ権限が付与されました。';

  @override
  String get main_loadingPreferences => '設定を読み込んでいます…';

  @override
  String get main_preferencesLoaded => '設定が読み込まれました。';

  @override
  String get main_loadingWorkspace => 'ワークスペースを読み込んでいます…';

  @override
  String get main_workspaceLoaded => 'ワークスペースが読み込まれました。';

  @override
  String get main_loadingTagsList => 'タグリストを読み込んでいます…';

  @override
  String get main_tagsListLoaded => 'タグリストが読み込まれました。';

  @override
  String get main_loadingKnownProjections => '既知の投影法を読み込んでいます…';

  @override
  String get main_knownProjectionsLoaded => '既知の投影法が読み込まれました。';

  @override
  String get main_loadingFences => 'フェンスを読み込んでいます…';

  @override
  String get main_fencesLoaded => 'フェンスが読み込まれました。';

  @override
  String get main_loadingLayersList => 'レイヤーリストを読み込んでいます…';

  @override
  String get main_layersListLoaded => 'レイヤーリストが読み込まれました。';

  @override
  String get main_locationBackgroundWarning => 'バックグラウンドでのGPSロギングを有効にするため、次のステップで位置情報を許可してください。(許可しない場合はフォアグラウンドでのみ動作します。)\nデータは共有されず、デバイスのローカルにのみ保存されます。';

  @override
  String get main_StorageIsInternalWarning => '注意してお読みください!\nAndroid 11以降では、SMASHのプロジェクトフォルダを、ストレージ内の\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\nフォルダに配置しないと使用できません。\nアプリをアンインストールすると、システムがフォルダを削除しますので、アンインストールする場合はデータをバックアップしてください。\n\nより良い解決策を検討中です。';

  @override
  String get main_locationPermissionIsMandatoryToOpenSmash => 'SMASHを開くには、位置情報の権限が必須です。';

  @override
  String get main_storagePermissionIsMandatoryToOpenSmash => 'SMASHを開くには、ストレージ権限が必須です。';

  @override
  String get main_anErrorOccurredTapToView => 'エラーが発生しました。タップして表示します。';

  @override
  String get mainView_loadingData => 'データを読み込んでいます…';

  @override
  String get mainView_turnGpsOn => 'GPSをオンにする';

  @override
  String get mainView_turnGpsOff => 'GPSをオフにする';

  @override
  String get mainView_exit => '終了';

  @override
  String get mainView_areYouSureCloseTheProject => 'プロジェクトを閉じてもよろしいですか？';

  @override
  String get mainView_activeOperationsWillBeStopped => 'アクティブな操作は停止されます。';

  @override
  String get mainView_showInteractiveCoachMarks => 'インタラクティブなコーチマークを表示します。';

  @override
  String get mainView_openToolsDrawer => 'ツールドロワーを開きます。';

  @override
  String get mainView_zoomIn => '拡大';

  @override
  String get mainView_zoomOut => '縮小';

  @override
  String get mainView_formNotes => 'フォームノート';

  @override
  String get mainView_simpleNotes => 'シンプルノート';

  @override
  String get mainviewUtils_projects => 'プロジェクト';

  @override
  String get mainviewUtils_import => 'インポート';

  @override
  String get mainviewUtils_export => 'エクスポート';

  @override
  String get mainviewUtils_settings => '設定';

  @override
  String get mainviewUtils_onlineHelp => 'オンラインヘルプ';

  @override
  String get mainviewUtils_about => 'SMASHについて';

  @override
  String get mainviewUtils_projectInfo => 'プロジェクト情報';

  @override
  String get mainviewUtils_projectStats => 'Project Stats';

  @override
  String get mainviewUtils_project => 'プロジェクト';

  @override
  String get mainviewUtils_database => 'データベース';

  @override
  String get mainviewUtils_extras => 'その他';

  @override
  String get mainviewUtils_availableIcons => '利用可能なアイコン';

  @override
  String get mainviewUtils_offlineMaps => 'オフラインマップ';

  @override
  String get mainviewUtils_positionTools => '位置ツール';

  @override
  String get mainviewUtils_goTo => '移動';

  @override
  String get mainviewUtils_goToCoordinate => 'Go to coordinate';

  @override
  String get mainviewUtils_enterLonLat => 'Enter longitude, latitude';

  @override
  String get mainviewUtils_goToCoordinateWrongFormat => 'Wrong coordinate format. Should be: 11.18463, 46.12345';

  @override
  String get mainviewUtils_goToCoordinateEmpty => 'This can\'t be empty.';

  @override
  String get mainviewUtils_sharePosition => '位置を共有';

  @override
  String get mainviewUtils_rotateMapWithGps => 'GPSで地図を回転';

  @override
  String get exportWidget_export => 'エクスポート';

  @override
  String get exportWidget_pdfExported => 'PDFエクスポート済み';

  @override
  String get exportWidget_exportToPortableDocumentFormat => 'プロジェクトをPDF形式にエクスポート';

  @override
  String get exportWidget_gpxExported => 'GPXエクスポート済み';

  @override
  String get exportWidget_exportToGpx => 'プロジェクトをGPXにエクスポート';

  @override
  String get exportWidget_kmlExported => 'KMLエクスポート済み';

  @override
  String get exportWidget_exportToKml => 'プロジェクトをKMLにエクスポート';

  @override
  String get exportWidget_imagesToFolderExported => '画像エクスポート済み';

  @override
  String get exportWidget_exportImagesToFolder => 'プロジェクトの画像をフォルダにエクスポート';

  @override
  String get exportWidget_exportImagesToFolderTitle => '画像';

  @override
  String get exportWidget_geopackageExported => 'GeoPackageエクスポート済み';

  @override
  String get exportWidget_exportToGeopackage => 'プロジェクトをGeoPackageにエクスポート';

  @override
  String get exportWidget_exportToGSS => 'Geopaparazzi Survey Serverにエクスポート';

  @override
  String get gssExport_gssExport => 'GSSエクスポート';

  @override
  String get gssExport_setProjectDirty => 'プロジェクトをダーティに設定しますか？';

  @override
  String get gssExport_thisCantBeUndone => 'これは元に戻せません！';

  @override
  String get gssExport_restoreProjectAsDirty => 'プロジェクトをすべてダーティとして復元します。';

  @override
  String get gssExport_setProjectClean => 'プロジェクトをクリーンに設定しますか？';

  @override
  String get gssExport_restoreProjectAsClean => 'プロジェクトをすべてクリーンな状態で復元します。';

  @override
  String get gssExport_nothingToSync => '同期するものがありません。';

  @override
  String get gssExport_collectingSyncStats => '同期統計を収集しています…';

  @override
  String get gssExport_unableToSyncDueToError => 'エラーのため同期できません。診断を確認してください。';

  @override
  String get gssExport_noGssUrlSet => 'GSSサーバーのURLが設定されていません。設定を確認してください。';

  @override
  String get gssExport_noGssPasswordSet => 'GSSサーバーのパスワードが設定されていません。設定を確認してください。';

  @override
  String get gssExport_synStats => '同期統計';

  @override
  String get gssExport_followingDataWillBeUploaded => '次のデータは同期時にアップロードされます。';

  @override
  String get gssExport_gpsLogs => 'GPSログ:';

  @override
  String get gssExport_simpleNotes => 'シンプルノート:';

  @override
  String get gssExport_formNotes => 'フォームノート:';

  @override
  String get gssExport_images => '画像:';

  @override
  String get gssExport_shouldNotHappen => '発生してはならない';

  @override
  String get gssExport_upload => 'アップロード';

  @override
  String get geocoding_geocoding => 'ジオコーディング';

  @override
  String get geocoding_nothingToLookFor => '検索するものがありません。アドレスを挿入してください。';

  @override
  String get geocoding_launchGeocoding => 'ジオコーディングの起動';

  @override
  String get geocoding_searching => '検索中…';

  @override
  String get gps_smashIsActive => 'SMASHはアクティブです';

  @override
  String get gps_smashIsLogging => 'SMASHはログを記録しています';

  @override
  String get gps_locationTracking => '位置追跡';

  @override
  String get gps_smashLocServiceIsActive => 'SMASHロケーションサービスがアクティブです。';

  @override
  String get gps_backgroundLocIsOnToKeepRegistering => 'アプリがバックグラウンドにある場合でも、アプリが位置情報を登録し続けるために、バックグラウンドロケーションがオンになっています。';

  @override
  String get gssImport_gssImport => 'GSSインポート';

  @override
  String get gssImport_downloadingDataList => 'データリストをダウンロードしています…';

  @override
  String get gssImport_unableDownloadDataList => 'エラーのため、データリストをダウンロードできません。設定とログを確認してください。';

  @override
  String get gssImport_noGssUrlSet => 'GSSサーバーのURLが設定されていません。設定を確認してください。';

  @override
  String get gssImport_noGssPasswordSet => 'GSSサーバーのパスワードが設定されていません。設定を確認してください。';

  @override
  String get gssImport_noPermToAccessServer => 'サーバーにアクセスする権限がありません。資格情報を確認してください。';

  @override
  String get gssImport_data => 'データ';

  @override
  String get gssImport_dataSetsDownloadedMapsFolder => 'データセットはマップフォルダーにダウンロードされます。';

  @override
  String get gssImport_noDataAvailable => '利用可能なデータがありません。';

  @override
  String get gssImport_projects => 'プロジェクト';

  @override
  String get gssImport_projectsDownloadedProjectFolder => 'プロジェクトはプロジェクトフォルダーにダウンロードされます。';

  @override
  String get gssImport_noProjectsAvailable => '利用可能なプロジェクトがありません。';

  @override
  String get gssImport_forms => 'フォーム';

  @override
  String get gssImport_tagsDownloadedFormsFolder => 'タグファイルはフォームフォルダーにダウンロードされます。';

  @override
  String get gssImport_noTagsAvailable => '使用可能なタグはありません。';

  @override
  String get importWidget_import => 'インポート';

  @override
  String get importWidget_importFromGeopaparazzi => 'Geopaparazzi Survey Serverからインポート';

  @override
  String get layersView_layerList => 'レイヤーリスト';

  @override
  String get layersView_loadRemoteDatabase => 'リモートデータベースをロード';

  @override
  String get layersView_loadOnlineSources => 'オンラインソースを読み込む';

  @override
  String get layersView_loadLocalDatasets => 'ローカルデータセットを読み込む';

  @override
  String get layersView_loading => '読み込み中…';

  @override
  String get layersView_zoomTo => 'ズーム';

  @override
  String get layersView_properties => 'プロパティ';

  @override
  String get layersView_delete => '削除';

  @override
  String get layersView_projCouldNotBeRecognized => 'プロジェクトを認識できませんでした。タップしてepsgを手動で入力してください。';

  @override
  String get layersView_projNotSupported => 'プロジェクトはサポートされていません。タップして解決してください。';

  @override
  String get layersView_onlyImageFilesWithWorldDef => 'ワールドファイル定義の画像ファイルのみがサポートされています。';

  @override
  String get layersView_onlyImageFileWithPrjDef => 'prjファイル定義のある画像ファイルのみがサポートされています。';

  @override
  String get layersView_selectTableToLoad => 'ロードするテーブルを選択してください。';

  @override
  String get layersView_fileFormatNotSUpported => 'ファイル形式はサポートされていません。';

  @override
  String get onlineSourcesPage_onlineSourcesCatalog => 'オンラインソースカタログ';

  @override
  String get onlineSourcesPage_loadingTmsLayers => 'TMSレイヤーを読み込んでいます…';

  @override
  String get onlineSourcesPage_loadingWmsLayers => 'WMSレイヤーを読み込んでいます…';

  @override
  String get onlineSourcesPage_importFromFile => 'ファイルからインポート';

  @override
  String get onlineSourcesPage_theFile => 'ファイル';

  @override
  String get onlineSourcesPage_doesntExist => '存在しません';

  @override
  String get onlineSourcesPage_onlineSourcesImported => 'オンラインソースがインポートされました。';

  @override
  String get onlineSourcesPage_exportToFile => 'ファイルにエクスポート';

  @override
  String get onlineSourcesPage_exportedTo => 'エクスポート先:';

  @override
  String get onlineSourcesPage_delete => '削除';

  @override
  String get onlineSourcesPage_addToLayers => 'レイヤーに追加';

  @override
  String get onlineSourcesPage_setNameTmsService => 'TMSサービスの名前を設定してください';

  @override
  String get onlineSourcesPage_enterName => '名前を入力してください';

  @override
  String get onlineSourcesPage_pleaseEnterValidName => '有効な名前を入力してください';

  @override
  String get onlineSourcesPage_insertUrlOfService => 'サービスのURLを挿入してください。';

  @override
  String get onlineSourcesPage_placeXyzBetBrackets => '中括弧の間にx、y、zを配置します。';

  @override
  String get onlineSourcesPage_pleaseEnterValidTmsUrl => '有効なTMS URLを入力してください';

  @override
  String get onlineSourcesPage_enterUrl => 'URLを入力';

  @override
  String get onlineSourcesPage_enterSubDomains => 'サブドメインを入力してください';

  @override
  String get onlineSourcesPage_addAttribution => '帰属を追加します。';

  @override
  String get onlineSourcesPage_enterAttribution => '帰属を入力';

  @override
  String get onlineSourcesPage_setMinMaxZoom => '最小ズームと最大ズームを設定します。';

  @override
  String get onlineSourcesPage_minZoom => '最小ズーム';

  @override
  String get onlineSourcesPage_maxZoom => '最大ズーム';

  @override
  String get onlineSourcesPage_pleaseCheckYourData => 'データを確認してください';

  @override
  String get onlineSourcesPage_details => '詳細';

  @override
  String get onlineSourcesPage_name => '名前: ';

  @override
  String get onlineSourcesPage_subDomains => 'サブドメイン: ';

  @override
  String get onlineSourcesPage_attribution => '帰属: ';

  @override
  String get onlineSourcesPage_cancel => 'キャンセル';

  @override
  String get onlineSourcesPage_ok => 'OK';

  @override
  String get onlineSourcesPage_newTmsOnlineService => '新しいTMSオンラインサービス';

  @override
  String get onlineSourcesPage_save => '保存';

  @override
  String get onlineSourcesPage_theBaseUrlWithQuestionMark => '疑問符で終わるベースURL。';

  @override
  String get onlineSourcesPage_pleaseEnterValidWmsUrl => '有効なWMS URLを入力してください';

  @override
  String get onlineSourcesPage_setWmsLayerName => 'WMSレイヤー名を設定';

  @override
  String get onlineSourcesPage_enterLayerToLoad => 'ロードするレイヤーを入力してください';

  @override
  String get onlineSourcesPage_pleaseEnterValidLayer => '有効なレイヤーを入力してください';

  @override
  String get onlineSourcesPage_setWmsImageFormat => 'WMS画像形式を設定';

  @override
  String get onlineSourcesPage_addAnAttribution => '帰属を追加します。';

  @override
  String get onlineSourcesPage_layer => 'レイヤー: ';

  @override
  String get onlineSourcesPage_url => 'URL: ';

  @override
  String get onlineSourcesPage_format => 'フォーマット';

  @override
  String get onlineSourcesPage_newWmsOnlineService => '新しいWMSオンラインサービス';

  @override
  String get remoteDbPage_remoteDatabases => 'リモートデータベース';

  @override
  String get remoteDbPage_delete => '削除';

  @override
  String get remoteDbPage_areYouSureDeleteDatabase => 'データベース構成を削除してもよろしいですか？';

  @override
  String get remoteDbPage_edit => '編集';

  @override
  String get remoteDbPage_table => 'table';

  @override
  String get remoteDbPage_user => 'user';

  @override
  String get remoteDbPage_loadInMap => 'マップにロードします。';

  @override
  String get remoteDbPage_databaseParameters => 'データベースパラメータ';

  @override
  String get remoteDbPage_cancel => 'キャンセル';

  @override
  String get remoteDbPage_ok => 'OK';

  @override
  String get remoteDbPage_theUrlNeedsToBeDefined => 'URLを定義する必要があります（postgis:host:port / dbname）';

  @override
  String get remoteDbPage_theUserNeedsToBeDefined => 'ユーザーを定義する必要があります。';

  @override
  String get remoteDbPage_password => 'パスワード';

  @override
  String get remoteDbPage_thePasswordNeedsToBeDefined => 'パスワードを定義する必要があります。';

  @override
  String get remoteDbPage_loadingTables => 'テーブルを読み込んでいます…';

  @override
  String get remoteDbPage_theTableNeedsToBeDefined => 'テーブル名を定義する必要があります。';

  @override
  String get remoteDbPage_unableToConnectToDatabase => 'データベースに接続できません。パラメータとネットワークを確認してください。';

  @override
  String get remoteDbPage_optionalWhereCondition => 'オプションの \"where\" 条件';

  @override
  String get geoImage_tiffProperties => 'TIFFプロパティ';

  @override
  String get geoImage_opacity => '不透明度';

  @override
  String get geoImage_colorToHide => '非表示にする色';

  @override
  String get gpx_gpxProperties => 'GPXプロパティ';

  @override
  String get gpx_wayPoints => 'ウェイポイント';

  @override
  String get gpx_color => '色';

  @override
  String get gpx_size => 'サイズ';

  @override
  String get gpx_viewLabelsIfAvailable => '利用可能な場合はラベルを表示しますか？';

  @override
  String get gpx_tracksRoutes => 'トラック/ルート';

  @override
  String get gpx_width => '幅';

  @override
  String get gpx_palette => 'パレット';

  @override
  String get tiles_tileProperties => 'タイルプロパティ';

  @override
  String get tiles_opacity => '不透明度';

  @override
  String get tiles_loadGeoPackageAsOverlay => 'GeoPackageタイルをタイルレイヤーではなくオーバーレイ画像としてロードします（gdalで生成されたデータやさまざまな投影法に最適）。';

  @override
  String get tiles_colorToHide => '非表示にする色';

  @override
  String get wms_wmsProperties => 'WMSプロパティ';

  @override
  String get wms_opacity => '不透明度';

  @override
  String get featureAttributesViewer_loadingData => 'データを読み込んでいます…';

  @override
  String get featureAttributesViewer_setNewValue => '新しい値を設定';

  @override
  String get featureAttributesViewer_field => 'フィールド';

  @override
  String get featureAttributesViewer_value => '値';

  @override
  String get projectsView_projectsView => 'プロジェクトビュー';

  @override
  String get projectsView_openExistingProject => '既存のプロジェクトを開く';

  @override
  String get projectsView_createNewProject => '新しいプロジェクトを作成する';

  @override
  String get projectsView_recentProjects => '最近のプロジェクト';

  @override
  String get projectsView_newProject => '新しいプロジェクト';

  @override
  String get projectsView_enterNameForNewProject => '新しいプロジェクトの名前を入力するか、提案を受け入れます。';

  @override
  String get dataLoader_note => 'note';

  @override
  String get dataLoader_Note => '注';

  @override
  String get dataLoader_hasForm => 'Has Form';

  @override
  String get dataLoader_POI => 'POI';

  @override
  String get dataLoader_savingImageToDB => '画像をdbに保存しています…';

  @override
  String get dataLoader_removeNote => 'ノートを削除';

  @override
  String get dataLoader_areYouSureRemoveNote => 'ノートを削除してもよろしいですか？';

  @override
  String get dataLoader_image => '画像';

  @override
  String get dataLoader_longitude => '経度';

  @override
  String get dataLoader_latitude => '緯度';

  @override
  String get dataLoader_altitude => '高度';

  @override
  String get dataLoader_timestamp => 'Timestamp';

  @override
  String get dataLoader_removeImage => '画像の削除';

  @override
  String get dataLoader_areYouSureRemoveImage => '画像を削除してもよろしいですか？';

  @override
  String get images_loadingImage => '画像を読み込んでいます…';

  @override
  String get about_loadingInformation => '情報を読み込んでいます…';

  @override
  String get about_ABOUT => 'SMASHについて ';

  @override
  String get about_smartMobileAppForSurveyor => '測量士の幸福のためのスマートモバイルアプリ';

  @override
  String get about_applicationVersion => 'バージョン';

  @override
  String get about_license => 'ライセンス';

  @override
  String get about_isAvailableUnderGPL3 => ' コピーレフトの自由ソフトウェアで、GPL v3以上でライセンスされています。';

  @override
  String get about_sourceCode => 'ソースコード';

  @override
  String get about_tapHereToVisitRepo => 'ここをタップしてソースコードリポジトリにアクセスしてください';

  @override
  String get about_legalInformation => '法的情報';

  @override
  String get about_copyright2020HydroloGIS => 'Copyright © 2020, HydroloGIS S.r.l. — 一部の権利は留保されています。タップしてアクセスしてください。';

  @override
  String get about_supportedBy => 'スポンサー';

  @override
  String get about_partiallySupportedByUniversityTrento => 'トレント大学のプロジェクトSteep Streamによって部分的にサポートされています。';

  @override
  String get about_privacyPolicy => 'プライバシーポリシー';

  @override
  String get about_tapHereToSeePrivacyPolicy => 'ここをタップすると、ユーザーと位置データを対象とするプライバシーポリシーが表示されます。';

  @override
  String get gpsInfoButton_noGpsInfoAvailable => '利用可能なGPS情報がありません…';

  @override
  String get gpsInfoButton_timestamp => 'タイムスタンプ';

  @override
  String get gpsInfoButton_speed => '速度';

  @override
  String get gpsInfoButton_heading => '方位角';

  @override
  String get gpsInfoButton_accuracy => '精度';

  @override
  String get gpsInfoButton_altitude => '高度';

  @override
  String get gpsInfoButton_latitude => '緯度';

  @override
  String get gpsInfoButton_copyLatitudeToClipboard => '緯度をクリップボードにコピーします。';

  @override
  String get gpsInfoButton_longitude => '経度';

  @override
  String get gpsInfoButton_copyLongitudeToClipboard => '経度をクリップボードにコピーします。';

  @override
  String get gpsLogButton_stopLogging => 'ロギングを停止しますか？';

  @override
  String get gpsLogButton_stopLoggingAndCloseLog => 'ロギングを停止して現在のGPSログを閉じますか？';

  @override
  String get gpsLogButton_newLog => '新しいログ';

  @override
  String get gpsLogButton_enterNameForNewLog => '新しいログの名前を入力してください';

  @override
  String get gpsLogButton_couldNotStartLogging => 'ロギングを開始できませんでした: ';

  @override
  String get imageWidgets_loadingImage => '画像を読み込んでいます…';

  @override
  String get logList_gpsLogsList => 'GPSログリスト';

  @override
  String get logList_selectAll => 'すべて選択';

  @override
  String get logList_unSelectAll => 'すべて選択解除';

  @override
  String get logList_invertSelection => '選択を反転';

  @override
  String get logList_mergeSelected => 'マージが選択されました';

  @override
  String get logList_loadingLogs => 'ログを読み込んでいます…';

  @override
  String get logList_zoomTo => 'ズーム';

  @override
  String get logList_properties => 'プロパティ';

  @override
  String get logList_profileView => 'プロファイルビュー';

  @override
  String get logList_toGPX => 'GPXへ';

  @override
  String get logList_gpsSavedInExportFolder => 'GPXはエクスポートフォルダーに保存されました。';

  @override
  String get logList_errorOccurredExportingLogGPX => 'ログをGPXにエクスポート中にエラーが発生しました。';

  @override
  String get logList_delete => '削除';

  @override
  String get logList_DELETE => '削除';

  @override
  String get logList_areYouSureDeleteTheLog => 'ログを削除してもよろしいですか？';

  @override
  String get logList_hours => '時間';

  @override
  String get logList_hour => '時間';

  @override
  String get logList_minutes => '分';

  @override
  String get logProperties_gpsLogProperties => 'GPSログプロパティ';

  @override
  String get logProperties_logName => 'ログ名';

  @override
  String get logProperties_start => '開始';

  @override
  String get logProperties_end => '終了';

  @override
  String get logProperties_duration => '期間';

  @override
  String get logProperties_color => '色';

  @override
  String get logProperties_palette => 'パレット';

  @override
  String get logProperties_width => '幅';

  @override
  String get logProperties_distanceAtPosition => '位置での距離:';

  @override
  String get logProperties_totalDistance => '合計距離:';

  @override
  String get logProperties_gpsLogView => 'GPSログビュー';

  @override
  String get logProperties_disableStats => '統計を無効にする';

  @override
  String get logProperties_enableStats => '統計を有効にする';

  @override
  String get logProperties_totalDuration => '合計期間:';

  @override
  String get logProperties_timestamp => 'タイムスタンプ:';

  @override
  String get logProperties_durationAtPosition => '位置での期間:';

  @override
  String get logProperties_speed => '速度:';

  @override
  String get logProperties_elevation => '標高:';

  @override
  String get noteList_simpleNotesList => 'シンプルノートリスト';

  @override
  String get noteList_formNotesList => 'フォームノートリスト';

  @override
  String get noteList_loadingNotes => 'ノートを読み込んでいます…';

  @override
  String get noteList_zoomTo => 'ズーム';

  @override
  String get noteList_edit => '編集';

  @override
  String get noteList_properties => 'プロパティ';

  @override
  String get noteList_delete => '削除';

  @override
  String get noteList_DELETE => '削除';

  @override
  String get noteList_areYouSureDeleteNote => 'ノートを削除してもよろしいですか？';

  @override
  String get settings_settings => '設定';

  @override
  String get settings_camera => 'カメラ';

  @override
  String get settings_cameraResolution => 'カメラの解像度';

  @override
  String get settings_resolution => '解像度';

  @override
  String get settings_theCameraResolution => 'カメラの解像度';

  @override
  String get settings_screen => '画面';

  @override
  String get settings_screenScaleBarIconSize => '画面、スケールバー、アイコンのサイズ';

  @override
  String get settings_keepScreenOn => '画面をオンに保つ';

  @override
  String get settings_retinaScreenMode => 'HiDPIスクリーンモード';

  @override
  String get settings_toApplySettingEnterExitLayerView => 'この設定を適用するには、レイヤービューを開始および終了する必要があります。';

  @override
  String get settings_colorPickerToUse => '使用するカラーピッカー';

  @override
  String get settings_mapCenterCross => '地図中心の十字';

  @override
  String get settings_color => '色';

  @override
  String get settings_size => 'サイズ';

  @override
  String get settings_width => '幅';

  @override
  String get settings_mapToolsIconSize => 'マップツールのアイコンサイズ';

  @override
  String get settings_gps => 'GPS';

  @override
  String get settings_gpsFiltersAndMockLoc => 'GPSフィルターとモックロケーション';

  @override
  String get settings_livePreview => 'ライブプレビュー';

  @override
  String get settings_noPointAvailableYet => 'まだ利用可能なポイントはありません。';

  @override
  String get settings_longitudeDeg => '経度 [deg]';

  @override
  String get settings_latitudeDeg => '緯度 [deg]';

  @override
  String get settings_accuracyM => '精度 [m]';

  @override
  String get settings_altitudeM => '高度 [m]';

  @override
  String get settings_headingDeg => '方位角 [deg]';

  @override
  String get settings_speedMS => '速度 [m/s]';

  @override
  String get settings_isLogging => 'ロギング中？';

  @override
  String get settings_mockLocations => 'モックロケーション？';

  @override
  String get settings_minDistFilterBlocks => '最小距離フィルターブロック';

  @override
  String get settings_minDistFilterPasses => '最小距離フィルターパス';

  @override
  String get settings_minTimeFilterBlocks => '最小時間フィルターブロック';

  @override
  String get settings_minTimeFilterPasses => '最小時間フィルターパス';

  @override
  String get settings_hasBeenBlocked => 'フィルターによるブロック';

  @override
  String get settings_distanceFromPrevM => '前回測位点からの距離 [m]';

  @override
  String get settings_timeFromPrevS => '前回測位時からの時間 [s]';

  @override
  String get settings_locationInfo => '位置情報';

  @override
  String get settings_filters => 'フィルター';

  @override
  String get settings_disableFilters => 'フィルターを無効にします。';

  @override
  String get settings_enableFilters => 'フィルターを有効にします。';

  @override
  String get settings_zoomIn => '拡大';

  @override
  String get settings_zoomOut => '縮小';

  @override
  String get settings_activatePointFlow => 'ポイントフローをアクティブ化します。';

  @override
  String get settings_pausePointsFlow => '一時停止ポイントフロー。';

  @override
  String get settings_visualizePointCount => 'ポイント数を視覚化';

  @override
  String get settings_showGpsPointsValidPoints => '有効なポイントのGPSポイント数を表示します。';

  @override
  String get settings_showGpsPointsAllPoints => 'すべてのポイントのGPSポイント数を表示します。';

  @override
  String get settings_logFilters => 'ログフィルター';

  @override
  String get settings_minDistanceBetween2Points => '2点間の最小距離。';

  @override
  String get settings_minTimespanBetween2Points => '2点間の最小時間間隔。';

  @override
  String get settings_gpsFilter => 'GPSフィルター';

  @override
  String get settings_disable => '無効';

  @override
  String get settings_enable => '有効';

  @override
  String get settings_theUseOfTheGps => 'フィルタリングされたGPSの使用。';

  @override
  String get settings_warningThisWillAffectGpsPosition => '警告: これはGPS位置、ノートの挿入、ログ統計およびグラフに影響します。';

  @override
  String get settings_MockLocations => 'モックロケーション';

  @override
  String get settings_testGpsLogDemoUse => 'デモ用のGPSログのテスト。';

  @override
  String get settings_setDurationGpsPointsInMilli => 'GPSポイントの継続時間をミリ秒単位で設定します。';

  @override
  String get settings_SETTING => '設定';

  @override
  String get settings_setMockedGpsDuration => 'モックされたGPSの期間を設定';

  @override
  String get settings_theValueHasToBeInt => '値は整数である必要があります。';

  @override
  String get settings_milliseconds => 'ミリ秒';

  @override
  String get settings_useGoogleToImproveLoc => 'Googleサービスを使用してロケーションを改善する';

  @override
  String get settings_useOfGoogleServicesRestart => 'Googleサービスの使用（アプリの再起動が必要）';

  @override
  String get settings_gpsLogsViewMode => 'GPSログビューモード';

  @override
  String get settings_logViewModeForOrigData => '元のデータのログビューモード。';

  @override
  String get settings_logViewModeFilteredData => 'フィルタリングされたデータのログビューモード。';

  @override
  String get settings_cancel => 'キャンセル';

  @override
  String get settings_ok => 'OK';

  @override
  String get settings_notesViewModes => 'ノートビューモード';

  @override
  String get settings_selectNotesViewMode => 'ノートビューモードを選択してください。';

  @override
  String get settings_mapPlugins => 'マッププラグイン';

  @override
  String get settings_vectorLayers => 'ベクターレイヤー';

  @override
  String get settings_loadingOptionsInfoTool => 'ロードオプションと情報ツール';

  @override
  String get settings_dataLoading => 'データの読み込み';

  @override
  String get settings_maxNumberFeatures => '地物の最大数';

  @override
  String get settings_maxNumFeaturesPerLayer => 'レイヤーごとの地物の最大数。適用するには、レイヤーを削除して追加します。';

  @override
  String get settings_all => '全部';

  @override
  String get settings_loadMapArea => '地図領域を読み込み。';

  @override
  String get settings_loadOnlyLastVisibleArea => '最後に表示された地図領域のみ読み込みます。適用するには、レイヤーを削除して追加し直します。';

  @override
  String get settings_infoTool => '情報ツール';

  @override
  String get settings_tapSizeInfoToolPixels => '情報ツールのタップサイズ（ピクセル単位）';

  @override
  String get settings_editingTool => '編集ツール';

  @override
  String get settings_editingDragIconSize => '編集時のドラッグハンドラーアイコンサイズ。';

  @override
  String get settings_editingIntermediateDragIconSize => '編集時の中間ドラッグハンドラーアイコンサイズ。';

  @override
  String get settings_diagnostics => '診断';

  @override
  String get settings_diagnosticsDebugLog => '診断とデバッグログ';

  @override
  String get settings_openFullDebugLog => '完全なデバッグログを開く';

  @override
  String get settings_debugLogView => 'デバッグログビュー';

  @override
  String get settings_viewAllMessages => 'すべてのメッセージを表示';

  @override
  String get settings_viewOnlyErrorsWarnings => 'エラーと警告のみを表示';

  @override
  String get settings_clearDebugLog => 'デバッグログをクリア';

  @override
  String get settings_loadingData => 'データを読み込んでいます…';

  @override
  String get settings_device => 'デバイス';

  @override
  String get settings_deviceIdentifier => 'デバイス識別子';

  @override
  String get settings_deviceId => 'デバイスID';

  @override
  String get settings_overrideDeviceId => 'デバイスIDを上書き';

  @override
  String get settings_overrideId => 'オーバーライドID';

  @override
  String get settings_pleaseEnterValidPassword => '有効なサーバーパスワードを入力してください。';

  @override
  String get settings_gss => 'GSS';

  @override
  String get settings_geopaparazziSurveyServer => 'Geopaparazzi Survey Server';

  @override
  String get settings_serverUrl => 'サーバーURL';

  @override
  String get settings_serverUrlStartWithHttp => 'サーバーのURLはhttpまたはhttpsで始まる必要があります。';

  @override
  String get settings_serverPassword => 'サーバーパスワード';

  @override
  String get settings_allowSelfSignedCert => '自己署名証明書を許可する';

  @override
  String get toolbarTools_zoomOut => '縮小';

  @override
  String get toolbarTools_zoomIn => '拡大';

  @override
  String get toolbarTools_cancelCurrentEdit => '現在の編集をキャンセルします。';

  @override
  String get toolbarTools_saveCurrentEdit => '現在の編集を保存します。';

  @override
  String get toolbarTools_insertPointMapCenter => 'マップの中心にポイントを挿入します。';

  @override
  String get toolbarTools_insertPointGpsPos => 'GPS位置にポイントを挿入します。';

  @override
  String get toolbarTools_removeSelectedFeature => '選択した地物を削除します。';

  @override
  String get toolbarTools_showFeatureAttributes => '地物属性を表示します。';

  @override
  String get toolbarTools_featureDoesNotHavePrimaryKey => '地物に主キーがありません。編集は許可されていません。';

  @override
  String get toolbarTools_queryFeaturesVectorLayers => '読み込まれたベクターレイヤーから地物をクエリします。';

  @override
  String get toolbarTools_measureDistanceWithFinger => '指で地図上の距離を測定します。';

  @override
  String get toolbarTools_modifyGeomVectorLayers => '編集可能なベクターレイヤーのジオメトリを変更します。';

  @override
  String get coachMarks_singleTap => 'シングルタップ: ';

  @override
  String get coachMarks_longTap => 'ロングタップ: ';

  @override
  String get coachMarks_doubleTap => 'ダブルタップ: ';

  @override
  String get coachMarks_simpleNoteButton => 'シンプルノートボタン';

  @override
  String get coachMarks_addNewNote => '新しいノートを追加';

  @override
  String get coachMarks_viewNotesList => 'ノートリストを表示';

  @override
  String get coachMarks_viewNotesSettings => 'ノートの設定を表示';

  @override
  String get coachMarks_formNotesButton => 'フォームノートボタン';

  @override
  String get coachMarks_addNewFormNote => '新しいフォームノートを追加';

  @override
  String get coachMarks_viewFormNoteList => 'フォームノートリストを表示';

  @override
  String get coachMarks_gpsLogButton => 'GPSログボタン';

  @override
  String get coachMarks_startStopLogging => 'ロギングの開始/ロギングの停止';

  @override
  String get coachMarks_viewLogsList => 'ログリストの表示';

  @override
  String get coachMarks_viewLogsSettings => 'ログ設定の表示';

  @override
  String get coachMarks_gpsInfoButton => 'GPS情報ボタン（該当する場合）';

  @override
  String get coachMarks_centerMapOnGpsPos => 'GPS位置を地図中心へ';

  @override
  String get coachMarks_showGpsInfo => 'GPS情報を表示';

  @override
  String get coachMarks_toggleAutoCenterGps => 'GPS位置の自動中心表示の切り替え';

  @override
  String get coachMarks_layersViewButton => 'レイヤービューボタン';

  @override
  String get coachMarks_openLayersView => 'レイヤービューを開く';

  @override
  String get coachMarks_openLayersPluginDialog => 'レイヤープラグインダイアログを開く';

  @override
  String get coachMarks_zoomInButton => '拡大ボタン';

  @override
  String get coachMarks_zoomImMapOneLevel => '地図を1レベル拡大';

  @override
  String get coachMarks_zoomOutButton => '縮小ボタン';

  @override
  String get coachMarks_zoomOutMapOneLevel => '地図を1レベル縮小';

  @override
  String get coachMarks_bottomToolsButton => '下部ツールボタン';

  @override
  String get coachMarks_toggleBottomToolsBar => '下部のツールバーを切り替えます。 ';

  @override
  String get coachMarks_toolsButton => 'ツールボタン';

  @override
  String get coachMarks_openEndDrawerToAccessProject => 'エンドドロワーを開いて、プロジェクト情報と共有オプション、マッププラグイン、機能ツールその他にアクセスします。';

  @override
  String get coachMarks_interactiveCoackMarksButton => 'インタラクティブコーチマークボタン';

  @override
  String get coachMarks_openInteractiveCoachMarks => 'メインマップビューのすべてのアクションを説明するインタラクティブコーチマークを開きます。';

  @override
  String get coachMarks_mainMenuButton => 'メインメニューボタン';

  @override
  String get coachMarks_openDrawerToLoadProject => 'ドロワーを開いて、プロジェクトの読み込み/作成、データのインポート/エクスポート、サーバーとの同期、設定へのアクセスとアプリ終了、GPSのオフが可能です。';

  @override
  String get coachMarks_skip => 'スキップ';

  @override
  String get network_cancelledByUser => 'ユーザーによってキャンセルされました。';

  @override
  String get network_completed => '完了しました。';

  @override
  String get network_buildingBaseCachePerformance => 'パフォーマンス向上のためのベースキャッシュの構築（時間がかかる場合があります）…';

  @override
  String get network_thisFIleAlreadyBeingDownloaded => 'このファイルはすでにダウンロード中です。';

  @override
  String get network_download => 'ダウンロード';

  @override
  String get network_downloadFile => 'ファイル';

  @override
  String get network_toTheDeviceTakeTime => 'をデバイスにダウンロードしますか？ これには時間がかかる場合があります。';

  @override
  String get network_availableMaps => '利用可能なマップ';

  @override
  String get network_searchMapByName => 'マップを名前で検索';

  @override
  String get network_uploading => 'アップロード';

  @override
  String get network_pleaseWait => 'お待ちください…';

  @override
  String get network_permissionOnServerDenied => 'サーバーへのアクセスが拒否されました。';

  @override
  String get network_couldNotConnectToServer => 'サーバーに接続できませんでした。オンラインですか？ アドレスを確認してください。';

  @override
  String get form_smash_cantSaveImageDb => '画像をデータベースに保存できませんでした。';

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
