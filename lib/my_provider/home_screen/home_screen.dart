import 'package:flutter/cupertino.dart';

class HomeScreenSubIndexProvider extends ChangeNotifier{

  int _subIndex =0;


 // late RouteSettings _settings;
 //
 // RouteSettings get settings => _settings;
 //
 // void changeRouteSettings(RouteSettings newSetting){
 //   _settings = newSetting;
 //   notifyListeners();
 // }

  int  subIndex() => _subIndex;

  void changeSubIndex(int index){
    _subIndex = index;
    notifyListeners();
  }

}