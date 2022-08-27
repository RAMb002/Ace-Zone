import 'package:chadate_alpha/FirebaseApi/firebase_stream.dart';
import 'package:chadate_alpha/oops/chat/chat_message_log.dart';
import 'package:chadate_alpha/oops/chat/chat_texting.dart';
import 'package:chadate_alpha/oops/profile_oops.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi extends FirebaseStream {
  static setProfileData(ProfileOops oops, String userId) async {
    var path = FirebaseFirestore.instance.collection('userData').doc(userId).collection('profileData').doc();
    await path.set(oops.profileData());
  }

  static setPhoneNumber(String phoneNumber) {
    var path = FirebaseFirestore.instance.collection("globalPhoneNumber").doc();
    path.set({'phoneNumber': phoneNumber});
  }

  static setEmail(String email) {
    var path = FirebaseFirestore.instance.collection("globalEmail").doc();
    path.set({'email': email});
  }

  static setCoordinates(Coordinates coordinates) {
    var path = FirebaseFirestore.instance.collection("globalCoordinates").doc();
    path.set(coordinates.coordinatesData());
  }

  static setDisplayName(String displayName, String userId) {
    FirebaseFirestore.instance
        .collection("globalDisplayName")
        .doc()
        .set({"displayName": displayName, "userId": userId});
  }

  static Future<bool> checkDisplayNamePresence(String displayName) async {
    bool presence = false;
    await FirebaseFirestore.instance
        .collection("globalDisplayName")
        .where("displayName", isEqualTo: displayName)
        .get()
        .then((value) => {
              if (value.docs.length == 0)
                {
                  presence = false,
                }
              else
                {
                  presence = true,
                }
            });
    return presence;
  }

  static Future<bool> checkEmailOrPhonePresence(
      String emailOrPhone, String collectionName, String name) async {
    bool status = false;
    var path = FirebaseFirestore.instance.collection(collectionName).get();
    await path.then((value) => {
          if (name == 'email')
            {
              if (value.docs.length == 0)
                {
                  print('empeyydd'),
                  status = false,
                }
              else if (value.docs[0].data()['email'] == emailOrPhone)
                {
                  // print(value.docs[0].data()['email']),

                  status = true
                }
              else
                {status = false}
            }
          else if (name == 'phone')
            {
              if (value.docs.length == 0)
                {print('emtpy'), status = false}
              else if (value.docs[0].data()['phoneNumber'] == emailOrPhone)
                {
                  // print(value.docs[0].data()['phoneNumber']),

                  status = true
                }
              else
                {status = false}
            }
        });
    return status;
  }

  static setChatMessage(ChatTextingOops chatTextingOops, String currentUserId, String otherUserId) {
    privateChat(currentUserId, otherUserId, chatTextingOops);
    privateChat(otherUserId, currentUserId, chatTextingOops);
  }

  static void privateChat(String currentUserId, String otherUserId, ChatTextingOops chatTextingOops) {
    FirebaseFirestore.instance
        .collection("userData")
        .doc(currentUserId)
        .collection("chats")
        .doc(otherUserId)
        .collection("privateChat")
        .doc()
        .set(chatTextingOops.setPrivateChatData());
  }

  static setChatLog(ChatMessageLogOops chatMessageLogOops, String currentUserId, String otherUserId) {
    var collection =
        FirebaseFirestore.instance.collection("userData").doc(currentUserId).collection("messageLog");
    collection.get().then((value) => {
          if (value.docs.length == 0)
            {
              print('length ==0'),
              collection.doc(otherUserId).set(chatMessageLogOops.setMessageLog()),
            }
          else
            {
              print("length !=0"),
              value.docs.forEach((element) {
                if (element.id == otherUserId) {
                  collection.doc(otherUserId).update(chatMessageLogOops.setMessageLog());
                } else {
                  collection.doc(otherUserId).set(chatMessageLogOops.setMessageLog());
                }
              })
            }
        });
    // collection.get().then((value) {
    //   if(value.docs.length ==0 ){
    //     collection.doc(otherUserId).set(chatMessageLogOops.setMessageLog());
    //     print('new');
    //   }else {
    //     collection.doc(otherUserId).update(chatMessageLogOops.setMessageLog());
    //     print('nooo');
    //   };
    // });
  }

  static searchUsers() {
    return FirebaseFirestore.instance.collection('globalDisplayName').where("userName").get();
  }

  static Future<Map<String, dynamic>> getUserNameAndDisplayPictureFromSearch(String userId) async {
    Map<String, dynamic> map = {};
    await FirebaseFirestore.instance
        .collection("userData")
        .doc(userId)
        .collection("profileData")
        .get()
        .then((value) => {
              map.addAll({
                "userName": value.docs[0].data()['userName'],
                "photoUrl": value.docs[0].data()['photoUrl'],
                "occupation": value.docs[0].data()['occupation']
              }),
            });
    return map;
  }
}
