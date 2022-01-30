// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'de';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "main_StorageIsInternalWarning" : MessageLookupByLibrary.simpleMessage("Bitte aufmerksam lesen!\nUnter Android 11 und höher muss sich der SMASH-Projektordner im Verzeichnis\n\nAndroid/data/eu.hydrologis.smash/files/smash\n\nbefinden.\nBei Deinstallation der App wird er vom System entfernt, daher sollten Sie Ihre Daten sichern.\n\nEine bessere Lösung ist in Arbeit."),
    "main_check_location_permission" : MessageLookupByLibrary.simpleMessage("Standortbestimmung prüfen…"),
    "main_checkingStoragePermission" : MessageLookupByLibrary.simpleMessage("Speicherberechtigung prüfen…"),
    "main_fencesLoaded" : MessageLookupByLibrary.simpleMessage("Begrenzungen geladen."),
    "main_knownProjectionsLoaded" : MessageLookupByLibrary.simpleMessage("Bekannte Projektionen geladen."),
    "main_layersListLoaded" : MessageLookupByLibrary.simpleMessage("Layerliste geladen."),
    "main_loadingFences" : MessageLookupByLibrary.simpleMessage("Lade Begrenzung…"),
    "main_loadingKnownProjections" : MessageLookupByLibrary.simpleMessage("Bekannte Projektionen laden…"),
    "main_loadingLayersList" : MessageLookupByLibrary.simpleMessage("Laden der Layerliste…"),
    "main_loadingPreferences" : MessageLookupByLibrary.simpleMessage("Laden der Einstellungen…"),
    "main_loadingTagsList" : MessageLookupByLibrary.simpleMessage("Liste der Tags laden…"),
    "main_loadingWorkspace" : MessageLookupByLibrary.simpleMessage("Arbeitsbereich laden…"),
    "main_locationBackgroundWarning" : MessageLookupByLibrary.simpleMessage("Erteilen Sie im nächsten Schritt die Standortfreigabe, um die GPS-Aufzeichnung im Hintergrund zu ermöglichen. ( Andernfalls funktioniert das System nur im Vordergrund.)\nEs werden keine Daten weitergegeben, sondern nur lokal auf dem Gerät gespeichert."),
    "main_location_permission_granted" : MessageLookupByLibrary.simpleMessage("Erlaubnis zur Lokalisierung erteilt."),
    "main_preferencesLoaded" : MessageLookupByLibrary.simpleMessage("Einstellungen geladen."),
    "main_storagePermissionGranted" : MessageLookupByLibrary.simpleMessage("Speichererlaubnis erteilt."),
    "main_tagsListLoaded" : MessageLookupByLibrary.simpleMessage("Liste der Tags geladen."),
    "main_welcome" : MessageLookupByLibrary.simpleMessage("Willkommen bei SMASH!"),
    "main_workspaceLoaded" : MessageLookupByLibrary.simpleMessage("Arbeitsbereich geladen.")
  };
}
