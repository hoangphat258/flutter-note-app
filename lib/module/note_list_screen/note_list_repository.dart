import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_note_app/db/db_helper.dart';
import 'package:flutter_note_app/model/note_item.dart';
import 'package:get/get.dart';

abstract class NoteListRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchData(String userId);
  Future<List<NoteItem>> fetchLocalData();
  Future<void> addLocalNote(String userId, NoteItem noteItem);
  Future<void> addRemoteNote(String userId, NoteItem noteItem);
  Future<void> updateNote(String userId, NoteItem noteItem);
}

class NoteListRepositoryImpl implements NoteListRepository {

  final _notesRef = Get.find<CollectionReference<Map<String, dynamic>>>();
  final _dbHelper = Get.find<DbHelper>();

  @override
  Future<void> addLocalNote(String userId, NoteItem noteItem) async {
    noteItem.timestamp = DateTime.now().millisecondsSinceEpoch;
    await _dbHelper.save(noteItem);
    addRemoteNote(userId, noteItem);
  }

  @override
  Future<void> addRemoteNote(String userId, NoteItem noteItem) async {
    final docRef = _notesRef.doc(userId).collection("items");
    try {
      final retDocRef = await docRef.add(noteItem.toJson());
      noteItem.isSynced = 1;
      noteItem.firestoreId = retDocRef.id;
      await retDocRef.update(noteItem.toJson());
      await _dbHelper.update(noteItem);
    } on Exception catch (e, st) {
      return Future.error(e);
    }
  }

  @override
  Future<List<NoteItem>> fetchLocalData() async {
    return await _dbHelper.getAll();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchData(String userId) {
    return _notesRef
        .doc(userId)
        .collection("items")
        .orderBy("title")
        .snapshots();
  }

  @override
  Future<void> updateNote(String userId, NoteItem noteItem) async {
    noteItem.timestamp = DateTime.now().millisecondsSinceEpoch;
    await _dbHelper.update(noteItem);
    // final docRef = _notesRef.doc(userId).collection("items").doc("abv");
    // try {
    //   await docRef.update(noteItem.toJson());
    // } on Exception catch (e, st) {
    //   return Future.error(e);
    // }
  }
}