import 'package:agora/qag/ask/bloc/search/qag_search_bloc.dart';
import 'package:agora/common/helper/timer_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/qag/ask/pages/qag_search_input_utils.dart';
import 'package:agora/qag/ask/pages/qags_search.dart';
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
            padding: const EdgeInsets.all(AgoraSpacings.x0_75),
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
                const SizedBox(width: AgoraSpacings.x0_75),
                Expanded(
                  child: TextField(
                    controller: textController,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    cursorRadius: AgoraCorners.rounded12,
                    cursorWidth: 2.0,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: AgoraSpacings.x0_375),
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: QagStrings.searchQagHint,
                      labelStyle: AgoraTextStyles.light14,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: AgoraCorners.borderRounded20,
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
