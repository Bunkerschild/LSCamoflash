#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <stdint.h>

int main(int ac, char *av[]) {
    // Show usage
    if (ac < 5) {
        fprintf(stderr, "usage: %s PID motoraddress iocmd value [count]\n", av[0]);
        return 1;
    }

    // Set memory path
    char mem_path[64];
    int ret = snprintf(mem_path, sizeof(mem_path), "/proc/%s/mem", av[1]);
    if (ret < 0 || (size_t) ret >= sizeof(mem_path)) {
        fprintf(stderr, "Error: snprintf mem_path failed or buffer overflow.\n");
        return 1;
    }

    // Open memory of process
    int fd = open(mem_path, O_RDONLY);
    if (fd < 0) {
        fprintf(stderr, "Can't access %s\n", av[1]);
        perror(":");
        return 1;
    }

    // Get params
    unsigned long mtrfdaddr = strtoul(av[2], NULL, 16);
    unsigned long iocmd = strtoul(av[3], NULL, 16);
    unsigned long value = strtoul(av[4], NULL, 16);
    unsigned long count = 1;
    if (ac >= 6) {
        count = strtoul(av[5], NULL, 10);
    }

    // Read motor file descriptor value
    if (lseek(fd, mtrfdaddr, SEEK_SET) == -1) {
        perror("lseek");
        close(fd);
        return 1;
    }

    unsigned long mtrfd = 0;
    if (read(fd, &mtrfd, sizeof(mtrfd)) != sizeof(mtrfd)) {
        perror("read");
        close(fd);
        return 1;
    }

    // Close memory file descriptor
    close(fd);

    // Feedback
    fprintf(stderr, "mtrfdaddr=%lx mtrfd=%lx val=%lx\n", mtrfdaddr, mtrfd, value);

    // Send command if we have a valid descriptor
    if (mtrfd != 0) {
        char fd_path[64];
        ret = snprintf(fd_path, sizeof(fd_path), "/proc/%s/fd/%lu", av[1], mtrfd);
        if (ret < 0 || (size_t) ret >= sizeof(fd_path)) {
            fprintf(stderr, "Error: snprintf fd_path failed or buffer overflow.\n");
            return 1;
        }

        int new_fd = open(fd_path, O_RDWR);
        if (new_fd < 0) {
            perror("open fd_path");
            return 1;
        }

        fprintf(stderr, "fd_path=%s new_fd=%d\n", fd_path, new_fd);

        int ioctl_ret = 0;
        while (count > 0) {
            ioctl_ret = ioctl(new_fd, iocmd, (int32_t*) &value);
            if (ioctl_ret < 0) {
                perror("ioctl failed");
                break;
            }
            usleep(10000);
            fprintf(stderr, "count=%lu\n", count);
            count--;
        }

        fprintf(stderr, "ret=%x\n", ioctl_ret);
        close(new_fd);
    }

    return 0;
}
