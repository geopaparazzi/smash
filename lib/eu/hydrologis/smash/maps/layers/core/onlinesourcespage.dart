import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/flutterlibs/theme/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/dialogs.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/progress.dart';
import 'package:smash/eu/hydrologis/flutterlibs/ui/ui.dart';
import 'package:smash/eu/hydrologis/flutterlibs/utils/preferences.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/tiles.dart';
import 'dart:convert';

class OnlineSourcesPage extends StatefulWidget {
  OnlineSourcesPage({Key key}) : super(key: key);

  @override
  _OnlineSourcesPageState createState() => _OnlineSourcesPageState();
}

class _OnlineSourcesPageState extends State<OnlineSourcesPage> {
  List<Widget> _tmsCardsList = [];
  List<String> _tmsSourcesList = [];
  ValueNotifier<int> reloadNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    reloadNotifier.addListener(() async {
      await getList();
      setState(() {});
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
                              setState(() {});
                            }
                          }),
                    ),
                  ],
                ),
          _tmsCardsList == null
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
                        children: _tmsCardsList,
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: FloatingActionButton(
                          child: Icon(MdiIcons.plus), onPressed: () {}),
                    ),
                  ],
                ),
        ]),
      ),
    );
  }

  Future getList() async {
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
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'DELETE',
                    style: TextStyle(color: SmashColors.mainDanger),
                  ),
                  onPressed: () async {
                    widget.sourcesList.removeAt(widget.index);
                    await GpPreferences().setTmsList(widget.sourcesList);
                    widget.reloadNotifier.value =
                        widget.reloadNotifier.value + 1;
                  },
                ),
                FlatButton(
                  child: const Text('ADD TO LAYERS'),
                  onPressed: () {
                    LayerManager().addLayerSource(widget.layerSource);
                    Navigator.pop(context);
                  },
                ),
              ],
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
        title: Text("New Online Service"),
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
