// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_question_response_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConsultationQuestionResponsesHiveAdapter extends TypeAdapter<ConsultationQuestionResponsesHive> {
  @override
  final int typeId = 1;

  @override
  ConsultationQuestionResponsesHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConsultationQuestionResponsesHive(
      questionId: fields[0] as String,
      responseIds: (fields[1] as List).cast<String>(),
      responseText: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ConsultationQuestionResponsesHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.questionId)
      ..writeByte(1)
      ..write(obj.responseIds)
      ..writeByte(2)
      ..write(obj.responseText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsultationQuestionResponsesHiveAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
