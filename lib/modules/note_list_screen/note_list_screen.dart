import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _bloc.fetchData("1234");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(
          () => EditNotePage(
            isCreateNew: true,
            onUpdateSuccessfuly: (isUpdateSuccessfully) {
              if (isUpdateSuccessfully) {
                _bloc.fetchData("1234");
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
            _bloc.fetchData("1234");
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
      onLongPress: () => _bloc.deleteNote("1234", noteItem),
      onTap: () => Get.to(() => EditNotePage(
            noteItem: noteItem,
            onUpdateSuccessfuly: (isUpdateSuccessfully) {
              if (isUpdateSuccessfully) {
                _bloc.fetchData("1234");
              }
            },
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            noteItem.title ?? "",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("${noteItem.timestamp}"),
              const SizedBox(width: 8,),
              Expanded(
                child: Text(
                  noteItem.description ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 18,),
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
