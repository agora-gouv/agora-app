import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class QagResponseAVenirViewModel extends Equatable {
  final String qagId;
  final ThematiqueViewModel thematique;
  final String title;
  final int supportCount;
  final bool isSupported;
  final String semaineGagnanteLabel;

  QagResponseAVenirViewModel({
    required this.qagId,
    required this.thematique,
    required this.title,
    required this.supportCount,
    required this.isSupported,
    required this.semaineGagnanteLabel,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
        supportCount,
        isSupported,
        semaineGagnanteLabel,
      ];
}
