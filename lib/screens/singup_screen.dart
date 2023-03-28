import 'package:chat_app/model/methods.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class CreatAccount extends StatefulWidget {
  const CreatAccount({super.key});

  @override
  State<CreatAccount> createState() => _CreatAccountState();
}

class _CreatAccountState extends State<CreatAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  void showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: size.width / 1.2,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back_ios,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  SizedBox(
                    width: size.width / 1.3,
                    child: const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 1.3,
                    child: const Text(
                      'Craete Account to Contiue!',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: textFiled(
                        size,
                        'Name',
                        Icons.account_box_rounded,
                        _name,
                        false,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width,
                    alignment: Alignment.center,
                    child: textFiled(
                      size,
                      'Email',
                      Icons.account_box_rounded,
                      _email,
                      false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: textFiled(
                        size,
                        'password',
                        Icons.lock,
                        _password,
                        true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 20,
                  ),
                  customButtom(
                    size,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget customButtom(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _name.text.length > 3 &&
            _name.text.length < 20 &&
            _email.text.isNotEmpty &&
            _email.text.contains('@') &&
            _email.text.contains('.') &&
            _password.text.isNotEmpty &&
            _password.text.length > 5) {
          setState(() {
            isLoading = true;
          });

          createAccount(
            _name.text,
            _email.text,
            _password.text,
            context,
          ).then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              showSnackBar(
                'Create Account Sucessfll',
                Colors.green,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              );
            } else {
              showSnackBar(
                'Creat Account Filed',
                Colors.red,
              );
              setState(() {
                isLoading = false;
              });
              //print('Creat Account Filed');
            }
          });
        } else {
          showSnackBar(
            'make sure name characters more than  3 , email formate , password more than 5',
            Colors.red,
          );
          // print(
          //     'Minimum 1 Upper case Minimum 1 lowercase Minimum 1 Numeric Number Minimum 1 Special Character Common Allow Character ( ! @ #  & * ~ )');
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Container(
        height: size.height / 14,
        width: size.width / 1.2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            10,
          ),
          color: Colors.blue,
        ),
        child: const Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget textFiled(
    Size size,
    String hintText,
    IconData icon,
    TextEditingController text,
    bool obscureText,
  ) {
    return SizedBox(
      height: size.height / 15,
      width: size.width / 1.1,
      child: TextField(
        obscureText: obscureText,
        controller: text,
        decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                10,
              ),
            )),
      ),
    );
  }
}
