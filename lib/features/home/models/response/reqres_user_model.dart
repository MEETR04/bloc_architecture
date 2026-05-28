import 'package:json_annotation/json_annotation.dart';

part 'reqres_user_model.g.dart';

// reqres.in GET /users response:
// {
//   "page": 1, "per_page": 6, "total": 12, "total_pages": 2,
//   "data": [ { "id": 1, "email": "...", "first_name": "...", "last_name": "...", "avatar": "..." } ]
// }

@JsonSerializable()
class ReqresUserListResponse {
  const ReqresUserListResponse({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
  });

  factory ReqresUserListResponse.fromJson(Map<String, dynamic> json) =>
      _$ReqresUserListResponseFromJson(json);

  @JsonKey(name: 'page')
  final int? page;

  @JsonKey(name: 'per_page')
  final int? perPage;

  @JsonKey(name: 'total')
  final int? total;

  @JsonKey(name: 'total_pages')
  final int? totalPages;

  @JsonKey(name: 'data')
  final List<ReqresUser>? data;

  Map<String, dynamic> toJson() => _$ReqresUserListResponseToJson(this);
}

@JsonSerializable()
class ReqresUser {
  const ReqresUser({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  factory ReqresUser.fromJson(Map<String, dynamic> json) =>
      _$ReqresUserFromJson(json);

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  @JsonKey(name: 'avatar')
  final String? avatar;

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  Map<String, dynamic> toJson() => _$ReqresUserToJson(this);
}
