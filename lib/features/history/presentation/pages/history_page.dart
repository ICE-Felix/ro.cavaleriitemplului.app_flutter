import 'package:app/core/network/supabase_client.dart';
import 'package:app/core/services/app_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_flutter;
import '../../../../core/widgets/custom_top_bar/custom_top_bar.dart';
import '../../../../core/style/app_colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _sections = [];
  List<Map<String, dynamic>> _timeline = [];
  List<Map<String, dynamic>> _principles = [];
  bool _isLoading = true;

  supabase_flutter.SupabaseClient get _client => SupabaseClient().client;
  final _settings = AppSettingsService.instance;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _client
          .from('history_sections')
          .select()
          .order('sort_order', ascending: true);

      if (!mounted) return;

      final list = data as List;
      setState(() {
        _sections = list
            .where((e) => e['section_type'] == 'section')
            .cast<Map<String, dynamic>>()
            .toList();
        _timeline = list
            .where((e) => e['section_type'] == 'timeline')
            .cast<Map<String, dynamic>>()
            .toList();
        _principles = list
            .where((e) => e['section_type'] == 'principle')
            .cast<Map<String, dynamic>>()
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  static const _iconMap = <String, IconData>{
    'scroll': FontAwesomeIcons.scroll,
    'shield': FontAwesomeIcons.shield,
    'handshake': FontAwesomeIcons.handshake,
    'cross': FontAwesomeIcons.cross,
    'heart': FontAwesomeIcons.heart,
    'users': FontAwesomeIcons.users,
    'crown': FontAwesomeIcons.crown,
    'star': FontAwesomeIcons.star,
    'book': FontAwesomeIcons.book,
    'bookOpen': FontAwesomeIcons.bookOpen,
  };

  static const _colorMap = <String, Color>{
    'primary': AppColors.primary,
    'secondary': AppColors.secondary,
    'info': AppColors.info,
    'warning': AppColors.warning,
    'success': AppColors.success,
  };

  IconData _getIcon(String name) => _iconMap[name] ?? FontAwesomeIcons.circle;
  Color _getColor(String name) => _colorMap[name] ?? AppColors.primary;

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
        showNotificationButton: true,
        onNotificationTap: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
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
                    _settings.get('history_hero_title', 'Scurt Istoric'),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      _settings.get('history_hero_subtitle',
                          'Descoperă istoria și valorile Ordinului'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section cards
                    for (int i = 0; i < _sections.length; i++) ...[
                      _buildSectionCard(
                        context,
                        icon: _getIcon(_sections[i]['icon'] ?? ''),
                        iconColor: _getColor(_sections[i]['icon_color'] ?? ''),
                        title: _sections[i]['title'] ?? '',
                        content: _sections[i]['content'] ?? '',
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Timeline
                    if (_timeline.isNotEmpty) ...[
                      _buildTimelineSection(context),
                      const SizedBox(height: 20),
                    ],

                    // Principles
                    if (_principles.isNotEmpty) _buildPrinciplesSection(context),
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
        border: Border.all(color: AppColors.border, width: 1),
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
                child: Center(child: FaIcon(icon, size: 24, color: iconColor)),
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
        border: Border.all(color: AppColors.border, width: 1),
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
              FaIcon(FontAwesomeIcons.clockRotateLeft,
                  size: 24, color: AppColors.warning),
              const SizedBox(width: 12),
              Text(
                _settings.get(
                    'history_timeline_title', 'Cronologie Importantă'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < _timeline.length; i++)
            _buildTimelineItem(
              context,
              year: _timeline[i]['year'] ?? '',
              event: _timeline[i]['title'] ?? '',
              isLast: i == _timeline.length - 1,
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
                Container(width: 2, height: 40, color: AppColors.border),
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
        border: Border.all(color: AppColors.border, width: 1),
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
              FaIcon(FontAwesomeIcons.star,
                  size: 24, color: AppColors.success),
              const SizedBox(width: 12),
              Text(
                _settings.get(
                    'history_principles_title', 'Principii Fundamentale'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < _principles.length; i++)
            _buildPrincipleItem(
              context,
              icon: _getIcon(_principles[i]['icon'] ?? ''),
              title: _principles[i]['title'] ?? '',
              description: _principles[i]['content'] ?? '',
              isLast: i == _principles.length - 1,
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
              child: FaIcon(icon, size: 18, color: AppColors.primary),
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
