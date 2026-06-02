import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class EditNoteView extends StatefulWidget {
  final Note note;

  const EditNoteView({
    super.key,
    required this.note,
  });

  @override
  State<EditNoteView> createState() =>
      _EditNoteViewState();
}

class _EditNoteViewState
    extends State<EditNoteView> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();

    titleController =
        TextEditingController(text: widget.note.title);

    contentController =
        TextEditingController(text: widget.note.content);
  }

  Future<void> updateNote() async {
    final token =
        context.read<AuthProvider>().token!;

    await ApiService().updateNote(
      token: token,
      id: int.parse(widget.note.id),
      title: titleController.text,
      content: contentController.text,
    );

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateNote,
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}