import 'package:flutter/widgets.dart';

class PasswordLoadingProvider extends ChangeNotifier{

  int _index =0;

  int get loadingIndex => _index;

  void changeLoadingIndex(int newIndex){
    _index = newIndex;
    notifyListeners();
  }

}