import 'package:flutter/material.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/widgets/forms.dart';


class SignUpHome extends StatefulWidget {
  @override
  SignUpHomeState createState() => SignUpHomeState();
}

class SignUpHomeState extends State<SignUpHome> {
  FormsWidget formsWidget = FormsWidget();
  
  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      appTitle: 'Create Account',
      bodyData: Center(
        child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              formsWidget.appIcon(),
              SizedBox(height: 35.0),
              _startedText(),
              SizedBox(height: 15.0),
              _accountOption(),
              SizedBox(height: 15.0),
              _emailSignup(),
              SizedBox(height: 15.0),
              _termsCondition(),
            ]),
      ),
      showDrawer: false,
    );
  }


  Widget _startedText() {
    return Center(
      child: new Text(
        "Let's get started",
        style: new TextStyle(
          color: Colors.orange.shade700,
          fontFamily: 'Poppins-Bold',
          fontSize: 30.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _accountOption() {
    return Center(
      child: new Text(
        // "Create your account using Google, Facebook, or Email",
        "Create your account by Email",
        style: new TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins-Light',
          fontSize: 18.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emailSignup() {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.of(context).pushNamed(UiData.signup);
        });
      },
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 42.0,
        child: Image.asset('assets/images/email-btn.png'),
      ),
    );
  }

  Widget _termsCondition() {
    return Center(
      child: new Text(
        "By creating an account I agree to Terms & Conditions, Privacy Policy, and Distribution Agreement;.",
        style: new TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 15.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
