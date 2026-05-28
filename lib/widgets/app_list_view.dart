import 'dart:io';

import 'package:bloc_architecture/values/extensions/context.extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _AppListViewType { normal, builder, separated }

class AppListView extends StatelessWidget {
  const AppListView({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    required List<Widget> children,
  }) : _type = _AppListViewType.normal,
       _children = children,
       itemBuilder = null,
       separatorBuilder = null,
       itemCount = null;

  const AppListView.builder({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    required this.itemBuilder,
    required this.itemCount,
  }) : _type = _AppListViewType.builder,
       _children = null,
       separatorBuilder = null;

  const AppListView.separated({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.itemCount,
  }) : _type = _AppListViewType.separated,
       _children = null;

  final _AppListViewType _type;
  final List<Widget>? _children;
  final IndexedWidgetBuilder? itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final int? itemCount;

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    // Only apply the bottom safe area inset padding on Android
    final double bottomInset = Platform.isAndroid
        ? context.systemBottomNavigationBarSpace + 5.r
        : 15.0.r;

    final EdgeInsets resolvedPadding = (padding ?? EdgeInsets.zero).resolve(
      Directionality.of(context),
    );

    final EdgeInsets finalPadding = resolvedPadding.copyWith(
      bottom: resolvedPadding.bottom + bottomInset,
    );

    switch (_type) {
      case _AppListViewType.normal:
        return ListView(
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: finalPadding,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          children: _children!,
        );
      case _AppListViewType.builder:
        return ListView.builder(
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: finalPadding,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          itemBuilder: itemBuilder!,
          itemCount: itemCount,
        );
      case _AppListViewType.separated:
        return ListView.separated(
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: finalPadding,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          itemBuilder: itemBuilder!,
          separatorBuilder: separatorBuilder!,
          itemCount: itemCount!,
        );
    }
  }
}
