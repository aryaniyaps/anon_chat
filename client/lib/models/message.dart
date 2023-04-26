class Message {
  String id;
  String content;
  DateTime createdAt;
  String ownerId;

  Message({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.ownerId,
  });
}
