import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/models/message.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class Repository {
  late final Dio _dio;

  Repository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment(
          "API_URL",
        ),
      ),
    );

    // add cookie manager
    getApplicationDocumentsDirectory().then((docsDir) {
      _dio.interceptors.add(
        CookieManager(
          PersistCookieJar(
            ignoreExpires: true,
            storage: FileStorage(
              "${docsDir.path}/.cookies/",
            ),
          ),
        ),
      );
    });
  }

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

  Future<ChatRoomsResponse> getChatRooms({
    String? before,
    int? limit,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.get(
      "/chatrooms",
      cancelToken: cancelToken,
      queryParameters: {
        "limit": limit,
        "before": before,
      },
    );
    return ChatRoomsResponse.fromJson(response.data);
  }

  Future<MessagesResponse> getMessages({
    required String roomId,
    String? before,
    int? limit,
    CancelToken? cancelToken,
  }) async {
    var response = await _dio.get(
      "/chatrooms/$roomId/messages",
      cancelToken: cancelToken,
      queryParameters: {
        "limit": limit,
        "before": before,
      },
    );
    return MessagesResponse.fromJson(response.data);
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
