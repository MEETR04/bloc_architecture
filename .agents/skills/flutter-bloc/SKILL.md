---
name: flutter-bloc
description: Use when creating or modifying a BLoC, Cubit, events, states, or consuming BLoC in Flutter UI with BlocBuilder, BlocListener, or BlocConsumer
---

# Flutter BLoC Guidelines

Apply these rules every time you create or modify a BLoC, Cubit, event, or state in this project.

---

## File Structure

Every BLoC lives in `features/<feature>/bloc/` with exactly three files:

```
bloc/
  <feature>_bloc.dart    ← BLoC class + part directives
  <feature>_event.dart   ← events (part of bloc file)
  <feature>_state.dart   ← states (part of bloc file)
```

- `_event.dart` and `_state.dart` use `part of '<feature>_bloc.dart';` — they are NOT standalone files.
- The bloc file declares `part '<feature>_event.dart';` and `part '<feature>_state.dart';`.

---

## State Design

- Root state is `@immutable sealed class XxxState {}`.
- Each concrete state is `final class XxxSomeState extends XxxState {}`.
- Always include these baseline states per feature:
  - `XxxInitial` — before any event fires
  - `XxxLoadingState` — while async work is in progress
  - One success state per action: `XxxSuccessfulState`
  - One failure state per action: `XxxFailedState`
- Carry data in success states, error message strings in failure states.
- Use `required` named parameters for state fields — never positional.

```dart
part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthLoadingState extends AuthState {}

final class LoginSuccessfulState extends AuthState {
  LoginSuccessfulState({required this.successMessage});
  final String successMessage;
}

final class LoginFailedState extends AuthState {
  LoginFailedState({required this.errorMessage});
  final String errorMessage;
}
```

---

## Event Design

- Root event is `@immutable sealed class XxxEvent {}`.
- Each concrete event is a plain class (not `final`) extending the sealed root.
- Name events after the user action, suffixed `Event`: `LoginButtonPressedEvent`, `UserScrolledEvent`.
- Carry only the data the handler needs — no business logic in events.
- Use `required` named parameters.

```dart
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginButtonPressedEvent extends AuthEvent {
  LoginButtonPressedEvent({required this.email, required this.password});
  final String email;
  final String password;
}
```

---

## BLoC Class

- Extend `Bloc<XxxEvent, XxxState>`.
- Register every handler in the constructor via `on<XxxEvent>(_onXxx)`.
- Handler naming: `_on<EventName>` (drop the `Event` suffix), e.g. `_onLogin`, `_onSignUp`.
- Inject use cases via named constructor parameters — never instantiate or call `locator` inside the BLoC.
- Use cases are stored as private final fields.

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required SignUpUseCase signUpUseCase,
  })  : _loginUseCase = loginUseCase,
        _signUpUseCase = signUpUseCase,
        super(AuthInitial()) {
    on<LoginButtonPressedEvent>(_onLogin);
    on<SignUpButtonPressedEvent>(_onSignUp);
  }

  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
}
```

---

## Handler Pattern

- Always emit loading before any async work.
- Use exhaustive `switch` on `AppResult` — never `if/else` or `.when`.
- Never `await` and then emit in the same expression; emit is sync, awaits are separate.
- Never throw from a handler; all errors come through `Failure` from the use case.

```dart
Future<void> _onLogin(
  LoginButtonPressedEvent event,
  Emitter<AuthState> emit,
) async {
  emit(AuthLoadingState());
  final result = await _loginUseCase(email: event.email, password: event.password);
  switch (result) {
    case Success():
      emit(LoginSuccessfulState(successMessage: 'Login Successful'));
    case Failure(:final message):
      emit(LoginFailedState(errorMessage: message));
  }
}
```

---

## UI — Providing BLoCs

- Provide BLoCs at the screen level via `BlocProvider`, not at the app root unless the BLoC is truly global.
- Retrieve from the locator inside the `create` callback — never pass an already-created BLoC to `BlocProvider.value` for fresh screens.

```dart
// ✅ Correct — new instance per screen
BlocProvider<AuthBloc>(
  create: (_) => locator<AuthBloc>(),
  child: const LoginPage(),
)

// ❌ Wrong — reusing an existing BLoC across screens
BlocProvider.value(value: existingBloc, child: ...)
```

---

## UI — Consuming BLoCs

Use the right builder for the right job:

| Widget | When to use |
|---|---|
| `BlocBuilder` | Rebuild part of the tree when state changes |
| `BlocListener` | Side effects only (navigation, snackbars, dialogs) — no build |
| `BlocConsumer` | Both rebuild and side effects from the same state |

- Scope `BlocBuilder` as tightly as possible — wrap only the widget that actually changes, not the whole scaffold.
- Always use `buildWhen` / `listenWhen` to filter irrelevant states and prevent unnecessary rebuilds.

```dart
// ✅ Narrow scope + buildWhen
BlocBuilder<AuthBloc, AuthState>(
  buildWhen: (prev, curr) => curr is AuthLoadingState || curr is LoginFailedState,
  builder: (context, state) {
    if (state is AuthLoadingState) return const CircularProgressIndicator();
    if (state is LoginFailedState) return Text(state.errorMessage);
    return const SizedBox.shrink();
  },
)
```

---

## Navigation from BLoC State

- Never navigate inside a handler. Navigation is a UI side effect.
- Use `BlocListener` in the widget tree to react to success/failure states and call `AppNavigator`.

```dart
BlocListener<AuthBloc, AuthState>(
  listenWhen: (_, curr) => curr is LoginSuccessfulState || curr is LoginFailedState,
  listener: (context, state) {
    if (state is LoginSuccessfulState) {
      AppNavigator.replaceAllWith(const HomeRoute());
    } else if (state is LoginFailedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage)),
      );
    }
  },
  child: ...,
)
```

---

## AppBlocObserver

- `AppBlocObserver` is already wired globally in `main.dart` — do not add additional observers.
- It logs `CREATE`, `TRANSITION`, `ERROR`, and `CLOSE` events in debug mode via `debugPrint`.
- Do not add `debugPrint` inside handlers for state transitions — the observer handles it.
- If you need `onChange` logging, uncomment the block in `AppBlocObserver` — don't duplicate it elsewhere.

---

## BLoC Lifecycle

- BLoCs registered as `registerFactory` in the locator get a fresh instance per `BlocProvider.create` call — this is correct for screen-scoped BLoCs.
- If a BLoC holds a stream subscription, close it in `close()`:
  ```dart
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
  ```
- Never manually call `bloc.close()` from a widget; let `BlocProvider` handle disposal.

---

## Anti-patterns

| ❌ Don't | ✅ Do instead |
|---|---|
| `setState` anywhere | `ValueNotifier` for local UI, BLoC for business state |
| Business logic in events | Move to use case |
| `locator<XxxUseCase>()` inside BLoC | Inject via constructor |
| `context.read<XxxBloc>().state` for display | `BlocBuilder` |
| Navigate inside a handler | `BlocListener` in the widget |
| Emit after `await` with no guard | Check `if (!isClosed) emit(...)` for long operations |

---

## Cross-skill References

| Topic | Skill file |
|---|---|
| Spacing, colors, typography, widget structure | `flutter-design-skill.md` |
| Retrofit, repository, use case, DI patterns | `flutter-api-skill.md` |
| Route registration, AppNavigator usage | `flutter-routing-skill.md` |
| End-to-end new feature scaffolding checklist | `flutter-new-feature-skill.md` |
| Git commit format | `git-format-skill.md` |
