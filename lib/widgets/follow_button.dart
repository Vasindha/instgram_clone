import 'package:flutter/material.dart';

class Followbutton extends StatelessWidget {
  Followbutton(
      {Key? key,
      required this.height,
      required this.width,
      required this.bgcolor,
      required this.bordercolor,
      required this.text,
      required this.textcolor,
      this.function})
      : super(key: key);
  final Function()? function;
  final Color bgcolor;
  final Color bordercolor;
  final String text;
  final Color textcolor;
  double height;
  double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: bgcolor,
            border: Border.all(color: bordercolor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
          ),
          width: width,
          height: height,
        ),
      ),
    );
  }
}
