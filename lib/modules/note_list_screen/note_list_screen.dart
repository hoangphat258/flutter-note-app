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
        _bloc.fetchData(firebaseAuth.currentUser?.uid ?? "",
            isFirstSignIn: true);
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
      backgroundColor: const Color(0xfff2f1f7),
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Note List",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: const Color(0xfff2f1f7),
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
      body: GetX<NoteListBloc>(
        init: Get.put<NoteListBloc>(NoteListBloc()),
        builder: (controller) => RefreshIndicator(
          onRefresh: () async {
            _bloc.fetchData(firebaseAuth.currentUser?.uid ?? "");
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: MediaQuery.of(context).size.height / 10 + 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Notes",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      controller.noteItems.isNotEmpty
                          ? _buildNoteList(controller.noteItems)
                          : Container(),
                    ],
                  ),
                ),
              ),
              controller.isLoading.isTrue
                  ? const Center(child: CircularProgressIndicator())
                  : Container(),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height / 10,
                  decoration: const BoxDecoration(
                    color: Color(0xfffafafa),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 5,
                        blurRadius: 2,
                        offset: Offset(0, 7),
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          controller.noteItems.isEmpty
                              ? "No Notes"
                              : "${controller.noteItems.length} notes",
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: MediaQuery.of(context).size.height / 28,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditNotePage(
                                          isCreateNew: true,
                                        ))).then((value) => _bloc.fetchData(
                                firebaseAuth.currentUser?.uid ?? "")),
                            child: const Icon(
                              Icons.note_add,
                              color: Color(0xffddaf07),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteList(List<NoteItem> noteList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: noteList.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
          top: 8,
          right: 8,
          left: 8,
        ),
        itemBuilder: (context, index) =>
            _buildNoteTile(noteList[index], index == noteList.length - 1),
      ),
    );
  }

  Widget _buildNoteTile(NoteItem noteItem, isLatest) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) =>
          _bloc.deleteNote(firebaseAuth.currentUser?.uid ?? "", noteItem),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditNotePage(noteItem: noteItem)))
            .then((value) {
          if (value is NoteItem) {
            for (int i = 0; i < _bloc.noteItems.length; i++) {
              if (value.id == _bloc.noteItems[i].id) {
                _bloc.noteItems[i] = value;
              }
            }
            //Delay to make sure the database get updated before fetching fresh data
            Future.delayed(const Duration(milliseconds: 500),
                () => _bloc.fetchData(firebaseAuth.currentUser?.uid ?? ""));
          }
        }),
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
            !isLatest
                ? const Divider()
                : const SizedBox(
                    height: 8,
                  ),
          ],
        ),
      ),
    );
  }
}
