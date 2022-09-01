import 'package:flutter/material.dart';

class AuthDetailTextFormField extends StatelessWidget {
  const AuthDetailTextFormField({
    required this.labelText,
    required this.controller,
    required this.validator,
    required this.editStatus,
    Key? key}) : super(key: key);

  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool editStatus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.lightBlueAccent,
      controller: controller,
      style: TextStyle(
        color: editStatus ? Theme.of(context).primaryColorDark : Colors.black
      ),
      decoration: InputDecoration(
          disabledBorder: UnderlineInputBorder(
            borderSide:  BorderSide(color:editStatus ? Theme.of(context).primaryColorDark : Colors.black38, width: 1.0),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:  BorderSide(color:editStatus ? Theme.of(context).primaryColorDark : Colors.black54, width: 2.0),
          ),
          labelText: labelText,
          labelStyle:  TextStyle(color: editStatus ? Theme.of(context).colorScheme.primaryVariant : Colors.black54)
      ),
      validator:validator ,
    );
  }
}
