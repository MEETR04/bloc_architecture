# Project Agent Rules

## Project Identity

- **Package name**: `bloc_architecture`
- **Flutter**: `3.47.2` (stable channel)
- **Dart**: `3.13.2`
- **Design size** (ScreenUtil): `375 × 812`

---

## Architecture Overview

Clean architecture with BLoC state management and GetIt DI. Every feature is self-contained under `lib/features/<feature>/` with these fixed layers:

```
features/<feature>/
  bloc/          → BLoC (events + states as part-of files)
  data/
    datasource/  → Retrofit @RestApi interface
    repository/  → Concrete IXxxRepository implementation
  domain/
    repository/  → Abstract interface (IXxxRepository)
    usecases/    → One UseCase class per action
  models/
    request/     → JSON request DTOs
    response/    → JSON response DTOs
  ui/            → @RoutePage() screens + extracted private widgets
```

---

## Key File Locations

| Purpose | Path |
|---|---|
| DI registration (GetIt) | `lib/core/locator/locator.dart` |
| API module (Dio + Retrofit setup) | `lib/core/api/api_module.dart` |
| API endpoint constants | `lib/core/api/api_endpoints.dart` |
| Exception types | `lib/core/api/exceptions/app_exception.dart` |
| AppResult (Success / Failure) | `lib/core/utils/app_result.dart` |
| BLoC observer | `lib/core/app_bloc_observer.dart` |
| Local DB (Hive) | `lib/core/db/app_db.dart` |
| Router config | `lib/routes/app_routes.dart` |
| Navigation helper | `lib/routes/app_navigator.dart` |
| Colors | `lib/values/app_colors.dart` |
| Spacing + EdgeInsets | `lib/values/app_spacing.dart` |
| Text styles | `lib/values/app_text_style.dart` |
| Theme (light + dark) | `lib/values/app_theme.dart` |

---

## Core Libraries (always available)

| Library | Use for |
|---|---|
| `flutter_bloc` | BLoC / Cubit state management |
| `get_it` | Dependency injection (`locator`) |
| `dio` + `retrofit` | HTTP client + type-safe API layer |
| `auto_route` | Declarative routing |
| `flutter_screenutil` | Responsive `.r` / `.w` / `.h` / `.sp` dimensions |
| `hive` | Local key-value persistence (`AppDB`) |
| `json_serializable` | Model codegen |
| `toastification` | In-app toast notifications |
| `flutter_dotenv` | `.env` secret loading |
| `connectivity_plus` | Network state |
| `cached_network_image` | Remote image loading with cache |

---

## Codegen

Run this after modifying any `_api.dart`, model, or route file:

```
make gen
```

Or directly:

```
dart run build_runner build
```

---

## Always-on Rules

- `debugPrint` only — never `print`
- All dimensions → `.r` (via `flutter_screenutil`)
- All spacing → `AppSpacing.*`
- All colors → `AppColors.*`
- All text styles → `AppTextStyle.*`
- No `setState` — BLoC for business state, `ValueNotifier` for local ephemeral UI only
- No UI in `body` — extract widgets to separate files or private classes
- No deprecated APIs
- Never call `locator` inside a BLoC — inject via constructor
- Never navigate from a BLoC handler — use `BlocListener` in the widget tree
- Always use `AppNavigator` — never `Navigator.of(context)` or `context.router`
- DI registration order: datasource → repository → use case → BLoC
