import 'package:equatable/equatable.dart';

class DeleteQagEvent extends Equatable {
  final String qagId;

  DeleteQagEvent({required this.qagId});

  @override
  List<Object> get props => [qagId];
}
