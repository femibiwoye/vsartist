import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/uploads/payment-bloc.dart';
import 'package:vsartist/src/uploads/payment-model.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/widgets/forms.dart';
import 'package:vsartist/src/global/networks.dart';

class UploadFinish extends StatefulWidget {
  final int id;
  final int count;
  final bool isDrawer;
  UploadFinish({this.id, this.count, this.isDrawer});
  @override
  _UploadFinishState createState() => _UploadFinishState();
}

class _UploadFinishState extends State<UploadFinish> {
  NetworkRequest network = new NetworkRequest();
  final scaffoldState = GlobalKey<ScaffoldState>();
  FormsWidget formsWidget = FormsWidget();

  @override
  void initState() {
    super.initState();
    loadPage();
  }

  loadPage() {
    paymentBloc.fetchPaymentDetails(widget.id, 'release');
  }

  body() => StreamBuilder(
        stream: paymentBloc.getPaymentDetails,
        builder: (context, AsyncSnapshot<PaymentDetailsModel> snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    formsWidget.sectionH3('${snapshot.data.title}',
                        position: TextAlign.center),
                    SizedBox(height: 20.0),
                    formsWidget.sectionBody(
                        "Track number: ${snapshot.data.trackCount.toString()}",
                        position: TextAlign.center),
                    formsWidget.sectionBody(
                        "Release Date: ${snapshot.data.releaseDate.toString()}",
                        position: TextAlign.center),
                    SizedBox(height: 40.0),
                    formsWidget.wideButton('Goto library', context, viewStatus),
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

  viewStatus() {
    Navigator.of(context).pushReplacementNamed(UiData.myMusic);
  }

  onSave(newValue) => setState(() {});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: scaffoldState,
      appTitle: 'Upload Successful',
      bodyData: body(),
      showDrawer: widget.isDrawer,
    );
  }
}
