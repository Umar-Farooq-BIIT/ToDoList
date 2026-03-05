import 'package:sqflite/sqflite.dart';
import 'package:todolist/Model/task.dart';
import 'package:todolist/TableSchema/todoTable.dart';


class DBHelper
{
  Database? _database;
  static DBHelper instance=DBHelper._init();
  DBHelper._init();
  Future<Database> get databse async{
    // if(_database!=null) return _database!;
    // _database=await _initializeDB();
    _database??=await _initializeDB();
    return _database!;
  }
  Future<Database> _initializeDB()async{
    String path=await getDatabasesPath();
    String dbPath=path+"/"+"todo.db";
    return await openDatabase(dbPath,version:1,
    onCreate: _createDB
    
    );

  }
  _createDB(Database db, int version)async
  {
//        String query='''
//   create table ${Todotable.tableName}
//   (${Todotable.colID} INTEGER PRIMARY KEY AUTOINCREMENT,
//   ${Todotable.colDetail} TEXT,
//   ${Todotable.colDate} TEXT
//   )
// ''';
//    await db.execute(query);
await db.execute(TodoTable.creteTable());
  }
  
  Future<int> insertTask(TaskModel task) async {
    // using Raw query
//     String query='''
//    insert into ${TodoTable.tableName} 
//    (${TodoTable.colDetail},${TodoTable.colDate},${TodoTable.colStatus})
//    values ('${task.detail}','${task.date}','${task.status}')
// ''';
// var db=await databse;
// return await db.rawInsert(query);

var db=await databse;
return await db.insert(TodoTable.tableName, task.toMap());

     
  }

  Future<List<TaskModel>> getAllTasks() async {
 var db =await databse;
  //   List<TaskModel> rows=[];
  //   String query='Select * from ${TodoTable.tableName} order by ${TodoTable.colID} DESC';
   
  //  var rowsMap=await db.rawQuery(query);
 var rowsMap= await db.query(TodoTable.tableName,orderBy: '${TodoTable.colID} DESC');
  //  for(int i=0;i<rowsMap.length;i++)
  //  {
  //         var rowMap=rowsMap[i];
  //        rows.add(TaskModel.fromMap(rowMap));
  //  }
  // return rows;
  return rowsMap.map((row)=>TaskModel.fromMap(row)).toList();

   
  
 
  }


  Future<int> updateTask(TaskModel task) async {

    var db=await databse;
    return await db.update(TodoTable.tableName,task.toMap(),
    where: '${TodoTable.colID}=?',whereArgs: [task.id]);

    
  }
    Future<int> deleteTask(int id) async {
       var db =await databse;
      //  String query='Delete from ${TodoTable.tableName} where ${TodoTable.colID}=${id}';
      // return await db.rawDelete(query);
    return await db.delete(TodoTable.tableName,
      where: '${TodoTable.colID}=?',whereArgs: [id]);
    
  }

  Future<int> updateTaskStatus({required int id, required int status}) async {
    var db=await databse;
//     String query='''
// Update ${TodoTable.tableName} set ${TodoTable.colStatus}=${status}
// where ${TodoTable.colID}=${id}
//     ''';
//  return  await db.rawUpdate(query);
return await db.update(TodoTable.tableName, {
  TodoTable.colStatus:status
},where: '${TodoTable.colID}=?',whereArgs: [id]);

   
  }

  Future<List<TaskModel>> getTasksByStatus(int status) async {
    var db =await databse;
  //   List<TaskModel> rows=[];
   //  String query='Select * from ${TodoTable.tableName} where ${TodoTable.colStatus}=${status} order by ${TodoTable.colID} DESC';
   
  //  var rowsMap=await db.rawQuery(query);
 var rowsMap= await db.query(
  TodoTable.tableName,
   where: '${TodoTable.colStatus}=? ',
   whereArgs: [status],
 
 orderBy: '${TodoTable.colID} DESC');
  //  for(int i=0;i<rowsMap.length;i++)
  //  {
  //         var rowMap=rowsMap[i];
  //        rows.add(TaskModel.fromMap(rowMap));
  //  }
  // return rows;
  return rowsMap.map((row)=>TaskModel.fromMap(row)).toList();

   
    
   
  }
}