import 'package:app_lab/widgets/go_back_button.dart';
import 'package:flutter/material.dart';
import '../constants/theme.dart';

class ActivityTwoPage extends StatelessWidget {

  const ActivityTwoPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;

    return Scaffold(
      backgroundColor: ColorPalette.backgroundDark,
      appBar: AppBar(
        title: Text("Activity 2"),
        backgroundColor: ColorPalette.page2,
        leading: Icon(Icons.account_circle_rounded),
        foregroundColor: ColorPalette.textLight,
        leadingWidth: 100,
      ),
      body: Container(
        width: width,
        height: height,
        //color: ColorPalette.backgroundDark,
        child: Center(
          child: GoBackButton(
            color: ColorPalette.page2,
            text: "Go back home",
          ),
        ),
      ),
    );
  }
}
