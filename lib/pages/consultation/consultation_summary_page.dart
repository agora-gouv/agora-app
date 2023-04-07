import 'package:agora/design/agora_button.dart';
import 'package:agora/design/agora_button_style.dart';
import 'package:agora/design/agora_colors.dart';
import 'package:agora/design/agora_text_styles.dart';
import 'package:agora/design/custom_view/agora_app_bar_with_tabs.dart';
import 'package:agora/design/custom_view/agora_scaffold.dart';
import 'package:agora/pages/loading_page.dart';
import 'package:flutter/material.dart';

class ConsultationSummaryPage extends StatefulWidget {
  static const routeName = "/consultationSummaryPage";

  @override
  State<ConsultationSummaryPage> createState() => _ConsultationSummaryPageState();
}

class _ConsultationSummaryPageState extends State<ConsultationSummaryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AgoraScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            AgoraAppBarWithTabs(
              tabController: _tabController,
              needTopDiagonal: false,
              needToolbar: true,
              topChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Développer le covoiturage au quotidien",
                    style: AgoraTextStyles.medium20.copyWith(color: AgoraColors.primaryGreen),
                  ),
                ],
              ),
              tabChild: [
                Tab(text: "Résultats"),
                Tab(text: "Et ensuite ?"),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        AgoraButton(
                          label: "Revenir au menu",
                          style: AgoraButtonStyle.primaryButtonStyle,
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              LoadingPage.routeName,
                              (route) => false,
                            );
                          },
                        ),
                      ],
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
