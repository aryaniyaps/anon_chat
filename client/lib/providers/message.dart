import 'dart:developer';

import 'package:anon_chat/core/ws_client.dart';
import 'package:anon_chat/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider = StreamProvider<List<Message>>((ref) async* {
  wsClient.socket.on("messages:create", (data) {
    log("message created");
    log(data);
  });

  ref.onDispose(() {
    wsClient.disconnect();
  });
});
