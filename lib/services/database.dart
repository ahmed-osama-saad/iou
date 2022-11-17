import 'package:iou/models/receipt.dart';
import 'package:iou/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'iou.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Run the CREATE {users} TABLE statement on the database.
    await db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT)',
    );
    // Run the CREATE {receipts} TABLE statement on the database.
    await db.execute(
        'CREATE TABLE receipts(id INTEGER PRIMARY KEY, description TEXT, currency TEXT, amount REAL, image BLOB,senderId INTEGER, receiverId INTEGER, FOREIGN KEY (senderId) REFERENCES users(id) ON DELETE SET NULL, FOREIGN KEY (receiverId) REFERENCES users(id) ON DELETE SET NULL)');
  }

  // Users functions

  // create user
  Future<void> insertUser(User user) async {
    final db = await _databaseService.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read
  Future<User> user(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return User.fromMap(maps[0]);
  }

  // List
  Future<List<User>> users() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (index) => User.fromMap(maps[index]));
  }

  // update
  Future<void> updateUser(User user) async {
    final db = await _databaseService.database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Delete
  Future<void> deleteUser(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Receipt fnctions
  // create
  Future<void> insertReceipt(Receipt receipt) async {
    final db = await _databaseService.database;
    await db.insert(
      'receipts',
      receipt.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read
  Future<Receipt> receipt(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> map = await db.query(
      'receipts',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Receipt.fromMap(map[0]);
  }

  // List
  Future<List<Receipt>> receipts() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('receipts');
    return List.generate(maps.length, (index) => Receipt.fromMap(maps[index]));
  }

  // Update
  Future<void> updateReceipt(Receipt receipt) async {
    final db = await _databaseService.database;
    await db.update('receipts', receipt.toMap(),
        where: 'id = ?', whereArgs: [receipt.id]);
  }

  // Delete
  Future<void> deleteReceipt(int id) async {
    final db = await _databaseService.database;
    await db.delete('receipts', where: 'id = ?', whereArgs: [id]);
  }
}
