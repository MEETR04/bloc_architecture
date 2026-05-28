import 'package:bloc_architecture/core/utils/app_result.dart';
import 'package:bloc_architecture/features/home/domain/repository/i_home_repository.dart';
import 'package:bloc_architecture/features/home/models/response/reqres_user_model.dart';

class GetUsersUseCase {
  const GetUsersUseCase(this._repository);
  final IHomeRepository _repository;

  Future<AppResult<List<ReqresUser>>> call({int page = 1}) async {
    try {
      final users = await _repository.getUsers(page: page);
      return Success(users);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
