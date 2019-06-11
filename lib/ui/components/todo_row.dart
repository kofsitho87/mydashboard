import 'package:flutter/material.dart';

import '../colors.dart';
import '../../models/Todo.dart';

Widget TodoRowView(int index, Todo todo) {
  var icon;
  var color;
  var colorDepp;
  switch(todo.category){
    case "공부":
      color = Color1; 
      colorDepp = Color1Deep;
      icon = Icons.book;
      break;
    case "개인":
      color = Color2;
      colorDepp = Color2Deep;
      icon = Icons.local_play;
      break;
    case "여가":
      color = Color3;
      colorDepp = Color3Deep;
      icon = Icons.refresh;
      break;
    case "일":
      color = Color4; 
      colorDepp = Color4Deep;
      icon = Icons.work;
      break;
  }

  var remainingDays = '기한없음';
  var monthDateString = '';
  if( todo.completeDate != null ){
    final inDays = todo.completeDate.difference(DateTime.now()).inDays;
    remainingDays = inDays == 0 ? 'Today' : inDays.toString() + '일 남음';
    monthDateString = todo.completeDate.month.toString() + '월 ' + todo.completeDate.day.toString() + '일';
  }
  final leftSide = Container(
    height: 100,
    width: 80,
    //padding: EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        bottomLeft: Radius.circular(8.0),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          backgroundColor: colorDepp,
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          remainingDays,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          monthDateString,
          style: TextStyle(color: Colors.white, fontSize: 10.0),
        )
      ],
    ),
  );

  final centerSide = Expanded(
    flex: 1,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(todo.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              ),
              SizedBox(height: 5),
              Text(
                todo.note,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.local_offer, color: color, size: 16),
              SizedBox(width: 5,),
              Text(
                todo.category,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  //var checked = false;
  // final rightSide = Center(
  //   child: Checkbox(
  //     value: checked,
  //   ),
  // );

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Container(
      //transform: Matrix4.rotationZ(0.1),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        //verticalDirection: VerticalDirection.up,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          leftSide,
          centerSide,
          //rightSide
        ],
      ),
    ),
  );
}
