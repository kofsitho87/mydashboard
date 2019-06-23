import 'package:flutter/material.dart';

import '../colors.dart';
import '../../models/Todo.dart';

class TodoRowView extends StatelessWidget {
  final Todo todo;
  final Function onToggleComplteTodoAction;
  final Function onChangeTodoAction;
  TodoRowView(this.todo, {@required this.onToggleComplteTodoAction, @required this.onChangeTodoAction});

  @override
  Widget build(BuildContext context) {
    var remainingDays = '기한없음';
    if (todo.completeDate != null) {
      final inDays = todo.completeDate.difference(DateTime.now()).inDays;
      remainingDays = inDays == 0 ? '오늘' : (inDays < 0 ? '기한지남' : inDays.toString() + '일 남음');
    }

    return ListTile(
      //leading: Icon(Icons.list, color: Colors.white),
      title: Text(todo.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      subtitle: todo.completeDate == null ? null : Column(
        children: <Widget>[
          SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(Icons.access_time, color: Colors.white, size: 16),
              SizedBox(width: 5),
              Text(remainingDays,
                  style: TextStyle(color: Colors.white, fontSize: 16))
            ],
          )
        ],
      ),
      leading: IconButton(
        icon: Icon(
            todo.completed ? Icons.check_box : Icons.check_box_outline_blank,
            color: Colors.white,
            size: 26),
        onPressed: () => onToggleComplteTodoAction(todo),
      ),
      trailing: IconButton(
        icon: Icon(
            todo.important ? Icons.star : Icons.star_border,
            color: Colors.white,
            size: 26),
        onPressed: () {
          if(todo.completed) return;
          todo.important = !todo.important; 
          onChangeTodoAction(todo);
        },
      ),
    );
  }
}
