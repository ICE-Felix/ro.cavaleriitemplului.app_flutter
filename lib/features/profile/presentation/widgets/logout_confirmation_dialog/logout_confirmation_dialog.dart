import 'package:flutter/material.dart';
import 'package:app/features/profile/presentation/widgets/logout_confirmation_dialog/dialog_header.dart';
import 'package:app/features/profile/presentation/widgets/logout_confirmation_dialog/warning_section.dart';
import 'package:app/features/profile/presentation/widgets/logout_confirmation_dialog/action_buttons.dart';

class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: Theme.of(context).dialogBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DialogHeader(),
            const SizedBox(height: 24),
            const WarningSection(),
            const SizedBox(height: 24),
            const ActionButtons(),
          ],
        ),
      ),
    );
  }
}
