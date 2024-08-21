import 'package:agora/qag/ask/bloc/search/qag_search_bloc.dart';
import 'package:agora/qag/ask/bloc/search/qag_search_event.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/timer_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String processNewInput(
  BuildContext context,
  TextEditingController textController,
  TimerHelper timerHelper,
  String previousSearchKeywordsSanitized,
) {
  final sanitizedInput = StringUtils.replaceDiacriticsAndRemoveSpecialChars(textController.text);
  bool reloadQags = false;
  String newPreviousSearchKeywordsSanitized;
  if (sanitizedInput.isNullOrBlank() || sanitizedInput.length < 3) {
    context.read<QagSearchBloc>().add(FetchQagsInitialEvent());
    newPreviousSearchKeywordsSanitized = '';
  } else {
    if (previousSearchKeywordsSanitized.length != sanitizedInput.length) {
      reloadQags = true;
    }
    newPreviousSearchKeywordsSanitized = sanitizedInput;
  }
  if (reloadQags) {
    context.read<QagSearchBloc>().add(FetchQagsLoadingEvent());
    timerHelper.startTimer(() => _loadQags(context, sanitizedInput));
  }
  return newPreviousSearchKeywordsSanitized;
}

void _loadQags(BuildContext context, String keywords) {
  context.read<QagSearchBloc>().add(FetchQagsSearchEvent(keywords: keywords));

  if (keywords.isNotEmpty == true) {
    TrackerHelper.trackSearch(
      widgetName: AnalyticsScreenNames.qagsPage,
      searchName: AnalyticsEventNames.qagsSearch,
      searchedKeywords: keywords,
    );
  }
}
