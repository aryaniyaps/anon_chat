import 'package:anon_chat/providers/chatrooms.dart';
import 'package:anon_chat/providers/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoomsNotifier = ref.read(chatRoomsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Anonymous chat"),
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
      body: RefreshIndicator(
        child: const ChatRoomList(),
        onRefresh: () async {
          chatRoomsNotifier.loadInitialChatRooms();
        },
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
        ref.read(chatRoomsProvider.notifier).loadMoreChatRooms();
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

    return response.when(
      data: (result) {
        final chatRooms = result.allChatRooms;
        if (chatRooms.isEmpty) {
          return const Center(
            child: Text("no rooms created."),
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
                  // join chatroom with ID
                  context.push("/chatrooms/${chatRoom.id}");
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
            return const Divider();
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
    final repo = ref.watch(repositoryProvider);
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
              if (_formKey.currentState!.saveAndValidate()) {
                var result = _formKey.currentState!.value;
                var chatRoom = await repo.createChatRoom(
                  name: result["name"],
                );
                // reset text field.
                _formKey.currentState!.fields["name"]?.reset();
                if (mounted) {
                  // close bottom modal
                  Navigator.pop(context);
                  //  navigate to chatroom
                  context.push("/chatrooms/${chatRoom.id}");
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
