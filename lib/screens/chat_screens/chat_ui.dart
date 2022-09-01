import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_stream.dart';
import 'package:chadate_alpha/FirebaseApi/firebase_update.dart';
import 'package:chadate_alpha/FirebaseApi/firebaseauth/auth_data.dart';
import 'package:chadate_alpha/classes/chat/chat_ui.dart';
import 'package:chadate_alpha/config.dart';
import 'package:chadate_alpha/constants/constants.dart';
import 'package:chadate_alpha/main.dart';
import 'package:chadate_alpha/my_provider/chat/chat_message/chat_message.dart';
import 'package:chadate_alpha/my_provider/home_screen/home_screen.dart';
import 'package:chadate_alpha/my_provider/profile_screen/app_bar_color.dart';
import 'package:chadate_alpha/my_provider/search_screen/other_user.dart';
import 'package:chadate_alpha/my_provider/search_screen/third_chat.dart';
import 'package:chadate_alpha/my_provider/stream/client_and_channel.dart';
import 'package:chadate_alpha/oops/chat/chat_message_log.dart';
import 'package:chadate_alpha/oops/chat/chat_texting.dart';
import 'package:chadate_alpha/screens/profile_screen/user_profile.dart';
import 'package:chadate_alpha/services/api/stream_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';


import 'package:provider/provider.dart';

class ChatUI extends StatefulWidget {
  ChatUI(
      {Key? key,
      required this.otherUser,
      required this.userName,
      required this.userImageProfile,
      this.status = false})
      : super(key: key);

  final String otherUser;
  final String userName;
  final String userImageProfile;
  bool status;


  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _timeScrollController = ScrollController();

  final PageController _pageController = PageController(
    // viewportFraction: 0.8,
    initialPage: 0,
  );

  // late var channel;

  @override
  void initState() {
    // TODO: implement initState
    final pScroll = Provider.of<ChatMessageProvider>(context, listen: false);
    _scrollController.addListener(() {
      pScroll.changeOffset(_scrollController.position.maxScrollExtent);
      pScroll.changeScrollOffset(_scrollController.offset);
    });
    super.initState();
    // assignChannel();
    // streamInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // print((screenHeight * 0.0220));
    // print((screenHeight * 0.015));

    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_back_outlined,
                  ),
                  constraints: BoxConstraints(),
                  onPressed: () {
                    if (widget.status) {
                      Provider.of<ThirdChat>(context, listen: false).changeStatus(false);
                      Provider.of<ScrollAppBarColor>(context, listen: false).changeOffSetValue(0);
                    }
                    FocusScope.of(context).unfocus();
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: 5,
                ),
                Hero(
                  tag: widget.userName,
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.lightBlueAccent,
                        image: widget.userImageProfile.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(
                                  widget.userImageProfile,
                                ),
                                fit: BoxFit.cover)
                            : null),
                    child: widget.userImageProfile.isNotEmpty ? null : ChatUi.getImageLoaderIcon(24),
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        width: screenWidth * 0.5,
                        child: Text(
                          widget.userName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: (screenHeight * 0.02).clamp(16, 19), color: theme.primaryColorDark),
                        ),
                      ),
                    ),
                    Positioned(
                        child: Material(
                          color: Colors.transparent,
                      child: InkWell(
                        onTap: (){
                          Provider.of<OtherUserProvider>(context, listen: false).changeOtherUserId(widget.otherUser);
                          Navigator.push(context, CupertinoPageRoute(builder: (context)=>
                              UserProfile(status: false,)));
                        },
                        splashColor: Colors.transparent,
                        child: Container(
                          height: 50,
                          width: screenWidth * 0.5,
                          // color: Colors.transparent,
                        ),
                      ),
                    ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        // pageSnapping: false,
        padEnds: true,
        onPageChanged: (value) {
          _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        },
        controller: _pageController,
        children: [

          ChatData(
            screenHeight: screenHeight,
            scrollController: _scrollController,
            widget: widget,
            screenWidth: screenWidth,
            theme: theme,
            timeStatus: false,
          ),
          Consumer<ChatMessageProvider>(
            builder: (context, data, child) => ChatData(
              screenHeight: screenHeight,
              scrollController: _timeScrollController,
              widget: widget,
              screenWidth: screenWidth,
              theme: theme,
              timeStatus: true,
            ),
          ),



        ],
      ),

      extendBody: true,
      floatingActionButton: Container(
        width: screenWidth - 30,
        padding: EdgeInsets.all(0),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
          tileColor: theme.colorScheme.secondaryContainer,
          // contentPadding: EdgeInsets.symmetric(horizontal: 20),
          leading: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: IconButton(
              splashColor: Colors.transparent,
              constraints: BoxConstraints(),
              padding: EdgeInsets.only(left: 0),
              color: Colors.grey,
              icon: Icon(Icons.camera_alt),
              onPressed: () {},
            ),
          ),
          title: TextField(
            controller: _messageController,
            maxLines: 1,
            cursorColor: Colors.lightBlueAccent,
            cursorHeight: 20,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Message",
              hintStyle: TextStyle(color: Colors.white60, fontSize: (screenHeight * 0.02).clamp(16, 18)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
            onSubmitted: (value) {
              sendMessage();
            },
          ),
          trailing: IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.zero,
              onPressed: () {
                sendMessage();
              },
              icon: Icon(
                Icons.send,
                color: Colors.white,
              )),
        ),
      ),
    );
  }

  void sendMessage() {
    final pScroll = Provider.of<ChatMessageProvider>(context, listen: false);
    print(pScroll.offset);
    if (_messageController.text.isNotEmpty) {
      ChatTextingOops chatInput =
          ChatTextingOops(currentUserId: AuthData.userId, message: _messageController.text);
      FirebaseApi.setChatMessage(chatInput, AuthData.userId, widget.otherUser);
      ChatMessageLogOops chatMessageLogOops =
          ChatMessageLogOops(lastMessage: _messageController.text, userId: widget.otherUser);
      FirebaseApi.setChatLog(chatMessageLogOops, AuthData.userId, widget.otherUser);
      ChatMessageLogOops chatMessageLogOopsTwo =
          ChatMessageLogOops(lastMessage: _messageController.text, userId: AuthData.userId);
      FirebaseApi.setChatLog(chatMessageLogOopsTwo, widget.otherUser, AuthData.userId);

      // FirebaseUpdate.updateChatLog(widget.userName, AuthData.userId, chatMessageLogOops);
      _messageController.clear();
      // _scrollController.animateTo(pScroll.offset,
      //     duration: Duration(milliseconds: 50), curve: Curves.easeIn);
    }
  }
}

