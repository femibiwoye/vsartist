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

  PaymentDetailsModel paymentDetails = PaymentDetailsModel();

  @override
  void initState() {
    super.initState();
    loadPage();
  }

  loadPage() {
    paymentBloc.fetchPaymentDetails(widget.id, widget.type);
    PaystackPlugin.initialize(publicKey: UiData.paymentKey);
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
                            _startAfreshCharge)),
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

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    print(cardDetails.cardNumber);
    print(cardDetails.cvv);
    print(cardDetails.expiryMonth);
    print(cardDetails.expiryYear);
    return PaymentCard(
      number: cardDetails.cardNumber,
      cvc: cardDetails.cvv,
      expiryMonth: cardDetails.expiryMonth,
      expiryYear: cardDetails.expiryYear,
    );

    // Using Cascade notation (similar to Java's builder pattern)
//    return PaymentCard(
//        number: cardNumber,
//        cvc: cvv,
//        expiryMonth: expiryMonth,
//        expiryYear: expiryYear)
//      ..name = 'Segun Chukwuma Adamu'
//      ..country = 'Nigeria'
//      ..addressLine1 = 'Ikeja, Lagos'
//      ..addressPostalCode = '100001';

    // Using optional parameters
//    return PaymentCard(
//        number: cardNumber,
//        cvc: cvv,
//        expiryMonth: expiryMonth,
//        expiryYear: expiryYear,
//        name: 'Ismail Adebola Emeka',
//        addressCountry: 'Nigeria',
//        addressLine1: '90, Nnebisi Road, Asaba, Deleta State');
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  _startAfreshCharge() async {
    _formKey.currentState.save();

    print(paymentDetails.amountExpected.replaceAll('.', ''));

    Charge charge = Charge()
      ..amount = int.tryParse(paymentDetails.amountExpected.replaceAll('.', ''))
      ..email = paymentDetails.email
      ..reference
      ..card = _getCardFromUI();

    // if (_isLocal()) {
    //   // Set transaction params directly in app (note that these params
    //   // are only used if an access_code is not set. In debug mode,
    //   // setting them after setting an access code would throw an exception
    //   // 1 NGN = 100Kobo
    //   // x NGN  = 2000
    //   charge
    //     ..amount = 10000
    //     ..email = 'customer@email.com'
    //     ..reference = _getReference()
    //     ..putCustomField('Charged From', 'Flutter SDK');
    //   _chargeCard(charge);
    // } else {
    // Perform transaction/initialize on Paystack server to get an access code
    // documentation: https://developers.paystack.co/reference#initialize-a-transaction
    charge.accessCode =await _fetchAccessCodeFrmServer();
    print('server code is ${charge.accessCode}');
    _chargeCard(charge);
    // }
  }

  _chargeCard(Charge charge) {
    // This is called only before requesting OTP
    // Save reference so you may send to server if error occurs with OTP
    handleBeforeValidate(Transaction transaction) {
      _updateStatus(transaction.reference, 'validating...');
    }

    handleOnError(Object e, Transaction transaction) {
      // If an access code has expired, simply ask your server for a new one
      // and restart the charge instead of displaying error
      print(e);
      if (e is ExpiredAccessCodeException) {
        _startAfreshCharge();
        _chargeCard(charge);
        return;
      }

      if (transaction.reference != null) {
        _verifyOnServer(transaction.reference, 'error');
      } else {
        _updateStatus(transaction.reference, e.toString());
      }
    }

    // This is called only after transaction is successful
    handleOnSuccess(Transaction transaction) {
      print('This is the message from paystack ${transaction.message}');
      _verifyOnServer(transaction.reference, 'success');
    }

    PaystackPlugin.chargeCard(context,
        charge: charge,
        beforeValidate: (transaction) => handleBeforeValidate(transaction),
        onSuccess: (transaction) => handleOnSuccess(transaction),
        onError: (error, transaction) => handleOnError(error, transaction));
  }

  void _verifyOnServer(String reference, message) async {
    _updateStatus(reference, 'Verifying...');
    print('dd1');
    try {
      String platform;
      if (Platform.isIOS) {
        platform = 'iOS';
      } else {
        platform = 'Android';
      }
      print('dd2');
      
      String parsed = await network.get(Uri.encodeFull(UiData.domain +
          "/payment/update-payment?id=${widget.id}&type=${widget.type}&ref=$reference&message=$message&source=$platform&option=paystack_card"));

      print('dd3');
      print(parsed);
      print('dd4');
      var response = jsonDecode(parsed);
      if (response["status"] == false) {
        print('dd5');
        _updateStatus(reference, response['data']);
        return;
      }
      print('dd6');
      _updateStatus(reference, 'Successful');
      print('dd7');
      Navigator.pop(context);
      loadPage();
      print('dd8');
    } catch (e) {
      _updateStatus(
          reference,
          'There was a problem verifying %s on the backend: '
          '$reference $e');
    }
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
      print('code from ftch new $parsed');
      var response = jsonDecode(parsed);
      if (response["status"] == false) {
        throw new Exception("Error while fetching data");
      }
      print(response['data']);

      accessCode = response[
          'data']; //paymentBloc.fetchNewPayCode(widget.id, widget.type);
      print('Response for access code = ${response['data']}');
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
    globalFunctions.goToDialog(context, inputPay());
  }

  viewStatus() {
    globalFunctions.openPaymentStatus(context, widget, _done);
    //FetchPaymentReceipt(done: _done, id: widget.id,type: widget.type);
  }

  onSave(newValue) => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: scaffoldState,
      appTitle:
          '${widget.type == 'album' ? 'Album ' : 'Tracks '}Release Payment',
      bodyData: body(),
      showDrawer:
          widget.isDrawer == null || widget.isDrawer == false ? false : true,
    );
  }
}
