import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/FirebaseApi/firebaseauth/auth_data.dart';
import 'package:chadate_alpha/authentication_service/authentication_service.dart';
import 'package:chadate_alpha/config.dart';
import 'package:chadate_alpha/my_provider/home_screen/bottom_navigation_index.dart';
import 'package:chadate_alpha/my_provider/home_screen/home/profile_visibility.dart';
import 'package:chadate_alpha/my_provider/home_screen/home_screen.dart';
import 'package:chadate_alpha/my_provider/profile_screen/app_bar_color.dart';
import 'package:chadate_alpha/my_provider/search_screen/other_user.dart';
import 'package:chadate_alpha/my_provider/search_screen/third_chat.dart';
import 'package:chadate_alpha/screens/chat_screens/message_log.dart';
import 'package:chadate_alpha/screens/map_screen/SwitchTheme.dart';
import 'package:chadate_alpha/screens/map_screen/flutter_map.dart';
import 'package:chadate_alpha/screens/page1.dart';
import 'package:chadate_alpha/screens/page2.dart';
import 'package:chadate_alpha/screens/profile_screen/user_profile.dart';
import 'package:chadate_alpha/screens/search_screen/search_screen.dart';
import 'package:chadate_alpha/screens/settings_screen/settings_screen.dart';
import 'package:chadate_alpha/theme/MyThemes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// import 'package:stream_chat/stream_chat.dart' as stream;
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'latlo';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // final client = stream.StreamChatClient(Config.streamApiKey,logLevel: stream.Level.SEVERE);

  final User? user = FirebaseAuth.instance.currentUser;
  // Set<Marker> _markers = {
  //   Marker(
  //       infoWindow: InfoWindow(
  //           title: 'dsss',
  //           snippet: 'ggggg'
  //       ),
  //       markerId: MarkerId('ddd'),
  // position:LatLng(37.42796133580664, -122.085749655962) )
  // };

  // void _onMapCreated(GoogleMapController controller){
  //   setState(() {
  //     _markers.add(
  //         Marker(
  //           infoWindow: InfoWindow(
  //             title: 'dsss',
  //             snippet: 'ggggg'
  //           ),
  //         markerId: MarkerId('ddd'),
  //         position:LatLng(37.42796133580664, -122.085749655962) ));
  //   });
  // }
  int _currentIndex = 0;

  final _page1 = GlobalKey<NavigatorState>();
  final _page2 = GlobalKey<NavigatorState>();
  final _page3 = GlobalKey<NavigatorState>();
  final _page4 = GlobalKey<NavigatorState>();

  List<int> navIndexList = [];

  List list = [
    FlutterMapWidget(),
    Container(),
    Consumer<HomeScreenSubIndexProvider>(
      builder: (context,data,child)=>
          Navigator(
            onGenerateRoute: (settings) {
              if(data.subIndex()==0){
                // print('index 0');
                print(data.subIndex());
                Widget page =  SearchScreen();
                if (settings.name == UserProfile.name) page = UserProfile(status: true);
                return CupertinoPageRoute(builder: (_) => page) ;
              }
              else if(data.subIndex()==1){
                // print('index 1');

                print(data.subIndex());

                Widget page = UserProfile(status: true,);
                if (settings.name == SearchScreen.name) page =  SearchScreen();
                return CupertinoPageRoute(builder: (_) => page);

              }
              // Widget page = Page1();
              // if (settings.name == 'page2') page = Page2();
              // return CupertinoPageRoute(builder: (_) => page);
            },
          ),
    ),

    UserProfile(otherUserId: AuthData.userId,status: false,)

  ];
  int count=0;
  // int _currentIndex=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future trial()async{
    print(user?.photoURL);
    // "sss".t
    // await user?.updatePhotoURL(
    // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR88AfEpIVx8halUjLi7MMYUjXVSUo-tZKZdKJVyy9FdU8DyEphHzFjQDjNE70INfhZ4AM&usqp=CAU');
    // print('doneeee');
    // setState(() {
    // });
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // print((screenHeight * 0.028).clamp(23, 27).toDouble());

    final iconList = <IconData>[
      _currentIndex==0 ? Icons.home : Icons.home_outlined,
      _currentIndex==1 ? Icons.favorite : Icons.favorite_border_outlined,
      _currentIndex==2 ? Icons.search : Icons.search,
      _currentIndex==3 ? Icons.person : Icons.person_outline,
    ];


    // user.photoURL;
    // print(user?.photoURL);


    print('mapscreen');
    // print(Theme.of(context).backgroundColor);

    return WillPopScope(
      onWillPop: ()async{
        final pProfileVisibility = Provider.of<ProfileVisibilityProvider>(context,listen: false);
        final pSubIndex =Provider.of<HomeScreenSubIndexProvider>(context,listen: false);
        final pUserProfileScrollOffset = Provider.of<ScrollAppBarColor>(context, listen: false);
        final pThirdChat = Provider.of<ThirdChat>(context,listen: false);
        // if(_currentIndex==2 && pSubIndex.subIndex()==1){
        //   Navigator.pushNamed(context, SearchScreen.name);
        //   pSubIndex.changeSubIndex(0);
        //   return false;
        // }
        if(pThirdChat.status){
          pThirdChat.changeStatus(false);
        }
        if(pUserProfileScrollOffset.offsetValue()>0){
          pUserProfileScrollOffset.changeOffSetValue(0);
        }
        if(_currentIndex ==0 && pProfileVisibility.status){
          pProfileVisibility.changeStatus(false);
          return false;
        }
        if(navIndexList.isNotEmpty){
          // print(navIndexList);
          // print("first");
          // print('not empty');
          // print(navIndexList);
          if(navIndexList.last==_currentIndex){
            navIndexList.removeLast();
            // print("second if");
            // print(navIndexList);
          }
          if(navIndexList.isEmpty){
            if(_currentIndex!=0){
              setState(() {
                _currentIndex=0;
              });
            }
          }
          // navIndexList.removeLast();
          setState(() {
            _currentIndex = navIndexList.last;
            navIndexList.removeLast();
          });
          return false;
        }
        else if(navIndexList.isEmpty){
          if(_currentIndex!=0){
            setState(() {
              _currentIndex =0;
            });
            return false;
          }
          else{
            return true;
          }
        }
        else if(pProfileVisibility.status){
          pProfileVisibility.changeStatus(false);
          return false;
        }
        else{
          return true;
        }

      },
      child: Scaffold(
          appBar: _currentIndex!=2 && _currentIndex!=3 ?
          AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Consumer<MyThemesProvider>(
              builder: (context,data,child)=>
               Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      data.isLight() ? "images/Main_icon.png" : "images/icon_dark_theme.png"
                    ),
                    fit: BoxFit.contain
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(onPressed: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context)=>SettingsScreen()));
              }, icon: Icon(Icons.settings,color:Theme.of(context).primaryColorDark ,)),
            ],
          ) : null,
          // resizeToAvoidBottomInset: false,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Consumer<ThirdChat>(
            builder: (context,data,child)=>
             Visibility(
               visible: !data.status,
               child: GestureDetector(
                // splashColor: Colors.transparent,
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context)
                  => MessageLog(),),);
                },
                child: Hero(
                  tag: "Logo",
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "images/bottom_logo.png"
                        ),
                      )
                    ),
                  ),
                ),
            ),
             ),
          ),


          extendBody: true,
          // resizeToAvoidBottomInset: false,

          bottomNavigationBar:Consumer<ThirdChat>(
            builder: (context,data,child){
              print('bototm navigation bar');
              print(_currentIndex==2);
              print(_currentIndex!=2 && data.status==false);
              // print(data.subIndex());
              return  Visibility(
              visible: !data.status,
                child: AnimatedBottomNavigationBar(
                    notchAndCornersAnimation: null,
                    backgroundColor: getBottomNavigationBarColor(),
                    activeColor: Colors.lightBlueAccent,
                    inactiveColor:  Theme.of(context).iconTheme.color,
                    icons: iconList,
                    iconSize: (screenHeight * 0.028).clamp(23, 27),
                    activeIndex: _currentIndex,
                    gapLocation: GapLocation.center,
                    // gapWidth: 100,
                    notchSmoothness: NotchSmoothness.smoothEdge,
                    leftCornerRadius: 0,
                    elevation: 102,
                    splashSpeedInMilliseconds: 100,
                    splashColor: Theme.of(context).iconTheme.color,
                    rightCornerRadius: 0,
                    onTap: (index) {
                      if(index ==3){
                        Provider.of<ScrollAppBarColor>(context,listen: false).changeOffSetValue(0);
                      }
                      if(_currentIndex!=index) {
                        setState(() {
                          navIndexList.add(index);
                          _currentIndex = index;
                        });
                        print(navIndexList);

                      }

                    }
                  //other params
                ),
              );
            }
          ),
          // bottomNavigationBar: Consumer<MyThemesProvider>(
          //   builder: (context, data, child) => BottomNavigationBar(
          //     showSelectedLabels: false,
          //     showUnselectedLabels: false,
          //     // fixedColor: Colors.red,
          //     backgroundColor: Theme.of(context).primaryColor,
          //     currentIndex: _currentIndex,
          //     type: BottomNavigationBarType.fixed,
          //     selectedIconTheme: Theme.of(context).iconTheme,
          //     unselectedIconTheme:
          //         Theme.of(context).iconTheme, // backgroundColor: Theme.of(context).primaryColor,
          //     onTap: (index) {
          //       Provider.of<BottomNavigationIndex>(context, listen: false).changeIndex(index);
          //       setState(() {
          //         _currentIndex = index;
          //       });
          //     },
          //     items: [
          //       BottomNavigationBarItem(
          //           icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined), label: ''),
          //       BottomNavigationBarItem(
          //           icon: Icon(_currentIndex == 1 ? Icons.favorite : Icons.favorite_border_outlined),
          //           label: ''),
          //       BottomNavigationBarItem(
          //           icon: Icon(_currentIndex == 2 ? Icons.chat_bubble : Icons.chat_bubble_outline), label: ''),
          //       BottomNavigationBarItem(
          //           icon: Icon(_currentIndex == 3 ? Icons.search : Icons.search_off_outlined), label: ''),
          //       BottomNavigationBarItem(
          //           icon: Icon(_currentIndex == 4 ? Icons.person : Icons.person_outline), label: ''),
          //     ],
          //   ),
          // ),
          // backgroundColor: Colors.black54,

          body: list[_currentIndex]

          // body:GoogleMap(
          //   onTap: (value){
          //     print('hille');
          //   },
          //   markers: _markers,
          //     initialCameraPosition: CameraPosition(
          //       target: LatLng(37.42796133580664, -122.085749655962),
          //       zoom: 14.4746,
          //     )) ,
          ),
    );
  }

  Color getBottomNavigationBarColor(){
    final pSubIndex =Provider.of<HomeScreenSubIndexProvider>(context,listen: false);
    final ThemeData theme = Theme.of(context);
    // print(pSubIndex)

    if( _currentIndex ==2 && pSubIndex.subIndex()==1 ){
      return theme.scaffoldBackgroundColor;

    }
    else if(_currentIndex ==2 && pSubIndex.subIndex()==0){
      return  theme.colorScheme.onSecondary;
    }
    else{
      return theme.scaffoldBackgroundColor;
    }
  }
}
// https://medium.com/flutter-community/drawing-route-lines-on-google-maps-between-two-locations-in-flutter-4d351733ccbe