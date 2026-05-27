// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_req_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpReqModel _$SignUpReqModelFromJson(Map<String, dynamic> json) =>
    SignUpReqModel(
      socialToken: json['social_token'] as String?,
      otp: json['otp'] as String,
      loginType: json['login_type'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phoneNumber: (json['phone_number'] as num?)?.toInt(),
      password: json['password'] as String?,
      userType: json['user_type'] as String,
      businessName: json['business_name'] as String?,
      deviceType: json['device_type'] as String,
      deviceToken: json['device_token'] as String?,
      deviceName: json['device_name'] as String?,
      uuid: json['uuid'] as String?,
      osVersion: json['os_version'] as String?,
      modelName: json['model_name'] as String?,
      ip: json['ip'] as String?,
    );

Map<String, dynamic> _$SignUpReqModelToJson(SignUpReqModel instance) =>
    <String, dynamic>{
      'social_token': instance.socialToken,
      'otp': instance.otp,
      'login_type': instance.loginType,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'password': instance.password,
      'user_type': instance.userType,
      'business_name': instance.businessName,
      'device_type': instance.deviceType,
      'device_token': instance.deviceToken,
      'device_name': instance.deviceName,
      'uuid': instance.uuid,
      'os_version': instance.osVersion,
      'model_name': instance.modelName,
      'ip': instance.ip,
    };
