import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:app/features/profile/presentation/widgets/language_selection_dialog/language_option.dart';
import 'package:app/core/localization/localization_inherited_widget.dart';

class LanguageOptionsWidget extends StatelessWidget {
  const LanguageOptionsWidget({
    super.key,
    required this.englishLocale,
    required this.romanianLocale,
  });

  final String englishLocale;
  final String romanianLocale;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LanguageOption(
          flag: '🇺🇸',
          title: 'English',
          subtitle: 'English',
          isSelected: false,
          onTap: () => _changeLanguage(
            context,
            englishLocale,
            context.getString(label: 'cart.languageChanged'),
          ),
        ),
        const SizedBox(height: 12),
        LanguageOption(
          flag: '🇷🇴',
          title: 'Română',
          subtitle: 'Romanian',
          isSelected: true,
          onTap: () => _changeLanguage(
            context,
            romanianLocale,
            context.getString(label: 'cart.languageChanged'),
          ),
        ),
      ],
    );
  }

  void _changeLanguage(
    BuildContext context,
    String locale,
    String successMessage,
  ) {
    Navigator.of(context).pop();
    context.read<ProfileCubit>().changeLanguage(locale);
    _showSuccessMessage(context, successMessage);
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
