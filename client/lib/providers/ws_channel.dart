import 'dart:convert';

import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/models/message.dart';
import 'package:anon_chat/providers/chatrooms.dart';
import 'package:anon_chat/providers/messages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final wsChannelProvider = Provider<WebSocketChannel>((ref) {
  var channel = WebSocketChannel.connect(
    Uri.parse(
      const String.fromEnvironment("WS_URL"),
    ),
  );

  final chatRoomsNotifier = ref.read(chatRoomsProvider.notifier);

  channel.stream.listen((message) {
    var content = jsonDecode(message);

    switch (content["type"]) {
      case "chatrooms:create":
        // add chatroom
        chatRoomsNotifier.addChatRoom(
          ChatRoom.fromJson(
            content["data"],
          ),
        );
        break;
      case "messages:create":
        // add message
        var roomId = content["data"]["chatRoomId"];
        ref.read(messagesProvider(roomId).notifier).addMessage(
              Message.fromJson(
                content["data"],
              ),
            );
        break;
    }
  });

  ref.onDispose(() {
    channel.sink.close();
  });

  return channel;
});
