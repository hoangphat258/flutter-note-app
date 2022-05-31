import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_note_app/model/note_item.dart';
import 'package:flutter_note_app/modules/edit_note_screen/edit_note_bloc.dart';
import 'package:get/get.dart';

class EditNotePage extends StatefulWidget {
  const EditNotePage({
    Key? key,
    this.noteItem,
    this.isCreateNew = false,
    this.onUpdateSuccessfuly,
  }) : super(key: key);

  final NoteItem? noteItem;
  final bool isCreateNew;
  final Function(bool)? onUpdateSuccessfuly;

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController =
      TextEditingController();
  final _noteController = Get.put<EditNoteBloc>(EditNoteBloc());
  late StreamSubscription _updatedSuccessfullyStream, _alertMessageStream;

  @override
  void initState() {
    super.initState();
    _titleTextController.text = widget.noteItem?.title ?? "";
    _descriptionTextController.text = widget.noteItem?.description ?? "";

    _updatedSuccessfullyStream =
        _noteController.isUpdatedSuccessfully.listen((isUpdatedSuccessfully) {
      widget.onUpdateSuccessfuly?.call(isUpdatedSuccessfully);
      Get.back();
      _noteController.isUpdatedSuccessfully.value = false;
    });

    _alertMessageStream = _noteController.alertMessage.listen((message) {
      if (message.isNotEmpty) Get.defaultDialog(title: message);
    });
  }

  @override
  void dispose() {
    super.dispose();

    //Cancel these stream to avoid listening multiple times if using shared NoteListBloc
    // _alertMessageStream.cancel();
    // _updatedSuccessfullyStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
      ),
      body: _buildLayout(),
    );
  }

  _buildLayout() {
    return Stack(
      fit: StackFit.loose,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 50,),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Column(
                  children: [
                    TextField(
                      controller: _titleTextController,
                      maxLines: null,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: _descriptionTextController,
                      maxLines: null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: ElevatedButton(
            onPressed: () {
              widget.isCreateNew
                  ? _noteController.addNote(
                  "1234",
                  NoteItem(
                    title: _titleTextController.text,
                    description: _descriptionTextController.text,
                  ))
                  : _noteController.updateNote(
                  "1234",
                  NoteItem(
                    id: widget.noteItem?.id,
                    title: _titleTextController.text,
                    description: _descriptionTextController.text,
                  ));
            },
            child: Text(widget.isCreateNew ? "Save" : "Update"),
          ),
        ),
        Obx(() => _noteController.isLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container()),
      ],
    );
  }
}
