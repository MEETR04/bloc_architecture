// This is a basic Flutter widget test for the custom AppButton widget.

import 'package:bloc_architecture/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppButton renders text and triggers onPressed on tap',
      (WidgetTester tester) async {
    bool isPressed = false;

    // Build our widget tree with ScreenUtilInit.
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: Center(
              child: AppButton(
                text: 'Test Button',
                onPressed: () {
                  isPressed = true;
                },
              ),
            ),
          ),
        ),
      ),
    );

    // Verify that the button is rendered with the correct label.
    expect(find.text('Test Button'), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.text('Test Button'));
    await tester.pumpAndSettle();

    // Verify that the tap callback was executed.
    expect(isPressed, true);

    // Pump to clear the 1-second debounce timer started by the button.
    await tester.pump(const Duration(seconds: 2));
  });
}

