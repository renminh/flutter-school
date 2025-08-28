import 'package:app_lab/components/go_back_button_widget.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text("Activity 2"),
        backgroundColor: Color(0xffD79921),
        leading: Icon(Icons.account_circle_rounded),
        foregroundColor: Color(0xffFBF1C7),
        leadingWidth: 100,
      ),
      body: Container(
        width: width,
        height: height,
        color: Color(0xff282828),
        child: Center(
          child: GoBackButton(
            color: Color(0xffD79921),
            text: "Go back home",
          ),
        ),
      ),
    );
  }
}
