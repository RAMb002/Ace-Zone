// import 'dart:html';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class MyImageProvider extends ChangeNotifier{
  XFile ?newProfilePic;

  XFile ?getProfilePic() => newProfilePic;

  void changeProfilePic(var tempImage){
    newProfilePic = tempImage;
    notifyListeners();
  }
}