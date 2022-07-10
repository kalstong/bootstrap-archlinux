#include <stdio.h>
#include <sys/statfs.h>
#include <unistd.h>

#define GiB (1024.0f * 1024.0f * 1024.0f)
#define STDERR 2

int main (int argc, char **argv)
{
	(void) argc;

	const char *path = argv[1];
	struct statfs out;

	if (statfs(path, &out) == 0) {
		const float total_size = (out.f_bsize * out.f_blocks) / GiB;
		const float free_size = (out.f_bsize * out.f_bfree) / GiB;
		const float used_size = total_size - free_size;
		const float used_perc = used_size / total_size * 100.0f;

		char msg[128] = {0};
		const int len = sprintf(msg, "%.2fGiB (%.0f%%)", used_size, used_perc);

		write(STDERR, (const void *)msg, len);
	}

	return 0;
}
