import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/style/app_colors.dart';
import '../members/data/models/member_model.dart';
import 'birthday_popup_service.dart';

class BirthdayPopupDialog extends StatefulWidget {
  final List<MemberModel> birthdayMembers;
  final BirthdayPopupService birthdayService;

  const BirthdayPopupDialog({
    super.key,
    required this.birthdayMembers,
    required this.birthdayService,
  });

  static Future<void> show(
    BuildContext context, {
    required List<MemberModel> members,
    required BirthdayPopupService service,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BirthdayPopupDialog(
        birthdayMembers: members,
        birthdayService: service,
      ),
    );
  }

  @override
  State<BirthdayPopupDialog> createState() => _BirthdayPopupDialogState();
}

class _BirthdayPopupDialogState extends State<BirthdayPopupDialog> {
  bool _dontShowAgainToday = false;

  void _dismiss() {
    if (_dontShowAgainToday) {
      widget.birthdayService.dismissForToday();
    }
    Navigator.of(context).pop();
  }

  Future<void> _sendWhatsApp() async {
    final names = widget.birthdayMembers.map((m) => m.name).join(', ');
    final message = 'La Multi Ani, $names! 🎂🥂';
    final uri = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(message)}',
    );

    if (_dontShowAgainToday) {
      widget.birthdayService.dismissForToday();
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🎂', style: TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              'La Multi Ani!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Astazi este ziua de nastere:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onBackground.withValues(alpha: 0.7),
                  ),
            ),
            const SizedBox(height: 16),

            // Birthday members list
            ...widget.birthdayMembers.map(
              (member) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      backgroundImage: member.imageUrl != null
                          ? NetworkImage(member.imageUrl!)
                          : null,
                      child: member.imageUrl == null
                          ? Text(
                              member.name.isNotEmpty
                                  ? member.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (member.title != null)
                            Text(
                              member.title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.onBackground
                                        .withValues(alpha: 0.6),
                                  ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Checkbox
            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _dontShowAgainToday,
                    onChanged: (v) =>
                        setState(() => _dontShowAgainToday = v ?? false),
                    activeColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(
                      () => _dontShowAgainToday = !_dontShowAgainToday),
                  child: Text(
                    'Nu mai afisa astazi',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Primary button - WhatsApp
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sendWhatsApp,
                icon: const Icon(Icons.send, size: 18),
                label: const Text('Ureaza La Multi Ani'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Secondary button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _dismiss,
                icon: Icon(Icons.access_time_rounded, size: 18, color: AppColors.onBackground.withValues(alpha: 0.5)),
                label: Text(
                  'Mai tarziu',
                  style: TextStyle(color: AppColors.onBackground.withValues(alpha: 0.6)),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
