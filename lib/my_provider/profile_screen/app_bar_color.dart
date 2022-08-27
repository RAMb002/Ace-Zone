import 'package:flutter/cupertino.dart';

class ScrollAppBarColor extends ChangeNotifier{
  double _offset=0;

  double offsetValue(){
    return _offset;
  }

  String _imageUrl ="";
  String _userName ="";

  String get imageUrl => imageUrl;
  String get userName => _userName;

  void changeImageUrl(String value){
    _imageUrl = value;
    notifyListeners();
  }

  void changeUserName(String value){
    _imageUrl = value;
    notifyListeners();
  }



  void changeOffSetValue(double newOffset ){
    _offset = newOffset;
    // print(_offset);
    notifyListeners();
  }
}