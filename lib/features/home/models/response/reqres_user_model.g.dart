// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reqres_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReqresUserListResponse _$ReqresUserListResponseFromJson(
  Map<String, dynamic> json,
) => ReqresUserListResponse(
  page: (json['page'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  totalPages: (json['total_pages'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ReqresUser.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ReqresUserListResponseToJson(
  ReqresUserListResponse instance,
) => <String, dynamic>{
  'page': instance.page,
  'per_page': instance.perPage,
  'total': instance.total,
  'total_pages': instance.totalPages,
  'data': instance.data,
};

ReqresUser _$ReqresUserFromJson(Map<String, dynamic> json) => ReqresUser(
  id: (json['id'] as num?)?.toInt(),
  email: json['email'] as String?,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$ReqresUserToJson(ReqresUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar': instance.avatar,
    };
