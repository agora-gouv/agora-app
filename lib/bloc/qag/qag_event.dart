import 'package:agora/bloc/thematique/thematique_view_model.dart';
import 'package:equatable/equatable.dart';

class QagsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchQagsEvent extends QagsEvent {
  final String? thematiqueId;

  FetchQagsEvent({required this.thematiqueId});

  @override
  List<Object?> get props => [thematiqueId];
}

class UpdateQagsEvent extends QagsEvent {
  final String qagId;
  final ThematiqueViewModel thematique;
  final String title;
  final String username;
  final String date;
  final int supportCount;
  final bool isSupported;

  UpdateQagsEvent({
    required this.qagId,
    required this.thematique,
    required this.title,
    required this.username,
    required this.date,
    required this.supportCount,
    required this.isSupported,
  });

  @override
  List<Object> get props => [
        qagId,
        thematique,
        title,
        username,
        date,
        supportCount,
        isSupported,
      ];
}
