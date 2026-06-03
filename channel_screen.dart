// lib/screens/channel/channel_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/button_model.dart';
import '../../data/models/video_model.dart';
import '../../providers/channel_provider.dart';
import '../player/player_screen.dart';

class ChannelScreen extends StatefulWidget {
  final ButtonModel button;
  const ChannelScreen({super.key, required this.button});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  late ChannelProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = ChannelProvider();
    _provider.loadVideos(widget.button.id);
  }

  @override
  void dispose() {
    _provider.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        backgroundColor: AppTheme.darkBg,
        appBar: AppBar(
          title: Text(widget.button.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Consumer<ChannelProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) return _LoadingList();
            if (provider.error != null) {
              return _ErrorWidget(
                message: provider.error!,
                onRetry: () => provider.retry(widget.button.id),
              );
            }
            if (provider.videos.isEmpty) return _EmptyWidget();
            return _VideoList(
              videos: provider.videos,
              categoryTitle: widget.button.title,
            );
          },
        ),
      ),
    );
  }
}

class _VideoList extends StatelessWidget {
  final List<VideoModel> videos;
  final String categoryTitle;

  const _VideoList({required this.videos, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.live_tv_rounded,
                  color: AppTheme.primaryRed, size: 20),
              const SizedBox(width: 8),
              Text(
                '${videos.length} VIDEOS AVAILABLE',
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            itemCount: videos.length,
            itemBuilder: (context, index) =>
                _VideoCard(video: videos[index], index: index),
          ),
        ),
      ],
    );
  }
}

class _VideoCard extends StatelessWidget {
  final VideoModel video;
  final int index;

  const _VideoCard({required this.video, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlayerScreen(video: video),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Row(
          children: [
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: video.thumbnail.isEmpty
                      ? Container(
                          width: 130,
                          height: 80,
                          color: AppTheme.surfaceBg,
                          child: const Center(
                            child: Icon(Icons.play_circle_outline_rounded,
                                color: AppTheme.textMuted, size: 36),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: video.thumbnail,
                          width: 130,
                          height: 80,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            width: 130,
                            height: 80,
                            color: AppTheme.surfaceBg,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: 130,
                            height: 80,
                            color: AppTheme.surfaceBg,
                            child: const Center(
                              child: Icon(Icons.image_not_supported_rounded,
                                  color: AppTheme.textMuted),
                            ),
                          ),
                        ),
                ),

                // Play overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),

                // Live badge
                if (video.isLive)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.liveBadge,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                // Type badge
                if (!video.isLive)
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        video.type.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    if (video.description.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        video.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          video.isYoutube
                              ? Icons.smart_display_rounded
                              : Icons.live_tv_rounded,
                          color: AppTheme.primaryRed,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          video.isYoutube
                              ? 'YouTube'
                              : video.isLive
                                  ? 'Live Stream'
                                  : 'MP4',
                          style: const TextStyle(
                            color: AppTheme.primaryRed,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textMuted, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.cardBg,
      highlightColor: AppTheme.surfaceBg,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          height: 90,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppTheme.textMuted, size: 56),
          const SizedBox(height: 16),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📺', style: TextStyle(fontSize: 56)),
          SizedBox(height: 16),
          Text('No Videos Available',
              style:
                  TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
        ],
      ),
    );
  }
}
