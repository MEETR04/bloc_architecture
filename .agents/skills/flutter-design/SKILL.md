---
name: flutter-design
description: Use when creating or modifying any Flutter UI, widgets, screens, layouts, styling, spacing, padding, colors, typography, or theme in this project
---

# Flutter UI Design Guidelines

Apply these rules every time you write or modify Flutter UI code in this project.

---

## Spacing

- Use `AppSpacing` for **all** spacing — never hardcode raw numbers in padding/margin/gap.
- Vertical gaps → `AppSpacing.vs*` (e.g. `AppSpacing.vs16`)
- Horizontal gaps → `AppSpacing.hs*` (e.g. `AppSpacing.hs12`)
- Uniform padding → `AppSpacing.allS*` (e.g. `AppSpacing.allS16`)
- Symmetric horizontal padding → `AppSpacing.symmetricHS*`
- Symmetric vertical padding → `AppSpacing.symmetricVS*`
- Raw spacing value (for BorderRadius, etc.) → `AppSpacing.s*` (e.g. `AppSpacing.s8`)

---

## Dimensions — `.r` Extension

- Every hardcoded `height`, `width`, `borderRadius`, `iconSize`, `elevation`, and font-adjacent pixel value **must** use `.r` from `flutter_screenutil`.
- Examples:
  ```dart
  height: 56.r
  width: 120.r
  BorderRadius.circular(12.r)
  Icon(Icons.add, size: 24.r)
  ```
- Never use raw `double` literals for dimensions without `.r`.

---

## Colors

- Use only `AppColors.*` — never `Colors.*` or hex literals inline.
- Respect light/dark surface semantics:
  - Light backgrounds → `AppColors.backgroundLight` / `AppColors.surfaceLight`
  - Dark backgrounds → `AppColors.backgroundDark` / `AppColors.surfaceDark`
- Semantic states → `AppColors.success`, `AppColors.error`, `AppColors.warning`, `AppColors.info`
- Primary brand → `AppColors.primary`, `AppColors.primaryLight`, `AppColors.primaryDark`
- Secondary accent → `AppColors.secondary`, `AppColors.secondaryLight`, `AppColors.secondaryDark`
- Neutral scale → `AppColors.grey50` … `AppColors.grey950`

---

## Typography

- Use only `AppTextStyle.*` — never inline `TextStyle(fontSize: ...)`.
- Hierarchy:
  - Hero text → `AppTextStyle.displayLarge/Medium/Small`
  - Section titles → `AppTextStyle.headingLarge/Medium/Small`
  - Body copy → `AppTextStyle.bodyLarge/Medium/Small`
  - Tags, captions, badges → `AppTextStyle.labelLarge/Medium/Small`
- Override only `color` or `fontWeight` via `.copyWith()`, never reconstruct a `TextStyle` from scratch.
- Font family is `'Outfit'` — do not reference another font.

---

## Theme

- Fetch theme-aware values from `Theme.of(context)` — do not hard-code light/dark colors when the theme already exposes them.
- Never call `Theme.of(context).copyWith(...)` inside a build method; place overrides in `AppTheme`.
- Use `AppTheme` as the single source of truth for `ThemeData`; do not scatter theme overrides across widgets.

---

## Widget Structure & File Organization

- **No UI directly in `body`** — extract every meaningful section into its own private widget or function.
- Extracted widgets go in a **separate file** (e.g. `_login_form.dart`, `_header_section.dart`) or as a **private class below** the screen class in the same file for small helpers.
- Name extracted widgets with a leading underscore `_` if they are file-private.
- One public `Screen` / `Page` class per file; supporting widgets are private.

```dart
// ✅ Correct — body delegates to extracted widget
body: const _LoginBody(),

// ❌ Wrong — UI in-line inside build
body: Column(children: [Text('...'), TextField(...)])
```

---

## State Management

- This project uses **BLoC**. Do not introduce setState, ChangeNotifier, or Provider.
- The only exception: `ValueNotifier` + `ValueListenableBuilder` for **purely local, ephemeral** UI state (e.g. password-visibility toggle) that has no business logic.
- Never call `setState` — if you feel you need it, use a `ValueNotifier` or push the state into the BLoC.
- Access BLoC via `context.read<MyBloc>()` (one-off dispatch) or `BlocBuilder` / `BlocListener` / `BlocConsumer` (reactive).

---

## Logging

- Always use `debugPrint(...)` — never `print(...)`.
- `debugPrint` is a no-op in release builds; `print` is not.

---

## Deprecated APIs

- Never use deprecated Flutter/Dart APIs. If the analyzer flags a deprecation, replace it before submitting.
- Common replacements:
  - `FlatButton` → `TextButton`
  - `RaisedButton` → `ElevatedButton`
  - `scaffold.showSnackBar` → `ScaffoldMessenger.of(context).showSnackBar`
  - `MediaQuery.of(context).size` → use `flutter_screenutil` equivalents where applicable

---

## Code Comments

- Add **one or two sentences** above each extracted widget explaining its responsibility.
- Skip comments for trivially obvious wrappers.
- Comments describe *what* the widget renders and *why* it exists — not how Flutter renders it.

```dart
/// Displays the user's avatar, name, and online badge in the chat header.
class _ChatHeader extends StatelessWidget { ... }
```

---

## Quick Reference — Imports

```dart
import 'package:<app>/values/app_colors.dart';
import 'package:<app>/values/app_spacing.dart';
import 'package:<app>/values/app_text_style.dart';
import 'package:<app>/values/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
```

---

## Cross-skill References

| Topic | Skill file |
|---|---|
| Retrofit, repository, use case, DI patterns | `flutter-api-skill.md` |
| BLoC state/event design, handler pattern, UI consumers | `flutter-bloc-skill.md` |
| Route registration, AppNavigator usage | `flutter-routing-skill.md` |
| End-to-end new feature scaffolding checklist | `flutter-new-feature-skill.md` |
| Git commit format | `git-format-skill.md` |
