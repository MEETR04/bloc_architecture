import 'package:bloc_architecture/core/utils/app_result.dart';
import 'package:bloc_architecture/features/home/domain/repository/i_home_repository.dart';
import 'package:bloc_architecture/features/home/models/response/category_list_response_model.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repository);
  final IHomeRepository _repository;

  Future<AppResult<List<Category>>> call() async {
    try {
      final response = await _repository.getCategories();
      if (response.isOk && response.data != null) {
        return Success(response.data!);
      }
      return Failure(response.message ?? 'Failed to load categories');
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
