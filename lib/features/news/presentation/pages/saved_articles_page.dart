import 'package:app/core/navigation/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/service_locator.dart';
import '../../../../core/widgets/custom_top_bar.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../../core/localization/app_localization.dart';
import '../../domain/entities/bookmark_entity.dart';
import '../../domain/repositories/bookmark_repository.dart';
import 'news_detail_page.dart';
import '../../domain/entities/news_entity.dart';

class SavedArticlesPage extends StatefulWidget {
  const SavedArticlesPage({super.key});

  @override
  State<SavedArticlesPage> createState() => _SavedArticlesPageState();
}

class _SavedArticlesPageState extends State<SavedArticlesPage> {
  List<BookmarkEntity> _savedArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedArticles();
  }

  Future<void> _loadSavedArticles() async {
    try {
      final bookmarkRepository = sl<BookmarkRepository>();
      final bookmarks = await bookmarkRepository.getAllBookmarks();
      setState(() {
        _savedArticles = bookmarks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshSavedArticles() async {
    setState(() {
      _isLoading = true;
    });
    await _loadSavedArticles();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(context.getString(label: 'savedArticles')),
        backgroundColor: colorScheme.surface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: LanguageSwitcherWidget(isCompact: true),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSavedArticles,
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _savedArticles.isEmpty
                ? _buildEmptyState(context)
                : _buildSavedArticlesList(context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50),
              ),
              child: FaIcon(
                FontAwesomeIcons.bookmark,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Niciun articol salvat',
              style: AppTextStyles.headlineSmall.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Salvează articolele tale preferate pentru a le putea citi mai târziu.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 16),
              label: const Text('Înapoi la articole'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedArticlesList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _savedArticles.length,
      itemBuilder: (context, index) {
        final bookmark = _savedArticles[index];
        return _buildSavedArticleItem(context, bookmark);
      },
    );
  }

  Widget _buildSavedArticleItem(BuildContext context, BookmarkEntity bookmark) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _openArticle(bookmark),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient:
                      bookmark.imageUrl.isNotEmpty
                          ? null
                          : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF4A148C), // Dark purple
                              Color(0xFF6A1B9A), // Slightly lighter purple
                            ],
                          ),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child:
                    bookmark.imageUrl.isNotEmpty
                        ? Image.network(
                          bookmark.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                        )
                        : _buildImagePlaceholder(),
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      bookmark.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Source and Category
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bookmark.source,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (bookmark.category.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              bookmark.category,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Footer with saved date
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidBookmark,
                          size: 12,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Salvat ${_formatDate(bookmark.bookmarkedAt)}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Image.asset(
        'assets/images/logo/logo.png',
        height: 24,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Text(
            context.getString(label: 'appName'),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 8,
            ),
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }

  void _openArticle(BookmarkEntity bookmark) {
    // Convert BookmarkEntity to NewsEntity for the detail page

    context.pushNamed(
      AppRoutesNames.newsDetails.name,
      pathParameters: {'id': bookmark.newsId},
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return context.getString(
        label: 'timeAgo.daysAgo',
        namedParameters: {
          'days': difference.inDays,
          'dayUnit': context.getString(
            label: 'timeAgo.dayUnit',
            variable: difference.inDays,
          ),
        },
      );
    } else if (difference.inHours > 0) {
      return context.getString(
        label: 'timeAgo.hoursAgo',
        namedParameters: {'hours': difference.inHours},
      );
    } else if (difference.inMinutes > 0) {
      return context.getString(
        label: 'timeAgo.minutesAgo',
        namedParameters: {'minutes': difference.inMinutes},
      );
    } else {
      return context.getString(label: 'timeAgo.now');
    }
  }
}
