import 'dart:convert';

import 'package:eparking_customer/models/login.dart';
import 'package:eparking_customer/models/parking.dart';
import 'package:eparking_customer/models/reservation.dart';
import 'package:eparking_customer/services/auth.service.dart';
import 'package:eparking_customer/services/url.helpers.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  static const String searchParkingPath = 'Reservation/searchParking';
  static const String reservationPath = 'Reservation/reserve/';
  static const String reservationListPath = 'Reservation/reservations/';
  static const String reservationCancelPath = 'Reservation/cancel/';

  Future<List<ParkingCapacity>> searchParking({
    required String province,
    required String ward,
    required String district,
    required String vehicleType,
  }) async {
    Account? user = AuthService.account;
    if (user == null) {
      throw Exception('NO-AUTHORIZIZATION');
    }
    if (user.expiredDate.isBefore(DateTime.now())) {
      throw Exception('TOKEN-EXPIRED');
    }
    final response = await http.post(
      URLHelpers.buildUri(searchParkingPath),
      headers: URLHelpers.buildHeaders(accessToken: user.accessToken),
      body: jsonEncode(
        {
          'address': {'province': province, 'ward': ward, 'district': district},
          'vehicleType': [vehicleType],
        },
      ),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        List<ParkingCapacity> parkingCapacities = [];
        json.forEach((v) {
          parkingCapacities.add(ParkingCapacity.fromJson(v));
        });
        return parkingCapacities.toList();
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('SERVER-ERROR');
    }
  }

  Future<Reservation> reserve(
      String parkingId, String subscriptionId, Duration timeComming) async {
    Account? user = AuthService.account;
    if (user == null) {
      throw Exception('NO-AUTHORIZIZATION');
    }
    if (user.expiredDate.isBefore(DateTime.now())) {
      throw Exception('TOKEN-EXPIRED');
    }
    final payload = jsonEncode({
      "parkingId": parkingId,
      "subscriptionId": subscriptionId,
      "reservationTime": DateTime.now().add(timeComming).toIso8601String()
    });
    final response = await http.post(URLHelpers.buildUri(reservationPath),
        headers: URLHelpers.buildHeaders(accessToken: user.accessToken),
        body: payload);

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        return Reservation.fromJson(json);
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('SERVER-ERROR');
    }
  }

  Future<Reservation> cancel(String reservationId) async {
    Account? user = AuthService.account;
    if (user == null) {
      throw Exception('NO-AUTHORIZIZATION');
    }
    if (user.expiredDate.isBefore(DateTime.now())) {
      throw Exception('TOKEN-EXPIRED');
    }
    final payload = '"$reservationId"';
    final response = await http.post(URLHelpers.buildUri(reservationCancelPath),
        headers: URLHelpers.buildHeaders(accessToken: user.accessToken),
        body: payload);

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        return Reservation.fromJson(json);
      case 400:
      case 300:
      case 500:
      default:
        throw Exception('SERVER-ERROR');
    }
  }
}
