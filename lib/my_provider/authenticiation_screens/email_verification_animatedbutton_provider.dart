import 'package:flutter/cupertino.dart';

class EmailVerificationAnimatedButtonProvider extends ChangeNotifier{
  bool _animationStatus = false;
  bool get status => _animationStatus;
  void changeAnimationStatus(bool value){
    _animationStatus = value;
    notifyListeners();
  }
}