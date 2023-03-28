import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

enum ImageOptions {
  camera,
  galary,
}

// ignore: must_be_immutable
class ChatRoom extends StatefulWidget {
  ChatRoom({
    super.key,
    required this.userMap,
    required this.chatRoomId,
  });

  final Map<String, dynamic> userMap;
  final String chatRoomId;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? imageFile;

  Future getImageGallary() async {
    ImagePicker _pickedimage = ImagePicker();

    await _pickedimage.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future getImageCamera() async {
    ImagePicker _pickedimage = ImagePicker();

    await _pickedimage.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      'sendby': _auth.currentUser!.displayName,
      'message': ''.trim(),
      'type': 'img',
      'time': FieldValue.serverTimestamp(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');

    var uploadImage = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadImage.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update(
        {'message': imageUrl},
      );
      if (kDebugMode) {
        print(imageUrl);
      }
    }

    // String imageUrl = await uploadImage.ref.getDownloadURL();
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'sendby': _auth.currentUser!.displayName,
        'message': _message.text,
        'type': 'text',
        'time': FieldValue.serverTimestamp(),
      };
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(
            messages,
          );
      _message.clear();
    } else {
      if (kDebugMode) {
        print('enter some text');
      }
    }
  }

  Future<void> _showSimpleDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // <-- SEE HERE
            title: const Text('Pick image from'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  getImageCamera();
                  Navigator.of(context).pop();
                },
                child: const Text('Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getImageGallary();
                  Navigator.of(context).pop();
                },
                child: const Text('Gallery'),
              ),
            ],
          );
        });
  }

  ScrollController textFieldScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection("users")
              .doc(widget.userMap['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.userMap['username']),
                    Row(
                      children: [
                        Text(
                          snapshot.data!['status'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: snapshot.data!['status'] == 'Online'
                              ? Colors.lightGreen
                              : Colors.red,
                        )
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messages(
                          size,
                          map,
                          context,
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
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
                              onPressed: _showSimpleDialog,
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

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Container(
            width: size.width,
            alignment: map['sendby'] == _auth.currentUser!.displayName
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
                  bottomLeft: map['sendby'] == _auth.currentUser!.displayName
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: map['sendby'] == _auth.currentUser!.displayName
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
                color: map['sendby'] == _auth.currentUser!.displayName
                    ? Colors.blue
                    : Colors.black,
              ),
              child: Text(
                map['message'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ),
            alignment: map['sendby'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: map['message'],
                  ),
                ),
              ),
              child: Container(
                height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(border: Border.all()),
                alignment: map['message'] != "" ? null : Alignment.center,
                child: map['message'] != ""
                    ? Image.network(
                        map['message'],
                        fit: BoxFit.cover,
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
