import 'package:anon_chat/models/message.dart';
import 'package:anon_chat/models/paging.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesState {
  List<Message> allMessages;
  PageInfo pageInfo;

  MessagesState({
    required this.allMessages,
    required this.pageInfo,
  });
}

class MessagesNotifier extends StateNotifier<AsyncValue<MessagesState>> {
  MessagesNotifier({
    required this.ref,
    required this.chatRoomId,
  }) : super(const AsyncLoading()) {
    // load initial messages
    loadInitialMessages();
  }

  final Ref ref;

  final String chatRoomId;

  Future<void> loadInitialMessages({int? limit}) async {
    // cancel the HTTP request if user leaves inbetween
    final cancelToken = CancelToken();

    ref.onDispose(cancelToken.cancel);

    final repo = ref.read(repositoryProvider);
    final result = await repo.getMessages(
      cancelToken: cancelToken,
      roomId: chatRoomId,
      limit: limit,
    );
    state = AsyncValue.data(
      MessagesState(
        allMessages: result.entities,
        pageInfo: result.pageInfo,
      ),
    );
  }

  Future<void> loadMoreMessages({int? take}) async {
    print("LOADING MORE MESSAGES");
    final value = state.requireValue;

    print(value.pageInfo.hasNextPage);

    if (value.pageInfo.hasNextPage) {
      // cancel the HTTP request if user leaves inbetween
      final cancelToken = CancelToken();

      ref.onDispose(cancelToken.cancel);

      final repo = ref.read(repositoryProvider);

      final result = await repo.getMessages(
        roomId: chatRoomId,
        limit: take,
        before: value.pageInfo.cursor,
        cancelToken: cancelToken,
      );

      state = AsyncValue.data(
        MessagesState(
          allMessages: [...value.allMessages, ...result.entities],
          pageInfo: result.pageInfo,
        ),
      );
    }
  }

  void addMessage(Message message) {
    final value = state.requireValue;
    state = AsyncValue.data(
      MessagesState(
        allMessages: [message, ...value.allMessages],
        pageInfo: value.pageInfo,
      ),
    );
  }
}

final messagesProvider = StateNotifierProvider.family<MessagesNotifier,
    AsyncValue<MessagesState>, String>((ref, id) {
  return MessagesNotifier(ref: ref, chatRoomId: id);
});
