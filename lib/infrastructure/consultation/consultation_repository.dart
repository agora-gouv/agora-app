import 'package:agora/common/agora_http_client.dart';
import 'package:agora/domain/consultation/details/consultation_details.dart';
import 'package:equatable/equatable.dart';

abstract class ConsultationRepository {
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails(String consultationId);
}

class ConsultationDioRepository extends ConsultationRepository {
  final AgoraDioHttpClient httpClient;

  ConsultationDioRepository({required this.httpClient});

  @override
  Future<GetConsultationDetailsRepositoryResponse> fetchConsultationDetails(String consultationId) async {
    try {
      final response = await httpClient.get("/consultations/$consultationId");
      return GetConsultationDetailsSucceedResponse(
        consultationDetails: ConsultationDetails(
          id: response.data["id"] as int,
          title: response.data["title"] as String,
          cover: response.data["cover"] as String,
          thematiqueId: response.data["thematique_id"] as int,
          endDate: DateTime.parse(response.data["end_date"] as String),
          questionCount: response.data["question_count"] as String,
          estimatedTime: response.data["estimated_time"] as String,
          participantCount: response.data["participant_count"] as int,
          participantCountGoal: response.data["participant_count_goal"] as int,
          description: response.data["description"] as String,
          tipsDescription: response.data["tips_description"] as String,
        ),
      );
    } catch (e) {
      return GetConsultationDetailsFailedResponse();
    }
  }
}

abstract class GetConsultationDetailsRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetConsultationDetailsSucceedResponse extends GetConsultationDetailsRepositoryResponse {
  final ConsultationDetails consultationDetails;

  GetConsultationDetailsSucceedResponse({required this.consultationDetails});
}

class GetConsultationDetailsFailedResponse extends GetConsultationDetailsRepositoryResponse {}
