import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class follobutton extends StatelessWidget {
  final Function()? function;
  final Color backgroundcolor;
  final Color bordercolor;
  final String text;
  final Color textcolor;
  const follobutton(
      {super.key,
      this.function,
      required this.backgroundcolor,
      required this.bordercolor,
      required this.text,
      required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: TextButton(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundcolor,
            border: Border.all(color: bordercolor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: textcolor, fontWeight: FontWeight.bold),
          ),
          width: 240,
          height: 30,
        ),
        onPressed: function,
      ),
    );
  }
}
