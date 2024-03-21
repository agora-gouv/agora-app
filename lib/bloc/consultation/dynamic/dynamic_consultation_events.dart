abstract class DynamicConsultationEvent {}

class FetchDynamicConsultationEvent extends DynamicConsultationEvent {
  final String id;

  FetchDynamicConsultationEvent(this.id);
}

class FetchDynamicConsultationResultsEvent {
  final String id;

  FetchDynamicConsultationResultsEvent(this.id);
}

class FetchDynamicConsultationUpdateEvent extends DynamicConsultationEvent {
  final String id;
  final String consultationId;

  FetchDynamicConsultationUpdateEvent(this.id, this.consultationId);
}

class SendConsultationUpdateFeedbackEvent extends DynamicConsultationEvent {
  final String updateId;
  final String consultationId;
  final bool isPositive;

  SendConsultationUpdateFeedbackEvent({
    required this.updateId,
    required this.consultationId,
    required this.isPositive,
  });
}

class DeleteConsultationUpdateFeedbackEvent extends DynamicConsultationEvent {
  final String updateId;
  final String consultationId;

  DeleteConsultationUpdateFeedbackEvent({
    required this.updateId,
    required this.consultationId,
  });
}
