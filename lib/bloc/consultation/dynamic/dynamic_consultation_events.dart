class FetchDynamicConsultationEvent {
  final String id;

  FetchDynamicConsultationEvent(this.id);
}

class FetchDynamicConsultationResultsEvent {
  final String id;

  FetchDynamicConsultationResultsEvent(this.id);
}

class FetchDynamicConsultationUpdateEvent {
  final String id;
  final String consultationId;

  FetchDynamicConsultationUpdateEvent(this.id, this.consultationId);
}