class ChatData extends StatelessWidget {
  const ChatData(
      {Key? key,
      required this.screenHeight,
      required ScrollController scrollController,
      required this.widget,
      required this.screenWidth,
      required this.theme,
      required this.timeStatus,


      })
      : _scrollController = scrollController,
        super(key: key);

  final double screenHeight;
  final ScrollController _scrollController;
  final ChatUI widget;
  final double screenWidth;
  final ThemeData theme;
  final bool timeStatus;
  // final String otherUserId;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: kHorizontalPadding + 2,
            right: kHorizontalPadding + 2,
            top: 15,
            bottom: screenWidth * 0.2),
        child: StreamBuilder(
            stream: FirebaseStream.privateChat(AuthData.userId, widget.otherUser),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (timeStatus) {
                    final pScroll = Provider.of<ChatMessageProvider>(context, listen: false);
                    _scrollController.jumpTo(pScroll.scrollOffset);
                  }
                  // if(_scrollController.hasClients){
                  if (!timeStatus) {
                    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 100), curve: Curves.easeIn);
                  }
                  // }
                });
                print(snapshot.data.docs.length);
                return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data.docs[index];
                      bool userDecision = AuthData.userId == data['currentUserId'];

                      String time = DateFormat('hh:mm a').format(data["timeStamp"].toDate());

                      return Column(
                        children: [
                          !timeStatus
                              ? Row(
                                  mainAxisAlignment:
                                      userDecision ? MainAxisAlignment.end : MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        constraints: BoxConstraints(
                                          maxWidth: screenWidth * 0.7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: userDecision
                                              ? theme.colorScheme.onSecondaryContainer
                                              : Colors.lightBlueAccent,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                        child:Text(
                                              data['message'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  // fontSize: 14
                                                  fontSize: (screenHeight * 0.02).clamp(15, 16)),
                                            )
                                         )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        constraints: BoxConstraints(
                                          maxWidth: screenWidth * 0.7,
                                          minWidth: 200
                                        ),
                                        // color: Colors.transparent,
                                        child: Stack(
                                              children: [
                                                Text(
                                                  data['message'],
                                                  style: TextStyle(
                                                      color: theme.scaffoldBackgroundColor,
                                                      // fontSize: 14
                                                      fontSize: (screenHeight * 0.02).clamp(15, 16)),
                                                ),
                                                Positioned(
                                                  left:0,
                                                  top: 0,
                                                  bottom: 0,
                                                  child:    Container(
                                                    color: theme.scaffoldBackgroundColor,
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: (screenHeight * 0.0220).clamp(15, 17),
                                                          width: (screenHeight * 0.0220).clamp(15, 17),
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(color: theme.primaryColorDark)
                                                          ),
                                                          child: Center(child: Icon(userDecision ? Icons.arrow_forward_rounded : Icons.arrow_back_outlined,size: (screenHeight * 0.015).clamp(10, 12),color: theme.primaryColorDark,)),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        Container(
                                                          color: theme.scaffoldBackgroundColor,
                                                          width: screenWidth * 0.9,
                                                          height:1000,
                                                          child: Text(
                                                            time ,
                                                            style: TextStyle(
                                                                color: theme.primaryColorDark,
                                                                // fontSize: 14
                                                                fontSize: (screenHeight * 0.018).clamp(12, 14)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                        ),
                                  ],
                                ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    });
              }
              // else return Center(child: CircularProgressIndicator(),);
              else
                return Container();
            }));
  }
}
