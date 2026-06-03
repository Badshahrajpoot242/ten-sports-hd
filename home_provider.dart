// lib/providers/home_provider.dart

import 'package:flutter/material.dart';
import '../data/models/button_model.dart';
import '../data/repositories/firebase_repository.dart';

class HomeProvider extends ChangeNotifier {
  final FirebaseRepository _repo = FirebaseRepository();

  List<ButtonModel> _buttons = [];
  bool _isLoading = true;
  String? _error;

  List<ButtonModel> get buttons => _buttons;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void loadButtons() {
    _isLoading = true;
    notifyListeners();

    _repo.getButtons().listen(
      (buttons) {
        _buttons = buttons;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load channels. Please try again.';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void retry() {
    loadButtons();
  }
}
