import 'package:flutter/material.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/global/networks.dart';
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
              Text('${percentProgress.toString()}%',
                  style: TextStyle(color: Colors.white)),
              formsWidget.linearProgressBar(percent)
            ]);
          }
        });
  }
}
