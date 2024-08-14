
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (argc != 2) {
   8:	4789                	li	a5,2
   a:	00f50f63          	beq	a0,a5,28 <main+0x28>
        printf("Usage: sleep <ticks>\n");
   e:	00000517          	auipc	a0,0x0
  12:	7ea50513          	addi	a0,a0,2026 # 7f8 <malloc+0xea>
  16:	00000097          	auipc	ra,0x0
  1a:	63a080e7          	jalr	1594(ra) # 650 <printf>
        exit(1);
  1e:	4505                	li	a0,1
  20:	00000097          	auipc	ra,0x0
  24:	2b8080e7          	jalr	696(ra) # 2d8 <exit>
    }

    int ticks = atoi(argv[1]);
  28:	6588                	ld	a0,8(a1)
  2a:	00000097          	auipc	ra,0x0
  2e:	1ae080e7          	jalr	430(ra) # 1d8 <atoi>
    if (ticks < 0) {
  32:	00054b63          	bltz	a0,48 <main+0x48>
        printf("Error: ticks must be a positive integer\n");
        exit(1);
    }

    sleep(ticks);
  36:	00000097          	auipc	ra,0x0
  3a:	332080e7          	jalr	818(ra) # 368 <sleep>
    exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	298080e7          	jalr	664(ra) # 2d8 <exit>
        printf("Error: ticks must be a positive integer\n");
  48:	00000517          	auipc	a0,0x0
  4c:	7c850513          	addi	a0,a0,1992 # 810 <malloc+0x102>
  50:	00000097          	auipc	ra,0x0
  54:	600080e7          	jalr	1536(ra) # 650 <printf>
        exit(1);
  58:	4505                	li	a0,1
  5a:	00000097          	auipc	ra,0x0
  5e:	27e080e7          	jalr	638(ra) # 2d8 <exit>

0000000000000062 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  62:	1141                	addi	sp,sp,-16
  64:	e422                	sd	s0,8(sp)
  66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	87aa                	mv	a5,a0
  6a:	0585                	addi	a1,a1,1
  6c:	0785                	addi	a5,a5,1
  6e:	fff5c703          	lbu	a4,-1(a1)
  72:	fee78fa3          	sb	a4,-1(a5)
  76:	fb75                	bnez	a4,6a <strcpy+0x8>
    ;
  return os;
}
  78:	6422                	ld	s0,8(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  84:	00054783          	lbu	a5,0(a0)
  88:	cb91                	beqz	a5,9c <strcmp+0x1e>
  8a:	0005c703          	lbu	a4,0(a1)
  8e:	00f71763          	bne	a4,a5,9c <strcmp+0x1e>
    p++, q++;
  92:	0505                	addi	a0,a0,1
  94:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	fbe5                	bnez	a5,8a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9c:	0005c503          	lbu	a0,0(a1)
}
  a0:	40a7853b          	subw	a0,a5,a0
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret

00000000000000aa <strlen>:

uint
strlen(const char *s)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	cf91                	beqz	a5,d0 <strlen+0x26>
  b6:	0505                	addi	a0,a0,1
  b8:	87aa                	mv	a5,a0
  ba:	4685                	li	a3,1
  bc:	9e89                	subw	a3,a3,a0
  be:	00f6853b          	addw	a0,a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	fb7d                	bnez	a4,be <strlen+0x14>
    ;
  return n;
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret
  for(n = 0; s[n]; n++)
  d0:	4501                	li	a0,0
  d2:	bfe5                	j	ca <strlen+0x20>

00000000000000d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  da:	ce09                	beqz	a2,f4 <memset+0x20>
  dc:	87aa                	mv	a5,a0
  de:	fff6071b          	addiw	a4,a2,-1
  e2:	1702                	slli	a4,a4,0x20
  e4:	9301                	srli	a4,a4,0x20
  e6:	0705                	addi	a4,a4,1
  e8:	972a                	add	a4,a4,a0
    cdst[i] = c;
  ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ee:	0785                	addi	a5,a5,1
  f0:	fee79de3          	bne	a5,a4,ea <memset+0x16>
  }
  return dst;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb99                	beqz	a5,11a <strchr+0x20>
    if(*s == c)
 106:	00f58763          	beq	a1,a5,114 <strchr+0x1a>
  for(; *s; s++)
 10a:	0505                	addi	a0,a0,1
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbfd                	bnez	a5,106 <strchr+0xc>
      return (char*)s;
  return 0;
 112:	4501                	li	a0,0
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  return 0;
 11a:	4501                	li	a0,0
 11c:	bfe5                	j	114 <strchr+0x1a>

