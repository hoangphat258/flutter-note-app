import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_note_app/base/base_bloc.dart';
import 'package:get/get.dart';

import '../../model/note_item.dart';
import 'note_list_repository.dart';

class NoteListBloc extends BaseBloc {

  final _noteListRepository = Get.find<NoteListRepositoryImpl>();
  final noteItems = <NoteItem>[].obs;
  final _firebaseAuth = Get.find<FirebaseAuth>();
  final isSignInSuccessfully = false.obs;

  void fetchData(String userId, {bool isFirstSignIn = false}) {
    noteItems.clear();
    _noteListRepository.fetchLocalData().then((notes) {
      noteItems.addAll(notes);
    });
    if (userId.isNotEmpty) {
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
        Future.delayed(const Duration(milliseconds: 1000), () => syncDataToFirestore(userId));
      });
    }
  }

  Future<void> syncDataToFirestore(String userId) async {
    final latestNoteItems = await _noteListRepository.fetchLocalData();
    for (NoteItem note in latestNoteItems) {
      if (note.isSynced == 0) {
        _noteListRepository.addRemoteNote(userId, note);
      }
    }
  }

  void deleteNote(String userId, NoteItem noteItem) {
    noteItems.removeWhere((item) => item.id == noteItem.id);
    _noteListRepository.deleteNote(userId, noteItem);
  }

  Future<void> signInFirebase(String email, String password) async {
    try {
      isLoading.value = true;
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      isLoading.value = false;
      isSignInSuccessfully.trigger(true);
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'user-not-found') {
        alertMessage.trigger('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        alertMessage.trigger('Wrong password provided for that user.');
      }
    }
  }

}
