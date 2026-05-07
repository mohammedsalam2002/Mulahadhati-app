import 'package:flutter/foundation.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/notes_repository.dart';

// طرق الترتيب المتاحة
enum SortMethod {
  dateDesc, // الأحدث أولاً
  dateAsc, // الأقدم أولاً
  titleAsc, // أبجدياً (أ-ي)
  titleDesc, // أبجدياً (ي-أ)
  updatedDesc, // آخر تعديل
}

// مزود الملاحظات - يدير حالة الملاحظات في التطبيق
// يستخدم ChangeNotifier لإعلام الواجهة بالتغييرات

class NotesProvider with ChangeNotifier {
  final NotesRepository _repository;

  NotesProvider(this._repository) {
    loadNotes();
  }

  List<Note> _notes = [];
  String _searchQuery = '';
  SortMethod _sortMethod = SortMethod.dateDesc;
  String? _selectedTag;

  // المُغيِّرات (Getters)
  List<Note> get allNotes => _notes;
  String get searchQuery => _searchQuery;
  SortMethod get sortMethod => _sortMethod;
  String? get selectedTag => _selectedTag;
  List<String> get allTags => _repository.getAllTags();

  // الملاحظات النشطة المُرتبة والمفلترة
  List<Note> get activeNotes {
    var notes = _searchQuery.isNotEmpty
        ? _repository.searchNotes(_searchQuery).where((n) => !n.isArchived).toList()
        : _repository.getActiveNotes();

    // تطبيق فلتر الوسوم
    if (_selectedTag != null && _selectedTag!.isNotEmpty) {
      notes = notes.where((n) => n.tags.contains(_selectedTag)).toList();
    }

    // الترتيب: المثبتة أولاً ثم حسب الترتيب المختار
    final pinned = notes.where((n) => n.isPinned).toList();
    final unpinned = notes.where((n) => !n.isPinned).toList();

    _sortNotes(pinned);
    _sortNotes(unpinned);

    return [...pinned, ...unpinned];
  }

  List<Note> get archivedNotes {
    final notes = _repository.getArchivedNotes();
    _sortNotes(notes);
    return notes;
  }

  List<Note> get trashedNotes {
    final notes = _repository.getTrashedNotes();
    notes.sort((a, b) =>
        (b.deletedAt ?? b.updatedAt).compareTo(a.deletedAt ?? a.updatedAt));
    return notes;
  }

  // تحميل الملاحظات وتنظيف القديمة
  Future<void> loadNotes() async {
    await _repository.cleanupOldTrash();
    _notes = _repository.getAllNotes();
    notifyListeners();
  }

  // إضافة ملاحظة
  Future<Note> addNote({
    required String title,
    required String content,
    required String plainText,
    List<String> tags = const [],
    int colorIndex = 0,
  }) async {
    final note = await _repository.addNote(
      title: title,
      content: content,
      plainText: plainText,
      tags: tags,
      colorIndex: colorIndex,
    );
    await loadNotes();
    return note;
  }

  // تعديل ملاحظة
  Future<void> updateNote(Note note) async {
    await _repository.updateNote(note);
    await loadNotes();
  }

  // نقل إلى سلة المحذوفات
  Future<void> moveToTrash(String id) async {
    await _repository.moveToTrash(id);
    await loadNotes();
  }

  // استعادة من سلة المحذوفات
  Future<void> restoreFromTrash(String id) async {
    await _repository.restoreFromTrash(id);
    await loadNotes();
  }

  // حذف نهائي
  Future<void> deletePermanently(String id) async {
    await _repository.deletePermanently(id);
    await loadNotes();
  }

  // تثبيت/إلغاء تثبيت
  Future<void> togglePin(String id) async {
    await _repository.togglePin(id);
    await loadNotes();
  }

  // أرشفة/إلغاء أرشفة
  Future<void> toggleArchive(String id) async {
    await _repository.toggleArchive(id);
    await loadNotes();
  }

  // إفراغ سلة المحذوفات
  Future<void> emptyTrash() async {
    await _repository.emptyTrash();
    await loadNotes();
  }

  // تحديث استعلام البحث
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // تعيين طريقة الترتيب
  void setSortMethod(SortMethod method) {
    _sortMethod = method;
    notifyListeners();
  }

  // تعيين فلتر الوسم
  void setTagFilter(String? tag) {
    _selectedTag = tag;
    notifyListeners();
  }

  // مسح جميع الفلاتر
  void clearFilters() {
    _searchQuery = '';
    _selectedTag = null;
    notifyListeners();
  }

  // ترتيب القائمة بناءً على الطريقة المختارة
  void _sortNotes(List<Note> notes) {
    switch (_sortMethod) {
      case SortMethod.dateDesc:
        notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortMethod.dateAsc:
        notes.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortMethod.titleAsc:
        notes.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortMethod.titleDesc:
        notes.sort(
            (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case SortMethod.updatedDesc:
        notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
    }
  }
}
