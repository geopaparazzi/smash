part of smash_import_export;

/*
 * Copyright (c) 2019-2026. Antonello Andrea (https://g-ant.eu). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

class GssExportPlugin extends AExportPlugin {
  late ProjectDb projectDb;
  late BuildContext context;

  @override
  void setContext(BuildContext context) {
    this.context = context;
  }

  @override
  Icon getIcon() {
    return Icon(
      MdiIcons.cloudLock,
      color: SmashColors.mainDecorations,
    );
  }

  @override
  String getTitle() {
    return "GSS";
  }

  @override
  String getDescription() {
    return SL.of(context).exportWidget_exportToGSS;
  }

  @override
  void setProjectDatabase(ProjectDb projectDb) {
    this.projectDb = projectDb;
  }

  @override
  Widget getExportPage() {
    return GssExportWidget(
      projectDb,
    );
  }

  @override
  Widget getSettingsPage() {
    return GssSettings();
  }
}

class GssExportWidget extends StatefulWidget {
  final ProjectDb projectDb;

  GssExportWidget(this.projectDb, {Key? key}) : super(key: key);

  @override
  _GssExportWidgetState createState() => new _GssExportWidgetState();
}

class _GssExportWidgetState extends State<GssExportWidget> {
  /*
   * 0 = loading data stats
   * 1 = show data stats
   * 2 = uploading data
   *
   * 10 = no no token available
   * 11 = no server url available
   * 12 = upload error
   * 100 = generic error
   *
   * if no project is selected, the user is redirected to GssSettings.
   */
  int _status = 0;

  late String _genericErrorMessage;
  late Map<String, String> tokenHeader;

  Project? _selectedProject;

  String? _serverUrl;

  late int _gpsLogCount;
  late int _simpleNotesCount;
  late int _formNotesCount;
  late int _imagesCount;

  List<Widget> _uploadTiles = [];

  @override
  void initState() {
    init();

    super.initState();
  }

  Future<void> init() async {
    String? selectedProjectJson = GpPreferences()
        .getStringSync(SmashPreferencesKeys.KEY_GSS_DJANGO_SERVER_PROJECT);
    if (selectedProjectJson == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => GssSettings()),
          );
        }
      });
      return;
    }
    _selectedProject = Project.fromJson(selectedProjectJson!);

    var token = ServerApi.getGssToken();
    if (token == null) {
      setState(() {
        _status = 10;
      });
      return;
    }
    tokenHeader = ServerApi.getTokenHeader();

    _serverUrl = GpPreferences()
        .getStringSync(SmashPreferencesKeys.KEY_GSS_DJANGO_SERVER_URL);
    if (_serverUrl == null) {
      setState(() {
        _status = 11;
      });
      return;
    }
    if (_serverUrl!.endsWith("/")) {
      _serverUrl = _serverUrl!.substring(0, _serverUrl!.length - 1);
    }

    /*
     * now gather data stats from db
     */
    gatherStats();
  }

  gatherStats() {
    /*
     * now gather data stats from db
     */
    var db = widget.projectDb;
    _gpsLogCount = db.getGpsLogCount(true);
    _simpleNotesCount = db.getSimpleNotesCount(true);
    _formNotesCount = db.getFormNotesCount(true);
    _imagesCount = db.getImagesCount(true);

    var allCount =
        _gpsLogCount + _simpleNotesCount + _formNotesCount + _imagesCount;
    setState(() {
      _status = allCount > 0 ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(SL.of(context).gssExport_gssExport), //"GSS Export"
        actions: _status < 2
            ? <Widget>[
                IconButton(
                  icon: Icon(MdiIcons.restore),
                  onPressed: () async {
                    var doIt = await SmashDialogs.showConfirmDialog(
                            context,
                            SL.of(context).gssExport_setProjectDirty,
                            SL.of(context).gssExport_thisCantBeUndone) ??
                        false; //"Set project to DIRTY?" //"This can't be undone!"
                    if (doIt) {
                      widget.projectDb.updateDirty(true);
                      setState(() {
                        _status = 0;
                      });
                      gatherStats();
                    }
                  },
                  tooltip: SL
                      .of(context)
                      .gssExport_restoreProjectAsDirty, //"Restore project as all dirty."
                ),
                IconButton(
                  icon: Icon(MdiIcons.wiperWash),
                  onPressed: () async {
                    var doIt = await SmashDialogs.showConfirmDialog(
                            context,
                            SL.of(context).gssExport_setProjectClean,
                            SL.of(context).gssExport_thisCantBeUndone) ??
                        false; //"Set project to CLEAN?" //"This can't be undone!"
                    if (doIt) {
                      widget.projectDb.updateDirty(false);
                      setState(() {
                        _status = 0;
                      });
                      gatherStats();
                    }
                  },
                  tooltip: SL
                      .of(context)
                      .gssExport_restoreProjectAsClean, //"Restore project as all clean."
                ),
              ]
            : <Widget>[],
      ),
      body: _status == -1
          ? Center(
              child: SmashUI.errorWidget(
                  SL.of(context).gssExport_nothingToSync,
                  bold: true)) //"Nothing to sync."
          : _status == 0
              ? Center(
                  child: SmashCircularProgress(
                      label: SL
                          .of(context)
                          .gssExport_collectingSyncStats), //"Collecting sync stats..."
                )
              : _status == 12
                  ? Center(
                      child: Padding(
                        padding: SmashUI.defaultPadding(),
                        child: SmashUI.errorWidget(SL
                            .of(context)
                            .gssExport_unableToSyncDueToError), //"Unable to sync due to an error, check diagnostics."
                      ),
                    )
                  : _status == 11
                      ? Center(
                          child: Padding(
                            padding: SmashUI.defaultPadding(),
                            child: SmashUI.titleText(SL
                                .of(context)
                                .gssExport_noGssUrlSet), //"No GSS server url has been set. Check your settings."
                          ),
                        )
                      : _status == 10
                          ? Center(
                              child: Padding(
                                padding: SmashUI.defaultPadding(),
                                child: SmashUI.titleText(
                                    "No access token available. Check your settings."),
                              ),
                            )
                          : _status == 1
                              ? // View stats
                              Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        child: Card(
                                          margin: SmashUI.defaultMargin(),
                                          elevation: SmashUI.DEFAULT_ELEVATION,
                                          color: SmashColors.mainBackground,
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    SmashUI.defaultPadding(),
                                                child: SmashUI.titleText(
                                                    _selectedProject!.name,
                                                    bold: true,
                                                    color: SmashColors
                                                        .mainSelection),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: SmashUI.defaultPadding(),
                                        child: SmashUI.titleText(
                                            SL
                                                .of(context)
                                                .gssExport_synStats, //"Sync Stats"
                                            bold: true),
                                      ),
                                      Padding(
                                        padding: SmashUI.defaultPadding(),
                                        child: SmashUI.smallText(
                                            SL
                                                .of(context)
                                                .gssExport_followingDataWillBeUploaded,
                                            color: Colors
                                                .grey), //"The following data will be uploaded upon sync."
                                      ),
                                      Expanded(
                                        child: ListView(
                                          children: <Widget>[
                                            ListTile(
                                              leading: Icon(
                                                SmashIcons.logIcon,
                                                color:
                                                    SmashColors.mainDecorations,
                                              ),
                                              title: SmashUI.normalText(
                                                  "${SL.of(context).gssExport_gpsLogs} $_gpsLogCount"), //"Gps Logs:"
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                SmashIcons.simpleNotesIcon,
                                                color:
                                                    SmashColors.mainDecorations,
                                              ),
                                              title: SmashUI.normalText(
                                                  "${SL.of(context).gssExport_simpleNotes} $_simpleNotesCount"), //"Simple Notes:"
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                SmashIcons.formNotesIcon,
                                                color:
                                                    SmashColors.mainDecorations,
                                              ),
                                              title: SmashUI.normalText(
                                                  "${SL.of(context).gssExport_formNotes} $_formNotesCount"), //"Form Notes:"
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                SmashIcons.imagesNotesIcon,
                                                color:
                                                    SmashColors.mainDecorations,
                                              ),
                                              title: SmashUI.normalText(
                                                  "${SL.of(context).gssExport_images} $_imagesCount"), //"Images:"
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : _status == 2
                                  ? Center(
                                      child: ListView(
                                        children: _uploadTiles,
                                      ),
                                    )
                                  : Container(
                                      child: Text(SL
                                          .of(context)
                                          .gssExport_shouldNotHappen), //"Should not happen"
                                    ),
      floatingActionButton: _status < 2 && _status != -1
          ? FloatingActionButton.extended(
              icon: Icon(SmashIcons.upload),
              onPressed: () async {
                if (!await NetworkUtilities.isConnected()) {
                  SmashDialogs.showOperationNeedsNetwork(context);
                } else {
                  await uploadProjectData();
                }
              },
              label: Text(SL.of(context).gssExport_upload)) //"Upload"
          : null,
    );
  }

  Future uploadProjectData() async {
    var db = widget.projectDb;
    Dio dio = NetworkHelper.getNewDioInstance();
    ValueNotifier<int> uploadOrder = ValueNotifier<int>(0);
    int order = 0;

    _uploadTiles = [];
    List<Note> simpleNotes = db.getNotes(doSimple: true, onlyDirty: true);
    for (var note in simpleNotes) {
      var uploadWidget = ProjectDataUploadListTileProgressWidget(
        dio,
        db,
        note,
        orderNotifier: uploadOrder,
        order: order++,
      );
      _uploadTiles.add(uploadWidget);
    }
    List<Note> formNotes = db.getNotes(doSimple: false, onlyDirty: true);
    for (var note in formNotes) {
      var uploadWidget = ProjectDataUploadListTileProgressWidget(
        dio,
        db,
        note,
        orderNotifier: uploadOrder,
        order: order++,
      );
      _uploadTiles.add(uploadWidget);
    }
    List<DbImage> imagesList = db.getImages(onlyDirty: true);
    for (var image in imagesList) {
      var uploadWidget = ProjectDataUploadListTileProgressWidget(
        dio,
        db,
        image,
        orderNotifier: uploadOrder,
        order: order++,
      );
      _uploadTiles.add(uploadWidget);
    }

    List<Log> logsList = db.getLogs(onlyDirty: true);
    for (var log in logsList) {
      var uploadWidget = ProjectDataUploadListTileProgressWidget(
        dio,
        db,
        log,
        orderNotifier: uploadOrder,
        order: order++,
      );
      _uploadTiles.add(uploadWidget);
    }

    setState(() {
      _status = 2;
    });
  }
}
