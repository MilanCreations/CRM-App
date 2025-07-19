import 'package:crm_milan_creations/Chat%20App/Chat%20Home%20Page/ChatUserListController.dart';
import 'package:crm_milan_creations/Chat%20App/Chat%20Inbox/chatInboxScreen.dart';
import 'package:crm_milan_creations/Chat%20App/Controller/chatController.dart';
import 'package:crm_milan_creations/Chat%20App/Socket%20Services/socketController.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
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
  final ChatUserListController objChatUserListController = Get.put(
    ChatUserListController(),
  );
  final chatController = Get.put(ChatController());
  TextEditingController searchController = TextEditingController();
  RxBool isSearching = false.obs;
  String userId = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    getUserData();
    objChatUserListController.chatUserListfunctions(isRefresh: true);
    // Initialize message activity listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.handleMessageActivity();
    });
  }

  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id") ?? "";
    username = sharedPreferences.getString("username") ?? "";
    print('📥 Logged-in user ID: $userId');

    if (userId != null && userId.isNotEmpty) {
      socketController.initSocket(userId, username);
    } else {
      print("⚠️ userId is null or empty");
    }
  }

  Future<void> _resetAndFetchFilteredData() async {
    objChatUserListController.hasMoreData.value = true;
    objChatUserListController.currentPage.value = 1;
    searchController.clear();
    objChatUserListController.chatUserListfunctions(searchQuery: "");
  }




void _onSearchChanged() {
  final query = searchController.text.trim();
  objChatUserListController.searchUserLocally(query);
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
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                socketController.isConnected.value
                    ? Icons.wifi
                    : Icons.wifi_off,
                color:
                    socketController.isConnected.value
                        ? Colors.green
                        : Colors.red,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            margin: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: 'Search employee...',
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                suffixIcon:
                    searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            FocusScope.of(context).unfocus();
                            _resetAndFetchFilteredData();
                          },
                        )
                        : null,
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              final users = objChatUserListController.chatUsers;
              if (objChatUserListController.isLoading.value) {
                return shimmereffectloader();
              }
              if (users.isEmpty) {
                return const Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      final selectedPersonID = users[index].id.toString();
                      if (userId != null && selectedPersonID.isNotEmpty) {
                        print(
                          'user id:- $userId selected person id:- $selectedPersonID',
                        );
                        final result = await Get.to(
                          ChatScreen(
                            userId: userId,
                            peerId: selectedPersonID,
                            selectedname: users[index].username,
                            username: users[index].name,
                          ),
                        );
                        if (result == true) {
                          print("✅ User sent a message. Refreshing list...");
                          objChatUserListController.chatUserListfunctions(
                            isRefresh: true,
                          );
                        } else {
                          print('No message sent. so nee to referesh the list');
                        }
                      }
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (users[index].profilePic != null &&
                                    users[index].profilePic.isNotEmpty) {
                                  Get.dialog(
                                    Dialog(
                                      backgroundColor: Colors.black,
                                      child: InteractiveViewer(
                                        panEnabled: true,
                                        minScale: 0.5,
                                        maxScale: 4.0,
                                        child: Image.network(
                                          users[index].profilePic,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.white,
                                                  ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child:
                                  users[index].profilePic != null &&
                                          users[index].profilePic.isNotEmpty
                                      ? CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage: NetworkImage(
                                          users[index].profilePic,
                                        ),
                                      )
                                      : const CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.person),
                                      ),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget shimmereffectloader() {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              FadeShimmer.round(
                size: 56,
                fadeTheme: FadeTheme.light, // Or use FadeTheme.dark
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeShimmer(
                      height: 14,
                      width: double.infinity,
                      radius: 4,
                      millisecondsDelay: 300,
                      fadeTheme: FadeTheme.light,
                    ),
                    const SizedBox(height: 8),
                    FadeShimmer(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.4,
                      radius: 4,
                      millisecondsDelay: 300,
                      fadeTheme: FadeTheme.light,
                      baseColor: CRMColors.darkGrey,
                      highlightColor: CRMColors.darkGrey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
