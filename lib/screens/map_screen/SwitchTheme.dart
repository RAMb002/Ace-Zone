import 'package:chadate_alpha/theme/MyThemes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MySwitchTheme extends StatelessWidget {
  const MySwitchTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<MyThemesProvider>(context, listen: false);
    return Switch(
        value: !themeProvider.isLight(),

        onChanged: (value) {
          themeProvider.changeThemeMode(value);
        });
  }
}
