// lib/widgets/common/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';
import '../../screens/privacy/privacy_screen.dart';
import '../../screens/contact/contact_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;

    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              bottom: 24,
              left: 20,
              right: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.deepRed, Color(0xFF2A0A0A)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryRed, AppTheme.deepRed],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryRed.withOpacity(0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🏏', style: TextStyle(fontSize: 34)),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  settings.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'AppFont',
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'LIVE SPORTS STREAMING',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 10,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerItem(
                  icon: Icons.home_rounded,
                  title: 'Home',
                  onTap: () => Navigator.pop(context),
                ),
                _DrawerItem(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const PrivacyScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.mail_rounded,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ContactScreen()),
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.share_rounded,
                  title: 'Share App',
                  onTap: () {
                    Navigator.pop(context);
                    Share.share(
                      'Watch Live Cricket & Sports on TEN SPORTS HD!\n${AppConstants.playStoreUrl}',
                      subject: 'TEN SPORTS HD',
                    );
                  },
                ),
                _DrawerItem(
                  icon: Icons.star_rounded,
                  title: 'Rate App',
                  iconColor: AppTheme.accentGold,
                  onTap: () async {
                    Navigator.pop(context);
                    final review = InAppReview.instance;
                    if (await review.isAvailable()) {
                      await review.requestReview();
                    } else {
                      await review.openStoreListing(
                          appStoreId: AppConstants.playStoreUrl);
                    }
                  },
                ),
                const Divider(height: 24),
                _DrawerItem(
                  icon: Icons.exit_to_app_rounded,
                  title: 'Exit',
                  iconColor: AppTheme.primaryRed,
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppTheme.cardBg,
                        title: const Text('Exit App'),
                        content:
                            const Text('Are you sure you want to exit?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => SystemNavigator.pop(),
                            child: const Text(
                              'Exit',
                              style:
                                  TextStyle(color: AppTheme.primaryRed),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'v${AppConstants.appVersion} • TEN SPORTS HD',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppTheme.textSecondary,
        size: 22,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: AppTheme.primaryRed.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }
}
