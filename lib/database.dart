import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'book.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('my_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_database.db');

    // DBが存在しない場合のみassetsからコピー
    final exists = await databaseExists(path);
    if (!exists) {
      print('Copying prepopulated database from assets to: $path');
      try {
        await Directory(dirname(path)).create(recursive: true);
        ByteData data = await rootBundle.load('assets/my_database.db');
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        print('Error copying database: $e');
      }
    }

    return await openDatabase(path);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR NOT NULL,
        subtitle VARCHAR,
        authors VARCHAR,
        description VARCHAR,
        isOwen BOOL NOT NULL,
        isRead BOOL NOT NULL,
        memo VARCHAR,
        publishedDate TIMESTAMP,
        thumbnailUrl VARCHAR
      );
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> insertItem(
      String title,
      String subtitle,
      String authors,
      String description,
      int isOwen,
      int isRead,
      String memo,
      String publishedDate,
      String thumbnailUrl,
      ) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('books',
        {
          'title': title,
          'subtitle': subtitle,
          'authors': authors,
          'description': description,
          'isOwen': isOwen,
          'isRead': isRead,
          'memo': memo,
          'publishedDate': publishedDate,
          'thumbnailUrl': thumbnailUrl
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await DatabaseHelper.instance.database;
    return await db.query('books');
  }

  Future<void> updateItem(
      int id,
      int isOwen,
      int isRead,
      String memo) async {

    final db = await DatabaseHelper.instance.database;
    await db.update(
      'book',
      {
        'isOwen': isOwen,
        'isRead': isRead,
        'memo': memo,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  //全レコードの取得
  Future<List<Book>> getAllBooks() async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query('books');

    return maps.map((map) => Book.fromMap(map)).toList();
  }
}