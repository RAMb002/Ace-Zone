import 'package:flutter/cupertino.dart';

class ThirdChat extends ChangeNotifier{
  bool _status = false;
  bool get status => _status;

  void changeStatus(bool value){
    _status = value;
    notifyListeners();
  }
}