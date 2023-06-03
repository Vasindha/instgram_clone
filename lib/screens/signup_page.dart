import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vgram/firebase_files/auth_methods.dart';
import 'package:vgram/responsive/layout.dart';
import 'package:vgram/screens/Authpage.dart';
import 'package:vgram/screens/login_screen.dart';
import 'package:vgram/utils/colors.dart';
import 'package:vgram/utils/image.dart';

import '../widgets/textField_widget.dart';

class Signuppage extends StatefulWidget {
  static const routeName = '/signup';
  Signuppage({Key? key}) : super(key: key);

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final TextEditingController _user = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Uint8List? imag;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bio.dispose();
    _user.dispose();
  }

  bool isLoad = false;
  signup_user() async {
    setState(() {
      isLoad = true;
    });
    String res = await AuthMethods().signUpuser(
        file: imag!,
        email: _emailController.text,
        password: _passwordController.text,
        username: _user.text,
        bio: _bio.text);
    _emailController.text = "";
    _passwordController.text = "";
    _bio.text = '';
    _user.text = "";
    if (res != "Succes") {
      showSnackbar(res, context);
    } else if (res == "Succes") {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LayoutPage()));
    }
    setState(() {
      isLoad = false;
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
    return Scaffold(
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
                  controller: _emailController,
                  hint: "Enter your Email",
                  type: TextInputType.emailAddress),
              const Gap(24),
              TextFieldInput(
                  controller: _passwordController,
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
                    child: isLoad
                        ? Center(
                            child: CircularProgressIndicator(color: primary),
                          )
                        : Text("Sign up")),
              ),
              Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an Account!"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.routeName, (route) => false);
                    },
                    child: Text("Login"),
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
