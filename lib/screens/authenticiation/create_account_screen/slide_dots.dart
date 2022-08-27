import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  const SlideDots({required this.isActive,Key? key}) : super(key: key);

  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        milliseconds: 150,
      ),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: isActive ? 10 : 6,
      width: isActive ? 10 : 6,
      decoration: BoxDecoration(
        color: isActive ? Colors.lightBlueAccent : Colors.black54,
        borderRadius: BorderRadius.all(Radius.circular(12))

      ),
    );
  }
}
