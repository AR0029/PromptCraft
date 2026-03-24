import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_colors.dart';
import 'features/splash/splash_screen.dart';
import 'services/local_storage_service.dart';
import 'navigation/navigation_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Initialize the local storage service
  final localStorageService = LocalStorageService();
  await localStorageService.init();

  runApp(
    ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(localStorageService),
      ],
      child: const AIPromptBuilderApp(),
    ),
  );
}

class AIPromptBuilderApp extends ConsumerWidget {
  const AIPromptBuilderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'PromptCraft',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (context, child) {
        // Returning child directly removes the portrait box and allows full screen landscape on web
        return child!;
      },
      home: const SplashScreen(),
    );
  }
}
