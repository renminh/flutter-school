import 'package:flutter/material.dart';
import '../util/responsive.dart';

class ActivityCard extends StatelessWidget {
	final String iconPath;
	final Color color;
	final String? cardHeader;
	final String? cardDescription;
	final VoidCallback? onTap;

	const ActivityCard({
		super.key,
		required this.iconPath,
		required this.color,
		this.cardHeader,
		this.cardDescription,
		this.onTap
	});

	@override
	Widget build(BuildContext context)
	{
		return InkWell(
			onTap: onTap,
			child: Card(
				color: color,
				elevation: 4,
				shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(16),
				),
				child: Padding(
					padding: const EdgeInsets.all(12),
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							buildActivityCardIcon(iconPath),
							const SizedBox(height: 12),
							buildActivityCardDescription(context, cardHeader, cardDescription),
						],
					),
				),
			)
		);
	}
}

Widget buildActivityCardIcon(String iconPath)
{
	return SizedBox(
		height: 72,
		child: ColorFiltered(
			colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
			child: Image.asset(iconPath, fit: BoxFit.fill)
		)
	);
}

Widget buildActivityCardDescription(BuildContext context, String? header, String? description)
{
	late Responsive responsive = Responsive(context);

	return Flexible(
		flex: 3,
		child: Column(
			mainAxisSize: MainAxisSize.min,
			children: [
				if (responsive.screenWidth > 180) buildInternalHeader(header),
				if (responsive.screenWidth > 180) const SizedBox(height: 8),
				if (responsive.screenWidth > 230) buildInternalDescription(description),
			],
		),
	);
}

Widget buildInternalHeader(String? header)
{
	if (header == null || header.isEmpty) return const SizedBox(height: 0);

	return Text(
		header,
		textAlign: TextAlign.center,
		style: TextStyle(
			fontWeight: FontWeight.bold,
			color: Colors.white,
		),
	);
}

Widget buildInternalDescription(String? description)
{
	if (description == null || description.isEmpty) return const SizedBox(height: 0);

	return Text(
		description,
		textAlign: TextAlign.center,
		style: TextStyle(
			color: Colors.white70,
		),
	);
}

