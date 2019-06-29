import 'dart:convert';
import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:vsartist/src/global/networks.dart';

import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/uploads/payment-model.dart';

class Paymentloc {
  NetworkRequest network = new NetworkRequest();

  final _getPaymenDetails = PublishSubject<PaymentDetailsModel>();
  Observable<PaymentDetailsModel> get getPaymentDetails =>
      _getPaymenDetails.stream;

  final _showProgress = PublishSubject<bool>();
  Observable<bool> get showProgress => _showProgress.stream;

  final snackBar = PublishSubject<String>();
  Observable<String> get snacksBar => snackBar.stream;

  fetchPaymentDetails(id, type) async {
    var toJson = PaymentDetailsModel();
//print(UiData.domain + "/payment/details?id=$id&type=$type");
    String parsed = await network.get(
        Uri.encodeFull(UiData.domain + "/payment/details?id=$id&type=$type"));
        print(parsed);
    var response = jsonDecode(parsed);
    if (response["status"] == false) {
      snackBar.add('Could not fetch data');
      return;
    }
    //print('value is gotten from the server');
    toJson = PaymentDetailsModel.fromJson(response['data']);
    _getPaymenDetails.sink.add(toJson);
  }


  fetchNewPayCode(id, type) async {
    print('enter fetch new code');
    String parsed = await network.get(
        Uri.encodeFull(UiData.domain + "/payment/new-payment-code?id=$id&type=$type"));
        print('code from ftch new $parsed');
    var response = jsonDecode(parsed);
    if (response["status"] == false) {
      throw new Exception("Error while fetching data");
    }
    //print(response['data']);
    return response['data'];
  }

  updateServerPayment(id, type,reference, message,option) async {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    String parsed = await network.get(
        Uri.encodeFull(UiData.domain + "/payment/update-payment?id=$id&type=$type&ref=$reference&message=$message&source=$platform&option=$option"));
    var response = jsonDecode(parsed);
    if (response["status"] == false) {
      snackBar.add('Could not fetch data');
      throw new Exception("Error while fetching data");
    }
    return response['data'];
  }

  dispose() {
    _getPaymenDetails.close();
    _showProgress.close();
    snackBar.close();
  }
}

final paymentBloc = Paymentloc();
