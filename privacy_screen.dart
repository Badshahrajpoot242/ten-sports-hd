// lib/screens/privacy/privacy_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/settings_provider.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;

    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryRed.withOpacity(0.15),
                    AppTheme.cardBg,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.primaryRed.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.privacy_tip_rounded,
                        color: AppTheme.primaryRed, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'TEN SPORTS HD',
                          style: TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Content
            Text(
              settings.privacyPolicy.isNotEmpty
                  ? settings.privacyPolicy
                  : _defaultPrivacyPolicy,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Text(
                '© ${DateTime.now().year} TEN SPORTS HD\nAll rights reserved.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const String _defaultPrivacyPolicy = '''
Last Updated: 2024

TEN SPORTS HD ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our mobile application.

INFORMATION WE COLLECT
We may collect the following information:
• Device information (model, OS version)
• App usage analytics
• Firebase token for push notifications

HOW WE USE YOUR INFORMATION
We use the collected information to:
• Provide and improve our services
• Send match alerts and breaking news
• Analyze usage patterns to enhance user experience

THIRD-PARTY SERVICES
Our app uses third-party services including:
• Google Firebase (analytics and notifications)
• Google AdMob (advertisements)
• YouTube (video streaming)

DATA SECURITY
We implement appropriate technical and organizational measures to protect your personal information.

CHILDREN'S PRIVACY
Our service is not directed to children under 13. We do not knowingly collect personal information from children.

CHANGES TO THIS POLICY
We may update this Privacy Policy from time to time. We will notify you of changes by posting the new policy in the app.

CONTACT US
If you have questions about this Privacy Policy, contact us at:
sultanprince0258@gmail.com
''';
}
