import 'package:hive/hive.dart';

part 'prompt_model.g.dart';

@HiveType(typeId: 0)
class PromptModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String aiTool;

  @HiveField(4)
  final String role;

  @HiveField(5)
  final String task;

  @HiveField(6)
  final String context;

  @HiveField(7)
  final String tone;

  @HiveField(8)
  final String constraints;

  @HiveField(9)
  final String outputFormat;

  @HiveField(10)
  final String example;

  @HiveField(11)
  final String lengthPreference;

  @HiveField(12)
  final String generatedPrompt;

  @HiveField(13)
  final double promptScore;

  @HiveField(14)
  final List<String> suggestions;

  @HiveField(15)
  bool isFavorite;

  @HiveField(16)
  final DateTime createdAt;

  @HiveField(17)
  final DateTime updatedAt;

  PromptModel({
    required this.id,
    required this.title,
    required this.category,
    required this.aiTool,
    required this.role,
    required this.task,
    required this.context,
    required this.tone,
    required this.constraints,
    required this.outputFormat,
    required this.example,
    required this.lengthPreference,
    required this.generatedPrompt,
    required this.promptScore,
    required this.suggestions,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
  });

  PromptModel copyWith({
    String? id,
    String? title,
    String? category,
    String? aiTool,
    String? role,
    String? task,
    String? context,
    String? tone,
    String? constraints,
    String? outputFormat,
    String? example,
    String? lengthPreference,
    String? generatedPrompt,
    double? promptScore,
    List<String>? suggestions,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PromptModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      aiTool: aiTool ?? this.aiTool,
      role: role ?? this.role,
      task: task ?? this.task,
      context: context ?? this.context,
      tone: tone ?? this.tone,
      constraints: constraints ?? this.constraints,
      outputFormat: outputFormat ?? this.outputFormat,
      example: example ?? this.example,
      lengthPreference: lengthPreference ?? this.lengthPreference,
      generatedPrompt: generatedPrompt ?? this.generatedPrompt,
      promptScore: promptScore ?? this.promptScore,
      suggestions: suggestions ?? this.suggestions,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
