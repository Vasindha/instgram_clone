import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
   TextFieldInput(
      {Key? key,
      required this.controller,
      required this.hint,
       this.isPass=false,
      required this.type})
      : super(key: key);
  final TextEditingController controller;
   bool isPass = false;
  final String hint;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    final inputborder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: inputborder,
        focusedBorder: inputborder,
        enabledBorder: inputborder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: type,
      obscureText: isPass,
    );
  }
}
