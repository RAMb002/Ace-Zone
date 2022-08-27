import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService{

  // Stream<User?> get authSateChanges => FirebaseAuth.instance.authStateChanges();
   static Future<String> signIn({String? email,String? password})async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.toString(), password: password.toString());
      return "true";
    }
    on FirebaseAuthException catch(e){
      return e.message.toString();
    }
  }

   static Future<String> signUp({String? email,String? password})async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.toString(), password: password.toString());
      return "true";
    }
    on FirebaseAuthException catch(e){
      return e.message.toString();
    }
  }
  static signOut()async{
     try{
       await FirebaseAuth.instance.signOut();
     }
     on FirebaseAuthException catch(e){
       return e.message.toString();
     }
  }
}