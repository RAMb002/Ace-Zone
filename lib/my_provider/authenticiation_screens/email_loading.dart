import 'package:flutter/cupertino.dart';

class MailLoadingProvider extends ChangeNotifier{
  bool _loading = false;
  int _index =0;
  int get loadingIndex => _index;
  void changeIndex(int value){
    _index = value;
    notifyListeners();
  }
  bool get loading=> _loading;
  void changeLoading(bool value){
    _loading = value;
    notifyListeners();
  }
}