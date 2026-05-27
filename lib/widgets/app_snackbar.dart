import 'package:bloc_architecture/values/app_colors.dart';
import 'package:bloc_architecture/values/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppSnackbar {
  AppSnackbar._();

  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: Text(
        title ?? 'Success',
        style: AppTextStyle.headingSmall.copyWith(color: AppColors.black),
      ),
      description: Text(
        message,
        style: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey700),
      ),
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      showProgressBar: true,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flatColored,
      title: Text(
        title ?? 'Error',
        style: AppTextStyle.headingSmall.copyWith(color: AppColors.black),
      ),
      description: Text(
        message,
        style: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey700),
      ),
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      showProgressBar: true,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      title: Text(
        title ?? 'Information',
        style: AppTextStyle.headingSmall.copyWith(color: AppColors.black),
      ),
      description: Text(
        message,
        style: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey700),
      ),
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      showProgressBar: true,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: Text(
        title ?? 'Warning',
        style: AppTextStyle.headingSmall.copyWith(color: AppColors.black),
      ),
      description: Text(
        message,
        style: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey700),
      ),
      autoCloseDuration: duration,
      alignment: Alignment.topCenter,
      showProgressBar: true,
    );
  }
}
