import 'package:flutter/material.dart';
import '../constants/theme.dart';

class GoBackButton extends StatelessWidget {
  final Color color;
  final String text;

  const GoBackButton({
    super.key,
    required this.color, 
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    /* 
     * In order to adjust the size of buttons, there must be a parent
     * widget that can hold it, i'm using SizedBox as the child is forced
     * to have its specific height and width constraints
     * https://api.flutter.dev/flutter/widgets/SizedBox-class.html
     * 
     * SizedBox.expand constructor can be used to fit the child to the parent
     * 
     * and for styling an TextButton widget
     * https://api.flutter.dev/flutter/material/TextButton-class.html
     */
    return SizedBox(
      height: 200.0,
      width: 200.0,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(
              Radius.elliptical(10, 10)
            )
          ),
        ),
        onPressed: () { Navigator.pop(context); }, 
        child: Text(
          text,
          style: TextStyle(color: ColorPalette.textLight)
        ),
      ),
    );
  }
}