000000000000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	711d                	addi	sp,sp,-96
 120:	ec86                	sd	ra,88(sp)
 122:	e8a2                	sd	s0,80(sp)
 124:	e4a6                	sd	s1,72(sp)
 126:	e0ca                	sd	s2,64(sp)
 128:	fc4e                	sd	s3,56(sp)
 12a:	f852                	sd	s4,48(sp)
 12c:	f456                	sd	s5,40(sp)
 12e:	f05a                	sd	s6,32(sp)
 130:	ec5e                	sd	s7,24(sp)
 132:	1080                	addi	s0,sp,96
 134:	8baa                	mv	s7,a0
 136:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 138:	892a                	mv	s2,a0
 13a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13c:	4aa9                	li	s5,10
 13e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 140:	89a6                	mv	s3,s1
 142:	2485                	addiw	s1,s1,1
 144:	0344d863          	bge	s1,s4,174 <gets+0x56>
    cc = read(0, &c, 1);
 148:	4605                	li	a2,1
 14a:	faf40593          	addi	a1,s0,-81
 14e:	4501                	li	a0,0
 150:	00000097          	auipc	ra,0x0
 154:	1a0080e7          	jalr	416(ra) # 2f0 <read>
    if(cc < 1)
 158:	00a05e63          	blez	a0,174 <gets+0x56>
    buf[i++] = c;
 15c:	faf44783          	lbu	a5,-81(s0)
 160:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 164:	01578763          	beq	a5,s5,172 <gets+0x54>
 168:	0905                	addi	s2,s2,1
 16a:	fd679be3          	bne	a5,s6,140 <gets+0x22>
  for(i=0; i+1 < max; ){
 16e:	89a6                	mv	s3,s1
 170:	a011                	j	174 <gets+0x56>
 172:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 174:	99de                	add	s3,s3,s7
 176:	00098023          	sb	zero,0(s3)
  return buf;
}
 17a:	855e                	mv	a0,s7
 17c:	60e6                	ld	ra,88(sp)
 17e:	6446                	ld	s0,80(sp)
 180:	64a6                	ld	s1,72(sp)
 182:	6906                	ld	s2,64(sp)
 184:	79e2                	ld	s3,56(sp)
 186:	7a42                	ld	s4,48(sp)
 188:	7aa2                	ld	s5,40(sp)
 18a:	7b02                	ld	s6,32(sp)
 18c:	6be2                	ld	s7,24(sp)
 18e:	6125                	addi	sp,sp,96
 190:	8082                	ret

0000000000000192 <stat>:

int
stat(const char *n, struct stat *st)
{
 192:	1101                	addi	sp,sp,-32
 194:	ec06                	sd	ra,24(sp)
 196:	e822                	sd	s0,16(sp)
 198:	e426                	sd	s1,8(sp)
 19a:	e04a                	sd	s2,0(sp)
 19c:	1000                	addi	s0,sp,32
 19e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a0:	4581                	li	a1,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	176080e7          	jalr	374(ra) # 318 <open>
  if(fd < 0)
 1aa:	02054563          	bltz	a0,1d4 <stat+0x42>
 1ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b0:	85ca                	mv	a1,s2
 1b2:	00000097          	auipc	ra,0x0
 1b6:	17e080e7          	jalr	382(ra) # 330 <fstat>
 1ba:	892a                	mv	s2,a0
  close(fd);
 1bc:	8526                	mv	a0,s1
 1be:	00000097          	auipc	ra,0x0
 1c2:	142080e7          	jalr	322(ra) # 300 <close>
  return r;
}
 1c6:	854a                	mv	a0,s2
 1c8:	60e2                	ld	ra,24(sp)
 1ca:	6442                	ld	s0,16(sp)
 1cc:	64a2                	ld	s1,8(sp)
 1ce:	6902                	ld	s2,0(sp)
 1d0:	6105                	addi	sp,sp,32
 1d2:	8082                	ret
    return -1;
 1d4:	597d                	li	s2,-1
 1d6:	bfc5                	j	1c6 <stat+0x34>

00000000000001d8 <atoi>:

