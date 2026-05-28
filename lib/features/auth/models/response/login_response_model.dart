import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

// reqres.in login response: { "token": "QpwL5tpe83ilfN2" }
@JsonSerializable()
class LoginResponseModel {
  const LoginResponseModel({this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  @JsonKey(name: 'token')
  final String? token;

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
