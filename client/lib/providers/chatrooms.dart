import 'dart:convert';

import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:anon_chat/providers/ws_channel.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomsProvider = StreamProvider<List<ChatRoom>>((ref) async* {
  // cancel the HTTP request if user leaves inbetween
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final repo = ref.watch(repositoryProvider);

  final channel = ref.watch(wsChannelProvider);

  var chatRooms = await repo.getChatRooms(cancelToken: cancelToken);

  channel.stream.listen((message) {
    print(message);

    var content = jsonDecode(message);

    if (content["type"] == "chatrooms:create") {
      chatRooms.add(
        ChatRoom.fromJson(
          content["data"],
        ),
      );
    }
  });

  yield chatRooms;
});
