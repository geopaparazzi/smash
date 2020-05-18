import 'package:flutter/material.dart';

const MARKER_ICON_TEXT_EXTRA_HEIGHT = 30.0;
const MARKER_ICON_TEXT_EXTRA_WIDTH_FACTOR = 3.0;

class MarkerIcon extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final double iconSize;
  final String labelText;
  final Color labelColor;
  final Color labelBackColor;

  const MarkerIcon(
    this.iconData,
    this.iconColor,
    this.iconSize,
    this.labelText,
    this.labelColor,
    this.labelBackColor,
  );

  @override
  Widget build(BuildContext context) {
    return labelText == null
        ? Container(
            child: Icon(
              iconData,
              size: iconSize,
              color: iconColor,
            ),
          )
        : Container(
            height: iconSize,
            width: iconSize,
            child: Column(
              children: [
                Container(
                  child: Icon(
                    iconData,
                    size: iconSize,
                    color: iconColor,
                  ),
                ),
                FittedBox(
                  child: Container(
                    decoration: BoxDecoration(
                      color: labelBackColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        labelText,
                        style: TextStyle(
                            color: labelColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
