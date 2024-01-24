import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smashlibs/smashlibs.dart';

class GpsInsertionModeSelector extends StatefulWidget {
  final bool allowTap;
  GpsInsertionModeSelector({Key? key, this.allowTap = false}) : super(key: key);

  @override
  _GpsInsertionModeSelectorState createState() =>
      _GpsInsertionModeSelectorState();
}

class _GpsInsertionModeSelectorState extends State<GpsInsertionModeSelector> {
  int _mode = POINT_INSERTION_MODE_GPS;

  @override
  Widget build(BuildContext context) {
    _mode = GpPreferences()
            .getIntSync(KEY_DO_NOTE_IN_GPS, POINT_INSERTION_MODE_GPS) ??
        POINT_INSERTION_MODE_GPS;

    if (!widget.allowTap && _mode == POINT_INSERTION_MODE_TAPPOSITION) {
      _mode = POINT_INSERTION_MODE_GPS;
    }
    var gpsState = Provider.of<GpsState>(context, listen: false);

    if (!gpsState.hasFix() && _mode == POINT_INSERTION_MODE_GPS) {
      _mode = POINT_INSERTION_MODE_MAPCENTER;
      gpsState.insertInGpsQuiet = _mode;
    }

    List<bool> sel = [];

    List<Widget> buttons = [];
    if (gpsState.hasFix()) {
      buttons.add(Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Tooltip(
            message: "Use GPS position.", child: Icon(SmashIcons.locationIcon)),
      ));
      sel.add(_mode == POINT_INSERTION_MODE_GPS);
    }
    buttons.add(Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Tooltip(
          message: "Use map center position.",
          child: Icon(MdiIcons.imageFilterCenterFocus)),
    ));
    sel.add(_mode == POINT_INSERTION_MODE_MAPCENTER);

    if (widget.allowTap) {
      buttons.add(Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Tooltip(
            message: "Use tap position.", child: Icon(MdiIcons.gestureTap)),
      ));
      sel.add(_mode == POINT_INSERTION_MODE_TAPPOSITION);
    }

    return Container(
      child: ToggleButtons(
        color: SmashColors.mainDecorations,
        fillColor: SmashColors.mainSelectionMc[100],
        selectedColor: SmashColors.mainSelection,
        renderBorder: true,
        borderRadius: BorderRadius.circular(15),
        borderWidth: 3,
        borderColor: SmashColors.mainDecorationsDarker,
        selectedBorderColor: SmashColors.mainSelection,
        children: buttons,
        isSelected: sel,
        onPressed: !gpsState.hasFix()
            ? null
            : (index) async {
                int selMode;
                if (index == 0) {
                  selMode = POINT_INSERTION_MODE_GPS;
                } else if (index == 2) {
                  selMode = POINT_INSERTION_MODE_TAPPOSITION;
                } else {
                  // if (index == 1) {
                  selMode = POINT_INSERTION_MODE_MAPCENTER;
                }
                var gpsState = Provider.of<GpsState>(context, listen: false);
                gpsState.insertInGpsQuiet = selMode;

                await GpPreferences().setInt(KEY_DO_NOTE_IN_GPS, selMode);
                _mode = selMode;
                setState(() {});
              },
      ),
    );
  }
}
