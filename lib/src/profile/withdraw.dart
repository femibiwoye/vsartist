import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/wallet/wallet-bloc.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';

import 'dart:math' as math;

import 'package:vsartist/src/widgets/forms.dart';

class Withdraw extends StatefulWidget {
  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController _textFieldController = TextEditingController();
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  FormsWidget formsWidget = FormsWidget();

  double balance = 0;

  @override
  Widget build(BuildContext context) {
    walletBloc.getWithdrawBalance(context);

    _displayDialog(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) {
            return Form(
                key: formKey,
                child: AlertDialog(
                  title: Text('Request withdrawal'),
                  content: TextFormField(
                    validator: (value) {
                      if (double.tryParse(value) < 50000)
                        return 'Withdraw cannot be below N50,000';
                      else if (double.tryParse(value) > balance)
                        return 'Withdraw cannot exceed N$balance';
                      else
                        return null;
                    },
                    autofocus: true,
                    //autovalidate: true,
                    inputFormatters: [
                      DecimalTextInputFormatter(decimalRange: 2)
                    ],
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _textFieldController,

                    decoration: InputDecoration(hintText: "Enter amount"),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('CANCEL'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text('SEND'),
                      onPressed: () {
                        final form = formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          walletBloc.requestWithdraw(
                              _textFieldController.text, context);
                          walletBloc.getWithdrawBalance(context);
                          Navigator.of(context).pop();
                        }
                      },
                    )
                  ],
                ));
          });
    }

    void _continue() {
      _displayDialog(context);
    }

    return ScaffoldCommon(
        appTitle: 'Withdraw',
        showDrawer: false,
        scaffoldState: scaffoldState,
        bodyData: StreamBuilder(
          //initialData: '0',
          stream: walletBloc.balance,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(UiData.orange),
              );
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            balance = double.tryParse(snapshot.data['balance']);

            return Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text('Wallet: ',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text('N${snapshot.data['balance']} ',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Tooltip(
                                      padding: EdgeInsets.all(10),
                                      preferBelow: false,
                                      message: 'As The Artist, You Recieve 70 percent of your Royalties',
                                      child: Icon(
                                        Icons.info,
                                        color: Colors.white70,
                                      )))
                            ]),
                        SizedBox(height: 20),
                        balance >= 50000 && snapshot.data['status'] == false
                            ? formsWidget.wideButton(
                                'Withdraw', context, _continue)
                            : formsWidget.wideButton('Withdraw', context, () {},
                                disable: true),
                        SizedBox(height: 15),
                        Text(
                            snapshot.data['status']
                                ? 'You have pending withdrawal of N${snapshot.data['amount']}'
                                : 'The minimum amount of money that can be withdraw is N50,000. ',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white38, fontSize: 14))
                      ])),
            );
          },
        ));
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}
