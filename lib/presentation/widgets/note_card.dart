import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/note_model.dart';
import '../providers/notes_provider.dart';

// ويدجت بطاقة الملاحظة - تُستخدم في القائمة الرئيسية والأرشيف

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final bool isListView;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    this.isListView = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppTheme.getDarkNoteColors() : AppTheme.noteColors;
    final cardColor = colors[note.colorIndex % colors.length];

    return Card(
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        onLongPress: () => _showOptions(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصف العلوي: العنوان + أيقونة التثبيت
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? 'بدون عنوان' : note.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.isPinned)
                    const Icon(Icons.push_pin, size: 16, color: Colors.black54),
                ],
              ),
              const SizedBox(height: 8),
              // المحتوى
              Expanded(
                child: Text(
                  note.plainText,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.7),
                    height: 1.4,
                  ),
                  maxLines: isListView ? 2 : 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              // الوسوم
              if (note.tags.isNotEmpty)
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: note.tags.take(2).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 4),
              // التاريخ
              Text(
                DateFormat('yyyy/MM/dd').format(note.updatedAt),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // قائمة الخيارات عند الضغط المطوّل
  void _showOptions(BuildContext context) {
    final provider = context.read<NotesProvider>();
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(note.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(note.isPinned ? 'إلغاء التثبيت' : 'تثبيت'),
              onTap: () {
                provider.togglePin(note.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(note.isArchived
                  ? Icons.unarchive_outlined
                  : Icons.archive_outlined),
              title: Text(note.isArchived ? 'إلغاء الأرشفة' : 'أرشفة'),
              onTap: () {
                provider.toggleArchive(note.id);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('حذف', style: TextStyle(color: Colors.red)),
              onTap: () {
                provider.moveToTrash(note.id);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
