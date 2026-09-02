import 'package:auto_route/auto_route.dart';
import 'package:bloc_architecture/values/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0.0,
    this.actions,
    this.showLeading = false,
    this.backAction,
    this.titleWidget,
    this.leadingWidget,
    this.titleColor,
    this.borderRadius = 20.0,
    this.bottom,
    Size? preferredSize,
  }) : _customPreferredSize = preferredSize,
       assert(
         title == null || titleWidget == null,
         "Title and Title widget both can't be set at the same time",
       );

  final String? title;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final List<Widget>? actions;
  final bool showLeading;
  final VoidCallback? backAction;
  final Widget? titleWidget;
  final Widget? leadingWidget;
  final Color? titleColor;
  final double borderRadius;
  final PreferredSizeWidget? bottom;
  final Size? _customPreferredSize;

  @override
  Size get preferredSize =>
      _customPreferredSize ??
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallbackBgColor =
        theme.appBarTheme.backgroundColor ?? theme.colorScheme.primary;
    final fallbackTitleColor =
        theme.appBarTheme.titleTextStyle?.color ?? theme.colorScheme.onPrimary;

    return AppBar(
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? fallbackBgColor,
      actions: actions,
      bottom: bottom,
      leading: showLeading
          ? (leadingWidget ??
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: titleColor ?? fallbackTitleColor,
                  onPressed: () {
                    if (backAction != null) {
                      backAction!();
                    } else {
                      context.router.maybePop();
                    }
                  },
                ))
          : leadingWidget,
      title:
          titleWidget ??
          Text(
            title ?? '',
            style: AppTextStyle.headingMedium.copyWith(
              color: titleColor ?? fallbackTitleColor,
              fontSize: 18.r,
            ),
          ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(borderRadius.r),
        ),
      ),
    );
  }
}

/// A wrapper class for backward compatibility with [BaseAppBar].
class BaseAppBar extends CustomAppBar {
  const BaseAppBar({
    super.key,
    super.title,
    super.centerTitle = true,
    super.backgroundColor,
    super.elevation = 0.0,
    super.actions,
    bool leadingIcon = false,
    super.backAction,
    super.titleWidget,
    super.leadingWidget,
    Color? titleWidgetColor,
    double? radius,
    super.bottom,
    super.preferredSize = const Size.fromHeight(kToolbarHeight),
  }) : super(
         showLeading: leadingIcon,
         titleColor: titleWidgetColor,
         borderRadius: radius ?? 20.0,
       );
}
