import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/models/paging.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatRoomsNotifier extends StateNotifier<AsyncValue<List<ChatRoom>>> {
  ChatRoomsNotifier({required this.ref, required this.search})
      : super(const AsyncLoading()) {
    // load initial chatrooms
    loadChatRooms();
  }

  final Ref ref;

  final String? search;

  PageInfo pageInfo = PageInfo(
    hasNextPage: true,
    cursor: null,
  );

  void reset() {
    pageInfo = PageInfo(hasNextPage: true, cursor: null);
    state = const AsyncLoading();
  }

  Future<void> loadChatRooms() async {
    // cancel the HTTP request if user leaves inbetween
    final cancelToken = CancelToken();

    // ref.onDispose(cancelToken.cancel);

    if (pageInfo.hasNextPage) {
      final repo = ref.read(repositoryProvider);

      final result = await repo.getChatRooms(
        cancelToken: cancelToken,
        search: search,
        before: pageInfo.cursor,
      );

      // update page info
      pageInfo = result.pageInfo;

      state = AsyncValue.data(result.entities);
    }
  }

  void addChatRoom(ChatRoom chatRoom) {
    final value = state.requireValue;
    state = AsyncValue.data([chatRoom, ...value]);
  }
}

final chatRoomsProvider = StateNotifierProvider.autoDispose<ChatRoomsNotifier,
    AsyncValue<List<ChatRoom>>>((ref) {
  final search = ref.watch(searchTextProvider);
  return ChatRoomsNotifier(ref: ref, search: search);
});

final searchTextProvider = StateProvider<String?>((ref) => null);
