import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl, LaunchMode;
import '../../core/constants/app_constants.dart';

// شاشة "حول التطبيق" - ضرورية لمتطلبات Google Play
// يجب أن تحتوي على روابط سياسة الخصوصية وشروط الاستخدام

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حول التطبيق')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          const SizedBox(height: 24),
          // شعار التطبيق
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.note_alt_outlined,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // اسم التطبيق
          Text(
            AppConstants.appName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'الإصدار ${AppConstants.appVersion}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 32),

          // وصف التطبيق
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'تطبيق ملاحظات بسيط وآمن يحفظ ملاحظاتك على جهازك فقط دون أي مشاركة مع خوادم خارجية. جميع بياناتك تبقى تحت سيطرتك الكاملة.',
                style: TextStyle(fontSize: 15, height: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // معلومات الخصوصية
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield_outlined,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      const Text(
                        'الخصوصية',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• لا نجمع أي بيانات شخصية\n'
                    '• لا نستخدم خدمات تتبع أو تحليلات\n'
                    '• جميع الملاحظات تُحفظ على جهازك فقط\n'
                    '• لا يتطلب التطبيق الاتصال بالإنترنت',
                    style: TextStyle(fontSize: 14, height: 1.8),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // الروابط
          Card(
            child: Column(
              children: [
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('تواصل معنا'),
                  subtitle: const Text(AppConstants.developerEmail),
                  onTap: () => _launchUrl('mailto:${AppConstants.developerEmail}'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} ${AppConstants.developerName}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
