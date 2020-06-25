import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/tiles.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/wms.dart';
import 'package:smashlibs/smashlibs.dart';

class OnlineSourcesPage extends StatefulWidget {
  OnlineSourcesPage({Key key}) : super(key: key);

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
          title: Text("Online Sources Catalog"),
          bottom: TabBar(tabs: [
            Tab(text: "TMS"),
            Tab(text: "WMS"),
          ]),
        ),
        endDrawer: Builder(
          builder: (BuildContext context) {
            return buildDrawer(context);
          },
        ),
        body: TabBarView(children: [
          _tmsCardsList == null
              ? Center(
                  child: SmashCircularProgress(label: "Loading TMS layers..."),
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
                  child: SmashCircularProgress(label: "Loading WMS layers..."),
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
                "Import from file",
                bold: true,
                color: c,
              ),
              onTap: () async {
                var exportsFolder = await Workspace.getExportsFolder();
                var importFilePath = FileUtilities.joinPaths(
                    exportsFolder.path, "onlinesources.json");

                var rel = Workspace.makeRelative(importFilePath);
                if (!File(importFilePath).existsSync()) {
                  showWarningDialog(context, "The file $rel doesn't exist");
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
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Online sources imported."),
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
                "Export to file",
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
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Exported to: $rel"),
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
      {Key key})
      : super(key: key);

  @override
  _OnlineSourceCardState createState() => _OnlineSourceCardState();
}

class _OnlineSourceCardState extends State<OnlineSourceCard> {
  @override
  Widget build(BuildContext context) {
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
                        center: new LatLng(46.47781, 11.33140),
                        zoom: 13.0,
                      ),
                      layers: widget.layers,
                    ),
                  )
                ],
              ),
            ),
            SmashUI.defaultButtonBar(
              dangerLabel: 'DELETE',
              dangerFunction: () async {
                widget.sourcesList.removeAt(widget.index);
                if (widget.type == LAYERSTYPE_TMS) {
                  await GpPreferences().setTmsList(widget.sourcesList);
                } else {
                  await GpPreferences().setWmsList(widget.sourcesList);
                }
                widget.reloadNotifier.value = widget.reloadNotifier.value + 1;
              },
              okLabel: 'ADD TO LAYERS',
              okFunction: () => Navigator.pop(context, widget.layerSource),
            ),
          ],
        ),
      ),
    );
  }
}

class TmsData {
  String name;
  String url;
  String subdomains;
  String attribution;
  String minZoom;
  String maxZoom;
}

class AddTmsStepper extends StatefulWidget {
  AddTmsStepper({Key key}) : super(key: key);

  @override
  _AddTmsStepperState createState() => _AddTmsStepperState();
}

