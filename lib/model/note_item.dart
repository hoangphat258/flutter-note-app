import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

NoteItem noteItemFromJson(String str) => NoteItem.fromJson(json.decode(str));
String noteItemToJson(NoteItem data) => json.encode(data.toJson());

class NoteItem {
  NoteItem({this.id, this.firestoreId, this.title, this.description, this.timestamp = 0, this.isSynced = 0});

  int? id;
  String? firestoreId;
  String? title;
  String? description;
  int timestamp;
  int isSynced;

  static NoteItem fromJson(Map<String, dynamic> json) => NoteItem(
      id: json["id"],
      firestoreId: json["firestoreId"],
      title: json["title"],
      description: json["description"],
      timestamp: json["timestamp"],
      isSynced: json["isSynced"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firestoreId": firestoreId,
    "title": title,
    "description": description,
    "timestamp": timestamp,
    "isSynced": isSynced,
  };

  NoteItem copyWith({int? id, String? firestoreId, String? title, String? description, int timestamp = 0, int isSynced = 0}) {
    this.id = id;
    this.firestoreId = firestoreId;
    this.title = title;
    this.description = description;
    this.timestamp = timestamp;
    this.isSynced = isSynced;
    return this;
  }
}