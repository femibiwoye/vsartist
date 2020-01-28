import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:rxdart/rxdart.dart';
import './uidata.dart';
import 'package:vsartist/src/global/shared-data.dart';
import 'package:dio/dio.dart';

class NetworkRequest {
  static NetworkRequest _instance = new NetworkRequest.internal();
  NetworkRequest.internal();
  factory NetworkRequest() => _instance;

  final _internetStatus = PublishSubject<String>();
  Observable<String> get internetStatus => _internetStatus.stream;

  final _sendProgress = PublishSubject<List>();
  Observable<List> get sendProgress => _sendProgress.stream;

  String token;

  getTokken() async {
    SharedData _pref = SharedData();
    if (await _pref.getisUserLogin() == true) {
      print(await _pref.getAuthToken());
      return token = await _pref.getAuthToken();
    } else {
      return token = null;
    }
  }

  authLogout(statusCode, context) {
    SharedData _pref = SharedData();
    if (context != null && statusCode == 401) {
      _pref.disposeLogin();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(UiData.login);
    }
  }

  Future<String> get(String url, {context}) async {
    token = await getTokken();
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json"
    };

    return await http
        .get(Uri.encodeFull(url), headers: headers)
        .then((response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print(res);
      print(statusCode);
      authLogout(statusCode, context);
      if (statusCode < 200 || statusCode > 422 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return res;
    });
  }

  Future<String> post(String url,
      {Map headers, body, encoding, context}) async {
    token = await getTokken();
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json"
    };

    return await http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      authLogout(statusCode, context);
      print('post: $statusCode');
      print('post: $res');
      if (statusCode < 200 || statusCode > 422 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return res;
    });
  }

  Future<dynamic> postWithFile(String url,
      {Map headers, body, encoding, context}) async {
    token = await getTokken();
    var headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",
      "content-type": "application/json"
    };

    Dio dio = new Dio();
    dio.options.headers = headers;

    return dio.post(url, data: body, onSendProgress: (int sent, int total) {
      print("$sent $total");
      _sendProgress.add([sent, total]);
    },
        options: new Options(
            contentType: Headers.jsonContentType)).then(
               //ContentType.parse("application/json")
        (response) {
      final dynamic res = response;
      final int statusCode = response.statusCode;
      print('Network response: $statusCode');
      print('Network response: $res');
      authLogout(statusCode, context);
      if (statusCode < 200 || statusCode > 422 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return res.toString();
    });
  }

  Future<dynamic> guestGet(String url) {
    var headers = {"Accept": "application/json"};
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 422 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return res;
    });
  }

  Future<dynamic> guestPost(String url, {Map headers, body, encoding}) {
    var headers = {"Accept": "application/json"};
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final dynamic res = response.body;
      //print(res);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 422 || json == null) {
        throw new Exception("Error while fetching data");
      }

      return {'statusCode': statusCode, 'data': res};
    });
  }

  Future<String> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print('No Internet Connection');
      _internetStatus.sink.add('No Internet Connection');
      return 'No Internet Connection';
    }
    return null;
  }

  dispose() {
    _internetStatus.close();
  }
}

final networkBloc = NetworkRequest();
