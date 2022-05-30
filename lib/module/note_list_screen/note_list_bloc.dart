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
    // final noteStream = _noteListRepository.fetchData(userId).map((query) {
    //   List<NoteItem> retList = [];
    //   retList.addAll(noteItems);
    //   for (var element in query.docs) {
    //     final note = NoteItem.fromJson(element.data());
    //     note.firestoreId = element.id;
    //     retList.add(note);
    //   }
    //   retList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    //   return retList;
    // });
    // noteItems.bindStream(noteStream);
  }


}
