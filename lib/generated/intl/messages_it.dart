// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
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
  String get localeName => 'it';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "main_anErrorOccurredTapToView" : MessageLookupByLibrary.simpleMessage("È avvenuto un errore. Tocca per informazioni."),
    "main_check_location_permission" : MessageLookupByLibrary.simpleMessage("Controllo permessi geolocalizzazione"),
    "main_checkingStoragePermission" : MessageLookupByLibrary.simpleMessage("Controllo permesso spazio archiviazione..."),
    "main_fencesLoaded" : MessageLookupByLibrary.simpleMessage("Recinti virtuali caricati."),
    "main_knownProjectionsLoaded" : MessageLookupByLibrary.simpleMessage("Proiezioni note caricate."),
    "main_layersListLoaded" : MessageLookupByLibrary.simpleMessage("Lista piani caricati."),
    "main_loadingFences" : MessageLookupByLibrary.simpleMessage("Caricamento recinti virtuali..."),
    "main_loadingKnownProjections" : MessageLookupByLibrary.simpleMessage("Caricamento proiezioni note..."),
    "main_loadingLayersList" : MessageLookupByLibrary.simpleMessage("Caricamento lista piani..."),
    "main_loadingPreferences" : MessageLookupByLibrary.simpleMessage("Caricamento preferenze..."),
    "main_loadingTagsList" : MessageLookupByLibrary.simpleMessage("Caricamento lista tags..."),
    "main_loadingWorkspace" : MessageLookupByLibrary.simpleMessage("Caricamento spazio di lavoro..."),
    "main_locationBackgroundWarning" : MessageLookupByLibrary.simpleMessage("Questa app registra dati di posizione dal dispositivo per permettere la registrazione di traccie gps anche se la app è sullo sfondo. Nessun dato è condiviso ma solamente salvato localmente sul dispositivo.\n\nSe non viene dato il permesso per l\'accesso alla posizione con app sullo sfondo nella prossima finestra, sarà comunque possibile raccogliere dati con SMASH, ma solo quando la app è visibile.\n"),
    "main_locationPermissionIsMandatoryToOpenSmash" : MessageLookupByLibrary.simpleMessage("Il permesso di geolocalizzazzione è obbligatorio per utilizzare SMASH."),
    "main_location_permission_granted" : MessageLookupByLibrary.simpleMessage("Permesso geolocalizzazione accettato."),
    "main_preferencesLoaded" : MessageLookupByLibrary.simpleMessage("Preferenze caricate."),
    "main_storagePermissionGranted" : MessageLookupByLibrary.simpleMessage("Permesso spazio archiviazione accettato."),
    "main_storagePermissionIsMandatoryToOpenSmash" : MessageLookupByLibrary.simpleMessage("Il permesso dello spazio di archiviazione è obbligatorio per utilizzare SMASH."),
    "main_tagsListLoaded" : MessageLookupByLibrary.simpleMessage("Lista tags caricata."),
    "main_welcome" : MessageLookupByLibrary.simpleMessage("Benvenuto in SMASH!"),
    "main_workspaceLoaded" : MessageLookupByLibrary.simpleMessage("Spazio di lavoro caricato.")
  };
}
