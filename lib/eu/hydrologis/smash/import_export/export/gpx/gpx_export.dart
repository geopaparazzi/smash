part of smash_import_export;

/*
 * Copyright (c) 2019-2026. Antonello Andrea (https://g-ant.eu). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

const TITLE_GPX = "GPX";

class GpxExportPlugin extends AExportPlugin {
  late ProjectDb projectDb;
  late BuildContext context;

  @override
  void setContext(BuildContext context) {
    this.context = context;
  }

  @override
  Icon getIcon() {
    return Icon(
      MdiIcons.mapMarker,
      color: SmashColors.mainDecorations,
    );
  }

  @override
  String getTitle() {
    return TITLE_GPX;
  }

  @override
  String getDescription() {
    return SL.of(context).exportWidget_exportToGpx;
  }

  @override
  void setProjectDatabase(ProjectDb projectDb) {
    this.projectDb = projectDb;
  }

  @override
  Widget getExportPage() {
    return GpxExportWidget(
      projectDb: projectDb,
    );
  }

  @override
  Widget? getSettingsPage() {
    return null;
  }
}

class GpxExportWidget extends StatefulWidget {
  final ProjectDb projectDb;
  GpxExportWidget({Key? key, required this.projectDb}) : super(key: key);

  @override
  State<GpxExportWidget> createState() => _GpxExportWidgetState();
}

class _GpxExportWidgetState extends State<GpxExportWidget>
    with AfterLayoutMixin {
  bool building = true;
  late String outFilePath;

  @override
  void afterFirstLayout(BuildContext context) {
    buildGpx();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(TITLE_GPX)),
        body: building
            ? Center(
                child: SmashCircularProgress(),
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SmashUI.titleText(
                      SL.of(context).exportWidget_gpxExported,
                    ),
                    SmashUI.smallText(
                      outFilePath,
                    ),
                  ],
                ),
              ));
  }

  Future<void> buildGpx() async {
    var exportsFolder = await Workspace.getExportsFolder();
    var ts = HU.TimeUtilities.DATE_TS_FORMATTER.format(DateTime.now());
    outFilePath =
        HU.FileUtilities.joinPaths(exportsFolder.path, "smash_export_$ts.gpx");

    await GpxExporter.exportDb(widget.projectDb, File(outFilePath), false);

    setState(() {
      building = false;
    });
  }
}
