
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <filter>:
#include "kernel/types.h"
#include "user/user.h"

void filter(int readfd) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	84aa                	mv	s1,a0
    int prime;
    if (read(readfd, &prime, sizeof(prime)) == 0) { // 读取管道中的第一个数
   c:	4611                	li	a2,4
   e:	fdc40593          	addi	a1,s0,-36
  12:	00000097          	auipc	ra,0x0
  16:	400080e7          	jalr	1024(ra) # 412 <read>
  1a:	c929                	beqz	a0,6c <filter+0x6c>
        close(readfd); // 如果没有数可读，关闭读端并返回
        return;
    }

    printf("prime %d\n", prime); // 打印该数，这个数是素数
  1c:	fdc42583          	lw	a1,-36(s0)
  20:	00001517          	auipc	a0,0x1
  24:	8f850513          	addi	a0,a0,-1800 # 918 <malloc+0xe8>
  28:	00000097          	auipc	ra,0x0
  2c:	74a080e7          	jalr	1866(ra) # 772 <printf>

    int p[2];
    pipe(p); // 创建新的管道
  30:	fd040513          	addi	a0,s0,-48
  34:	00000097          	auipc	ra,0x0
  38:	3d6080e7          	jalr	982(ra) # 40a <pipe>
    if (fork() == 0) { // 创建子进程
  3c:	00000097          	auipc	ra,0x0
  40:	3b6080e7          	jalr	950(ra) # 3f2 <fork>
  44:	ed15                	bnez	a0,80 <filter+0x80>
        close(p[1]); // 关闭写端
  46:	fd442503          	lw	a0,-44(s0)
  4a:	00000097          	auipc	ra,0x0
  4e:	3d8080e7          	jalr	984(ra) # 422 <close>
        filter(p[0]); // 子进程递归调用filter函数继续筛选素数
  52:	fd042503          	lw	a0,-48(s0)
  56:	00000097          	auipc	ra,0x0
  5a:	faa080e7          	jalr	-86(ra) # 0 <filter>
        close(p[0]);
  5e:	fd042503          	lw	a0,-48(s0)
  62:	00000097          	auipc	ra,0x0
  66:	3c0080e7          	jalr	960(ra) # 422 <close>
  6a:	a031                	j	76 <filter+0x76>
        close(readfd); // 如果没有数可读，关闭读端并返回
  6c:	8526                	mv	a0,s1
  6e:	00000097          	auipc	ra,0x0
  72:	3b4080e7          	jalr	948(ra) # 422 <close>
        }
        close(p[1]); // 关闭写端
        close(readfd); // 关闭读端
        wait(0); // 等待子进程结束
    }
}
  76:	70e2                	ld	ra,56(sp)
  78:	7442                	ld	s0,48(sp)
  7a:	74a2                	ld	s1,40(sp)
  7c:	6121                	addi	sp,sp,64
  7e:	8082                	ret
        close(p[0]); // 关闭读端
  80:	fd042503          	lw	a0,-48(s0)
  84:	00000097          	auipc	ra,0x0
  88:	39e080e7          	jalr	926(ra) # 422 <close>
        while (read(readfd, &num, sizeof(num)) > 0) { // 读取父管道的数
  8c:	4611                	li	a2,4
  8e:	fcc40593          	addi	a1,s0,-52
  92:	8526                	mv	a0,s1
  94:	00000097          	auipc	ra,0x0
  98:	37e080e7          	jalr	894(ra) # 412 <read>
  9c:	02a05363          	blez	a0,c2 <filter+0xc2>
            if (num % prime != 0) { // 如果不能被当前素数整除
  a0:	fcc42783          	lw	a5,-52(s0)
  a4:	fdc42703          	lw	a4,-36(s0)
  a8:	02e7e7bb          	remw	a5,a5,a4
  ac:	d3e5                	beqz	a5,8c <filter+0x8c>
                write(p[1], &num, sizeof(num)); // 写入新管道
  ae:	4611                	li	a2,4
  b0:	fcc40593          	addi	a1,s0,-52
  b4:	fd442503          	lw	a0,-44(s0)
  b8:	00000097          	auipc	ra,0x0
  bc:	362080e7          	jalr	866(ra) # 41a <write>
  c0:	b7f1                	j	8c <filter+0x8c>
        close(p[1]); // 关闭写端
  c2:	fd442503          	lw	a0,-44(s0)
  c6:	00000097          	auipc	ra,0x0
  ca:	35c080e7          	jalr	860(ra) # 422 <close>
        close(readfd); // 关闭读端
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	352080e7          	jalr	850(ra) # 422 <close>
        wait(0); // 等待子进程结束
  d8:	4501                	li	a0,0
  da:	00000097          	auipc	ra,0x0
  de:	328080e7          	jalr	808(ra) # 402 <wait>
  e2:	bf51                	j	76 <filter+0x76>

00000000000000e4 <main>:

int main(int argc, char *argv[]) {
  e4:	7179                	addi	sp,sp,-48
  e6:	f406                	sd	ra,40(sp)
  e8:	f022                	sd	s0,32(sp)
  ea:	ec26                	sd	s1,24(sp)
  ec:	1800                	addi	s0,sp,48
    int p[2];
    pipe(p); // 创建初始管道
  ee:	fd840513          	addi	a0,s0,-40
  f2:	00000097          	auipc	ra,0x0
  f6:	318080e7          	jalr	792(ra) # 40a <pipe>

    if (fork() == 0) { // 创建子进程
  fa:	00000097          	auipc	ra,0x0
  fe:	2f8080e7          	jalr	760(ra) # 3f2 <fork>
 102:	e505                	bnez	a0,12a <main+0x46>
        close(p[1]); // 关闭写端
 104:	fdc42503          	lw	a0,-36(s0)
 108:	00000097          	auipc	ra,0x0
 10c:	31a080e7          	jalr	794(ra) # 422 <close>
        filter(p[0]); // 子进程调用filter函数开始筛选
 110:	fd842503          	lw	a0,-40(s0)
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <filter>
        close(p[0]);
 11c:	fd842503          	lw	a0,-40(s0)
 120:	00000097          	auipc	ra,0x0
 124:	302080e7          	jalr	770(ra) # 422 <close>
 128:	a889                	j	17a <main+0x96>
    } else {
        close(p[0]); // 关闭读端
 12a:	fd842503          	lw	a0,-40(s0)
 12e:	00000097          	auipc	ra,0x0
 132:	2f4080e7          	jalr	756(ra) # 422 <close>
        for (int i = 2; i <= 35; i++) {
 136:	4789                	li	a5,2
 138:	fcf42a23          	sw	a5,-44(s0)
 13c:	02300493          	li	s1,35
            write(p[1], &i, sizeof(i)); // 将2到35的数写入管道
 140:	4611                	li	a2,4
 142:	fd440593          	addi	a1,s0,-44
 146:	fdc42503          	lw	a0,-36(s0)
 14a:	00000097          	auipc	ra,0x0
 14e:	2d0080e7          	jalr	720(ra) # 41a <write>
        for (int i = 2; i <= 35; i++) {
 152:	fd442783          	lw	a5,-44(s0)
 156:	2785                	addiw	a5,a5,1
 158:	0007871b          	sext.w	a4,a5
 15c:	fcf42a23          	sw	a5,-44(s0)
 160:	fee4d0e3          	bge	s1,a4,140 <main+0x5c>
        }
        close(p[1]); // 关闭写端
 164:	fdc42503          	lw	a0,-36(s0)
 168:	00000097          	auipc	ra,0x0
 16c:	2ba080e7          	jalr	698(ra) # 422 <close>
        wait(0); // 等待子进程结束
 170:	4501                	li	a0,0
 172:	00000097          	auipc	ra,0x0
 176:	290080e7          	jalr	656(ra) # 402 <wait>
    }
    exit(0);
 17a:	4501                	li	a0,0
 17c:	00000097          	auipc	ra,0x0
 180:	27e080e7          	jalr	638(ra) # 3fa <exit>

0000000000000184 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18a:	87aa                	mv	a5,a0
 18c:	0585                	addi	a1,a1,1
 18e:	0785                	addi	a5,a5,1
 190:	fff5c703          	lbu	a4,-1(a1)
 194:	fee78fa3          	sb	a4,-1(a5)
 198:	fb75                	bnez	a4,18c <strcpy+0x8>
    ;
  return os;
}
 19a:	6422                	ld	s0,8(sp)
 19c:	0141                	addi	sp,sp,16
 19e:	8082                	ret

00000000000001a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a0:	1141                	addi	sp,sp,-16
 1a2:	e422                	sd	s0,8(sp)
 1a4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	cb91                	beqz	a5,1be <strcmp+0x1e>
 1ac:	0005c703          	lbu	a4,0(a1)
 1b0:	00f71763          	bne	a4,a5,1be <strcmp+0x1e>
    p++, q++;
 1b4:	0505                	addi	a0,a0,1
 1b6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbe5                	bnez	a5,1ac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1be:	0005c503          	lbu	a0,0(a1)
}
 1c2:	40a7853b          	subw	a0,a5,a0
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strlen>:

uint
strlen(const char *s)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cf91                	beqz	a5,1f2 <strlen+0x26>
 1d8:	0505                	addi	a0,a0,1
 1da:	87aa                	mv	a5,a0
 1dc:	4685                	li	a3,1
 1de:	9e89                	subw	a3,a3,a0
 1e0:	00f6853b          	addw	a0,a3,a5
 1e4:	0785                	addi	a5,a5,1
 1e6:	fff7c703          	lbu	a4,-1(a5)
 1ea:	fb7d                	bnez	a4,1e0 <strlen+0x14>
    ;
  return n;
}
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret
  for(n = 0; s[n]; n++)
 1f2:	4501                	li	a0,0
 1f4:	bfe5                	j	1ec <strlen+0x20>

00000000000001f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e422                	sd	s0,8(sp)
 1fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1fc:	ce09                	beqz	a2,216 <memset+0x20>
 1fe:	87aa                	mv	a5,a0
 200:	fff6071b          	addiw	a4,a2,-1
 204:	1702                	slli	a4,a4,0x20
 206:	9301                	srli	a4,a4,0x20
 208:	0705                	addi	a4,a4,1
 20a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 20c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 210:	0785                	addi	a5,a5,1
 212:	fee79de3          	bne	a5,a4,20c <memset+0x16>
  }
  return dst;
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret

