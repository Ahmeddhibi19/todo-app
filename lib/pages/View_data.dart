import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ViewData extends StatefulWidget {
  ViewData({Key? key, required this.document, required this.id})
      : super(key: key);
  final Map<String, dynamic> document;
  final String id;
  @override
  _ViewDataState createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String type;
  late String category;
  bool edit = false;
  DateTime selectedDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();
String time="";
String date="";
String status="unfinished";

  @override
  void initState() {
    super.initState();
    String title = widget.document["title"] == null
        ? "hey there"
        : widget.document["title"];
    titleController = TextEditingController(text: title);
    descriptionController =
        TextEditingController(text: widget.document["description"]);
    type = widget.document["task"];
    category = widget.document["category"];
    time=widget.document["time"];
    date=widget.document["date"];
    status=widget.document["status"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff1d1e26), Color(0xff252041)]),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Todo")
                              .doc(widget.id)
                              .delete().then((value) => Navigator.pop(context));
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: edit ? Colors.green : Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? "Editing" : "View",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Your Todo",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                     SizedBox(height: 25,),
                     label("Date && Time"),
                      SizedBox(height: 12,),
                      dateTime(),
                      SizedBox(height: 25,),
                       label("Status"),
                      SizedBox(height: 12,),
                      Status(),
                      SizedBox(height: 25,),
                    label("Task Title"),
                    SizedBox(
                      height: 12,
                    ),
                    title(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Task Type"),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        taskSelect("Important", 0xff2664fa),
                        SizedBox(
                          width: 20,
                        ),
                        taskSelect("Planned", 0xff2bc8d9),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Description"),
                    SizedBox(
                      height: 12,
                    ),
                    description(),
                    SizedBox(
                      height: 25,
                    ),
                    label("Category"),
                    SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categorySelect("Food", 0xffff6d6e),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Workout", 0xfff29732),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Work", 0xff6557ff),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Sport", 0xff234ebd),
                        SizedBox(
                          width: 20,
                        ),
                        categorySelect("Chopping", 0xff2bc8d9),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    edit ? button() : Container(),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection("Todo").doc(widget.id).update({
          "title": titleController.text,
          "task": type,
          "category": category,
          "description": descriptionController.text,
            "date":date,
            "time":time,
            "status":status,
        });
        Navigator.pop(context);
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient:
                LinearGradient(colors: [Color(0xff8a32f1), Color(0xffad32f9)])),
        child: Center(
          child: Text(
            "Update Todo",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color(0xff2a2e3d), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: descriptionController,
        enabled: edit,
        style: TextStyle(color: Colors.grey, fontSize: 17),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "task title",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
            contentPadding: EdgeInsets.only(left: 20, right: 20)),
      ),
    );
  }

  Widget chipData(String label, int color) {
    return Chip(
      backgroundColor: Color(color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      labelPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color(0xff2a2e3d), borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: titleController,
        enabled: edit,
        style: TextStyle(color: Colors.grey, fontSize: 17),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "task title",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
            contentPadding: EdgeInsets.only(left: 20, right: 20)),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          letterSpacing: 0.2),
    );
  }

  Widget taskSelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                type = label;
              });
            }
          : null,
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: type == label ? Colors.white : Color(color),
        label: Text(label),
        labelStyle: TextStyle(
          color: type == label ? Color(color) : Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                category = label;
              });
            }
          : null,
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: category == label ? Colors.white : Color(color),
        label: Text(label),
        labelStyle: TextStyle(
          color: category == label ? Color(color) : Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }
  Widget dateTime(){
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Selection
        InkWell(
          onTap:edit ? () {
            _selectDate(context);
          }:null,
          child: Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 10),
              Text(
                'Date: ${date}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        // Time Selection
        InkWell(
          onTap:edit? () {
            _selectTime(context);
          }: null,
          child: Row(
            children: [
              Icon(Icons.access_time),
              SizedBox(width: 10),
              Text(
                'Time: ${time}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );

  }

   Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
              date = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

      });
  }

   Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        time='${selectedTime.hour}:${selectedTime.minute}';
      });
  }
 Widget Status() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status:',
          style: TextStyle(color: Colors.white),
        ),
        Row(
          children: [
            Radio(
              value: "finished",
              groupValue: status,
              onChanged: edit
                  ? (value) {
                      setState(() {
                        status = value.toString();
                      });
                    }
                  : null,
            ),
            Text(
              'Finished',
              style: TextStyle(color: Colors.white),
            ),
            Radio(
              value: "unfinished",
              groupValue: status,
              onChanged: edit
                  ? (value) {
                      setState(() {
                        status = value.toString();
                      });
                    }
                  : null,
            ),
            Text(
              'Unfinished',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
