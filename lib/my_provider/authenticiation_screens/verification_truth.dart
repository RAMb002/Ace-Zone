import 'package:flutter/cupertino.dart';

class VerificationTruthProvider extends ChangeNotifier{
  bool _phoneVerification = false;
  bool _emailVerification = false;
  bool _userNameVerification = false;

  bool get phoneVerificationTruth => _phoneVerification;
  bool get emailVerificationTruth => _emailVerification;
  bool get userNameVerificationTurth => _userNameVerification;

  void changePhoneVerificationTruth(bool value){
    _phoneVerification = value;
    notifyListeners();
  }

  void changeEmailVerificationTruth(bool value){
    _emailVerification = value;
    notifyListeners();
  }

  void changeUserNameVerificationTruth(bool value){
    _userNameVerification = value;
    notifyListeners();
  }
}