000000000000021c <strchr>:

char*
strchr(const char *s, char c)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  for(; *s; s++)
 222:	00054783          	lbu	a5,0(a0)
 226:	cb99                	beqz	a5,23c <strchr+0x20>
    if(*s == c)
 228:	00f58763          	beq	a1,a5,236 <strchr+0x1a>
  for(; *s; s++)
 22c:	0505                	addi	a0,a0,1
 22e:	00054783          	lbu	a5,0(a0)
 232:	fbfd                	bnez	a5,228 <strchr+0xc>
      return (char*)s;
  return 0;
 234:	4501                	li	a0,0
}
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
  return 0;
 23c:	4501                	li	a0,0
 23e:	bfe5                	j	236 <strchr+0x1a>

0000000000000240 <gets>:

char*
gets(char *buf, int max)
{
 240:	711d                	addi	sp,sp,-96
 242:	ec86                	sd	ra,88(sp)
 244:	e8a2                	sd	s0,80(sp)
 246:	e4a6                	sd	s1,72(sp)
 248:	e0ca                	sd	s2,64(sp)
 24a:	fc4e                	sd	s3,56(sp)
 24c:	f852                	sd	s4,48(sp)
 24e:	f456                	sd	s5,40(sp)
 250:	f05a                	sd	s6,32(sp)
 252:	ec5e                	sd	s7,24(sp)
 254:	1080                	addi	s0,sp,96
 256:	8baa                	mv	s7,a0
 258:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	892a                	mv	s2,a0
 25c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 25e:	4aa9                	li	s5,10
 260:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 262:	89a6                	mv	s3,s1
 264:	2485                	addiw	s1,s1,1
 266:	0344d863          	bge	s1,s4,296 <gets+0x56>
    cc = read(0, &c, 1);
 26a:	4605                	li	a2,1
 26c:	faf40593          	addi	a1,s0,-81
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	1a0080e7          	jalr	416(ra) # 412 <read>
    if(cc < 1)
 27a:	00a05e63          	blez	a0,296 <gets+0x56>
    buf[i++] = c;
 27e:	faf44783          	lbu	a5,-81(s0)
 282:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 286:	01578763          	beq	a5,s5,294 <gets+0x54>
 28a:	0905                	addi	s2,s2,1
 28c:	fd679be3          	bne	a5,s6,262 <gets+0x22>
  for(i=0; i+1 < max; ){
 290:	89a6                	mv	s3,s1
 292:	a011                	j	296 <gets+0x56>
 294:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 296:	99de                	add	s3,s3,s7
 298:	00098023          	sb	zero,0(s3)
  return buf;
}
 29c:	855e                	mv	a0,s7
 29e:	60e6                	ld	ra,88(sp)
 2a0:	6446                	ld	s0,80(sp)
 2a2:	64a6                	ld	s1,72(sp)
 2a4:	6906                	ld	s2,64(sp)
 2a6:	79e2                	ld	s3,56(sp)
 2a8:	7a42                	ld	s4,48(sp)
 2aa:	7aa2                	ld	s5,40(sp)
 2ac:	7b02                	ld	s6,32(sp)
 2ae:	6be2                	ld	s7,24(sp)
 2b0:	6125                	addi	sp,sp,96
 2b2:	8082                	ret

00000000000002b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b4:	1101                	addi	sp,sp,-32
 2b6:	ec06                	sd	ra,24(sp)
 2b8:	e822                	sd	s0,16(sp)
 2ba:	e426                	sd	s1,8(sp)
 2bc:	e04a                	sd	s2,0(sp)
 2be:	1000                	addi	s0,sp,32
 2c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c2:	4581                	li	a1,0
 2c4:	00000097          	auipc	ra,0x0
 2c8:	176080e7          	jalr	374(ra) # 43a <open>
  if(fd < 0)
 2cc:	02054563          	bltz	a0,2f6 <stat+0x42>
 2d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d2:	85ca                	mv	a1,s2
 2d4:	00000097          	auipc	ra,0x0
 2d8:	17e080e7          	jalr	382(ra) # 452 <fstat>
 2dc:	892a                	mv	s2,a0
  close(fd);
 2de:	8526                	mv	a0,s1
 2e0:	00000097          	auipc	ra,0x0
 2e4:	142080e7          	jalr	322(ra) # 422 <close>
  return r;
}
 2e8:	854a                	mv	a0,s2
 2ea:	60e2                	ld	ra,24(sp)
 2ec:	6442                	ld	s0,16(sp)
 2ee:	64a2                	ld	s1,8(sp)
 2f0:	6902                	ld	s2,0(sp)
 2f2:	6105                	addi	sp,sp,32
 2f4:	8082                	ret
    return -1;
 2f6:	597d                	li	s2,-1
 2f8:	bfc5                	j	2e8 <stat+0x34>

