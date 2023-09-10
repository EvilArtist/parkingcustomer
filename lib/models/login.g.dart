// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Login _$LoginFromJson(Map<String, dynamic> json) => Login(
      json['email'] as String,
      json['password'] as String,
    );

Map<String, dynamic> _$LoginToJson(Login instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      username: json['username'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      accessToken: json['accessToken'] as String,
      expiredDate: DateTime.parse(json['expiredDate'] as String),
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'roles': instance.roles,
      'accessToken': instance.accessToken,
      'expiredDate': instance.expiredDate.toIso8601String(),
    };
