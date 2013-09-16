#define _GNU_SOURCE
#include <sched.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/mount.h>
#include <stdio.h>
#define chk(X) if((X) == -1) { perror(#X); exit(1); }

int main(int argc, char **argv)
{
	uid_t uid = getuid();
	uid_t gid = getgid();

	char *tarballs=getenv("C");
	if(!tarballs) tarballs = "./tarballs";

	chk(unshare(CLONE_NEWUSER|CLONE_NEWNS));

	int fd = open("/proc/self/uid_map", O_RDWR);
	dprintf(fd, "%u %u 1\n", 0, uid);
	close(fd);
	fd = open("/proc/self/gid_map", O_RDWR);
	dprintf(fd, "%u %u 1\n", 0, gid);
	close(fd);

	setgroups(0, 0);

	chdir(argv[1]);
	chk(mount("/dev", "./dev", 0, MS_BIND|MS_REC, 0));
	chk(mount("/proc", "./proc", 0, MS_BIND|MS_REC, 0));
	chk(mount(tarballs, "./src/tarballs", 0, MS_BIND, 0));

	chk(chroot("."));

	chk(execv(argv[2], argv+2));
}
