

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/model/note.dart';
import 'package:note_keeper/pages/add_edit_pages.dart';

import '../database/note_database.dart';

class NoteDetailPage extends StatefulWidget {
  final int id;
  const NoteDetailPage({super.key, required this.id});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool isLoading = false;
  late Note note;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                     //color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: const TextStyle(color: Colors.white38),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    note.description,
                   // style: const TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ));
  }

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });

    note = await NoteDatabase.instance.getNoteById(widget.id);

    setState(() {
      isLoading = false;
    });
  }

  Widget editButton() =>
      IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () async {
        if (isLoading) return;
        final route = MaterialPageRoute(builder: (context)=> AddEditNotePage(note: note,));
        await Navigator.push(context, route);
        refreshNote();
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          if (isLoading) return;
          await NoteDatabase.instance.deleteNoteById(note.id!);
          Navigator.pop(context);
        },
      );
}
