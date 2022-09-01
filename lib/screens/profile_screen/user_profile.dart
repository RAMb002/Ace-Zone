import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_stream.dart';
import 'package:chadate_alpha/FirebaseApi/firebaseauth/auth_data.dart';
import 'package:chadate_alpha/classes/chat/chat_ui.dart';
import 'package:chadate_alpha/my_provider/home_screen/home_screen.dart';
import 'package:chadate_alpha/my_provider/profile_screen/app_bar_color.dart';
import 'package:chadate_alpha/my_provider/profile_screen/photourl_name.dart';
import 'package:chadate_alpha/my_provider/search_screen/other_user.dart';
import 'package:chadate_alpha/my_provider/search_screen/third_chat.dart';
import 'package:chadate_alpha/screens/authenticiation/create_account_screen/detail_screen.dart';
import 'package:chadate_alpha/screens/chat_screens/chat_ui.dart';
import 'package:chadate_alpha/screens/page_animation/page_animation.dart';
import 'package:chadate_alpha/screens/search_screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

const borderRadius = BorderRadius.only(bottomLeft: Radius.circular(00), bottomRight: Radius.circular(00));

class UserProfile extends StatefulWidget {
  UserProfile({Key? key, this.otherUserId = "", required this.status}) : super(key: key);

  String otherUserId;
  final bool status;

