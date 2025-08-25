import 'package:app_lab/components/go_back_button_widget.dart';
import 'package:flutter/material.dart';

class OSDevelopmentPage extends StatelessWidget {

  const OSDevelopmentPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("OS Development"),
        backgroundColor: Color(0xffCC2412),
        leading: Icon(Icons.adf_scanner_rounded),
        foregroundColor: Color(0xffFBF1C7),
        leadingWidth: 100,
      ),
      body: Container(
        width: width,
        height: height,
        color: Color(0xff282828),
        child: Center(
          child: GoBackButton(
            color: Color(0xffCC2412),
            text: "Go back home",
          ),
        ),
      ),
    );
  }
}
