import 'package:flutter/material.dart';
import 'package:smash/eu/hydrologis/smash/l10n/localization.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MainViewCoachMarks with Localization {
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

  List<TargetFocus> targets = [];

  void initCoachMarks() {
    var all = 11;
    var i = 1;
    var s = loc.coachMarks_singleTap; //"Single tap: "
    var l = loc.coachMarks_longTap; //"Long tap: "
    var d = loc.coachMarks_doubleTap; //"Double tap: "

    var title =
        "$i/$all ${loc.coachMarks_simpleNoteButton}"; //Simple Notes Button
    String? singleTap = "${s}${loc.coachMarks_addNewNote}"; //"add a new note"
    String? longTap = "${l}${loc.coachMarks_viewNotesList}"; //"view notes list"
    String? doubleTap =
        "${d}${loc.coachMarks_viewNotesSettings}"; //"view notes settings"
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: simpleNotesButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all ${loc.coachMarks_formNotesButton}"; //"Form Notes Button"
    singleTap = "${s}${loc.coachMarks_addNewFormNote}"; //"add new form note"
    longTap = "${l}${loc.coachMarks_viewFormNoteList}"; //"view form notes list"
    doubleTap =
        "${d}${loc.coachMarks_viewNotesSettings}"; //"view notes settings"
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: formsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all ${loc.coachMarks_gpsLogButton}"; //"GPS Log Button"
    singleTap =
        "${s}${loc.coachMarks_startStopLogging}"; //"start logging/stop logging"
    longTap = "${l}${loc.coachMarks_viewLogsList}"; //"view logs list"
    doubleTap = "${d}${loc.coachMarks_viewLogsSettings}"; //"view logs settings"
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: logsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title =
        "$i/$all ${loc.coachMarks_gpsInfoButton}"; //"GPS Info Button (if applicable)"
    singleTap =
        "${s}${loc.coachMarks_centerMapOnGpsPos}"; //"center map on GPS position"
    longTap = "${l}${loc.coachMarks_showGpsInfo}"; //"show GPS info"
    doubleTap =
        "${d}${loc.coachMarks_toggleAutoCenterGps}"; //"toggle automatic center on GPS"
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: gpsButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all ${loc.coachMarks_layersViewButton}"; //"Layers View Button"
    singleTap = "${s}${loc.coachMarks_openLayersView}"; //"Open the layers view"
    longTap = null;
    doubleTap =
        "${d}${loc.coachMarks_openLayersPluginDialog}"; //"Open the layer plugins dialog"
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: layersButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all ${loc.coachMarks_zoomInButton}"; //"Zoom In Button"
    singleTap =
        loc.coachMarks_zoomImMapOneLevel; //"Zoom in the map by one level"
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: zoomInButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all ${loc.coachMarks_zoomOutButton}"; //"Zoom Out Button"
    singleTap =
        loc.coachMarks_zoomOutMapOneLevel; //"Zoom out the map by one level"
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: zoomOutButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title =
        "$i/$all ${loc.coachMarks_bottomToolsButton}"; //"Bottom Tools Button"
    singleTap =
        loc.coachMarks_toggleBottomToolsBar; //"Toggle bottom tools bar. "
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: toolbarButtonKey,
      contents: [getContentTarget(title, singleTap, longTap, doubleTap)],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all ${loc.coachMarks_toolsButton}"; //"Tools Button"
    singleTap = loc
        .coachMarks_openEndDrawerToAccessProject; //"Open the end drawer to access project info and sharing options as well as the MAP PLUGINS, feature tools and extras."
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: toolsButtonKey,
      contents: [
        getContentTarget(title, singleTap, longTap, doubleTap,
            alignContent: ContentAlign.bottom)
      ],
      shape: ShapeLightFocus.Circle,
    ));

    title =
        "$i/$all ${loc.coachMarks_interactiveCoackMarksButton}"; //"Interactive coach marks button"
    singleTap = loc
        .coachMarks_openInteractiveCoachMarks; //"Open the interactice coach marks that explain all the actions of the main map view."
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: coachMarkButtonKey,
      contents: [
        getContentTarget(title, singleTap, longTap, doubleTap,
            alignContent: ContentAlign.bottom)
      ],
      shape: ShapeLightFocus.Circle,
    ));

    title = "$i/$all ${loc.coachMarks_mainMenuButton}"; //"Main Menu Button"
    singleTap = loc
        .coachMarks_openDrawerToLoadProject; //"Open the drawer to load a project, create a new one, import and export data, synchronize with servers, access settings and exit the application/disable the GPS."
    longTap = null;
    doubleTap = null;
    targets.add(TargetFocus(
      identify: "Target ${i++}",
      keyTarget: drawerButtonKey,
      contents: [
        getContentTarget(title, singleTap, longTap, doubleTap,
            alignContent: ContentAlign.bottom)
      ],
      shape: ShapeLightFocus.Circle,
    ));
  }

  TargetContent getContentTarget(
      String title, String? singleTap, String? longTap, String? doubleTap,
      {ContentAlign alignContent = ContentAlign.top}) {
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

    return TargetContent(
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
    TutorialCoachMark(
        targets: targets,
        colorShadow: SmashColors.mainDecorations,
        alignSkip: Alignment.topCenter,
        textSkip: SL.of(context).coachMarks_skip, //"SKIP"
        paddingFocus: 10,
        opacityShadow: 0.7,
        onFinish: () {
          // print("finish");
        },
        onClickTarget: (target) {
          // print(target);
        },
        onSkip: () {
          // print("skip");
          return true;
        })
      ..show(context: context);
  }
}
