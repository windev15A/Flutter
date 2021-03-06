import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  String id;
  String name;
  Function deleteTask;
  Function displayTask;

  TaskCard({this.id, this.name, this.deleteTask, this.displayTask});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.displayTask,
      child: Container(
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.lime,
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.id,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
                onPressed: widget.deleteTask,
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                  size: 35,
                ))
          ],
        ),
      ),
    );
  }
}
