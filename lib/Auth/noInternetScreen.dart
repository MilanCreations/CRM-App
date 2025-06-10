// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NointernetScreen extends StatefulWidget {
  const NointernetScreen({super.key});

  @override
  State<NointernetScreen> createState() => _NointernetScreenState();
}

class _NointernetScreenState extends State<NointernetScreen> {
  final Connectivity _connectivity = Connectivity();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

    @override
  void dispose() {
   _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      _connectionStatus = result;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status:- $e', );
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }



  Future<void> _tryAgain() async {
    await _checkConnectivity(); // Refresh the connection status
    
    if (_connectionStatus.contains(ConnectivityResult.mobile) || 
        _connectionStatus.contains(ConnectivityResult.wifi)) {
          print('done');
      // Internet is connected, go back
      Get.back();
    } else {
      // Still no internet, show snackbar
      Get.snackbar(
        "No Internet", 
        "Please check your internet connection",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.whiteColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔌 No Connection Image
              Image.asset(
                'assets/Noconnection.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              // ❗ Message
              const CustomText(
                text: "No internet connection",
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),

              const SizedBox(height: 10),

              const Text(
                "Please check your Wi-Fi or mobile data settings.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // ⚙️ Open Settings Button
              CustomButton(
                text: 'Try Again',
                onPressed: _tryAgain,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                borderRadius: 12,
                height: 48,
                width: double.infinity,
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}