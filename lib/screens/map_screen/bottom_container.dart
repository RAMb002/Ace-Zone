import 'package:auto_size_text/auto_size_text.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_stream.dart';
import 'package:chadate_alpha/classes/chat/chat_ui.dart';
import 'package:chadate_alpha/config.dart';
import 'package:chadate_alpha/my_provider/home_screen/home/profile_visibility.dart';
import 'package:chadate_alpha/screens/chat_screens/chat_ui.dart';
import 'package:chadate_alpha/screens/chat_screens/message_log.dart';
import 'package:chadate_alpha/screens/map_screen/bottom_container_loading.dart';
import 'package:chadate_alpha/services/api/stream_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  Widget build(BuildContext context) {
    print(userId);

    print('bottom container');
    return StreamBuilder(
        stream: FirebaseStream.profileData(userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data.docs[0];
            return Container(
              // height: 324,
              padding: EdgeInsets.symmetric(horizontal: 30),
              // color: Colors.blue,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 60,
                        // color: Colors.red,
                      ),
                      Container(
                        // height: 324,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
                        width: MediaQuery.of(context).size.width - 60,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            // Align(alignment: Alignment.topRight, child: Icon(Icons.favorite)),
                            SizedBox(
                              height: 5,
                            ),
                            AutoSizeText(
                              data['userName'],
                              // 'ram prasanth nmodfshfsifhsfdsssihssssss',
                              minFontSize: 16,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                // color: Colors.red
                              ),
                            ),
                            Visibility(
                                visible: data['occupation'].toString().isNotEmpty,
                                child: SizedBox(
                                  height: 6,
                                )),
                            Visibility(
                              visible: data['occupation'].toString().isNotEmpty,
                              child: AutoSizeText(
                                "${data['occupation']}",
                                // 'Software Engineer | Madurai',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                minFontSize: 14,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Theme.of(context).colorScheme.primaryVariant),
                              ),
                            ),
                            Visibility(
                                visible: data['bio'].toString().isNotEmpty,
                                child: SizedBox(
                                  height: 12,
                                )),
                            AutoSizeText(
                              data['bio'],
                              // 'Hey guys, Rambo here, I am a full stack developleer A'
                              //     'freelancer Contact me to collab!!',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              minFontSize: 15,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                // color: Theme.of(context).colorScheme.primaryVariant
                              ),
                            ),
                            Visibility(
                              visible: data['bio'].toString().isNotEmpty,
                              child: SizedBox(
                                height: 15,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  color: Colors.lightBlueAccent,
                                  elevation: 6,
                                  shadowColor: Theme.of(context).colorScheme.primaryContainer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: FlatButton(
                                    splashColor: Colors.transparent,
                                    height: 50,
                                    minWidth: 50,
                                    // padding: EdgeInsets.all(0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                    // color:Theme.of(context).colorScheme.primaryContainer ,
                                    color: Colors.lightBlueAccent,
                                    onPressed: () {},
                                    child: Icon(
                                      Icons.phone,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Card(
                                    // color: Theme.of(context).primaryColor,
                                    color: Colors.lightBlueAccent,
                                    elevation: 6,
                                    shadowColor: Theme.of(context).colorScheme.primaryContainer,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: FlatButton(
                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                        // splashColor: Colors.transparent,
                                        // color: Theme.of(context).primaryColor,
                                        onPressed: () async {
                                          // final client = stream.StreamChatClient(Config.streamApiKey,logLevel:stream.Level.SEVERE);
                                          //
                                          // final  User? user = FirebaseAuth.instance.currentUser;
                                          // stream.Channel channel = await StreamApi.createChannel(
                                          //     client, type: 'sample', id: user!.uid);
                                          // print('channel created');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatUI(
                                                otherUser: userId,
                                                userName: data['userName'],
                                                userImageProfile: data['photoUrl'].toString(),
                                              ),
                                            ),
                                          );
                                          Provider.of<ProfileVisibilityProvider>(context,listen: false).changeStatus(false);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.message,
                                              // color: Theme.of(context).colorScheme.primaryContainer,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 13,
                                            ),
                                            Text(
                                              'Send Message',
                                              style: TextStyle(
                                                  // fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )),
                                  ),
                                )
                              ],
                            ),

                            // Row
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            // color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(40))),
                      ),
                    ],
                  ),
                  Positioned(
                      top: 5,
                      child: Hero(
                        tag: data['userName'],
                        child: CircleAvatar(
                            backgroundColor: Colors.lightBlueAccent,
                            radius: 55,
                            // backgroundImage:data['photoUrl'].toString().isNotEmpty ? NetworkImage(
                            //   data[data['photoUrl'].toString()]
                            // ) : null,
                            child: ClipOval(

                              child: data['photoUrl'].toString().isNotEmpty
                                  ? Image.network(data['photoUrl'].toString(),fit: BoxFit.cover, width: 105,
                                height: 105,)
                                  : ChatUi.getImageLoaderIcon(60)
                            )),
                      )),
                ],
              ),
            );
          } else
            return BottomContainerLoading();
        });
  }
}
// Positioned(
// top: 5,
// child: data['photoUrl'].toString().isNotEmpty ? Container(
// height: 55,
// width: 55,
// decoration: BoxDecoration(
// color: Colors.lightBlueAccent,
// shape: BoxShape.circle,
// image: DecorationImage(
// image: NetworkImage(
// data['photoUrl'],
// ),
// fit: BoxFit.cover
// )
// ),
// ) : Container(
// height: 55,
// width: 55,
// decoration: BoxDecoration(
// shape: BoxShape.circle,
// color: Colors.lightBlueAccent
// ),
// child: Center(child: Icon(Icons.person,size: 60,color:Colors.white,)),
// )),
