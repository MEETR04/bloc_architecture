import 'package:bloc_architecture/core/api/base_response/base_response.dart';
import 'package:bloc_architecture/core/api/exceptions/app_exception.dart';
import 'package:bloc_architecture/features/home/data/datasource/home_api.dart';
import 'package:bloc_architecture/features/home/domain/repository/i_home_repository.dart';
import 'package:bloc_architecture/features/home/models/response/category_list_response_model.dart';
import 'package:dio/dio.dart';

class HomeRepository implements IHomeRepository {
  const HomeRepository(this._homeApi);
  final HomeApi _homeApi;

  @override
  Future<BaseResponse<List<Category>>> getCategories() async {
    try {
      return await _homeApi.getCategories();
    } on DioException catch (e) {
      final msg = e.response?.data['error']?.toString();
      throw AppException(msg ?? e.error.toString());
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
