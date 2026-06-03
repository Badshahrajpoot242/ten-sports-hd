// lib/widgets/sport_category_card.dart
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/category_model.dart';

class SportCategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;

  const SportCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.cardBg,
              AppColors.cardBg.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: category.isLive
                ? AppColors.accent.withOpacity(0.5)
                : AppColors.cardBorder,
            width: category.isLive ? 1.5 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: category.isLive
                  ? AppColors.accent.withOpacity(0.15)
                  : Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background shimmer effect
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.03),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category.iconEmoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                      if (category.isLive) const _LiveBadge(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        category.subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tap ripple
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(16),
                  splashColor: AppColors.accent.withOpacity(0.1),
                  highlightColor: AppColors.accent.withOpacity(0.05),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          const Text(
            'LIVE',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub Category Button ───────────────────────────────────────
class SubCategoryButton extends StatelessWidget {
  final SubCategoryModel subCategory;
  final VoidCallback onTap;

  const SubCategoryButton({
    super.key,
    required this.subCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: subCategory.isLive
                ? AppColors.accent.withOpacity(0.4)
                : AppColors.cardBorder,
            width: subCategory.isLive ? 1.0 : 0.5,
          ),
        ),
        child: Row(
          children: [
            if (subCategory.iconEmoji != null)
              Text(
                subCategory.iconEmoji!,
                style: const TextStyle(fontSize: 24),
              ),
            if (subCategory.iconEmoji != null) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          subCategory.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (subCategory.isLive) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (subCategory.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subCategory.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Video Link Button ─────────────────────────────────────────
class VideoLinkButton extends StatelessWidget {
  final VideoLinkModel videoLink;
  final VoidCallback onTap;

  const VideoLinkButton({
    super.key,
    required this.videoLink,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accent.withOpacity(0.15),
              AppColors.cardBg,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoLink.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      _QualityBadge(quality: videoLink.quality),
                      const SizedBox(width: 8),
                      _TypeBadge(type: videoLink.type),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QualityBadge extends StatelessWidget {
  final String quality;
  const _QualityBadge({required this.quality});

  @override
  Widget build(BuildContext context) {
    Color color = quality == 'FHD'
        ? AppColors.accentGold
        : quality == 'HD'
            ? Colors.blue
            : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        quality,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final VideoType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    String label;
    switch (type) {
      case VideoType.hls:
        label = 'M3U8';
        break;
      case VideoType.youtube:
        label = 'YouTube';
        break;
      case VideoType.mp4:
        label = 'MP4';
        break;
      default:
        label = 'Stream';
    }
    return Text(
      label,
      style: const TextStyle(
        fontSize: 11,
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ── Banner Ad Placeholder ─────────────────────────────────────
class BannerAdPlaceholder extends StatelessWidget {
  const BannerAdPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real AdWidget when AdMob is connected
    // if (AdsService().bannerAd != null) {
    //   return SizedBox(height: 50, child: AdWidget(ad: AdsService().bannerAd!));
    // }
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: const Center(
        child: Text(
          'AD SPACE — Connect AdMob to activate',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
