import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'package:vsartist/src/global/networks.dart';
import 'package:vsartist/src/global/uidata.dart';
import 'package:vsartist/src/wallet/wallet-model.dart';

class WalletBloc {
  NetworkRequest network = new NetworkRequest();

  final _balance = PublishSubject<String>();
  Observable<String> get balance => _balance.stream;

  final _history = PublishSubject<List<BalanceHistory>>();
  Observable<List<BalanceHistory>> get history => _history.stream;

  final _showProgress = PublishSubject<bool>();
  Observable<bool> get showProgress => _showProgress.stream;

  final snackBar = PublishSubject<String>();
  Observable<String> get snacksBar => snackBar.stream;

  getBalance() async {
    String parsed =
        await network.get(Uri.encodeFull(UiData.domain + "/wallet/balance"));
    var response = jsonDecode(parsed);
    if (response["status"] == false) {
      snackBar.add('Could not fetch balance');
      return;
    }
    _balance.sink.add(response['balance']);
  }

  getHistory() async {
    var toJson = List<BalanceHistory>();
   
    String parsed =
        await network.get(Uri.encodeFull(UiData.domain + "/wallet/history"));
    var response = jsonDecode(parsed);
    if (response["status"] == false) {
      snackBar.add('Could not fetch history');
      return;
    }
    
    Iterable list = response['history'];
    toJson = list.map((model) => BalanceHistory.fromJson(model)).toList();
    _history.sink.add(toJson);
  }

  dispose() {
    _balance.close();
    _history.close();
    _showProgress.close();
    snackBar.close();
  }
}

final walletBloc = WalletBloc();
