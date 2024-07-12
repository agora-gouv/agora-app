import 'package:equatable/equatable.dart';

class QagModerateEvent extends Equatable {
  final String qagId;
  final bool isAccept;

  QagModerateEvent({required this.qagId, required this.isAccept});

  @override
  List<Object> get props => [qagId, isAccept];
}
