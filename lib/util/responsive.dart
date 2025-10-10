import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const double MOBILE_WIDTH_MAX = 600;
// ignore: constant_identifier_names
const double TABLET_WIDTH_MAX = 1024;

/* thanks to khokar for the inspiration :)
 * https://medium.com/@ashfaque-khokhar/best-way-to-use-mediaquery-in-flutter-with-step-by-step-guide-864adae7bd49 */
class Responsive {
	final BuildContext context;

	late double screenWidth;
	late double screenHeight;
	late double percentHeight;
	late double percentWidth;
	Responsive(this.context) {
		screenWidth		= MediaQuery.of(context).size.width;
		screenHeight	= MediaQuery.of(context).size.height;
		percentWidth	= screenWidth / 100;
		percentHeight	= screenHeight / 100;
	}

	bool isMobile() => screenWidth <= MOBILE_WIDTH_MAX;
	bool isTablet() => screenWidth <= TABLET_WIDTH_MAX && screenWidth > MOBILE_WIDTH_MAX;
	bool isDesktop() => screenWidth >= TABLET_WIDTH_MAX;

	double ph(double percent) => percentHeight * percent;
	double pw(double percent) => percentWidth * percent;
}
