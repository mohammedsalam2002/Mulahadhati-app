import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/note_model.dart';
import '../../core/constants/app_constants.dart';

// مستودع الملاحظات - يدير جميع عمليات CRUD
// يستخدم Hive للتخزين المحلي السريع والآمن

class NotesRepository {
  final _uuid = const Uuid();
  Box<Note> get _box => Hive.box<Note>(AppConstants.notesBox);

  // إضافة ملاحظة جديدة
  Future<Note> addNote({
    required String title,
    required String content,
    required String plainText,
    List<String> tags = const [],
    int colorIndex = 0,
    String? category,
  }) async {
    final note = Note(
      id: _uuid.v4(),
      title: title,
      content: content,
      plainText: plainText,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: tags,
      colorIndex: colorIndex,
      category: category,
    );
    await _box.put(note.id, note);
    return note;
  }

  // تعديل ملاحظة موجودة
  Future<void> updateNote(Note note) async {
    final updatedNote = note.copyWith(updatedAt: DateTime.now());
    await _box.put(note.id, updatedNote);
  }

  // نقل الملاحظة إلى سلة المحذوفات
  Future<void> moveToTrash(String id) async {
    final note = _box.get(id);
    if (note != null) {
      final updated = note.copyWith(
        isDeleted: true,
        deletedAt: DateTime.now(),
        isPinned: false,
      );
      await _box.put(id, updated);
    }
  }

  // استعادة ملاحظة من سلة المحذوفات
  Future<void> restoreFromTrash(String id) async {
    final note = _box.get(id);
    if (note != null) {
      final updated = note.copyWith(
        isDeleted: false,
        deletedAt: null,
      );
      await _box.put(id, updated);
    }
  }

  // حذف نهائي
  Future<void> deletePermanently(String id) async {
    await _box.delete(id);
  }

  // تثبيت/إلغاء تثبيت
  Future<void> togglePin(String id) async {
    final note = _box.get(id);
    if (note != null) {
      final updated = note.copyWith(isPinned: !note.isPinned);
      await _box.put(id, updated);
    }
  }

  // أرشفة/إلغاء أرشفة
  Future<void> toggleArchive(String id) async {
    final note = _box.get(id);
    if (note != null) {
      final updated = note.copyWith(
        isArchived: !note.isArchived,
        isPinned: false,
      );
      await _box.put(id, updated);
    }
  }

  // الحصول على جميع الملاحظات النشطة (غير محذوفة وغير مؤرشفة)
  List<Note> getActiveNotes() {
    return _box.values
        .where((note) => !note.isDeleted && !note.isArchived)
        .toList();
  }

  // الحصول على الملاحظات المؤرشفة
  List<Note> getArchivedNotes() {
    return _box.values
        .where((note) => !note.isDeleted && note.isArchived)
        .toList();
  }

  // الحصول على ملاحظات سلة المحذوفات
  List<Note> getTrashedNotes() {
    return _box.values.where((note) => note.isDeleted).toList();
  }

  // الحصول على ملاحظة بالمعرف
  Note? getNoteById(String id) => _box.get(id);

  // البحث في الملاحظات
  List<Note> searchNotes(String query) {
    if (query.isEmpty) return getActiveNotes();
    final lowerQuery = query.toLowerCase();
    return _box.values
        .where((note) =>
            !note.isDeleted &&
            (note.title.toLowerCase().contains(lowerQuery) ||
                note.plainText.toLowerCase().contains(lowerQuery) ||
                note.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))))
        .toList();
  }

  // الحصول على جميع الوسوم المستخدمة
  List<String> getAllTags() {
    final Set<String> tags = {};
    for (var note in _box.values) {
      if (!note.isDeleted) {
        tags.addAll(note.tags);
      }
    }
    return tags.toList()..sort();
  }

  // تنظيف سلة المحذوفات تلقائياً (الأقدم من 30 يوم)
  Future<void> cleanupOldTrash() async {
    final now = DateTime.now();
    final toDelete = <String>[];

    for (var note in _box.values) {
      if (note.isDeleted && note.deletedAt != null) {
        final daysSinceDeleted = now.difference(note.deletedAt!).inDays;
        if (daysSinceDeleted > AppConstants.trashRetentionDays) {
          toDelete.add(note.id);
        }
      }
    }

    for (var id in toDelete) {
      await _box.delete(id);
    }
  }

  // إفراغ سلة المحذوفات يدوياً
  Future<void> emptyTrash() async {
    final trashedIds = _box.values
        .where((note) => note.isDeleted)
        .map((note) => note.id)
        .toList();

    for (var id in trashedIds) {
      await _box.delete(id);
    }
  }

  // الحصول على جميع الملاحظات (للنسخ الاحتياطي)
  List<Note> getAllNotes() => _box.values.toList();

  // استيراد ملاحظات (للاستعادة من نسخة احتياطية)
  Future<void> importNotes(List<Note> notes) async {
    for (var note in notes) {
      await _box.put(note.id, note);
    }
  }
}
