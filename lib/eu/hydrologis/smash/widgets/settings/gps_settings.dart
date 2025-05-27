import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/gps/filters.dart';
import 'package:smash/eu/hydrologis/smash/gps/testlog.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';

class GpsSettings extends StatefulWidget {
  @override
  GpsSettingsState createState() {
    return GpsSettingsState();
  }
}

class GpsSettingsState extends State<GpsSettings> {
  //static final title = "GPS";
  //static final subtitle = "GPS filters and mock locations";
  static final iconData = MdiIcons.crosshairsGps;
  List<GpsFilterManagerMessage> gpsInfoList = [];
  List<int> gpsInfoListCounter = [];
  int _count = 0;
  bool isPaused = false;

  late MapController _mapController;
  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          title: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  iconData,
                  color: SmashColors.mainBackground,
                ),
              ),
              Text(SL.of(context).settings_gps), //"GPS"
            ],
          ),
          bottom: TabBar(tabs: [
            Tab(text: SL.of(context).settings_settings), //"Settings"
            Tab(text: SL.of(context).settings_livePreview), //"Live Preview"
          ]),
        ),
        body: TabBarView(children: [
          getSettingsPart(context),
          getLivePreviewPart(context),
        ]),
      ),
    );
  }

  Widget getLivePreviewPart(BuildContext context) {
    return Consumer<GpsState>(builder: (context, gpsState, child) {
      if (!isPaused) {
        var msg = GpsFilterManager().currentMessage;
        if (!gpsInfoList.contains(msg) &&
            msg != null &&
            msg.newPosLatLon != null) {
          gpsInfoList.insert(0, msg);
          gpsInfoListCounter.insert(0, _count);
          _count++;
          if (gpsInfoList.length > 50) {
            gpsInfoList.removeRange(50, gpsInfoList.length);
          }
        }
      }

      if (gpsInfoList.isEmpty) {
        return SmashCircularProgress(
            label: SL
                .of(context)
                .settings_noPointAvailableYet); //"No point available yet."
      }

      var layer = MarkerLayer(
        markers: gpsInfoList.map((msg) {
          var clr = Colors.red.withAlpha(100);
          if (msg == gpsInfoList.first) {
            clr = Colors.blue.withAlpha(150);
          }

          return Marker(
            width: 10,
            height: 10,
            point: LatLngExt.fromCoordinate(msg.newPosLatLon!),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Icon(
                    MdiIcons.circle,
                    color: clr,
                    size: 10,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );

      return Stack(
        children: <Widget>[
          FlutterMap(
            options: new MapOptions(
              initialCenter:
                  LatLngExt.fromCoordinate(gpsInfoList.last.newPosLatLon!),
              initialZoom: 19,
              minZoom: 7,
              maxZoom: 21,
            ),
            children: [layer],
            mapController: _mapController,
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: gpsInfoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    GpsFilterManagerMessage msg = gpsInfoList[index];
                    int i = gpsInfoListCounter[index];
                    var infoMap = {
                      SL.of(context).settings_longitudeDeg: //"longitude [deg]"
                          msg.newPosLatLon!.x.toStringAsFixed(6),
                      SL.of(context).settings_latitudeDeg: //"latitude [deg]"
                          msg.newPosLatLon!.y.toStringAsFixed(6),
                      SL.of(context).settings_accuracyM: //"accuracy [m]"
                          msg.accuracy!.toStringAsFixed(0),
                      SL.of(context).settings_altitudeM: //"altitude [m]"
                          msg.altitude!.toStringAsFixed(0),
                      SL.of(context).settings_headingDeg: //"heading [deg]"
                          msg.heading!.toStringAsFixed(0),
                      SL.of(context).settings_speedMS: //"speed [m/s]"
                          msg.speed!.toStringAsFixed(0),
                      SL.of(context).settings_isLogging: //"is logging?"
                          msg.isLogging,
                      SL.of(context).settings_mockLocations: //"mock locations?"
                          msg.mocked,
                    };

                    var infoTable = TableUtilities.fromMap(infoMap,
                        doSmallText: true,
                        borderColor: SmashColors.mainDecorations,
                        backgroundColor: Colors.white.withAlpha(0),
                        withBorder: true);

                    double distanceLastEvent = msg.distanceLastEvent!;
                    int minAllowedDistanceLastEvent =
                        msg.minAllowedDistanceLastEvent!;

                    int timeLastEvent = msg.timeDeltaLastEvent!;
                    int minAllowedTimeLastEvent =
                        msg.minAllowedTimeDeltaLastEvent!;

                    bool minDistFilterBlocks =
                        distanceLastEvent <= minAllowedDistanceLastEvent;
                    bool minTimeFilterBlocks =
                        timeLastEvent <= minAllowedTimeLastEvent;

                    var minDistString = minDistFilterBlocks
                        ? SL
                            .of(context)
                            .settings_minDistFilterBlocks //"MIN DIST FILTER BLOCKS"
                        : SL
                            .of(context)
                            .settings_minDistFilterPasses; //"Min dist filter passes"
                    var minTimeString = minTimeFilterBlocks
                        ? SL
                            .of(context)
                            .settings_minTimeFilterBlocks //"MIN TIME FILTER BLOCKS"
                        : SL
                            .of(context)
                            .settings_minTimeFilterPasses; //"Min time filter passes"

                    bool hasBeenBlocked = msg.blockedByFilter;
                    var filterMap = {
                      SL
                              .of(context)
                              .settings_hasBeenBlocked: //"HAS BEEN BLOCKED"
                          "$hasBeenBlocked",
                      SL
                              .of(context)
                              .settings_distanceFromPrevM: //"Distance from prev [m]"
                          distanceLastEvent,
                      SL
                              .of(context)
                              .settings_timeFromPrevS: //"Time from prev [s]"
                          timeLastEvent,
                      minDistString:
                          "$distanceLastEvent <= $minAllowedDistanceLastEvent",
                      minTimeString:
                          "$timeLastEvent <= $minAllowedTimeLastEvent",
                    };
                    var filtersTable = TableUtilities.fromMap(
                      filterMap,
                      doSmallText: true,
                      borderColor: Colors.orange,
                      withBorder: true,
                      colWidthFlex: [0.6, 0.4],
                      highlightPattern: "BLOCKS",
                      highlightColor: Colors.orange.withAlpha(128),
                      backgroundColor: Colors.white.withAlpha(0),
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: ListTile(
                        title: Text(
                            "$i        " +
                                DateTime.fromMillisecondsSinceEpoch(
                                        (msg.timestamp).toInt())
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: SmashColors.mainDecorations)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                          SL
                                              .of(context)
                                              .settings_locationInfo, //"Location Info"
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  SmashColors.mainDecorations)),
                                    ),
                                    Expanded(child: infoTable),
                                  ],
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    RotatedBox(
                                      quarterTurns: 3,
                                      child: Text(
                                        SL
                                            .of(context)
                                            .settings_filters, //"Filters"
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange),
                                      ),
                                    ),
                                    Expanded(child: filtersTable),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: SmashColors.mainDecorations,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      tooltip: GpsFilterManager().filtersEnabled
                          ? SL
                              .of(context)
                              .settings_disableFilters //"Disable Filters."
                          : SL
                              .of(context)
                              .settings_enableFilters, //"Enable Filters."
                      icon: Icon(
                        GpsFilterManager().filtersEnabled
                            ? MdiIcons.filterRemove
                            : MdiIcons.filter,
                        color: SmashColors.mainBackground,
                      ),
                      onPressed: () {
                        setState(() {
                          GpsFilterManager().filtersEnabled =
                              !GpsFilterManager().filtersEnabled;
                        });
                      },
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    IconButton(
                      tooltip: SL.of(context).settings_zoomIn, //"Zoom in"
                      icon: Icon(
                        SmashIcons.zoomInIcon,
                        color: SmashColors.mainBackground,
                      ),
                      onPressed: () {
                        var z = _mapController.camera.zoom + 1;
                        if (z > 21) z = 21;
                        _mapController.move(
                            LatLngExt.fromCoordinate(
                                gpsInfoList.last.newPosLatLon!),
                            z);
                      },
                    ),
                    IconButton(
                      tooltip: SL.of(context).settings_zoomOut, //"Zoom out"
                      icon: Icon(
                        SmashIcons.zoomOutIcon,
                        color: SmashColors.mainBackground,
                      ),
                      onPressed: () {
                        var z = _mapController.camera.zoom - 1;
                        if (z < 7) z = 7;
                        _mapController.move(
                            LatLngExt.fromCoordinate(
                                gpsInfoList.last.newPosLatLon!),
                            z);
                      },
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    IconButton(
                      tooltip: isPaused
                          ? SL
                              .of(context)
                              .settings_activatePointFlow //"Activate point flow."
                          : SL
                              .of(context)
                              .settings_pausePointsFlow, //"Pause points flow."
                      icon: Icon(isPaused ? MdiIcons.play : MdiIcons.pause,
                          color: SmashColors.mainBackground),
                      onPressed: () {
                        setState(() {
                          isPaused = !isPaused;
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      );
    });
  }

  SingleChildScrollView getSettingsPart(BuildContext context) {
    int minDistance = GpPreferences().getIntSync(
            SmashPreferencesKeys.KEY_GPS_MIN_DISTANCE,
            SmashPreferencesKeys.MINDISTANCES[1]) ??
        SmashPreferencesKeys.MINDISTANCES[1];
    int timeInterval = GpPreferences().getIntSync(
            SmashPreferencesKeys.KEY_GPS_TIMEINTERVAL,
            SmashPreferencesKeys.TIMEINTERVALS[1]) ??
        SmashPreferencesKeys.TIMEINTERVALS[1];
    bool doTestLog = GpPreferences()
        .getBooleanSync(SmashPreferencesKeys.KEY_GPS_TESTLOG, false);
    var testlogDurationKey = "KEY_GPS_TESTLOG_DURATIONMILLIS";
    int testLogDuration =
        GpPreferences().getIntSync(testlogDurationKey, 500) ?? 500;
    bool useGpsFilteredGenerally = GpPreferences().getBooleanSync(
        SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY, true);

    // SmashLocationAccuracy locationAccuracy =
    //     SmashLocationAccuracy.fromPreferences();
    // var accuraciesList = SmashLocationAccuracy.values();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          // TODO enable this when the locationaccuracy works properly
          // Card(
          //   margin: SmashUI.defaultMargin(),
          //   // elevation: SmashUI.DEFAULT_ELEVATION,
          //   color: SmashColors.mainBackground,
          //   child: Column(
          //     children: <Widget>[
          //       Padding(
          //         padding: SmashUI.defaultPadding(),
          //         child: SmashUI.normalText("GPS accuracy",
          //             bold: true, textAlign: TextAlign.start),
          //       ),
          //       ListTile(
          //         leading: Icon(MdiIcons.crosshairsQuestion),
          //         title: Text("System accuracy to use."),
          //         subtitle: Wrap(
          //           children: <Widget>[
          //             DropdownButton<int>(
          //               value: locationAccuracy.code,
          //               isExpanded: false,
          //               items: accuraciesList.map((i) {
          //                 return DropdownMenuItem<int>(
          //                   child: Text(
          //                     i.label,
          //                     textAlign: TextAlign.center,
          //                   ),
          //                   value: i.code,
          //                 );
          //               }).toList(),
          //               onChanged: (selected) async {
          //                 if (locationAccuracy.code != selected) {
          //                   var newAccuracy =
          //                       SmashLocationAccuracy.fromCode(selected);
          //                   await SmashLocationAccuracy.toPreferences(
          //                       newAccuracy);
          //                   GpsHandler().restartLocationsService();
          //                   setState(() {});
          //                 }
          //               },
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Card(
            margin: SmashUI.defaultMargin(),
            // elevation: SmashUI.DEFAULT_ELEVATION,
            color: SmashColors.mainBackground,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: SmashUI.normalText(
                      SL.of(context).settings_logFilters, //"Log filters"
                      bold: true,
                      textAlign: TextAlign.start),
                ),
                ListTile(
                  leading: Icon(MdiIcons.ruler),
                  title: Text(SL
                      .of(context)
                      .settings_minDistanceBetween2Points), //"Min distance between 2 points."
                  subtitle: Wrap(
                    children: <Widget>[
                      DropdownButton<int>(
                        value: minDistance,
                        isExpanded: false,
                        items: SmashPreferencesKeys.MINDISTANCES.map((i) {
                          return DropdownMenuItem<int>(
                            child: Text(
                              "$i m",
                              textAlign: TextAlign.center,
                            ),
                            value: i,
                          );
                        }).toList(),
                        onChanged: (selected) async {
                          await GpPreferences().setInt(
                              SmashPreferencesKeys.KEY_GPS_MIN_DISTANCE,
                              selected!);
                          var gpsState =
                              Provider.of<GpsState>(context, listen: false);
                          gpsState.gpsMinDistance = selected;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(MdiIcons.timelapse),
                  title: Text(SL
                      .of(context)
                      .settings_minTimespanBetween2Points), //"Min timespan between 2 points."
                  subtitle: Wrap(
                    children: <Widget>[
                      DropdownButton<int>(
                        value: timeInterval,
                        isExpanded: false,
                        items: SmashPreferencesKeys.TIMEINTERVALS.map((i) {
                          return DropdownMenuItem<int>(
                            child: Text(
                              "$i sec",
                              textAlign: TextAlign.center,
                            ),
                            value: i,
                          );
                        }).toList(),
                        onChanged: (selected) async {
                          await GpPreferences().setInt(
                              SmashPreferencesKeys.KEY_GPS_TIMEINTERVAL,
                              selected!);
                          var gpsState =
                              Provider.of<GpsState>(context, listen: false);
                          gpsState.gpsTimeInterval = selected;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: SmashUI.defaultMargin(),
            color: SmashColors.mainBackground,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: SmashUI.normalText(SL.of(context).settings_gpsFilter,
                      bold: true), //"GPS Filter"
                ),
                ListTile(
                  leading: Icon(MdiIcons.filter),
                  title: Text(
                      "${useGpsFilteredGenerally ? SL.of(context).settings_disable : SL.of(context).settings_enable} ${SL.of(context).settings_theUseOfTheGps}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: SmashUI.defaultTBPadding(),
                        child: Text(
                          SL
                              .of(context)
                              .settings_warningThisWillAffectGpsPosition, //"WARNING: This will affect GPS position, notes insertion, log statistics and charting."
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Checkbox(
                        value: useGpsFilteredGenerally,
                        onChanged: (newValue) async {
                          var gpsState =
                              Provider.of<GpsState>(context, listen: false);
                          gpsState.useFilteredGpsQuiet = newValue!;
                          await GpPreferences().setBoolean(
                              SmashPreferencesKeys.KEY_GPS_USE_FILTER_GENERALLY,
                              newValue);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: SmashUI.defaultMargin(),
            color: SmashColors.mainBackground,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: SmashUI.defaultPadding(),
                  child: SmashUI.normalText(
                      SL.of(context).settings_MockLocations,
                      bold: true), //"Mock locations"
                ),
                ListTile(
                  leading: Icon(MdiIcons.crosshairsGps),
                  title: Text(
                      "${doTestLog ? SL.of(context).settings_disable : SL.of(context).settings_enable} ${SL.of(context).settings_testGpsLogDemoUse}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: doTestLog,
                        onChanged: (newValue) async {
                          await GpPreferences().setBoolean(
                              SmashPreferencesKeys.KEY_GPS_TESTLOG, newValue!);
                          var gpsState =
                              Provider.of<GpsState>(context, listen: false);
                          gpsState.doTestLog = newValue;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(MdiIcons.timer),
                  title: Text(SL
                      .of(context)
                      .settings_setDurationGpsPointsInMilli), //"Set duration for GPS points in milliseconds."
                  subtitle: TextButton(
                      style: SmashUI.defaultFlatButtonStyle(),
                      onPressed: () async {
                        var newValue = await SmashDialogs.showInputDialog(
                            context,
                            SL.of(context).settings_SETTING, //"SETTING"
                            SL
                                .of(context)
                                .settings_setMockedGpsDuration, //"Set Mocked GPS duration"
                            defaultText: "$testLogDuration",
                            validationFunction: (value) {
                          if (int.tryParse(value) == null) {
                            return SL
                                .of(context)
                                .settings_theValueHasToBeInt; //"The value has to be an integer."
                          }
                          return null;
                        });
                        if (newValue != null) {
                          var newMillis = int.parse(newValue);
                          TestLogStream().setNewDuration(newMillis);
                          await GpPreferences()
                              .setInt(testlogDurationKey, newMillis);
                          setState(() {});
                        }
                      },
                      child: Text(
                          "$testLogDuration ${SL.of(context).settings_milliseconds}")), //milliseconds
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
