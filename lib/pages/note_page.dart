import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_keeper/database/note_database.dart';
import 'package:note_keeper/model/note.dart';
import 'package:note_keeper/pages/add_edit_pages.dart';
import 'package:note_keeper/pages/note_detail_pages.dart';
import 'package:note_keeper/widgets/note_card_widgets.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  bool isLoading = false;
  late List<Note> notes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Note Home")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text("Note Data Kosong")
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final route =
              MaterialPageRoute(builder: (context) => AddEditNotePage());
          await Navigator.push(context, route);
          refreshNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    notes = await NoteDatabase.instance.getAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  Widget buildNotes() {
    return MasonryGridView.count(
        crossAxisCount: 2,
        itemCount: notes.length,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
              onTap: () async {
                final route = MaterialPageRoute(
                    builder: (context) => NoteDetailPage(id: note.id!));
                await Navigator.push(context, route);
                refreshNotes();
              },
              child: NoteCardWidget(note: note, index: index));
        });
  }
}
