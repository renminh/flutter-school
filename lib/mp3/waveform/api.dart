import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import '../../util/util.dart';

/* --------------------------------------------------------------------------
 * apis for waveform extraction used together with waveform widget.
 * Also includes a global cache for waveform
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

	WaveformInterface({
		required this.path,
		this.height = 60,
		this.samples = 500,
		this.scale = 0.5,
		this.mirrored = true,
  });
}

Future<void> waveformExtract(WaveformInterface wf) async
{
	final tempFile = File('${wf.path}.pcm');
	/*
	 * overwrite w/o asking,
	 * force ouput to s16le (little endian)
	 * set up monochannel
	 * set sample rate to 44100hz
	 */
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
		// ignore: avoid_print
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
	await waveformExtract(wf);
	waveformCache[path] = wf;
	return wf;
}

double waveformGetProgress(WaveformInterface wf) => wf.progress;
List<double> waveformGetData(WaveformInterface wf) => wf.waveform;
