import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/service_locator.dart';
import '../../../../core/style/app_colors.dart';
import '../../domain/repositories/revista_repository.dart';
import '../bloc/revista_details_bloc.dart';

class RevistaDetailsPage extends StatefulWidget {
  final String revistaId;

  const RevistaDetailsPage({
    super.key,
    required this.revistaId,
  });

  @override
  State<RevistaDetailsPage> createState() => _RevistaDetailsPageState();
}

class _RevistaDetailsPageState extends State<RevistaDetailsPage> {
  bool _isDownloading = false;
  String? _downloadError;

  Future<void> _downloadAndOpenPdf(String storagePath, String title) async {
    if (storagePath.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Documentul nu este disponibil.')),
        );
      }
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadError = null;
    });

    try {
      final repository = sl<RevistaRepository>();
      final sanitizedName = title.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
      final localPath = await repository.downloadPdfFile(storagePath, '$sanitizedName.pdf');

      if (mounted) {
        setState(() => _isDownloading = false);
        // Share/open the downloaded file
        await Share.shareXFiles(
          [XFile(localPath)],
          text: title,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadError = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eroare la descărcare: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => sl<RevistaDetailsBloc>()
        ..add(LoadRevistaDetailsRequested(id: widget.revistaId)),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocBuilder<RevistaDetailsBloc, RevistaDetailsState>(
          builder: (context, state) {
            if (state is RevistaDetailsLoading) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    leading: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 20),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              );
            }

            if (state is RevistaDetailsError) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    leading: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 20),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.triangleExclamation,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(state.message,
                              style: theme.textTheme.bodyMedium,
                              textAlign: TextAlign.center),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<RevistaDetailsBloc>().add(
                                    LoadRevistaDetailsRequested(
                                        id: widget.revistaId),
                                  );
                            },
                            icon: const FaIcon(FontAwesomeIcons.arrowsRotate,
                                size: 16),
                            label: Text(context.getString(label: 'retry')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is RevistaDetailsLoaded) {
              final revista = state.revista;
              final dateFormat = DateFormat('MMMM yyyy');
              final hasPdf = revista.pdfUrl.isNotEmpty;

              return CustomScrollView(
                slivers: [
                  // Hero image app bar
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    leading: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const FaIcon(FontAwesomeIcons.arrowLeft,
                            size: 16, color: Colors.white),
                      ),
                      onPressed: () => context.pop(),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: revista.imageUrl.isNotEmpty
                          ? Image.network(
                              revista.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  color: AppColors.primary,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stack) =>
                                  Container(
                                color: AppColors.primary,
                                child: const Center(
                                  child: FaIcon(FontAwesomeIcons.bookOpen,
                                      size: 64, color: Colors.white54),
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.primary,
                              child: const Center(
                                child: FaIcon(FontAwesomeIcons.bookOpen,
                                    size: 64, color: Colors.white54),
                              ),
                            ),
                    ),
                  ),

                  // Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Issue number badge
                          if (revista.issueNumber.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Nr. ${revista.issueNumber}',
                                style:
                                    theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // Title
                          Text(
                            revista.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Date and page count
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.calendar,
                                  size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Text(
                                dateFormat.format(revista.publishedAt),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (revista.pageCount > 0) ...[
                                const SizedBox(width: 20),
                                FaIcon(FontAwesomeIcons.fileLines,
                                    size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 6),
                                Text(
                                  '${revista.pageCount} pagini',
                                  style:
                                      theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),

                          // Download button
                          if (hasPdf) ...[
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isDownloading
                                    ? null
                                    : () => _downloadAndOpenPdf(
                                        revista.pdfUrl, revista.title),
                                icon: _isDownloading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const FaIcon(
                                        FontAwesomeIcons.fileArrowDown,
                                        size: 18),
                                label: Text(
                                  _isDownloading
                                      ? 'Se descarcă...'
                                      : 'Descarcă documentul',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),
                          Divider(color: Colors.grey[300]),
                          const SizedBox(height: 20),

                          // Description
                          if (revista.description.isNotEmpty)
                            Text(
                              revista.description,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                height: 1.6,
                                color: AppColors.onBackground,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