class _AddTmsStepperState extends State<AddTmsStepper> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static TmsData tmsData = TmsData();
  List<Step> steps = [
    Step(
      title: const Text("Set a name for the TMS service"),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "enter name",
              icon: const Icon(MdiIcons.text),
            ),
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String value) {
              tmsData.name = value;
            },
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return 'Please enter a valid name';
              }
              return null;
            },
          ),
        ],
      ),
    ),
    Step(
      title: const Text("Insert the url of the service."),
      subtitle: Text("Place the x, y, z between curly brackets."),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String value) {
              print(value);
              tmsData.url = value;
            },
            validator: (value) {
              if (value.isEmpty ||
                  value.length < 1 ||
                  !value.toLowerCase().startsWith("http") ||
                  !value.contains("{x}") ||
                  !value.contains("{y}") ||
                  !value.contains("{z}")) {
                return 'Please enter a valid TMS URL';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "enter URL",
              icon: const Icon(MdiIcons.link),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String value) {
              tmsData.subdomains = value;
            },
            decoration: InputDecoration(
                icon: const Icon(MdiIcons.fileTree),
                labelText: "enter subdomains"),
          ),
        ],
      ),
    ),
    Step(
      title: const Text("Add an attribution."),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String value) {
              tmsData.attribution = value;
            },
            decoration: InputDecoration(
              labelText: "enter attribution",
              icon: const Icon(MdiIcons.license),
            ),
          ),
        ],
      ),
    ),
    Step(
      title: const Text("Set min and max zoom."),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (String value) {
              tmsData.minZoom = value;
            },
            initialValue: "0",
            decoration: InputDecoration(labelText: "min zoom"),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (String value) {
              tmsData.maxZoom = value;
            },
            initialValue: "19",
            decoration: InputDecoration(labelText: "max zoom"),
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
    final FormState formState = _formKey.currentState;
    if (!formState.validate()) {
      showWarningDialog(context, 'Please check your data');
    } else {
      formState.save();
      bool okToGo = await showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Details"),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text("Name: " + tmsData.name),
                  new Text("URL: " + tmsData.url),
                  new Text("Subdomains: " + tmsData.subdomains ?? "- nv -"),
                  new Text("Attribution: " + tmsData.attribution ?? "- nv -"),
                  new Text("Min zoom: ${tmsData.minZoom ?? ""}"),
                  new Text("Max zoom: ${tmsData.maxZoom ?? ""}"),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ));

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
        title: Text("New TMS Online Service"),
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
                  child: SmashUI.titleText("Save",
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

class WmsData {
  String layer;
  String url;
  String attribution;
  String minZoom;
  String maxZoom;
}

class AddWmsStepper extends StatefulWidget {
  AddWmsStepper({Key key}) : super(key: key);

  @override
  _AddWmsStepperState createState() => _AddWmsStepperState();
}

class _AddWmsStepperState extends State<AddWmsStepper> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static WmsData wmsData = WmsData();
  List<Step> steps = [
    Step(
      title: const Text("Set WMS layer name"),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: "enter layer to load",
              icon: const Icon(MdiIcons.text),
            ),
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String value) {
              wmsData.layer = value;
            },
            validator: (value) {
              if (value.isEmpty || value.length < 1) {
                return 'Please enter a valid layer';
              }
              return null;
            },
          ),
        ],
      ),
    ),
    Step(
      title: const Text("Insert the url of the service."),
      subtitle: Text("The base url ending with question mark."),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String value) {
              print(value);
              wmsData.url = value;
            },
            validator: (value) {
              if (value.isEmpty ||
                  value.length < 1 ||
                  !value.toLowerCase().startsWith("http")) {
                return 'Please enter a valid WMS URL';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "enter URL",
              icon: const Icon(MdiIcons.link),
            ),
          ),
        ],
      ),
    ),
    Step(
      title: const Text("Add an attribution."),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            onSaved: (String value) {
              wmsData.attribution = value;
            },
            decoration: InputDecoration(
              labelText: "enter attribution",
              icon: const Icon(MdiIcons.license),
            ),
          ),
        ],
      ),
    ),
    Step(
      title: const Text("Set min and max zoom."),
      isActive: true,
      state: StepState.indexed,
      content: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (String value) {
              wmsData.minZoom = value;
            },
            initialValue: "0",
            decoration: InputDecoration(labelText: "min zoom"),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            onSaved: (String value) {
              wmsData.maxZoom = value;
            },
            initialValue: "19",
            decoration: InputDecoration(labelText: "max zoom"),
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
    final FormState formState = _formKey.currentState;
    if (!formState.validate()) {
      showWarningDialog(context, 'Please check your data');
    } else {
      formState.save();
      bool okToGo = await showDialog(
          context: context,
          child: new AlertDialog(
            title: new Text("Details"),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text("Layer: " + wmsData.layer),
                  new Text("URL: " + wmsData.url),
                  new Text("Attribution: " + wmsData.attribution ?? "- nv -"),
                  new Text("Min zoom: ${wmsData.minZoom ?? ""}"),
                  new Text("Max zoom: ${wmsData.maxZoom ?? ""}"),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ));

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
        title: Text("New WMS Online Service"),
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
                  child: SmashUI.titleText("Save",
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
