import 'dart:convert';

import 'package:eparking_customer/models/card.dart';
import 'package:eparking_customer/models/reservation.dart';
import 'package:eparking_customer/models/vehicle_type.dart';

import '../models/customer.dart';
import 'auth.service.dart';
import 'url.helpers.dart';
import 'package:http/http.dart' as http;

class CustomerService {
  static const String getUserInfoPath = 'Customer/user/';
  static const String getVehicleTypePath = 'Customer/vehicleTypes/';
  static const String createCardPath = 'Customer/add-card';
  static const String editProfilePath = 'Customer/user/editProfile';
  static const String getReservationPath = 'Customer/reservation';

  static Customer? userInfo;
  static List<VehicleType> _vehicleTypes = List.empty(growable: true);
  Future<Customer> getUserInfo() async {
    if (userInfo != null) {
      return userInfo!;
    } else {
      await refreshUser();
      return userInfo!;
    }
  }

  Future<Customer> refreshUser() async {
    final token = AuthService.account!.accessToken;
    final response = await http.get(URLHelpers.buildUri(getUserInfoPath),
        headers: URLHelpers.buildHeaders(accessToken: token));

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final user = Customer.fromJson(json);
        userInfo = user;
        return user;
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<List<VehicleType>> getVehicleTypes() async {
    if (_vehicleTypes.isNotEmpty) {
      return _vehicleTypes;
    }
    final token = AuthService.account!.accessToken;
    final response = await http.get(URLHelpers.buildUri(getVehicleTypePath),
        headers: URLHelpers.buildHeaders(accessToken: token));

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final List<VehicleType> vehicleTypes = [];
        json.forEach((v) {
          vehicleTypes.add(VehicleType.fromJson(v));
        });
        _vehicleTypes = vehicleTypes;
        return _vehicleTypes;
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<CardDetails> createCard(CardCreate createDTO) async {
    final token = AuthService.account!.accessToken;
    final response = await http.post(URLHelpers.buildUri(createCardPath),
        headers: URLHelpers.buildHeaders(accessToken: token),
        body: jsonEncode(createDTO));

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final card = CardDetails.fromJson(json);
        return card;
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<List<Reservation>> getMyReservations() async {
    final token = AuthService.account!.accessToken;
    final response = await http.get(URLHelpers.buildUri(getReservationPath),
        headers: URLHelpers.buildHeaders(accessToken: token));

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        final List<Reservation> reservations = [];
        json.forEach((v) {
          reservations.add(Reservation.fromJson(v));
        });
        return reservations;
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('Error contacting the server!');
    }
  }

  Future<Customer> updateProfile(Customer profileData) async {
    try {
      final token = AuthService.account!.accessToken;
      final response = await http.get(URLHelpers.buildUri(editProfilePath),
          headers: URLHelpers.buildHeaders(accessToken: token));

      final statusType = (response.statusCode / 100).floor() * 100;
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final user = Customer.fromJson(json);
        userInfo = user;
        return user;
      } else {
        throw Exception('Đã có lỗi xảy ra');
      }
    } catch (error) {
      throw Exception('Đã có lỗi xảy ra!');
    }
  }
}
