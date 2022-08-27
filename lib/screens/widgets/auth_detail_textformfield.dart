import 'package:flutter/material.dart';

class AuthDetailTextFormField extends StatelessWidget {
  const AuthDetailTextFormField({
    required this.labelText,
    required this.controller,
    required this.validator,
    Key? key}) : super(key: key);

  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.lightBlueAccent,
      controller: controller,
      decoration: InputDecoration(
          disabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.black38, width: 1.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.black54, width: 2.0),
          ),
          labelText: labelText,
          labelStyle:  TextStyle(color: Colors.black54)
      ),
      validator:validator ,
    );
  }
}
