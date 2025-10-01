// ignore_for_file: non_constant_identifier_names
int ICLAMP(int min, int max, int value)
{
	return (min < max)
		? ((value < min) ? min : ((value > max) ? max : value))
		: ((value < max) ? max : ((value > min) ? min : value));
}

double DCLAMP(double min, double max, double value)
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


