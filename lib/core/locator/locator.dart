import 'dart:io';

import 'package:bloc_architecture/core/api/api_module.dart';
import 'package:bloc_architecture/core/db/app_db.dart';
import 'package:bloc_architecture/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_architecture/features/auth/data/datasource/auth_api.dart';
import 'package:bloc_architecture/features/auth/data/repository/auth_repository.dart';
import 'package:bloc_architecture/features/auth/domain/repository/i_auth_repository.dart';
import 'package:bloc_architecture/features/auth/domain/usecases/login_use_case.dart';
import 'package:bloc_architecture/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:bloc_architecture/features/auth/models/response/sign_up_response_model.dart';
import 'package:bloc_architecture/features/home/bloc/home_bloc.dart';
import 'package:bloc_architecture/features/home/data/datasource/home_api.dart';
import 'package:bloc_architecture/features/home/data/repository/home_repository.dart';
import 'package:bloc_architecture/features/home/domain/repository/i_home_repository.dart';
import 'package:bloc_architecture/features/home/domain/usecases/get_categories_use_case.dart';
import 'package:bloc_architecture/routes/app_routes.dart';
import 'package:bloc_architecture/service/enc_service.dart';
import 'package:bloc_architecture/service/get_device_info.dart';
import 'package:bloc_architecture/service/network_service.dart';
import 'package:bloc_architecture/values/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final appDocumentDir = Platform.isAndroid
      ? await getApplicationDocumentsDirectory()
      : await getLibraryDirectory();

  Hive.init(appDocumentDir.path);

  // 1. Persistence
  locator.registerSingletonAsync<AppDB>(AppDB.getInstance);
  await locator.isReady<AppDB>();

  // 2. Encryption (key sourced from AppConstants — single source of truth)
  locator.registerSingleton<EncService>(
    EncService(aesKey: AppConstants.aesKey),
  );

  // 3. Hive adapters
  Hive.registerAdapter(SignUpResponseModelAdapter());

  // 4. Router
  locator.registerSingleton<AppRouter>(AppRouter());

  // 5. NetworkService
  final networkService = NetworkService();
  locator.registerSingleton<NetworkService>(networkService);
  await networkService.initialize();

  // 6. Network layer (Dio, Retrofit)
  await ApiModule().provides();

  // 7. DeviceInfo — pre-fetched async singleton
  locator.registerSingletonAsync<DeviceInfo>(DeviceInfo.fetch);
  await locator.isReady<DeviceInfo>();

  // 7. Auth — data layer
  locator
    ..registerLazySingleton<IAuthRepository>(
      () => AuthRepository(locator<AuthApi>()),
    )
    // 8. Auth — domain (use cases)
    ..registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(locator<IAuthRepository>()),
    )
    ..registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(locator<IAuthRepository>(), locator<DeviceInfo>()),
    )
    // 9. Auth — presentation
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        loginUseCase: locator<LoginUseCase>(),
        signUpUseCase: locator<SignUpUseCase>(),
      ),
    )
    // 10. Home — data layer
    ..registerLazySingleton<IHomeRepository>(
      () => HomeRepository(locator<HomeApi>()),
    )
    // 11. Home — domain
    ..registerLazySingleton<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(locator<IHomeRepository>()),
    )
    // 12. Home — presentation
    ..registerLazySingleton<HomeBloc>(
      () => HomeBloc(getCategoriesUseCase: locator<GetCategoriesUseCase>()),
    );
}
