import 'package:flutter/material.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/widgets/forms.dart';
import 'package:vsartist/src/global/uidata.dart';

class SignlesUploadInstruction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FormsWidget formsWidget = FormsWidget();

    Widget instructionHead1(title) {
      return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: new Text(
          title,
          style: new TextStyle(
            color: Colors.orange.shade700,
            fontFamily: 'Poppins-Bold',
            fontSize: 25.0,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget instructionSubHead1(content) {
      return Padding(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: new Text(
          content,
          style: new TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontSize: 14.0,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    nextButton() {
      Navigator.of(context).pushNamed(UiData.signlesUploadNumber);
    }

    Widget body() => Center(
          child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                //instructionHead1("Song Upload Guide"),
                //SizedBox(height: 10.0),
                instructionSubHead1(
                    "Before you begin, make sure you \n have your assets prepared and \n available on your phone."),
                SizedBox(height: 25.0),
                instructionHead1("Cover art requirements:"),
                SizedBox(height: 10.0),
                instructionSubHead1("Clear cover image, no blurry."),
                SizedBox(height: 25.0),
                instructionHead1("Music/audio file requirements:"),
                SizedBox(height: 10.0),
                instructionSubHead1(".wav-file, .mp3-file."),
                
                SizedBox(height: 40.0),
                formsWidget.wideButton('PROCEED', context, nextButton),
              ]),
        );

    return ScaffoldCommon(
      appTitle: 'Song Upload Guide',
      bodyData: body(),
      showDrawer: false,
    );
  }
}
