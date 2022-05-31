import 'package:flutter_note_app/base/base_bloc.dart';
import 'package:flutter_note_app/model/note_item.dart';
import 'package:get/get.dart';

import '../note_list_screen/note_list_repository.dart';

class EditNoteBloc extends BaseBloc {

  final _noteListRepository = Get.find<NoteListRepositoryImpl>();
  final isUpdatedSuccessfully = false.obs;

  void addNote(String userId, NoteItem noteItem) async {
    try {
      await _noteListRepository.addLocalNote(userId, noteItem, isAddToRemote: true);
      isUpdatedSuccessfully.value = true;
    } on Exception catch (e, st) {
      print(e.toString());
    }
  }

  void updateNote(String userId, NoteItem noteItem) async {
    // isLoading.value = true;
    try {
      await _noteListRepository.updateNote(userId, noteItem);
      isUpdatedSuccessfully.value = true;
    } on Exception catch (e, st) {
      // isLoading.value = false;
      alertMessage.trigger(e.toString());
    }
  }
}