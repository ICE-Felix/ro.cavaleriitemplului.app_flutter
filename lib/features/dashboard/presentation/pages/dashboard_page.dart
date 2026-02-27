import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_top_bar/custom_top_bar.dart';
import '../../../../core/style/app_colors.dart';
import '../cubit/dashboard_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit()..loadDashboard(),
      child: const _DashboardView(),
    );
  }
}

/// Maps icon string names from Supabase to FontAwesome IconData.
IconData _mapIcon(String name) {
  const icons = <String, IconData>{
    'bookOpen': FontAwesomeIcons.bookOpen,
    'newspaper': FontAwesomeIcons.newspaper,
    'calendarDays': FontAwesomeIcons.calendarDays,
    'bullhorn': FontAwesomeIcons.bullhorn,
    'users': FontAwesomeIcons.users,
    'book': FontAwesomeIcons.book,
    'store': FontAwesomeIcons.store,
    'headset': FontAwesomeIcons.headset,
  };
  return icons[name] ?? FontAwesomeIcons.circleQuestion;
}

/// Maps color string names from Supabase to AppColors.
Color _mapColor(String name) {
  const colors = <String, Color>{
    'primary': AppColors.primary,
    'secondary': AppColors.secondary,
    'info': AppColors.info,
    'warning': AppColors.warning,
    'success': AppColors.success,
    'error': AppColors.error,
  };
  return colors[name] ?? AppColors.primary;
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomTopBar.withCart(
            context: context,
            showLogo: true,
            logoHeight: 200,
            logoWidth: 0,
            centerTitle: false,
            showNotificationButton: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome greeting
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    state.setting('greeting_line1', 'Bine ai revenit,'),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    state.userName.isNotEmpty
                        ? state.userName
                        : state.setting('greeting_fallback_name', 'Frate'),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: AppColors.onBackground),
                  ),
                ),
                const SizedBox(height: 24),

                // Large dashboard cards (from Supabase)
                ...state.largeCards.map((card) {
                  String description;
                  String? subtitle;
                  String? subtitleInfo;

                  if (card.dynamicSource == 'events') {
                    final label = state.nextEventLabel.isNotEmpty ? state.nextEventLabel : null;
                    description = state.nextEventTitle.isNotEmpty
                        ? (label != null ? '$label: ${state.nextEventTitle}' : state.nextEventTitle)
                        : (card.dynamicFallback ?? card.description ?? '');
                    subtitle = state.nextEventDate.isNotEmpty ? state.nextEventDate : null;
                    subtitleInfo = state.nextEventTime.isNotEmpty ? state.nextEventTime : null;
                  } else if (card.dynamicSource == 'news') {
                    description = state.latestNewsTitle.isNotEmpty
                        ? state.latestNewsTitle
                        : (card.dynamicFallback ?? card.description ?? '');
                    subtitle = state.latestNewsTime.isNotEmpty ? state.latestNewsTime : null;
                    subtitleInfo = null;
                  } else {
                    description = card.description ?? '';
                    subtitle = null;
                    subtitleInfo = null;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _DashboardCard(
                      title: card.title,
                      description: description,
                      icon: _mapIcon(card.icon),
                      iconColor: _mapColor(card.iconColor),
                      badge: card.badge,
                      subtitle: subtitle,
                      subtitleInfo: subtitleInfo,
                      ctaText: state.setting('see_details_text', 'Vezi detalii'),
                      onTap: () {
                        if (card.dynamicSource == 'news' && state.latestNewsId.isNotEmpty) {
                          context.go('/news/news_details/${state.latestNewsId}');
                        } else {
                          context.go(card.route);
                        }
                      },
                    ),
                  );
                }),

                // Small quick-link cards (from Supabase, in rows of 2)
                ..._buildSmallCardRows(context, state),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSmallCardRows(BuildContext context, DashboardState state) {
    final cards = state.smallCards;
    final rows = <Widget>[];

    for (var i = 0; i < cards.length; i += 2) {
      final first = cards[i];
      final second = (i + 1 < cards.length) ? cards[i + 1] : null;

      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Expanded(
                child: _DashboardSmallCard(
                  title: first.title,
                  icon: _mapIcon(first.icon),
                  iconColor: _mapColor(first.iconColor),
                  onTap: () => context.go(first.route),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: second != null
                    ? _DashboardSmallCard(
                        title: second.title,
                        icon: _mapIcon(second.icon),
                        iconColor: _mapColor(second.iconColor),
                        onTap: () => context.go(second.route),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }

    return rows;
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final String? badge;
  final String? subtitle;
  final String? subtitleInfo;
  final String ctaText;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.badge,
    this.subtitle,
    this.subtitleInfo,
    this.ctaText = 'Vezi detalii',
    required this.onTap,
  });

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
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: FaIcon(icon, size: 24, color: iconColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onBackground.withValues(alpha: 0.7),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subtitle!,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(
                          color: iconColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (subtitleInfo != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        subtitleInfo!,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(
                          color: AppColors.onBackground.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    ctaText,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  FaIcon(
                    FontAwesomeIcons.arrowRight,
                    size: 14,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardSmallCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _DashboardSmallCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

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
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: FaIcon(icon, size: 28, color: iconColor)),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
