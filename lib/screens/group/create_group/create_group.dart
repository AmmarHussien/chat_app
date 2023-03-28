import 'package:chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../group_room_screen.dart';

class CreatGroup extends StatefulWidget {
  const CreatGroup({
    super.key,
    required this.memberList,
  });

  final List<Map<String, dynamic>> memberList;

  @override
  State<CreatGroup> createState() => _CreatGroupState();
}

class _CreatGroupState extends State<CreatGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  void createGroup() async {
    setState(() {
      isLoading = true;
    });
    String groupId = const Uuid().v1();

    await _firestore.collection('groups').doc('groupId').set({
      'members': widget.memberList,
      'id': groupId,
    });

    for (int i = 0; i < widget.memberList.length; i++) {
      String uid = widget.memberList[i]['uid'];
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(groupId)
          .set({
        'groupname': _groupName.text,
        'id': groupId,
      });
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Group Name',
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 10,
                ),
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _groupName,
                      decoration: InputDecoration(
                        hintText: 'Enter Group Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                  onPressed: createGroup,
                  child: const Text('Create Group'),
                ),
              ],
            ),
    );
  }
}
