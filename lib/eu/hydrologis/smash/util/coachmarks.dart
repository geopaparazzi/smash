import 'package:flutter/material.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/content_target.dart';
import 'package:tutorial_coach_mark/target_focus.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MainViewCoachMarks {
  GlobalKey simpleNotesButtonKey = GlobalKey();
  GlobalKey formsButtonKey = GlobalKey();
  GlobalKey logsButtonKey = GlobalKey();
  GlobalKey gpsButtonKey = GlobalKey();
  GlobalKey layersButtonKey = GlobalKey();
  GlobalKey zoomInButtonKey = GlobalKey();
  GlobalKey zoomOutButtonKey = GlobalKey();

  List<TargetFocus> targets = List();

  void initCoachMarks() {
    var title = "Simple Notes Button";
    var singleTap = "Single tap: add new note";
    var longTap = "Long tap: view notes list";
    var doubleTap = "Double tap: view notes settings";
    targets.add(TargetFocus(
      identify: "Target 1",
      keyTarget: simpleNotesButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));
    title = "Form Notes Button";
    singleTap = "Single tap: add new form note";
    longTap = "Long tap: view form notes list";
    doubleTap = "Double tap: view notes settings";
    targets.add(TargetFocus(
      identify: "Target 2",
      keyTarget: formsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));
    title = "GPS Log Button";
    singleTap = "Single tap: start logging/stop logging";
    longTap = "Long tap: view logs list";
    doubleTap = "Double tap: view logs settings";
    targets.add(TargetFocus(
      identify: "Target 3",
      keyTarget: logsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));
    title = "GPS Info Button";
    singleTap = "Single tap: center map on GPS position";
    longTap = "Long tap: show GPS info";
    doubleTap = "Double tap: toggle automatic center on GPS";
    targets.add(TargetFocus(
      identify: "Target 4",
      keyTarget: gpsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));
    title = "Layers View Button";
    singleTap = "single tap: open layers view";
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target 5",
      keyTarget: layersButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));
  }

  ContentTarget getContentTarget(
      String title, String singleTap, String longTap, String doubleTap) {
    var size = SmashUI.MEDIUM_SIZE;
    var widgets = <Widget>[];

    widgets.add(SmashUI.titleText(title, useColor: true, bold: true));

    if (singleTap != null) {
      widgets.add(
        Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 4),
            child: getRichText(size, singleTap)),
      );
    }
    if (longTap != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: getRichText(size, longTap),
        ),
      );
    }
    if (doubleTap != null) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: getRichText(size, doubleTap),
        ),
      );
    }

    return ContentTarget(
        align: AlignContent.top,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          ),
        ));
  }

  RichText getRichText(double size, String singleTap) {
    return RichText(
        text: TextSpan(
            style: TextStyle(
              color: SmashColors.mainBackground,
              fontWeight: FontWeight.normal,
              fontSize: size,
            ),
            children: [
          TextSpan(
              text: singleTap.substring(0, singleTap.indexOf(":")),
              style: TextStyle(
                color: SmashColors.mainBackground,
                fontWeight: FontWeight.bold,
                fontSize: size,
              )),
          TextSpan(
            text: singleTap.substring(singleTap.indexOf(":")),
          ),
        ]));
  }

  void showTutorial(BuildContext context) {
    TutorialCoachMark(context,
        targets: targets,
        colorShadow: SmashColors.mainDecorations,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.7, finish: () {
      // print("finish");
    }, clickTarget: (target) {
      print(target);
    }, clickSkip: () {
      // print("skip");
    })
      ..show();
  }
}