00000000000002fa <atoi>:

int
atoi(const char *s)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 300:	00054603          	lbu	a2,0(a0)
 304:	fd06079b          	addiw	a5,a2,-48
 308:	0ff7f793          	andi	a5,a5,255
 30c:	4725                	li	a4,9
 30e:	02f76963          	bltu	a4,a5,340 <atoi+0x46>
 312:	86aa                	mv	a3,a0
  n = 0;
 314:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 316:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 318:	0685                	addi	a3,a3,1
 31a:	0025179b          	slliw	a5,a0,0x2
 31e:	9fa9                	addw	a5,a5,a0
 320:	0017979b          	slliw	a5,a5,0x1
 324:	9fb1                	addw	a5,a5,a2
 326:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 32a:	0006c603          	lbu	a2,0(a3)
 32e:	fd06071b          	addiw	a4,a2,-48
 332:	0ff77713          	andi	a4,a4,255
 336:	fee5f1e3          	bgeu	a1,a4,318 <atoi+0x1e>
  return n;
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret
  n = 0;
 340:	4501                	li	a0,0
 342:	bfe5                	j	33a <atoi+0x40>

0000000000000344 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 344:	1141                	addi	sp,sp,-16
 346:	e422                	sd	s0,8(sp)
 348:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34a:	02b57663          	bgeu	a0,a1,376 <memmove+0x32>
    while(n-- > 0)
 34e:	02c05163          	blez	a2,370 <memmove+0x2c>
 352:	fff6079b          	addiw	a5,a2,-1
 356:	1782                	slli	a5,a5,0x20
 358:	9381                	srli	a5,a5,0x20
 35a:	0785                	addi	a5,a5,1
 35c:	97aa                	add	a5,a5,a0
  dst = vdst;
 35e:	872a                	mv	a4,a0
      *dst++ = *src++;
 360:	0585                	addi	a1,a1,1
 362:	0705                	addi	a4,a4,1
 364:	fff5c683          	lbu	a3,-1(a1)
 368:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 36c:	fee79ae3          	bne	a5,a4,360 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 370:	6422                	ld	s0,8(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret
    dst += n;
 376:	00c50733          	add	a4,a0,a2
    src += n;
 37a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 37c:	fec05ae3          	blez	a2,370 <memmove+0x2c>
 380:	fff6079b          	addiw	a5,a2,-1
 384:	1782                	slli	a5,a5,0x20
 386:	9381                	srli	a5,a5,0x20
 388:	fff7c793          	not	a5,a5
 38c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38e:	15fd                	addi	a1,a1,-1
 390:	177d                	addi	a4,a4,-1
 392:	0005c683          	lbu	a3,0(a1)
 396:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 39a:	fee79ae3          	bne	a5,a4,38e <memmove+0x4a>
 39e:	bfc9                	j	370 <memmove+0x2c>

00000000000003a0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e422                	sd	s0,8(sp)
 3a4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a6:	ca05                	beqz	a2,3d6 <memcmp+0x36>
 3a8:	fff6069b          	addiw	a3,a2,-1
 3ac:	1682                	slli	a3,a3,0x20
 3ae:	9281                	srli	a3,a3,0x20
 3b0:	0685                	addi	a3,a3,1
 3b2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b4:	00054783          	lbu	a5,0(a0)
 3b8:	0005c703          	lbu	a4,0(a1)
 3bc:	00e79863          	bne	a5,a4,3cc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c0:	0505                	addi	a0,a0,1
    p2++;
 3c2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c4:	fed518e3          	bne	a0,a3,3b4 <memcmp+0x14>
  }
  return 0;
 3c8:	4501                	li	a0,0
 3ca:	a019                	j	3d0 <memcmp+0x30>
      return *p1 - *p2;
 3cc:	40e7853b          	subw	a0,a5,a4
}
 3d0:	6422                	ld	s0,8(sp)
 3d2:	0141                	addi	sp,sp,16
 3d4:	8082                	ret
  return 0;
 3d6:	4501                	li	a0,0
 3d8:	bfe5                	j	3d0 <memcmp+0x30>

