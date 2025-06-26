import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crm_milan_creations/Chat%20App/Chat%20Home%20Page/ChatUserListController.dart';
import 'package:crm_milan_creations/Chat%20App/Chat%20Inbox/chatInboxScreen.dart';
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
  final ChatUserListController objChatUserListController = Get.put(ChatUserListController());

  String userId ="";
  String username ="";

  @override
  void initState() {
    super.initState();
    getUserData();
    objChatUserListController.ChatUserListfunctions(isRefresh: true);
  }

  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id") ?? "";
    username = sharedPreferences.getString("username")?? "";
    print('📥 Logged-in user ID: $userId');

    if (userId != null && userId.isNotEmpty) {
      socketController.initSocket(userId, username);
    } 
    
     else {
      print("⚠️ userId is null or empty");
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

      body: Obx(() {
      final users = objChatUserListController.ChatUsers;
      if(users.isEmpty){
        return const Center(child: Text("Chat box is Empty"));
      }
      return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              final selectedPersonID = users[index].id.toString();
              if(userId != null && selectedPersonID.isNotEmpty){
                print('user id:- $userId selected person id:- $selectedPersonID');
                Get.to(ChatScreen(userId: userId, peerId: selectedPersonID, selectedname: users[index].username, username:users[index].name,));
              }
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
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: const AssetImage('assets/mainlogo.png'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: users[index].name,
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
                        // const SizedBox(height: 6),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        //   decoration: BoxDecoration(
                        //     color: CRMColors.crmMainCOlor,
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: const CustomText(
                        //     text: '2',
                        //     color: Colors.white,
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
      },);
      },),
   
    );
  }
}
