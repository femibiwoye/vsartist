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
      title: 'DREAM TO REALITY',
      text:
          'Vibespot For Artist is designed specifically for you to get the most out of Vibespot.',
      textColor: Colors.white),
  PageModel(
      assetImagePath: 'assets/images/onboard/manage-profile.png',
      background: 'assets/images/splash-background.png',
      title: 'MANAGE YOUR PROFILE',
      text:
          'Update your bio, share your playlist, control how listeners see you on Vibespot.',
      textColor: Colors.white),
  PageModel(
      assetImagePath: 'assets/images/onboard/fan-base.png',
      background: 'assets/images/splash-background.png',
      title: 'BUILD YOUR LOCAL FAN BASE',
      text:
          'Push your song to your best Audience. Using the State Vibes and Push Notification feature.',
      textColor: Colors.white),
  PageModel(
      assetImagePath: 'assets/images/onboard/statistics.png',
      background: 'assets/images/splash-background.png',
      title: 'LIVE UPDATES ON YOUR STATISTICS',
      text:
          'Get live updates on how listeners react to your music including updates on how much money you earn.',
      textColor: Colors.white),
  PageModel(
      assetImagePath: 'assets/images/onboard/partnership.png',
      background: 'assets/images/splash-background.png',
      title: 'WORK WITH US',
      text:
          'We provide a wide range of services as a media company. We would be happy to work with you. Lifting your career to the next level.',
      textColor: Colors.white),
];
