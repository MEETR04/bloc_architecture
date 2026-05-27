import 'package:bloc_architecture/core/api/base_response/base_response.dart';
import 'package:bloc_architecture/features/home/models/response/category_list_response_model.dart';

abstract interface class IHomeRepository {
  Future<BaseResponse<List<Category>>> getCategories();
}