  static String name = "userProfile";
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late String userId;
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.otherUserId.isEmpty) {
      print('empty');
      userId = Provider.of<OtherUserProvider>(context, listen: false).otherUserId;
    } else {
      print('notEmpty');
      userId = AuthData.userId;
    }
    if (widget.status) {
      print("user profile screen");
      print(Provider.of<HomeScreenSubIndexProvider>(context, listen: false).subIndex());
      print("11111111111111111111111111111111111111111111");
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Provider.of<HomeScreenSubIndexProvider>(context, listen: false).changeSubIndex(1);
      });
    }
    _scrollController = ScrollController()
      ..addListener(() {
        Provider.of<ScrollAppBarColor>(context, listen: false).changeOffSetValue(_scrollController.offset);
        print(_scrollController.offset);
      });
  }

  @override
  Widget build(BuildContext context) {
    final pSubIndex = Provider.of<HomeScreenSubIndexProvider>(context, listen: false);
    final pThirdChat = Provider.of<ThirdChat>(context, listen: false);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      extendBody: true,
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      // appBar: PreferredSize(
      //   preferredSize: Size(MediaQuery.of(context).size.width, 50),
      //   child: Consumer<ScrollAppBarColor>(
      //     builder: (context, changeColor, child) => Container(
      //       height: 50,
      //       width: screenWidth,
      //       // color: Colors.black.withOpacity((changeColor.offsetValue() / 100).clamp(0, 1).toDouble()),
      //       color: Colors.black.withOpacity(0.5),
      //
      //     )
      //   ),
      // ),z
      backgroundColor: theme.colorScheme.onSecondary,
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            children: [
              StreamBuilder(
                stream: FirebaseStream.profileData(userId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    String name = snapshot.data.docs[0]['userName'];
                    String photoUrl = snapshot.data.docs[0]['photoUrl'];
                    String bio = snapshot.data.docs[0]["bio"];
                    String officeAddress = snapshot.data.docs[0]["officeAddress"];
                    String companyName = snapshot.data.docs[0]['companyName'];
                    String occupation = snapshot.data.docs[0]['occupation'];
                    final pAppBar = Provider.of<PhotoUrlName>(context, listen: false);

                    print('ss');
                    print(bio.isEmpty );
                    print(bio.length);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      pAppBar.changePhotoUrl(photoUrl);
                      pAppBar.changeUserName(name);
                    });

                    print(name);
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Container(
                                  // height: screenHeight * 0.44,
                                  height: screenWidth * 0.735,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(photoUrl
                                              // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYSizgg0zrW_4-qDJhf3nwZUmqxKcwL6sljw&usqp=CAU",
                                              ),
                                          fit: BoxFit.cover),
                                      color: theme.scaffoldBackgroundColor,
                                      borderRadius: borderRadius),
                                ),
                                Positioned(
                                    child: Container(
                                  padding: EdgeInsets.only(bottom: 0),
                                  height: screenWidth * 0.735,
                                  decoration: BoxDecoration(borderRadius: borderRadius),
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      // blendMode: BlendMode.lighten,
                                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: borderRadius,
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                        // padding: EdgeInsets.all(6),
                                        // height: 50,
                                        // width: 50,
                                      ),
                                    ),
                                  ),
                                )),
                                Positioned(
                                    child: Container(
                                  height: screenHeight * 0.44,
                                  decoration: BoxDecoration(
                                    borderRadius: borderRadius,
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [Colors.black54, Colors.black12],
                                        stops: [0, 0.2]),
                                  ),
                                )),
                                Positioned(
                                    child: Container(
                                      height: screenHeight * 0.44,
                                      decoration: BoxDecoration(
                                        borderRadius: borderRadius,
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [Colors.black54, Colors.black12],
                                            stops: [0, 0.1]),
                                      ),
                                    )),
                                Positioned(
                                  bottom: screenHeight * 0.16,
                                  // left: 40,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                        boxShadow: [
                                          BoxShadow(color: Colors.black, spreadRadius: 2, blurRadius: 20)
                                        ],
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              photoUrl,
                                              // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYSizgg0zrW_4-qDJhf3nwZUmqxKcwL6sljw&usqp=CAU"),
                                            ),
                                            fit: BoxFit.cover)),
                                    // height: 120,
                                    // width: 120,
                                    height: screenHeight * 0.18,
                                    width: screenWidth * 0.4,
                                    child: photoUrl.isEmpty ? ChatUi.getImageLoaderIcon(60) : null,
                                  ),
                                ),
                                Positioned(
                                    bottom: screenHeight * 0.09,
                                    // left: 50,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            // width: screenWidth * 0.6,
                                            child: AutoSizeText(
                                          name,
                                          minFontSize: 18,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: (screenHeight * 0.0307).clamp(20, 22)),
                                        )),
                                      ],
                                    )),


                              ],
                            ),
                            Container(
                              // height: 500,
                              width: screenWidth,
                              decoration: BoxDecoration(
                                  color: theme.colorScheme.onSecondary,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(35), topLeft: Radius.circular(35))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    AuthData.userId != userId
                                        ? FlatButton(
                                        height: 45,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        color: Colors.lightBlueAccent,
                                        onPressed: () {
                                          if (widget.status) {
                                            print('trueeee');
                                            // pSubIndex.changeSubIndex(2);
                                            pThirdChat.changeStatus(true);
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) => ChatUI(
                                                      otherUser: userId,
                                                      userName: name,
                                                      userImageProfile: photoUrl,
                                                      status: true,
                                                    )));
                                          }
                                        },
                                        child: Text(
                                          "Send message",
                                          style: TextStyle(
                                              fontSize: (screenHeight * 0.0238).clamp(16, 18.5),
                                              color: Colors.white),
                                        ))
                                        : FlatButton(
                                        height: 45,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        color: Colors.lightBlueAccent,
                                        onPressed: () {
                                          Navigator.of(context).push(CustomPageRoute(
                                              DetailScreen(
                                                editStatus: true,
                                                photoUrl: photoUrl,
                                                officeAddress: officeAddress,
                                                companyName: companyName,
                                                occupation: occupation,
                                                bio: bio,
                                              )
                                          ));
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Edit Profile",
                                              style: TextStyle(
                                                  fontSize: (screenHeight * 0.0238).clamp(16, 18.5),
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )),

                                    SizedBox(
                                      height: 20,
                                    ),
                                    Visibility(
                                      visible: bio.isNotEmpty,
                                      child: Bubble(
                                        theme: theme,
                                        heading: "About me",
                                        content: bio,
                                      ),
                                    ),
                                    Visibility(
                                      visible: bio.isNotEmpty,
                                      child: SizedBox(
                                        height: 8,
                                      ),
                                    ),
                                    Visibility(
                                      visible: occupation.isNotEmpty,
                                      child: Bubble(
                                        theme: theme,
                                        heading: "Occupation",
                                        content: occupation,
                                      ),
                                    ),
                                    Visibility(
                                      visible: occupation.isNotEmpty,
                                      child: SizedBox(
                                        height: 8,
                                      ),
                                    ),
                                    Visibility(
                                      visible: companyName.isNotEmpty,
                                      child: Bubble(
                                        theme: theme,
                                        heading: "Company Name",
                                        content: companyName,
                                      ),
                                    ),
                                    Visibility(
                                      visible: companyName.isNotEmpty,
                                      child: SizedBox(
                                        height: 8,
                                      ),
                                    ),
                                    Visibility(
                                      visible : officeAddress.isNotEmpty,
                                      child: Bubble(
                                        theme: theme,
                                        heading: "Office Address",
                                        content: officeAddress,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            // Container(
                            //   height: screenHeight * 0.75,
                            //   color: theme.colorScheme.onSecondary,
                            // )
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      height: screenHeight,
                      child: Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: Colors.lightBlueAccent,
                          // secondRingColor: Colors.blue,
                          // thirdRingColor: Colors.white,
                          size: 45,
                        ),
                      ),
                    );
                  }
                },
              )
            ],

            // SliverAppBar(
            //   leading: Container(
            //     margin: EdgeInsets.all(10),
            //     height: 50,
            //     width: 50,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       image:  DecorationImage(
            //           image: NetworkImage(
            //               "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYSizgg0zrW_4-qDJhf3nwZUmqxKcwL6sljw&usqp=CAU"
            //           ),
            //           fit: BoxFit.cover
            //       )
            //     ),
            //   ),
            //   actions: [
            //     Icon(Icons.add),
            //     Icon(Icons.add),
            //     Icon(Icons.add),
            //     Icon(Icons.add),
            //
            //   ],
            //   pinned: true,
            //
            //   expandedHeight: screenHeight * 0.38,
            //   backgroundColor: Colors.red,
            //   // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
            //   flexibleSpace: LayoutBuilder(
            //       builder: (BuildContext context, BoxConstraints constraints) {
            //         // print('constraints=' + constraints.toString());
            //         double top = constraints.biggest.height;
            //         return FlexibleSpaceBar(
            //           titlePadding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
            //             centerTitle: false,
            //             title: AnimatedOpacity(
            //                 duration: Duration(milliseconds: 300),
            //                 //opacity: top == MediaQuery.of(context).padding.top + kToolbarHeight ? 1.0 : 0.0,
            //                 opacity: 1.0,
            //                 child: Row(
            //                   children: [
            //                     Text(
            //                       top.toString(),
            //                       style: TextStyle(fontSize: 19.0,color: Colors.white,),
            //                     ),
            //
            //                   ],
            //                 )),
            //             background: Stack(
            //               children: [
            //                 Container(
            //                   // height: 200,
            //                   decoration: BoxDecoration(
            //                       // borderRadius:BorderRadius.all(Radius.circular(40)) ,
            //                       image: DecorationImage(
            //                           image: NetworkImage(
            //                             "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYSizgg0zrW_4-qDJhf3nwZUmqxKcwL6sljw&usqp=CAU"
            //                           ),
            //                           fit: BoxFit.cover
            //                       )
            //                   ),
            //                 ),
            //                 Positioned(child: Container(
            //                   decoration: BoxDecoration(
            //                       gradient: LinearGradient(
            //                           colors: [Colors.black,Colors.black12],
            //                           begin:Alignment.bottomCenter,
            //                           end: Alignment.topCenter,
            //                         stops: [0.02,0.5]
            //                       )
            //                   ),
            //                 ))
            //               ],
            //             ),
            //         );
            //       }
            //
            //   //   FlexibleSpaceBar(
            //   //   titlePadding: EdgeInsets.zero,
            //   //   background:
            //   //   title: Text('Naruto Uzumaki',style: TextStyle(color: Colors.white),),
            //   // ),
            //
            // ),),
          ),
          Positioned(
              top: 0,
              child: Consumer<PhotoUrlName>(
                  builder: (context, data, child) => Consumer<ScrollAppBarColor>(
                      builder: (context, changeColor, child) => Container(
                            padding: EdgeInsets.all(10),
                            height: 90,
                            // height: screenHeight * 0.13,
                            width: screenWidth,
                            // color: Colors.red,
                            color: theme.scaffoldBackgroundColor
                                .withOpacity((changeColor.offsetValue() / 200).clamp(0, 1).toDouble()),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 22.0, left: 10),
                              child: Row(
                                children: [
                                  Visibility(
                                      visible: widget.status,
                                      child: IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          onPressed: () {
                                            print('doinggggg');
                                            pSubIndex.changeSubIndex(0);
                                            Navigator.pushNamed(context, SearchScreen.name);
                                          },
                                          icon: Icon(
                                            Icons.arrow_back_outlined,
                                            color: changeColor.offsetValue() > screenHeight * 0.2
                                                ? theme.primaryColorDark
                                                : Colors.white,
                                          ))),
                                  Visibility(
                                    visible: changeColor.offsetValue() > screenHeight * 0.25,
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          // height:screenHeight *0.068 ,
                                          // width: screenWidth * 0.122,
                                          decoration: BoxDecoration(
                                              image: data.photoUrl.isNotEmpty
                                                  ? DecorationImage(
                                                      image: NetworkImage(data.photoUrl), fit: BoxFit.cover)
                                                  : null,
                                              color: Colors.lightBlueAccent,
                                              shape: BoxShape.circle),
                                          child: data.photoUrl.isEmpty ? ChatUi.getImageLoaderIcon(25) : null,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        AutoSizeText(
                                          data.userName,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.4,
                                              fontSize: (screenHeight * 0.025).clamp(17, 20),
                                              color: theme.primaryColorDark),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))))
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  const Bubble({Key? key, required this.theme, required this.heading, required this.content})
      : super(key: key);

  final String heading;
  final String content;

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    print(screenHeight * 0.0238);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          // height: 400,
          width: screenWidth,
          decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heading,
                style: TextStyle(fontSize: (screenHeight * 0.025).clamp(17, 20), fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                content,
                style: TextStyle(
                    fontSize: (screenHeight * 0.0207).clamp(14, 16),
                    color: theme.primaryColorDark.withOpacity(0.7)),
              )
            ],
          ),
        ),
      ],
    );
  }
}
