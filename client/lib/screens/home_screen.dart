import 'package:anon_chat/providers/chatroom.dart';
import 'package:anon_chat/providers/chatrooms.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomsNotifier = ref.read(chatRoomsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            context.push("/chatroom");
          },
          child: const Text("Anonymous chat"),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () {
              context.push("/user-info");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: TextField(
                  maxLength: 50,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    hintText: "search chatrooms...",
                    border: InputBorder.none,
                    counterText: "",
                    suffixIcon: const Icon(
                      Icons.search,
                    ),
                  ),
                  onChanged: (value) {
                    // update chatroom search text
                    ref.read(searchTextProvider.notifier).state = value;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: RefreshIndicator(
              child: const ChatRoomList(),
              onRefresh: () async {
                chatRoomsNotifier.reset();
                chatRoomsNotifier.loadChatRooms();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: buildCreateRoomModal,
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChatRoomList extends ConsumerStatefulWidget {
  const ChatRoomList({super.key});

  @override
  ConsumerState<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends ConsumerState<ChatRoomList> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        ref.read(chatRoomsProvider.notifier).loadChatRooms();
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
    final response = ref.watch(chatRoomsProvider);

    final chatRoomsNotifier = ref.read(chatRoomsProvider.notifier);

    return response.when(
      data: (chatRooms) {
        if (chatRooms.isEmpty) {
          return const Center(
            child: Text("no rooms found."),
          );
        }
        return ListView.separated(
          itemCount: chatRooms.length + 1,
          controller: _controller,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            if (index < chatRooms.length) {
              var chatRoom = chatRooms[index];
              return InkWell(
                onTap: () {
                  // set current chatroom ID
                  ref.read(selectedChatRoomId.notifier).state = chatRoom.id;
                  context.push("/chatroom");
                },
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 16.0),
                  title: Text(chatRoom.name),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "created ${timeago.format(chatRoom.createdAt)}",
                    ),
                  ),
                ),
              );
            } else if (chatRoomsNotifier.pageInfo.hasNextPage) {
              return const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 32.0,
                ),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return null;
          },
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 0.4,
            );
          },
        );
      },
      error: (error, stack) => Center(
        child: Text(
          error.toString(),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

Widget buildCreateRoomModal(BuildContext context) {
  return Padding(
    padding: MediaQuery.of(context).viewInsets,
    child: const Padding(
      padding: EdgeInsets.all(18.0),
      child: CreateRoomForm(),
    ),
  );
}

class CreateRoomForm extends ConsumerStatefulWidget {
  const CreateRoomForm({super.key});

  @override
  ConsumerState<CreateRoomForm> createState() => _CreateRoomFormState();
}

class _CreateRoomFormState extends ConsumerState<CreateRoomForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(repositoryProvider);

    final chatRoomsNotifier = ref.read(chatRoomsProvider.notifier);

    return FormBuilder(
      key: _formKey,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FormBuilderTextField(
              name: "name",
              maxLength: 25,
              validator: FormBuilderValidators.required(),
              decoration: const InputDecoration(
                labelText: "room name",
                hintText: "What should we call your room?",
              ),
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () async {
              final state = _formKey.currentState!;

              if (state.saveAndValidate()) {
                var result = state.value;
                var chatRoom = await repo.createChatRoom(
                  name: result["name"],
                );
                // reset text field.
                state.fields["name"]?.reset();

                // add chatroom to local state
                chatRoomsNotifier.addChatRoom(chatRoom);

                if (mounted) {
                  // close bottom modal
                  Navigator.pop(context);

                  // set current chatroom ID
                  ref.read(selectedChatRoomId.notifier).state = chatRoom.id;
                  context.push("/chatroom");
                }
              }
            },
            child: const Text(
              "create room",
            ),
          ),
        ],
      ),
    );
  }
}
