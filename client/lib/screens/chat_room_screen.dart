import 'package:anon_chat/providers/chatroom.dart';
import 'package:anon_chat/providers/messages.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final response = ref.watch(chatRoomProvider(widget.chatRoomId));
    final repo = ref.watch(repositoryProvider);
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
              FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: "content",
                          maxLength: 250,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: "send a message",
                            border: InputBorder.none,
                            counterText: "",
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      FloatingActionButton(
                        onPressed: () async {
                          if (_formKey.currentState!.saveAndValidate()) {
                            var result = _formKey.currentState!.value;
                            var content = result["content"];
                            if (content != null) {
                              // todo: disable button instead when content is empty
                              await repo.createMessage(
                                roomId: widget.chatRoomId,
                                content: result["content"],
                              );
                            }
                            // reset text field
                            _formKey.currentState!.fields["content"]?.reset();
                          }
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
              )
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
  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider(widget.chatRoomId));
    return ListView.separated(
      reverse: true,
      itemCount: messages.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final reversedIndex = messages.length - 1 - index;
        var message = messages[reversedIndex];
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
  }
}
