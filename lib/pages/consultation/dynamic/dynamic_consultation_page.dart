import 'dart:math';

import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_bloc.dart';
import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_events.dart';
import 'package:agora/bloc/consultation/dynamic/dynamic_consultation_state.dart';
import 'package:agora/common/extension/date_extension.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/domain/consultation/dynamic/dynamic_consultation.dart';
import 'package:agora/domain/consultation/dynamic/dynamic_consultation_section.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dynamic_consultation_view_model.dart';
part 'dynamic_consultation_presenter.dart';

class DynamicConsultationPage extends StatelessWidget {
  static const routeName = '/consultation/dynamic';

  final String consultationId;

  DynamicConsultationPage(this.consultationId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return DynamicConsultationBloc(
          RepositoryManager.getConsultationRepository(),
        )..add(FetchDynamicConsultationEvent(consultationId));
      },
      child: BlocSelector<DynamicConsultationBloc, DynamicConsultationState, _ViewModel>(
        selector: _Presenter.getViewModelFromState,
      ),
    );
  }
}
