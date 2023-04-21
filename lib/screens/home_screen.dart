import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anonymous chat"),
      ),
      body: ChatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChatRoom {
  String id;
  String name;
  DateTime createdAt;
  int onlineCount;

  ChatRoom({
    required this.name,
    required this.createdAt,
    required this.onlineCount,
    required this.id,
  });
}

class ChatRoomList extends StatelessWidget {
  ChatRoomList({super.key});

  final _chatRooms = <ChatRoom>[
    ChatRoom(
      name: "Chat Room 1",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      onlineCount: 2353,
      id: "1001",
    ),
    ChatRoom(
      name: "Chat Room 2",
      createdAt: DateTime(2023, 4, 21, 12, 30),
      onlineCount: 78123,
      id: "1002",
    ),
    ChatRoom(
      name: "Chat Room 3",
      createdAt: DateTime(2023, 4, 21, 10, 1),
      onlineCount: 435,
      id: "1003",
    ),
    ChatRoom(
      name: "Chat Room 4",
      createdAt: DateTime(2023, 4, 21, 8, 57),
      onlineCount: 5123,
      id: "1004",
    ),
    ChatRoom(
      name: "Chat Room 5",
      createdAt: DateTime(2023, 4, 21, 12, 24),
      onlineCount: 12,
      id: "1005",
    ),
    ChatRoom(
      name: "Chat Room 6",
      createdAt: DateTime(2023, 4, 21, 11, 3),
      onlineCount: 1876,
      id: "1006",
    ),
    ChatRoom(
      name: "Chat Room 7",
      createdAt: DateTime(2023, 4, 21, 6, 31),
      onlineCount: 378,
      id: "1007",
    ),
    ChatRoom(
      name: "Chat Room 8",
      createdAt: DateTime(2023, 4, 21, 9, 43),
      onlineCount: 4322,
      id: "1008",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _chatRooms.length,
      itemBuilder: (context, index) {
        var chatRoom = _chatRooms[index];
        return InkWell(
          onTap: () {
            // navigate to chatroom screen
            context.push("/chatrooms/${chatRoom.id}");
          },
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            title: Text(chatRoom.name),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 20,
                child: Row(
                  children: [
                    Text(timeago.format(chatRoom.createdAt)),
                    const VerticalDivider(),
                    Text("${chatRoom.onlineCount.toString()} online")
                  ],
                ),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
