import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final List<double> waveform;
  final Color color;
  final double scaleFactor;
  final bool mirrored;
  final double progress; // normalized 0.0..1.0

  WaveformPainter({
    required this.waveform,
    required this.color,
    this.scaleFactor = 0.5,
    this.mirrored = true,
    this.progress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveform.isEmpty) return;

    final step = size.width / waveform.length;
    final centerY = size.height / 2;

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
