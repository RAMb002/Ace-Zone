import 'package:flutter/cupertino.dart';

class BottomNavigationIndex extends ChangeNotifier{
  int _index =0;

  int getIndex()=> _index;

  void changeIndex(int newIndex){
    _index = newIndex;
    notifyListeners();
  }
}