import 'package:flutter/material.dart';
import 'package:vsartist/src/account/signup_home.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/onboarding/onboarding.dart';
import 'package:vsartist/src/account/login.dart';
import 'package:vsartist/src/dashboard.dart';
import 'package:vsartist/src/account/signup.dart';
import 'package:vsartist/src/services/services_page.dart';
import 'package:vsartist/src/uploads/album-cover.dart';
import 'package:vsartist/src/uploads/album-upload-instruction.dart';
import 'package:vsartist/src/uploads/signles-upload-number.dart';
import 'package:vsartist/src/uploads/singles-upload-instruction.dart';
import 'package:vsartist/src/uploads/singles-upload.dart';
import 'package:vsartist/src/wallet/balance.dart';
import 'package:vsartist/src/music/music-home.dart';




final routes = <String, WidgetBuilder>{
  UiData.onboarding: (BuildContext context) => new Onboarding(),
  UiData.login: (BuildContext context) => new Login(),
  UiData.signupHome: (BuildContext context) => new SignUpHome(),
  UiData.signup: (BuildContext context) => new Signup(),
  UiData.dashboard: (BuildContext context) => new Dashboard(),
  UiData.signlesUploadInstruction: (BuildContext context) => new SignlesUploadInstruction(),
  UiData.signlesUploadNumber: (BuildContext context) => new SignlesUploadNumber(),
  UiData.signlesUpload: (BuildContext context) => new SinglesUpload(),
  UiData.myBalance: (BuildContext context) => new WalletBalance(),
  UiData.myMusic: (BuildContext context) => new MusicHome(),
  UiData.servicesHome: (BuildContext context) => new ServicesHome(),
  UiData.albumUploadInstruction: (BuildContext context) => new AlbumUploadInstruction(),
  UiData.albumCover: (BuildContext context) => new AlbumCover(),
  
  
};
