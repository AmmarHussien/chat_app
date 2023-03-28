import 'package:chat_app/screens/group/add_new_members_to_group.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo({
    super.key,
    required this.groupName,
    required this.groupId,
  });

  final String groupName, groupId;

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List memberList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getGroupMembers();
  }

  bool checkAdmin() {
    bool isAdmin = false;

    memberList.forEach((element) {
      if (element['uid'] == _auth.currentUser!.uid) {
        isAdmin = element['isAdmin'];
      }
    });
    return isAdmin;
  }

  void getGroupMembers() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((value) {
      setState(() {
        memberList = value['members'];
        isLoading = false;
      });
    });
  }

  void removeUser(int index) async {
    if (checkAdmin()) {
      if (_auth.currentUser!.uid != memberList[index]['uid']) {
        setState(() {
          isLoading = true;
        });

        String uid = memberList[index]['uid'];
        memberList.removeAt(index);

        await _firestore.collection('groups').doc(widget.groupId).update({
          'members': memberList,
        });

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(widget.groupId)
            .delete();

        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('can not remove ');
    }
  }

  void onLeaveGroup() async {
    if (!checkAdmin()) {
      setState(() {
        isLoading = true;
      });

      String uid = _auth.currentUser!.uid;

      for (int i = 0; i < memberList.length; i++) {
        if (memberList[i]['uid'] == uid) {
          memberList.removeAt(i);
        }
      }

      await _firestore.collection('groups').doc(widget.groupId).update({
        'members': memberList,
      });

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } else {
      print('a7a');
    }
  }

  void showRemoveDialog(int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: ListTile(
            onTap: () => removeUser(index),
            title: const Text(
              'Remove This Member',
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: BackButton(),
                    ),
                    Container(
                      height: size.height / 8,
                      width: size.width / 1.1,
                      child: Row(
                        children: [
                          Container(
                            height: size.height / 10,
                            width: size.width / 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: Icon(
                              Icons.group,
                              size: size.width / 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: size.width / 20,
                          ),
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.groupName,
                                style: TextStyle(
                                  fontSize: size.width / 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: size.width / 1.1,
                      child: Text(
                        '${memberList.length} Members',
                        style: TextStyle(
                          fontSize: size.width / 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    ListTile(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddMembers(
                            groupId: widget.groupId,
                            groupName: widget.groupName,
                            memberList: memberList,
                          ),
                        ),
                      ),
                      leading: const Icon(
                        Icons.add,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        'Add Member',
                        style: TextStyle(
                          fontSize: size.width / 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),

                    // members name
                    Flexible(
                      child: ListView.builder(
                        itemCount: memberList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onLongPress: () {
                              showRemoveDialog(
                                index,
                              );
                            },
                            leading: const Icon(
                              Icons.account_circle,
                            ),
                            title: Text(
                              memberList[index]['username'],
                              style: TextStyle(
                                fontSize: size.width / 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              memberList[index]['useremail'],
                            ),
                            trailing: Text(
                              memberList[index]['isAdmin'] ? "Admin" : " ",
                              style: TextStyle(
                                color: Colors.red[300],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: size.height / 50,
                    ),

                    ListTile(
                      onTap: onLeaveGroup,
                      leading: const Icon(
                        Icons.exit_to_app_sharp,
                        color: Colors.redAccent,
                      ),
                      title: Text(
                        'Leave Group',
                        style: TextStyle(
                          fontSize: size.width / 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
