import 'package:flutter/material.dart';

class IconState extends ChangeNotifier {
  bool isSelected = true;

  void toggleSelection() {
    isSelected = !isSelected;
    notifyListeners();
  }
}
