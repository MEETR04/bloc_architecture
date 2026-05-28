import 'package:bloc_architecture/features/home/models/response/reqres_user_model.dart';

abstract interface class IHomeRepository {
  Future<List<ReqresUser>> getUsers({int page = 1});
}
