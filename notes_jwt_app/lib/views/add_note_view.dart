import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> saveNote() async {
    final token =
        context.read<AuthProvider>().token!;

    await ApiService().createNote(
      token: token,
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
        title: const Text('Tambah Catatan'),
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
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveNote,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}