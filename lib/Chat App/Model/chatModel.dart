class ChatMessage {
  final String id;
  final String from;
  final String to;
  final String fromName; // ✅ Add this
  final String message;
  final String? file;
  final DateTime timestamp;
  final bool isSentByMe;
  final String? status;

  ChatMessage({
    required this.id,
    required this.from,
    required this.to,
    required this.fromName,
    required this.message,
    required this.timestamp,
    required this.isSentByMe,
    this.file,
    this.status,
  });

  ChatMessage copyWith({
    String? id,
    String? status,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      from: from,
      to: to,
      fromName: fromName,
      message: message,
      file: file,
      timestamp: timestamp,
      isSentByMe: isSentByMe,
      status: status ?? this.status,
    );
  }
}
