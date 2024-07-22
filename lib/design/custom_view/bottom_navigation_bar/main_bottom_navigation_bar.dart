import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/design/custom_view/agora_responsive_view.dart';
import 'package:agora/design/custom_view/bottom_navigation_bar/agora_bottom_navigation_bar.dart';
import 'package:agora/design/custom_view/bottom_navigation_bar/agora_bottom_navigation_bar_item.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/consultation/pages/consultations_page.dart';
import 'package:agora/profil/pages/profil_page.dart';
import 'package:agora/qag/pages/qags_page.dart';
import 'package:agora/reponse/pages/reponses_page.dart';
import 'package:flutter/material.dart';

enum NavigationPage { consultation, reponse, qag, profil }

class MainBottomNavigationBar extends StatefulWidget {
  final NavigationPage startPage;

  MainBottomNavigationBar({super.key, required this.startPage});

  @override
  State<MainBottomNavigationBar> createState() => _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar> {
  final List<NavigationPage> pages = [
    NavigationPage.qag,
    NavigationPage.reponse,
    NavigationPage.consultation,
    NavigationPage.profil,
  ];
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = pages.indexWhere((page) => page == widget.startPage);
  }

  @override
  Widget build(BuildContext context) {
    return AgoraResponsiveView(child: _buildScaffold());
  }

  Scaffold _buildScaffold() {
    return Scaffold(
      backgroundColor: AgoraColors.white,
      appBar: AppBar(
        backgroundColor: HelperManager.getMainColorHelper().getMainColor(),
        toolbarHeight: 0,
        elevation: 0,
      ),
      bottomNavigationBar: AgoraBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) => setState(() => _currentIndex = newIndex),
        items: pages.map((page) => _getBottomNavigationBarItem(page)).toList(),
      ),
      body: SafeArea(child: _Content(pages[_currentIndex])),
    );
  }

  AgoraBottomNavigationBarItem _getBottomNavigationBarItem(NavigationPage page) {
    switch (page) {
      case NavigationPage.qag:
        return AgoraBottomNavigationBarItem(
          activateIcon: "ic_question.svg",
          inactivateIcon: "ic_question_inactivate.svg",
          label: "Questions",
        );
      case NavigationPage.reponse:
        return AgoraBottomNavigationBarItem(
          activateIcon: "ic_reponse.svg",
          inactivateIcon: "ic_reponse_inactivate.svg",
          label: "Réponses",
        );
      case NavigationPage.consultation:
        return AgoraBottomNavigationBarItem(
          activateIcon: "ic_consultation.svg",
          inactivateIcon: "ic_consultation_inactivate.svg",
          label: "Consultations",
        );
      case NavigationPage.profil:
        return AgoraBottomNavigationBarItem(
          activateIcon: "ic_consultation.svg",
          inactivateIcon: "ic_consultation_inactivate.svg",
          label: "Profil",
        );
    }
  }
}

class _Content extends StatelessWidget {
  final NavigationPage currentPage;

  const _Content(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return switch (currentPage) {
      NavigationPage.qag => QagsPage(),
      NavigationPage.reponse => ReponsesPage(),
      NavigationPage.consultation => ConsultationsPage(),
      NavigationPage.profil => ProfilPage(),
    };
  }
}
