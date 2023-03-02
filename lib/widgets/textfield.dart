import 'package:flutter/material.dart';

class TextFieldinput extends StatelessWidget {
  
  final TextEditingController textEditingController;
  final bool isPass=false;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldinput({
    Key? key,
    required this.textEditingController,
    isPass = false,
    required this.hintText,
    required this.textInputType,
  }) : super(key: key);

  // const TextFieldinput({super.key});

  @override
  Widget build(BuildContext context) {
    final border=OutlineInputBorder(borderSide: Divider.createBorderSide(context),);
    return TextField(
      controller:textEditingController ,
      decoration: InputDecoration(
        hintText:hintText ,
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        filled: true,
        contentPadding: EdgeInsets.all(8),
      ),
      keyboardType:textInputType ,
      obscureText:isPass ,
    );
  }
}