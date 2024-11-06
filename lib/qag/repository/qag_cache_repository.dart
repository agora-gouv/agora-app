import 'package:agora/qag/repository/qag_repository.dart';

class QagCacheRepository {
  final QagRepository qagRepository;

  QagCacheRepository({required this.qagRepository});

  GetQagsResponseRepositoryResponse? qagResponseData;
  GetQagsResponsePaginatedRepositoryResponse? qagResponsePaginatedData;
  DateTime? lastUpdate;

  static const Duration CACHE_MAX_AGE = Duration(minutes: 5);

  bool get isCacheSuccess =>
      qagResponseData is GetQagsResponseSucceedResponse &&
      qagResponsePaginatedData is GetQagsResponsePaginatedSucceedResponse &&
      isCacheFresh;

  bool get isCacheFresh => lastUpdate != null && DateTime.now().isBefore(lastUpdate!.add(CACHE_MAX_AGE));

  Future<GetQagsResponseRepositoryResponse> fetchQagsResponse() async {
    if (isCacheSuccess) {
      return qagResponseData!;
    }
    qagResponseData = await qagRepository.fetchQagsResponse();
    lastUpdate = DateTime.now();
    return qagResponseData!;
  }

  Future<GetQagsResponsePaginatedRepositoryResponse> fetchQagsResponsePaginated({required int pageNumber}) async {
    if (isCacheSuccess) {
      return qagResponsePaginatedData!;
    }
    qagResponsePaginatedData = await qagRepository.fetchQagsResponsePaginated(pageNumber: pageNumber);
    lastUpdate = DateTime.now();
    return qagResponsePaginatedData!;
  }
}