int
atoi(const char *s)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1de:	00054603          	lbu	a2,0(a0)
 1e2:	fd06079b          	addiw	a5,a2,-48
 1e6:	0ff7f793          	andi	a5,a5,255
 1ea:	4725                	li	a4,9
 1ec:	02f76963          	bltu	a4,a5,21e <atoi+0x46>
 1f0:	86aa                	mv	a3,a0
  n = 0;
 1f2:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 1f4:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 1f6:	0685                	addi	a3,a3,1
 1f8:	0025179b          	slliw	a5,a0,0x2
 1fc:	9fa9                	addw	a5,a5,a0
 1fe:	0017979b          	slliw	a5,a5,0x1
 202:	9fb1                	addw	a5,a5,a2
 204:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 208:	0006c603          	lbu	a2,0(a3)
 20c:	fd06071b          	addiw	a4,a2,-48
 210:	0ff77713          	andi	a4,a4,255
 214:	fee5f1e3          	bgeu	a1,a4,1f6 <atoi+0x1e>
  return n;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  n = 0;
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <atoi+0x40>

0000000000000222 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 228:	02b57663          	bgeu	a0,a1,254 <memmove+0x32>
    while(n-- > 0)
 22c:	02c05163          	blez	a2,24e <memmove+0x2c>
 230:	fff6079b          	addiw	a5,a2,-1
 234:	1782                	slli	a5,a5,0x20
 236:	9381                	srli	a5,a5,0x20
 238:	0785                	addi	a5,a5,1
 23a:	97aa                	add	a5,a5,a0
  dst = vdst;
 23c:	872a                	mv	a4,a0
      *dst++ = *src++;
 23e:	0585                	addi	a1,a1,1
 240:	0705                	addi	a4,a4,1
 242:	fff5c683          	lbu	a3,-1(a1)
 246:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24a:	fee79ae3          	bne	a5,a4,23e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 24e:	6422                	ld	s0,8(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret
    dst += n;
 254:	00c50733          	add	a4,a0,a2
    src += n;
 258:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 25a:	fec05ae3          	blez	a2,24e <memmove+0x2c>
 25e:	fff6079b          	addiw	a5,a2,-1
 262:	1782                	slli	a5,a5,0x20
 264:	9381                	srli	a5,a5,0x20
 266:	fff7c793          	not	a5,a5
 26a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 26c:	15fd                	addi	a1,a1,-1
 26e:	177d                	addi	a4,a4,-1
 270:	0005c683          	lbu	a3,0(a1)
 274:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 278:	fee79ae3          	bne	a5,a4,26c <memmove+0x4a>
 27c:	bfc9                	j	24e <memmove+0x2c>

000000000000027e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 284:	ca05                	beqz	a2,2b4 <memcmp+0x36>
 286:	fff6069b          	addiw	a3,a2,-1
 28a:	1682                	slli	a3,a3,0x20
 28c:	9281                	srli	a3,a3,0x20
 28e:	0685                	addi	a3,a3,1
 290:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 292:	00054783          	lbu	a5,0(a0)
 296:	0005c703          	lbu	a4,0(a1)
 29a:	00e79863          	bne	a5,a4,2aa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 29e:	0505                	addi	a0,a0,1
    p2++;
 2a0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a2:	fed518e3          	bne	a0,a3,292 <memcmp+0x14>
  }
  return 0;
 2a6:	4501                	li	a0,0
 2a8:	a019                	j	2ae <memcmp+0x30>
      return *p1 - *p2;
 2aa:	40e7853b          	subw	a0,a5,a4
}
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	bfe5                	j	2ae <memcmp+0x30>

