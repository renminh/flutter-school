import 'package:app_lab/components/go_back_button_widget.dart';
import 'package:flutter/material.dart';

class ActivityOnePage extends StatelessWidget {

  const ActivityOnePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Activity 1"),
        backgroundColor: Color(0xff458588),
        leading: Icon(Icons.computer_rounded),
        foregroundColor: Color(0xffFBF1C7),
        leadingWidth: 100,
      ),
      body: Container(
        width: width,
        height: height,
        color: Color(0xff282828),
        child: Center(
          child: GoBackButton(
            color: Color(0xff458588),
            text: "Go back home",
          ),
        ),
      ),
    );
  }
}
