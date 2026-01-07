import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class InternetService {
  InternetService._privateConstructor();
  static final InternetService instance = InternetService._privateConstructor();

  final Connectivity connectivity = Connectivity();
  final StreamController<bool> controller = StreamController<bool>.broadcast();

  bool _hasInternet = true;
  bool get hasInternet => _hasInternet;

  Stream<bool> get onStatusChange => controller.stream;

  void initialize() {
    checkInternet();

    connectivity.onConnectivityChanged.listen((_) async {
      await checkInternet();
    });
  }

  Future<void> checkInternet() async {
    bool previousState = hasInternet;

    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _hasInternet = false;
      } else {
        final result = await InternetAddress.lookup('google.com');
        _hasInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      }
    } catch (_) {
      _hasInternet = false;
    }

    if (previousState != hasInternet) {
      controller.add(hasInternet);
    }
  }

  void dispose() {
    controller.close();
  }
}
