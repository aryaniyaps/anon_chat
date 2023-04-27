import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/models/message.dart';
import 'package:dio/dio.dart';

class HTTPClient {
  final _dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        "API_URL",
      ),
    ),
  );

  Future<ChatRoom> getChatRoom({required String roomId}) async {
    var response = await _dio.get(
      "/chatrooms/$roomId",
    );
    return ChatRoom.fromJson(response.data);
  }

  Future<List<ChatRoom>> getChatRooms() async {
    var response = await _dio.get(
      "/chatrooms",
    );
    return List<ChatRoom>.from(
      response.data.map(
        (item) => ChatRoom.fromJson(item),
      ),
    );
  }

  Future<ChatRoom> createChatRoom({required String name}) async {
    var response = await _dio.post(
      "/chatrooms",
      data: {
        "name": name,
      },
    );
    return ChatRoom.fromJson(response.data);
  }

  Future<Message> createMessage({
    required String roomId,
    required String content,
  }) async {
    var response = await _dio.post(
      "/chatrooms/$roomId/messages",
      data: {
        "content": content,
      },
    );
    return Message.fromJson(response.data);
  }
}

final httpClient = HTTPClient();
