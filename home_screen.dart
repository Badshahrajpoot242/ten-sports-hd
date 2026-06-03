// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/category_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/sport_category_card.dart';
import '../categories/sub_category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadCategories();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: Builder(
              builder: (ctx) => IconButton(
                onPressed: () => Scaffold.of(ctx).openDrawer(),
                icon: const Icon(Icons.menu_rounded, color: Colors.white),
              ),
            ),
            actions: [
              Consumer<AppProvider>(
                builder: (_, provider, __) => Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_outlined,
                          color: Colors.white),
                    ),
                    if (provider.notificationCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${provider.notificationCount}',
                            style: const TextStyle(
                                fontSize: 9, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildAppBarBackground(),
            ),
          ),

          // Banner Ad Placeholder
          const SliverToBoxAdapter(child: BannerAdPlaceholder()),

          // Content
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                );
              }

              if (provider.error != null) {
                return SliverFillRemaining(
                  child: _buildErrorState(provider),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: _buildCategoryGrid(provider.categories),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppBarBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A0A0A), AppColors.primary],
        ),
      ),
      child: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -20,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentGold.withOpacity(0.05),
              ),
            ),
          ),

          // Title
          Positioned(
            left: 60,
            right: 60,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    const Text(
                      'TEN SPORTS HD',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Live Sports • Anytime • Anywhere',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(List<CategoryModel> categories) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final category = categories[index];
          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              final delay = (index * 0.08).clamp(0.0, 0.7);
              final itemAnimation = CurvedAnimation(
                parent: _animationController,
                curve: Interval(delay, (delay + 0.4).clamp(0.0, 1.0),
                    curve: Curves.easeOut),
              );
              return FadeTransition(
                opacity: itemAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(itemAnimation),
                  child: child,
                ),
              );
            },
            child: SportCategoryCard(
              category: category,
              onTap: () => _navigateToCategory(category),
            ),
          );
        },
        childCount: categories.length,
      ),
    );
  }

  Widget _buildErrorState(AppProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😕', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            provider.error!,
            style: const TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: provider.refresh,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToCategory(CategoryModel category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SubCategoryScreen(
          title: category.title,
          subCategories: category.subCategories,
          isTopLevel: true,
        ),
      ),
    );
  }
}
