import 'dart:convert';

import 'package:anon_chat/models/message.dart';
import 'package:anon_chat/providers/messages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

final wsChannelProvider = Provider<void>((ref) {
  var channel = WebSocketChannel.connect(
    Uri.parse(
      const String.fromEnvironment("WS_URL"),
    ),
  );

  channel.stream.listen((message) {
    var content = jsonDecode(message);

    switch (content["type"]) {
      case "messages:create":
        // add message
        final roomId = content["data"]["chatRoomId"];

        final roomNotifier = ref.read(messagesProvider(roomId).notifier);

        roomNotifier.addMessage(
          Message.fromJson(
            content["data"],
          ),
        );
        break;
    }
  });

  ref.onDispose(() {
    channel.sink.close(status.goingAway);
  });
});
