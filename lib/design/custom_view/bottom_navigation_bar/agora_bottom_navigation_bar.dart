import 'dart:io';
import 'dart:ui' show lerpDouble;

import 'package:agora/design/custom_view/bottom_navigation_bar/agora_bottom_navigation_bar_item.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AgoraBottomNavigationBarItem> items;

  AgoraBottomNavigationBar({
    super.key,
    this.currentIndex = 0,
    required this.onTap,
    required this.items,
  });

  @override
  State createState() => _AgoraBottomNavigationBarState();
}

class _AgoraBottomNavigationBarState extends State<AgoraBottomNavigationBar> {
  final double _webBottomBarHeight = 60;
  final double _indicatorHeight = 3;

  final Color _activeLabelColor = AgoraColors.primaryBlue;
  final Color _inactiveLabelColor = AgoraColors.primaryGreyOpacity80;
  final Color _activeIndicatorColor = AgoraColors.primaryBlue;
  final Color _inactiveIndicatorColor = AgoraColors.superSilver;

  final Duration _duration = Duration(milliseconds: 170);

  List<AgoraBottomNavigationBarItem> get _items => widget.items;
  double _width = 0;
  int _currentSelectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentSelectedIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    return Container(
      height: kIsWeb ? _webBottomBarHeight : null,
      width: _width,
      decoration: BoxDecoration(
        color: _inactiveIndicatorColor,
        boxShadow: [BoxShadow(color: AgoraColors.blur, blurRadius: 25, spreadRadius: 25)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _width,
            child: AnimatedAlign(
              alignment: Alignment(_getIndicatorPosition(_currentSelectedIndex)!, 0),
              curve: Curves.linear,
              duration: _duration,
              child: Container(
                color: _activeIndicatorColor,
                width: _width / _items.length,
                height: _indicatorHeight,
              ),
            ),
          ),
          Material(
            color: AgoraColors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _items.map((item) {
                final onTapIndex = _items.indexOf(item);
                return InkWell(
                  onTap: () {
                    setState(() {
                      _currentSelectedIndex = onTapIndex;
                      widget.onTap(_currentSelectedIndex);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AgoraSpacings.base),
                    child: _buildItemWidget(onTapIndex, item),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  double? _getIndicatorPosition(int index) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    if (isLtr) {
      return lerpDouble(-1.0, 1.0, index / (_items.length - 1));
    } else {
      return lerpDouble(1.0, -1.0, index / (_items.length - 1));
    }
  }

  Widget _buildItemWidget(int selectedIndex, AgoraBottomNavigationBarItem item) {
    return Semantics(
      selected: selectedIndex == _currentSelectedIndex,
      label: 'Onglet ${selectedIndex + 1} sur 2',
      button: true,
      child: SizedBox(
        height: kIsWeb ? _webBottomBarHeight : null,
        width: _width / _items.length,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _setIcon(selectedIndex, item),
            _setLabel(selectedIndex, item),
            if (Platform.isIOS) const SizedBox(height: AgoraSpacings.x0_75),
          ],
        ),
      ),
    );
  }

  Widget _setIcon(int selectedIndex, AgoraBottomNavigationBarItem item) {
    return selectedIndex == _currentSelectedIndex
        ? SvgPicture.asset(height: 20, width: 20, "assets/${item.activateIcon}", excludeFromSemantics: true)
        : SvgPicture.asset(height: 20, width: 20, "assets/${item.inactivateIcon}", excludeFromSemantics: true);
  }

  Widget _setLabel(int selectedIndex, AgoraBottomNavigationBarItem item) {
    return Text(
      item.label,
      textAlign: TextAlign.center,
      style: selectedIndex == _currentSelectedIndex
          ? AgoraTextStyles.medium13.copyWith(color: _activeLabelColor)
          : AgoraTextStyles.medium13.copyWith(color: _inactiveLabelColor),
    );
  }
}
