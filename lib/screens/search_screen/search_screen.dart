import 'package:auto_size_text/auto_size_text.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/FirebaseApi/firebaseauth/auth_data.dart';
import 'package:chadate_alpha/classes/chat/chat_ui.dart';
import 'package:chadate_alpha/classes/loading.dart';
import 'package:chadate_alpha/my_provider/home_screen/home_screen.dart';
import 'package:chadate_alpha/my_provider/search_screen/other_user.dart';
import 'package:chadate_alpha/screens/profile_screen/user_profile.dart';
import 'package:chadate_alpha/theme/MyThemes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

const borderRadius =  BorderRadius.all(Radius.circular(6));
const whiteColor =Color(0xFFD8D8D8);
const darkColor=Color(0xFF1D282D);

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

   static String name ="searchScreen";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeScreenSubIndexProvider>(context,listen: false).changeSubIndex(0);

    });
  }

  TextEditingController _textEditingController =TextEditingController();
  int count =0;

  var queryResultSet=[];
  var tempSearchStore =[];

  initiateSearch(String value){
    print('initiated search');
    try{
      if(value.length ==0){
        print("clear");
        setState(() {
          tempSearchStore =[];
          queryResultSet =[];
        });
      }
      if(queryResultSet.length==0 && (value.length == 1)){
        print('got in');
        FirebaseApi.searchUsers()
            .then((QuerySnapshot snapshot) {
          for (int i = 0; i < snapshot.docs.length; ++i) {
            print('adding');
            print(snapshot.docs[i].data());
            queryResultSet.add(snapshot.docs[i].data());
          }
          // print(queryResultSet);
          tempSearchStore = [];
          print(queryResultSet);
          queryResultSet.forEach((element) {
            print(element['displayName']);
            String genre = element['displayName'].toString().toLowerCase();
            print(genre);
            if (genre.contains(value.toString().toLowerCase())) {
              print("if part");
              // print(count);
              count++;
              setState(() {
                tempSearchStore.add(element);
              });
            }
            // else if (count == 0) {
            //   print('count 0');
            //   setState(() {
            //     tempSearchStore.clear();
            //   });
            // }
          });
          // print('sfsfsfsssssssssssssssssssssssss');
          // print(tempSearchStore);
        });
      }
      else{
        print('got in else');
        tempSearchStore = [];
        queryResultSet.forEach((element) {
          String genre = element['displayName'].toString().toLowerCase();
          if (genre.contains(value.toString().toLowerCase())) {
            print('checking two');
            count++;
            // print(count);
            setState(() {
              tempSearchStore.add(element);
            });
          } else if (count == 0) {
            print('count 0');

            setState(() {
              tempSearchStore.clear();
            });
          }
        });
      }
    }
    catch (e){
      print(e);
    }
    print(")0000000000000000");
    if(tempSearchStore.isEmpty){
      setState(() {

      });
    }
    print(tempSearchStore);

  }

  String searchText ="";
  bool keyPadFocus = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    print((screenHeight * 0.0191));

    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
           preferredSize: Size(double.infinity,80),
          child: Container(
            // color: Colors.red,
            child: Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 20),
                    child: Container(
                      // margin: EdgeInsets.only(top: 30,left: 30,right: 30),
                      padding: EdgeInsets.only(top: 10),
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color:theme.colorScheme.onSecondary ,

                      ),
                      child: FocusScope(
                        child: Focus(
                          onFocusChange: (focus){
                            print(focus);
                            setState(() {
                              keyPadFocus = focus;
                            });
                          },
                          child: TextField(
                            autofocus: true,
                            controller: _textEditingController,
                            cursorColor: theme.primaryColorDark,
                            onChanged: (value){
                              print(value);
                              initiateSearch(value);
                            },
                            style: TextStyle(
                                color: theme.primaryColorDark
                            ),
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: theme.primaryColorDark.withOpacity(0.4)),
                                hintText: "Search for a name",
                                prefixIcon: IconButton(
                                  constraints: BoxConstraints(),
                                  padding: EdgeInsets.only(bottom: 10),
                                  icon: Icon(Icons.search_outlined,color:keyPadFocus ?
                                  theme.primaryColorDark : Colors.grey,),
                                  onPressed: (){},
                                ),
                                suffixIcon: Visibility(
                                  visible: _textEditingController.text.isNotEmpty,
                                  child: IconButton(
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.only(bottom: 10),
                                    onPressed: (){
                                      setState(() {
                                        _textEditingController.clear();

                                      });
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),

                                focusedBorder:OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ) ,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),
                                fillColor: whiteColor
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3,),
                Divider(height: 5,color: theme.colorScheme.onSecondary,thickness: 2,)
              ],
            ),
          ),

      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0,left: 00,right: 00),
        child: Column(
          children: [
            Visibility(
              visible: tempSearchStore.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  itemCount: tempSearchStore.length,
                    itemBuilder: (context,index){
                  return Visibility(
                    visible: tempSearchStore[index]["userId"] != AuthData.userId,
                    child: FutureBuilder(
                        future: FirebaseApi.getUserNameAndDisplayPictureFromSearch(tempSearchStore[index]["userId"]),
                        builder: (BuildContext context,AsyncSnapshot<Map<String,dynamic>> snapshot){
                          if(snapshot.hasData){
                            String userName =snapshot.data!['userName'];
                            String photoUrl =snapshot.data!['photoUrl'];
                            String occupation = snapshot.data!['occupation'];
                            String userId = tempSearchStore[index]['userId'];
                            print(occupation);

                            print(userId);
                            print(AuthData.userId);
                            // print(photoUrl);
                            // print(snapshot.data!['userName']);
                            return Column(
                              children: [
                                Stack(
                                  alignment : AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 4,horizontal: 0),
                                      // margin: EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: borderRadius,
                                        color: theme.scaffoldBackgroundColor,


                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 30,),
                                          Container(
                                            height:screenHeight * 0.1 ,
                                            width: screenWidth * 0.15,
                                            decoration: BoxDecoration(
                                              image: photoUrl.isNotEmpty ? DecorationImage(
                                                image: NetworkImage(
                                                    photoUrl
                                                ),
                                                fit: BoxFit.cover
                                              ) : null,
                                                color : whiteColor,
                                                shape: BoxShape.circle
                                            ),
                                            child:photoUrl.isNotEmpty?null : Center(
                                              child: ChatUi.getImageLoaderIcon(30,color: Colors.black38),
                                            ),
                                          ),
                                          SizedBox(width: 20,),
                                          Container(
                                            // color: Colors.red,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: screenWidth * 0.6,
                                                  child: AutoSizeText(
                                                    userName,
                                                    // snapshot.data[0]["usernam"],
                                                    minFontSize: (screenHeight * 0.02).clamp(15, 18),
                                                    maxFontSize: (screenHeight * 0.02).clamp(15, 18),
                                                    style: TextStyle(
                                                        color: theme.primaryColorDark
                                                      // fontSize: (screenHeight * 0.02).clamp(15, 18)
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Visibility(visible : occupation.isNotEmpty,child: SizedBox(height: 3,)),
                                                Visibility(
                                                  visible: occupation.isNotEmpty,
                                                  child: Container(
                                                    width: screenWidth * 0.6,
                                                    child: AutoSizeText(
                                                        occupation,
                                                      // minFontSize:(screenHeight * 0.0191).clamp(12, 14).toDouble() ,
                                                      // maxFontSize: (screenHeight * 0.0191).clamp(12, 14).toDouble(),
                                                      style: TextStyle(
                                                        overflow: TextOverflow.ellipsis,
                                                        color: theme.primaryColorDark.withOpacity(0.48),
                                                        fontSize: (screenHeight * 0.0191).clamp(12, 14)
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      // left:10,
                                      left:8,
                                      right:8,
                                      child: Material(
                                        color : Colors.transparent,
                                        child: InkWell(
                                          splashColor : Colors.lightBlueAccent.withOpacity(0.2),
                                          onTap :(){
                                            print('ontap');

                                            final pSubIndexInScreen =Provider.of<HomeScreenSubIndexProvider>(context,listen: false);
                                            final pOtherUser = Provider.of<OtherUserProvider>(context,listen: false);
                                            // pSubIndexInScreen.changeOtherUserId(userId);
                                            pOtherUser.changeOtherUserId(userId);
                                            // print(pSubIndexInScreen.otherUserId);
                                            // print(AuthData.userId);
                                            // print('other user name');
                                            // print(userName);
                                            Navigator.pushNamed(context, UserProfile.name);
                                            pSubIndexInScreen.changeSubIndex(1);
                                            // CupertinoPageRoute(builder: (context)=>UserProfile(userId: userId));
                                            // Navigator.push(context, route)

                                            },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                            margin: EdgeInsets.symmetric(horizontal: 18),
                                            // color: Colors.red,
                                            height:screenHeight * 0.12 ,
                                            decoration: BoxDecoration(
                                              borderRadius: borderRadius
                                            ),

                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                // SizedBox(height: 4,)
                              ],
                            );
                          }else{
                           return LoaderSearch();
                          }

                    }),
                  );

                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoaderSearch extends StatelessWidget {
  const LoaderSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                SizedBox(width: 30,),
                Container(
                  height:screenHeight * 0.1 ,
                  width: screenWidth * 0.15,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // color: Theme.of(context).colorScheme.primaryVariant,
                      width: screenWidth * 0.55,
                      // height: 50,
                      // color: Colors.red,
                      child: Container(
                        // color: Colors.red,
                        width : screenWidth * 0.26,
                        height: LoadingData.shimmerContainerHeight,
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      height: LoadingData.shimmerContainerHeight,
                      width: screenWidth * 0.28,
                      color: Theme.of(context).colorScheme.primaryVariant,
                    )
                  ],
                ),


              ],
            ),
          ),
          // SizedBox(
          //   height: 20,
          // )
        ],
      ),
    );;
  }
}

