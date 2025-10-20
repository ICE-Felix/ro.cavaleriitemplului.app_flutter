import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/core/cubit/permission_cubit.dart';

class PermissionWrapper extends StatefulWidget {
  const PermissionWrapper({
    super.key,
    required this.child,
    required this.permission,
    this.deniedBuilder,
    this.permanentlyDeniedBuilder,
    this.disabledServicesBuilder,
    this.checkingBuilder,
    this.onPermissionGranted,
    this.isServiceEnabled,
    this.openServiceSettings,
  });

  factory PermissionWrapper.location({
    Key? key,
    required Widget child,
    WidgetBuilder? deniedBuilder,
    WidgetBuilder? permanentlyDeniedBuilder,
    WidgetBuilder? disabledServicesBuilder,
    WidgetBuilder? checkingBuilder,
    VoidCallback? onPermissionGranted,
  }) {
    return PermissionWrapper(
      key: key,
      child: child,
      permission: Permission.location,
      deniedBuilder: deniedBuilder,
      permanentlyDeniedBuilder: permanentlyDeniedBuilder,
      disabledServicesBuilder: disabledServicesBuilder,
      checkingBuilder: checkingBuilder,
      onPermissionGranted: onPermissionGranted,
      isServiceEnabled: Geolocator.isLocationServiceEnabled,
      openServiceSettings: Geolocator.openLocationSettings,
    );
  }

  final Widget child;
  final Permission permission;
  final WidgetBuilder? deniedBuilder;
  final WidgetBuilder? permanentlyDeniedBuilder;
  final WidgetBuilder? disabledServicesBuilder;
  final WidgetBuilder? checkingBuilder;
  final VoidCallback? onPermissionGranted;
  final Future<bool> Function()? isServiceEnabled;
  final Future<void> Function()? openServiceSettings;

  @override
  State<PermissionWrapper> createState() => _PermissionWrapperState();
}

class _PermissionWrapperState extends State<PermissionWrapper> {
  late final PermissionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PermissionCubit(
      permission: widget.permission,
      isServiceEnabled: widget.isServiceEnabled,
      openServiceSettings: widget.openServiceSettings,
    )..initialize();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionCubit, PermissionState>(
      bloc: _cubit,
      builder: (BuildContext context, PermissionState state) {
        if (state.isChecking) {
          if (widget.checkingBuilder != null)
            return widget.checkingBuilder!(context);
          return const Center(child: CircularProgressIndicator());
        }
        if (!state.isServiceEnabled) {
          if (widget.disabledServicesBuilder != null)
            return widget.disabledServicesBuilder!(context);
          return _DisabledServices(
            onOpenSettings: _cubit.openServiceSettingsSafe,
          );
        }
        if (state.status.isGranted) return widget.child;
        if (state.status.isPermanentlyDenied) {
          if (widget.permanentlyDeniedBuilder != null)
            return widget.permanentlyDeniedBuilder!(context);
          return _PermanentlyDenied(onOpenSettings: _cubit.openAppSettingsSafe);
        }
        if (widget.deniedBuilder != null) return widget.deniedBuilder!(context);
        return _Denied(
          onRequest: () async {
            await _cubit.requestPermission();
            if (_cubit.state.status.isGranted) {
              widget.onPermissionGranted?.call();
            }
          },
        );
      },
    );
  }
}

class _Denied extends StatelessWidget {
  const _Denied({required this.onRequest});

  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.privacy_tip_outlined, size: 48),
            const SizedBox(height: 12),
            const Text('Permission is required to continue.'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRequest, child: const Text('Allow')),
          ],
        ),
      ),
    );
  }
}

class _PermanentlyDenied extends StatelessWidget {
  const _PermanentlyDenied({required this.onOpenSettings});

  final Future<void> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, size: 48),
            const SizedBox(height: 12),
            const Text('Permission is permanently denied.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onOpenSettings,
              child: const Text('Open App Settings'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisabledServices extends StatelessWidget {
  const _DisabledServices({required this.onOpenSettings});

  final Future<void> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.settings, size: 48),
            const SizedBox(height: 12),
            const Text('Required services are disabled.'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onOpenSettings,
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
