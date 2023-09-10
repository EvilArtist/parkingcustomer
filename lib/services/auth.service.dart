import 'dart:convert';

import 'package:smart_parking_customer/services/url.helpers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/customer.dart';
import '../models/login.dart';

class AuthService {
  static const String loginPath = 'Auth/login';
  static const String signupPath = 'Auth/signup';
  static const String confirmPhoneNumberPath = 'Auth/confirm-phone';
  static const String registerPath = 'Auth/users/';
  static const String refreshPath = 'token/refresh/';
  static const String verifyPath = 'token/verify/';
  static const String userKey = 'user';

  final storage = const FlutterSecureStorage();
  static Account? account;

  Future<Account> loadAccount() async {
    if (account != null) {
      return account!;
    }
    final json = await storage.read(
      key: userKey,
    );
    if (json != null) {
      account = Account.fromJson(jsonDecode(json));
      return account!;
    } else {
      throw Exception('No User found');
    }
  }

  void saveUser(Account user) async {
    await storage.write(
      key: userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<Account> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final response = await http.post(
      URLHelpers.buildUri(loginPath),
      headers: URLHelpers.buildHeaders(),
      body: jsonEncode(
        {
          'username': emailOrPhone,
          'password': password,
        },
      ),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final user = Account.fromJson(json);
        account = user;
        saveUser(user);

        return user;
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<Customer> signup({
    required String phoneNumber,
    required String password,
  }) async {
    final response = await http.post(
      URLHelpers.buildUri(signupPath),
      headers: URLHelpers.buildHeaders(),
      body: jsonEncode(
        {
          'username': phoneNumber,
          'password': password,
        },
      ),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final user = Customer.fromJson(json);

        return user;
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<bool> confirmPhoneNumber({
    required String phoneNumber,
    required String token,
  }) async {
    final map = <String, String>{'phoneNumber': phoneNumber, 'code': token};
    final response = await http.get(
      URLHelpers.buildUriWithParams(confirmPhoneNumberPath, map),
      headers: URLHelpers.buildHeaders(),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final result = json["success"];
        return result;
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }
}
