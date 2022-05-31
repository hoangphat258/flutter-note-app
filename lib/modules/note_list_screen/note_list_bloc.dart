import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_note_app/base/base_bloc.dart';
import 'package:get/get.dart';

import '../../model/note_item.dart';
import 'note_list_repository.dart';

class NoteListBloc extends BaseBloc {

  final _noteListRepository = Get.find<NoteListRepositoryImpl>();
  final noteItems = <NoteItem>[].obs;

  void fetchData(String userId) {
    noteItems.clear();
    _noteListRepository.fetchLocalData().then((notes) {
      noteItems.addAll(notes);
    });
    _noteListRepository.fetchData(userId).then((query) {
      for (var element in query.docs) {
        final note = NoteItem.fromJson(element.data());
        final exists = noteItems.where((item) => note.timestamp == item.timestamp);
        if (exists.isEmpty) {
          noteItems.add(note);
          _noteListRepository.addLocalNote(userId, note);
        }
      }
      noteItems.sort((b, a) => a.timestamp.compareTo(b.timestamp));
    });
  }

  void deleteNote(String userId, NoteItem noteItem) {
    noteItems.removeWhere((item) => item.id == noteItem.id);
    _noteListRepository.deleteNote(userId, noteItem);
  }

}
