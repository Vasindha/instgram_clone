import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vgram/screens/signup_page.dart';
import 'package:vgram/utils/colors.dart';

import '../firebase_files/auth_methods.dart';
import '../responsive/layout.dart';
import '../utils/image.dart';
import '../widgets/textField_widget.dart';
import 'login_screen.dart';

class Authpage extends StatefulWidget {
  Authpage({Key? key}) : super(key: key);

  @override
  State<Authpage> createState() => AuthpageState();
}

class AuthpageState extends State<Authpage> {
  bool isLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _user = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _emailController1 = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailController1.dispose();
    _passwordController1.dispose();
    _bio.dispose();
    _user.dispose();
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

  Uint8List? imag;

  bool isLoad1 = false;
  signup_user() async {
    setState(() {
      isLoad1 = true;
    });
    String res = await AuthMethods().signUpuser(
        file: imag!,
        email: _emailController1.text,
        password: _passwordController1.text,
        username: _user.text,
        bio: _bio.text);

    if (res != "Succes") {
      showSnackbar(res, context);
    } else if (res == "Succes") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LayoutPage()));
    }
    setState(() {
      isLoad1 = false;
    });
  }

  Future selectImage() async {
    Uint8List file = await pikeImage(ImageSource.gallery);

    setState(() {
      this.imag = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? Scaffold(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        // ignore: avoid_unnecessary_containers
                        child: Container(
                          child: const Text("Don't have an account?"),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Container(
                          child: const Text(
                            "Sign up.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  )

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
          )
        : Scaffold(
            body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(30),
                    //logo
                    //text for emal
                    Stack(
                      children: [
                        imag != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(imag!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80"),
                              ),
                        Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: const Icon(Icons.add_a_photo)))
                      ],
                    ),
                    const Gap(24),
                    TextFieldInput(
                        controller: _user,
                        hint: "Enter your username",
                        type: TextInputType.emailAddress),
                    const Gap(24),
                    TextFieldInput(
                        controller: _emailController1,
                        hint: "Enter your Email",
                        type: TextInputType.emailAddress),
                    const Gap(24),
                    TextFieldInput(
                        controller: _passwordController1,
                        isPass: true,
                        hint: "Enter your Password",
                        type: TextInputType.emailAddress),
                    const Gap(24),
                    //text for password
                    TextFieldInput(
                        controller: _bio,
                        hint: "Enter your bio",
                        type: TextInputType.text),
                    const Gap(12),
                    //button
                    GestureDetector(
                      onTap: () {
                        signup_user();
                      },
                      child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: ShapeDecoration(
                              color: bluecolor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4))),
                          child: isLoad1
                              ? Center(
                                  child:
                                      CircularProgressIndicator(color: primary),
                                )
                              : Text("Sign up")),
                    ),
                    Gap(40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            child: const Text("have an account?"),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Container(
                            child: const Text(
                              "Login.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ));
  }
}
