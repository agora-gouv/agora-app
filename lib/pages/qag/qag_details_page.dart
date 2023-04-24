import 'package:agora/bloc/qag/details/qag_details_bloc.dart';
import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_bloc.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_event.dart';
import 'package:agora/bloc/qag/feedback/qag_feedback_state.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
import 'package:agora/bloc/thematique/thematique_bloc.dart';
import 'package:agora/common/client/helper_manager.dart';
import 'package:agora/common/client/repository_manager.dart';
import 'package:agora/common/helper/thematique_helper.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_spacings.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_error_view.dart';
import 'package:agora/design/custom_view/agora_read_more_text.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_single_scroll_view.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:agora/design/custom_view/agora_video_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QagDetailsArguments {
  final ThematiqueBloc thematiqueBloc;
  final String qagId;

  QagDetailsArguments({required this.thematiqueBloc, required this.qagId});
}

class QagDetailsPage extends StatefulWidget {
  static const routeName = "/qagDetailsPage";
  final String qagId;

  const QagDetailsPage({super.key, required this.qagId});

  @override
  State<QagDetailsPage> createState() => _QagDetailsPageState();
}

class _QagDetailsPageState extends State<QagDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return QagDetailsBloc(
              qagRepository: RepositoryManager.getQagRepository(),
              deviceIdHelper: HelperManager.getDeviceInfoHelper(),
            )..add(FetchQagDetailsEvent(qagId: widget.qagId));
          },
        ),
        BlocProvider(
          create: (BuildContext context) => QagSupportBloc(
            qagRepository: RepositoryManager.getQagRepository(),
            deviceIdHelper: HelperManager.getDeviceInfoHelper(),
          ),
        ),
        BlocProvider(
          create: (BuildContext context) => QagFeedbackBloc(
            qagRepository: RepositoryManager.getQagRepository(),
            deviceIdHelper: HelperManager.getDeviceInfoHelper(),
          ),
        ),
      ],
      child: AgoraScaffold(
        child: BlocBuilder<QagDetailsBloc, QagDetailsState>(
          builder: (context, detailsState) {
            if (detailsState is QagDetailsFetchedState) {
              final viewModel = detailsState.viewModel;
              final support = viewModel.support;
              final response = viewModel.response;
              return AgoraSingleScrollView(
                child: Stack(
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
                              if (support != null) ...[
                                RichText(
                                  text: TextSpan(
                                    style: AgoraTextStyles.regularItalic14
                                        .copyWith(color: AgoraColors.primaryGreyOpacity80),
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
                                _buildSupportView(support),
                              ],
                            ],
                          ),
                        ),
                        if (response != null) _buildResponseView(response, viewModel),
                      ],
                    ),
                  ],
                ),
              );
            } else if (detailsState is QagDetailsInitialLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: AgoraErrorView());
            }
          },
        ),
      ),
    );
  }

  Widget _buildSupportView(QagDetailsSupportViewModel support) {
    return BlocBuilder<QagSupportBloc, QagSupportState>(
      builder: (context, supportState) {
        final isSupported = support.isSupported;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: AgoraButton(
                    icon: _buildIcon(isSupported, supportState),
                    label: _buildLabel(isSupported, supportState),
                    style: _buildButtonStyle(isSupported, supportState),
                    isLoading: supportState is QagSupportLoadingState || supportState is QagDeleteSupportLoadingState,
                    onPressed: () => _buildOnPressed(context, widget.qagId, isSupported, supportState),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: AgoraSpacings.base),
                    SvgPicture.asset("assets/ic_heard.svg"),
                    SizedBox(width: AgoraSpacings.x0_25),
                    Text(
                      _buildCount(support, supportState),
                      style: AgoraTextStyles.medium14,
                    ),
                    SizedBox(width: AgoraSpacings.x0_5),
                  ],
                ),
              ],
            ),
            if (supportState is QagSupportErrorState || supportState is QagDeleteSupportErrorState) ...[
              SizedBox(height: AgoraSpacings.base),
              AgoraErrorView(),
            ]
          ],
        );
      },
    );
  }

  Widget _buildResponseView(QagDetailsResponseViewModel response, QagDetailsViewModel viewModel) {
    return Flexible(
      child: Container(
        width: double.infinity,
        color: AgoraColors.background,
        child: Padding(
          padding: const EdgeInsets.all(AgoraSpacings.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(QagStrings.governmentResponseTitle, style: AgoraTextStyles.medium17),
              SizedBox(height: AgoraSpacings.base),
              AgoraVideoView(videoUrl: response.videoUrl),
              SizedBox(height: AgoraSpacings.base),
              RichText(
                text: TextSpan(
                  style: AgoraTextStyles.light16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  children: [
                    TextSpan(text: QagStrings.by),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: response.author,
                      style: AgoraTextStyles.medium16.copyWith(color: AgoraColors.primaryGreyOpacity90),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AgoraSpacings.x0_5),
              Padding(
                padding: const EdgeInsets.only(left: AgoraSpacings.horizontalPadding),
                child: Text(
                  response.authorDescription,
                  style: AgoraTextStyles.mediumItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                ),
              ),
              SizedBox(height: AgoraSpacings.x0_5),
              RichText(
                text: TextSpan(
                  style: AgoraTextStyles.light16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  children: [
                    TextSpan(text: QagStrings.at),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: viewModel.date,
                      style: AgoraTextStyles.mediumItalic16.copyWith(color: AgoraColors.primaryGreyOpacity80),
                    )
                  ],
                ),
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              RichText(
                text: TextSpan(
                  style: AgoraTextStyles.regularItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                  children: [
                    TextSpan(text: QagStrings.answerTo),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: viewModel.username,
                      style: AgoraTextStyles.mediumItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                    ),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(text: QagStrings.at),
                    WidgetSpan(child: SizedBox(width: AgoraSpacings.x0_25)),
                    TextSpan(
                      text: viewModel.date,
                      style: AgoraTextStyles.mediumItalic14.copyWith(color: AgoraColors.primaryGreyOpacity80),
                    )
                  ],
                ),
              ),
              SizedBox(height: AgoraSpacings.x1_5),
              AgoraReadMoreText(response.transcription),
              SizedBox(height: AgoraSpacings.x2),
              Text(QagStrings.questionUtilsTitle, style: AgoraTextStyles.medium18),
              SizedBox(height: AgoraSpacings.base),
              BlocBuilder<QagFeedbackBloc, QagFeedbackState>(
                builder: (context, feedbackState) {
                  final qagFeedbackBloc = context.read<QagFeedbackBloc>();
                  bool isThumbUpClicked = true;
                  return feedbackState is QagFeedbackSuccessState ||
                          (feedbackState is QagFeedbackInitialState && response.feedbackStatus)
                      ? Text(QagStrings.feedback)
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AgoraButton(
                                  icon: "ic_thumb_white.svg",
                                  label: QagStrings.utils,
                                  style: AgoraButtonStyle.primaryButtonStyle,
                                  isLoading: feedbackState is QagFeedbackLoadingState && isThumbUpClicked,
                                  onPressed: () {
                                    isThumbUpClicked = true;
                                    qagFeedbackBloc.add(QagFeedbackEvent(qagId: widget.qagId, isHelpful: true));
                                  },
                                ),
                                SizedBox(width: AgoraSpacings.base),
                                AgoraButton(
                                  icon: "ic_thumb_down_white.svg",
                                  label: QagStrings.notUtils,
                                  style: AgoraButtonStyle.primaryButtonStyle,
                                  isLoading: feedbackState is QagFeedbackLoadingState && !isThumbUpClicked,
                                  onPressed: () {
                                    isThumbUpClicked = false;
                                    qagFeedbackBloc.add(QagFeedbackEvent(qagId: widget.qagId, isHelpful: false));
                                  },
                                ),
                              ],
                            ),
                            if (feedbackState is QagFeedbackErrorState) ...[
                              SizedBox(height: AgoraSpacings.base),
                              AgoraErrorView(),
                            ]
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildCount(QagDetailsSupportViewModel serverSupportViewModel, QagSupportState supportState) {
    final isSupported = serverSupportViewModel.isSupported;
    final supportCount = serverSupportViewModel.count;
    if (!isSupported && supportState is QagSupportSuccessState) {
      return (supportCount + 1).toString();
    } else if (isSupported && supportState is QagDeleteSupportSuccessState) {
      return (supportCount - 1).toString();
    }
    return supportCount.toString();
  }

  String _buildIcon(bool isSupported, QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      if (isSupported) {
        return "ic_confirmation_green.svg";
      } else {
        return "ic_thumb_white.svg";
      }
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        return "ic_confirmation_green.svg";
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        return "ic_thumb_white.svg";
      }
    }
    return ""; // value not important
  }

  String _buildLabel(bool isSupported, QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      if (isSupported) {
        return QagStrings.questionSupported;
      } else {
        return QagStrings.supportQuestion;
      }
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        return QagStrings.questionSupported;
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        return QagStrings.supportQuestion;
      }
    }
    return ""; // value not important
  }

  ButtonStyle _buildButtonStyle(bool isSupported, QagSupportState supportState) {
    if (supportState is QagSupportInitialState) {
      if (isSupported) {
        return AgoraButtonStyle.whiteButtonWithGreenBorderStyle;
      } else {
        return AgoraButtonStyle.primaryButtonStyle;
      }
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        return AgoraButtonStyle.whiteButtonWithGreenBorderStyle;
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        return AgoraButtonStyle.primaryButtonStyle;
      }
    }
    return AgoraButtonStyle.whiteButtonStyle; // value not important
  }

  void _buildOnPressed(BuildContext context, String qagId, bool isSupported, QagSupportState supportState) {
    final qagSupportBloc = context.read<QagSupportBloc>();
    if (supportState is QagSupportInitialState) {
      if (isSupported) {
        qagSupportBloc.add(DeleteSupportQagEvent(qagId: qagId));
      } else {
        qagSupportBloc.add(SupportQagEvent(qagId: qagId));
      }
    } else {
      if (supportState is QagSupportSuccessState || supportState is QagDeleteSupportErrorState) {
        qagSupportBloc.add(DeleteSupportQagEvent(qagId: qagId));
      } else if (supportState is QagSupportErrorState || supportState is QagDeleteSupportSuccessState) {
        qagSupportBloc.add(SupportQagEvent(qagId: qagId));
      }
    }
  }
}
