import 'package:bloc_architecture/core/api/exceptions/app_exception.dart';
import 'package:bloc_architecture/core/api/exceptions/dio_exception_utils.dart';
import 'package:bloc_architecture/features/home/data/datasource/home_api.dart';
import 'package:bloc_architecture/features/home/domain/repository/i_home_repository.dart';
import 'package:bloc_architecture/features/home/models/response/reqres_user_model.dart';
import 'package:dio/dio.dart';

class HomeRepository implements IHomeRepository {
  const HomeRepository(this._homeApi);
  final HomeApi _homeApi;

  @override
  Future<List<ReqresUser>> getUsers({int page = 1}) async {
    try {
      final response = await _homeApi.getUsers(page: page);
      return response.data ?? [];
    } on DioException catch (e) {
      throw DioExceptionUtil.parseError(e);
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
