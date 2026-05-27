import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode

class AppBlocObserver extends BlocObserver {
  void _log(String message) {
    if (kDebugMode) debugPrint(message);
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    _log('🟢 [CREATE] ${bloc.runtimeType}');
    super.onCreate(bloc);
  }

  /*
    @override
    void onChange(BlocBase bloc, Change change) {
    _log("""
🔄 [CHANGE] ${bloc.runtimeType}
  → current: ${change.currentState}
  → next: ${change.nextState}
""");
    super.onChange(bloc, change);
  }
  */

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    _log('''
⚡ [TRANSITION] ${bloc.runtimeType}
  → event: ${transition.event}
  → current: ${transition.currentState}
  → next: ${transition.nextState}
''');
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _log('''
❌ [ERROR] ${bloc.runtimeType}
  → error: $error
  → stacktrace: $stackTrace
''');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    _log('🔴 [CLOSE] ${bloc.runtimeType}');
    super.onClose(bloc);
  }
}
