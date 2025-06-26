import 'dart:io';
import 'package:get/get.dart';
import 'package:crm_milan_creations/Chat%20App/Model/chatModel.dart';
import 'package:crm_milan_creations/Chat%20App/Socket%20Services/socketController.dart';
import 'package:crm_milan_creations/Chat%20App/Controller/chatInboxHistoryController.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final Socketcontroller socketService = Get.find<Socketcontroller>();
  final Chatinboxhistorycontroller chatHistory = Get.put(Chatinboxhistorycontroller());

  /// Parses timestamp from API/socket
  DateTime _parseTimestamp(dynamic rawTimestamp) {
    if (rawTimestamp == null) return DateTime.now();

    if (rawTimestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(rawTimestamp);
    }

    if (rawTimestamp is String) {
      try {
        return DateTime.parse(rawTimestamp);
      } catch (_) {
        return DateTime.now();
      }
    }

    return DateTime.now();
  }

  /// Load previous messages from API
  Future<void> loadChatHistory(String currentUserId, String peerId)async {
    await chatHistory.messagesListFunction(isRefresh: true, peerId: peerId);

    for (var item in chatHistory.messageList) {
      messages.add(ChatMessage(
        id: item.id?.toString() ?? '',
        from: item.senderId?.toString() ?? '',
        to: item.receiverId?.toString() ?? '',
        fromName: item.senderId?.toString() ?? '',
        message: item.message ?? '',
        // file: item.file,
        timestamp: _parseTimestamp(item.createdAt),
        isSentByMe: item.senderId?.toString() == currentUserId,
        status: 'delivered',
      ));
    }
  }

  /// Setup listener for new messages via socket
  void initListeners(String currentUserId, String peerId) {
    loadChatHistory(currentUserId,peerId); // Load history first

    final socket = socketService.socket;

    if (socket != null) {
      socket.off('privateMessage');

      socket.on('privateMessage', (data) {
        print('📥 Received socket message: $data');

        try {
          if (data is! Map) {
            print('⚠️ Message is not a valid map.');
            return;
          }

          final receivedMsg = ChatMessage(
            id: data['id'] ?? '',
            from: data['sender_id']?.toString() ?? '',
            to: data['receiver_id']?.toString() ?? '',
            fromName: data['username']?.toString() ?? '',
            message: data['message']?.toString() ?? '',
            file: data['file']?.toString(),
            timestamp: _parseTimestamp(data['timestamp']),
            isSentByMe: false,
            status: data['status']?.toString() ?? 'received',
          );

          if (receivedMsg.to == currentUserId) {
            messages.add(receivedMsg);
            print('✅ Message added from ${receivedMsg.from}');

            if (data['id'] != null) {
              socket.emit('acknowledgeMessage', {'messageId': data['id']});
              print('📨 ACK sent for message ID: ${data['id']}');
            }
          } else {
            print('⛔ Message not intended for current user.');
          }
        } catch (e, stackTrace) {
          print('❌ Error handling message: $e\n$stackTrace');
        }
      });
    }
  }

  /// Send message through socket
  void sendMessage({
    required String fromId,
    required String fromName,
    required String toId,
    String? message,
    File? selectedFile,
    required String recievername,
  }) {
    final socket = socketService.socket;
    if (socket == null) return;

    final String tempId = DateTime.now().millisecondsSinceEpoch.toString();

    final newMessagePayload = {
      'id': tempId,
      'sender_id': fromId,
      'username': recievername,
      'receiver_id': toId,
      'status': 'sent',
      'timestamp': DateTime.now().toIso8601String(),
      if (message != null && message.trim().isNotEmpty)
        'message': message.trim(),
      if (selectedFile != null)
        'file': selectedFile.path,
    };

    messages.add(
      ChatMessage(
        id: tempId,
        from: fromId,
        to: toId,
        fromName: fromName,
        message: message ?? '',
        file: selectedFile?.path,
        timestamp: DateTime.now(),
        isSentByMe: true,
        status: 'sent',
      ),
    );

    socket.emit('privateMessage', newMessagePayload);
  }
}
