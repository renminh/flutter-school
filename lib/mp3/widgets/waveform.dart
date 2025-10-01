import 'package:flutter/material.dart';
import '../waveform/api.dart';

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
  Widget build(BuildContext context) {
	final waveformHeight = overrideHeight ?? wf.height;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (details) => _seek(context, details.localPosition.dx),
      onHorizontalDragUpdate: (details) => _seek(context, details.localPosition.dx),
      child: CustomPaint(
        size: Size(double.infinity, waveformHeight),
        painter: _WaveformPainter(
          waveform: wf.waveform,
          color: color,
          scaleFactor: wf.scale,
          mirrored: wf.mirrored,
          progress: wf.progress,
		  height: waveformHeight
        ),
      ),
    );
  }

  void _seek(BuildContext context, double localX) {
    if (wf.waveform.isEmpty) return;
    final box = context.findRenderObject() as RenderBox;
    final width = box.size.width;
    final newProgress = localX / width;
    wf.progress = newProgress.clamp(0.0, 1.0);
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
  void paint(Canvas canvas, Size size) {
    if (waveform.isEmpty) return;

    final step = size.width / waveform.length;
    final centerY = height / 2;

    final playedColor = color;
    final remainingColor = color.withAlpha((255 * 0.4).round());

    for (int i = 0; i < waveform.length; i++) {
      final x = i * step;
      final barHeight = waveform[i] * centerY * scaleFactor;

      final barPaint = Paint()
        ..color = (i / waveform.length <= progress) ? playedColor : remainingColor
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(x, centerY), Offset(x, centerY - barHeight), barPaint);
      if (mirrored) {
        canvas.drawLine(Offset(x, centerY), Offset(x, centerY + barHeight), barPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
