import 'dart:async';

import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/service/network_service.dart';
import 'package:flutter/material.dart';

class AutoRefreshBuilder extends StatefulWidget {
  const AutoRefreshBuilder({
    super.key,
    required this.onRetry,
    required this.child,
  });
  final Widget child;
  final VoidCallback onRetry;

  @override
  State<AutoRefreshBuilder> createState() => _AutoRefreshBuilderState();
}

class _AutoRefreshBuilderState extends State<AutoRefreshBuilder> {
  StreamSubscription<void>? _subscription;

  @override
  void initState() {
    super.initState();
    try {
      if (locator.isRegistered<NetworkService>()) {
        _subscription = locator<NetworkService>().onInternetRestored.listen((
          _,
        ) {
          if (mounted) widget.onRetry();
        });
      }
    } catch (e) {
      debugPrint('AutoRefreshBuilder error: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
