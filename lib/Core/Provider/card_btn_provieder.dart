import 'dart:async';

import 'package:flutter/material.dart';

class DownloadProvider extends ChangeNotifier {
  bool _downloading = false;
  bool _downloaded = false;

  bool get downloading => _downloading;
  bool get downloaded => _downloaded;

  void startDownload() {
    _downloading = true;
    notifyListeners();

    // Simulate a 5-second download
    Timer(Duration(seconds: 2), () {
      _downloading = false;
      _downloaded = true;
      notifyListeners();
    });
  }

  void reset() {
    _downloading = false;
    _downloaded = false;
    notifyListeners();
  }
}
