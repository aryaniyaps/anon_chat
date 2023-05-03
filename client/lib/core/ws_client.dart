import 'package:socket_io_client/socket_io_client.dart';

class WSClient {
  final _socket = io(
    const String.fromEnvironment("API_URL"),
    <String, dynamic>{
      "autoConnect": false,
      "transports": [
        "websockets",
      ],
    },
  );

  WSClient() {
    _socket.connect();
    _socket.onConnect(
      (_) {
        print("connected to websocket server.");
      },
    );
  }

  void disconnect() {
    _socket.disconnect();
  }
}

final wsClient = WSClient();
