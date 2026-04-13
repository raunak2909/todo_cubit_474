import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_cubit_474/cubit/todo_cubit.dart';
import 'package:todo_cubit_474/todo_model.dart';

class AddTodoPage extends StatefulWidget {
  String title, remark;
  int createdAt;
  bool isCompleted;
  bool isUpdated;
  int id;

  AddTodoPage({
    this.title = "",
    this.remark = "",
    this.isUpdated = false,
    this.id = 0,
    this.createdAt = 0,
    this.isCompleted = false,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();

  TextEditingController remarkController = TextEditingController();

  int selectedPriority = 2;

  List<String> mPriority = ["Low", "Medium", "High"];

  @override
  Widget build(BuildContext context) {
    if (widget.isUpdated) {
      titleController.text = widget.title;
      remarkController.text = widget.remark;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.isUpdated ? 'Update' : 'Add'} Todo'),
      ),
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

            StatefulBuilder(
              builder: (context, ss) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(mPriority.length, (index) {
                    return RadioMenuButton(
                      value: index,
                      groupValue: selectedPriority,
                      onChanged: (value) {
                        selectedPriority = value!;
                        ss(() {});
                      },
                      child: Text(mPriority[index]),
                    );
                  }),
                );
              }
            ),

            SizedBox(height: 11),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    if (widget.isUpdated) {
                      context.read<TodoCubit>().updateTodo(
                        updatedTodo: TodoModel(
                          title: titleController.text,
                          remark: remarkController.text,
                          isCompleted: widget.isCompleted,
                          createdAt: widget.createdAt,
                          id: widget.id,
                          priority: selectedPriority,
                        ),
                      );
                    } else {
                      context.read<TodoCubit>().addTodo(
                        newTodo: TodoModel(
                          title: titleController.text,
                          remark: remarkController.text,
                          isCompleted: false,
                          createdAt: DateTime.now().millisecondsSinceEpoch,
                          priority: selectedPriority,
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
