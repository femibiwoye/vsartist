import 'package:intl/intl.dart';

class PaymentDetailsModel {
  int id;
  int userId;
  String title;
  String email;
  int trackCount;
  String releaseDate;
  String paidAmount;
  String paidDate;
  int paymentStatus;
  String amountExpected;
  String reference;

  PaymentDetailsModel(
      {this.id,
      this.userId,
      this.title,
      this.email,
      this.trackCount,
      this.releaseDate,
      this.paidAmount,
      this.paidDate,
      this.paymentStatus,
      this.amountExpected, this.reference});

  // Map<String, dynamic> toJson(ReleaseSingle instance) {
  //   return {
  //     'track_count': instance.tracksNumber.toString(),
  //     'release_name': instance.releaseName,
  //     'release_date': instance.releaseDate
  //   };
  // }

  factory PaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    final formatCurrency = new NumberFormat.simpleCurrency();
    return new PaymentDetailsModel(
      id: int.tryParse(json['id']),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']),
      title: json['title'],
      email: json['email'],
      trackCount: int.tryParse(json['track_count']),
      releaseDate: json['release_date'],
      paidAmount: json['paid_amount'],
      paidDate: json['paid_date'],
      paymentStatus: int.tryParse(json['payment_status']),
      amountExpected: json['amount_expected'],
      reference: json['payment_reference'],
    );
  }
}

class CardDetails {
  int id;
  int userId;
  String cardNumber;
  String cvv;
  int expiryMonth;
  int expiryYear;
  int amount;

  CardDetails(
      {this.id,
      this.userId,
      this.cardNumber,
      this.cvv,
      this.expiryMonth,
      this.expiryYear,
      this.amount});
}
