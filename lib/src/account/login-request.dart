import './user.dart';
import 'package:vsartist/src/global/networks.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'dart:convert';
import 'package:vsartist/src/global/shared-data.dart';
import 'package:rxdart/rxdart.dart';

abstract class LoginResponseScreen {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginRequest {
  LoginResponseScreen _view;
  LoginRequest(this._view);

  final showProgress = PublishSubject<bool>();
  Observable<bool> get showProgressBar => showProgress.stream;

  doLogin(String username, String password) async {
    showProgress.add(true);
    NetworkRequest network = new NetworkRequest();
    var body = {"username": username, "password": password};
    return network
        .guestPost(UiData.domain + "/artist-auth/login", body: body)
        .then((dynamic response) {
      response = response['data'];
      var res = jsonDecode(response);
      if (res["status"]) {
        User user = User.map(res["body"]);
        String userData = jsonEncode(res["body"]);
        SharedData _pref = SharedData();
        _pref.setisUserLogin(true);
        _pref.setAuthToken(user.token);
        _pref.setAuthUserData(userData);
        _view.onLoginSuccess(user);
      } else {
        _view.onLoginError(res["body"]["password"][0]);
      }
      showProgress.add(false);
    });
  }

   dispose() {
    showProgress.close();
  }
}

