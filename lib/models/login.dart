import 'package:json_annotation/json_annotation.dart';
part "login.g.dart";

@JsonSerializable()
class Login {
  Login(this.email, this.password);

  String email;
  String password;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$LoginToJson(this);
}

@JsonSerializable()
class Account {
  Account({
    required this.username,
    required this.roles,
    required this.accessToken,
    required this.expiredDate,
  });
  String username;
  String? email;
  String? phoneNumber;
  List<String> roles;
  String accessToken;
  DateTime expiredDate;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
