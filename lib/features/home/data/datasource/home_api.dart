import 'package:bloc_architecture/core/api/api_endpoints.dart';
import 'package:bloc_architecture/features/home/models/response/reqres_user_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'home_api.g.dart';

@RestApi(baseUrl: APIEndPoints.baseUrl)
abstract class HomeApi {
  factory HomeApi(Dio dio, {String baseUrl}) = _HomeApi;

  // reqres.in returns paginated user list directly
  @GET(APIEndPoints.getUsers)
  Future<ReqresUserListResponse> getUsers({
    @Query('page') int page = 1,
  });
}
