import 'package:chadate_alpha/screens/authenticiation/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoadingScreenAlpha extends StatefulWidget {
  const LoadingScreenAlpha({Key? key}) : super(key: key);

  @override
  State<LoadingScreenAlpha> createState() => _LoadingScreenAlphaState();
}

class _LoadingScreenAlphaState extends State<LoadingScreenAlpha> {
  bool state = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sleep();
  }

  void sleep()async{
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      state = true;
    });
    await Future.delayed(Duration(milliseconds: 1500));
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const WelcomeScreen(),
      ),
    );  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Visibility(
            visible: state,
            child: Hero(
              tag: "Logo",
              child: Container(
                height:screenHeight * 0.2 ,
                width: screenWidth * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "images/Main_icon.png"
                    ),
                    fit:BoxFit.contain
                  )
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
