import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_cubit_474/todo_model.dart';

class DBHelper {
  DBHelper._();

  static DBHelper getInstance() => DBHelper._();

  Database? mDB;
  static const String DB_NAME = "todoDB.db";
  static const String TABLE_TODO = "todos";
  static const String COLUMN_TODO_ID = "t_id";
  static const String COLUMN_TODO_TITLE = "t_title";
  static const String COLUMN_TODO_REMARK = "t_remark";
  static const String COLUMN_TODO_CREATED_AT = "t_created_at";
  static const String COLUMN_TODO_IS_COMPLETED = "t_is_completed";
  static const String COLUMN_TODO_PRIORITY = "t_priority";

  Future<Database> initDB() async {
    mDB ??= await openDB();
    return mDB!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, DB_NAME);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "create table $TABLE_TODO ( $COLUMN_TODO_ID integer primary key autoincrement, $COLUMN_TODO_TITLE text, $COLUMN_TODO_REMARK text, $COLUMN_TODO_IS_COMPLETED integer, $COLUMN_TODO_CREATED_AT text, $COLUMN_TODO_PRIORITY integer)",
        );
      },
    );
  }

  ///addTodo
  Future<bool> addTodo({required TodoModel newTodo}) async {
    Database db = await initDB();
    int rowsEffected = await db.insert(TABLE_TODO, newTodo.toMap());
    return rowsEffected > 0;
  }

  ///fetchAll todo
  Future<List<TodoModel>> fetchAllTodo({int filterType = 2}) async {
    Database db = await initDB();
    List<Map<String, dynamic>> mData = [];

    if (filterType > 1) {
      /// all todos
      mData = await db.query(TABLE_TODO);
    } else {
      ///filtered (0/1)
      mData = await db.query(
        TABLE_TODO,
        where: "$COLUMN_TODO_IS_COMPLETED = ?",
        whereArgs: ["$filterType"],
      );
    }

    List<TodoModel> mTodo = [];

    for (Map<String, dynamic> eachMap in mData) {
      mTodo.add(TodoModel.fromMap(eachMap));
    }

    return mTodo;
  }

  ///toggle todo
  Future<bool> toggleTodo({required int id, required bool isCompleted}) async {
    Database db = await initDB();
    int rowsEffected = await db.update(
      TABLE_TODO,
      {COLUMN_TODO_IS_COMPLETED: isCompleted ? 1 : 0},
      where: "$COLUMN_TODO_ID = ?",
      whereArgs: ["$id"],
    );
    return rowsEffected > 0;
  }

  /// update
  Future<bool> updateTodo({required TodoModel updatedTodo}) async {
    Database db = await initDB();

    int rowsEffected = await db.update(
      TABLE_TODO,
      updatedTodo.toMap(),
      where: "$COLUMN_TODO_ID = ?",
      whereArgs: ["${updatedTodo.id}"],
    );

    return rowsEffected > 0;
  }

  /// delete
  Future<bool> deleteTodo({required int id}) async {
    Database db = await initDB();
    int rowsEffected = await db.delete(
      TABLE_TODO,
      where: "$COLUMN_TODO_ID = ?",
      whereArgs: ["$id"],
    );
    return rowsEffected > 0;
  }
}
