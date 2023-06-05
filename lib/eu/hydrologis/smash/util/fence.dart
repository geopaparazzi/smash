import 'dart:async';
import 'dart:convert';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart'
    hide TextStyle;
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smash/eu/hydrologis/smash/util/notifications.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/com/hydrologis/flutterlibs/utils/logging.dart';
import 'package:smashlibs/smashlibs.dart';

class FenceMaster {
  static final KEY = "KEY_PREFERENCES_FENCES";
  static final DEFAULT_FENCE_RADIUS = 500.0;
  static const DEFAULT_SOUND_DURATION = 5;
  static final FenceMaster _singleton = FenceMaster._internal();

  static final JSON_TS = "ts";
  static final JSON_NAME = "name";
  static final JSON_RADIUS_METERS = "radm";
  static final JSON_LAT = "lat";
  static final JSON_LON = "lon";
  static final JSON_ONENTER = "onenter";
  static final JSON_ONEXIT = "onexit";

  Fence? currentFence;
  bool firstPositionUpdate = true;

  bool _hasFences = false;

  late List<Fence> fencesList;

  factory FenceMaster() {
    return _singleton;
  }
  FenceMaster._internal();

  bool get hasFences => _hasFences;

  void readFences(BuildContext context) {
    currentFence = null;
    var fenceJson = GpPreferences().getStringSync(KEY, "")!;
    fencesList = [];
    if (fenceJson.isNotEmpty) {
      var json = jsonDecode(fenceJson);
      if (json is List<dynamic>) {
        json.forEach((fenceMap) {
          if (fenceMap is Map) {
            Fence fence = Fence(context)
              ..name = fenceMap[JSON_NAME]
              ..radius = fenceMap[JSON_RADIUS_METERS]
              ..lat = fenceMap[JSON_LAT]
              ..lon = fenceMap[JSON_LON]
              ..onEnter = ENotificationSounds.forName(fenceMap[JSON_ONENTER])
              ..onExit = ENotificationSounds.forName(fenceMap[JSON_ONEXIT]);
            var ts = fenceMap[JSON_TS];
            if (ts != null) {
              fence.creationTs = ts;
            }
            addFence(fence);
          }
        });
      }
    }
  }

  Future<void> writeFences() async {
    var jsonString = jsonEncode(fencesList);
    await GpPreferences().setString(KEY, jsonString);
  }

  void addFence(Fence fence) {
    fencesList.add(fence);
    _hasFences = true;
  }

  bool remove(Fence remFence) {
    if (!_hasFences) {
      return false;
    }
    var removed = fencesList.remove(remFence);
    _hasFences = fencesList.isNotEmpty;
    return removed;
  }

  Fence? findIn(Coordinate center) {
    if (!_hasFences) {
      return null;
    }
    if (_hasFences) {
      for (var i = 0; i < fencesList.length; i++) {
        var fence = fencesList[i];
        var distance = CoordinateUtilities.getDistance(
            center, Coordinate.fromYX(fence.lat, fence.lon));
        if (distance <= fence.radius) {
          return fence;
        }
      }
    }
    return null;
  }

  Future<void> onPositionUpdate(Coordinate coordinate) async {
    if (!_hasFences) {
      return;
    }
    var fence = findIn(coordinate);
    if (firstPositionUpdate) {
      firstPositionUpdate = false;
      currentFence = fence;
      return;
    }
    if (fence != null && currentFence == null) {
      // entered new fence
      SMLogger().d("ENTER ${fence.name}");
      currentFence = fence;
      if (fence.onEnter != null &&
          fence.onEnter != ENotificationSounds.nosound) {
        SMLogger().d("ENTER RING ${fence.name}");
        await fence.onEnter!
            .playTone(durationSeconds: FenceMaster.DEFAULT_SOUND_DURATION);
      }
      SMLogger().d("ENTER POST ${fence.name}");
    } else if (fence == null && currentFence != null) {
      // exited fence
      var tmpFence = currentFence!;
      currentFence = null;
      SMLogger().d("EXIT ${tmpFence.name}");
      if (tmpFence.onExit != null &&
          tmpFence.onExit != ENotificationSounds.nosound) {
        SMLogger().d("EXIT RING ${tmpFence.name}");
        await tmpFence.onExit!
            .playTone(durationSeconds: FenceMaster.DEFAULT_SOUND_DURATION);
      }
      SMLogger().d("EXIT POST ${tmpFence.name}");
    }
  }

