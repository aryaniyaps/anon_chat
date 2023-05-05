import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomsNotifier extends StateNotifier<List<ChatRoom>> {
  ChatRoomsNotifier({required this.ref}) : super([]) {
    loadChatRooms();
  }

  final Ref ref;

  Future<void> loadChatRooms() async {
    // cancel the HTTP request if user leaves inbetween
    final cancelToken = CancelToken();

    ref.onDispose(cancelToken.cancel);

    final repo = ref.read(repositoryProvider);
    state = await repo.getChatRooms(cancelToken: cancelToken);
  }

  void addChatRoom(ChatRoom chatRoom) {
    state = [...state, chatRoom];
  }
}

final chatRoomsProvider =
    StateNotifierProvider.autoDispose<ChatRoomsNotifier, List<ChatRoom>>((ref) {
  return ChatRoomsNotifier(ref: ref);
});
