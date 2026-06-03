// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/home_provider.dart';
import '../../providers/settings_provider.dart';
import '../../data/models/button_model.dart';
import '../../widgets/common/app_drawer.dart';
import '../channel/channel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadButtons();
      context.read<SettingsProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        if (settingsProvider.settings.maintenanceMode) {
          return _MaintenanceScreen();
        }
        return _HomeContent();
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppTheme.primaryRed, AppTheme.accentGold],
          ).createShader(bounds),
          child: const Text(
            'TEN SPORTS HD',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'AppFont',
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return _LoadingGrid();
          if (provider.error != null) return _ErrorWidget(
            message: provider.error!,
            onRetry: provider.retry,
          );
          if (provider.buttons.isEmpty) return _EmptyWidget();
          return _ButtonGrid(buttons: provider.buttons);
        },
      ),
    );
  }
}

class _ButtonGrid extends StatelessWidget {
  final List<ButtonModel> buttons;
  const _ButtonGrid({required this.buttons});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        final settings = settingsProvider.settings;
        return RefreshIndicator(
          color: AppTheme.primaryRed,
          backgroundColor: AppTheme.cardBg,
          onRefresh: () async {
            context.read<HomeProvider>().retry();
            await Future.delayed(const Duration(milliseconds: 800));
          },
          child: CustomScrollView(
            slivers: [
              // Banner
              if (settings.bannerImage.isNotEmpty)
                SliverToBoxAdapter(
                  child: _BannerWidget(imageUrl: settings.bannerImage),
                ),

              // Live Indicator
              const SliverToBoxAdapter(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      _LiveBadge(),
                      SizedBox(width: 10),
                      Text(
                        'ALL CHANNELS',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Grid
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _ButtonCard(
                      button: buttons[index],
                      index: index,
                    ),
                    childCount: buttons.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ButtonCard extends StatelessWidget {
  final ButtonModel button;
  final int index;

  const _ButtonCard({required this.button, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChannelScreen(button: button),
        ),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200 + index * 50),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.dividerColor,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background glow
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryRed.withOpacity(0.05),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  _ChannelLogo(logoUrl: button.logo),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    button.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily: 'AppFont',
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Description
                  Text(
                    button.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            const Positioned(
              bottom: 12,
              right: 12,
              child: Icon(
                Icons.play_circle_fill_rounded,
                color: AppTheme.primaryRed,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChannelLogo extends StatelessWidget {
  final String logoUrl;
  const _ChannelLogo({required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppTheme.surfaceBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: logoUrl.isEmpty
            ? const Center(
                child: Text('🏏', style: TextStyle(fontSize: 26)))
            : CachedNetworkImage(
                imageUrl: logoUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => const Center(
                  child: Text('🏏', style: TextStyle(fontSize: 26)),
                ),
              ),
      ),
    );
  }
}

class _BannerWidget extends StatelessWidget {
  final String imageUrl;
  const _BannerWidget({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            height: 160,
            color: AppTheme.cardBg,
            child: const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryRed),
            ),
          ),
          errorWidget: (_, __, ___) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _LiveBadge extends StatefulWidget {
  const _LiveBadge();

  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppTheme.liveBadge.withOpacity(0.9 + 0.1 * _anim.value),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 10,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.cardBg,
      highlightColor: AppTheme.surfaceBg,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 8,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.signal_wifi_off_rounded,
                color: AppTheme.textMuted, size: 64),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📺', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text(
            'No Channels Available',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Check back later',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _MaintenanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔧', style: TextStyle(fontSize: 72)),
              const SizedBox(height: 24),
              const Text(
                'UNDER MAINTENANCE',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'AppFont',
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'We\'re working on improvements.\nPlease check back soon.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.textSecondary, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
