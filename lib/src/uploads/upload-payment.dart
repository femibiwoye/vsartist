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
  final formatCurrency = new NumberFormat.simpleCurrency();
  Functions functions = new Functions();

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

  inputPay() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Material(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(UiData.logo, height: 80),
                    Text(paymentDetails.email,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500)),
                    Text(
                        NumberFormat.currency(decimalDigits: 2, symbol: 'N')
                            .format(
                                double.tryParse(paymentDetails.amountExpected)),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    Divider(color: Colors.grey),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          formsWidget.formLabel('Card Number'),
                          SizedBox(height: 7),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            onSaved: (val) =>
                                setState(() => cardDetails.cardNumber = val),
                            style: TextStyle(color: Colors.black),
                            validator: (val) {
                              return val.length < 16
                                  ? "Minimum character is 16"
                                  : null;
                            },
                            maxLength: 16,
                            decoration: formsWidget
                                .formDecoration('0000 0000 0000 0000'),
                          )
                        ],
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: card(),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: formsWidget.wideButton(
                            'Pay Now ${NumberFormat.currency(decimalDigits: 2, symbol: '').format(double.tryParse(paymentDetails.amountExpected))}',
                            context,
                            () {})),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, color: Colors.red),
                              Text('Secured By',
                                  style: TextStyle(color: Colors.black)),
                              Text('Paystack',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600))
                            ])),
                    Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: RaisedButton(
                          //backgroundColor:Colors.white,

                          color: Colors.white,
                          shape: StadiumBorder(),
                          onPressed: _launchURL,
                          textColor: Colors.amber,
                          child: Text("What is Paystack",
                              style: TextStyle(color: Colors.black)),
                        ))
                  ],
                )),
          ),
        ),
      );

  Widget card() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 3,
              child: Container(
                width: double
                    .maxFinite, //MediaQuery.of(context).size.width * 0.35,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formsWidget.formLabel('Expiry Date (DD/MM)'),
                      SizedBox(height: 7),
                      Row(children: [
                        Flexible(
                            flex: 2,
                            child: Container(
                                width: double
                                    .maxFinite, //MediaQuery.of(context).size.width * 0.35,
                                child: new TextFormField(
                                  keyboardType: TextInputType.phone,
                                  onSaved: (val) => setState(() => cardDetails
                                      .expiryMonth = int.tryParse(val)),
                                  style: TextStyle(color: Colors.black),
                                  validator: (val) {
                                    return val.length < 2
                                        ? "Minimum character is 2"
                                        : null;
                                  },
                                  maxLength: 2,
                                  decoration: formsWidget.formDecoration('MM'),
                                ))),
                        SizedBox(width: 5),
                        Flexible(
                            flex: 3,
                            child: Container(
                                width: double
                                    .maxFinite, //MediaQuery.of(context).size.width * 0.35,
                                child: new TextFormField(
                                  keyboardType: TextInputType.phone,
                                  onSaved: (val) => setState(() => cardDetails
                                      .expiryYear = int.tryParse(val)),
                                  style: TextStyle(color: Colors.black),
                                  validator: (val) {
                                    return val.length < 4
                                        ? "Minimum character is 4"
                                        : null;
                                  },
                                  maxLength: 4,
                                  decoration:
                                      formsWidget.formDecoration('YYYY'),
                                ))),
                      ])
                    ]),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              flex: 1,
              child: Container(
                width: double
                    .maxFinite, //MediaQuery.of(context).size.width * 0.35,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formsWidget.formLabel('CVV'),
                      SizedBox(height: 7),
                      new TextFormField(
                        keyboardType: TextInputType.phone,
                        onSaved: (val) => cardDetails.cvv = val,
                        style: TextStyle(color: Colors.black),
                        validator: (val) {
                          return val.length < 3
                              ? "Minimum character is 3"
                              : null;
                        },
                        maxLength: 3,
                        decoration: formsWidget.formDecoration('...'),
                      )
                    ]),
              ),
            ),
          ],
        ));
  }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    scaffoldState.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => scaffoldState.currentState.removeCurrentSnackBar()),
    ));
  }

  Future<String> _fetchAccessCodeFrmServer() async {
    String accessCode;
    try {
      String parsed = await network.get(Uri.encodeFull(UiData.domain +
          "/payment/new-payment-code?id=${widget.id}&type=${widget.type}"));
      var response = jsonDecode(parsed);
      if (response["status"] == false) {
        throw new Exception("Error while fetching data");
      }

      accessCode = response[
          'data']; //paymentBloc.fetchNewPayCode(widget.id, widget.type);
    } catch (e) {
      _updateStatus(
          'reference',
          'There was a problem getting a new access code form'
              ' the backend: $e');
    }

    return accessCode;
  }

  _done() {
    loadPage();
    Navigator.pop(context);
  }

  body() => StreamBuilder(
        stream: paymentBloc.getPaymentDetails,
        builder: (context, AsyncSnapshot<PaymentDetailsModel> snapshot) {
          if (snapshot.hasData) {
            var _formattedNumber =
                NumberFormat.currency(decimalDigits: 0, symbol: 'N')
                    .format(double.tryParse(snapshot.data.amountExpected));
            paymentDetails = snapshot.data;

            return Center(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    formsWidget.sectionH3(
                        'Payment for ${widget.type == 'album' ? 'an album' : widget.count.toString() + ' tracks'} \n(${snapshot.data.title})',
                        position: TextAlign.center),
                    SizedBox(height: 20.0),
                    formsWidget.sectionBody(
                        "Track number: ${snapshot.data.trackCount.toString()}",
                        position: TextAlign.center),
                    formsWidget.sectionBody("Amount: $_formattedNumber",
                        position: TextAlign.center),
                    formsWidget.sectionBody(
                        "Release Date: ${snapshot.data.releaseDate.toString()}",
                        position: TextAlign.center),
                    SizedBox(height: 40.0),
                    paymentDetails.paymentStatus.toString() != "1"
                        ? formsWidget.wideButton('Pay Now', context, nextButton)
                        : formsWidget.wideButton(
                            'View Status', context, viewStatus),
                  ]),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(UiData.orange)),
          );
        },
      );

  _launchURL() async {
    const url = 'https://paystack.com/why-choose-paystack';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  nextButton() {
    _continue();
  }

  Future<dynamic> initiatePayment() async {
    String parsed = await network.get(Uri.encodeFull(UiData.domain +
        "/payment/new-payment-code?id=${widget.id}&type=${widget.type}"));

    return parsed;
  }

  Future<CheckoutResponse> getResponse(Charge charge) async {
    print(
        'card payment details ${charge.accessCode} ${charge.amount} ${charge.email} ${charge.reference} ${charge.bearer} ${charge.card}');
    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card,
      // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    print(
        'card resp is ${response.message} ${response.method} ${response.card} ${response.account}');
    return response;
  }

  void _continue() {
    Future<dynamic> post = initiatePayment();
    post.then((dynamics) {
      var json = jsonDecode(dynamics);
      if (!json.isEmpty) {
        if (json['status'] == true && json['data'] != 'Paid') {
          Charge charge = Charge()
            ..amount =
                int.tryParse(paymentDetails.amountExpected.replaceAll('.', ''))
            //..accessCode = json['data']
            ..reference = json['data']
            ..email = paymentDetails.email
            ..putCustomField('purchase', widget.type)
            ..putCustomField('purchase_id', widget.id.toString());

          Future<CheckoutResponse> responseObj = getResponse(charge);
          responseObj.then((onValue) {
            Future<dynamic> verifyObj =
                _verifyOnServer(onValue.reference, onValue.message);
            verifyObj.then((dynamicsv) {
              var json = jsonDecode(dynamicsv);
              if (!json.isEmpty) {
                if (json['status']) {
                      functions.showToast(json['data']);
                  loadPage();
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

  _verifyOnServer(String reference, message) async {
    _updateStatus(reference, 'Verifying...');
    try {
      String platform;
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }
print(Uri.encodeFull(UiData.domain +
          "/payment/update-payment?id=${widget.id}&type=${widget.type}&ref=$reference&message=$message&source=$platform&option=paystack_card"));
      String parsed = await network.get(Uri.encodeFull(UiData.domain +
          "/payment/update-payment?id=${widget.id}&type=${widget.type}&ref=$reference&message=$message&source=$platform&option=paystack_card"));

      var response = jsonDecode(parsed);
      if (response["status"] == false) {
        _updateStatus(reference, response['data']);
        return parsed;
      }
      _updateStatus(reference, 'Successful');
      loadPage();
      return parsed;
    } catch (e) {
      _updateStatus(
          reference,
          'There was a problem verifying %s on the backend: '
          '$reference $e');
    }
  }

  viewStatus() {
    globalFunctions.openPaymentStatus(context, widget, _done);
  }

  onSave(newValue) => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: scaffoldState,
      appTitle:
          '${widget.type == 'album' ? 'Album' : 'Tracks'} Release Payment',
      bodyData: body(),
      showDrawer: widget.isDrawer,
    );
  }
}
