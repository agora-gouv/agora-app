import 'package:agora/bloc/consultation/details/consultation_details_view_model.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:intl/intl.dart';

class ConsultationDetailsPresenter {
  static ConsultationDetailsViewModel present(ConsultationDetails consultationDetails) {
    return ConsultationDetailsViewModel(
      id: consultationDetails.id,
      title: consultationDetails.title,
      cover: consultationDetails.cover,
      thematiqueId: consultationDetails.thematiqueId,
      endDate: ConsultationStrings.endDate.format(
        DateFormat("dd MMMM").format(consultationDetails.endDate),
      ),
      questionCount: consultationDetails.questionCount,
      estimatedTime: consultationDetails.estimatedTime,
      participantCount: consultationDetails.participantCount,
      participantCountGoal: consultationDetails.participantCountGoal,
      participantCountText: ConsultationStrings.participantCount.format(
        consultationDetails.participantCount.toString(),
      ),
      participantCountGoalText: ConsultationStrings.participantCountGoal.format(
        consultationDetails.participantCountGoal.toString(),
      ),
      description: consultationDetails.description,
      tipsDescription: consultationDetails.tipsDescription,
    );
  }
}
