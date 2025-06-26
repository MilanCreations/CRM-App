import 'package:crm_milan_creations/Employee/Notifications/notificationsController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  final RemoteMessage message;
  const NotificationsScreen({super.key, required this.message});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationsHistoryController notificationsHistoryController =
      Get.put(NotificationsHistoryController());

  @override
  void initState() {
    super.initState();
    notificationsHistoryController.NotificationsHistoryfunctions(isRefresh: true);
  }

String formatDate(dynamic dateTimeInput) {
  try {
    DateTime dt;

    if (dateTimeInput is String) {
      dt = DateTime.parse(dateTimeInput).toLocal();
    } else if (dateTimeInput is DateTime) {
      dt = dateTimeInput.toLocal();
    } else {
      return '';
    }

    return DateFormat('MMM dd, yyyy – hh:mm a').format(dt);
  } catch (e) {
    return '';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'Notifications',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
      ),
      body: Obx(() {
        final list = notificationsHistoryController.notificationsList;
        if (list.isEmpty) {
          return const Center(child: Text("No notifications found."));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final item = list[index];
            return Card(
              color: item.isRead ? Colors.white : const Color(0xFFE8F0FE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                title: Text(
                  item.title ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: CRMColors.black1,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      item.body ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                     text: formatDate(item.createdAt ?? '').toString(),
                      fontSize: 12, color: Colors.grey
                    ),
                  ],
                ),
                trailing: item.isRead
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.circle, size: 12, color: Colors.redAccent),
              ),
            );
          },
        );
      }),
    );
  }
}
