import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/global/networks.dart';
import 'package:vsartist/src/uploads/payment-bloc.dart';
import 'package:vsartist/src/uploads/payment-model.dart';
import 'package:vsartist/src/widgets/forms.dart';

class Functions {
  FormsWidget formsWidget = FormsWidget();

  List _genres = [
    'Afrobeat',
    'Afropop',
    'World',
    'Gospel',
    'Soundtrack (Original score)',
    'Reggae',
    'R&B/Soul',
    'Rock',
    'Pop',
    'Hip hop/Rap',
    'Blues',
    'Highlife',
    'Fuji',
    'Apala',
    'Alternative'
  ];
  checkInternet(scaffoldState) async {
    if (await networkBloc.checkInternet() != null) {
      this.showSnack(await networkBloc.checkInternet(), scaffoldState);
    }
  }

showToast(data) {
    //Toast.show(data, context,
      //  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: UiData.orange,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  showSnack(data, scaffoldState) {
    if (data != null) {
      scaffoldState.currentState.showSnackBar(new SnackBar(
          duration: Duration(seconds: 5),
          content: new Text(data.toString()),
          backgroundColor: UiData.orange));
    }
  }

  genres() {
    return _genres.map((item) {
      return new DropdownMenuItem<String>(
        child: new Text(
          item,
          style: TextStyle(color: Colors.grey),
        ),
        value: item,
      );
    }).toList();
  }

  Widget progressIndicator(sendProgress) {
    return StreamBuilder<List>(
        stream: sendProgress,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.data == null) {
            return new Container();
          } else {
            double percent = (snapshot.data[0] / snapshot.data[1]) * 1;
            int percentProgress = (percent * 100).round();
            return Column(children: [
              Text(percentProgress<100?'${percentProgress.toString()}%':'Please wait',
                  style: TextStyle(color: Colors.white)),
              formsWidget.linearProgressBar(percent)
            ]);
          }
        });
  }

  goToDialog(context, type) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    type,
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  horizontalList(title, value) => Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.black)),
          Text(value.toString(), style: TextStyle(color: Colors.black)),
        ],
      ));

  successTicket(context, _done, PaymentDetailsModel data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Material(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        elevation: 2.0,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(UiData.logo, height: 80),
              SizedBox(height: 20),
              Image.asset('assets/images/successful-payment.png', height: 80),
              SizedBox(height: 20),
              Text('Payment Completed',
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
                      SizedBox(height: 10),
              Text('A confirmation mail has been sent to ${data.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
              Divider(height: 30, color: Colors.grey),
              horizontalList('Transaction ID', data.reference),
              horizontalList('Date', data.paidDate),
              horizontalList('Paid Amount', '#${data.paidAmount}'),
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: formsWidget.wideButton('DONE', context, _done)),
            ],
          ),
        ),
      ),
    );
  }

  openPaymentStatus(context, widget, _done) {
    paymentBloc.fetchPaymentDetails(widget.id, widget.type);

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: StreamBuilder(
                      stream: paymentBloc.getPaymentDetails,
                      builder: (context,
                          AsyncSnapshot<PaymentDetailsModel> snapshot) {
                        if (snapshot.hasData) {
                          return globalFunctions.successTicket(
                              context, _done, snapshot.data);
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return Center(
                          child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(UiData.orange)),
                        );
                      },
                    )),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _done();
                      },
                    )
                  ],
                ),
              ),
            ));
  }
}

final globalFunctions = Functions();
