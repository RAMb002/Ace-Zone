import 'package:chadate_alpha/my_provider/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Page2 extends StatefulWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeScreenSubIndexProvider>(context,listen: false).changeSubIndex(1);

    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.red,  body: Center(
      child: FlatButton(
        color: Colors.blue,
        onPressed: (){
          Navigator.pushNamed(context, 'page1');
          Provider.of<HomeScreenSubIndexProvider>(context,listen: false).changeSubIndex(0);


        },
        child: Text(
            'page2'
        ),
      ),
    ),

    );
  }
}
