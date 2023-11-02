import 'package:memory_project/models/teacher_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/scores_model.dart';
import '../models/student_model.dart';

class DatabaseHelper {
  final _databaseName = 'bbbb.db';
  final _databaseVersion = 1;
  final table = 'users';
  final columnId = 'id';
  static const columnEmail = 'email';
  static const columnPassword = 'password';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnEmail TEXT NOT NULL,
            $columnPassword TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE students (
              id INTEGER PRIMARY KEY,
              codigo TEXT NOT NULL,
              name TEXT NOT NULL,
              lastname TEXT NOT NULL,
              dateOfBirth DATE NOT NULL,
              status BOOLEAN DEFAULT 1,
              bestEasyLevel INTEGER DEFAULT 0,
              bestMediumLevel INTEGER DEFAULT 0,
              bestHardLevel INTEGER DEFAULT 0,
              teacher_id INTEGER, 
              FOREIGN KEY (teacher_id) REFERENCES teachers (id)
          )
          ''');

    await db.execute('''
              CREATE TABLE teachers (
                  id INTEGER PRIMARY KEY,
                  email TEXT NOT NULL,
                  password TEXT NOT NULL,
                  name TEXT NOT NULL,
                  lastname TEXT NOT NULL,
                  dateOfBirth DATE NOT NULL,
                  status BOOLEAN DEFAULT 1
              )
          ''');

    await db.execute('''
              CREATE TABLE scores (
                  id INTEGER PRIMARY KEY,
                  time INTEGER DEFAULT 0,
                  level TEXT NOT NULL,
                  currentDate DATE NOT NULL,
                  currentTime TEXT NOT NULL,
                  student_id INTEGER,
                  status BOOLEAN DEFAULT 1
              )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row, String tableName) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row, String tableName) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(tableName, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Add this method to the DatabaseHelper class
  Future<Teacher?> getTeacher(String email, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> teachers = await db.query(
      'teachers',
      where: '$columnEmail = ? AND $columnPassword = ?',
      whereArgs: [email, password],
    );
    if (teachers.isNotEmpty) {
      return Teacher.fromMap(teachers.first);
    } else {
      return null;
    }
  }

  Future<int?> getAllStudentsByTseacher(int id) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT(*) FROM students WHERE teacher_id = $id'));
  }

  Future<List<Map<String, dynamic>>> getRowById(
      String tableName, int id) async {
    Database db = await instance.database;
    // return await db.rawQuery(
    //     'SELECT * FROM $tableName WHERE teacher_id = $id AND status = 1');
    return await db.rawQuery('''
        SELECT
          s.id AS id,
          s.codigo AS codigo,
          s.name AS name,
          s.lastname AS lastname,
          s.dateOfBirth AS dateOfBirth,
          s.bestEasyLevel AS bestEasyLevel,
          s.bestMediumLevel AS bestMediumLevel,
          s.bestHardLevel AS bestHardLevel,
          s.teacher_id AS teacher_id,
          t.name AS teacher_name,
          t.lastname AS teacher_lastname
        FROM $tableName AS s
        JOIN teachers AS t ON s.teacher_id = t.id
        WHERE s.teacher_id = $id AND s.status = 1;
  ''');
  }

  Future<List<Map<String, dynamic>>> getAllStudentsByTeacher(
      String tableName, int id) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT * FROM $tableName WHERE teacher_id = $id AND status = 1');
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    Database db = await instance.database;
    return await db.rawQuery('''
        SELECT
          s.id AS id,
          s.codigo AS codigo,
          s.name AS name,
          s.lastname AS lastname,
          s.dateOfBirth AS dateOfBirth,
          s.bestEasyLevel AS bestEasyLevel,
          s.bestMediumLevel AS bestMediumLevel,
          s.bestHardLevel AS bestHardLevel,
          s.teacher_id AS teacher_id,
          t.name AS teacher_name,
          t.lastname AS teacher_lastname
        FROM students AS s
        JOIN teachers AS t ON s.teacher_id = t.id
        WHERE s.status = 1;
  ''');
  }

  Future<List<Map<String, dynamic>>> getAllTeachers(String tableName) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tableName WHERE status = 1');
  }

  Future<List<Map<String, dynamic>>> getAllActiveTeachers(
      String tableName) async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tableName WHERE status = 1');
  }

  Future<List<Student>> search(String query, String tableName) async {
    Database db = await instance.database;
    var result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE name LIKE ? AND status = 1',
        ['%$query%']);
    List<Student> studentsList = result.isNotEmpty
        ? result.map((item) => Student.fromMap(item)).toList()
        : [];
    return studentsList;
  }

  Future<Teacher?> existsTeacher(Map<String, dynamic> data) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> teachers = await db.query(
      'teachers',
      where: 'email = ? AND dateOfBirth = ? AND status = 1',
      whereArgs: [data['email'], data['dateOfBirth']],
    );
    if (teachers.isNotEmpty) {
      return Teacher.fromMap(teachers.first);
    } else {
      return null;
    }
  }

  Future<List<Score>> getScoreByStudent(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> scores = await db
        .rawQuery('SELECT * FROM scores WHERE student_id = $id AND status = 1');
    List<Score> scoresList = scores.isNotEmpty
        ? scores.map((item) => Score.fromMap(item)).toList()
        : [];
    return scoresList;
  }
}