00000000000002b8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c0:	00000097          	auipc	ra,0x0
 2c4:	f62080e7          	jalr	-158(ra) # 222 <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d0:	4885                	li	a7,1
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d8:	4889                	li	a7,2
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e0:	488d                	li	a7,3
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e8:	4891                	li	a7,4
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <read>:
.global read
read:
 li a7, SYS_read
 2f0:	4895                	li	a7,5
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <write>:
.global write
write:
 li a7, SYS_write
 2f8:	48c1                	li	a7,16
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <close>:
.global close
close:
 li a7, SYS_close
 300:	48d5                	li	a7,21
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <kill>:
.global kill
kill:
 li a7, SYS_kill
 308:	4899                	li	a7,6
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <exec>:
.global exec
exec:
 li a7, SYS_exec
 310:	489d                	li	a7,7
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <open>:
.global open
open:
 li a7, SYS_open
 318:	48bd                	li	a7,15
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 320:	48c5                	li	a7,17
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 328:	48c9                	li	a7,18
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 330:	48a1                	li	a7,8
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <link>:
.global link
link:
 li a7, SYS_link
 338:	48cd                	li	a7,19
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 340:	48d1                	li	a7,20
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 348:	48a5                	li	a7,9
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <dup>:
.global dup
dup:
 li a7, SYS_dup
 350:	48a9                	li	a7,10
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 358:	48ad                	li	a7,11
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 360:	48b1                	li	a7,12
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 368:	48b5                	li	a7,13
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 370:	48b9                	li	a7,14
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 378:	1101                	addi	sp,sp,-32
 37a:	ec06                	sd	ra,24(sp)
 37c:	e822                	sd	s0,16(sp)
 37e:	1000                	addi	s0,sp,32
 380:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 384:	4605                	li	a2,1
 386:	fef40593          	addi	a1,s0,-17
 38a:	00000097          	auipc	ra,0x0
 38e:	f6e080e7          	jalr	-146(ra) # 2f8 <write>
}
 392:	60e2                	ld	ra,24(sp)
 394:	6442                	ld	s0,16(sp)
 396:	6105                	addi	sp,sp,32
 398:	8082                	ret

000000000000039a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39a:	7139                	addi	sp,sp,-64
 39c:	fc06                	sd	ra,56(sp)
 39e:	f822                	sd	s0,48(sp)
 3a0:	f426                	sd	s1,40(sp)
 3a2:	f04a                	sd	s2,32(sp)
 3a4:	ec4e                	sd	s3,24(sp)
 3a6:	0080                	addi	s0,sp,64
 3a8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3aa:	c299                	beqz	a3,3b0 <printint+0x16>
 3ac:	0805c863          	bltz	a1,43c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3b0:	2581                	sext.w	a1,a1
  neg = 0;
 3b2:	4881                	li	a7,0
 3b4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3b8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ba:	2601                	sext.w	a2,a2
 3bc:	00000517          	auipc	a0,0x0
 3c0:	48c50513          	addi	a0,a0,1164 # 848 <digits>
 3c4:	883a                	mv	a6,a4
 3c6:	2705                	addiw	a4,a4,1
 3c8:	02c5f7bb          	remuw	a5,a1,a2
 3cc:	1782                	slli	a5,a5,0x20
 3ce:	9381                	srli	a5,a5,0x20
 3d0:	97aa                	add	a5,a5,a0
 3d2:	0007c783          	lbu	a5,0(a5)
 3d6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3da:	0005879b          	sext.w	a5,a1
 3de:	02c5d5bb          	divuw	a1,a1,a2
 3e2:	0685                	addi	a3,a3,1
 3e4:	fec7f0e3          	bgeu	a5,a2,3c4 <printint+0x2a>
  if(neg)
 3e8:	00088b63          	beqz	a7,3fe <printint+0x64>
    buf[i++] = '-';
 3ec:	fd040793          	addi	a5,s0,-48
 3f0:	973e                	add	a4,a4,a5
 3f2:	02d00793          	li	a5,45
 3f6:	fef70823          	sb	a5,-16(a4)
 3fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3fe:	02e05863          	blez	a4,42e <printint+0x94>
 402:	fc040793          	addi	a5,s0,-64
 406:	00e78933          	add	s2,a5,a4
 40a:	fff78993          	addi	s3,a5,-1
 40e:	99ba                	add	s3,s3,a4
 410:	377d                	addiw	a4,a4,-1
 412:	1702                	slli	a4,a4,0x20
 414:	9301                	srli	a4,a4,0x20
 416:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 41a:	fff94583          	lbu	a1,-1(s2)
 41e:	8526                	mv	a0,s1
 420:	00000097          	auipc	ra,0x0
 424:	f58080e7          	jalr	-168(ra) # 378 <putc>
  while(--i >= 0)
 428:	197d                	addi	s2,s2,-1
 42a:	ff3918e3          	bne	s2,s3,41a <printint+0x80>
}
 42e:	70e2                	ld	ra,56(sp)
 430:	7442                	ld	s0,48(sp)
 432:	74a2                	ld	s1,40(sp)
 434:	7902                	ld	s2,32(sp)
 436:	69e2                	ld	s3,24(sp)
 438:	6121                	addi	sp,sp,64
 43a:	8082                	ret
    x = -xx;
 43c:	40b005bb          	negw	a1,a1
    neg = 1;
 440:	4885                	li	a7,1
    x = -xx;
 442:	bf8d                	j	3b4 <printint+0x1a>

