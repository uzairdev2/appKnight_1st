import 'package:flutter/material.dart';

class CurrentScreen extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
