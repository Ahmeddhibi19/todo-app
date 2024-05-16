//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_v1/Service/Auth_Service.dart';
import 'package:todo_app_v1/pages/AddToDo.dart';
import 'package:todo_app_v1/pages/SignInPage.dart';
import 'package:todo_app_v1/pages/SignUpPage.dart';
import 'package:todo_app_v1/Custom/TodoCard.dart';
import 'package:todo_app_v1/pages/View_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences prefs;
  String userEmail = '';
  Stream<QuerySnapshot>? _stream;
  List<Select> selected = [];
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "Schedule",
            style: TextStyle(
                fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/DAB03919-10470989.webp"),
            ),
            SizedBox(width: 25),
          ],
          bottom: PreferredSize(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tasks",
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        var instance =
                            FirebaseFirestore.instance.collection("Todo");
                        for (int i = 0; i < selected.length; i++) {
                          selected[i].checkValue == true
                              ? instance.doc(selected[i].id).delete()
                              : null;
                        }
                        selected.clear();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            preferredSize: Size.fromHeight(35),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 32,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => AddToDoPage()));
                },
                child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.indigoAccent, Colors.purple],
                        )),
                    child: Icon(
                      Icons.add,
                      size: 32,
                      color: Colors.white,
                    )),
              ),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () async {
                  await authClass.logout(context: context);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => SignInPage()),
                      (route) => false);
                },
                child: Icon(
                  Icons.logout,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              label: 'Settings',
            ),
          ],
        ),
        body: FutureBuilder(
            future: initPrefs(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Show loading indicator while waiting
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Handle error
              } else {
                return StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            IconData iconData = Icons.run_circle_outlined;
                            Color iconColor = Colors.white;
                            Map<String, dynamic> document =
                                snapshot.data?.docs[index].data()
                                    as Map<String, dynamic>;
                            switch (document["category"]) {
                              case "Work":
                                iconData = Icons.run_circle_outlined;
                                iconColor = Colors.red;
                                break;
                              case "Workout":
                                iconData = Icons.alarm;
                                iconColor = Colors.teal;
                                break;
                              case "Food":
                                iconData = Icons.local_grocery_store;
                                iconColor = Colors.blue;
                                break;
                              case "Sport":
                                iconData = Icons.sports_football;
                                iconColor = Color.fromARGB(255, 3, 243, 163);
                                break;
                              case "Chopping":
                                iconData = Icons.kitchen;
                                iconColor = Colors.pink;
                                break;
                              default:
                                iconData = Icons.run_circle_outlined;
                                iconColor = Colors.red;
                            }
                            selected.add(Select(
                                id: snapshot.data!.docs[index].id,
                                checkValue: false));
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ViewData(
                                              document: document,
                                              id: snapshot.data!.docs[index].id,
                                            )));
                              },
                              child: TodaCard(
                                title: document["title"] == null
                                    ? "Hey There"
                                    : document["title"],
                                iconData: iconData,
                                iconColor: iconColor,
                                time: document["time"] == null
                                    ? "undefined"
                                    : document["time"],
                                date: document["date"] == null
                                    ? "undefined"
                                    : document["date"],
                                check: selected[index].checkValue,
                                iconBgColore: Colors.white,
                                index: index,
                                onChange: onChange,
                                task: document["task"] == null
                                    ? "undefined"
                                    : document["task"],
                                status: document["status"] == null
                                    ? "unfinished"
                                    : document["status"],
                              ),
                            );
                          });
                    });
              }
            }));
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    userEmail = await authClass
        .getUserEmailFromCredential(); // Ensure this method returns the user's email
    _stream = FirebaseFirestore.instance
        .collection("Todo")
        .where("userEmail",
            isEqualTo: userEmail) // Filter documents by userEmail
        .orderBy("date")
        .orderBy("time")
        .snapshots();
  }
}

class Select {
  String id;
  bool checkValue = false;
  Select({required this.id, required this.checkValue});
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