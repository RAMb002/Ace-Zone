import 'package:flutter/cupertino.dart';

class ProfileVisibilityProvider extends ChangeNotifier{
  bool _status = false;
  bool get status => _status;

  int _i =0;
  int get i =>_i;

  void changeI(int value){
    _i = value;
    notifyListeners();
  }

  void changeStatus(bool value){
    _status = value;
    notifyListeners();
  }


}