import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart'
    hide TextStyle;
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:latlong/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layermanager.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/postgis.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class RemoteDbsWidget extends StatefulWidget {
  RemoteDbsWidget({Key key}) : super(key: key);

  @override
  _RemoteDbsWidgetState createState() => _RemoteDbsWidgetState();
}

class _RemoteDbsWidgetState extends State<RemoteDbsWidget> {
  final key = "KEY_REMOTE_DBS";

  List<LayerSource> sources = [];

  void loadConfig() {
    sources = [];
    var dbJson = GpPreferences().getStringSync(key, "");
    var list = dbJson.isEmpty ? [] : jsonDecode(dbJson);
    if (list.isNotEmpty) {
      list.forEach((dynamic map) {
        var url = map[LAYERSKEY_URL];
        if (url != null && url.startsWith("postgis")) {
          var postgisSource = PostgisSource.fromMap(map);
          sources.add(postgisSource);
        }
      });
    }
  }

  @override
  void initState() {
    loadConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remote Databases"),
      ),
      body: ListView.builder(
        itemCount: sources.length,
        itemBuilder: (BuildContext context, int index) {
          PostgisSource source = sources[index];
          String url = source.getUrl();
          String table = source.getName();
          String user = source.getUser();
          String where = source.getWhere();
          if (where != null && where.isNotEmpty) {
            where = "\nwhere: $where";
          } else {
            where = "";
          }

          List<Widget> secondaryActions = [];
          secondaryActions.add(IconSlideAction(
              caption: 'Delete',
              color: SmashColors.mainDanger,
              icon: MdiIcons.delete,
              onTap: () async {
                bool doDelete = await SmashDialogs.showConfirmDialog(
                    context,
                    "DELETE",
                    'Are you sure you want to delete the database configuration?');
                if (doDelete) {
                  sources.removeAt(index);
                  var list =
                      sources.map((s) => jsonDecode(s.toJson())).toList();
                  var jsonString = jsonEncode(list);
                  await GpPreferences().setString(key, jsonString);
                  loadConfig();
                  setState(() {});
                }
              }));
          List<Widget> actions = [];
          actions.add(IconSlideAction(
              caption: 'Edit',
              icon: MdiIcons.pencil,
              color: SmashColors.mainDecorations,
              onTap: () async {
                var dbConfigMap = jsonDecode(source.toJson());
                var newMap =
                    await showRemoteDbPropertiesDialog(context, dbConfigMap);
                if (newMap != null) {
                  var dbJson = GpPreferences().getStringSync(key, "");
                  var list = jsonDecode(dbJson);
                  list.add(newMap);
                  var jsonString = jsonEncode(list);
                  await GpPreferences().setString(key, jsonString);
                  setState(() {});
                }
              }));

          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: actions,
            secondaryActions: secondaryActions,
            child: ListTile(
              title: Text(url),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("table: $table  user: $user$where"),
              ),
              leading: FittedBox(
                fit: BoxFit.cover,
                child: Icon(
                  MdiIcons.database,
                  color: SmashColors.mainDecorations,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: "Load in map.",
                    icon: Icon(
                      MdiIcons.openInApp,
                      color: SmashColors.mainDecorations,
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop(source);
                      // }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(MdiIcons.plus),
        onPressed: () async {
          Map<String, dynamic> dbConfigMap = {};
          var newMap = await showRemoteDbPropertiesDialog(context, dbConfigMap);
          if (newMap != null) {
            var dbJson = GpPreferences().getStringSync(key, "");
            var list = dbJson.isEmpty ? [] : jsonDecode(dbJson);
            list.add(newMap);
            var jsonString = jsonEncode(list);
            await GpPreferences().setString(key, jsonString);
            setState(() {
              loadConfig();
            });
          }
        },
      ),
    );
  }
}

Future<Map<String, dynamic>> showRemoteDbPropertiesDialog(
    BuildContext context, Map<String, dynamic> dbConfigMap) async {
  return await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Database Parameters"),
        content: Builder(builder: (context) {
          var width = MediaQuery.of(context).size.width;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Container(
                width: width,
                child: RemoteDbPropertiesContainer(dbConfigMap),
              ),
            ),
          );
        }),
        actions: <Widget>[
          FlatButton(
            child: Text("CANCEL"),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(dbConfigMap);
            },
          ),
        ],
      );
    },
  );
}

