import 'package:flutter/material.dart';

class UiData {
  static const String homeDomain = "http://localhost/vibespot/web";
  static const String domain = "http://localhost/vibespot/api/a1";
  static const String webDomain = "$homeDomain";

  //Authentication Maintenance
  static const String tokenRefresh = '$homeDomain/api/auth/refresh';

  //Routes names - Auth
  static const String homeRoute = "/home";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String signupHome = "/signupHome";
  static const String onboarding = "/onboarding";
  static const String dashboard = "/dashboard";
  static const String signlesUploadInstruction = "/signlesUploadInstruction";
  static const String signlesUploadNumber = "/signlesUploadNumber";
  static const String signlesUpload = "/singlesUpload";
  static const String albumUpload = "/albumUpload";
  static const String myMusic = "/myMusic";
  static const String myPlaylist = "/myPlaylist";
  static const String myBalance = "/myBalance";
  static const String myStatistics = "/myStatistics";
  static const String help = "/help";/// This to be a link to FAQ on a website
  

  //strings
  static const String appName = "VS Artist";

  //fonts
  static const String poppins = "Poppins";

  //images
  static const String imageDir = "assets/images";
  static const String logo = "$imageDir/vibeStream-selected-icon.png";
  static const String splashImage = "$imageDir/splash.png";
  static const String userPlaceholder = "$imageDir/user-avatar.png";
  static const String comingSoon = "$imageDir/coming-soon.png";

  static List<Color> kitGradients = [
    // new Color.fromRGBO(103, 218, 255, 1.0),
    // new Color.fromRGBO(3, 169, 244, 1.0),
    // new Color.fromRGBO(0, 122, 193, 1.0),
    Color(0xFFcaaa3b),
    Color(0xFFe8b91b),
  ];

//Colors
  static const Color orange = Color(0xFFed7333);

  //gneric
  static const String error = "Error";
  static const String success = "Success";
  static const String ok = "OK";
  static const String forgot_password = "Forgot Password?";
  static const String something_went_wrong = "Something went wrong";
  static const String coming_soon = "Coming Soon";
  static const String notFound = "Page Not Found";
}
