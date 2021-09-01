import 'package:flutter/material.dart';
import 'package:language/api/myDataBase.dart';
import 'package:language/models/taskModel.dart';

class SqlLiteScreen extends StatefulWidget {
  @override
  _SqlLiteScreenState createState() => _SqlLiteScreenState();
}

class _SqlLiteScreenState extends State<SqlLiteScreen> {
  final _controller = TextEditingController();
  List<TaskModel> tasks = [];
  TaskModel taskModel;
  DB db;

  @override
  void initState() {
    super.initState();
    db = DB();
    getAllData();
  }

  Future<void> getAllData() async {
    List<TaskModel> list = await db.getAllTask();
    setState(() {
      tasks = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SqlLite + flutter"),
      ),
      body: Container(
          child: Column(
        children: [
          TextField(
            controller: _controller,
          ),
          ElevatedButton(
            onPressed: () {
              taskModel = TaskModel(name: _controller.text);
              db.insert(taskModel);
              _controller.text = "";
            },
            child: Text("Insert"),
          ),
          ElevatedButton(
            onPressed: getAllData,
            child: Text("Show all tasks"),
          ),
          Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text("${tasks[index].id}"),
                      subtitle: Text("${tasks[index].name}"),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: tasks.length))
        ],
      )),
    );
  }
}
