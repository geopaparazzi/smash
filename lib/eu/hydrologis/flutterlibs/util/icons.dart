/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'ui.dart';
import 'preferences.dart';
import 'colors.dart';

const List<String> DEFAULT_NOTES_ICONDATA = [
  'mapMarker',
  'circle',
  'home',
  'camera',
  'earth',
  'parking',
  'car',
  'wheelchairAccessibility',
  'shopping',
  'heart',
  'lightbulb',
  'bomb',
  'bell',
  'carrot',
  'alert',
  'flag',
  'information',
  'medicalBag',
  'emoticon',
  'emoticonAngry',
  'emoticonCool',
  'tag',
  'cupWater',
  'checkCircle',
  'tools',
  'delete',
  'account',
  'comment',
  'pizza',
  'truck',
  'thumbUp',
  'thumbDown',
];

IconData getIcon(String key) {
  var iconData = MdiIcons.fromString(key);
  if (iconData == null) {
    return MdiIcons.mapMarker;
  }
  return iconData;
}

/// The notes properties page.
class IconsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IconsWidgetState();
  }
}

class IconsWidgetState extends State<IconsWidget> {
  double _iconSize = 48;
  TextEditingController editingController = TextEditingController();
  List<List<dynamic>> _completeList = [];
  List<List<dynamic>> _visualizeList = [];
  List<String> chosenIconsList = [];

  @override
  void initState() {
    chosenIconsList.addAll(GpPreferences().getStringListSync(KEY_ICONS_LIST, DEFAULT_NOTES_ICONDATA));

    MdiIcons.getIconsName().forEach((name) {
      _completeList.add([name, MdiIcons.fromString(name)]);
    });
    _visualizeList = []..addAll(_completeList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        GpPreferences().setStringList(KEY_ICONS_LIST, chosenIconsList);
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Icons (${_visualizeList.length})"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.check_box_outline_blank),
                tooltip: "Unselect and view all icons",
                onPressed: () {
                  setState(() {
                    chosenIconsList.clear();
                    _visualizeList.clear();
                    _visualizeList.addAll(_completeList);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.check_box),
                tooltip: "Show only selected",
                onPressed: () {
                  setState(() {
                    _visualizeList.clear();
                    _visualizeList.addAll(_completeList.where((item) {
                      return chosenIconsList.contains(item[0]);
                    }).toList());
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.playlist_add_check),
                tooltip: "Select only default",
                onPressed: () {
                  setState(() {
                    chosenIconsList.addAll(DEFAULT_NOTES_ICONDATA);
                  });
                },
              ),
            ],
          ),
          body: Container(
              child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search icon by name",
                    hintText: "Search icon by name",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _visualizeList.length,
                itemBuilder: (context, index) {
                  var item = _visualizeList[index];
                  bool doCheck = chosenIconsList.contains(item[0]);
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(item[0],
                          style: TextStyle(
                            fontSize: SmashUI.NORMAL_SIZE,
                            color: SmashColors.mainDecorations,
                          )),
                    ),
                    leading: Icon(
                      item[1],
                      size: _iconSize,
                      color: SmashColors.mainDecorations,
                    ),
                    trailing: Checkbox(
                        value: doCheck,
                        onChanged: (check) {
                          setState(() {
                            if (check) {
                              chosenIconsList.add(item[0]);
                            } else {
                              chosenIconsList.remove(item[0]);
                            }
                          });
                        }),
                  );
                },
              ),
            ),
          ]))),
    );
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      query = query.toLowerCase();
      _visualizeList.clear();
      _completeList.forEach((item) {
        String name = item[0];
        if (name.toLowerCase().contains(query)) {
          _visualizeList.add(item);
        }
      });
      setState(() {});
      return;
    } else {
      setState(() {
        _visualizeList = []..addAll(_completeList);
      });
    }
  }
}
