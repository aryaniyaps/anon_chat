class Message {
  String id;
  String content;
  DateTime createdAt;
  String sentBy;

  Message({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.sentBy,
  });
}
