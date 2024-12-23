import 'package:dart_hydrologis_utils/dart_hydrologis_utils.dart';
import 'package:dart_jts/dart_jts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smash/eu/hydrologis/smash/models/project_state.dart';
import 'package:smash/eu/hydrologis/smash/project/project_database.dart';
import 'package:smashlibs/smashlibs.dart';

class ProjectStatsPage extends StatefulWidget {
  const ProjectStatsPage({key});

  @override
  State<ProjectStatsPage> createState() => Project_StatsPageState();
}

class Project_StatsPageState extends State<ProjectStatsPage> {
  bool isLoading = true;
  int formNotesCount = 0;
  int allNotesCount = 0;
  int logsCount = 0;
  Envelope? notesEnvelope;
  double notesEnvWidth = 0;
  double notesEnvHeight = 0;
  Envelope? logsEnvelope;
  double logEnvWidth = 0;
  double logEnvHeight = 0;

  String? notesStartDate;
  String? notesEndDate;
  String? logsLengthString;
  String? logStartDate;
  String? logEndDate;

  String? logNameFilter;

  initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((value) async {
      setState(() {
        isLoading = false;
      });
      collectStats(null);
    });
  }

  Future<void> collectStats(String? logPattern) async {
    var projectState = Provider.of<ProjectState>(context, listen: false);
    GeopaparazziProjectDb? db = projectState.projectDb;
    if (db == null) {
      return;
    }

    allNotesCount = db.getNotesCount(false);
    formNotesCount = db.getFormNotesCount(false);

    notesEnvelope = Envelope.empty();
    var notes = db.getNotes();
    int startTs = 0;
    int endTs = 0;
    for (var note in notes) {
      notesEnvelope!.expandToInclude(note.lon, note.lat);

      if (startTs == 0 || note.timeStamp < startTs) {
        startTs = note.timeStamp;
      }
      if (endTs == 0 || note.timeStamp > endTs) {
        endTs = note.timeStamp;
      }
    }
    notesStartDate = TimeUtilities.ISO8601_TS_FORMATTER
        .format(DateTime.fromMillisecondsSinceEpoch(startTs));
    notesEndDate = TimeUtilities.ISO8601_TS_FORMATTER
        .format(DateTime.fromMillisecondsSinceEpoch(endTs));

    // get envelope width and height
    notesEnvWidth = CoordinateUtilities.getDistance(
        Coordinate.fromYX(notesEnvelope!.getMinY(), notesEnvelope!.getMinX()),
        Coordinate.fromYX(notesEnvelope!.getMinY(), notesEnvelope!.getMaxX()));
    notesEnvHeight = CoordinateUtilities.getDistance(
        Coordinate.fromYX(notesEnvelope!.getMinY(), notesEnvelope!.getMinX()),
        Coordinate.fromYX(notesEnvelope!.getMaxY(), notesEnvelope!.getMinX()));

    var logs = db.getLogs();
    logsCount = 0;

    double totalLength = 0;
    int startTsLogs = 0;
    int endTsLogs = 0;
    logsEnvelope = Envelope.empty();
    for (var log in logs) {
      if (logNameFilter != null) {
        if (!log.text!.toLowerCase().contains(logNameFilter!.toLowerCase())) {
          continue;
        }
      }
      logsCount++;

      var pointsList = db.getLogDataPoints(log.id!);

      for (int i = 0; i < pointsList.length - 1; i++) {
        // calculate the length
        LogDataPoint ldp1 = pointsList[i];
        LogDataPoint ldp2 = pointsList[i + 1];
        double distance;
        if (ldp1.filtered_lat != null) {
          distance = CoordinateUtilities.getDistance(
              Coordinate.fromYX(ldp1.filtered_lat!, ldp1.filtered_lon!),
              Coordinate.fromYX(ldp2.filtered_lat!, ldp2.filtered_lon!));

          if (i == 0) {
            logsEnvelope!
                .expandToInclude(ldp1.filtered_lon!, ldp1.filtered_lat!);
          }
          logsEnvelope!.expandToInclude(ldp2.filtered_lon!, ldp2.filtered_lat!);
        } else {
          distance = CoordinateUtilities.getDistance(
              Coordinate.fromYX(ldp1.lat, ldp1.lon),
              Coordinate.fromYX(ldp2.lat, ldp2.lon));

          if (i == 0) {
            logsEnvelope!.expandToInclude(ldp1.lon, ldp1.lat);
          }
          logsEnvelope!.expandToInclude(ldp2.lon, ldp2.lat);
        }
        totalLength += distance;
      }

      var tmp = log.startTime ?? 0;
      if (startTsLogs == 0 || tmp < startTsLogs) {
        startTsLogs = tmp;
      }
      tmp = log.endTime ?? 0;
      if (endTsLogs == 0 || tmp > endTsLogs) {
        endTsLogs = tmp;
      }
    }
    logsLengthString = lengthToString(totalLength);
    logStartDate = TimeUtilities.ISO8601_TS_FORMATTER
        .format(DateTime.fromMillisecondsSinceEpoch(startTsLogs));
    logEndDate = TimeUtilities.ISO8601_TS_FORMATTER
        .format(DateTime.fromMillisecondsSinceEpoch(endTsLogs));

    logEnvWidth = CoordinateUtilities.getDistance(
        Coordinate.fromYX(logsEnvelope!.getMinY(), logsEnvelope!.getMinX()),
        Coordinate.fromYX(logsEnvelope!.getMinY(), logsEnvelope!.getMaxX()));

    logEnvHeight = CoordinateUtilities.getDistance(
        Coordinate.fromYX(logsEnvelope!.getMinY(), logsEnvelope!.getMinX()),
        Coordinate.fromYX(logsEnvelope!.getMaxY(), logsEnvelope!.getMinX()));

    setState(() {
      isLoading = false;
    });
  }

  String lengthToString(double length) {
    if (length > 1000) {
      var lengthKm = length / 1000;
      var l = (lengthKm * 10).toInt() / 10.0;
      return "${l.toStringAsFixed(1)} km";
    } else {
      return "${length.round()} m";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Stats'),
      ),
      body: isLoading
          ? SmashCircularProgress(label: "Loading project data...")
          : ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: SmashUI.titleText('Notes count',
                      color: SmashColors.mainDecorations),
                  subtitle: SmashUI.normalText(
                      'Collected $allNotesCount notes, of which $formNotesCount are form notes.'),
                ),
                ListTile(
                  title: SmashUI.titleText('Notes temporal envelope',
                      color: SmashColors.mainDecorations),
                  subtitle: SmashUI.normalText(
                      'From $notesStartDate to $notesEndDate.'),
                ),
                ListTile(
                  title: SmashUI.titleText('Notes spatial envelope',
                      color: SmashColors.mainDecorations),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmashUI.normalText(
                          'Envelope: ${notesEnvelope!.getMinX().toStringAsFixed(6)}, ${notesEnvelope!.getMinY().toStringAsFixed(6)} - ${notesEnvelope!.getMaxX().toStringAsFixed(6)}, ${notesEnvelope!.getMaxY().toStringAsFixed(6)}'),
                      SmashUI.normalText(
                          'Width: ${lengthToString(notesEnvWidth)}, Height: ${lengthToString(notesEnvHeight)}'),
                    ],
                  ),
                ),
                ListTile(
                  title: SmashUI.titleText('Logs count',
                      color: SmashColors.mainDecorations),
                  subtitle: SmashUI.normalText('Collected $logsCount logs.'),
                ),
                ListTile(
                  title: SmashUI.titleText('Logs temporal envelope',
                      color: SmashColors.mainDecorations),
                  subtitle:
                      SmashUI.normalText('From $logStartDate to $logEndDate.'),
                ),
                ListTile(
                  title: SmashUI.titleText('Logs spatial envelope',
                      color: SmashColors.mainDecorations),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmashUI.normalText(
                          'Envelope: ${logsEnvelope!.getMinX().toStringAsFixed(6)}, ${logsEnvelope!.getMinY().toStringAsFixed(6)} - ${logsEnvelope!.getMaxX().toStringAsFixed(6)}, ${logsEnvelope!.getMaxY().toStringAsFixed(6)}'),
                      SmashUI.normalText(
                          'Width: ${lengthToString(logEnvWidth)}, Height: ${lengthToString(logEnvHeight)}'),
                    ],
                  ),
                ),
                ListTile(
                  title: SmashUI.titleText('Logs length',
                      color: SmashColors.mainDecorations),
                  subtitle:
                      SmashUI.normalText('Total length: $logsLengthString.'),
                ),
                ListTile(
                  title: SmashUI.titleText('Filter logs by name',
                      color: SmashColors.mainDecorations),
                  subtitle: TextField(
                    onChanged: (value) async {
                      logNameFilter = value;
                      setState(() {
                        isLoading = false;
                      });
                      collectStats(logNameFilter);
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter a log name to filter logs',
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
