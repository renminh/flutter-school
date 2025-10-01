import 'package:flutter/material.dart';
import '../theme/dark.dart';

class ActivityButton extends StatelessWidget {
  final Widget destinationRoute;
  final String text;
  final String description;

  const ActivityButton({
    super.key,
    required this.destinationRoute,
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      width: 50.0,

      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.all(
              Radius.elliptical(10, 10)
            )
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => destinationRoute,
            ),
          );
        },

        child: _ActivityButtonContent(
          text: text,
          description: description
        )
      ),
    );
  }
}

/*
 * i don't wanna expose this anywhere else so it's private
 * https://www.geeksforgeeks.org/dart/how-to-create-private-class-in-dart/
 */
class _ActivityButtonContent extends StatelessWidget {
  final String text;
  final String description;

  const _ActivityButtonContent({
    required this.text,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    /* https://api.flutter.dev/flutter/widgets/Align-class.html */
    return Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
			text,
			style: TextStyle(fontSize: 20, color: Colors.white)
			),
          Text(
            description,
            style: TextStyle(
              color: Color.fromARGB(255, 174, 168, 162),
              fontSize: 13,
            )
          )
        ],
      ),
    );
  }
}
