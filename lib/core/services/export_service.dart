import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../data/models/note_model.dart';

// خدمة تصدير الملاحظات إلى PDF أو TXT

class ExportService {
  // تصدير ملاحظة كـ PDF
  Future<String?> exportToPdf(Note note) async {
    try {
      final pdf = pw.Document();

      // تحميل خط يدعم العربية
      final fontData =
          await rootBundle.load('assets/fonts/Cairo-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);

      final boldFontData =
          await rootBundle.load('assets/fonts/Cairo-Bold.ttf');
      final boldTtf = pw.Font.ttf(boldFontData);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          textDirection: pw.TextDirection.rtl,
          theme: pw.ThemeData.withFont(base: ttf, bold: boldTtf),
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                note.title.isEmpty ? 'بدون عنوان' : note.title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'تاريخ الإنشاء: ${DateFormat('yyyy/MM/dd - HH:mm').format(note.createdAt)}',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
            if (note.tags.isNotEmpty) ...[
              pw.SizedBox(height: 4),
              pw.Text(
                'الوسوم: ${note.tags.join("، ")}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ],
            pw.Divider(),
            pw.SizedBox(height: 12),
            pw.Text(
              note.plainText,
              style: const pw.TextStyle(fontSize: 14, lineSpacing: 1.5),
            ),
          ],
          footer: (context) => pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(top: 16),
            child: pw.Text(
              'صفحة ${context.pageNumber} من ${context.pagesCount}',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey,
              ),
            ),
          ),
        ),
      );

      final dir = await getTemporaryDirectory();
      final fileName = _sanitizeFileName(note.title);
      final file = File('${dir.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([XFile(file.path)], text: note.title);
      return file.path;
    } catch (e) {
      return null;
    }
  }

  // تصدير ملاحظة كـ TXT
  Future<String?> exportToTxt(Note note) async {
    try {
      final dir = await getTemporaryDirectory();
      final fileName = _sanitizeFileName(note.title);
      final file = File('${dir.path}/$fileName.txt');

      final buffer = StringBuffer();
      buffer.writeln(note.title.isEmpty ? 'بدون عنوان' : note.title);
      buffer.writeln('=' * 40);
      buffer.writeln(
        'التاريخ: ${DateFormat('yyyy/MM/dd - HH:mm').format(note.createdAt)}',
      );
      if (note.tags.isNotEmpty) {
        buffer.writeln('الوسوم: ${note.tags.join("، ")}');
      }
      buffer.writeln('-' * 40);
      buffer.writeln();
      buffer.writeln(note.plainText);

      await file.writeAsString(buffer.toString());
      await Share.shareXFiles([XFile(file.path)], text: note.title);
      return file.path;
    } catch (e) {
      return null;
    }
  }

  // تنظيف اسم الملف من الرموز غير المسموحة
  String _sanitizeFileName(String name) {
    if (name.isEmpty) return 'note_${DateTime.now().millisecondsSinceEpoch}';
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_').trim();
  }
}
