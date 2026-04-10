import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit_474/cubit/todo_state.dart';
import 'package:todo_cubit_474/db_helper.dart';
import 'package:todo_cubit_474/todo_model.dart';

class TodoCubit extends Cubit<TodoState>{
  DBHelper dbHelper;
  TodoCubit({required this.dbHelper}) : super(TodoState(allTodo: []));

  ///events
  addTodo({required TodoModel newTodo}) async {
    bool isAdded = await dbHelper.addTodo(newTodo: newTodo);
    if(isAdded){
      fetchAllTodo();
    }
  }

  fetchAllTodo() async {
    List<TodoModel> mTodo = await dbHelper.fetchAllTodo();
    emit(TodoState(allTodo: mTodo));
  }

  toggleTodo({required int id, required bool isCompleted}) async{
    bool isChanged = await dbHelper.toggleTodo(id: id, isCompleted: isCompleted);
    if(isChanged){
      fetchAllTodo();
    }
  }

}