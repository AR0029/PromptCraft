// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromptModelAdapter extends TypeAdapter<PromptModel> {
  @override
  final int typeId = 0;

  @override
  PromptModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PromptModel(
      id: fields[0] as String,
      title: fields[1] as String,
      category: fields[2] as String,
      aiTool: fields[3] as String,
      role: fields[4] as String,
      task: fields[5] as String,
      context: fields[6] as String,
      tone: fields[7] as String,
      constraints: fields[8] as String,
      outputFormat: fields[9] as String,
      example: fields[10] as String,
      lengthPreference: fields[11] as String,
      generatedPrompt: fields[12] as String,
      promptScore: fields[13] as double,
      suggestions: (fields[14] as List).cast<String>(),
      isFavorite: fields[15] as bool,
      createdAt: fields[16] as DateTime,
      updatedAt: fields[17] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PromptModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.aiTool)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.task)
      ..writeByte(6)
      ..write(obj.context)
      ..writeByte(7)
      ..write(obj.tone)
      ..writeByte(8)
      ..write(obj.constraints)
      ..writeByte(9)
      ..write(obj.outputFormat)
      ..writeByte(10)
      ..write(obj.example)
      ..writeByte(11)
      ..write(obj.lengthPreference)
      ..writeByte(12)
      ..write(obj.generatedPrompt)
      ..writeByte(13)
      ..write(obj.promptScore)
      ..writeByte(14)
      ..write(obj.suggestions)
      ..writeByte(15)
      ..write(obj.isFavorite)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromptModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
