import 'package:flutter/cupertino.dart';

class PasswordVisibilityProvider extends ChangeNotifier{
  bool _passwordVisibility = false;

  bool get getPasswordVisibility => _passwordVisibility;

  void changePasswordVisibility(bool value){
    _passwordVisibility=value;
    notifyListeners();

  }
}