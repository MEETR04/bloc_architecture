import 'package:json_annotation/json_annotation.dart';

part 'sign_up_req_model.g.dart';

// reqres.in register only needs email + password
@JsonSerializable()
class SignUpReqModel {
  const SignUpReqModel({required this.email, required this.password});

  factory SignUpReqModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpReqModelFromJson(json);

  final String email;
  final String password;

  Map<String, dynamic> toJson() => _$SignUpReqModelToJson(this);
}
