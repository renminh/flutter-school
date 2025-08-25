import 'package:app_lab/components/go_back_button_widget.dart';
import 'package:flutter/material.dart';

/* 
 * this level of abstraction might actually be too much and bad as ideally it would be better
 * to just create seperate pages and create a widget for the base that is extended for those pages
 * unlike creating this page that creates it for me
 */

class ActivityPageRoute extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Color buttonColor;
  final String buttonText;

  const ActivityPageRoute({
    super.key,
    required this.appBar,
    required this.buttonColor,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: GoBackButton(
          color: buttonColor,
          text: buttonText,
        ),
      ),
    );
  }
}
