// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  id: json['_id'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'image': instance.image,
};
