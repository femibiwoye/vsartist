import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/uploads/pay-test.dart';
import 'package:vsartist/src/uploads/payment-bloc.dart';
import 'package:vsartist/src/uploads/payment-model.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/widgets/forms.dart';
import 'package:intl/intl.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:vsartist/src/global/functions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsartist/src/global/networks.dart';
// import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class UploadPayment extends StatefulWidget {
  final int id;
  final String type;
  final int count;
  final bool isDrawer;
  UploadPayment({this.id, this.type, this.count, this.isDrawer});
  @override
  _UploadPaymentState createState() => _UploadPaymentState();
}

/**
 * Card Number: 4123450131001381
Expiry Date: any date in the future
CVV: 883
 */

class _UploadPaymentState extends State<UploadPayment> {
  NetworkRequest network = new NetworkRequest();
  final scaffoldState = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  FormsWidget formsWidget = FormsWidget();
  CardDetails cardDetails = CardDetails();
  Functions functions = new Functions();
  final formatCurrency = new NumberFormat.simpleCurrency();

  PaymentDetailsModel paymentDetails = PaymentDetailsModel();

  @override
  void initState() {
    super.initState();
    loadPage();
    PaystackPlugin.initialize(publicKey: UiData.paymentKey);
  }

  loadPage() {
    paymentBloc.fetchPaymentDetails(widget.id, widget.type);
  }

  void showToast() {
    functions.showToast("Test show");
  }

  Future<dynamic> initiatePayment() {
    return http.get("http://test.afiaanyi.com/api/directoryoverview").then((http.Response response) {
      final String res = response.body;
      print('server resp: $res');
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || res == null) {
        throw new Exception("Error while fetching data");
      }
      return DateTime.now().millisecondsSinceEpoch.toString();
    });
  }

  Future<dynamic> verifyPayment(String reference) {
    return http.post("http://test.afiaanyi.com/api/me/verifypayments",
        body: {"reference": reference}).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || res == null) {
        throw new Exception("Error while fetching data");
      }
      return '{"status":true,"transaction_status":"success"}';
    });
  }

  Future<CheckoutResponse> getResponse(Charge charge) async {
    print('card payment details ${charge.accessCode} ${charge.amount} ${charge.email} ${charge.reference} ${charge.bearer} ${charge.card}');
    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card,
      // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    print('card resp is ${response.message} ${response.method} ${response.card} ${response.account}');
    return response;
  }
/**Payment end from here */

  Widget bodyBullet(text) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Container(
              height: 5.0,
              width: 5.0,
              decoration: new BoxDecoration(
                color: UiData.orange,
                shape: BoxShape.circle,
              )),
          SizedBox(
            height: 25,
            width: 10,
          ),
          Flexible(
              child: Text(text,
                  softWrap: true,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13)))
        ],
      ));

  Widget paymentPlan(name, amount, textOne, textTwo, textThree,
          {textFour, button}) =>
      Card(
          borderOnForeground: false,
          elevation: 3,
          child: Container(
              //height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width * 0.65,
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                image: new AssetImage(UiData.success),
                fit: BoxFit.cover,
              )),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    new Container(
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      width: 130.0,
                      height: 130.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          image: new AssetImage(UiData.logo),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      )),
                    ),
                    Text(amount,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: 10),
                    bodyBullet(textOne),
                    bodyBullet(textTwo),
                    bodyBullet(textThree),
                    textFour != null ? bodyBullet(textFour) : Container(),
                    SizedBox(height: 10),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: formsWidget.wideButton(
                            'Get Started', context, button)),
                  ])));

  Widget paymentBody() => Container(
      margin: EdgeInsets.only(top: 40),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                paymentPlan(
                    'INDIVIDUAL BUSINESS ACCOUNT',
                    'N1,000',
                    'Create Business Profile',
                    'Online Support',
                    'Upload 5 business pictures',
                    button: continue1),
                SizedBox(height: 40),
                
              ],
            )),
      ));

  continue1() {
    print('click 1');
    _continue(100000);
  }


  void _continue(amount) {
    print('ccc 1');
    Future<dynamic> post = initiatePayment();
    print('ccc 2');
    //Future<dynamic> post = initiatePayment("1");
    post.then((dynamics) {
      print('ccc 3');
      //var json = jsonDecode(dynamics);
      var json = dynamics;;
      if (!json.isEmpty) {
        print('ccc 4');

        if (json!= null) {
          print('ccc 5');
          //Toast.show(json['access_code'], context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          Charge charge = Charge()
            ..amount = amount
            ..reference= 'hgjgkjhkugjghh'//DateTime.now().millisecondsSinceEpoch.toString()
            ..email = 'assample@gmail.com';
print('ccc 6');
          Future<CheckoutResponse> responseObj = getResponse(charge);
          responseObj.then((onValue) {
            Future<dynamic> verifyObj = verifyPayment(onValue.reference);
            verifyObj.then((dynamicsv) {
              var json = jsonDecode(dynamicsv);
              if (!json.isEmpty) {
                if (json['status'] && json['transaction_status'] == 'success') {
                  functions.showToast('Success');
                  
                  Navigator.pop(context);
                } else {
                  functions.showToast('Error occured');
                }
              }
            });
          });
        } else {
          functions.showToast(json['proceed']);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: scaffoldState,
      appTitle:
          '${widget.type == 'album' ? 'Album ' : 'Tracks '}Release Payment',
      bodyData: paymentBody(),
      showDrawer:
          widget.isDrawer == null || widget.isDrawer == false ? false : true,
    );
  }
}
