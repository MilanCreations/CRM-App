import 'dart:io';
import 'package:crm_milan_creations/Chat%20App/Controller/chatInboxHistoryController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:crm_milan_creations/Chat%20App/Controller/chatController.dart';
import 'package:crm_milan_creations/Chat%20App/Model/chatModel.dart';
import 'package:crm_milan_creations/Chat%20App/Socket%20Services/socketController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String peerId;
  final String selectedname;
  final String username;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.peerId,
    required this.selectedname,
    required this.username,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = Get.put(ChatController());
  final socketController = Get.put(Socketcontroller());
  final TextEditingController msgCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Chatinboxhistorycontroller chatinboxhistorycontroller = Get.put(Chatinboxhistorycontroller());
  File? selectedFile;

  @override
  void initState() {
    super.initState();
    socketController.initSocket(widget.userId, widget.username);
    chatController.initListeners(widget.userId, widget.peerId);

    chatController.messages.listen((_){
      Future.delayed(Duration(milliseconds: 100),(){
        if(_scrollController.hasClients){
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        }
      });
    });

  }

  void sendMessage() {
    if (msgCtrl.text.trim().isEmpty && selectedFile == null) return;

    chatController.sendMessage(
      fromId: widget.userId,
      fromName: widget.username,
      toId: widget.peerId,
      message: msgCtrl.text.trim(),
      selectedFile: selectedFile,
      recievername: widget.selectedname
    );

    msgCtrl.clear();
    setState(() => selectedFile = null);

    Future.delayed(Duration(milliseconds: 100),(){
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });


  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      setState(() => selectedFile = File(result.files.single.path!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        title: CustomText(
          text: widget.username,
          fontSize: 18,
          color: CRMColors.white,
        ),
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        actions: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                socketController.isConnected.value ? Icons.wifi : Icons.wifi_off,
                color: socketController.isConnected.value ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(10),
                controller: _scrollController,
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final ChatMessage msg = chatController.messages[index];
                  final isMe = msg.isSentByMe;

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blueAccent : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          if (msg.message.isNotEmpty)
                            Text(
                              msg.message,
                              style: TextStyle(color: isMe ? Colors.white : Colors.black87),
                            ),
                          if (msg.file != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                children: [
                                  Icon(Icons.attach_file, color: isMe ? Colors.white : Colors.black87),
                                  Text(
                                    '📎 Attachment',
                                    style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (selectedFile != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      selectedFile!.path.split('/').last,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => selectedFile = null),
                  )
                ],
              ),
            ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.attach_file), onPressed: pickFile),
                Expanded(
                  child: TextField(
                    controller: msgCtrl,
                    decoration: const InputDecoration(hintText: 'Type your message...'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
