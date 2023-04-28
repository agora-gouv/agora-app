import 'package:agora/domain/thematique/thematique_with_id.dart';
import 'package:agora/infrastructure/thematique/thematique_repository.dart';

class FakeThematiqueSuccessRepository extends ThematiqueRepository {
  @override
  Future<ThematiqueRepositoryResponse> fetchThematiques() async {
    return GetThematiqueSucceedResponse(
      thematiques: [
        ThematiqueWithId(id: "1", picto: "\ud83d\udcbc", label: "Travail & emploi", color: "#FFCFDEFC"),
        ThematiqueWithId(id: "2", picto: "\ud83c\udf31", label: "Transition écologique", color: "#FFCFFCD9"),
        ThematiqueWithId(id: "3", picto: "\ud83e\ude7a", label: "Santé", color: "#FFFCCFDD"),
        ThematiqueWithId(id: "4", picto: "\ud83d\udcc8", label: "Economie", color: "#FFCFF6FC"),
        ThematiqueWithId(id: "5", picto: "\ud83c\udf93", label: "Education", color: "#FFFCE7CF"),
        ThematiqueWithId(id: "6", picto: "\ud83c\udf0f", label: "International", color: "#FFE8CFFC"),
        ThematiqueWithId(id: "7", picto: "\ud83d\ude8a", label: "Transports", color: "#FFFCF7CF"),
        ThematiqueWithId(id: "8", picto: "\ud83d\ude94", label: "Sécurité", color: "#FFE1E7F3"),
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
