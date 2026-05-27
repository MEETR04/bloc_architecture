import 'package:auto_route/auto_route.dart';
import 'package:bloc_architecture/routes/app_routes.dart';
import 'package:flutter/material.dart';

/// Centralized navigation helper.
/// All methods delegate to [appRouter] — no BuildContext required.
class AppNavigator {
  AppNavigator._();

  static NavigatorState get _nav => appRouter.navigatorKey.currentState!;

  // ──────────────────────────────────────────────
  // Push
  // ──────────────────────────────────────────────

  /// Push a route onto the stack.
  static Future<T?> push<T>(PageRouteInfo route) => appRouter.push<T>(route);

  /// Navigate to [route] — respects existing stack.
  static Future<void> navigate(PageRouteInfo route) =>
      appRouter.navigate(route);

  // ──────────────────────────────────────────────
  // Replace
  // ──────────────────────────────────────────────

  /// Replace the top-most route with [route].
  static Future<T?> replace<T>(PageRouteInfo route) =>
      appRouter.replace<T>(route);

  /// Clear the entire stack and push [route] as the new root.
  static Future<void> replaceAll(List<PageRouteInfo> routes) =>
      appRouter.replaceAll(routes);

  /// Convenience: replace all with a single root route.
  static Future<void> replaceAllWith(PageRouteInfo route) =>
      appRouter.replaceAll([route]);

  // ──────────────────────────────────────────────
  // Pop
  // ──────────────────────────────────────────────

  /// Pop the top-most route. Optionally return a [result].
  static void pop<T extends Object?>([T? result]) => _nav.pop<T>(result);

  /// Pop only if the stack allows it (safe pop).
  static Future<bool> maybePop<T extends Object?>([T? result]) =>
      _nav.maybePop<T>(result);

  /// Pop routes until [predicate] returns true.
  static void popUntil(bool Function(Route<dynamic>) predicate) =>
      _nav.popUntil(predicate);

  /// Pop until the route whose name matches [routeName].
  static void popUntilRouteNamed(String routeName) =>
      _nav.popUntil(ModalRoute.withName(routeName));

  /// Pop all routes until the first route (back to root).
  static void popToRoot() => appRouter.popUntilRoot();

  // ──────────────────────────────────────────────
  // State queries
  // ──────────────────────────────────────────────

  /// Whether there is at least one route that can be popped.
  static bool get canPop =>
      appRouter.navigatorKey.currentState?.canPop() ?? false;

  /// Current route name on top of the stack.
  static String? get currentRouteName => appRouter.current.name;
}
