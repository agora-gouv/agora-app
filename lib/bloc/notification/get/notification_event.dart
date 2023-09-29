import 'package:equatable/equatable.dart';

class GetNotificationEvent extends Equatable {
  final int pageNumber;

  GetNotificationEvent({required this.pageNumber});

  @override
  List<Object> get props => [pageNumber];
}
