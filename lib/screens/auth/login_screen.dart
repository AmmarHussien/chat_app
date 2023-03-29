import 'package:chat_app/model/methods.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/auth/singup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

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

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: size.width / 1.2,
                      
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
                        'Sing In to Contiue!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 10,
                    ),
                    Container(
                      width: size.width,
                      alignment: Alignment.center,
                      child: textFormFiled(
                        size: size,
                        hintText: 'email',
                        icon: Icons.account_box_rounded,
                        controller: _email,
                        obscureText: false,
                        type: TextInputType.emailAddress,
                        lable: 'Email',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: textFormFiled(
                          size: size,
                          hintText: 'password',
                          icon: Icons.lock,
                          controller: _password,
                          obscureText: true,
                          type: TextInputType.text,
                          lable: 'Password',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 10,
                    ),
                    customButtom(
                      size,
                    ),
                    SizedBox(
                      height: size.height / 40,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CreatAccount(),
                        ),
                      ),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget customButtom(Size size) {
    return GestureDetector(
      onTap: () {
        if (_email.text.isNotEmpty &&
            _password.text.isNotEmpty &&
            _email.text.contains('@') &&
            _email.text.contains('.') &&
            _password.text.length > 5) {
          setState(() {
            isLoading = true;
          });
          logIn(
            _email.text,
            _password.text,
            context,
          ).then((user) {
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              showSnackBar(
                'Login Sucessfll',
                Colors.green,
              );
              // if (kDebugMode) {
              //   print('Login Sucessfll');
              // }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              );
            } else {
              showSnackBar(
                'Login filed',
                Theme.of(context).colorScheme.error,
              );
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(
              //     content: const Text('Login filed'),
              //     backgroundColor: Theme.of(context).errorColor,
              //   ),
              // );
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          showSnackBar(
            'password must be 7 characters and valid email formate',
            Theme.of(context).colorScheme.error,
          );
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: const Text('please fill form correctly'),
          //     backgroundColor: Theme.of(context).errorColor,
          //   ),
          // );
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
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget textFormFiled({
    required Size size,
    required String hintText,
    IconData? icon,
    required String lable,
    required TextEditingController controller,
    required bool obscureText,
    required TextInputType type,
    Function? validate,
  }) =>
      SizedBox(
        height: size.height / 15,
        width: size.width / 1.1,
        child: TextFormField(
          validator: (value) {
            validate;
            return null;
          },
          keyboardType: type,
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            labelText: lable,
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
            ),
          ),
        ),
      );
}
