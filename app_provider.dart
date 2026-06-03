// lib/providers/app_provider.dart
import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../services/data_service.dart';

class AppProvider extends ChangeNotifier {
  final DataService _dataService = DataService();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _error;
  int _notificationCount = 0;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get notificationCount => _notificationCount;

  Future<void> loadCategories() async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _dataService.getCategories();
      _error = null;
    } catch (e) {
      _error = 'Failed to load data. Please try again.';
      debugPrint('AppProvider error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _dataService.clearCache();
    await loadCategories();
  }

  void setNotificationCount(int count) {
    _notificationCount = count;
    notifyListeners();
  }
}
