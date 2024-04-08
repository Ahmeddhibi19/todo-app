import 'package:flutter/material.dart';
import 'package:todo_app_v1/Service/Auth_Service.dart';
import 'package:todo_app_v1/pages/AddToDo.dart';
import 'package:todo_app_v1/pages/SignInPage.dart';
import 'package:todo_app_v1/pages/SignUpPage.dart';
import 'package:todo_app_v1/Custom/TodoCard.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Today's Schedule",
          style: TextStyle(
            fontSize: 34,
            fontWeight:FontWeight.bold,
            color: Colors.white
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/DAB03919-10470989.webp"),
          ),
          SizedBox(width:25),
       
      ],
      bottom:PreferredSize(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Text(
              "Monday 21",
                style: TextStyle(
                fontSize: 34,
                fontWeight:FontWeight.w600,
                color: Colors.white
              ),
              ),
          ),
        ),
      preferredSize: Size.fromHeight(35),),
      ),
      bottomNavigationBar:BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size: 32,color: Colors.white,),
             label: 'Home',
            
            ),
              BottomNavigationBarItem(
            icon: InkWell(
              onTap:(){
                Navigator.push(
                  context,
                   MaterialPageRoute(builder: (builder)=>AddToDoPage())
                  );
              } ,
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors:[
                    Colors.indigoAccent,
                    Colors.purple
                  ],
                  )
                ),
                child: Icon(Icons.add,size: 32,color: Colors.white,)
                ),
            ),
            label: 'Add',
            
            ),
             BottomNavigationBarItem(
            icon: Icon(Icons.settings,size: 32,color: Colors.white,),
            label: 'Settings',
            ),
        ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20
            ),
            child: Column(
              children: [
               TodaCard(
                  title: "wake up",
                  check: true,
                  iconBgColore: Colors.white,
                  iconColor: Colors.red,
                  iconData: Icons.alarm,
                  time: "10 am",
               ),
               SizedBox(height: 10,),
               TodaCard(
                  title: "Gym",
                  check: false,
                  iconBgColore: Color(0xff2cc8d9),
                  iconColor: Colors.white,
                  iconData: Icons.run_circle,
                  time: "11 am",
               ),
               SizedBox(height: 10,),
               TodaCard(
                  title: "Buy some food",
                  check: false,
                  iconBgColore: Color(0xfff19733),
                  iconColor: Colors.white,
                  iconData: Icons.local_grocery_store,
                  time: "13 am",
               ),
               SizedBox(height: 10,),
              ],
            ),
          ),
        ),
    );
  }
}
/*
IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await authClass.logout(context: context);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => SignInPage()),
                (route) => false);
          },
        ),
  */