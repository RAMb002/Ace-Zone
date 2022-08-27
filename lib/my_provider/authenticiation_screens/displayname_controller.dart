import 'package:flutter/cupertino.dart';

class DisplayNameController extends ChangeNotifier{
  TextEditingController _displayNameController = TextEditingController();

  TextEditingController get displayNameController => _displayNameController;

  void clearUserDisplayController(){
    _displayNameController.clear();
    notifyListeners();
  }
}