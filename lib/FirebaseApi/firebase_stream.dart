import 'package:chadate_alpha/FirebaseApi/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStream{
  static Stream coordinateSnapshots(){
    return FirebaseFirestore.instance.collection("globalCoordinates").snapshots();
  }
  static Stream getUserCoordinates(String userId){
   return FirebaseFirestore.instance.collection("globalCoordinates").where("userId",isEqualTo:userId).get().asStream();
  }

  static Stream profileData(String userId){
    return FirebaseFirestore.instance.collection('userData').doc(userId).collection('profileData').snapshots();
  }

  static Stream privateChat(String currentUserId,String otherUserId){
    return FirebaseFirestore.instance.collection('userData').doc(currentUserId).collection("chats")
        .doc(otherUserId)
        .collection("privateChat").orderBy("timeStamp").snapshots();
  }

  static Stream messageLog(String currentUserId){
    return FirebaseFirestore.instance.collection("userData").doc(currentUserId)
        .collection("messageLog").orderBy("timeStamp").snapshots();
  }

  static Stream chatLog(String currentUserId){
    return FirebaseFirestore.instance.collection("userData").doc(currentUserId)
        .collection("chats").snapshots();
  }
}