int clampi(int min, int max, int value)
{
	return (min < max)
		? ((value < min) ? min : ((value > max) ? max : value))
		: ((value < max) ? max : ((value > min) ? min : value));
}

double clampd(double min, double max, double value)
{
	return (min < max)
		? ((value < min) ? min : ((value > max) ? max : value))
		: ((value < max) ? max : ((value > min) ? min : value));
}
