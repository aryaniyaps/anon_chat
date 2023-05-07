import 'package:anon_chat/models/message.dart';
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

  final String chatRoomId;

  Future<void> loadMessages({int? limit, String? before}) async {
    // cancel the HTTP request if user leaves inbetween
    final cancelToken = CancelToken();

    ref.onDispose(cancelToken.cancel);

    final repo = ref.read(repositoryProvider);
    final result = await repo.getMessages(
      cancelToken: cancelToken,
      roomId: chatRoomId,
      limit: limit,
      before: before,
    );
    state = AsyncValue.data(result.entities);
  }

  void addMessage(Message message) {
    state = AsyncValue.data([message, ...state.requireValue]);
  }
}

final messagesProvider = StateNotifierProvider.family<MessagesNotifier,
    AsyncValue<List<Message>>, String>((ref, id) {
  return MessagesNotifier(ref: ref, chatRoomId: id);
});
