part of 'permission_cubit.dart';

class PermissionState extends Equatable {
  const PermissionState({
    this.status = PermissionStatus.denied,
    this.isServiceEnabled = true,
    this.isChecking = true,
  });

  final PermissionStatus status;
  final bool isServiceEnabled;
  final bool isChecking;

  PermissionState copyWith({
    PermissionStatus? status,
    bool? isServiceEnabled,
    bool? isChecking,
  }) {
    return PermissionState(
      status: status ?? this.status,
      isServiceEnabled: isServiceEnabled ?? this.isServiceEnabled,
      isChecking: isChecking ?? this.isChecking,
    );
  }

  @override
  List<Object?> get props => [status, isServiceEnabled, isChecking];
}
