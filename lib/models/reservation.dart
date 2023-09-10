import 'package:smart_parking_customer/models/slot_type.dart';
import 'package:smart_parking_customer/models/vehicle_type.dart';

import 'address.dart';
import 'customer.dart';
import 'parking.dart';

class ParkingSearch {
  Address? address;
  String? vehicleType;

  ParkingSearch({address, vehicleType});

  ParkingSearch.fromJson(Map<String, dynamic> json) {
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    vehicleType = json['vehicleType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['vehicleType'] = vehicleType;
    return data;
  }
}

class Reservation {
  String id;
  String? parkingId;
  String? customerId;
  Parking? parking;
  Customer? customer;
  String? slotTypeCode;
  SlotType? slotType;
  DateTime? reservationTime;
  String? expiredTime;
  String? status;
  VehicleType? vehicleType;
  String licensePlate = "";
  String cardCode = "";

  Reservation(
      {required this.id,
      parkingId,
      customerId,
      parking,
      customer,
      slotTypeCode,
      slotType,
      reservationTime,
      expiredTime,
      status});

  Reservation.fromJson(Map<String, dynamic> json) : id = json['id'] {
    id = json['id'];
    parkingId = json['parkingId'];
    customerId = json['customerId'];
    cardCode = json['cardCode'];
    licensePlate = json['licensePlate'] ?? "";
    parking =
        json['parking'] != null ? Parking.fromJson(json['parking']) : null;
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    slotTypeCode = json['slotTypeCode'];
    slotType =
        json['slotType'] != null ? SlotType.fromJson(json['slotType']) : null;
    vehicleType = json['slotType'] != null
        ? VehicleType.fromJson(json['vehicleType'])
        : null;
    reservationTime = DateTime.parse(json['reservationTime']);
    expiredTime = json['expiredTime'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parkingId'] = parkingId;
    data['customerId'] = customerId;
    if (parking != null) {
      data['parking'] = parking!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    data['slotTypeCode'] = slotTypeCode;
    if (slotType != null) {
      data['slotType'] = slotType!.toJson();
    }
    data['reservationTime'] = reservationTime;
    data['expiredTime'] = expiredTime;
    data['status'] = status;
    return data;
  }
}
