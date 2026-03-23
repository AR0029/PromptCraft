import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../navigation/navigation_providers.dart';
import '../../services/local_storage_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _confirmClearHistory(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Prompts?'),
        content: const Text('This will permanently delete all your saved prompts and favorites. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              try {
                final storage = ref.read(localStorageServiceProvider);
                storage.clearAllPrompts();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All prompts deleted.')));
              } catch (_) {}
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildSettingsGroup(
            title: 'Appearance',
            children: [
              _buildThemeOption(
                context: context,
                ref: ref,
                title: 'System Settings',
                value: ThemeMode.system,
                groupValue: currentTheme,
                icon: Icons.brightness_auto,
              ),
              const Divider(height: 1, indent: 56),
              _buildThemeOption(
                context: context,
                ref: ref,
                title: 'Light Mode',
                value: ThemeMode.light,
                groupValue: currentTheme,
                icon: Icons.light_mode,
              ),
              const Divider(height: 1, indent: 56),
              _buildThemeOption(
                context: context,
                ref: ref,
                title: 'Dark Mode',
                value: ThemeMode.dark,
                groupValue: currentTheme,
                icon: Icons.dark_mode,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSettingsGroup(
            title: 'Data & Privacy',
            children: [
              ListTile(
                leading: const Icon(Icons.delete_sweep, color: AppColors.error),
                title: const Text('Clear Output History', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                subtitle: const Text('Delete all saved prompts permanently'),
                onTap: () => _confirmClearHistory(context, ref),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSettingsGroup(
            title: 'About',
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline, color: AppColors.primaryLight),
                title: Text('PromptCraft Version'),
                trailing: Text('1.0.0 Pro', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ),
              const Divider(height: 1, indent: 56),
              ListTile(
                leading: const Icon(Icons.star_border, color: Colors.amber),
                title: const Text('Rate on App Store'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming Soon!')));
                },
              ),
            ],
          ),
          
          const SizedBox(height: 48),
          Center(
            child: Text(
              'PromptCraft Engine v2.0',
              style: TextStyle(color: Colors.grey.withOpacity(0.5), fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey, letterSpacing: 1.2),
          ),
        ),
        Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required ThemeMode value,
    required ThemeMode groupValue,
    required IconData icon,
  }) {
    return RadioListTile<ThemeMode>(
      title: Row(
        children: [
          Icon(icon, size: 20, color: groupValue == value ? AppColors.primaryLight : Colors.grey),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(fontWeight: groupValue == value ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
      value: value,
      groupValue: groupValue,
      onChanged: (ThemeMode? newValue) {
        if (newValue != null) {
          ref.read(themeModeProvider.notifier).state = newValue;
        }
      },
      activeColor: AppColors.primaryLight,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
