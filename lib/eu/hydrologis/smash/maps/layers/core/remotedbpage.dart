import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/core/layersource.dart';
import 'package:smash/eu/hydrologis/smash/maps/layers/types/postgis.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

class RemoteDbsWidget extends StatefulWidget {
  RemoteDbsWidget({Key? key}) : super(key: key);

  @override
  _RemoteDbsWidgetState createState() => _RemoteDbsWidgetState();
}

class _RemoteDbsWidgetState extends State<RemoteDbsWidget> {
  final key = "KEY_REMOTE_DBS";

  List<LayerSource> sources = [];

  void loadConfig() {
    sources = [];
    var dbJson = GpPreferences().getStringSync(key, "") ?? "";
    var list = dbJson.isEmpty ? [] : jsonDecode(dbJson);
    if (list.isNotEmpty) {
      list.forEach((dynamic map) {
        var layerSource = DbVectorLayerSource.fromMap(map);
        if (layerSource != null) {
          sources.add(layerSource);
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
        title: Text(
            SL.of(context).remoteDbPage_remoteDatabases), //"Remote Databases"
      ),
      body: ListView.builder(
        itemCount: sources.length,
        itemBuilder: (BuildContext context, int index) {
          DbVectorLayerSource source = sources[index] as DbVectorLayerSource;
          String? url = source.getUrl();
          String? table = source.getName();
          String? user = source.getUser();
          String? where = source.getWhere();
          if (where != null && where.isNotEmpty) {
            where = "\nwhere: $where";
          } else {
            where = "";
          }

          List<Widget> endActions = [];
          endActions.add(SlidableAction(
              label: SL.of(context).remoteDbPage_delete, //'Delete'
              foregroundColor: SmashColors.mainDanger,
              icon: SmashIcons.deleteIcon,
              onPressed: (context) async {
                bool? doDelete = await SmashDialogs.showConfirmDialog(
                    context,
                    SL.of(context).remoteDbPage_delete, //"DELETE"
                    SL
                        .of(context)
                        .remoteDbPage_areYouSureDeleteDatabase); //'Are you sure you want to delete the database configuration?'
                if (doDelete!) {
                  sources.removeAt(index);
                  var list =
                      sources.map((s) => jsonDecode(s.toJson())).toList();
                  var jsonString = jsonEncode(list);
                  await GpPreferences().setString(key, jsonString);
                  loadConfig();
                  setState(() {});
                }
              }));
          List<Widget> startActions = [];
          startActions.add(SlidableAction(
              label: SL.of(context).remoteDbPage_edit, //"Edit"
              icon: SmashIcons.editIcon,
              foregroundColor: SmashColors.mainDecorations,
              onPressed: (context) async {
                var dbConfigMap = jsonDecode(source.toJson());
                var newMap =
                    await showRemoteDbPropertiesDialog(context, dbConfigMap);
                if (newMap != null) {
                  var layerSource = DbVectorLayerSource.fromMap(newMap);
                  sources[index] = layerSource!;
                  var list =
                      sources.map((s) => jsonDecode(s.toJson())).toList();
                  var jsonString = jsonEncode(list);
                  await GpPreferences().setString(key, jsonString);
                  loadConfig();
                  setState(() {});
                }
              }));

          return Slidable(
            startActionPane: ActionPane(
              extentRatio: 0.35,
              dragDismissible: false,
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: startActions,
            ),
            endActionPane: ActionPane(
              extentRatio: 0.35,
              dragDismissible: false,
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: endActions,
            ),
            child: ListTile(
              title: Text(url!),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                    "${SL.of(context).remoteDbPage_table}: $table  ${SL.of(context).remoteDbPage_user}: $user$where"), //table //user
              ),
              leading: FittedBox(
                fit: BoxFit.cover,
                child: Icon(
                  source.getIcon(),
                  color: SmashColors.mainDecorations,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip:
                        SL.of(context).remoteDbPage_loadInMap, //"Load in map."
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
            var dbJson = GpPreferences().getStringSync(key, "") ?? "";
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

Future<Map<String, dynamic>?> showRemoteDbPropertiesDialog(
    BuildContext context, Map<String, dynamic> dbConfigMap) async {
  return await showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(SL
            .of(context)
            .remoteDbPage_databaseParameters), //"Database Parameters"
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
          TextButton(
            child: Text(SL.of(context).remoteDbPage_cancel), //"CANCEL"
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          TextButton(
            child: Text(SL.of(context).remoteDbPage_ok), //"OK"
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

  RemoteDbPropertiesContainer(this.sourceMap, {Key? key}) : super(key: key);

  @override
  _RemoteDbPropertiesContainerState createState() =>
      _RemoteDbPropertiesContainerState(sourceMap);
}

class _RemoteDbPropertiesContainerState
    extends State<RemoteDbPropertiesContainer> {
  final Map<String, dynamic> sourceMap;
  List<String>? _geomTables;
  bool _isLoadingGeomTables = false;
  String? errorMessage;

  _RemoteDbPropertiesContainerState(this.sourceMap) {}

  @override
  Widget build(BuildContext context) {
    // _dbUrl = postgis:host:port/dbname
    var url = sourceMap[LAYERSKEY_URL] ?? "postgis:localhost:5432/dbname";
    var user = sourceMap[LAYERSKEY_USER] ?? "";
    String tableName = sourceMap[LAYERSKEY_LABEL] ?? "";
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
        var errorText = txt!.isEmpty
            ? SL
                .of(context)
                .remoteDbPage_theUrlNeedsToBeDefined //"The url needs to be defined (postgis:host:port/dbname)"
            : null;
        return errorText;
      },
    );
    var userEC = new TextEditingController(text: user);
    var userID = new InputDecoration(
        labelText: SL.of(context).remoteDbPage_user); //"user"
    var userWidget = new TextFormField(
      controller: userEC,
      autovalidateMode: AutovalidateMode.always,
      autofocus: false,
      decoration: userID,
      validator: (txt) {
        sourceMap[LAYERSKEY_USER] = txt;
        var errorText = txt!.isEmpty
            ? SL.of(context).remoteDbPage_theUserNeedsToBeDefined
            : //"The user needs to be defined."
            null;
        return errorText;
      },
    );
    var passwordEC = new TextEditingController(text: pwd);
    var passwordID = new InputDecoration(
        labelText: SL.of(context).remoteDbPage_password); //"password"
    var passwordWidget = new TextFormField(
      obscureText: true,
      controller: passwordEC,
      autovalidateMode: AutovalidateMode.always,
      autofocus: false,
      decoration: passwordID,
      validator: (txt) {
        sourceMap[LAYERSKEY_PWD] = txt;
        var errorText = txt!.isEmpty
            ? SL.of(context).remoteDbPage_thePasswordNeedsToBeDefined
            : //"The password needs to be defined."
            null;
        return errorText;
      },
    );

    Widget tableWidget;
    if (_isLoadingGeomTables) {
      tableWidget = SmashCircularProgress(
          label:
              SL.of(context).remoteDbPage_loadingTables); //"loading tables..."
    } else if (_geomTables != null && _geomTables!.isNotEmpty) {
      if (!_geomTables!.contains(tableName)) {
        tableName = _geomTables![0];
        sourceMap[LAYERSKEY_LABEL] = tableName;
      }
      tableWidget = DropdownButton<String>(
        isDense: false,
        isExpanded: true,
        value: tableName,
        items: _geomTables!
            .map((table) => DropdownMenuItem<String>(
                  child: Text(table),
                  value: table,
                ))
            .toList(),
        onChanged: (newSelection) {
          sourceMap[LAYERSKEY_LABEL] = newSelection;
          setState(() {});
        },
      );
    } else {
      var tableEC = new TextEditingController(text: tableName);
      var tableID = new InputDecoration(
          labelText: SL.of(context).remoteDbPage_table); //"table"
      var tableTextWidget = new TextFormField(
        controller: tableEC,
        autovalidateMode: AutovalidateMode.always,
        autofocus: false,
        decoration: tableID,
        validator: (txt) {
          sourceMap[LAYERSKEY_LABEL] = txt;
          var errorText = txt!.isEmpty
              ? SL.of(context).remoteDbPage_theTableNeedsToBeDefined
              : //"The table name needs to be defined."
              null;
          return errorText;
        },
      );
      tableWidget = Row(
        children: [
          Expanded(child: tableTextWidget),
          IconButton(
            icon: Icon(MdiIcons.refresh),
            onPressed: () async {
              errorMessage = null;
              setState(() {
                _isLoadingGeomTables = true;
              });
              try {
                var s = PostgisSource.fromMap(sourceMap);
                var db = await PostgisConnectionsHandler().open(
                    s.getUrl(), s.getName(), s.getUser(), s.getPassword());
                if (db != null) {
                  var tables = await db.getTables(true);
                  _geomTables = [];
                  for (var tableName in tables) {
                    bool isGeom =
                        await db.getGeometryColumnsForTable(tableName) != null;
                    if (isGeom) {
                      _geomTables!.add(tableName.name);
                    }
                  }
                  setState(() {
                    _isLoadingGeomTables = false;
                  });
                } else {
                  setState(() {
                    _isLoadingGeomTables = false;
                  });
                  SmashDialogs.showWarningDialog(
                      context,
                      SL
                          .of(context)
                          .remoteDbPage_unableToConnectToDatabase); //"Unable to connect to the database. Check parameters and network."
                }
              } catch (e) {
                errorMessage = e.toString();
                setState(() {
                  _isLoadingGeomTables = false;
                });
              }
            },
          )
        ],
      );
    }

    var whereEC = new TextEditingController(text: where);
    var whereID = new InputDecoration(
        labelText: SL
            .of(context)
            .remoteDbPage_optionalWhereCondition); //"optional where condition"
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
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SmashUI.normalText(errorMessage!,
                  color: SmashColors.mainDanger),
            ),
        ],
      ),
    );
  }
}
