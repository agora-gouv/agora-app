import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/manager/repository_manager.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/custom_view/agora_html.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/consultation/consultations_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:agora/pages/qag/response_paginated/qags_response_paginated_page.dart';
import 'package:agora/welcome/bloc/welcome_bloc.dart';
import 'package:agora/welcome/bloc/welcome_event.dart';
import 'package:agora/welcome/bloc/welcome_state.dart';
import 'package:agora/welcome/pages/welcome_a_la_une_presenter.dart';
import 'package:agora/welcome/pages/welcome_a_la_une_view_model.dart';
import 'package:agora/welcome/pages/welcome_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  static const routeName = "/welcomePage";

  const WelcomePage();

  @override
  Widget build(BuildContext context) {
    final largerThanMobile = ResponsiveHelper.isLargerThanMobile(context);
    return AgoraScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
              child: Column(
                crossAxisAlignment: largerThanMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AgoraSpacings.x0_75),
                  Align(
                    alignment: Alignment.topLeft,
                    child: SvgPicture.asset(
                      "assets/ic_marianne.svg",
                      height: 70,
                      width: 70,
                      excludeFromSemantics: true,
                    ),
                  ),
                  SizedBox(height: AgoraSpacings.base),
                  Semantics(
                    header: true,
                    focused: true,
                    child: Text(
                      GenericStrings.welcomeTitle,
                      style: AgoraTextStyles.bold28.copyWith(color: AgoraColors.primaryBlue),
                      textAlign: largerThanMobile ? TextAlign.center : TextAlign.start,
                    ),
                  ),
                  SizedBox(height: AgoraSpacings.base),
                  Text(
                    GenericStrings.welcomeDescription,
                    style: AgoraTextStyles.regular16,
                    textAlign: largerThanMobile ? TextAlign.center : TextAlign.start,
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: [
                  SizedBox(height: AgoraSpacings.x2),
                  Padding(
                    padding: const EdgeInsets.only(right: AgoraSpacings.x4_5),
                    child: WelcomeCard(
                      backgroundColor: AgoraColors.primaryBlue,
                      iconPath: "assets/ic_welcome_question.svg",
                      textContent: [
                        TextSpan(
                          text: "Poser ma ",
                          style: AgoraTextStyles.light16.copyWith(color: AgoraColors.white),
                        ),
                        TextSpan(
                          text: "question au Gouvernement",
                          style: AgoraTextStyles.bold16.copyWith(color: AgoraColors.white),
                        ),
                      ],
                      onTap: () {
                        Navigator.pushReplacementNamed(context, QagsPage.routeName);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AgoraSpacings.x3),
                    child: WelcomeCard(
                      iconPath: "assets/ic_reponse.svg",
                      iconColorFilter: ColorFilter.mode(AgoraColors.primaryBlue, BlendMode.srcIn),
                      textContent: [
                        TextSpan(
                          text: "Suivre les ",
                          style: AgoraTextStyles.light16.copyWith(color: AgoraColors.primaryBlue),
                        ),
                        TextSpan(
                          text: "réponses des ministres",
                          style: AgoraTextStyles.bold16.copyWith(color: AgoraColors.primaryBlue),
                        ),
                      ],
                      onTap: () {
                        Navigator.pushReplacementNamed(context, QagsPage.routeName);
                        Navigator.pushNamed(context, QagResponsePaginatedPage.routeName);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: AgoraSpacings.x1_5),
                    child: WelcomeCard(
                      backgroundColor: AgoraColors.red,
                      iconPath: "assets/ic_welcome_consultation.svg",
                      textContent: [
                        TextSpan(
                          text: "Participer aux ",
                          style: AgoraTextStyles.light16.copyWith(color: AgoraColors.white),
                        ),
                        TextSpan(
                          text: "consultations citoyennes",
                          style: AgoraTextStyles.bold16.copyWith(color: AgoraColors.white),
                        ),
                      ],
                      onTap: () {
                        Navigator.pushReplacementNamed(context, ConsultationsPage.routeName);
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocProvider(
                      create: (context) => WelcomeBloc(
                        welcomeRepository: RepositoryManager.getWelcomeRepository(),
                      )..add(GetWelcomeALaUneEvent()),
                      child: BlocSelector<WelcomeBloc, WelcomeState, WelcomeALaUneViewModel>(
                        selector: WelcomeALaUnePresenter.getViewModelFromState,
                        builder: (context, vm) {
                          if (vm.status == AllPurposeStatus.error || vm.welcomeALaUne == null) {
                            return SizedBox();
                          } else {
                            final aLaUne = vm.welcomeALaUne!;
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color: AgoraColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(context, QagsPage.routeName);
                                    Navigator.pushNamed(context, aLaUne.routeName, arguments: aLaUne.routeArgument);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: AgoraSpacings.horizontalPadding),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: AgoraSpacings.x0_75),
                                        Text(
                                          GenericStrings.welcomeNewsTitle,
                                          style: AgoraTextStyles.regular26.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: AgoraSpacings.x0_75),
                                        AgoraHtml(
                                          data: aLaUne.description,
                                          textAlign: TextAlign.end,
                                        ),
                                        SizedBox(height: AgoraSpacings.x0_75),
                                        Row(
                                          children: [
                                            SizedBox(width: AgoraSpacings.x4_5),
                                            Expanded(
                                              child: Text(
                                                aLaUne.actionText,
                                                style: AgoraTextStyles.regular14,
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            SizedBox(width: AgoraSpacings.x0_75),
                                            SvgPicture.asset(
                                              "assets/ic_chevrons.svg",
                                              colorFilter: ColorFilter.mode(AgoraColors.black, BlendMode.srcIn),
                                              width: 15,
                                              height: 15,
                                              excludeFromSemantics: true,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
