import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
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
  String? _pdfLocalPath;
  bool _isLoadingPdf = false;
  int _totalPages = 0;
  int _currentPage = 0;

  Future<void> _loadPdfInline(String storagePath, String title) async {
    if (storagePath.isEmpty || _pdfLocalPath != null) return;

    setState(() => _isLoadingPdf = true);

    try {
      final repository = sl<RevistaRepository>();
      final sanitizedName = title.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
      final localPath = await repository.downloadPdfFile(storagePath, '$sanitizedName.pdf');

      if (mounted) {
        setState(() {
          _pdfLocalPath = localPath;
          _isLoadingPdf = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingPdf = false;
          _downloadError = e.toString();
        });
      }
    }
  }

  Rect _shareOrigin() {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      return Rect.fromLTWH(position.dx, position.dy, box.size.width, box.size.height);
    }
    return Rect.fromLTWH(0, 0, MediaQuery.of(context).size.width, 100);
  }

  Future<void> _downloadAndSharePdf(String storagePath, String title) async {
    final origin = _shareOrigin();
    if (_pdfLocalPath != null) {
      await Share.shareXFiles([XFile(_pdfLocalPath!)], text: title, sharePositionOrigin: origin);
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
        setState(() {
          _isDownloading = false;
          _pdfLocalPath = localPath;
        });
        await Share.shareXFiles([XFile(localPath)], text: title, sharePositionOrigin: origin);
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
                    iconTheme: const IconThemeData(color: Colors.white),
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
                      title: Text(
                        revista.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
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

                          // PDF section
                          if (hasPdf) ...[
                            const SizedBox(height: 24),
                            // Share/download button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _isDownloading
                                    ? null
                                    : () => _downloadAndSharePdf(
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
                                        FontAwesomeIcons.shareFromSquare,
                                        size: 18),
                                label: Text(
                                  _isDownloading
                                      ? 'Se descarcă...'
                                      : 'Distribuie documentul',
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

                  // Inline PDF viewer
                  if (hasPdf)
                    SliverToBoxAdapter(
                      child: _buildPdfViewer(revista.pdfUrl, revista.title),
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

  Widget _buildPdfViewer(String storagePath, String title) {
    // Auto-load PDF if not loaded yet
    if (_pdfLocalPath == null && !_isLoadingPdf && _downloadError == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPdfInline(storagePath, title);
      });
    }

    if (_isLoadingPdf) {
      return Container(
        height: 400,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Se incarca documentul...'),
            ],
          ),
        ),
      );
    }

    if (_downloadError != null) {
      return Container(
        height: 200,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(FontAwesomeIcons.triangleExclamation,
                  color: Colors.red, size: 32),
              const SizedBox(height: 12),
              const Text('Nu s-a putut incarca documentul'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() => _downloadError = null);
                  _loadPdfInline(storagePath, title);
                },
                child: const Text('Reincearca'),
              ),
            ],
          ),
        ),
      );
    }

    if (_pdfLocalPath != null) {
      return Column(
        children: [
          // Page counter + fullscreen button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                if (_totalPages > 0) ...[
                  FaIcon(FontAwesomeIcons.fileLines,
                      size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    'Pagina ${_currentPage + 1} din $_totalPages',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _openFullScreen(title: title),
                  icon: const FaIcon(FontAwesomeIcons.expand, size: 14),
                  label: const Text('Ecran complet'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
          // PDF viewer
          Container(
            height: 600,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: PDFView(
              filePath: _pdfLocalPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              defaultPage: _currentPage,
              onRender: (pages) {
                if (mounted) setState(() => _totalPages = pages ?? 0);
              },
              onPageChanged: (page, total) {
                if (mounted) setState(() => _currentPage = page ?? 0);
              },
              onError: (error) {
                if (mounted) {
                  setState(() => _downloadError = error.toString());
                }
              },
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _openFullScreen({String title = ''}) {
    if (_pdfLocalPath == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullScreenPdfPage(
          filePath: _pdfLocalPath!,
          title: title,
          initialPage: _currentPage,
        ),
      ),
    );
  }
}

class _FullScreenPdfPage extends StatefulWidget {
  final String filePath;
  final String title;
  final int initialPage;

  const _FullScreenPdfPage({
    required this.filePath,
    required this.title,
    required this.initialPage,
  });

  @override
  State<_FullScreenPdfPage> createState() => _FullScreenPdfPageState();
}

class _FullScreenPdfPageState extends State<_FullScreenPdfPage> {
  int _currentPage = 0;
  int _totalPages = 0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _showControls = !_showControls),
        child: Stack(
          children: [
            // PDF viewer - full screen
            PDFView(
              filePath: widget.filePath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: true,
              pageFling: true,
              defaultPage: widget.initialPage,
              fitPolicy: FitPolicy.BOTH,
              onRender: (pages) {
                if (mounted) setState(() => _totalPages = pages ?? 0);
              },
              onPageChanged: (page, total) {
                if (mounted) setState(() => _currentPage = page ?? 0);
              },
            ),

            // Top bar with close button
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white, size: 28),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        if (widget.title.isNotEmpty)
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        else
                          const Spacer(),
                        if (_totalPages > 0)
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${_currentPage + 1} / $_totalPages',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
