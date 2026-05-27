import 'dart:async';

import 'package:bloc_architecture/routes/app_routes.dart';
import 'package:bloc_architecture/values/app_colors.dart';
import 'package:bloc_architecture/values/app_text_style.dart';
import 'package:bloc_architecture/widgets/app_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  bool _isDialogShowing = false;

  bool isConnected = true;

  void setConnection(bool value) => isConnected = value;

  final _internetRestoredSubject = StreamController<void>.broadcast();
  Stream<void> get onInternetRestored => _internetRestoredSubject.stream;

  Future<void> initialize() async {
    if (_subscription != null) return;

    final result = await _connectivity.checkConnectivity();
    final connected = !result.contains(ConnectivityResult.none);
    setConnection(connected);

    debugPrint('NetworkService: Initial connection state: $connected');

    if (!connected) _showNoInternetDialog();

    _subscription = _connectivity.onConnectivityChanged.listen(_handleChange);
  }

  void _handleChange(List<ConnectivityResult> result) {
    final connected = !result.contains(ConnectivityResult.none);
    debugPrint('NetworkService: Connection changed to: $connected ($result)');

    if (connected == isConnected) return;

    setConnection(connected);

    if (!connected) {
      _showNoInternetDialog();
    } else {
      _dismissDialog();
      _internetRestoredSubject.add(null);
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogShowing) return;

    final context = appRouter.navigatorKey.currentContext;
    if (context == null) {
      debugPrint('NetworkService: Cannot show dialog, context is null');
      return;
    }

    _isDialogShowing = true;
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 32.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.wifi_off_rounded,
                      size: 40.r,
                      color: AppColors.error,
                    ),
                  ),
                  24.verticalSpace,
                  Text(
                    'No Internet Connection',
                    style: AppTextStyle.headingLarge.copyWith(
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  12.verticalSpace,
                  Text(
                    'Please check your internet connection and try again to continue using the app.',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.grey600,
                      height: 1.5,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  32.verticalSpace,
                  AppButton(
                    text: 'Retry',
                    onPressed: _retry,
                    height: 50.h,
                    buttonRadius: 16.r,
                    buttonBgColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() {
      _isDialogShowing = false;
    });
  }

  Future<void> _retry() async {
    final result = await _connectivity.checkConnectivity();
    if (!result.contains(ConnectivityResult.none)) {
      setConnection(true);
      _dismissDialog();
      _internetRestoredSubject.add(null);
    }
  }

  void _dismissDialog() {
    if (!_isDialogShowing) return;

    _isDialogShowing = false;
    if (appRouter.navigatorKey.currentState?.canPop() ?? false) {
      appRouter.navigatorKey.currentState!.pop();
    }
  }

  void dispose() {
    _subscription?.cancel();
    _internetRestoredSubject.close();
  }
}
