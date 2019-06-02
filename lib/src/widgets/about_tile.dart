import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';

class MyAboutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      applicationIcon: Image.asset(UiData.logo,width: 60),
      icon: Image.asset(UiData.logo,width: 40),
      aboutBoxChildren: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        Text(
          "Developed By Intemporel",
        style: TextStyle(color:Colors.orange)),
        Text(
          "VS Music",
        style: TextStyle(color:Colors.orange)),
      ],
      applicationName: UiData.appName,
      applicationVersion: "1.0.1",
      applicationLegalese: "License to VSM",
    );
  }
}
