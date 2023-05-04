import 'dart:convert';

import 'package:anon_chat/core/http_client.dart';
import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/providers/ws_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomProvider = StreamProvider<List<ChatRoom>>((ref) async* {
  var chatRooms = await httpClient.getChatRooms();
  final channel = ref.watch(wsChannelProvider);

  channel.stream.listen((message) {
    print(message);

    var content = jsonDecode(message);
    print(content);
    print(content["data"]);
    // message.data doesn't exist!
    // print(message.data);
  });

  // wsClient.socket.on("chatrooms:create", (data) {
  //   print("chatroom created");
  //   log(data);

  //   chatRooms.add(ChatRoom.fromJson(data));
  // });

  yield chatRooms;
});
