import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit({
    required Permission permission,
    Future<bool> Function()? isServiceEnabled,
    Future<void> Function()? openServiceSettings,
  }) : _permission = permission,
       _isServiceEnabledCb = isServiceEnabled,
       _openServiceSettingsCb = openServiceSettings,
       super(const PermissionState());

  static const Duration _pollInterval = Duration(seconds: 5);

  final Permission _permission;
  final Future<bool> Function()? _isServiceEnabledCb;
  final Future<void> Function()? _openServiceSettingsCb;
  Timer? _timer;

  Future<void> initialize() async {
    await _refresh();
    // Automatically request permission once on init if currently denied
    if (state.status.isDenied && state.isServiceEnabled) {
      await requestPermission();
    }
    _startMonitoring();
  }

  Future<void> refreshStatus() async {
    await _refresh();
  }

  Future<void> requestPermission() async {
    final PermissionStatus status = await _permission.request();
    final bool isServiceEnabled = await _checkServiceEnabled();
    emit(
      state.copyWith(
        status: status,
        isServiceEnabled: isServiceEnabled,
        isChecking: false,
      ),
    );
  }

  Future<void> openAppSettingsSafe() async {
    await openAppSettings();
  }

  Future<void> openServiceSettingsSafe() async {
    if (_openServiceSettingsCb != null) {
      await _openServiceSettingsCb.call();
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _startMonitoring() {
    _timer?.cancel();
    _timer = Timer.periodic(_pollInterval, (_) async {
      await _refresh();
    });
  }

  Future<void> _refresh() async {
    emit(state.copyWith(isChecking: true));
    final PermissionStatus status = await _permission.status;
    final bool isServiceEnabled = await _checkServiceEnabled();
    emit(
      state.copyWith(
        status: status,
        isServiceEnabled: isServiceEnabled,
        isChecking: false,
      ),
    );
  }

  Future<bool> _checkServiceEnabled() async {
    if (_isServiceEnabledCb == null) {
      return true;
    }
    return await _isServiceEnabledCb.call();
  }
}
