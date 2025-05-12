import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoaderOverlay extends StatelessWidget {
  final RxBool isLoading;

  const LoaderOverlay({Key? key, required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!isLoading.value) return const SizedBox.shrink();
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    });
  }
}
