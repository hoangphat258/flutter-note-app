import 'package:flutter/material.dart';
import 'package:flutter_note_app/module/note_list_screen/note_list_bloc.dart';
import 'package:get/get.dart';

import '../../model/note_item.dart';
import '../edit_note_screen/edit_note_page.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {

  final _viewModel = Get.put<NoteListBloc>(NoteListBloc());

  @override
  void initState() {
    super.initState();
    _viewModel.fetchData("1234");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() =>
          EditNotePage(
            isCreateNew: true,
            onUpdateSuccessfuly: (isUpdateSuccessfully) {
              if (isUpdateSuccessfully) {
                _viewModel.fetchData("1234");
              }
            },
          ),
        ),
        child: const Icon(Icons.add_circle),
      ),
      body: GetX<NoteListBloc>(
        init: Get.put<NoteListBloc>(NoteListBloc()),
        builder: (controller) => Stack(
          children: [
            _buildNoteList(controller.noteItems),
            controller.isLoading.isTrue
                ? const Center(child: CircularProgressIndicator())
                : Container(),
          ],
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
      onTap: () => Get.to(() =>
        EditNotePage(
          noteItem: noteItem,
          onUpdateSuccessfuly: (isUpdateSuccessfully) {
            if (isUpdateSuccessfully) {
              _viewModel.fetchData("1234");
            }
          },
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            noteItem.title ?? "",
            style: const TextStyle(fontSize: 22),
          ),
          Text(
            noteItem.description ?? "",
            style: const TextStyle(fontSize: 18),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