00000000000003da <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3da:	1141                	addi	sp,sp,-16
 3dc:	e406                	sd	ra,8(sp)
 3de:	e022                	sd	s0,0(sp)
 3e0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e2:	00000097          	auipc	ra,0x0
 3e6:	f62080e7          	jalr	-158(ra) # 344 <memmove>
}
 3ea:	60a2                	ld	ra,8(sp)
 3ec:	6402                	ld	s0,0(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret

00000000000003f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f2:	4885                	li	a7,1
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fa:	4889                	li	a7,2
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <wait>:
.global wait
wait:
 li a7, SYS_wait
 402:	488d                	li	a7,3
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40a:	4891                	li	a7,4
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <read>:
.global read
read:
 li a7, SYS_read
 412:	4895                	li	a7,5
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <write>:
.global write
write:
 li a7, SYS_write
 41a:	48c1                	li	a7,16
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <close>:
.global close
close:
 li a7, SYS_close
 422:	48d5                	li	a7,21
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <kill>:
.global kill
kill:
 li a7, SYS_kill
 42a:	4899                	li	a7,6
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <exec>:
.global exec
exec:
 li a7, SYS_exec
 432:	489d                	li	a7,7
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <open>:
.global open
open:
 li a7, SYS_open
 43a:	48bd                	li	a7,15
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 442:	48c5                	li	a7,17
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44a:	48c9                	li	a7,18
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 452:	48a1                	li	a7,8
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <link>:
.global link
link:
 li a7, SYS_link
 45a:	48cd                	li	a7,19
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 462:	48d1                	li	a7,20
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46a:	48a5                	li	a7,9
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <dup>:
.global dup
dup:
 li a7, SYS_dup
 472:	48a9                	li	a7,10
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47a:	48ad                	li	a7,11
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 482:	48b1                	li	a7,12
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 48a:	48b5                	li	a7,13
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 492:	48b9                	li	a7,14
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 49a:	1101                	addi	sp,sp,-32
 49c:	ec06                	sd	ra,24(sp)
 49e:	e822                	sd	s0,16(sp)
 4a0:	1000                	addi	s0,sp,32
 4a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a6:	4605                	li	a2,1
 4a8:	fef40593          	addi	a1,s0,-17
 4ac:	00000097          	auipc	ra,0x0
 4b0:	f6e080e7          	jalr	-146(ra) # 41a <write>
}
 4b4:	60e2                	ld	ra,24(sp)
 4b6:	6442                	ld	s0,16(sp)
 4b8:	6105                	addi	sp,sp,32
 4ba:	8082                	ret

