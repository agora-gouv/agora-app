import 'package:agora/common/analytics/analytics_event_names.dart';
import 'package:agora/common/analytics/analytics_screen_names.dart';
import 'package:agora/common/helper/tracker_helper.dart';
import 'package:agora/common/strings/profile_strings.dart';
import 'package:agora/design/custom_view/agora_rounded_card.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';

class AgoraNotificationCard extends StatelessWidget {
  final String title;
  final String type;
  final String date;

  AgoraNotificationCard({
    required this.title,
    required this.type,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    TrackerHelper.trackEvent(
      eventName: AnalyticsEventNames.notificationEvent,
      widgetName: AnalyticsScreenNames.notificationCenterPage,
    );
    return AgoraRoundedCard(
      borderColor: AgoraColors.border,
      padding: EdgeInsets.symmetric(vertical: AgoraSpacings.base, horizontal: AgoraSpacings.base),
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: double.infinity),
          Text(title, style: AgoraTextStyles.light15),
          SizedBox(height: AgoraSpacings.base),
          RichText(
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            text: TextSpan(
              style: AgoraTextStyles.medium13.copyWith(color: AgoraColors.primaryGrey),
              children: [
                TextSpan(text: ProfileStrings.inType),
                TextSpan(text: type, style: AgoraTextStyles.medium13.copyWith(color: AgoraColors.primaryBlue)),
                TextSpan(text: ProfileStrings.byDate),
                TextSpan(text: date, style: AgoraTextStyles.medium13.copyWith(color: AgoraColors.primaryBlue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
