class ChatRoom {
  String id;
  String name;
  DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  static ChatRoom fromJSON(data) {
    return ChatRoom(
      id: data.id,
      name: data.name,
      createdAt: data.createdAt,
    );
  }
}
