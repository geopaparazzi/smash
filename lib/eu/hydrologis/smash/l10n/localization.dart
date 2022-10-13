import 'package:flutter/widgets.dart';
import 'package:smash/generated/l10n.dart';

class Localization {
  static SL? _loc;

  SL get loc => Localization._loc!;

  static void init(BuildContext context) => _loc = SL.of(context)!;
}
