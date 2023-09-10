import 'package:eparking_customer/models/card.dart';
import 'package:flutter/cupertino.dart';

import 'reservation.dart';

class Customer extends ChangeNotifier {
  String id;
  String userNo;
  String userName;
  String? email;
  String? phoneNumber;
  String firstName;
  String lastName;
  String? company;
  bool legacyAccount = false;
  final List<CardDetails> subscriptions = [];
  List<Reservation> reservations = [];
  Wallet? wallet;

  Customer(
      {required this.id,
      required this.userNo,
      required this.userName,
      email,
      phoneNumber,
      required this.firstName,
      required this.lastName,
      company,
      legacyAccount});

  Customer.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userNo = json['userNo'],
        userName = json['userName'],
        firstName = json['firstName'],
        lastName = json['lastName'] {
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    company = json['company'];
    legacyAccount = json['legacyAccount'];
    subscriptions.clear();
    if (json['subscriptions'] != null) {
      json['subscriptions'].forEach((v) {
        subscriptions.add(CardDetails.fromJson(v));
      });
    }
    wallet = json['wallet'] != null
        ? Wallet.fromJson(json['wallet'])
        : Wallet(amount: 0, currency: 'VND');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userNo'] = userNo;
    data['userName'] = userName;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['company'] = company;
    data['legacyAccount'] = legacyAccount;
    return data;
  }

  void addSubscription(CardDetails subscription) {
    subscriptions.add(subscription);
    notifyListeners();
  }

  void setReservations(List<Reservation> data) {
    reservations = data;
    notifyListeners();
  }
}

class Wallet {
  int? amount;
  String? currency;

  Wallet({this.amount, this.currency});

  Wallet.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    return data;
  }
}
