import 'package:anon_chat/providers/chatroom.dart';
import 'package:anon_chat/providers/messages.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String chatRoomId;

  const ChatRoomScreen({super.key, required this.chatRoomId});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  void sendMessage() async {
    final repo = ref.read(repositoryProvider);

    final state = _formKey.currentState!;

    if (state.isValid) {
      state.save();
      final result = state.value;
      await repo.createMessage(
        roomId: widget.chatRoomId,
        content: result["content"],
      );
      // reset text field
      final textField = state.fields["content"]!;
      textField.didChange("");
      textField.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final response = ref.watch(chatRoomProvider(widget.chatRoomId));

    return response.when(
      data: (chatRoom) {
        return Scaffold(
          appBar: AppBar(
            title: Text(chatRoom.name),
            centerTitle: true,
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
                          validator: FormBuilderValidators.required(),
                          decoration: const InputDecoration(
                            hintText: "send a message",
                            border: InputBorder.none,
                            counterText: "",
                            errorStyle: TextStyle(),
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) {
                            // send message when enter is pressed
                            sendMessage();
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextFieldTapRegion(
                        child: IconButton(
                          onPressed: sendMessage,
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).colorScheme.primary,
                            size: 25.0,
                          ),
                        ),
                      )
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
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final messagesNotifier =
          ref.watch(messagesProvider(widget.chatRoomId).notifier);
      if (_controller.position.maxScrollExtent == _controller.offset) {
        messagesNotifier.loadMoreMessages();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final response = ref.watch(messagesProvider(widget.chatRoomId));
    return response.when(
      data: (result) {
        final messages = result.allMessages;

        return ListView.separated(
          reverse: true,
          controller: _controller,
          itemCount: messages.length + 1,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index < messages.length) {
              var message = messages[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 6.5,
                          backgroundImage: NetworkImage(
                            "https://api.dicebear.com/6.x/identicon/png?seed=${message.userId}",
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          message.userId,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(message.content),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateFormat.jm().format(message.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            } else if (result.pageInfo.hasNextPage) {
              return const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 32.0,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 10,
            );
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
