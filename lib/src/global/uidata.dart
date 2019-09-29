import 'package:flutter/material.dart';

class UiData {
  //static const String homeDomain = "http://localhost/vibespot/web";
  //static const String homeDomain = "http://192.168.8.101/vibespot/api/a1";
  
  //static const String homeDomain = "http://api.vibespotmusic.com/a1";
  //static const String domain = "http://api.vibespotmusic.com/a1";
  
  static const String homeDomain = "http://vibespot.akiba.ng/api/a1";
  static const String domain = "http://vibespot.akiba.ng/api/a1";

  //static const String homeDomain = "http://192.168.8.101/vibespot/api/a1";
  //static const String domain = "http://192.168.8.101/vibespot/api/a1";

  //static const String domain = "http://10.0.2.2:8080/vibespot/api/a1";
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
  static const String albumUploadInstruction = "/albumUploadInstruction";
  static const String albumCover = "/albumCover";
  static const String albumUpload = "/albumUpload";
  static const String myMusic = "/myMusic";
  static const String myPlaylist = "/myPlaylist";
  static const String myBalance = "/myBalance";
  static const String myStatistics = "/myStatistics";
  static const String help = "/help";/// This to be a link to FAQ on a website
  static const String servicesHome = "/servicesHome";

  static const String paymentKey = 'pk_test_47e502216ebf7256414e0e27494a4132c5c81e63'; //For testing
  //static const String paymentKey = 'pk_live_4531751ef20bb49fe16fcb718dc78bd5c12b183a';
  

  //strings
  static const String appName = "VS Artist";

  //fonts
  static const String poppins = "Poppins";

  //images
  static const String imageDir = "assets/images";
  static const String logo = "$imageDir/vibeStream-selected-icon.png";
  static const String logoMedium = "$imageDir/logo-200.png";
  static const String logoWhite = "$imageDir/vibeStream-white-icon.png";
  static const String splashImage = "$imageDir/splash.png";
  static const String userPlaceholder = "$imageDir/user-avatar.png";
  static const String comingSoon = "$imageDir/coming-soon.png";

  static List<Color> kitGradients = [
    //  Colors.orangeAccent,
    //  new Color.fromRGBO(3, 169, 244, 1.0),
    //  new Color.fromRGBO(0, 122, 193, 1.0),
    
    Color(0xFF242424),
    Color(0xFF111010),
    
  ];

//Colors
  static const Color orange = Color(0xFFed7333);
  static const Color grey = Color(0xFF43464b);

  //gneric
  static const String error = "Error";
  static const String success = "Success";
  static const String ok = "OK";
  static const String forgot_password = "Forgot Password?";
  static const String something_went_wrong = "Something went wrong";
  static const String coming_soon = "Coming Soon";
  static const String notFound = "Page Not Found";
}
