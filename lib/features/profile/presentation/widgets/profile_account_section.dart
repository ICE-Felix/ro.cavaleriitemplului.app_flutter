import 'package:app/features/profile/presentation/widgets/logout_confirmation_dialog/logout_confirmation_dialog.dart';
import 'package:app/core/localization/localization_inherited_widget.dart';
import 'package:app/core/navigation/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:app/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:app/features/auth/presentation/bloc/authentication_bloc.dart';

class ProfileAccountSection extends StatelessWidget {
  const ProfileAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: context.getString(label: 'profile.account'),
      items: [
        ProfileMenuItem(
          icon: FontAwesomeIcons.shoppingBag,
          title: context.getString(label: 'profile.orders'),
          subtitle: context.getString(label: 'profile.viewOrders'),
          onTap: () => context.pushNamed(AppRoutesNames.orderHistory.name),
        ),
        ProfileMenuItem(
          icon: FontAwesomeIcons.rightFromBracket,
          title: context.getString(label: 'profile.logout'),
          subtitle: context.getString(label: 'profile.signOut'),
          isDestructive: true,
          onTap: () => _showLogoutDialog(context),
        ),
        ProfileMenuItem(
          icon: FontAwesomeIcons.trash,
          title: context.getString(label: 'profile.deleteAccount'),
          subtitle: context.getString(label: 'profile.deleteAccountSubtitle'),
          isDestructive: true,
          onTap: () => _showDeleteAccountDialog(context),
        ),
      ],
    );
  }

  void _showComingSoonMessage(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - ${context.getString(label: 'comingSoon')}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final authBloc = context.read<AuthenticationBloc>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          title: Row(
            children: [
              Icon(FontAwesomeIcons.triangleExclamation,
                  color: Colors.red, size: 24),
              const SizedBox(width: 12),
              Text(context.getString(label: 'profile.deleteAccountTitle')),
            ],
          ),
          content: Text(
            context.getString(label: 'profile.deleteAccountWarning'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                context.getString(label: 'profile.deleteAccountCancel'),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                authBloc.add(DeleteAccountRequested());
                // Navigate to intro after deletion
                while (context.canPop()) {
                  context.pop();
                }
                context.pushReplacementNamed(AppRoutesNames.intro.name);
              },
              child: Text(
                context.getString(label: 'profile.deleteAccountConfirm'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final authBloc = context.read<AuthenticationBloc>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return LogoutConfirmationDialog(
          onLogout: () {
            authBloc.add(LogoutRequested());
            // Navigate to intro/login after logout
            while (context.canPop()) {
              context.pop();
            }
            context.pushReplacementNamed(AppRoutesNames.intro.name);
          },
        );
      },
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.items});

  final String title;
  final List<ProfileMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleMedium?.color,
              letterSpacing: 0.5,
            ),
          ),
        ),
        // Section Items
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children:
                items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == items.length - 1;

                  return Column(
                    children: [
                      item,
                      if (!isLast)
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Theme.of(
                            context,
                          ).dividerColor.withOpacity(0.3),
                          indent: 16,
                          endIndent: 16,
                        ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
