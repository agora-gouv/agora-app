import 'package:agora/design/custom_view/bottom_navigation_bar/agora_bottom_navigation_bar.dart';
import 'package:agora/design/custom_view/bottom_navigation_bar/agora_bottom_navigation_bar_item.dart';
import 'package:agora/pages/consultation/consultations_page.dart';
import 'package:agora/pages/qag/qag_page.dart';
import 'package:flutter/material.dart';

enum MainBottomNavigationPages { consultation, qag }

class MainBottomNavigationPage extends StatelessWidget {
  final MainBottomNavigationPages startPage;

  const MainBottomNavigationPage({Key? key, required this.startPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = [
      MainBottomNavigationPages.consultation,
      MainBottomNavigationPages.qag,
    ];
    return MainBottomNavigationContent(
      pages: pages,
      firstDisplayedPageIndex: pages.indexWhere((page) => page == startPage),
    );
  }
}

class MainBottomNavigationContent extends StatefulWidget {
  final List<MainBottomNavigationPages> pages;
  final int firstDisplayedPageIndex;

  MainBottomNavigationContent({super.key, required this.pages, required this.firstDisplayedPageIndex});

  @override
  State<MainBottomNavigationContent> createState() => _MainBottomNavigationContentState();
}

class _MainBottomNavigationContentState extends State<MainBottomNavigationContent> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.firstDisplayedPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AgoraBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (newIndex) => setState(() => _currentIndex = newIndex),
        items: widget.pages.map((page) => _getBottomNavigationBarItem(page)).toList(),
      ),
      body: _getDisplayedPage(),
    );
  }

  AgoraBottomNavigationBarItem _getBottomNavigationBarItem(MainBottomNavigationPages page) {
    switch (page) {
      case MainBottomNavigationPages.consultation:
        return AgoraBottomNavigationBarItem(
          icon: "ic_consultation.svg",
          label: "Consultations",
        );
      case MainBottomNavigationPages.qag:
        return AgoraBottomNavigationBarItem(
          icon: "ic_question.svg",
          label: "Questions citoyennes",
        );
    }
  }

  Widget _getDisplayedPage() {
    switch (widget.pages[_currentIndex]) {
      case MainBottomNavigationPages.consultation:
        return ConsultationsPage();
      case MainBottomNavigationPages.qag:
        return QagPage();
    }
  }
}
