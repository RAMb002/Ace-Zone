import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:chadate_alpha/oops/chat/chat_message_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUpdate extends FirebaseApi {

  static Future updateProfileData(String userId,String data,String fieldName)async{
    var path = FirebaseFirestore.instance.collection('userData').doc(userId).collection('profileData');
    path.get().then((value)async => {
      await path.doc(value.docs[0].id).update({fieldName : data}),
      print('updated')
    });
  }

  static updateChatLog(String currentUserId,String otherUserId,ChatMessageLogOops chatMessageLogOops,){
    FirebaseFirestore.instance.collection("userData").doc(currentUserId).collection("messageLog")
        .doc(otherUserId).update(chatMessageLogOops.setMessageLog());

  }


}