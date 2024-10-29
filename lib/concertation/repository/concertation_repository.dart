import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:agora/consultation/domain/consultation.dart';
import 'package:agora/consultation/repository/consultation_mapper.dart';
import 'package:agora/thematique/domain/thematique.dart';

abstract class ConcertationRepository {
  Future<List<Concertation>> fetchConcertations();

  List<Concertation> get concertationsResponse;
}

class ConcertationDioRepository extends ConcertationRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;
  final ConsultationMapper mapper;

  ConcertationDioRepository({
    required this.httpClient,
    required this.sentryWrapper,
    required this.mapper,
  });

  @override
  List<Concertation> concertationsResponse = [];

  @override
  Future<List<Concertation>> fetchConcertations() async {
    const uri = '/concertations';
    try {
      final response = await httpClient.get(uri);
      final concertations = (response.data as List).map(
        (concertation) {
          final thematiqueJson = concertation['thematique'] as Map<String, dynamic>;
          return Concertation(
            id: concertation['id'] as String,
            slug: concertation['id'] as String,
            title: concertation['title'] as String,
            coverUrl: concertation['imageUrl'] as String,
            externalLink: concertation['externalLink'] as String,
            thematique: Thematique(
              label: thematiqueJson['label'] as String,
              picto: thematiqueJson['picto'] as String,
            ),
            label: concertation['updateLabel'] as String?,
            updateDate: (concertation['updateDate'] as String).parseToDateTime(),
            territoire: concertation["territory"] as String? ?? "",
          );
        },
      ).toList();
      concertationsResponse = concertations;
      return concertations;
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
    }
    concertationsResponse = [];
    return [];
  }
}
