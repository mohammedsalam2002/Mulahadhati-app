import 'package:hive/hive.dart';

part 'note_model.g.dart';

// نموذج الملاحظة - يُستخدم مع Hive للتخزين المحلي
// بعد التعديل: شغّل `flutter pub run build_runner build` لتوليد ملف note_model.g.dart

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content; // محتوى الملاحظة بصيغة JSON من flutter_quill

  @HiveField(3)
  String plainText; // نص مجرد للبحث

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  List<String> tags;

  @HiveField(7)
  bool isPinned;

  @HiveField(8)
  bool isArchived;

  @HiveField(9)
  bool isDeleted;

  @HiveField(10)
  DateTime? deletedAt;

  @HiveField(11)
  int colorIndex; // فهرس اللون من قائمة الألوان

  @HiveField(12)
  String? category;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.plainText,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.isPinned = false,
    this.isArchived = false,
    this.isDeleted = false,
    this.deletedAt,
    this.colorIndex = 0,
    this.category,
  });

  // إنشاء نسخة معدلة من الملاحظة
  Note copyWith({
    String? title,
    String? content,
    String? plainText,
    DateTime? updatedAt,
    List<String>? tags,
    bool? isPinned,
    bool? isArchived,
    bool? isDeleted,
    DateTime? deletedAt,
    int? colorIndex,
    String? category,
  }) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      plainText: plainText ?? this.plainText,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      colorIndex: colorIndex ?? this.colorIndex,
      category: category ?? this.category,
    );
  }

  // تحويل إلى Map (للتصدير/النسخ الاحتياطي)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'plainText': plainText,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tags': tags,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt?.toIso8601String(),
      'colorIndex': colorIndex,
      'category': category,
    };
  }

  // إنشاء من Map (للاستيراد/الاستعادة)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      plainText: json['plainText'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tags: List<String>.from(json['tags'] ?? []),
      isPinned: json['isPinned'] ?? false,
      isArchived: json['isArchived'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      colorIndex: json['colorIndex'] ?? 0,
      category: json['category'] as String?,
    );
  }
}
