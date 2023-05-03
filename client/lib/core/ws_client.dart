import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart';

class WSClient {
  final socket = io(
    const String.fromEnvironment("API_URL"),
    <String, dynamic>{
      "autoConnect": false,
      "transports": [
        "websockets",
      ],
    },
  );

  void connect() {
    socket.connect();
    socket.onConnect(
      (_) {
        log("connected to websocket server.");
      },
    );
  }

  void disconnect() {
    socket.disconnect();
  }
}

final wsClient = WSClient();
