import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localization.dart';
import '../../../../core/style/app_colors.dart';
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
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    // Load revista details
    context.read<RevistaDetailsBloc>().add(
          LoadRevistaDetailsRequested(id: widget.revistaId),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(context.getString(label: 'revista')),
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<RevistaDetailsBloc, RevistaDetailsState>(
        listener: (context, state) {
          if (state is RevistaDetailsLoaded && state.pdfLocalPath == null) {
            // Auto-load PDF when revista details are loaded
            context.read<RevistaDetailsBloc>().add(
                  LoadPdfUrlRequested(fileId: state.revista.pdfUrl),
                );
          }
        },
        builder: (context, state) {
          if (state is RevistaDetailsLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    context.getString(label: 'loadingRevista'),
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }

          if (state is RevistaDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.triangleExclamation,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.getString(label: 'error'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<RevistaDetailsBloc>().add(
                            LoadRevistaDetailsRequested(id: widget.revistaId),
                          );
                    },
                    icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
                    label: Text(context.getString(label: 'retry')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is RevistaDetailsLoaded) {
            final revista = state.revista;
            final dateFormat = DateFormat('MMMM yyyy');

            return Column(
              children: [
                // Header with revista info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Issue number
                      if (revista.issueNumber.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            context
                                .getString(label: 'issueNumber')
                                .replaceAll('{number}', revista.issueNumber),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (revista.issueNumber.isNotEmpty)
                        const SizedBox(height: 8),

                      // Title
                      Text(
                        revista.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Date
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.calendar,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateFormat.format(revista.publishedAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // PDF Viewer or loading state
                Expanded(
                  child: _buildPdfView(state, theme),
                ),

                // Page indicator
                if (_isReady && _totalPages > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _currentPage > 0
                              ? () {
                                  _pdfViewController?.setPage(_currentPage - 1);
                                }
                              : null,
                          icon: const FaIcon(
                            FontAwesomeIcons.chevronLeft,
                            size: 16,
                          ),
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${context.getString(label: 'page')} ${_currentPage + 1} ${context.getString(label: 'of')} $_totalPages',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: _currentPage < _totalPages - 1
                              ? () {
                                  _pdfViewController?.setPage(_currentPage + 1);
                                }
                              : null,
                          icon: const FaIcon(
                            FontAwesomeIcons.chevronRight,
                            size: 16,
                          ),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPdfView(RevistaDetailsLoaded state, ThemeData theme) {
    if (state.isLoadingPdf) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              context.getString(label: 'loadingPdf'),
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    if (state.pdfError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.filePdf,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                context.getString(label: 'pdfLoadError'),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                state.pdfError!,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<RevistaDetailsBloc>().add(
                        LoadPdfUrlRequested(fileId: state.revista.pdfUrl),
                      );
                },
                icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
                label: Text(context.getString(label: 'retry')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.pdfLocalPath != null) {
      return PDFView(
        filePath: state.pdfLocalPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        defaultPage: _currentPage,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        onRender: (pages) {
          setState(() {
            _totalPages = pages ?? 0;
            _isReady = true;
          });
        },
        onError: (error) {
          print('PDF Error: $error');
        },
        onPageError: (page, error) {
          print('Page $page Error: $error');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          _pdfViewController = pdfViewController;
        },
        onPageChanged: (int? page, int? total) {
          setState(() {
            _currentPage = page ?? 0;
          });
        },
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FaIcon(
            FontAwesomeIcons.filePdf,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            context.getString(label: 'noPdfAvailable'),
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
