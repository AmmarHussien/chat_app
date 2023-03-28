import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'group_info.dart';

class GroupRoomScreen extends StatefulWidget {
  const GroupRoomScreen({super.key});

  @override
  State<GroupRoomScreen> createState() => _GroupRoomScreenState();
}

class _GroupRoomScreenState extends State<GroupRoomScreen> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ScrollController textFieldScrollController = ScrollController();

  String currentUserName = 'user1';

  List<Map<String, dynamic>> dummyChatList = [
    {
      'message': 'User1 created this Group',
      'type': 'notify',
    },
    {
      'message': 'hello',
      'sendby': 'user1',
      'type': 'text',
    },
    {
      'message': 'hello',
      'sendby': 'user2',
      'type': 'text',
    },
    {
      'message': 'hello',
      'sendby': 'user3',
      'type': 'text',
    },
    {
      'message': 'hello',
      'sendby': 'user4',
      'type': 'text',
    },
    {
      'message': 'User1 add this Group',
      'type': 'notify',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Group Name',
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const GroupInfo())),
            icon: const Icon(
              Icons.more_vert_sharp,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.27,
              width: size.width,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return messageTile(size, dummyChatList[index]);
                },
                itemCount: dummyChatList.length,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size.width / 1.3,
                        child: TextField(
                          controller: _message,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.photo,
                              ),
                            ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          scrollController: textFieldScrollController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 15,
                          onChanged: (value) {
                            textFieldScrollController.jumpTo(
                                textFieldScrollController
                                    .position.maxScrollExtent);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (context) {
      if (chatMap['type'] == 'text') {
        return Container(
          width: size.width,
          alignment: chatMap['sendby'] == currentUserName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 14,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                15,
              ),
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatMap['sendby'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  chatMap['message'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (chatMap['type'] == 'img') {
        return Container(
          width: size.width,
          alignment: chatMap['sendby'] == currentUserName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 8,
              ),
              height: size.height / 2,
              child: Image.network(chatMap['message'])),
        );
      } else if (chatMap['type'] == 'notify') {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 8,
            ),
            margin: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                5,
              ),
              color: Colors.black38,
            ),
            child: Text(
              chatMap['message'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
