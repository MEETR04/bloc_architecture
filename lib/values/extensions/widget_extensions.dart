import 'package:flutter/material.dart';

extension WidgetX on Widget {
  // Padding wrapping
  Widget padAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  Widget padSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  Widget padOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );

  // Alignment and Layout wrapping
  Widget get center => Center(child: this);

  Widget align(Alignment alignment) => Align(alignment: alignment, child: this);

  // Visibility
  Widget visible(
    bool visible, {
    Widget defaultWidget = const SizedBox.shrink(),
  }) => visible ? this : defaultWidget;

  // Gesture wrapping
  Widget onTap(VoidCallback action) => GestureDetector(
    onTap: action,
    behavior: HitTestBehavior.opaque,
    child: this,
  );
}
