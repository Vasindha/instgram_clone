import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:vgram/firebase_files/auth_methods.dart';
import 'package:vgram/screens/Authpage.dart';
import 'package:vgram/screens/signup_page.dart';

import 'package:vgram/utils/colors.dart';
import 'package:vgram/utils/image.dart';
import 'package:vgram/widgets/textField_widget.dart';

import '../responsive/layout.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  bool isLoad = false;
  // ignore: non_constant_identifier_names
  void login_user() async {
    setState(() {
      isLoad = true;
    });
    String res = await AuthMethods()
        .loginUser(_emailController.text, _passwordController.text);
    if (res != "Succes") {
      showSnackbar(res, context);
    } else if (res == "Succes") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LayoutPage()));
    }
    setState(() {
      isLoad = false;
    });
  }

  void navigateToSignup() {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.45,
              ),
              TextFieldInput(
                  controller: _emailController,
                  hint: "Enter your Email",
                  type: TextInputType.emailAddress),
              const SizedBox(
                height: 20,
              ),
              //text for password
              TextFieldInput(
                  isPass: true,
                  controller: _passwordController,
                  hint: "Enter your Password",
                  type: TextInputType.text),
              const SizedBox(
                height: 20,
              ),
              //button
              GestureDetector(
                onTap: () {
                  login_user();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                      color: bluecolor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  child: isLoad
                      ? const Center(
                          child: CircularProgressIndicator(color: primary),
                        )
                      : const Text("Login"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text("Not have an Account!"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Signuppage.routeName, (route) => false);
                    },
                    child: Text("Sign Up"),
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