00000000000004bc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4bc:	7139                	addi	sp,sp,-64
 4be:	fc06                	sd	ra,56(sp)
 4c0:	f822                	sd	s0,48(sp)
 4c2:	f426                	sd	s1,40(sp)
 4c4:	f04a                	sd	s2,32(sp)
 4c6:	ec4e                	sd	s3,24(sp)
 4c8:	0080                	addi	s0,sp,64
 4ca:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4cc:	c299                	beqz	a3,4d2 <printint+0x16>
 4ce:	0805c863          	bltz	a1,55e <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d2:	2581                	sext.w	a1,a1
  neg = 0;
 4d4:	4881                	li	a7,0
 4d6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4da:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4dc:	2601                	sext.w	a2,a2
 4de:	00000517          	auipc	a0,0x0
 4e2:	45250513          	addi	a0,a0,1106 # 930 <digits>
 4e6:	883a                	mv	a6,a4
 4e8:	2705                	addiw	a4,a4,1
 4ea:	02c5f7bb          	remuw	a5,a1,a2
 4ee:	1782                	slli	a5,a5,0x20
 4f0:	9381                	srli	a5,a5,0x20
 4f2:	97aa                	add	a5,a5,a0
 4f4:	0007c783          	lbu	a5,0(a5)
 4f8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fc:	0005879b          	sext.w	a5,a1
 500:	02c5d5bb          	divuw	a1,a1,a2
 504:	0685                	addi	a3,a3,1
 506:	fec7f0e3          	bgeu	a5,a2,4e6 <printint+0x2a>
  if(neg)
 50a:	00088b63          	beqz	a7,520 <printint+0x64>
    buf[i++] = '-';
 50e:	fd040793          	addi	a5,s0,-48
 512:	973e                	add	a4,a4,a5
 514:	02d00793          	li	a5,45
 518:	fef70823          	sb	a5,-16(a4)
 51c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 520:	02e05863          	blez	a4,550 <printint+0x94>
 524:	fc040793          	addi	a5,s0,-64
 528:	00e78933          	add	s2,a5,a4
 52c:	fff78993          	addi	s3,a5,-1
 530:	99ba                	add	s3,s3,a4
 532:	377d                	addiw	a4,a4,-1
 534:	1702                	slli	a4,a4,0x20
 536:	9301                	srli	a4,a4,0x20
 538:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 53c:	fff94583          	lbu	a1,-1(s2)
 540:	8526                	mv	a0,s1
 542:	00000097          	auipc	ra,0x0
 546:	f58080e7          	jalr	-168(ra) # 49a <putc>
  while(--i >= 0)
 54a:	197d                	addi	s2,s2,-1
 54c:	ff3918e3          	bne	s2,s3,53c <printint+0x80>
}
 550:	70e2                	ld	ra,56(sp)
 552:	7442                	ld	s0,48(sp)
 554:	74a2                	ld	s1,40(sp)
 556:	7902                	ld	s2,32(sp)
 558:	69e2                	ld	s3,24(sp)
 55a:	6121                	addi	sp,sp,64
 55c:	8082                	ret
    x = -xx;
 55e:	40b005bb          	negw	a1,a1
    neg = 1;
 562:	4885                	li	a7,1
    x = -xx;
 564:	bf8d                	j	4d6 <printint+0x1a>

