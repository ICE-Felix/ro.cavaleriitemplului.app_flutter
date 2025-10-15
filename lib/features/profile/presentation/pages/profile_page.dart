import 'package:app/core/widgets/custom_top_bar/custom_top_bar.dart';
import 'package:app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:app/features/profile/presentation/widgets/profile_header.dart';
import 'package:app/features/profile/presentation/widgets/profile_settings_section.dart';
import 'package:app/features/profile/presentation/widgets/profile_account_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Constants
  static const double _sectionSpacing = 32.0;
  static const double _itemSpacing = 24.0;
  static const double _bottomSpacing = 40.0;
  static const double _logoHeight = 90.0;
  static const double _logoWidth = 140.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..initialize(),
      child: Scaffold(
        appBar: CustomTopBar.withCart(
          context: context,
          showLogo: true,
          showNotificationButton: true,
          logoHeight: _logoHeight,
          logoWidth: _logoWidth,
          logoPadding: const EdgeInsets.only(
            left: 20.0,
            top: 10.0,
            bottom: 10.0,
          ),
          onNotificationTap: _handleNotificationTap,
          onLogoTap: _handleLogoTap,
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.error}'),
                    ElevatedButton(
                      onPressed:
                          () => context.read<ProfileCubit>().initialize(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: _sectionSpacing),
                  const ProfileSettingsSection(),
                  const SizedBox(height: _itemSpacing),
                  const ProfileAccountSection(),
                  const SizedBox(height: _bottomSpacing),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Handles notification tap
  void _handleNotificationTap() {
    // TODO: Implement notification handling
  }

  /// Handles logo tap
  void _handleLogoTap() {
    // TODO: Implement logo tap handling
  }
}
