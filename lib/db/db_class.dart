import 'dart:developer';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

import 'package:lab_5/db/db_model.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = '${dir.path}/mybase.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      await db.execute("""CREATE TABLE Results(
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        weight DOUBLE,
                        height DOUBLE,
                        result DOUBLE,
                      );""");
    } catch (e) {
      log(e.toString());
    }
  }

/*
  Future<List<Map<String, dynamic>>> getPerson(int id) async {
    Database db = await this.database;
    final List<Map<String, dynamic>> data;
    data = await db.query("Person", where: "id = ?", whereArgs: [id]);
    return data;
  }

  Future<int> updatePerson(
      int id, double weight, double value2, double result) async {
    Database db = await this.database;
    return await db.update("Person", where: "id = ?", whereArgs: [id]);
  }

  Future<void> saveCalculationResult(
      double value1, double value2, double result) async {
    Database db = await this.database;
    final id = await db.insert(
      'RESULTS',
      {'value1': value1, 'value2': value2, 'result': result},
    );
    setState(() {
      _calculationResults.add(
          {'id': id, 'value1': value1, 'value2': value2, 'result': result});
    });
  }*/
  Future<int> insertResult(Result result) async {
    Database db = await this.database;
    return await db.insert('Results', result.toMap());
  }

  // Read all items (journals)
  Future<List<Map<String, dynamic>>> getItems() async {
    Database db = await database;
    final List<Map<String, dynamic>> data =
        await db.query('Results', orderBy: "id");
    return data;
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  Future<List<Map<String, dynamic>>> getItem(int id) async {
    Database db = await database;
    return db.query('Results', where: "id = ?", whereArgs: [id], limit: 1);
  }

/*
  Future<int> updateResult(Result result) async {
    Database db = await this.database;
    int res = await db.update(
      'Results',
      result.toMap(),
      where: "id = ?",
      whereArgs: [result.id],
    );
    return res;
  }

  Future<List<Result>> retrieveResults() async {
    Database db = await this.database;
    final List<Map<String, Object?>> queryResult = await db.query('RESULTS');
    return queryResult.map((e) => Result.fromMap(e)).toList();
  }

  Future<void> deleteResult(int id) async {
    Database db = await this.database;
    await db.delete(
      'RESULTS',
      where: "id = ?",
      whereArgs: [id],
    );
  }*/
}
/*
class BmiDataCubit extends Cubit<List<Map<String, dynamic>>> {
  BmiDataCubit() : super([]);

  void loadData() async {
    final database = await this.database;
    final data = await database.query('RESULTS');
    emit(data);
  }
}
*/
