import 'package:agora/bloc/qag/details/qag_details_bloc.dart';
import 'package:agora/bloc/qag/details/qag_details_event.dart';
import 'package:agora/bloc/qag/details/qag_details_state.dart';
import 'package:agora/bloc/qag/details/qag_details_view_model.dart';
import 'package:agora/bloc/qag/support/qag_support_bloc.dart';
import 'package:agora/bloc/qag/support/qag_support_event.dart';
import 'package:agora/bloc/qag/support/qag_support_state.dart';
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
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/custom_view/agora_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QagDetailsPage extends StatefulWidget {
  static const routeName = "/qagDetailsPage";

  @override
  State<QagDetailsPage> createState() => _QagDetailsPageState();
}

class _QagDetailsPageState extends State<QagDetailsPage> {
  @override
  Widget build(BuildContext context) {
    const qagId = "f29c5d6f-9838-4c57-a7ec-0612145bb0c8";
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) {
            return QagDetailsBloc(
              qagRepository: RepositoryManager.getQagRepository(),
              deviceIdHelper: HelperManager.getDeviceIdHelper(),
            )..add(FetchQagDetailsEvent(qagId: qagId));
          },
        ),
        BlocProvider(
          create: (BuildContext context) => QagSupportBloc(
            qagRepository: RepositoryManager.getQagRepository(),
            deviceIdHelper: HelperManager.getDeviceIdHelper(),
          ),
        )
      ],
      child: AgoraScaffold(
        child: BlocBuilder<QagDetailsBloc, QagDetailsState>(
          builder: (context, detailsState) {
            if (detailsState is QagDetailsFetchedState) {
              final viewModel = detailsState.viewModel;
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
                            if (viewModel.support != null)
                              BlocBuilder<QagSupportBloc, QagSupportState>(
                                builder: (context, supportState) {
                                  final isSupported = viewModel.support!.isSupported;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: AgoraButton(
                                          icon: _buildIcon(isSupported, supportState),
                                          label: _buildLabel(isSupported, supportState),
                                          style: _buildButtonStyle(isSupported, supportState),
                                          isLoading: supportState is QagSupportLoadingState ||
                                              supportState is QagDeleteSupportLoadingState,
                                          onPressed: () => _buildOnPressed(context, qagId, isSupported, supportState),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(width: AgoraSpacings.base),
                                          SvgPicture.asset("assets/ic_heard.svg"),
                                          SizedBox(width: AgoraSpacings.x0_25),
                                          Text(
                                            _buildCount(viewModel.support!, supportState),
                                            style: AgoraTextStyles.medium14,
                                          ),
                                          SizedBox(width: AgoraSpacings.x0_5),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
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
