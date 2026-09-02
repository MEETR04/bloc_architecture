import 'package:bloc/bloc.dart';
import 'package:bloc_architecture/core/utils/app_logger.dart';

/// Global BLoC observer providing structured transitions, events, and error diagnostics.
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    AppLogger.d('🟢 [CREATE] ${bloc.runtimeType}', tag: 'BLoC');
    super.onCreate(bloc);
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    AppLogger.d(
      '⚡ [TRANSITION] ${bloc.runtimeType} | event: ${transition.event.runtimeType} -> ${transition.nextState.runtimeType}',
      tag: 'BLoC',
    );
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.e(
      '❌ [ERROR] in ${bloc.runtimeType}',
      tag: 'BLoC',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    AppLogger.d('🔴 [CLOSE] ${bloc.runtimeType}', tag: 'BLoC');
    super.onClose(bloc);
  }
}
