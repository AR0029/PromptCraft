import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/prompt_model.dart';
import '../../services/local_storage_service.dart';
import '../generated_prompt/generated_prompt_screen.dart';
import '../../core/constants/app_colors.dart';

class PromptLibraryScreen extends ConsumerStatefulWidget {
  const PromptLibraryScreen({super.key});

  @override
  ConsumerState<PromptLibraryScreen> createState() => _PromptLibraryScreenState();
}

class _PromptLibraryScreenState extends ConsumerState<PromptLibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PromptModel> _allPrompts = [];
  List<PromptModel> _favoritePrompts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPrompts();
  }

  void _loadPrompts() {
    try {
      final storage = ref.read(localStorageServiceProvider);
      setState(() {
        _allPrompts = storage.getAllPrompts();
        _favoritePrompts = storage.getFavoritePrompts();
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _deletePrompt(String id) async {
    try {
      final storage = ref.read(localStorageServiceProvider);
      await storage.deletePrompt(id);
      _loadPrompts();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prompt deleted')));
    } catch (_) {}
  }

  void _toggleFavorite(String id) async {
    try {
      final storage = ref.read(localStorageServiceProvider);
      await storage.toggleFavorite(id);
      _loadPrompts();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryLight,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryLight,
          indicatorWeight: 4,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          tabs: const [
            Tab(text: 'All Saved'),
            Tab(text: 'Favorites'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPromptsList(_allPrompts, 'No saved prompts yet.'),
          _buildPromptsList(_favoritePrompts, 'No favorite prompts yet.'),
        ],
      ),
    );
  }

  Widget _buildPromptsList(List<PromptModel> prompts, String emptyMsg) {
    if (prompts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_awesome_motion, size: 80, color: Colors.grey.withOpacity(0.3)),
            const SizedBox(height: 24),
            Text(emptyMsg, style: TextStyle(color: Colors.grey.shade600, fontSize: 18, fontWeight: FontWeight.w500)),
          ],
        ),
      ).animate().fade().scale();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      itemCount: prompts.length,
      itemBuilder: (context, index) {
        final prompt = prompts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => GeneratedPromptScreen(prompt: prompt),
                ),
              ).then((_) => _loadPrompts());
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 48), // Space for favorite icon
                        child: Text(
                          prompt.title, 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: -0.3),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        prompt.generatedPrompt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(prompt.category, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(prompt.aiTool, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: -12,
                    right: -12,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            prompt.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: prompt.isFavorite ? Colors.redAccent : Colors.grey,
                            size: 24,
                          ),
                          onPressed: () => _toggleFavorite(prompt.id),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.grey),
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deletePrompt(prompt.id);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fade(delay: (index * 50).ms).slideY(begin: 0.1);
      },
    );
  }
}
