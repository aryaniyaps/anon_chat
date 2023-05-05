import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/models/message.dart';
import 'package:dio/dio.dart';

class Repository {
  final _dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        "API_URL",
      ),
    ),
  );

  Future<ChatRoom> getChatRoom({
    required String roomId,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.get(
      "/chatrooms/$roomId",
      cancelToken: cancelToken,
    );
    return ChatRoom.fromJson(response.data);
  }

  Future<List<ChatRoom>> getChatRooms({
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.get(
      "/chatrooms",
      cancelToken: cancelToken,
    );
    return List<ChatRoom>.from(
      response.data.map(
        (item) => ChatRoom.fromJson(item),
      ),
    );
  }

  Future<List<Message>> getMessages({
    required String roomId,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.get(
      "/chatrooms/$roomId/messages",
      cancelToken: cancelToken,
    );
    return List<Message>.from(
      response.data.map(
        (item) => Message.fromJson(item),
      ),
    );
  }

  Future<ChatRoom> createChatRoom({
    required String name,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.post(
      "/chatrooms",
      data: {
        "name": name,
      },
      cancelToken: cancelToken,
    );
    return ChatRoom.fromJson(response.data);
  }

  Future<Message> createMessage({
    required String roomId,
    required String content,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.post(
      "/chatrooms/$roomId/messages",
      data: {
        "content": content,
      },
      cancelToken: cancelToken,
    );
    return Message.fromJson(response.data);
  }
}
