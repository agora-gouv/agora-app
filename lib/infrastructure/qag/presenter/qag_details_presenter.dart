import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/domain/qag/details/qag_details.dart';

class QagDetailsPresenter {
  static QagDetailsViewModel present(QagDetails qagDetails) {
    return QagDetailsViewModel(
      id: qagDetails.id,
      thematiqueId: qagDetails.thematiqueId,
      title: qagDetails.title,
      description: qagDetails.description,
      date: qagDetails.date.formatToDayMonth(),
      username: qagDetails.username,
      support: qagDetails.support != null
          ? QagDetailsSupportViewModel(
              count: qagDetails.support!.count,
              isSupported: qagDetails.support!.isSupported,
            )
          : null,
    );
  }
}
