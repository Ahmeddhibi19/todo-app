import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/widgets.dart';
import 'package:todo_app_v1/Service/Auth_Service.dart';
import 'package:todo_app_v1/pages/AddToDo.dart';
import 'package:todo_app_v1/pages/HomePage.dart';
import 'package:todo_app_v1/pages/SignInPage.dart';
import 'package:todo_app_v1/pages/SignUpPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

Widget currentPage=SignInPage();
AuthClass authClass= AuthClass();

 @override
void initState() {
  super.initState();
  checkLogin();
  
}

void checkLogin() async{
String? token = await authClass.getToken();
if(token!=null){
  setState(() {
    currentPage=HomePage();
  });
}
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
