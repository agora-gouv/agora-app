import 'dart:math';

import 'package:agora/common/strings/generic_strings.dart';
import 'package:agora/design/style/agora_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimSearchBar extends StatefulWidget {
  final double width;
  final double height;
  final TextEditingController textController;
  final String helpText;
  final int animationDurationInMilli;
  final Function() onClose;
  final bool autoFocus;
  final TextStyle? style;
  final bool closeSearchOnSuffixTap;
  final Color? color;
  final Color? textFieldColor;
  final Color? searchIconColor;
  final Color? textFieldIconColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool isSearchBarDisplayed;
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;
  final Function(bool) searchBarOpen;
  final Function() onClearText;

  const AnimSearchBar({
    super.key,
    required this.width,
    required this.searchBarOpen,
    required this.textController,
    required this.helpText,
    this.height = 100,
    this.color = Colors.white,
    this.textFieldColor = Colors.white,
    this.searchIconColor = Colors.black,
    this.textFieldIconColor = Colors.black,
    this.textInputAction = TextInputAction.done,
    required this.onClose,
    required this.onClearText,
    this.animationDurationInMilli = 375,
    required this.onSubmitted,
    this.autoFocus = false,
    this.style,
    this.closeSearchOnSuffixTap = false,
    this.isSearchBarDisplayed = false,
    this.inputFormatters,
  });

  @override
  AnimSearchBarState createState() => AnimSearchBarState();
}

class AnimSearchBarState extends State<AnimSearchBar> with SingleTickerProviderStateMixin {
  ///toggle - 0 => false or closed
  ///toggle 1 => true or open
  int toggle = 0;

  ///use this variable to check current text from OnChange
  String textFieldValue = '';

  ///initializing the AnimationController
  late AnimationController _controller;
  FocusNode keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    ///Initializing the animationController which is responsible for the expanding and shrinking of the search bar
    _controller = AnimationController(
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
      alignment: Alignment(-1.0, 0.0),

      ///Using Animated container to expand and shrink the widget
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.animationDurationInMilli),
        height: widget.height,
        width: (toggle == 0) ? 48.0 : widget.width,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          /// can add custom  color or the color will be white
          color: toggle == 1 ? widget.textFieldColor : widget.color,
        ),
        child: Stack(
          children: [
            ///Using Animated Positioned widget to expand and shrink the widget
            AnimatedPositioned(
              duration: Duration(milliseconds: widget.animationDurationInMilli),
              right: 6.0,
              curve: Curves.easeOut,
              child: AnimatedOpacity(
                opacity: (toggle == 0) ? 0.0 : 1.0,
                duration: Duration(milliseconds: 200),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: AnimatedBuilder(
                      builder: (context, widget) {
                        ///Using Transform.rotate to rotate the suffix icon when it gets expanded
                        return Transform.rotate(
                          angle: _controller.value * 2.0 * pi,
                          child: widget,
                        );
                      },
                      animation: _controller,
                      child: Material(
                        color: toggle == 0 ? widget.color : widget.textFieldColor,
                        child: Focus(
                          canRequestFocus: false,
                          descendantsAreFocusable: widget.isSearchBarDisplayed,
                          child: IconButton(
                            constraints: BoxConstraints(minHeight: 48, minWidth: 48),
                            splashRadius: 19.0,
                            icon: Semantics(
                              button: true,
                              label: textFieldValue.isNotEmpty
                                  ? GenericStrings.searchBarDelete
                                  : GenericStrings.searchBarClose,
                              child: Icon(
                                semanticLabel: "",
                                Icons.close,
                                size: 22.0,
                                color: widget.textFieldIconColor,
                              ),
                            ),
                            onPressed: () {
                              try {
                                /// if field empty then the user trying to close bar
                                if (textFieldValue == '') {
                                  widget.onClose();
                                  unFocusKeyboard();
                                  setState(() {
                                    toggle = 0;
                                  });

                                  ///reverse == close
                                  _controller.reverse();
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
                                if (kDebugMode) {
                                  print(e);
                                }
                              }
                            },
                          ),
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
                    child: Focus(
                      canRequestFocus: false,
                      descendantsAreFocusable: widget.isSearchBarDisplayed,
                      child: TextField(
                        ///Text Controller. you can manipulate the text inside this textField by calling this controller.
                        controller: widget.textController,
                        inputFormatters: widget.inputFormatters,
                        focusNode: keyboardFocusNode,
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
            ),

            ///Using material widget here to get the ripple effect on the prefix icon
            Material(
              /// can add custom color or the color will be white
              /// toggle button color based on toggle state
              color: toggle == 0 ? widget.color : widget.textFieldColor,
              child: IconButton(
                constraints: BoxConstraints(minHeight: 48, minWidth: 48),
                splashRadius: 19.0,

                ///if toggle is 1, which means it's open. so show the back icon, which will close it.
                ///if the toggle is 0, which means it's closed, so tapping on it will expand the widget.
                ///prefixIcon is of type Icon
                icon: Semantics(
                  button: true,
                  label: toggle == 1 ? GenericStrings.searchBarClose : GenericStrings.searchBarOpen,
                  child: Icon(
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
                            FocusScope.of(context).requestFocus(keyboardFocusNode);
                          }
                        });

                        ///forward == expand
                        _controller.forward();
                      } else {
                        ///if the search bar is expanded
                        toggle = 0;

                        ///if the autoFocus is true, the keyboard will close, automatically
                        setState(() {
                          if (widget.autoFocus) unFocusKeyboard();
                        });

                        widget.onClose();

                        ///reverse == close
                        _controller.reverse();
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
