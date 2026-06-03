// lib/providers/settings_provider.dart

import 'package:flutter/material.dart';
import '../data/models/app_settings_model.dart';
import '../data/repositories/firebase_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final FirebaseRepository _repo = FirebaseRepository();

  AppSettingsModel _settings = AppSettingsModel.defaults();
  bool _isLoading = true;
  String? _error;

  AppSettingsModel get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isMaintenanceMode => _settings.maintenanceMode;

  void init() {
    _repo.getSettings().listen(
      (settings) {
        _settings = settings;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
