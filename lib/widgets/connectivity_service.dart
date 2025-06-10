// connectivity_service.dart
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile) || 
           result.contains(ConnectivityResult.wifi);
  }

  void showNoInternetScreen() {
    Get.to(() => const NointernetScreen());
  }

  StreamSubscription<List<ConnectivityResult>> listenToConnectivityChanges({
    required VoidCallback onConnected,
    required VoidCallback onDisconnected,
  }) {
    return _connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.mobile) || 
         result.contains(ConnectivityResult.wifi)) {
        onConnected();
      } else {
        onDisconnected();
      }
    });
  }
}