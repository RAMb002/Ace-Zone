import 'package:flutter/cupertino.dart';

class PhotoUrlName extends ChangeNotifier{
  String _userName ="";
  String _photoUrl ="";

  String get userName => _userName;
  String get photoUrl => _photoUrl;

  void changeUserName (String value){
    _userName = value;
    notifyListeners();
  }

  void changePhotoUrl(String value){
    _photoUrl = value;
    notifyListeners();
  }
}