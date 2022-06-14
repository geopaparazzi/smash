import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/tiles.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/wms.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

class OnlineSourcesPage extends StatefulWidget {
  OnlineSourcesPage({Key? key}) : super(key: key);

  @override
  _OnlineSourcesPageState createState() => _OnlineSourcesPageState();
}

class _OnlineSourcesPageState extends State<OnlineSourcesPage>
    with AfterLayoutMixin {
  List<Widget> _tmsCardsList = [];
  List<String> _tmsSourcesList = [];
  List<Widget> _wmsCardsList = [];
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
            )),
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
                        children: _tmsCardsList,
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: FloatingActionButton(
                          child: Icon(MdiIcons.plus),
                          onPressed: () async {
                            String layerJson = await Navigator.push(
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
                        children: _wmsCardsList,
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: FloatingActionButton(
                          child: Icon(MdiIcons.plus),
                          onPressed: () async {
                            String layerJson = await Navigator.push(
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
    _tmsCardsList.clear();
    if (tmsList.isEmpty) {
      // load a default set if empty
      for (var i = 0; i < onlinesTilesSources.length; i++) {
        var os = onlinesTilesSources[i];
        var json = os.toJson();
        _tmsSourcesList.add(json);
      }
    } else {
      // load from preferences
      for (var i = 0; i < tmsList.length; i++) {
        var json = tmsList[i];
        _tmsSourcesList.add(json);
      }
    }
    for (var i = 0; i < _tmsSourcesList.length; i++) {
      var json = _tmsSourcesList[i];
      var map = jsonDecode(json);
      var type = map[LAYERSKEY_TYPE];
      if (type == LAYERSTYPE_TMS) {
        var layerSource = TileSource.fromMap(map);
        var layers = await layerSource.toLayers(context);
        _tmsCardsList.add(OnlineSourceCard(
            type, layerSource, layers, _tmsSourcesList, i, reloadNotifier));
      }
    }
    // WMS
    var wmsList = GpPreferences().getWmsListSync();
    _wmsSourcesList.clear();
    _wmsCardsList.clear();
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
      var type = map[LAYERSKEY_TYPE];
      if (type == LAYERSTYPE_WMS) {
        var layerSource = WmsSource.fromMap(map);
        var layers = await layerSource.toLayers(context);
        _wmsCardsList.add(OnlineSourceCard(
            type, layerSource, layers, _wmsSourcesList, i, reloadNotifier));
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
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(MdiIcons.layersTripleOutline),
              title: Text(widget.layerSource.getName()),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(widget.layerSource.getUrl()),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    height: 100,
                    child: FlutterMap(
                      options: new MapOptions(
                        center: new LatLng(lat, lon),
                        zoom: zoom,
                      ),
                      layers: widget.layers,
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
            ),
          ],
        ),
      ),
    );
  }
}

class TmsData {
  String? name;
  String? url;
  String? subdomains;
  String? attribution;
  String? minZoom;
  String? maxZoom;
}

class AddTmsStepper extends StatefulWidget {
  AddTmsStepper({Key? key}) : super(key: key);

  @override
  _AddTmsStepperState createState() => _AddTmsStepperState();
}

class _AddTmsStepperState extends State<AddTmsStepper> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static TmsData tmsData = TmsData();
  List<Step> steps = [
    Step(
      title: Text(SL.current
          .onlineSourcesPage_setNameTmsService), //"Set a name for the TMS service"
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: SL.current.onlineSourcesPage_enterName, //"enter name"
              icon: const Icon(MdiIcons.text),
            ),
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String? value) {
              tmsData.name = value;
            },
            validator: (value) {
              if (value!.isEmpty || value!.length < 1) {
                return SL.current
                    .onlineSourcesPage_pleaseEnterValidName; //"Please enter a valid name"
              }
              return null;
            },
          ),
        ],
      ),
    ),
    Step(
      title: Text(SL.current
          .onlineSourcesPage_insertUrlOfService), //"Insert the url of the service."
      subtitle: Text(SL.current
          .onlineSourcesPage_placeXyzBetBrackets), //"Place the x, y, z between curly brackets."
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String? value) {
              print(value);
              tmsData.url = value;
            },
            validator: (value) {
              if (value!.isEmpty ||
                  value.length < 1 ||
                  !value.toLowerCase().startsWith("http") ||
                  !value.contains("{x}") ||
                  !value.contains("{y}") ||
                  !value.contains("{z}")) {
                return SL.current
                    .onlineSourcesPage_pleaseEnterValidTmsUrl; //'Please enter a valid TMS URL'
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: SL.current.onlineSourcesPage_enterUrl, //"enter URL"
              icon: const Icon(MdiIcons.link),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String? value) {
              tmsData.subdomains = value;
            },
            decoration: InputDecoration(
              icon: const Icon(MdiIcons.fileTree),
              labelText: SL.current
                  .onlineSourcesPage_enterSubDomains, //"enter subdomains"
            ),
          ),
        ],
      ),
    ),
    Step(
      title: Text(
          SL.current.onlineSourcesPage_addAttribution), //"Add an attribution."
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String? value) {
              tmsData.attribution = value;
            },
            decoration: InputDecoration(
              labelText: SL.current
                  .onlineSourcesPage_enterAttribution, //"enter attribution"
              icon: const Icon(MdiIcons.license),
            ),
          ),
        ],
      ),
    ),
    Step(
      title: Text(
          SL.current.onlineSourcesPage_setMinMaxZoom), //"Set min and max zoom."
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (String? value) {
              tmsData.minZoom = value;
            },
            initialValue: "0",
            decoration: InputDecoration(
                labelText: SL.current.onlineSourcesPage_minZoom), //"min zoom"
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (String? value) {
              tmsData.maxZoom = value;
            },
            initialValue: "19",
            decoration: InputDecoration(
                labelText: SL.current.onlineSourcesPage_maxZoom), //"max zoom"
          ),
        ],
      ),
    ),
  ];

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
                      tmsData.name!), //"Name: "
                  new Text("URL: " + tmsData.url!),
                  new Text(SL.of(context).onlineSourcesPage_subDomains +
                      (tmsData.subdomains ?? "- nv -")), //"Subdomains: "
                  new Text(SL.of(context).onlineSourcesPage_attribution +
                      (tmsData.attribution ?? "- nv -")), //"Attribution: "
                  new Text(
                      "${SL.of(context).onlineSourcesPage_minZoom}: ${tmsData.minZoom ?? ""}"), //"Min zoom:"
                  new Text(
                      "${SL.of(context).onlineSourcesPage_maxZoom}: ${tmsData.maxZoom ?? ""}"), //"Max zoom:"
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
            "$LAYERSKEY_MINZOOM": ${tmsData.minZoom ?? 0},
            "$LAYERSKEY_MAXZOOM": ${tmsData.maxZoom ?? 19},
            "$LAYERSKEY_OPACITY": 100,
            "$LAYERSKEY_ATTRIBUTION": "${tmsData.attribution ?? ""}",
            "$LAYERSKEY_TYPE": "$LAYERSTYPE_TMS",
            "$LAYERSKEY_ISVISIBLE": true,
            "$LAYERSKEY_SUBDOMAINS": "${tmsData.subdomains ?? ""}"
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
  String? layer;
  String? url;
  String? attribution;
  String? minZoom;
  String? maxZoom;
  String format = LAYERSTYPE_FORMAT_JPG;
  String version = "1.1.1";
  int srid = SmashPrj.EPSG3857_INT;
}

