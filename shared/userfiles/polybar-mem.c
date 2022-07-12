#define _GNU_SOURCE

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define KiB2GiB (1024.0f * 1024.0f)
#define STDERR 2

static bool
starts_with (const char *str, const char *pattern)
{
	int i = 0;
	while (str[i] && pattern[i]) {
		if (str[i] != pattern[i]) return false;
		else i++;
	}

	return true;
}

int main(int argc, char **argv)
{
	(void) argc;
	(void) argv;

	FILE *stream = fopen("/proc/meminfo", "r");
	if (stream == NULL) return -1;

	#define TOTAL_SOURCES 7
	unsigned int mem_total = 0, mem_free = 0, mem_buffers = 0,
		mem_cached = 0, mem_reclaimable = 0, mem_unreclaimable = 0,
		mem_tmpfs = 0, i = 0;

	char *line = 0;
	size_t len = 0;
	while (i < TOTAL_SOURCES) {
		getline(&line, &len, stream);
		if (mem_total == 0 && starts_with(line, "MemTotal:")) {
			i++;
			sscanf(line, "MemTotal: %u kB", &mem_total);
			continue;
		}

		if (mem_free == 0 && starts_with(line, "MemFree:")) {
			i++;
			sscanf(line, "MemFree: %u kB", &mem_free);
			continue;
		}

		if (mem_buffers == 0 && starts_with(line, "Buffers:")) {
			i++;
			sscanf(line, "Buffers: %u kB", &mem_buffers);
			continue;
		}

		if (mem_cached == 0 && starts_with(line, "Cached:")) {
			i++;
			sscanf(line, "Cached: %u kB", &mem_cached);
			continue;
		}

		if (mem_reclaimable == 0 && starts_with(line, "SReclaimable:")) {
			i++;
			sscanf(line, "SReclaimable: %u kB", &mem_reclaimable);
			continue;
		}

		if (mem_unreclaimable == 0 && starts_with(line, "SUnreclaim:")) {
			i++;
			sscanf(line, "SUnreclaim: %u kB", &mem_unreclaimable);
			continue;
		}

		if (mem_tmpfs == 0 && starts_with(line, "Shmem:")) {
			i++;
			sscanf(line, "Shmem: %u kB", &mem_tmpfs);
			continue;
		}
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
