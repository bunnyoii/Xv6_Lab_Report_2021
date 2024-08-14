#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

#define MAXLEN 32

int main(int argc, char *argv[]) {
    char *path = "echo";
    char buf[MAXLEN * MAXARG] = {0}, *p;
    char *params[MAXARG];
    int paramIdx = 0;
    int i;
    int len;

    // 读取原有参数, 与上一种方法相同
    if (argc > 1) {
        if (argc + 1 > MAXARG) {
            fprintf(2, "xargs: too many ars\n");
            exit(1);
        }
        path = argv[1];
        for (i = 1; i < argc; ++i) {
            params[paramIdx++] = argv[i];
        }
    } else {
        params[paramIdx++] = path;
    }
    
    p = buf;
    while (1) {
        // 读取字符知道结束或遇到回车
        while (1) {
            len = read(0, p, 1);
            if (len == 0 || *p == '\n') {
                break;
            }
            ++p;
        }
        *p = 0;
        // 直接将其作为一个参数
        params[paramIdx] = buf;
        // 创建子进程执行
        if (fork() == 0) {
            exec(path, params);
            exit(0);
        } else {
            wait((int *) 0);
            p=buf;
        }
        if (len == 0) {
            break;
        }
    }
    exit(0);
}