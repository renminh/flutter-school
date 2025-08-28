import 'package:app_lab/components/go_back_button_widget.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text("Activity 4"),
        backgroundColor: Color(0xff98971A),
        leading: Icon(Icons.compass_calibration_rounded),
        foregroundColor: Color(0xffFBF1C7),
        leadingWidth: 100,
      ),
      body: Container(
        width: width,
        height: height,
        color: Color(0xff282828),
        child: Center(
          child: GoBackButton(
            color: Color(0xff98971A),
            text: "Go back home",
          ),
        ),
      ),
    );
  }
}