0000000000000444 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 444:	7119                	addi	sp,sp,-128
 446:	fc86                	sd	ra,120(sp)
 448:	f8a2                	sd	s0,112(sp)
 44a:	f4a6                	sd	s1,104(sp)
 44c:	f0ca                	sd	s2,96(sp)
 44e:	ecce                	sd	s3,88(sp)
 450:	e8d2                	sd	s4,80(sp)
 452:	e4d6                	sd	s5,72(sp)
 454:	e0da                	sd	s6,64(sp)
 456:	fc5e                	sd	s7,56(sp)
 458:	f862                	sd	s8,48(sp)
 45a:	f466                	sd	s9,40(sp)
 45c:	f06a                	sd	s10,32(sp)
 45e:	ec6e                	sd	s11,24(sp)
 460:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 462:	0005c903          	lbu	s2,0(a1)
 466:	18090f63          	beqz	s2,604 <vprintf+0x1c0>
 46a:	8aaa                	mv	s5,a0
 46c:	8b32                	mv	s6,a2
 46e:	00158493          	addi	s1,a1,1
  state = 0;
 472:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 474:	02500a13          	li	s4,37
      if(c == 'd'){
 478:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 47c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 480:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 484:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 488:	00000b97          	auipc	s7,0x0
 48c:	3c0b8b93          	addi	s7,s7,960 # 848 <digits>
 490:	a839                	j	4ae <vprintf+0x6a>
        putc(fd, c);
 492:	85ca                	mv	a1,s2
 494:	8556                	mv	a0,s5
 496:	00000097          	auipc	ra,0x0
 49a:	ee2080e7          	jalr	-286(ra) # 378 <putc>
 49e:	a019                	j	4a4 <vprintf+0x60>
    } else if(state == '%'){
 4a0:	01498f63          	beq	s3,s4,4be <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 4a4:	0485                	addi	s1,s1,1
 4a6:	fff4c903          	lbu	s2,-1(s1)
 4aa:	14090d63          	beqz	s2,604 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 4ae:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4b2:	fe0997e3          	bnez	s3,4a0 <vprintf+0x5c>
      if(c == '%'){
 4b6:	fd479ee3          	bne	a5,s4,492 <vprintf+0x4e>
        state = '%';
 4ba:	89be                	mv	s3,a5
 4bc:	b7e5                	j	4a4 <vprintf+0x60>
      if(c == 'd'){
 4be:	05878063          	beq	a5,s8,4fe <vprintf+0xba>
      } else if(c == 'l') {
 4c2:	05978c63          	beq	a5,s9,51a <vprintf+0xd6>
      } else if(c == 'x') {
 4c6:	07a78863          	beq	a5,s10,536 <vprintf+0xf2>
      } else if(c == 'p') {
 4ca:	09b78463          	beq	a5,s11,552 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 4ce:	07300713          	li	a4,115
 4d2:	0ce78663          	beq	a5,a4,59e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4d6:	06300713          	li	a4,99
 4da:	0ee78e63          	beq	a5,a4,5d6 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 4de:	11478863          	beq	a5,s4,5ee <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4e2:	85d2                	mv	a1,s4
 4e4:	8556                	mv	a0,s5
 4e6:	00000097          	auipc	ra,0x0
 4ea:	e92080e7          	jalr	-366(ra) # 378 <putc>
        putc(fd, c);
 4ee:	85ca                	mv	a1,s2
 4f0:	8556                	mv	a0,s5
 4f2:	00000097          	auipc	ra,0x0
 4f6:	e86080e7          	jalr	-378(ra) # 378 <putc>
      }
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	b765                	j	4a4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 4fe:	008b0913          	addi	s2,s6,8
 502:	4685                	li	a3,1
 504:	4629                	li	a2,10
 506:	000b2583          	lw	a1,0(s6)
 50a:	8556                	mv	a0,s5
 50c:	00000097          	auipc	ra,0x0
 510:	e8e080e7          	jalr	-370(ra) # 39a <printint>
 514:	8b4a                	mv	s6,s2
      state = 0;
 516:	4981                	li	s3,0
 518:	b771                	j	4a4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 51a:	008b0913          	addi	s2,s6,8
 51e:	4681                	li	a3,0
 520:	4629                	li	a2,10
 522:	000b2583          	lw	a1,0(s6)
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	e72080e7          	jalr	-398(ra) # 39a <printint>
 530:	8b4a                	mv	s6,s2
      state = 0;
 532:	4981                	li	s3,0
 534:	bf85                	j	4a4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 536:	008b0913          	addi	s2,s6,8
 53a:	4681                	li	a3,0
 53c:	4641                	li	a2,16
 53e:	000b2583          	lw	a1,0(s6)
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e56080e7          	jalr	-426(ra) # 39a <printint>
 54c:	8b4a                	mv	s6,s2
      state = 0;
 54e:	4981                	li	s3,0
 550:	bf91                	j	4a4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 552:	008b0793          	addi	a5,s6,8
 556:	f8f43423          	sd	a5,-120(s0)
 55a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 55e:	03000593          	li	a1,48
 562:	8556                	mv	a0,s5
 564:	00000097          	auipc	ra,0x0
 568:	e14080e7          	jalr	-492(ra) # 378 <putc>
  putc(fd, 'x');
 56c:	85ea                	mv	a1,s10
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	e08080e7          	jalr	-504(ra) # 378 <putc>
 578:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 57a:	03c9d793          	srli	a5,s3,0x3c
 57e:	97de                	add	a5,a5,s7
 580:	0007c583          	lbu	a1,0(a5)
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	df2080e7          	jalr	-526(ra) # 378 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 58e:	0992                	slli	s3,s3,0x4
 590:	397d                	addiw	s2,s2,-1
 592:	fe0914e3          	bnez	s2,57a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 596:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b721                	j	4a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 59e:	008b0993          	addi	s3,s6,8
 5a2:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 5a6:	02090163          	beqz	s2,5c8 <vprintf+0x184>
        while(*s != 0){
 5aa:	00094583          	lbu	a1,0(s2)
 5ae:	c9a1                	beqz	a1,5fe <vprintf+0x1ba>
          putc(fd, *s);
 5b0:	8556                	mv	a0,s5
 5b2:	00000097          	auipc	ra,0x0
 5b6:	dc6080e7          	jalr	-570(ra) # 378 <putc>
          s++;
 5ba:	0905                	addi	s2,s2,1
        while(*s != 0){
 5bc:	00094583          	lbu	a1,0(s2)
 5c0:	f9e5                	bnez	a1,5b0 <vprintf+0x16c>
        s = va_arg(ap, char*);
 5c2:	8b4e                	mv	s6,s3
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bdf9                	j	4a4 <vprintf+0x60>
          s = "(null)";
 5c8:	00000917          	auipc	s2,0x0
 5cc:	27890913          	addi	s2,s2,632 # 840 <malloc+0x132>
        while(*s != 0){
 5d0:	02800593          	li	a1,40
 5d4:	bff1                	j	5b0 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 5d6:	008b0913          	addi	s2,s6,8
 5da:	000b4583          	lbu	a1,0(s6)
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	d98080e7          	jalr	-616(ra) # 378 <putc>
 5e8:	8b4a                	mv	s6,s2
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	bd65                	j	4a4 <vprintf+0x60>
        putc(fd, c);
 5ee:	85d2                	mv	a1,s4
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	d86080e7          	jalr	-634(ra) # 378 <putc>
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b565                	j	4a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 5fe:	8b4e                	mv	s6,s3
      state = 0;
 600:	4981                	li	s3,0
 602:	b54d                	j	4a4 <vprintf+0x60>
    }
  }
}
 604:	70e6                	ld	ra,120(sp)
 606:	7446                	ld	s0,112(sp)
 608:	74a6                	ld	s1,104(sp)
 60a:	7906                	ld	s2,96(sp)
 60c:	69e6                	ld	s3,88(sp)
 60e:	6a46                	ld	s4,80(sp)
 610:	6aa6                	ld	s5,72(sp)
 612:	6b06                	ld	s6,64(sp)
 614:	7be2                	ld	s7,56(sp)
 616:	7c42                	ld	s8,48(sp)
 618:	7ca2                	ld	s9,40(sp)
 61a:	7d02                	ld	s10,32(sp)
 61c:	6de2                	ld	s11,24(sp)
 61e:	6109                	addi	sp,sp,128
 620:	8082                	ret

0000000000000622 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 622:	715d                	addi	sp,sp,-80
 624:	ec06                	sd	ra,24(sp)
 626:	e822                	sd	s0,16(sp)
 628:	1000                	addi	s0,sp,32
 62a:	e010                	sd	a2,0(s0)
 62c:	e414                	sd	a3,8(s0)
 62e:	e818                	sd	a4,16(s0)
 630:	ec1c                	sd	a5,24(s0)
 632:	03043023          	sd	a6,32(s0)
 636:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 63a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 63e:	8622                	mv	a2,s0
 640:	00000097          	auipc	ra,0x0
 644:	e04080e7          	jalr	-508(ra) # 444 <vprintf>
}
 648:	60e2                	ld	ra,24(sp)
 64a:	6442                	ld	s0,16(sp)
 64c:	6161                	addi	sp,sp,80
 64e:	8082                	ret

0000000000000650 <printf>:

void
printf(const char *fmt, ...)
{
 650:	711d                	addi	sp,sp,-96
 652:	ec06                	sd	ra,24(sp)
 654:	e822                	sd	s0,16(sp)
 656:	1000                	addi	s0,sp,32
 658:	e40c                	sd	a1,8(s0)
 65a:	e810                	sd	a2,16(s0)
 65c:	ec14                	sd	a3,24(s0)
 65e:	f018                	sd	a4,32(s0)
 660:	f41c                	sd	a5,40(s0)
 662:	03043823          	sd	a6,48(s0)
 666:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 66a:	00840613          	addi	a2,s0,8
 66e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 672:	85aa                	mv	a1,a0
 674:	4505                	li	a0,1
 676:	00000097          	auipc	ra,0x0
 67a:	dce080e7          	jalr	-562(ra) # 444 <vprintf>
}
 67e:	60e2                	ld	ra,24(sp)
 680:	6442                	ld	s0,16(sp)
 682:	6125                	addi	sp,sp,96
 684:	8082                	ret

0000000000000686 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 686:	1141                	addi	sp,sp,-16
 688:	e422                	sd	s0,8(sp)
 68a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 690:	00000797          	auipc	a5,0x0
 694:	1d07b783          	ld	a5,464(a5) # 860 <freep>
 698:	a805                	j	6c8 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 69a:	4618                	lw	a4,8(a2)
 69c:	9db9                	addw	a1,a1,a4
 69e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a2:	6398                	ld	a4,0(a5)
 6a4:	6318                	ld	a4,0(a4)
 6a6:	fee53823          	sd	a4,-16(a0)
 6aa:	a091                	j	6ee <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ac:	ff852703          	lw	a4,-8(a0)
 6b0:	9e39                	addw	a2,a2,a4
 6b2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 6b4:	ff053703          	ld	a4,-16(a0)
 6b8:	e398                	sd	a4,0(a5)
 6ba:	a099                	j	700 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6bc:	6398                	ld	a4,0(a5)
 6be:	00e7e463          	bltu	a5,a4,6c6 <free+0x40>
 6c2:	00e6ea63          	bltu	a3,a4,6d6 <free+0x50>
{
 6c6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c8:	fed7fae3          	bgeu	a5,a3,6bc <free+0x36>
 6cc:	6398                	ld	a4,0(a5)
 6ce:	00e6e463          	bltu	a3,a4,6d6 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d2:	fee7eae3          	bltu	a5,a4,6c6 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 6d6:	ff852583          	lw	a1,-8(a0)
 6da:	6390                	ld	a2,0(a5)
 6dc:	02059713          	slli	a4,a1,0x20
 6e0:	9301                	srli	a4,a4,0x20
 6e2:	0712                	slli	a4,a4,0x4
 6e4:	9736                	add	a4,a4,a3
 6e6:	fae60ae3          	beq	a2,a4,69a <free+0x14>
    bp->s.ptr = p->s.ptr;
 6ea:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ee:	4790                	lw	a2,8(a5)
 6f0:	02061713          	slli	a4,a2,0x20
 6f4:	9301                	srli	a4,a4,0x20
 6f6:	0712                	slli	a4,a4,0x4
 6f8:	973e                	add	a4,a4,a5
 6fa:	fae689e3          	beq	a3,a4,6ac <free+0x26>
  } else
    p->s.ptr = bp;
 6fe:	e394                	sd	a3,0(a5)
  freep = p;
 700:	00000717          	auipc	a4,0x0
 704:	16f73023          	sd	a5,352(a4) # 860 <freep>
}
 708:	6422                	ld	s0,8(sp)
 70a:	0141                	addi	sp,sp,16
 70c:	8082                	ret

