import 'dart:io';

import 'package:aida/features/chat/data/model/Conversation.dart';
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
          'CREATE TABLE messages(id TEXT PRIMARY KEY, isUser BOOLEAN, time TEXT, message TEXT)');
      // 'CREATE TABLE messages(id TEXT PRIMARY KEY, authorId TEXT, createdAt INTEGER, text TEXT)');
    });
  }

  Future<void> saveMessage(Conversation message) async {
    Database db = await database;

    try {
      await db.insert('messages', message.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('sendMessage - saveMessage, ERROR: $e');
    }
  }

  Future<List<Conversation>> loadMessages() async {
    Database db = await database;

    List<Map<String, dynamic>> maps = await db.query('messages');
    // List<Conversation> messages = maps.isNotEmpty
    // ? maps.map((e) => Conversation.fromJson(e)).toList()
    // : [];
    List<Conversation> messages = [];
    if (maps.isNotEmpty) {
      try {
        messages = maps.map((e) => Conversation.fromJson(e)).toList();
      } catch (e) {
        print('sendMessage - loadMessages, ERROR parsing messages from DB: $e');
        messages = [];
      }
    } else {
      messages = [];
    }

    print('sendMessage - loadMessages - messages loaded from DB: ${messages}');

    return messages;
  }

  Future<void> deleteMessage(String messageId) async {
    Database db = await database;
    await db.delete('messages', where: 'id = ?', whereArgs: [messageId]);
  }

  Future<void> clearChat() async {
    Database db = await database;
    await db.delete('messages');
  }
}
