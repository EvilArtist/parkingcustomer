class CardCreate {
  String? licensePlate;
  String? color;
  String? vehicleTypeCode;

  CardCreate({this.licensePlate, this.color, this.vehicleTypeCode});

  CardCreate.fromJson(Map<String, dynamic> json)
      : licensePlate = json['licensePlate'],
        vehicleTypeCode = json['vehicleTypeCode'] {
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['licensePlate'] = licensePlate;
    data['color'] = color;
    data['vehicleTypeCode'] = vehicleTypeCode;
    return data;
  }
}

class CardDetails {
  int? id;
  String? uuid;
  String? code;
  String? subscriptionId;
  String? name;
  int? cardType;
  int? status;
  String? licensePlate;
  String? customerName;
  String? color;
  String? subscriptionType;
  String? subscriptionTypeCode;
  String? vehicleType;
  String? vehicleTypeCode;
  DateTime? expiredDate;
  DateTime? extendedDate;
  bool isSubscription;
  bool isExpired;

  CardDetails({
    this.id,
    this.uuid,
    this.code,
    this.name,
    this.cardType,
    this.status,
    this.licensePlate,
    this.customerName,
    this.color,
    this.subscriptionType,
    this.subscriptionTypeCode,
    this.vehicleType,
    this.vehicleTypeCode,
    this.expiredDate,
    this.extendedDate,
    this.isSubscription = false,
    this.subscriptionId,
    this.isExpired = false,
  });

  CardDetails.fromJson(Map<String, dynamic> json)
      : isExpired = json['isExpired'] ?? false,
        isSubscription = json['isSubscription'] ?? false {
    id = json['id'];
    uuid = json['uuid'];
    code = json['code'];
    name = json['name'];
    cardType = json['cardType'];
    status = json['status'];
    licensePlate = json['licensePlate'];
    customerName = json['customerName'];
    color = json['color'];
    subscriptionType = json['subscriptionType'];
    subscriptionTypeCode = json['subscriptionTypeCode'];
    vehicleType = json['vehicleType'];
    vehicleTypeCode = json['vehicleTypeCode'];
    expiredDate = DateTime.parse(json['expiredDate']);
    extendedDate = DateTime.parse(json['extendedDate']);
    subscriptionId = json['subscriptionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['code'] = code;
    data['name'] = name;
    data['cardType'] = cardType;
    data['status'] = status;
    data['licensePlate'] = licensePlate;
    data['customerName'] = customerName;
    data['color'] = color;
    data['subscriptionType'] = subscriptionType;
    data['subscriptionTypeCode'] = subscriptionTypeCode;
    data['vehicleType'] = vehicleType;
    data['vehicleTypeCode'] = vehicleTypeCode;
    data['expiredDate'] = expiredDate;
    data['extendedDate'] = extendedDate;
    data['isSubscription'] = isSubscription;
    data['subscriptionId'] = subscriptionId;
    return data;
  }
}
