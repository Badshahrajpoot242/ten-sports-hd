// lib/providers/player_provider.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../data/models/video_model.dart';

enum PlayerState { loading, playing, paused, error, retrying }

class PlayerProvider extends ChangeNotifier {
  VideoPlayerController? _controller;
  VideoModel? _currentVideo;
  PlayerState _state = PlayerState.loading;
  String? _errorMessage;
  int _retryCount = 0;
  static const int maxRetries = 3;

  VideoPlayerController? get controller => _controller;
  VideoModel? get currentVideo => _currentVideo;
  PlayerState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLive => _currentVideo?.isLive ?? false;
  bool get isPlaying => _state == PlayerState.playing;

  Future<void> initializeVideo(VideoModel video) async {
    _currentVideo = video;
    _retryCount = 0;
    await _loadVideo(video);
  }

  Future<void> _loadVideo(VideoModel video) async {
    _state = PlayerState.loading;
    notifyListeners();

    try {
      await _controller?.dispose();

      if (video.isYoutube) {
        // YouTube handled separately in UI
        _state = PlayerState.playing;
        notifyListeners();
        return;
      }

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(video.url),
        httpHeaders: {
          'User-Agent': 'TenSportsHD/1.0',
          'Accept': '*/*',
        },
      );

      await _controller!.initialize();
      _controller!.addListener(_onControllerUpdate);
      await _controller!.play();
      _state = PlayerState.playing;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _onControllerUpdate() {
    if (_controller == null) return;
    if (_controller!.value.hasError && _state != PlayerState.error) {
      _handleError(_controller!.value.errorDescription ?? 'Playback error');
    }
    notifyListeners();
  }

  void _handleError(String message) {
    _errorMessage = message;
    _state = PlayerState.error;
    notifyListeners();

    if (_retryCount < maxRetries) {
      Future.delayed(Duration(seconds: 3 + _retryCount * 2), () {
        if (_currentVideo != null) {
          _retryCount++;
          _state = PlayerState.retrying;
          notifyListeners();
          _loadVideo(_currentVideo!);
        }
      });
    }
  }

  void togglePlayPause() {
    if (_controller == null) return;
    if (_controller!.value.isPlaying) {
      _controller!.pause();
      _state = PlayerState.paused;
    } else {
      _controller!.play();
      _state = PlayerState.playing;
    }
    notifyListeners();
  }

  void manualRetry() {
    if (_currentVideo != null) {
      _retryCount = 0;
      _loadVideo(_currentVideo!);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerUpdate);
    _controller?.dispose();
    super.dispose();
  }
}
