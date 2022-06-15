import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:smash/eu/hydrologis/smash/util/fence.dart';

/// Helper class to play simple notification sounds.
class ENotificationSounds {
  static const nosound = const ENotificationSounds._("nosound", -1, -1);
  static const alarm = const ENotificationSounds._("alarm", 1, 1005);
  static const notification =
      const ENotificationSounds._("notification", 2, 1009);
  static const ring = const ENotificationSounds._("ringtone", 3, 1151);

  static List<ENotificationSounds> get values =>
      <ENotificationSounds>[nosound, ring, alarm, notification];

  final String name;
  final int androidCode;
  final int iosCode;

  const ENotificationSounds._(this.name, this.androidCode, this.iosCode);

  static ENotificationSounds? forName(String? name) {
    if (name == null) {
      return null;
    }
    return values.firstWhere((ns) => ns.name == name);
  }

  bool hasSound() {
    return this != nosound;
  }

  Future<void> playTone(
      {loop: true,
      volume: 0.1,
      asAlarm: false,
      durationSeconds: FenceMaster.DEFAULT_SOUND_DURATION}) async {
    await FlutterRingtonePlayer.play(
      android: AndroidSound(androidCode),
      ios: IosSound(iosCode),
      looping: loop,
      volume: volume,
      asAlarm: asAlarm,
    );
    Future.delayed(
        const Duration(seconds: (FenceMaster.DEFAULT_SOUND_DURATION)),
        () async {
      await FlutterRingtonePlayer.stop();
    });
  }

  Future<void> stopCurrentTone() async {
    await FlutterRingtonePlayer.stop();
  }
}
