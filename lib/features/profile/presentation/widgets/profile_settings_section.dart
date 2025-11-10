import 'package:app/features/profile/presentation/widgets/language_selection_dialog/language_selection_dialog.dart';
import 'package:app/core/localization/localization_inherited_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app/features/profile/presentation/widgets/profile_menu_item.dart';

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileSection(
      title: context.getString(label: 'profile.settings'),
      items: [
        ProfileMenuItem(
          icon: FontAwesomeIcons.language,
          title: context.getString(label: 'profile.language'),
          subtitle: context.getString(label: 'profile.changeLanguage'),
          onTap: () => _showLanguageDialog(context),
        ),
        ProfileMenuItem(
          icon: FontAwesomeIcons.bell,
          title: context.getString(label: 'profile.notifications'),
          subtitle: context.getString(label: 'profile.manageNotifications'),
          onTap: () => _showComingSoonMessage(
            context,
            context.getString(label: 'profile.notifications'),
          ),
        ),
        ProfileMenuItem(
          icon: FontAwesomeIcons.locationDot,
          title: context.getString(label: 'profile.location'),
          subtitle: context.getString(label: 'profile.locationSettings'),
          onTap: () => _showComingSoonMessage(
            context,
            context.getString(label: 'profile.location'),
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const LanguageSelectionDialog();
      },
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