0000000000000566 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 566:	7119                	addi	sp,sp,-128
 568:	fc86                	sd	ra,120(sp)
 56a:	f8a2                	sd	s0,112(sp)
 56c:	f4a6                	sd	s1,104(sp)
 56e:	f0ca                	sd	s2,96(sp)
 570:	ecce                	sd	s3,88(sp)
 572:	e8d2                	sd	s4,80(sp)
 574:	e4d6                	sd	s5,72(sp)
 576:	e0da                	sd	s6,64(sp)
 578:	fc5e                	sd	s7,56(sp)
 57a:	f862                	sd	s8,48(sp)
 57c:	f466                	sd	s9,40(sp)
 57e:	f06a                	sd	s10,32(sp)
 580:	ec6e                	sd	s11,24(sp)
 582:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 584:	0005c903          	lbu	s2,0(a1)
 588:	18090f63          	beqz	s2,726 <vprintf+0x1c0>
 58c:	8aaa                	mv	s5,a0
 58e:	8b32                	mv	s6,a2
 590:	00158493          	addi	s1,a1,1
  state = 0;
 594:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 596:	02500a13          	li	s4,37
      if(c == 'd'){
 59a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 59e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5a2:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5a6:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5aa:	00000b97          	auipc	s7,0x0
 5ae:	386b8b93          	addi	s7,s7,902 # 930 <digits>
 5b2:	a839                	j	5d0 <vprintf+0x6a>
        putc(fd, c);
 5b4:	85ca                	mv	a1,s2
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	ee2080e7          	jalr	-286(ra) # 49a <putc>
 5c0:	a019                	j	5c6 <vprintf+0x60>
    } else if(state == '%'){
 5c2:	01498f63          	beq	s3,s4,5e0 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5c6:	0485                	addi	s1,s1,1
 5c8:	fff4c903          	lbu	s2,-1(s1)
 5cc:	14090d63          	beqz	s2,726 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5d0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d4:	fe0997e3          	bnez	s3,5c2 <vprintf+0x5c>
      if(c == '%'){
 5d8:	fd479ee3          	bne	a5,s4,5b4 <vprintf+0x4e>
        state = '%';
 5dc:	89be                	mv	s3,a5
 5de:	b7e5                	j	5c6 <vprintf+0x60>
      if(c == 'd'){
 5e0:	05878063          	beq	a5,s8,620 <vprintf+0xba>
      } else if(c == 'l') {
 5e4:	05978c63          	beq	a5,s9,63c <vprintf+0xd6>
      } else if(c == 'x') {
 5e8:	07a78863          	beq	a5,s10,658 <vprintf+0xf2>
      } else if(c == 'p') {
 5ec:	09b78463          	beq	a5,s11,674 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5f0:	07300713          	li	a4,115
 5f4:	0ce78663          	beq	a5,a4,6c0 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5f8:	06300713          	li	a4,99
 5fc:	0ee78e63          	beq	a5,a4,6f8 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 600:	11478863          	beq	a5,s4,710 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 604:	85d2                	mv	a1,s4
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	e92080e7          	jalr	-366(ra) # 49a <putc>
        putc(fd, c);
 610:	85ca                	mv	a1,s2
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e86080e7          	jalr	-378(ra) # 49a <putc>
      }
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b765                	j	5c6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 620:	008b0913          	addi	s2,s6,8
 624:	4685                	li	a3,1
 626:	4629                	li	a2,10
 628:	000b2583          	lw	a1,0(s6)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	e8e080e7          	jalr	-370(ra) # 4bc <printint>
 636:	8b4a                	mv	s6,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	b771                	j	5c6 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b0913          	addi	s2,s6,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000b2583          	lw	a1,0(s6)
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	e72080e7          	jalr	-398(ra) # 4bc <printint>
 652:	8b4a                	mv	s6,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	bf85                	j	5c6 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 658:	008b0913          	addi	s2,s6,8
 65c:	4681                	li	a3,0
 65e:	4641                	li	a2,16
 660:	000b2583          	lw	a1,0(s6)
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	e56080e7          	jalr	-426(ra) # 4bc <printint>
 66e:	8b4a                	mv	s6,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	bf91                	j	5c6 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 674:	008b0793          	addi	a5,s6,8
 678:	f8f43423          	sd	a5,-120(s0)
 67c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 680:	03000593          	li	a1,48
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e14080e7          	jalr	-492(ra) # 49a <putc>
  putc(fd, 'x');
 68e:	85ea                	mv	a1,s10
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e08080e7          	jalr	-504(ra) # 49a <putc>
 69a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 69c:	03c9d793          	srli	a5,s3,0x3c
 6a0:	97de                	add	a5,a5,s7
 6a2:	0007c583          	lbu	a1,0(a5)
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	df2080e7          	jalr	-526(ra) # 49a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b0:	0992                	slli	s3,s3,0x4
 6b2:	397d                	addiw	s2,s2,-1
 6b4:	fe0914e3          	bnez	s2,69c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6b8:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b721                	j	5c6 <vprintf+0x60>
        s = va_arg(ap, char*);
 6c0:	008b0993          	addi	s3,s6,8
 6c4:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6c8:	02090163          	beqz	s2,6ea <vprintf+0x184>
        while(*s != 0){
 6cc:	00094583          	lbu	a1,0(s2)
 6d0:	c9a1                	beqz	a1,720 <vprintf+0x1ba>
          putc(fd, *s);
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	dc6080e7          	jalr	-570(ra) # 49a <putc>
          s++;
 6dc:	0905                	addi	s2,s2,1
        while(*s != 0){
 6de:	00094583          	lbu	a1,0(s2)
 6e2:	f9e5                	bnez	a1,6d2 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6e4:	8b4e                	mv	s6,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bdf9                	j	5c6 <vprintf+0x60>
          s = "(null)";
 6ea:	00000917          	auipc	s2,0x0
 6ee:	23e90913          	addi	s2,s2,574 # 928 <malloc+0xf8>
        while(*s != 0){
 6f2:	02800593          	li	a1,40
 6f6:	bff1                	j	6d2 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6f8:	008b0913          	addi	s2,s6,8
 6fc:	000b4583          	lbu	a1,0(s6)
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	d98080e7          	jalr	-616(ra) # 49a <putc>
 70a:	8b4a                	mv	s6,s2
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bd65                	j	5c6 <vprintf+0x60>
        putc(fd, c);
 710:	85d2                	mv	a1,s4
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	d86080e7          	jalr	-634(ra) # 49a <putc>
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b565                	j	5c6 <vprintf+0x60>
        s = va_arg(ap, char*);
 720:	8b4e                	mv	s6,s3
      state = 0;
 722:	4981                	li	s3,0
 724:	b54d                	j	5c6 <vprintf+0x60>
    }
  }
}
 726:	70e6                	ld	ra,120(sp)
 728:	7446                	ld	s0,112(sp)
 72a:	74a6                	ld	s1,104(sp)
 72c:	7906                	ld	s2,96(sp)
 72e:	69e6                	ld	s3,88(sp)
 730:	6a46                	ld	s4,80(sp)
 732:	6aa6                	ld	s5,72(sp)
 734:	6b06                	ld	s6,64(sp)
 736:	7be2                	ld	s7,56(sp)
 738:	7c42                	ld	s8,48(sp)
 73a:	7ca2                	ld	s9,40(sp)
 73c:	7d02                	ld	s10,32(sp)
 73e:	6de2                	ld	s11,24(sp)
 740:	6109                	addi	sp,sp,128
 742:	8082                	ret

0000000000000744 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 744:	715d                	addi	sp,sp,-80
 746:	ec06                	sd	ra,24(sp)
 748:	e822                	sd	s0,16(sp)
 74a:	1000                	addi	s0,sp,32
 74c:	e010                	sd	a2,0(s0)
 74e:	e414                	sd	a3,8(s0)
 750:	e818                	sd	a4,16(s0)
 752:	ec1c                	sd	a5,24(s0)
 754:	03043023          	sd	a6,32(s0)
 758:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 760:	8622                	mv	a2,s0
 762:	00000097          	auipc	ra,0x0
 766:	e04080e7          	jalr	-508(ra) # 566 <vprintf>
}
 76a:	60e2                	ld	ra,24(sp)
 76c:	6442                	ld	s0,16(sp)
 76e:	6161                	addi	sp,sp,80
 770:	8082                	ret

0000000000000772 <printf>:

void
printf(const char *fmt, ...)
{
 772:	711d                	addi	sp,sp,-96
 774:	ec06                	sd	ra,24(sp)
 776:	e822                	sd	s0,16(sp)
 778:	1000                	addi	s0,sp,32
 77a:	e40c                	sd	a1,8(s0)
 77c:	e810                	sd	a2,16(s0)
 77e:	ec14                	sd	a3,24(s0)
 780:	f018                	sd	a4,32(s0)
 782:	f41c                	sd	a5,40(s0)
 784:	03043823          	sd	a6,48(s0)
 788:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78c:	00840613          	addi	a2,s0,8
 790:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 794:	85aa                	mv	a1,a0
 796:	4505                	li	a0,1
 798:	00000097          	auipc	ra,0x0
 79c:	dce080e7          	jalr	-562(ra) # 566 <vprintf>
}
 7a0:	60e2                	ld	ra,24(sp)
 7a2:	6442                	ld	s0,16(sp)
 7a4:	6125                	addi	sp,sp,96
 7a6:	8082                	ret

00000000000007a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a8:	1141                	addi	sp,sp,-16
 7aa:	e422                	sd	s0,8(sp)
 7ac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b2:	00000797          	auipc	a5,0x0
 7b6:	1967b783          	ld	a5,406(a5) # 948 <freep>
 7ba:	a805                	j	7ea <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7bc:	4618                	lw	a4,8(a2)
 7be:	9db9                	addw	a1,a1,a4
 7c0:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c4:	6398                	ld	a4,0(a5)
 7c6:	6318                	ld	a4,0(a4)
 7c8:	fee53823          	sd	a4,-16(a0)
 7cc:	a091                	j	810 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ce:	ff852703          	lw	a4,-8(a0)
 7d2:	9e39                	addw	a2,a2,a4
 7d4:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7d6:	ff053703          	ld	a4,-16(a0)
 7da:	e398                	sd	a4,0(a5)
 7dc:	a099                	j	822 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7de:	6398                	ld	a4,0(a5)
 7e0:	00e7e463          	bltu	a5,a4,7e8 <free+0x40>
 7e4:	00e6ea63          	bltu	a3,a4,7f8 <free+0x50>
{
 7e8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	fed7fae3          	bgeu	a5,a3,7de <free+0x36>
 7ee:	6398                	ld	a4,0(a5)
 7f0:	00e6e463          	bltu	a3,a4,7f8 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f4:	fee7eae3          	bltu	a5,a4,7e8 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7f8:	ff852583          	lw	a1,-8(a0)
 7fc:	6390                	ld	a2,0(a5)
 7fe:	02059713          	slli	a4,a1,0x20
 802:	9301                	srli	a4,a4,0x20
 804:	0712                	slli	a4,a4,0x4
 806:	9736                	add	a4,a4,a3
 808:	fae60ae3          	beq	a2,a4,7bc <free+0x14>
    bp->s.ptr = p->s.ptr;
 80c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 810:	4790                	lw	a2,8(a5)
 812:	02061713          	slli	a4,a2,0x20
 816:	9301                	srli	a4,a4,0x20
 818:	0712                	slli	a4,a4,0x4
 81a:	973e                	add	a4,a4,a5
 81c:	fae689e3          	beq	a3,a4,7ce <free+0x26>
  } else
    p->s.ptr = bp;
 820:	e394                	sd	a3,0(a5)
  freep = p;
 822:	00000717          	auipc	a4,0x0
 826:	12f73323          	sd	a5,294(a4) # 948 <freep>
}
 82a:	6422                	ld	s0,8(sp)
 82c:	0141                	addi	sp,sp,16
 82e:	8082                	ret

