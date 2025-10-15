import 'package:app/core/style/app_colors.dart';
import 'package:app/features/locations/data/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({super.key, required this.location});

  final LocationModel location;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Icon(Icons.info_outline, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'About',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (location.description != null)
            Html(
              data: location.description!,
              style: {
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(14),
                  lineHeight: const LineHeight(1.5),
                  color: Colors.grey.shade700,
                ),
                "p": Style(margin: Margins.only(bottom: 8)),
                "h1, h2, h3, h4, h5, h6": Style(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                  margin: Margins.only(bottom: 8, top: 12),
                ),
                "ul, ol": Style(margin: Margins.only(left: 16, bottom: 8)),
                "li": Style(margin: Margins.only(bottom: 4)),
                "strong, b": Style(fontWeight: FontWeight.bold),
                "em, i": Style(fontStyle: FontStyle.italic),
              },
            )
          else
            Text(
              'No description available for this location.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
