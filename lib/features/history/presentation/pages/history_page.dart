import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/widgets/custom_top_bar/custom_top_bar.dart';
import '../../../../core/style/app_colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomTopBar.withCart(
        context: context,
        showLogo: true,
        logoHeight: 90,
        logoWidth: 140,
        logoPadding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
        showNotificationButton: true,
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with image placeholder
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.bookOpen,
                    size: 64,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Scurt Istoric',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'Descoperă istoria și valorile Ordinului',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Content sections
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction
                  _buildSectionCard(
                    context,
                    icon: FontAwesomeIcons.scroll,
                    iconColor: AppColors.primary,
                    title: 'Originile',
                    content:
                        'Ordinul Cavalerilor Templului reprezintă o tradiție milenară de devotament, onoare și serviciu. Fondat în perioada medievală, Ordinul a fost recunoscut pentru devotamentul său față de valorile creștine și pentru protecția pelerinilor.',
                  ),
                  const SizedBox(height: 20),

                  // Values
                  _buildSectionCard(
                    context,
                    icon: FontAwesomeIcons.shield,
                    iconColor: AppColors.secondary,
                    title: 'Valorile Noastre',
                    content:
                        'Onoarea, loialitatea, curajul și credința au fost întotdeauna stâlpii pe care s-a construit Ordinul. Aceste valori ne ghidează și astăzi în misiunea noastră de a servi comunitatea și de a păstra tradițiile.',
                  ),
                  const SizedBox(height: 20),

                  // Mission
                  _buildSectionCard(
                    context,
                    icon: FontAwesomeIcons.handshake,
                    iconColor: AppColors.info,
                    title: 'Misiunea Modernă',
                    content:
                        'În epoca modernă, Ordinul continuă să promoveze valorile tradiționale adaptate la contextul contemporan. Ne dedicăm activităților caritabile, educației și păstrării patrimoniului cultural și spiritual.',
                  ),
                  const SizedBox(height: 20),

                  // Timeline section
                  _buildTimelineSection(context),
                  const SizedBox(height: 20),

                  // Key principles
                  _buildPrinciplesSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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
                  child: FaIcon(
                    icon,
                    size: 24,
                    color: iconColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.onBackground,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.clockRotateLeft,
                size: 24,
                color: AppColors.warning,
              ),
              const SizedBox(width: 12),
              Text(
                'Cronologie Importantă',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTimelineItem(
            context,
            year: '1118',
            event: 'Fondarea Ordinului în Ierusalim',
          ),
          _buildTimelineItem(
            context,
            year: '1129',
            event: 'Recunoașterea oficială de către Biserica Catolică',
          ),
          _buildTimelineItem(
            context,
            year: 'Sec. XII-XIII',
            event: 'Perioada de glorie și expansiune',
          ),
          _buildTimelineItem(
            context,
            year: 'Modern',
            event: 'Reînvierea tradițiilor și valorilor',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required String year,
    required String event,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: AppColors.border,
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  year,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  event,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onBackground,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrinciplesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.star,
                size: 24,
                color: AppColors.success,
              ),
              const SizedBox(width: 12),
              Text(
                'Principii Fundamentale',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildPrincipleItem(
            context,
            icon: FontAwesomeIcons.cross,
            title: 'Credința',
            description: 'Devotament față de valorile spirituale',
          ),
          _buildPrincipleItem(
            context,
            icon: FontAwesomeIcons.heart,
            title: 'Caritatea',
            description: 'Serviciu pentru comunitate și cei în nevoie',
          ),
          _buildPrincipleItem(
            context,
            icon: FontAwesomeIcons.users,
            title: 'Frăția',
            description: 'Unitate și sprijin reciproc între membri',
          ),
          _buildPrincipleItem(
            context,
            icon: FontAwesomeIcons.crown,
            title: 'Onoarea',
            description: 'Integritate și conduită nobilă',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPrincipleItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: FaIcon(
                icon,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onBackground.withValues(alpha: 0.8),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