000000000000070e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 70e:	7139                	addi	sp,sp,-64
 710:	fc06                	sd	ra,56(sp)
 712:	f822                	sd	s0,48(sp)
 714:	f426                	sd	s1,40(sp)
 716:	f04a                	sd	s2,32(sp)
 718:	ec4e                	sd	s3,24(sp)
 71a:	e852                	sd	s4,16(sp)
 71c:	e456                	sd	s5,8(sp)
 71e:	e05a                	sd	s6,0(sp)
 720:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 722:	02051493          	slli	s1,a0,0x20
 726:	9081                	srli	s1,s1,0x20
 728:	04bd                	addi	s1,s1,15
 72a:	8091                	srli	s1,s1,0x4
 72c:	0014899b          	addiw	s3,s1,1
 730:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 732:	00000517          	auipc	a0,0x0
 736:	12e53503          	ld	a0,302(a0) # 860 <freep>
 73a:	c515                	beqz	a0,766 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 73e:	4798                	lw	a4,8(a5)
 740:	02977f63          	bgeu	a4,s1,77e <malloc+0x70>
 744:	8a4e                	mv	s4,s3
 746:	0009871b          	sext.w	a4,s3
 74a:	6685                	lui	a3,0x1
 74c:	00d77363          	bgeu	a4,a3,752 <malloc+0x44>
 750:	6a05                	lui	s4,0x1
 752:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 756:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 75a:	00000917          	auipc	s2,0x0
 75e:	10690913          	addi	s2,s2,262 # 860 <freep>
  if(p == (char*)-1)
 762:	5afd                	li	s5,-1
 764:	a88d                	j	7d6 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 766:	00000797          	auipc	a5,0x0
 76a:	10278793          	addi	a5,a5,258 # 868 <base>
 76e:	00000717          	auipc	a4,0x0
 772:	0ef73923          	sd	a5,242(a4) # 860 <freep>
 776:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 778:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 77c:	b7e1                	j	744 <malloc+0x36>
      if(p->s.size == nunits)
 77e:	02e48b63          	beq	s1,a4,7b4 <malloc+0xa6>
        p->s.size -= nunits;
 782:	4137073b          	subw	a4,a4,s3
 786:	c798                	sw	a4,8(a5)
        p += p->s.size;
 788:	1702                	slli	a4,a4,0x20
 78a:	9301                	srli	a4,a4,0x20
 78c:	0712                	slli	a4,a4,0x4
 78e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 790:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 794:	00000717          	auipc	a4,0x0
 798:	0ca73623          	sd	a0,204(a4) # 860 <freep>
      return (void*)(p + 1);
 79c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7a0:	70e2                	ld	ra,56(sp)
 7a2:	7442                	ld	s0,48(sp)
 7a4:	74a2                	ld	s1,40(sp)
 7a6:	7902                	ld	s2,32(sp)
 7a8:	69e2                	ld	s3,24(sp)
 7aa:	6a42                	ld	s4,16(sp)
 7ac:	6aa2                	ld	s5,8(sp)
 7ae:	6b02                	ld	s6,0(sp)
 7b0:	6121                	addi	sp,sp,64
 7b2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7b4:	6398                	ld	a4,0(a5)
 7b6:	e118                	sd	a4,0(a0)
 7b8:	bff1                	j	794 <malloc+0x86>
  hp->s.size = nu;
 7ba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7be:	0541                	addi	a0,a0,16
 7c0:	00000097          	auipc	ra,0x0
 7c4:	ec6080e7          	jalr	-314(ra) # 686 <free>
  return freep;
 7c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7cc:	d971                	beqz	a0,7a0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d0:	4798                	lw	a4,8(a5)
 7d2:	fa9776e3          	bgeu	a4,s1,77e <malloc+0x70>
    if(p == freep)
 7d6:	00093703          	ld	a4,0(s2)
 7da:	853e                	mv	a0,a5
 7dc:	fef719e3          	bne	a4,a5,7ce <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 7e0:	8552                	mv	a0,s4
 7e2:	00000097          	auipc	ra,0x0
 7e6:	b7e080e7          	jalr	-1154(ra) # 360 <sbrk>
  if(p == (char*)-1)
 7ea:	fd5518e3          	bne	a0,s5,7ba <malloc+0xac>
        return 0;
 7ee:	4501                	li	a0,0
 7f0:	bf45                	j	7a0 <malloc+0x92>
