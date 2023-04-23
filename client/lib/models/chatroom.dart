class ChatRoom {
  String id;
  String name;
  DateTime createdAt;
  int onlineCount;
  bool enabled;

  ChatRoom({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.onlineCount,
    required this.enabled,
  });
}
