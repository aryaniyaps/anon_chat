import 'package:anon_chat/models/paging.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatroom.g.dart';

@JsonSerializable()
class ChatRoom {
  String id;
  String name;
  DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return _$ChatRoomFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}

@JsonSerializable()
class ChatRoomsResponse {
  List<ChatRoom> entities;
  PageInfo pageInfo;

  ChatRoomsResponse({required this.entities, required this.pageInfo});

  factory ChatRoomsResponse.fromJson(Map<String, dynamic> json) {
    return _$ChatRoomsResponseFromJson(json);
  }
}
