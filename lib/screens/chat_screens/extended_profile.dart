import 'package:flutter/material.dart';

class ExtendedProfile extends StatelessWidget {
  const ExtendedProfile({Key? key,
  required this.userName,
  required this.userId,
  required this.photoUrl}) : super(key: key);

  final String userName;
  final String userId;
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final _key = GlobalKey<FormState>();


    return AlertDialog(
      contentPadding: EdgeInsets.only(bottom: 10,top: 20,left: 30,right: 10),
      backgroundColor: Colors.grey.shade900,
      key: _key,
      content: Form(
        child: Hero(
          tag: userName,
          child: Container(
            height: screenHeight * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  photoUrl
                ),
                fit: BoxFit.cover
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container()

              ],
            ),
          ),
        ),

      ),
    );
  }
}
