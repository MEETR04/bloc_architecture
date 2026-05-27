import 'package:flutter/material.dart';

extension DoubleX on num {
  // Spacing (as Widgets)
  Widget get vSpace => SizedBox(height: toDouble());
  Widget get hSpace => SizedBox(width: toDouble());

  // EdgeInsets Padding
  EdgeInsets get padAll => EdgeInsets.all(toDouble());
  EdgeInsets get padHorizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get padVertical => EdgeInsets.symmetric(vertical: toDouble());

  // Durations
  Duration get ms => Duration(milliseconds: toInt());
  Duration get secs => Duration(seconds: toInt());
}
