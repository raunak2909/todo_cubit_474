import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_cubit_474/cubit/todo_cubit.dart';
import 'package:todo_cubit_474/todo_model.dart';

class AddTodoPage extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  String title, remark;
  bool isUpdated;
  int id;

  AddTodoPage({
    this.title = "",
    this.remark = "",
    this.isUpdated = false,
    this.id = 0,
  });

  @override
  Widget build(BuildContext context) {
    if (isUpdated) {
      titleController.text = title;
      remarkController.text = remark;
    }

    return Scaffold(
      appBar: AppBar(title: Text('${isUpdated ? 'Update' : 'Add'} Todo')),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Enter your title here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            SizedBox(height: 11),
            TextField(
              controller: remarkController,
              maxLines: 4,
              minLines: 4,
              decoration: InputDecoration(
                labelText: "Remark",
                hintText: "Enter your remarks here..",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    if (isUpdated) {
                    } else {
                      context.read<TodoCubit>().addTodo(
                        newTodo: TodoModel(
                          title: titleController.text,
                          remark: remarkController.text,
                          isCompleted: false,
                          createdAt: DateTime.now().millisecondsSinceEpoch,
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
                SizedBox(width: 11),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
