import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  final String _authUserData = "authuserData";
  final String _authToken = "authToken";
  final String _isUserLogin = "isUserLogin";
  final String _isScreenBaorded = "isScreenBaorded";

  /// The user token
  Future<bool> getisUserLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isUserLogin) ?? false;
  }

  Future<bool> setisUserLogin(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isUserLogin, value);
  }

  /// The user token
  Future<String> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authToken) ?? null;
  }

  Future<bool> setAuthToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_authToken, value);
  }

  /// Get currently loggedin user data
  Future<String> getAuthUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_authUserData) ?? null;
  }

  Future<bool> setAuthUserData(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_authUserData, value);
  }

  /// FOr onboarding screen. This will tell if you should see onboarding screen or not
  Future<bool> getScreenBaorded() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isScreenBaorded) ?? false;
  }

  Future<bool> setScreenBaorded(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isScreenBaorded, value);
  }

  Future<bool> disposeLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_authUserData);
    prefs.remove(_authToken);

    return prefs.remove(_isUserLogin);
  }
}
