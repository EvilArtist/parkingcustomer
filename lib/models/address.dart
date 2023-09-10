class Address {
  String? fullAddress;
  String? address1;
  String? address2;
  String? street;
  String? ward;
  String? district;
  String? province;

  Address({fullAddress, address1, address2, street, ward, district, province});

  Address.fromJson(Map<String, dynamic> json) {
    fullAddress = json['fullAddress'];
    address1 = json['address1'];
    address2 = json['address2'];
    street = json['street'];
    ward = json['ward'];
    district = json['district'];
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullAddress'] = fullAddress;
    data['address1'] = address1;
    data['address2'] = address2;
    data['street'] = street;
    data['ward'] = ward;
    data['district'] = district;
    data['province'] = province;
    return data;
  }
}
