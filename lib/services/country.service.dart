import 'dart:convert';

import 'package:eparking_customer/services/url.helpers.dart';

import '../models/country.dart';
import 'package:http/http.dart' as http;

class CountryService {
  static const String host = 'vn-public-apis.fpo.vn';
  static const String provinces = 'provinces/getAll';
  static const String districtsByProvince = 'districts/getByProvince';
  static const String wardsByDistrict = '/wards/getByDistrict';
  static const String limit = 'limit';
  static const String provinceCode = 'provinceCode';
  static const String districtCode = 'districtCode';

  Future<List<Province>> getAllProvinces() async {
    final response = await http.get(
      Uri.https(host, provinces, {limit: '-1'}),
      headers: URLHelpers.buildHeaders(),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    switch (statusType) {
      case 200:
        final json = jsonDecode(response.body);
        List<dynamic> data = json['data']['data'];
        List<Province> listProvinces = data.map((e) {
          final province = Province.fromJson(e);
          return province;
        }).toList();
        listProvinces.sort((a, b) {
          if (a.code == '01') {
            return -1;
          }
          if (b.code == '01') {
            return 1;
          }
          if (a.code == '79' && b.code != '01') {
            return -1;
          }
          if (b.code == '79' && a.code != '01') {
            return 1;
          }
          return a.slug.compareTo(b.slug);
        });
        return listProvinces;
      case 400:
      case 300:
      case 500:
      default:
        return [];
    }
  }

  Future<List<District>> getAllDistrictsByProvince(String code) async {
    final response = await http.get(
      Uri.https(host, districtsByProvince,
          {limit: '-1', provinceCode: code.toString()}),
      headers: URLHelpers.buildHeaders(),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    if (statusType == 200) {
      final json = jsonDecode(response.body);
      List<dynamic> data = json['data']['data'];
      List<District> listDistricts = data.map((e) {
        final district = District.fromJson(e);
        return district;
      }).toList();

      return listDistricts;
    }
    return [];
  }

  Future<List<Ward>> getAllWardsByProvince(String code) async {
    final response = await http.get(
      Uri.https(
          host, wardsByDistrict, {limit: '-1', districtCode: code.toString()}),
      headers: URLHelpers.buildHeaders(),
    );

    final statusType = (response.statusCode / 100).floor() * 100;
    if (statusType == 200) {
      final json = jsonDecode(response.body);
      List<dynamic> data = json['data']['data'];
      List<Ward> listDistricts = data.map((e) {
        final district = Ward.fromJson(e);
        return district;
      }).toList();

      return listDistricts;
    }
    return [];
  }
}
