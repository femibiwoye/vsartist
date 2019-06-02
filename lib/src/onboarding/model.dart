import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';

class PageModel {
  final String assetImagePath;
  final String title;
  final String text;
  final String background;
  final Color textColor;
  PageModel(
      {this.assetImagePath,
      this.background,
      this.title,
      this.text,
      this.textColor});
}

List<PageModel> pages = [
  PageModel(
      assetImagePath: UiData.logo,
      background: 'assets/images/splash-background.png',
      title: 'MUSIC IS EVERYTHING',
      text:
          'This is a description you might want people to see on the first page of the mobile app. Note, it could also be multiple line.',
      textColor: Colors.white),
  PageModel(
      assetImagePath: 'assets/images/no-data-image.png',
      background: 'assets/images/splash-background.png',
      title: 'EARN WHILE YOU LISTEN TO SONGS',
      text:
          'This is a description you might want people to see on the first page of the mobile app.',
      textColor: Colors.white),
  PageModel(
      assetImagePath: 'assets/images/no-data-image.png',
      background: 'assets/images/splash-background.png',
      title: 'Music for The street',
      text:
          'This is a description you might want people to see on the first page of the mobile app. Note, it could also be multiple line.',
      textColor: Colors.white),
  PageModel(
      assetImagePath: 'assets/images/no-data-image.png',
      background: 'assets/images/splash-background.png',
      title: 'Music for all',
      text:
          'This is a description you might want people to see on the first page of the mobile app. ',
      textColor: Colors.white),
];
