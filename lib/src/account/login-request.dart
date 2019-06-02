import './user.dart';
import 'package:vsartist/src/global/networks.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'dart:convert';
import 'package:vsartist/src/global/shared-data.dart';

abstract class LoginResponseScreen {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginRequest {
  LoginResponseScreen _view;
  LoginRequest(this._view);

  doLogin(String username, String password) async {
    print('the username is $username or password is $password');
    NetworkRequest network = new NetworkRequest();
    print(UiData.domain + "/artist-auth/login");
    var body = {"username": username, "password": password};
    print(body);
    return network
        .guestPost(UiData.domain + "/artist-auth/login", body: body)
        .then((dynamic response) {
      response = response['data'];
      var res = jsonDecode(response);
      print('Server response is $res');
      print('Error message is ${res["status"]}');
      if (res["status"]) {
        User user = User.map(res["body"]);
        print('Passed data encoding');
        // {
        //   'name':user.name,
        //   'username':user.username,
        //   'name':user.email,
        //   'name':user.avatar ?? UiData.userPlaceholder,
        //   'name':user.phone,
        //   'name':user.stage_name
        // }
        String userData = jsonEncode(res["body"]);
        print('Passed data decoding');
        SharedData _pref = SharedData();
        _pref.setisUserLogin(true);
        _pref.setAuthToken(user.token);
        _pref.setAuthUserData(userData);
        _view.onLoginSuccess(user);
        print('thi sis token from login ${user.token} and ${user.name}');
      } else {
        _view.onLoginError(res["body"]["password"][0]);
      }
    });
  }
}
