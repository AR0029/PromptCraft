import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/home/home_screen.dart';
import '../features/prompt_builder/prompt_builder_screen.dart';
import '../features/prompt_library/prompt_library_screen.dart';
import '../features/settings/settings_screen.dart';
import '../core/constants/app_colors.dart';
import 'navigation_providers.dart';

class MainScaffold extends ConsumerWidget {
  const MainScaffold({super.key});

  final List<Widget> _screens = const [
    HomeScreen(),
    PromptBuilderScreen(),
    PromptLibraryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _screens[currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(bottomNavIndexProvider.notifier).state = index;
        },
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        destinations: const [
          NavigationDestination(
            icon: Icon(CupertinoIcons.home),
            selectedIcon: Icon(CupertinoIcons.house_fill, color: AppColors.primaryLight),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.add_circled),
            selectedIcon: Icon(CupertinoIcons.add_circled_solid, color: AppColors.primaryLight),
            label: 'Builder',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.bookmark),
            selectedIcon: Icon(CupertinoIcons.bookmark_solid, color: AppColors.primaryLight),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.settings),
            selectedIcon: Icon(CupertinoIcons.settings_solid, color: AppColors.primaryLight),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

