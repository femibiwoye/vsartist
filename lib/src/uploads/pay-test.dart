import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;

// To get started quickly, change this to your heroku deployment of
// https://github.com/PaystackHQ/sample-charge-card-backend
// Step 1. Visit https://github.com/PaystackHQ/sample-charge-card-backend
// Step 2. Click "Deploy to heroku"
// Step 3. Login with your heroku credentials or create a free heroku account
// Step 4. Provide your secret key and an email with which to start all test transactions
// Step 5. Copy the url generated by heroku (format https://some-url.herokuapp.com) into the space below
String backendUrl = 'https://wilbur-paystack.herokuapp.com';
// Set this to a public key that matches the secret key you supplied while creating the heroku instance
String paystackPublicKey = 'pk_test_7b26bc92d2ed6b175907ea6913786fb05ee2d9e6';
const String appName = 'Paystack Example';

class PayTest extends StatefulWidget {
  @override
  _PayTestState createState() => _PayTestState();
}

class _PayTestState extends State<PayTest> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  //int _radioValue = 0;
  CheckoutMethod _method;
  bool _inProgress = false;
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;

  @override
  void initState() {
    super.initState();
    PaystackPlugin.initialize(publicKey: paystackPublicKey);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(title: const Text(appName)),
      body: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new Form(
          key: _formKey,
          child: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                // new Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     new Expanded(
                //       child: const Text('Initalize transaction from:'),
                //     ),
                //     new Expanded(
                //       child: new Column(
                //           mainAxisSize: MainAxisSize.min,
                //           children: <Widget>[
                //             new RadioListTile<int>(
                //               value: 0,
                //               groupValue: _radioValue,
                //               onChanged: _handleRadioValueChanged,
                //               title: const Text('Local'),
                //             ),
                //             new RadioListTile<int>(
                //               value: 1,
                //               groupValue: _radioValue,
                //               onChanged: _handleRadioValueChanged,
                //               title: const Text('Server'),
                //             ),
                //           ]),
                //     )
                //   ],
                // ),

                new TextFormField(
                  decoration: const InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelText: 'Card number',
                  ),
                  onSaved: (String value) => _cardNumber = value,
                ),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'CVV',
                        ),
                        maxLength: 3,
                        validator: (val) {
                          return val.length < 3
                              ? "Minimum character is 4"
                              : null;
                        },
                        onSaved: (String value) => _cvv = value,
                      ),
                    ),
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Expiry Month',
                        ),
                        validator: (val) {
                          return val.length < 2
                              ? "Minimum character is 2"
                              : null;
                        },
                        maxLength: 2,
                        onSaved: (String value) =>
                            _expiryMonth = int.tryParse(value),
                      ),
                    ),
                    
                    new Expanded(
                      child: new TextFormField(
                        decoration: const InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Expiry Year',
                        ),
                        maxLength: 4,
                        validator: (val) {
                          return val.length < 4
                              ? "Minimum character is 4"
                              : null;
                        },
                        onSaved: (String value) =>
                            _expiryYear = int.tryParse(value),
                      ),
                    )
                  ],
                ),

                _inProgress
                    ? new Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Platform.isIOS
                            ? new CupertinoActivityIndicator()
                            : new CircularProgressIndicator(),
                      )
                    : new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _getPlatformButton(
                              'Charge Card', () => _startAfreshCharge()),
                          new SizedBox(
                            height: 40.0,
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Flexible(
                                  flex: 3,
                                  child: new DropdownButtonHideUnderline(
                                      child: new InputDecorator(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      hintText: 'Checkout method',
                                    ),
                                    isEmpty: _method == null,
                                    child: new DropdownButton<CheckoutMethod>(
                                      value: _method,
                                      isDense: true,
                                      onChanged: (CheckoutMethod value) {
                                        setState(() {
                                          _method = value;
                                        });
                                      },
                                      items: banks.map((String value) {
                                        return new DropdownMenuItem<
                                            CheckoutMethod>(
                                          value: _parseStringToMethod(value),
                                          child: new Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ))),
                              new Flexible(
                                flex: 2,
                                child: new Container(
                                    width: double.infinity,
                                    child: _getPlatformButton(
                                      'Checkout',
                                      () => _handleCheckout(),
                                    )),
                              ),
                            ],
                          )
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _handleRadioValueChanged(int value) =>
  //     setState(() => _radioValue = value);

  _handleCheckout() async {
    if (_method == null) {
      _showMessage('Select checkout method first');
      return;
    }
    setState(() => _inProgress = true);
    _formKey.currentState.save();
    Charge charge = Charge()
      ..amount = 10000
      ..email = 'customer@email.com'
      ..card = _getCardFromUI();

    // if (!_isLocal()) {
    var accessCode = await _fetchAccessCodeFrmServer(_getReference());
    charge.accessCode = accessCode;
    // } else {
    //   charge.reference = _getReference();
    // }

    CheckoutResponse response = await PaystackPlugin.checkout(context,
        method: _method, charge: charge, fullscreen: false);
    print('Response = $response');
    setState(() => _inProgress = false);
    _updateStatus(response.reference, '$response');
  }

  _startAfreshCharge() async {
    _formKey.currentState.save();

    Charge charge = Charge();
    charge.card = _getCardFromUI();

    setState(() => _inProgress = true);

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
    charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
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
      if (e is ExpiredAccessCodeException) {
        _startAfreshCharge();
        _chargeCard(charge);
        return;
      }

      if (transaction.reference != null) {
        _verifyOnServer(transaction.reference);
      } else {
        setState(() => _inProgress = false);
        _updateStatus(transaction.reference, e.toString());
      }
    }

    // This is called only after transaction is successful
    handleOnSuccess(Transaction transaction) {
      _verifyOnServer(transaction.reference);
    }

    PaystackPlugin.chargeCard(context,
        charge: charge,
        beforeValidate: (transaction) => handleBeforeValidate(transaction),
        onSuccess: (transaction) => handleOnSuccess(transaction),
        onError: (error, transaction) => handleOnError(error, transaction));
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

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
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

  Widget _getPlatformButton(String string, Function() function) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = new CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color: CupertinoColors.activeBlue,
        child: new Text(
          string,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = new RaisedButton(
        onPressed: function,
        color: Colors.blueAccent,
        textColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
        child: new Text(
          string.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    }
    return widget;
  }

  Future<String> _fetchAccessCodeFrmServer(String reference) async {
    String url = '$backendUrl/new-access-code';
    String accessCode;
    try {
      http.Response response = await http.get(url);
      accessCode = response.body;
      print('Response for access code = $accessCode');
    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
          ' the backend: $e');
    }

    return accessCode;
  }

  void _verifyOnServer(String reference) async {
    _updateStatus(reference, 'Verifying...');
    String url = '$backendUrl/verify/$reference';
    try {
      http.Response response = await http.get(url);
      var body = response.body;
      _updateStatus(reference, body);
    } catch (e) {
      _updateStatus(
          reference,
          'There was a problem verifying %s on the backend: '
          '$reference $e');
    }
    setState(() => _inProgress = false);
  }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n\ Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message),
      duration: duration,
      action: new SnackBarAction(
          label: 'CLOSE',
          onPressed: () => _scaffoldKey.currentState.removeCurrentSnackBar()),
    ));
  }

  // bool _isLocal() {
  //   return _radioValue == 0;
  // }
}

var banks = ['Selectable', 'Bank', 'Card'];

CheckoutMethod _parseStringToMethod(String string) {
  CheckoutMethod method = CheckoutMethod.selectable;
  switch (string) {
    case 'Bank':
      method = CheckoutMethod.bank;
      break;
    case 'Card':
      method = CheckoutMethod.card;
      break;
  }
  return method;
}