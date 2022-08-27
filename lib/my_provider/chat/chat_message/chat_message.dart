import 'package:flutter/cupertino.dart';

class ChatMessageProvider extends ChangeNotifier{
  double _offset =0;//max scroll

  double get offset => _offset;

  void changeOffset(double value){
    _offset = value;
    notifyListeners();
  }

  double _scrollOffset =0;

  double get scrollOffset => _scrollOffset;

  void changeScrollOffset(double value){
    _scrollOffset = value;
    notifyListeners();
  }
}