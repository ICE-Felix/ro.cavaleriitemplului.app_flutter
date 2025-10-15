import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/profile/presentation/cubit/profile_cubit.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  static const double _headerPadding = 24.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(_headerPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const _UserAvatar(),
          const SizedBox(height: 16),
          const _UserEmail(),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  static const double _avatarRadius = 35.0;
  static const double _avatarBorderWidth = 3.0;
  static const double _iconSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'User profile avatar',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: _avatarBorderWidth,
          ),
        ),
        child: CircleAvatar(
          radius: _avatarRadius,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person_rounded,
            size: _iconSize,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class _UserEmail extends StatelessWidget {
  const _UserEmail();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Semantics(
          label: 'User email address',
          value:
              state.userEmail.isNotEmpty
                  ? state.userEmail
                  : 'No email available',
          child: Text(
            state.userEmail,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
