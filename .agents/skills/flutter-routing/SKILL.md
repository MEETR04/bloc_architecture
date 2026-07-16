---
name: flutter-routing
description: Use when adding new screens, navigating between pages, modifying AppRouter, or working with auto_route in this Flutter project
---

# Flutter Routing Guidelines

Apply these rules every time you add screens, navigate between pages, or modify the route configuration in this project.

---

## Stack

- Router: `auto_route`
- Config: `AppRouter` in `routes/app_routes.dart`
- Generated file: `routes/app_routes.gr.dart` — **never edit manually**
- Navigation helper: `AppNavigator` in `routes/app_navigator.dart`

---

## Adding a New Screen

**Step 1 — Annotate the page widget**

Every routable screen must be annotated with `@RoutePage()`.
The class name must end in `Page` (the generator strips `Page` and appends `Route`).

```dart
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  ...
}
```

**Step 2 — Register in `AppRouter`**

Add an `AutoRoute` entry to the `routes` list in `app_routes.dart`:

```dart
@override
List<AutoRoute> get routes => [
  AutoRoute(page: LoginRoute.page, initial: true),
  AutoRoute(page: HomeRoute.page),
  AutoRoute(page: ProfileRoute.page),  // ← add here
];
```

**Step 3 — Run codegen**

```
dart run build_runner build
```

This regenerates `app_routes.gr.dart`. The new `ProfileRoute` class will be available after this step.

---

## Navigating

Always use `AppNavigator` static methods — never call `Navigator.of(context)`, `context.router`, or `context.pushRoute` directly.

| Action | Method |
|---|---|
| Push onto stack | `AppNavigator.push(const ProfileRoute())` |
| Navigate (stack-aware) | `AppNavigator.navigate(const HomeRoute())` |
| Replace top route | `AppNavigator.replace(const HomeRoute())` |
| Clear stack + push single root | `AppNavigator.replaceAllWith(const HomeRoute())` |
| Clear stack + push multiple | `AppNavigator.replaceAll([const LoginRoute()])` |
| Pop | `AppNavigator.pop()` |
| Safe pop | `AppNavigator.maybePop()` |
| Pop to root | `AppNavigator.popToRoot()` |
| Pop until named route | `AppNavigator.popUntilRouteNamed(HomeRoute.name)` |
| Check if poppable | `AppNavigator.canPop` |
| Current route name | `AppNavigator.currentRouteName` |

---

## Passing Route Arguments

Declare parameters in the page constructor — `auto_route` generates the typed route class automatically.

```dart
@RoutePage()
class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key, required this.userId});
  final int userId;
}

// Navigate:
AppNavigator.push(UserDetailRoute(userId: 42));
```

Run `build_runner` after changing constructor parameters.

---

## Default Route Type

The default transition is `RouteType.cupertino()` (iOS-style slide), set in `AppRouter.defaultRouteType`.
To override for a specific route, pass `type:` in the `AutoRoute` definition:

```dart
AutoRoute(page: SplashRoute.page, type: const RouteType.fade()),
```

---

## Navigation from BLoC Handlers

Never call `AppNavigator` inside a BLoC handler.
Navigation is a UI side effect — trigger it from `BlocListener`:

```dart
BlocListener<AuthBloc, AuthState>(
  listenWhen: (_, curr) => curr is LoginSuccessfulState,
  listener: (context, state) {
    AppNavigator.replaceAllWith(const HomeRoute());
  },
  child: ...,
)
```

---

## No `BuildContext` Required

`AppNavigator` is context-free — it operates through the `AppRouter`'s `navigatorKey`.
This means navigation can be triggered from anywhere (BLoC observers, services, etc.) without needing a `BuildContext`.

---

## Anti-patterns

| ❌ Don't | ✅ Do instead |
|---|---|
| `Navigator.of(context).push(...)` | `AppNavigator.push(const XxxRoute())` |
| `context.router.push(...)` | `AppNavigator.push(...)` |
| Hardcode route name strings | Use `XxxRoute.name` constant |
| Edit `app_routes.gr.dart` | Run `build_runner` to regenerate |
| Pass `BuildContext` into a service for navigation | Use `AppNavigator` directly |
| Register a route but skip `build_runner` | Always regenerate after route changes |

---

## Cross-skill References

| Topic | Skill file |
|---|---|
| Spacing, colors, typography, widget structure | `flutter-design-skill.md` |
| Retrofit, repository, use case, DI patterns | `flutter-api-skill.md` |
| BLoC state/event design, handler pattern, UI consumers | `flutter-bloc-skill.md` |
| End-to-end new feature scaffolding checklist | `flutter-new-feature-skill.md` |
| Git commit format | `git-format-skill.md` |
