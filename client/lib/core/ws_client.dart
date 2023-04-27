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

  void connect() {
    _socket.connect();
    _socket.onConnect(
      (data) {
        print("connected to websocket server.");
      },
    );
    _socket.onError(
      (error) {
        print(error.toString());
      },
    );
  }

  void disconnect() {
    _socket.disconnect();
  }
}
