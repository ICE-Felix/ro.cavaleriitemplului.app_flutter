import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../app_localization.dart';

class LanguageSwitcherWidget extends StatelessWidget {
  final bool isCompact;
  final Color? iconColor;
  final Color? textColor;

  const LanguageSwitcherWidget({
    super.key,
    this.isCompact = false,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        String currentLocale = context.localization.currentLocale;

        return PopupMenuButton<String>(
          icon: Icon(
            FontAwesomeIcons.globe,
            color: iconColor ?? Theme.of(context).iconTheme.color,
            size: isCompact ? 16 : 20,
          ),
          tooltip: context.getString(label: 'changeLanguage'),
          onSelected: (String locale) {
            context.localization.changeLocale(locale);
          },
          itemBuilder:
              (BuildContext context) => [
                PopupMenuItem<String>(
                  value: 'ro',
                  child: Row(
                    children: [
                      const Text('🇷🇴'),
                      const SizedBox(width: 8),
                      Text(
                        'Română',
                        style: TextStyle(
                          color:
                              textColor ??
                              Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight:
                              currentLocale == 'ro'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                      if (currentLocale == 'ro') ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.check,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'en',
                  child: Row(
                    children: [
                      const Text('🇺🇸'),
                      const SizedBox(width: 8),
                      Text(
                        'English',
                        style: TextStyle(
                          color:
                              textColor ??
                              Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight:
                              currentLocale == 'en'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        ),
                      ),
                      if (currentLocale == 'en') ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.check,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
        );
      },
    );
  }
}

class LanguageSwitcherButton extends StatelessWidget {
  final bool showLabel;
  final Color? iconColor;
  final Color? textColor;

  const LanguageSwitcherButton({
    super.key,
    this.showLabel = true,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        String currentLocale = context.localization.currentLocale;

        return InkWell(
          onTap: () {
            // Toggle between languages
            final newLocale = currentLocale == 'ro' ? 'en' : 'ro';
            context.localization.changeLocale(newLocale);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentLocale == 'ro' ? '🇷🇴' : '🇺🇸',
                  style: const TextStyle(fontSize: 16),
                ),
                if (showLabel) ...[
                  const SizedBox(width: 8),
                  Text(
                    currentLocale == 'ro' ? 'RO' : 'EN',
                    style: TextStyle(
                      color:
                          textColor ??
                          Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: iconColor ?? Theme.of(context).iconTheme.color,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
