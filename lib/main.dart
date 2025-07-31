import 'package:crm_milan_creations/Auth/SplashScreen.dart';
import 'package:crm_milan_creations/Chat%20App/Socket%20Services/socketController.dart';
import 'package:crm_milan_creations/widgets/notficationsServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  // You can handle the message here if needed
} 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  Get.put(Socketcontroller(), permanent: true);
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService = Get.put(NotificationService());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use FutureBuilder to ensure context is available before calling permission
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haazir Janaab',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Builder(
        builder: (context) {
         _initializeFCM(context);
          return const Splashscreen();
        },
      ),
    );
  }

void _initializeFCM(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  notificationService.requestNotificationPermission(context);

  String? token = await messaging.getToken();
  print("📱 FCM Token: $token");

  if (token != null) {
    await preferences.setString('fcm_token', token);
    print("✅ Token saved to SharedPreferences: $token");
  }

  notificationService.firebaseInit(context);
  notificationService.setupInteractMessage(context); // Optional: to handle taps
}

}
