import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/prompt_model.dart';

final promptScoringServiceProvider = Provider<PromptScoringService>((ref) {
  return PromptScoringService();
});

class PromptScoringResult {
  final double score; // 0.0 to 1.0
  final List<String> suggestions;

  PromptScoringResult(this.score, this.suggestions);
}

class PromptScoringService {
  /// Evaluates the completeness of the prompt inputs
  PromptScoringResult scorePrompt(PromptModel model) {
    double score = 0.0;
    List<String> suggestions = [];

    // Base scoring - Task is mandatory for any decent prompt
    if (model.task.isNotEmpty) {
      score += 0.3;
      if (model.task.split(' ').length < 5) {
        suggestions.add('Make your task more descriptive for better results.');
      }
    } else {
      suggestions.add('You are missing a core task. Define what you want the AI to do.');
    }

    // Role check
    if (model.role.isNotEmpty) {
      score += 0.15;
    } else {
      suggestions.add('Assigning a specific Role (e.g., "Senior Copywriter") improves AI persona.');
    }

    // Context check
    if (model.context.isNotEmpty) {
      score += 0.2;
    } else {
      suggestions.add('Add Context. Background information helps narrow down exactly what you mean.');
    }

    // Constraints check
    if (model.constraints.isNotEmpty) {
      score += 0.15;
    } else {
      suggestions.add('Adding Constraints (e.g., "Do not use jargon") reduces AI hallucinations.');
    }

    // Format & Tone check
    if (model.outputFormat.isNotEmpty) {
      score += 0.1;
    } else {
      suggestions.add('Specifying an Output Format (e.g., JSON, Bullet points) structures the response.');
    }
    
    if (model.tone.isNotEmpty) {
      score += 0.1;
    } else {
      suggestions.add('Providing a Tone ensures the AI matches your brand or style.');
    }

    // Example check (bonus points)
    if (model.example.isNotEmpty) {
      score += 0.1;
    } else if (score < 0.9) {
      suggestions.add('Few-shot prompting: Adding an Example drastically improves reliability.');
    }

    // Cap score at 1.0
    if (score > 1.0) score = 1.0;

    return PromptScoringResult(score, suggestions);
  }
}
