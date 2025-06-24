import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;
  String? _userId; 

  void connect({
    required String userId,
    required Function(String title, String message) onNotification,
    required Function(String log) onLog,   
  }) {
    _userId = userId;

    if (_isConnected && _socket?.connected == true) {
      onLog("⚠️ Socket already connected.");
      return;
    }

    if (_socket != null && !_socket!.connected) {
      onLog("🔄 Socket exists but not connected. Reconnecting...");
      _socket!.connect();

      // ✅ Re-register listeners on manual connect
      _registerListeners(onNotification, onLog);
      return;
    }

    onLog("👤 User ID set: $_userId");

    _socket = IO.io(
      'http://192.168.1.17:3000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'forceNew': false,
      },
    );

    _registerListeners(onNotification, onLog);
    _socket!.connect();
  }

  void _registerListeners(
    Function(String title, String message) onNotification,
    Function(String log) onLog,
  ) {
    _socket!.onConnect((_) {
      _isConnected = true;
      onLog("✅ Connected to server with ID: ${_socket!.id}");
      _socket!.emit('register', _userId);
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      onLog("❌ Disconnected from server");
    });

    _socket!.onConnectError((err) {
      _isConnected = false;
      onLog("⚠️ Connection Error: $err");
    });

    _socket!.onError((err) {
      _isConnected = false;
      onLog("❌ Socket error: $err");
    });

    _socket!.on('notification', (data) {
      String title = "Notification";
      String message = "";

      if (data is List && data.length >= 2) {
        title = data[0].toString();
        message = data[1].toString();
      } else if (data is Map) {
        title = data['title']?.toString() ?? "Notification";
        message = data['message']?.toString() ?? data.toString();
      } else {
        message = data.toString();
      }

      onNotification(title, message);
    });
  }

  void disconnect() {
    if (_socket != null && _socket!.connected) {
      _socket!.disconnect();
      _socket!.dispose();
      print("✅ Socket disconnected successfully.");
    } else {
      print("🔌 Socket already disconnected or null.");
    }
    _isConnected = false;
  }

  bool isConnected() => _isConnected;
}
