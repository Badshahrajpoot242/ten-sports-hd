// lib/screens/player/video_player_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../config/app_theme.dart';
import '../../models/category_model.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoLinkModel videoLink;

  const VideoPlayerScreen({super.key, required this.videoLink});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  YoutubePlayerController? _ytController;

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initPlayer();
    // Set landscape for fullscreen feel
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _initPlayer() async {
    try {
      if (widget.videoLink.type == VideoType.youtube) {
        _initYouTubePlayer();
      } else {
        await _initVideoPlayer();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load stream. Please try another link.';
        _isLoading = false;
      });
    }
  }

  void _initYouTubePlayer() {
    final videoId =
        YoutubePlayer.convertUrlToId(widget.videoLink.url) ?? '';
    if (videoId.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Invalid YouTube URL.';
        _isLoading = false;
      });
      return;
    }
    _ytController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        forceHD: true,
      ),
    );
    setState(() => _isLoading = false);
  }

  Future<void> _initVideoPlayer() async {
    final uri = Uri.parse(widget.videoLink.url);

    if (widget.videoLink.type == VideoType.hls) {
      _videoController = VideoPlayerController.networkUrl(
        uri,
        httpHeaders: const {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 Chrome/91.0',
        },
      );
    } else {
      _videoController = VideoPlayerController.networkUrl(uri);
    }

    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      allowMuting: true,
      showControlsOnInitialize: true,
      showOptions: false,
      placeholder: Container(color: Colors.black),
      errorBuilder: (context, errorMessage) {
        return Center(
          child: _ErrorWidget(
            message: errorMessage,
            onRetry: _retryPlayer,
          ),
        );
      },
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.accent,
        handleColor: AppColors.accent,
        backgroundColor: Colors.white24,
        bufferedColor: Colors.white38,
      ),
    );

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _retryPlayer() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    _disposeControllers();
    await _initPlayer();
  }

  void _disposeControllers() {
    _chewieController?.dispose();
    _videoController?.dispose();
    _ytController?.dispose();
    _chewieController = null;
    _videoController = null;
    _ytController = null;
  }

  @override
  void dispose() {
    _disposeControllers();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Player section
          _buildPlayerContainer(),

          // Info section
          Expanded(
            child: Container(
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVideoInfo(),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  const BannerAdPlaceholder(),
                  _buildStreamDetails(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerContainer() {
    final screenWidth = MediaQuery.of(context).size.width;
    final playerHeight = screenWidth * 9 / 16;

    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.black,
      child: Stack(
        children: [
          // Player
          if (_isLoading)
            const Center(child: _LoadingWidget())
          else if (_hasError)
            Center(
                child: _ErrorWidget(
                    message: _errorMessage, onRetry: _retryPlayer))
          else
            _buildPlayer(),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    if (widget.videoLink.type == VideoType.youtube &&
        _ytController != null) {
      return YoutubePlayer(
        controller: _ytController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.accent,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.accent,
          handleColor: AppColors.accent,
        ),
      );
    }

    if (_chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return const Center(
      child: Text('Player error', style: TextStyle(color: Colors.white)),
    );
  }

  Widget _buildVideoInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.videoLink.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'LIVE',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _InfoChip(
                label: widget.videoLink.quality,
                icon: Icons.hd_rounded,
                color: AppColors.accentGold,
              ),
              const SizedBox(width: 8),
              _InfoChip(
                label: widget.videoLink.type.name.toUpperCase(),
                icon: Icons.stream_rounded,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreamDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'STREAM CONTROLS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ControlButton(
                icon: Icons.refresh_rounded,
                label: 'Retry',
                onTap: _retryPlayer,
              ),
              const SizedBox(width: 12),
              _ControlButton(
                icon: Icons.fullscreen_rounded,
                label: 'Fullscreen',
                onTap: () {
                  if (_chewieController != null) {
                    _chewieController!.enterFullScreen();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Loading Widget ────────────────────────────────────────────
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: AppColors.accent,
          strokeWidth: 3,
        ),
        const SizedBox(height: 16),
        const Text(
          'Loading Stream...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ── Error Widget ──────────────────────────────────────────────
class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.accent, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Chip ─────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _InfoChip(
      {required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

// ── Control Button ────────────────────────────────────────────
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.accent, size: 18),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
