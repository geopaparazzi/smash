/*
 * Copyright (c) 2019-2020. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:smash/generated/l10n.dart';
import 'package:smashlibs/smashlibs.dart';
import 'package:url_launcher/url_launcher.dart';

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
            label: SL
                .of(context)
                .about_loadingInformation, //"Loading information..."
          )
        : Scaffold(
            appBar: new AppBar(
              title: Text(SL.of(context).about_ABOUT + _appName), //"ABOUT "
            ),
            body: Container(
              padding: SmashUI.defaultPadding(),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(_appName),
                    subtitle: Text(SL
                        .of(context)
                        .about_smartMobileAppForSurveyor), //"Smart Mobile App for Surveyor's Happiness"
                  ),
                  ListTile(
                    title: Text(SL
                        .of(context)
                        .about_applicationVersion), //"Application version"
                    subtitle: Text(version),
                  ),
                  ListTile(
                    title: Text(SL.of(context).about_license), //"License"
                    subtitle: Text(_appName +
                        SL
                            .of(context)
                            .about_isAvailableUnderGPL3), //" is available under the General Public License, version 3."
                  ),
                  ListTile(
                    title:
                        Text(SL.of(context).about_sourceCode), //"Source Code"
                    subtitle: Text(SL
                        .of(context)
                        .about_tapHereToVisitRepo), //"Tap here to visit the source code repository"
                    onTap: () async {
                      if (await canLaunch("https://github.com/moovida/smash")) {
                        await launch("https://github.com/moovida/smash");
                      }
                    },
                  ),
                  ListTile(
                    title: Text(SL
                        .of(context)
                        .about_legalInformation), //"Legal Information"
                    subtitle: Text(SL
                        .of(context)
                        .about_copyright2020HydroloGIS), //"Copyright 2020, HydroloGIS S.r.l. -  some rights reserved. Tap to visit."
                    onTap: () async {
                      if (await canLaunch("http://www.hydrologis.com")) {
                        await launch("http://www.hydrologis.com");
                      }
                    },
                  ),
                  ListTile(
                    title:
                        Text(SL.of(context).about_supportedBy), //"Supported by"
                    subtitle: Text(SL
                        .of(context)
                        .about_partiallySupportedByUniversityTrento), //"Partially supported by the project Steep Stream of the University of Trento."
                  ),
                  ListTile(
                    title: Text(
                        SL.of(context).about_privacyPolicy), //"Privacy Policy"
                    subtitle: Text(SL
                        .of(context)
                        .about_tapHereToSeePrivacyPolicy), //"Tap here to see the privacy policy that covers user and location data."
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
