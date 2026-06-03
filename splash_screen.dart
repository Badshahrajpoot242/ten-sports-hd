// lib/screens/splash/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/settings_provider.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  int _countdown = AppConstants.splashDurationSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: AppConstants.splashDurationSeconds),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _startAnimations();
    _startCountdown();
  }

  void _startAnimations() async {
    await _logoController.forward();
    _textController.forward();
    _progressController.forward();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _countdown--);
        if (_countdown <= 0) {
          timer.cancel();
          _navigateHome();
        }
      }
    });
  }

  void _navigateHome() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.8,
                colors: [
                  Color(0xFF1A0A0A),
                  AppTheme.darkBg,
                ],
              ),
            ),
          ),

          // Red glow behind logo
          Center(
            child: AnimatedBuilder(
              animation: _logoController,
              builder: (_, __) => Container(
                width: 200 * _logoScale.value,
                height: 200 * _logoScale.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryRed
                          .withOpacity(0.3 * _logoFade.value),
                      blurRadius: 80,
                      spreadRadius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cricket logo / App icon
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, __) => Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppTheme.primaryRed, AppTheme.deepRed],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryRed.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            '🏏',
                            style: TextStyle(fontSize: 56),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // App Name
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              AppTheme.primaryRed,
                              AppTheme.accentGold,
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'TEN SPORTS',
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'AppFont',
                              color: Colors.white,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'HD',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'AppFont',
                              color: Colors.white,
                              letterSpacing: 6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'LIVE SPORTS STREAMING',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 4,
                            color: AppTheme.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Progress bar at bottom
          Positioned(
            bottom: 60,
            left: 40,
            right: 40,
            child: FadeTransition(
              opacity: _textFade,
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (_, __) => ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: _progressController.value,
                        backgroundColor: AppTheme.dividerColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryRed),
                        minHeight: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Loading...',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _timer?.cancel();
                          _navigateHome();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppTheme.primaryRed.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'SKIP $_countdown',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
