import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUi{


 static Icon getImageLoaderIcon(double size,{ Color color=Colors.white}){
   return Icon(
     Icons.person,
     size: size,
     color: color,
   );
 }
}