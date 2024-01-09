import 'package:agora/bloc/qag/search/qag_search_bloc.dart';
import 'package:agora/bloc/qag/search/qag_search_event.dart';
import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/extension/string_extension.dart';
import 'package:agora/common/helper/timer_helper.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/common/strings/string_utils.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/qag/qags_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPageFromAskQuestionPage extends StatelessWidget {
  static const routeName = "/searchFromAskQuestionPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QagSearchBloc(
        qagRepository: RepositoryManager.getQagRepository(),
      ),
      child: AgoraScaffold(
        child: _Content(),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  final TextEditingController textController = TextEditingController();
  String previousSearchKeywords = '';
  String previousSearchKeywordsSanitized = '';
  final timerHelper = TimerHelper(countdownDurationInSecond: 1);

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      previousSearchKeywords = textController.text;
      previousSearchKeywordsSanitized = processNewInput(
        context,
        textController,
        timerHelper,
        previousSearchKeywordsSanitized,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        AgoraToolbar(pageLabel: 'Recherche'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.x0_5),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AgoraColors.doctor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  spreadRadius: -10.0,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.search),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: textController,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    cursorRadius: Radius.circular(10.0),
                    cursorWidth: 2.0,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: 5),
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: QagStrings.searchQagHint,
                      labelStyle: AgoraTextStyles.light14,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AgoraSpacings.base),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AgoraSpacings.base),
            child: SingleChildScrollView(
              child: QagSearch(false),
            ),
          ),
        ),
      ],
    );
  }
}

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
