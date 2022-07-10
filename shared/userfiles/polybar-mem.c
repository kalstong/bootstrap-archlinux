#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define KiB2GiB (1024.0f * 1024.0f)
#define STDERR 2

int main(int argc, char **argv)
{
	(void) argc;
	(void) argv;

	FILE *stream = fopen("/proc/meminfo", "r");
	if (stream == NULL) return -1;

	unsigned int mem_total = 0, mem_free = 0, mem_buffers = 0,
		mem_cached = 0, mem_reclaimable = 0, mem_unreclaimable = 0,
		mem_tmpfs = 0;

	char *line = 0;
	size_t len = 0;
	while (getline(&line, &len, stream) != -1) {
		if (mem_total == 0)
		if (sscanf(line, "MemTotal: %u kB", &mem_total) == 1)
			continue;

		if (mem_free == 0)
		if (sscanf(line, "MemFree: %u kB", &mem_free) == 1)
			continue;

		if (mem_buffers == 0)
		if (sscanf(line, "Buffers: %u kB", &mem_buffers) == 1)
			continue;

		if (mem_cached == 0)
		if (sscanf(line, "Cached: %u kB", &mem_cached) == 1)
			continue;

		if (mem_reclaimable == 0)
		if (sscanf(line, "SReclaimable: %u kB", &mem_reclaimable) == 1)
			continue;

		if (mem_unreclaimable == 0)
		if (sscanf(line, "SUnreclaimable: %u kB", &mem_unreclaimable) == 1)
			continue;

		if (mem_tmpfs == 0)
		if (sscanf(line, "Shmem: %u kB", &mem_tmpfs) == 1)
			continue;
	}

	char msg[16] = {0};
	const float mem_used =
		(mem_total - mem_free - mem_buffers -
		 mem_cached - mem_reclaimable +
		 mem_unreclaimable + mem_tmpfs) / KiB2GiB;

	const int n = sprintf(msg, "%.3fGiB", mem_used);
	write(STDERR, (const void *)msg, n);

	free(line);
	fclose(stream);
	return 0;
}
