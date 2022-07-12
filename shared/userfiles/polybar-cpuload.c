#define _GNU_SOURCE

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define STDERR 2

bool read_cpu_counters (
	unsigned long *user, unsigned long *nice, unsigned long *sys,
	unsigned long *idle, unsigned long *io, unsigned long *irq,
	unsigned long *irqsoft, unsigned long *guest, unsigned long *guest_nice)
{
	FILE *stream = fopen("/proc/stat", "r");
	if (stream == NULL) false;

	char *line = 0;
	size_t line_length = 0;
	if (getline(&line, &line_length, stream) == -1) {
		fclose(stream);
		return false;
	}

	unsigned long ignore = 0;
	sscanf(line, "cpu %lu %lu %lu %lu %lu %lu %lu %lu %lu %lu",
		user, nice, sys, idle, io, irq, irqsoft, &ignore, guest, guest_nice);

	free(line);
	fclose(stream);

	return true;
}

int main(int argc, char **argv)
{
	(void) argc;
	(void) argv;

	unsigned long user = 0, nice = 0, sys = 0, idle = 0,
		io = 0, irq = 0, softirq = 0, guest = 0, guest_nice = 0;
	unsigned long total_t1 = 0, work_t1 = 0, total_t2 = 0, work_t2 = 0;

	bool success = read_cpu_counters(
		&user, &nice, &sys, &idle,
		&io, &irq, &softirq,
		&guest, &guest_nice);

	if (!success) return -1;
	total_t1 = user + nice + sys + idle + io + irq + softirq + guest + guest_nice;
	work_t1 = user + nice + sys + guest + guest_nice;

	struct timespec sleep_amount = { .tv_sec = 1, .tv_nsec = 0 };
	nanosleep(&sleep_amount, 0);

	success = read_cpu_counters(
		&user, &nice, &sys, &idle,
		&io, &irq, &softirq,
		&guest, &guest_nice);

	if (!success) return -1;
	total_t2 = user + nice + sys + idle + io + irq + softirq + guest + guest_nice;
	work_t2 = user + nice + sys + guest + guest_nice;

	const float load_perc = (work_t2 - work_t1) * 100.0f / (total_t2 - total_t1);

	char msg[8] = {0};
	const int n = sprintf(msg, "%03.0f%%", load_perc);
	write(STDERR, (const void *)msg, n);

	return 0;
}
