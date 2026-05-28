import 'package:json_annotation/json_annotation.dart';

part 'sign_up_response_model.g.dart';

// reqres.in register response: { "id": 4, "token": "QpwL5tpe83ilfN2" }
@JsonSerializable()
class SignUpResponseModel {
  const SignUpResponseModel({this.id, this.token});

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseModelFromJson(json);

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'token')
  final String? token;

  Map<String, dynamic> toJson() => _$SignUpResponseModelToJson(this);
}
