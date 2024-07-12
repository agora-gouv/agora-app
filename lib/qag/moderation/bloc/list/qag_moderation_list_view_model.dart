import 'package:agora/thematique/bloc/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class QagModerationListViewModel extends Equatable {
  final int totalNumber;
  final List<QagModerationViewModel> qagsToModerationViewModels;

  QagModerationListViewModel({required this.totalNumber, required this.qagsToModerationViewModels});

  @override
  List<Object> get props => [totalNumber, qagsToModerationViewModels];
}

class QagModerationViewModel extends Equatable {
  final String id;
  final ThematiqueViewModel thematique;
  final String title;
  final String description;
  final String username;
  final String date;
  final int supportCount;
  final bool isSupported;

  QagModerationViewModel({
    required this.id,
    required this.thematique,
    required this.title,
    required this.description,
    required this.username,
    required this.date,
    required this.supportCount,
    required this.isSupported,
  });

  @override
  List<Object> get props => [
        id,
        thematique,
        title,
        description,
        username,
        date,
        supportCount,
        isSupported,
      ];
}
