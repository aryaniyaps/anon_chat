import 'package:anon_chat/core/api_client.dart';
import 'package:anon_chat/models/chatroom.dart';
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
      body: const ChatRoomList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChatRoomList extends StatefulWidget {
  const ChatRoomList({super.key});

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  List<ChatRoom> _chatRooms = [];

  @override
  void initState() {
    super.initState();
    loadChatRooms();
  }

  void loadChatRooms() async {
    var result = await client.getChatRooms();
    setState(() {
      _chatRooms = result;
    });
  }

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
