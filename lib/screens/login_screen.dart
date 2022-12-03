import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:vgram/firebase_files/auth_methods.dart';
import 'package:vgram/screens/Authpage.dart';

import 'package:vgram/utils/colors.dart';
import 'package:vgram/utils/image.dart';
import 'package:vgram/widgets/textField_widget.dart';

import '../responsive/layout.dart';

class LoginPage extends StatefulWidget {
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
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            //logo
            //text for emal
            TextFieldInput(
                controller: _emailController,
                hint: "Enter your Email",
                type: TextInputType.emailAddress),
            const Gap(24),
            //text for password
            TextFieldInput(
                isPass: true,
                controller: _passwordController,
                hint: "Enter your Password",
                type: TextInputType.text),
            const Gap(12),
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
            Flexible(
              flex: 2,
              child: Container(),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     InkWell(
            //       // ignore: avoid_unnecessary_containers
            //       child: Container(
            //         child: const Text("Don't have an account?"),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           print("tap");
            //           AuthpageState().toggle();
            //         });
            //       },
            //       child: Container(
            //         child: const Text(
            //           "Sign up.",
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //     )
            //   ],
            // )

            // RichText(
            //     text: TextSpan(
            //         style: TextStyle(
            //           fontSize: 20,
            //         ),
            //         text: 'Have an Account?',
            //         children: [
                      
            //       TextSpan(
                    
            //           recognizer: TapGestureRecognizer()
            //             ..onTap = 
            //             AuthpageState().toggle,
                        
            //           text: 'Sign In',
            //           style: TextStyle(
            //             decoration: TextDecoration.underline,
            //             color: Theme.of(context).colorScheme.secondary,
            //           ))
            //     ]))
          ],
        ),
      )),
    );
  }
}
