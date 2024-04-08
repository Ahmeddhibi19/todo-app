import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app_v1/Service/Auth_Service.dart';
import 'package:todo_app_v1/pages/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todo_app_v1/pages/HomePage.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPgeState createState() => _SignInPgeState();
}

class _SignInPgeState extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              buttonItem("assets/google.svg", "continue with google", 25,(){
                authClass.googleSignIn(context);
              }),
              SizedBox(
                height: 15,
              ),
              buttonItem("assets/phone.svg", "continue with phone", 30,(){}),
              SizedBox(
                height: 15,
              ),
              Text("Or", style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(
                height: 15,
              ),
              texItem("email..", _emailController, false),
              SizedBox(
                height: 15,
              ),
              texItem("password...", _passwordController, true),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 30,
              ),
              colorButton(),
              SizedBox(
                height: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "if you all don't have an account ?   ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => SignUpPage()),
                          (route) => false);
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(
                          color: Color.fromARGB(255, 231, 9, 76),
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Forgot password ??",
                style: TextStyle(
                  color: Color.fromARGB(255, 250, 247, 248),
                  fontSize: 23,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonItem(String imagepath, String buttonName, double size,Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        
        height: 60,
        width: MediaQuery.of(context).size.width - 60,
        child: Card(
          color: Colors.black,
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                width: 1,
                color: Colors.grey,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagepath,
                height: size,
                width: size,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: TextStyle(color: Colors.white, fontSize: 17),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget texItem(
      String labelText, TextEditingController controller, bool obscureText) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width - 70,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 17, color: Colors.white),
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 17, color: Colors.white),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.amber,
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.grey,
                ))),
      ),
    );
  }

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);
          print(userCredential.user?.email);
          setState(() {
            circular = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              Color(0xfffd746c),
              Color(0xffff9068),
              Color(0xfffd746c)
            ])),
        child: Center(
          child: circular
              ? CircularProgressIndicator()
              : Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
        ),
      ),
    );
  }
}
