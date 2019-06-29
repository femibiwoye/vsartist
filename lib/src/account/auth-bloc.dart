import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vsartist/src/dashboard.dart';
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


doLogin(String username, String password, context) async {
    _showProgress.add(true);
    
    var body = {"username": username, "password": password};
    
    return network
        .guestPost(UiData.domain + "/artist-auth/login", body: body)
        .then((dynamic response) {
      response = response['data'];
      var res = jsonDecode(response);
      if (res["status"]) {
        User user = User.map(res["body"]);
        String userData = jsonEncode(res["body"]);
        print(userData);
        SharedData _pref = SharedData();
        _pref.setisUserLogin(true);
        _pref.setAuthToken(user.token);
        _pref.setAuthUserData(userData);

         Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => new Dashboard()));
        
      } else {
       snackBar.add('${res["body"]["password"][0]}');
          _showProgress.add(false);
          return;
      }
      
    });
  }


  register(SignupForm signup,context) async {
    _showProgress.add(true);
    Map<dynamic, dynamic> body = {
      "stage_name": signup.stage_name,
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
      String data = res['data'];
      var response = jsonDecode(data);

      if (res['statusCode'] == 200) {
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
