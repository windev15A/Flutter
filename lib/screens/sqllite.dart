import 'package:flutter/material.dart';
import 'package:language/api/myDataBase.dart';
import 'package:language/components/taskCard.dart';
import 'package:language/models/taskModel.dart';

class SqlLiteScreen extends StatefulWidget {
  @override
  _SqlLiteScreenState createState() => _SqlLiteScreenState();
}

class _SqlLiteScreenState extends State<SqlLiteScreen> {
  final _controller = TextEditingController();
  List<TaskModel> tasks = [];
  TaskModel taskModel;
  bool edit = false;
  String errorText;
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

  void addTask() {
    if(_controller.text == ""){
      setState(() {
        errorText = "Task is empty !!!!";
      });
    }else{
    taskModel = TaskModel(name: _controller.text);
    db.insert(taskModel);
    taskModel.id = tasks.length == 0 ? 1 : tasks[tasks.length - 1].id + 1;
    setState(() {
      tasks.add(taskModel);
    });
    _controller.clear();
    }
  }

  void editTask(int id) {
    taskModel.name = _controller.text;
    db.update(taskModel, id);
    int index = tasks.indexWhere((task) => task.id == id);
    setState(() {
      tasks[index].name = _controller.text;
    });
    _controller.clear();
  }

  void deleteTask(int id) {
    db.delete(id);
    setState(() {
      tasks.removeWhere((task) => task.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        title: Text("SqlLite + flutter"),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        if (value == "") {
                          setState(() {
                            edit = false;
                          });
                        }else{
                          setState(() {
                            errorText = "";
                          });
                        }
                      },
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      decoration: InputDecoration(
                        errorText: errorText,
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
                    ),
                    child: InkWell(

                      onTap: () =>
                            edit ? editTask(taskModel.id) : addTask(),
                        child: Icon(
                          edit ? Icons.edit : Icons.add,
                          size: 35,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                "List tasks",
                style: TextStyle(fontSize: 34, color: Colors.grey),
              ),
              tasks.length > 0
                  ? Expanded(
                      child: ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        return TaskCard(
                          id: tasks[index].id.toString(),
                          name: tasks[index].name,
                          deleteTask: () => deleteTask(tasks[index].id),
                          displayTask: () {
                            _controller.text = tasks[index].name;
                            setState(() {
                              taskModel = TaskModel(
                                  id: tasks[index].id, name: tasks[index].name);
                              edit = true;
                            });
                          },
                        );
                      },
                      itemCount: tasks.length,
                    ))
                  : Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          Icon(
                            Icons.format_align_justify_outlined,
                            color: Colors.red,
                            size: 120,
                          ),
                          Text("No data"),
                        ],
                      ),
                    ),
            ],
          )),
    );
  }
}
