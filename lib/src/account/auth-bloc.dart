import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import './../global/networks.dart';
import './user.dart';
import './../global/uidata.dart';
import './../global/database.dart';
import 'dart:convert';
import 'package:vsartist/src/global/shared-data.dart';


class AuthBloc {
  NetworkRequest network = new NetworkRequest();
  var db = new DatabaseHelper();

  final _signup = PublishSubject<SignupForm>();
  Observable<SignupForm> get signup => _signup.stream;

  final snackBar = PublishSubject<String>();
  Observable<String> get snacksBar => snackBar.stream;

  final _showProgress = PublishSubject<bool>();
  Observable<bool> get showProgress => _showProgress.stream;

  // final _snackBar = StreamController<String>();
  // Stream<String> get snackBar => _snackBar.stream;

  register(SignupForm signup,context) async {
    _showProgress.add(true);
    Map<dynamic, dynamic> body = {
      "username": signup.username,
      "email": signup.email,
      "phone": signup.phone,
      "state": signup.state,
      "city": signup.city,
      "password": signup.password,
      "password_confirm": signup.password_confirmation,
    };

    return network
        .guestPost(UiData.domain + "/artist-auth/signup", body: body)
        .then((res) {
      print('Server response is $res and ${res['data']}');
      String data = res['data'];
      var response = jsonDecode(data);

      if (res['statusCode'] == 200) {
        print('everything went well');
        print('This is the body: ${response}');
        //Hide keyboard
        //FocusScope.of(context).requestFocus(new FocusNode());

        //Login the current user after successful login
        snackBar.add('Account Successfuly created');
        //var userData = jsonEncode(response);
        User user = User.map(response);
        SharedData _pref = SharedData();
        _pref.setisUserLogin(true);
        _pref.setAuthToken(user.token);
        _pref.setAuthUserData(data);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(UiData.dashboard);
      } else {
        
        
          snackBar.add('${response[0]['message']}');
          _showProgress.add(false);
          return;
        
      }
    });
  }

  dispose() {
    _signup.close();
    snackBar.close();
    _showProgress.close();
  }
}

final authBloc = AuthBloc();
