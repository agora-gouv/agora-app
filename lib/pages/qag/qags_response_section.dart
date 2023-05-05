import 'package:agora/bloc/qag/qag_view_model.dart';
import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/common/strings/qag_strings.dart';
import 'package:agora/design/custom_view/agora_alert_dialog.dart';
import 'package:agora/design/custom_view/agora_qag_response_card.dart';
import 'package:agora/design/custom_view/agora_title_rich_text.dart';
import 'package:agora/design/custom_view/button/agora_rounded_button.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/pages/qag/details/qag_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QagsResponseSection extends StatelessWidget {
  final List<QagResponseViewModel> qagResponseViewModels;

  const QagsResponseSection({super.key, required this.qagResponseViewModels});

  @override
  Widget build(BuildContext context) {
    if (qagResponseViewModels.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.only(
          left: AgoraSpacings.horizontalPadding,
          top: AgoraSpacings.base,
          right: AgoraSpacings.horizontalPadding,
        ),
        child: Column(
          children: [
            _buildQagResponseHeader(context),
            SizedBox(height: AgoraSpacings.x0_75),
            LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraint.maxWidth),
                    child: IntrinsicHeight(
                      // IntrinsicHeight : make all card same height
                      child: Row(children: _buildQagResponseCard(context, qagResponseViewModels)),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildQagResponseHeader(BuildContext context) {
    return Row(
      children: [
        AgoraRichText(
          items: [
            AgoraRichTextTextItem(text: "${QagStrings.qagResponsePart1}\n", style: AgoraRichTextItemStyle.bold),
            AgoraRichTextTextItem(text: QagStrings.qagResponsePart2, style: AgoraRichTextItemStyle.regular),
          ],
        ),
        SizedBox(width: AgoraSpacings.x0_75),
        GestureDetector(
          child: SvgPicture.asset("assets/ic_info.svg"),
          onTap: () {
            showAgoraDialog(
              context: context,
              dismissible: true,
              columnChildren: [Text("A faire")],
            );
          },
        ),
        Spacer(),
        AgoraRoundedButton(
          label: GenericStrings.all,
          style: AgoraRoundedButtonStyle.whiteButton,
          onPressed: () {
            // TODO
          },
        ),
      ],
    );
  }

  List<Widget> _buildQagResponseCard(BuildContext context, List<QagResponseViewModel> qagResponses) {
    final List<Widget> qagWidget = List.empty(growable: true);
    for (final qagResponse in qagResponses) {
      qagWidget.add(
        AgoraQagResponseCard(
          thematique: qagResponse.thematique,
          title: qagResponse.title,
          authorImageUrl: qagResponse.authorPortraitUrl,
          author: qagResponse.author,
          date: qagResponse.responseDate,
          onClick: () {
            Navigator.pushNamed(
              context,
              QagDetailsPage.routeName,
              arguments: QagDetailsArguments(qagId: qagResponse.qagId),
            );
          },
        ),
      );
      qagWidget.add(SizedBox(width: AgoraSpacings.x0_5));
    }
    return qagWidget;
  }
}
