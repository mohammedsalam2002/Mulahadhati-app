import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/backup_service.dart';
import '../../data/repositories/notes_repository.dart';
import '../providers/settings_provider.dart';
import 'about_screen.dart';

// شاشة الإعدادات - تشمل المظهر، اللغة، الأمان، النسخ الاحتياطي

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  late final BackupService _backupService;

  @override
  void initState() {
    super.initState();
    _backupService = BackupService(NotesRepository());
  }

  // تعيين PIN جديد
  Future<void> _setupPin() async {
    final pinController = TextEditingController();
    final confirmController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تعيين رمز PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'PIN جديد (4-6 أرقام)',
              ),
            ),
            TextField(
              controller: confirmController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'تأكيد PIN',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              if (pinController.text.length < 4) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يجب أن يكون PIN 4 أرقام على الأقل')),
                );
                return;
              }
              if (pinController.text != confirmController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN غير متطابق')),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _authService.setPin(pinController.text);
      if (mounted) {
        await context.read<SettingsProvider>().setLockEnabled(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تفعيل قفل التطبيق')),
        );
      }
    }
  }

  // تفعيل/تعطيل القفل
  Future<void> _toggleLock(bool value) async {
    final settings = context.read<SettingsProvider>();
    if (value) {
      await _setupPin();
    } else {
      await _authService.removePin();
      await settings.setLockEnabled(false);
    }
  }

  // تفعيل/تعطيل البصمة
  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      final available = await _authService.isBiometricAvailable();
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('البصمة غير متوفرة على هذا الجهاز')),
          );
        }
        return;
      }
    }
    if (mounted) {
      await context.read<SettingsProvider>().setBiometricEnabled(value);
    }
  }

  // إنشاء نسخة احتياطية
  Future<void> _createBackup() async {
    final success = await _backupService.shareBackup();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'تم إنشاء النسخة الاحتياطية بنجاح'
              : 'فشل إنشاء النسخة الاحتياطية'),
        ),
      );
    }
  }

  // استعادة من نسخة احتياطية
  Future<void> _restoreBackup() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('استعادة من نسخة احتياطية'),
        content: const Text(
            'سيتم دمج الملاحظات من النسخة الاحتياطية مع ملاحظاتك الحالية.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('متابعة'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await _backupService.restoreFromBackup();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.success
              ? 'تم استعادة ${result.count} ملاحظة بنجاح'
              : result.error ?? 'فشل في الاستعادة'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) => ListView(
          children: [
            // قسم المظهر
            _SectionHeader(title: 'المظهر'),
            ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('الوضع'),
              subtitle: Text(_themeName(settings.themeMode)),
              onTap: () => _showThemeDialog(settings),
            ),

            // قسم الأمان
            _SectionHeader(title: 'الأمان والخصوصية'),
            SwitchListTile(
              secondary: const Icon(Icons.lock_outline),
              title: const Text('قفل التطبيق'),
              subtitle: const Text('حماية الملاحظات برمز PIN'),
              value: settings.lockEnabled,
              onChanged: _toggleLock,
            ),
            if (settings.lockEnabled)
              SwitchListTile(
                secondary: const Icon(Icons.fingerprint),
                title: const Text('فتح بالبصمة'),
                subtitle: const Text('استخدم بصمة الإصبع لفتح التطبيق'),
                value: settings.biometricEnabled,
                onChanged: _toggleBiometric,
              ),

            // قسم البيانات
            _SectionHeader(title: 'النسخ الاحتياطي'),
            ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: const Text('إنشاء نسخة احتياطية'),
              subtitle: const Text('حفظ جميع الملاحظات في ملف'),
              onTap: _createBackup,
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('استعادة نسخة احتياطية'),
              subtitle: const Text('استيراد الملاحظات من ملف'),
              onTap: _restoreBackup,
            ),

            // قسم حول
            _SectionHeader(title: 'معلومات'),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('حول التطبيق'),
              subtitle: const Text('الإصدار ${AppConstants.appVersion}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'فاتح';
      case ThemeMode.dark:
        return 'داكن';
      case ThemeMode.system:
        return 'تلقائي (حسب النظام)';
    }
  }

  void _showThemeDialog(SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('اختر الوضع'),
        children: [
          for (var mode in ThemeMode.values)
            RadioListTile<ThemeMode>(
              title: Text(_themeName(mode)),
              value: mode,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) settings.setThemeMode(value);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}

// رأس قسم الإعدادات
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
