import 'package:flutter/material.dart';

import '../../../../core/localization/app_localization.dart';
import '../../domain/entities/news_entity.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback? onTap;

  const NewsItemWidget({super.key, required this.news, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF4A148C), // Dark purple
                      const Color(0xFF6A1B9A), // Slightly lighter purple
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child:
                    news.imageUrl.isNotEmpty
                        ? Image.network(
                          news.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
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
                          },
                        )
                        : Center(
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
                        ),
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      news.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Source
                    Text(
                      news.source,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Footer with date and views
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _formatDate(context, news.publishedAt),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Text(
                          ' • ',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),

                        Expanded(
                          child: Text(
                            '${_formatViews(news.views)} ${context.getString(label: 'clicks')}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
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

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }

  String _formatDate(BuildContext context, DateTime date) {
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
