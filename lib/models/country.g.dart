// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Province _$ProvinceFromJson(Map<String, dynamic> json) => Province(
      json['name'] as String,
      json['slug'] as String,
      json['type'] as String,
      json['name_with_type'] as String,
      json['code'] as String,
      json['isDeleted'] as bool,
    );

Map<String, dynamic> _$ProvinceToJson(Province instance) => <String, dynamic>{
      'name': instance.name,
      'slug': instance.slug,
      'type': instance.type,
      'name_with_type': instance.fullName,
      'code': instance.code,
      'isDeleted': instance.isDeleted,
    };

District _$DistrictFromJson(Map<String, dynamic> json) => District(
      json['name'] as String,
      json['type'] as String,
      json['slug'] as String,
      json['name_with_type'] as String,
      json['path'] as String,
      json['path_with_type'] as String,
      json['code'] as String,
      json['parent_code'] as String,
    );

Map<String, dynamic> _$DistrictToJson(District instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'slug': instance.slug,
      'name_with_type': instance.fullName,
      'path': instance.path,
      'path_with_type': instance.fullPath,
      'code': instance.code,
      'parent_code': instance.parentCode,
    };

Ward _$WardFromJson(Map<String, dynamic> json) => Ward(
      json['name'] as String,
      json['type'] as String,
      json['slug'] as String,
      json['name_with_type'] as String,
      json['path'] as String,
      json['path_with_type'] as String,
      json['code'] as String,
      json['parent_code'] as String,
    );

Map<String, dynamic> _$WardToJson(Ward instance) => <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'slug': instance.slug,
      'name_with_type': instance.fullName,
      'path': instance.path,
      'path_with_type': instance.fullPath,
      'code': instance.code,
      'parent_code': instance.parentCode,
    };
