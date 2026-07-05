import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetProvider with ChangeNotifier {
  bool _isOnline = true;

  bool get isOnline => _isOnline;

  InternetProvider() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        _isOnline = false;
      } else {
        _isOnline = true;
      }
      notifyListeners();
    });
  }
}