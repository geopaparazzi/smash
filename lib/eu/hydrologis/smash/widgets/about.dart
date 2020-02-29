/*
 * Copyright (c) 2019. Antonello Andrea (www.hydrologis.com). All rights reserved.
 * Use of this source code is governed by a GPL3 license that can be
 * found in the LICENSE file.
 */
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/colors.dart';
import 'package:smash/eu/hydrologis/flutterlibs/util/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  AboutPageState createState() {
    return AboutPageState();
  }
}

class AboutPageState extends State<AboutPage> {
  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    if(appName == null){
      appName = "SMASH";
    }
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    if(version != buildNumber){
      buildNumber = ", build $buildNumber";
    }else{
      buildNumber="";
    }

    return "$appName $version$buildNumber";
  }

  @override
  Widget build(BuildContext context) {
    var filler = Container(
      height: 15,
    );
    return FutureBuilder(
      future: getVersion(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return new Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                    color: SmashColors.mainSelection,
                    fontWeight: FontWeight.bold),
              );
            } else {
              return Scaffold(
                appBar: new AppBar(
                  title: Text("ABOUT"),
                ),
                body: Container(
                  padding: SmashUI.defaultPadding(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SmashUI.titleText(snapshot.data,
                          textAlign: TextAlign.justify, useColor: true),
                      filler,
                      SmashUI.normalText(
                          "Welcome to the Smart Mobile App for Surveyor's Happyness!",
                          bold: true,
                          textAlign: TextAlign.justify),
                      filler,
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch("http://www.hydrologis.com")) {
                            await launch("http://www.hydrologis.com");
                          }
                        },
                        child: SmashUI.normalText(
                            "It is brought to you by HydroloGIS",
                            underline: true,
                            textAlign: TextAlign.justify),
                      ),
                      filler,
                      SmashUI.normalText(
                          "SMASH is the smaller brother of Geopaparazzi.",
                          textAlign: TextAlign.justify),
                      GestureDetector(
                        onTap: () async {
                          if (await canLaunch("http://www.geopaparazzi.eu")) {
                            await launch("http://www.geopaparazzi.eu");
                          }
                        },
                        child: SmashUI.normalText(
                            "Have a look at the homepage of the projects to better understand the differences and advantages.",
                            underline: true,
                            textAlign: TextAlign.justify),
                      ),
                      filler,
                      SmashUI.normalText(
                          "Partially supported by the project Steep Stream of the University of Trento.",
                          textAlign: TextAlign.justify),
                    ],
                  ),
                ),
              );
            }
        }
      },
    );
  }
}
