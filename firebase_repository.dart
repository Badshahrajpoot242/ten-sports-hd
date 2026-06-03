// lib/data/repositories/firebase_repository.dart

import 'package:firebase_database/firebase_database.dart';
import '../models/button_model.dart';
import '../models/video_model.dart';
import '../models/app_settings_model.dart';
import '../../core/constants/app_constants.dart';

class FirebaseRepository {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // ─── Settings ───────────────────────────────────────────────
  Stream<AppSettingsModel> getSettings() {
    return _database
        .ref(AppConstants.settingsPath)
        .onValue
        .map((event) {
      if (event.snapshot.value != null) {
        return AppSettingsModel.fromMap(
            event.snapshot.value as Map<dynamic, dynamic>);
      }
      return AppSettingsModel.defaults();
    });
  }

  // ─── Buttons ─────────────────────────────────────────────────
  Stream<List<ButtonModel>> getButtons() {
    return _database
        .ref(AppConstants.buttonsPath)
        .onValue
        .map((event) {
      if (event.snapshot.value == null) return [];
      final Map<dynamic, dynamic> map =
          event.snapshot.value as Map<dynamic, dynamic>;
      final List<ButtonModel> buttons = [];
      map.forEach((key, value) {
        final btn = ButtonModel.fromMap(key.toString(), value);
        if (btn.active) buttons.add(btn);
      });
      return buttons;
    });
  }

  // ─── Videos ──────────────────────────────────────────────────
  Stream<List<VideoModel>> getVideos(String categoryId) {
    return _database
        .ref('${AppConstants.videosPath}/$categoryId')
        .limitToFirst(AppConstants.maxVideosPerCategory)
        .onValue
        .map((event) {
      if (event.snapshot.value == null) return [];
      final Map<dynamic, dynamic> map =
          event.snapshot.value as Map<dynamic, dynamic>;
      final List<VideoModel> videos = [];
      map.forEach((key, value) {
        videos.add(VideoModel.fromMap(key.toString(), categoryId, value));
      });
      return videos;
    });
  }

  // ─── One-time fetch ──────────────────────────────────────────
  Future<AppSettingsModel> fetchSettingsOnce() async {
    final snapshot =
        await _database.ref(AppConstants.settingsPath).get();
    if (snapshot.value != null) {
      return AppSettingsModel.fromMap(
          snapshot.value as Map<dynamic, dynamic>);
    }
    return AppSettingsModel.defaults();
  }

  Future<List<ButtonModel>> fetchButtonsOnce() async {
    final snapshot =
        await _database.ref(AppConstants.buttonsPath).get();
    if (snapshot.value == null) return [];
    final Map<dynamic, dynamic> map =
        snapshot.value as Map<dynamic, dynamic>;
    final List<ButtonModel> buttons = [];
    map.forEach((key, value) {
      final btn = ButtonModel.fromMap(key.toString(), value);
      if (btn.active) buttons.add(btn);
    });
    return buttons;
  }
}
