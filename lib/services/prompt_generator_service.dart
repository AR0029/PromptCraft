import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/prompt_model.dart';

final promptGeneratorServiceProvider = Provider<PromptGeneratorService>((ref) {
  return PromptGeneratorService();
});

class PromptGeneratorService {
  /// Generates a highly structured "Mega-Prompt" based on user inputs and category.
  String generatePrompt(PromptModel model) {
    StringBuffer buffer = StringBuffer();

    // System Instructions / Meta Setup
    if (model.aiTool.isNotEmpty && model.aiTool.toLowerCase() != 'generic ai') {
      buffer.writeln('You are interacting with a specialized prompt designed for ${model.aiTool}. Please follow all instructions strictly.\n');
    }

    // 1. IDENTITY & PERSONA
    buffer.writeln('# IDENTITY AND PURPOSE');
    if (model.role.isNotEmpty) {
      buffer.writeln('You are an expert, highly capable ${model.role}.');
    } else {
      buffer.writeln('You are a highly capable AI assistant.');
    }
    
    // Inject category specific expertise
    buffer.writeln(_getCategoryExpertise(model.category));
    
    if (model.task.isNotEmpty) {
      buffer.writeln('\nYour primary objective is to: ${model.task}.');
    }

    // 2. CONTEXT
    if (model.context.isNotEmpty) {
      buffer.writeln('\n# CONTEXT');
      buffer.writeln('You must operate safely within the following context:');
      buffer.writeln(model.context);
    }

    // 3. GUIDELINES & CONSTRAINTS
    buffer.writeln('\n# GUIDELINES AND CONSTRAINTS');
    buffer.writeln('- Execute the task logically and systematically.');
    if (model.lengthPreference.isNotEmpty) {
      buffer.writeln('- Length requirement: Provide a ${model.lengthPreference.toLowerCase()} response.');
    }
    if (model.tone.isNotEmpty) {
      buffer.writeln('- Tone/Voice: Maintain a ${model.tone.toLowerCase()} tone throughout.');
    }
    if (model.constraints.isNotEmpty) {
      buffer.writeln('- Critical constraint: ${model.constraints}');
    }
    buffer.writeln(_getCategoryConstraints(model.category));

    // 4. OUTPUT FORMAT
    if (model.outputFormat.isNotEmpty) {
      buffer.writeln('\n# OUTPUT FORMAT');
      buffer.writeln('You must format your final response strictly as: ${model.outputFormat}.');
      if (model.outputFormat.toLowerCase() == 'json') {
        buffer.writeln('Ensure the JSON is valid and contains no trailing commas.');
      }
    }

    // 5. EXAMPLES (Few-shot prompting)
    if (model.example.isNotEmpty) {
      buffer.writeln('\n# REFERENCE EXAMPLES');
      buffer.writeln('Analyze this example to understand the expected quality and structure:');
      buffer.writeln('"""\n${model.example}\n"""');
    }

    // 6. FINAL INSTRUCTIONS
    buffer.writeln('\n# EXECUTION');
    buffer.writeln('Acknowledge these instructions implicitly. Begin your response immediately by executing the objective.');

    return buffer.toString().trim();
  }

  String _getCategoryExpertise(String category) {
    switch (category.toLowerCase()) {
      case 'coding':
        return 'You have deep technical knowledge, prioritize optimized, clean, and well-documented code, and understand software architecture.';
      case 'writing':
        return 'You have exceptional copywriting skills, a deep understanding of psychological triggers, and impeccable grammar.';
      case 'study':
        return 'You are a master educator who uses analogies (like the Feynman technique) to simplify complex topics efficiently.';
      case 'resume':
        return 'You are an elite technical recruiter and career coach who knows what applicant tracking systems (ATS) and hiring managers look for.';
      case 'business':
        return 'You are a seasoned growth strategist, executive consultant, and analyst focused on ROI, market trends, and actionable insights.';
      case 'social':
        return 'You are a viral content strategist who excels at creating high-engagement hooks, persuasive calls-to-action, and platform-native content.';
      default:
        return 'You are committed to accuracy, clarity, and providing the highest quality output possible.';
    }
  }

  String _getCategoryConstraints(String category) {
    switch (category.toLowerCase()) {
      case 'coding':
        return '- Do not provide outdated syntax. Use the latest language standards.\n- Include brief comments explaining complex logic.';
      case 'writing':
        return '- Avoid robotic cliches (e.g., "In today\'s fast-paced world...").\n- Keep paragraphs brief and highly readable.';
      case 'research':
        return '- Maintain objective neutrality.\n- Cite hypothetical or real sources if making empirical claims.';
      case 'images':
        return '- Focus strictly on visual descriptors (lighting, camera angle, medium, style, atmosphere).';
      default:
        return '- Do not break character. Do not apologize unnecessarily.';
    }
  }
}

