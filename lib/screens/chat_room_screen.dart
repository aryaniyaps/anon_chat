import 'package:flutter/material.dart';

class ChatRoomScreen extends StatelessWidget {
  final String chatRoomId;
  const ChatRoomScreen({super.key, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat room title"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline))
        ],
      ),
      body: Stack(
        children: [MessageList(), TextField()],
      ),
    );
  }
}

class MessageList extends StatelessWidget {
  const MessageList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
