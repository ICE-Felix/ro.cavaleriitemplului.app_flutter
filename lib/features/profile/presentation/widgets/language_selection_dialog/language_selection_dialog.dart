import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:app/features/profile/presentation/widgets/language_selection_dialog/dialog_header.dart';
import 'package:app/features/profile/presentation/widgets/language_selection_dialog/language_options_widget.dart';
import 'package:app/features/profile/presentation/widgets/language_selection_dialog/dialog_footer.dart';

class LanguageSelectionDialog extends StatelessWidget {
  const LanguageSelectionDialog({super.key});

  static const String _englishLocale = 'en';
  static const String _romanianLocale = 'ro';

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
            LanguageOptionsWidget(
              englishLocale: _englishLocale,
              romanianLocale: _romanianLocale,
            ),
            const SizedBox(height: 24),
            const DialogFooter(),
          ],
        ),
      ),
    );
  }
}
