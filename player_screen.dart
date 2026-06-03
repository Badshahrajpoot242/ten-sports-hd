// lib/screens/player/player_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/video_model.dart';

class PlayerScreen extends StatefulWidget {
  final VideoModel video;
  const PlayerScreen({super.key, required this.video});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with WidgetsBindingObserver {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  YoutubePlayerController? _ytController;

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMsg = '';
  int _retryCount = 0;
  static const int _maxRetries = 3;
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setLandscape();
    WakelockPlus.enable();
    _initPlayer();
  }

  void _setLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _initPlayer() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      if (widget.video.isYoutube) {
        _initYouTube();
        return;
      }
      await _initVideoPlayer();
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _initYouTube() {
    final ytId = AppUtils.extractYoutubeId(widget.video.url);
    if (ytId.isEmpty) {
      _handleError('Invalid YouTube URL');
      return;
    }

    _ytController = YoutubePlayerController(
      initialVideoId: ytId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        forceHD: true,
      ),
    );

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _initVideoPlayer() async {
    _videoController?.dispose();
    _chewieController?.dispose();

    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.url),
      httpHeaders: {'User-Agent': 'TenSportsHD/1.0'},
    );

    await _videoController!.initialize();

    if (!mounted) return;

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: widget.video.isLive,
      allowFullScreen: true,
      allowMuting: true,
      showControls: true,
      showControlsOnInitialize: true,
      fullScreenByDefault: true,
      allowedScreenSleep: false,
      errorBuilder: (context, errorMessage) =>
          _buildError(errorMessage),
      materialProgressColors: ChewieProgressColors(
        playedColor: AppTheme.primaryRed,
        handleColor: AppTheme.primaryRed,
        backgroundColor: AppTheme.dividerColor,
        bufferedColor: AppTheme.surfaceBg,
      ),
      placeholder: Container(color: Colors.black),
      overlay: widget.video.isLive
          ? const Positioned(
              top: 16,
              left: 16,
              child: _LiveIndicator(),
            )
          : null,
    );

    if (mounted) setState(() => _isLoading = false);
  }

  void _handleError(String message) {
    if (!mounted) return;
    setState(() {
      _hasError = true;
      _isLoading = false;
      _errorMsg = message;
    });

    if (_retryCount < _maxRetries) {
      _retryCount++;
      final delay = Duration(seconds: 3 + _retryCount * 2);
      _retryTimer = Timer(delay, () {
        if (mounted) {
          setState(() {
            _isLoading = true;
            _hasError = false;
          });
          _initPlayer();
        }
      });
    }
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppTheme.primaryRed, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _videoController?.dispose();
    _chewieController?.dispose();
    _ytController?.dispose();
    WakelockPlus.disable();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Player
          if (_isLoading) _buildLoading(),
          if (_hasError && _retryCount >= _maxRetries)
            _buildFinalError()
          else if (!_isLoading && !_hasError)
            _buildPlayer(),
          if (_isLoading && _retryCount > 0) _buildRetryOverlay(),

          // Back button
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.white, size: 18),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    if (widget.video.isYoutube && _ytController != null) {
      return YoutubePlayer(
        controller: _ytController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppTheme.primaryRed,
        onReady: () => _ytController!.play(),
      );
    }

    if (_chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoading() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppTheme.primaryRed,
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              _retryCount > 0
                  ? 'Retrying... ($_retryCount/$_maxRetries)'
                  : 'Loading...',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              widget.video.title,
              style: const TextStyle(
                  color: AppTheme.textMuted, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalError() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.signal_cellular_connected_no_internet_4_bar,
                  color: AppTheme.primaryRed, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Unable to Play',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMsg,
                style: const TextStyle(
                    color: AppTheme.textMuted, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  _retryCount = 0;
                  _initPlayer();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRetryOverlay() {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Reconnecting... ($_retryCount/$_maxRetries)',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _videoController?.pause();
    } else if (state == AppLifecycleState.resumed) {
      _videoController?.play();
    }
  }
}

class _LiveIndicator extends StatefulWidget {
  const _LiveIndicator();

  @override
  State<_LiveIndicator> createState() => _LiveIndicatorState();
}

class _LiveIndicatorState extends State<_LiveIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppTheme.liveBadge
              .withOpacity(0.85 + 0.15 * _anim.value),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
            ),
            const SizedBox(width: 6),
            const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
