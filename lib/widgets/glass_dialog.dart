import 'dart:ui';

import 'package:flutter/material.dart';

class GlassDialog {
  static Future<T?> showGlassDialog<T>({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
    Color barrierColor = Colors.white,
    String? barrierLabel,
    bool useSafeArea = false,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
    // Glass dialog specific properties
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    Color? backgroundColor,
    double? backgroundOpacity,
    double blur = 5.0,
    double borderRadius = 20.0,
    Color? borderColor,
    double borderWidth = 1.0,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    double? verticalPadding,
    double? horizontalPadding,
    double? defaultOpacity,
    VoidCallback? onTap,
    // Background glassmorphism properties
    double backgroundBlur = 5.0,
    Color? backgroundGlassColor,
    double? backgroundGlassOpacity,
  }) => showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.transparent,
    barrierLabel: barrierLabel,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    traversalEdgeBehavior: traversalEdgeBehavior,
    builder: (BuildContext context) => GlassDialogWrapper(
      barrierDismissible: barrierDismissible,
      backgroundBlur: backgroundBlur,
      backgroundGlassColor:
          backgroundGlassColor ?? Colors.black.withValues(alpha: 0.1),
      backgroundGlassOpacity: backgroundGlassOpacity ?? 0.3,
      // Remove Dialog wrapper and use Material directly
      child: Dialog(
        constraints: BoxConstraints(
          minWidth: MediaQuery.widthOf(context) * 0.9,
        ),
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: GlassDialogContainer(
          backgroundColor: backgroundColor,
          backgroundOpacity: backgroundOpacity,
          blur: blur,
          borderRadius: borderRadius,
          gradient: gradient,
          verticalPadding: verticalPadding,
          horizontalPadding: horizontalPadding,
          defaultOpacity: defaultOpacity,
          onTap: onTap,
          child: child,
        ),
      ),
    ),
  );
}

class GlassDialogWrapper extends StatelessWidget {
  const GlassDialogWrapper({
    super.key,
    required this.child,
    required this.barrierDismissible,
    required this.backgroundBlur,
    required this.backgroundGlassColor,
    required this.backgroundGlassOpacity,
  });
  final Widget child;
  final bool barrierDismissible;
  final double backgroundBlur;
  final Color backgroundGlassColor;
  final double backgroundGlassOpacity;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: barrierDismissible ? () => Navigator.of(context).pop() : null,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: backgroundBlur, sigmaY: backgroundBlur),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundGlassColor.withValues(alpha: backgroundGlassOpacity),
        child: GestureDetector(
          onTap: () {}, // Prevent taps on dialog content from closing dialog
          child: child,
        ),
      ),
    ),
  );
}

class GlassDialogContainer extends StatelessWidget {
  const GlassDialogContainer({
    super.key,
    this.child,
    this.padding,
    this.alignment,
    this.backgroundColor,
    this.backgroundOpacity,
    this.blur = 5.0,
    this.borderRadius = 20.0,
    this.gradient,
    this.onTap,
    this.verticalPadding,
    this.horizontalPadding,
    this.defaultOpacity,
  });
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final double? backgroundOpacity;
  final double blur;
  final double borderRadius;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? defaultOpacity;

  @override
  Widget build(BuildContext context) {
    // Use IntrinsicWidth to size based on content
    Widget glassWidget = IntrinsicWidth(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: verticalPadding ?? 16.0, // Default padding
              horizontal: horizontalPadding ?? 24.0, // Default padding
            ),
            decoration: BoxDecoration(
              color: (backgroundColor ?? Colors.white).withValues(
                alpha: backgroundOpacity ?? defaultOpacity ?? 0.25,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: child,
          ),
        ),
      ),
    );

    // Add tap functionality if provided
    if (onTap != null) {
      glassWidget = GestureDetector(onTap: onTap, child: glassWidget);
    }

    return glassWidget;
  }
}
