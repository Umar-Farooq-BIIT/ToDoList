class TodoTable 
{
  static String tableName="Tasks";
  static String colID="ID";
  static String colDetail="Detail";
  static String colDate="Date";
  static String colStatus="Status";
  static String creteTable()
  {
    String query='''
   create table ${tableName}
  (
   ${colID} INTEGER PRIMARY KEY AUTOINCREMENT,
   ${colDetail} TEXT,
   ${colDate} TEXT, ${colStatus} INTEGER 
  ) 
''';
    return query;
  }
}