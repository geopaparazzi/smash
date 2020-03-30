/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

/// Validator that checks [value] for empty string.
///
/// Returns null if the string is valid. This can be used
/// as [TextFormField] validator.
String noEmptyValidator(String value) {
  if (value.trim().length == 0) {
    return "Please enter some text to continue.";
  } else {
    return null;
  }
}

/// Validator that checks [value] for being a valid filename.
///
/// Returns null if the string is valid. This can be used
/// as [TextFormField] validator.
String fileNameValidator(String value) {
  if (value.trim().length == 0) {
    // TODO add proper checks for safe filenames
    return "Please enter a valid file name to continue.";
  } else {
    return null;
  }
}
