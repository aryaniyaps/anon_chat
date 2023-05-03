import 'dart:developer';

import 'package:anon_chat/core/ws_client.dart';
import 'package:anon_chat/models/chatroom.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomProvider = StreamProvider<List<ChatRoom>>((ref) async* {
  var chatRooms = <ChatRoom>[];

  wsClient.socket.onAny((event, data) {
    print(event);
    print(data);
  });

  wsClient.socket.on("chatrooms:create", (data) {
    print("chatroom created");
    log(data);

    chatRooms.add(ChatRoom.fromJson(data));
  });

  ref.onDispose(() {
    wsClient.disconnect();
  });

  yield chatRooms;
});
