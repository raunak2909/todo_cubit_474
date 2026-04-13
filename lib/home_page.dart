import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_cubit_474/cubit/todo_cubit.dart';
import 'package:todo_cubit_474/cubit/todo_state.dart';
import 'package:todo_cubit_474/todo_model.dart';

import 'add_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Quiz App (Cubit)
/// Add filters
/// on the basis of priority
/// on the basis complete/pending

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().fetchAllTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (_, state) {
          List<TodoModel> allTodo = state.allTodo;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: (){
                    context.read<TodoCubit>().fetchAllTodo(
                      filterType: 0
                    );
                  }, child: Text("Pending")),
                  OutlinedButton(onPressed: (){
                    context.read<TodoCubit>().fetchAllTodo(filterType: 1);
                  }, child: Text("Completed")),
                  OutlinedButton(onPressed: (){
                    context.read<TodoCubit>().fetchAllTodo();
                  }, child: Text("All")),
                ],
              ),
              Expanded(
                child: allTodo.isNotEmpty
                    ? ListView.builder(
                        itemCount: allTodo.length,
                        itemBuilder: (_, index) {

                          int priority = allTodo[index].priority;
                          Color bgColor = Colors.white;

                          if(allTodo[index].isCompleted){
                            bgColor = Colors.green.shade200;
                          } else {
                            if (priority == 2) {
                              bgColor = Colors.red.shade200;
                            } else if (priority == 1) {
                              bgColor = Colors.yellow.shade200;
                            } else {
                              bgColor = Colors.blue.shade200;
                            }
                          }
                          return Card(
                            color: bgColor,
                            child: ListTile(
                              /*controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (value){
                                context.read<DBProvider>().toggleTodo(
                                  id: allTodo[index][DBHelper.COLUMN_TODO_ID],
                                  isChecked: value ?? false,
                                );
                              },
                              value:
                              allTodo[index][DBHelper.COLUMN_TODO_IS_COMPLETED] ==
                                  1,*/
                              leading: Checkbox(
                                value: allTodo[index].isCompleted,
                                onChanged: (value) {
                                  context.read<TodoCubit>().toggleTodo(
                                    id: allTodo[index].id!,
                                    isCompleted: value ?? false,
                                  );
                                },
                              ),
                              title: Text(
                                allTodo[index].title,
                                style: TextStyle(
                                  decoration: allTodo[index].isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: Text(
                                allTodo[index].remark,
                                style: TextStyle(
                                  decoration: allTodo[index].isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddTodoPage(
                                            isUpdated: true,
                                            title: allTodo[index].title,
                                            remark: allTodo[index].remark,
                                            id: allTodo[index].id!,
                                            createdAt: allTodo[index].createdAt,
                                            isCompleted: allTodo[index].isCompleted,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<TodoCubit>().deleteTodo(id: allTodo[index].id!);
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(child: Text("No Todos yet!!")),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
