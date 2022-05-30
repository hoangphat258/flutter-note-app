import 'dart:convert';
import 'note_item.dart';


User noteItemFromJson(String str) => User.fromJson(json.decode(str));
// String noteItemToJson(User data) => json.encode(data.toJson());

class User {
  User({this.noteItems});

  List<NoteItem>? noteItems;

  factory User.fromJson(Map<String, dynamic> json) => User(
    noteItems: List<NoteItem>.from(json["items"]),
  );

  // Map<String, dynamic> toJson() => {
  //   "title": title,
  //   "description": description,
  // };
}