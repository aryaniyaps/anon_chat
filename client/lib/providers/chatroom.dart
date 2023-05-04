import 'package:anon_chat/core/http_client.dart';
import 'package:anon_chat/models/chatroom.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomProvider =
    FutureProvider.family<ChatRoom, String>((ref, roomId) async {
  return await httpClient.getChatRoom(roomId: roomId);
});
