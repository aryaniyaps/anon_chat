import 'package:anon_chat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomScreen extends StatefulWidget {
  final String chatRoomId;

  const ChatRoomScreen({super.key, required this.chatRoomId});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _chatRoom = ChatRoom(
    name: "Chat Room 1",
    createdAt: DateTime(2023, 4, 21, 12, 36),
    onlineCount: 2353,
    enabled: true,
    id: "1001",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 30,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_chatRoom.name),
              const VerticalDivider(),
              Text(
                "${_chatRoom.onlineCount} online",
                style: const TextStyle(fontSize: 16.0),
              )
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.people_sharp),
          )
        ],
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
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      border: InputBorder.none,
                    ),
                    enabled: _chatRoom.enabled,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () {
                    // scroll down the messageScrollController here
                  },
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

class MessageList extends StatefulWidget {
  MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final _messages = <Message>[
    Message(
      id: "1001",
      content: "message 1",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      sentBy: "username",
    ),
    Message(
      id: "1002",
      content: "message 2",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      sentBy: "username",
    ),
    Message(
      id: "1003",
      content: "message 3",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      sentBy: "username",
    ),
    Message(
      id: "1004",
      content: "message 4",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      sentBy: "username",
    ),
    Message(
      id: "1005",
      content: "message 5",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      sentBy: "username",
    ),
    Message(
      id: "1006",
      content: "message 6",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      sentBy: "username",
    ),
    Message(
      id: "1007",
      content: "message 7",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      sentBy: "username",
    ),
    Message(
      id: "1008",
      content: "message 8",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      sentBy: "username",
    ),
    Message(
      id: "1009",
      content: "message 9",
      createdAt: DateTime(2023, 4, 21, 12, 36),
      sentBy: "username",
    ),
  ];

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
                  Text(message.sentBy),
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