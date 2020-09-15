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
  GlobalKey toolsButtonKey = GlobalKey();
  GlobalKey drawerButtonKey = GlobalKey();
  GlobalKey toolbarButtonKey = GlobalKey();
  GlobalKey coachMarkButtonKey = GlobalKey();

  List<TargetFocus> targets = List();

  void initCoachMarks() {
    var all = 11;
    var i = 1;
    const s = "Single tap: ";
    const l = "Long tap: ";
    const d = "Double tap: ";

    var title = "$i/$all Simple Notes Button";
    var singleTap = "${s}add a new note";
    var longTap = "${l}view notes list";
    var doubleTap = "${d}view notes settings";
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: simpleNotesButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all Form Notes Button";
    singleTap = "${s}add new form note";
    longTap = "${l}view form notes list";
    doubleTap = "${d}view notes settings";
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: formsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all GPS Log Button";
    singleTap = "${s}start logging/stop logging";
    longTap = "${l}view logs list";
    doubleTap = "${d}view logs settings";
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: logsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all GPS Info Button (if applicable)";
    singleTap = "${s}center map on GPS position";
    longTap = "${l}show GPS info";
    doubleTap = "${d}toggle automatic center on GPS";
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: gpsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all Layers View Button";
    singleTap = "${s}Open the layers view";
    longTap = null;
    doubleTap = "${d}Open the layer plugins dialog";
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: layersButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all Zoom In Button";
    singleTap = "Zoom in the map by one level";
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: zoomInButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all Zoom Out Button";
    singleTap = "Zoom out the map by one level";
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: zoomOutButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all Bottom Tools Button";
    singleTap = "Toggle bottom tools bar. ";
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: toolbarButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all Tools Button";
    singleTap =
        "Open the end drawer to access project info and sharing options as well as the MAP PLUGINS, feature tools and extras.";
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: toolsButtonKey,
      contents: [
        getContentTarget(title, singleTap, longTap, doubleTap,
            alignContent: AlignContent.bottom)
      ],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all Interactive coach marks button";
    singleTap =
        "Open the interactice coach marks that explain all the actions of the main map view.";
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: coachMarkButtonKey,
      contents: [
        getContentTarget(title, singleTap, longTap, doubleTap,
            alignContent: AlignContent.bottom)
      ],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all Main Menu Button";
    singleTap =
        "Open the drawer to load a project, create a new one, import and export data, synchronize with servers, access settings and exit the application/disable the GPS.";
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: drawerButtonKey,
      contents: [
        getContentTarget(title, singleTap, longTap, doubleTap,
            alignContent: AlignContent.bottom)
      ],
      shape: ShapeLightFocus.Circle,
    ));
  }

  ContentTarget getContentTarget(
      String title, String singleTap, String longTap, String doubleTap,
      {AlignContent alignContent = AlignContent.top}) {
    var size = SmashUI.MEDIUM_SIZE;
    var widgets = <Widget>[];

    widgets.add(SmashUI.titleText(title, useColor: true, bold: true));

    if (singleTap != null) {
      if (singleTap.contains(":")) {
        widgets.add(
          Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 4),
              child: getRichText(size, singleTap)),
        );
      } else {
        widgets.add(
          Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 4),
              child: SmashUI.normalText(singleTap,
                  color: SmashColors.mainBackground)),
        );
      }
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
        align: alignContent,
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
        alignSkip: Alignment.topCenter,
        textSkip: "",
        paddingFocus: 10,
        opacityShadow: 0.7, finish: () {
      // print("finish");
    }, clickTarget: (target) {
      // print(target);
    }, clickSkip: () {
      // print("skip");
    })
      ..show();
  }
}
