import 'package:agora/common/client/agora_dio_exception.dart';
import 'package:agora/common/client/agora_http_client.dart';
import 'package:agora/common/helper/crashlytics_helper.dart';
import 'package:agora/domain/thematique/thematique_with_id.dart';
import 'package:equatable/equatable.dart';

abstract class ThematiqueRepository {
  Future<ThematiqueRepositoryResponse> fetchThematiques();
}

class ThematiqueDioRepository extends ThematiqueRepository {
  final AgoraDioHttpClient httpClient;
  final CrashlyticsHelper crashlyticsHelper;

  ThematiqueDioRepository({required this.httpClient, required this.crashlyticsHelper});

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
      crashlyticsHelper.recordError(e, s, AgoraDioExceptionType.fetchThematiques);
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
