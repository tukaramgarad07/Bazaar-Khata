import 'package:new_bazaar_khata/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databasename = 'BazaarKhata.db';
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._createInstance();
  static Database? _database;

  String noteTable = 'note1_table';
  String itemTable = 'items_table';
  String activityTable = 'activity_table';

  String colId = 'id';
  String colDescription = 'description';
  String colDate = 'date';
  String colShopName = 'shopName';
  String colShopId = 'shopId';
  String colCustomerName = 'customerName';
  String colCustomerId = 'customerId';
  String colBill = 'bill';
  String colAmount = 'amount';
  String colMethod = 'method';
  String colDateTime = 'dateTime';

  String itemId = 'itemId';
  String shopId = 'shopId';
  String itemName = 'itemName';
  String itemQuantity = 'itemQuantity';
  String itemStep = 'itemStep';
  String itemPrice = 'itemPrice';

  String activityId = 'activityId';
  String shopName = 'shopName';
  String activityContent = 'activityContent';
  String activityMethod = 'activityMethod';
  String activityDate = 'activityDate';

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    String path = join(dbPath, _databasename);

    var notesDatabase =
        await openDatabase(path, version: 3, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''CREATE TABLE $noteTable(
          $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
          $colShopName TEXT, 
          $colShopId TEXT, 
          $colCustomerName TEXT,
          $colCustomerId TEXT,
          $colBill TEXT, 
          $colDescription TEXT, 
          $colAmount TEXT, 
          $colMethod TEXT, 
          $colDate TEXT, 
          $colDateTime TEXT)''');

    await db.execute('''
    CREATE TABLE $itemTable(
      $itemId INTEGER PRIMARY KEY AUTOINCREMENT,
      $shopId TEXT, 
      $itemName TEXT,
      $itemQuantity INT,
      $itemStep INT,
      $itemPrice INT)''');

    await db.execute('''
    CREATE TABLE $activityTable(
      $activityId INTEGER PRIMARY KEY AUTOINCREMENT,
      $shopId TEXT, 
      $activityContent TEXT,
      $activityMethod TEXT,
      $activityDate TEXT)''');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colId DESC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getNoteMapListNew(owner, customer) async {
    Database db = await database;

    var result = await db.rawQuery(
        'SELECT * FROM $noteTable where $colCustomerId = "$customer" order by $colId DESC');
    // 'SELECT * FROM $noteTable order by $colId DESC');
    // 'SELECT * FROM $noteTable where $colShopId == "$owner" AND $colCustomerId == "$customer" order by $colId DESC');
    // var result = await db.query(noteTable,
    //     orderBy: '$colId DESC',
    //     where: '$colShopId == "$owner" AND $colCustomerId == "$customer"');
    return result;
  }

  Future<List<Map<String, dynamic>>> getPaymentMapList(String userId) async {
    Database db = await database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable,
        where: '$colMethod = "cash" AND $colShopId = "$userId"',
        orderBy: '$colId DESC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getItemMapList(String userId) async {
    Database db = await database;
    var result = await db.rawQuery(
        'SELECT * FROM $itemTable WHERE shopId = "$userId" order by $itemId ASC');

    // var result = await db.query(itemTable,
    //     orderBy: '$itemId ASC', where: "shopId = $userId");
    return result;
  }

  Future<List<Map<String, dynamic>>> getActivityMapList(String userId) async {
    Database db = await database;
    // var result = await db.rawQuery(
    //     'SELECT * FROM $activityTable WHERE shopId = "$userId" order by $activityId DESC');
    // Database db = await database;
    var result = await db.query(activityTable,
        where: 'shopId = "$userId"', orderBy: '$activityId DESC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> insertItems(Items note) async {
    Database db = await database;
    var result = await db.insert(itemTable, note.toMap());
    return result;
  }

  Future<int> insertActivity(Activity note) async {
    Database db = await database;
    var result = await db.insert(activityTable, note.toMap());

    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(bill, desc, amount, method, date, datetime, id) async {
    var db = await database;
    var result = await db.rawUpdate(
        'UPDATE $noteTable SET bill = "$bill", description = "$desc", amount = "$amount", method = "$method", date= "$date", dateTime = "$datetime" WHERE id = "$id"');
    return result;
  }

  Future<int> updateItems(
      itemName, itemQuantity, itemStep, itemPrice, id) async {
    var db = await database;
    // var result = await db
    //     .update(itemTable, note.toMap(), where: '$itemId = ?', whereArgs: [id]);
    var result = await db.rawUpdate(
        'UPDATE items_table SET itemName = "$itemName", itemQuantity = $itemQuantity, itemStep = $itemStep, itemPrice = $itemPrice WHERE itemId = $id');
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await database;
    int result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int> deleteItems(int id) async {
    var db = await database;

    int result =
        await db.rawDelete('DELETE FROM $itemTable WHERE $itemId = $id');
    return result;
  }

  Future<int> deleteActivity(int id) async {
    var db = await database;

    int result = await db
        .rawDelete('DELETE FROM $activityTable WHERE $activityId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int?> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int?> paymentCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x = await db.rawQuery(
        'SELECT COUNT (*) from $noteTable WHERE $colMethod = "payment"');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int?> getItemCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $itemTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int?> getActivityCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $activityTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Note> noteList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  Future<List<Note>> getNoteListNew(String owner, String customer) async {
    var noteMapList = await getNoteMapListNew(
        owner, customer); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Note> noteList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  Future<List<Note>> getPaymentList(String userID) async {
    var noteMapList =
        await getPaymentMapList(userID); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Note> noteList = [];
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  Future<List<Items>> getItemsList(String userId) async {
    var noteMapList = await getItemMapList(userId);
    int count = noteMapList.length;
    List<Items> noteList = [];
    for (int i = 0; i < count; i++) {
      noteList.add(Items.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }

  Future<List<Activity>> getActivityList(String userId) async {
    var noteMapList = await getActivityMapList(userId);
    int count = noteMapList.length;

    List<Activity> noteList = [];
    for (int i = 0; i < count; i++) {
      noteList.add(Activity.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
