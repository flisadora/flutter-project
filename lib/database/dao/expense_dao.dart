import 'package:bytebank_persistence/database/app_database.dart';
import 'package:bytebank_persistence/models/expense.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_type TEXT, '
      '$_value DOUBLE, '
      '$_label TEXT, '
      '$_date TEXT)';

  static const String _tableName = 'expenses';
  static const String _id = 'id';
  static const String _type = 'type';
  static const String _value = 'value';
  static const String _label = 'label';
  static const String _date = 'date';

  Future<int> save(Expense expense) async{
    final Database db = await getDatabase();
    Map<String, dynamic> expenseMap = _toMap(expense);
    print(expenseMap.toString());
    return db.insert(_tableName, expenseMap);
  }

  Map<String, dynamic> _toMap(Expense? expense) {
    final Map<String, dynamic> expenseMap = Map();
    expenseMap[_type] = expense?.type;
    expenseMap[_value] = expense?.value;
    expenseMap[_label] = expense?.label;
    expenseMap[_date] = expense?.date;
    return expenseMap;
  }

  Future<List<Expense>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Expense> expenses = _toList(result);
    return expenses;
  }

  List<Expense> _toList(List<Map<String, dynamic>> result) {
    final List<Expense> expenses = [];
    for (Map<String, dynamic> row in result) {
      final Expense expense = Expense(
        row[_id],
        row[_type],
        row[_value],
        row[_label],
        row[_date],
      );
      expenses.add(expense);
    }
    return expenses;
  }

  Future<int> update(Expense expense) async {
    final Database db = await getDatabase();
    final Map<String, dynamic> expenseMap = _toMap(expense);
    return await db.update(
      _tableName,
      expenseMap,
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> delete(Expense expense) async {
    final Database db = await getDatabase();
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }
}