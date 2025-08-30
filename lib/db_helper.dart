import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'student_model.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal(); //singleton Pattern
  factory DbHelper() => _instance; //
  DbHelper._internal(); //privat Constructor

  //Database Variable

  static Database? _db; // database is will be null first

  //Database Getter Method
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB(); //Create database using initDB
    return _db!;
  }

  //Initialize Database

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath(); // Systum folder, to save database
    final path = join(dbPath, 'student.db');

    var openDatabase2 = openDatabase(
      //open database
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(
          //run sql command
          '''CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT,
  firstName TEXT,secondName TEXT,course TEXT,age TEXT,phone TEXT,
  imagePath TEXT)''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE students ADD COLUMN firstName TEXT');
          await db.execute('ALTER TABLE students ADD COLUMN secondName TEXT');
        }
      },
    );
    return await openDatabase2;
  }

  Future<int> insertStudent(Student student) async {
    //insert student object to database
    final db = await database;
    return await db.insert(
      'students',
      student.toMap(),
    ); //added data to student table
  }

  //Get All Student
  //fetching all student records from table
  Future<List<Student>> getAllStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
    ); //Getting data as a list
    return List.generate(maps.length, (i) {
      //converting maps into studens object
      return Student.fromMap(maps[i]);
    });
  }

  //Delet Student

  Future<void> deleteStudent(int id) async {
    //delete student using id
    final db = await database;
    await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateStudent(Student student) async {
    //recieve student object method of,to be updated student data
    final db = await database;
    return await db.update(
      'students',
      student.toMap(), //Student object data, convert map
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }
}
