import 'dart:ui' show lerpDouble;

import 'package:agora/design/custom_view/bottom_navigation_bar/agora_bottom_navigation_bar_item.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_spacings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgoraBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AgoraBottomNavigationBarItem> items;

  AgoraBottomNavigationBar({
    Key? key,
    this.currentIndex = 0,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  State createState() => _AgoraBottomNavigationBarState();
}

class _AgoraBottomNavigationBarState extends State<AgoraBottomNavigationBar> {
  final double _bottomBarHeight = 60;
  final double _indicatorHeight = 2;

  final Color _activeLabelColor = AgoraColors.primaryGrey;
  final Color _inactiveLabelColor = AgoraColors.primaryGreyOpacity80;
  final Color _activeBgColor = AgoraColors.white;
  final Color _inactiveBgColor = AgoraColors.background;
  final Color _activeIndicatorColor = AgoraColors.blueFrance;
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
      height: _bottomBarHeight + MediaQuery.of(context).viewPadding.bottom,
      width: _width,
      decoration: BoxDecoration(color: _inactiveIndicatorColor),
      child: Stack(
        children: [
          Positioned(
            top: _indicatorHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _items.map((item) {
                final onTapIndex = _items.indexOf(item);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentSelectedIndex = onTapIndex;
                      widget.onTap(_currentSelectedIndex);
                    });
                  },
                  child: _buildItemWidget(onTapIndex, item),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
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
    return Container(
      color: selectedIndex == _currentSelectedIndex ? _activeBgColor : _inactiveBgColor,
      height: _bottomBarHeight,
      width: _width / _items.length,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _setIcon(selectedIndex, item),
          SizedBox(width: AgoraSpacings.x0_25),
          _setLabel(selectedIndex, item),
        ],
      ),
    );
  }

  Widget _setIcon(int index, AgoraBottomNavigationBarItem item) {
    return SvgPicture.asset(height: 20, width: 20, "assets/${item.icon}");
  }

  Widget _setLabel(int selectedIndex, AgoraBottomNavigationBarItem item) {
    return Text(
      item.label,
      textAlign: TextAlign.center,
      style: selectedIndex == _currentSelectedIndex
          ? AgoraTextStyles.medium12.copyWith(color: _activeLabelColor)
          : AgoraTextStyles.medium12.copyWith(color: _inactiveLabelColor),
    );
  }
}
