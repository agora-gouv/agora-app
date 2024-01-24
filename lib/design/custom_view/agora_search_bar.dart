import 'dart:math';

import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/style/agora_colors.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Widget forked from https://github.com/Imgkl/anim_search_bar/

class AnimSearchBar extends StatefulWidget {
  ///  width - double ,isRequired : Yes
  ///  textController - TextEditingController  ,isRequired : Yes
  ///  onSuffixTap - Function, isRequired : Yes
  ///  onSubmitted - Function, isRequired : Yes
  ///  rtl - Boolean, isRequired : No
  ///  autoFocus - Boolean, isRequired : No
  ///  style - TextStyle, isRequired : No
  ///  closeSearchOnSuffixTap - bool , isRequired : No
  ///  suffixIcon - Icon ,isRequired :  No
  ///  prefixIcon - Icon  ,isRequired : No
  ///  animationDurationInMilli -  int ,isRequired : No
  ///  helpText - String ,isRequired :  No
  ///  inputFormatters - TextInputFormatter, Required - No
  ///  boxShadow - bool ,isRequired : No
  ///  textFieldColor - Color ,isRequired : No
  ///  searchIconColor - Color ,isRequired : No
  ///  textFieldIconColor - Color ,isRequired : No
  ///  textInputAction  -TextInputAction, isRequired : No

  final double width;
  final double height;
  final TextEditingController textController;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final String helpText;
  final int animationDurationInMilli;
  final Function() onClose;
  final bool rtl;
  final bool autoFocus;
  final TextStyle? style;
  final bool closeSearchOnSuffixTap;
  final Color? color;
  final Color? textFieldColor;
  final Color? searchIconColor;
  final Color? textFieldIconColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool boxShadow;
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;
  final Function(bool) searchBarOpen;
  final Function() onClearText;

  const AnimSearchBar({
    super.key,

    /// The width cannot be null
    required this.width,
    required this.searchBarOpen,

    /// The textController cannot be null
    required this.textController,
    this.suffixIcon,
    this.prefixIcon,
    this.helpText = "Search...",

    /// Height of wrapper container
    this.height = 100,

    /// choose your custom color
    this.color = Colors.white,

    /// choose your custom color for the search when it is expanded
    this.textFieldColor = Colors.white,

    /// choose your custom color for the search when it is expanded
    this.searchIconColor = Colors.black,

    /// choose your custom color for the search when it is expanded
    this.textFieldIconColor = Colors.black,
    this.textInputAction = TextInputAction.done,
    required this.onClose,
    required this.onClearText,
    this.animationDurationInMilli = 375,

    /// The onSubmitted cannot be null
    required this.onSubmitted,

    /// make the search bar to open from right to left
    this.rtl = false,

    /// make the keyboard to show automatically when the searchbar is expanded
    this.autoFocus = false,

    /// TextStyle of the contents inside the searchbar
    this.style,

    /// close the search on suffix tap
    this.closeSearchOnSuffixTap = false,

    /// enable/disable the box shadow decoration
    this.boxShadow = true,

    /// can add list of inputformatters to control the input
    this.inputFormatters,
  });

  @override
  AnimSearchBarState createState() => AnimSearchBarState();
}

class AnimSearchBarState extends State<AnimSearchBar> with SingleTickerProviderStateMixin {
  ///toggle - 0 => false or closed
  ///toggle 1 => true or open
  int toggle = 0;

  /// * use this variable to check current text from OnChange
  String textFieldValue = '';

