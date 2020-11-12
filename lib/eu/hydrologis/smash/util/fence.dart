import 'dart:async';
import 'dart:convert';

import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:latlong/latlong.dart';
import 'package:smash/eu/hydrologis/smash/gps/gps.dart';
import 'package:smashlibs/smashlibs.dart';

class FenceMaster {
  static final KEY = "KEY_PREFERENCES_FENCES";
  static final DEFAULT_FENCE_RADIUS = 500;
  static final FenceMaster _singleton = FenceMaster._internal();

  static final JSON_TS = "ts";
  static final JSON_NAME = "name";
  static final JSON_RADIUS_METERS = "radm";
  static final JSON_LAT = "lat";
  static final JSON_LON = "lon";

  bool ringOnEnter = true;
  bool ringOnExit = true;
  Fence currentFence;
  bool firstPositionUpdate = true;

  List<Fence> fencesList;

  factory FenceMaster() {
    return _singleton;
  }
  FenceMaster._internal();

  void readFences() {
    currentFence = null;
    var fenceJson = GpPreferences().getStringSync(KEY, "");
    fencesList = [];
    if (fenceJson.isNotEmpty) {
      var json = jsonDecode(fenceJson);
      if (json is List<dynamic>) {
        json.forEach((fenceMap) {
          if (fenceMap is Map) {
            Fence fence = Fence()
              ..name = fenceMap[JSON_NAME]
              ..radius = fenceMap[JSON_RADIUS_METERS]
              ..lat = fenceMap[JSON_LAT]
              ..lon = fenceMap[JSON_LON];
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

    // add the buffer geom to use for intersection checks
    LatLng offsetLL = CoordinateUtilities.getAtOffset(
        LatLng(fence.lat, fence.lon), fence.radius, 90);
    var delta = (fence.lon - offsetLL.longitude).abs();
    var buffer = GeometryFactory.defaultPrecision()
        .createPoint(Coordinate(fence.lon, fence.lat))
        .buffer(delta);
    fence.buffer = buffer;
  }

  bool remove(Fence remFence) {
    return fencesList.remove(remFence);
  }

  Fence findIn(Coordinate center) {
    var centerP = GeometryFactory.defaultPrecision().createPoint(center);
    for (var i = 0; i < fencesList.length; i++) {
      var fence = fencesList[i];
      if (fence.buffer.intersects(centerP)) {
        return fence;
      }
    }
    return null;
  }

  Future<void> onPositionUpdate(Coordinate coordinate) async {
    if (fencesList.isEmpty) {
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
      if (ringOnEnter) {
        currentFence = fence;
        // ring
        FlutterRingtonePlayer.play(
          android: AndroidSounds.ringtone,
          ios: IosSounds.glass,
          looping: true,
          volume: 0.1,
          asAlarm: false,
        );
        Future.delayed(const Duration(seconds: (5)), () {
          FlutterRingtonePlayer.stop();
        });
      }
    } else if (fence == null && currentFence != null) {
      // exited fence
      if (ringOnExit) {
        currentFence = null;
        // ring
        FlutterRingtonePlayer.play(
          android: AndroidSounds.ringtone,
          ios: IosSounds.glass,
          looping: true,
          volume: 0.1,
          asAlarm: false,
        );
        Future.delayed(const Duration(seconds: (5)), () {
          FlutterRingtonePlayer.stop();
        });
      }
    }
  }
}

class Fence {
  int creationTs;
  String name;
  double radius;
  double lat;
  double lon;
  Geometry buffer;

  Fence() : creationTs = DateTime.now().millisecondsSinceEpoch;

  dynamic toJson() {
    return {
      FenceMaster.JSON_NAME: name,
      FenceMaster.JSON_NAME: name,
      FenceMaster.JSON_RADIUS_METERS: radius,
      FenceMaster.JSON_LAT: lat,
      FenceMaster.JSON_LON: lon,
    };
  }

  operator ==(other) => creationTs == other.creationTs;

  int get hashCode => HashUtilities.hashObjects([creationTs]);
}
