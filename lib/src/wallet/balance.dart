import 'package:flutter/material.dart';
import 'package:vsartist/src/wallet/wallet-model.dart';
import 'package:vsartist/src/widgets/common-scaffold.dart';
import 'package:vsartist/src/widgets/forms.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/wallet/wallet-bloc.dart';

class WalletBalance extends StatefulWidget {
  @override
  _WalletBalanceState createState() => _WalletBalanceState();
}

class _WalletBalanceState extends State<WalletBalance> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  FormsWidget formsWidget = FormsWidget();

  @override
  void initState() {
    super.initState();
    walletBloc.getBalance(context);
    walletBloc.getHistory();
  }

  Widget appBarTitle() => StreamBuilder(
        stream: walletBloc.balance,
        //initialData: '0.00',
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data, style: TextStyle(color: UiData.orange));
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(UiData.orange),
          );
        },
      );

  Widget appBar() => SliverAppBar(
        backgroundColor: Colors.black,
        pinned: true,
        elevation: 10.0,
        forceElevated: true,
        expandedHeight: 150.0,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          background: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: UiData.kitGradients)),
          ),
          title: Row(
            children: <Widget>[
              Image.asset(UiData.logoMedium, width: 40),
              SizedBox(
                width: 10.0,
              ),
              appBarTitle()
            ],
          ),
        ),
      );

  body() => CustomScrollView(
        slivers: <Widget>[
          appBar(),
          StreamBuilder<List<BalanceHistory>>(
            stream: walletBloc.history,
            builder: (context, snapshot) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    double oldBalance = double.parse(snapshot.data[index].oldBalance);
                    double newBalance = double.parse(snapshot.data[index].newBalance);
                    double balance = newBalance-oldBalance;
                    return ListTile(
                      title: Text(balance.toString(),
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text('From ${snapshot.data[index].oldBalance} to ${snapshot.data[index].newBalance}',
                          style: TextStyle(color: Colors.white)),
                      trailing: Icon(Icons.keyboard_arrow_right,color: snapshot.data[index].type=='credit'? Colors.green: Colors.red),
                    );
                  },
                  childCount: snapshot.hasData ? snapshot.data.length : 0,
                ),
              );
            },
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return ScaffoldCommon(
      scaffoldState: scaffoldState,
      //appTitle: 'Release Payment',
      bodyData: body(),
      showDrawer: false,
    );
  }
}
