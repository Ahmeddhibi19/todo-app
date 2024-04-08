import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import 'package:todo_app_v1/pages/HomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  GoogleSignIn _googleSignIn = GoogleSignIn(
      // Optional clientId
      // clientId: 'your-client_id.apps.googleusercontent.com',
      scopes: ['email']);

  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          storeTokenAndSata(userCredential);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        final snackBar = SnackBar(content: Text("unable to sign up"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> storeTokenAndSata(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: userCredential.credential?.token.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
  }
  Future<String?>  getToken() async{
    return await  storage.read(key: "token");
  }

  Future<void>  logout({required BuildContext context}) async{

    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      final snackBar = SnackBar(content : Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber , BuildContext context ,Function setData) async{
    PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async{
      showSnackBar(context,"verification completed");
    };
    PhoneVerificationFailed verificationFailed = (FirebaseAuthException exception){
      showSnackBar(context,exception.toString());
    };
    PhoneCodeSent codeSent = (String verificationId,[int? forceResendingToken]) {
      showSnackBar(context,"verification code sent on the phone number");
      setData(verificationId);
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId){
      showSnackBar(context,"time out");
    };
    try{
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
         verificationFailed: verificationFailed, 
         codeSent: codeSent, 
         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }catch(e){
      showSnackBar(context,e.toString());
    }
  }

  void showSnackBar(BuildContext context,String text){
     final snackBar = SnackBar(content : Text(text));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> signInWithPhoneNumber(String verificationId,String smsCode,BuildContext context) async{
    try{
      AuthCredential credential=PhoneAuthProvider.credential(
        verificationId: verificationId,
         smsCode: smsCode);
        UserCredential userCredential= await auth.signInWithCredential(credential);
        storeTokenAndSata(userCredential);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
              showSnackBar(context, "logged in");

    }catch(e){
        showSnackBar(context, e.toString());
    };
  }
  

}
