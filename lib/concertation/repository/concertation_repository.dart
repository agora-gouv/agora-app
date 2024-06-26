import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/domain/consultation/consultation.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';

abstract class ConcertationRepository {
  Future<List<Concertation>> getConcertations();
}

class ConcertationDioRepository extends ConcertationRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper? sentryWrapper;

  ConcertationDioRepository({
    required this.httpClient,
    this.sentryWrapper,
  });

  @override
  Future<List<Concertation>> getConcertations() async {
    try {
      final response = await httpClient.get('/concertations');
      return (response.data as List).map(
        (concertation) {
          final thematiqueJson = concertation['thematique'] as Map<String, dynamic>;
          return Concertation(
            id: concertation['id'] as String,
            title: concertation['title'] as String,
            coverUrl: concertation['imageUrl'] as String,
            externalLink: concertation['externalLink'] as String,
            thematique: Thematique(
              label: thematiqueJson['label'] as String,
              picto: thematiqueJson['picto'] as String,
            ),
            label: concertation['updateLabel'] as String?,
            updateDate: (concertation['updateDate'] as String).parseToDateTime(),
          );
        },
      ).toList();
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
    }
    return [];
  }
}
