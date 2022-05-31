import 'package:flutter_note_app/model/note_item.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper extends GetxService {
  late Database db;

  Future<DbHelper> init() async {
    db = await _getDatabase();
    return this;
  }

  Future<Database> _getDatabase() async {
    var databasePath = await getDatabasesPath();
    return db = await openDatabase(
      join(databasePath, "notes.db"),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE notes (id INTEGER PRIMARY KEY, title TEXT, description TEXT, timestamp INTEGER, isSynced INTEGER, firestoreId TEXT)');
      },
      version: 1,
    );
  }

  Future<List<NoteItem>> getAll() async {
    final result =
        await db.rawQuery('SELECT * FROM notes ORDER BY timestamp DESC');
    print(result);
    return result.map((json) => NoteItem.fromJson(json)).toList();
  }

  Future<NoteItem> getNoteItemById(int id) async {
    final result = await db.rawQuery('SELECT * FROM notes WHERE id = ?', [id]);
    print(result);
    return result.map((json) => NoteItem.fromJson(json)).toList().first;
  }

  Future<NoteItem> save(NoteItem note) async {
    final id = await db.rawInsert(
        'INSERT INTO notes (title, description, timestamp, isSynced, firestoreId) VALUES (?, ?, ?, ?, ?)',
        [
          note.title,
          note.description,
          note.timestamp,
          note.isSynced,
          note.firestoreId
        ]);
    note.id = id;
    return note;
  }

  Future<NoteItem> update(NoteItem note) async {
    final id = await db.rawUpdate(
        'UPDATE notes SET title = ?, description = ?, timestamp = ?, isSynced = ?, firestoreId = ? WHERE id = ?',
        [
          note.title,
          note.description,
          note.timestamp,
          note.isSynced,
          note.firestoreId,
          note.id
        ]);

    note.id = id;
    return note;
  }

  Future<int> delete(int noteId) async {
    final id = await db.rawDelete('DELETE FROM notes WHERE id = ?', [noteId]);
    print(id);
    return id;
  }
}
