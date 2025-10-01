import 'package:app_lab/common/go_back_button.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class ActivityFourPage extends StatelessWidget {

  const ActivityFourPage({
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
        title: Text("Activity 4"),
        backgroundColor: ColorPalette.page4,
        leading: Icon(Icons.compass_calibration_rounded),
        foregroundColor: ColorPalette.textLight,
        leadingWidth: 100,
      ),
      body: SizedBox(
        width: width,
        height: height,
        //color: ColorPalette.backgroundDark,
        child: Center(
          child: GoBackButton(
            color: ColorPalette.page4,
            text: "Go back home",
          ),
        ),
      ),
    );
  }
}
