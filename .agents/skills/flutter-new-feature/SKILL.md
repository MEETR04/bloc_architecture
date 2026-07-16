---
name: flutter-new-feature
description: Use when scaffolding, building, or adding a complete new feature from scratch in this Flutter project, covering all layers from API to UI
---

# New Feature Scaffolding Guide

Use this checklist every time you add a brand-new feature to this project.
Work top-down — each layer depends on the one above it.

---

## Folder Structure to Create

```
lib/features/<feature>/
  bloc/
    <feature>_bloc.dart
    <feature>_event.dart
    <feature>_state.dart
  data/
    datasource/
      <feature>_api.dart        ← Retrofit interface
      <feature>_api.g.dart      ← generated (do not touch)
    repository/
      <feature>_repository.dart ← concrete implementation
  domain/
    repository/
      i_<feature>_repository.dart  ← abstract interface
    usecases/
      <action>_use_case.dart    ← one file per action
  models/
    request/
      <name>_request_model.dart
      <name>_request_model.g.dart  ← generated
    response/
      <name>_response_model.dart
      <name>_response_model.g.dart ← generated
  ui/
    <feature>_page.dart         ← @RoutePage() screen
    widgets/
      _<widget_name>.dart       ← extracted private widgets
```

---

## Step-by-Step Checklist

### 1 — Endpoints
- [ ] Add path constant(s) to `APIEndPoints` in `core/api/api_endpoints.dart`

### 2 — Models
- [ ] Create request model(s) in `models/request/` with `@JsonSerializable()`
- [ ] Create response model(s) in `models/response/` with `@JsonSerializable()`
- [ ] Run codegen:
  ```
  dart run build_runner build
  ```

### 3 — Datasource
- [ ] Create `<feature>_api.dart` with `@RestApi` abstract class
- [ ] Add `part '<feature>_api.g.dart';`
- [ ] Run codegen again (if not already done in step 2):
  ```
  dart run build_runner build
  ```

### 4 — Domain Interface
- [ ] Create `i_<feature>_repository.dart` as `abstract interface class`
- [ ] Declare one method per use case — return raw response models (not `AppResult`)

### 5 — Repository Implementation
- [ ] Create `<feature>_repository.dart` implementing `I<Feature>Repository`
- [ ] Constructor-inject the datasource
- [ ] Wrap every call in try/catch: `DioException` → `AppException`, generic `catch` → `AppException`

### 6 — Use Cases
- [ ] Create one `<Action>UseCase` class per business action in `domain/usecases/`
- [ ] Each use case: constructor-injects `I<Feature>Repository`, has a single `call(...)` method
- [ ] Return `AppResult<T>` — validate input, catch all errors, never throw

### 7 — BLoC
- [ ] Create `<feature>_bloc.dart`, `_event.dart`, `_state.dart`
- [ ] States: `sealed class` root + `final class` variants (Initial, Loading, Success, Failed per action)
- [ ] Events: `sealed class` root + one class per user action
- [ ] BLoC: inject use cases via named constructor params, register handlers with `on<>()`
- [ ] Handler pattern: `emit(Loading)` → `await useCase()` → `switch(AppResult)` → `emit(Success/Failed)`

### 8 — Dependency Injection
- [ ] In `locator.dart`, register in this order:
  1. Datasource → `registerSingleton<FeatureApi>(FeatureApi(locator<Dio>()))`
  2. Repository → `registerLazySingleton<IFeatureRepository>(() => FeatureRepository(locator<FeatureApi>()))`
  3. Use case(s) → `registerLazySingleton<ActionUseCase>(() => ActionUseCase(locator<IFeatureRepository>()))`
  4. BLoC → `registerFactory<FeatureBloc>(() => FeatureBloc(actionUseCase: locator<ActionUseCase>()))`
- [ ] Add `FeatureApi` registration to `ApiModule.provides()` as well

### 9 — UI
- [ ] Create `<feature>_page.dart` annotated with `@RoutePage()`
- [ ] No UI in the `build` body — extract all sections to private widgets in `ui/widgets/`
- [ ] Wrap screen in `BlocProvider<FeatureBloc>(create: (_) => locator<FeatureBloc>())`
- [ ] Use `BlocBuilder` for rebuilds, `BlocListener` for navigation/snackbars
- [ ] Spacing → `AppSpacing`, dimensions → `.r`, colors → `AppColors`, text → `AppTextStyle`

### 10 — Routing
- [ ] Add `AutoRoute(page: FeatureRoute.page)` to `AppRouter.routes` in `app_routes.dart`
- [ ] Run codegen to generate `FeatureRoute` in `app_routes.gr.dart`:
  ```
  dart run build_runner build
  ```
- [ ] Navigate using `AppNavigator.push(const FeatureRoute())`

---

## Codegen Summary

Run this after **any** of these changes: model, datasource, or route file.

```
dart run build_runner build
```

---

## Cross-skill References

| Topic | Skill file |
|---|---|
| Spacing, colors, typography, widget structure | `flutter-design-skill.md` |
| Retrofit, repository, use case, DI patterns | `flutter-api-skill.md` |
| BLoC state/event design, handler pattern, UI consumers | `flutter-bloc-skill.md` |
| Route registration, AppNavigator usage | `flutter-routing-skill.md` |
| Git commit format | `git-format-skill.md` |
