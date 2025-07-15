import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/service_locator.dart';
import '../../../../core/widgets/custom_top_bar.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/localization/app_localization.dart';
import '../../domain/entities/news_entity.dart';
import '../../domain/usecases/toggle_bookmark_usecase.dart';
import '../../domain/usecases/check_bookmark_usecase.dart';

class NewsDetailPage extends StatefulWidget {
  final NewsEntity news;

  const NewsDetailPage({super.key, required this.news});

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  bool _isBookmarked = false;
  bool _isCheckingBookmark = true;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    try {
      final checkBookmarkUseCase = sl<CheckBookmarkUseCase>();
      final isBookmarked = await checkBookmarkUseCase(widget.news.id);
      setState(() {
        _isBookmarked = isBookmarked;
        _isCheckingBookmark = false;
      });
    } catch (e) {
      setState(() {
        _isCheckingBookmark = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 0,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withOpacity(0.8),
                  ),
                  child: LogoTopBar(
                    isTransparent: true,
                    hasBlur: false, // Blur handled here
                    elevation: 0,
                    onBackPressed: () => Navigator.of(context).pop(),
                    onSharePressed: () => _shareArticle(),
                    showShareButton: true,
                    logoHeight: 40,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Hero Image
                _buildHeroImage(context),
                // Content
                _buildContent(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(color: colorScheme.surfaceVariant),
      child:
          widget.news.imageUrl.isNotEmpty
              ? Image.network(
                widget.news.imageUrl,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder(context);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildImagePlaceholder(context);
                },
              )
              : _buildImagePlaceholder(context),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF4A148C), // Dark purple
            const Color(0xFF6A1B9A), // Slightly lighter purple
          ],
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo/logo.png',
          height: 80,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if logo asset fails to load
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                context.getString(label: 'appName'),
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Category Tag
          if (widget.news.category.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                widget.news.category.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.news.title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Article Meta
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Author
                if (widget.news.author.isNotEmpty) ...[
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: colorScheme.primaryContainer,
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      size: 12,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.news.author,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Date
                FaIcon(
                  FontAwesomeIcons.clock,
                  size: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 3,
                  child: Text(
                    DateFormat('dd MMM yyyy').format(widget.news.publishedAt),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(width: 8),

                // Views
                FaIcon(
                  FontAwesomeIcons.eye,
                  size: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatViews(widget.news.views),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: colorScheme.outlineVariant, thickness: 1),
          ),

          const SizedBox(height: 24),

          // Article Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.news.content,
              style: AppTextStyles.bodyLarge.copyWith(
                color: colorScheme.onSurface,
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Tags
          if (widget.news.tags.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Tags',
                style: AppTextStyles.titleSmall.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    widget.news.tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              tag,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 32),
          ],

          // Source
          if (widget.news.source.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.globe,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.getString(label: 'source'),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      widget.news.source,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _shareArticle(),
                    icon: const FaIcon(FontAwesomeIcons.share, size: 16),
                    label: const Text('Share Article'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _isCheckingBookmark ? null : () => _bookmarkArticle(),
                    icon:
                        _isCheckingBookmark
                            ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            )
                            : FaIcon(
                              _isBookmarked
                                  ? FontAwesomeIcons.solidBookmark
                                  : FontAwesomeIcons.bookmark,
                              size: 16,
                              color: Colors.white,
                            ),
                    label: Text(
                      _isBookmarked ? 'Salvat' : 'Salvează',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor:
                          _isBookmarked
                              ? const Color(0xFF4A148C) // Dark purple for saved
                              : Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: _isBookmarked ? 2 : 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }

  void _shareArticle() {
    // Implement share functionality
    HapticFeedback.lightImpact();

    final shareText = '''
${widget.news.title}

${widget.news.summary}

Intră pe Mommy Hai ca să citești acest articol!

#MommyHai #Parenting #Copii
''';

    Share.share(shareText, subject: widget.news.title);
  }

  Future<void> _bookmarkArticle() async {
    // Implement bookmark functionality
    HapticFeedback.lightImpact();

    try {
      final toggleBookmarkUseCase = sl<ToggleBookmarkUseCase>();
      final params = ToggleBookmarkParams(
        newsId: widget.news.id,
        title: widget.news.title,
        summary: widget.news.summary,
        imageUrl: widget.news.imageUrl,
        author: widget.news.author,
        category: widget.news.category,
        source: widget.news.source,
      );

      final isNowBookmarked = await toggleBookmarkUseCase(params);

      setState(() {
        _isBookmarked = isNowBookmarked;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNowBookmarked
                ? context.getString(
                  label: 'articleBookmarked',
                  namedParameters: {'title': widget.news.title},
                )
                : context.getString(
                  label: 'articleUnbookmarked',
                  namedParameters: {'title': widget.news.title},
                ),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Eroare: ${e.toString()}'),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
