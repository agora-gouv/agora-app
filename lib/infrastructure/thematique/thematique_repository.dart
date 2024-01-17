import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/domain/thematique/thematique_with_id.dart';
import 'package:agora/infrastructure/errors/sentry_wrapper.dart';
import 'package:equatable/equatable.dart';

abstract class ThematiqueRepository {
  Future<ThematiqueRepositoryResponse> fetchThematiques();
}

class ThematiqueDioRepository extends ThematiqueRepository {
  final AgoraDioHttpClient httpClient;
  final SentryWrapper? sentryWrapper;

  ThematiqueDioRepository({required this.httpClient, this.sentryWrapper});

  @override
  Future<ThematiqueRepositoryResponse> fetchThematiques() async {
    try {
      final response = await httpClient.get("/thematiques");
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
    } catch (e, s) {
      sentryWrapper?.captureException(e, s);
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
