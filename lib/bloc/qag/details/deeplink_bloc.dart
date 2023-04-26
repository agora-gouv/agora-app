import 'dart:async';

import 'package:agora/bloc/deeplink/deeplink_event.dart';
import 'package:agora/bloc/deeplink/deeplink_state.dart';
import 'package:agora/common/helper/deep_link_helper.dart';
import 'package:agora/common/log/log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeeplinkBloc extends Bloc<DeeplinkEvent, DeeplinkState> {
  final DeeplinkHelper deeplinkHelper;
  final uuidRegExp = RegExp(r'[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}');

  DeeplinkBloc({
    required this.deeplinkHelper,
  }) : super(DeeplinkInitialState()) {
    on<InitDeeplinkListenerEvent>(_handleDeeplink);
  }

  Future<void> _handleDeeplink(
    InitDeeplinkListenerEvent event,
    Emitter<DeeplinkState> emit,
  ) async {
    final uri = await deeplinkHelper.getInitUri();
    if (uri != null) {
      Log.d("deeplink initiate uri : $uri");
      emit(DeeplinkLoadingState());
      switch (uri.host) {
        case DeeplinkImplHelper.consultationHost:
          _handleConsultationDeeplink(uri, emit, "deeplink initiate uri no consultation id match");
          break;
        case DeeplinkImplHelper.qagHost:
          break;
      }
    }

    await emit.onEach(
      deeplinkHelper.getUriLinkStream(),
      onData: (uri) {
        Log.d("deeplink listen uri : $uri");
        emit(DeeplinkLoadingState());
        if (uri != null) {
          switch (uri.host) {
            case DeeplinkImplHelper.consultationHost:
              _handleConsultationDeeplink(uri, emit, "deeplink listen uri no consultation id match");
              break;
            case DeeplinkImplHelper.qagHost:
              break;
          }
        }
      },
    );
  }

  void _handleConsultationDeeplink(Uri uri, Emitter<DeeplinkState> emit, String errorMessage) {
    final RegExpMatch? match = uuidRegExp.firstMatch(uri.toString());
    if (match != null && match[0] != null) {
      emit(ConsultationDeeplinkState(consultationId: match[0]!));
    } else {
      Log.e("deeplink regRex no match error $errorMessage");
    }
  }
}
