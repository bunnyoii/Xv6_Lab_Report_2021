#include "kernel/types.h"
#include "user/user.h"
#include "kernel/fcntl.h"

int main() {
    int p[2], q[2];
    char buf[1];
    int pid;

    // 创建两个管道
    pipe(p);
    pipe(q);

    // 创建子进程
    if ((pid = fork()) < 0) {
        fprintf(2, "fork error\n");
        exit(1);
    }

    if (pid == 0) { // 子进程
        // 从父进程读取字节
        read(p[0], buf, 1);
        printf("%d: received ping\n", getpid());

        // 将字节写回父进程
        write(q[1], buf, 1);

        // 退出子进程
        exit(0);
    } else { // 父进程
        // 向子进程写入字节
        write(p[1], "x", 1);

        // 从子进程读取字节
        read(q[0], buf, 1);
        printf("%d: received pong\n", getpid());

        // 等待子进程退出
        wait(0);
    }

    exit(0);
}