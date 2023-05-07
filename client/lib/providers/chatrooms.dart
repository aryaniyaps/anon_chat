import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/models/paging.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomsState {
  List<ChatRoom> allChatRooms;
  PageInfo pageInfo;

  ChatRoomsState({
    required this.allChatRooms,
    required this.pageInfo,
  });
}

class ChatRoomsNotifier extends StateNotifier<AsyncValue<ChatRoomsState>> {
  ChatRoomsNotifier({required this.ref}) : super(const AsyncLoading()) {
    // load initial chatrooms
    loadInitialChatRooms();
  }

  final Ref ref;

  Future<void> loadInitialChatRooms({int? take}) async {
    // cancel the HTTP request if user leaves inbetween
    final cancelToken = CancelToken();

    ref.onDispose(cancelToken.cancel);

    final repo = ref.read(repositoryProvider);

    final result = await repo.getChatRooms(
      limit: take,
      cancelToken: cancelToken,
    );

    state = AsyncValue.data(
      ChatRoomsState(
        allChatRooms: result.entities,
        pageInfo: result.pageInfo,
      ),
    );
  }

  Future<void> loadMoreChatRooms({int? take}) async {
    final value = state.requireValue;

    if (value.pageInfo.hasNextPage) {
      // cancel the HTTP request if user leaves inbetween
      final cancelToken = CancelToken();

      ref.onDispose(cancelToken.cancel);

      final repo = ref.read(repositoryProvider);

      final result = await repo.getChatRooms(
        limit: take,
        before: value.pageInfo.cursor,
        cancelToken: cancelToken,
      );

      state = AsyncValue.data(
        ChatRoomsState(
          allChatRooms: [...value.allChatRooms, ...result.entities],
          pageInfo: result.pageInfo,
        ),
      );
    }
  }

  void addChatRoom(ChatRoom chatRoom) {
    final value = state.requireValue;
    state = AsyncValue.data(
      ChatRoomsState(
        allChatRooms: [chatRoom, ...value.allChatRooms],
        pageInfo: value.pageInfo,
      ),
    );
  }
}

final chatRoomsProvider = StateNotifierProvider.autoDispose<ChatRoomsNotifier,
    AsyncValue<ChatRoomsState>>((ref) {
  return ChatRoomsNotifier(ref: ref);
});
