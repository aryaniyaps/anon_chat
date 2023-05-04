import 'package:anon_chat/models/message.dart';
import 'package:anon_chat/providers/ws_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider = StreamProvider<List<Message>>((ref) async* {
  final channel = ref.watch(wsChannelProvider);
  // return a stream of messages here

  // wsClient.socket.on("messages:create", (data) {
  //   log("message created");
  //   log(data);
  // });
});
