import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import '../../util/util.dart';

/* --------------------------------------------------------------------------
 * apis for waveform extraction used together with waveform widget.
 */

final Map<String, WaveformInterface> waveformCache = {};

class WaveformInterface {
	final String path;
	final int samples;
	final double scale;
	final bool mirrored;

	List <double> waveform = [];
	// progress is normalized
	double progress = 0.0;
	double height;
	Duration? duration;

	WaveformInterface({
		required this.path,
		this.height = 60,
		this.samples = 80,
		this.scale = 0.5,
		this.duration,
		this.mirrored = true,
  	});
}

Future<void> waveformExtract(WaveformInterface wf) async {
	final tempDir = await getTemporaryDirectory();
	final tempFile = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.pcm');

	final result = await Process.run('ffmpeg', [
		'-y',
		'-i',
		wf.path,
		'-f',
		's16le',
		'-ac',
		'1',
		'-ar',
		'44100',
		tempFile.path,
	]);

	if (result.exitCode != 0) {
		print("FFmpeg error: ${result.stderr}");
		return;
	}

	final bytes = await tempFile.readAsBytes();
	final byteData = bytes.buffer.asByteData();
	final samples = <double>[];

	for (int i = 0; i < byteData.lengthInBytes; i += 2) {
		samples.add(byteData.getInt16(i, Endian.little).abs().toDouble());
	}

	final step = max(1, (samples.length / wf.samples).floor());
	final downsampled = <double>[];
	for (int i = 0; i < samples.length; i += step) {
		downsampled.add(samples.sublist(i, min(i + step, samples.length)).reduce(max));
	}

	final maxSample = downsampled.reduce(max);
	wf.waveform = downsampled.map((e) => e / maxSample).toList();
	await tempFile.delete();
}

void waveformSetProgress(WaveformInterface wf, double progress)
{
	wf.progress = DCLAMP(0.0, 1.0, progress);
}

Future<WaveformInterface> getWaveform(String path) async
{
	if (waveformCache.containsKey(path)) return waveformCache[path]!;

	final wf = WaveformInterface(path: path);
	wf.progress = 0.0;
	await waveformExtract(wf);
	waveformCache[path] = wf;
	return wf;
}

double waveformGetProgress(WaveformInterface wf) => wf.progress;
List<double> waveformGetData(WaveformInterface wf) => wf.waveform;
