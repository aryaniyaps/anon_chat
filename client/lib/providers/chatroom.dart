import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatRoomProvider =
    FutureProvider.autoDispose.family<ChatRoom, String>((ref, roomId) async {
  // cancel the HTTP request if user leaves inbetween
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final repo = ref.read(repositoryProvider);

  final chatRoom = await repo.getChatRoom(
    roomId: roomId,
    cancelToken: cancelToken,
  );

  // cache the chatroom
  ref.keepAlive();
  return chatRoom;
});
