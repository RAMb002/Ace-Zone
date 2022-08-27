import 'package:chadate_alpha/my_provider/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);


  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeScreenSubIndexProvider>(context,listen: false).changeSubIndex(0);

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.orange,
      //   onTap: (index){
      //     if(index==1)
      //       Navigator.pushNamed(context, 'page2');
      //   },
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Call'),
      //     BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
      //   ],
      // ),
      // backgroundColor: Colors.blue,
      body: Center(
        child: FlatButton(
          color: Theme.of(context).backgroundColor,
          onPressed: (){
            Navigator.pushNamed(context, 'page2');

          },
          child: Text(
            'hii',
            style: TextStyle(
              fontSize: 20
            ),
          ),
        ),
      ),
    );
  }
}
