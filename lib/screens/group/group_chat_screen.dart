import 'package:flutter/material.dart';

import 'create_group/add_members.dart';
import 'group_room_screen.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({super.key});

  @override
  State<GroupChatHomeScreen> createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Groups',
        ),
      ),
      body: ListView.builder(
        itemBuilder: ((context, index) {
          return ListTile(
            title: Text(
              'Group $index',
            ),
            leading: const Icon(
              Icons.group,
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const GroupRoomScreen(),
              ),
            ),
          );
        }),
        itemCount: 5,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const AddMembersInGroup(),
          ),
        ),
        tooltip: 'Create Group',
        child: const Icon(
          Icons.create,
        ),
      ),
    );
  }
}
