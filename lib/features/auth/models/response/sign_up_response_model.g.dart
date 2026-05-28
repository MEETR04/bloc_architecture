// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpResponseModel _$SignUpResponseModelFromJson(Map<String, dynamic> json) =>
    SignUpResponseModel(
      id: (json['id'] as num?)?.toInt(),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$SignUpResponseModelToJson(
        SignUpResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
    };
