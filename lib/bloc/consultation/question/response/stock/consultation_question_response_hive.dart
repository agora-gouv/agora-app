import 'package:hive/hive.dart';

part 'consultation_question_response_hive.g.dart';

@HiveType(typeId: 1)
class ConsultationQuestionResponsesHive extends HiveObject {
  @HiveField(0)
  String questionId;

  @HiveField(1)
  List<String> responseIds;

  @HiveField(2)
  String responseText;

  ConsultationQuestionResponsesHive({
    required this.questionId,
    required this.responseIds,
    required this.responseText,
  });
}
