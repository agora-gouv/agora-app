import 'package:agora/domain/thematique/thematique_with_id.dart';
import 'package:agora/infrastructure/thematique/thematique_repository.dart';

class FakeThematiqueSuccessRepository extends ThematiqueRepository {
  @override
  Future<ThematiqueRepositoryResponse> fetchThematiques() async {
    return GetThematiqueSucceedResponse(
      thematiques: [
        ThematiqueWithId(id: "1", picto: "\ud83d\udcbc", label: "Travail & emploi"),
        ThematiqueWithId(id: "2", picto: "\ud83c\udf31", label: "Transition écologique"),
        ThematiqueWithId(id: "3", picto: "\ud83e\ude7a", label: "Santé"),
        ThematiqueWithId(id: "4", picto: "\ud83d\udcc8", label: "Economie"),
        ThematiqueWithId(id: "5", picto: "\ud83c\udf93", label: "Education"),
        ThematiqueWithId(id: "6", picto: "\ud83c\udf0f", label: "International"),
        ThematiqueWithId(id: "7", picto: "\ud83d\ude8a", label: "Transports"),
        ThematiqueWithId(id: "8", picto: "\ud83d\ude94", label: "Sécurité"),
      ],
    );
  }
}

class FakeThematiqueFailureRepository extends ThematiqueRepository {
  @override
  Future<ThematiqueRepositoryResponse> fetchThematiques() async {
    return GetThematiqueFailedResponse();
  }
}
