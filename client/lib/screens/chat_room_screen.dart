import 'package:anon_chat/core/api_client.dart';
import 'package:anon_chat/models/message.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../models/chatroom.dart';

class ChatRoomScreen extends StatefulWidget {
  final String chatRoomId;

  const ChatRoomScreen({super.key, required this.chatRoomId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  ChatRoom? _chatRoom;

  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadChatRoom();
  }

  @override
  void dispose() {
    // clean up controller
    _messageController.dispose();
    super.dispose();
  }

  void loadChatRoom() async {
    var result = await client.getChatRoom(roomId: widget.chatRoomId);
    setState(() {
      _chatRoom = result;
    });
  }

  void sendMessage() async {
    await client.createMessage(
      roomId: _chatRoom!.id,
      content: _messageController.value.toString(),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_chatRoom == null) {
      return const Scaffold(
        body: Center(
          child: Text("loading room."),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(_chatRoom!.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // leave chatroom with ID
            context.pop();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageList(
              key: widget.key,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: sendMessage,
                  // remove shadow
                  elevation: 0,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final _messages = <Message>[];

  late ScrollController _scrollController;

  @override
  void initState() {
    // setup scroll controller
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    // dispose scroll controller
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    final bottomOffset = _scrollController.position.maxScrollExtent;
    _scrollController.animateTo(
      bottomOffset,
      duration: const Duration(microseconds: 1024),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      itemCount: _messages.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        var message = _messages[index];
        return ListTile(
          title: Text(message.content),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 20,
              child: Row(
                children: [
                  Text(message.ownerId),
                  const VerticalDivider(),
                  Text(timeago.format(message.createdAt)),
                ],
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
