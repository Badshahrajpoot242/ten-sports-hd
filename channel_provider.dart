// lib/providers/channel_provider.dart

import 'package:flutter/material.dart';
import '../data/models/video_model.dart';
import '../data/repositories/firebase_repository.dart';

class ChannelProvider extends ChangeNotifier {
  final FirebaseRepository _repo = FirebaseRepository();

  List<VideoModel> _videos = [];
  bool _isLoading = true;
  String? _error;
  String? _currentCategoryId;

  List<VideoModel> get videos => _videos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadVideos(String categoryId) {
    if (_currentCategoryId == categoryId) return;
    _currentCategoryId = categoryId;
    _isLoading = true;
    _videos = [];
    notifyListeners();

    _repo.getVideos(categoryId).listen(
      (videos) {
        _videos = videos;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load videos. Please try again.';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void retry(String categoryId) {
    _currentCategoryId = null;
    loadVideos(categoryId);
  }

  void reset() {
    _videos = [];
    _isLoading = true;
    _error = null;
    _currentCategoryId = null;
  }
}
