import 'package:anon_chat/models/chatroom.dart';
import 'package:socket_io_client/socket_io_client.dart';

class Repository {
  Repository() {
    // initialize socket
    _socket = io(
      const String.fromEnvironment("API_URL"),
      <String, dynamic>{
        "autoConnect": false,
        "transports": [
          "websocket",
        ],
      },
    );
    _socket.connect();
    _socket.onConnect((data) {
      print("connected");
    });
    _socket.onError((print));
  }

  late Socket _socket;

  void createChatRoom(String name) {
    _socket.emit(
      "chatrooms:create",
      {
        "name": name,
      },
    );
  }

  void joinChatRoom(String roomId) {
    _socket.emitWithAck(
      "chatrooms:join",
      {
        "roomId": roomId,
      },
    );
  }

  void leaveChatRoom(String roomId) {
    _socket.emit(
      "chatrooms:leave",
      {
        "roomId": roomId,
      },
    );
  }

  void listChatRooms() {
    _socket.emit(
      "chatrooms:list",
    );
  }

  ChatRoom getChatRoom(String roomId) {
    _socket.emit(
      "chatrooms:get",
      {
        "roomId": roomId,
      },
    );
    return ChatRoom(id: "id", name: "chatroom name", createdAt: DateTime.now());
  }

  void createMessage(String roomId, String content) {
    _socket.emit(
      "messages:create",
      {
        "roomId": roomId,
        "content": content,
      },
    );
  }

  void listMessages(String roomId) {
    _socket.emit(
      "messages:list",
      {
        "roomId": roomId,
      },
    );
  }
}

final repo = Repository();
