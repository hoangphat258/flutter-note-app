import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../modules/note_list_screen/note_list_repository.dart';

class AppBinding implements Bindings {

  @override
  void dependencies() {
    Get.put<FirebaseAuth>(FirebaseAuth.instance);
    Get.put<FirebaseFirestore>(FirebaseFirestore.instance);
    Get.put<CollectionReference<Map<String, dynamic>>>(Get.find<FirebaseFirestore>().collection("notes"));
    Get.put<NoteListRepositoryImpl>(NoteListRepositoryImpl());
  }

}