import 'package:agora/domain/thematique/thematique.dart';
import 'package:equatable/equatable.dart';

class QagResponseIncoming extends Equatable {
  final String qagId;
  final Thematique thematique;
  final String title;
  final int supportCount;
  final bool isSupported;

  QagResponseIncoming({
    required this.qagId,
    required this.thematique,
    required this.title,
    required this.supportCount,
    required this.isSupported,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
        supportCount,
        isSupported,
      ];
}