class AddWmsStepper extends StatefulWidget {
  AddWmsStepper({Key? key}) : super(key: key);

  @override
  _AddWmsStepperState createState() => _AddWmsStepperState();
}

class _AddWmsStepperState extends State<AddWmsStepper> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static WmsData wmsData = WmsData();
  List<Step> steps = [
    Step(
      title: Text(SL.current
          .onlineSourcesPage_insertUrlOfService), //"Insert the url of the service."
      subtitle: Text(SL.current
          .onlineSourcesPage_theBaseUrlWithQuestionMark), //"The base url ending with question mark."
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String? value) {
              if (value!.contains("?")) {
                var markIndex = value.indexOf("?");
                value = value.substring(0, markIndex + 1);
              }
              wmsData.url = value;
            },
            validator: (value) {
              if (value!.isEmpty ||
                  value.length < 1 ||
                  !value.toLowerCase().startsWith("http")) {
                return SL.current
                    .onlineSourcesPage_pleaseEnterValidWmsUrl; //"Please enter a valid WMS URL"
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: SL.current.onlineSourcesPage_enterUrl, //"enter URL"
              icon: const Icon(MdiIcons.link),
            ),
          ),
        ],
      ),
    ),
    Step(
      title: Text(
          SL.current.onlineSourcesPage_setWmsLayerName), //"Set WMS layer name"
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: SL.current
                  .onlineSourcesPage_enterLayerToLoad, //"enter layer to load"
              icon: const Icon(MdiIcons.text),
            ),
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String? value) {
              wmsData.layer = value;
            },
            validator: (value) {
              if (value!.isEmpty || value.length < 1) {
                return SL.current
                    .onlineSourcesPage_pleaseEnterValidLayer; //"Please enter a valid layer"
              }
              return null;
            },
          ),
        ],
      ),
    ),
    Step(
      title: Text(SL.current
          .onlineSourcesPage_setWmsImageFormat), //"Set WMS image format"
      isActive: true,
      state: StepState.indexed,
      content: Column(children: <Widget>[
        StringCombo([
          LAYERSTYPE_FORMAT_JPG,
          LAYERSTYPE_FORMAT_PNG,
          LAYERSTYPE_FORMAT_TIFF
        ], LAYERSTYPE_FORMAT_JPG, (newSelection) {
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
        ], "EPSG:3857", (String newSelection) {
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
        ], "1.1.1", (String newSelection) {
          wmsData.version = newSelection;
        }),
      ]),
    ),
    Step(
      title: Text(SL
          .current.onlineSourcesPage_addAnAttribution), //"Add an attribution."
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String? value) {
              wmsData.attribution = value;
            },
            decoration: InputDecoration(
              labelText: SL.current
                  .onlineSourcesPage_enterAttribution, //"enter attribution"
              icon: const Icon(MdiIcons.license),
            ),
          ),
        ],
      ),
    ),
    Step(
      title: Text(
          SL.current.onlineSourcesPage_setMinMaxZoom), //"Set min and max zoom."
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (String? value) {
              wmsData.minZoom = value;
            },
            initialValue: "0",
            decoration: InputDecoration(
                labelText: SL.current.onlineSourcesPage_minZoom), //"min zoom"
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (String? value) {
              wmsData.maxZoom = value;
            },
            initialValue: "19",
            decoration: InputDecoration(
                labelText: SL.current.onlineSourcesPage_maxZoom), //"max zoom"
          ),
        ],
      ),
    ),
  ];

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
          SL.current
              .onlineSourcesPage_pleaseCheckYourData); //'Please check your data'
    } else {
      formState.save();
      bool? okToGo = await showDialog(
          context: context,
          builder: (_) {
            return new AlertDialog(
              title: new Text(SL.current.onlineSourcesPage_details), //"Details"
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text(SL.current.onlineSourcesPage_layer +
                        wmsData.layer!), //"Layer: "
                    new Text(SL.current.onlineSourcesPage_url +
                        wmsData.url!), //"URL: "
                    new Text("EPSG:${wmsData.srid}"),
                    new Text("Version: " + wmsData.version),
                    new Text(SL.current.onlineSourcesPage_attribution +
                        (wmsData.attribution ?? "- nv -")), //"Attribution: "
                    new Text(
                        "${SL.current.onlineSourcesPage_format}: ${wmsData.format}"), //Format
                    new Text(
                        "${SL.current.onlineSourcesPage_minZoom}: ${wmsData.minZoom ?? ""}"), //Min zoom
                    new Text(
                        "${SL.current.onlineSourcesPage_maxZoom}: ${wmsData.maxZoom ?? ""}"), //Max zoom
                  ],
                ),
              ),
              actions: <Widget>[
                new TextButton(
                  child:
                      new Text(SL.current.onlineSourcesPage_cancel), //'CANCEL'
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                new TextButton(
                  child: new Text(SL.current.onlineSourcesPage_ok), //'OK'
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
            "$LAYERSKEY_MINZOOM": ${wmsData.minZoom ?? 0},
            "$LAYERSKEY_MAXZOOM": ${wmsData.maxZoom ?? 19},
            "$LAYERSKEY_OPACITY": 100,
            "$LAYERSKEY_ATTRIBUTION": "${wmsData.attribution ?? ""}",
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
              child: new RaisedButton(
                child: Padding(
                  padding: SmashUI.defaultPadding(),
                  child: SmashUI.titleText(
                      SL.of(context).onlineSourcesPage_save, //"Save"
                      color: SmashColors.mainBackground),
                ),
                onPressed: _submitDetails,
                color: SmashColors.mainDecorations,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
