import 'package:chadate_alpha/authentication_service/authentication_service.dart';
import 'package:chadate_alpha/screens/map_screen/SwitchTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final ThemeData theme =  Theme.of(context);
    return Scaffold(
      backgroundColor:theme.scaffoldBackgroundColor ,
      appBar: AppBar(
        elevation: 0.5,
        shadowColor: theme.primaryColorDark,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 20
          ),
        ),
        leading: IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.lightBlueAccent,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),

      body: ListView(
        children: [
          SizedBox(height: 10,),
          MyListTile(
            text: "Edit Profile",
            onPressed: (){},
          ),
          MyListTile(
            text: "Account Settings",
            onPressed: (){},
          ),

      ListTile(
        onTap: (){},
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "Dark mode",style: TextStyle(
            color: theme.primaryColorDark,
            fontSize: (screenHeight * 0.025).clamp(17, 20),
          ),),
        ),
        trailing:MySwitchTheme(),
      ),
          Divider(
            color: theme.primaryColorDark,
            thickness: 0.2,
          ),
          // SizedBox(height: 10,),
          ListTile(
            leading:Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "More",style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 20,
              ),),
            ),
          ),
          MyListTile(
            text: "About us",
            onPressed: (){},
          ),
          MyListTile(
            text: "Privacy policy",
            onPressed: (){},
          ),
          MyListTile(
            text: "Terms and conditions",
            onPressed: (){},
          ),
          MyListTile(
            text: "Log out",
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    // title: Text('Location Permission'),
                    content: Text(
                        'Are you sure you want to log out ?',
                    style: TextStyle(fontSize: 18),),
                    actions: <Widget>[
                      CupertinoDialogAction(
                          child: Text('No'),
                          onPressed: () => {
                            Navigator.of(context).pop(),
                          }),
                      CupertinoDialogAction(
                        child: Text('Yes'),
                        onPressed: () {
                          AuthenticationService.signOut();
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      ),
                    ],
                  ));            },
          ),

        ],
      ),
    );
  }
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) =>
      const AboutDialog(),
    );
  }

}


class MyListTile extends StatelessWidget {
  const MyListTile({
    Key? key,
    required this.text,
    required this.onPressed,

  }) : super(key: key);

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final ThemeData theme =  Theme.of(context);
    return ListTile(
      onTap: onPressed,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          text,style: TextStyle(
          color: theme.primaryColorDark,
          fontSize: (screenHeight * 0.025).clamp(17, 20),
        ),),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          Icons.arrow_forward_ios_outlined,
          color: theme.primaryColorDark,
          size: 18,

        ),
      ),
    );
  }
}
