import 'dart:io';

import 'package:bloc_architecture/core/api/api_module.dart';
import 'package:bloc_architecture/core/db/app_db.dart';
import 'package:bloc_architecture/core/utils/crash_reporter.dart';
import 'package:bloc_architecture/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_architecture/features/auth/data/datasource/auth_api.dart';
import 'package:bloc_architecture/features/auth/data/repository/auth_repository.dart';
import 'package:bloc_architecture/features/auth/domain/repository/i_auth_repository.dart';
import 'package:bloc_architecture/features/auth/domain/usecases/login_use_case.dart';
import 'package:bloc_architecture/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:bloc_architecture/features/home/bloc/home_bloc.dart';
import 'package:bloc_architecture/features/home/data/datasource/home_api.dart';
import 'package:bloc_architecture/features/home/data/repository/home_repository.dart';
import 'package:bloc_architecture/features/home/domain/repository/i_home_repository.dart';
import 'package:bloc_architecture/features/home/domain/usecases/get_users_use_case.dart';
import 'package:bloc_architecture/routes/app_routes.dart';
import 'package:bloc_architecture/service/network_service.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final appDocumentDir = Platform.isAndroid
      ? await getApplicationDocumentsDirectory()
      : await getLibraryDirectory();

  Hive.init(appDocumentDir.path);

  // 0. Crash reporting & analytics abstraction & Persistence
  locator
    ..registerSingleton<ICrashReporter>(DefaultCrashReporter())
    ..registerSingletonAsync<AppDB>(AppDB.getInstance);
  await locator.isReady<AppDB>();

  // 2. Router
  locator.registerSingleton<AppRouter>(AppRouter());

  // 3. Network layer
  await ApiModule().provides();
  final networkService = NetworkService();
  locator.registerSingleton<NetworkService>(networkService);
  await networkService.initialize();

  // 4. Auth — data layer
  locator
    ..registerLazySingleton<IAuthRepository>(
      () => AuthRepository(locator<AuthApi>()),
    )
    // 5. Auth — domain
    ..registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(locator<IAuthRepository>()),
    )
    ..registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(locator<IAuthRepository>()),
    )
    // 6. Auth — presentation
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        loginUseCase: locator<LoginUseCase>(),
        signUpUseCase: locator<SignUpUseCase>(),
      ),
    )
    // 7. Home — data layer
    ..registerLazySingleton<IHomeRepository>(
      () => HomeRepository(locator<HomeApi>()),
    )
    // 8. Home — domain
    ..registerLazySingleton<GetUsersUseCase>(
      () => GetUsersUseCase(locator<IHomeRepository>()),
    )
    // 9. Home — presentation
    ..registerFactory<HomeBloc>(
      () => HomeBloc(getUsersUseCase: locator<GetUsersUseCase>()),
    );
}
