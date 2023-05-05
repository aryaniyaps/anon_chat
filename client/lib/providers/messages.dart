import 'package:anon_chat/models/message.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessagesNotifier extends StateNotifier<List<Message>> {
  MessagesNotifier({
    required this.ref,
    required this.chatRoomId,
  }) : super([]) {
    loadMessages();
  }

  final Ref ref;

  final String chatRoomId;

  Future<void> loadMessages() async {
    // cancel the HTTP request if user leaves inbetween
    final cancelToken = CancelToken();

    ref.onDispose(cancelToken.cancel);

    final repo = ref.read(repositoryProvider);
    state = await repo.getMessages(
      cancelToken: cancelToken,
      roomId: chatRoomId,
    );
  }

  void addMessage(Message message) {
    state = [...state, message];
  }
}

final messagesProvider =
    StateNotifierProvider.family<MessagesNotifier, List<Message>, String>(
        (ref, id) {
  return MessagesNotifier(ref: ref, chatRoomId: id);
});
