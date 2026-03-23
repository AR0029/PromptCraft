import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_colors.dart';
import '../../navigation/navigation_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('PromptCraft'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.cardGradientDark : AppColors.surfaceGradientLight,
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              _buildWelcomeCard(context, ref).animate().fade(duration: 500.ms).slideY(begin: 0.2, curve: Curves.easeOutCubic),
              const SizedBox(height: 32),
              
              _buildSectionTitle('Prompt Categories').animate().fade(delay: 200.ms).slideX(begin: -0.1),
              const SizedBox(height: 16),
              _buildCategoriesGrid(ref).animate().fade(delay: 300.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
              
              const SizedBox(height: 32),
              
              _buildSectionTitle('Recent Prompts').animate().fade(delay: 400.ms).slideX(begin: -0.1),
              _buildEmptyState('No recent prompts yet.', CupertinoIcons.time).animate().fade(delay: 500.ms),
              
              const SizedBox(height: 48),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Made with passion by Aryan Chaudhary',
                      style: TextStyle(
                        color: isDark ? Colors.white30 : Colors.black38,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.primaryLight.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
                  ],
                ),
              ).animate().fade(delay: 800.ms).slideY(begin: 0.2),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.sparkles, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ready to create magic?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Craft the perfect prompt to get exceptional responses from any AI model.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(bottomNavIndexProvider.notifier).state = 1;
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryLight,
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            icon: const Icon(CupertinoIcons.add_circled_solid),
            label: const Text('New Prompt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
    );
  }

  Widget _buildCategoriesGrid(WidgetRef ref) {
    final categories = [
      {'title': 'Writing', 'icon': CupertinoIcons.pencil, 'color': Colors.orangeAccent},
      {'title': 'Coding', 'icon': CupertinoIcons.chevron_left_slash_chevron_right, 'color': Colors.blueAccent},
      {'title': 'Study', 'icon': CupertinoIcons.book, 'color': Colors.greenAccent},
      {'title': 'Resume', 'icon': CupertinoIcons.briefcase, 'color': Colors.purpleAccent},
      {'title': 'Research', 'icon': CupertinoIcons.search, 'color': Colors.tealAccent},
      {'title': 'Images', 'icon': CupertinoIcons.photo, 'color': Colors.pinkAccent},
      {'title': 'Business', 'icon': CupertinoIcons.chart_bar, 'color': Colors.indigoAccent},
      {'title': 'Social', 'icon': CupertinoIcons.heart, 'color': Colors.redAccent},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final title = cat['title'] as String;
        final icon = cat['icon'] as IconData;
        final color = cat['color'] as Color;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = title;
              ref.read(bottomNavIndexProvider.notifier).state = 1;
            },
            borderRadius: BorderRadius.circular(16),
            child: Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title, 
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1), style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(message, style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
