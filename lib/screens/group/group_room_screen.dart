import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'group_info.dart';

class GroupRoomScreen extends StatelessWidget {
  GroupRoomScreen({
    super.key,
    required this.groupChatId,
    required this.groupName,
  });

  final String groupChatId, groupName;

  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ScrollController textFieldScrollController = ScrollController();

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        'sendby': _auth.currentUser!.displayName,
        'message': _message.text.trim(),
        'type': 'text',
        'time': FieldValue.serverTimestamp(),
      };
      _message.clear();

      await _firestore
          .collection('groups')
          .doc(groupChatId)
          .collection('chats')
          .add(chatData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          groupName,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const GroupInfo(),
              ),
            ),
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
              height: size.height / 1.25,
              // width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groups')
                    .doc(groupChatId)
                    .collection('chats')
                    .orderBy(
                      "time",
                      descending: true,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> chatMap =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;

                        return messageTile(size, chatMap);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
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
                        onPressed: onSendMessage,
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
    return Builder(
      builder: (context) {
        if (chatMap['type'] == 'text') {
          return Container(
            width: size.width,
            alignment: chatMap['sendby'] == _auth.currentUser!.displayName
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(
                    12,
                  ),
                  topRight: const Radius.circular(
                    12,
                  ),
                  bottomLeft:
                      chatMap['sendby'] == _auth.currentUser!.displayName
                          ? const Radius.circular(12)
                          : const Radius.circular(0),
                  bottomRight:
                      chatMap['sendby'] == _auth.currentUser!.displayName
                          ? const Radius.circular(0)
                          : const Radius.circular(12),
                ),
                color: chatMap['sendby'] == _auth.currentUser!.displayName
                    ? Colors.blue
                    : Colors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatMap['sendby'],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
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
            alignment: chatMap['sendby'] == _auth.currentUser!.displayName
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
              child: Image.network(
                chatMap['message'],
              ),
            ),
          );
        } else if (chatMap['type'] == "notify") {
          return Container(
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
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
      },
    );
  }
}
