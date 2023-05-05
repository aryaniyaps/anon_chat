import 'package:anon_chat/models/message.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:anon_chat/providers/ws_channel.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagesProvider =
    StreamProvider.family<List<Message>, String>((ref, id) async* {
  // cancel the HTTP request if user leaves inbetween
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);

  final repo = ref.watch(repositoryProvider);

  final channel = ref.watch(wsChannelProvider);

  var messages = await repo.getMessages(
    roomId: id,
    cancelToken: cancelToken,
  );
  // return a stream of messages here

  // channel.stream.listen((message) {
  //   print(message);

  //   var content = jsonDecode(message);

  //   if (content["type"] == "messages:create") {
  //     // check if message belongs to the chatroom
  //     messages.add(
  //       Message.fromJson(
  //         content["data"],
  //       ),
  //     );
  //   }
  // });
  yield messages;
});