0000000000000830 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 830:	7139                	addi	sp,sp,-64
 832:	fc06                	sd	ra,56(sp)
 834:	f822                	sd	s0,48(sp)
 836:	f426                	sd	s1,40(sp)
 838:	f04a                	sd	s2,32(sp)
 83a:	ec4e                	sd	s3,24(sp)
 83c:	e852                	sd	s4,16(sp)
 83e:	e456                	sd	s5,8(sp)
 840:	e05a                	sd	s6,0(sp)
 842:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 844:	02051493          	slli	s1,a0,0x20
 848:	9081                	srli	s1,s1,0x20
 84a:	04bd                	addi	s1,s1,15
 84c:	8091                	srli	s1,s1,0x4
 84e:	0014899b          	addiw	s3,s1,1
 852:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 854:	00000517          	auipc	a0,0x0
 858:	0f453503          	ld	a0,244(a0) # 948 <freep>
 85c:	c515                	beqz	a0,888 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 860:	4798                	lw	a4,8(a5)
 862:	02977f63          	bgeu	a4,s1,8a0 <malloc+0x70>
 866:	8a4e                	mv	s4,s3
 868:	0009871b          	sext.w	a4,s3
 86c:	6685                	lui	a3,0x1
 86e:	00d77363          	bgeu	a4,a3,874 <malloc+0x44>
 872:	6a05                	lui	s4,0x1
 874:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 878:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87c:	00000917          	auipc	s2,0x0
 880:	0cc90913          	addi	s2,s2,204 # 948 <freep>
  if(p == (char*)-1)
 884:	5afd                	li	s5,-1
 886:	a88d                	j	8f8 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 888:	00000797          	auipc	a5,0x0
 88c:	0c878793          	addi	a5,a5,200 # 950 <base>
 890:	00000717          	auipc	a4,0x0
 894:	0af73c23          	sd	a5,184(a4) # 948 <freep>
 898:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 89e:	b7e1                	j	866 <malloc+0x36>
      if(p->s.size == nunits)
 8a0:	02e48b63          	beq	s1,a4,8d6 <malloc+0xa6>
        p->s.size -= nunits;
 8a4:	4137073b          	subw	a4,a4,s3
 8a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8aa:	1702                	slli	a4,a4,0x20
 8ac:	9301                	srli	a4,a4,0x20
 8ae:	0712                	slli	a4,a4,0x4
 8b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	08a73923          	sd	a0,146(a4) # 948 <freep>
      return (void*)(p + 1);
 8be:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c2:	70e2                	ld	ra,56(sp)
 8c4:	7442                	ld	s0,48(sp)
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	7902                	ld	s2,32(sp)
 8ca:	69e2                	ld	s3,24(sp)
 8cc:	6a42                	ld	s4,16(sp)
 8ce:	6aa2                	ld	s5,8(sp)
 8d0:	6b02                	ld	s6,0(sp)
 8d2:	6121                	addi	sp,sp,64
 8d4:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8d6:	6398                	ld	a4,0(a5)
 8d8:	e118                	sd	a4,0(a0)
 8da:	bff1                	j	8b6 <malloc+0x86>
  hp->s.size = nu;
 8dc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e0:	0541                	addi	a0,a0,16
 8e2:	00000097          	auipc	ra,0x0
 8e6:	ec6080e7          	jalr	-314(ra) # 7a8 <free>
  return freep;
 8ea:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ee:	d971                	beqz	a0,8c2 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f2:	4798                	lw	a4,8(a5)
 8f4:	fa9776e3          	bgeu	a4,s1,8a0 <malloc+0x70>
    if(p == freep)
 8f8:	00093703          	ld	a4,0(s2)
 8fc:	853e                	mv	a0,a5
 8fe:	fef719e3          	bne	a4,a5,8f0 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 902:	8552                	mv	a0,s4
 904:	00000097          	auipc	ra,0x0
 908:	b7e080e7          	jalr	-1154(ra) # 482 <sbrk>
  if(p == (char*)-1)
 90c:	fd5518e3          	bne	a0,s5,8dc <malloc+0xac>
        return 0;
 910:	4501                	li	a0,0
 912:	bf45                	j	8c2 <malloc+0x92>
