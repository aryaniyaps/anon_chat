import 'package:anon_chat/models/paging.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  String id;
  String content;
  DateTime createdAt;
  String userId;
  String chatRoomId;

  Message({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.chatRoomId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return _$MessageFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

@JsonSerializable()
class MessagesResponse {
  List<Message> entities;
  PageInfo pageInfo;

  MessagesResponse({required this.entities, required this.pageInfo});

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    return _$MessagesResponseFromJson(json);
  }
}
