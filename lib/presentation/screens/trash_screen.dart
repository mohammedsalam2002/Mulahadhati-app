import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../providers/notes_provider.dart';
import '../widgets/empty_state.dart';

// شاشة سلة المحذوفات - يتم حذف الملاحظات نهائياً بعد 30 يوم تلقائياً

class TrashScreen extends StatelessWidget {
  const TrashScreen({super.key});

  // إفراغ السلة كاملة
  Future<void> _emptyTrash(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إفراغ السلة'),
        content: const Text(
            'سيتم حذف جميع الملاحظات في سلة المحذوفات نهائياً. هل أنت متأكد؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('إفراغ'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await context.read<NotesProvider>().emptyTrash();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المحذوفات'),
        actions: [
          Consumer<NotesProvider>(
            builder: (context, provider, _) {
              if (provider.trashedNotes.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_forever),
                tooltip: 'إفراغ السلة',
                onPressed: () => _emptyTrash(context),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, provider, _) {
          final notes = provider.trashedNotes;

          if (notes.isEmpty) {
            return const EmptyState(
              icon: Icons.delete_outline,
              title: 'سلة المحذوفات فارغة',
              subtitle: 'الملاحظات المحذوفة تُحذف تلقائياً بعد 30 يوماً',
            );
          }

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.orange.withOpacity(0.1),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'يتم حذف الملاحظات نهائياً بعد 30 يوماً',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          note.title.isEmpty ? 'بدون عنوان' : note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          'حُذف في ${DateFormat('yyyy/MM/dd').format(note.deletedAt ?? note.updatedAt)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.restore),
                              tooltip: 'استعادة',
                              onPressed: () => provider.restoreFromTrash(note.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_forever,
                                  color: Colors.red),
                              tooltip: 'حذف نهائي',
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('حذف نهائي'),
                                    content: const Text(
                                        'لا يمكن التراجع عن هذا الإجراء.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('إلغاء'),
                                      ),
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('حذف'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await provider.deletePermanently(note.id);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
