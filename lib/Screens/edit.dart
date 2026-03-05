import 'package:flutter/material.dart';
import 'package:todolist/DB/db.dart';
import 'package:todolist/Model/task.dart';


class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() =>
      _EditTaskScreenState();
}

class _EditTaskScreenState
    extends State<EditTaskScreen> {

  late TextEditingController detailController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();

    detailController =
        TextEditingController(text: widget.task.detail);

    dateController =
        TextEditingController(text: widget.task.date);
  }

  
  Future<void> updateTask() async {

    if (detailController.text.isEmpty) return;

    TaskModel updatedTask = TaskModel(
      id: widget.task.id,
      detail: detailController.text,
      date: dateController.text,
      status: widget.task.status,
    );

    await DBHelper.instance.updateTask(updatedTask);

    Navigator.pop(context, true);
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Task"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Icon(
              Icons.edit_note,
              size: 70,
              color: Color(0xFF3B82F6),
            ),

            const SizedBox(height: 20),

            /// Task Title
            TextField(
              controller: detailController,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.task),
                labelText: "Task Title",
                filled: true,
                fillColor:
                    const Color(0xFFF5F7FB),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// Date Picker
            TextField(
              controller: dateController,
              readOnly: true,
              onTap: () async {

                DateTime? picked =
                    await showDatePicker(
                  context: context,
                  initialDate:
                      DateTime.now(),
                  firstDate:
                      DateTime(2020),
                  lastDate:
                      DateTime(2100),
                );

                if (picked != null) {
                  dateController.text =
                      "${picked.year}-${picked.month}-${picked.day}";
                }
              },
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.calendar_today),
                labelText: "Task Date",
                filled: true,
                fillColor:
                    const Color(0xFFF5F7FB),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(
                          vertical: 14),
                  backgroundColor:
                      const Color(0xFF3B82F6),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),
                onPressed: updateTask,
                child: const Text(
                  "Update Task",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}