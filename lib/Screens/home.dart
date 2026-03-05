import 'package:flutter/material.dart';
import 'package:todolist/DB/db.dart';
import 'package:todolist/Model/task.dart';
import 'package:todolist/Screens/edit.dart';

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() =>
      _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {

  int selectedTab = 0;
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await DBHelper.instance
        .getTasksByStatus(selectedTab);
    setState(() {});
  }

  Future<void> toggleStatus(TaskModel task) async {
    await DBHelper.instance.updateTaskStatus(
        id: task.id!,
        status: task.status == 0 ? 1 : 0);

    loadTasks();
  }

  
  void showAddDialog() {

    TextEditingController detailController =
        TextEditingController();

    TextEditingController dateController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(25)),
        child: Container(
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(25),
            color: Colors.white,
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Icon(
                Icons.add_task,
                size: 60,
                color: Color(0xFF3B82F6),
              ),

              const SizedBox(height: 15),

              const Text(
                "Create New Task",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// Task Title
              TextField(
                controller: detailController,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.edit),
                  hintText: "Task Title",
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
                  hintText: "Select Date",
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

              const SizedBox(height: 25),

              /// Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 90, 140, 221),
                    padding:
                        const EdgeInsets.symmetric(
                            vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15)),
                  ),
                  onPressed: () async {

                    if (detailController.text.isEmpty) return;

                    await DBHelper.instance.insertTask(
                        TaskModel(
                            detail:
                                detailController.text,
                            date:
                                dateController.text));

                    Navigator.pop(context);
                    loadTasks();
                  },
                  child: const Text(
                    "Save Task",
                    style: TextStyle(
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget buildTab(String text, int index) {

    bool isSelected = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
          loadTasks();
        },
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1F2A44)
                : Colors.grey.shade300,
            borderRadius:
                BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }


  // Widget buildTaskCard(TaskModel task) {

  //   bool isDone = task.status == 1;

  //   return GestureDetector(
  //     onTap: () => toggleStatus(task),

  //     onLongPress: () async {
  //       final result = await Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (_) =>
  //                 EditTaskScreen(task: task)),
  //       );

  //       if (result == true) loadTasks();
  //     },

  //     child: Container(
  //       margin:
  //           const EdgeInsets.symmetric(
  //               horizontal: 16, vertical: 8),
  //       padding: const EdgeInsets.all(16),

  //       decoration: BoxDecoration(
  //         color: isDone
  //             ? const Color(0xFFE8F5E9)
  //             : Colors.white,
  //         borderRadius:
  //             BorderRadius.circular(18),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.shade300,
  //             blurRadius: 6,
  //             offset: const Offset(0, 3),
  //           )
  //         ],
  //       ),

  //       child: Row(
  //         children: [

  //           Icon(
  //             isDone
  //                 ? Icons.check_circle
  //                 : Icons.radio_button_unchecked,
  //             color: isDone
  //                 ? Colors.green
  //                 : const Color(0xFF3B82F6),
  //           ),

  //           const SizedBox(width: 15),

  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment:
  //                   CrossAxisAlignment.start,
  //               children: [

  //                 Text(
  //                   task.detail,
  //                   style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w600,
  //                       decoration: isDone
  //                           ? TextDecoration.lineThrough
  //                           : TextDecoration.none),
  //                 ),

  //                 Text(task.date,
  //                     style: const TextStyle(
  //                         color: Colors.grey)),
  //               ],
  //             ),
  //           ),

  //           /// EDIT BUTTON
  //           IconButton(
  //             icon: const Icon(Icons.edit,
  //                 color: Color(0xFF3B82F6)),
  //             onPressed: () async {
  //               final result = await Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (_) =>
  //                           EditTaskScreen(task: task)));

  //               if (result == true) loadTasks();
  //             },
  //           ),

  //           /// DELETE BUTTON
  //           IconButton(
  //             icon: const Icon(Icons.delete,
  //                 color: Colors.red),
  //             onPressed: () async {
  //               await DBHelper.instance
  //                   .deleteTask(task.id!);
  //               loadTasks();
  //             },
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
Widget buildTaskCard(TaskModel task) {

  bool isDone = task.status == 1;

  return Container(
    margin: const EdgeInsets.symmetric(
        horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          blurRadius: 6,
          offset: const Offset(0, 3),
        )
      ],
    ),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// TITLE + STATUS ICON ROW
        Row(
          children: [

            Icon(
              isDone
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: isDone
                  ? Colors.green
                  : const Color(0xFF3B82F6),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                task.detail,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  decoration: isDone
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        /// DATE
        Text(
          task.date,
          style: const TextStyle(
              color: Colors.grey),
        ),

        const SizedBox(height: 15),

        /// BUTTON ROW
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [

            /// MARK AS DONE BUTTON
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDone
                    ? Colors.orange
                    : const Color(0xFF22C55E),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await toggleStatus(task);
              },
              icon: Icon(
                isDone
                    ? Icons.undo
                    : Icons.check,
                color: Colors.white,
                size: 18,
              ),
              label: Text(
                isDone
                    ? "Mark Pending"
                    : "Mark Done",
                style: const TextStyle(
                    color: Colors.white),
              ),
            ),

            Row(
              children: [

                /// EDIT BUTTON
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color(0xFF3B82F6)),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {

                    final result =
                        await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              EditTaskScreen(
                                  task: task)),
                    );

                    if (result == true)
                      loadTasks();
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Color(0xFF3B82F6),
                    size: 18,
                  ),
                  label: const Text(
                    "Edit",
                    style: TextStyle(
                        color: Color(0xFF3B82F6)),
                  ),
                ),

                const SizedBox(width: 8),

                /// DELETE BUTTON
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () async {
                    await DBHelper.instance
                        .deleteTask(task.id!);
                    loadTasks();
                  },
                ),
              ],
            )
          ],
        )
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
      ),

      floatingActionButton:
          FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [

          /// Tabs
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                buildTab("Pending", 0),
                const SizedBox(width: 10),
                buildTab("Done", 1),
              ],
            ),
          ),

          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text("No Tasks Found"))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (_, i) =>
                        buildTaskCard(tasks[i]),
                  ),
          )
        ],
      ),
    );
  }
}