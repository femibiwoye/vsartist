import 'package:flutter/material.dart';
import 'package:vsartist/src/account/signup_home.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/onboarding/onboarding.dart';
import 'package:vsartist/src/account/login.dart';
import 'package:vsartist/src/dashboard.dart';
import 'package:vsartist/src/account/signup.dart';
import 'package:vsartist/src/uploads/signles-upload-number.dart';
import 'package:vsartist/src/uploads/singles-upload-instruction.dart';
import 'package:vsartist/src/uploads/singles-upload.dart';




final routes = <String, WidgetBuilder>{
  UiData.onboarding: (BuildContext context) => new Onboarding(),
  UiData.login: (BuildContext context) => new Login(),
  UiData.signupHome: (BuildContext context) => new SignUpHome(),
  UiData.signup: (BuildContext context) => new Signup(),
  UiData.dashboard: (BuildContext context) => new Dashboard(),
  UiData.signlesUploadInstruction: (BuildContext context) => new SignlesUploadInstruction(),
  UiData.signlesUploadNumber: (BuildContext context) => new SignlesUploadNumber(),
  UiData.signlesUpload: (BuildContext context) => new SinglesUpload(),
  
};
