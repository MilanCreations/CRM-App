import 'package:crm_milan_creations/Chat%20App/Socket%20Services/socketController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final Socketcontroller socketController = Get.find<Socketcontroller>();
  String? userId;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id");
    print('user id:- $userId');
    if (userId != null && userId!.isNotEmpty) {
      socketController.initSocket(userId!);
    } else {
      print("userId is null or empty");
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
          text: 'Chat',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  socketController.isConnected.value
                      ? Icons.wifi
                      : Icons.wifi_off,
                  color: socketController.isConnected.value
                      ? Colors.green
                      : Colors.red,
                ),
              ))
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // Navigate to chat box
              // Get.to(() => ChatBoxScreen(userName: 'User ${index + 1}'));
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: const AssetImage('assets/mainlogo.png'),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: Obx(() => Container(
                        //         height: 12,
                        //         width: 12,
                        //         decoration: BoxDecoration(
                        //           color: socketController.isConnected.value ? Colors.green : Colors.grey,
                        //           shape: BoxShape.circle,
                        //           border: Border.all(color: Colors.white, width: 2),
                        //         ),
                        //       )),
                        // ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'User Name ${index + 1}',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: 'This is a sample message preview...',
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: CRMColors.crmMainCOlor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const CustomText(
                           text:  '2', // unread message count
                            color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
