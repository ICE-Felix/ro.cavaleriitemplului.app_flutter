import 'package:app/core/service_locator.dart';
import 'package:app/features/auth/domain/services/authentication_service.dart';
import 'package:app/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:app/core/localization/cubit/localization_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.isLoading = false,
    this.userEmail = '',
    this.error,
    this.currentLanguage = 'en',
  });

  final bool isLoading;
  final String userEmail;
  final String? error;
  final String currentLanguage;

  ProfileState copyWith({
    bool? isLoading,
    String? userEmail,
    String? error,
    String? currentLanguage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userEmail: userEmail ?? this.userEmail,
      error: error ?? this.error,
      currentLanguage: currentLanguage ?? this.currentLanguage,
    );
  }

  @override
  List<Object?> get props => [isLoading, userEmail, error, currentLanguage];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  /// Initializes the profile data
  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _loadUserEmail();
      await _loadCurrentLanguage();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Loads the user email from authentication service
  Future<void> _loadUserEmail() async {
    try {
      final authService = sl<AuthenticationService>();
      final user = await authService.currentUser;
      emit(state.copyWith(userEmail: user?.email ?? ''));
    } catch (e) {
      emit(state.copyWith(userEmail: ''));
    }
  }

  /// Loads the current language from localization cubit
  Future<void> _loadCurrentLanguage() async {
    try {
      // TODO: Get current language from localization cubit
      emit(state.copyWith(currentLanguage: 'en'));
    } catch (e) {
      emit(state.copyWith(currentLanguage: 'en'));
    }
  }

  /// Changes the app language
  Future<void> changeLanguage(String locale) async {
    try {
      final localizationCubit = sl<LocalizationCubit>();
      await localizationCubit.changeLocale(locale);
      emit(state.copyWith(currentLanguage: locale));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to change language: $e'));
    }
  }

  /// Performs logout
  Future<void> logout() async {
    try {
      final authBloc = sl<AuthenticationBloc>();
      authBloc.add(LogoutRequested());
    } catch (e) {
      emit(state.copyWith(error: 'Logout failed: $e'));
    }
  }

  /// Clears any error state
  void clearError() {
    emit(state.copyWith(error: null));
  }
}
