/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../generated/l10n.dart';

class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() {
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  String _appName;
  String _version;

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _appName = packageInfo.appName;
    if (_appName == null) {
      _appName = "SMASH";
    }
    _version = packageInfo.version;

    setState(() {});
  }

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String version = _version;

    return _appName == null
        ? SmashCircularProgress(
            label: SL.of(context).about_loadingInformation,
          )
        : Scaffold(
            appBar: new AppBar(
              title: Text(SL.of(context).about_titleBar(_appName)),
            ),
            body: Container(
              padding: SmashUI.defaultPadding(),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(_appName),
                    subtitle: Text(SL.of(context).about_subtitle),
                  ),
                  ListTile(
                    title: Text(SL.of(context).about_version),
                    subtitle: Text(version),
                  ),
                  ListTile(
                    title: Text(SL.of(context).about_license),
                    subtitle: Text(SL.of(context).about_licenseText(_appName)),
                  ),
                  ListTile(
                    title: Text(SL.of(context).about_sourceCode),
                    subtitle: Text(SL.of(context).about_tapHereVisitRepository),
                    onTap: () async {
                      if (await canLaunch("https://github.com/moovida/smash")) {
                        await launch("https://github.com/moovida/smash");
                      }
                    },
                  ),
                  ListTile(
                    title: Text(SL.of(context).about_legalInformation),
                    subtitle: Text(SL.of(context).about_copyright),
                    onTap: () async {
                      if (await canLaunch("http://www.hydrologis.com")) {
                        await launch("http://www.hydrologis.com");
                      }
                    },
                  ),
                  ListTile(
                    title: Text(SL.of(context).about_supportedBy),
                    subtitle: Text(SL.of(context).about_supportedByText),
                  ),
                  ListTile(
                    title: Text(SL.of(context).about_privacyPolicy),
                    subtitle: Text(SL.of(context).about_privacyPolicyText),
                    onTap: () async {
                      if (await canLaunch(
                          "https://www.hydrologis.com/geo_privacy_policy")) {
                        await launch(
                            "https://www.hydrologis.com/geo_privacy_policy");
                      }
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
