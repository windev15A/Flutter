import 'package:flutter/material.dart';
import 'package:language/api/myDataBase.dart';
import 'package:language/components/taskwidget.dart';
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
    print("Debut ${tasks.length}");
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
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      decoration: InputDecoration(
                        icon: Icon(Icons.task),
                        hintText: "New task",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        taskModel = TaskModel(name: _controller.text);
                        db.insert(taskModel);
                        getAllData();
                        print(tasks.length);
                        _controller.text = "";
                      },
                      child: Icon(
                        Icons.add,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "List tasks",
                style: TextStyle(fontSize: 34, color: Colors.grey),
              ),
              Expanded(
                  child: ListView.builder(
                itemBuilder: (BuildContext context, index) {
                  return TaskWidget(
                    id: tasks[index].id.toString(),
                    name: tasks[index].name,
                    deleteTask: ()=> print("Delete"),
                    displayTask: (){
                      _controller.text = tasks[index].name;
                    },
                  );
                },
                itemCount: tasks.length,
              ))
            ],
          )),
    );
  }
}
