import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/news_entity.dart';

class NewsCardWidget extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback? onTap;

  const NewsCardWidget({super.key, required this.news, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card.filled(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with category and date
              Row(
                children: [
                  Badge(
                    label: Text(news.category),
                    backgroundColor: colorScheme.primaryContainer,
                    textColor: colorScheme.onPrimaryContainer,
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(news.publishedAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Image
              if (news.imageUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      news.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF4A148C), // Dark purple
                                const Color(
                                  0xFF6A1B9A,
                                ), // Slightly lighter purple
                              ],
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/logo/logo.png',
                              height: 40,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback if logo asset fails to load
                                return Text(
                                  'MOMMY HAI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Title
              Text(
                news.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Summary
              Text(
                news.summary,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Footer
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: colorScheme.primaryContainer,
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      size: 10,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      news.author,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FaIcon(
                    FontAwesomeIcons.eye,
                    size: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatViews(news.views),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return DateFormat('dd MMM').format(date);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
