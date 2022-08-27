import 'package:firebase_auth/firebase_auth.dart';

class AuthData{

  static String get userId {
    final User? user = FirebaseAuth.instance?.currentUser;
    String ? id= user?.uid;
    return id.toString();
  }
}