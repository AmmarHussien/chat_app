import 'package:flutter/material.dart';

class CreatGroup extends StatelessWidget {
  const CreatGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextEditingController _groupName = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Group Name',
        ),
      ),
      body: Column(
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
            onPressed: () {},
            child: const Text('Create Group'),
          ),
        ],
      ),
    );
  }
}
