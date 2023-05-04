import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final wsChannelProvider = Provider<WebSocketChannel>((ref) {
  var channel = WebSocketChannel.connect(
    Uri.parse(
      const String.fromEnvironment("WS_URL"),
    ),
  );

  ref.onDispose(() {
    channel.sink.close();
  });

  return channel;
});
