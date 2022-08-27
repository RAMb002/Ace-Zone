import 'dart:math';

import 'package:flutter/cupertino.dart';

class EmailOtpVerification extends ChangeNotifier{

  TextEditingController _otpController = TextEditingController();

  TextEditingController get otpController => _otpController;

  void clearOtpController(){
    otpController.clear();
    notifyListeners();
  }

  int _otpVerification =444444;

  String get otpNumber => _otpVerification.toString();

  void generateRandomNumber(){
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    _otpVerification = code;
    notifyListeners();
  }
}