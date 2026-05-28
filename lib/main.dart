import 'package:bloc_architecture/core/app_bloc_observer.dart';
import 'package:bloc_architecture/core/db/app_db.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/generated/l10n.dart';
import 'package:bloc_architecture/routes/app_routes.dart';
import 'package:bloc_architecture/values/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized prior to calling native channels.
  WidgetsFlutterBinding.ensureInitialized();

  // Attach a global observer to log BLoC state transitions, events, and errors.
  Bloc.observer = AppBlocObserver();

  // Run asynchronous startup operations in parallel to optimize boot speed.
  await Future.wait([
    // Load local environment configuration keys from the .env asset.
    dotenv.load(fileName: '.env'),

    // Enable edge-to-edge display mode.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),

    // Restrict screen orientation strictly to portrait mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]),
  ]);

  // Adjust system status and navigation bar styles for edge-to-edge rendering.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  // Initialize the GetIt service locator and register all app dependencies.
  await setupLocator();

  // Wait until the local database (AppDB/Hive) is fully ready before running the UI.
  await locator.isReady<AppDB>();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) => MaterialApp.router(
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? widget) => ToastificationWrapper(
        config: const ToastificationConfig(maxToastLimit: 1),
        child: widget!,
      ),
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    ),
  );
}
