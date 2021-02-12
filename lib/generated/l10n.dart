// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class SL {
  SL();
  
  static SL current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<SL> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      SL.current = SL();
      
      return SL.current;
    });
  } 

  static SL of(BuildContext context) {
    return Localizations.of<SL>(context, SL);
  }

  /// `Welcome to SMASH!`
  String get main_welcome {
    return Intl.message(
      'Welcome to SMASH!',
      name: 'main_welcome',
      desc: '',
      args: [],
    );
  }

  /// `Checking location permission...`
  String get main_check_location_permission {
    return Intl.message(
      'Checking location permission...',
      name: 'main_check_location_permission',
      desc: '',
      args: [],
    );
  }

  /// `Location permission granted.`
  String get main_location_permission_granted {
    return Intl.message(
      'Location permission granted.',
      name: 'main_location_permission_granted',
      desc: '',
      args: [],
    );
  }

  /// `Checking storage permission...`
  String get main_checkingStoragePermission {
    return Intl.message(
      'Checking storage permission...',
      name: 'main_checkingStoragePermission',
      desc: '',
      args: [],
    );
  }

  /// `Storage permission granted.`
  String get main_storagePermissionGranted {
    return Intl.message(
      'Storage permission granted.',
      name: 'main_storagePermissionGranted',
      desc: '',
      args: [],
    );
  }

  /// `Loading preferences...`
  String get main_loadingPreferences {
    return Intl.message(
      'Loading preferences...',
      name: 'main_loadingPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Preferences loaded.`
  String get main_preferencesLoaded {
    return Intl.message(
      'Preferences loaded.',
      name: 'main_preferencesLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Loading workspace...`
  String get main_loadingWorkspace {
    return Intl.message(
      'Loading workspace...',
      name: 'main_loadingWorkspace',
      desc: '',
      args: [],
    );
  }

  /// `Workspace loaded.`
  String get main_workspaceLoaded {
    return Intl.message(
      'Workspace loaded.',
      name: 'main_workspaceLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Loading tags list...`
  String get main_loadingTagsList {
    return Intl.message(
      'Loading tags list...',
      name: 'main_loadingTagsList',
      desc: '',
      args: [],
    );
  }

  /// `Tags list loaded.`
  String get main_tagsListLoaded {
    return Intl.message(
      'Tags list loaded.',
      name: 'main_tagsListLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Loading known projections...`
  String get main_loadingKnownProjections {
    return Intl.message(
      'Loading known projections...',
      name: 'main_loadingKnownProjections',
      desc: '',
      args: [],
    );
  }

  /// `Known projections loaded.`
  String get main_knownProjectionsLoaded {
    return Intl.message(
      'Known projections loaded.',
      name: 'main_knownProjectionsLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Loading fences...`
  String get main_loadingFences {
    return Intl.message(
      'Loading fences...',
      name: 'main_loadingFences',
      desc: '',
      args: [],
    );
  }

  /// `Fences loaded.`
  String get main_fencesLoaded {
    return Intl.message(
      'Fences loaded.',
      name: 'main_fencesLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Loading layers list...`
  String get main_loadingLayersList {
    return Intl.message(
      'Loading layers list...',
      name: 'main_loadingLayersList',
      desc: '',
      args: [],
    );
  }

  /// `Layers list loaded.`
  String get main_layersListLoaded {
    return Intl.message(
      'Layers list loaded.',
      name: 'main_layersListLoaded',
      desc: '',
      args: [],
    );
  }

  /// `This app collects location data to your device to enable gps logs recording even when the app is placed in background. No data is shared, it is only saved locally to the device.\n\nIf you do not give permission to the background location service in the next dialog, you will still be able to collect data with SMASH, but will need to keep the app always in foreground to do so.\n`
  String get main_locationBackgroundWarning {
    return Intl.message(
      'This app collects location data to your device to enable gps logs recording even when the app is placed in background. No data is shared, it is only saved locally to the device.\n\nIf you do not give permission to the background location service in the next dialog, you will still be able to collect data with SMASH, but will need to keep the app always in foreground to do so.\n',
      name: 'main_locationBackgroundWarning',
      desc: '',
      args: [],
    );
  }

  /// `Location permission is mandatory to open SMASH.`
  String get main_locationPermissionIsMandatoryToOpenSmash {
    return Intl.message(
      'Location permission is mandatory to open SMASH.',
      name: 'main_locationPermissionIsMandatoryToOpenSmash',
      desc: '',
      args: [],
    );
  }

  /// `Storage permission is mandatory to open SMASH.`
  String get main_storagePermissionIsMandatoryToOpenSmash {
    return Intl.message(
      'Storage permission is mandatory to open SMASH.',
      name: 'main_storagePermissionIsMandatoryToOpenSmash',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Tap to view.`
  String get main_anErrorOccurredTapToView {
    return Intl.message(
      'An error occurred. Tap to view.',
      name: 'main_anErrorOccurredTapToView',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<SL> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<SL> load(Locale locale) => SL.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}