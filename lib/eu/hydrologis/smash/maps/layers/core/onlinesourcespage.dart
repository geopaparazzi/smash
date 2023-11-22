import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/smash/l10n/localization.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

class OnlineSourcesPage extends StatefulWidget {
  OnlineSourcesPage({Key? key}) : super(key: key);

  @override
  _OnlineSourcesPageState createState() => _OnlineSourcesPageState();
}

class _OnlineSourcesPageState extends State<OnlineSourcesPage>
    with AfterLayoutMixin {
  List<Widget>? _tmsCardsList;
  List<String> _tmsSourcesList = [];
  List<Widget>? _wmsCardsList;
  List<String> _wmsSourcesList = [];
  ValueNotifier<int> reloadNotifier = ValueNotifier<int>(0);

  void afterFirstLayout(BuildContext context) {
    reloadNotifier.addListener(() async {
      await getList();
    });
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(SL
              .of(context)
              .onlineSourcesPage_onlineSourcesCatalog), //"Online Sources Catalog"
          bottom: TabBar(tabs: [
            Tab(text: "TMS"),
            Tab(text: "WMS"),
          ]),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        endDrawer: Builder(
          builder: (BuildContext context) {
            return buildDrawer(context);
          },
        ),
        body: TabBarView(children: [
          _tmsCardsList == null
              ? Center(
                  child: SmashCircularProgress(
                      label: SL
                          .of(context)
                          .onlineSourcesPage_loadingTmsLayers), //"Loading TMS layers..."
                )
              : Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _tmsCardsList!,
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: FloatingActionButton(
                          child: Icon(MdiIcons.plus),
                          onPressed: () async {
                            String? layerJson = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddTmsStepper()));
                            if (layerJson != null) {
                              await GpPreferences().addNewTms(layerJson);
                              await getList();
                              setState(() {});
                            }
                          }),
                    ),
                  ],
                ),
          _wmsCardsList == null
              ? Center(
                  child: SmashCircularProgress(
                      label: SL
                          .of(context)
                          .onlineSourcesPage_loadingWmsLayers), //"Loading WMS layers..."
                )
              : Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _wmsCardsList!,
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: FloatingActionButton(
                          child: Icon(MdiIcons.plus),
                          onPressed: () async {
                            String? layerJson = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddWmsStepper()));
                            if (layerJson != null) {
                              await GpPreferences().addNewWms(layerJson);
                              await getList();
                              setState(() {});
                            }
                          }),
                    ),
                  ],
                ),
        ]),
      ),
    );
  }

  Drawer buildDrawer(BuildContext context) {
    double iconSize = SmashUI.MEDIUM_ICON_SIZE;
    Color c = SmashColors.mainDecorations;
    return Drawer(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Container(
          margin: EdgeInsets.only(bottom: 20),
          child: new DrawerHeader(
            child: Image.asset(
              "assets/maptools_icon.png",
            ),
          ),
          color: SmashColors.mainBackground,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                MdiIcons.map,
                color: c,
                size: iconSize,
              ),
              title: SmashUI.normalText(
                SL.of(context).addTmsFromDefaults,
                bold: true,
                color: c,
              ),
              onTap: () async {
                Map<String, TileSource> names2SourcesMap = {};
                for (var i = 0; i < onlinesTilesSources.length; i++) {
                  var os = onlinesTilesSources[i];
                  names2SourcesMap[os.getName()!] = os;
                }
                var selection = await SmashDialogs.showSingleChoiceDialog(
                    context,
                    SL.of(context).addTmsFromDefaults,
                    names2SourcesMap.keys.toList());
                if (selection != null) {
                  var os = names2SourcesMap[selection];
                  var json = os!.toJson();
                  await GpPreferences().addNewTms(json);
                  await getList();
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: Icon(
                MdiIcons.import,
                color: c,
                size: iconSize,
              ),
              title: SmashUI.normalText(
                SL
                    .of(context)
                    .onlineSourcesPage_importFromFile, //"Import from file"
                bold: true,
                color: c,
              ),
              onTap: () async {
                var exportsFolder = await Workspace.getExportsFolder();
                var importFilePath = FileUtilities.joinPaths(
                    exportsFolder.path, "onlinesources.json");

                var rel = Workspace.makeRelative(importFilePath);
                if (!File(importFilePath).existsSync()) {
                  SmashDialogs.showWarningDialog(context,
                      "${SL.of(context).onlineSourcesPage_theFile} $rel ${SL.of(context).onlineSourcesPage_doesntExist}"); //The file //doesn't exist
                } else {
                  var json = FileUtilities.readFile(importFilePath);
                  var mapList = jsonDecode(json);
                  if (mapList is List) {
                    for (var i = 0; i < mapList.length; i++) {
                      var map = mapList[i];
                      var type = map[LAYERSKEY_TYPE];
                      if (type == LAYERSTYPE_TMS) {
                        var layerSource = TileSource.fromMap(map);
                        await GpPreferences().addNewTms(layerSource.toJson());
                      } else if (type == LAYERSTYPE_WMS) {
                        var layerSource = WmsSource.fromMap(map);
                        await GpPreferences().addNewWms(layerSource.toJson());
                      }
                    }
                    await getList();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(SL
                          .of(context)
                          .onlineSourcesPage_onlineSourcesImported), //"Online sources imported."
                    ));
                  }
                }
              },
            ),
            ListTile(
              leading: Icon(
                MdiIcons.export,
                color: c,
                size: iconSize,
              ),
              title: SmashUI.normalText(
                SL
                    .of(context)
                    .onlineSourcesPage_exportToFile, //"Export to file"
                bold: true,
                color: c,
              ),
              onTap: () async {
                List<dynamic> exportList = [];
                _tmsSourcesList.forEach((tmsStr) {
                  var map = jsonDecode(tmsStr);
                  exportList.add(map);
                });
                _wmsSourcesList.forEach((wmsStr) {
                  var map = jsonDecode(wmsStr);
                  exportList.add(map);
                });

                var exportJson =
                    JsonEncoder.withIndent("  ").convert(exportList);

                var exportsFolder = await Workspace.getExportsFolder();
                var exportFilePath = FileUtilities.joinPaths(
                    exportsFolder.path, "onlinesources.json");
                FileUtilities.writeStringToFile(exportFilePath, exportJson);
                Navigator.pop(context);

                var rel = Workspace.makeRelative(exportFilePath);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(
                      "${SL.of(context).onlineSourcesPage_exportedTo} $rel"), //Exported to:
                ));
              },
            ),
          ],
        ),
      ],
    ));
  }

  Future getList() async {
    // TMS
    var tmsList = GpPreferences().getTmsListSync();
    _tmsSourcesList.clear();
    if (_tmsCardsList != null) {
      _tmsCardsList!.clear();
    } else {
      _tmsCardsList = [];
    }
    // load from preferences
    for (var i = 0; i < tmsList.length; i++) {
      var json = tmsList[i];
      _tmsSourcesList.add(json);
    }
    for (var i = 0; i < _tmsSourcesList.length; i++) {
      var json = _tmsSourcesList[i];
      var map = jsonDecode(json);
      if (map is Map<String, dynamic>) {
        var type = map[LAYERSKEY_TYPE];
        if (type == LAYERSTYPE_TMS) {
          var layerSource = TileSource.fromMap(map);
          var layers = await layerSource.toLayers(context);
          _tmsCardsList!.add(OnlineSourceCard(
              type, layerSource, layers, _tmsSourcesList, i, reloadNotifier));
        }
      }
    }
    // WMS
    var wmsList = GpPreferences().getWmsListSync();
    _wmsSourcesList.clear();
    if (_wmsCardsList != null) {
      _wmsCardsList!.clear();
    } else {
      _wmsCardsList = [];
    }
    if (wmsList.isNotEmpty) {
      // load from preferences
      for (var i = 0; i < wmsList.length; i++) {
        var json = wmsList[i];
        _wmsSourcesList.add(json);
      }
    }
    for (var i = 0; i < _wmsSourcesList.length; i++) {
      var json = _wmsSourcesList[i];
      var map = jsonDecode(json);
      if (map is Map<String, dynamic>) {
        var type = map[LAYERSKEY_TYPE];
        if (type == LAYERSTYPE_WMS) {
          var layerSource = WmsSource.fromMap(map);
          var layers = await layerSource.toLayers(context);
          _wmsCardsList!.add(OnlineSourceCard(
              type, layerSource, layers, _wmsSourcesList, i, reloadNotifier));
        }
      }
    }

    setState(() {});
  }
}

