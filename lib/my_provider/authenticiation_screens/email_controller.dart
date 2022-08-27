import 'package:flutter/cupertino.dart';

class EmailControllerProvider extends ChangeNotifier{
   TextEditingController _emailController = TextEditingController();

   TextEditingController get emailController => _emailController;

   void clearEmailController (){
     _emailController.clear();
     notifyListeners();

   }

}