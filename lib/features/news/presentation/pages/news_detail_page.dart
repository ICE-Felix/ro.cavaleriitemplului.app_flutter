import 'dart:ui';
import 'package:app/features/news/presentation/bloc/news_details_bloc.dart';
import 'package:app/features/news/presentation/widgets/image_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
  final String id;

  const NewsDetailPage({super.key, required this.id});

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
      final isBookmarked = await checkBookmarkUseCase(widget.id);
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

    return BlocProvider(
      create:
          (context) => NewsDetailsBloc()..add(GetNewsDetails(id: widget.id)),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: BlocBuilder<NewsDetailsBloc, NewsDetailsState>(
          builder: (context, state) {
            if (state is NewsDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsDetailsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is NewsDetailsLoaded) {
              return CustomScrollView(
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
                            hasBlur: false,
                            // Blur handled here
                            elevation: 0,
                            onBackPressed: () => context.pop(),
                            onSharePressed: () => _shareArticle(state.news),
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
                        Container(
                          height: 280,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceVariant,
                          ),
                          child:
                              state.news.imageUrl.isNotEmpty
                                  ? Image.network(
                                    state.news.imageUrl,
                                    width: double.infinity,
                                    height: 280,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return ImagePlaceholderWidget();
                                    },
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return ImagePlaceholderWidget();
                                    },
                                  )
                                  : ImagePlaceholderWidget(),
                        ),
                        // Content
                        Container(
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
                              if (state.news.category.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer
                                        .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    state.news.category.toUpperCase(),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 16),

                              // Title
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Text(
                                  state.news.title,
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  children: [
                                    // Author
                                    if (state.news.author.isNotEmpty) ...[
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor:
                                            colorScheme.primaryContainer,
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
                                          state.news.author,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color:
                                                    colorScheme
                                                        .onSurfaceVariant,
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
                                        DateFormat(
                                          'dd MMM yyyy',
                                        ).format(state.news.publishedAt),
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
                                      _formatViews(state.news.views),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Divider(
                                  color: colorScheme.outlineVariant,
                                  thickness: 1,
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Article Content
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Text(
                                  state.news.content,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: colorScheme.onSurface,
                                    height: 1.6,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Tags
                              if (state.news.tags.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        state.news.tags
                                            .map(
                                              (tag) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      colorScheme
                                                          .surfaceVariant,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Text(
                                                  tag,
                                                  style: AppTextStyles
                                                      .labelSmall
                                                      .copyWith(
                                                        color:
                                                            colorScheme
                                                                .onSurfaceVariant,
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
                              if (state.news.source.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surfaceVariant
                                          .withOpacity(0.5),
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
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color:
                                                    colorScheme
                                                        .onSurfaceVariant,
                                              ),
                                        ),
                                        Text(
                                          state.news.source,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed:
                                            () => _shareArticle(state.news),
                                        icon: const FaIcon(
                                          FontAwesomeIcons.share,
                                          size: 16,
                                        ),
                                        label: const Text('Share Article'),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed:
                                            _isCheckingBookmark
                                                ? null
                                                : () => _bookmarkArticle(
                                                  state.news,
                                                ),
                                        icon:
                                            _isCheckingBookmark
                                                ? SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                        ),
                                                  ),
                                                )
                                                : FaIcon(
                                                  _isBookmarked
                                                      ? FontAwesomeIcons
                                                          .solidBookmark
                                                      : FontAwesomeIcons
                                                          .bookmark,
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
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          backgroundColor:
                                              _isBookmarked
                                                  ? const Color(
                                                    0xFF4A148C,
                                                  ) // Dark purple for saved
                                                  : Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
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
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
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

  void _shareArticle(NewsEntity news) {
    // Implement share functionality
    HapticFeedback.lightImpact();

    final shareText = '''
${news.title}

${news.summary}

Intră pe Mommy Hai ca să citești acest articol!

#MommyHai #Parenting #Copii
''';

    Share.share(shareText, subject: news.title);
  }

  Future<void> _bookmarkArticle(NewsEntity news) async {
    // Implement bookmark functionality
    HapticFeedback.lightImpact();

    try {
      final toggleBookmarkUseCase = sl<ToggleBookmarkUseCase>();
      final params = ToggleBookmarkParams(
        newsId: news.id,
        title: news.title,
        summary: news.summary,
        imageUrl: news.imageUrl,
        author: news.author,
        category: news.category,
        source: news.source,
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
                  namedParameters: {'title': news.title},
                )
                : context.getString(
                  label: 'articleUnbookmarked',
                  namedParameters: {'title': news.title},
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
