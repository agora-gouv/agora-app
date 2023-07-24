enum AgoraDioExceptionType {
  // thematiques
  fetchThematiques,
  // demographics
  getDemographicResponses,
  sendDemographicResponses,
  // login
  signUpUpdateVersion,
  signUpTimeout,
  signUp,
  loginUpdateVersion,
  loginTimeout,
  login,
  // consultations
  fetchConsultations,
  fetchConsultationsTimeout,
  fetchConsultationsFinishedPaginated,
  fetchConsultationDetails,
  fetchConsultationQuestions,
  sendConsultationResponses,
  fetchConsultationSummary,
  // qags
  createQag,
  fetchQags,
  fetchQagsTimeout,
  fetchQagsPaginated,
  fetchQagsResponsePaginated,
  fetchQagDetails,
  fetchQagDetailsModerated,
  supportQag,
  deleteSupportQag,
  giveQagResponseFeedback,
  fetchQagModerationList,
  moderateQag,
  hasSimilarQag,
}
