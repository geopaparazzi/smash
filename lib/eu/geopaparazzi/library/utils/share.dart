/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:esys_flutter_share/esys_flutter_share.dart';

shareText(String text, {String title: ''}) async {
  await Share.text(title, text, 'text/plain');
}

shareImage(String text, {String title: '', mimeType: "image/png"}) async {
//  final ByteData bytes = await rootBundle.load('assets/image1.png');
  // TODO
  String name = "";
//  await Share.file(title, name, bytes.buffer.asUint8List(), mimeType);
}
