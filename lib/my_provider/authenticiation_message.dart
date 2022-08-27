import 'package:flutter/cupertino.dart';

class AuthenticationMessageProvider extends ChangeNotifier{

  String _message ="";
  String get message=> _message;
  void changeMessage(String value){
    _message = value;
    notifyListeners();
  }

}