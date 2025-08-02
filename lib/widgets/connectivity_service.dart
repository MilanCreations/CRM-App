import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// REAL Internet check
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) return false;

    try {
      final lookup = await InternetAddress.lookup('google.com');
      return lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  void showNoInternetScreen() {
    Get.to(() => const NointernetScreen());
  }

  StreamSubscription<List<ConnectivityResult>> listenToConnectivityChanges({
    required VoidCallback onConnected,
    required VoidCallback onDisconnected,
  }) {
    return _connectivity.onConnectivityChanged.listen((result) async {
      bool internet = await isConnected();
      if (internet) {
        onConnected();
      } else {
        onDisconnected();
      }
    });
  }
}

