import 'package:flutter/material.dart';

class MyTextFormFieldIconButtonClose extends StatelessWidget {
  const MyTextFormFieldIconButtonClose({required this.onPressed, required this.lineColorWhite,Key? key,}) : super(key: key);

  final Function() onPressed;
  final bool lineColorWhite;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: lineColorWhite ? EdgeInsets.only(top: 15) : EdgeInsets.zero,
      constraints: lineColorWhite ? BoxConstraints() : null,
      onPressed: onPressed,
      icon: Icon(
        Icons.close,
        color: lineColorWhite ? Colors.white : Colors.black,
        size: 22.0,
      ),
    );
    ;
  }
}
