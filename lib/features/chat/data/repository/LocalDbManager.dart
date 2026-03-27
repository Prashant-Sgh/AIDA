import 'dart:io';

import 'package:aida/features/chat/data/model/message.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'conversation.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) {
      return db.execute(
          'CREATE TABLE messages(id INTEGER PRIMARY KEY, content TEXT, timestamp TEXT, sender TEXT)');
    });
  }

  Future<void> saveMessage(Message message) async {
    Database db = await database;

    await db.insert('messages', message.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Message>> loadMessages() async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query('messages');
    List<Message> messages = maps.isNotEmpty
        ? maps.map((e) => Message.fromJson(e)).toList()
        : [];

    return messages;
  }

  Future<void> deleteMessage() async {
    Database db = await database;
    await db.delete('messages');
  }
}