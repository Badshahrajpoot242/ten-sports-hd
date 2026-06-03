// lib/screens/categories/sub_category_screen.dart
import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/category_model.dart';
import '../../widgets/sport_category_card.dart';
import '../player/video_player_screen.dart';

class SubCategoryScreen extends StatelessWidget {
  final String title;
  final List<SubCategoryModel> subCategories;
  final bool isTopLevel;

  const SubCategoryScreen({
    super.key,
    required this.title,
    required this.subCategories,
    this.isTopLevel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const BannerAdPlaceholder(),
          Expanded(
            child: subCategories.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: subCategories.length,
                    itemBuilder: (context, index) {
                      final sub = subCategories[index];
                      return SubCategoryButton(
                        subCategory: sub,
                        onTap: () => _handleTap(context, sub),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _handleTap(BuildContext context, SubCategoryModel sub) {
    if (sub.hasSubCategories) {
      // Navigate deeper
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SubCategoryScreen(
            title: sub.title,
            subCategories: sub.subCategories,
          ),
        ),
      );
    } else if (sub.hasVideoLinks) {
      if (sub.videoLinks.length == 1) {
        // Single stream - go straight to player
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(videoLink: sub.videoLinks.first),
          ),
        );
      } else {
        // Multiple streams - show stream selection screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StreamSelectionScreen(
              title: sub.title,
              videoLinks: sub.videoLinks,
            ),
          ),
        );
      }
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📡', style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
          Text(
            'No streams available',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Stream Selection Screen ───────────────────────────────────
class StreamSelectionScreen extends StatelessWidget {
  final String title;
  final List<VideoLinkModel> videoLinks;

  const StreamSelectionScreen({
    super.key,
    required this.title,
    required this.videoLinks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const BannerAdPlaceholder(),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SELECT STREAM QUALITY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: videoLinks.length,
              itemBuilder: (context, index) {
                return VideoLinkButton(
                  videoLink: videoLinks[index],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(
                            videoLink: videoLinks[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
