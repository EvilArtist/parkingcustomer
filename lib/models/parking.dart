import 'address.dart';
import 'vehicle_type.dart';

class Parking {
  String id;
  String? name;
  String? fullAddress;
  int? numberOfCards;
  int? numberOfParkingLane;
  int? totalCapacity;

  Parking(
      {required this.id,
      name,
      fullAddress,
      numberOfCards,
      numberOfParkingLane,
      totalCapacity});

  Parking.fromJson(Map<String, dynamic> json) : id = json['id'] {
    id = json['id'];
    name = json['name'];
    fullAddress = json['fullAddress'];
    numberOfCards = json['numberOfCards'];
    numberOfParkingLane = json['numberOfParkingLane'];
    totalCapacity = json['totalCapacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fullAddress'] = fullAddress;
    data['numberOfCards'] = numberOfCards;
    data['numberOfParkingLane'] = numberOfParkingLane;
    data['totalCapacity'] = totalCapacity;
    return data;
  }
}

class ParkingCapacity {
  String id;
  String name;
  Address? address;
  List<Capacity>? capacities;

  ParkingCapacity(
      {required this.id, required this.name, this.address, this.capacities});

  ParkingCapacity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'] {
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    if (json['capacities'] != null) {
      capacities = <Capacity>[];
      json['capacities'].forEach((v) {
        capacities!.add(Capacity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (capacities != null) {
      data['capacities'] = capacities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Capacity {
  String? parkingId;
  String? slotTypeCode;
  String? slotTypeName;
  int? capacity;
  int? using;
  int? reserved;
  int? available;
  List<VehicleType> vehicleTypes = List<VehicleType>.empty(growable: true);

  Capacity(
      {this.parkingId,
      this.slotTypeCode,
      this.slotTypeName,
      this.capacity,
      this.using,
      this.reserved,
      this.available});

  Capacity.fromJson(Map<String, dynamic> json) {
    parkingId = json['parkingId'];
    slotTypeCode = json['slotTypeCode'];
    slotTypeName = json['slotTypeName'];
    capacity = json['capacity'];
    using = json['using'];
    reserved = json['reserved'];
    available = json['available'];
    vehicleTypes = [];
    for (var element in json["vehicleTypes"]) {
      VehicleType vehicleType = VehicleType.fromJson(element);
      vehicleTypes.add(vehicleType);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parkingId'] = parkingId;
    data['slotTypeCode'] = slotTypeCode;
    data['slotTypeName'] = slotTypeName;
    data['capacity'] = capacity;
    data['using'] = using;
    data['reserved'] = reserved;
    data['available'] = available;
    data['vehicleTypes'] = available;
    return data;
  }
}
