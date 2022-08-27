import 'package:flutter/cupertino.dart';

class OtherUserProvider extends ChangeNotifier{
  String _otherUserId="";

  String get otherUserId => _otherUserId;

  void changeOtherUserId(String value){
    _otherUserId = value;
    notifyListeners();
  }
}