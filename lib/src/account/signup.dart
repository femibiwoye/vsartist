import 'package:flutter/material.dart';
import './user.dart';

import './auth-bloc.dart';
import 'package:vsartist/src/global/networks.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/widgets/forms.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FormsWidget formsWidget = FormsWidget();
  final scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  SignupForm signup = new SignupForm();

  List _states = [], _cities = [], _allCities;

  @override
  void initState() {
    super.initState();
    checkInternet();
    loadStates();
  }

  Future<String> loadStates() async {
    String states = await rootBundle.loadString('assets/datas/states.json');
    String cities =
        await rootBundle.loadString('assets/datas/local_governments.json');

    setState(() {
      _states = json.decode(states);
      _cities = json.decode(cities);
      _allCities = _cities;
    });
  }

  states() {
    return _states.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(
          item['name'],
          style: TextStyle(color: Colors.grey),
        ),
        value: item['alias'].toString(),
      );
    }).toList();
  }

  cities() {
    return _cities.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(
          item['name'],
          style: TextStyle(color: Colors.grey),
        ),
        value: item['alias'].toString(),
      );
    }).toList();
  }

  checkInternet() async {
    if (await networkBloc.checkInternet() != null){
      authBloc.snackBar.add(await networkBloc.checkInternet());
    }
  }

  formDecoration(title) {
    return InputDecoration(
      hintText: title,
      hintStyle: new TextStyle(color: Colors.grey[400]),
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      fillColor: Colors.white,
      enabledBorder: const OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 0.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
    );
  }

  signupFields() => Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextFormField(
                        onSaved: (val) => signup.stage_name = val,
                        style: TextStyle(color: Colors.black),
                        validator: (val) {
                          return val.length < 4
                              ? "Artist Name must have atleast 4 chars"
                              : null;
                        },
                        decoration: formsWidget.formDecoration('Artist Name',
                            icon: Icons.mic)),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextFormField(
                        onSaved: (val) => signup.username = val,
                        style: TextStyle(color: Colors.black),
                        validator: (val) {
                          return val.length < 4
                              ? "Username must have atleast 4 chars"
                              : null;
                        },
                        decoration: formsWidget.formDecoration('Username',
                            icon: Icons.person)),
                  ),
                  new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (val) => signup.email = val,
                        style: TextStyle(color: Colors.black),
                        validator: (val) {
                          return val.length < 4
                              ? "Email must have atleast 4 chars"
                              : null;
                        },
                        decoration: formsWidget.formDecoration('Email',
                            icon: Icons.email),
                      )),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextFormField(
                        keyboardType: TextInputType.phone,
                        onSaved: (val) => signup.phone = val,
                        style: TextStyle(color: Colors.black),
                        validator: (val) {
                          return val.length < 4
                              ? "Phone Number must have atleast 4 chars"
                              : null;
                        },
                        decoration: formsWidget.formDecoration('Phone Number',
                            icon: Icons.phone)),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: formsWidget.dropdownField('Select Your State',
                          states(), signup.state, stateOnChange,
                          prefix: Icons.location_on, label: 'State')),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: formsWidget.dropdownField('Select Your City',
                          cities(), signup.city, cityOnChange,
                          prefix: Icons.location_city, label: 'Cities')),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextFormField(
                        onSaved: (val) => signup.password = val,
                        obscureText: true,
                        style: TextStyle(color: Colors.black),
                        validator: (val) {
                          return val.length < 4
                              ? "Password must have atleast 4 chars"
                              : null;
                        },
                        decoration: formsWidget.formDecoration('Password',
                            icon: Icons.security)),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextFormField(
                        onSaved: (val) => signup.password_confirmation = val,
                        obscureText: true,
                        style: TextStyle(color: Colors.black),
                        validator: (val) {
                          return val.length < 4
                              ? "Password must have atleast 4 chars"
                              : null;
                        },
                        decoration: formsWidget.formDecoration(
                            'Password Confirmation',
                            icon: Icons.security)),
                  )
                ],
              ),
            ),
            signupButton(),
          ],
        ),
      );

  _submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      authBloc.register(signup, context);
      authBloc.snacksBar.listen((data) {
        if(data!=null){
        scaffoldState.currentState.showSnackBar(new SnackBar(
            duration: Duration(seconds: 5), content: new Text(data)));
        }
      });
    }
  }

  signupButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<bool>(
          stream: authBloc.showProgress,
          initialData: false,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data) {
              return new Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: formsWidget.wideButton('REGISTER', context, _submit));
            }
          }),
    );
  }

  stateOnChange(newValue) {
    setState(() {
      signup.state = newValue;
      _cities = _allCities.where((l) => l['state'] == newValue).toList();
      signup.city = null;
    });
  }

  cityOnChange(newValue) {
    setState(() {
      signup.city = newValue;
    });
  }

  // snackMessage() {
  //   return StreamBuilder<String>(
  //       stream: authBloc.snackBar,
  //       builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
  //         print('Printed in snack ${snapshot.data}');
  //         if (snapshot.data == null) {
  //           print('Printed in outside snack 1');
  //           return SizedBox(height: 1);
  //         } else {
  //           WidgetsBinding.instance.addPostFrameCallback((_) =>
  //               scaffoldState.currentState.showSnackBar(new SnackBar(
  //                   duration: Duration(seconds: 5),
  //                   content: new Text(snapshot.data))));
  //           return SizedBox(height: 1);
  //         }
  //       });
  //   scaffoldState.currentState.showSnackBar(new SnackBar(
  //       duration: Duration(seconds: 5), content: new Text('snapshot.data')));
  // }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      appTitle: 'Signup',
      scaffoldState: scaffoldState,
      bodyData: new Container(
          child: new ListView(
        children: <Widget>[
          new Center(
            child: new Column(
              children: <Widget>[
                formsWidget.appIcon(),
                signupFields(),
              ],
            ),
          ),
        ],
      )),
      showDrawer: false,
    );
  }
}
