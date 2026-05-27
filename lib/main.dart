import 'package:bloc_architecture/core/app_bloc_observer.dart';
import 'package:bloc_architecture/core/db/app_db.dart';
import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/generated/l10n.dart';
import 'package:bloc_architecture/routes/app_routes.dart';
import 'package:bloc_architecture/values/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await setupLocator();

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
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? widget) =>
          ToastificationWrapper(
            config: const ToastificationConfig(
              maxToastLimit: 1,
            ),
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
