import 'package:flutter/cupertino.dart';

class LoadingProvider extends ChangeNotifier{
  bool _loading = false;
  bool get loadingStatus => _loading;
  void changeLoadingStatus(bool value){
    _loading = value;
    notifyListeners();
  }
}