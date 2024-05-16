import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TodaCard extends StatelessWidget {
  const TodaCard({super.key , required this.title, required this.iconData , required this.iconColor, required this.time , required this.check,required this.iconBgColore,required this.onChange , required this.index , required this.date, required this.task, required this.status});

  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final String date;
  final bool check;
  final Color iconBgColore;
  final Function onChange;
  final int index;
  final String task;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                activeColor: Color(0xff6cf8a9) ,
                checkColor:Color(0xff0e3e26) ,
                value: check,
                 onChanged: (bool? value){
                  onChange(index);
                 },
                ),
            ),
              data: ThemeData(
                primarySwatch: Colors.blue,
                unselectedWidgetColor: Color(0xff5e616a)
              ),
          ),
          Expanded(
            child: Container(
              height: 75,
              child: Card(
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: status=="unfinished"? BorderSide(color: const Color.fromARGB(255, 247, 1, 1)): BorderSide(color: Color.fromARGB(255, 3, 202, 53))),
                color: task=="Important" ?Colors.indigoAccent:Color(0xff2a2e3d) ,
                child: Row(
                  children: [
                    SizedBox(width:15 ,),
                    Container(
                      height: 33,
                      width:36 ,
                      decoration: BoxDecoration(
                        color:iconBgColore,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child:Icon(iconData , color: iconColor,) ,
                    ),
                    SizedBox(width:20 ,),
                    Expanded(
                      child: Text(
                       title,
                         style: TextStyle(
                          fontSize: task=="Important" ? 22 : 18,
                          letterSpacing: 1,
                          fontWeight:  task=="Important" ? FontWeight.w700 :FontWeight.w500,
                          color: Colors.white
                        ),
                        ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         SizedBox(height:10 ,),
                        Text(
                          'Time: ${time}',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          'Date: ${date}',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ],
                    ),
                     
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

   String _formatTime(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}