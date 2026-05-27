import 'package:bloc_architecture/core/api/api_endpoints.dart';
import 'package:bloc_architecture/core/api/base_response/base_response.dart';
import 'package:bloc_architecture/features/home/models/response/category_list_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'home_api.g.dart';

@RestApi(baseUrl: APIEndPoints.baseUrl)
abstract class HomeApi {
  factory HomeApi(Dio dio, {String baseUrl}) = _HomeApi;

  @GET(APIEndPoints.getCategory)
  Future<BaseResponse<List<Category>>> getCategories();
}
