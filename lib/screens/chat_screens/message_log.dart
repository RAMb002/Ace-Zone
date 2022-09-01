import 'package:auto_size_text/auto_size_text.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_stream.dart';
import 'package:chadate_alpha/FirebaseApi/firebaseauth/auth_data.dart';
import 'package:chadate_alpha/classes/chat/chat_ui.dart';
import 'package:chadate_alpha/classes/chat/time_filter.dart';
import 'package:chadate_alpha/classes/chat/timeago.dart';
import 'package:chadate_alpha/classes/loading.dart';
import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/screens/chat_screens/chat_ui.dart';
import 'package:chadate_alpha/screens/chat_screens/extended_profile.dart';
import 'package:chadate_alpha/theme/MyThemes.dart';
import 'package:chadate_alpha/trial_data/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';


const customLightColor =Color(0xFF868686);
class MessageLog extends StatelessWidget {
  const MessageLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final ThemeData theme = Theme.of(context);
    print(screenHeight * 0.0354);
    // print(13.clamp(16, 20));
    // print((screenHeight * 0.025).clamp(16, 20));
    // print(screenHeight * 0.02.clamp(16, 20));
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: theme.primaryColorDark),
        title: Text(
          "Messages",
          style: TextStyle(
            letterSpacing: 1,
            fontSize: (screenHeight * 0.025).clamp(17, 18.5),
            color: theme.primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding, vertical: 12),
                  child: Container(
                    // color: Colors.blue,
                    height: screenHeight * 0.15,
                    child: ListView.builder(
                        shrinkWrap: true,
                        // physics: ClampingScrollPhysics(),
                        itemCount: 10,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                // color: Colors.red,
                                width: screenWidth * 0.18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: screenHeight * 0.08,
                                      width: screenWidth * 0.18,
                                      decoration: BoxDecoration(
                                          color: customLightColor, shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            Data.data[index].imageUrl
                                          ),
                                          fit: BoxFit.cover
                                        )

                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    AutoSizeText(
                                      Data.data[index].name,
                                      // "fsifsiofhsiofhsfioshfois",
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      // minFontSize: 8,
                                      maxFontSize: (screenHeight * 0.025).clamp(14, 15),
                                      minFontSize: (screenHeight * 0.025).clamp(14, 14),
                                      // minFontSize: screenHeight * 0.00,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: theme.primaryColorDark, fontSize: screenHeight * 0.022),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 11,
                              )
                            ],
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                  // height: 500,
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.7
                  ),
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                      color: theme.colorScheme.onSecondary
                    // color: Colors.blue
                  ),
                  child: StreamBuilder(
                    stream: FirebaseStream.messageLog(AuthData.userId),
                    builder: (BuildContext context,AsyncSnapshot snapshot){
                      if(snapshot.hasData){
                        return Align(
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data.docs[index];
                                String otherUserId = data['userId'];
                                Timestamp time = data['timeStamp'];
                                // print('time time time tiem time teim');
                                // print(time.toDate());
                                // // print(time.millisecondsSinceEpoch);
                                // // print(DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch));
                                // print(time.toDate().hour);
                                // print(DateFormat("yyyy-MM-dd").format(DateTime.now()));
                                // print(DateFormat('hh:mm:ss a').format(DateTime.now()));
                                // // print(DateFormat())
                                // String d =DateFormat('hh:mm ').format(time.toDate());



                                return StreamBuilder(
                                  stream: FirebaseStream.profileData(data['userId']),
                                  builder: (BuildContext context,AsyncSnapshot profileSnapshot){
                                    if(profileSnapshot.hasData){
                                      var profileData = profileSnapshot.data.docs[0];
                                      String photoUrl = profileData['photoUrl'];
                                      String userName =profileData['userName'];
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              onTap: (){
                                                Navigator.push(context, CupertinoPageRoute(builder: (context)=>
                                                ChatUI(
                                                    otherUser: otherUserId,
                                                    userName: userName,
                                                    userImageProfile: photoUrl),),);
                                                // Navigator.push(context, CupertinoPageRoute(builder: (context) => ChatUI(
                                                //   otherUser: ,
                                                // )));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(bottom: 10,top: 10),
                                                // height: 50,
                                                // width: 400,
                                                // color: Colors.red,
                                                child: Row(
                                                  children: [
                                                    GestureDetector(
                                                      onTap:(){
                                                        print("tapped circle");
                                                        Navigator.of(context).push(
                                                            new PageRouteBuilder(
                                                              fullscreenDialog: false,
                                                                opaque: false,
                                                                barrierDismissible:true,
                                                                pageBuilder: (BuildContext context, _, __) {
                                                                  return IgnorePointer(
                                                                    child: Container(
                                                                      color: Colors.black.withOpacity(0.7),
                                                                      child: Column(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Hero(
                                                                            tag : userName,
                                                                            child: Stack(
                                                                              alignment: AlignmentDirectional.center,
                                                                              children: [
                                                                                Container(
                                                                                  height: screenHeight*0.45,
                                                                                  width: screenWidth * 0.6,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                    color: customLightColor,
                                                                                    image: photoUrl.isNotEmpty ? DecorationImage(
                                                                                      image: NetworkImage(
                                                                                        photoUrl
                                                                                      ),
                                                                                      fit: BoxFit.cover
                                                                                    ) : null
                                                                                  ) ,
                                                                                  child: photoUrl.isEmpty ?ChatUi.getImageLoaderIcon(150) : null,
                                                                                ),
                                                                                // Positioned(
                                                                                //   bottom: 0,
                                                                                //     child: Container(
                                                                                //   width: screenWidth * 0.6,
                                                                                //   height: 50,
                                                                                //   color: Colors.black.withOpacity(0.8),
                                                                                //       child: Row(
                                                                                //         children: [
                                                                                //           Expanded(
                                                                                //             child: Padding(
                                                                                //               padding: const EdgeInsets.all(8.0),
                                                                                //               child: FlatButton(onPressed: (){},
                                                                                //                   // padding: EdgeInsets.all(10),
                                                                                //                   child: Icon(Icons.comment,color: Colors.white,)),
                                                                                //             ),
                                                                                //           ),
                                                                                //           SizedBox(w)
                                                                                //           Expanded(
                                                                                //             child: FlatButton(onPressed: (){},
                                                                                //                 child: Icon(Icons.info_outline,color: Colors.white,)),
                                                                                //           ),
                                                                                //
                                                                                //         ],
                                                                                //       ),
                                                                                // ))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                            )
                                                        );
                                                        // showDialog(
                                                        //   barrierDismissible: true,
                                                        //   context: context,
                                                        //   // isScrollControlled: true,
                                                        //   builder: (context) => ExtendedProfile(
                                                        //     userName: userName,
                                                        //     userId: otherUserId,
                                                        //     photoUrl: photoUrl,
                                                        //   ),
                                                        // );
                                                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                        // ExtendedProfile()));

                                              },
                                                      child: Hero(
                                                        tag: userName,
                                                        child: Container(
                                                          height: screenHeight * 0.068,
                                                          width: screenWidth * 0.165,
                                                          decoration: BoxDecoration(
                                                              color: customLightColor,
                                                              shape: BoxShape.circle,
                                                              boxShadow: <BoxShadow>[
                                                                BoxShadow(
                                                                    color: Colors.black54,
                                                                    blurRadius: 5.0,
                                                                    // blurStyle: BlurStyle.normal,
                                                                    offset: Offset(0.0, 1)
                                                                )
                                                              ],
                                                              image:photoUrl.isNotEmpty ? DecorationImage(
                                                                  image: NetworkImage(
                                                                    photoUrl,
                                                                  ),
                                                                  fit: BoxFit.cover
                                                              ) : null
                                                          ),
                                                          child: photoUrl.isNotEmpty ? null : ChatUi.getImageLoaderIcon((screenHeight * 0.0354).clamp(24, 30)),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.03,
                                                    ),
                                                    Container(
                                                      width: screenWidth * 0.72,
                                                      // height: 50,
                                                      // color: Colors.red,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Container(
                                                                // color: Colors.red,
                                                                width : screenWidth * 0.5,
                                                                child: Text(
                                                                  userName,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(
                                                                      color: theme.primaryColorDark,
                                                                      fontWeight: FontWeight.bold,
                                                                      // fontSize: screenHeight * 0.02
                                                                      fontSize: (screenHeight * 0.02).clamp(15.5, 18)
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox( width: screenWidth * 0.04 ,),
                                                              Align(
                                                                alignment : Alignment.centerRight,
                                                                child: Container(
                                                                  // color: Colors.blue,
                                                                  width: screenWidth * 0.15,
                                                                  child: Text(
                                                                    TimeFilter.timeStampToValidTime(time),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    textAlign: TextAlign.right,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                      fontSize: (screenHeight * 0.0155).clamp(11, 12),
                                                                      color: customLightColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Container(
                                                            width: screenWidth * 0.8,
                                                            child: Text(
                                                              data['lastMessage'],
                                                              // "jfshfioshfosihfsoifhsoifhighdooihoiihdoighdoighoihiohj",
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  color: theme.primaryColorDark.withOpacity(0.5),
                                                                  // fontSize: 14
                                                                  fontSize: (screenHeight * 0.0155).clamp(14, 16)
                                                              ),
                                                            ),
                                                          )

                                                        ],
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 20,
                                          // )
                                        ],
                                      );
                                    }
                                    else{
                                      return MessageLogLoader(length: snapshot.data.docs.length,);
                                    }
                                  },

                                );
                              }),
                        );
                    }
                      else{
                        return MessageLogLoader(length: 10,);
                      }
                    },
                  )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MessageLogLoader extends StatelessWidget {
  const MessageLogLoader({Key? key,required this.length}) : super(key: key);

  final int length;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: 500,
      child: ListView.builder(
        itemCount: length,
          itemBuilder: (context,index){
        return Shimmer.fromColors(
          enabled: true,
          period: Duration(milliseconds: 1000),
          baseColor: Colors.grey,
          highlightColor:Provider.of<MyThemesProvider>(context).getThemeMode() == ThemeMode.dark ?Colors.grey.shade300 : Colors.grey.shade700,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 10,top: 10),
                // height: 50,
                // width: 400,
                // color: Colors.red,
                child: Row(
                  children: [
                    Container(
                      height: screenHeight * 0.065,
                      width: screenWidth * 0.165,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.03,
                    ),
                    Container(
                      // color: Theme.of(context).colorScheme.primaryVariant,
                      width: screenWidth * 0.72,
                      // height: 50,
                      // color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // color: Colors.red,
                                width : screenWidth * 0.26,
                                height: LoadingData.shimmerContainerHeight,
                                color: Theme.of(context).colorScheme.primaryVariant,
                              ),
                              SizedBox( width: screenWidth * 0.04 ,),
                              Align(
                                alignment : Alignment.centerRight,
                                child: Container(
                                  // color: Colors.blue,
                                  width: screenWidth * 0.08,
                                  color: Theme.of(context).colorScheme.primaryVariant,
                                  height: LoadingData.shimmerContainerHeight,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Container(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            width: screenWidth * 0.47,
                            height: LoadingData.shimmerContainerHeight,
                          )

                        ],
                      ),
                    ),


                  ],
                ),
              ),
              // SizedBox(
              //   height: 20,
              // )
            ],
          ),
        );
      }),
    );
  }
}

