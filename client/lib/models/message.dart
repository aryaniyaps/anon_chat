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
