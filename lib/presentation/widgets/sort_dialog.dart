import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';

// ويدجت اختيار طريقة الترتيب

class SortDialog extends StatelessWidget {
  const SortDialog({super.key});

  String _getSortLabel(SortMethod method) {
    switch (method) {
      case SortMethod.dateDesc:
        return 'الأحدث أولاً';
      case SortMethod.dateAsc:
        return 'الأقدم أولاً';
      case SortMethod.titleAsc:
        return 'العنوان (أ-ي)';
      case SortMethod.titleDesc:
        return 'العنوان (ي-أ)';
      case SortMethod.updatedDesc:
        return 'آخر تعديل';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();

    return SimpleDialog(
      title: const Text('ترتيب حسب'),
      children: [
        for (var method in SortMethod.values)
          RadioListTile<SortMethod>(
            title: Text(_getSortLabel(method)),
            value: method,
            groupValue: provider.sortMethod,
            onChanged: (value) {
              if (value != null) provider.setSortMethod(value);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
