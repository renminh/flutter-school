int CLAMPI(int min, int max, int value)
{
	return (min < max)
		? ((value < min) ? min : ((value > max) ? max : value))
		: ((value < max) ? max : ((value > min) ? min : value));
}

double CLAMPD(double min, double max, double value)
{
	return (min < max)
		? ((value < min) ? min : ((value > max) ? max : value))
		: ((value < max) ? max : ((value > min) ? min : value));
}

int IMIN(int a, int b) => (a < b) ? a : b;
int IMAX(int a, int b) => (a > b) ? a : b;
double DMIN(double a, double b) => (a < b) ? a : b;
double DMAX(double a, double b) => (a > b) ? a : b;

String STR_OR(String? input, String fallback) => (input!= null) ? input : fallback;
int INT_OR(int? input, int fallback) => (input != null) ? input : fallback;


String MM_SS_FORMAT_DUR(Duration duration)
{
	String min = duration.inMinutes.toString().padLeft(2, '0');
	String sec = (duration.inSeconds % 60).toString().padLeft(2, '0');
	return "$min:$sec";
}

