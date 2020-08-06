import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:text_recognition_ocr/model/card_structure.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;

  String cardTable = 'card_table';
  String colId = 'id';
  String colName = 'name';
  String colComapanyName = 'company_name';
  String colMobile = 'mobile';
  String colEmailId = 'emailid';
  String colWebsite = 'website';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
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
    String path = directory.path + 'cards.db';

    // Open/create the database at a given path
    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $cardTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
        '$colComapanyName TEXT, $colMobile TEXT, $colEmailId TEXT,$colWebsite TEXT)');
  }

  //CRUD OPERATIONS STARTING...:-

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getCardMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    //var result = await db.query(cardTable, orderBy: '$colId ASC');
    var result = await db.query(cardTable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertCard(Cardone card) async {
    Database db = await this.database;
    var result = await db.insert(cardTable, card.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateCard(Cardone card) async {
    var db = await this.database;
    var result = await db.update(cardTable, card.toMap(), where: '$colId = ?', whereArgs: [card.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteCard(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $cardTable WHERE $colId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $cardTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Cardone>> getCardList() async {

    var cardMapList = await getCardMapList(); // Get 'Map List' from database ie FETCH OPERATION
    int count = cardMapList.length;         // Count the number of map entries in db table

    List<Cardone> cardList = List<Cardone>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      cardList.add(Cardone.fromMapObject(cardMapList[i]));
    }
    return cardList;
  }
}