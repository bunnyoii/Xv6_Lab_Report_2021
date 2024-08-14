#include "kernel/types.h"
#include "user/user.h"

void filter(int readfd) {
    int prime;
    if (read(readfd, &prime, sizeof(prime)) == 0) { // 读取管道中的第一个数
        close(readfd); // 如果没有数可读，关闭读端并返回
        return;
    }

    printf("prime %d\n", prime); // 打印该数，这个数是素数

    int p[2];
    pipe(p); // 创建新的管道
    if (fork() == 0) { // 创建子进程
        close(p[1]); // 关闭写端
        filter(p[0]); // 子进程递归调用filter函数继续筛选素数
        close(p[0]);
    } else {
        close(p[0]); // 关闭读端
        int num;
        while (read(readfd, &num, sizeof(num)) > 0) { // 读取父管道的数
            if (num % prime != 0) { // 如果不能被当前素数整除
                write(p[1], &num, sizeof(num)); // 写入新管道
            }
        }
        close(p[1]); // 关闭写端
        close(readfd); // 关闭读端
        wait(0); // 等待子进程结束
    }
}

int main(int argc, char *argv[]) {
    int p[2];
    pipe(p); // 创建初始管道

    if (fork() == 0) { // 创建子进程
        close(p[1]); // 关闭写端
        filter(p[0]); // 子进程调用filter函数开始筛选
        close(p[0]);
    } else {
        close(p[0]); // 关闭读端
        for (int i = 2; i <= 35; i++) {
            write(p[1], &i, sizeof(i)); // 将2到35的数写入管道
        }
        close(p[1]); // 关闭写端
        wait(0); // 等待子进程结束
    }
    exit(0);
}