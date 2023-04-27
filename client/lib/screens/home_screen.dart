import 'package:anon_chat/core/api_client.dart';
import 'package:anon_chat/models/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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

  Future<void> loadChatRooms() async {
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

Widget buildCreateRoomModal(BuildContext context) {
  return Padding(
    padding: MediaQuery.of(context).viewInsets,
    child: const Padding(
      padding: EdgeInsets.all(18.0),
      child: CreateRoomForm(),
    ),
  );
}

class CreateRoomForm extends StatefulWidget {
  const CreateRoomForm({super.key});

  @override
  State<CreateRoomForm> createState() => _CreateRoomFormState();
}

class _CreateRoomFormState extends State<CreateRoomForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> createRoom() async {}

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormBuilderTextField(
            name: "name",
            maxLength: 25,
            validator: FormBuilderValidators.required(),
            decoration: const InputDecoration(
              labelText: "room name",
              hintText: "What should we call your room?",
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.saveAndValidate()) {
                var result = _formKey.currentState!.value;
                var chatRoom = await client.createChatRoom(
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
