import 'package:flutter/material.dart';
import 'package:note_keeper/database/note_database.dart';
import 'package:note_keeper/model/note.dart';
import 'package:note_keeper/widgets/note_form_widgets.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButtonSave()],
      ),
      body: Form(
          key: _formKey,
          child: NoteFormWidget(
            isImportant: isImportant,
            number: number,
            title: title,
            description: description,
            onChangeDescription: (value) {
              description = value;
            },
            onChangeIsImportant: (value) {
              setState(() {
                isImportant = value;
              });
            },
            onChangeNumber: (value) {
              setState(() {
                number = value;
              });
            },
            onChangeTitle: (value) {
              title = value;
            },
          )),
    );
  }

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? "";
    description = widget.note?.description ?? "";
  }

  buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        onPressed: addOrEditNote,
        child: const Text("Save"),
      ),
    );
  }

  void addOrEditNote() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdate = widget.note != null;
      if (isUpdate) {
        updateNote();
      } else {
        //TAMBAH DATA
        addNote();
      }

      //KEMBALI KE HALAMAN SEBELUMNYA
      Navigator.pop(context);
    }
  }

  Future addNote() async {
    final note = Note(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());
    await NoteDatabase.instance.create(note);
  }
  Future updateNote() async {
    final note = widget.note?.copy(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());
    await NoteDatabase.instance.updateNote(note!);
  }
}