class OnlineSourceCard extends StatefulWidget {
  final layerSource;
  final layers;
  final ValueNotifier<int> reloadNotifier;
  final sourcesList;
  final index;
  final type;
  OnlineSourceCard(this.type, this.layerSource, this.layers, this.sourcesList,
      this.index, this.reloadNotifier,
      {Key? key})
      : super(key: key);

  @override
  _OnlineSourceCardState createState() => _OnlineSourceCardState();
}

class _OnlineSourceCardState extends State<OnlineSourceCard> {
  @override
  Widget build(BuildContext context) {
    var lastPosition = GpPreferences().getLastPositionSync();
    var lon = 11.33140;
    var lat = 46.47781;
    var zoom = 13.0;
    if (lastPosition != null) {
      lon = lastPosition[0];
      lat = lastPosition[1];
      zoom = lastPosition[2];
    }

    return Center(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              // leading: Icon(MdiIcons.layersTripleOutline),
              title: Text(widget.layerSource.getName()),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(widget.layerSource.getUrl()),
                      ),
                      if (widget.layerSource is TileSource)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                              "Zoom: min=${widget.layerSource.minZoom}, max=${widget.layerSource.maxZoom}, nativemax=${widget.layerSource.maxNativeZoom}"),
                        ),
                      if (widget.layerSource is TileSource)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                              "Attribution: ${widget.layerSource.attribution}"),
                        ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    height: 100,
                    child: FlutterMap(
                      options: new MapOptions(
                        center: new LatLng(lat, lon),
                        zoom: zoom,
                      ),
                      children: widget.layers,
                    ),
                  )
                ],
              ),
            ),
            SmashUI.defaultButtonBar(
              dangerLabel: SL.of(context).onlineSourcesPage_delete, //'DELETE'
              dangerFunction: () async {
                widget.sourcesList.removeAt(widget.index);
                if (widget.type == LAYERSTYPE_TMS) {
                  await GpPreferences().setTmsList(widget.sourcesList);
                } else {
                  await GpPreferences().setWmsList(widget.sourcesList);
                }
                widget.reloadNotifier.value = widget.reloadNotifier.value + 1;
              },
              okLabel: SL
                  .of(context)
                  .onlineSourcesPage_addToLayers, //'ADD TO LAYERS'
              okFunction: () => Navigator.pop(context, widget.layerSource),
              cancelLabel: "Modify",
              cancelFunction: () async {
                if (widget.type == LAYERSTYPE_TMS) {
                  TmsData tmsData = TmsData();
                  tmsData.url = widget.layerSource.getUrl();
                  tmsData.name = widget.layerSource.getName();
                  tmsData.attribution = widget.layerSource.getAttribution();
                  tmsData.subdomains = widget.layerSource.subdomains.join(",");

                  String? layerJson = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddTmsStepper(
                                tmsData: tmsData,
                              )));
                  if (layerJson != null) {
                    widget.sourcesList.removeAt(widget.index);
                    await GpPreferences().setTmsList(widget.sourcesList);
                    await GpPreferences().addNewTms(layerJson);
                    widget.reloadNotifier.value =
                        widget.reloadNotifier.value + 1;
                    // await getList();
                    setState(() {});
                  }
                } else {
                  WmsData wmsData = WmsData();
                  wmsData.url = widget.layerSource.getUrl();
                  wmsData.layer = widget.layerSource.getName();
                  wmsData.attribution = widget.layerSource.getAttribution();
                  wmsData.format = widget.layerSource.imageFormat;
                  wmsData.srid = widget.layerSource.getSrid();
                  wmsData.version = widget.layerSource.getVersion();

                  String? layerJson = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddWmsStepper(
                                wmsData: wmsData,
                              )));
                  if (layerJson != null) {
                    widget.sourcesList.removeAt(widget.index);
                    await GpPreferences().setWmsList(widget.sourcesList);
                    await GpPreferences().addNewWms(layerJson);
                    widget.reloadNotifier.value =
                        widget.reloadNotifier.value + 1;
                    // await getList();
                    setState(() {});
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TmsData {
  String name = "";
  String url = "";
  String subdomains = "";
  String attribution = "";
  String minZoom = "0";
  String maxZoom = "19";
}

class AddTmsStepper extends StatefulWidget {
  TmsData? tmsData;
  AddTmsStepper({this.tmsData, Key? key}) : super(key: key);

  @override
  _AddTmsStepperState createState() => _AddTmsStepperState();
}

class _AddTmsStepperState extends State<AddTmsStepper> with Localization {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static TmsData tmsData = TmsData();
  late List<Step> steps;

  @override
  void initState() {
    if (widget.tmsData == null) {
      tmsData = TmsData();
    } else {
      tmsData = widget.tmsData!;
    }
    steps = [
      Step(
        title: Text(loc.onlineSourcesPage_setNameTmsService),
        //"Set a name for the TMS service"
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              initialValue: tmsData.name,
              decoration: InputDecoration(
                labelText: loc.onlineSourcesPage_enterName, //"enter name"
                icon: Icon(MdiIcons.text),
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
              onSaved: (String? value) {
                if (value != null) tmsData.name = value;
              },
              validator: (value) {
                if (value!.isEmpty || value.length < 1) {
                  return loc
                      .onlineSourcesPage_pleaseEnterValidName; //"Please enter a valid name"
                }
                return null;
              },
            ),
          ],
        ),
      ),
      Step(
        title: Text(loc.onlineSourcesPage_insertUrlOfService),
        //"Insert the url of the service."
        subtitle: Text(loc.onlineSourcesPage_placeXyzBetBrackets),
        //"Place the x, y, z between curly brackets."
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              initialValue: tmsData.url,
              keyboardType: TextInputType.url,
              autocorrect: false,
              onSaved: (String? value) {
                if (value != null) tmsData.url = value;
              },
              validator: (value) {
                if (value!.isEmpty ||
                    value.length < 1 ||
                    !value.toLowerCase().startsWith("http") ||
                    !value.contains("{x}") ||
                    !value.contains("{y}") ||
                    !value.contains("{z}")) {
                  return loc
                      .onlineSourcesPage_pleaseEnterValidTmsUrl; //'Please enter a valid TMS URL'
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: loc.onlineSourcesPage_enterUrl, //"enter URL"
                icon: Icon(MdiIcons.link),
              ),
            ),
            TextFormField(
              initialValue: tmsData.subdomains,
              keyboardType: TextInputType.text,
              autocorrect: false,
              onSaved: (String? value) {
                if (value != null) tmsData.subdomains = value;
              },
              decoration: InputDecoration(
                icon: Icon(MdiIcons.fileTree),
                labelText:
                    loc.onlineSourcesPage_enterSubDomains, //"enter subdomains"
              ),
            ),
          ],
        ),
      ),
      Step(
        title:
            Text(loc.onlineSourcesPage_addAttribution), //"Add an attribution."
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              initialValue: tmsData.attribution,
              keyboardType: TextInputType.text,
              autocorrect: false,
              onSaved: (String? value) {
                if (value != null) tmsData.attribution = value;
              },
              decoration: InputDecoration(
                labelText: loc
                    .onlineSourcesPage_enterAttribution, //"enter attribution"
                icon: Icon(MdiIcons.license),
              ),
            ),
          ],
        ),
      ),
      Step(
        title:
            Text(loc.onlineSourcesPage_setMinMaxZoom), //"Set min and max zoom."
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              onSaved: (String? value) {
                tmsData.minZoom = value!;
              },
              initialValue: "0",
              decoration: InputDecoration(
                  labelText: loc.onlineSourcesPage_minZoom), //"min zoom"
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              onSaved: (String? value) {
                tmsData.maxZoom = value!;
              },
              initialValue: "19",
              decoration: InputDecoration(
                  labelText: loc.onlineSourcesPage_maxZoom), //"max zoom"
            ),
          ],
        ),
      ),
    ];
    super.initState();
  }

  int currentStep = 0;

  next() {
    currentStep + 1 != steps.length ? goTo(currentStep + 1) : _submitDetails();
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    } else {
      Navigator.pop(context);
    }
  }

  void _submitDetails() async {
    final FormState? formState = _formKey.currentState;
    if (!formState!.validate()) {
      SmashDialogs.showWarningDialog(
          context,
          SL
              .of(context)
              .onlineSourcesPage_pleaseCheckYourData); //'Please check your data'
    } else {
      formState.save();
      bool? okToGo = await showDialog(
        context: context,
        builder: (_) {
          return new AlertDialog(
            title:
                new Text(SL.of(context).onlineSourcesPage_details), //"Details"
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(SL.of(context).onlineSourcesPage_name +
                      tmsData.name), //"Name: "
                  new Text("URL: " + tmsData.url),
                  new Text(SL.of(context).onlineSourcesPage_subDomains +
                      (tmsData.subdomains)), //"Subdomains: "
                  new Text(SL.of(context).onlineSourcesPage_attribution +
                      (tmsData.attribution)), //"Attribution: "
                  new Text(
                      "${SL.of(context).onlineSourcesPage_minZoom}: ${tmsData.minZoom}"), //"Min zoom:"
                  new Text(
                      "${SL.of(context).onlineSourcesPage_maxZoom}: ${tmsData.maxZoom}"), //"Max zoom:"
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text(
                    SL.of(context).onlineSourcesPage_cancel), //"CANCEL"
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              new TextButton(
                child: new Text(SL.of(context).onlineSourcesPage_ok), //"OK"
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );

      if (okToGo != null && okToGo) {
        var json = '''
        {
            "$LAYERSKEY_LABEL": "${tmsData.name}",
            "$LAYERSKEY_URL": "${tmsData.url}",
            "$LAYERSKEY_MINZOOM": ${tmsData.minZoom},
            "$LAYERSKEY_MAXZOOM": ${tmsData.maxZoom},
            "$LAYERSKEY_OPACITY": 100,
            "$LAYERSKEY_ATTRIBUTION": "${tmsData.attribution}",
            "$LAYERSKEY_TYPE": "$LAYERSTYPE_TMS",
            "$LAYERSKEY_ISVISIBLE": true,
            "$LAYERSKEY_SUBDOMAINS": "${tmsData.subdomains}"
        }
        ''';
        Navigator.pop(context, json);
      } else if (okToGo != null && !okToGo) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SL
            .of(context)
            .onlineSourcesPage_newTmsOnlineService), //"New TMS Online Service"
      ),
      body: new Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stepper(
                steps: steps,
                currentStep: currentStep,
                onStepContinue: next,
                onStepCancel: cancel,
                onStepTapped: (step) => goTo(step),
              ),
            ),
            Padding(
              padding: SmashUI.defaultPadding(),
              child: new ElevatedButton(
                  child: Padding(
                    padding: SmashUI.defaultPadding(),
                    child: SmashUI.titleText(
                        SL.of(context).onlineSourcesPage_save, //"Save"
                        color: SmashColors.mainBackground),
                  ),
                  onPressed: _submitDetails,
                  style: ElevatedButton.styleFrom(
                    primary: SmashColors.mainDecorations,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class WmsData {
  String layer = "";
  String url = "";
  String attribution = "";
  String minZoom = "0";
  String maxZoom = "19";
  String format = LAYERSTYPE_FORMAT_JPG;
  String version = "1.1.1";
  int srid = SmashPrj.EPSG3857_INT;
}

class AddWmsStepper extends StatefulWidget {
  WmsData? wmsData;
  AddWmsStepper({this.wmsData, Key? key}) : super(key: key);

  @override
  _AddWmsStepperState createState() => _AddWmsStepperState();
}

class _AddWmsStepperState extends State<AddWmsStepper> with Localization {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  late List<Step> steps;
  late WmsData wmsData;

  @override
  void initState() {
    if (widget.wmsData == null) {
      wmsData = WmsData();
    } else {
      wmsData = widget.wmsData!;
    }

    steps = [
      Step(
        title: Text(loc
            .onlineSourcesPage_insertUrlOfService), //"Insert the url of the service."
        subtitle: Text(loc
            .onlineSourcesPage_theBaseUrlWithQuestionMark), //"The base url ending with question mark."
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              initialValue: wmsData.url,
              keyboardType: TextInputType.url,
              autocorrect: false,
              onSaved: (String? value) {
                if (value != null) {
                  if (value.contains("?")) {
                    var markIndex = value.indexOf("?");
                    value = value.substring(0, markIndex + 1);
                  }
                  wmsData.url = value;
                }
              },
              validator: (value) {
                if (value!.isEmpty ||
                    value.length < 1 ||
                    !value.toLowerCase().startsWith("http")) {
                  return loc
                      .onlineSourcesPage_pleaseEnterValidWmsUrl; //"Please enter a valid WMS URL"
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: loc.onlineSourcesPage_enterUrl, //"enter URL"
                icon: Icon(MdiIcons.link),
              ),
            ),
          ],
        ),
      ),
      Step(
        title:
            Text(loc.onlineSourcesPage_setWmsLayerName), //"Set WMS layer name"
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              initialValue: wmsData.layer,
              decoration: InputDecoration(
                labelText: loc
                    .onlineSourcesPage_enterLayerToLoad, //"enter layer to load"
                icon: Icon(MdiIcons.text),
              ),
              keyboardType: TextInputType.text,
              autocorrect: false,
              onSaved: (String? value) {
                if (value != null) {
                  wmsData.layer = value;
                }
              },
              validator: (value) {
                if (value!.isEmpty || value.length < 1) {
                  return loc
                      .onlineSourcesPage_pleaseEnterValidLayer; //"Please enter a valid layer"
                }
                return null;
              },
            ),
          ],
        ),
      ),
      Step(
        title: Text(
            loc.onlineSourcesPage_setWmsImageFormat), //"Set WMS image format"
        isActive: true,
        state: StepState.indexed,
        content: Column(children: <Widget>[
          StringCombo([
            LAYERSTYPE_FORMAT_JPG,
            LAYERSTYPE_FORMAT_PNG,
            LAYERSTYPE_FORMAT_TIFF
          ], wmsData.format, (newSelection) {
            wmsData.format = newSelection;
          }),
        ]),
      ),
      Step(
        title: Text("Select CRS"),
        isActive: true,
        state: StepState.indexed,
        content: Column(children: <Widget>[
          StringCombo([
            "EPSG:3857",
            "EPSG:4326",
          ], "EPSG:" + wmsData.srid.toString(), (String newSelection) {
            var code = newSelection.replaceFirst("EPSG:", "");
            wmsData.srid = int.parse(code);
          }),
        ]),
      ),
      Step(
        title: Text("Select Version"),
        isActive: true,
        state: StepState.indexed,
        content: Column(children: <Widget>[
          StringCombo([
            "1.1.1",
            "1.3.0",
          ], wmsData.version, (String newSelection) {
            wmsData.version = newSelection;
          }),
        ]),
      ),
      Step(
        title: Text(
            loc.onlineSourcesPage_addAnAttribution), //"Add an attribution."
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              initialValue: wmsData.attribution,
              keyboardType: TextInputType.text,
              autocorrect: false,
              onSaved: (String? value) {
                if (value != null) {
                  wmsData.attribution = value;
                }
              },
              decoration: InputDecoration(
                labelText: loc
                    .onlineSourcesPage_enterAttribution, //"enter attribution"
                icon: Icon(MdiIcons.license),
              ),
            ),
          ],
        ),
      ),
      Step(
        title:
            Text(loc.onlineSourcesPage_setMinMaxZoom), //"Set min and max zoom."
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              onSaved: (String? value) {
                if (value != null) {
                  wmsData.minZoom = value;
                }
              },
              initialValue: wmsData.minZoom,
              decoration: InputDecoration(
                  labelText: loc.onlineSourcesPage_minZoom), //"min zoom"
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              onSaved: (String? value) {
                if (value != null) {
                  wmsData.maxZoom = value;
                }
              },
              initialValue: wmsData.maxZoom,
              decoration: InputDecoration(
                  labelText: loc.onlineSourcesPage_maxZoom), //"max zoom"
            ),
          ],
        ),
      ),
    ];
    super.initState();
  }

  int currentStep = 0;

  next() {
    currentStep + 1 != steps.length ? goTo(currentStep + 1) : _submitDetails();
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    } else {
      Navigator.pop(context);
    }
  }

  void _submitDetails() async {
    final FormState? formState = _formKey.currentState;
    if (!formState!.validate()) {
      SmashDialogs.showWarningDialog(context,
          loc.onlineSourcesPage_pleaseCheckYourData); //'Please check your data'
    } else {
      formState.save();
      bool? okToGo = await showDialog(
          context: context,
          builder: (_) {
            return new AlertDialog(
              title: new Text(loc.onlineSourcesPage_details), //"Details"
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text(loc.onlineSourcesPage_layer +
                        wmsData.layer), //"Layer: "
                    new Text(loc.onlineSourcesPage_url + wmsData.url), //"URL: "
                    new Text("EPSG:${wmsData.srid}"),
                    new Text("Version: " + wmsData.version),
                    new Text(loc.onlineSourcesPage_attribution +
                        (wmsData.attribution)), //"Attribution: "
                    new Text(
                        "${loc.onlineSourcesPage_format}: ${wmsData.format}"), //Format
                    new Text(
                        "${loc.onlineSourcesPage_minZoom}: ${wmsData.minZoom}"), //Min zoom
                    new Text(
                        "${loc.onlineSourcesPage_maxZoom}: ${wmsData.maxZoom}"), //Max zoom
                  ],
                ),
              ),
              actions: <Widget>[
                new TextButton(
                  child: new Text(loc.onlineSourcesPage_cancel), //'CANCEL'
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                new TextButton(
                  child: new Text(loc.onlineSourcesPage_ok), //'OK'
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
              ],
            );
          });

      if (okToGo != null && okToGo) {
        var json = '''
        {
            "$LAYERSKEY_LABEL": "${wmsData.layer}",
            "$LAYERSKEY_URL": "${wmsData.url}",
            "$LAYERSKEY_MINZOOM": ${wmsData.minZoom},
            "$LAYERSKEY_MAXZOOM": ${wmsData.maxZoom},
            "$LAYERSKEY_OPACITY": 100,
            "$LAYERSKEY_ATTRIBUTION": "${wmsData.attribution}",
            "$LAYERSKEY_TYPE": "$LAYERSTYPE_WMS",
            "$LAYERSKEY_FORMAT": "${wmsData.format}",
            "$LAYERSKEY_SRID": ${wmsData.srid},
            "$LAYERSKEY_WMSVERSION": "${wmsData.version}",
            "$LAYERSKEY_ISVISIBLE": true
        }
        ''';
        Navigator.pop(context, json);
      } else if (okToGo != null && !okToGo) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SL
            .of(context)
            .onlineSourcesPage_newWmsOnlineService), //"New WMS Online Service"
      ),
      body: new Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stepper(
                steps: steps,
                currentStep: currentStep,
                onStepContinue: next,
                onStepCancel: cancel,
                onStepTapped: (step) => goTo(step),
              ),
            ),
            Padding(
              padding: SmashUI.defaultPadding(),
              child: new ElevatedButton(
                style: SmashUI.defaultElevateButtonStyle(
                    color: SmashColors.mainDecorations),
                child: Padding(
                  padding: SmashUI.defaultPadding(),
                  child: SmashUI.titleText(
                      SL.of(context).onlineSourcesPage_save, //"Save"
                      color: SmashColors.mainBackground),
                ),
                onPressed: _submitDetails,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
