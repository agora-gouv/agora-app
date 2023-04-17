import 'package:agora/bloc/qag/details/qag_details_bloc.dart';
import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/common/client/repository_manager.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QagDetailsPage extends StatelessWidget {
  static const routeName = "/qagDetailsPage";

  @override
  Widget build(BuildContext context) {
    const qagId = "qagId";
    return BlocProvider(
      create: (BuildContext context) {
        return QagDetailsBloc(
          qagRepository: RepositoryManager.getQagRepository(),
        )..add(FetchQagDetailsEvent(qagId: qagId));
      },
      child: AgoraScaffold(
        child: BlocBuilder<QagDetailsBloc, QagDetailsState>(
          builder: (context, state) {
            if (state is QagDetailsFetchedState) {
              final viewModel = state.viewModel;
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AgoraSpacings.horizontalPadding,
                        vertical: AgoraSpacings.x0_5,
                      ),
                      child: AgoraButton(
                        icon: "ic_share.svg",
                        label: QagStrings.share,
                        style: AgoraButtonStyle.lightGreyButtonStyle,
                        onPressed: () {
                          // TODO
                        },
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      AgoraToolbar(),
                      Padding(
                        padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ThematiqueHelper.buildCard(context, viewModel.thematiqueId),
                            SizedBox(height: AgoraSpacings.base),
                            Text(viewModel.title, style: AgoraTextStyles.medium18),
                            SizedBox(height: AgoraSpacings.base),
                            Text(viewModel.description, style: AgoraTextStyles.light14),
                            SizedBox(height: AgoraSpacings.base),
                            RichText(
                              text: TextSpan(
                                style:
                                    AgoraTextStyles.regularItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                                children: [
                                  TextSpan(text: QagStrings.by),
                                  WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                                  TextSpan(
                                    text: viewModel.username,
                                    style: AgoraTextStyles.mediumItalic14
                                        .copyWith(color: AgoraColors.primaryGreyOpacity80),
                                  ),
                                  WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                                  TextSpan(text: QagStrings.at),
                                  WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                                  TextSpan(
                                    text: viewModel.date,
                                    style: AgoraTextStyles.mediumItalic14
                                        .copyWith(color: AgoraColors.primaryGreyOpacity80),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: AgoraSpacings.x3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: AgoraButton(
                                    icon: "ic_thumb_white.svg",
                                    label: "Soutenir cette question",
                                    style: AgoraButtonStyle.primaryButtonStyle,
                                    onPressed: () {
                                      // TODO
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: AgoraSpacings.base),
                                    SvgPicture.asset("assets/ic_heard.svg"),
                                    SizedBox(width: AgoraSpacings.x0_25),
                                    Text(viewModel.supportCount.toString(), style: AgoraTextStyles.medium14),
                                    SizedBox(width: AgoraSpacings.x0_5),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (state is QagDetailsInitialLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: AgoraErrorView());
            }
          },
        ),
      ),
    );
  }
}
