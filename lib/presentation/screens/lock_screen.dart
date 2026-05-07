import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import '../providers/settings_provider.dart';
import 'home_screen.dart';

// شاشة القفل - تظهر عند فتح التطبيق إذا كان القفل مفعّلاً

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _authService = AuthService();
  final _pinController = TextEditingController();
  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tryBiometric();
  }

  // محاولة المصادقة بالبصمة تلقائياً
  Future<void> _tryBiometric() async {
    final settings = context.read<SettingsProvider>();
    if (!settings.biometricEnabled) return;

    final available = await _authService.isBiometricAvailable();
    if (!available) return;

    final authenticated = await _authService.authenticateWithBiometric(
      reason: 'افتح التطبيق ببصمة الإصبع',
    );

    if (authenticated && mounted) {
      _navigateToHome();
    }
  }

  // التحقق من PIN
  Future<void> _verifyPin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final isValid = await _authService.verifyPin(_pinController.text);

    setState(() => _isLoading = false);

    if (isValid && mounted) {
      _navigateToHome();
    } else {
      setState(() {
        _errorMessage = 'رمز PIN غير صحيح';
        _pinController.clear();
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'أدخل رمز PIN',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
                decoration: const InputDecoration(
                  hintText: '••••',
                  counterText: '',
                ),
                onSubmitted: (_) => _verifyPin(),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _verifyPin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('فتح'),
                ),
              ),
              if (settings.biometricEnabled) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: _tryBiometric,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('استخدم البصمة'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
