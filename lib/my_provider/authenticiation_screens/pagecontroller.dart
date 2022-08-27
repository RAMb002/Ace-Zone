import 'package:flutter/cupertino.dart';

class PageControllerIndexProvider extends ChangeNotifier{
  int _index =0;
  int get pageIndex => _index;
  void changeIndex(int newIndex){
    _index = newIndex;
    notifyListeners();
  }
}