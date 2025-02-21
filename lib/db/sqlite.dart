import 'package:auscurator/model/notification_model.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqlite {
  final String databaseName = "notification.db";

  Future<Database> initDatabase() async {
    final dbBath = await getDatabasesPath();
    final db = join(dbBath, databaseName);
    return await openDatabase(db, onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE Notification(id INTEGER PRIMARY KEY AUTOINCREMENT,unique_id TEXT NOT NULL,title TEXT NOT NULL,description TEXT NOT NULL,datetime TEXT NOT NULL)",
      );
    }, version: 1);
  }

  Future<void> createItem(NotificationModel notification) async {
    final db = await initDatabase();
    print("sqlite unique id ${notification.id}");
    db.insert('Notification', notification.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<NotificationModel>> getNotificationList() async {
    final db = await initDatabase();
    final List<Map<String, dynamic>> quryResult =
        await db.query('Notification');
    return quryResult.map((e) => NotificationModel.fromMap(e)).toList();
  }

  Future<void> deleteItem(String id) async {
    final db = await Sqlite().initDatabase();
    try {
      await db.delete("Notification", where: "unique_id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Unable to delete the record. $e");
    }
  }

  Future<void> deleteAll() async {
    final db = await Sqlite().initDatabase();
    db.delete("Notification");
  }
}
