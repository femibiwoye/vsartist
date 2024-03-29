import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vsartist/src/global/uidata.dart';
import './user.dart';
import './../inherited/login_provider.dart';
import './login-request.dart';
import 'package:vsartist/src/dashboard.dart';
import 'package:vsartist/src/global/networks.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/widgets/forms.dart';
import './auth-bloc.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //LoginRequest loginRequest;
  final scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  FormsWidget formsWidget = FormsWidget();
  String _username, _password;

  // _LoginState() {
  //   loginRequest = new LoginRequest(this);
  // }

  @override
  void initState() {
    super.initState();
    checkInternet();
  }

  checkInternet() async {
    if (await networkBloc.checkInternet() != null)
      _showSnackBar(await networkBloc.checkInternet());
  }

  void vibestreamRedirect() {
    //Navigator.of(context).pushNamed(UiData.productsCategories);
    Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new Dashboard()));
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar('Successfully logged in');
    Timer(new Duration(seconds: 2), vibestreamRedirect);
  }

  void _showSnackBar(String text) {
    scaffoldState.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  Future<bool> loginAction() async {
    //replace the below line of code with your login request
    await new Future.delayed(const Duration(seconds: 1));
    return true;
  }

  void _submit() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      authBloc.doLogin(_username, _password, context);
      authBloc.snacksBar.listen((data) {
        scaffoldState.currentState.showSnackBar(new SnackBar(
            duration: Duration(seconds: 5), content: new Text(data)));
      });
    }
  }

  Widget loginScaffold() => LoginProvider(
        child: ScaffoldCommon(
          appTitle: 'Sign In',
          scaffoldState: scaffoldState,
          bodyData: _loginContainer(),
          showDrawer: true,
        ),
      );

  _loginContainer() {
    return new Container(
        child: new ListView(
      children: <Widget>[
        new Center(
          child: new Column(
            children: <Widget>[
              formsWidget.appIcon(),
              _formContainer(),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _formContainer() {
    return new Container(
      child: new Form(
          key: formKey,
          child: new Theme(
              data: new ThemeData(primarySwatch: Colors.orange),
              child: new Column(
                children: <Widget>[
                  _usernameContainer(),
                  _passwordContainer(),
                  SizedBox(height: 20),
                  loginButto(),
                  SizedBox(height: 20),
                  //forgotPassword(),
                  _registerNowLabel(),
                ],
              ))),
      margin: EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
    );
  }

  Widget _usernameContainer() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: new TextFormField(
          onSaved: (val) => _username = val,
          style: TextStyle(color: Colors.white),
          validator: (val) {
            return val.length < 4 ? "Username must have atleast 4 chars" : null;
          },
          decoration:
              formsWidget.formDecoration('Username', icon: Icons.email)),
    );
  }

  Widget _passwordContainer() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: new TextFormField(
          style: TextStyle(color: Colors.white),
          obscureText: true,
          onSaved: (val) => _password = val,
          validator: (val) {
            return val.length < 4 ? "Password must have atleast 4 chars" : null;
          },
          decoration:
              formsWidget.formDecoration('Password', icon: Icons.vpn_key)),
    );
  }

  forgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0, right: 15.0, top: 20.0),
        child: new InkWell(
            child: new Text(
              'Forgot Password',
              style: TextStyle(color: UiData.orange, fontSize: 15),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UiData.forgot_password);
            }),
      ),
    );
  }

  Widget _registerNowLabel() {
    return new GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(UiData.signupHome);
      },
      child: new Container(
          child: new Text(
            'New Artist? Register Now!',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
          margin: EdgeInsets.only(bottom: 30.0)),
    );
  }

  loginButto() {
    return StreamBuilder<bool>(
        stream: authBloc.showProgress,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data) {
            return new Center(child: CircularProgressIndicator());
          } else {
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: formsWidget.wideButton('LOGIN', context, _submit));
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return loginScaffold();
  }
}
