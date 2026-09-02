import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    this.url,
    this.file,
    this.assets,
    this.initial,
    this.radius = 0,
    this.backgroundColor,
    this.borderColor = Colors.transparent,
    this.borderWidth = 3.0,
    this.textStyle,
    this.height,
    this.width,
    this.roundedCorner,
    this.placeHolder,
    this.boxFit,
    this.shimmer = true,
  });

  /// Remote image URL.
  final String? url;

  /// Local file path.
  final String? file;

  /// Asset path (e.g. `Assets.images.logo`).
  final String? assets;

  /// Initials shown when no image source resolves.
  final String? initial;

  /// Used for circular images. Sets both height and width to [radius] * 2
  /// when [height] / [width] are not provided, and defaults [roundedCorner]
  /// to [radius].
  final double radius;

  final Color? backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final TextStyle? textStyle;
  final double? height;
  final double? width;

  /// Overrides the corner radius; defaults to [radius].
  final double? roundedCorner;

  /// Custom placeholder widget shown while the network image loads.
  final Widget? placeHolder;

  final BoxFit? boxFit;

  /// When `true` (default), shows a shimmer skeleton as the error fallback
  /// instead of an empty container.
  final bool? shimmer;

  @override
  Widget build(BuildContext context) {
    final double h = height ?? radius * 2;
    final double w = width ?? radius * 2;
    final double corner = roundedCorner ?? radius;

    return ClipRRect(
      borderRadius: BorderRadius.circular(corner),
      child: _buildImage(context, h, w),
    );
  }

  Widget _buildImage(BuildContext context, double h, double w) {
    final imageUrl = url?.trim() ?? '';
    final filePath = file?.trim() ?? '';
    final assetPath = assets?.trim() ?? '';

    if (imageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        height: h,
        width: w,
        fit: boxFit ?? BoxFit.cover,
        placeholder: (_, _) => _buildShimmerPlaceholder(h, w),
        errorWidget: (_, _, _) => _buildFallback(context, h, w),
      );
    }

    if (filePath.isNotEmpty && File(filePath).existsSync()) {
      return Image.file(
        File(filePath),
        height: h,
        width: w,
        fit: boxFit ?? BoxFit.cover,
      );
    }

    if (assetPath.isNotEmpty) {
      return Image.asset(
        assetPath,
        height: h,
        width: w,
        fit: boxFit ?? BoxFit.scaleDown,
      );
    }

    return _buildFallback(context, h, w);
  }

  /// Animated shimmer shown while a network image is loading.
  Widget _buildShimmerPlaceholder(double h, double w) =>
      placeHolder ??
      Shimmer(
        duration: const Duration(seconds: 2),
        interval: Duration.zero,
        color: Colors.white,
        colorOpacity: 0.3,
        enabled: true,
        child: Container(
          height: h,
          width: w,
          decoration: BoxDecoration(color: Colors.grey.shade400),
        ),
      );

  /// Fallback shown when no source resolves or network load fails.
  /// Shows a shimmer container with initials / placeholder content when
  /// [shimmer] is `true`, or an empty [SizedBox] otherwise.
  Widget _buildFallback(BuildContext context, double h, double w) {
    if (shimmer != true) return SizedBox(height: h, width: w);

    final theme = Theme.of(context);
    return Container(
      height: h,
      width: w,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      alignment: Alignment.center,
      child: initial != null && initial!.isNotEmpty
          ? Text(
              initial![0].toUpperCase(),
              style:
                  textStyle ??
                  TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: (h * 0.35).clamp(12, 48),
                  ),
            )
          : Icon(
              Icons.image_not_supported_outlined,
              color: theme.colorScheme.onSurfaceVariant,
              size: (h * 0.4).clamp(16, 48),
            ),
    );
  }
}
