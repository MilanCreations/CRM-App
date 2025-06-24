import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

class Socketcontroller extends GetxService {          // ① make it a Service
  IO.Socket? socket;
  final RxBool isConnected = false.obs;
  String? userId;




  // Call this once after login
  void initSocket(String id) {
    userId = id;
    if (socket != null && socket!.connected) return;  // already connected

    socket = IO.io(
      'http://192.168.1.36:3000',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,                          // ② correct key-name
      },
    );

    socket!
      ..connect()
      ..on('connect', (_) {
        isConnected.value = true;
        print('✅ socket connected');
        socket!.emit('setUserId', userId);
      })
      ..on('disconnect', (_) {                        // add disconnect handler
        isConnected.value = false;
        print('❌ socket disconnected');
        _reconnect();
      })
      ..on('connect_error', (err) {
        isConnected.value = false;
        print('⚠️ connect_error: $err');
        _reconnect();
      });
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!isConnected.value && userId != null) {
        print('🔁 reconnecting…');
        initSocket(userId!);
      }
    });
  }

  void sendMessage(String toUserId, String message) =>
      socket?.emit('sendMessage', {'to': toUserId, 'message': message});
}
