import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment = AlignmentGeometry.center,
    this.backgroundColor,
    this.backgroundOpacity,
    this.blur = 4.0,
    this.borderRadius = 12.0,
    this.borderColor,
    this.borderWidth = 1.0,
    this.boxShadow,
    this.gradient,
    this.onTap,
    this.verticalPadding,
    this.horizontalPadding,
    this.defaultOpacity,
    this.isRectangle = false,
    this.needBorder = true,
  });
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final double? backgroundOpacity;
  final double blur;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? defaultOpacity;
  final bool? isRectangle;
  final bool? needBorder;

  @override
  Widget build(BuildContext context) {
    // Determine effective padding
    final EdgeInsetsGeometry effectivePadding =
        padding ??
        EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 16.0,
          vertical: verticalPadding ?? 16.0,
        );
    // Create the glass effect container
    Widget glassWidget = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          // width: width,
          // height: height,
          alignment: alignment,
          padding: effectivePadding,
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                Colors.white.withValues(alpha: defaultOpacity ?? 0.1),
            borderRadius: BorderRadius.circular(borderRadius),
            border: needBorder == false
                ? Border.all(
                    color: borderColor ?? Colors.transparent,
                    width: borderWidth,
                  )
                : GradientBoxBorder(
                    width: borderWidth,
                    gradient: LinearGradient(
                      colors: isRectangle == false
                          ? [Colors.white, Colors.transparent, Colors.white]
                          : [
                              Colors.white,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              Colors.white,
                            ],
                    ),
                  ),
          ),
          child: child,
        ),
      ),
    );

    // Wrap with margin if provided
    if (margin != null) {
      glassWidget = Container(margin: margin, child: glassWidget);
    }

    // Add tap functionality if provided
    if (onTap != null) {
      glassWidget = GestureDetector(onTap: onTap, child: glassWidget);
    }

    return glassWidget;
  }
}
