import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';

class Socketcontroller extends GetxService {          // ① make it a Service
  IO.Socket? socket;
  final RxBool isConnected = false.obs;
  String? userId ;
  String? username;
 
  // Call this once after login
  void initSocket(String id, String name) {
    userId=id;
    username=name;
    if (socket != null && socket!.connected) return;  // already connected
    var url = "https://crm.venusstudies.com";
    socket = IO.io(
      url,
      IO.OptionBuilder()
       .setQuery({'userId': id, 'username':name})
        .setTransports(['websocket'])
        .setPath('/socket.io')
        .build()
    );

    socket!
      ..connect()
      ..on('connect', (_) {
        isConnected.value = true;
        print('✅ socket connected');
         print('My Socket ID: ${socket?.id}');
        socket!.emit('userId', userId);
      })

      
      ..on('disconnect', (_) {                        // add disconnect handler
        isConnected.value = false;
        print('❌ socket disconnected');
        _reconnect();
      })
      ..on('connect_error', (err) {
        isConnected.value = false;
        print('⚠️ connect_error: $err');
        // _reconnect();
      });
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!isConnected.value && userId != null) {
        print('🔁 reconnecting…');
        initSocket(userId!,username!);
      }
    });
  }

}
