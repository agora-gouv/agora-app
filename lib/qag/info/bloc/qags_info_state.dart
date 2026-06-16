import 'package:agora/common/helper/all_purpose_status.dart';
import 'package:equatable/equatable.dart';

class QagsInfoState extends Equatable {
  final AllPurposeStatus status;
  final String infoText;
  final String texteTotalQuestions;
  final String programmeDuMois;
  final String commentCaMarche;

  QagsInfoState({
    required this.status,
    required this.infoText,
    required this.texteTotalQuestions,
    required this.programmeDuMois,
    required this.commentCaMarche,
  });

  QagsInfoState.init()
      : status = AllPurposeStatus.loading,
        infoText = "",
        texteTotalQuestions = "",
        programmeDuMois = "",
        commentCaMarche = "";

  QagsInfoState clone({
    AllPurposeStatus? status,
    String? infoText,
    String? texteTotalQuestions,
    String? programmeDuMois,
    String? commentCaMarche,
  }) {
    return QagsInfoState(
      status: status ?? this.status,
      infoText: infoText ?? this.infoText,
      texteTotalQuestions: texteTotalQuestions ?? this.texteTotalQuestions,
      programmeDuMois: programmeDuMois ?? this.programmeDuMois,
      commentCaMarche: commentCaMarche ?? this.commentCaMarche,
    );
  }

  @override
  List<Object?> get props => [status, infoText, texteTotalQuestions, programmeDuMois, commentCaMarche];
}
