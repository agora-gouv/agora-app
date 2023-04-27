import 'dart:async';

import 'package:agora/bloc/deeplink/deeplink_event.dart';
import 'package:agora/bloc/deeplink/deeplink_state.dart';
import 'package:agora/common/helper/deep_link_helper.dart';
import 'package:agora/common/log/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeeplinkBloc extends Bloc<DeeplinkEvent, DeeplinkState> {
  final DeeplinkHelper deeplinkHelper;
  final uuidRegExp = RegExp(r'[0-9a-fA-F]{8}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{4}\b-[0-9a-fA-F]{12}');

  DeeplinkBloc({
    required this.deeplinkHelper,
  }) : super(DeeplinkInitialState()) {
    on<InitDeeplinkListenerEvent>(_handleInitDeeplinkListener);
  }

  Future<void> _handleInitDeeplinkListener(
    InitDeeplinkListenerEvent event,
    Emitter<DeeplinkState> emit,
  ) async {
    emit(DeeplinkLoadingState());
    final uri = await deeplinkHelper.getInitUri();
    if (uri != null) {
      Log.d("deeplink initiate uri : $uri");
      switch (uri.host) {
        case DeeplinkImplHelper.consultationHost:
          _handleDeeplink(
            uri: uri,
            onMatchSuccessCallback: (id) => emit(ConsultationDeeplinkState(consultationId: id)),
            onMatchFailedCallback: () {
              Log.e("deeplink initiate uri : no consultation id match error");
              emit(DeeplinkEmptyState());
            },
          );
          break;
        case DeeplinkImplHelper.qagHost:
          _handleDeeplink(
            uri: uri,
            onMatchSuccessCallback: (id) => emit(QagDeeplinkState(qagId: id)),
            onMatchFailedCallback: () {
              Log.e("deeplink initiate uri : no qag id match error");
              emit(DeeplinkEmptyState());
            },
          );
          break;
        default:
          Log.e("deeplink initiate uri : unknown host error");
          emit(DeeplinkEmptyState());
          break;
      }
    } else {
      emit(DeeplinkEmptyState());
    }

    await emit.onEach(
      deeplinkHelper.getUriLinkStream(),
      onData: (uri) {
        Log.d("deeplink listen uri : $uri");
        emit(DeeplinkLoadingState());
        if (uri != null) {
          switch (uri.host) {
            case DeeplinkImplHelper.consultationHost:
              _handleDeeplink(
                uri: uri,
                onMatchSuccessCallback: (id) => emit(ConsultationDeeplinkState(consultationId: id)),
                onMatchFailedCallback: () {
                  Log.e("deeplink listen uri : no consultation id match error");
                  emit(DeeplinkEmptyState());
                },
              );
              break;
            case DeeplinkImplHelper.qagHost:
              _handleDeeplink(
                uri: uri,
                onMatchSuccessCallback: (id) => emit(QagDeeplinkState(qagId: id)),
                onMatchFailedCallback: () {
                  Log.e("deeplink listen uri : no qag id match error");
                  emit(DeeplinkEmptyState());
                },
              );
              break;
            default:
              Log.e("deeplink listen uri : unknown host error");
              emit(DeeplinkEmptyState());
              break;
          }
        } else {
          Log.e("deeplink listen uri : null uri error");
          emit(DeeplinkEmptyState());
        }
      },
    );
  }

  void _handleDeeplink({
    required Uri uri,
    required Function(String id) onMatchSuccessCallback,
    required VoidCallback onMatchFailedCallback,
  }) {
    final RegExpMatch? match = uuidRegExp.firstMatch(uri.toString());
    if (match != null && match[0] != null) {
      onMatchSuccessCallback(match[0]!);
    } else {
      onMatchFailedCallback();
    }
  }
}
