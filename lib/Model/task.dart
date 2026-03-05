import 'package:todolist/TableSchema/todoTable.dart';

class TaskModel {
  final int? id;
  final String detail;
  final String date; // store as "YYYY-MM-DD"
  final int status;  // 0=pending, 1=done

  TaskModel({
    this.id,
    required this.detail,
    required this.date,
    this.status = 0,
  });

  Map<String, dynamic> toMap() => {
        TodoTable.colID: id,
        TodoTable.colDetail: detail,
        TodoTable.colDate: date,
        TodoTable.colStatus: status,
      };

  factory TaskModel.fromMap(Map<String, dynamic> map) => TaskModel(
        id: map[TodoTable.colID] as int?,
        detail: map[TodoTable.colDetail] as String,
        date: map[TodoTable.colDate] as String,
        status: map[TodoTable.colStatus] as int,
      );
}