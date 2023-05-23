import 'package:anon_chat/models/message.dart';
import 'package:anon_chat/models/paging.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesNotifier extends StateNotifier<AsyncValue<List<Message>>> {
  MessagesNotifier({
    required this.ref,
    required this.chatRoomId,
  }) : super(const AsyncLoading()) {
    // load initial messages
    loadMessages();
  }

  final Ref ref;

  PageInfo pageInfo = PageInfo(
    hasNextPage: true,
    cursor: null,
  );

  final String chatRoomId;

  Future<void> loadMessages({int? limit}) async {
    // cancel the HTTP request if user leaves inbetween
    final cancelToken = CancelToken();

    ref.onDispose(cancelToken.cancel);
    if (pageInfo.hasNextPage) {
      final repo = ref.read(repositoryProvider);

      final result = await repo.getMessages(
        cancelToken: cancelToken,
        roomId: chatRoomId,
        limit: limit,
        before: pageInfo.cursor,
      );

      // update page info
      pageInfo = result.pageInfo;

      state = AsyncValue.data(result.entities);
    }
  }

  void addMessage(Message message) {
    final value = state.requireValue;
    state = AsyncValue.data([message, ...value]);
  }
}

final messagesProvider = StateNotifierProvider.family<MessagesNotifier,
    AsyncValue<List<Message>>, String>((ref, id) {
  return MessagesNotifier(ref: ref, chatRoomId: id);
});
