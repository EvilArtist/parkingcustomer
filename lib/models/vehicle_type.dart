class VehicleType {
  String id = "";
  String text = "";
  String code = "";
  String name = "";

  VehicleType();

  VehicleType.fromJson(Map<String, dynamic> json) {
    id = json['code'] ?? json['id'];
    text = json['name'] ?? json['text'];
    code = json['code'] ?? json['id'];
    name = json['name'] ?? json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    return data;
  }
}
