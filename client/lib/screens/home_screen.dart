import 'package:anon_chat/models/chatroom.dart';
import 'package:anon_chat/repository.dart';
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

class ChatRoomList extends StatelessWidget {
  ChatRoomList({super.key});

  final _chatRooms = <ChatRoom>[
    ChatRoom(
      name: "Chat Room 1",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      id: "1001",
    ),
    ChatRoom(
      name: "Chat Room 2",
      createdAt: DateTime(2023, 4, 21, 12, 30),
      id: "1002",
    ),
    ChatRoom(
      name: "Chat Room 3",
      createdAt: DateTime(2023, 4, 21, 10, 1),
      id: "1003",
    ),
    ChatRoom(
      name: "Chat Room 4",
      createdAt: DateTime(2023, 4, 21, 8, 57),
      id: "1004",
    ),
    ChatRoom(
      name: "Chat Room 5",
      createdAt: DateTime(2023, 4, 21, 12, 24),
      id: "1005",
    ),
    ChatRoom(
      name: "Chat Room 6",
      createdAt: DateTime(2023, 4, 21, 11, 3),
      id: "1006",
    ),
    ChatRoom(
      name: "Chat Room 7",
      createdAt: DateTime(2023, 4, 21, 6, 31),
      id: "1007",
    ),
    ChatRoom(
      name: "Chat Room 8",
      createdAt: DateTime(2023, 4, 21, 9, 43),
      id: "1008",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_chatRooms.isEmpty) {
      return const Center(
        child: Text("no rooms created."),
      );
    }
    return ListView.separated(
      itemCount: _chatRooms.length,
      itemBuilder: (context, index) {
        var chatRoom = _chatRooms[index];
        return InkWell(
          onTap: () {
            // join chatroom with ID
            repo.createChatRoom(chatRoom.id);
            context.push("/chatrooms/${chatRoom.id}");
          },
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            title: Text(chatRoom.name),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "created ${timeago.format(chatRoom.createdAt)}",
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
