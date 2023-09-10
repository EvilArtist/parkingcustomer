class SlotType {
  String code;
  String name;
  String? description;

  SlotType({required this.code, required this.name, description});

  SlotType.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        name = json['name'] {
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
