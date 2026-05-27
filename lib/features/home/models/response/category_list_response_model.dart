import 'package:json_annotation/json_annotation.dart';

part 'category_list_response_model.g.dart';

@JsonSerializable()
class Category {
  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String image;

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
