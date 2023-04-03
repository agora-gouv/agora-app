import 'package:agora/common/agora_http_client.dart';
import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

abstract class ThematiqueRepository {
  Future<ThematiqueRepositoryResponse> fetchThematiques();
}

class ThematiqueDioRepository extends ThematiqueRepository {
  final AgoraDioHttpClient httpClient;

  ThematiqueDioRepository({required this.httpClient});

  @override
  Future<ThematiqueRepositoryResponse> fetchThematiques() async {
    try {
      final response = await httpClient.get(
        "todo/thematique",
      );
      final thematiques = (response.data["thematiques"] as List)
          .map(
            (thematique) => Thematique(
              id: thematique["id"] as int,
              picto: thematique["picto"] as String,
              label: thematique["label"] as String,
              color: thematique["color"] as String,
            ),
          )
          .toList();
      return GetThematiqueSucceedResponse(thematiques: thematiques);
    } catch (e) {
      return GetThematiqueFailedResponse();
    }
  }
}

abstract class ThematiqueRepositoryResponse extends Equatable {
  @override
  List<Object> get props => [];
}

class GetThematiqueSucceedResponse extends ThematiqueRepositoryResponse {
  final List<Thematique> thematiques;

  GetThematiqueSucceedResponse({required this.thematiques});

  @override
  List<Object> get props => [thematiques];
}

class GetThematiqueFailedResponse extends ThematiqueRepositoryResponse {}