  Future<Fence?> showFencePropertiesDialog(
      BuildContext context, Fence fence, bool allowDelete) async {
    return await showDialog<Fence>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(SL.of(context).fence_fenceProperties), //"Fence Properties"
          content: Builder(builder: (context) {
            var width = MediaQuery.of(context).size.width;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Container(
                  width: width,
                  child: FencePropertiesContainer(fence),
                ),
              ),
            );
          }),
          actions: <Widget>[
            if (allowDelete)
              TextButton(
                child: Text(
                  SL.of(context).fence_delete, //"DELETE"
                  style: TextStyle(color: SmashColors.mainDanger),
                ),
                onPressed: () async {
                  var res = await SmashDialogs.showConfirmDialog(
                          context,
                          SL.of(context).fence_removeFence, //"Remove fence"
                          "${SL.of(context).fence_areYouSureRemoveFence} ${fence.name}") //"Are you sure you want to remove fence:"
                      ??
                      false;
                  if (res) {
                    FenceMaster().remove(fence);
                  }
                  Navigator.of(context).pop(null);
                },
              ),
            TextButton(
              child: Text(SL.of(context).fence_cancel), //"CANCEL"
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: Text(SL.of(context).fence_ok), //"OK"
              onPressed: () {
                Navigator.of(context).pop(fence);
              },
            ),
          ],
        );
      },
    );
  }
}

class Fence {
  int creationTs;
  String name;
  double radius = FenceMaster.DEFAULT_FENCE_RADIUS;
  late double lat;
  late double lon;
  ENotificationSounds? onEnter = ENotificationSounds.nosound;
  ENotificationSounds? onExit = ENotificationSounds.nosound;

  Fence(BuildContext context)
      : creationTs = DateTime.now().millisecondsSinceEpoch,
        name = SL.of(context).fence_aNewFence; //"a new fence"

  dynamic toJson() {
    return {
      FenceMaster.JSON_TS: creationTs,
      FenceMaster.JSON_NAME: name,
      FenceMaster.JSON_RADIUS_METERS: radius,
      FenceMaster.JSON_LAT: lat,
      FenceMaster.JSON_LON: lon,
      FenceMaster.JSON_ONENTER: onEnter?.name,
      FenceMaster.JSON_ONEXIT: onExit?.name,
    };
  }

  operator ==(other) => creationTs == (other as Fence).creationTs;

  int get hashCode => HashUtilities.hashObjects([creationTs]);
}

class FencePropertiesContainer extends StatefulWidget {
  final Fence fence;

  FencePropertiesContainer(this.fence, {Key? key}) : super(key: key);

  @override
  _FencePropertiesContainerState createState() =>
      _FencePropertiesContainerState(fence);
}

class _FencePropertiesContainerState extends State<FencePropertiesContainer> {
  final Fence fence;

  _FencePropertiesContainerState(this.fence) {}

  @override
  Widget build(BuildContext context) {
    var nameEC = new TextEditingController(text: fence.name);
    var nameID = new InputDecoration(
        labelText: SL.of(context).fence_label, //"Label"
        hintText: SL.of(context).fence_aNameForFence); //"A name for the fence."
    var nameWidget = new TextFormField(
      controller: nameEC,
      autovalidateMode: AutovalidateMode.always,
      autofocus: false,
      decoration: nameID,
      validator: (txt) {
        fence.name = txt!;
        var nameErrorText = txt.isEmpty
            ? SL
                .of(context)
                .fence_theNameNeedsToBeDefined //"The name needs to be defined."
            : null;
        return nameErrorText;
      },
    );
    var radiusEC = new TextEditingController(text: fence.radius.toString());
    var radiusID = new InputDecoration(
        labelText: SL.of(context).fence_radius, //"Radius"
        hintText: SL
            .of(context)
            .fence_theFenceRadiusMeters); //"The fence radius in meters."
    var radiusWidget = new TextFormField(
      controller: radiusEC,
      autofocus: false,
      autovalidateMode: AutovalidateMode.always,
      decoration: radiusID,
      validator: (txt) {
        double? rad = double.tryParse(txt!);
        if (rad != null) {
          fence.radius = rad;
        }
        var radiusErrorText = txt.isEmpty || rad == null
            ? SL
                .of(context)
                .fence_radiusNeedsToBePositive //"The radius needs to be a positive number in meters."
            : null;
        return radiusErrorText;
      },
    );

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: nameWidget,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: radiusWidget,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: SmashUI.defaultRigthPadding() * 2,
                  child: SmashUI.smallText(
                      SL.of(context).fence_onEnter), //"On enter"
                ),
                DropdownButton<ENotificationSounds>(
                  items: ENotificationSounds.values
                      .map((ns) => DropdownMenuItem<ENotificationSounds>(
                            value: ns,
                            child: Text(
                              ns.name,
                              textAlign: TextAlign.center,
                            ),
                          ))
                      .toList(),
                  value: fence.onEnter,
                  onChanged: (newNs) {
                    setState(() {
                      fence.onEnter = newNs;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: SmashUI.defaultRigthPadding() * 2,
                  child: SmashUI.smallText(
                      SL.of(context).fence_onExit), //"On exit"
                ),
                DropdownButton<ENotificationSounds>(
                  items: ENotificationSounds.values
                      .map((ns) => DropdownMenuItem<ENotificationSounds>(
                            value: ns,
                            child: Text(
                              ns.name,
                              textAlign: TextAlign.center,
                            ),
                          ))
                      .toList(),
                  value: fence.onExit,
                  onChanged: (newNs) {
                    setState(() {
                      fence.onExit = newNs;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
