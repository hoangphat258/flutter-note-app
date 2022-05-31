import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_note_app/extensions/num_extension.dart';
import 'package:flutter_note_app/modules/note_list_screen/note_list_bloc.dart';
import 'package:get/get.dart';

import '../../model/note_item.dart';
import '../edit_note_screen/edit_note_page.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final _bloc = Get.put<NoteListBloc>(NoteListBloc());
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final firebaseAuth = Get.find<FirebaseAuth>();
  bool isHiddenSignIn = false;

  @override
  void initState() {
    super.initState();
    isHiddenSignIn = firebaseAuth.currentUser != null;
    _bloc.fetchData("");
    _bloc.isSignInSuccessfully.listen((isSignInSuccessfully) {
      if (isSignInSuccessfully) {
        Navigator.pop(context);
        setState(() {
          isHiddenSignIn = true;
        });
        _bloc.fetchData(firebaseAuth.currentUser?.uid ?? "", isFirstSignIn: true);
      }
    });

    _bloc.alertMessage.listen((message) {
      if (message.isNotEmpty) Get.defaultDialog(title: message);
    });
  }

  signInDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                TextField(
                  controller: _emailTextController,
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                ),
                TextField(
                  controller: _passwordTextController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Obx(
                  () => _bloc.isLoading.isTrue
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () => _bloc.signInFirebase(
                              _emailTextController.text,
                              _passwordTextController.text),
                          child: const Text("Sign In"),
                        ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note List"),
        actions: [
          !isHiddenSignIn
              ? GestureDetector(
                  onTap: () => signInDialog(),
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Center(
                      child: Text(
                        "Sign In",
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(
          () => EditNotePage(
            isCreateNew: true,
            onUpdateSuccessfully: (isUpdateSuccessfully) {
              if (isUpdateSuccessfully) {
                _bloc.fetchData(firebaseAuth.currentUser?.uid ?? "");
              }
            },
          ),
        ),
        child: const Icon(Icons.add_circle),
      ),
      body: GetX<NoteListBloc>(
        init: Get.put<NoteListBloc>(NoteListBloc()),
        builder: (controller) => RefreshIndicator(
          onRefresh: () async {
            _bloc.fetchData(firebaseAuth.currentUser?.uid ?? "");
          },
          child: Stack(
            children: [
              controller.noteItems.isNotEmpty
                  ? _buildNoteList(controller.noteItems)
                  : const Center(
                      child: Text("There is no note"),
                    ),
              controller.isLoading.isTrue
                  ? const Center(child: CircularProgressIndicator())
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteList(List<NoteItem> noteList) {
    return ListView.builder(
      itemCount: noteList.length,
      padding: const EdgeInsets.only(
        top: 8,
        right: 8,
        left: 8,
      ),
      itemBuilder: (context, index) => _buildNoteTile(noteList[index]),
    );
  }

  Widget _buildNoteTile(NoteItem noteItem) {
    return InkWell(
      onLongPress: () => _bloc.deleteNote(firebaseAuth.currentUser?.uid ?? "", noteItem),
      onTap: () => Get.to(() => EditNotePage(
            noteItem: noteItem,
            onUpdateSuccessfully: (isUpdateSuccessfully) {
              if (isUpdateSuccessfully) {
                _bloc.fetchData(firebaseAuth.currentUser?.uid ?? "");
              }
            },
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            noteItem.title ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(noteItem.timestamp.convertTimestampToString()),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  noteItem.description ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
