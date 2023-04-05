import 'package:agora/domain/consultation/questions/consultation_question_type.dart';

extension ColorExtension on String {
  int toColorInt() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse("0x$hexColor");
  }
}

extension StringExtension on String {
  String format(String to) {
    return replaceFirst("%s", to);
  }

  String format2(String to1, String to2) {
    return replaceFirst("%1s", to1).replaceFirst("%2s", to2);
  }
}

extension ConsultationQuestionTypeExtension on String {
  ConsultationQuestionType toConsultationQuestionType() {
    switch (this) {
      case "unique":
        return ConsultationQuestionType.unique;
      default:
        throw Exception("Question type doesn't exist: $this}");
    }
  }
}
