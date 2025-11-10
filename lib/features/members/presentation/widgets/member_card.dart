import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/style/app_colors.dart';
import '../../data/models/member_model.dart';

class MemberCard extends StatelessWidget {
  final MemberModel member;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const MemberCard({
    super.key,
    required this.member,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: member.isImportant ? AppColors.primary : AppColors.border,
              width: member.isImportant ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      image: member.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(member.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: member.imageUrl == null
                        ? Center(
                            child: Text(
                              member.name.isNotEmpty
                                  ? member.name[0].toUpperCase()
                                  : '?',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Member Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                member.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                              ),
                            ),
                            Row(
                              children: [
                                if (member.isImportant)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: FaIcon(
                                      FontAwesomeIcons.star,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (member.isImportant)
                                  const SizedBox(width: 8),
                                InkWell(
                                  onTap: onFavoriteTap,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    child: FaIcon(
                                      isFavorite
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      size: 18,
                                      color: isFavorite
                                          ? AppColors.error
                                          : AppColors.onBackground
                                              .withValues(alpha: 0.4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (member.title != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            member.title!,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ],
                        if (member.position != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            member.position!,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.onBackground
                                          .withValues(alpha: 0.7),
                                    ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (member.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  member.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onBackground.withValues(alpha: 0.7),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (member.phoneNumber != null || member.email != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (member.phoneNumber != null) ...[
                      Expanded(
                        child: _ContactButton(
                          icon: FontAwesomeIcons.phone,
                          label: 'Call',
                          onTap: () => _makePhoneCall(member.phoneNumber!),
                        ),
                      ),
                      if (member.email != null) const SizedBox(width: 8),
                    ],
                    if (member.email != null)
                      Expanded(
                        child: _ContactButton(
                          icon: FontAwesomeIcons.envelope,
                          label: 'Email',
                          onTap: () => _sendEmail(member.email!),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 14,
              color: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
