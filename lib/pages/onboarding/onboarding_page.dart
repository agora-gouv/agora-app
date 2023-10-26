import 'dart:math';

import 'package:agora/common/helper/responsive_helper.dart';
import 'package:agora/common/strings/consultation_strings.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/semantics_strings.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_corners.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:agora/pages/onboarding/onboarding_step_view.dart';
import 'package:agora/pages/onboarding/onboarding_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingPage extends StatefulWidget {
  static const routeName = "/onboardingPage";

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const totalStep = 4;
  final _controller = PageController(initialPage: 0);
  int step = 0;
  final List<dynamic> iconsTheme = [
    {
      "id": "5cdb4732-0153-11ee-be56-0242ac120002",
      "label": "Handicap",
      "picto": "🧑‍🦯 👩‍🦯 👨‍🦯",
    },
    {
      "id": "3953a966-015e-11ee-be56-0242ac120002",
      "label": "Handicap",
      "picto": "👩‍🦽 🧑‍🦽 👨‍🦽",
    },{
      "id": "3953a966-015e-11ee-be56-0242ac120002",
      "label": "Handicap",
      "picto": "♿️",
    },
    {
      "id": "01c4789a-015e-11ee-be56-0242ac120002",
      "label": "Etudes sup. & recherche",
      "picto": "🎓 🥽 🛰️",
    },
    {
      "id": "30671310-ee62-11ed-a05b-0242ac120003",
      "label": "Etudes sup. & recherche",
      "picto": "🚀 ⚖️ 🩺",
    },
    {
      "id": "c97c3afd-1940-4b6d-950a-734b885ee5cb",
      "label": "Etudes sup. & recherche",
      "picto": "🖋️ 🖊️ ✒️",
    },
    {
      "id": "5b9180e6-3e43-4c63-bcb5-4eab621fc016",
      "label": "Etudes sup. & recherche",
      "picto": "🔍 🔎 🧮",
    },
    {
      "id": "73fa6438-015e-11ee-be56-0242ac120002",
      "label": "Egalité",
      "picto": "👥",
    },
    {
      "id": "5e6bed94-015e-11ee-be56-0242ac120002",
      "label": "Energie",
      "picto": "⚡",
    },
    {
      "id": "801e3eb0-015e-11ee-be56-0242ac120002",
      "label": "Enfance",
      "picto": "👶",
    },
    {
      "id": "0ca6f2f6-015e-11ee-be56-0242ac120002",
      "label": "Etudes sup. & recherche",
      "picto": "🧬",
    },
    {
      "id": "8e200137-df3b-4bde-9981-b39a3d326da7",
      "label": "Europe & international",
      "picto": "🌏",
    },
    {
      "id": "41dcc98c-015e-11ee-be56-0242ac120002",
      "label": "Handicap",
      "picto": "🧑‍🦽",
    },
    {
      "id": "2186bc60-015e-11ee-be56-0242ac120002",
      "label": "Justice",
      "picto": "⚖️",
    },
    {
      "id": "8a4e95e2-015e-11ee-be56-0242ac120002",
      "label": "Logement",
      "picto": "🏡",
    },
    {
      "id": "175ab0b6-015e-11ee-be56-0242ac120002",
      "label": "Outre-mer",
      "picto": "🌍",
    },
    {
      "id": "a4bb4b27-3271-4278-83c9-79ac3eee843a",
      "label": "Santé",
      "picto": "🏥",
    },
    {
      "id": "5531afc0-015e-11ee-be56-0242ac120002",
      "label": "Services publics",
      "picto": "🏛",
    },
    {
      "id": "2d1c72fe-015e-11ee-be56-0242ac120002",
      "label": "Solidarités",
      "picto": "🤝",
    },
    {
      "id": "4c379646-015e-11ee-be56-0242ac120002",
      "label": "Sport",
      "picto": "🏀",
    },
    {
      "id": "b276606e-f251-454e-9a73-9b70a6f30bfd",
      "label": "Sécurité & défense",
      "picto": "🛡",
    },
    {
      "id": "bb051bf2-644b-47b6-9488-7759fa727dc0",
      "label": "Transition écologique",
      "picto": "🌱",
    },
    {
      "id": "0f644115-08f3-46ff-b776-51f19c65fdd1",
      "label": "Transports",
      "picto": "🚊",
    },
    {
      "id": "1f3dbdc6-cff7-4d6a-88b5-c5ec84c55d15",
      "label": "Travail",
      "picto": "💼",
    },
    {
      "id": "47897e51-8e94-4920-a26a-1b1e5e232e82",
      "label": "Autre",
      "picto": "📦",
    }
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      shouldPop: false,
      appBarColor: AgoraColors.primaryBlue,
      floatingActionButton: Theme(
        data: _floatingButtonStyle(context),
        child: _floatingButton(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(
          iconsTheme.length,
          (index) => Center(
            child: Text(
              iconsTheme[index]["picto"] as String,
              style: AgoraTextStyles.medium32,
            ),
          ),
        ),
      ),
    );
  }

  ThemeData _floatingButtonStyle(BuildContext context) {
    return Theme.of(context).copyWith(
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: _isSmallFloatingButtonStyle()
            ? null
            : RoundedRectangleBorder(borderRadius: BorderRadius.all(AgoraCorners.rounded)),
        extendedSizeConstraints: BoxConstraints.tightFor(height: AgoraSpacings.x3),
        extendedPadding: EdgeInsets.symmetric(horizontal: AgoraSpacings.x0_75),
        extendedTextStyle: AgoraTextStyles.primaryFloatingButton,
      ),
    );
  }

  Widget _floatingButton(BuildContext context) {
    if (_isSmallFloatingButtonStyle()) {
      return _smallFloatingActionButton(context);
    } else {
      return _largeFloatingActionButton(context);
    }
  }

  bool _isSmallFloatingButtonStyle() => step == 1 || step == 2;

  Widget _smallFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AgoraColors.primaryBlue,
      child: Semantics(
        label: SemanticsStrings.nextPage,
        child: SvgPicture.asset("assets/ic_forward.svg", excludeFromSemantics: true),
      ),
      onPressed: () => _nextPage(context),
    );
  }

  Widget _largeFloatingActionButton(BuildContext context) {
    return SizedBox(
      width: kIsWeb
          ? min(MediaQuery.of(context).size.width, ResponsiveHelper.maxScreenSize) - AgoraSpacings.horizontalPadding * 2
          : MediaQuery.of(context).size.width - AgoraSpacings.horizontalPadding * 2,
      child: FloatingActionButton.extended(
        backgroundColor: AgoraColors.primaryBlue,
        label: Text(step == 0 ? ConsultationStrings.beginButton : GenericStrings.onboardingStep3LetsGo),
        onPressed: () => _nextPage(context),
      ),
    );
  }

  void _nextPage(BuildContext context) {
    setState(() => step++);
    if (step >= totalStep) {
      Navigator.pop(context);
    } else {
      _controller.jumpToPage(step);
    }
  }

/* Widget _handleStep(BuildContext context) {
    return PageView(
      controller: _controller,
      onPageChanged: (index) {
        setState(() {
          step = index;
        });
        _controller.jumpToPage(step);
      },
      children: [
        OnboardingView(),
        OnboardingStepView(step: OnboardingStep.participate),
        OnboardingStepView(step: OnboardingStep.askYourQuestion),
        OnboardingStepView(step: OnboardingStep.invent),
      ],
    );
  }*/
}
