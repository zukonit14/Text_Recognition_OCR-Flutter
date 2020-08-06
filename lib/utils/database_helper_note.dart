import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:text_recognition_ocr/model/note_structure.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelperNote {

  static DatabaseHelperNote _databaseHelperNote;
  static Database _database;

  String noteTable="note_table";
  String colId = 'id';
  String colTitle = 'title';
  String colDescription ="description";

  DatabaseHelperNote._createInstance();

  factory DatabaseHelperNote() {

    if (_databaseHelperNote == null) {
      _databaseHelperNote = DatabaseHelperNote._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelperNote;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes1.db';

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT)');
  }

  //CRUD ON:

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getCardMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    //var result = await db.query(cardTable, orderBy: '$colId ASC');
    var result = await db.query(noteTable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertCard(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateCard(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteCard(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getCardList() async {

    var noteMapList = await getCardMapList(); // Get 'Map List' from database ie FETCH OPERATION
    int count = noteMapList.length;         // Count the number of map entries in db table

    List<Note> noteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}