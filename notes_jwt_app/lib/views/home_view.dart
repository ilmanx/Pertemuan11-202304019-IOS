import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import 'add_note_view.dart';
import 'edit_note_view.dart';
import 'login_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<List<Note>> _fetchNotes(String token) async {
    final data = await ApiService().getNotes(token);

    return data.map<Note>((item) {
      return Note.fromJson(item);
    }).toList();
  }

  Future<void> _deleteNote(
    Note note,
    String token,
  ) async {
    await ApiService().deleteNote(
      token: token,
      id: int.parse(note.id),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Pribadi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();

              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginView(),
                  ),
                );
              }
            },
          ),
        ],
      ),

      // TOMBOL TAMBAH
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddNoteView(),
            ),
          );

          if (result == true) {
            setState(() {});
          }
        },
      ),

      body: FutureBuilder<List<Note>>(
        future: _fetchNotes(authProvider.token ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada catatan',
              ),
            );
          }

          final notes = snapshot.data!;

          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      note.id.toString(),
                    ),
                  ),
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // EDIT
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final result =
                              await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditNoteView(
                                note: note,
                              ),
                            ),
                          );

                          if (result == true) {
                            setState(() {});
                          }
                        },
                      ),

                      // DELETE
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _deleteNote(
                            note,
                            authProvider.token ?? '',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}