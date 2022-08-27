import 'package:flutter/cupertino.dart';

class PhoneAuthenticationProvider extends ChangeNotifier{
  String? _country ="IN";
  String? _phoneNumber ="";
  String? _countryNumberCode ="";

  String? get country => _country;
  String? get phoneNumber => _phoneNumber;
  String? get countryNumberCode => _countryNumberCode;

  void changePhoneNumber(String? value){
    this._phoneNumber = value;
    notifyListeners();
  }

  void changeCountry(String? value){
    this._country = value;
    notifyListeners();
  }

  void changeCountryNumberCode(String? value){
    this._countryNumberCode = value;
    notifyListeners();
  }
}