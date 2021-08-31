import 'package:flutter/material.dart';
import 'package:language/models/taskModel.dart';

class SqlLiteScreen extends StatefulWidget {
  @override
  _SqlLiteScreenState createState() => _SqlLiteScreenState();
}

class _SqlLiteScreenState extends State<SqlLiteScreen> {
  final _controller = TextEditingController();
  List<TaskModel> tasks = [];
  TaskModel taskModel;
  final HelperDb helperDb = HelperDb();

  Future getAllData() async {
    this.tasks = await helperDb.getAllTask();
  }

  @override
  void initState() {
    super.initState();
    helperDb.initDatabase();
    getAllData();
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
              _controller.text = "";
              helperDb.insert(taskModel);
            },
            child: Text("Insert"),
          ),
          ElevatedButton(
            onPressed: () async {
              List<TaskModel> list = await helperDb.getAllTask();
              setState(() {
                tasks = list;
              });
            },
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
