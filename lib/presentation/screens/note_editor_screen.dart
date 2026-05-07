import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/export_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/note_model.dart';
import '../providers/notes_provider.dart';

// شاشة محرر الملاحظة - متوافقة مع flutter_quill 11.x
// تم إصلاح مشكلة اختفاء الكيبورد بفصل المحرر عن SingleChildScrollView

class NoteEditorScreen extends StatefulWidget {
  final String? noteId;

  const NoteEditorScreen({super.key, this.noteId});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late quill.QuillController _quillController;
  final _titleController = TextEditingController();
  final _tagController = TextEditingController();
  final _exportService = ExportService();
  final _editorFocusNode = FocusNode();
  final _editorScrollController = ScrollController();

  Note? _note;
  List<String> _tags = [];
  int _colorIndex = 0;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeNote();
  }

  void _initializeNote() {
    if (widget.noteId != null) {
      _note = context.read<NotesProvider>().allNotes.firstWhere(
            (n) => n.id == widget.noteId,
          );
      _titleController.text = _note!.title;
      _tags = List.from(_note!.tags);
      _colorIndex = _note!.colorIndex;

      try {
        final doc = quill.Document.fromJson(jsonDecode(_note!.content));
        _quillController = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        _quillController = quill.QuillController(
          document: quill.Document()..insert(0, _note!.plainText),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
    } else {
      _quillController = quill.QuillController.basic();
    }

    _titleController.addListener(() {
      if (mounted && !_hasChanges) setState(() => _hasChanges = true);
    });
    _quillController.addListener(() {
      if (mounted && !_hasChanges) setState(() => _hasChanges = true);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tagController.dispose();
    _quillController.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  // حفظ الملاحظة
  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = jsonEncode(_quillController.document.toDelta().toJson());
    final plainText = _quillController.document.toPlainText().trim();

    if (title.isEmpty && plainText.isEmpty) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final provider = context.read<NotesProvider>();

    if (_note == null) {
      await provider.addNote(
        title: title.isEmpty ? 'بدون عنوان' : title,
        content: content,
        plainText: plainText,
        tags: _tags,
        colorIndex: _colorIndex,
      );
    } else {
      final updated = _note!.copyWith(
        title: title.isEmpty ? 'بدون عنوان' : title,
        content: content,
        plainText: plainText,
        tags: _tags,
        colorIndex: _colorIndex,
      );
      await provider.updateNote(updated);
    }

    if (mounted) Navigator.pop(context);
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
        _hasChanges = true;
      });
    }
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر لون الملاحظة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(AppTheme.noteColors.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _colorIndex = index;
                      _hasChanges = true;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.noteColors[index],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _colorIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: _colorIndex == index ? 3 : 1,
                      ),
                    ),
                    child: _colorIndex == index
                        ? const Icon(Icons.check, color: Colors.black54)
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _exportNote(String format) async {
    if (_note == null) {
      await _saveNote();
      return;
    }
    if (format == 'pdf') {
      await _exportService.exportToPdf(_note!);
    } else {
      await _exportService.exportToTxt(_note!);
    }
  }

  Future<void> _onPopInvoked(bool didPop, dynamic result) async {
    if (didPop) return;
    if (_hasChanges) {
      await _saveNote();
    } else {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppTheme.getDarkNoteColors() : AppTheme.noteColors;
    final bgColor = colors[_colorIndex % colors.length];

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: _onPopInvoked,
      child: Scaffold(
        // مهم: resizeToAvoidBottomInset = true (افتراضي)
        // ليتم تعديل الواجهة عند ظهور الكيبورد
        resizeToAvoidBottomInset: true,
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.color_lens_outlined),
              tooltip: 'تغيير اللون',
              onPressed: _showColorPicker,
            ),
            if (_note != null) ...[
              IconButton(
                icon: Icon(_note!.isPinned
                    ? Icons.push_pin
                    : Icons.push_pin_outlined),
                tooltip: 'تثبيت',
                onPressed: () async {
                  await context.read<NotesProvider>().togglePin(_note!.id);
                  if (mounted) Navigator.pop(context);
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  switch (value) {
                    case 'archive':
                      await context
                          .read<NotesProvider>()
                          .toggleArchive(_note!.id);
                      if (mounted) Navigator.pop(context);
                      break;
                    case 'delete':
                      await context
                          .read<NotesProvider>()
                          .moveToTrash(_note!.id);
                      if (mounted) Navigator.pop(context);
                      break;
                    case 'pdf':
                      _exportNote('pdf');
                      break;
                    case 'txt':
                      _exportNote('txt');
                      break;
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'archive',
                    child: ListTile(
                      leading: Icon(_note!.isArchived
                          ? Icons.unarchive_outlined
                          : Icons.archive_outlined),
                      title:
                          Text(_note!.isArchived ? 'إلغاء الأرشفة' : 'أرشفة'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'pdf',
                    child: ListTile(
                      leading: Icon(Icons.picture_as_pdf_outlined),
                      title: Text('تصدير PDF'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'txt',
                    child: ListTile(
                      leading: Icon(Icons.text_snippet_outlined),
                      title: Text('تصدير TXT'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, color: Colors.red),
                      title: Text('حذف', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ],
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: 'حفظ',
              onPressed: _saveNote,
            ),
          ],
        ),
        // ====================================================
        // الحل: استخدام Column بدل SingleChildScrollView
        // ووضع QuillEditor داخل Expanded ليأخذ المساحة المتبقية
        // ====================================================
        body: Column(
          children: [
            // الجزء العلوي الثابت: العنوان + الوسوم
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppConstants.defaultPadding,
                AppConstants.defaultPadding,
                AppConstants.defaultPadding,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // حقل العنوان
                  TextField(
                    controller: _titleController,
                    maxLength: AppConstants.maxTitleLength,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'العنوان',
                      border: InputBorder.none,
                      counterText: '',
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  _buildTagsSection(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            // ====================================================
            // المحرر داخل Expanded - هذا يحل مشكلة الكيبورد
            // المحرر يستخدم scroll الخاص به الآن
            // ====================================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: quill.QuillEditor(
                  controller: _quillController,
                  focusNode: _editorFocusNode,
                  scrollController: _editorScrollController,
                  config: const quill.QuillEditorConfig(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    autoFocus: false,
                    expands: true, // مهم: ليملأ المساحة
                    placeholder: 'ابدأ الكتابة...',
                    scrollable: true, // مهم: scroll داخلي
                  ),
                ),
              ),
            ),
            // شريط الأدوات في الأسفل
            Container(
              decoration: BoxDecoration(
                color: bgColor,
                border: Border(
                  top: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                ),
              ),
              child: quill.QuillSimpleToolbar(
                controller: _quillController,
                config: const quill.QuillSimpleToolbarConfig(
                  showAlignmentButtons: true,
                  showBoldButton: true,
                  showItalicButton: true,
                  showUnderLineButton: true,
                  showStrikeThrough: true,
                  showListBullets: true,
                  showListNumbers: true,
                  showListCheck: true,
                  showQuote: true,
                  showFontFamily: false,
                  showFontSize: false,
                  showColorButton: true,
                  showBackgroundColorButton: false,
                  showClearFormat: true,
                  showHeaderStyle: true,
                  showCodeBlock: false,
                  showInlineCode: false,
                  showLink: false,
                  showSearchButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                  multiRowsDisplay: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ..._tags.map((tag) => Chip(
              label: Text(tag),
              onDeleted: () => setState(() {
                _tags.remove(tag);
                _hasChanges = true;
              }),
              visualDensity: VisualDensity.compact,
            )),
        ActionChip(
          label: const Text('+ إضافة وسم'),
          onPressed: () => _showAddTagDialog(),
        ),
      ],
    );
  }

  void _showAddTagDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة وسم'),
        content: TextField(
          controller: _tagController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'اسم الوسم'),
          onSubmitted: (_) {
            _addTag();
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _tagController.clear();
              Navigator.pop(context);
            },
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              _addTag();
              Navigator.pop(context);
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}