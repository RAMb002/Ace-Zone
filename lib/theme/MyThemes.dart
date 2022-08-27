import 'package:flutter/material.dart';

class MyThemesProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  bool isLight() => _themeMode == ThemeMode.light;

  ThemeMode getThemeMode() => _themeMode;

  void changeThemeMode(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF1D282D), //chat background
    // primaryColor: Colors.grey.shade900,
    primaryColor: Color(0xFF2B3D45),
    primaryColorDark: Colors.white,
    // primaryColor: Color(0xFF1B202D),

    colorScheme: ColorScheme.dark(
      outline: Colors.lightBlueAccent,
      primaryVariant: Colors.white54,
      primaryContainer: Colors.grey.shade400,
      secondary: Color(0xFF284753) ,// chat textfield
        onSecondary: Color(0xFF2B3D45),//chat messageLog chatscroll
      onSecondaryContainer:Color(0xFF284753) ,

  ),
    primaryIconTheme: IconThemeData(color: Colors.white24),
    backgroundColor: Colors.blue,
    selectedRowColor: Colors.white54,
    // canvasColor: Colors.white60,
    iconTheme: IconThemeData(color: Colors.white),
  );

  static final lightTheme = ThemeData(
    primaryColorDark: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      primaryIconTheme: IconThemeData(color: Colors.black12),
      primaryColor: Colors.white,
      selectedRowColor: Colors.black54,
      // backgroundColor: Colors.red,
      canvasColor: Colors.black54,
      colorScheme: ColorScheme.light(
        secondary: Color(0xFF284753), //chat textfield
        onSecondary: Color(0xFFECECEC), //chat messageLog chatscroll
        onSecondaryContainer:Color(0xFF2B3D45) ,
        outline: Colors.lightBlueAccent,
        primaryVariant: Colors.black54,
        primaryContainer: Colors.grey.shade900,

      ),
    iconTheme: IconThemeData(color: Colors.black)
  );


}
