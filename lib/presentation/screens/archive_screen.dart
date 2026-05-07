import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import 'note_editor_screen.dart';

// شاشة الأرشيف - تعرض الملاحظات المؤرشفة

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأرشيف'),
      ),
      body: Consumer<NotesProvider>(
        builder: (context, provider, _) {
          final notes = provider.archivedNotes;

          if (notes.isEmpty) {
            return const EmptyState(
              icon: Icons.archive_outlined,
              title: 'الأرشيف فارغ',
              subtitle: 'الملاحظات المؤرشفة ستظهر هنا',
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) => NoteCard(
              note: notes[index],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NoteEditorScreen(noteId: notes[index].id),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
