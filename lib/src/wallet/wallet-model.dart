class BalanceHistory {
  String type;
  String oldBalance;
  String newBalance;

  BalanceHistory({this.type, this.oldBalance, this.newBalance});

  Map<String, dynamic> toJson(BalanceHistory instance) {
    return {
      'type': instance.type.toString(),
      'old_balance': instance.oldBalance,
      'new_balance': instance.newBalance
    };
  }

  factory BalanceHistory.fromJson(Map<String, dynamic> json) {
    return new BalanceHistory(
        type: json['type'],
        oldBalance: json['old_balance'],
        newBalance: json['new_balance']);
  }
}
