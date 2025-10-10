import 'package:app_lab/util/util.dart';
import 'package:flutter/material.dart';
import '../../core/waveform.dart';

class Waveform extends StatelessWidget {
	final WaveformInterface wf;
	final Color color;
	final double? overrideHeight;
	final void Function(double) onSeek;

	const Waveform({
		super.key,
		this.overrideHeight,
		required this.wf,
		required this.color,
		required this.onSeek,
	});

  @override
  Widget build(BuildContext context)
  {
		final waveformHeight = overrideHeight ?? wf.height;
		final screenWidth = MediaQuery.of(context).size.width;
		final clampedHeight = DCLAMP(20.0, 100.0, waveformHeight);
		final remaining = wf.duration != null
		? wf.duration! * (1.0 - wf.progress)
		: Duration.zero;

		// format helper for mm:ss
		String formatDuration(Duration d) {
			final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
			final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
			return "$minutes:$seconds";
		}

	return GestureDetector(
		behavior: HitTestBehavior.opaque,
		onTapDown: (details) => _seek(context, details.localPosition.dx),
		onHorizontalDragUpdate: (details) => _seek(context, details.localPosition.dx),
		child: SizedBox(
			width: screenWidth,
			height: clampedHeight,
			child: Stack(
				children: [
					CustomPaint(
						size: Size(screenWidth, clampedHeight),
						painter: _WaveformPainter(
							waveform: wf.waveform,
							color: color,
							scaleFactor: wf.scale,
							mirrored: wf.mirrored,
							progress: wf.progress,
							height: clampedHeight,
						),
						),
						// Progress text (bottom-left)
						Positioned(
						left: 4,
						bottom: 0,
						child: Text(
							formatDuration(wf.duration != null
								? wf.duration! * wf.progress
								: Duration.zero),
							style: const TextStyle(
							color: Colors.white,
							fontSize: 12,
							),
						),
						),
						// Remaining duration text (bottom-right)
						Positioned(
						right: 4,
						bottom: 0,
						child: Text(
							"-${formatDuration(remaining)}",
							style: const TextStyle(
							color: Colors.white,
							fontSize: 12,
							),
						),
					),
				],
			),
		)
	);
}

  void _seek(BuildContext context, double localX)
	{
		if (wf.waveform.isEmpty) return;
		final box = context.findRenderObject() as RenderBox;
		final width = box.size.width;
		final newProgress = localX / width;
		wf.progress = DCLAMP(0.0, 1.0, newProgress);
		onSeek(wf.progress);
	}
}


class _WaveformPainter extends CustomPainter {
	final List<double> waveform;
	final Color color;
	final double scaleFactor;
	final bool mirrored;
	final double height;
	final double progress; // normalized

	_WaveformPainter({
		required this.waveform,
		required this.color,
		required this.height,
		this.scaleFactor = 0.5,
		this.mirrored = true,
		this.progress = 0.0,
	});

  @override
  void paint(Canvas canvas, Size size)
  {
    if (waveform.isEmpty) return;

    final double step = size.width / waveform.length;
	// clamp between 1.0px -> 4.0px
	final double lineWidth = DCLAMP(1.5, 3.2, step);
    final double centerY = height / 2;

    final Color playedColor = color;
    final Color remainingColor = color.withAlpha((255 * 0.4).round());

    for (int i = 0; i < waveform.length; i++) {
    	final x = i * step;
    	final barHeight = waveform[i] * centerY * scaleFactor;

      	final barPaint = Paint()
        	..color = (i / waveform.length <= progress) ? playedColor : remainingColor
        	..strokeCap = StrokeCap.round
			..strokeWidth = lineWidth; // set width here

      	canvas.drawLine(Offset(x, centerY), Offset(x, centerY - barHeight), barPaint);
      	if (mirrored) {
        	canvas.drawLine(Offset(x, centerY), Offset(x, centerY + barHeight), barPaint);
      	}
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
