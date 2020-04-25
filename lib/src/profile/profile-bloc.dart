import 'dart:convert';
import 'package:rxdart/rxdart.dart';
import 'package:vsartist/src/global/networks.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/profile/profile-model.dart';
import 'package:vsartist/src/global/shared-data.dart';

class ProfileBloc {
  NetworkRequest network = new NetworkRequest();

  final _fetchModel = PublishSubject<ProfileModel>();
  Observable<ProfileModel> get profile => _fetchModel.stream;

  final _showProgress = PublishSubject<bool>();
  Observable<bool> get showProgress => _showProgress.stream;

  final snackBar = PublishSubject<String>();
  Observable<String> get snacksBar => snackBar.stream;

  fetchProfile(context) async {
    ProfileModel model;
    String parsed =
        await network.get(Uri.encodeFull(UiData.domain + "/profile/index"),context:context);
    var response = jsonDecode(parsed);
    if (response["status"] == false) {
      snackBar.add(response['msg']);
      return;
    } else {
      model = ProfileModel.fromJson(response['data']);
      _fetchModel.sink.add(model);
    }
  }

  postProfile(ProfileModel model) async {
    _showProgress.add(true);

    Map<dynamic, dynamic> body;
    if (model.image == null || model.image.contains('http')) {
      body = {
        "surname": model.surname,
        "firstname": model.firstname,
        "stage_name": model.stageName,
        "othernames": model.othernames ?? '',
        "state": model.state,
        "city": model.city,
        "phone": model.phone,
      };
    } else {
      body = {
        "surname": model.surname,
        "firstname": model.firstname,
        "stage_name": model.stageName,
        "othernames": model.othernames ?? '',
        "state": model.state,
        "city": model.city,
        "phone": model.phone,
        "image": model.image != null ? model.image : '',
      };
    }

    return network
        .post(UiData.domain + "/profile/edit", body: body)
        .then((res) {
      var response = jsonDecode(res);

      ///Will use this incase there is error or success
      if (response["status"] == false) {
        _showProgress.add(false);
        Map<dynamic, dynamic> fridgesDs = response['msg'];
        fridgesDs.forEach((key, value) {
          snackBar.add('${value[0]}');
          return;
        });
      } else if (response["status"] == true) {
        //updateLoginProfile(response["user"]);
        SharedData _pref = SharedData();
        _pref.setAuthUserData(jsonEncode(response['body']));
        snackBar.add('Successful');
      } else {
        snackBar.add('Something went wrong');
      }
      _showProgress.add(false);
    });
  }

  dispose() {
    _fetchModel.close();
  }
}

final profileBloc = ProfileBloc();
