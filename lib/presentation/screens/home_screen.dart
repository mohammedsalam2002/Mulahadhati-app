import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/sort_dialog.dart';
import 'note_editor_screen.dart';
import 'archive_screen.dart';
import 'trash_screen.dart';
import 'settings_screen.dart';

// الشاشة الرئيسية - تعرض قائمة الملاحظات النشطة

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // البحث مع تأخير لتقليل عمليات البحث
  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(AppConstants.searchDebounce, () {
      context.read<NotesProvider>().setSearchQuery(value);
    });
  }

  void _openEditor({String? noteId}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(noteId: noteId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView ? 'عرض قائمة' : 'عرض شبكة',
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'ترتيب',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const SortDialog(),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'ابحث في الملاحظات...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<NotesProvider>().setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          // فلتر الوسوم
          _buildTagsFilter(),
          // قائمة الملاحظات
          Expanded(
            child: Consumer<NotesProvider>(
              builder: (context, provider, child) {
                final notes = provider.activeNotes;

                if (notes.isEmpty) {
                  return EmptyState(
                    icon: provider.searchQuery.isNotEmpty
                        ? Icons.search_off
                        : Icons.note_add_outlined,
                    title: provider.searchQuery.isNotEmpty
                        ? 'لا توجد نتائج'
                        : 'لا توجد ملاحظات بعد',
                    subtitle: provider.searchQuery.isNotEmpty
                        ? 'جرّب كلمة بحث أخرى'
                        : 'اضغط زر + لإضافة ملاحظة جديدة',
                  );
                }

                return _isGridView
                    ? _buildGridView(notes)
                    : _buildListView(notes);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        tooltip: 'ملاحظة جديدة',
        child: const Icon(Icons.add),
      ),
    );
  }

  // عرض شبكة
  Widget _buildGridView(List notes) {
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
        onTap: () => _openEditor(noteId: notes[index].id),
      ),
    );
  }

  // عرض قائمة
  Widget _buildListView(List notes) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: notes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) => NoteCard(
        note: notes[index],
        isListView: true,
        onTap: () => _openEditor(noteId: notes[index].id),
      ),
    );
  }

  // فلتر الوسوم الأفقي
  Widget _buildTagsFilter() {
    return Consumer<NotesProvider>(
      builder: (context, provider, _) {
        final tags = provider.allTags;
        if (tags.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              FilterChip(
                label: const Text('الكل'),
                selected: provider.selectedTag == null,
                onSelected: (_) => provider.setTagFilter(null),
              ),
              const SizedBox(width: 8),
              ...tags.map((tag) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: FilterChip(
                      label: Text(tag),
                      selected: provider.selectedTag == tag,
                      onSelected: (selected) =>
                          provider.setTagFilter(selected ? tag : null),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  // القائمة الجانبية
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.note_alt_outlined,
                    size: 48, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.note_outlined),
            title: const Text('الملاحظات'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: const Text('الأرشيف'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ArchiveScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('سلة المحذوفات'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TrashScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('الإعدادات'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
