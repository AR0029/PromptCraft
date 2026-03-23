import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../data/models/prompt_model.dart';
import '../../services/local_storage_service.dart';
import '../../core/constants/app_colors.dart';

class GeneratedPromptScreen extends ConsumerStatefulWidget {
  final PromptModel prompt;

  const GeneratedPromptScreen({super.key, required this.prompt});

  @override
  ConsumerState<GeneratedPromptScreen> createState() => _GeneratedPromptScreenState();
}

class _GeneratedPromptScreenState extends ConsumerState<GeneratedPromptScreen> {
  late PromptModel _currentPrompt;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _currentPrompt = widget.prompt;
    _checkSavedState();
  }

  void _checkSavedState() {
    try {
      final storage = ref.read(localStorageServiceProvider);
      final existing = storage.getPromptById(_currentPrompt.id);
      if (existing != null) {
        setState(() => _isSaved = true);
      }
    } catch (_) {}
  }

  void _savePrompt() async {
    try {
      final storage = ref.read(localStorageServiceProvider);
      await storage.savePrompt(_currentPrompt);
      setState(() => _isSaved = true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✨ Prompt saved to library!')));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save prompt.')));
    }
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _currentPrompt.generatedPrompt));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('📋 Copied to clipboard! Ready to paste into AI.')));
  }

  void _sharePrompt() {
    Share.share(_currentPrompt.generatedPrompt, subject: 'Check out this mega-prompt I generated!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mega Prompt Ready'),
          actions: [
            IconButton(
              icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border, 
                         color: _isSaved ? AppColors.primaryLight : null),
              onPressed: _isSaved ? null : _savePrompt,
            ).animate().scale(),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    _buildPromptCard().animate().fade(duration: 400.ms).slideY(begin: 0.1),
                    const SizedBox(height: 32),
                    _buildScoreCard().animate().fade(delay: 200.ms).slideY(begin: 0.1),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildBottomActions().animate().fade(delay: 400.ms).slideY(begin: 0.2),
          ],
        ));
  }

  Widget _buildPromptCard() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryLight.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primaryLight, size: 20),
                const SizedBox(width: 12),
                const Text('Optimized for AI', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.copy, color: AppColors.primaryLight),
                  onPressed: _copyToClipboard,
                  tooltip: 'Copy all',
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SelectableText(
              _currentPrompt.generatedPrompt,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard() {
    final scorePercent = (_currentPrompt.promptScore * 100).toInt();
    Color scoreColor = AppColors.scoreLow;
    if (scorePercent >= 80) scoreColor = AppColors.scoreHigh;
    else if (scorePercent >= 50) scoreColor = AppColors.scoreMedium;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Prompt Quality Index', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('$scorePercent/100', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: scoreColor)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _currentPrompt.promptScore,
                backgroundColor: scoreColor.withOpacity(0.15),
                color: scoreColor,
                minHeight: 12,
              ),
            ),
            if (_currentPrompt.suggestions.isNotEmpty) ...[
              const SizedBox(height: 24),
              const Row(
                children: [
                  Icon(Icons.tips_and_updates, color: Colors.amber, size: 22),
                  SizedBox(width: 10),
                  Text('AI Tips & Tricks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              ..._currentPrompt.suggestions.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•', style: TextStyle(color: AppColors.primaryLight, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Expanded(child: Text(s, style: TextStyle(fontSize: 15, height: 1.5, color: Colors.grey.shade700))),
                  ],
                ),
              )).toList(),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  side: BorderSide(color: AppColors.primaryLight.withOpacity(0.5), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(color: AppColors.primaryLight.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _copyToClipboard,
                  icon: const Icon(Icons.copy, color: Colors.white),
                  label: const Text('Copy to Clipboard', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
