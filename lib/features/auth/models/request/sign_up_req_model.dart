import 'package:json_annotation/json_annotation.dart';

part 'sign_up_req_model.g.dart';

@JsonSerializable()
class SignUpReqModel {
  const SignUpReqModel({
    this.socialToken,
    required this.otp,
    required this.loginType,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.password,
    required this.userType,
    this.businessName,
    required this.deviceType,
    this.deviceToken,
    this.deviceName,
    this.uuid,
    this.osVersion,
    this.modelName,
    this.ip,
  });

  /// Factory constructor for creating a new instance from a map
  factory SignUpReqModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpReqModelFromJson(json);
  @JsonKey(name: 'social_token')
  final String? socialToken;

  final String otp;

  @JsonKey(name: 'login_type')
  final String loginType;

  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  final String email;

  @JsonKey(name: 'phone_number')
  final int? phoneNumber;

  final String? password;

  @JsonKey(name: 'user_type')
  final String userType;

  @JsonKey(name: 'business_name')
  final String? businessName;

  @JsonKey(name: 'device_type')
  final String deviceType;

  @JsonKey(name: 'device_token')
  final String? deviceToken;

  @JsonKey(name: 'device_name')
  final String? deviceName;

  final String? uuid;

  @JsonKey(name: 'os_version')
  final String? osVersion;

  @JsonKey(name: 'model_name')
  final String? modelName;

  final String? ip;

  /// Converts instance to JSON map
  Map<String, dynamic> toJson() => _$SignUpReqModelToJson(this);
}
