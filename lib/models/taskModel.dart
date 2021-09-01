
class TaskModel {
  final int id;
  final String name;

  TaskModel({
    this.id,
    this.name,
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
  };
}

