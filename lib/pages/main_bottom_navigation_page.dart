import 'package:agora/common/manager/helper_manager.dart';
import 'package:agora/design/custom_view/agora_responsive_view.dart';
import 'package:agora/design/custom_view/bottom_navigation_bar/agora_bottom_navigation_bar.dart';
import 'package:agora/design/custom_view/bottom_navigation_bar/agora_bottom_navigation_bar_item.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/consultation/pages/consultations_page.dart';
import 'package:agora/pages/qag/qags_page.dart';
import 'package:agora/reponse/pages/reponses_page.dart';
import 'package:flutter/material.dart';

enum MainBottomNavigationPages { consultation, reponse, qag }

class MainBottomNavigationPage extends StatefulWidget {
  final MainBottomNavigationPages startPage;

  MainBottomNavigationPage({super.key, required this.startPage});

  @override
  State<MainBottomNavigationPage> createState() => _MainBottomNavigationPageState();
}

class _MainBottomNavigationPageState extends State<MainBottomNavigationPage> {
  final List<MainBottomNavigationPages> pages = [
    MainBottomNavigationPages.qag,
    MainBottomNavigationPages.reponse,
    MainBottomNavigationPages.consultation,
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
      body: _getDisplayedPage(),
    );
  }

  AgoraBottomNavigationBarItem _getBottomNavigationBarItem(MainBottomNavigationPages page) {
    switch (page) {
      case MainBottomNavigationPages.qag:
        return AgoraBottomNavigationBarItem(
          activateIcon: "ic_question.svg",
          inactivateIcon: "ic_question_inactivate.svg",
          label: "Questions",
        );
      case MainBottomNavigationPages.reponse:
        return AgoraBottomNavigationBarItem(
          activateIcon: "ic_reponse.svg",
          inactivateIcon: "ic_reponse_inactivate.svg",
          label: "Réponses",
        );
      case MainBottomNavigationPages.consultation:
        return AgoraBottomNavigationBarItem(
          activateIcon: "ic_consultation.svg",
          inactivateIcon: "ic_consultation_inactivate.svg",
          label: "Consultations",
        );
    }
  }

  Widget _getDisplayedPage() {
    switch (pages[_currentIndex]) {
      case MainBottomNavigationPages.qag:
        return QagsPage();
      case MainBottomNavigationPages.reponse:
        return ReponsesPage();
      case MainBottomNavigationPages.consultation:
        return ConsultationsPage();
    }
  }
}
