import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/notes_repository.dart';

// خدمة النسخ الاحتياطي والاستعادة
// تحفظ الملاحظات في ملف JSON يمكن استعادته لاحقاً

class BackupService {
  final NotesRepository _repository;

  BackupService(this._repository);

  // إنشاء نسخة احتياطية وحفظها
  Future<String?> createBackup() async {
    try {
      final notes = _repository.getAllNotes();
      final backupData = {
        'version': '1.0',
        'createdAt': DateTime.now().toIso8601String(),
        'notesCount': notes.length,
        'notes': notes.map((n) => n.toJson()).toList(),
      };

      final jsonString = jsonEncode(backupData);
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${dir.path}/notes_backup_$timestamp.json');
      await file.writeAsString(jsonString);

      return file.path;
    } catch (e) {
      return null;
    }
  }

  // مشاركة ملف النسخة الاحتياطية
  Future<bool> shareBackup() async {
    final path = await createBackup();
    if (path == null) return false;

    try {
      await Share.shareXFiles(
        [XFile(path)],
        text: 'نسخة احتياطية لملاحظاتي',
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // استعادة من نسخة احتياطية
  Future<({bool success, int count, String? error})> restoreFromBackup() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) {
        return (success: false, count: 0, error: 'لم يتم اختيار ملف');
      }

      final file = File(result.files.first.path!);
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      // التحقق من صحة الملف
      if (!data.containsKey('notes')) {
        return (
          success: false,
          count: 0,
          error: 'الملف غير صالح أو تالف'
        );
      }

      final notesJson = data['notes'] as List;
      final notes = notesJson
          .map((json) => Note.fromJson(json as Map<String, dynamic>))
          .toList();

      await _repository.importNotes(notes);

      return (success: true, count: notes.length, error: null);
    } catch (e) {
      return (
        success: false,
        count: 0,
        error: 'خطأ في الاستعادة: ${e.toString()}'
      );
    }
  }
}
