import 'package:todo_cubit_474/db_helper.dart';

class TodoModel{
  int? id;
  String title, remark;
  bool isCompleted;
  int createdAt;

  TodoModel({
    this.id,
    required this.title,
    required this.remark,
    required this.isCompleted,
    required this.createdAt
  });

  ///fromMap
  factory TodoModel.fromMap(Map<String, dynamic> map){
    return TodoModel(
        id: map[DBHelper.COLUMN_TODO_ID],
        title: map[DBHelper.COLUMN_TODO_TITLE],
        remark: map[DBHelper.COLUMN_TODO_REMARK],
        isCompleted: map[DBHelper.COLUMN_TODO_IS_COMPLETED] == 1 ? true : false,
        createdAt: int.parse(map[DBHelper.COLUMN_TODO_CREATED_AT]));
  }

  ///ToMap
  Map<String, dynamic> toMap(){
    return {
      DBHelper.COLUMN_TODO_TITLE : title,
      DBHelper.COLUMN_TODO_REMARK : remark,
      DBHelper.COLUMN_TODO_IS_COMPLETED : isCompleted ? 1 : 0,
      DBHelper.COLUMN_TODO_CREATED_AT : createdAt.toString(),
    };
  }
}