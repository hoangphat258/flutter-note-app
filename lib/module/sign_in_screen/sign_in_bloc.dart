import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_note_app/base/base_bloc.dart';
import 'package:get/get.dart';

class SignInBloc extends BaseBloc {

  final _firebaseAuth = Get.find<FirebaseAuth>();
  final isSignInSuccessfully = false.obs;

  signInFirebase(String email, String password) async {
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