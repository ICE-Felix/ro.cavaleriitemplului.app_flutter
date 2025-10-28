import 'package:app/core/banners/domain/entities/banner_entity.dart';
import 'package:app/core/banners/presentation/cubit/banners_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerWidget extends StatelessWidget {
  final BannerType type;

  const BannerWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersCubit, BannersState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SizedBox.shrink();
        }

        final banner =
            type == BannerType.primary
                ? context.read<BannersCubit>().getRandomPrimaryBanner()
                : context.read<BannersCubit>().getRandomSecondaryBanner();

        if (banner == null) {
          return const SizedBox.shrink();
        }

        return _BannerDisplay(banner: banner);
      },
    );
  }
}

class _BannerDisplay extends StatefulWidget {
  final BannerEntity banner;

  const _BannerDisplay({required this.banner});

  @override
  State<_BannerDisplay> createState() => _BannerDisplayState();
}

class _BannerDisplayState extends State<_BannerDisplay> {
  bool _hasIncrementedDisplay = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleBannerTap(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.network(
            widget.banner.imageUrl,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                if (!_hasIncrementedDisplay) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_hasIncrementedDisplay) {
                      _hasIncrementedDisplay = true;
                      context.read<BannersCubit>().incrementDisplays(
                        widget.banner.id,
                      );
                    }
                  });
                }
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value:
                      loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey.shade400,
                  size: 48,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleBannerTap(BuildContext context) async {
    context.read<BannersCubit>().incrementClicks(widget.banner.id);
    try {
      final uri = Uri.parse(widget.banner.redirectLink);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching banner URL: $e');
    }
  }
}
