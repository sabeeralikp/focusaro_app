import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/sound_profiles.dart';
import 'dart:async';
import 'package:flutter/services.dart';

Future<void> setSilentMode() async {
  String message;

  try {
    message = await SoundMode.setSoundMode(Profiles.SILENT);
  } on PlatformException {
    print('Do Not Disturb access permissions required!');
  }
}

Future<void> setNormalMode() async {
  String message;

  try {
    message = await SoundMode.setSoundMode(Profiles.NORMAL);
  } on PlatformException {
    print('Do Not Disturb access permissions required!');
  }
}
