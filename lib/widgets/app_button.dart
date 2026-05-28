import 'dart:async';

import 'package:bloc_architecture/values/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.text,
    this.child,
    required this.onPressed,
    this.isLoading = false,
    this.buttonBgColor,
    this.textColor,
    this.padding,
    this.minWidth,
    this.height,
    this.borderColor,
    this.borderWidth,
    this.buttonRadius,
    this.textSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.enableScale = true,
    this.enableSplash = true,
  });
  final String text;
  final Widget? child;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? buttonBgColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? minWidth;
  final double? height;
  final Color? borderColor;
  final double? textSize;
  final double? borderWidth;
  final double? buttonRadius;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool enableScale;
  final bool enableSplash;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (widget.isLoading) return;
    DebouncedButton.run(() async {
      HapticFeedback.mediumImpact();

      if (widget.enableScale) {
        // Shrink
        await _animationController.reverse();
        // Expand back
        await _animationController.forward();
      }

      widget.onPressed();
    }, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final Color baseColor =
        widget.buttonBgColor ?? Theme.of(context).primaryColor;

    final Color splash = _getOptimalSplashColor(baseColor);

    return DebouncedButton(
      onTap: _handleTap,
      enableHaptic: false,
      child: ScaleTransition(
        scale: _animationController,
        child: MaterialButton(
          onPressed: widget.isLoading ? null : _handleTap,
          color: baseColor,
          disabledColor: baseColor.withValues(alpha: 0.6),
          textColor: widget.textColor ?? Colors.white,
          elevation: 0,
          highlightElevation: 0,
          splashColor: widget.enableSplash && !widget.isLoading ? splash : Colors.transparent,
          highlightColor: widget.enableSplash && !widget.isLoading ? null : Colors.transparent,
          padding:
              widget.padding ??
              EdgeInsets.symmetric(
                horizontal: widget.horizontalPadding ?? 16.w,
                vertical: widget.verticalPadding ?? 12.h,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.buttonRadius ?? 8.r),
            side: BorderSide(
              color: widget.borderColor ?? Colors.transparent,
              width: widget.borderWidth ?? 0,
            ),
          ),
          minWidth: widget.minWidth,
          height: widget.height,
          child: widget.isLoading
              ? SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.textColor ?? Colors.white,
                    ),
                  ),
                )
              : (widget.child ??
                  Text(
                    widget.text,
                    style: AppTextStyle.labelLarge.copyWith(
                      fontSize: widget.textSize ?? 16.r,
                      color: widget.textColor ?? Colors.white,
                    ),
                  )),
        ),
      ),
    );
  }

  Color _getOptimalSplashColor(Color baseColor) {
    if (baseColor is MaterialColor) {
      return baseColor.shade200.withAlpha(90);
    }
    return _createCustomSplashColor(baseColor);
  }

  Color _createCustomSplashColor(Color baseColor) {
    final hsl = HSLColor.fromColor(baseColor);

    final lighter = hsl
        .withLightness((hsl.lightness + 0.3).clamp(0, 1))
        .withSaturation((hsl.saturation + 0.1).clamp(0, 1));

    return lighter.toColor().withAlpha(90);
  }
}

class DebouncedButton extends StatefulWidget {
  const DebouncedButton({
    super.key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.onLongPressUp,
    this.behavior,
    this.enableHaptic = true,
  });

  final HitTestBehavior? behavior;
  final Widget child;
  final bool enableHaptic;
  final VoidCallback? onLongPress;
  final VoidCallback? onLongPressUp;
  final VoidCallback onTap;

  static Timer? _globalDebounceTimer;

  static void run(
    VoidCallback action, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (_globalDebounceTimer?.isActive ?? false) return;
    action();
    _globalDebounceTimer = Timer(duration, () {});
  }

  @override
  State<DebouncedButton> createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton> {
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: widget.behavior ?? HitTestBehavior.opaque,
    onTap: () {
      if (widget.enableHaptic) {
        HapticFeedback.mediumImpact();
      }
      DebouncedButton.run(widget.onTap);
    },
    onLongPress: widget.onLongPress,
    onLongPressUp: widget.onLongPressUp,
    child: widget.child,
  );
}
