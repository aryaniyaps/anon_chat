import 'package:anon_chat/providers/chatroom.dart';
import 'package:anon_chat/providers/messages.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String chatRoomId;

  const ChatRoomScreen({super.key, required this.chatRoomId});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    // clean up controller
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    final repo = ref.watch(repositoryProvider);
    await repo.createMessage(
      roomId: widget.chatRoomId,
      content: _messageController.value.text,
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final response = ref.watch(chatRoomProvider(widget.chatRoomId));
    return response.when(
      data: (chatRoom) {
        return Scaffold(
          appBar: AppBar(
            title: Text(chatRoom.name),
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
                  chatRoomId: widget.chatRoomId,
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
      },
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class MessageList extends ConsumerStatefulWidget {
  final String chatRoomId;

  const MessageList({super.key, required this.chatRoomId});

  @override
  ConsumerState<MessageList> createState() => _MessageListState();
}

class _MessageListState extends ConsumerState<MessageList> {
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
    final response = ref.watch(messagesProvider(widget.chatRoomId));

    return response.when(
      data: (messages) {
        return ListView.separated(
          controller: _scrollController,
          itemCount: messages.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            var message = messages[index];
            return ListTile(
              title: Text(message.content),
              subtitle: Text(
                timeago.format(message.createdAt),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
        );
      },
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
