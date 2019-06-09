import 'package:flutter/material.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/widgets/forms.dart';

class UploadPayment extends StatefulWidget {
  final int id;
  final String type;
  final int count;
  UploadPayment({this.id, this.type, this.count});
  @override
  _UploadPaymentState createState() => _UploadPaymentState();
}

class _UploadPaymentState extends State<UploadPayment> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  FormsWidget formsWidget = FormsWidget();

  body() => Center(
        child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              formsWidget.sectionH3(
                  'Payment for ${widget.type == 'album' ? 'an album' : widget.count.toString() + ' tracks'}',
                  position: TextAlign.center),
              SizedBox(height: 10.0),
              formsWidget.sectionBody(
                  "Track number: 2 \nAmount: N23,000 \nRelease Date: 2019-08-06.",
                  position: TextAlign.center),
              SizedBox(height: 40.0),
              formsWidget.wideButton('Pay Now', context, nextButton),
            ]),
      );

  nextButton() {}

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: scaffoldState,
      appTitle: '${widget.type == 'album' ? 'Album ' : 'Tracks '}Release Payment',
      bodyData: body(),
      showDrawer: true,
    );
  }
}
