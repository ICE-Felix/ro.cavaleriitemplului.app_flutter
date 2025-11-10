import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_top_bar/custom_top_bar.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/navigation/routes_name.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomTopBar.withCart(
        context: context,
        showLogo: true,
        logoHeight: 200,
        logoWidth: 0,
        centerTitle: false,
        titleWidget: Text(
          'R.L. 126 C.T.',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        showNotificationButton: true,
        onNotificationTap: () {
          // Handle notification tap
        },
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
                'Bine ai revenit,',
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
                'Frate Cavalier',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppColors.onBackground),
              ),
            ),
            const SizedBox(height: 24),

            // Dashboard Cards Grid
            _DashboardCard(
              title: 'Scurt istoric',
              description: 'Descoperă istoria și valorile Ordinului',
              icon: FontAwesomeIcons.bookOpen,
              iconColor: AppColors.primary,
              onTap: () {
                // Navigate to history section
                context.pushNamed(AppRoutesNames.history.name);
              },
            ),
            const SizedBox(height: 16),

            _DashboardCard(
              title: 'Revista',
              description: 'Ultima ediție este disponibilă pentru lectura',
              icon: FontAwesomeIcons.newspaper,
              iconColor: AppColors.secondary,
              badge: 'NOU',
              onTap: () {
                // Navigate to magazine
                context.pushNamed(AppRoutesNames.revistas.name);
              },
            ),
            const SizedBox(height: 16),

            _DashboardCard(
              title: 'Program de activități',
              description: 'Următoarea ședință: 15 septembrie, ora 18:00',
              icon: FontAwesomeIcons.calendarDays,
              iconColor: AppColors.info,
              subtitle: '15 septembrie',
              subtitleInfo: 'ora 18:00',
              onTap: () {
                // Navigate to events
                context.pushNamed(AppRoutesNames.events.name);
              },
            ),
            const SizedBox(height: 16),

            _DashboardCard(
              title: 'Noutăți',
              description: 'Comunicat MLNR',
              icon: FontAwesomeIcons.bullhorn,
              iconColor: AppColors.warning,
              subtitle: 'Postat acum 2 ore',
              onTap: () {
                // Navigate to news
                context.pushNamed(AppRoutesNames.news.name);
              },
            ),
            const SizedBox(height: 12),

            // Additional sections
            Row(
              children: [
                Expanded(
                  child: _DashboardSmallCard(
                    title: 'Membri',
                    icon: FontAwesomeIcons.users,
                    iconColor: AppColors.primary,
                    onTap: () {
                      // Navigate to members
                      context.pushNamed(AppRoutesNames.members.name);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DashboardSmallCard(
                    title: 'Bibliotecă',
                    icon: FontAwesomeIcons.book,
                    iconColor: AppColors.secondary,
                    onTap: () {
                      // Navigate to library (revistas)
                      context.pushNamed(AppRoutesNames.revistas.name);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _DashboardSmallCard(
                    title: 'Magazin',
                    icon: FontAwesomeIcons.store,
                    iconColor: AppColors.info,
                    onTap: () {
                      context.pushNamed(AppRoutesNames.shop.name);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DashboardSmallCard(
                    title: 'Locații',
                    icon: FontAwesomeIcons.mapLocationDot,
                    iconColor: AppColors.success,
                    onTap: () {
                      context.pushNamed(AppRoutesNames.locations.name);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.badge,
    this.subtitle,
    this.subtitleInfo,
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
                    'Vezi detalii',
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
