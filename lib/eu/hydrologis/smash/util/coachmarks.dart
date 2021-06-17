import 'package:flutter/material.dart';
import 'package:smash/generated/l10n.dart';
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
    var s = SL.current.coachMarks_singleTap; //"Single tap: "
    var l = SL.current.coachMarks_longTap; //"Long tap: "
    var d = SL.current.coachMarks_doubleTap; //"Double tap: "

    var title =
        "$i/$all ${SL.current.coachMarks_simpleNoteButton}"; //Simple Notes Button
    var singleTap =
        "${s}${SL.current.coachMarks_addNewNote}"; //"add a new note"
    var longTap =
        "${l}${SL.current.coachMarks_viewNotesList}"; //"view notes list"
    var doubleTap =
        "${d}${SL.current.coachMarks_viewNotesSettings}"; //"view notes settings"
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: simpleNotesButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title =
        "$i/$all ${SL.current.coachMarks_formNotesButton}"; //"Form Notes Button"
    singleTap =
        "${s}${SL.current.coachMarks_addNewFormNote}"; //"add new form note"
    longTap =
        "${l}${SL.current.coachMarks_viewFormNoteList}"; //"view form notes list"
    doubleTap =
        "${d}${SL.current.coachMarks_viewNotesSettings}"; //"view notes settings"
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: formsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all ${SL.current.coachMarks_gpsLogButton}"; //"GPS Log Button"
    singleTap =
        "${s}${SL.current.coachMarks_startStopLogging}"; //"start logging/stop logging"
    longTap = "${l}${SL.current.coachMarks_viewLogsList}"; //"view logs list"
    doubleTap =
        "${d}${SL.current.coachMarks_viewLogsSettings}"; //"view logs settings"
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: logsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title =
        "$i/$all ${SL.current.coachMarks_gpsInfoButton}"; //"GPS Info Button (if applicable)"
    singleTap =
        "${s}${SL.current.coachMarks_centerMapOnGpsPos}"; //"center map on GPS position"
    longTap = "${l}${SL.current.coachMarks_showGpsInfo}"; //"show GPS info"
    doubleTap =
        "${d}${SL.current.coachMarks_toggleAutoCenterGps}"; //"toggle automatic center on GPS"
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: gpsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title =
        "$i/$all ${SL.current.coachMarks_layersViewButton}"; //"Layers View Button"
    singleTap =
        "${s}${SL.current.coachMarks_openLayersView}"; //"Open the layers view"
    longTap = null;
    doubleTap =
        "${d}${SL.current.coachMarks_openLayersPluginDialog}"; //"Open the layer plugins dialog"
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: layersButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all ${SL.current.coachMarks_zoomInButton}"; //"Zoom In Button"
    singleTap = SL
        .current.coachMarks_zoomImMapOneLevel; //"Zoom in the map by one level"
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: zoomInButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title =
        "$i/$all ${SL.current.coachMarks_zoomOutButton}"; //"Zoom Out Button"
    singleTap = SL.current
        .coachMarks_zoomOutMapOneLevel; //"Zoom out the map by one level"
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: zoomOutButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title =
        "$i/$all ${SL.current.coachMarks_bottomToolsButton}"; //"Bottom Tools Button"
    singleTap = SL
        .current.coachMarks_toggleBottomToolsBar; //"Toggle bottom tools bar. "
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: toolbarButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all ${SL.current.coachMarks_toolsButton}"; //"Tools Button"
    singleTap = SL.current
        .coachMarks_openEndDrawerToAccessProject; //"Open the end drawer to access project info and sharing options as well as the MAP PLUGINS, feature tools and extras."
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

    title =
        "$i/$all ${SL.current.coachMarks_interactiveCoachMarksButton}"; //"Interactive coach marks button"
    singleTap = SL.current
        .coachMarks_openInteractiveCoachMarks; //"Open the interactice coach marks that explain all the actions of the main map view."
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

    title =
        "$i/$all ${SL.current.coachMarks_mainMenuButton}"; //"Main Menu Button"
    singleTap = SL.current
        .coachMarks_openDrawerToLoadProject; //"Open the drawer to load a project, create a new one, import and export data, synchronize with servers, access settings and exit the application/disable the GPS."
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
        textSkip: SL.of(context).coachMarks_skip, //"SKIP"
        paddingFocus: 10,
        opacityShadow: 0.7, onFinish: () {
      // print("finish");
    }, onClickTarget: (target) {
      // print(target);
    }, onClickSkip: () {
      // print("skip");
    })
      ..show();
  }
}
