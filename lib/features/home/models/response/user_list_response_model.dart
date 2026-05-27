// page : 0
// per_page : 0
// total : 0
// total_pages : 0
// data : [{"id":0,"email":"string","first_name":"string","last_name":"string","avatar":"string"}]

class UserListResponseModel {
  UserListResponseModel({
    num? page,
    num? perPage,
    num? total,
    num? totalPages,
    List<Data>? data,
  }) {
    _page = page;
    _perPage = perPage;
    _total = total;
    _totalPages = totalPages;
    _data = data;
  }

  UserListResponseModel.fromJson(dynamic json) {
    if (json is Map) {
      _page = json['page'] as num?;
      _perPage = json['per_page'] as num?;
      _total = json['total'] as num?;
      _totalPages = json['total_pages'] as num?;
      if (json['data'] is List) {
        _data = [];
        for (final dynamic v in json['data'] as List) {
          _data?.add(Data.fromJson(v));
        }
      }
    }
  }
  num? _page;
  num? _perPage;
  num? _total;
  num? _totalPages;
  List<Data>? _data;
  UserListResponseModel copyWith({
    num? page,
    num? perPage,
    num? total,
    num? totalPages,
    List<Data>? data,
  }) => UserListResponseModel(
    page: page ?? _page,
    perPage: perPage ?? _perPage,
    total: total ?? _total,
    totalPages: totalPages ?? _totalPages,
    data: data ?? _data,
  );
  num? get page => _page;
  num? get perPage => _perPage;
  num? get total => _total;
  num? get totalPages => _totalPages;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = _page;
    map['per_page'] = _perPage;
    map['total'] = _total;
    map['total_pages'] = _totalPages;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

// id : 0
// email : "string"
// first_name : "string"
// last_name : "string"
// avatar : "string"

class Data {
  Data({
    num? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
  }) {
    _id = id;
    _email = email;
    _firstName = firstName;
    _lastName = lastName;
    _avatar = avatar;
  }

  Data.fromJson(dynamic json) {
    if (json is Map) {
      _id = json['id'] as num?;
      _email = json['email'] as String?;
      _firstName = json['first_name'] as String?;
      _lastName = json['last_name'] as String?;
      _avatar = json['avatar'] as String?;
    }
  }
  num? _id;
  String? _email;
  String? _firstName;
  String? _lastName;
  String? _avatar;
  Data copyWith({
    num? id,
    String? email,
    String? firstName,
    String? lastName,
    String? avatar,
  }) => Data(
    id: id ?? _id,
    email: email ?? _email,
    firstName: firstName ?? _firstName,
    lastName: lastName ?? _lastName,
    avatar: avatar ?? _avatar,
  );
  num? get id => _id;
  String? get email => _email;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get avatar => _avatar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['first_name'] = _firstName;
    map['last_name'] = _lastName;
    map['avatar'] = _avatar;
    return map;
  }
}
