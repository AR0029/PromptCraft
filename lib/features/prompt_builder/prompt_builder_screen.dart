import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/prompt_model.dart';
import '../../services/prompt_generator_service.dart';
import '../../services/prompt_scoring_service.dart';
import '../generated_prompt/generated_prompt_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../navigation/navigation_providers.dart';

class PromptBuilderScreen extends ConsumerStatefulWidget {
  const PromptBuilderScreen({super.key});

  @override
  ConsumerState<PromptBuilderScreen> createState() => _PromptBuilderScreenState();
}

class _PromptBuilderScreenState extends ConsumerState<PromptBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _taskController = TextEditingController();
  final _roleController = TextEditingController();
  final _contextController = TextEditingController();
  final _constraintsController = TextEditingController();
  final _exampleController = TextEditingController();

  // Selections
  String _selectedAiTool = 'Generic AI';
  String _selectedTone = '';
  String _selectedFormat = '';
  String _selectedLength = 'Balanced';

  @override
  void dispose() {
    _taskController.dispose();
    _roleController.dispose();
    _contextController.dispose();
    _constraintsController.dispose();
    _exampleController.dispose();
    super.dispose();
  }

  void _generatePrompt() async {
    if (!_formKey.currentState!.validate()) return;
    
    final category = ref.read(selectedCategoryProvider);

    final prompt = PromptModel(
      id: const Uuid().v4(),
      title: 'Prompt for ${_taskController.text.split(' ').take(3).join(' ')}...',
      category: category,
      aiTool: _selectedAiTool,
      role: _roleController.text.trim(),
      task: _taskController.text.trim(),
      context: _contextController.text.trim(),
      tone: _selectedTone,
      constraints: _constraintsController.text.trim(),
      outputFormat: _selectedFormat,
      example: _exampleController.text.trim(),
      lengthPreference: _selectedLength,
      generatedPrompt: '',
      promptScore: 0.0,
      suggestions: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final generator = ref.read(promptGeneratorServiceProvider);
    final scorer = ref.read(promptScoringServiceProvider);
    
    final generatedText = generator.generatePrompt(prompt);
    final scoreResult = scorer.scorePrompt(prompt);

    final finalPrompt = prompt.copyWith(
      generatedPrompt: generatedText,
      promptScore: scoreResult.score,
      suggestions: scoreResult.suggestions,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GeneratedPromptScreen(prompt: finalPrompt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Prompt'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryLight.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.category, color: AppColors.primaryLight),
                  const SizedBox(width: 12),
                  Text('Active Category: ', style: TextStyle(color: Colors.grey.shade700)),
                  Text(activeCategory, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
                ],
              ),
            ).animate().fade().slideY(begin: -0.1),
            const SizedBox(height: 24),

            _buildFormCard(
              title: '1. Core Request',
              delay: 100,
              children: [
                TextFormField(
                  controller: _taskController,
                  decoration: const InputDecoration(labelText: 'Task *', hintText: 'e.g., Write a blog post about AI'),
                  validator: (v) => v!.isEmpty ? 'Task is required' : null,
                  maxLines: 2,
                ),
              ],
            ),
            
            _buildFormCard(
              title: '2. Context & Persona',
              delay: 200,
              children: [
                TextFormField(
                  controller: _roleController,
                  decoration: const InputDecoration(labelText: 'Role (Optional)', hintText: 'e.g., Senior Software Engineer'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contextController,
                  decoration: const InputDecoration(labelText: 'Context (Recommended)', hintText: 'Provide background information...'),
                  maxLines: 3,
                ),
              ],
            ),

            _buildFormCard(
              title: '3. Formatting & Options',
              delay: 300,
              children: [
                _buildChips('AI Platform', ['Generic AI', 'ChatGPT', 'Claude', 'Gemini'], _selectedAiTool, (v) => setState(() => _selectedAiTool = v)),
                _buildChips('Tone', ['Professional', 'Friendly', 'Formal', 'Creative', 'Concise'], _selectedTone, (v) => setState(() => _selectedTone = v == _selectedTone ? '' : v)),
                _buildChips('Format', ['Paragraph', 'Bullet points', 'JSON', 'Table', 'Step-by-step'], _selectedFormat, (v) => setState(() => _selectedFormat = v == _selectedFormat ? '' : v)),
              ],
            ),
            
            _buildFormCard(
              title: '4. Advanced Guidelines',
              delay: 400,
              children: [
                TextFormField(
                  controller: _constraintsController,
                  decoration: const InputDecoration(labelText: 'Constraints', hintText: 'e.g., Limit to 200 words'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _exampleController,
                  decoration: const InputDecoration(labelText: 'Reference Example', hintText: 'Paste an example of desired output...'),
                  maxLines: 3,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: AppColors.primaryGradient,
                boxShadow: [
                  BoxShadow(color: AppColors.primaryLight.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
                ],
              ),
              child: ElevatedButton(
                onPressed: _generatePrompt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Generate Optimized Prompt', style: TextStyle(fontSize: 18, color: Colors.white)),
                  ],
                ),
              ),
            ).animate().fade(delay: 500.ms).slideY(begin: 0.2),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard({required String title, required List<Widget> children, required int delay}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    ).animate().fade(delay: delay.ms).slideY(begin: 0.1);
  }

  Widget _buildChips(String label, List<String> options, String currentValue, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = opt == currentValue;
            return ChoiceChip(
              label: Text(opt),
              selected: isSelected,
              onSelected: (_) => onSelect(opt),
              selectedColor: AppColors.primaryLight,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: isSelected ? AppColors.primaryLight : Colors.grey.withOpacity(0.3)),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
