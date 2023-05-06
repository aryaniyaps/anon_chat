import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomsNotifier extends StateNotifier<AsyncValue<List<ChatRoom>>> {
  ChatRoomsNotifier({required this.ref}) : super(const AsyncLoading()) {
    // load initial chatrooms
    loadChatRooms();
  }

  final Ref ref;

  Future<void> loadChatRooms({int? take, String? after}) async {
    // cancel the HTTP request if user leaves inbetween
    final cancelToken = CancelToken();

    ref.onDispose(cancelToken.cancel);

    final repo = ref.read(repositoryProvider);
    final result = await repo.getChatRooms(
      take: take,
      after: after,
      cancelToken: cancelToken,
    );
    state = AsyncValue.data(result.data);
  }

  void addChatRoom(ChatRoom chatRoom) {
    state = AsyncValue.data([chatRoom, ...state.requireValue]);
  }
}

final chatRoomsProvider = StateNotifierProvider.autoDispose<ChatRoomsNotifier,
    AsyncValue<List<ChatRoom>>>((ref) {
  return ChatRoomsNotifier(ref: ref);
});