  ///initializing the AnimationController
  late AnimationController _con;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    ///Initializing the animationController which is responsible for the expanding and shrinking of the search bar
    _con = AnimationController(
      vsync: this,

      /// animationDurationInMilli is optional, the default value is 375
      duration: Duration(milliseconds: widget.animationDurationInMilli),
    );
  }

  void unFocusKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,

      ///if the rtl is true, search bar will be from right to left
      alignment: widget.rtl ? Alignment.centerRight : Alignment(-1.0, 0.0),

      ///Using Animated container to expand and shrink the widget
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.animationDurationInMilli),
        height: widget.height,
        width: (toggle == 0) ? 48.0 : widget.width,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          /// can add custom  color or the color will be white
          color: toggle == 1 ? widget.textFieldColor : widget.color,

          /// show boxShadow unless false was passed
          boxShadow: !widget.boxShadow
              ? null
              : [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: -10.0,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
        ),
        child: Stack(
          children: [
            ///Using Animated Positioned widget to expand and shrink the widget
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              top: 2.0,
              right: 6.0,
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    /// can add custom color or the color will be white
                    color: widget.color,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: AnimatedBuilder(
                    builder: (context, widget) {
                      ///Using Transform.rotate to rotate the suffix icon when it gets expanded
                      return Transform.rotate(
                        angle: _con.value * 2.0 * pi,
                        child: widget,
                      );
                    },
                    animation: _con,
                    child: GestureDetector(
                      onTap: () {
                        try {
                          // * if field empty then the user trying to close bar
                          if (textFieldValue == '') {
                            widget.onClose();
                            unFocusKeyboard();
                            setState(() {
                              toggle = 0;
                            });

                            ///reverse == close
                            _con.reverse();
                          } else {
                            widget.textController.clear();
                            setState(() {
                              textFieldValue = '';
                            });
                            widget.onClearText();
                          }

                          ///closeSearchOnSuffixTap will execute if it's true
                          if (widget.closeSearchOnSuffixTap) {
                            unFocusKeyboard();
                            setState(() {
                              toggle = 0;
                            });
                          }
                        } catch (e) {
                          ///print the error if the try block fails
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      },

                      ///suffixIcon is of type Icon
                      child: Semantics(
                        button: true,
                        label:
                            textFieldValue.isNotEmpty ? GenericStrings.searchBarDelete : GenericStrings.searchBarClose,
                        child: widget.suffixIcon ??
                            Icon(
                              semanticLabel: "",
                              Icons.close,
                              size: 22.0,
                              color: AgoraColors.primaryBlue,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              left: (toggle == 0) ? 20.0 : 40.0,
              curve: Curves.easeOut,
              top: 9.0,

              ///Using Animated opacity to change the opacity of th textField while expanding
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.topCenter,
                  width: widget.width / 1.7,
                  child: Semantics(
                    label: 'Recherche',
                    child: TextField(
                      ///Text Controller. you can manipulate the text inside this textField by calling this controller.
                      controller: widget.textController,
                      inputFormatters: widget.inputFormatters,
                      focusNode: focusNode,
                      textInputAction: widget.textInputAction,
                      cursorRadius: Radius.circular(10.0),
                      cursorWidth: 2.0,
                      onChanged: (value) {
                        setState(() {
                          textFieldValue = value;
                        });
                      },
                      onSubmitted: (value) => {
                        widget.onSubmitted(value),
                        setState(() {
                          textFieldValue = value;
                        }),
                        unFocusKeyboard(),
                      },
                      onEditingComplete: () {
                        /// on editing complete the keyboard will be closed and the search bar will be closed
                        unFocusKeyboard();
                      },

                      ///style is of type TextStyle, the default is just a color black
                      style: widget.style ?? TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 5),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: widget.helpText,
                        labelStyle: AgoraTextStyles.light14,
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///Using material widget here to get the ripple effect on the prefix icon
            Material(
              /// can add custom color or the color will be white
              /// toggle button color based on toggle state
              color: toggle == 0 ? widget.color : widget.textFieldColor,
              child: IconButton(
                splashRadius: 19.0,

                ///if toggle is 1, wxhich means it's open. so show the back icon, which will close it.
                ///if the toggle is 0, which means it's closed, so tapping on it will expand the widget.
                ///prefixIcon is of type Icon
                icon: Semantics(
                  button: true,
                  label: toggle == 1 ? GenericStrings.searchBarClose : GenericStrings.searchBarOpen,
                  child: widget.prefixIcon != null
                      ? toggle == 1
                          ? Icon(
                              Icons.arrow_back_ios,
                              color: widget.textFieldIconColor,
                            )
                          : widget.prefixIcon!
                      : Icon(
                          toggle == 1 ? Icons.arrow_back_ios : Icons.search,
                          // search icon color when closed
                          color: toggle == 0 ? widget.searchIconColor : widget.textFieldIconColor,
                          size: 22.0,
                        ),
                ),
                onPressed: () {
                  setState(
                    () {
                      ///if the search bar is closed
                      if (toggle == 0) {
                        toggle = 1;
                        setState(() {
                          ///if the autoFocus is true, the keyboard will pop open, automatically
                          if (widget.autoFocus) {
                            FocusScope.of(context).requestFocus(focusNode);
                          }
                        });

                        ///forward == expand
                        _con.forward();
                      } else {
                        ///if the search bar is expanded
                        toggle = 0;

                        ///if the autoFocus is true, the keyboard will close, automatically
                        setState(() {
                          if (widget.autoFocus) unFocusKeyboard();
                        });

                        widget.onClose();

                        ///reverse == close
                        _con.reverse();
                      }
                    },
                  );
                  widget.searchBarOpen(toggle == 1);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
