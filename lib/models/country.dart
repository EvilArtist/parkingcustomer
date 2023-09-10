import 'package:json_annotation/json_annotation.dart';
part 'country.g.dart';

@JsonSerializable()
class Province {
  final String name;
  final String slug;
  final String type;
  // ignore: non_constant_identifier_names
  @JsonKey(name: 'name_with_type')
  final String fullName;
  final String code;
  final bool isDeleted;

  Province(this.name, this.slug, this.type, this.fullName, this.code,
      this.isDeleted);
  factory Province.fromJson(Map<String, dynamic> json) =>
      _$ProvinceFromJson(json);
  Map<String, dynamic> toJson() => _$ProvinceToJson(this);
}

@JsonSerializable()
class District {
  final String name;
  final String type;
  final String slug;
  @JsonKey(name: 'name_with_type')
  final String fullName;
  final String path;
  @JsonKey(name: 'path_with_type')
  final String fullPath;
  final String code;
  @JsonKey(name: 'parent_code')
  final String parentCode;

  District(this.name, this.type, this.slug, this.fullName, this.path,
      this.fullPath, this.code, this.parentCode);
  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);
  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}

@JsonSerializable()
class Ward {
  final String name;
  final String type;
  final String slug;
  @JsonKey(name: 'name_with_type')
  final String fullName;
  final String path;
  @JsonKey(name: 'path_with_type')
  final String fullPath;
  final String code;
  @JsonKey(name: 'parent_code')
  final String parentCode;

  Ward(this.name, this.type, this.slug, this.fullName, this.path, this.fullPath,
      this.code, this.parentCode);
  factory Ward.fromJson(Map<String, dynamic> json) => _$WardFromJson(json);
  Map<String, dynamic> toJson() => _$WardToJson(this);
}
