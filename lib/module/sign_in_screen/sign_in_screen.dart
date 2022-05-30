import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/module/sign_in_screen/sign_in_bloc.dart';
import 'package:get/get.dart';

import '../note_list_screen/note_list_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _signInViewModel = Get.put(SignInBloc());

  @override
  void initState() {
    super.initState();

    _signInViewModel.isSignInSuccessfully.listen((isSignInSuccessfully) {
      if (isSignInSuccessfully) {
        Get.offAll(const NoteListScreen());
      }
    });

    _signInViewModel.alertMessage.listen((message) {
      if (message.isNotEmpty) Get.defaultDialog(title: message);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailTextController,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: _passwordTextController,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  _signInViewModel.signInFirebase(_emailTextController.text, _passwordTextController.text);
                },
                child: const Text("Sign In"),
              ),
            ],
          ),
          Obx(() => _signInViewModel.isLoading.isTrue ? const CircularProgressIndicator() : Container()),
        ],
      ),
    );
  }
}