class RemoteDbPropertiesContainer extends StatefulWidget {
  final Map<String, dynamic> sourceMap;

  RemoteDbPropertiesContainer(this.sourceMap, {Key key}) : super(key: key);

  @override
  _RemoteDbPropertiesContainerState createState() =>
      _RemoteDbPropertiesContainerState(sourceMap);
}

class _RemoteDbPropertiesContainerState
    extends State<RemoteDbPropertiesContainer> {
  final Map<String, dynamic> sourceMap;
  // String host = "localhost";
  // String port = "5432";
  // String tableName = "";
  // String user = "";
  // String pwd = "";
  // String where = "";

  _RemoteDbPropertiesContainerState(this.sourceMap) {}

  @override
  Widget build(BuildContext context) {
    // _dbUrl = postgis:host:port/dbname
    var url = sourceMap[LAYERSKEY_URL] ?? "postgis:localhost:5432/dbname";
    var user = sourceMap[LAYERSKEY_USER] ?? "";
    var tableName = sourceMap[LAYERSKEY_LABEL] ?? "";
    var pwd = sourceMap[LAYERSKEY_PWD] ?? "";
    var where = sourceMap[LAYERSKEY_WHERE] ?? "";

    var urlEC = new TextEditingController(text: url);
    var urlID = new InputDecoration(labelText: "url");
    var urlWidget = new TextFormField(
      controller: urlEC,
      autovalidateMode: AutovalidateMode.always,
      autofocus: false,
      decoration: urlID,
      validator: (txt) {
        sourceMap[LAYERSKEY_URL] = txt;
        var errorText = txt.isEmpty
            ? "The url needs to be defined (postgis:host:port/dbname)"
            : null;
        return errorText;
      },
    );
    var userEC = new TextEditingController(text: user);
    var userID = new InputDecoration(labelText: "user");
    var userWidget = new TextFormField(
      controller: userEC,
      autovalidateMode: AutovalidateMode.always,
      autofocus: false,
      decoration: userID,
      validator: (txt) {
        sourceMap[LAYERSKEY_USER] = txt;
        var errorText = txt.isEmpty ? "The user needs to be defined." : null;
        return errorText;
      },
    );
    var passwordEC = new TextEditingController(text: pwd);
    var passwordID = new InputDecoration(labelText: "password");
    var passwordWidget = new TextFormField(
      obscureText: true,
      controller: passwordEC,
      autovalidateMode: AutovalidateMode.always,
      autofocus: false,
      decoration: passwordID,
      validator: (txt) {
        sourceMap[LAYERSKEY_PWD] = txt;
        var errorText =
            txt.isEmpty ? "The password needs to be defined." : null;
        return errorText;
      },
    );
    var tableEC = new TextEditingController(text: tableName);
    var tableID = new InputDecoration(labelText: "table");
    var tableWidget = new TextFormField(
      controller: tableEC,
      autovalidateMode: AutovalidateMode.always,
      autofocus: false,
      decoration: tableID,
      validator: (txt) {
        sourceMap[LAYERSKEY_LABEL] = txt;
        var errorText =
            txt.isEmpty ? "The table name needs to be defined." : null;
        return errorText;
      },
    );
    var whereEC = new TextEditingController(text: where);
    var whereID = new InputDecoration(labelText: "optional where condition");
    var whereWidget = new TextFormField(
      controller: whereEC,
      autovalidateMode: AutovalidateMode.always,
      autofocus: false,
      decoration: whereID,
      validator: (txt) {
        sourceMap[LAYERSKEY_WHERE] = txt;
        // var errorText =
        //     txt.isEmpty ? "The where name needs to be defined." : null;
        return null;
      },
    );

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: urlWidget,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: userWidget,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: passwordWidget,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: tableWidget,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: whereWidget,
          ),
        ],
      ),
    );
  }
}
