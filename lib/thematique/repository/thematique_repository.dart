import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/thematique/domain/thematique_with_id.dart';
import 'package:agora/common/log/sentry_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class ThematiqueRepository {
  Future<ThematiqueRepositoryResponse> fetchThematiques();
}

class ThematiqueDioRepository extends ThematiqueRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper sentryWrapper;

  ThematiqueDioRepository({required this.httpClient, required this.sentryWrapper});

  @override
  Future<ThematiqueRepositoryResponse> fetchThematiques() async {
    const uri = "/thematiques";
    try {
      final response = await httpClient.get(uri);
      final thematiques = (response.data["thematiques"] as List)
          .map(
            (thematique) => ThematiqueWithId(
              id: thematique["id"] as String,
              picto: thematique["picto"] as String,
              label: thematique["label"] as String,
            ),
          )
          .toList();
      return GetThematiqueSucceedResponse(thematiques: thematiques);
    } catch (exception, stacktrace) {
      sentryWrapper.captureException(exception, stacktrace, message: "Erreur lors de l'appel : $uri");
      return GetThematiqueFailedResponse();
    }
  }
}

abstract class ThematiqueRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetThematiqueSucceedResponse extends ThematiqueRepositoryResponse {
  final List<ThematiqueWithId> thematiques;

  GetThematiqueSucceedResponse({required this.thematiques});

  @override
  List<Object> get props => [thematiques];
}

class GetThematiqueFailedResponse extends ThematiqueRepositoryResponse {}
