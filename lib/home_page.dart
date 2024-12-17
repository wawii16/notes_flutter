import 'package:flutter/material.dart';
import 'add_note_page.dart';
import 'note_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> notes = [];

  // Tambahkan catatan
  void addNote(String title, String content) {
    setState(() {
      notes.add({'title': title, 'content': content});
    });
  }

  // Edit catatan
  void editNote(int index, String updatedTitle, String updatedContent) {
    setState(() {
      notes[index] = {'title': updatedTitle, 'content': updatedContent};
    });
  }

  // Hapus catatan
  void removeNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Catatan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: notes.isEmpty
          ? const Center(
        child: Text(
          'Belum ada catatan. Tambahkan sekarang!',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteItem(
            title: notes[index]['title']!,
            content: notes[index]['content']!,
            onEdit: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNotePage(
                    initialTitle: notes[index]['title']!,
                    initialContent: notes[index]['content']!,
                  ),
                ),
              );

              if (result != null && result is Map<String, String>) {
                editNote(index, result['title']!, result['content']!);
              }
            },
            onDelete: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Hapus Catatan'),
                  content: const Text(
                      'Apakah Anda yakin ingin menghapus catatan ini?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        removeNote(index);
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNotePage()),
          );

          if (result != null && result is Map<String, String>) {
            addNote(result['title']!, result['content']!);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
