
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	92013103          	ld	sp,-1760(sp) # 80008920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	183050ef          	jal	ra,80005998 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	21078793          	addi	a5,a5,528 # 80021240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	338080e7          	jalr	824(ra) # 80006392 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3d8080e7          	jalr	984(ra) # 80006446 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	dbe080e7          	jalr	-578(ra) # 80005e48 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	20e080e7          	jalr	526(ra) # 80006302 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00021517          	auipc	a0,0x21
    80000104:	14050513          	addi	a0,a0,320 # 80021240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	266080e7          	jalr	614(ra) # 80006392 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	302080e7          	jalr	770(ra) # 80006446 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	2d8080e7          	jalr	728(ra) # 80006446 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	b36080e7          	jalr	-1226(ra) # 80005e92 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	728080e7          	jalr	1832(ra) # 80001a94 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	fac080e7          	jalr	-84(ra) # 80005320 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fd6080e7          	jalr	-42(ra) # 80001352 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	9d6080e7          	jalr	-1578(ra) # 80005d5a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	cec080e7          	jalr	-788(ra) # 80006078 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	3cc50513          	addi	a0,a0,972 # 80008760 <syscalls+0x398>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	af6080e7          	jalr	-1290(ra) # 80005e92 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	ae6080e7          	jalr	-1306(ra) # 80005e92 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	3ac50513          	addi	a0,a0,940 # 80008760 <syscalls+0x398>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	ad6080e7          	jalr	-1322(ra) # 80005e92 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	688080e7          	jalr	1672(ra) # 80001a6c <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6a8080e7          	jalr	1704(ra) # 80001a94 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	f16080e7          	jalr	-234(ra) # 8000530a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	f24080e7          	jalr	-220(ra) # 80005320 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	dd2080e7          	jalr	-558(ra) # 800021d6 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	528080e7          	jalr	1320(ra) # 80002934 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	57e080e7          	jalr	1406(ra) # 80003992 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	026080e7          	jalr	38(ra) # 80005442 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cfc080e7          	jalr	-772(ra) # 80001120 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	9ba080e7          	jalr	-1606(ra) # 80005e48 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	8c2080e7          	jalr	-1854(ra) # 80005e48 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	8b2080e7          	jalr	-1870(ra) # 80005e48 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00006097          	auipc	ra,0x6
    80000614:	838080e7          	jalr	-1992(ra) # 80005e48 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	6ec080e7          	jalr	1772(ra) # 80005e48 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	6dc080e7          	jalr	1756(ra) # 80005e48 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	6cc080e7          	jalr	1740(ra) # 80005e48 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	6bc080e7          	jalr	1724(ra) # 80005e48 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	5de080e7          	jalr	1502(ra) # 80005e48 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	49c080e7          	jalr	1180(ra) # 80005e48 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	3c0080e7          	jalr	960(ra) # 80005e48 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	3b0080e7          	jalr	944(ra) # 80005e48 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	346080e7          	jalr	838(ra) # 80005e48 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	00009a17          	auipc	s4,0x9
    80000d0a:	58aa0a13          	addi	s4,s4,1418 # 8000a290 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	858d                	srai	a1,a1,0x3
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	16848493          	addi	s1,s1,360
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	0e4080e7          	jalr	228(ra) # 80005e48 <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	572080e7          	jalr	1394(ra) # 80006302 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	55a080e7          	jalr	1370(ra) # 80006302 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	00009997          	auipc	s3,0x9
    80000dd6:	4be98993          	addi	s3,s3,1214 # 8000a290 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	524080e7          	jalr	1316(ra) # 80006302 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	878d                	srai	a5,a5,0x3
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	16848493          	addi	s1,s1,360
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	4f4080e7          	jalr	1268(ra) # 80006346 <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	57a080e7          	jalr	1402(ra) # 800063e6 <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	5b6080e7          	jalr	1462(ra) # 80006446 <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	a387a783          	lw	a5,-1480(a5) # 800088d0 <first.1672>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c0a080e7          	jalr	-1014(ra) # 80001aac <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	a007af23          	sw	zero,-1506(a5) # 800088d0 <first.1672>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	9f8080e7          	jalr	-1544(ra) # 800028b4 <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	4b6080e7          	jalr	1206(ra) # 80006392 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	9f078793          	addi	a5,a5,-1552 # 800088d4 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	550080e7          	jalr	1360(ra) # 80006446 <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	05893683          	ld	a3,88(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	6d28                	ld	a0,88(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001016:	68a8                	ld	a0,80(s1)
    80001018:	c511                	beqz	a0,80001024 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	64ac                	ld	a1,72(s1)
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	f8c080e7          	jalr	-116(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001024:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001028:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001030:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001034:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
    80001066:	00009917          	auipc	s2,0x9
    8000106a:	22a90913          	addi	s2,s2,554 # 8000a290 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	322080e7          	jalr	802(ra) # 80006392 <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	c395                	beqz	a5,8000109e <allocproc+0x4c>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	3c8080e7          	jalr	968(ra) # 80006446 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	16848493          	addi	s1,s1,360
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
}
    80001090:	8526                	mv	a0,s1
    80001092:	60e2                	ld	ra,24(sp)
    80001094:	6442                	ld	s0,16(sp)
    80001096:	64a2                	ld	s1,8(sp)
    80001098:	6902                	ld	s2,0(sp)
    8000109a:	6105                	addi	sp,sp,32
    8000109c:	8082                	ret
  p->pid = allocpid();
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	e28080e7          	jalr	-472(ra) # 80000ec6 <allocpid>
    800010a6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a8:	4785                	li	a5,1
    800010aa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010ac:	fffff097          	auipc	ra,0xfffff
    800010b0:	06c080e7          	jalr	108(ra) # 80000118 <kalloc>
    800010b4:	892a                	mv	s2,a0
    800010b6:	eca8                	sd	a0,88(s1)
    800010b8:	cd05                	beqz	a0,800010f0 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010ba:	8526                	mv	a0,s1
    800010bc:	00000097          	auipc	ra,0x0
    800010c0:	e50080e7          	jalr	-432(ra) # 80000f0c <proc_pagetable>
    800010c4:	892a                	mv	s2,a0
    800010c6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c8:	c121                	beqz	a0,80001108 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010ca:	07000613          	li	a2,112
    800010ce:	4581                	li	a1,0
    800010d0:	06048513          	addi	a0,s1,96
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	0a4080e7          	jalr	164(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010dc:	00000797          	auipc	a5,0x0
    800010e0:	da478793          	addi	a5,a5,-604 # 80000e80 <forkret>
    800010e4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e6:	60bc                	ld	a5,64(s1)
    800010e8:	6705                	lui	a4,0x1
    800010ea:	97ba                	add	a5,a5,a4
    800010ec:	f4bc                	sd	a5,104(s1)
  return p;
    800010ee:	b74d                	j	80001090 <allocproc+0x3e>
    freeproc(p);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	f08080e7          	jalr	-248(ra) # 80000ffa <freeproc>
    release(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	34a080e7          	jalr	842(ra) # 80006446 <release>
    return 0;
    80001104:	84ca                	mv	s1,s2
    80001106:	b769                	j	80001090 <allocproc+0x3e>
    freeproc(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	ef0080e7          	jalr	-272(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001112:	8526                	mv	a0,s1
    80001114:	00005097          	auipc	ra,0x5
    80001118:	332080e7          	jalr	818(ra) # 80006446 <release>
    return 0;
    8000111c:	84ca                	mv	s1,s2
    8000111e:	bf8d                	j	80001090 <allocproc+0x3e>

0000000080001120 <userinit>:
{
    80001120:	1101                	addi	sp,sp,-32
    80001122:	ec06                	sd	ra,24(sp)
    80001124:	e822                	sd	s0,16(sp)
    80001126:	e426                	sd	s1,8(sp)
    80001128:	1000                	addi	s0,sp,32
  p = allocproc();
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f28080e7          	jalr	-216(ra) # 80001052 <allocproc>
    80001132:	84aa                	mv	s1,a0
  initproc = p;
    80001134:	00008797          	auipc	a5,0x8
    80001138:	eca7be23          	sd	a0,-292(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000113c:	03400613          	li	a2,52
    80001140:	00007597          	auipc	a1,0x7
    80001144:	7a058593          	addi	a1,a1,1952 # 800088e0 <initcode>
    80001148:	6928                	ld	a0,80(a0)
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	6b6080e7          	jalr	1718(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001152:	6785                	lui	a5,0x1
    80001154:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001156:	6cb8                	ld	a4,88(s1)
    80001158:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000115c:	6cb8                	ld	a4,88(s1)
    8000115e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001160:	4641                	li	a2,16
    80001162:	00007597          	auipc	a1,0x7
    80001166:	01e58593          	addi	a1,a1,30 # 80008180 <etext+0x180>
    8000116a:	15848513          	addi	a0,s1,344
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	15c080e7          	jalr	348(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001176:	00007517          	auipc	a0,0x7
    8000117a:	01a50513          	addi	a0,a0,26 # 80008190 <etext+0x190>
    8000117e:	00002097          	auipc	ra,0x2
    80001182:	210080e7          	jalr	528(ra) # 8000338e <namei>
    80001186:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000118a:	478d                	li	a5,3
    8000118c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118e:	8526                	mv	a0,s1
    80001190:	00005097          	auipc	ra,0x5
    80001194:	2b6080e7          	jalr	694(ra) # 80006446 <release>
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6105                	addi	sp,sp,32
    800011a0:	8082                	ret

00000000800011a2 <growproc>:
{
    800011a2:	1101                	addi	sp,sp,-32
    800011a4:	ec06                	sd	ra,24(sp)
    800011a6:	e822                	sd	s0,16(sp)
    800011a8:	e426                	sd	s1,8(sp)
    800011aa:	e04a                	sd	s2,0(sp)
    800011ac:	1000                	addi	s0,sp,32
    800011ae:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011b0:	00000097          	auipc	ra,0x0
    800011b4:	c98080e7          	jalr	-872(ra) # 80000e48 <myproc>
    800011b8:	892a                	mv	s2,a0
  sz = p->sz;
    800011ba:	652c                	ld	a1,72(a0)
    800011bc:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011c0:	00904f63          	bgtz	s1,800011de <growproc+0x3c>
  } else if(n < 0){
    800011c4:	0204cc63          	bltz	s1,800011fc <growproc+0x5a>
  p->sz = sz;
    800011c8:	1602                	slli	a2,a2,0x20
    800011ca:	9201                	srli	a2,a2,0x20
    800011cc:	04c93423          	sd	a2,72(s2)
  return 0;
    800011d0:	4501                	li	a0,0
}
    800011d2:	60e2                	ld	ra,24(sp)
    800011d4:	6442                	ld	s0,16(sp)
    800011d6:	64a2                	ld	s1,8(sp)
    800011d8:	6902                	ld	s2,0(sp)
    800011da:	6105                	addi	sp,sp,32
    800011dc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011de:	9e25                	addw	a2,a2,s1
    800011e0:	1602                	slli	a2,a2,0x20
    800011e2:	9201                	srli	a2,a2,0x20
    800011e4:	1582                	slli	a1,a1,0x20
    800011e6:	9181                	srli	a1,a1,0x20
    800011e8:	6928                	ld	a0,80(a0)
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	6d0080e7          	jalr	1744(ra) # 800008ba <uvmalloc>
    800011f2:	0005061b          	sext.w	a2,a0
    800011f6:	fa69                	bnez	a2,800011c8 <growproc+0x26>
      return -1;
    800011f8:	557d                	li	a0,-1
    800011fa:	bfe1                	j	800011d2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fc:	9e25                	addw	a2,a2,s1
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	1582                	slli	a1,a1,0x20
    80001204:	9181                	srli	a1,a1,0x20
    80001206:	6928                	ld	a0,80(a0)
    80001208:	fffff097          	auipc	ra,0xfffff
    8000120c:	66a080e7          	jalr	1642(ra) # 80000872 <uvmdealloc>
    80001210:	0005061b          	sext.w	a2,a0
    80001214:	bf55                	j	800011c8 <growproc+0x26>

0000000080001216 <fork>:
{
    80001216:	7179                	addi	sp,sp,-48
    80001218:	f406                	sd	ra,40(sp)
    8000121a:	f022                	sd	s0,32(sp)
    8000121c:	ec26                	sd	s1,24(sp)
    8000121e:	e84a                	sd	s2,16(sp)
    80001220:	e44e                	sd	s3,8(sp)
    80001222:	e052                	sd	s4,0(sp)
    80001224:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001226:	00000097          	auipc	ra,0x0
    8000122a:	c22080e7          	jalr	-990(ra) # 80000e48 <myproc>
    8000122e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001230:	00000097          	auipc	ra,0x0
    80001234:	e22080e7          	jalr	-478(ra) # 80001052 <allocproc>
    80001238:	10050b63          	beqz	a0,8000134e <fork+0x138>
    8000123c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000123e:	04893603          	ld	a2,72(s2)
    80001242:	692c                	ld	a1,80(a0)
    80001244:	05093503          	ld	a0,80(s2)
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	7be080e7          	jalr	1982(ra) # 80000a06 <uvmcopy>
    80001250:	04054663          	bltz	a0,8000129c <fork+0x86>
  np->sz = p->sz;
    80001254:	04893783          	ld	a5,72(s2)
    80001258:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000125c:	05893683          	ld	a3,88(s2)
    80001260:	87b6                	mv	a5,a3
    80001262:	0589b703          	ld	a4,88(s3)
    80001266:	12068693          	addi	a3,a3,288
    8000126a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000126e:	6788                	ld	a0,8(a5)
    80001270:	6b8c                	ld	a1,16(a5)
    80001272:	6f90                	ld	a2,24(a5)
    80001274:	01073023          	sd	a6,0(a4)
    80001278:	e708                	sd	a0,8(a4)
    8000127a:	eb0c                	sd	a1,16(a4)
    8000127c:	ef10                	sd	a2,24(a4)
    8000127e:	02078793          	addi	a5,a5,32
    80001282:	02070713          	addi	a4,a4,32
    80001286:	fed792e3          	bne	a5,a3,8000126a <fork+0x54>
  np->trapframe->a0 = 0;
    8000128a:	0589b783          	ld	a5,88(s3)
    8000128e:	0607b823          	sd	zero,112(a5)
    80001292:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001296:	15000a13          	li	s4,336
    8000129a:	a03d                	j	800012c8 <fork+0xb2>
    freeproc(np);
    8000129c:	854e                	mv	a0,s3
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	d5c080e7          	jalr	-676(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012a6:	854e                	mv	a0,s3
    800012a8:	00005097          	auipc	ra,0x5
    800012ac:	19e080e7          	jalr	414(ra) # 80006446 <release>
    return -1;
    800012b0:	5a7d                	li	s4,-1
    800012b2:	a069                	j	8000133c <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b4:	00002097          	auipc	ra,0x2
    800012b8:	770080e7          	jalr	1904(ra) # 80003a24 <filedup>
    800012bc:	009987b3          	add	a5,s3,s1
    800012c0:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012c2:	04a1                	addi	s1,s1,8
    800012c4:	01448763          	beq	s1,s4,800012d2 <fork+0xbc>
    if(p->ofile[i])
    800012c8:	009907b3          	add	a5,s2,s1
    800012cc:	6388                	ld	a0,0(a5)
    800012ce:	f17d                	bnez	a0,800012b4 <fork+0x9e>
    800012d0:	bfcd                	j	800012c2 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012d2:	15093503          	ld	a0,336(s2)
    800012d6:	00002097          	auipc	ra,0x2
    800012da:	818080e7          	jalr	-2024(ra) # 80002aee <idup>
    800012de:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012e2:	4641                	li	a2,16
    800012e4:	15890593          	addi	a1,s2,344
    800012e8:	15898513          	addi	a0,s3,344
    800012ec:	fffff097          	auipc	ra,0xfffff
    800012f0:	fde080e7          	jalr	-34(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012f4:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800012f8:	854e                	mv	a0,s3
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	14c080e7          	jalr	332(ra) # 80006446 <release>
  acquire(&wait_lock);
    80001302:	00008497          	auipc	s1,0x8
    80001306:	d6648493          	addi	s1,s1,-666 # 80009068 <wait_lock>
    8000130a:	8526                	mv	a0,s1
    8000130c:	00005097          	auipc	ra,0x5
    80001310:	086080e7          	jalr	134(ra) # 80006392 <acquire>
  np->parent = p;
    80001314:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001318:	8526                	mv	a0,s1
    8000131a:	00005097          	auipc	ra,0x5
    8000131e:	12c080e7          	jalr	300(ra) # 80006446 <release>
  acquire(&np->lock);
    80001322:	854e                	mv	a0,s3
    80001324:	00005097          	auipc	ra,0x5
    80001328:	06e080e7          	jalr	110(ra) # 80006392 <acquire>
  np->state = RUNNABLE;
    8000132c:	478d                	li	a5,3
    8000132e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	112080e7          	jalr	274(ra) # 80006446 <release>
}
    8000133c:	8552                	mv	a0,s4
    8000133e:	70a2                	ld	ra,40(sp)
    80001340:	7402                	ld	s0,32(sp)
    80001342:	64e2                	ld	s1,24(sp)
    80001344:	6942                	ld	s2,16(sp)
    80001346:	69a2                	ld	s3,8(sp)
    80001348:	6a02                	ld	s4,0(sp)
    8000134a:	6145                	addi	sp,sp,48
    8000134c:	8082                	ret
    return -1;
    8000134e:	5a7d                	li	s4,-1
    80001350:	b7f5                	j	8000133c <fork+0x126>

0000000080001352 <scheduler>:
{
    80001352:	7139                	addi	sp,sp,-64
    80001354:	fc06                	sd	ra,56(sp)
    80001356:	f822                	sd	s0,48(sp)
    80001358:	f426                	sd	s1,40(sp)
    8000135a:	f04a                	sd	s2,32(sp)
    8000135c:	ec4e                	sd	s3,24(sp)
    8000135e:	e852                	sd	s4,16(sp)
    80001360:	e456                	sd	s5,8(sp)
    80001362:	e05a                	sd	s6,0(sp)
    80001364:	0080                	addi	s0,sp,64
    80001366:	8792                	mv	a5,tp
  int id = r_tp();
    80001368:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000136a:	00779a93          	slli	s5,a5,0x7
    8000136e:	00008717          	auipc	a4,0x8
    80001372:	ce270713          	addi	a4,a4,-798 # 80009050 <pid_lock>
    80001376:	9756                	add	a4,a4,s5
    80001378:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000137c:	00008717          	auipc	a4,0x8
    80001380:	d0c70713          	addi	a4,a4,-756 # 80009088 <cpus+0x8>
    80001384:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001386:	498d                	li	s3,3
        p->state = RUNNING;
    80001388:	4b11                	li	s6,4
        c->proc = p;
    8000138a:	079e                	slli	a5,a5,0x7
    8000138c:	00008a17          	auipc	s4,0x8
    80001390:	cc4a0a13          	addi	s4,s4,-828 # 80009050 <pid_lock>
    80001394:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001396:	00009917          	auipc	s2,0x9
    8000139a:	efa90913          	addi	s2,s2,-262 # 8000a290 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000139e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a6:	10079073          	csrw	sstatus,a5
    800013aa:	00008497          	auipc	s1,0x8
    800013ae:	0d648493          	addi	s1,s1,214 # 80009480 <proc>
    800013b2:	a03d                	j	800013e0 <scheduler+0x8e>
        p->state = RUNNING;
    800013b4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013b8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013bc:	06048593          	addi	a1,s1,96
    800013c0:	8556                	mv	a0,s5
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	640080e7          	jalr	1600(ra) # 80001a02 <swtch>
        c->proc = 0;
    800013ca:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013ce:	8526                	mv	a0,s1
    800013d0:	00005097          	auipc	ra,0x5
    800013d4:	076080e7          	jalr	118(ra) # 80006446 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013d8:	16848493          	addi	s1,s1,360
    800013dc:	fd2481e3          	beq	s1,s2,8000139e <scheduler+0x4c>
      acquire(&p->lock);
    800013e0:	8526                	mv	a0,s1
    800013e2:	00005097          	auipc	ra,0x5
    800013e6:	fb0080e7          	jalr	-80(ra) # 80006392 <acquire>
      if(p->state == RUNNABLE) {
    800013ea:	4c9c                	lw	a5,24(s1)
    800013ec:	ff3791e3          	bne	a5,s3,800013ce <scheduler+0x7c>
    800013f0:	b7d1                	j	800013b4 <scheduler+0x62>

00000000800013f2 <sched>:
{
    800013f2:	7179                	addi	sp,sp,-48
    800013f4:	f406                	sd	ra,40(sp)
    800013f6:	f022                	sd	s0,32(sp)
    800013f8:	ec26                	sd	s1,24(sp)
    800013fa:	e84a                	sd	s2,16(sp)
    800013fc:	e44e                	sd	s3,8(sp)
    800013fe:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001400:	00000097          	auipc	ra,0x0
    80001404:	a48080e7          	jalr	-1464(ra) # 80000e48 <myproc>
    80001408:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000140a:	00005097          	auipc	ra,0x5
    8000140e:	f0e080e7          	jalr	-242(ra) # 80006318 <holding>
    80001412:	c93d                	beqz	a0,80001488 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001414:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001416:	2781                	sext.w	a5,a5
    80001418:	079e                	slli	a5,a5,0x7
    8000141a:	00008717          	auipc	a4,0x8
    8000141e:	c3670713          	addi	a4,a4,-970 # 80009050 <pid_lock>
    80001422:	97ba                	add	a5,a5,a4
    80001424:	0a87a703          	lw	a4,168(a5)
    80001428:	4785                	li	a5,1
    8000142a:	06f71763          	bne	a4,a5,80001498 <sched+0xa6>
  if(p->state == RUNNING)
    8000142e:	4c98                	lw	a4,24(s1)
    80001430:	4791                	li	a5,4
    80001432:	06f70b63          	beq	a4,a5,800014a8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001436:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000143a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000143c:	efb5                	bnez	a5,800014b8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001440:	00008917          	auipc	s2,0x8
    80001444:	c1090913          	addi	s2,s2,-1008 # 80009050 <pid_lock>
    80001448:	2781                	sext.w	a5,a5
    8000144a:	079e                	slli	a5,a5,0x7
    8000144c:	97ca                	add	a5,a5,s2
    8000144e:	0ac7a983          	lw	s3,172(a5)
    80001452:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001454:	2781                	sext.w	a5,a5
    80001456:	079e                	slli	a5,a5,0x7
    80001458:	00008597          	auipc	a1,0x8
    8000145c:	c3058593          	addi	a1,a1,-976 # 80009088 <cpus+0x8>
    80001460:	95be                	add	a1,a1,a5
    80001462:	06048513          	addi	a0,s1,96
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	59c080e7          	jalr	1436(ra) # 80001a02 <swtch>
    8000146e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001470:	2781                	sext.w	a5,a5
    80001472:	079e                	slli	a5,a5,0x7
    80001474:	97ca                	add	a5,a5,s2
    80001476:	0b37a623          	sw	s3,172(a5)
}
    8000147a:	70a2                	ld	ra,40(sp)
    8000147c:	7402                	ld	s0,32(sp)
    8000147e:	64e2                	ld	s1,24(sp)
    80001480:	6942                	ld	s2,16(sp)
    80001482:	69a2                	ld	s3,8(sp)
    80001484:	6145                	addi	sp,sp,48
    80001486:	8082                	ret
    panic("sched p->lock");
    80001488:	00007517          	auipc	a0,0x7
    8000148c:	d1050513          	addi	a0,a0,-752 # 80008198 <etext+0x198>
    80001490:	00005097          	auipc	ra,0x5
    80001494:	9b8080e7          	jalr	-1608(ra) # 80005e48 <panic>
    panic("sched locks");
    80001498:	00007517          	auipc	a0,0x7
    8000149c:	d1050513          	addi	a0,a0,-752 # 800081a8 <etext+0x1a8>
    800014a0:	00005097          	auipc	ra,0x5
    800014a4:	9a8080e7          	jalr	-1624(ra) # 80005e48 <panic>
    panic("sched running");
    800014a8:	00007517          	auipc	a0,0x7
    800014ac:	d1050513          	addi	a0,a0,-752 # 800081b8 <etext+0x1b8>
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	998080e7          	jalr	-1640(ra) # 80005e48 <panic>
    panic("sched interruptible");
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	d1050513          	addi	a0,a0,-752 # 800081c8 <etext+0x1c8>
    800014c0:	00005097          	auipc	ra,0x5
    800014c4:	988080e7          	jalr	-1656(ra) # 80005e48 <panic>

00000000800014c8 <yield>:
{
    800014c8:	1101                	addi	sp,sp,-32
    800014ca:	ec06                	sd	ra,24(sp)
    800014cc:	e822                	sd	s0,16(sp)
    800014ce:	e426                	sd	s1,8(sp)
    800014d0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d2:	00000097          	auipc	ra,0x0
    800014d6:	976080e7          	jalr	-1674(ra) # 80000e48 <myproc>
    800014da:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014dc:	00005097          	auipc	ra,0x5
    800014e0:	eb6080e7          	jalr	-330(ra) # 80006392 <acquire>
  p->state = RUNNABLE;
    800014e4:	478d                	li	a5,3
    800014e6:	cc9c                	sw	a5,24(s1)
  sched();
    800014e8:	00000097          	auipc	ra,0x0
    800014ec:	f0a080e7          	jalr	-246(ra) # 800013f2 <sched>
  release(&p->lock);
    800014f0:	8526                	mv	a0,s1
    800014f2:	00005097          	auipc	ra,0x5
    800014f6:	f54080e7          	jalr	-172(ra) # 80006446 <release>
}
    800014fa:	60e2                	ld	ra,24(sp)
    800014fc:	6442                	ld	s0,16(sp)
    800014fe:	64a2                	ld	s1,8(sp)
    80001500:	6105                	addi	sp,sp,32
    80001502:	8082                	ret

0000000080001504 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001504:	7179                	addi	sp,sp,-48
    80001506:	f406                	sd	ra,40(sp)
    80001508:	f022                	sd	s0,32(sp)
    8000150a:	ec26                	sd	s1,24(sp)
    8000150c:	e84a                	sd	s2,16(sp)
    8000150e:	e44e                	sd	s3,8(sp)
    80001510:	1800                	addi	s0,sp,48
    80001512:	89aa                	mv	s3,a0
    80001514:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001516:	00000097          	auipc	ra,0x0
    8000151a:	932080e7          	jalr	-1742(ra) # 80000e48 <myproc>
    8000151e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001520:	00005097          	auipc	ra,0x5
    80001524:	e72080e7          	jalr	-398(ra) # 80006392 <acquire>
  release(lk);
    80001528:	854a                	mv	a0,s2
    8000152a:	00005097          	auipc	ra,0x5
    8000152e:	f1c080e7          	jalr	-228(ra) # 80006446 <release>

  // Go to sleep.
  p->chan = chan;
    80001532:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001536:	4789                	li	a5,2
    80001538:	cc9c                	sw	a5,24(s1)

  sched();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	eb8080e7          	jalr	-328(ra) # 800013f2 <sched>

  // Tidy up.
  p->chan = 0;
    80001542:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001546:	8526                	mv	a0,s1
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	efe080e7          	jalr	-258(ra) # 80006446 <release>
  acquire(lk);
    80001550:	854a                	mv	a0,s2
    80001552:	00005097          	auipc	ra,0x5
    80001556:	e40080e7          	jalr	-448(ra) # 80006392 <acquire>
}
    8000155a:	70a2                	ld	ra,40(sp)
    8000155c:	7402                	ld	s0,32(sp)
    8000155e:	64e2                	ld	s1,24(sp)
    80001560:	6942                	ld	s2,16(sp)
    80001562:	69a2                	ld	s3,8(sp)
    80001564:	6145                	addi	sp,sp,48
    80001566:	8082                	ret

0000000080001568 <wait>:
{
    80001568:	715d                	addi	sp,sp,-80
    8000156a:	e486                	sd	ra,72(sp)
    8000156c:	e0a2                	sd	s0,64(sp)
    8000156e:	fc26                	sd	s1,56(sp)
    80001570:	f84a                	sd	s2,48(sp)
    80001572:	f44e                	sd	s3,40(sp)
    80001574:	f052                	sd	s4,32(sp)
    80001576:	ec56                	sd	s5,24(sp)
    80001578:	e85a                	sd	s6,16(sp)
    8000157a:	e45e                	sd	s7,8(sp)
    8000157c:	e062                	sd	s8,0(sp)
    8000157e:	0880                	addi	s0,sp,80
    80001580:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    80001582:	00000097          	auipc	ra,0x0
    80001586:	8c6080e7          	jalr	-1850(ra) # 80000e48 <myproc>
    8000158a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000158c:	00008517          	auipc	a0,0x8
    80001590:	adc50513          	addi	a0,a0,-1316 # 80009068 <wait_lock>
    80001594:	00005097          	auipc	ra,0x5
    80001598:	dfe080e7          	jalr	-514(ra) # 80006392 <acquire>
    havekids = 0;
    8000159c:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000159e:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015a0:	00009997          	auipc	s3,0x9
    800015a4:	cf098993          	addi	s3,s3,-784 # 8000a290 <tickslock>
        havekids = 1;
    800015a8:	4b05                	li	s6,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015aa:	00008c17          	auipc	s8,0x8
    800015ae:	abec0c13          	addi	s8,s8,-1346 # 80009068 <wait_lock>
    havekids = 0;
    800015b2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015b4:	00008497          	auipc	s1,0x8
    800015b8:	ecc48493          	addi	s1,s1,-308 # 80009480 <proc>
    800015bc:	a0bd                	j	8000162a <wait+0xc2>
          pid = np->pid;
    800015be:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015c2:	000a8e63          	beqz	s5,800015de <wait+0x76>
    800015c6:	4691                	li	a3,4
    800015c8:	02c48613          	addi	a2,s1,44
    800015cc:	85d6                	mv	a1,s5
    800015ce:	05093503          	ld	a0,80(s2)
    800015d2:	fffff097          	auipc	ra,0xfffff
    800015d6:	538080e7          	jalr	1336(ra) # 80000b0a <copyout>
    800015da:	02054563          	bltz	a0,80001604 <wait+0x9c>
          freeproc(np);
    800015de:	8526                	mv	a0,s1
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	a1a080e7          	jalr	-1510(ra) # 80000ffa <freeproc>
          release(&np->lock);
    800015e8:	8526                	mv	a0,s1
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	e5c080e7          	jalr	-420(ra) # 80006446 <release>
          release(&wait_lock);
    800015f2:	00008517          	auipc	a0,0x8
    800015f6:	a7650513          	addi	a0,a0,-1418 # 80009068 <wait_lock>
    800015fa:	00005097          	auipc	ra,0x5
    800015fe:	e4c080e7          	jalr	-436(ra) # 80006446 <release>
          return pid;
    80001602:	a09d                	j	80001668 <wait+0x100>
            release(&np->lock);
    80001604:	8526                	mv	a0,s1
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	e40080e7          	jalr	-448(ra) # 80006446 <release>
            release(&wait_lock);
    8000160e:	00008517          	auipc	a0,0x8
    80001612:	a5a50513          	addi	a0,a0,-1446 # 80009068 <wait_lock>
    80001616:	00005097          	auipc	ra,0x5
    8000161a:	e30080e7          	jalr	-464(ra) # 80006446 <release>
            return -1;
    8000161e:	59fd                	li	s3,-1
    80001620:	a0a1                	j	80001668 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001622:	16848493          	addi	s1,s1,360
    80001626:	03348463          	beq	s1,s3,8000164e <wait+0xe6>
      if(np->parent == p){
    8000162a:	7c9c                	ld	a5,56(s1)
    8000162c:	ff279be3          	bne	a5,s2,80001622 <wait+0xba>
        acquire(&np->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	00005097          	auipc	ra,0x5
    80001636:	d60080e7          	jalr	-672(ra) # 80006392 <acquire>
        if(np->state == ZOMBIE){
    8000163a:	4c9c                	lw	a5,24(s1)
    8000163c:	f94781e3          	beq	a5,s4,800015be <wait+0x56>
        release(&np->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00005097          	auipc	ra,0x5
    80001646:	e04080e7          	jalr	-508(ra) # 80006446 <release>
        havekids = 1;
    8000164a:	875a                	mv	a4,s6
    8000164c:	bfd9                	j	80001622 <wait+0xba>
    if(!havekids || p->killed){
    8000164e:	c701                	beqz	a4,80001656 <wait+0xee>
    80001650:	02892783          	lw	a5,40(s2)
    80001654:	c79d                	beqz	a5,80001682 <wait+0x11a>
      release(&wait_lock);
    80001656:	00008517          	auipc	a0,0x8
    8000165a:	a1250513          	addi	a0,a0,-1518 # 80009068 <wait_lock>
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	de8080e7          	jalr	-536(ra) # 80006446 <release>
      return -1;
    80001666:	59fd                	li	s3,-1
}
    80001668:	854e                	mv	a0,s3
    8000166a:	60a6                	ld	ra,72(sp)
    8000166c:	6406                	ld	s0,64(sp)
    8000166e:	74e2                	ld	s1,56(sp)
    80001670:	7942                	ld	s2,48(sp)
    80001672:	79a2                	ld	s3,40(sp)
    80001674:	7a02                	ld	s4,32(sp)
    80001676:	6ae2                	ld	s5,24(sp)
    80001678:	6b42                	ld	s6,16(sp)
    8000167a:	6ba2                	ld	s7,8(sp)
    8000167c:	6c02                	ld	s8,0(sp)
    8000167e:	6161                	addi	sp,sp,80
    80001680:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001682:	85e2                	mv	a1,s8
    80001684:	854a                	mv	a0,s2
    80001686:	00000097          	auipc	ra,0x0
    8000168a:	e7e080e7          	jalr	-386(ra) # 80001504 <sleep>
    havekids = 0;
    8000168e:	b715                	j	800015b2 <wait+0x4a>

0000000080001690 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001690:	7139                	addi	sp,sp,-64
    80001692:	fc06                	sd	ra,56(sp)
    80001694:	f822                	sd	s0,48(sp)
    80001696:	f426                	sd	s1,40(sp)
    80001698:	f04a                	sd	s2,32(sp)
    8000169a:	ec4e                	sd	s3,24(sp)
    8000169c:	e852                	sd	s4,16(sp)
    8000169e:	e456                	sd	s5,8(sp)
    800016a0:	0080                	addi	s0,sp,64
    800016a2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016a4:	00008497          	auipc	s1,0x8
    800016a8:	ddc48493          	addi	s1,s1,-548 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016ac:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016ae:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016b0:	00009917          	auipc	s2,0x9
    800016b4:	be090913          	addi	s2,s2,-1056 # 8000a290 <tickslock>
    800016b8:	a811                	j	800016cc <wakeup+0x3c>
      }
      release(&p->lock);
    800016ba:	8526                	mv	a0,s1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	d8a080e7          	jalr	-630(ra) # 80006446 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c4:	16848493          	addi	s1,s1,360
    800016c8:	03248663          	beq	s1,s2,800016f4 <wakeup+0x64>
    if(p != myproc()){
    800016cc:	fffff097          	auipc	ra,0xfffff
    800016d0:	77c080e7          	jalr	1916(ra) # 80000e48 <myproc>
    800016d4:	fea488e3          	beq	s1,a0,800016c4 <wakeup+0x34>
      acquire(&p->lock);
    800016d8:	8526                	mv	a0,s1
    800016da:	00005097          	auipc	ra,0x5
    800016de:	cb8080e7          	jalr	-840(ra) # 80006392 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016e2:	4c9c                	lw	a5,24(s1)
    800016e4:	fd379be3          	bne	a5,s3,800016ba <wakeup+0x2a>
    800016e8:	709c                	ld	a5,32(s1)
    800016ea:	fd4798e3          	bne	a5,s4,800016ba <wakeup+0x2a>
        p->state = RUNNABLE;
    800016ee:	0154ac23          	sw	s5,24(s1)
    800016f2:	b7e1                	j	800016ba <wakeup+0x2a>
    }
  }
}
    800016f4:	70e2                	ld	ra,56(sp)
    800016f6:	7442                	ld	s0,48(sp)
    800016f8:	74a2                	ld	s1,40(sp)
    800016fa:	7902                	ld	s2,32(sp)
    800016fc:	69e2                	ld	s3,24(sp)
    800016fe:	6a42                	ld	s4,16(sp)
    80001700:	6aa2                	ld	s5,8(sp)
    80001702:	6121                	addi	sp,sp,64
    80001704:	8082                	ret

0000000080001706 <reparent>:
{
    80001706:	7179                	addi	sp,sp,-48
    80001708:	f406                	sd	ra,40(sp)
    8000170a:	f022                	sd	s0,32(sp)
    8000170c:	ec26                	sd	s1,24(sp)
    8000170e:	e84a                	sd	s2,16(sp)
    80001710:	e44e                	sd	s3,8(sp)
    80001712:	e052                	sd	s4,0(sp)
    80001714:	1800                	addi	s0,sp,48
    80001716:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001718:	00008497          	auipc	s1,0x8
    8000171c:	d6848493          	addi	s1,s1,-664 # 80009480 <proc>
      pp->parent = initproc;
    80001720:	00008a17          	auipc	s4,0x8
    80001724:	8f0a0a13          	addi	s4,s4,-1808 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001728:	00009997          	auipc	s3,0x9
    8000172c:	b6898993          	addi	s3,s3,-1176 # 8000a290 <tickslock>
    80001730:	a029                	j	8000173a <reparent+0x34>
    80001732:	16848493          	addi	s1,s1,360
    80001736:	01348d63          	beq	s1,s3,80001750 <reparent+0x4a>
    if(pp->parent == p){
    8000173a:	7c9c                	ld	a5,56(s1)
    8000173c:	ff279be3          	bne	a5,s2,80001732 <reparent+0x2c>
      pp->parent = initproc;
    80001740:	000a3503          	ld	a0,0(s4)
    80001744:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001746:	00000097          	auipc	ra,0x0
    8000174a:	f4a080e7          	jalr	-182(ra) # 80001690 <wakeup>
    8000174e:	b7d5                	j	80001732 <reparent+0x2c>
}
    80001750:	70a2                	ld	ra,40(sp)
    80001752:	7402                	ld	s0,32(sp)
    80001754:	64e2                	ld	s1,24(sp)
    80001756:	6942                	ld	s2,16(sp)
    80001758:	69a2                	ld	s3,8(sp)
    8000175a:	6a02                	ld	s4,0(sp)
    8000175c:	6145                	addi	sp,sp,48
    8000175e:	8082                	ret

0000000080001760 <exit>:
{
    80001760:	7179                	addi	sp,sp,-48
    80001762:	f406                	sd	ra,40(sp)
    80001764:	f022                	sd	s0,32(sp)
    80001766:	ec26                	sd	s1,24(sp)
    80001768:	e84a                	sd	s2,16(sp)
    8000176a:	e44e                	sd	s3,8(sp)
    8000176c:	e052                	sd	s4,0(sp)
    8000176e:	1800                	addi	s0,sp,48
    80001770:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001772:	fffff097          	auipc	ra,0xfffff
    80001776:	6d6080e7          	jalr	1750(ra) # 80000e48 <myproc>
    8000177a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000177c:	00008797          	auipc	a5,0x8
    80001780:	8947b783          	ld	a5,-1900(a5) # 80009010 <initproc>
    80001784:	0d050493          	addi	s1,a0,208
    80001788:	15050913          	addi	s2,a0,336
    8000178c:	02a79363          	bne	a5,a0,800017b2 <exit+0x52>
    panic("init exiting");
    80001790:	00007517          	auipc	a0,0x7
    80001794:	a5050513          	addi	a0,a0,-1456 # 800081e0 <etext+0x1e0>
    80001798:	00004097          	auipc	ra,0x4
    8000179c:	6b0080e7          	jalr	1712(ra) # 80005e48 <panic>
      fileclose(f);
    800017a0:	00002097          	auipc	ra,0x2
    800017a4:	2d6080e7          	jalr	726(ra) # 80003a76 <fileclose>
      p->ofile[fd] = 0;
    800017a8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017ac:	04a1                	addi	s1,s1,8
    800017ae:	01248563          	beq	s1,s2,800017b8 <exit+0x58>
    if(p->ofile[fd]){
    800017b2:	6088                	ld	a0,0(s1)
    800017b4:	f575                	bnez	a0,800017a0 <exit+0x40>
    800017b6:	bfdd                	j	800017ac <exit+0x4c>
  begin_op();
    800017b8:	00002097          	auipc	ra,0x2
    800017bc:	df2080e7          	jalr	-526(ra) # 800035aa <begin_op>
  iput(p->cwd);
    800017c0:	1509b503          	ld	a0,336(s3)
    800017c4:	00001097          	auipc	ra,0x1
    800017c8:	5cc080e7          	jalr	1484(ra) # 80002d90 <iput>
  end_op();
    800017cc:	00002097          	auipc	ra,0x2
    800017d0:	e5e080e7          	jalr	-418(ra) # 8000362a <end_op>
  p->cwd = 0;
    800017d4:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800017d8:	00008497          	auipc	s1,0x8
    800017dc:	89048493          	addi	s1,s1,-1904 # 80009068 <wait_lock>
    800017e0:	8526                	mv	a0,s1
    800017e2:	00005097          	auipc	ra,0x5
    800017e6:	bb0080e7          	jalr	-1104(ra) # 80006392 <acquire>
  reparent(p);
    800017ea:	854e                	mv	a0,s3
    800017ec:	00000097          	auipc	ra,0x0
    800017f0:	f1a080e7          	jalr	-230(ra) # 80001706 <reparent>
  wakeup(p->parent);
    800017f4:	0389b503          	ld	a0,56(s3)
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	e98080e7          	jalr	-360(ra) # 80001690 <wakeup>
  acquire(&p->lock);
    80001800:	854e                	mv	a0,s3
    80001802:	00005097          	auipc	ra,0x5
    80001806:	b90080e7          	jalr	-1136(ra) # 80006392 <acquire>
  p->xstate = status;
    8000180a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000180e:	4795                	li	a5,5
    80001810:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001814:	8526                	mv	a0,s1
    80001816:	00005097          	auipc	ra,0x5
    8000181a:	c30080e7          	jalr	-976(ra) # 80006446 <release>
  sched();
    8000181e:	00000097          	auipc	ra,0x0
    80001822:	bd4080e7          	jalr	-1068(ra) # 800013f2 <sched>
  panic("zombie exit");
    80001826:	00007517          	auipc	a0,0x7
    8000182a:	9ca50513          	addi	a0,a0,-1590 # 800081f0 <etext+0x1f0>
    8000182e:	00004097          	auipc	ra,0x4
    80001832:	61a080e7          	jalr	1562(ra) # 80005e48 <panic>

0000000080001836 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001836:	7179                	addi	sp,sp,-48
    80001838:	f406                	sd	ra,40(sp)
    8000183a:	f022                	sd	s0,32(sp)
    8000183c:	ec26                	sd	s1,24(sp)
    8000183e:	e84a                	sd	s2,16(sp)
    80001840:	e44e                	sd	s3,8(sp)
    80001842:	1800                	addi	s0,sp,48
    80001844:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001846:	00008497          	auipc	s1,0x8
    8000184a:	c3a48493          	addi	s1,s1,-966 # 80009480 <proc>
    8000184e:	00009997          	auipc	s3,0x9
    80001852:	a4298993          	addi	s3,s3,-1470 # 8000a290 <tickslock>
    acquire(&p->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	b3a080e7          	jalr	-1222(ra) # 80006392 <acquire>
    if(p->pid == pid){
    80001860:	589c                	lw	a5,48(s1)
    80001862:	03278363          	beq	a5,s2,80001888 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	bde080e7          	jalr	-1058(ra) # 80006446 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001870:	16848493          	addi	s1,s1,360
    80001874:	ff3491e3          	bne	s1,s3,80001856 <kill+0x20>
  }
  return -1;
    80001878:	557d                	li	a0,-1
}
    8000187a:	70a2                	ld	ra,40(sp)
    8000187c:	7402                	ld	s0,32(sp)
    8000187e:	64e2                	ld	s1,24(sp)
    80001880:	6942                	ld	s2,16(sp)
    80001882:	69a2                	ld	s3,8(sp)
    80001884:	6145                	addi	sp,sp,48
    80001886:	8082                	ret
      p->killed = 1;
    80001888:	4785                	li	a5,1
    8000188a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000188c:	4c98                	lw	a4,24(s1)
    8000188e:	4789                	li	a5,2
    80001890:	00f70963          	beq	a4,a5,800018a2 <kill+0x6c>
      release(&p->lock);
    80001894:	8526                	mv	a0,s1
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	bb0080e7          	jalr	-1104(ra) # 80006446 <release>
      return 0;
    8000189e:	4501                	li	a0,0
    800018a0:	bfe9                	j	8000187a <kill+0x44>
        p->state = RUNNABLE;
    800018a2:	478d                	li	a5,3
    800018a4:	cc9c                	sw	a5,24(s1)
    800018a6:	b7fd                	j	80001894 <kill+0x5e>

00000000800018a8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018a8:	7179                	addi	sp,sp,-48
    800018aa:	f406                	sd	ra,40(sp)
    800018ac:	f022                	sd	s0,32(sp)
    800018ae:	ec26                	sd	s1,24(sp)
    800018b0:	e84a                	sd	s2,16(sp)
    800018b2:	e44e                	sd	s3,8(sp)
    800018b4:	e052                	sd	s4,0(sp)
    800018b6:	1800                	addi	s0,sp,48
    800018b8:	84aa                	mv	s1,a0
    800018ba:	892e                	mv	s2,a1
    800018bc:	89b2                	mv	s3,a2
    800018be:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018c0:	fffff097          	auipc	ra,0xfffff
    800018c4:	588080e7          	jalr	1416(ra) # 80000e48 <myproc>
  if(user_dst){
    800018c8:	c08d                	beqz	s1,800018ea <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018ca:	86d2                	mv	a3,s4
    800018cc:	864e                	mv	a2,s3
    800018ce:	85ca                	mv	a1,s2
    800018d0:	6928                	ld	a0,80(a0)
    800018d2:	fffff097          	auipc	ra,0xfffff
    800018d6:	238080e7          	jalr	568(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018da:	70a2                	ld	ra,40(sp)
    800018dc:	7402                	ld	s0,32(sp)
    800018de:	64e2                	ld	s1,24(sp)
    800018e0:	6942                	ld	s2,16(sp)
    800018e2:	69a2                	ld	s3,8(sp)
    800018e4:	6a02                	ld	s4,0(sp)
    800018e6:	6145                	addi	sp,sp,48
    800018e8:	8082                	ret
    memmove((char *)dst, src, len);
    800018ea:	000a061b          	sext.w	a2,s4
    800018ee:	85ce                	mv	a1,s3
    800018f0:	854a                	mv	a0,s2
    800018f2:	fffff097          	auipc	ra,0xfffff
    800018f6:	8e6080e7          	jalr	-1818(ra) # 800001d8 <memmove>
    return 0;
    800018fa:	8526                	mv	a0,s1
    800018fc:	bff9                	j	800018da <either_copyout+0x32>

00000000800018fe <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800018fe:	7179                	addi	sp,sp,-48
    80001900:	f406                	sd	ra,40(sp)
    80001902:	f022                	sd	s0,32(sp)
    80001904:	ec26                	sd	s1,24(sp)
    80001906:	e84a                	sd	s2,16(sp)
    80001908:	e44e                	sd	s3,8(sp)
    8000190a:	e052                	sd	s4,0(sp)
    8000190c:	1800                	addi	s0,sp,48
    8000190e:	892a                	mv	s2,a0
    80001910:	84ae                	mv	s1,a1
    80001912:	89b2                	mv	s3,a2
    80001914:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001916:	fffff097          	auipc	ra,0xfffff
    8000191a:	532080e7          	jalr	1330(ra) # 80000e48 <myproc>
  if(user_src){
    8000191e:	c08d                	beqz	s1,80001940 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001920:	86d2                	mv	a3,s4
    80001922:	864e                	mv	a2,s3
    80001924:	85ca                	mv	a1,s2
    80001926:	6928                	ld	a0,80(a0)
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	26e080e7          	jalr	622(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001930:	70a2                	ld	ra,40(sp)
    80001932:	7402                	ld	s0,32(sp)
    80001934:	64e2                	ld	s1,24(sp)
    80001936:	6942                	ld	s2,16(sp)
    80001938:	69a2                	ld	s3,8(sp)
    8000193a:	6a02                	ld	s4,0(sp)
    8000193c:	6145                	addi	sp,sp,48
    8000193e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001940:	000a061b          	sext.w	a2,s4
    80001944:	85ce                	mv	a1,s3
    80001946:	854a                	mv	a0,s2
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	890080e7          	jalr	-1904(ra) # 800001d8 <memmove>
    return 0;
    80001950:	8526                	mv	a0,s1
    80001952:	bff9                	j	80001930 <either_copyin+0x32>

0000000080001954 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001954:	715d                	addi	sp,sp,-80
    80001956:	e486                	sd	ra,72(sp)
    80001958:	e0a2                	sd	s0,64(sp)
    8000195a:	fc26                	sd	s1,56(sp)
    8000195c:	f84a                	sd	s2,48(sp)
    8000195e:	f44e                	sd	s3,40(sp)
    80001960:	f052                	sd	s4,32(sp)
    80001962:	ec56                	sd	s5,24(sp)
    80001964:	e85a                	sd	s6,16(sp)
    80001966:	e45e                	sd	s7,8(sp)
    80001968:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000196a:	00007517          	auipc	a0,0x7
    8000196e:	df650513          	addi	a0,a0,-522 # 80008760 <syscalls+0x398>
    80001972:	00004097          	auipc	ra,0x4
    80001976:	520080e7          	jalr	1312(ra) # 80005e92 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000197a:	00008497          	auipc	s1,0x8
    8000197e:	c5e48493          	addi	s1,s1,-930 # 800095d8 <proc+0x158>
    80001982:	00009917          	auipc	s2,0x9
    80001986:	a6690913          	addi	s2,s2,-1434 # 8000a3e8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000198a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000198c:	00007997          	auipc	s3,0x7
    80001990:	87498993          	addi	s3,s3,-1932 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001994:	00007a97          	auipc	s5,0x7
    80001998:	874a8a93          	addi	s5,s5,-1932 # 80008208 <etext+0x208>
    printf("\n");
    8000199c:	00007a17          	auipc	s4,0x7
    800019a0:	dc4a0a13          	addi	s4,s4,-572 # 80008760 <syscalls+0x398>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019a4:	00007b97          	auipc	s7,0x7
    800019a8:	89cb8b93          	addi	s7,s7,-1892 # 80008240 <states.1709>
    800019ac:	a00d                	j	800019ce <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019ae:	ed86a583          	lw	a1,-296(a3)
    800019b2:	8556                	mv	a0,s5
    800019b4:	00004097          	auipc	ra,0x4
    800019b8:	4de080e7          	jalr	1246(ra) # 80005e92 <printf>
    printf("\n");
    800019bc:	8552                	mv	a0,s4
    800019be:	00004097          	auipc	ra,0x4
    800019c2:	4d4080e7          	jalr	1236(ra) # 80005e92 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c6:	16848493          	addi	s1,s1,360
    800019ca:	03248163          	beq	s1,s2,800019ec <procdump+0x98>
    if(p->state == UNUSED)
    800019ce:	86a6                	mv	a3,s1
    800019d0:	ec04a783          	lw	a5,-320(s1)
    800019d4:	dbed                	beqz	a5,800019c6 <procdump+0x72>
      state = "???";
    800019d6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d8:	fcfb6be3          	bltu	s6,a5,800019ae <procdump+0x5a>
    800019dc:	1782                	slli	a5,a5,0x20
    800019de:	9381                	srli	a5,a5,0x20
    800019e0:	078e                	slli	a5,a5,0x3
    800019e2:	97de                	add	a5,a5,s7
    800019e4:	6390                	ld	a2,0(a5)
    800019e6:	f661                	bnez	a2,800019ae <procdump+0x5a>
      state = "???";
    800019e8:	864e                	mv	a2,s3
    800019ea:	b7d1                	j	800019ae <procdump+0x5a>
  }
}
    800019ec:	60a6                	ld	ra,72(sp)
    800019ee:	6406                	ld	s0,64(sp)
    800019f0:	74e2                	ld	s1,56(sp)
    800019f2:	7942                	ld	s2,48(sp)
    800019f4:	79a2                	ld	s3,40(sp)
    800019f6:	7a02                	ld	s4,32(sp)
    800019f8:	6ae2                	ld	s5,24(sp)
    800019fa:	6b42                	ld	s6,16(sp)
    800019fc:	6ba2                	ld	s7,8(sp)
    800019fe:	6161                	addi	sp,sp,80
    80001a00:	8082                	ret

0000000080001a02 <swtch>:
    80001a02:	00153023          	sd	ra,0(a0)
    80001a06:	00253423          	sd	sp,8(a0)
    80001a0a:	e900                	sd	s0,16(a0)
    80001a0c:	ed04                	sd	s1,24(a0)
    80001a0e:	03253023          	sd	s2,32(a0)
    80001a12:	03353423          	sd	s3,40(a0)
    80001a16:	03453823          	sd	s4,48(a0)
    80001a1a:	03553c23          	sd	s5,56(a0)
    80001a1e:	05653023          	sd	s6,64(a0)
    80001a22:	05753423          	sd	s7,72(a0)
    80001a26:	05853823          	sd	s8,80(a0)
    80001a2a:	05953c23          	sd	s9,88(a0)
    80001a2e:	07a53023          	sd	s10,96(a0)
    80001a32:	07b53423          	sd	s11,104(a0)
    80001a36:	0005b083          	ld	ra,0(a1)
    80001a3a:	0085b103          	ld	sp,8(a1)
    80001a3e:	6980                	ld	s0,16(a1)
    80001a40:	6d84                	ld	s1,24(a1)
    80001a42:	0205b903          	ld	s2,32(a1)
    80001a46:	0285b983          	ld	s3,40(a1)
    80001a4a:	0305ba03          	ld	s4,48(a1)
    80001a4e:	0385ba83          	ld	s5,56(a1)
    80001a52:	0405bb03          	ld	s6,64(a1)
    80001a56:	0485bb83          	ld	s7,72(a1)
    80001a5a:	0505bc03          	ld	s8,80(a1)
    80001a5e:	0585bc83          	ld	s9,88(a1)
    80001a62:	0605bd03          	ld	s10,96(a1)
    80001a66:	0685bd83          	ld	s11,104(a1)
    80001a6a:	8082                	ret

0000000080001a6c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a6c:	1141                	addi	sp,sp,-16
    80001a6e:	e406                	sd	ra,8(sp)
    80001a70:	e022                	sd	s0,0(sp)
    80001a72:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a74:	00006597          	auipc	a1,0x6
    80001a78:	7fc58593          	addi	a1,a1,2044 # 80008270 <states.1709+0x30>
    80001a7c:	00009517          	auipc	a0,0x9
    80001a80:	81450513          	addi	a0,a0,-2028 # 8000a290 <tickslock>
    80001a84:	00005097          	auipc	ra,0x5
    80001a88:	87e080e7          	jalr	-1922(ra) # 80006302 <initlock>
}
    80001a8c:	60a2                	ld	ra,8(sp)
    80001a8e:	6402                	ld	s0,0(sp)
    80001a90:	0141                	addi	sp,sp,16
    80001a92:	8082                	ret

0000000080001a94 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001a94:	1141                	addi	sp,sp,-16
    80001a96:	e422                	sd	s0,8(sp)
    80001a98:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a9a:	00003797          	auipc	a5,0x3
    80001a9e:	7b678793          	addi	a5,a5,1974 # 80005250 <kernelvec>
    80001aa2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aa6:	6422                	ld	s0,8(sp)
    80001aa8:	0141                	addi	sp,sp,16
    80001aaa:	8082                	ret

0000000080001aac <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001aac:	1141                	addi	sp,sp,-16
    80001aae:	e406                	sd	ra,8(sp)
    80001ab0:	e022                	sd	s0,0(sp)
    80001ab2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	394080e7          	jalr	916(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001abc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ac0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ac6:	00005617          	auipc	a2,0x5
    80001aca:	53a60613          	addi	a2,a2,1338 # 80007000 <_trampoline>
    80001ace:	00005697          	auipc	a3,0x5
    80001ad2:	53268693          	addi	a3,a3,1330 # 80007000 <_trampoline>
    80001ad6:	8e91                	sub	a3,a3,a2
    80001ad8:	040007b7          	lui	a5,0x4000
    80001adc:	17fd                	addi	a5,a5,-1
    80001ade:	07b2                	slli	a5,a5,0xc
    80001ae0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ae6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ae8:	180026f3          	csrr	a3,satp
    80001aec:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001aee:	6d38                	ld	a4,88(a0)
    80001af0:	6134                	ld	a3,64(a0)
    80001af2:	6585                	lui	a1,0x1
    80001af4:	96ae                	add	a3,a3,a1
    80001af6:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001af8:	6d38                	ld	a4,88(a0)
    80001afa:	00000697          	auipc	a3,0x0
    80001afe:	13868693          	addi	a3,a3,312 # 80001c32 <usertrap>
    80001b02:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b04:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b06:	8692                	mv	a3,tp
    80001b08:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b0a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b0e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b12:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b16:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b1a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b1c:	6f18                	ld	a4,24(a4)
    80001b1e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b22:	692c                	ld	a1,80(a0)
    80001b24:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b26:	00005717          	auipc	a4,0x5
    80001b2a:	56a70713          	addi	a4,a4,1386 # 80007090 <userret>
    80001b2e:	8f11                	sub	a4,a4,a2
    80001b30:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b32:	577d                	li	a4,-1
    80001b34:	177e                	slli	a4,a4,0x3f
    80001b36:	8dd9                	or	a1,a1,a4
    80001b38:	02000537          	lui	a0,0x2000
    80001b3c:	157d                	addi	a0,a0,-1
    80001b3e:	0536                	slli	a0,a0,0xd
    80001b40:	9782                	jalr	a5
}
    80001b42:	60a2                	ld	ra,8(sp)
    80001b44:	6402                	ld	s0,0(sp)
    80001b46:	0141                	addi	sp,sp,16
    80001b48:	8082                	ret

0000000080001b4a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b4a:	1101                	addi	sp,sp,-32
    80001b4c:	ec06                	sd	ra,24(sp)
    80001b4e:	e822                	sd	s0,16(sp)
    80001b50:	e426                	sd	s1,8(sp)
    80001b52:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b54:	00008497          	auipc	s1,0x8
    80001b58:	73c48493          	addi	s1,s1,1852 # 8000a290 <tickslock>
    80001b5c:	8526                	mv	a0,s1
    80001b5e:	00005097          	auipc	ra,0x5
    80001b62:	834080e7          	jalr	-1996(ra) # 80006392 <acquire>
  ticks++;
    80001b66:	00007517          	auipc	a0,0x7
    80001b6a:	4b250513          	addi	a0,a0,1202 # 80009018 <ticks>
    80001b6e:	411c                	lw	a5,0(a0)
    80001b70:	2785                	addiw	a5,a5,1
    80001b72:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b74:	00000097          	auipc	ra,0x0
    80001b78:	b1c080e7          	jalr	-1252(ra) # 80001690 <wakeup>
  release(&tickslock);
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	00005097          	auipc	ra,0x5
    80001b82:	8c8080e7          	jalr	-1848(ra) # 80006446 <release>
}
    80001b86:	60e2                	ld	ra,24(sp)
    80001b88:	6442                	ld	s0,16(sp)
    80001b8a:	64a2                	ld	s1,8(sp)
    80001b8c:	6105                	addi	sp,sp,32
    80001b8e:	8082                	ret

0000000080001b90 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001b90:	1101                	addi	sp,sp,-32
    80001b92:	ec06                	sd	ra,24(sp)
    80001b94:	e822                	sd	s0,16(sp)
    80001b96:	e426                	sd	s1,8(sp)
    80001b98:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b9a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001b9e:	00074d63          	bltz	a4,80001bb8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001ba2:	57fd                	li	a5,-1
    80001ba4:	17fe                	slli	a5,a5,0x3f
    80001ba6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001ba8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001baa:	06f70363          	beq	a4,a5,80001c10 <devintr+0x80>
  }
}
    80001bae:	60e2                	ld	ra,24(sp)
    80001bb0:	6442                	ld	s0,16(sp)
    80001bb2:	64a2                	ld	s1,8(sp)
    80001bb4:	6105                	addi	sp,sp,32
    80001bb6:	8082                	ret
     (scause & 0xff) == 9){
    80001bb8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bbc:	46a5                	li	a3,9
    80001bbe:	fed792e3          	bne	a5,a3,80001ba2 <devintr+0x12>
    int irq = plic_claim();
    80001bc2:	00003097          	auipc	ra,0x3
    80001bc6:	796080e7          	jalr	1942(ra) # 80005358 <plic_claim>
    80001bca:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bcc:	47a9                	li	a5,10
    80001bce:	02f50763          	beq	a0,a5,80001bfc <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001bd2:	4785                	li	a5,1
    80001bd4:	02f50963          	beq	a0,a5,80001c06 <devintr+0x76>
    return 1;
    80001bd8:	4505                	li	a0,1
    } else if(irq){
    80001bda:	d8f1                	beqz	s1,80001bae <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bdc:	85a6                	mv	a1,s1
    80001bde:	00006517          	auipc	a0,0x6
    80001be2:	69a50513          	addi	a0,a0,1690 # 80008278 <states.1709+0x38>
    80001be6:	00004097          	auipc	ra,0x4
    80001bea:	2ac080e7          	jalr	684(ra) # 80005e92 <printf>
      plic_complete(irq);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	00003097          	auipc	ra,0x3
    80001bf4:	78c080e7          	jalr	1932(ra) # 8000537c <plic_complete>
    return 1;
    80001bf8:	4505                	li	a0,1
    80001bfa:	bf55                	j	80001bae <devintr+0x1e>
      uartintr();
    80001bfc:	00004097          	auipc	ra,0x4
    80001c00:	6b6080e7          	jalr	1718(ra) # 800062b2 <uartintr>
    80001c04:	b7ed                	j	80001bee <devintr+0x5e>
      virtio_disk_intr();
    80001c06:	00004097          	auipc	ra,0x4
    80001c0a:	c56080e7          	jalr	-938(ra) # 8000585c <virtio_disk_intr>
    80001c0e:	b7c5                	j	80001bee <devintr+0x5e>
    if(cpuid() == 0){
    80001c10:	fffff097          	auipc	ra,0xfffff
    80001c14:	20c080e7          	jalr	524(ra) # 80000e1c <cpuid>
    80001c18:	c901                	beqz	a0,80001c28 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c1a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c1e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c20:	14479073          	csrw	sip,a5
    return 2;
    80001c24:	4509                	li	a0,2
    80001c26:	b761                	j	80001bae <devintr+0x1e>
      clockintr();
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	f22080e7          	jalr	-222(ra) # 80001b4a <clockintr>
    80001c30:	b7ed                	j	80001c1a <devintr+0x8a>

0000000080001c32 <usertrap>:
{
    80001c32:	1101                	addi	sp,sp,-32
    80001c34:	ec06                	sd	ra,24(sp)
    80001c36:	e822                	sd	s0,16(sp)
    80001c38:	e426                	sd	s1,8(sp)
    80001c3a:	e04a                	sd	s2,0(sp)
    80001c3c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c3e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c42:	1007f793          	andi	a5,a5,256
    80001c46:	e3ad                	bnez	a5,80001ca8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c48:	00003797          	auipc	a5,0x3
    80001c4c:	60878793          	addi	a5,a5,1544 # 80005250 <kernelvec>
    80001c50:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c54:	fffff097          	auipc	ra,0xfffff
    80001c58:	1f4080e7          	jalr	500(ra) # 80000e48 <myproc>
    80001c5c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c5e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c60:	14102773          	csrr	a4,sepc
    80001c64:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c66:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c6a:	47a1                	li	a5,8
    80001c6c:	04f71c63          	bne	a4,a5,80001cc4 <usertrap+0x92>
    if(p->killed)
    80001c70:	551c                	lw	a5,40(a0)
    80001c72:	e3b9                	bnez	a5,80001cb8 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001c74:	6cb8                	ld	a4,88(s1)
    80001c76:	6f1c                	ld	a5,24(a4)
    80001c78:	0791                	addi	a5,a5,4
    80001c7a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c80:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c84:	10079073          	csrw	sstatus,a5
    syscall();
    80001c88:	00000097          	auipc	ra,0x0
    80001c8c:	2e0080e7          	jalr	736(ra) # 80001f68 <syscall>
  if(p->killed)
    80001c90:	549c                	lw	a5,40(s1)
    80001c92:	ebc1                	bnez	a5,80001d22 <usertrap+0xf0>
  usertrapret();
    80001c94:	00000097          	auipc	ra,0x0
    80001c98:	e18080e7          	jalr	-488(ra) # 80001aac <usertrapret>
}
    80001c9c:	60e2                	ld	ra,24(sp)
    80001c9e:	6442                	ld	s0,16(sp)
    80001ca0:	64a2                	ld	s1,8(sp)
    80001ca2:	6902                	ld	s2,0(sp)
    80001ca4:	6105                	addi	sp,sp,32
    80001ca6:	8082                	ret
    panic("usertrap: not from user mode");
    80001ca8:	00006517          	auipc	a0,0x6
    80001cac:	5f050513          	addi	a0,a0,1520 # 80008298 <states.1709+0x58>
    80001cb0:	00004097          	auipc	ra,0x4
    80001cb4:	198080e7          	jalr	408(ra) # 80005e48 <panic>
      exit(-1);
    80001cb8:	557d                	li	a0,-1
    80001cba:	00000097          	auipc	ra,0x0
    80001cbe:	aa6080e7          	jalr	-1370(ra) # 80001760 <exit>
    80001cc2:	bf4d                	j	80001c74 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cc4:	00000097          	auipc	ra,0x0
    80001cc8:	ecc080e7          	jalr	-308(ra) # 80001b90 <devintr>
    80001ccc:	892a                	mv	s2,a0
    80001cce:	c501                	beqz	a0,80001cd6 <usertrap+0xa4>
  if(p->killed)
    80001cd0:	549c                	lw	a5,40(s1)
    80001cd2:	c3a1                	beqz	a5,80001d12 <usertrap+0xe0>
    80001cd4:	a815                	j	80001d08 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cd6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cda:	5890                	lw	a2,48(s1)
    80001cdc:	00006517          	auipc	a0,0x6
    80001ce0:	5dc50513          	addi	a0,a0,1500 # 800082b8 <states.1709+0x78>
    80001ce4:	00004097          	auipc	ra,0x4
    80001ce8:	1ae080e7          	jalr	430(ra) # 80005e92 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001cf0:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001cf4:	00006517          	auipc	a0,0x6
    80001cf8:	5f450513          	addi	a0,a0,1524 # 800082e8 <states.1709+0xa8>
    80001cfc:	00004097          	auipc	ra,0x4
    80001d00:	196080e7          	jalr	406(ra) # 80005e92 <printf>
    p->killed = 1;
    80001d04:	4785                	li	a5,1
    80001d06:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d08:	557d                	li	a0,-1
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	a56080e7          	jalr	-1450(ra) # 80001760 <exit>
  if(which_dev == 2)
    80001d12:	4789                	li	a5,2
    80001d14:	f8f910e3          	bne	s2,a5,80001c94 <usertrap+0x62>
    yield();
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	7b0080e7          	jalr	1968(ra) # 800014c8 <yield>
    80001d20:	bf95                	j	80001c94 <usertrap+0x62>
  int which_dev = 0;
    80001d22:	4901                	li	s2,0
    80001d24:	b7d5                	j	80001d08 <usertrap+0xd6>

0000000080001d26 <kerneltrap>:
{
    80001d26:	7179                	addi	sp,sp,-48
    80001d28:	f406                	sd	ra,40(sp)
    80001d2a:	f022                	sd	s0,32(sp)
    80001d2c:	ec26                	sd	s1,24(sp)
    80001d2e:	e84a                	sd	s2,16(sp)
    80001d30:	e44e                	sd	s3,8(sp)
    80001d32:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d34:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d38:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d3c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d40:	1004f793          	andi	a5,s1,256
    80001d44:	cb85                	beqz	a5,80001d74 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d4a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d4c:	ef85                	bnez	a5,80001d84 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d4e:	00000097          	auipc	ra,0x0
    80001d52:	e42080e7          	jalr	-446(ra) # 80001b90 <devintr>
    80001d56:	cd1d                	beqz	a0,80001d94 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001d58:	4789                	li	a5,2
    80001d5a:	06f50a63          	beq	a0,a5,80001dce <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d5e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d62:	10049073          	csrw	sstatus,s1
}
    80001d66:	70a2                	ld	ra,40(sp)
    80001d68:	7402                	ld	s0,32(sp)
    80001d6a:	64e2                	ld	s1,24(sp)
    80001d6c:	6942                	ld	s2,16(sp)
    80001d6e:	69a2                	ld	s3,8(sp)
    80001d70:	6145                	addi	sp,sp,48
    80001d72:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001d74:	00006517          	auipc	a0,0x6
    80001d78:	59450513          	addi	a0,a0,1428 # 80008308 <states.1709+0xc8>
    80001d7c:	00004097          	auipc	ra,0x4
    80001d80:	0cc080e7          	jalr	204(ra) # 80005e48 <panic>
    panic("kerneltrap: interrupts enabled");
    80001d84:	00006517          	auipc	a0,0x6
    80001d88:	5ac50513          	addi	a0,a0,1452 # 80008330 <states.1709+0xf0>
    80001d8c:	00004097          	auipc	ra,0x4
    80001d90:	0bc080e7          	jalr	188(ra) # 80005e48 <panic>
    printf("scause %p\n", scause);
    80001d94:	85ce                	mv	a1,s3
    80001d96:	00006517          	auipc	a0,0x6
    80001d9a:	5ba50513          	addi	a0,a0,1466 # 80008350 <states.1709+0x110>
    80001d9e:	00004097          	auipc	ra,0x4
    80001da2:	0f4080e7          	jalr	244(ra) # 80005e92 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001daa:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dae:	00006517          	auipc	a0,0x6
    80001db2:	5b250513          	addi	a0,a0,1458 # 80008360 <states.1709+0x120>
    80001db6:	00004097          	auipc	ra,0x4
    80001dba:	0dc080e7          	jalr	220(ra) # 80005e92 <printf>
    panic("kerneltrap");
    80001dbe:	00006517          	auipc	a0,0x6
    80001dc2:	5ba50513          	addi	a0,a0,1466 # 80008378 <states.1709+0x138>
    80001dc6:	00004097          	auipc	ra,0x4
    80001dca:	082080e7          	jalr	130(ra) # 80005e48 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dce:	fffff097          	auipc	ra,0xfffff
    80001dd2:	07a080e7          	jalr	122(ra) # 80000e48 <myproc>
    80001dd6:	d541                	beqz	a0,80001d5e <kerneltrap+0x38>
    80001dd8:	fffff097          	auipc	ra,0xfffff
    80001ddc:	070080e7          	jalr	112(ra) # 80000e48 <myproc>
    80001de0:	4d18                	lw	a4,24(a0)
    80001de2:	4791                	li	a5,4
    80001de4:	f6f71de3          	bne	a4,a5,80001d5e <kerneltrap+0x38>
    yield();
    80001de8:	fffff097          	auipc	ra,0xfffff
    80001dec:	6e0080e7          	jalr	1760(ra) # 800014c8 <yield>
    80001df0:	b7bd                	j	80001d5e <kerneltrap+0x38>

0000000080001df2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001df2:	1101                	addi	sp,sp,-32
    80001df4:	ec06                	sd	ra,24(sp)
    80001df6:	e822                	sd	s0,16(sp)
    80001df8:	e426                	sd	s1,8(sp)
    80001dfa:	1000                	addi	s0,sp,32
    80001dfc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	04a080e7          	jalr	74(ra) # 80000e48 <myproc>
  switch (n) {
    80001e06:	4795                	li	a5,5
    80001e08:	0497e163          	bltu	a5,s1,80001e4a <argraw+0x58>
    80001e0c:	048a                	slli	s1,s1,0x2
    80001e0e:	00006717          	auipc	a4,0x6
    80001e12:	5a270713          	addi	a4,a4,1442 # 800083b0 <states.1709+0x170>
    80001e16:	94ba                	add	s1,s1,a4
    80001e18:	409c                	lw	a5,0(s1)
    80001e1a:	97ba                	add	a5,a5,a4
    80001e1c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e1e:	6d3c                	ld	a5,88(a0)
    80001e20:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e22:	60e2                	ld	ra,24(sp)
    80001e24:	6442                	ld	s0,16(sp)
    80001e26:	64a2                	ld	s1,8(sp)
    80001e28:	6105                	addi	sp,sp,32
    80001e2a:	8082                	ret
    return p->trapframe->a1;
    80001e2c:	6d3c                	ld	a5,88(a0)
    80001e2e:	7fa8                	ld	a0,120(a5)
    80001e30:	bfcd                	j	80001e22 <argraw+0x30>
    return p->trapframe->a2;
    80001e32:	6d3c                	ld	a5,88(a0)
    80001e34:	63c8                	ld	a0,128(a5)
    80001e36:	b7f5                	j	80001e22 <argraw+0x30>
    return p->trapframe->a3;
    80001e38:	6d3c                	ld	a5,88(a0)
    80001e3a:	67c8                	ld	a0,136(a5)
    80001e3c:	b7dd                	j	80001e22 <argraw+0x30>
    return p->trapframe->a4;
    80001e3e:	6d3c                	ld	a5,88(a0)
    80001e40:	6bc8                	ld	a0,144(a5)
    80001e42:	b7c5                	j	80001e22 <argraw+0x30>
    return p->trapframe->a5;
    80001e44:	6d3c                	ld	a5,88(a0)
    80001e46:	6fc8                	ld	a0,152(a5)
    80001e48:	bfe9                	j	80001e22 <argraw+0x30>
  panic("argraw");
    80001e4a:	00006517          	auipc	a0,0x6
    80001e4e:	53e50513          	addi	a0,a0,1342 # 80008388 <states.1709+0x148>
    80001e52:	00004097          	auipc	ra,0x4
    80001e56:	ff6080e7          	jalr	-10(ra) # 80005e48 <panic>

0000000080001e5a <fetchaddr>:
{
    80001e5a:	1101                	addi	sp,sp,-32
    80001e5c:	ec06                	sd	ra,24(sp)
    80001e5e:	e822                	sd	s0,16(sp)
    80001e60:	e426                	sd	s1,8(sp)
    80001e62:	e04a                	sd	s2,0(sp)
    80001e64:	1000                	addi	s0,sp,32
    80001e66:	84aa                	mv	s1,a0
    80001e68:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	fde080e7          	jalr	-34(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001e72:	653c                	ld	a5,72(a0)
    80001e74:	02f4f863          	bgeu	s1,a5,80001ea4 <fetchaddr+0x4a>
    80001e78:	00848713          	addi	a4,s1,8
    80001e7c:	02e7e663          	bltu	a5,a4,80001ea8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001e80:	46a1                	li	a3,8
    80001e82:	8626                	mv	a2,s1
    80001e84:	85ca                	mv	a1,s2
    80001e86:	6928                	ld	a0,80(a0)
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	d0e080e7          	jalr	-754(ra) # 80000b96 <copyin>
    80001e90:	00a03533          	snez	a0,a0
    80001e94:	40a00533          	neg	a0,a0
}
    80001e98:	60e2                	ld	ra,24(sp)
    80001e9a:	6442                	ld	s0,16(sp)
    80001e9c:	64a2                	ld	s1,8(sp)
    80001e9e:	6902                	ld	s2,0(sp)
    80001ea0:	6105                	addi	sp,sp,32
    80001ea2:	8082                	ret
    return -1;
    80001ea4:	557d                	li	a0,-1
    80001ea6:	bfcd                	j	80001e98 <fetchaddr+0x3e>
    80001ea8:	557d                	li	a0,-1
    80001eaa:	b7fd                	j	80001e98 <fetchaddr+0x3e>

0000000080001eac <fetchstr>:
{
    80001eac:	7179                	addi	sp,sp,-48
    80001eae:	f406                	sd	ra,40(sp)
    80001eb0:	f022                	sd	s0,32(sp)
    80001eb2:	ec26                	sd	s1,24(sp)
    80001eb4:	e84a                	sd	s2,16(sp)
    80001eb6:	e44e                	sd	s3,8(sp)
    80001eb8:	1800                	addi	s0,sp,48
    80001eba:	892a                	mv	s2,a0
    80001ebc:	84ae                	mv	s1,a1
    80001ebe:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	f88080e7          	jalr	-120(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001ec8:	86ce                	mv	a3,s3
    80001eca:	864a                	mv	a2,s2
    80001ecc:	85a6                	mv	a1,s1
    80001ece:	6928                	ld	a0,80(a0)
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	d52080e7          	jalr	-686(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001ed8:	00054763          	bltz	a0,80001ee6 <fetchstr+0x3a>
  return strlen(buf);
    80001edc:	8526                	mv	a0,s1
    80001ede:	ffffe097          	auipc	ra,0xffffe
    80001ee2:	41e080e7          	jalr	1054(ra) # 800002fc <strlen>
}
    80001ee6:	70a2                	ld	ra,40(sp)
    80001ee8:	7402                	ld	s0,32(sp)
    80001eea:	64e2                	ld	s1,24(sp)
    80001eec:	6942                	ld	s2,16(sp)
    80001eee:	69a2                	ld	s3,8(sp)
    80001ef0:	6145                	addi	sp,sp,48
    80001ef2:	8082                	ret

0000000080001ef4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001ef4:	1101                	addi	sp,sp,-32
    80001ef6:	ec06                	sd	ra,24(sp)
    80001ef8:	e822                	sd	s0,16(sp)
    80001efa:	e426                	sd	s1,8(sp)
    80001efc:	1000                	addi	s0,sp,32
    80001efe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f00:	00000097          	auipc	ra,0x0
    80001f04:	ef2080e7          	jalr	-270(ra) # 80001df2 <argraw>
    80001f08:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f0a:	4501                	li	a0,0
    80001f0c:	60e2                	ld	ra,24(sp)
    80001f0e:	6442                	ld	s0,16(sp)
    80001f10:	64a2                	ld	s1,8(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret

0000000080001f16 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f16:	1101                	addi	sp,sp,-32
    80001f18:	ec06                	sd	ra,24(sp)
    80001f1a:	e822                	sd	s0,16(sp)
    80001f1c:	e426                	sd	s1,8(sp)
    80001f1e:	1000                	addi	s0,sp,32
    80001f20:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f22:	00000097          	auipc	ra,0x0
    80001f26:	ed0080e7          	jalr	-304(ra) # 80001df2 <argraw>
    80001f2a:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f2c:	4501                	li	a0,0
    80001f2e:	60e2                	ld	ra,24(sp)
    80001f30:	6442                	ld	s0,16(sp)
    80001f32:	64a2                	ld	s1,8(sp)
    80001f34:	6105                	addi	sp,sp,32
    80001f36:	8082                	ret

0000000080001f38 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f38:	1101                	addi	sp,sp,-32
    80001f3a:	ec06                	sd	ra,24(sp)
    80001f3c:	e822                	sd	s0,16(sp)
    80001f3e:	e426                	sd	s1,8(sp)
    80001f40:	e04a                	sd	s2,0(sp)
    80001f42:	1000                	addi	s0,sp,32
    80001f44:	84ae                	mv	s1,a1
    80001f46:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f48:	00000097          	auipc	ra,0x0
    80001f4c:	eaa080e7          	jalr	-342(ra) # 80001df2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001f50:	864a                	mv	a2,s2
    80001f52:	85a6                	mv	a1,s1
    80001f54:	00000097          	auipc	ra,0x0
    80001f58:	f58080e7          	jalr	-168(ra) # 80001eac <fetchstr>
}
    80001f5c:	60e2                	ld	ra,24(sp)
    80001f5e:	6442                	ld	s0,16(sp)
    80001f60:	64a2                	ld	s1,8(sp)
    80001f62:	6902                	ld	s2,0(sp)
    80001f64:	6105                	addi	sp,sp,32
    80001f66:	8082                	ret

0000000080001f68 <syscall>:
[SYS_symlink] sys_symlink,
};

void
syscall(void)
{
    80001f68:	1101                	addi	sp,sp,-32
    80001f6a:	ec06                	sd	ra,24(sp)
    80001f6c:	e822                	sd	s0,16(sp)
    80001f6e:	e426                	sd	s1,8(sp)
    80001f70:	e04a                	sd	s2,0(sp)
    80001f72:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	ed4080e7          	jalr	-300(ra) # 80000e48 <myproc>
    80001f7c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001f7e:	05853903          	ld	s2,88(a0)
    80001f82:	0a893783          	ld	a5,168(s2)
    80001f86:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001f8a:	37fd                	addiw	a5,a5,-1
    80001f8c:	4755                	li	a4,21
    80001f8e:	00f76f63          	bltu	a4,a5,80001fac <syscall+0x44>
    80001f92:	00369713          	slli	a4,a3,0x3
    80001f96:	00006797          	auipc	a5,0x6
    80001f9a:	43278793          	addi	a5,a5,1074 # 800083c8 <syscalls>
    80001f9e:	97ba                	add	a5,a5,a4
    80001fa0:	639c                	ld	a5,0(a5)
    80001fa2:	c789                	beqz	a5,80001fac <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80001fa4:	9782                	jalr	a5
    80001fa6:	06a93823          	sd	a0,112(s2)
    80001faa:	a839                	j	80001fc8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fac:	15848613          	addi	a2,s1,344
    80001fb0:	588c                	lw	a1,48(s1)
    80001fb2:	00006517          	auipc	a0,0x6
    80001fb6:	3de50513          	addi	a0,a0,990 # 80008390 <states.1709+0x150>
    80001fba:	00004097          	auipc	ra,0x4
    80001fbe:	ed8080e7          	jalr	-296(ra) # 80005e92 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001fc2:	6cbc                	ld	a5,88(s1)
    80001fc4:	577d                	li	a4,-1
    80001fc6:	fbb8                	sd	a4,112(a5)
  }
}
    80001fc8:	60e2                	ld	ra,24(sp)
    80001fca:	6442                	ld	s0,16(sp)
    80001fcc:	64a2                	ld	s1,8(sp)
    80001fce:	6902                	ld	s2,0(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret

0000000080001fd4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001fd4:	1101                	addi	sp,sp,-32
    80001fd6:	ec06                	sd	ra,24(sp)
    80001fd8:	e822                	sd	s0,16(sp)
    80001fda:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80001fdc:	fec40593          	addi	a1,s0,-20
    80001fe0:	4501                	li	a0,0
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	f12080e7          	jalr	-238(ra) # 80001ef4 <argint>
    return -1;
    80001fea:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80001fec:	00054963          	bltz	a0,80001ffe <sys_exit+0x2a>
  exit(n);
    80001ff0:	fec42503          	lw	a0,-20(s0)
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	76c080e7          	jalr	1900(ra) # 80001760 <exit>
  return 0;  // not reached
    80001ffc:	4781                	li	a5,0
}
    80001ffe:	853e                	mv	a0,a5
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	6105                	addi	sp,sp,32
    80002006:	8082                	ret

0000000080002008 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002008:	1141                	addi	sp,sp,-16
    8000200a:	e406                	sd	ra,8(sp)
    8000200c:	e022                	sd	s0,0(sp)
    8000200e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002010:	fffff097          	auipc	ra,0xfffff
    80002014:	e38080e7          	jalr	-456(ra) # 80000e48 <myproc>
}
    80002018:	5908                	lw	a0,48(a0)
    8000201a:	60a2                	ld	ra,8(sp)
    8000201c:	6402                	ld	s0,0(sp)
    8000201e:	0141                	addi	sp,sp,16
    80002020:	8082                	ret

0000000080002022 <sys_fork>:

uint64
sys_fork(void)
{
    80002022:	1141                	addi	sp,sp,-16
    80002024:	e406                	sd	ra,8(sp)
    80002026:	e022                	sd	s0,0(sp)
    80002028:	0800                	addi	s0,sp,16
  return fork();
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	1ec080e7          	jalr	492(ra) # 80001216 <fork>
}
    80002032:	60a2                	ld	ra,8(sp)
    80002034:	6402                	ld	s0,0(sp)
    80002036:	0141                	addi	sp,sp,16
    80002038:	8082                	ret

000000008000203a <sys_wait>:

uint64
sys_wait(void)
{
    8000203a:	1101                	addi	sp,sp,-32
    8000203c:	ec06                	sd	ra,24(sp)
    8000203e:	e822                	sd	s0,16(sp)
    80002040:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002042:	fe840593          	addi	a1,s0,-24
    80002046:	4501                	li	a0,0
    80002048:	00000097          	auipc	ra,0x0
    8000204c:	ece080e7          	jalr	-306(ra) # 80001f16 <argaddr>
    80002050:	87aa                	mv	a5,a0
    return -1;
    80002052:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002054:	0007c863          	bltz	a5,80002064 <sys_wait+0x2a>
  return wait(p);
    80002058:	fe843503          	ld	a0,-24(s0)
    8000205c:	fffff097          	auipc	ra,0xfffff
    80002060:	50c080e7          	jalr	1292(ra) # 80001568 <wait>
}
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	6105                	addi	sp,sp,32
    8000206a:	8082                	ret

000000008000206c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000206c:	7179                	addi	sp,sp,-48
    8000206e:	f406                	sd	ra,40(sp)
    80002070:	f022                	sd	s0,32(sp)
    80002072:	ec26                	sd	s1,24(sp)
    80002074:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002076:	fdc40593          	addi	a1,s0,-36
    8000207a:	4501                	li	a0,0
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	e78080e7          	jalr	-392(ra) # 80001ef4 <argint>
    80002084:	87aa                	mv	a5,a0
    return -1;
    80002086:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002088:	0207c063          	bltz	a5,800020a8 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000208c:	fffff097          	auipc	ra,0xfffff
    80002090:	dbc080e7          	jalr	-580(ra) # 80000e48 <myproc>
    80002094:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002096:	fdc42503          	lw	a0,-36(s0)
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	108080e7          	jalr	264(ra) # 800011a2 <growproc>
    800020a2:	00054863          	bltz	a0,800020b2 <sys_sbrk+0x46>
    return -1;
  return addr;
    800020a6:	8526                	mv	a0,s1
}
    800020a8:	70a2                	ld	ra,40(sp)
    800020aa:	7402                	ld	s0,32(sp)
    800020ac:	64e2                	ld	s1,24(sp)
    800020ae:	6145                	addi	sp,sp,48
    800020b0:	8082                	ret
    return -1;
    800020b2:	557d                	li	a0,-1
    800020b4:	bfd5                	j	800020a8 <sys_sbrk+0x3c>

00000000800020b6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800020b6:	7139                	addi	sp,sp,-64
    800020b8:	fc06                	sd	ra,56(sp)
    800020ba:	f822                	sd	s0,48(sp)
    800020bc:	f426                	sd	s1,40(sp)
    800020be:	f04a                	sd	s2,32(sp)
    800020c0:	ec4e                	sd	s3,24(sp)
    800020c2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800020c4:	fcc40593          	addi	a1,s0,-52
    800020c8:	4501                	li	a0,0
    800020ca:	00000097          	auipc	ra,0x0
    800020ce:	e2a080e7          	jalr	-470(ra) # 80001ef4 <argint>
    return -1;
    800020d2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020d4:	06054563          	bltz	a0,8000213e <sys_sleep+0x88>
  acquire(&tickslock);
    800020d8:	00008517          	auipc	a0,0x8
    800020dc:	1b850513          	addi	a0,a0,440 # 8000a290 <tickslock>
    800020e0:	00004097          	auipc	ra,0x4
    800020e4:	2b2080e7          	jalr	690(ra) # 80006392 <acquire>
  ticks0 = ticks;
    800020e8:	00007917          	auipc	s2,0x7
    800020ec:	f3092903          	lw	s2,-208(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800020f0:	fcc42783          	lw	a5,-52(s0)
    800020f4:	cf85                	beqz	a5,8000212c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800020f6:	00008997          	auipc	s3,0x8
    800020fa:	19a98993          	addi	s3,s3,410 # 8000a290 <tickslock>
    800020fe:	00007497          	auipc	s1,0x7
    80002102:	f1a48493          	addi	s1,s1,-230 # 80009018 <ticks>
    if(myproc()->killed){
    80002106:	fffff097          	auipc	ra,0xfffff
    8000210a:	d42080e7          	jalr	-702(ra) # 80000e48 <myproc>
    8000210e:	551c                	lw	a5,40(a0)
    80002110:	ef9d                	bnez	a5,8000214e <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002112:	85ce                	mv	a1,s3
    80002114:	8526                	mv	a0,s1
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	3ee080e7          	jalr	1006(ra) # 80001504 <sleep>
  while(ticks - ticks0 < n){
    8000211e:	409c                	lw	a5,0(s1)
    80002120:	412787bb          	subw	a5,a5,s2
    80002124:	fcc42703          	lw	a4,-52(s0)
    80002128:	fce7efe3          	bltu	a5,a4,80002106 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000212c:	00008517          	auipc	a0,0x8
    80002130:	16450513          	addi	a0,a0,356 # 8000a290 <tickslock>
    80002134:	00004097          	auipc	ra,0x4
    80002138:	312080e7          	jalr	786(ra) # 80006446 <release>
  return 0;
    8000213c:	4781                	li	a5,0
}
    8000213e:	853e                	mv	a0,a5
    80002140:	70e2                	ld	ra,56(sp)
    80002142:	7442                	ld	s0,48(sp)
    80002144:	74a2                	ld	s1,40(sp)
    80002146:	7902                	ld	s2,32(sp)
    80002148:	69e2                	ld	s3,24(sp)
    8000214a:	6121                	addi	sp,sp,64
    8000214c:	8082                	ret
      release(&tickslock);
    8000214e:	00008517          	auipc	a0,0x8
    80002152:	14250513          	addi	a0,a0,322 # 8000a290 <tickslock>
    80002156:	00004097          	auipc	ra,0x4
    8000215a:	2f0080e7          	jalr	752(ra) # 80006446 <release>
      return -1;
    8000215e:	57fd                	li	a5,-1
    80002160:	bff9                	j	8000213e <sys_sleep+0x88>

0000000080002162 <sys_kill>:

uint64
sys_kill(void)
{
    80002162:	1101                	addi	sp,sp,-32
    80002164:	ec06                	sd	ra,24(sp)
    80002166:	e822                	sd	s0,16(sp)
    80002168:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000216a:	fec40593          	addi	a1,s0,-20
    8000216e:	4501                	li	a0,0
    80002170:	00000097          	auipc	ra,0x0
    80002174:	d84080e7          	jalr	-636(ra) # 80001ef4 <argint>
    80002178:	87aa                	mv	a5,a0
    return -1;
    8000217a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000217c:	0007c863          	bltz	a5,8000218c <sys_kill+0x2a>
  return kill(pid);
    80002180:	fec42503          	lw	a0,-20(s0)
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	6b2080e7          	jalr	1714(ra) # 80001836 <kill>
}
    8000218c:	60e2                	ld	ra,24(sp)
    8000218e:	6442                	ld	s0,16(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000219e:	00008517          	auipc	a0,0x8
    800021a2:	0f250513          	addi	a0,a0,242 # 8000a290 <tickslock>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	1ec080e7          	jalr	492(ra) # 80006392 <acquire>
  xticks = ticks;
    800021ae:	00007497          	auipc	s1,0x7
    800021b2:	e6a4a483          	lw	s1,-406(s1) # 80009018 <ticks>
  release(&tickslock);
    800021b6:	00008517          	auipc	a0,0x8
    800021ba:	0da50513          	addi	a0,a0,218 # 8000a290 <tickslock>
    800021be:	00004097          	auipc	ra,0x4
    800021c2:	288080e7          	jalr	648(ra) # 80006446 <release>
  return xticks;
}
    800021c6:	02049513          	slli	a0,s1,0x20
    800021ca:	9101                	srli	a0,a0,0x20
    800021cc:	60e2                	ld	ra,24(sp)
    800021ce:	6442                	ld	s0,16(sp)
    800021d0:	64a2                	ld	s1,8(sp)
    800021d2:	6105                	addi	sp,sp,32
    800021d4:	8082                	ret

00000000800021d6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021d6:	7179                	addi	sp,sp,-48
    800021d8:	f406                	sd	ra,40(sp)
    800021da:	f022                	sd	s0,32(sp)
    800021dc:	ec26                	sd	s1,24(sp)
    800021de:	e84a                	sd	s2,16(sp)
    800021e0:	e44e                	sd	s3,8(sp)
    800021e2:	e052                	sd	s4,0(sp)
    800021e4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021e6:	00006597          	auipc	a1,0x6
    800021ea:	29a58593          	addi	a1,a1,666 # 80008480 <syscalls+0xb8>
    800021ee:	00008517          	auipc	a0,0x8
    800021f2:	0ba50513          	addi	a0,a0,186 # 8000a2a8 <bcache>
    800021f6:	00004097          	auipc	ra,0x4
    800021fa:	10c080e7          	jalr	268(ra) # 80006302 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800021fe:	00010797          	auipc	a5,0x10
    80002202:	0aa78793          	addi	a5,a5,170 # 800122a8 <bcache+0x8000>
    80002206:	00010717          	auipc	a4,0x10
    8000220a:	30a70713          	addi	a4,a4,778 # 80012510 <bcache+0x8268>
    8000220e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002212:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002216:	00008497          	auipc	s1,0x8
    8000221a:	0aa48493          	addi	s1,s1,170 # 8000a2c0 <bcache+0x18>
    b->next = bcache.head.next;
    8000221e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002220:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002222:	00006a17          	auipc	s4,0x6
    80002226:	266a0a13          	addi	s4,s4,614 # 80008488 <syscalls+0xc0>
    b->next = bcache.head.next;
    8000222a:	2b893783          	ld	a5,696(s2)
    8000222e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002230:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002234:	85d2                	mv	a1,s4
    80002236:	01048513          	addi	a0,s1,16
    8000223a:	00001097          	auipc	ra,0x1
    8000223e:	62e080e7          	jalr	1582(ra) # 80003868 <initsleeplock>
    bcache.head.next->prev = b;
    80002242:	2b893783          	ld	a5,696(s2)
    80002246:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002248:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000224c:	45848493          	addi	s1,s1,1112
    80002250:	fd349de3          	bne	s1,s3,8000222a <binit+0x54>
  }
}
    80002254:	70a2                	ld	ra,40(sp)
    80002256:	7402                	ld	s0,32(sp)
    80002258:	64e2                	ld	s1,24(sp)
    8000225a:	6942                	ld	s2,16(sp)
    8000225c:	69a2                	ld	s3,8(sp)
    8000225e:	6a02                	ld	s4,0(sp)
    80002260:	6145                	addi	sp,sp,48
    80002262:	8082                	ret

0000000080002264 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002264:	7179                	addi	sp,sp,-48
    80002266:	f406                	sd	ra,40(sp)
    80002268:	f022                	sd	s0,32(sp)
    8000226a:	ec26                	sd	s1,24(sp)
    8000226c:	e84a                	sd	s2,16(sp)
    8000226e:	e44e                	sd	s3,8(sp)
    80002270:	1800                	addi	s0,sp,48
    80002272:	89aa                	mv	s3,a0
    80002274:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002276:	00008517          	auipc	a0,0x8
    8000227a:	03250513          	addi	a0,a0,50 # 8000a2a8 <bcache>
    8000227e:	00004097          	auipc	ra,0x4
    80002282:	114080e7          	jalr	276(ra) # 80006392 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002286:	00010497          	auipc	s1,0x10
    8000228a:	2da4b483          	ld	s1,730(s1) # 80012560 <bcache+0x82b8>
    8000228e:	00010797          	auipc	a5,0x10
    80002292:	28278793          	addi	a5,a5,642 # 80012510 <bcache+0x8268>
    80002296:	02f48f63          	beq	s1,a5,800022d4 <bread+0x70>
    8000229a:	873e                	mv	a4,a5
    8000229c:	a021                	j	800022a4 <bread+0x40>
    8000229e:	68a4                	ld	s1,80(s1)
    800022a0:	02e48a63          	beq	s1,a4,800022d4 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800022a4:	449c                	lw	a5,8(s1)
    800022a6:	ff379ce3          	bne	a5,s3,8000229e <bread+0x3a>
    800022aa:	44dc                	lw	a5,12(s1)
    800022ac:	ff2799e3          	bne	a5,s2,8000229e <bread+0x3a>
      b->refcnt++;
    800022b0:	40bc                	lw	a5,64(s1)
    800022b2:	2785                	addiw	a5,a5,1
    800022b4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022b6:	00008517          	auipc	a0,0x8
    800022ba:	ff250513          	addi	a0,a0,-14 # 8000a2a8 <bcache>
    800022be:	00004097          	auipc	ra,0x4
    800022c2:	188080e7          	jalr	392(ra) # 80006446 <release>
      acquiresleep(&b->lock);
    800022c6:	01048513          	addi	a0,s1,16
    800022ca:	00001097          	auipc	ra,0x1
    800022ce:	5d8080e7          	jalr	1496(ra) # 800038a2 <acquiresleep>
      return b;
    800022d2:	a8b9                	j	80002330 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022d4:	00010497          	auipc	s1,0x10
    800022d8:	2844b483          	ld	s1,644(s1) # 80012558 <bcache+0x82b0>
    800022dc:	00010797          	auipc	a5,0x10
    800022e0:	23478793          	addi	a5,a5,564 # 80012510 <bcache+0x8268>
    800022e4:	00f48863          	beq	s1,a5,800022f4 <bread+0x90>
    800022e8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022ea:	40bc                	lw	a5,64(s1)
    800022ec:	cf81                	beqz	a5,80002304 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022ee:	64a4                	ld	s1,72(s1)
    800022f0:	fee49de3          	bne	s1,a4,800022ea <bread+0x86>
  panic("bget: no buffers");
    800022f4:	00006517          	auipc	a0,0x6
    800022f8:	19c50513          	addi	a0,a0,412 # 80008490 <syscalls+0xc8>
    800022fc:	00004097          	auipc	ra,0x4
    80002300:	b4c080e7          	jalr	-1204(ra) # 80005e48 <panic>
      b->dev = dev;
    80002304:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002308:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000230c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002310:	4785                	li	a5,1
    80002312:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002314:	00008517          	auipc	a0,0x8
    80002318:	f9450513          	addi	a0,a0,-108 # 8000a2a8 <bcache>
    8000231c:	00004097          	auipc	ra,0x4
    80002320:	12a080e7          	jalr	298(ra) # 80006446 <release>
      acquiresleep(&b->lock);
    80002324:	01048513          	addi	a0,s1,16
    80002328:	00001097          	auipc	ra,0x1
    8000232c:	57a080e7          	jalr	1402(ra) # 800038a2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002330:	409c                	lw	a5,0(s1)
    80002332:	cb89                	beqz	a5,80002344 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002334:	8526                	mv	a0,s1
    80002336:	70a2                	ld	ra,40(sp)
    80002338:	7402                	ld	s0,32(sp)
    8000233a:	64e2                	ld	s1,24(sp)
    8000233c:	6942                	ld	s2,16(sp)
    8000233e:	69a2                	ld	s3,8(sp)
    80002340:	6145                	addi	sp,sp,48
    80002342:	8082                	ret
    virtio_disk_rw(b, 0);
    80002344:	4581                	li	a1,0
    80002346:	8526                	mv	a0,s1
    80002348:	00003097          	auipc	ra,0x3
    8000234c:	23e080e7          	jalr	574(ra) # 80005586 <virtio_disk_rw>
    b->valid = 1;
    80002350:	4785                	li	a5,1
    80002352:	c09c                	sw	a5,0(s1)
  return b;
    80002354:	b7c5                	j	80002334 <bread+0xd0>

0000000080002356 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002356:	1101                	addi	sp,sp,-32
    80002358:	ec06                	sd	ra,24(sp)
    8000235a:	e822                	sd	s0,16(sp)
    8000235c:	e426                	sd	s1,8(sp)
    8000235e:	1000                	addi	s0,sp,32
    80002360:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002362:	0541                	addi	a0,a0,16
    80002364:	00001097          	auipc	ra,0x1
    80002368:	5d8080e7          	jalr	1496(ra) # 8000393c <holdingsleep>
    8000236c:	cd01                	beqz	a0,80002384 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000236e:	4585                	li	a1,1
    80002370:	8526                	mv	a0,s1
    80002372:	00003097          	auipc	ra,0x3
    80002376:	214080e7          	jalr	532(ra) # 80005586 <virtio_disk_rw>
}
    8000237a:	60e2                	ld	ra,24(sp)
    8000237c:	6442                	ld	s0,16(sp)
    8000237e:	64a2                	ld	s1,8(sp)
    80002380:	6105                	addi	sp,sp,32
    80002382:	8082                	ret
    panic("bwrite");
    80002384:	00006517          	auipc	a0,0x6
    80002388:	12450513          	addi	a0,a0,292 # 800084a8 <syscalls+0xe0>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	abc080e7          	jalr	-1348(ra) # 80005e48 <panic>

0000000080002394 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002394:	1101                	addi	sp,sp,-32
    80002396:	ec06                	sd	ra,24(sp)
    80002398:	e822                	sd	s0,16(sp)
    8000239a:	e426                	sd	s1,8(sp)
    8000239c:	e04a                	sd	s2,0(sp)
    8000239e:	1000                	addi	s0,sp,32
    800023a0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800023a2:	01050913          	addi	s2,a0,16
    800023a6:	854a                	mv	a0,s2
    800023a8:	00001097          	auipc	ra,0x1
    800023ac:	594080e7          	jalr	1428(ra) # 8000393c <holdingsleep>
    800023b0:	c92d                	beqz	a0,80002422 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800023b2:	854a                	mv	a0,s2
    800023b4:	00001097          	auipc	ra,0x1
    800023b8:	544080e7          	jalr	1348(ra) # 800038f8 <releasesleep>

  acquire(&bcache.lock);
    800023bc:	00008517          	auipc	a0,0x8
    800023c0:	eec50513          	addi	a0,a0,-276 # 8000a2a8 <bcache>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	fce080e7          	jalr	-50(ra) # 80006392 <acquire>
  b->refcnt--;
    800023cc:	40bc                	lw	a5,64(s1)
    800023ce:	37fd                	addiw	a5,a5,-1
    800023d0:	0007871b          	sext.w	a4,a5
    800023d4:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023d6:	eb05                	bnez	a4,80002406 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023d8:	68bc                	ld	a5,80(s1)
    800023da:	64b8                	ld	a4,72(s1)
    800023dc:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800023de:	64bc                	ld	a5,72(s1)
    800023e0:	68b8                	ld	a4,80(s1)
    800023e2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023e4:	00010797          	auipc	a5,0x10
    800023e8:	ec478793          	addi	a5,a5,-316 # 800122a8 <bcache+0x8000>
    800023ec:	2b87b703          	ld	a4,696(a5)
    800023f0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023f2:	00010717          	auipc	a4,0x10
    800023f6:	11e70713          	addi	a4,a4,286 # 80012510 <bcache+0x8268>
    800023fa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800023fc:	2b87b703          	ld	a4,696(a5)
    80002400:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002402:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002406:	00008517          	auipc	a0,0x8
    8000240a:	ea250513          	addi	a0,a0,-350 # 8000a2a8 <bcache>
    8000240e:	00004097          	auipc	ra,0x4
    80002412:	038080e7          	jalr	56(ra) # 80006446 <release>
}
    80002416:	60e2                	ld	ra,24(sp)
    80002418:	6442                	ld	s0,16(sp)
    8000241a:	64a2                	ld	s1,8(sp)
    8000241c:	6902                	ld	s2,0(sp)
    8000241e:	6105                	addi	sp,sp,32
    80002420:	8082                	ret
    panic("brelse");
    80002422:	00006517          	auipc	a0,0x6
    80002426:	08e50513          	addi	a0,a0,142 # 800084b0 <syscalls+0xe8>
    8000242a:	00004097          	auipc	ra,0x4
    8000242e:	a1e080e7          	jalr	-1506(ra) # 80005e48 <panic>

0000000080002432 <bpin>:

void
bpin(struct buf *b) {
    80002432:	1101                	addi	sp,sp,-32
    80002434:	ec06                	sd	ra,24(sp)
    80002436:	e822                	sd	s0,16(sp)
    80002438:	e426                	sd	s1,8(sp)
    8000243a:	1000                	addi	s0,sp,32
    8000243c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000243e:	00008517          	auipc	a0,0x8
    80002442:	e6a50513          	addi	a0,a0,-406 # 8000a2a8 <bcache>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	f4c080e7          	jalr	-180(ra) # 80006392 <acquire>
  b->refcnt++;
    8000244e:	40bc                	lw	a5,64(s1)
    80002450:	2785                	addiw	a5,a5,1
    80002452:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002454:	00008517          	auipc	a0,0x8
    80002458:	e5450513          	addi	a0,a0,-428 # 8000a2a8 <bcache>
    8000245c:	00004097          	auipc	ra,0x4
    80002460:	fea080e7          	jalr	-22(ra) # 80006446 <release>
}
    80002464:	60e2                	ld	ra,24(sp)
    80002466:	6442                	ld	s0,16(sp)
    80002468:	64a2                	ld	s1,8(sp)
    8000246a:	6105                	addi	sp,sp,32
    8000246c:	8082                	ret

000000008000246e <bunpin>:

void
bunpin(struct buf *b) {
    8000246e:	1101                	addi	sp,sp,-32
    80002470:	ec06                	sd	ra,24(sp)
    80002472:	e822                	sd	s0,16(sp)
    80002474:	e426                	sd	s1,8(sp)
    80002476:	1000                	addi	s0,sp,32
    80002478:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000247a:	00008517          	auipc	a0,0x8
    8000247e:	e2e50513          	addi	a0,a0,-466 # 8000a2a8 <bcache>
    80002482:	00004097          	auipc	ra,0x4
    80002486:	f10080e7          	jalr	-240(ra) # 80006392 <acquire>
  b->refcnt--;
    8000248a:	40bc                	lw	a5,64(s1)
    8000248c:	37fd                	addiw	a5,a5,-1
    8000248e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002490:	00008517          	auipc	a0,0x8
    80002494:	e1850513          	addi	a0,a0,-488 # 8000a2a8 <bcache>
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	fae080e7          	jalr	-82(ra) # 80006446 <release>
}
    800024a0:	60e2                	ld	ra,24(sp)
    800024a2:	6442                	ld	s0,16(sp)
    800024a4:	64a2                	ld	s1,8(sp)
    800024a6:	6105                	addi	sp,sp,32
    800024a8:	8082                	ret

00000000800024aa <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800024aa:	1101                	addi	sp,sp,-32
    800024ac:	ec06                	sd	ra,24(sp)
    800024ae:	e822                	sd	s0,16(sp)
    800024b0:	e426                	sd	s1,8(sp)
    800024b2:	e04a                	sd	s2,0(sp)
    800024b4:	1000                	addi	s0,sp,32
    800024b6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800024b8:	00d5d59b          	srliw	a1,a1,0xd
    800024bc:	00010797          	auipc	a5,0x10
    800024c0:	4c87a783          	lw	a5,1224(a5) # 80012984 <sb+0x1c>
    800024c4:	9dbd                	addw	a1,a1,a5
    800024c6:	00000097          	auipc	ra,0x0
    800024ca:	d9e080e7          	jalr	-610(ra) # 80002264 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800024ce:	0074f713          	andi	a4,s1,7
    800024d2:	4785                	li	a5,1
    800024d4:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800024d8:	14ce                	slli	s1,s1,0x33
    800024da:	90d9                	srli	s1,s1,0x36
    800024dc:	00950733          	add	a4,a0,s1
    800024e0:	05874703          	lbu	a4,88(a4)
    800024e4:	00e7f6b3          	and	a3,a5,a4
    800024e8:	c69d                	beqz	a3,80002516 <bfree+0x6c>
    800024ea:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024ec:	94aa                	add	s1,s1,a0
    800024ee:	fff7c793          	not	a5,a5
    800024f2:	8ff9                	and	a5,a5,a4
    800024f4:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800024f8:	00001097          	auipc	ra,0x1
    800024fc:	28a080e7          	jalr	650(ra) # 80003782 <log_write>
  brelse(bp);
    80002500:	854a                	mv	a0,s2
    80002502:	00000097          	auipc	ra,0x0
    80002506:	e92080e7          	jalr	-366(ra) # 80002394 <brelse>
}
    8000250a:	60e2                	ld	ra,24(sp)
    8000250c:	6442                	ld	s0,16(sp)
    8000250e:	64a2                	ld	s1,8(sp)
    80002510:	6902                	ld	s2,0(sp)
    80002512:	6105                	addi	sp,sp,32
    80002514:	8082                	ret
    panic("freeing free block");
    80002516:	00006517          	auipc	a0,0x6
    8000251a:	fa250513          	addi	a0,a0,-94 # 800084b8 <syscalls+0xf0>
    8000251e:	00004097          	auipc	ra,0x4
    80002522:	92a080e7          	jalr	-1750(ra) # 80005e48 <panic>

0000000080002526 <balloc>:
{
    80002526:	711d                	addi	sp,sp,-96
    80002528:	ec86                	sd	ra,88(sp)
    8000252a:	e8a2                	sd	s0,80(sp)
    8000252c:	e4a6                	sd	s1,72(sp)
    8000252e:	e0ca                	sd	s2,64(sp)
    80002530:	fc4e                	sd	s3,56(sp)
    80002532:	f852                	sd	s4,48(sp)
    80002534:	f456                	sd	s5,40(sp)
    80002536:	f05a                	sd	s6,32(sp)
    80002538:	ec5e                	sd	s7,24(sp)
    8000253a:	e862                	sd	s8,16(sp)
    8000253c:	e466                	sd	s9,8(sp)
    8000253e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002540:	00010797          	auipc	a5,0x10
    80002544:	42c7a783          	lw	a5,1068(a5) # 8001296c <sb+0x4>
    80002548:	cbd1                	beqz	a5,800025dc <balloc+0xb6>
    8000254a:	8baa                	mv	s7,a0
    8000254c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000254e:	00010b17          	auipc	s6,0x10
    80002552:	41ab0b13          	addi	s6,s6,1050 # 80012968 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002556:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002558:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000255a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000255c:	6c89                	lui	s9,0x2
    8000255e:	a831                	j	8000257a <balloc+0x54>
    brelse(bp);
    80002560:	854a                	mv	a0,s2
    80002562:	00000097          	auipc	ra,0x0
    80002566:	e32080e7          	jalr	-462(ra) # 80002394 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000256a:	015c87bb          	addw	a5,s9,s5
    8000256e:	00078a9b          	sext.w	s5,a5
    80002572:	004b2703          	lw	a4,4(s6)
    80002576:	06eaf363          	bgeu	s5,a4,800025dc <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000257a:	41fad79b          	sraiw	a5,s5,0x1f
    8000257e:	0137d79b          	srliw	a5,a5,0x13
    80002582:	015787bb          	addw	a5,a5,s5
    80002586:	40d7d79b          	sraiw	a5,a5,0xd
    8000258a:	01cb2583          	lw	a1,28(s6)
    8000258e:	9dbd                	addw	a1,a1,a5
    80002590:	855e                	mv	a0,s7
    80002592:	00000097          	auipc	ra,0x0
    80002596:	cd2080e7          	jalr	-814(ra) # 80002264 <bread>
    8000259a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000259c:	004b2503          	lw	a0,4(s6)
    800025a0:	000a849b          	sext.w	s1,s5
    800025a4:	8662                	mv	a2,s8
    800025a6:	faa4fde3          	bgeu	s1,a0,80002560 <balloc+0x3a>
      m = 1 << (bi % 8);
    800025aa:	41f6579b          	sraiw	a5,a2,0x1f
    800025ae:	01d7d69b          	srliw	a3,a5,0x1d
    800025b2:	00c6873b          	addw	a4,a3,a2
    800025b6:	00777793          	andi	a5,a4,7
    800025ba:	9f95                	subw	a5,a5,a3
    800025bc:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800025c0:	4037571b          	sraiw	a4,a4,0x3
    800025c4:	00e906b3          	add	a3,s2,a4
    800025c8:	0586c683          	lbu	a3,88(a3)
    800025cc:	00d7f5b3          	and	a1,a5,a3
    800025d0:	cd91                	beqz	a1,800025ec <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025d2:	2605                	addiw	a2,a2,1
    800025d4:	2485                	addiw	s1,s1,1
    800025d6:	fd4618e3          	bne	a2,s4,800025a6 <balloc+0x80>
    800025da:	b759                	j	80002560 <balloc+0x3a>
  panic("balloc: out of blocks");
    800025dc:	00006517          	auipc	a0,0x6
    800025e0:	ef450513          	addi	a0,a0,-268 # 800084d0 <syscalls+0x108>
    800025e4:	00004097          	auipc	ra,0x4
    800025e8:	864080e7          	jalr	-1948(ra) # 80005e48 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800025ec:	974a                	add	a4,a4,s2
    800025ee:	8fd5                	or	a5,a5,a3
    800025f0:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800025f4:	854a                	mv	a0,s2
    800025f6:	00001097          	auipc	ra,0x1
    800025fa:	18c080e7          	jalr	396(ra) # 80003782 <log_write>
        brelse(bp);
    800025fe:	854a                	mv	a0,s2
    80002600:	00000097          	auipc	ra,0x0
    80002604:	d94080e7          	jalr	-620(ra) # 80002394 <brelse>
  bp = bread(dev, bno);
    80002608:	85a6                	mv	a1,s1
    8000260a:	855e                	mv	a0,s7
    8000260c:	00000097          	auipc	ra,0x0
    80002610:	c58080e7          	jalr	-936(ra) # 80002264 <bread>
    80002614:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002616:	40000613          	li	a2,1024
    8000261a:	4581                	li	a1,0
    8000261c:	05850513          	addi	a0,a0,88
    80002620:	ffffe097          	auipc	ra,0xffffe
    80002624:	b58080e7          	jalr	-1192(ra) # 80000178 <memset>
  log_write(bp);
    80002628:	854a                	mv	a0,s2
    8000262a:	00001097          	auipc	ra,0x1
    8000262e:	158080e7          	jalr	344(ra) # 80003782 <log_write>
  brelse(bp);
    80002632:	854a                	mv	a0,s2
    80002634:	00000097          	auipc	ra,0x0
    80002638:	d60080e7          	jalr	-672(ra) # 80002394 <brelse>
}
    8000263c:	8526                	mv	a0,s1
    8000263e:	60e6                	ld	ra,88(sp)
    80002640:	6446                	ld	s0,80(sp)
    80002642:	64a6                	ld	s1,72(sp)
    80002644:	6906                	ld	s2,64(sp)
    80002646:	79e2                	ld	s3,56(sp)
    80002648:	7a42                	ld	s4,48(sp)
    8000264a:	7aa2                	ld	s5,40(sp)
    8000264c:	7b02                	ld	s6,32(sp)
    8000264e:	6be2                	ld	s7,24(sp)
    80002650:	6c42                	ld	s8,16(sp)
    80002652:	6ca2                	ld	s9,8(sp)
    80002654:	6125                	addi	sp,sp,96
    80002656:	8082                	ret

0000000080002658 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002658:	7139                	addi	sp,sp,-64
    8000265a:	fc06                	sd	ra,56(sp)
    8000265c:	f822                	sd	s0,48(sp)
    8000265e:	f426                	sd	s1,40(sp)
    80002660:	f04a                	sd	s2,32(sp)
    80002662:	ec4e                	sd	s3,24(sp)
    80002664:	e852                	sd	s4,16(sp)
    80002666:	e456                	sd	s5,8(sp)
    80002668:	0080                	addi	s0,sp,64
    8000266a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000266c:	47a9                	li	a5,10
    8000266e:	08b7fd63          	bgeu	a5,a1,80002708 <bmap+0xb0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002672:	ff55849b          	addiw	s1,a1,-11
    80002676:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000267a:	0ff00793          	li	a5,255
    8000267e:	0ae7f863          	bgeu	a5,a4,8000272e <bmap+0xd6>
    brelse(bp);
    return addr;
  }

  // doubly-indirect block - lab9-1
  bn -= NINDIRECT;
    80002682:	ef55849b          	addiw	s1,a1,-267
    80002686:	0004871b          	sext.w	a4,s1
  if(bn < NDOUBLYINDIRECT) {
    8000268a:	67c1                	lui	a5,0x10
    8000268c:	14f77e63          	bgeu	a4,a5,800027e8 <bmap+0x190>
    // get the address of doubly-indirect block
    if((addr = ip->addrs[NDIRECT + 1]) == 0) {
    80002690:	08052583          	lw	a1,128(a0)
    80002694:	10058063          	beqz	a1,80002794 <bmap+0x13c>
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    }
    bp = bread(ip->dev, addr);
    80002698:	0009a503          	lw	a0,0(s3)
    8000269c:	00000097          	auipc	ra,0x0
    800026a0:	bc8080e7          	jalr	-1080(ra) # 80002264 <bread>
    800026a4:	892a                	mv	s2,a0
    a = (uint*)bp->data;
    800026a6:	05850a13          	addi	s4,a0,88
    // get the address of singly-indirect block
    if((addr = a[bn / NINDIRECT]) == 0) {
    800026aa:	0084d79b          	srliw	a5,s1,0x8
    800026ae:	078a                	slli	a5,a5,0x2
    800026b0:	9a3e                	add	s4,s4,a5
    800026b2:	000a2a83          	lw	s5,0(s4) # 2000 <_entry-0x7fffe000>
    800026b6:	0e0a8963          	beqz	s5,800027a8 <bmap+0x150>
      a[bn / NINDIRECT] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026ba:	854a                	mv	a0,s2
    800026bc:	00000097          	auipc	ra,0x0
    800026c0:	cd8080e7          	jalr	-808(ra) # 80002394 <brelse>
    bp = bread(ip->dev, addr);
    800026c4:	85d6                	mv	a1,s5
    800026c6:	0009a503          	lw	a0,0(s3)
    800026ca:	00000097          	auipc	ra,0x0
    800026ce:	b9a080e7          	jalr	-1126(ra) # 80002264 <bread>
    800026d2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800026d4:	05850793          	addi	a5,a0,88
    bn %= NINDIRECT;
    // get the address of direct block
    if((addr = a[bn]) == 0) {
    800026d8:	0ff4f593          	andi	a1,s1,255
    800026dc:	058a                	slli	a1,a1,0x2
    800026de:	00b784b3          	add	s1,a5,a1
    800026e2:	0004a903          	lw	s2,0(s1)
    800026e6:	0e090163          	beqz	s2,800027c8 <bmap+0x170>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800026ea:	8552                	mv	a0,s4
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	ca8080e7          	jalr	-856(ra) # 80002394 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800026f4:	854a                	mv	a0,s2
    800026f6:	70e2                	ld	ra,56(sp)
    800026f8:	7442                	ld	s0,48(sp)
    800026fa:	74a2                	ld	s1,40(sp)
    800026fc:	7902                	ld	s2,32(sp)
    800026fe:	69e2                	ld	s3,24(sp)
    80002700:	6a42                	ld	s4,16(sp)
    80002702:	6aa2                	ld	s5,8(sp)
    80002704:	6121                	addi	sp,sp,64
    80002706:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002708:	02059493          	slli	s1,a1,0x20
    8000270c:	9081                	srli	s1,s1,0x20
    8000270e:	048a                	slli	s1,s1,0x2
    80002710:	94aa                	add	s1,s1,a0
    80002712:	0504a903          	lw	s2,80(s1)
    80002716:	fc091fe3          	bnez	s2,800026f4 <bmap+0x9c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000271a:	4108                	lw	a0,0(a0)
    8000271c:	00000097          	auipc	ra,0x0
    80002720:	e0a080e7          	jalr	-502(ra) # 80002526 <balloc>
    80002724:	0005091b          	sext.w	s2,a0
    80002728:	0524a823          	sw	s2,80(s1)
    8000272c:	b7e1                	j	800026f4 <bmap+0x9c>
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000272e:	5d6c                	lw	a1,124(a0)
    80002730:	c985                	beqz	a1,80002760 <bmap+0x108>
    bp = bread(ip->dev, addr);
    80002732:	0009a503          	lw	a0,0(s3)
    80002736:	00000097          	auipc	ra,0x0
    8000273a:	b2e080e7          	jalr	-1234(ra) # 80002264 <bread>
    8000273e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002740:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002744:	1482                	slli	s1,s1,0x20
    80002746:	9081                	srli	s1,s1,0x20
    80002748:	048a                	slli	s1,s1,0x2
    8000274a:	94be                	add	s1,s1,a5
    8000274c:	0004a903          	lw	s2,0(s1)
    80002750:	02090263          	beqz	s2,80002774 <bmap+0x11c>
    brelse(bp);
    80002754:	8552                	mv	a0,s4
    80002756:	00000097          	auipc	ra,0x0
    8000275a:	c3e080e7          	jalr	-962(ra) # 80002394 <brelse>
    return addr;
    8000275e:	bf59                	j	800026f4 <bmap+0x9c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002760:	4108                	lw	a0,0(a0)
    80002762:	00000097          	auipc	ra,0x0
    80002766:	dc4080e7          	jalr	-572(ra) # 80002526 <balloc>
    8000276a:	0005059b          	sext.w	a1,a0
    8000276e:	06b9ae23          	sw	a1,124(s3)
    80002772:	b7c1                	j	80002732 <bmap+0xda>
      a[bn] = addr = balloc(ip->dev);
    80002774:	0009a503          	lw	a0,0(s3)
    80002778:	00000097          	auipc	ra,0x0
    8000277c:	dae080e7          	jalr	-594(ra) # 80002526 <balloc>
    80002780:	0005091b          	sext.w	s2,a0
    80002784:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    80002788:	8552                	mv	a0,s4
    8000278a:	00001097          	auipc	ra,0x1
    8000278e:	ff8080e7          	jalr	-8(ra) # 80003782 <log_write>
    80002792:	b7c9                	j	80002754 <bmap+0xfc>
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
    80002794:	4108                	lw	a0,0(a0)
    80002796:	00000097          	auipc	ra,0x0
    8000279a:	d90080e7          	jalr	-624(ra) # 80002526 <balloc>
    8000279e:	0005059b          	sext.w	a1,a0
    800027a2:	08b9a023          	sw	a1,128(s3)
    800027a6:	bdcd                	j	80002698 <bmap+0x40>
      a[bn / NINDIRECT] = addr = balloc(ip->dev);
    800027a8:	0009a503          	lw	a0,0(s3)
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	d7a080e7          	jalr	-646(ra) # 80002526 <balloc>
    800027b4:	00050a9b          	sext.w	s5,a0
    800027b8:	015a2023          	sw	s5,0(s4)
      log_write(bp);
    800027bc:	854a                	mv	a0,s2
    800027be:	00001097          	auipc	ra,0x1
    800027c2:	fc4080e7          	jalr	-60(ra) # 80003782 <log_write>
    800027c6:	bdd5                	j	800026ba <bmap+0x62>
      a[bn] = addr = balloc(ip->dev);
    800027c8:	0009a503          	lw	a0,0(s3)
    800027cc:	00000097          	auipc	ra,0x0
    800027d0:	d5a080e7          	jalr	-678(ra) # 80002526 <balloc>
    800027d4:	0005091b          	sext.w	s2,a0
    800027d8:	0124a023          	sw	s2,0(s1)
      log_write(bp);
    800027dc:	8552                	mv	a0,s4
    800027de:	00001097          	auipc	ra,0x1
    800027e2:	fa4080e7          	jalr	-92(ra) # 80003782 <log_write>
    800027e6:	b711                	j	800026ea <bmap+0x92>
  panic("bmap: out of range");
    800027e8:	00006517          	auipc	a0,0x6
    800027ec:	d0050513          	addi	a0,a0,-768 # 800084e8 <syscalls+0x120>
    800027f0:	00003097          	auipc	ra,0x3
    800027f4:	658080e7          	jalr	1624(ra) # 80005e48 <panic>

00000000800027f8 <iget>:
{
    800027f8:	7179                	addi	sp,sp,-48
    800027fa:	f406                	sd	ra,40(sp)
    800027fc:	f022                	sd	s0,32(sp)
    800027fe:	ec26                	sd	s1,24(sp)
    80002800:	e84a                	sd	s2,16(sp)
    80002802:	e44e                	sd	s3,8(sp)
    80002804:	e052                	sd	s4,0(sp)
    80002806:	1800                	addi	s0,sp,48
    80002808:	89aa                	mv	s3,a0
    8000280a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000280c:	00010517          	auipc	a0,0x10
    80002810:	17c50513          	addi	a0,a0,380 # 80012988 <itable>
    80002814:	00004097          	auipc	ra,0x4
    80002818:	b7e080e7          	jalr	-1154(ra) # 80006392 <acquire>
  empty = 0;
    8000281c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000281e:	00010497          	auipc	s1,0x10
    80002822:	18248493          	addi	s1,s1,386 # 800129a0 <itable+0x18>
    80002826:	00012697          	auipc	a3,0x12
    8000282a:	c0a68693          	addi	a3,a3,-1014 # 80014430 <log>
    8000282e:	a039                	j	8000283c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002830:	02090b63          	beqz	s2,80002866 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002834:	08848493          	addi	s1,s1,136
    80002838:	02d48a63          	beq	s1,a3,8000286c <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000283c:	449c                	lw	a5,8(s1)
    8000283e:	fef059e3          	blez	a5,80002830 <iget+0x38>
    80002842:	4098                	lw	a4,0(s1)
    80002844:	ff3716e3          	bne	a4,s3,80002830 <iget+0x38>
    80002848:	40d8                	lw	a4,4(s1)
    8000284a:	ff4713e3          	bne	a4,s4,80002830 <iget+0x38>
      ip->ref++;
    8000284e:	2785                	addiw	a5,a5,1
    80002850:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002852:	00010517          	auipc	a0,0x10
    80002856:	13650513          	addi	a0,a0,310 # 80012988 <itable>
    8000285a:	00004097          	auipc	ra,0x4
    8000285e:	bec080e7          	jalr	-1044(ra) # 80006446 <release>
      return ip;
    80002862:	8926                	mv	s2,s1
    80002864:	a03d                	j	80002892 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002866:	f7f9                	bnez	a5,80002834 <iget+0x3c>
    80002868:	8926                	mv	s2,s1
    8000286a:	b7e9                	j	80002834 <iget+0x3c>
  if(empty == 0)
    8000286c:	02090c63          	beqz	s2,800028a4 <iget+0xac>
  ip->dev = dev;
    80002870:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002874:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002878:	4785                	li	a5,1
    8000287a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000287e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002882:	00010517          	auipc	a0,0x10
    80002886:	10650513          	addi	a0,a0,262 # 80012988 <itable>
    8000288a:	00004097          	auipc	ra,0x4
    8000288e:	bbc080e7          	jalr	-1092(ra) # 80006446 <release>
}
    80002892:	854a                	mv	a0,s2
    80002894:	70a2                	ld	ra,40(sp)
    80002896:	7402                	ld	s0,32(sp)
    80002898:	64e2                	ld	s1,24(sp)
    8000289a:	6942                	ld	s2,16(sp)
    8000289c:	69a2                	ld	s3,8(sp)
    8000289e:	6a02                	ld	s4,0(sp)
    800028a0:	6145                	addi	sp,sp,48
    800028a2:	8082                	ret
    panic("iget: no inodes");
    800028a4:	00006517          	auipc	a0,0x6
    800028a8:	c5c50513          	addi	a0,a0,-932 # 80008500 <syscalls+0x138>
    800028ac:	00003097          	auipc	ra,0x3
    800028b0:	59c080e7          	jalr	1436(ra) # 80005e48 <panic>

00000000800028b4 <fsinit>:
fsinit(int dev) {
    800028b4:	7179                	addi	sp,sp,-48
    800028b6:	f406                	sd	ra,40(sp)
    800028b8:	f022                	sd	s0,32(sp)
    800028ba:	ec26                	sd	s1,24(sp)
    800028bc:	e84a                	sd	s2,16(sp)
    800028be:	e44e                	sd	s3,8(sp)
    800028c0:	1800                	addi	s0,sp,48
    800028c2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028c4:	4585                	li	a1,1
    800028c6:	00000097          	auipc	ra,0x0
    800028ca:	99e080e7          	jalr	-1634(ra) # 80002264 <bread>
    800028ce:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028d0:	00010997          	auipc	s3,0x10
    800028d4:	09898993          	addi	s3,s3,152 # 80012968 <sb>
    800028d8:	02000613          	li	a2,32
    800028dc:	05850593          	addi	a1,a0,88
    800028e0:	854e                	mv	a0,s3
    800028e2:	ffffe097          	auipc	ra,0xffffe
    800028e6:	8f6080e7          	jalr	-1802(ra) # 800001d8 <memmove>
  brelse(bp);
    800028ea:	8526                	mv	a0,s1
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	aa8080e7          	jalr	-1368(ra) # 80002394 <brelse>
  if(sb.magic != FSMAGIC)
    800028f4:	0009a703          	lw	a4,0(s3)
    800028f8:	102037b7          	lui	a5,0x10203
    800028fc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002900:	02f71263          	bne	a4,a5,80002924 <fsinit+0x70>
  initlog(dev, &sb);
    80002904:	00010597          	auipc	a1,0x10
    80002908:	06458593          	addi	a1,a1,100 # 80012968 <sb>
    8000290c:	854a                	mv	a0,s2
    8000290e:	00001097          	auipc	ra,0x1
    80002912:	bf8080e7          	jalr	-1032(ra) # 80003506 <initlog>
}
    80002916:	70a2                	ld	ra,40(sp)
    80002918:	7402                	ld	s0,32(sp)
    8000291a:	64e2                	ld	s1,24(sp)
    8000291c:	6942                	ld	s2,16(sp)
    8000291e:	69a2                	ld	s3,8(sp)
    80002920:	6145                	addi	sp,sp,48
    80002922:	8082                	ret
    panic("invalid file system");
    80002924:	00006517          	auipc	a0,0x6
    80002928:	bec50513          	addi	a0,a0,-1044 # 80008510 <syscalls+0x148>
    8000292c:	00003097          	auipc	ra,0x3
    80002930:	51c080e7          	jalr	1308(ra) # 80005e48 <panic>

0000000080002934 <iinit>:
{
    80002934:	7179                	addi	sp,sp,-48
    80002936:	f406                	sd	ra,40(sp)
    80002938:	f022                	sd	s0,32(sp)
    8000293a:	ec26                	sd	s1,24(sp)
    8000293c:	e84a                	sd	s2,16(sp)
    8000293e:	e44e                	sd	s3,8(sp)
    80002940:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002942:	00006597          	auipc	a1,0x6
    80002946:	be658593          	addi	a1,a1,-1050 # 80008528 <syscalls+0x160>
    8000294a:	00010517          	auipc	a0,0x10
    8000294e:	03e50513          	addi	a0,a0,62 # 80012988 <itable>
    80002952:	00004097          	auipc	ra,0x4
    80002956:	9b0080e7          	jalr	-1616(ra) # 80006302 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000295a:	00010497          	auipc	s1,0x10
    8000295e:	05648493          	addi	s1,s1,86 # 800129b0 <itable+0x28>
    80002962:	00012997          	auipc	s3,0x12
    80002966:	ade98993          	addi	s3,s3,-1314 # 80014440 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000296a:	00006917          	auipc	s2,0x6
    8000296e:	bc690913          	addi	s2,s2,-1082 # 80008530 <syscalls+0x168>
    80002972:	85ca                	mv	a1,s2
    80002974:	8526                	mv	a0,s1
    80002976:	00001097          	auipc	ra,0x1
    8000297a:	ef2080e7          	jalr	-270(ra) # 80003868 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000297e:	08848493          	addi	s1,s1,136
    80002982:	ff3498e3          	bne	s1,s3,80002972 <iinit+0x3e>
}
    80002986:	70a2                	ld	ra,40(sp)
    80002988:	7402                	ld	s0,32(sp)
    8000298a:	64e2                	ld	s1,24(sp)
    8000298c:	6942                	ld	s2,16(sp)
    8000298e:	69a2                	ld	s3,8(sp)
    80002990:	6145                	addi	sp,sp,48
    80002992:	8082                	ret

0000000080002994 <ialloc>:
{
    80002994:	715d                	addi	sp,sp,-80
    80002996:	e486                	sd	ra,72(sp)
    80002998:	e0a2                	sd	s0,64(sp)
    8000299a:	fc26                	sd	s1,56(sp)
    8000299c:	f84a                	sd	s2,48(sp)
    8000299e:	f44e                	sd	s3,40(sp)
    800029a0:	f052                	sd	s4,32(sp)
    800029a2:	ec56                	sd	s5,24(sp)
    800029a4:	e85a                	sd	s6,16(sp)
    800029a6:	e45e                	sd	s7,8(sp)
    800029a8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800029aa:	00010717          	auipc	a4,0x10
    800029ae:	fca72703          	lw	a4,-54(a4) # 80012974 <sb+0xc>
    800029b2:	4785                	li	a5,1
    800029b4:	04e7fa63          	bgeu	a5,a4,80002a08 <ialloc+0x74>
    800029b8:	8aaa                	mv	s5,a0
    800029ba:	8bae                	mv	s7,a1
    800029bc:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029be:	00010a17          	auipc	s4,0x10
    800029c2:	faaa0a13          	addi	s4,s4,-86 # 80012968 <sb>
    800029c6:	00048b1b          	sext.w	s6,s1
    800029ca:	0044d593          	srli	a1,s1,0x4
    800029ce:	018a2783          	lw	a5,24(s4)
    800029d2:	9dbd                	addw	a1,a1,a5
    800029d4:	8556                	mv	a0,s5
    800029d6:	00000097          	auipc	ra,0x0
    800029da:	88e080e7          	jalr	-1906(ra) # 80002264 <bread>
    800029de:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029e0:	05850993          	addi	s3,a0,88
    800029e4:	00f4f793          	andi	a5,s1,15
    800029e8:	079a                	slli	a5,a5,0x6
    800029ea:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029ec:	00099783          	lh	a5,0(s3)
    800029f0:	c785                	beqz	a5,80002a18 <ialloc+0x84>
    brelse(bp);
    800029f2:	00000097          	auipc	ra,0x0
    800029f6:	9a2080e7          	jalr	-1630(ra) # 80002394 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029fa:	0485                	addi	s1,s1,1
    800029fc:	00ca2703          	lw	a4,12(s4)
    80002a00:	0004879b          	sext.w	a5,s1
    80002a04:	fce7e1e3          	bltu	a5,a4,800029c6 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a08:	00006517          	auipc	a0,0x6
    80002a0c:	b3050513          	addi	a0,a0,-1232 # 80008538 <syscalls+0x170>
    80002a10:	00003097          	auipc	ra,0x3
    80002a14:	438080e7          	jalr	1080(ra) # 80005e48 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a18:	04000613          	li	a2,64
    80002a1c:	4581                	li	a1,0
    80002a1e:	854e                	mv	a0,s3
    80002a20:	ffffd097          	auipc	ra,0xffffd
    80002a24:	758080e7          	jalr	1880(ra) # 80000178 <memset>
      dip->type = type;
    80002a28:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a2c:	854a                	mv	a0,s2
    80002a2e:	00001097          	auipc	ra,0x1
    80002a32:	d54080e7          	jalr	-684(ra) # 80003782 <log_write>
      brelse(bp);
    80002a36:	854a                	mv	a0,s2
    80002a38:	00000097          	auipc	ra,0x0
    80002a3c:	95c080e7          	jalr	-1700(ra) # 80002394 <brelse>
      return iget(dev, inum);
    80002a40:	85da                	mv	a1,s6
    80002a42:	8556                	mv	a0,s5
    80002a44:	00000097          	auipc	ra,0x0
    80002a48:	db4080e7          	jalr	-588(ra) # 800027f8 <iget>
}
    80002a4c:	60a6                	ld	ra,72(sp)
    80002a4e:	6406                	ld	s0,64(sp)
    80002a50:	74e2                	ld	s1,56(sp)
    80002a52:	7942                	ld	s2,48(sp)
    80002a54:	79a2                	ld	s3,40(sp)
    80002a56:	7a02                	ld	s4,32(sp)
    80002a58:	6ae2                	ld	s5,24(sp)
    80002a5a:	6b42                	ld	s6,16(sp)
    80002a5c:	6ba2                	ld	s7,8(sp)
    80002a5e:	6161                	addi	sp,sp,80
    80002a60:	8082                	ret

0000000080002a62 <iupdate>:
{
    80002a62:	1101                	addi	sp,sp,-32
    80002a64:	ec06                	sd	ra,24(sp)
    80002a66:	e822                	sd	s0,16(sp)
    80002a68:	e426                	sd	s1,8(sp)
    80002a6a:	e04a                	sd	s2,0(sp)
    80002a6c:	1000                	addi	s0,sp,32
    80002a6e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a70:	415c                	lw	a5,4(a0)
    80002a72:	0047d79b          	srliw	a5,a5,0x4
    80002a76:	00010597          	auipc	a1,0x10
    80002a7a:	f0a5a583          	lw	a1,-246(a1) # 80012980 <sb+0x18>
    80002a7e:	9dbd                	addw	a1,a1,a5
    80002a80:	4108                	lw	a0,0(a0)
    80002a82:	fffff097          	auipc	ra,0xfffff
    80002a86:	7e2080e7          	jalr	2018(ra) # 80002264 <bread>
    80002a8a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a8c:	05850793          	addi	a5,a0,88
    80002a90:	40c8                	lw	a0,4(s1)
    80002a92:	893d                	andi	a0,a0,15
    80002a94:	051a                	slli	a0,a0,0x6
    80002a96:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002a98:	04449703          	lh	a4,68(s1)
    80002a9c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002aa0:	04649703          	lh	a4,70(s1)
    80002aa4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002aa8:	04849703          	lh	a4,72(s1)
    80002aac:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002ab0:	04a49703          	lh	a4,74(s1)
    80002ab4:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ab8:	44f8                	lw	a4,76(s1)
    80002aba:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002abc:	03400613          	li	a2,52
    80002ac0:	05048593          	addi	a1,s1,80
    80002ac4:	0531                	addi	a0,a0,12
    80002ac6:	ffffd097          	auipc	ra,0xffffd
    80002aca:	712080e7          	jalr	1810(ra) # 800001d8 <memmove>
  log_write(bp);
    80002ace:	854a                	mv	a0,s2
    80002ad0:	00001097          	auipc	ra,0x1
    80002ad4:	cb2080e7          	jalr	-846(ra) # 80003782 <log_write>
  brelse(bp);
    80002ad8:	854a                	mv	a0,s2
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	8ba080e7          	jalr	-1862(ra) # 80002394 <brelse>
}
    80002ae2:	60e2                	ld	ra,24(sp)
    80002ae4:	6442                	ld	s0,16(sp)
    80002ae6:	64a2                	ld	s1,8(sp)
    80002ae8:	6902                	ld	s2,0(sp)
    80002aea:	6105                	addi	sp,sp,32
    80002aec:	8082                	ret

0000000080002aee <idup>:
{
    80002aee:	1101                	addi	sp,sp,-32
    80002af0:	ec06                	sd	ra,24(sp)
    80002af2:	e822                	sd	s0,16(sp)
    80002af4:	e426                	sd	s1,8(sp)
    80002af6:	1000                	addi	s0,sp,32
    80002af8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002afa:	00010517          	auipc	a0,0x10
    80002afe:	e8e50513          	addi	a0,a0,-370 # 80012988 <itable>
    80002b02:	00004097          	auipc	ra,0x4
    80002b06:	890080e7          	jalr	-1904(ra) # 80006392 <acquire>
  ip->ref++;
    80002b0a:	449c                	lw	a5,8(s1)
    80002b0c:	2785                	addiw	a5,a5,1
    80002b0e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b10:	00010517          	auipc	a0,0x10
    80002b14:	e7850513          	addi	a0,a0,-392 # 80012988 <itable>
    80002b18:	00004097          	auipc	ra,0x4
    80002b1c:	92e080e7          	jalr	-1746(ra) # 80006446 <release>
}
    80002b20:	8526                	mv	a0,s1
    80002b22:	60e2                	ld	ra,24(sp)
    80002b24:	6442                	ld	s0,16(sp)
    80002b26:	64a2                	ld	s1,8(sp)
    80002b28:	6105                	addi	sp,sp,32
    80002b2a:	8082                	ret

0000000080002b2c <ilock>:
{
    80002b2c:	1101                	addi	sp,sp,-32
    80002b2e:	ec06                	sd	ra,24(sp)
    80002b30:	e822                	sd	s0,16(sp)
    80002b32:	e426                	sd	s1,8(sp)
    80002b34:	e04a                	sd	s2,0(sp)
    80002b36:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b38:	c115                	beqz	a0,80002b5c <ilock+0x30>
    80002b3a:	84aa                	mv	s1,a0
    80002b3c:	451c                	lw	a5,8(a0)
    80002b3e:	00f05f63          	blez	a5,80002b5c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002b42:	0541                	addi	a0,a0,16
    80002b44:	00001097          	auipc	ra,0x1
    80002b48:	d5e080e7          	jalr	-674(ra) # 800038a2 <acquiresleep>
  if(ip->valid == 0){
    80002b4c:	40bc                	lw	a5,64(s1)
    80002b4e:	cf99                	beqz	a5,80002b6c <ilock+0x40>
}
    80002b50:	60e2                	ld	ra,24(sp)
    80002b52:	6442                	ld	s0,16(sp)
    80002b54:	64a2                	ld	s1,8(sp)
    80002b56:	6902                	ld	s2,0(sp)
    80002b58:	6105                	addi	sp,sp,32
    80002b5a:	8082                	ret
    panic("ilock");
    80002b5c:	00006517          	auipc	a0,0x6
    80002b60:	9f450513          	addi	a0,a0,-1548 # 80008550 <syscalls+0x188>
    80002b64:	00003097          	auipc	ra,0x3
    80002b68:	2e4080e7          	jalr	740(ra) # 80005e48 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b6c:	40dc                	lw	a5,4(s1)
    80002b6e:	0047d79b          	srliw	a5,a5,0x4
    80002b72:	00010597          	auipc	a1,0x10
    80002b76:	e0e5a583          	lw	a1,-498(a1) # 80012980 <sb+0x18>
    80002b7a:	9dbd                	addw	a1,a1,a5
    80002b7c:	4088                	lw	a0,0(s1)
    80002b7e:	fffff097          	auipc	ra,0xfffff
    80002b82:	6e6080e7          	jalr	1766(ra) # 80002264 <bread>
    80002b86:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b88:	05850593          	addi	a1,a0,88
    80002b8c:	40dc                	lw	a5,4(s1)
    80002b8e:	8bbd                	andi	a5,a5,15
    80002b90:	079a                	slli	a5,a5,0x6
    80002b92:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b94:	00059783          	lh	a5,0(a1)
    80002b98:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b9c:	00259783          	lh	a5,2(a1)
    80002ba0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ba4:	00459783          	lh	a5,4(a1)
    80002ba8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bac:	00659783          	lh	a5,6(a1)
    80002bb0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bb4:	459c                	lw	a5,8(a1)
    80002bb6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bb8:	03400613          	li	a2,52
    80002bbc:	05b1                	addi	a1,a1,12
    80002bbe:	05048513          	addi	a0,s1,80
    80002bc2:	ffffd097          	auipc	ra,0xffffd
    80002bc6:	616080e7          	jalr	1558(ra) # 800001d8 <memmove>
    brelse(bp);
    80002bca:	854a                	mv	a0,s2
    80002bcc:	fffff097          	auipc	ra,0xfffff
    80002bd0:	7c8080e7          	jalr	1992(ra) # 80002394 <brelse>
    ip->valid = 1;
    80002bd4:	4785                	li	a5,1
    80002bd6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bd8:	04449783          	lh	a5,68(s1)
    80002bdc:	fbb5                	bnez	a5,80002b50 <ilock+0x24>
      panic("ilock: no type");
    80002bde:	00006517          	auipc	a0,0x6
    80002be2:	97a50513          	addi	a0,a0,-1670 # 80008558 <syscalls+0x190>
    80002be6:	00003097          	auipc	ra,0x3
    80002bea:	262080e7          	jalr	610(ra) # 80005e48 <panic>

0000000080002bee <iunlock>:
{
    80002bee:	1101                	addi	sp,sp,-32
    80002bf0:	ec06                	sd	ra,24(sp)
    80002bf2:	e822                	sd	s0,16(sp)
    80002bf4:	e426                	sd	s1,8(sp)
    80002bf6:	e04a                	sd	s2,0(sp)
    80002bf8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002bfa:	c905                	beqz	a0,80002c2a <iunlock+0x3c>
    80002bfc:	84aa                	mv	s1,a0
    80002bfe:	01050913          	addi	s2,a0,16
    80002c02:	854a                	mv	a0,s2
    80002c04:	00001097          	auipc	ra,0x1
    80002c08:	d38080e7          	jalr	-712(ra) # 8000393c <holdingsleep>
    80002c0c:	cd19                	beqz	a0,80002c2a <iunlock+0x3c>
    80002c0e:	449c                	lw	a5,8(s1)
    80002c10:	00f05d63          	blez	a5,80002c2a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c14:	854a                	mv	a0,s2
    80002c16:	00001097          	auipc	ra,0x1
    80002c1a:	ce2080e7          	jalr	-798(ra) # 800038f8 <releasesleep>
}
    80002c1e:	60e2                	ld	ra,24(sp)
    80002c20:	6442                	ld	s0,16(sp)
    80002c22:	64a2                	ld	s1,8(sp)
    80002c24:	6902                	ld	s2,0(sp)
    80002c26:	6105                	addi	sp,sp,32
    80002c28:	8082                	ret
    panic("iunlock");
    80002c2a:	00006517          	auipc	a0,0x6
    80002c2e:	93e50513          	addi	a0,a0,-1730 # 80008568 <syscalls+0x1a0>
    80002c32:	00003097          	auipc	ra,0x3
    80002c36:	216080e7          	jalr	534(ra) # 80005e48 <panic>

0000000080002c3a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c3a:	715d                	addi	sp,sp,-80
    80002c3c:	e486                	sd	ra,72(sp)
    80002c3e:	e0a2                	sd	s0,64(sp)
    80002c40:	fc26                	sd	s1,56(sp)
    80002c42:	f84a                	sd	s2,48(sp)
    80002c44:	f44e                	sd	s3,40(sp)
    80002c46:	f052                	sd	s4,32(sp)
    80002c48:	ec56                	sd	s5,24(sp)
    80002c4a:	e85a                	sd	s6,16(sp)
    80002c4c:	e45e                	sd	s7,8(sp)
    80002c4e:	e062                	sd	s8,0(sp)
    80002c50:	0880                	addi	s0,sp,80
    80002c52:	89aa                	mv	s3,a0
  int i, j, k;  // lab9-1
  struct buf *bp, *bp2;     // lab9-1
  uint *a, *a2; // lab9-1

  for(i = 0; i < NDIRECT; i++){
    80002c54:	05050493          	addi	s1,a0,80
    80002c58:	07c50913          	addi	s2,a0,124
    80002c5c:	a021                	j	80002c64 <itrunc+0x2a>
    80002c5e:	0491                	addi	s1,s1,4
    80002c60:	01248d63          	beq	s1,s2,80002c7a <itrunc+0x40>
    if(ip->addrs[i]){
    80002c64:	408c                	lw	a1,0(s1)
    80002c66:	dde5                	beqz	a1,80002c5e <itrunc+0x24>
      bfree(ip->dev, ip->addrs[i]);
    80002c68:	0009a503          	lw	a0,0(s3)
    80002c6c:	00000097          	auipc	ra,0x0
    80002c70:	83e080e7          	jalr	-1986(ra) # 800024aa <bfree>
      ip->addrs[i] = 0;
    80002c74:	0004a023          	sw	zero,0(s1)
    80002c78:	b7dd                	j	80002c5e <itrunc+0x24>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c7a:	07c9a583          	lw	a1,124(s3)
    80002c7e:	e59d                	bnez	a1,80002cac <itrunc+0x72>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  // free the doubly-indirect block - lab9-1
  if(ip->addrs[NDIRECT + 1]) {
    80002c80:	0809a583          	lw	a1,128(s3)
    80002c84:	eda5                	bnez	a1,80002cfc <itrunc+0xc2>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    ip->addrs[NDIRECT + 1] = 0;
  }

  ip->size = 0;
    80002c86:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c8a:	854e                	mv	a0,s3
    80002c8c:	00000097          	auipc	ra,0x0
    80002c90:	dd6080e7          	jalr	-554(ra) # 80002a62 <iupdate>
}
    80002c94:	60a6                	ld	ra,72(sp)
    80002c96:	6406                	ld	s0,64(sp)
    80002c98:	74e2                	ld	s1,56(sp)
    80002c9a:	7942                	ld	s2,48(sp)
    80002c9c:	79a2                	ld	s3,40(sp)
    80002c9e:	7a02                	ld	s4,32(sp)
    80002ca0:	6ae2                	ld	s5,24(sp)
    80002ca2:	6b42                	ld	s6,16(sp)
    80002ca4:	6ba2                	ld	s7,8(sp)
    80002ca6:	6c02                	ld	s8,0(sp)
    80002ca8:	6161                	addi	sp,sp,80
    80002caa:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cac:	0009a503          	lw	a0,0(s3)
    80002cb0:	fffff097          	auipc	ra,0xfffff
    80002cb4:	5b4080e7          	jalr	1460(ra) # 80002264 <bread>
    80002cb8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cba:	05850493          	addi	s1,a0,88
    80002cbe:	45850913          	addi	s2,a0,1112
    80002cc2:	a021                	j	80002cca <itrunc+0x90>
    80002cc4:	0491                	addi	s1,s1,4
    80002cc6:	01248b63          	beq	s1,s2,80002cdc <itrunc+0xa2>
      if(a[j])
    80002cca:	408c                	lw	a1,0(s1)
    80002ccc:	dde5                	beqz	a1,80002cc4 <itrunc+0x8a>
        bfree(ip->dev, a[j]);
    80002cce:	0009a503          	lw	a0,0(s3)
    80002cd2:	fffff097          	auipc	ra,0xfffff
    80002cd6:	7d8080e7          	jalr	2008(ra) # 800024aa <bfree>
    80002cda:	b7ed                	j	80002cc4 <itrunc+0x8a>
    brelse(bp);
    80002cdc:	8552                	mv	a0,s4
    80002cde:	fffff097          	auipc	ra,0xfffff
    80002ce2:	6b6080e7          	jalr	1718(ra) # 80002394 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ce6:	07c9a583          	lw	a1,124(s3)
    80002cea:	0009a503          	lw	a0,0(s3)
    80002cee:	fffff097          	auipc	ra,0xfffff
    80002cf2:	7bc080e7          	jalr	1980(ra) # 800024aa <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cf6:	0609ae23          	sw	zero,124(s3)
    80002cfa:	b759                	j	80002c80 <itrunc+0x46>
    bp = bread(ip->dev, ip->addrs[NDIRECT + 1]);
    80002cfc:	0009a503          	lw	a0,0(s3)
    80002d00:	fffff097          	auipc	ra,0xfffff
    80002d04:	564080e7          	jalr	1380(ra) # 80002264 <bread>
    80002d08:	8c2a                	mv	s8,a0
    for(j = 0; j < NINDIRECT; ++j) {
    80002d0a:	05850a13          	addi	s4,a0,88
    80002d0e:	45850b13          	addi	s6,a0,1112
    80002d12:	a83d                	j	80002d50 <itrunc+0x116>
            bfree(ip->dev, a2[k]);
    80002d14:	0009a503          	lw	a0,0(s3)
    80002d18:	fffff097          	auipc	ra,0xfffff
    80002d1c:	792080e7          	jalr	1938(ra) # 800024aa <bfree>
        for(k = 0; k < NINDIRECT; ++k) {
    80002d20:	0491                	addi	s1,s1,4
    80002d22:	00990563          	beq	s2,s1,80002d2c <itrunc+0xf2>
          if(a2[k]) {
    80002d26:	408c                	lw	a1,0(s1)
    80002d28:	dde5                	beqz	a1,80002d20 <itrunc+0xe6>
    80002d2a:	b7ed                	j	80002d14 <itrunc+0xda>
        brelse(bp2);
    80002d2c:	855e                	mv	a0,s7
    80002d2e:	fffff097          	auipc	ra,0xfffff
    80002d32:	666080e7          	jalr	1638(ra) # 80002394 <brelse>
        bfree(ip->dev, a[j]);
    80002d36:	000aa583          	lw	a1,0(s5)
    80002d3a:	0009a503          	lw	a0,0(s3)
    80002d3e:	fffff097          	auipc	ra,0xfffff
    80002d42:	76c080e7          	jalr	1900(ra) # 800024aa <bfree>
        a[j] = 0;
    80002d46:	000aa023          	sw	zero,0(s5)
    for(j = 0; j < NINDIRECT; ++j) {
    80002d4a:	0a11                	addi	s4,s4,4
    80002d4c:	036a0263          	beq	s4,s6,80002d70 <itrunc+0x136>
      if(a[j]) {
    80002d50:	8ad2                	mv	s5,s4
    80002d52:	000a2583          	lw	a1,0(s4)
    80002d56:	d9f5                	beqz	a1,80002d4a <itrunc+0x110>
        bp2 = bread(ip->dev, a[j]);
    80002d58:	0009a503          	lw	a0,0(s3)
    80002d5c:	fffff097          	auipc	ra,0xfffff
    80002d60:	508080e7          	jalr	1288(ra) # 80002264 <bread>
    80002d64:	8baa                	mv	s7,a0
        for(k = 0; k < NINDIRECT; ++k) {
    80002d66:	05850493          	addi	s1,a0,88
    80002d6a:	45850913          	addi	s2,a0,1112
    80002d6e:	bf65                	j	80002d26 <itrunc+0xec>
    brelse(bp);
    80002d70:	8562                	mv	a0,s8
    80002d72:	fffff097          	auipc	ra,0xfffff
    80002d76:	622080e7          	jalr	1570(ra) # 80002394 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT + 1]);
    80002d7a:	0809a583          	lw	a1,128(s3)
    80002d7e:	0009a503          	lw	a0,0(s3)
    80002d82:	fffff097          	auipc	ra,0xfffff
    80002d86:	728080e7          	jalr	1832(ra) # 800024aa <bfree>
    ip->addrs[NDIRECT + 1] = 0;
    80002d8a:	0809a023          	sw	zero,128(s3)
    80002d8e:	bde5                	j	80002c86 <itrunc+0x4c>

0000000080002d90 <iput>:
{
    80002d90:	1101                	addi	sp,sp,-32
    80002d92:	ec06                	sd	ra,24(sp)
    80002d94:	e822                	sd	s0,16(sp)
    80002d96:	e426                	sd	s1,8(sp)
    80002d98:	e04a                	sd	s2,0(sp)
    80002d9a:	1000                	addi	s0,sp,32
    80002d9c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d9e:	00010517          	auipc	a0,0x10
    80002da2:	bea50513          	addi	a0,a0,-1046 # 80012988 <itable>
    80002da6:	00003097          	auipc	ra,0x3
    80002daa:	5ec080e7          	jalr	1516(ra) # 80006392 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dae:	4498                	lw	a4,8(s1)
    80002db0:	4785                	li	a5,1
    80002db2:	02f70363          	beq	a4,a5,80002dd8 <iput+0x48>
  ip->ref--;
    80002db6:	449c                	lw	a5,8(s1)
    80002db8:	37fd                	addiw	a5,a5,-1
    80002dba:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dbc:	00010517          	auipc	a0,0x10
    80002dc0:	bcc50513          	addi	a0,a0,-1076 # 80012988 <itable>
    80002dc4:	00003097          	auipc	ra,0x3
    80002dc8:	682080e7          	jalr	1666(ra) # 80006446 <release>
}
    80002dcc:	60e2                	ld	ra,24(sp)
    80002dce:	6442                	ld	s0,16(sp)
    80002dd0:	64a2                	ld	s1,8(sp)
    80002dd2:	6902                	ld	s2,0(sp)
    80002dd4:	6105                	addi	sp,sp,32
    80002dd6:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dd8:	40bc                	lw	a5,64(s1)
    80002dda:	dff1                	beqz	a5,80002db6 <iput+0x26>
    80002ddc:	04a49783          	lh	a5,74(s1)
    80002de0:	fbf9                	bnez	a5,80002db6 <iput+0x26>
    acquiresleep(&ip->lock);
    80002de2:	01048913          	addi	s2,s1,16
    80002de6:	854a                	mv	a0,s2
    80002de8:	00001097          	auipc	ra,0x1
    80002dec:	aba080e7          	jalr	-1350(ra) # 800038a2 <acquiresleep>
    release(&itable.lock);
    80002df0:	00010517          	auipc	a0,0x10
    80002df4:	b9850513          	addi	a0,a0,-1128 # 80012988 <itable>
    80002df8:	00003097          	auipc	ra,0x3
    80002dfc:	64e080e7          	jalr	1614(ra) # 80006446 <release>
    itrunc(ip);
    80002e00:	8526                	mv	a0,s1
    80002e02:	00000097          	auipc	ra,0x0
    80002e06:	e38080e7          	jalr	-456(ra) # 80002c3a <itrunc>
    ip->type = 0;
    80002e0a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e0e:	8526                	mv	a0,s1
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	c52080e7          	jalr	-942(ra) # 80002a62 <iupdate>
    ip->valid = 0;
    80002e18:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e1c:	854a                	mv	a0,s2
    80002e1e:	00001097          	auipc	ra,0x1
    80002e22:	ada080e7          	jalr	-1318(ra) # 800038f8 <releasesleep>
    acquire(&itable.lock);
    80002e26:	00010517          	auipc	a0,0x10
    80002e2a:	b6250513          	addi	a0,a0,-1182 # 80012988 <itable>
    80002e2e:	00003097          	auipc	ra,0x3
    80002e32:	564080e7          	jalr	1380(ra) # 80006392 <acquire>
    80002e36:	b741                	j	80002db6 <iput+0x26>

0000000080002e38 <iunlockput>:
{
    80002e38:	1101                	addi	sp,sp,-32
    80002e3a:	ec06                	sd	ra,24(sp)
    80002e3c:	e822                	sd	s0,16(sp)
    80002e3e:	e426                	sd	s1,8(sp)
    80002e40:	1000                	addi	s0,sp,32
    80002e42:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e44:	00000097          	auipc	ra,0x0
    80002e48:	daa080e7          	jalr	-598(ra) # 80002bee <iunlock>
  iput(ip);
    80002e4c:	8526                	mv	a0,s1
    80002e4e:	00000097          	auipc	ra,0x0
    80002e52:	f42080e7          	jalr	-190(ra) # 80002d90 <iput>
}
    80002e56:	60e2                	ld	ra,24(sp)
    80002e58:	6442                	ld	s0,16(sp)
    80002e5a:	64a2                	ld	s1,8(sp)
    80002e5c:	6105                	addi	sp,sp,32
    80002e5e:	8082                	ret

0000000080002e60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e60:	1141                	addi	sp,sp,-16
    80002e62:	e422                	sd	s0,8(sp)
    80002e64:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e66:	411c                	lw	a5,0(a0)
    80002e68:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e6a:	415c                	lw	a5,4(a0)
    80002e6c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e6e:	04451783          	lh	a5,68(a0)
    80002e72:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e76:	04a51783          	lh	a5,74(a0)
    80002e7a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e7e:	04c56783          	lwu	a5,76(a0)
    80002e82:	e99c                	sd	a5,16(a1)
}
    80002e84:	6422                	ld	s0,8(sp)
    80002e86:	0141                	addi	sp,sp,16
    80002e88:	8082                	ret

0000000080002e8a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e8a:	457c                	lw	a5,76(a0)
    80002e8c:	0ed7e963          	bltu	a5,a3,80002f7e <readi+0xf4>
{
    80002e90:	7159                	addi	sp,sp,-112
    80002e92:	f486                	sd	ra,104(sp)
    80002e94:	f0a2                	sd	s0,96(sp)
    80002e96:	eca6                	sd	s1,88(sp)
    80002e98:	e8ca                	sd	s2,80(sp)
    80002e9a:	e4ce                	sd	s3,72(sp)
    80002e9c:	e0d2                	sd	s4,64(sp)
    80002e9e:	fc56                	sd	s5,56(sp)
    80002ea0:	f85a                	sd	s6,48(sp)
    80002ea2:	f45e                	sd	s7,40(sp)
    80002ea4:	f062                	sd	s8,32(sp)
    80002ea6:	ec66                	sd	s9,24(sp)
    80002ea8:	e86a                	sd	s10,16(sp)
    80002eaa:	e46e                	sd	s11,8(sp)
    80002eac:	1880                	addi	s0,sp,112
    80002eae:	8baa                	mv	s7,a0
    80002eb0:	8c2e                	mv	s8,a1
    80002eb2:	8ab2                	mv	s5,a2
    80002eb4:	84b6                	mv	s1,a3
    80002eb6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002eb8:	9f35                	addw	a4,a4,a3
    return 0;
    80002eba:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ebc:	0ad76063          	bltu	a4,a3,80002f5c <readi+0xd2>
  if(off + n > ip->size)
    80002ec0:	00e7f463          	bgeu	a5,a4,80002ec8 <readi+0x3e>
    n = ip->size - off;
    80002ec4:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec8:	0a0b0963          	beqz	s6,80002f7a <readi+0xf0>
    80002ecc:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ece:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ed2:	5cfd                	li	s9,-1
    80002ed4:	a82d                	j	80002f0e <readi+0x84>
    80002ed6:	020a1d93          	slli	s11,s4,0x20
    80002eda:	020ddd93          	srli	s11,s11,0x20
    80002ede:	05890613          	addi	a2,s2,88
    80002ee2:	86ee                	mv	a3,s11
    80002ee4:	963a                	add	a2,a2,a4
    80002ee6:	85d6                	mv	a1,s5
    80002ee8:	8562                	mv	a0,s8
    80002eea:	fffff097          	auipc	ra,0xfffff
    80002eee:	9be080e7          	jalr	-1602(ra) # 800018a8 <either_copyout>
    80002ef2:	05950d63          	beq	a0,s9,80002f4c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ef6:	854a                	mv	a0,s2
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	49c080e7          	jalr	1180(ra) # 80002394 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f00:	013a09bb          	addw	s3,s4,s3
    80002f04:	009a04bb          	addw	s1,s4,s1
    80002f08:	9aee                	add	s5,s5,s11
    80002f0a:	0569f763          	bgeu	s3,s6,80002f58 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f0e:	000ba903          	lw	s2,0(s7)
    80002f12:	00a4d59b          	srliw	a1,s1,0xa
    80002f16:	855e                	mv	a0,s7
    80002f18:	fffff097          	auipc	ra,0xfffff
    80002f1c:	740080e7          	jalr	1856(ra) # 80002658 <bmap>
    80002f20:	0005059b          	sext.w	a1,a0
    80002f24:	854a                	mv	a0,s2
    80002f26:	fffff097          	auipc	ra,0xfffff
    80002f2a:	33e080e7          	jalr	830(ra) # 80002264 <bread>
    80002f2e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f30:	3ff4f713          	andi	a4,s1,1023
    80002f34:	40ed07bb          	subw	a5,s10,a4
    80002f38:	413b06bb          	subw	a3,s6,s3
    80002f3c:	8a3e                	mv	s4,a5
    80002f3e:	2781                	sext.w	a5,a5
    80002f40:	0006861b          	sext.w	a2,a3
    80002f44:	f8f679e3          	bgeu	a2,a5,80002ed6 <readi+0x4c>
    80002f48:	8a36                	mv	s4,a3
    80002f4a:	b771                	j	80002ed6 <readi+0x4c>
      brelse(bp);
    80002f4c:	854a                	mv	a0,s2
    80002f4e:	fffff097          	auipc	ra,0xfffff
    80002f52:	446080e7          	jalr	1094(ra) # 80002394 <brelse>
      tot = -1;
    80002f56:	59fd                	li	s3,-1
  }
  return tot;
    80002f58:	0009851b          	sext.w	a0,s3
}
    80002f5c:	70a6                	ld	ra,104(sp)
    80002f5e:	7406                	ld	s0,96(sp)
    80002f60:	64e6                	ld	s1,88(sp)
    80002f62:	6946                	ld	s2,80(sp)
    80002f64:	69a6                	ld	s3,72(sp)
    80002f66:	6a06                	ld	s4,64(sp)
    80002f68:	7ae2                	ld	s5,56(sp)
    80002f6a:	7b42                	ld	s6,48(sp)
    80002f6c:	7ba2                	ld	s7,40(sp)
    80002f6e:	7c02                	ld	s8,32(sp)
    80002f70:	6ce2                	ld	s9,24(sp)
    80002f72:	6d42                	ld	s10,16(sp)
    80002f74:	6da2                	ld	s11,8(sp)
    80002f76:	6165                	addi	sp,sp,112
    80002f78:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f7a:	89da                	mv	s3,s6
    80002f7c:	bff1                	j	80002f58 <readi+0xce>
    return 0;
    80002f7e:	4501                	li	a0,0
}
    80002f80:	8082                	ret

0000000080002f82 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f82:	457c                	lw	a5,76(a0)
    80002f84:	10d7e963          	bltu	a5,a3,80003096 <writei+0x114>
{
    80002f88:	7159                	addi	sp,sp,-112
    80002f8a:	f486                	sd	ra,104(sp)
    80002f8c:	f0a2                	sd	s0,96(sp)
    80002f8e:	eca6                	sd	s1,88(sp)
    80002f90:	e8ca                	sd	s2,80(sp)
    80002f92:	e4ce                	sd	s3,72(sp)
    80002f94:	e0d2                	sd	s4,64(sp)
    80002f96:	fc56                	sd	s5,56(sp)
    80002f98:	f85a                	sd	s6,48(sp)
    80002f9a:	f45e                	sd	s7,40(sp)
    80002f9c:	f062                	sd	s8,32(sp)
    80002f9e:	ec66                	sd	s9,24(sp)
    80002fa0:	e86a                	sd	s10,16(sp)
    80002fa2:	e46e                	sd	s11,8(sp)
    80002fa4:	1880                	addi	s0,sp,112
    80002fa6:	8b2a                	mv	s6,a0
    80002fa8:	8c2e                	mv	s8,a1
    80002faa:	8ab2                	mv	s5,a2
    80002fac:	8936                	mv	s2,a3
    80002fae:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002fb0:	9f35                	addw	a4,a4,a3
    80002fb2:	0ed76463          	bltu	a4,a3,8000309a <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fb6:	040437b7          	lui	a5,0x4043
    80002fba:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80002fbe:	0ee7e063          	bltu	a5,a4,8000309e <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fc2:	0c0b8863          	beqz	s7,80003092 <writei+0x110>
    80002fc6:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc8:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fcc:	5cfd                	li	s9,-1
    80002fce:	a091                	j	80003012 <writei+0x90>
    80002fd0:	02099d93          	slli	s11,s3,0x20
    80002fd4:	020ddd93          	srli	s11,s11,0x20
    80002fd8:	05848513          	addi	a0,s1,88
    80002fdc:	86ee                	mv	a3,s11
    80002fde:	8656                	mv	a2,s5
    80002fe0:	85e2                	mv	a1,s8
    80002fe2:	953a                	add	a0,a0,a4
    80002fe4:	fffff097          	auipc	ra,0xfffff
    80002fe8:	91a080e7          	jalr	-1766(ra) # 800018fe <either_copyin>
    80002fec:	07950263          	beq	a0,s9,80003050 <writei+0xce>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ff0:	8526                	mv	a0,s1
    80002ff2:	00000097          	auipc	ra,0x0
    80002ff6:	790080e7          	jalr	1936(ra) # 80003782 <log_write>
    brelse(bp);
    80002ffa:	8526                	mv	a0,s1
    80002ffc:	fffff097          	auipc	ra,0xfffff
    80003000:	398080e7          	jalr	920(ra) # 80002394 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003004:	01498a3b          	addw	s4,s3,s4
    80003008:	0129893b          	addw	s2,s3,s2
    8000300c:	9aee                	add	s5,s5,s11
    8000300e:	057a7663          	bgeu	s4,s7,8000305a <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003012:	000b2483          	lw	s1,0(s6)
    80003016:	00a9559b          	srliw	a1,s2,0xa
    8000301a:	855a                	mv	a0,s6
    8000301c:	fffff097          	auipc	ra,0xfffff
    80003020:	63c080e7          	jalr	1596(ra) # 80002658 <bmap>
    80003024:	0005059b          	sext.w	a1,a0
    80003028:	8526                	mv	a0,s1
    8000302a:	fffff097          	auipc	ra,0xfffff
    8000302e:	23a080e7          	jalr	570(ra) # 80002264 <bread>
    80003032:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003034:	3ff97713          	andi	a4,s2,1023
    80003038:	40ed07bb          	subw	a5,s10,a4
    8000303c:	414b86bb          	subw	a3,s7,s4
    80003040:	89be                	mv	s3,a5
    80003042:	2781                	sext.w	a5,a5
    80003044:	0006861b          	sext.w	a2,a3
    80003048:	f8f674e3          	bgeu	a2,a5,80002fd0 <writei+0x4e>
    8000304c:	89b6                	mv	s3,a3
    8000304e:	b749                	j	80002fd0 <writei+0x4e>
      brelse(bp);
    80003050:	8526                	mv	a0,s1
    80003052:	fffff097          	auipc	ra,0xfffff
    80003056:	342080e7          	jalr	834(ra) # 80002394 <brelse>
  }

  if(off > ip->size)
    8000305a:	04cb2783          	lw	a5,76(s6)
    8000305e:	0127f463          	bgeu	a5,s2,80003066 <writei+0xe4>
    ip->size = off;
    80003062:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003066:	855a                	mv	a0,s6
    80003068:	00000097          	auipc	ra,0x0
    8000306c:	9fa080e7          	jalr	-1542(ra) # 80002a62 <iupdate>

  return tot;
    80003070:	000a051b          	sext.w	a0,s4
}
    80003074:	70a6                	ld	ra,104(sp)
    80003076:	7406                	ld	s0,96(sp)
    80003078:	64e6                	ld	s1,88(sp)
    8000307a:	6946                	ld	s2,80(sp)
    8000307c:	69a6                	ld	s3,72(sp)
    8000307e:	6a06                	ld	s4,64(sp)
    80003080:	7ae2                	ld	s5,56(sp)
    80003082:	7b42                	ld	s6,48(sp)
    80003084:	7ba2                	ld	s7,40(sp)
    80003086:	7c02                	ld	s8,32(sp)
    80003088:	6ce2                	ld	s9,24(sp)
    8000308a:	6d42                	ld	s10,16(sp)
    8000308c:	6da2                	ld	s11,8(sp)
    8000308e:	6165                	addi	sp,sp,112
    80003090:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003092:	8a5e                	mv	s4,s7
    80003094:	bfc9                	j	80003066 <writei+0xe4>
    return -1;
    80003096:	557d                	li	a0,-1
}
    80003098:	8082                	ret
    return -1;
    8000309a:	557d                	li	a0,-1
    8000309c:	bfe1                	j	80003074 <writei+0xf2>
    return -1;
    8000309e:	557d                	li	a0,-1
    800030a0:	bfd1                	j	80003074 <writei+0xf2>

00000000800030a2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030a2:	1141                	addi	sp,sp,-16
    800030a4:	e406                	sd	ra,8(sp)
    800030a6:	e022                	sd	s0,0(sp)
    800030a8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030aa:	4639                	li	a2,14
    800030ac:	ffffd097          	auipc	ra,0xffffd
    800030b0:	1a4080e7          	jalr	420(ra) # 80000250 <strncmp>
}
    800030b4:	60a2                	ld	ra,8(sp)
    800030b6:	6402                	ld	s0,0(sp)
    800030b8:	0141                	addi	sp,sp,16
    800030ba:	8082                	ret

00000000800030bc <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030bc:	7139                	addi	sp,sp,-64
    800030be:	fc06                	sd	ra,56(sp)
    800030c0:	f822                	sd	s0,48(sp)
    800030c2:	f426                	sd	s1,40(sp)
    800030c4:	f04a                	sd	s2,32(sp)
    800030c6:	ec4e                	sd	s3,24(sp)
    800030c8:	e852                	sd	s4,16(sp)
    800030ca:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030cc:	04451703          	lh	a4,68(a0)
    800030d0:	4785                	li	a5,1
    800030d2:	00f71a63          	bne	a4,a5,800030e6 <dirlookup+0x2a>
    800030d6:	892a                	mv	s2,a0
    800030d8:	89ae                	mv	s3,a1
    800030da:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030dc:	457c                	lw	a5,76(a0)
    800030de:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030e0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e2:	e79d                	bnez	a5,80003110 <dirlookup+0x54>
    800030e4:	a8a5                	j	8000315c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030e6:	00005517          	auipc	a0,0x5
    800030ea:	48a50513          	addi	a0,a0,1162 # 80008570 <syscalls+0x1a8>
    800030ee:	00003097          	auipc	ra,0x3
    800030f2:	d5a080e7          	jalr	-678(ra) # 80005e48 <panic>
      panic("dirlookup read");
    800030f6:	00005517          	auipc	a0,0x5
    800030fa:	49250513          	addi	a0,a0,1170 # 80008588 <syscalls+0x1c0>
    800030fe:	00003097          	auipc	ra,0x3
    80003102:	d4a080e7          	jalr	-694(ra) # 80005e48 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003106:	24c1                	addiw	s1,s1,16
    80003108:	04c92783          	lw	a5,76(s2)
    8000310c:	04f4f763          	bgeu	s1,a5,8000315a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003110:	4741                	li	a4,16
    80003112:	86a6                	mv	a3,s1
    80003114:	fc040613          	addi	a2,s0,-64
    80003118:	4581                	li	a1,0
    8000311a:	854a                	mv	a0,s2
    8000311c:	00000097          	auipc	ra,0x0
    80003120:	d6e080e7          	jalr	-658(ra) # 80002e8a <readi>
    80003124:	47c1                	li	a5,16
    80003126:	fcf518e3          	bne	a0,a5,800030f6 <dirlookup+0x3a>
    if(de.inum == 0)
    8000312a:	fc045783          	lhu	a5,-64(s0)
    8000312e:	dfe1                	beqz	a5,80003106 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003130:	fc240593          	addi	a1,s0,-62
    80003134:	854e                	mv	a0,s3
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	f6c080e7          	jalr	-148(ra) # 800030a2 <namecmp>
    8000313e:	f561                	bnez	a0,80003106 <dirlookup+0x4a>
      if(poff)
    80003140:	000a0463          	beqz	s4,80003148 <dirlookup+0x8c>
        *poff = off;
    80003144:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003148:	fc045583          	lhu	a1,-64(s0)
    8000314c:	00092503          	lw	a0,0(s2)
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	6a8080e7          	jalr	1704(ra) # 800027f8 <iget>
    80003158:	a011                	j	8000315c <dirlookup+0xa0>
  return 0;
    8000315a:	4501                	li	a0,0
}
    8000315c:	70e2                	ld	ra,56(sp)
    8000315e:	7442                	ld	s0,48(sp)
    80003160:	74a2                	ld	s1,40(sp)
    80003162:	7902                	ld	s2,32(sp)
    80003164:	69e2                	ld	s3,24(sp)
    80003166:	6a42                	ld	s4,16(sp)
    80003168:	6121                	addi	sp,sp,64
    8000316a:	8082                	ret

000000008000316c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000316c:	711d                	addi	sp,sp,-96
    8000316e:	ec86                	sd	ra,88(sp)
    80003170:	e8a2                	sd	s0,80(sp)
    80003172:	e4a6                	sd	s1,72(sp)
    80003174:	e0ca                	sd	s2,64(sp)
    80003176:	fc4e                	sd	s3,56(sp)
    80003178:	f852                	sd	s4,48(sp)
    8000317a:	f456                	sd	s5,40(sp)
    8000317c:	f05a                	sd	s6,32(sp)
    8000317e:	ec5e                	sd	s7,24(sp)
    80003180:	e862                	sd	s8,16(sp)
    80003182:	e466                	sd	s9,8(sp)
    80003184:	1080                	addi	s0,sp,96
    80003186:	84aa                	mv	s1,a0
    80003188:	8b2e                	mv	s6,a1
    8000318a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000318c:	00054703          	lbu	a4,0(a0)
    80003190:	02f00793          	li	a5,47
    80003194:	02f70363          	beq	a4,a5,800031ba <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003198:	ffffe097          	auipc	ra,0xffffe
    8000319c:	cb0080e7          	jalr	-848(ra) # 80000e48 <myproc>
    800031a0:	15053503          	ld	a0,336(a0)
    800031a4:	00000097          	auipc	ra,0x0
    800031a8:	94a080e7          	jalr	-1718(ra) # 80002aee <idup>
    800031ac:	89aa                	mv	s3,a0
  while(*path == '/')
    800031ae:	02f00913          	li	s2,47
  len = path - s;
    800031b2:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031b4:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031b6:	4c05                	li	s8,1
    800031b8:	a865                	j	80003270 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031ba:	4585                	li	a1,1
    800031bc:	4505                	li	a0,1
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	63a080e7          	jalr	1594(ra) # 800027f8 <iget>
    800031c6:	89aa                	mv	s3,a0
    800031c8:	b7dd                	j	800031ae <namex+0x42>
      iunlockput(ip);
    800031ca:	854e                	mv	a0,s3
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	c6c080e7          	jalr	-916(ra) # 80002e38 <iunlockput>
      return 0;
    800031d4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031d6:	854e                	mv	a0,s3
    800031d8:	60e6                	ld	ra,88(sp)
    800031da:	6446                	ld	s0,80(sp)
    800031dc:	64a6                	ld	s1,72(sp)
    800031de:	6906                	ld	s2,64(sp)
    800031e0:	79e2                	ld	s3,56(sp)
    800031e2:	7a42                	ld	s4,48(sp)
    800031e4:	7aa2                	ld	s5,40(sp)
    800031e6:	7b02                	ld	s6,32(sp)
    800031e8:	6be2                	ld	s7,24(sp)
    800031ea:	6c42                	ld	s8,16(sp)
    800031ec:	6ca2                	ld	s9,8(sp)
    800031ee:	6125                	addi	sp,sp,96
    800031f0:	8082                	ret
      iunlock(ip);
    800031f2:	854e                	mv	a0,s3
    800031f4:	00000097          	auipc	ra,0x0
    800031f8:	9fa080e7          	jalr	-1542(ra) # 80002bee <iunlock>
      return ip;
    800031fc:	bfe9                	j	800031d6 <namex+0x6a>
      iunlockput(ip);
    800031fe:	854e                	mv	a0,s3
    80003200:	00000097          	auipc	ra,0x0
    80003204:	c38080e7          	jalr	-968(ra) # 80002e38 <iunlockput>
      return 0;
    80003208:	89d2                	mv	s3,s4
    8000320a:	b7f1                	j	800031d6 <namex+0x6a>
  len = path - s;
    8000320c:	40b48633          	sub	a2,s1,a1
    80003210:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003214:	094cd463          	bge	s9,s4,8000329c <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003218:	4639                	li	a2,14
    8000321a:	8556                	mv	a0,s5
    8000321c:	ffffd097          	auipc	ra,0xffffd
    80003220:	fbc080e7          	jalr	-68(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003224:	0004c783          	lbu	a5,0(s1)
    80003228:	01279763          	bne	a5,s2,80003236 <namex+0xca>
    path++;
    8000322c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000322e:	0004c783          	lbu	a5,0(s1)
    80003232:	ff278de3          	beq	a5,s2,8000322c <namex+0xc0>
    ilock(ip);
    80003236:	854e                	mv	a0,s3
    80003238:	00000097          	auipc	ra,0x0
    8000323c:	8f4080e7          	jalr	-1804(ra) # 80002b2c <ilock>
    if(ip->type != T_DIR){
    80003240:	04499783          	lh	a5,68(s3)
    80003244:	f98793e3          	bne	a5,s8,800031ca <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003248:	000b0563          	beqz	s6,80003252 <namex+0xe6>
    8000324c:	0004c783          	lbu	a5,0(s1)
    80003250:	d3cd                	beqz	a5,800031f2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003252:	865e                	mv	a2,s7
    80003254:	85d6                	mv	a1,s5
    80003256:	854e                	mv	a0,s3
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	e64080e7          	jalr	-412(ra) # 800030bc <dirlookup>
    80003260:	8a2a                	mv	s4,a0
    80003262:	dd51                	beqz	a0,800031fe <namex+0x92>
    iunlockput(ip);
    80003264:	854e                	mv	a0,s3
    80003266:	00000097          	auipc	ra,0x0
    8000326a:	bd2080e7          	jalr	-1070(ra) # 80002e38 <iunlockput>
    ip = next;
    8000326e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003270:	0004c783          	lbu	a5,0(s1)
    80003274:	05279763          	bne	a5,s2,800032c2 <namex+0x156>
    path++;
    80003278:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000327a:	0004c783          	lbu	a5,0(s1)
    8000327e:	ff278de3          	beq	a5,s2,80003278 <namex+0x10c>
  if(*path == 0)
    80003282:	c79d                	beqz	a5,800032b0 <namex+0x144>
    path++;
    80003284:	85a6                	mv	a1,s1
  len = path - s;
    80003286:	8a5e                	mv	s4,s7
    80003288:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000328a:	01278963          	beq	a5,s2,8000329c <namex+0x130>
    8000328e:	dfbd                	beqz	a5,8000320c <namex+0xa0>
    path++;
    80003290:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003292:	0004c783          	lbu	a5,0(s1)
    80003296:	ff279ce3          	bne	a5,s2,8000328e <namex+0x122>
    8000329a:	bf8d                	j	8000320c <namex+0xa0>
    memmove(name, s, len);
    8000329c:	2601                	sext.w	a2,a2
    8000329e:	8556                	mv	a0,s5
    800032a0:	ffffd097          	auipc	ra,0xffffd
    800032a4:	f38080e7          	jalr	-200(ra) # 800001d8 <memmove>
    name[len] = 0;
    800032a8:	9a56                	add	s4,s4,s5
    800032aa:	000a0023          	sb	zero,0(s4)
    800032ae:	bf9d                	j	80003224 <namex+0xb8>
  if(nameiparent){
    800032b0:	f20b03e3          	beqz	s6,800031d6 <namex+0x6a>
    iput(ip);
    800032b4:	854e                	mv	a0,s3
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	ada080e7          	jalr	-1318(ra) # 80002d90 <iput>
    return 0;
    800032be:	4981                	li	s3,0
    800032c0:	bf19                	j	800031d6 <namex+0x6a>
  if(*path == 0)
    800032c2:	d7fd                	beqz	a5,800032b0 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032c4:	0004c783          	lbu	a5,0(s1)
    800032c8:	85a6                	mv	a1,s1
    800032ca:	b7d1                	j	8000328e <namex+0x122>

00000000800032cc <dirlink>:
{
    800032cc:	7139                	addi	sp,sp,-64
    800032ce:	fc06                	sd	ra,56(sp)
    800032d0:	f822                	sd	s0,48(sp)
    800032d2:	f426                	sd	s1,40(sp)
    800032d4:	f04a                	sd	s2,32(sp)
    800032d6:	ec4e                	sd	s3,24(sp)
    800032d8:	e852                	sd	s4,16(sp)
    800032da:	0080                	addi	s0,sp,64
    800032dc:	892a                	mv	s2,a0
    800032de:	8a2e                	mv	s4,a1
    800032e0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032e2:	4601                	li	a2,0
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	dd8080e7          	jalr	-552(ra) # 800030bc <dirlookup>
    800032ec:	e93d                	bnez	a0,80003362 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ee:	04c92483          	lw	s1,76(s2)
    800032f2:	c49d                	beqz	s1,80003320 <dirlink+0x54>
    800032f4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032f6:	4741                	li	a4,16
    800032f8:	86a6                	mv	a3,s1
    800032fa:	fc040613          	addi	a2,s0,-64
    800032fe:	4581                	li	a1,0
    80003300:	854a                	mv	a0,s2
    80003302:	00000097          	auipc	ra,0x0
    80003306:	b88080e7          	jalr	-1144(ra) # 80002e8a <readi>
    8000330a:	47c1                	li	a5,16
    8000330c:	06f51163          	bne	a0,a5,8000336e <dirlink+0xa2>
    if(de.inum == 0)
    80003310:	fc045783          	lhu	a5,-64(s0)
    80003314:	c791                	beqz	a5,80003320 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003316:	24c1                	addiw	s1,s1,16
    80003318:	04c92783          	lw	a5,76(s2)
    8000331c:	fcf4ede3          	bltu	s1,a5,800032f6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003320:	4639                	li	a2,14
    80003322:	85d2                	mv	a1,s4
    80003324:	fc240513          	addi	a0,s0,-62
    80003328:	ffffd097          	auipc	ra,0xffffd
    8000332c:	f64080e7          	jalr	-156(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003330:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003334:	4741                	li	a4,16
    80003336:	86a6                	mv	a3,s1
    80003338:	fc040613          	addi	a2,s0,-64
    8000333c:	4581                	li	a1,0
    8000333e:	854a                	mv	a0,s2
    80003340:	00000097          	auipc	ra,0x0
    80003344:	c42080e7          	jalr	-958(ra) # 80002f82 <writei>
    80003348:	872a                	mv	a4,a0
    8000334a:	47c1                	li	a5,16
  return 0;
    8000334c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000334e:	02f71863          	bne	a4,a5,8000337e <dirlink+0xb2>
}
    80003352:	70e2                	ld	ra,56(sp)
    80003354:	7442                	ld	s0,48(sp)
    80003356:	74a2                	ld	s1,40(sp)
    80003358:	7902                	ld	s2,32(sp)
    8000335a:	69e2                	ld	s3,24(sp)
    8000335c:	6a42                	ld	s4,16(sp)
    8000335e:	6121                	addi	sp,sp,64
    80003360:	8082                	ret
    iput(ip);
    80003362:	00000097          	auipc	ra,0x0
    80003366:	a2e080e7          	jalr	-1490(ra) # 80002d90 <iput>
    return -1;
    8000336a:	557d                	li	a0,-1
    8000336c:	b7dd                	j	80003352 <dirlink+0x86>
      panic("dirlink read");
    8000336e:	00005517          	auipc	a0,0x5
    80003372:	22a50513          	addi	a0,a0,554 # 80008598 <syscalls+0x1d0>
    80003376:	00003097          	auipc	ra,0x3
    8000337a:	ad2080e7          	jalr	-1326(ra) # 80005e48 <panic>
    panic("dirlink");
    8000337e:	00005517          	auipc	a0,0x5
    80003382:	32a50513          	addi	a0,a0,810 # 800086a8 <syscalls+0x2e0>
    80003386:	00003097          	auipc	ra,0x3
    8000338a:	ac2080e7          	jalr	-1342(ra) # 80005e48 <panic>

000000008000338e <namei>:

struct inode*
namei(char *path)
{
    8000338e:	1101                	addi	sp,sp,-32
    80003390:	ec06                	sd	ra,24(sp)
    80003392:	e822                	sd	s0,16(sp)
    80003394:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003396:	fe040613          	addi	a2,s0,-32
    8000339a:	4581                	li	a1,0
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	dd0080e7          	jalr	-560(ra) # 8000316c <namex>
}
    800033a4:	60e2                	ld	ra,24(sp)
    800033a6:	6442                	ld	s0,16(sp)
    800033a8:	6105                	addi	sp,sp,32
    800033aa:	8082                	ret

00000000800033ac <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033ac:	1141                	addi	sp,sp,-16
    800033ae:	e406                	sd	ra,8(sp)
    800033b0:	e022                	sd	s0,0(sp)
    800033b2:	0800                	addi	s0,sp,16
    800033b4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033b6:	4585                	li	a1,1
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	db4080e7          	jalr	-588(ra) # 8000316c <namex>
}
    800033c0:	60a2                	ld	ra,8(sp)
    800033c2:	6402                	ld	s0,0(sp)
    800033c4:	0141                	addi	sp,sp,16
    800033c6:	8082                	ret

00000000800033c8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033c8:	1101                	addi	sp,sp,-32
    800033ca:	ec06                	sd	ra,24(sp)
    800033cc:	e822                	sd	s0,16(sp)
    800033ce:	e426                	sd	s1,8(sp)
    800033d0:	e04a                	sd	s2,0(sp)
    800033d2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033d4:	00011917          	auipc	s2,0x11
    800033d8:	05c90913          	addi	s2,s2,92 # 80014430 <log>
    800033dc:	01892583          	lw	a1,24(s2)
    800033e0:	02892503          	lw	a0,40(s2)
    800033e4:	fffff097          	auipc	ra,0xfffff
    800033e8:	e80080e7          	jalr	-384(ra) # 80002264 <bread>
    800033ec:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033ee:	02c92683          	lw	a3,44(s2)
    800033f2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033f4:	02d05763          	blez	a3,80003422 <write_head+0x5a>
    800033f8:	00011797          	auipc	a5,0x11
    800033fc:	06878793          	addi	a5,a5,104 # 80014460 <log+0x30>
    80003400:	05c50713          	addi	a4,a0,92
    80003404:	36fd                	addiw	a3,a3,-1
    80003406:	1682                	slli	a3,a3,0x20
    80003408:	9281                	srli	a3,a3,0x20
    8000340a:	068a                	slli	a3,a3,0x2
    8000340c:	00011617          	auipc	a2,0x11
    80003410:	05860613          	addi	a2,a2,88 # 80014464 <log+0x34>
    80003414:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003416:	4390                	lw	a2,0(a5)
    80003418:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000341a:	0791                	addi	a5,a5,4
    8000341c:	0711                	addi	a4,a4,4
    8000341e:	fed79ce3          	bne	a5,a3,80003416 <write_head+0x4e>
  }
  bwrite(buf);
    80003422:	8526                	mv	a0,s1
    80003424:	fffff097          	auipc	ra,0xfffff
    80003428:	f32080e7          	jalr	-206(ra) # 80002356 <bwrite>
  brelse(buf);
    8000342c:	8526                	mv	a0,s1
    8000342e:	fffff097          	auipc	ra,0xfffff
    80003432:	f66080e7          	jalr	-154(ra) # 80002394 <brelse>
}
    80003436:	60e2                	ld	ra,24(sp)
    80003438:	6442                	ld	s0,16(sp)
    8000343a:	64a2                	ld	s1,8(sp)
    8000343c:	6902                	ld	s2,0(sp)
    8000343e:	6105                	addi	sp,sp,32
    80003440:	8082                	ret

0000000080003442 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003442:	00011797          	auipc	a5,0x11
    80003446:	01a7a783          	lw	a5,26(a5) # 8001445c <log+0x2c>
    8000344a:	0af05d63          	blez	a5,80003504 <install_trans+0xc2>
{
    8000344e:	7139                	addi	sp,sp,-64
    80003450:	fc06                	sd	ra,56(sp)
    80003452:	f822                	sd	s0,48(sp)
    80003454:	f426                	sd	s1,40(sp)
    80003456:	f04a                	sd	s2,32(sp)
    80003458:	ec4e                	sd	s3,24(sp)
    8000345a:	e852                	sd	s4,16(sp)
    8000345c:	e456                	sd	s5,8(sp)
    8000345e:	e05a                	sd	s6,0(sp)
    80003460:	0080                	addi	s0,sp,64
    80003462:	8b2a                	mv	s6,a0
    80003464:	00011a97          	auipc	s5,0x11
    80003468:	ffca8a93          	addi	s5,s5,-4 # 80014460 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000346c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000346e:	00011997          	auipc	s3,0x11
    80003472:	fc298993          	addi	s3,s3,-62 # 80014430 <log>
    80003476:	a035                	j	800034a2 <install_trans+0x60>
      bunpin(dbuf);
    80003478:	8526                	mv	a0,s1
    8000347a:	fffff097          	auipc	ra,0xfffff
    8000347e:	ff4080e7          	jalr	-12(ra) # 8000246e <bunpin>
    brelse(lbuf);
    80003482:	854a                	mv	a0,s2
    80003484:	fffff097          	auipc	ra,0xfffff
    80003488:	f10080e7          	jalr	-240(ra) # 80002394 <brelse>
    brelse(dbuf);
    8000348c:	8526                	mv	a0,s1
    8000348e:	fffff097          	auipc	ra,0xfffff
    80003492:	f06080e7          	jalr	-250(ra) # 80002394 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003496:	2a05                	addiw	s4,s4,1
    80003498:	0a91                	addi	s5,s5,4
    8000349a:	02c9a783          	lw	a5,44(s3)
    8000349e:	04fa5963          	bge	s4,a5,800034f0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a2:	0189a583          	lw	a1,24(s3)
    800034a6:	014585bb          	addw	a1,a1,s4
    800034aa:	2585                	addiw	a1,a1,1
    800034ac:	0289a503          	lw	a0,40(s3)
    800034b0:	fffff097          	auipc	ra,0xfffff
    800034b4:	db4080e7          	jalr	-588(ra) # 80002264 <bread>
    800034b8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034ba:	000aa583          	lw	a1,0(s5)
    800034be:	0289a503          	lw	a0,40(s3)
    800034c2:	fffff097          	auipc	ra,0xfffff
    800034c6:	da2080e7          	jalr	-606(ra) # 80002264 <bread>
    800034ca:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034cc:	40000613          	li	a2,1024
    800034d0:	05890593          	addi	a1,s2,88
    800034d4:	05850513          	addi	a0,a0,88
    800034d8:	ffffd097          	auipc	ra,0xffffd
    800034dc:	d00080e7          	jalr	-768(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034e0:	8526                	mv	a0,s1
    800034e2:	fffff097          	auipc	ra,0xfffff
    800034e6:	e74080e7          	jalr	-396(ra) # 80002356 <bwrite>
    if(recovering == 0)
    800034ea:	f80b1ce3          	bnez	s6,80003482 <install_trans+0x40>
    800034ee:	b769                	j	80003478 <install_trans+0x36>
}
    800034f0:	70e2                	ld	ra,56(sp)
    800034f2:	7442                	ld	s0,48(sp)
    800034f4:	74a2                	ld	s1,40(sp)
    800034f6:	7902                	ld	s2,32(sp)
    800034f8:	69e2                	ld	s3,24(sp)
    800034fa:	6a42                	ld	s4,16(sp)
    800034fc:	6aa2                	ld	s5,8(sp)
    800034fe:	6b02                	ld	s6,0(sp)
    80003500:	6121                	addi	sp,sp,64
    80003502:	8082                	ret
    80003504:	8082                	ret

0000000080003506 <initlog>:
{
    80003506:	7179                	addi	sp,sp,-48
    80003508:	f406                	sd	ra,40(sp)
    8000350a:	f022                	sd	s0,32(sp)
    8000350c:	ec26                	sd	s1,24(sp)
    8000350e:	e84a                	sd	s2,16(sp)
    80003510:	e44e                	sd	s3,8(sp)
    80003512:	1800                	addi	s0,sp,48
    80003514:	892a                	mv	s2,a0
    80003516:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003518:	00011497          	auipc	s1,0x11
    8000351c:	f1848493          	addi	s1,s1,-232 # 80014430 <log>
    80003520:	00005597          	auipc	a1,0x5
    80003524:	08858593          	addi	a1,a1,136 # 800085a8 <syscalls+0x1e0>
    80003528:	8526                	mv	a0,s1
    8000352a:	00003097          	auipc	ra,0x3
    8000352e:	dd8080e7          	jalr	-552(ra) # 80006302 <initlock>
  log.start = sb->logstart;
    80003532:	0149a583          	lw	a1,20(s3)
    80003536:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003538:	0109a783          	lw	a5,16(s3)
    8000353c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000353e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003542:	854a                	mv	a0,s2
    80003544:	fffff097          	auipc	ra,0xfffff
    80003548:	d20080e7          	jalr	-736(ra) # 80002264 <bread>
  log.lh.n = lh->n;
    8000354c:	4d3c                	lw	a5,88(a0)
    8000354e:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003550:	02f05563          	blez	a5,8000357a <initlog+0x74>
    80003554:	05c50713          	addi	a4,a0,92
    80003558:	00011697          	auipc	a3,0x11
    8000355c:	f0868693          	addi	a3,a3,-248 # 80014460 <log+0x30>
    80003560:	37fd                	addiw	a5,a5,-1
    80003562:	1782                	slli	a5,a5,0x20
    80003564:	9381                	srli	a5,a5,0x20
    80003566:	078a                	slli	a5,a5,0x2
    80003568:	06050613          	addi	a2,a0,96
    8000356c:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000356e:	4310                	lw	a2,0(a4)
    80003570:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003572:	0711                	addi	a4,a4,4
    80003574:	0691                	addi	a3,a3,4
    80003576:	fef71ce3          	bne	a4,a5,8000356e <initlog+0x68>
  brelse(buf);
    8000357a:	fffff097          	auipc	ra,0xfffff
    8000357e:	e1a080e7          	jalr	-486(ra) # 80002394 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003582:	4505                	li	a0,1
    80003584:	00000097          	auipc	ra,0x0
    80003588:	ebe080e7          	jalr	-322(ra) # 80003442 <install_trans>
  log.lh.n = 0;
    8000358c:	00011797          	auipc	a5,0x11
    80003590:	ec07a823          	sw	zero,-304(a5) # 8001445c <log+0x2c>
  write_head(); // clear the log
    80003594:	00000097          	auipc	ra,0x0
    80003598:	e34080e7          	jalr	-460(ra) # 800033c8 <write_head>
}
    8000359c:	70a2                	ld	ra,40(sp)
    8000359e:	7402                	ld	s0,32(sp)
    800035a0:	64e2                	ld	s1,24(sp)
    800035a2:	6942                	ld	s2,16(sp)
    800035a4:	69a2                	ld	s3,8(sp)
    800035a6:	6145                	addi	sp,sp,48
    800035a8:	8082                	ret

00000000800035aa <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035aa:	1101                	addi	sp,sp,-32
    800035ac:	ec06                	sd	ra,24(sp)
    800035ae:	e822                	sd	s0,16(sp)
    800035b0:	e426                	sd	s1,8(sp)
    800035b2:	e04a                	sd	s2,0(sp)
    800035b4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035b6:	00011517          	auipc	a0,0x11
    800035ba:	e7a50513          	addi	a0,a0,-390 # 80014430 <log>
    800035be:	00003097          	auipc	ra,0x3
    800035c2:	dd4080e7          	jalr	-556(ra) # 80006392 <acquire>
  while(1){
    if(log.committing){
    800035c6:	00011497          	auipc	s1,0x11
    800035ca:	e6a48493          	addi	s1,s1,-406 # 80014430 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ce:	4979                	li	s2,30
    800035d0:	a039                	j	800035de <begin_op+0x34>
      sleep(&log, &log.lock);
    800035d2:	85a6                	mv	a1,s1
    800035d4:	8526                	mv	a0,s1
    800035d6:	ffffe097          	auipc	ra,0xffffe
    800035da:	f2e080e7          	jalr	-210(ra) # 80001504 <sleep>
    if(log.committing){
    800035de:	50dc                	lw	a5,36(s1)
    800035e0:	fbed                	bnez	a5,800035d2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035e2:	509c                	lw	a5,32(s1)
    800035e4:	0017871b          	addiw	a4,a5,1
    800035e8:	0007069b          	sext.w	a3,a4
    800035ec:	0027179b          	slliw	a5,a4,0x2
    800035f0:	9fb9                	addw	a5,a5,a4
    800035f2:	0017979b          	slliw	a5,a5,0x1
    800035f6:	54d8                	lw	a4,44(s1)
    800035f8:	9fb9                	addw	a5,a5,a4
    800035fa:	00f95963          	bge	s2,a5,8000360c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035fe:	85a6                	mv	a1,s1
    80003600:	8526                	mv	a0,s1
    80003602:	ffffe097          	auipc	ra,0xffffe
    80003606:	f02080e7          	jalr	-254(ra) # 80001504 <sleep>
    8000360a:	bfd1                	j	800035de <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000360c:	00011517          	auipc	a0,0x11
    80003610:	e2450513          	addi	a0,a0,-476 # 80014430 <log>
    80003614:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003616:	00003097          	auipc	ra,0x3
    8000361a:	e30080e7          	jalr	-464(ra) # 80006446 <release>
      break;
    }
  }
}
    8000361e:	60e2                	ld	ra,24(sp)
    80003620:	6442                	ld	s0,16(sp)
    80003622:	64a2                	ld	s1,8(sp)
    80003624:	6902                	ld	s2,0(sp)
    80003626:	6105                	addi	sp,sp,32
    80003628:	8082                	ret

000000008000362a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000362a:	7139                	addi	sp,sp,-64
    8000362c:	fc06                	sd	ra,56(sp)
    8000362e:	f822                	sd	s0,48(sp)
    80003630:	f426                	sd	s1,40(sp)
    80003632:	f04a                	sd	s2,32(sp)
    80003634:	ec4e                	sd	s3,24(sp)
    80003636:	e852                	sd	s4,16(sp)
    80003638:	e456                	sd	s5,8(sp)
    8000363a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000363c:	00011497          	auipc	s1,0x11
    80003640:	df448493          	addi	s1,s1,-524 # 80014430 <log>
    80003644:	8526                	mv	a0,s1
    80003646:	00003097          	auipc	ra,0x3
    8000364a:	d4c080e7          	jalr	-692(ra) # 80006392 <acquire>
  log.outstanding -= 1;
    8000364e:	509c                	lw	a5,32(s1)
    80003650:	37fd                	addiw	a5,a5,-1
    80003652:	0007891b          	sext.w	s2,a5
    80003656:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003658:	50dc                	lw	a5,36(s1)
    8000365a:	efb9                	bnez	a5,800036b8 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000365c:	06091663          	bnez	s2,800036c8 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003660:	00011497          	auipc	s1,0x11
    80003664:	dd048493          	addi	s1,s1,-560 # 80014430 <log>
    80003668:	4785                	li	a5,1
    8000366a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000366c:	8526                	mv	a0,s1
    8000366e:	00003097          	auipc	ra,0x3
    80003672:	dd8080e7          	jalr	-552(ra) # 80006446 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003676:	54dc                	lw	a5,44(s1)
    80003678:	06f04763          	bgtz	a5,800036e6 <end_op+0xbc>
    acquire(&log.lock);
    8000367c:	00011497          	auipc	s1,0x11
    80003680:	db448493          	addi	s1,s1,-588 # 80014430 <log>
    80003684:	8526                	mv	a0,s1
    80003686:	00003097          	auipc	ra,0x3
    8000368a:	d0c080e7          	jalr	-756(ra) # 80006392 <acquire>
    log.committing = 0;
    8000368e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003692:	8526                	mv	a0,s1
    80003694:	ffffe097          	auipc	ra,0xffffe
    80003698:	ffc080e7          	jalr	-4(ra) # 80001690 <wakeup>
    release(&log.lock);
    8000369c:	8526                	mv	a0,s1
    8000369e:	00003097          	auipc	ra,0x3
    800036a2:	da8080e7          	jalr	-600(ra) # 80006446 <release>
}
    800036a6:	70e2                	ld	ra,56(sp)
    800036a8:	7442                	ld	s0,48(sp)
    800036aa:	74a2                	ld	s1,40(sp)
    800036ac:	7902                	ld	s2,32(sp)
    800036ae:	69e2                	ld	s3,24(sp)
    800036b0:	6a42                	ld	s4,16(sp)
    800036b2:	6aa2                	ld	s5,8(sp)
    800036b4:	6121                	addi	sp,sp,64
    800036b6:	8082                	ret
    panic("log.committing");
    800036b8:	00005517          	auipc	a0,0x5
    800036bc:	ef850513          	addi	a0,a0,-264 # 800085b0 <syscalls+0x1e8>
    800036c0:	00002097          	auipc	ra,0x2
    800036c4:	788080e7          	jalr	1928(ra) # 80005e48 <panic>
    wakeup(&log);
    800036c8:	00011497          	auipc	s1,0x11
    800036cc:	d6848493          	addi	s1,s1,-664 # 80014430 <log>
    800036d0:	8526                	mv	a0,s1
    800036d2:	ffffe097          	auipc	ra,0xffffe
    800036d6:	fbe080e7          	jalr	-66(ra) # 80001690 <wakeup>
  release(&log.lock);
    800036da:	8526                	mv	a0,s1
    800036dc:	00003097          	auipc	ra,0x3
    800036e0:	d6a080e7          	jalr	-662(ra) # 80006446 <release>
  if(do_commit){
    800036e4:	b7c9                	j	800036a6 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036e6:	00011a97          	auipc	s5,0x11
    800036ea:	d7aa8a93          	addi	s5,s5,-646 # 80014460 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036ee:	00011a17          	auipc	s4,0x11
    800036f2:	d42a0a13          	addi	s4,s4,-702 # 80014430 <log>
    800036f6:	018a2583          	lw	a1,24(s4)
    800036fa:	012585bb          	addw	a1,a1,s2
    800036fe:	2585                	addiw	a1,a1,1
    80003700:	028a2503          	lw	a0,40(s4)
    80003704:	fffff097          	auipc	ra,0xfffff
    80003708:	b60080e7          	jalr	-1184(ra) # 80002264 <bread>
    8000370c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000370e:	000aa583          	lw	a1,0(s5)
    80003712:	028a2503          	lw	a0,40(s4)
    80003716:	fffff097          	auipc	ra,0xfffff
    8000371a:	b4e080e7          	jalr	-1202(ra) # 80002264 <bread>
    8000371e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003720:	40000613          	li	a2,1024
    80003724:	05850593          	addi	a1,a0,88
    80003728:	05848513          	addi	a0,s1,88
    8000372c:	ffffd097          	auipc	ra,0xffffd
    80003730:	aac080e7          	jalr	-1364(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003734:	8526                	mv	a0,s1
    80003736:	fffff097          	auipc	ra,0xfffff
    8000373a:	c20080e7          	jalr	-992(ra) # 80002356 <bwrite>
    brelse(from);
    8000373e:	854e                	mv	a0,s3
    80003740:	fffff097          	auipc	ra,0xfffff
    80003744:	c54080e7          	jalr	-940(ra) # 80002394 <brelse>
    brelse(to);
    80003748:	8526                	mv	a0,s1
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	c4a080e7          	jalr	-950(ra) # 80002394 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003752:	2905                	addiw	s2,s2,1
    80003754:	0a91                	addi	s5,s5,4
    80003756:	02ca2783          	lw	a5,44(s4)
    8000375a:	f8f94ee3          	blt	s2,a5,800036f6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000375e:	00000097          	auipc	ra,0x0
    80003762:	c6a080e7          	jalr	-918(ra) # 800033c8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003766:	4501                	li	a0,0
    80003768:	00000097          	auipc	ra,0x0
    8000376c:	cda080e7          	jalr	-806(ra) # 80003442 <install_trans>
    log.lh.n = 0;
    80003770:	00011797          	auipc	a5,0x11
    80003774:	ce07a623          	sw	zero,-788(a5) # 8001445c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003778:	00000097          	auipc	ra,0x0
    8000377c:	c50080e7          	jalr	-944(ra) # 800033c8 <write_head>
    80003780:	bdf5                	j	8000367c <end_op+0x52>

0000000080003782 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003782:	1101                	addi	sp,sp,-32
    80003784:	ec06                	sd	ra,24(sp)
    80003786:	e822                	sd	s0,16(sp)
    80003788:	e426                	sd	s1,8(sp)
    8000378a:	e04a                	sd	s2,0(sp)
    8000378c:	1000                	addi	s0,sp,32
    8000378e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003790:	00011917          	auipc	s2,0x11
    80003794:	ca090913          	addi	s2,s2,-864 # 80014430 <log>
    80003798:	854a                	mv	a0,s2
    8000379a:	00003097          	auipc	ra,0x3
    8000379e:	bf8080e7          	jalr	-1032(ra) # 80006392 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037a2:	02c92603          	lw	a2,44(s2)
    800037a6:	47f5                	li	a5,29
    800037a8:	06c7c563          	blt	a5,a2,80003812 <log_write+0x90>
    800037ac:	00011797          	auipc	a5,0x11
    800037b0:	ca07a783          	lw	a5,-864(a5) # 8001444c <log+0x1c>
    800037b4:	37fd                	addiw	a5,a5,-1
    800037b6:	04f65e63          	bge	a2,a5,80003812 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037ba:	00011797          	auipc	a5,0x11
    800037be:	c967a783          	lw	a5,-874(a5) # 80014450 <log+0x20>
    800037c2:	06f05063          	blez	a5,80003822 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037c6:	4781                	li	a5,0
    800037c8:	06c05563          	blez	a2,80003832 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037cc:	44cc                	lw	a1,12(s1)
    800037ce:	00011717          	auipc	a4,0x11
    800037d2:	c9270713          	addi	a4,a4,-878 # 80014460 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037d6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d8:	4314                	lw	a3,0(a4)
    800037da:	04b68c63          	beq	a3,a1,80003832 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037de:	2785                	addiw	a5,a5,1
    800037e0:	0711                	addi	a4,a4,4
    800037e2:	fef61be3          	bne	a2,a5,800037d8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037e6:	0621                	addi	a2,a2,8
    800037e8:	060a                	slli	a2,a2,0x2
    800037ea:	00011797          	auipc	a5,0x11
    800037ee:	c4678793          	addi	a5,a5,-954 # 80014430 <log>
    800037f2:	963e                	add	a2,a2,a5
    800037f4:	44dc                	lw	a5,12(s1)
    800037f6:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037f8:	8526                	mv	a0,s1
    800037fa:	fffff097          	auipc	ra,0xfffff
    800037fe:	c38080e7          	jalr	-968(ra) # 80002432 <bpin>
    log.lh.n++;
    80003802:	00011717          	auipc	a4,0x11
    80003806:	c2e70713          	addi	a4,a4,-978 # 80014430 <log>
    8000380a:	575c                	lw	a5,44(a4)
    8000380c:	2785                	addiw	a5,a5,1
    8000380e:	d75c                	sw	a5,44(a4)
    80003810:	a835                	j	8000384c <log_write+0xca>
    panic("too big a transaction");
    80003812:	00005517          	auipc	a0,0x5
    80003816:	dae50513          	addi	a0,a0,-594 # 800085c0 <syscalls+0x1f8>
    8000381a:	00002097          	auipc	ra,0x2
    8000381e:	62e080e7          	jalr	1582(ra) # 80005e48 <panic>
    panic("log_write outside of trans");
    80003822:	00005517          	auipc	a0,0x5
    80003826:	db650513          	addi	a0,a0,-586 # 800085d8 <syscalls+0x210>
    8000382a:	00002097          	auipc	ra,0x2
    8000382e:	61e080e7          	jalr	1566(ra) # 80005e48 <panic>
  log.lh.block[i] = b->blockno;
    80003832:	00878713          	addi	a4,a5,8
    80003836:	00271693          	slli	a3,a4,0x2
    8000383a:	00011717          	auipc	a4,0x11
    8000383e:	bf670713          	addi	a4,a4,-1034 # 80014430 <log>
    80003842:	9736                	add	a4,a4,a3
    80003844:	44d4                	lw	a3,12(s1)
    80003846:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003848:	faf608e3          	beq	a2,a5,800037f8 <log_write+0x76>
  }
  release(&log.lock);
    8000384c:	00011517          	auipc	a0,0x11
    80003850:	be450513          	addi	a0,a0,-1052 # 80014430 <log>
    80003854:	00003097          	auipc	ra,0x3
    80003858:	bf2080e7          	jalr	-1038(ra) # 80006446 <release>
}
    8000385c:	60e2                	ld	ra,24(sp)
    8000385e:	6442                	ld	s0,16(sp)
    80003860:	64a2                	ld	s1,8(sp)
    80003862:	6902                	ld	s2,0(sp)
    80003864:	6105                	addi	sp,sp,32
    80003866:	8082                	ret

0000000080003868 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003868:	1101                	addi	sp,sp,-32
    8000386a:	ec06                	sd	ra,24(sp)
    8000386c:	e822                	sd	s0,16(sp)
    8000386e:	e426                	sd	s1,8(sp)
    80003870:	e04a                	sd	s2,0(sp)
    80003872:	1000                	addi	s0,sp,32
    80003874:	84aa                	mv	s1,a0
    80003876:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003878:	00005597          	auipc	a1,0x5
    8000387c:	d8058593          	addi	a1,a1,-640 # 800085f8 <syscalls+0x230>
    80003880:	0521                	addi	a0,a0,8
    80003882:	00003097          	auipc	ra,0x3
    80003886:	a80080e7          	jalr	-1408(ra) # 80006302 <initlock>
  lk->name = name;
    8000388a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000388e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003892:	0204a423          	sw	zero,40(s1)
}
    80003896:	60e2                	ld	ra,24(sp)
    80003898:	6442                	ld	s0,16(sp)
    8000389a:	64a2                	ld	s1,8(sp)
    8000389c:	6902                	ld	s2,0(sp)
    8000389e:	6105                	addi	sp,sp,32
    800038a0:	8082                	ret

00000000800038a2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038a2:	1101                	addi	sp,sp,-32
    800038a4:	ec06                	sd	ra,24(sp)
    800038a6:	e822                	sd	s0,16(sp)
    800038a8:	e426                	sd	s1,8(sp)
    800038aa:	e04a                	sd	s2,0(sp)
    800038ac:	1000                	addi	s0,sp,32
    800038ae:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038b0:	00850913          	addi	s2,a0,8
    800038b4:	854a                	mv	a0,s2
    800038b6:	00003097          	auipc	ra,0x3
    800038ba:	adc080e7          	jalr	-1316(ra) # 80006392 <acquire>
  while (lk->locked) {
    800038be:	409c                	lw	a5,0(s1)
    800038c0:	cb89                	beqz	a5,800038d2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038c2:	85ca                	mv	a1,s2
    800038c4:	8526                	mv	a0,s1
    800038c6:	ffffe097          	auipc	ra,0xffffe
    800038ca:	c3e080e7          	jalr	-962(ra) # 80001504 <sleep>
  while (lk->locked) {
    800038ce:	409c                	lw	a5,0(s1)
    800038d0:	fbed                	bnez	a5,800038c2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038d2:	4785                	li	a5,1
    800038d4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038d6:	ffffd097          	auipc	ra,0xffffd
    800038da:	572080e7          	jalr	1394(ra) # 80000e48 <myproc>
    800038de:	591c                	lw	a5,48(a0)
    800038e0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038e2:	854a                	mv	a0,s2
    800038e4:	00003097          	auipc	ra,0x3
    800038e8:	b62080e7          	jalr	-1182(ra) # 80006446 <release>
}
    800038ec:	60e2                	ld	ra,24(sp)
    800038ee:	6442                	ld	s0,16(sp)
    800038f0:	64a2                	ld	s1,8(sp)
    800038f2:	6902                	ld	s2,0(sp)
    800038f4:	6105                	addi	sp,sp,32
    800038f6:	8082                	ret

00000000800038f8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038f8:	1101                	addi	sp,sp,-32
    800038fa:	ec06                	sd	ra,24(sp)
    800038fc:	e822                	sd	s0,16(sp)
    800038fe:	e426                	sd	s1,8(sp)
    80003900:	e04a                	sd	s2,0(sp)
    80003902:	1000                	addi	s0,sp,32
    80003904:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003906:	00850913          	addi	s2,a0,8
    8000390a:	854a                	mv	a0,s2
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	a86080e7          	jalr	-1402(ra) # 80006392 <acquire>
  lk->locked = 0;
    80003914:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003918:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000391c:	8526                	mv	a0,s1
    8000391e:	ffffe097          	auipc	ra,0xffffe
    80003922:	d72080e7          	jalr	-654(ra) # 80001690 <wakeup>
  release(&lk->lk);
    80003926:	854a                	mv	a0,s2
    80003928:	00003097          	auipc	ra,0x3
    8000392c:	b1e080e7          	jalr	-1250(ra) # 80006446 <release>
}
    80003930:	60e2                	ld	ra,24(sp)
    80003932:	6442                	ld	s0,16(sp)
    80003934:	64a2                	ld	s1,8(sp)
    80003936:	6902                	ld	s2,0(sp)
    80003938:	6105                	addi	sp,sp,32
    8000393a:	8082                	ret

000000008000393c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000393c:	7179                	addi	sp,sp,-48
    8000393e:	f406                	sd	ra,40(sp)
    80003940:	f022                	sd	s0,32(sp)
    80003942:	ec26                	sd	s1,24(sp)
    80003944:	e84a                	sd	s2,16(sp)
    80003946:	e44e                	sd	s3,8(sp)
    80003948:	1800                	addi	s0,sp,48
    8000394a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000394c:	00850913          	addi	s2,a0,8
    80003950:	854a                	mv	a0,s2
    80003952:	00003097          	auipc	ra,0x3
    80003956:	a40080e7          	jalr	-1472(ra) # 80006392 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000395a:	409c                	lw	a5,0(s1)
    8000395c:	ef99                	bnez	a5,8000397a <holdingsleep+0x3e>
    8000395e:	4481                	li	s1,0
  release(&lk->lk);
    80003960:	854a                	mv	a0,s2
    80003962:	00003097          	auipc	ra,0x3
    80003966:	ae4080e7          	jalr	-1308(ra) # 80006446 <release>
  return r;
}
    8000396a:	8526                	mv	a0,s1
    8000396c:	70a2                	ld	ra,40(sp)
    8000396e:	7402                	ld	s0,32(sp)
    80003970:	64e2                	ld	s1,24(sp)
    80003972:	6942                	ld	s2,16(sp)
    80003974:	69a2                	ld	s3,8(sp)
    80003976:	6145                	addi	sp,sp,48
    80003978:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000397a:	0284a983          	lw	s3,40(s1)
    8000397e:	ffffd097          	auipc	ra,0xffffd
    80003982:	4ca080e7          	jalr	1226(ra) # 80000e48 <myproc>
    80003986:	5904                	lw	s1,48(a0)
    80003988:	413484b3          	sub	s1,s1,s3
    8000398c:	0014b493          	seqz	s1,s1
    80003990:	bfc1                	j	80003960 <holdingsleep+0x24>

0000000080003992 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003992:	1141                	addi	sp,sp,-16
    80003994:	e406                	sd	ra,8(sp)
    80003996:	e022                	sd	s0,0(sp)
    80003998:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000399a:	00005597          	auipc	a1,0x5
    8000399e:	c6e58593          	addi	a1,a1,-914 # 80008608 <syscalls+0x240>
    800039a2:	00011517          	auipc	a0,0x11
    800039a6:	bd650513          	addi	a0,a0,-1066 # 80014578 <ftable>
    800039aa:	00003097          	auipc	ra,0x3
    800039ae:	958080e7          	jalr	-1704(ra) # 80006302 <initlock>
}
    800039b2:	60a2                	ld	ra,8(sp)
    800039b4:	6402                	ld	s0,0(sp)
    800039b6:	0141                	addi	sp,sp,16
    800039b8:	8082                	ret

00000000800039ba <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039ba:	1101                	addi	sp,sp,-32
    800039bc:	ec06                	sd	ra,24(sp)
    800039be:	e822                	sd	s0,16(sp)
    800039c0:	e426                	sd	s1,8(sp)
    800039c2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039c4:	00011517          	auipc	a0,0x11
    800039c8:	bb450513          	addi	a0,a0,-1100 # 80014578 <ftable>
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	9c6080e7          	jalr	-1594(ra) # 80006392 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039d4:	00011497          	auipc	s1,0x11
    800039d8:	bbc48493          	addi	s1,s1,-1092 # 80014590 <ftable+0x18>
    800039dc:	00012717          	auipc	a4,0x12
    800039e0:	b5470713          	addi	a4,a4,-1196 # 80015530 <ftable+0xfb8>
    if(f->ref == 0){
    800039e4:	40dc                	lw	a5,4(s1)
    800039e6:	cf99                	beqz	a5,80003a04 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e8:	02848493          	addi	s1,s1,40
    800039ec:	fee49ce3          	bne	s1,a4,800039e4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039f0:	00011517          	auipc	a0,0x11
    800039f4:	b8850513          	addi	a0,a0,-1144 # 80014578 <ftable>
    800039f8:	00003097          	auipc	ra,0x3
    800039fc:	a4e080e7          	jalr	-1458(ra) # 80006446 <release>
  return 0;
    80003a00:	4481                	li	s1,0
    80003a02:	a819                	j	80003a18 <filealloc+0x5e>
      f->ref = 1;
    80003a04:	4785                	li	a5,1
    80003a06:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a08:	00011517          	auipc	a0,0x11
    80003a0c:	b7050513          	addi	a0,a0,-1168 # 80014578 <ftable>
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	a36080e7          	jalr	-1482(ra) # 80006446 <release>
}
    80003a18:	8526                	mv	a0,s1
    80003a1a:	60e2                	ld	ra,24(sp)
    80003a1c:	6442                	ld	s0,16(sp)
    80003a1e:	64a2                	ld	s1,8(sp)
    80003a20:	6105                	addi	sp,sp,32
    80003a22:	8082                	ret

0000000080003a24 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a24:	1101                	addi	sp,sp,-32
    80003a26:	ec06                	sd	ra,24(sp)
    80003a28:	e822                	sd	s0,16(sp)
    80003a2a:	e426                	sd	s1,8(sp)
    80003a2c:	1000                	addi	s0,sp,32
    80003a2e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a30:	00011517          	auipc	a0,0x11
    80003a34:	b4850513          	addi	a0,a0,-1208 # 80014578 <ftable>
    80003a38:	00003097          	auipc	ra,0x3
    80003a3c:	95a080e7          	jalr	-1702(ra) # 80006392 <acquire>
  if(f->ref < 1)
    80003a40:	40dc                	lw	a5,4(s1)
    80003a42:	02f05263          	blez	a5,80003a66 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a46:	2785                	addiw	a5,a5,1
    80003a48:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a4a:	00011517          	auipc	a0,0x11
    80003a4e:	b2e50513          	addi	a0,a0,-1234 # 80014578 <ftable>
    80003a52:	00003097          	auipc	ra,0x3
    80003a56:	9f4080e7          	jalr	-1548(ra) # 80006446 <release>
  return f;
}
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	60e2                	ld	ra,24(sp)
    80003a5e:	6442                	ld	s0,16(sp)
    80003a60:	64a2                	ld	s1,8(sp)
    80003a62:	6105                	addi	sp,sp,32
    80003a64:	8082                	ret
    panic("filedup");
    80003a66:	00005517          	auipc	a0,0x5
    80003a6a:	baa50513          	addi	a0,a0,-1110 # 80008610 <syscalls+0x248>
    80003a6e:	00002097          	auipc	ra,0x2
    80003a72:	3da080e7          	jalr	986(ra) # 80005e48 <panic>

0000000080003a76 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a76:	7139                	addi	sp,sp,-64
    80003a78:	fc06                	sd	ra,56(sp)
    80003a7a:	f822                	sd	s0,48(sp)
    80003a7c:	f426                	sd	s1,40(sp)
    80003a7e:	f04a                	sd	s2,32(sp)
    80003a80:	ec4e                	sd	s3,24(sp)
    80003a82:	e852                	sd	s4,16(sp)
    80003a84:	e456                	sd	s5,8(sp)
    80003a86:	0080                	addi	s0,sp,64
    80003a88:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a8a:	00011517          	auipc	a0,0x11
    80003a8e:	aee50513          	addi	a0,a0,-1298 # 80014578 <ftable>
    80003a92:	00003097          	auipc	ra,0x3
    80003a96:	900080e7          	jalr	-1792(ra) # 80006392 <acquire>
  if(f->ref < 1)
    80003a9a:	40dc                	lw	a5,4(s1)
    80003a9c:	06f05163          	blez	a5,80003afe <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003aa0:	37fd                	addiw	a5,a5,-1
    80003aa2:	0007871b          	sext.w	a4,a5
    80003aa6:	c0dc                	sw	a5,4(s1)
    80003aa8:	06e04363          	bgtz	a4,80003b0e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003aac:	0004a903          	lw	s2,0(s1)
    80003ab0:	0094ca83          	lbu	s5,9(s1)
    80003ab4:	0104ba03          	ld	s4,16(s1)
    80003ab8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003abc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ac0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ac4:	00011517          	auipc	a0,0x11
    80003ac8:	ab450513          	addi	a0,a0,-1356 # 80014578 <ftable>
    80003acc:	00003097          	auipc	ra,0x3
    80003ad0:	97a080e7          	jalr	-1670(ra) # 80006446 <release>

  if(ff.type == FD_PIPE){
    80003ad4:	4785                	li	a5,1
    80003ad6:	04f90d63          	beq	s2,a5,80003b30 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ada:	3979                	addiw	s2,s2,-2
    80003adc:	4785                	li	a5,1
    80003ade:	0527e063          	bltu	a5,s2,80003b1e <fileclose+0xa8>
    begin_op();
    80003ae2:	00000097          	auipc	ra,0x0
    80003ae6:	ac8080e7          	jalr	-1336(ra) # 800035aa <begin_op>
    iput(ff.ip);
    80003aea:	854e                	mv	a0,s3
    80003aec:	fffff097          	auipc	ra,0xfffff
    80003af0:	2a4080e7          	jalr	676(ra) # 80002d90 <iput>
    end_op();
    80003af4:	00000097          	auipc	ra,0x0
    80003af8:	b36080e7          	jalr	-1226(ra) # 8000362a <end_op>
    80003afc:	a00d                	j	80003b1e <fileclose+0xa8>
    panic("fileclose");
    80003afe:	00005517          	auipc	a0,0x5
    80003b02:	b1a50513          	addi	a0,a0,-1254 # 80008618 <syscalls+0x250>
    80003b06:	00002097          	auipc	ra,0x2
    80003b0a:	342080e7          	jalr	834(ra) # 80005e48 <panic>
    release(&ftable.lock);
    80003b0e:	00011517          	auipc	a0,0x11
    80003b12:	a6a50513          	addi	a0,a0,-1430 # 80014578 <ftable>
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	930080e7          	jalr	-1744(ra) # 80006446 <release>
  }
}
    80003b1e:	70e2                	ld	ra,56(sp)
    80003b20:	7442                	ld	s0,48(sp)
    80003b22:	74a2                	ld	s1,40(sp)
    80003b24:	7902                	ld	s2,32(sp)
    80003b26:	69e2                	ld	s3,24(sp)
    80003b28:	6a42                	ld	s4,16(sp)
    80003b2a:	6aa2                	ld	s5,8(sp)
    80003b2c:	6121                	addi	sp,sp,64
    80003b2e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b30:	85d6                	mv	a1,s5
    80003b32:	8552                	mv	a0,s4
    80003b34:	00000097          	auipc	ra,0x0
    80003b38:	34c080e7          	jalr	844(ra) # 80003e80 <pipeclose>
    80003b3c:	b7cd                	j	80003b1e <fileclose+0xa8>

0000000080003b3e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b3e:	715d                	addi	sp,sp,-80
    80003b40:	e486                	sd	ra,72(sp)
    80003b42:	e0a2                	sd	s0,64(sp)
    80003b44:	fc26                	sd	s1,56(sp)
    80003b46:	f84a                	sd	s2,48(sp)
    80003b48:	f44e                	sd	s3,40(sp)
    80003b4a:	0880                	addi	s0,sp,80
    80003b4c:	84aa                	mv	s1,a0
    80003b4e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b50:	ffffd097          	auipc	ra,0xffffd
    80003b54:	2f8080e7          	jalr	760(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b58:	409c                	lw	a5,0(s1)
    80003b5a:	37f9                	addiw	a5,a5,-2
    80003b5c:	4705                	li	a4,1
    80003b5e:	04f76763          	bltu	a4,a5,80003bac <filestat+0x6e>
    80003b62:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b64:	6c88                	ld	a0,24(s1)
    80003b66:	fffff097          	auipc	ra,0xfffff
    80003b6a:	fc6080e7          	jalr	-58(ra) # 80002b2c <ilock>
    stati(f->ip, &st);
    80003b6e:	fb840593          	addi	a1,s0,-72
    80003b72:	6c88                	ld	a0,24(s1)
    80003b74:	fffff097          	auipc	ra,0xfffff
    80003b78:	2ec080e7          	jalr	748(ra) # 80002e60 <stati>
    iunlock(f->ip);
    80003b7c:	6c88                	ld	a0,24(s1)
    80003b7e:	fffff097          	auipc	ra,0xfffff
    80003b82:	070080e7          	jalr	112(ra) # 80002bee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b86:	46e1                	li	a3,24
    80003b88:	fb840613          	addi	a2,s0,-72
    80003b8c:	85ce                	mv	a1,s3
    80003b8e:	05093503          	ld	a0,80(s2)
    80003b92:	ffffd097          	auipc	ra,0xffffd
    80003b96:	f78080e7          	jalr	-136(ra) # 80000b0a <copyout>
    80003b9a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b9e:	60a6                	ld	ra,72(sp)
    80003ba0:	6406                	ld	s0,64(sp)
    80003ba2:	74e2                	ld	s1,56(sp)
    80003ba4:	7942                	ld	s2,48(sp)
    80003ba6:	79a2                	ld	s3,40(sp)
    80003ba8:	6161                	addi	sp,sp,80
    80003baa:	8082                	ret
  return -1;
    80003bac:	557d                	li	a0,-1
    80003bae:	bfc5                	j	80003b9e <filestat+0x60>

0000000080003bb0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bb0:	7179                	addi	sp,sp,-48
    80003bb2:	f406                	sd	ra,40(sp)
    80003bb4:	f022                	sd	s0,32(sp)
    80003bb6:	ec26                	sd	s1,24(sp)
    80003bb8:	e84a                	sd	s2,16(sp)
    80003bba:	e44e                	sd	s3,8(sp)
    80003bbc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bbe:	00854783          	lbu	a5,8(a0)
    80003bc2:	c3d5                	beqz	a5,80003c66 <fileread+0xb6>
    80003bc4:	84aa                	mv	s1,a0
    80003bc6:	89ae                	mv	s3,a1
    80003bc8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bca:	411c                	lw	a5,0(a0)
    80003bcc:	4705                	li	a4,1
    80003bce:	04e78963          	beq	a5,a4,80003c20 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bd2:	470d                	li	a4,3
    80003bd4:	04e78d63          	beq	a5,a4,80003c2e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bd8:	4709                	li	a4,2
    80003bda:	06e79e63          	bne	a5,a4,80003c56 <fileread+0xa6>
    ilock(f->ip);
    80003bde:	6d08                	ld	a0,24(a0)
    80003be0:	fffff097          	auipc	ra,0xfffff
    80003be4:	f4c080e7          	jalr	-180(ra) # 80002b2c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003be8:	874a                	mv	a4,s2
    80003bea:	5094                	lw	a3,32(s1)
    80003bec:	864e                	mv	a2,s3
    80003bee:	4585                	li	a1,1
    80003bf0:	6c88                	ld	a0,24(s1)
    80003bf2:	fffff097          	auipc	ra,0xfffff
    80003bf6:	298080e7          	jalr	664(ra) # 80002e8a <readi>
    80003bfa:	892a                	mv	s2,a0
    80003bfc:	00a05563          	blez	a0,80003c06 <fileread+0x56>
      f->off += r;
    80003c00:	509c                	lw	a5,32(s1)
    80003c02:	9fa9                	addw	a5,a5,a0
    80003c04:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c06:	6c88                	ld	a0,24(s1)
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	fe6080e7          	jalr	-26(ra) # 80002bee <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c10:	854a                	mv	a0,s2
    80003c12:	70a2                	ld	ra,40(sp)
    80003c14:	7402                	ld	s0,32(sp)
    80003c16:	64e2                	ld	s1,24(sp)
    80003c18:	6942                	ld	s2,16(sp)
    80003c1a:	69a2                	ld	s3,8(sp)
    80003c1c:	6145                	addi	sp,sp,48
    80003c1e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c20:	6908                	ld	a0,16(a0)
    80003c22:	00000097          	auipc	ra,0x0
    80003c26:	3c8080e7          	jalr	968(ra) # 80003fea <piperead>
    80003c2a:	892a                	mv	s2,a0
    80003c2c:	b7d5                	j	80003c10 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c2e:	02451783          	lh	a5,36(a0)
    80003c32:	03079693          	slli	a3,a5,0x30
    80003c36:	92c1                	srli	a3,a3,0x30
    80003c38:	4725                	li	a4,9
    80003c3a:	02d76863          	bltu	a4,a3,80003c6a <fileread+0xba>
    80003c3e:	0792                	slli	a5,a5,0x4
    80003c40:	00011717          	auipc	a4,0x11
    80003c44:	89870713          	addi	a4,a4,-1896 # 800144d8 <devsw>
    80003c48:	97ba                	add	a5,a5,a4
    80003c4a:	639c                	ld	a5,0(a5)
    80003c4c:	c38d                	beqz	a5,80003c6e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c4e:	4505                	li	a0,1
    80003c50:	9782                	jalr	a5
    80003c52:	892a                	mv	s2,a0
    80003c54:	bf75                	j	80003c10 <fileread+0x60>
    panic("fileread");
    80003c56:	00005517          	auipc	a0,0x5
    80003c5a:	9d250513          	addi	a0,a0,-1582 # 80008628 <syscalls+0x260>
    80003c5e:	00002097          	auipc	ra,0x2
    80003c62:	1ea080e7          	jalr	490(ra) # 80005e48 <panic>
    return -1;
    80003c66:	597d                	li	s2,-1
    80003c68:	b765                	j	80003c10 <fileread+0x60>
      return -1;
    80003c6a:	597d                	li	s2,-1
    80003c6c:	b755                	j	80003c10 <fileread+0x60>
    80003c6e:	597d                	li	s2,-1
    80003c70:	b745                	j	80003c10 <fileread+0x60>

0000000080003c72 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c72:	715d                	addi	sp,sp,-80
    80003c74:	e486                	sd	ra,72(sp)
    80003c76:	e0a2                	sd	s0,64(sp)
    80003c78:	fc26                	sd	s1,56(sp)
    80003c7a:	f84a                	sd	s2,48(sp)
    80003c7c:	f44e                	sd	s3,40(sp)
    80003c7e:	f052                	sd	s4,32(sp)
    80003c80:	ec56                	sd	s5,24(sp)
    80003c82:	e85a                	sd	s6,16(sp)
    80003c84:	e45e                	sd	s7,8(sp)
    80003c86:	e062                	sd	s8,0(sp)
    80003c88:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c8a:	00954783          	lbu	a5,9(a0)
    80003c8e:	10078663          	beqz	a5,80003d9a <filewrite+0x128>
    80003c92:	892a                	mv	s2,a0
    80003c94:	8aae                	mv	s5,a1
    80003c96:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c98:	411c                	lw	a5,0(a0)
    80003c9a:	4705                	li	a4,1
    80003c9c:	02e78263          	beq	a5,a4,80003cc0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003ca0:	470d                	li	a4,3
    80003ca2:	02e78663          	beq	a5,a4,80003cce <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ca6:	4709                	li	a4,2
    80003ca8:	0ee79163          	bne	a5,a4,80003d8a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cac:	0ac05d63          	blez	a2,80003d66 <filewrite+0xf4>
    int i = 0;
    80003cb0:	4981                	li	s3,0
    80003cb2:	6b05                	lui	s6,0x1
    80003cb4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cb8:	6b85                	lui	s7,0x1
    80003cba:	c00b8b9b          	addiw	s7,s7,-1024
    80003cbe:	a861                	j	80003d56 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cc0:	6908                	ld	a0,16(a0)
    80003cc2:	00000097          	auipc	ra,0x0
    80003cc6:	22e080e7          	jalr	558(ra) # 80003ef0 <pipewrite>
    80003cca:	8a2a                	mv	s4,a0
    80003ccc:	a045                	j	80003d6c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cce:	02451783          	lh	a5,36(a0)
    80003cd2:	03079693          	slli	a3,a5,0x30
    80003cd6:	92c1                	srli	a3,a3,0x30
    80003cd8:	4725                	li	a4,9
    80003cda:	0cd76263          	bltu	a4,a3,80003d9e <filewrite+0x12c>
    80003cde:	0792                	slli	a5,a5,0x4
    80003ce0:	00010717          	auipc	a4,0x10
    80003ce4:	7f870713          	addi	a4,a4,2040 # 800144d8 <devsw>
    80003ce8:	97ba                	add	a5,a5,a4
    80003cea:	679c                	ld	a5,8(a5)
    80003cec:	cbdd                	beqz	a5,80003da2 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cee:	4505                	li	a0,1
    80003cf0:	9782                	jalr	a5
    80003cf2:	8a2a                	mv	s4,a0
    80003cf4:	a8a5                	j	80003d6c <filewrite+0xfa>
    80003cf6:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cfa:	00000097          	auipc	ra,0x0
    80003cfe:	8b0080e7          	jalr	-1872(ra) # 800035aa <begin_op>
      ilock(f->ip);
    80003d02:	01893503          	ld	a0,24(s2)
    80003d06:	fffff097          	auipc	ra,0xfffff
    80003d0a:	e26080e7          	jalr	-474(ra) # 80002b2c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d0e:	8762                	mv	a4,s8
    80003d10:	02092683          	lw	a3,32(s2)
    80003d14:	01598633          	add	a2,s3,s5
    80003d18:	4585                	li	a1,1
    80003d1a:	01893503          	ld	a0,24(s2)
    80003d1e:	fffff097          	auipc	ra,0xfffff
    80003d22:	264080e7          	jalr	612(ra) # 80002f82 <writei>
    80003d26:	84aa                	mv	s1,a0
    80003d28:	00a05763          	blez	a0,80003d36 <filewrite+0xc4>
        f->off += r;
    80003d2c:	02092783          	lw	a5,32(s2)
    80003d30:	9fa9                	addw	a5,a5,a0
    80003d32:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d36:	01893503          	ld	a0,24(s2)
    80003d3a:	fffff097          	auipc	ra,0xfffff
    80003d3e:	eb4080e7          	jalr	-332(ra) # 80002bee <iunlock>
      end_op();
    80003d42:	00000097          	auipc	ra,0x0
    80003d46:	8e8080e7          	jalr	-1816(ra) # 8000362a <end_op>

      if(r != n1){
    80003d4a:	009c1f63          	bne	s8,s1,80003d68 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d4e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d52:	0149db63          	bge	s3,s4,80003d68 <filewrite+0xf6>
      int n1 = n - i;
    80003d56:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d5a:	84be                	mv	s1,a5
    80003d5c:	2781                	sext.w	a5,a5
    80003d5e:	f8fb5ce3          	bge	s6,a5,80003cf6 <filewrite+0x84>
    80003d62:	84de                	mv	s1,s7
    80003d64:	bf49                	j	80003cf6 <filewrite+0x84>
    int i = 0;
    80003d66:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d68:	013a1f63          	bne	s4,s3,80003d86 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d6c:	8552                	mv	a0,s4
    80003d6e:	60a6                	ld	ra,72(sp)
    80003d70:	6406                	ld	s0,64(sp)
    80003d72:	74e2                	ld	s1,56(sp)
    80003d74:	7942                	ld	s2,48(sp)
    80003d76:	79a2                	ld	s3,40(sp)
    80003d78:	7a02                	ld	s4,32(sp)
    80003d7a:	6ae2                	ld	s5,24(sp)
    80003d7c:	6b42                	ld	s6,16(sp)
    80003d7e:	6ba2                	ld	s7,8(sp)
    80003d80:	6c02                	ld	s8,0(sp)
    80003d82:	6161                	addi	sp,sp,80
    80003d84:	8082                	ret
    ret = (i == n ? n : -1);
    80003d86:	5a7d                	li	s4,-1
    80003d88:	b7d5                	j	80003d6c <filewrite+0xfa>
    panic("filewrite");
    80003d8a:	00005517          	auipc	a0,0x5
    80003d8e:	8ae50513          	addi	a0,a0,-1874 # 80008638 <syscalls+0x270>
    80003d92:	00002097          	auipc	ra,0x2
    80003d96:	0b6080e7          	jalr	182(ra) # 80005e48 <panic>
    return -1;
    80003d9a:	5a7d                	li	s4,-1
    80003d9c:	bfc1                	j	80003d6c <filewrite+0xfa>
      return -1;
    80003d9e:	5a7d                	li	s4,-1
    80003da0:	b7f1                	j	80003d6c <filewrite+0xfa>
    80003da2:	5a7d                	li	s4,-1
    80003da4:	b7e1                	j	80003d6c <filewrite+0xfa>

0000000080003da6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003da6:	7179                	addi	sp,sp,-48
    80003da8:	f406                	sd	ra,40(sp)
    80003daa:	f022                	sd	s0,32(sp)
    80003dac:	ec26                	sd	s1,24(sp)
    80003dae:	e84a                	sd	s2,16(sp)
    80003db0:	e44e                	sd	s3,8(sp)
    80003db2:	e052                	sd	s4,0(sp)
    80003db4:	1800                	addi	s0,sp,48
    80003db6:	84aa                	mv	s1,a0
    80003db8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dba:	0005b023          	sd	zero,0(a1)
    80003dbe:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dc2:	00000097          	auipc	ra,0x0
    80003dc6:	bf8080e7          	jalr	-1032(ra) # 800039ba <filealloc>
    80003dca:	e088                	sd	a0,0(s1)
    80003dcc:	c551                	beqz	a0,80003e58 <pipealloc+0xb2>
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	bec080e7          	jalr	-1044(ra) # 800039ba <filealloc>
    80003dd6:	00aa3023          	sd	a0,0(s4)
    80003dda:	c92d                	beqz	a0,80003e4c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ddc:	ffffc097          	auipc	ra,0xffffc
    80003de0:	33c080e7          	jalr	828(ra) # 80000118 <kalloc>
    80003de4:	892a                	mv	s2,a0
    80003de6:	c125                	beqz	a0,80003e46 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003de8:	4985                	li	s3,1
    80003dea:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dee:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003df2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003df6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dfa:	00005597          	auipc	a1,0x5
    80003dfe:	84e58593          	addi	a1,a1,-1970 # 80008648 <syscalls+0x280>
    80003e02:	00002097          	auipc	ra,0x2
    80003e06:	500080e7          	jalr	1280(ra) # 80006302 <initlock>
  (*f0)->type = FD_PIPE;
    80003e0a:	609c                	ld	a5,0(s1)
    80003e0c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e10:	609c                	ld	a5,0(s1)
    80003e12:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e16:	609c                	ld	a5,0(s1)
    80003e18:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e1c:	609c                	ld	a5,0(s1)
    80003e1e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e22:	000a3783          	ld	a5,0(s4)
    80003e26:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e2a:	000a3783          	ld	a5,0(s4)
    80003e2e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e32:	000a3783          	ld	a5,0(s4)
    80003e36:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e3a:	000a3783          	ld	a5,0(s4)
    80003e3e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e42:	4501                	li	a0,0
    80003e44:	a025                	j	80003e6c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e46:	6088                	ld	a0,0(s1)
    80003e48:	e501                	bnez	a0,80003e50 <pipealloc+0xaa>
    80003e4a:	a039                	j	80003e58 <pipealloc+0xb2>
    80003e4c:	6088                	ld	a0,0(s1)
    80003e4e:	c51d                	beqz	a0,80003e7c <pipealloc+0xd6>
    fileclose(*f0);
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	c26080e7          	jalr	-986(ra) # 80003a76 <fileclose>
  if(*f1)
    80003e58:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e5c:	557d                	li	a0,-1
  if(*f1)
    80003e5e:	c799                	beqz	a5,80003e6c <pipealloc+0xc6>
    fileclose(*f1);
    80003e60:	853e                	mv	a0,a5
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	c14080e7          	jalr	-1004(ra) # 80003a76 <fileclose>
  return -1;
    80003e6a:	557d                	li	a0,-1
}
    80003e6c:	70a2                	ld	ra,40(sp)
    80003e6e:	7402                	ld	s0,32(sp)
    80003e70:	64e2                	ld	s1,24(sp)
    80003e72:	6942                	ld	s2,16(sp)
    80003e74:	69a2                	ld	s3,8(sp)
    80003e76:	6a02                	ld	s4,0(sp)
    80003e78:	6145                	addi	sp,sp,48
    80003e7a:	8082                	ret
  return -1;
    80003e7c:	557d                	li	a0,-1
    80003e7e:	b7fd                	j	80003e6c <pipealloc+0xc6>

0000000080003e80 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e80:	1101                	addi	sp,sp,-32
    80003e82:	ec06                	sd	ra,24(sp)
    80003e84:	e822                	sd	s0,16(sp)
    80003e86:	e426                	sd	s1,8(sp)
    80003e88:	e04a                	sd	s2,0(sp)
    80003e8a:	1000                	addi	s0,sp,32
    80003e8c:	84aa                	mv	s1,a0
    80003e8e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e90:	00002097          	auipc	ra,0x2
    80003e94:	502080e7          	jalr	1282(ra) # 80006392 <acquire>
  if(writable){
    80003e98:	02090d63          	beqz	s2,80003ed2 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e9c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ea0:	21848513          	addi	a0,s1,536
    80003ea4:	ffffd097          	auipc	ra,0xffffd
    80003ea8:	7ec080e7          	jalr	2028(ra) # 80001690 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eac:	2204b783          	ld	a5,544(s1)
    80003eb0:	eb95                	bnez	a5,80003ee4 <pipeclose+0x64>
    release(&pi->lock);
    80003eb2:	8526                	mv	a0,s1
    80003eb4:	00002097          	auipc	ra,0x2
    80003eb8:	592080e7          	jalr	1426(ra) # 80006446 <release>
    kfree((char*)pi);
    80003ebc:	8526                	mv	a0,s1
    80003ebe:	ffffc097          	auipc	ra,0xffffc
    80003ec2:	15e080e7          	jalr	350(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ec6:	60e2                	ld	ra,24(sp)
    80003ec8:	6442                	ld	s0,16(sp)
    80003eca:	64a2                	ld	s1,8(sp)
    80003ecc:	6902                	ld	s2,0(sp)
    80003ece:	6105                	addi	sp,sp,32
    80003ed0:	8082                	ret
    pi->readopen = 0;
    80003ed2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ed6:	21c48513          	addi	a0,s1,540
    80003eda:	ffffd097          	auipc	ra,0xffffd
    80003ede:	7b6080e7          	jalr	1974(ra) # 80001690 <wakeup>
    80003ee2:	b7e9                	j	80003eac <pipeclose+0x2c>
    release(&pi->lock);
    80003ee4:	8526                	mv	a0,s1
    80003ee6:	00002097          	auipc	ra,0x2
    80003eea:	560080e7          	jalr	1376(ra) # 80006446 <release>
}
    80003eee:	bfe1                	j	80003ec6 <pipeclose+0x46>

0000000080003ef0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ef0:	7159                	addi	sp,sp,-112
    80003ef2:	f486                	sd	ra,104(sp)
    80003ef4:	f0a2                	sd	s0,96(sp)
    80003ef6:	eca6                	sd	s1,88(sp)
    80003ef8:	e8ca                	sd	s2,80(sp)
    80003efa:	e4ce                	sd	s3,72(sp)
    80003efc:	e0d2                	sd	s4,64(sp)
    80003efe:	fc56                	sd	s5,56(sp)
    80003f00:	f85a                	sd	s6,48(sp)
    80003f02:	f45e                	sd	s7,40(sp)
    80003f04:	f062                	sd	s8,32(sp)
    80003f06:	ec66                	sd	s9,24(sp)
    80003f08:	1880                	addi	s0,sp,112
    80003f0a:	84aa                	mv	s1,a0
    80003f0c:	8aae                	mv	s5,a1
    80003f0e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f10:	ffffd097          	auipc	ra,0xffffd
    80003f14:	f38080e7          	jalr	-200(ra) # 80000e48 <myproc>
    80003f18:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	00002097          	auipc	ra,0x2
    80003f20:	476080e7          	jalr	1142(ra) # 80006392 <acquire>
  while(i < n){
    80003f24:	0d405163          	blez	s4,80003fe6 <pipewrite+0xf6>
    80003f28:	8ba6                	mv	s7,s1
  int i = 0;
    80003f2a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f2c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f2e:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f32:	21c48c13          	addi	s8,s1,540
    80003f36:	a08d                	j	80003f98 <pipewrite+0xa8>
      release(&pi->lock);
    80003f38:	8526                	mv	a0,s1
    80003f3a:	00002097          	auipc	ra,0x2
    80003f3e:	50c080e7          	jalr	1292(ra) # 80006446 <release>
      return -1;
    80003f42:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f44:	854a                	mv	a0,s2
    80003f46:	70a6                	ld	ra,104(sp)
    80003f48:	7406                	ld	s0,96(sp)
    80003f4a:	64e6                	ld	s1,88(sp)
    80003f4c:	6946                	ld	s2,80(sp)
    80003f4e:	69a6                	ld	s3,72(sp)
    80003f50:	6a06                	ld	s4,64(sp)
    80003f52:	7ae2                	ld	s5,56(sp)
    80003f54:	7b42                	ld	s6,48(sp)
    80003f56:	7ba2                	ld	s7,40(sp)
    80003f58:	7c02                	ld	s8,32(sp)
    80003f5a:	6ce2                	ld	s9,24(sp)
    80003f5c:	6165                	addi	sp,sp,112
    80003f5e:	8082                	ret
      wakeup(&pi->nread);
    80003f60:	8566                	mv	a0,s9
    80003f62:	ffffd097          	auipc	ra,0xffffd
    80003f66:	72e080e7          	jalr	1838(ra) # 80001690 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f6a:	85de                	mv	a1,s7
    80003f6c:	8562                	mv	a0,s8
    80003f6e:	ffffd097          	auipc	ra,0xffffd
    80003f72:	596080e7          	jalr	1430(ra) # 80001504 <sleep>
    80003f76:	a839                	j	80003f94 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f78:	21c4a783          	lw	a5,540(s1)
    80003f7c:	0017871b          	addiw	a4,a5,1
    80003f80:	20e4ae23          	sw	a4,540(s1)
    80003f84:	1ff7f793          	andi	a5,a5,511
    80003f88:	97a6                	add	a5,a5,s1
    80003f8a:	f9f44703          	lbu	a4,-97(s0)
    80003f8e:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f92:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f94:	03495d63          	bge	s2,s4,80003fce <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f98:	2204a783          	lw	a5,544(s1)
    80003f9c:	dfd1                	beqz	a5,80003f38 <pipewrite+0x48>
    80003f9e:	0289a783          	lw	a5,40(s3)
    80003fa2:	fbd9                	bnez	a5,80003f38 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fa4:	2184a783          	lw	a5,536(s1)
    80003fa8:	21c4a703          	lw	a4,540(s1)
    80003fac:	2007879b          	addiw	a5,a5,512
    80003fb0:	faf708e3          	beq	a4,a5,80003f60 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fb4:	4685                	li	a3,1
    80003fb6:	01590633          	add	a2,s2,s5
    80003fba:	f9f40593          	addi	a1,s0,-97
    80003fbe:	0509b503          	ld	a0,80(s3)
    80003fc2:	ffffd097          	auipc	ra,0xffffd
    80003fc6:	bd4080e7          	jalr	-1068(ra) # 80000b96 <copyin>
    80003fca:	fb6517e3          	bne	a0,s6,80003f78 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fce:	21848513          	addi	a0,s1,536
    80003fd2:	ffffd097          	auipc	ra,0xffffd
    80003fd6:	6be080e7          	jalr	1726(ra) # 80001690 <wakeup>
  release(&pi->lock);
    80003fda:	8526                	mv	a0,s1
    80003fdc:	00002097          	auipc	ra,0x2
    80003fe0:	46a080e7          	jalr	1130(ra) # 80006446 <release>
  return i;
    80003fe4:	b785                	j	80003f44 <pipewrite+0x54>
  int i = 0;
    80003fe6:	4901                	li	s2,0
    80003fe8:	b7dd                	j	80003fce <pipewrite+0xde>

0000000080003fea <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fea:	715d                	addi	sp,sp,-80
    80003fec:	e486                	sd	ra,72(sp)
    80003fee:	e0a2                	sd	s0,64(sp)
    80003ff0:	fc26                	sd	s1,56(sp)
    80003ff2:	f84a                	sd	s2,48(sp)
    80003ff4:	f44e                	sd	s3,40(sp)
    80003ff6:	f052                	sd	s4,32(sp)
    80003ff8:	ec56                	sd	s5,24(sp)
    80003ffa:	e85a                	sd	s6,16(sp)
    80003ffc:	0880                	addi	s0,sp,80
    80003ffe:	84aa                	mv	s1,a0
    80004000:	892e                	mv	s2,a1
    80004002:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004004:	ffffd097          	auipc	ra,0xffffd
    80004008:	e44080e7          	jalr	-444(ra) # 80000e48 <myproc>
    8000400c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000400e:	8b26                	mv	s6,s1
    80004010:	8526                	mv	a0,s1
    80004012:	00002097          	auipc	ra,0x2
    80004016:	380080e7          	jalr	896(ra) # 80006392 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000401a:	2184a703          	lw	a4,536(s1)
    8000401e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004022:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004026:	02f71463          	bne	a4,a5,8000404e <piperead+0x64>
    8000402a:	2244a783          	lw	a5,548(s1)
    8000402e:	c385                	beqz	a5,8000404e <piperead+0x64>
    if(pr->killed){
    80004030:	028a2783          	lw	a5,40(s4)
    80004034:	ebc1                	bnez	a5,800040c4 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004036:	85da                	mv	a1,s6
    80004038:	854e                	mv	a0,s3
    8000403a:	ffffd097          	auipc	ra,0xffffd
    8000403e:	4ca080e7          	jalr	1226(ra) # 80001504 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004042:	2184a703          	lw	a4,536(s1)
    80004046:	21c4a783          	lw	a5,540(s1)
    8000404a:	fef700e3          	beq	a4,a5,8000402a <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000404e:	09505263          	blez	s5,800040d2 <piperead+0xe8>
    80004052:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004054:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004056:	2184a783          	lw	a5,536(s1)
    8000405a:	21c4a703          	lw	a4,540(s1)
    8000405e:	02f70d63          	beq	a4,a5,80004098 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004062:	0017871b          	addiw	a4,a5,1
    80004066:	20e4ac23          	sw	a4,536(s1)
    8000406a:	1ff7f793          	andi	a5,a5,511
    8000406e:	97a6                	add	a5,a5,s1
    80004070:	0187c783          	lbu	a5,24(a5)
    80004074:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004078:	4685                	li	a3,1
    8000407a:	fbf40613          	addi	a2,s0,-65
    8000407e:	85ca                	mv	a1,s2
    80004080:	050a3503          	ld	a0,80(s4)
    80004084:	ffffd097          	auipc	ra,0xffffd
    80004088:	a86080e7          	jalr	-1402(ra) # 80000b0a <copyout>
    8000408c:	01650663          	beq	a0,s6,80004098 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004090:	2985                	addiw	s3,s3,1
    80004092:	0905                	addi	s2,s2,1
    80004094:	fd3a91e3          	bne	s5,s3,80004056 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004098:	21c48513          	addi	a0,s1,540
    8000409c:	ffffd097          	auipc	ra,0xffffd
    800040a0:	5f4080e7          	jalr	1524(ra) # 80001690 <wakeup>
  release(&pi->lock);
    800040a4:	8526                	mv	a0,s1
    800040a6:	00002097          	auipc	ra,0x2
    800040aa:	3a0080e7          	jalr	928(ra) # 80006446 <release>
  return i;
}
    800040ae:	854e                	mv	a0,s3
    800040b0:	60a6                	ld	ra,72(sp)
    800040b2:	6406                	ld	s0,64(sp)
    800040b4:	74e2                	ld	s1,56(sp)
    800040b6:	7942                	ld	s2,48(sp)
    800040b8:	79a2                	ld	s3,40(sp)
    800040ba:	7a02                	ld	s4,32(sp)
    800040bc:	6ae2                	ld	s5,24(sp)
    800040be:	6b42                	ld	s6,16(sp)
    800040c0:	6161                	addi	sp,sp,80
    800040c2:	8082                	ret
      release(&pi->lock);
    800040c4:	8526                	mv	a0,s1
    800040c6:	00002097          	auipc	ra,0x2
    800040ca:	380080e7          	jalr	896(ra) # 80006446 <release>
      return -1;
    800040ce:	59fd                	li	s3,-1
    800040d0:	bff9                	j	800040ae <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040d2:	4981                	li	s3,0
    800040d4:	b7d1                	j	80004098 <piperead+0xae>

00000000800040d6 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040d6:	df010113          	addi	sp,sp,-528
    800040da:	20113423          	sd	ra,520(sp)
    800040de:	20813023          	sd	s0,512(sp)
    800040e2:	ffa6                	sd	s1,504(sp)
    800040e4:	fbca                	sd	s2,496(sp)
    800040e6:	f7ce                	sd	s3,488(sp)
    800040e8:	f3d2                	sd	s4,480(sp)
    800040ea:	efd6                	sd	s5,472(sp)
    800040ec:	ebda                	sd	s6,464(sp)
    800040ee:	e7de                	sd	s7,456(sp)
    800040f0:	e3e2                	sd	s8,448(sp)
    800040f2:	ff66                	sd	s9,440(sp)
    800040f4:	fb6a                	sd	s10,432(sp)
    800040f6:	f76e                	sd	s11,424(sp)
    800040f8:	0c00                	addi	s0,sp,528
    800040fa:	84aa                	mv	s1,a0
    800040fc:	dea43c23          	sd	a0,-520(s0)
    80004100:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	d44080e7          	jalr	-700(ra) # 80000e48 <myproc>
    8000410c:	892a                	mv	s2,a0

  begin_op();
    8000410e:	fffff097          	auipc	ra,0xfffff
    80004112:	49c080e7          	jalr	1180(ra) # 800035aa <begin_op>

  if((ip = namei(path)) == 0){
    80004116:	8526                	mv	a0,s1
    80004118:	fffff097          	auipc	ra,0xfffff
    8000411c:	276080e7          	jalr	630(ra) # 8000338e <namei>
    80004120:	c92d                	beqz	a0,80004192 <exec+0xbc>
    80004122:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	a08080e7          	jalr	-1528(ra) # 80002b2c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000412c:	04000713          	li	a4,64
    80004130:	4681                	li	a3,0
    80004132:	e5040613          	addi	a2,s0,-432
    80004136:	4581                	li	a1,0
    80004138:	8526                	mv	a0,s1
    8000413a:	fffff097          	auipc	ra,0xfffff
    8000413e:	d50080e7          	jalr	-688(ra) # 80002e8a <readi>
    80004142:	04000793          	li	a5,64
    80004146:	00f51a63          	bne	a0,a5,8000415a <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    8000414a:	e5042703          	lw	a4,-432(s0)
    8000414e:	464c47b7          	lui	a5,0x464c4
    80004152:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004156:	04f70463          	beq	a4,a5,8000419e <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000415a:	8526                	mv	a0,s1
    8000415c:	fffff097          	auipc	ra,0xfffff
    80004160:	cdc080e7          	jalr	-804(ra) # 80002e38 <iunlockput>
    end_op();
    80004164:	fffff097          	auipc	ra,0xfffff
    80004168:	4c6080e7          	jalr	1222(ra) # 8000362a <end_op>
  }
  return -1;
    8000416c:	557d                	li	a0,-1
}
    8000416e:	20813083          	ld	ra,520(sp)
    80004172:	20013403          	ld	s0,512(sp)
    80004176:	74fe                	ld	s1,504(sp)
    80004178:	795e                	ld	s2,496(sp)
    8000417a:	79be                	ld	s3,488(sp)
    8000417c:	7a1e                	ld	s4,480(sp)
    8000417e:	6afe                	ld	s5,472(sp)
    80004180:	6b5e                	ld	s6,464(sp)
    80004182:	6bbe                	ld	s7,456(sp)
    80004184:	6c1e                	ld	s8,448(sp)
    80004186:	7cfa                	ld	s9,440(sp)
    80004188:	7d5a                	ld	s10,432(sp)
    8000418a:	7dba                	ld	s11,424(sp)
    8000418c:	21010113          	addi	sp,sp,528
    80004190:	8082                	ret
    end_op();
    80004192:	fffff097          	auipc	ra,0xfffff
    80004196:	498080e7          	jalr	1176(ra) # 8000362a <end_op>
    return -1;
    8000419a:	557d                	li	a0,-1
    8000419c:	bfc9                	j	8000416e <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000419e:	854a                	mv	a0,s2
    800041a0:	ffffd097          	auipc	ra,0xffffd
    800041a4:	d6c080e7          	jalr	-660(ra) # 80000f0c <proc_pagetable>
    800041a8:	8baa                	mv	s7,a0
    800041aa:	d945                	beqz	a0,8000415a <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ac:	e7042983          	lw	s3,-400(s0)
    800041b0:	e8845783          	lhu	a5,-376(s0)
    800041b4:	c7ad                	beqz	a5,8000421e <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041b6:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b8:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800041ba:	6c85                	lui	s9,0x1
    800041bc:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041c0:	def43823          	sd	a5,-528(s0)
    800041c4:	a42d                	j	800043ee <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041c6:	00004517          	auipc	a0,0x4
    800041ca:	48a50513          	addi	a0,a0,1162 # 80008650 <syscalls+0x288>
    800041ce:	00002097          	auipc	ra,0x2
    800041d2:	c7a080e7          	jalr	-902(ra) # 80005e48 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041d6:	8756                	mv	a4,s5
    800041d8:	012d86bb          	addw	a3,s11,s2
    800041dc:	4581                	li	a1,0
    800041de:	8526                	mv	a0,s1
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	caa080e7          	jalr	-854(ra) # 80002e8a <readi>
    800041e8:	2501                	sext.w	a0,a0
    800041ea:	1aaa9963          	bne	s5,a0,8000439c <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041ee:	6785                	lui	a5,0x1
    800041f0:	0127893b          	addw	s2,a5,s2
    800041f4:	77fd                	lui	a5,0xfffff
    800041f6:	01478a3b          	addw	s4,a5,s4
    800041fa:	1f897163          	bgeu	s2,s8,800043dc <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041fe:	02091593          	slli	a1,s2,0x20
    80004202:	9181                	srli	a1,a1,0x20
    80004204:	95ea                	add	a1,a1,s10
    80004206:	855e                	mv	a0,s7
    80004208:	ffffc097          	auipc	ra,0xffffc
    8000420c:	2fe080e7          	jalr	766(ra) # 80000506 <walkaddr>
    80004210:	862a                	mv	a2,a0
    if(pa == 0)
    80004212:	d955                	beqz	a0,800041c6 <exec+0xf0>
      n = PGSIZE;
    80004214:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004216:	fd9a70e3          	bgeu	s4,s9,800041d6 <exec+0x100>
      n = sz - i;
    8000421a:	8ad2                	mv	s5,s4
    8000421c:	bf6d                	j	800041d6 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000421e:	4901                	li	s2,0
  iunlockput(ip);
    80004220:	8526                	mv	a0,s1
    80004222:	fffff097          	auipc	ra,0xfffff
    80004226:	c16080e7          	jalr	-1002(ra) # 80002e38 <iunlockput>
  end_op();
    8000422a:	fffff097          	auipc	ra,0xfffff
    8000422e:	400080e7          	jalr	1024(ra) # 8000362a <end_op>
  p = myproc();
    80004232:	ffffd097          	auipc	ra,0xffffd
    80004236:	c16080e7          	jalr	-1002(ra) # 80000e48 <myproc>
    8000423a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000423c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004240:	6785                	lui	a5,0x1
    80004242:	17fd                	addi	a5,a5,-1
    80004244:	993e                	add	s2,s2,a5
    80004246:	757d                	lui	a0,0xfffff
    80004248:	00a977b3          	and	a5,s2,a0
    8000424c:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004250:	6609                	lui	a2,0x2
    80004252:	963e                	add	a2,a2,a5
    80004254:	85be                	mv	a1,a5
    80004256:	855e                	mv	a0,s7
    80004258:	ffffc097          	auipc	ra,0xffffc
    8000425c:	662080e7          	jalr	1634(ra) # 800008ba <uvmalloc>
    80004260:	8b2a                	mv	s6,a0
  ip = 0;
    80004262:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004264:	12050c63          	beqz	a0,8000439c <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004268:	75f9                	lui	a1,0xffffe
    8000426a:	95aa                	add	a1,a1,a0
    8000426c:	855e                	mv	a0,s7
    8000426e:	ffffd097          	auipc	ra,0xffffd
    80004272:	86a080e7          	jalr	-1942(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004276:	7c7d                	lui	s8,0xfffff
    80004278:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000427a:	e0043783          	ld	a5,-512(s0)
    8000427e:	6388                	ld	a0,0(a5)
    80004280:	c535                	beqz	a0,800042ec <exec+0x216>
    80004282:	e9040993          	addi	s3,s0,-368
    80004286:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000428a:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000428c:	ffffc097          	auipc	ra,0xffffc
    80004290:	070080e7          	jalr	112(ra) # 800002fc <strlen>
    80004294:	2505                	addiw	a0,a0,1
    80004296:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000429a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000429e:	13896363          	bltu	s2,s8,800043c4 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042a2:	e0043d83          	ld	s11,-512(s0)
    800042a6:	000dba03          	ld	s4,0(s11)
    800042aa:	8552                	mv	a0,s4
    800042ac:	ffffc097          	auipc	ra,0xffffc
    800042b0:	050080e7          	jalr	80(ra) # 800002fc <strlen>
    800042b4:	0015069b          	addiw	a3,a0,1
    800042b8:	8652                	mv	a2,s4
    800042ba:	85ca                	mv	a1,s2
    800042bc:	855e                	mv	a0,s7
    800042be:	ffffd097          	auipc	ra,0xffffd
    800042c2:	84c080e7          	jalr	-1972(ra) # 80000b0a <copyout>
    800042c6:	10054363          	bltz	a0,800043cc <exec+0x2f6>
    ustack[argc] = sp;
    800042ca:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042ce:	0485                	addi	s1,s1,1
    800042d0:	008d8793          	addi	a5,s11,8
    800042d4:	e0f43023          	sd	a5,-512(s0)
    800042d8:	008db503          	ld	a0,8(s11)
    800042dc:	c911                	beqz	a0,800042f0 <exec+0x21a>
    if(argc >= MAXARG)
    800042de:	09a1                	addi	s3,s3,8
    800042e0:	fb3c96e3          	bne	s9,s3,8000428c <exec+0x1b6>
  sz = sz1;
    800042e4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042e8:	4481                	li	s1,0
    800042ea:	a84d                	j	8000439c <exec+0x2c6>
  sp = sz;
    800042ec:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042ee:	4481                	li	s1,0
  ustack[argc] = 0;
    800042f0:	00349793          	slli	a5,s1,0x3
    800042f4:	f9040713          	addi	a4,s0,-112
    800042f8:	97ba                	add	a5,a5,a4
    800042fa:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042fe:	00148693          	addi	a3,s1,1
    80004302:	068e                	slli	a3,a3,0x3
    80004304:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004308:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000430c:	01897663          	bgeu	s2,s8,80004318 <exec+0x242>
  sz = sz1;
    80004310:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004314:	4481                	li	s1,0
    80004316:	a059                	j	8000439c <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004318:	e9040613          	addi	a2,s0,-368
    8000431c:	85ca                	mv	a1,s2
    8000431e:	855e                	mv	a0,s7
    80004320:	ffffc097          	auipc	ra,0xffffc
    80004324:	7ea080e7          	jalr	2026(ra) # 80000b0a <copyout>
    80004328:	0a054663          	bltz	a0,800043d4 <exec+0x2fe>
  p->trapframe->a1 = sp;
    8000432c:	058ab783          	ld	a5,88(s5)
    80004330:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004334:	df843783          	ld	a5,-520(s0)
    80004338:	0007c703          	lbu	a4,0(a5)
    8000433c:	cf11                	beqz	a4,80004358 <exec+0x282>
    8000433e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004340:	02f00693          	li	a3,47
    80004344:	a039                	j	80004352 <exec+0x27c>
      last = s+1;
    80004346:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    8000434a:	0785                	addi	a5,a5,1
    8000434c:	fff7c703          	lbu	a4,-1(a5)
    80004350:	c701                	beqz	a4,80004358 <exec+0x282>
    if(*s == '/')
    80004352:	fed71ce3          	bne	a4,a3,8000434a <exec+0x274>
    80004356:	bfc5                	j	80004346 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004358:	4641                	li	a2,16
    8000435a:	df843583          	ld	a1,-520(s0)
    8000435e:	158a8513          	addi	a0,s5,344
    80004362:	ffffc097          	auipc	ra,0xffffc
    80004366:	f68080e7          	jalr	-152(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    8000436a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000436e:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004372:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004376:	058ab783          	ld	a5,88(s5)
    8000437a:	e6843703          	ld	a4,-408(s0)
    8000437e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004380:	058ab783          	ld	a5,88(s5)
    80004384:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004388:	85ea                	mv	a1,s10
    8000438a:	ffffd097          	auipc	ra,0xffffd
    8000438e:	c1e080e7          	jalr	-994(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004392:	0004851b          	sext.w	a0,s1
    80004396:	bbe1                	j	8000416e <exec+0x98>
    80004398:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000439c:	e0843583          	ld	a1,-504(s0)
    800043a0:	855e                	mv	a0,s7
    800043a2:	ffffd097          	auipc	ra,0xffffd
    800043a6:	c06080e7          	jalr	-1018(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    800043aa:	da0498e3          	bnez	s1,8000415a <exec+0x84>
  return -1;
    800043ae:	557d                	li	a0,-1
    800043b0:	bb7d                	j	8000416e <exec+0x98>
    800043b2:	e1243423          	sd	s2,-504(s0)
    800043b6:	b7dd                	j	8000439c <exec+0x2c6>
    800043b8:	e1243423          	sd	s2,-504(s0)
    800043bc:	b7c5                	j	8000439c <exec+0x2c6>
    800043be:	e1243423          	sd	s2,-504(s0)
    800043c2:	bfe9                	j	8000439c <exec+0x2c6>
  sz = sz1;
    800043c4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043c8:	4481                	li	s1,0
    800043ca:	bfc9                	j	8000439c <exec+0x2c6>
  sz = sz1;
    800043cc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d0:	4481                	li	s1,0
    800043d2:	b7e9                	j	8000439c <exec+0x2c6>
  sz = sz1;
    800043d4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d8:	4481                	li	s1,0
    800043da:	b7c9                	j	8000439c <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043dc:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043e0:	2b05                	addiw	s6,s6,1
    800043e2:	0389899b          	addiw	s3,s3,56
    800043e6:	e8845783          	lhu	a5,-376(s0)
    800043ea:	e2fb5be3          	bge	s6,a5,80004220 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043ee:	2981                	sext.w	s3,s3
    800043f0:	03800713          	li	a4,56
    800043f4:	86ce                	mv	a3,s3
    800043f6:	e1840613          	addi	a2,s0,-488
    800043fa:	4581                	li	a1,0
    800043fc:	8526                	mv	a0,s1
    800043fe:	fffff097          	auipc	ra,0xfffff
    80004402:	a8c080e7          	jalr	-1396(ra) # 80002e8a <readi>
    80004406:	03800793          	li	a5,56
    8000440a:	f8f517e3          	bne	a0,a5,80004398 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000440e:	e1842783          	lw	a5,-488(s0)
    80004412:	4705                	li	a4,1
    80004414:	fce796e3          	bne	a5,a4,800043e0 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004418:	e4043603          	ld	a2,-448(s0)
    8000441c:	e3843783          	ld	a5,-456(s0)
    80004420:	f8f669e3          	bltu	a2,a5,800043b2 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004424:	e2843783          	ld	a5,-472(s0)
    80004428:	963e                	add	a2,a2,a5
    8000442a:	f8f667e3          	bltu	a2,a5,800043b8 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000442e:	85ca                	mv	a1,s2
    80004430:	855e                	mv	a0,s7
    80004432:	ffffc097          	auipc	ra,0xffffc
    80004436:	488080e7          	jalr	1160(ra) # 800008ba <uvmalloc>
    8000443a:	e0a43423          	sd	a0,-504(s0)
    8000443e:	d141                	beqz	a0,800043be <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    80004440:	e2843d03          	ld	s10,-472(s0)
    80004444:	df043783          	ld	a5,-528(s0)
    80004448:	00fd77b3          	and	a5,s10,a5
    8000444c:	fba1                	bnez	a5,8000439c <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000444e:	e2042d83          	lw	s11,-480(s0)
    80004452:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004456:	f80c03e3          	beqz	s8,800043dc <exec+0x306>
    8000445a:	8a62                	mv	s4,s8
    8000445c:	4901                	li	s2,0
    8000445e:	b345                	j	800041fe <exec+0x128>

0000000080004460 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004460:	7179                	addi	sp,sp,-48
    80004462:	f406                	sd	ra,40(sp)
    80004464:	f022                	sd	s0,32(sp)
    80004466:	ec26                	sd	s1,24(sp)
    80004468:	e84a                	sd	s2,16(sp)
    8000446a:	1800                	addi	s0,sp,48
    8000446c:	892e                	mv	s2,a1
    8000446e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004470:	fdc40593          	addi	a1,s0,-36
    80004474:	ffffe097          	auipc	ra,0xffffe
    80004478:	a80080e7          	jalr	-1408(ra) # 80001ef4 <argint>
    8000447c:	04054063          	bltz	a0,800044bc <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004480:	fdc42703          	lw	a4,-36(s0)
    80004484:	47bd                	li	a5,15
    80004486:	02e7ed63          	bltu	a5,a4,800044c0 <argfd+0x60>
    8000448a:	ffffd097          	auipc	ra,0xffffd
    8000448e:	9be080e7          	jalr	-1602(ra) # 80000e48 <myproc>
    80004492:	fdc42703          	lw	a4,-36(s0)
    80004496:	01a70793          	addi	a5,a4,26
    8000449a:	078e                	slli	a5,a5,0x3
    8000449c:	953e                	add	a0,a0,a5
    8000449e:	611c                	ld	a5,0(a0)
    800044a0:	c395                	beqz	a5,800044c4 <argfd+0x64>
    return -1;
  if(pfd)
    800044a2:	00090463          	beqz	s2,800044aa <argfd+0x4a>
    *pfd = fd;
    800044a6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044aa:	4501                	li	a0,0
  if(pf)
    800044ac:	c091                	beqz	s1,800044b0 <argfd+0x50>
    *pf = f;
    800044ae:	e09c                	sd	a5,0(s1)
}
    800044b0:	70a2                	ld	ra,40(sp)
    800044b2:	7402                	ld	s0,32(sp)
    800044b4:	64e2                	ld	s1,24(sp)
    800044b6:	6942                	ld	s2,16(sp)
    800044b8:	6145                	addi	sp,sp,48
    800044ba:	8082                	ret
    return -1;
    800044bc:	557d                	li	a0,-1
    800044be:	bfcd                	j	800044b0 <argfd+0x50>
    return -1;
    800044c0:	557d                	li	a0,-1
    800044c2:	b7fd                	j	800044b0 <argfd+0x50>
    800044c4:	557d                	li	a0,-1
    800044c6:	b7ed                	j	800044b0 <argfd+0x50>

00000000800044c8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044c8:	1101                	addi	sp,sp,-32
    800044ca:	ec06                	sd	ra,24(sp)
    800044cc:	e822                	sd	s0,16(sp)
    800044ce:	e426                	sd	s1,8(sp)
    800044d0:	1000                	addi	s0,sp,32
    800044d2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044d4:	ffffd097          	auipc	ra,0xffffd
    800044d8:	974080e7          	jalr	-1676(ra) # 80000e48 <myproc>
    800044dc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044de:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdde90>
    800044e2:	4501                	li	a0,0
    800044e4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044e6:	6398                	ld	a4,0(a5)
    800044e8:	cb19                	beqz	a4,800044fe <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044ea:	2505                	addiw	a0,a0,1
    800044ec:	07a1                	addi	a5,a5,8
    800044ee:	fed51ce3          	bne	a0,a3,800044e6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044f2:	557d                	li	a0,-1
}
    800044f4:	60e2                	ld	ra,24(sp)
    800044f6:	6442                	ld	s0,16(sp)
    800044f8:	64a2                	ld	s1,8(sp)
    800044fa:	6105                	addi	sp,sp,32
    800044fc:	8082                	ret
      p->ofile[fd] = f;
    800044fe:	01a50793          	addi	a5,a0,26
    80004502:	078e                	slli	a5,a5,0x3
    80004504:	963e                	add	a2,a2,a5
    80004506:	e204                	sd	s1,0(a2)
      return fd;
    80004508:	b7f5                	j	800044f4 <fdalloc+0x2c>

000000008000450a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000450a:	715d                	addi	sp,sp,-80
    8000450c:	e486                	sd	ra,72(sp)
    8000450e:	e0a2                	sd	s0,64(sp)
    80004510:	fc26                	sd	s1,56(sp)
    80004512:	f84a                	sd	s2,48(sp)
    80004514:	f44e                	sd	s3,40(sp)
    80004516:	f052                	sd	s4,32(sp)
    80004518:	ec56                	sd	s5,24(sp)
    8000451a:	0880                	addi	s0,sp,80
    8000451c:	89ae                	mv	s3,a1
    8000451e:	8ab2                	mv	s5,a2
    80004520:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004522:	fb040593          	addi	a1,s0,-80
    80004526:	fffff097          	auipc	ra,0xfffff
    8000452a:	e86080e7          	jalr	-378(ra) # 800033ac <nameiparent>
    8000452e:	892a                	mv	s2,a0
    80004530:	12050f63          	beqz	a0,8000466e <create+0x164>
    return 0;

  ilock(dp);
    80004534:	ffffe097          	auipc	ra,0xffffe
    80004538:	5f8080e7          	jalr	1528(ra) # 80002b2c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000453c:	4601                	li	a2,0
    8000453e:	fb040593          	addi	a1,s0,-80
    80004542:	854a                	mv	a0,s2
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	b78080e7          	jalr	-1160(ra) # 800030bc <dirlookup>
    8000454c:	84aa                	mv	s1,a0
    8000454e:	c921                	beqz	a0,8000459e <create+0x94>
    iunlockput(dp);
    80004550:	854a                	mv	a0,s2
    80004552:	fffff097          	auipc	ra,0xfffff
    80004556:	8e6080e7          	jalr	-1818(ra) # 80002e38 <iunlockput>
    ilock(ip);
    8000455a:	8526                	mv	a0,s1
    8000455c:	ffffe097          	auipc	ra,0xffffe
    80004560:	5d0080e7          	jalr	1488(ra) # 80002b2c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004564:	2981                	sext.w	s3,s3
    80004566:	4789                	li	a5,2
    80004568:	02f99463          	bne	s3,a5,80004590 <create+0x86>
    8000456c:	0444d783          	lhu	a5,68(s1)
    80004570:	37f9                	addiw	a5,a5,-2
    80004572:	17c2                	slli	a5,a5,0x30
    80004574:	93c1                	srli	a5,a5,0x30
    80004576:	4705                	li	a4,1
    80004578:	00f76c63          	bltu	a4,a5,80004590 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000457c:	8526                	mv	a0,s1
    8000457e:	60a6                	ld	ra,72(sp)
    80004580:	6406                	ld	s0,64(sp)
    80004582:	74e2                	ld	s1,56(sp)
    80004584:	7942                	ld	s2,48(sp)
    80004586:	79a2                	ld	s3,40(sp)
    80004588:	7a02                	ld	s4,32(sp)
    8000458a:	6ae2                	ld	s5,24(sp)
    8000458c:	6161                	addi	sp,sp,80
    8000458e:	8082                	ret
    iunlockput(ip);
    80004590:	8526                	mv	a0,s1
    80004592:	fffff097          	auipc	ra,0xfffff
    80004596:	8a6080e7          	jalr	-1882(ra) # 80002e38 <iunlockput>
    return 0;
    8000459a:	4481                	li	s1,0
    8000459c:	b7c5                	j	8000457c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000459e:	85ce                	mv	a1,s3
    800045a0:	00092503          	lw	a0,0(s2)
    800045a4:	ffffe097          	auipc	ra,0xffffe
    800045a8:	3f0080e7          	jalr	1008(ra) # 80002994 <ialloc>
    800045ac:	84aa                	mv	s1,a0
    800045ae:	c529                	beqz	a0,800045f8 <create+0xee>
  ilock(ip);
    800045b0:	ffffe097          	auipc	ra,0xffffe
    800045b4:	57c080e7          	jalr	1404(ra) # 80002b2c <ilock>
  ip->major = major;
    800045b8:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800045bc:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800045c0:	4785                	li	a5,1
    800045c2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800045c6:	8526                	mv	a0,s1
    800045c8:	ffffe097          	auipc	ra,0xffffe
    800045cc:	49a080e7          	jalr	1178(ra) # 80002a62 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045d0:	2981                	sext.w	s3,s3
    800045d2:	4785                	li	a5,1
    800045d4:	02f98a63          	beq	s3,a5,80004608 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045d8:	40d0                	lw	a2,4(s1)
    800045da:	fb040593          	addi	a1,s0,-80
    800045de:	854a                	mv	a0,s2
    800045e0:	fffff097          	auipc	ra,0xfffff
    800045e4:	cec080e7          	jalr	-788(ra) # 800032cc <dirlink>
    800045e8:	06054b63          	bltz	a0,8000465e <create+0x154>
  iunlockput(dp);
    800045ec:	854a                	mv	a0,s2
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	84a080e7          	jalr	-1974(ra) # 80002e38 <iunlockput>
  return ip;
    800045f6:	b759                	j	8000457c <create+0x72>
    panic("create: ialloc");
    800045f8:	00004517          	auipc	a0,0x4
    800045fc:	07850513          	addi	a0,a0,120 # 80008670 <syscalls+0x2a8>
    80004600:	00002097          	auipc	ra,0x2
    80004604:	848080e7          	jalr	-1976(ra) # 80005e48 <panic>
    dp->nlink++;  // for ".."
    80004608:	04a95783          	lhu	a5,74(s2)
    8000460c:	2785                	addiw	a5,a5,1
    8000460e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004612:	854a                	mv	a0,s2
    80004614:	ffffe097          	auipc	ra,0xffffe
    80004618:	44e080e7          	jalr	1102(ra) # 80002a62 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000461c:	40d0                	lw	a2,4(s1)
    8000461e:	00004597          	auipc	a1,0x4
    80004622:	06258593          	addi	a1,a1,98 # 80008680 <syscalls+0x2b8>
    80004626:	8526                	mv	a0,s1
    80004628:	fffff097          	auipc	ra,0xfffff
    8000462c:	ca4080e7          	jalr	-860(ra) # 800032cc <dirlink>
    80004630:	00054f63          	bltz	a0,8000464e <create+0x144>
    80004634:	00492603          	lw	a2,4(s2)
    80004638:	00004597          	auipc	a1,0x4
    8000463c:	05058593          	addi	a1,a1,80 # 80008688 <syscalls+0x2c0>
    80004640:	8526                	mv	a0,s1
    80004642:	fffff097          	auipc	ra,0xfffff
    80004646:	c8a080e7          	jalr	-886(ra) # 800032cc <dirlink>
    8000464a:	f80557e3          	bgez	a0,800045d8 <create+0xce>
      panic("create dots");
    8000464e:	00004517          	auipc	a0,0x4
    80004652:	04250513          	addi	a0,a0,66 # 80008690 <syscalls+0x2c8>
    80004656:	00001097          	auipc	ra,0x1
    8000465a:	7f2080e7          	jalr	2034(ra) # 80005e48 <panic>
    panic("create: dirlink");
    8000465e:	00004517          	auipc	a0,0x4
    80004662:	04250513          	addi	a0,a0,66 # 800086a0 <syscalls+0x2d8>
    80004666:	00001097          	auipc	ra,0x1
    8000466a:	7e2080e7          	jalr	2018(ra) # 80005e48 <panic>
    return 0;
    8000466e:	84aa                	mv	s1,a0
    80004670:	b731                	j	8000457c <create+0x72>

0000000080004672 <sys_dup>:
{
    80004672:	7179                	addi	sp,sp,-48
    80004674:	f406                	sd	ra,40(sp)
    80004676:	f022                	sd	s0,32(sp)
    80004678:	ec26                	sd	s1,24(sp)
    8000467a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000467c:	fd840613          	addi	a2,s0,-40
    80004680:	4581                	li	a1,0
    80004682:	4501                	li	a0,0
    80004684:	00000097          	auipc	ra,0x0
    80004688:	ddc080e7          	jalr	-548(ra) # 80004460 <argfd>
    return -1;
    8000468c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000468e:	02054363          	bltz	a0,800046b4 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004692:	fd843503          	ld	a0,-40(s0)
    80004696:	00000097          	auipc	ra,0x0
    8000469a:	e32080e7          	jalr	-462(ra) # 800044c8 <fdalloc>
    8000469e:	84aa                	mv	s1,a0
    return -1;
    800046a0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046a2:	00054963          	bltz	a0,800046b4 <sys_dup+0x42>
  filedup(f);
    800046a6:	fd843503          	ld	a0,-40(s0)
    800046aa:	fffff097          	auipc	ra,0xfffff
    800046ae:	37a080e7          	jalr	890(ra) # 80003a24 <filedup>
  return fd;
    800046b2:	87a6                	mv	a5,s1
}
    800046b4:	853e                	mv	a0,a5
    800046b6:	70a2                	ld	ra,40(sp)
    800046b8:	7402                	ld	s0,32(sp)
    800046ba:	64e2                	ld	s1,24(sp)
    800046bc:	6145                	addi	sp,sp,48
    800046be:	8082                	ret

00000000800046c0 <sys_read>:
{
    800046c0:	7179                	addi	sp,sp,-48
    800046c2:	f406                	sd	ra,40(sp)
    800046c4:	f022                	sd	s0,32(sp)
    800046c6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046c8:	fe840613          	addi	a2,s0,-24
    800046cc:	4581                	li	a1,0
    800046ce:	4501                	li	a0,0
    800046d0:	00000097          	auipc	ra,0x0
    800046d4:	d90080e7          	jalr	-624(ra) # 80004460 <argfd>
    return -1;
    800046d8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046da:	04054163          	bltz	a0,8000471c <sys_read+0x5c>
    800046de:	fe440593          	addi	a1,s0,-28
    800046e2:	4509                	li	a0,2
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	810080e7          	jalr	-2032(ra) # 80001ef4 <argint>
    return -1;
    800046ec:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ee:	02054763          	bltz	a0,8000471c <sys_read+0x5c>
    800046f2:	fd840593          	addi	a1,s0,-40
    800046f6:	4505                	li	a0,1
    800046f8:	ffffe097          	auipc	ra,0xffffe
    800046fc:	81e080e7          	jalr	-2018(ra) # 80001f16 <argaddr>
    return -1;
    80004700:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004702:	00054d63          	bltz	a0,8000471c <sys_read+0x5c>
  return fileread(f, p, n);
    80004706:	fe442603          	lw	a2,-28(s0)
    8000470a:	fd843583          	ld	a1,-40(s0)
    8000470e:	fe843503          	ld	a0,-24(s0)
    80004712:	fffff097          	auipc	ra,0xfffff
    80004716:	49e080e7          	jalr	1182(ra) # 80003bb0 <fileread>
    8000471a:	87aa                	mv	a5,a0
}
    8000471c:	853e                	mv	a0,a5
    8000471e:	70a2                	ld	ra,40(sp)
    80004720:	7402                	ld	s0,32(sp)
    80004722:	6145                	addi	sp,sp,48
    80004724:	8082                	ret

0000000080004726 <sys_write>:
{
    80004726:	7179                	addi	sp,sp,-48
    80004728:	f406                	sd	ra,40(sp)
    8000472a:	f022                	sd	s0,32(sp)
    8000472c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000472e:	fe840613          	addi	a2,s0,-24
    80004732:	4581                	li	a1,0
    80004734:	4501                	li	a0,0
    80004736:	00000097          	auipc	ra,0x0
    8000473a:	d2a080e7          	jalr	-726(ra) # 80004460 <argfd>
    return -1;
    8000473e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004740:	04054163          	bltz	a0,80004782 <sys_write+0x5c>
    80004744:	fe440593          	addi	a1,s0,-28
    80004748:	4509                	li	a0,2
    8000474a:	ffffd097          	auipc	ra,0xffffd
    8000474e:	7aa080e7          	jalr	1962(ra) # 80001ef4 <argint>
    return -1;
    80004752:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004754:	02054763          	bltz	a0,80004782 <sys_write+0x5c>
    80004758:	fd840593          	addi	a1,s0,-40
    8000475c:	4505                	li	a0,1
    8000475e:	ffffd097          	auipc	ra,0xffffd
    80004762:	7b8080e7          	jalr	1976(ra) # 80001f16 <argaddr>
    return -1;
    80004766:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004768:	00054d63          	bltz	a0,80004782 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000476c:	fe442603          	lw	a2,-28(s0)
    80004770:	fd843583          	ld	a1,-40(s0)
    80004774:	fe843503          	ld	a0,-24(s0)
    80004778:	fffff097          	auipc	ra,0xfffff
    8000477c:	4fa080e7          	jalr	1274(ra) # 80003c72 <filewrite>
    80004780:	87aa                	mv	a5,a0
}
    80004782:	853e                	mv	a0,a5
    80004784:	70a2                	ld	ra,40(sp)
    80004786:	7402                	ld	s0,32(sp)
    80004788:	6145                	addi	sp,sp,48
    8000478a:	8082                	ret

000000008000478c <sys_close>:
{
    8000478c:	1101                	addi	sp,sp,-32
    8000478e:	ec06                	sd	ra,24(sp)
    80004790:	e822                	sd	s0,16(sp)
    80004792:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004794:	fe040613          	addi	a2,s0,-32
    80004798:	fec40593          	addi	a1,s0,-20
    8000479c:	4501                	li	a0,0
    8000479e:	00000097          	auipc	ra,0x0
    800047a2:	cc2080e7          	jalr	-830(ra) # 80004460 <argfd>
    return -1;
    800047a6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047a8:	02054463          	bltz	a0,800047d0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047ac:	ffffc097          	auipc	ra,0xffffc
    800047b0:	69c080e7          	jalr	1692(ra) # 80000e48 <myproc>
    800047b4:	fec42783          	lw	a5,-20(s0)
    800047b8:	07e9                	addi	a5,a5,26
    800047ba:	078e                	slli	a5,a5,0x3
    800047bc:	97aa                	add	a5,a5,a0
    800047be:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047c2:	fe043503          	ld	a0,-32(s0)
    800047c6:	fffff097          	auipc	ra,0xfffff
    800047ca:	2b0080e7          	jalr	688(ra) # 80003a76 <fileclose>
  return 0;
    800047ce:	4781                	li	a5,0
}
    800047d0:	853e                	mv	a0,a5
    800047d2:	60e2                	ld	ra,24(sp)
    800047d4:	6442                	ld	s0,16(sp)
    800047d6:	6105                	addi	sp,sp,32
    800047d8:	8082                	ret

00000000800047da <sys_fstat>:
{
    800047da:	1101                	addi	sp,sp,-32
    800047dc:	ec06                	sd	ra,24(sp)
    800047de:	e822                	sd	s0,16(sp)
    800047e0:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047e2:	fe840613          	addi	a2,s0,-24
    800047e6:	4581                	li	a1,0
    800047e8:	4501                	li	a0,0
    800047ea:	00000097          	auipc	ra,0x0
    800047ee:	c76080e7          	jalr	-906(ra) # 80004460 <argfd>
    return -1;
    800047f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047f4:	02054563          	bltz	a0,8000481e <sys_fstat+0x44>
    800047f8:	fe040593          	addi	a1,s0,-32
    800047fc:	4505                	li	a0,1
    800047fe:	ffffd097          	auipc	ra,0xffffd
    80004802:	718080e7          	jalr	1816(ra) # 80001f16 <argaddr>
    return -1;
    80004806:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004808:	00054b63          	bltz	a0,8000481e <sys_fstat+0x44>
  return filestat(f, st);
    8000480c:	fe043583          	ld	a1,-32(s0)
    80004810:	fe843503          	ld	a0,-24(s0)
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	32a080e7          	jalr	810(ra) # 80003b3e <filestat>
    8000481c:	87aa                	mv	a5,a0
}
    8000481e:	853e                	mv	a0,a5
    80004820:	60e2                	ld	ra,24(sp)
    80004822:	6442                	ld	s0,16(sp)
    80004824:	6105                	addi	sp,sp,32
    80004826:	8082                	ret

0000000080004828 <sys_link>:
{
    80004828:	7169                	addi	sp,sp,-304
    8000482a:	f606                	sd	ra,296(sp)
    8000482c:	f222                	sd	s0,288(sp)
    8000482e:	ee26                	sd	s1,280(sp)
    80004830:	ea4a                	sd	s2,272(sp)
    80004832:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004834:	08000613          	li	a2,128
    80004838:	ed040593          	addi	a1,s0,-304
    8000483c:	4501                	li	a0,0
    8000483e:	ffffd097          	auipc	ra,0xffffd
    80004842:	6fa080e7          	jalr	1786(ra) # 80001f38 <argstr>
    return -1;
    80004846:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004848:	10054e63          	bltz	a0,80004964 <sys_link+0x13c>
    8000484c:	08000613          	li	a2,128
    80004850:	f5040593          	addi	a1,s0,-176
    80004854:	4505                	li	a0,1
    80004856:	ffffd097          	auipc	ra,0xffffd
    8000485a:	6e2080e7          	jalr	1762(ra) # 80001f38 <argstr>
    return -1;
    8000485e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004860:	10054263          	bltz	a0,80004964 <sys_link+0x13c>
  begin_op();
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	d46080e7          	jalr	-698(ra) # 800035aa <begin_op>
  if((ip = namei(old)) == 0){
    8000486c:	ed040513          	addi	a0,s0,-304
    80004870:	fffff097          	auipc	ra,0xfffff
    80004874:	b1e080e7          	jalr	-1250(ra) # 8000338e <namei>
    80004878:	84aa                	mv	s1,a0
    8000487a:	c551                	beqz	a0,80004906 <sys_link+0xde>
  ilock(ip);
    8000487c:	ffffe097          	auipc	ra,0xffffe
    80004880:	2b0080e7          	jalr	688(ra) # 80002b2c <ilock>
  if(ip->type == T_DIR){
    80004884:	04449703          	lh	a4,68(s1)
    80004888:	4785                	li	a5,1
    8000488a:	08f70463          	beq	a4,a5,80004912 <sys_link+0xea>
  ip->nlink++;
    8000488e:	04a4d783          	lhu	a5,74(s1)
    80004892:	2785                	addiw	a5,a5,1
    80004894:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004898:	8526                	mv	a0,s1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	1c8080e7          	jalr	456(ra) # 80002a62 <iupdate>
  iunlock(ip);
    800048a2:	8526                	mv	a0,s1
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	34a080e7          	jalr	842(ra) # 80002bee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048ac:	fd040593          	addi	a1,s0,-48
    800048b0:	f5040513          	addi	a0,s0,-176
    800048b4:	fffff097          	auipc	ra,0xfffff
    800048b8:	af8080e7          	jalr	-1288(ra) # 800033ac <nameiparent>
    800048bc:	892a                	mv	s2,a0
    800048be:	c935                	beqz	a0,80004932 <sys_link+0x10a>
  ilock(dp);
    800048c0:	ffffe097          	auipc	ra,0xffffe
    800048c4:	26c080e7          	jalr	620(ra) # 80002b2c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048c8:	00092703          	lw	a4,0(s2)
    800048cc:	409c                	lw	a5,0(s1)
    800048ce:	04f71d63          	bne	a4,a5,80004928 <sys_link+0x100>
    800048d2:	40d0                	lw	a2,4(s1)
    800048d4:	fd040593          	addi	a1,s0,-48
    800048d8:	854a                	mv	a0,s2
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	9f2080e7          	jalr	-1550(ra) # 800032cc <dirlink>
    800048e2:	04054363          	bltz	a0,80004928 <sys_link+0x100>
  iunlockput(dp);
    800048e6:	854a                	mv	a0,s2
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	550080e7          	jalr	1360(ra) # 80002e38 <iunlockput>
  iput(ip);
    800048f0:	8526                	mv	a0,s1
    800048f2:	ffffe097          	auipc	ra,0xffffe
    800048f6:	49e080e7          	jalr	1182(ra) # 80002d90 <iput>
  end_op();
    800048fa:	fffff097          	auipc	ra,0xfffff
    800048fe:	d30080e7          	jalr	-720(ra) # 8000362a <end_op>
  return 0;
    80004902:	4781                	li	a5,0
    80004904:	a085                	j	80004964 <sys_link+0x13c>
    end_op();
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	d24080e7          	jalr	-732(ra) # 8000362a <end_op>
    return -1;
    8000490e:	57fd                	li	a5,-1
    80004910:	a891                	j	80004964 <sys_link+0x13c>
    iunlockput(ip);
    80004912:	8526                	mv	a0,s1
    80004914:	ffffe097          	auipc	ra,0xffffe
    80004918:	524080e7          	jalr	1316(ra) # 80002e38 <iunlockput>
    end_op();
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	d0e080e7          	jalr	-754(ra) # 8000362a <end_op>
    return -1;
    80004924:	57fd                	li	a5,-1
    80004926:	a83d                	j	80004964 <sys_link+0x13c>
    iunlockput(dp);
    80004928:	854a                	mv	a0,s2
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	50e080e7          	jalr	1294(ra) # 80002e38 <iunlockput>
  ilock(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	1f8080e7          	jalr	504(ra) # 80002b2c <ilock>
  ip->nlink--;
    8000493c:	04a4d783          	lhu	a5,74(s1)
    80004940:	37fd                	addiw	a5,a5,-1
    80004942:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004946:	8526                	mv	a0,s1
    80004948:	ffffe097          	auipc	ra,0xffffe
    8000494c:	11a080e7          	jalr	282(ra) # 80002a62 <iupdate>
  iunlockput(ip);
    80004950:	8526                	mv	a0,s1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	4e6080e7          	jalr	1254(ra) # 80002e38 <iunlockput>
  end_op();
    8000495a:	fffff097          	auipc	ra,0xfffff
    8000495e:	cd0080e7          	jalr	-816(ra) # 8000362a <end_op>
  return -1;
    80004962:	57fd                	li	a5,-1
}
    80004964:	853e                	mv	a0,a5
    80004966:	70b2                	ld	ra,296(sp)
    80004968:	7412                	ld	s0,288(sp)
    8000496a:	64f2                	ld	s1,280(sp)
    8000496c:	6952                	ld	s2,272(sp)
    8000496e:	6155                	addi	sp,sp,304
    80004970:	8082                	ret

0000000080004972 <sys_unlink>:
{
    80004972:	7151                	addi	sp,sp,-240
    80004974:	f586                	sd	ra,232(sp)
    80004976:	f1a2                	sd	s0,224(sp)
    80004978:	eda6                	sd	s1,216(sp)
    8000497a:	e9ca                	sd	s2,208(sp)
    8000497c:	e5ce                	sd	s3,200(sp)
    8000497e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004980:	08000613          	li	a2,128
    80004984:	f3040593          	addi	a1,s0,-208
    80004988:	4501                	li	a0,0
    8000498a:	ffffd097          	auipc	ra,0xffffd
    8000498e:	5ae080e7          	jalr	1454(ra) # 80001f38 <argstr>
    80004992:	18054163          	bltz	a0,80004b14 <sys_unlink+0x1a2>
  begin_op();
    80004996:	fffff097          	auipc	ra,0xfffff
    8000499a:	c14080e7          	jalr	-1004(ra) # 800035aa <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000499e:	fb040593          	addi	a1,s0,-80
    800049a2:	f3040513          	addi	a0,s0,-208
    800049a6:	fffff097          	auipc	ra,0xfffff
    800049aa:	a06080e7          	jalr	-1530(ra) # 800033ac <nameiparent>
    800049ae:	84aa                	mv	s1,a0
    800049b0:	c979                	beqz	a0,80004a86 <sys_unlink+0x114>
  ilock(dp);
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	17a080e7          	jalr	378(ra) # 80002b2c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049ba:	00004597          	auipc	a1,0x4
    800049be:	cc658593          	addi	a1,a1,-826 # 80008680 <syscalls+0x2b8>
    800049c2:	fb040513          	addi	a0,s0,-80
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	6dc080e7          	jalr	1756(ra) # 800030a2 <namecmp>
    800049ce:	14050a63          	beqz	a0,80004b22 <sys_unlink+0x1b0>
    800049d2:	00004597          	auipc	a1,0x4
    800049d6:	cb658593          	addi	a1,a1,-842 # 80008688 <syscalls+0x2c0>
    800049da:	fb040513          	addi	a0,s0,-80
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	6c4080e7          	jalr	1732(ra) # 800030a2 <namecmp>
    800049e6:	12050e63          	beqz	a0,80004b22 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049ea:	f2c40613          	addi	a2,s0,-212
    800049ee:	fb040593          	addi	a1,s0,-80
    800049f2:	8526                	mv	a0,s1
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	6c8080e7          	jalr	1736(ra) # 800030bc <dirlookup>
    800049fc:	892a                	mv	s2,a0
    800049fe:	12050263          	beqz	a0,80004b22 <sys_unlink+0x1b0>
  ilock(ip);
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	12a080e7          	jalr	298(ra) # 80002b2c <ilock>
  if(ip->nlink < 1)
    80004a0a:	04a91783          	lh	a5,74(s2)
    80004a0e:	08f05263          	blez	a5,80004a92 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a12:	04491703          	lh	a4,68(s2)
    80004a16:	4785                	li	a5,1
    80004a18:	08f70563          	beq	a4,a5,80004aa2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a1c:	4641                	li	a2,16
    80004a1e:	4581                	li	a1,0
    80004a20:	fc040513          	addi	a0,s0,-64
    80004a24:	ffffb097          	auipc	ra,0xffffb
    80004a28:	754080e7          	jalr	1876(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a2c:	4741                	li	a4,16
    80004a2e:	f2c42683          	lw	a3,-212(s0)
    80004a32:	fc040613          	addi	a2,s0,-64
    80004a36:	4581                	li	a1,0
    80004a38:	8526                	mv	a0,s1
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	548080e7          	jalr	1352(ra) # 80002f82 <writei>
    80004a42:	47c1                	li	a5,16
    80004a44:	0af51563          	bne	a0,a5,80004aee <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a48:	04491703          	lh	a4,68(s2)
    80004a4c:	4785                	li	a5,1
    80004a4e:	0af70863          	beq	a4,a5,80004afe <sys_unlink+0x18c>
  iunlockput(dp);
    80004a52:	8526                	mv	a0,s1
    80004a54:	ffffe097          	auipc	ra,0xffffe
    80004a58:	3e4080e7          	jalr	996(ra) # 80002e38 <iunlockput>
  ip->nlink--;
    80004a5c:	04a95783          	lhu	a5,74(s2)
    80004a60:	37fd                	addiw	a5,a5,-1
    80004a62:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a66:	854a                	mv	a0,s2
    80004a68:	ffffe097          	auipc	ra,0xffffe
    80004a6c:	ffa080e7          	jalr	-6(ra) # 80002a62 <iupdate>
  iunlockput(ip);
    80004a70:	854a                	mv	a0,s2
    80004a72:	ffffe097          	auipc	ra,0xffffe
    80004a76:	3c6080e7          	jalr	966(ra) # 80002e38 <iunlockput>
  end_op();
    80004a7a:	fffff097          	auipc	ra,0xfffff
    80004a7e:	bb0080e7          	jalr	-1104(ra) # 8000362a <end_op>
  return 0;
    80004a82:	4501                	li	a0,0
    80004a84:	a84d                	j	80004b36 <sys_unlink+0x1c4>
    end_op();
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	ba4080e7          	jalr	-1116(ra) # 8000362a <end_op>
    return -1;
    80004a8e:	557d                	li	a0,-1
    80004a90:	a05d                	j	80004b36 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a92:	00004517          	auipc	a0,0x4
    80004a96:	c1e50513          	addi	a0,a0,-994 # 800086b0 <syscalls+0x2e8>
    80004a9a:	00001097          	auipc	ra,0x1
    80004a9e:	3ae080e7          	jalr	942(ra) # 80005e48 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aa2:	04c92703          	lw	a4,76(s2)
    80004aa6:	02000793          	li	a5,32
    80004aaa:	f6e7f9e3          	bgeu	a5,a4,80004a1c <sys_unlink+0xaa>
    80004aae:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ab2:	4741                	li	a4,16
    80004ab4:	86ce                	mv	a3,s3
    80004ab6:	f1840613          	addi	a2,s0,-232
    80004aba:	4581                	li	a1,0
    80004abc:	854a                	mv	a0,s2
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	3cc080e7          	jalr	972(ra) # 80002e8a <readi>
    80004ac6:	47c1                	li	a5,16
    80004ac8:	00f51b63          	bne	a0,a5,80004ade <sys_unlink+0x16c>
    if(de.inum != 0)
    80004acc:	f1845783          	lhu	a5,-232(s0)
    80004ad0:	e7a1                	bnez	a5,80004b18 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ad2:	29c1                	addiw	s3,s3,16
    80004ad4:	04c92783          	lw	a5,76(s2)
    80004ad8:	fcf9ede3          	bltu	s3,a5,80004ab2 <sys_unlink+0x140>
    80004adc:	b781                	j	80004a1c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ade:	00004517          	auipc	a0,0x4
    80004ae2:	bea50513          	addi	a0,a0,-1046 # 800086c8 <syscalls+0x300>
    80004ae6:	00001097          	auipc	ra,0x1
    80004aea:	362080e7          	jalr	866(ra) # 80005e48 <panic>
    panic("unlink: writei");
    80004aee:	00004517          	auipc	a0,0x4
    80004af2:	bf250513          	addi	a0,a0,-1038 # 800086e0 <syscalls+0x318>
    80004af6:	00001097          	auipc	ra,0x1
    80004afa:	352080e7          	jalr	850(ra) # 80005e48 <panic>
    dp->nlink--;
    80004afe:	04a4d783          	lhu	a5,74(s1)
    80004b02:	37fd                	addiw	a5,a5,-1
    80004b04:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b08:	8526                	mv	a0,s1
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	f58080e7          	jalr	-168(ra) # 80002a62 <iupdate>
    80004b12:	b781                	j	80004a52 <sys_unlink+0xe0>
    return -1;
    80004b14:	557d                	li	a0,-1
    80004b16:	a005                	j	80004b36 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b18:	854a                	mv	a0,s2
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	31e080e7          	jalr	798(ra) # 80002e38 <iunlockput>
  iunlockput(dp);
    80004b22:	8526                	mv	a0,s1
    80004b24:	ffffe097          	auipc	ra,0xffffe
    80004b28:	314080e7          	jalr	788(ra) # 80002e38 <iunlockput>
  end_op();
    80004b2c:	fffff097          	auipc	ra,0xfffff
    80004b30:	afe080e7          	jalr	-1282(ra) # 8000362a <end_op>
  return -1;
    80004b34:	557d                	li	a0,-1
}
    80004b36:	70ae                	ld	ra,232(sp)
    80004b38:	740e                	ld	s0,224(sp)
    80004b3a:	64ee                	ld	s1,216(sp)
    80004b3c:	694e                	ld	s2,208(sp)
    80004b3e:	69ae                	ld	s3,200(sp)
    80004b40:	616d                	addi	sp,sp,240
    80004b42:	8082                	ret

0000000080004b44 <sys_open>:
  return 0;
}

uint64
sys_open(void)
{
    80004b44:	7149                	addi	sp,sp,-368
    80004b46:	f686                	sd	ra,360(sp)
    80004b48:	f2a2                	sd	s0,352(sp)
    80004b4a:	eea6                	sd	s1,344(sp)
    80004b4c:	eaca                	sd	s2,336(sp)
    80004b4e:	e6ce                	sd	s3,328(sp)
    80004b50:	e2d2                	sd	s4,320(sp)
    80004b52:	fe56                	sd	s5,312(sp)
    80004b54:	fa5a                	sd	s6,304(sp)
    80004b56:	1a80                	addi	s0,sp,368
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b58:	08000613          	li	a2,128
    80004b5c:	f4040593          	addi	a1,s0,-192
    80004b60:	4501                	li	a0,0
    80004b62:	ffffd097          	auipc	ra,0xffffd
    80004b66:	3d6080e7          	jalr	982(ra) # 80001f38 <argstr>
    return -1;
    80004b6a:	597d                	li	s2,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b6c:	0c054863          	bltz	a0,80004c3c <sys_open+0xf8>
    80004b70:	f3c40593          	addi	a1,s0,-196
    80004b74:	4505                	li	a0,1
    80004b76:	ffffd097          	auipc	ra,0xffffd
    80004b7a:	37e080e7          	jalr	894(ra) # 80001ef4 <argint>
    80004b7e:	0a054f63          	bltz	a0,80004c3c <sys_open+0xf8>

  begin_op();
    80004b82:	fffff097          	auipc	ra,0xfffff
    80004b86:	a28080e7          	jalr	-1496(ra) # 800035aa <begin_op>

  if(omode & O_CREATE){
    80004b8a:	f3c42783          	lw	a5,-196(s0)
    80004b8e:	2007f793          	andi	a5,a5,512
    80004b92:	c7e9                	beqz	a5,80004c5c <sys_open+0x118>
    ip = create(path, T_FILE, 0, 0);
    80004b94:	4681                	li	a3,0
    80004b96:	4601                	li	a2,0
    80004b98:	4589                	li	a1,2
    80004b9a:	f4040513          	addi	a0,s0,-192
    80004b9e:	00000097          	auipc	ra,0x0
    80004ba2:	96c080e7          	jalr	-1684(ra) # 8000450a <create>
    80004ba6:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ba8:	c54d                	beqz	a0,80004c52 <sys_open+0x10e>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004baa:	04449783          	lh	a5,68(s1)
    80004bae:	0007869b          	sext.w	a3,a5
    80004bb2:	470d                	li	a4,3
    80004bb4:	0ee68963          	beq	a3,a4,80004ca6 <sys_open+0x162>
    end_op();
    return -1;
  }

  // handle the symlink - lab9-2
  if(ip->type == T_SYMLINK && (omode & O_NOFOLLOW) == 0) {
    80004bb8:	2781                	sext.w	a5,a5
    80004bba:	4711                	li	a4,4
    80004bbc:	00e79863          	bne	a5,a4,80004bcc <sys_open+0x88>
    80004bc0:	f3c42783          	lw	a5,-196(s0)
    80004bc4:	8b91                	andi	a5,a5,4
    80004bc6:	0007871b          	sext.w	a4,a5
    80004bca:	cff5                	beqz	a5,80004cc6 <sys_open+0x182>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	dee080e7          	jalr	-530(ra) # 800039ba <filealloc>
    80004bd4:	89aa                	mv	s3,a0
    80004bd6:	1e050c63          	beqz	a0,80004dce <sys_open+0x28a>
    80004bda:	00000097          	auipc	ra,0x0
    80004bde:	8ee080e7          	jalr	-1810(ra) # 800044c8 <fdalloc>
    80004be2:	892a                	mv	s2,a0
    80004be4:	1e054063          	bltz	a0,80004dc4 <sys_open+0x280>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004be8:	04449703          	lh	a4,68(s1)
    80004bec:	478d                	li	a5,3
    80004bee:	1af70e63          	beq	a4,a5,80004daa <sys_open+0x266>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bf2:	4789                	li	a5,2
    80004bf4:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bf8:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bfc:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c00:	f3c42783          	lw	a5,-196(s0)
    80004c04:	0017c713          	xori	a4,a5,1
    80004c08:	8b05                	andi	a4,a4,1
    80004c0a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c0e:	0037f713          	andi	a4,a5,3
    80004c12:	00e03733          	snez	a4,a4
    80004c16:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c1a:	4007f793          	andi	a5,a5,1024
    80004c1e:	c791                	beqz	a5,80004c2a <sys_open+0xe6>
    80004c20:	04449703          	lh	a4,68(s1)
    80004c24:	4789                	li	a5,2
    80004c26:	18f70963          	beq	a4,a5,80004db8 <sys_open+0x274>
    itrunc(ip);
  }

  iunlock(ip);
    80004c2a:	8526                	mv	a0,s1
    80004c2c:	ffffe097          	auipc	ra,0xffffe
    80004c30:	fc2080e7          	jalr	-62(ra) # 80002bee <iunlock>
  end_op();
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	9f6080e7          	jalr	-1546(ra) # 8000362a <end_op>

  return fd;
}
    80004c3c:	854a                	mv	a0,s2
    80004c3e:	70b6                	ld	ra,360(sp)
    80004c40:	7416                	ld	s0,352(sp)
    80004c42:	64f6                	ld	s1,344(sp)
    80004c44:	6956                	ld	s2,336(sp)
    80004c46:	69b6                	ld	s3,328(sp)
    80004c48:	6a16                	ld	s4,320(sp)
    80004c4a:	7af2                	ld	s5,312(sp)
    80004c4c:	7b52                	ld	s6,304(sp)
    80004c4e:	6175                	addi	sp,sp,368
    80004c50:	8082                	ret
      end_op();
    80004c52:	fffff097          	auipc	ra,0xfffff
    80004c56:	9d8080e7          	jalr	-1576(ra) # 8000362a <end_op>
      return -1;
    80004c5a:	b7cd                	j	80004c3c <sys_open+0xf8>
    if((ip = namei(path)) == 0){
    80004c5c:	f4040513          	addi	a0,s0,-192
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	72e080e7          	jalr	1838(ra) # 8000338e <namei>
    80004c68:	84aa                	mv	s1,a0
    80004c6a:	c905                	beqz	a0,80004c9a <sys_open+0x156>
    ilock(ip);
    80004c6c:	ffffe097          	auipc	ra,0xffffe
    80004c70:	ec0080e7          	jalr	-320(ra) # 80002b2c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c74:	04449703          	lh	a4,68(s1)
    80004c78:	4785                	li	a5,1
    80004c7a:	f2f718e3          	bne	a4,a5,80004baa <sys_open+0x66>
    80004c7e:	f3c42783          	lw	a5,-196(s0)
    80004c82:	d7a9                	beqz	a5,80004bcc <sys_open+0x88>
      iunlockput(ip);
    80004c84:	8526                	mv	a0,s1
    80004c86:	ffffe097          	auipc	ra,0xffffe
    80004c8a:	1b2080e7          	jalr	434(ra) # 80002e38 <iunlockput>
      end_op();
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	99c080e7          	jalr	-1636(ra) # 8000362a <end_op>
      return -1;
    80004c96:	597d                	li	s2,-1
    80004c98:	b755                	j	80004c3c <sys_open+0xf8>
      end_op();
    80004c9a:	fffff097          	auipc	ra,0xfffff
    80004c9e:	990080e7          	jalr	-1648(ra) # 8000362a <end_op>
      return -1;
    80004ca2:	597d                	li	s2,-1
    80004ca4:	bf61                	j	80004c3c <sys_open+0xf8>
  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ca6:	0464d703          	lhu	a4,70(s1)
    80004caa:	47a5                	li	a5,9
    80004cac:	f2e7f0e3          	bgeu	a5,a4,80004bcc <sys_open+0x88>
    iunlockput(ip);
    80004cb0:	8526                	mv	a0,s1
    80004cb2:	ffffe097          	auipc	ra,0xffffe
    80004cb6:	186080e7          	jalr	390(ra) # 80002e38 <iunlockput>
    end_op();
    80004cba:	fffff097          	auipc	ra,0xfffff
    80004cbe:	970080e7          	jalr	-1680(ra) # 8000362a <end_op>
    return -1;
    80004cc2:	597d                	li	s2,-1
    80004cc4:	bfa5                	j	80004c3c <sys_open+0xf8>
  if(ip->type == T_SYMLINK && (omode & O_NOFOLLOW) == 0) {
    80004cc6:	e9040a13          	addi	s4,s0,-368
  for(i = 0; i < NSYMLINK; ++i) {
    80004cca:	893a                	mv	s2,a4
    for(j = 0; j <= i; ++j) {
    80004ccc:	89ba                	mv	s3,a4
    if(ip->type != T_SYMLINK) {
    80004cce:	4a91                	li	s5,4
  for(i = 0; i < NSYMLINK; ++i) {
    80004cd0:	4b29                	li	s6,10
    inums[i] = ip->inum;
    80004cd2:	40dc                	lw	a5,4(s1)
    80004cd4:	00fa2023          	sw	a5,0(s4)
    if(readi(ip, 0, (uint64)target, 0, MAXPATH) <= 0) {
    80004cd8:	08000713          	li	a4,128
    80004cdc:	4681                	li	a3,0
    80004cde:	eb840613          	addi	a2,s0,-328
    80004ce2:	4581                	li	a1,0
    80004ce4:	8526                	mv	a0,s1
    80004ce6:	ffffe097          	auipc	ra,0xffffe
    80004cea:	1a4080e7          	jalr	420(ra) # 80002e8a <readi>
    80004cee:	06a05763          	blez	a0,80004d5c <sys_open+0x218>
    iunlockput(ip);
    80004cf2:	8526                	mv	a0,s1
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	144080e7          	jalr	324(ra) # 80002e38 <iunlockput>
    if((ip = namei(target)) == 0) {
    80004cfc:	eb840513          	addi	a0,s0,-328
    80004d00:	ffffe097          	auipc	ra,0xffffe
    80004d04:	68e080e7          	jalr	1678(ra) # 8000338e <namei>
    80004d08:	84aa                	mv	s1,a0
    80004d0a:	c53d                	beqz	a0,80004d78 <sys_open+0x234>
    for(j = 0; j <= i; ++j) {
    80004d0c:	00094d63          	bltz	s2,80004d26 <sys_open+0x1e2>
      if(ip->inum == inums[j]) {
    80004d10:	4150                	lw	a2,4(a0)
    80004d12:	e9040793          	addi	a5,s0,-368
    for(j = 0; j <= i; ++j) {
    80004d16:	874e                	mv	a4,s3
      if(ip->inum == inums[j]) {
    80004d18:	4394                	lw	a3,0(a5)
    80004d1a:	06c68a63          	beq	a3,a2,80004d8e <sys_open+0x24a>
    for(j = 0; j <= i; ++j) {
    80004d1e:	2705                	addiw	a4,a4,1
    80004d20:	0791                	addi	a5,a5,4
    80004d22:	fee95be3          	bge	s2,a4,80004d18 <sys_open+0x1d4>
    ilock(ip);
    80004d26:	8526                	mv	a0,s1
    80004d28:	ffffe097          	auipc	ra,0xffffe
    80004d2c:	e04080e7          	jalr	-508(ra) # 80002b2c <ilock>
    if(ip->type != T_SYMLINK) {
    80004d30:	04449783          	lh	a5,68(s1)
    80004d34:	e9579ce3          	bne	a5,s5,80004bcc <sys_open+0x88>
  for(i = 0; i < NSYMLINK; ++i) {
    80004d38:	2905                	addiw	s2,s2,1
    80004d3a:	0a11                	addi	s4,s4,4
    80004d3c:	f9691be3          	bne	s2,s6,80004cd2 <sys_open+0x18e>
  iunlockput(ip);
    80004d40:	8526                	mv	a0,s1
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	0f6080e7          	jalr	246(ra) # 80002e38 <iunlockput>
  printf("open_symlink: the depth of links reaches the limit\n");
    80004d4a:	00004517          	auipc	a0,0x4
    80004d4e:	a1e50513          	addi	a0,a0,-1506 # 80008768 <syscalls+0x3a0>
    80004d52:	00001097          	auipc	ra,0x1
    80004d56:	140080e7          	jalr	320(ra) # 80005e92 <printf>
  return 0;
    80004d5a:	a091                	j	80004d9e <sys_open+0x25a>
      iunlockput(ip);
    80004d5c:	8526                	mv	a0,s1
    80004d5e:	ffffe097          	auipc	ra,0xffffe
    80004d62:	0da080e7          	jalr	218(ra) # 80002e38 <iunlockput>
      printf("open_symlink: open symlink failed\n");
    80004d66:	00004517          	auipc	a0,0x4
    80004d6a:	98a50513          	addi	a0,a0,-1654 # 800086f0 <syscalls+0x328>
    80004d6e:	00001097          	auipc	ra,0x1
    80004d72:	124080e7          	jalr	292(ra) # 80005e92 <printf>
      return 0;
    80004d76:	a025                	j	80004d9e <sys_open+0x25a>
      printf("open_symlink: path \"%s\" is not exist\n", target);
    80004d78:	eb840593          	addi	a1,s0,-328
    80004d7c:	00004517          	auipc	a0,0x4
    80004d80:	99c50513          	addi	a0,a0,-1636 # 80008718 <syscalls+0x350>
    80004d84:	00001097          	auipc	ra,0x1
    80004d88:	10e080e7          	jalr	270(ra) # 80005e92 <printf>
      return 0;
    80004d8c:	a809                	j	80004d9e <sys_open+0x25a>
        printf("open_symlink: links form a cycle\n");
    80004d8e:	00004517          	auipc	a0,0x4
    80004d92:	9b250513          	addi	a0,a0,-1614 # 80008740 <syscalls+0x378>
    80004d96:	00001097          	auipc	ra,0x1
    80004d9a:	0fc080e7          	jalr	252(ra) # 80005e92 <printf>
      end_op();
    80004d9e:	fffff097          	auipc	ra,0xfffff
    80004da2:	88c080e7          	jalr	-1908(ra) # 8000362a <end_op>
      return -1;
    80004da6:	597d                	li	s2,-1
    80004da8:	bd51                	j	80004c3c <sys_open+0xf8>
    f->type = FD_DEVICE;
    80004daa:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dae:	04649783          	lh	a5,70(s1)
    80004db2:	02f99223          	sh	a5,36(s3)
    80004db6:	b599                	j	80004bfc <sys_open+0xb8>
    itrunc(ip);
    80004db8:	8526                	mv	a0,s1
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	e80080e7          	jalr	-384(ra) # 80002c3a <itrunc>
    80004dc2:	b5a5                	j	80004c2a <sys_open+0xe6>
      fileclose(f);
    80004dc4:	854e                	mv	a0,s3
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	cb0080e7          	jalr	-848(ra) # 80003a76 <fileclose>
    iunlockput(ip);
    80004dce:	8526                	mv	a0,s1
    80004dd0:	ffffe097          	auipc	ra,0xffffe
    80004dd4:	068080e7          	jalr	104(ra) # 80002e38 <iunlockput>
    end_op();
    80004dd8:	fffff097          	auipc	ra,0xfffff
    80004ddc:	852080e7          	jalr	-1966(ra) # 8000362a <end_op>
    return -1;
    80004de0:	597d                	li	s2,-1
    80004de2:	bda9                	j	80004c3c <sys_open+0xf8>

0000000080004de4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004de4:	7175                	addi	sp,sp,-144
    80004de6:	e506                	sd	ra,136(sp)
    80004de8:	e122                	sd	s0,128(sp)
    80004dea:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	7be080e7          	jalr	1982(ra) # 800035aa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004df4:	08000613          	li	a2,128
    80004df8:	f7040593          	addi	a1,s0,-144
    80004dfc:	4501                	li	a0,0
    80004dfe:	ffffd097          	auipc	ra,0xffffd
    80004e02:	13a080e7          	jalr	314(ra) # 80001f38 <argstr>
    80004e06:	02054963          	bltz	a0,80004e38 <sys_mkdir+0x54>
    80004e0a:	4681                	li	a3,0
    80004e0c:	4601                	li	a2,0
    80004e0e:	4585                	li	a1,1
    80004e10:	f7040513          	addi	a0,s0,-144
    80004e14:	fffff097          	auipc	ra,0xfffff
    80004e18:	6f6080e7          	jalr	1782(ra) # 8000450a <create>
    80004e1c:	cd11                	beqz	a0,80004e38 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	01a080e7          	jalr	26(ra) # 80002e38 <iunlockput>
  end_op();
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	804080e7          	jalr	-2044(ra) # 8000362a <end_op>
  return 0;
    80004e2e:	4501                	li	a0,0
}
    80004e30:	60aa                	ld	ra,136(sp)
    80004e32:	640a                	ld	s0,128(sp)
    80004e34:	6149                	addi	sp,sp,144
    80004e36:	8082                	ret
    end_op();
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	7f2080e7          	jalr	2034(ra) # 8000362a <end_op>
    return -1;
    80004e40:	557d                	li	a0,-1
    80004e42:	b7fd                	j	80004e30 <sys_mkdir+0x4c>

0000000080004e44 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e44:	7135                	addi	sp,sp,-160
    80004e46:	ed06                	sd	ra,152(sp)
    80004e48:	e922                	sd	s0,144(sp)
    80004e4a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e4c:	ffffe097          	auipc	ra,0xffffe
    80004e50:	75e080e7          	jalr	1886(ra) # 800035aa <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e54:	08000613          	li	a2,128
    80004e58:	f7040593          	addi	a1,s0,-144
    80004e5c:	4501                	li	a0,0
    80004e5e:	ffffd097          	auipc	ra,0xffffd
    80004e62:	0da080e7          	jalr	218(ra) # 80001f38 <argstr>
    80004e66:	04054a63          	bltz	a0,80004eba <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e6a:	f6c40593          	addi	a1,s0,-148
    80004e6e:	4505                	li	a0,1
    80004e70:	ffffd097          	auipc	ra,0xffffd
    80004e74:	084080e7          	jalr	132(ra) # 80001ef4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e78:	04054163          	bltz	a0,80004eba <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e7c:	f6840593          	addi	a1,s0,-152
    80004e80:	4509                	li	a0,2
    80004e82:	ffffd097          	auipc	ra,0xffffd
    80004e86:	072080e7          	jalr	114(ra) # 80001ef4 <argint>
     argint(1, &major) < 0 ||
    80004e8a:	02054863          	bltz	a0,80004eba <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e8e:	f6841683          	lh	a3,-152(s0)
    80004e92:	f6c41603          	lh	a2,-148(s0)
    80004e96:	458d                	li	a1,3
    80004e98:	f7040513          	addi	a0,s0,-144
    80004e9c:	fffff097          	auipc	ra,0xfffff
    80004ea0:	66e080e7          	jalr	1646(ra) # 8000450a <create>
     argint(2, &minor) < 0 ||
    80004ea4:	c919                	beqz	a0,80004eba <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ea6:	ffffe097          	auipc	ra,0xffffe
    80004eaa:	f92080e7          	jalr	-110(ra) # 80002e38 <iunlockput>
  end_op();
    80004eae:	ffffe097          	auipc	ra,0xffffe
    80004eb2:	77c080e7          	jalr	1916(ra) # 8000362a <end_op>
  return 0;
    80004eb6:	4501                	li	a0,0
    80004eb8:	a031                	j	80004ec4 <sys_mknod+0x80>
    end_op();
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	770080e7          	jalr	1904(ra) # 8000362a <end_op>
    return -1;
    80004ec2:	557d                	li	a0,-1
}
    80004ec4:	60ea                	ld	ra,152(sp)
    80004ec6:	644a                	ld	s0,144(sp)
    80004ec8:	610d                	addi	sp,sp,160
    80004eca:	8082                	ret

0000000080004ecc <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ecc:	7135                	addi	sp,sp,-160
    80004ece:	ed06                	sd	ra,152(sp)
    80004ed0:	e922                	sd	s0,144(sp)
    80004ed2:	e526                	sd	s1,136(sp)
    80004ed4:	e14a                	sd	s2,128(sp)
    80004ed6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ed8:	ffffc097          	auipc	ra,0xffffc
    80004edc:	f70080e7          	jalr	-144(ra) # 80000e48 <myproc>
    80004ee0:	892a                	mv	s2,a0
  
  begin_op();
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	6c8080e7          	jalr	1736(ra) # 800035aa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004eea:	08000613          	li	a2,128
    80004eee:	f6040593          	addi	a1,s0,-160
    80004ef2:	4501                	li	a0,0
    80004ef4:	ffffd097          	auipc	ra,0xffffd
    80004ef8:	044080e7          	jalr	68(ra) # 80001f38 <argstr>
    80004efc:	04054b63          	bltz	a0,80004f52 <sys_chdir+0x86>
    80004f00:	f6040513          	addi	a0,s0,-160
    80004f04:	ffffe097          	auipc	ra,0xffffe
    80004f08:	48a080e7          	jalr	1162(ra) # 8000338e <namei>
    80004f0c:	84aa                	mv	s1,a0
    80004f0e:	c131                	beqz	a0,80004f52 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f10:	ffffe097          	auipc	ra,0xffffe
    80004f14:	c1c080e7          	jalr	-996(ra) # 80002b2c <ilock>
  if(ip->type != T_DIR){
    80004f18:	04449703          	lh	a4,68(s1)
    80004f1c:	4785                	li	a5,1
    80004f1e:	04f71063          	bne	a4,a5,80004f5e <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f22:	8526                	mv	a0,s1
    80004f24:	ffffe097          	auipc	ra,0xffffe
    80004f28:	cca080e7          	jalr	-822(ra) # 80002bee <iunlock>
  iput(p->cwd);
    80004f2c:	15093503          	ld	a0,336(s2)
    80004f30:	ffffe097          	auipc	ra,0xffffe
    80004f34:	e60080e7          	jalr	-416(ra) # 80002d90 <iput>
  end_op();
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	6f2080e7          	jalr	1778(ra) # 8000362a <end_op>
  p->cwd = ip;
    80004f40:	14993823          	sd	s1,336(s2)
  return 0;
    80004f44:	4501                	li	a0,0
}
    80004f46:	60ea                	ld	ra,152(sp)
    80004f48:	644a                	ld	s0,144(sp)
    80004f4a:	64aa                	ld	s1,136(sp)
    80004f4c:	690a                	ld	s2,128(sp)
    80004f4e:	610d                	addi	sp,sp,160
    80004f50:	8082                	ret
    end_op();
    80004f52:	ffffe097          	auipc	ra,0xffffe
    80004f56:	6d8080e7          	jalr	1752(ra) # 8000362a <end_op>
    return -1;
    80004f5a:	557d                	li	a0,-1
    80004f5c:	b7ed                	j	80004f46 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f5e:	8526                	mv	a0,s1
    80004f60:	ffffe097          	auipc	ra,0xffffe
    80004f64:	ed8080e7          	jalr	-296(ra) # 80002e38 <iunlockput>
    end_op();
    80004f68:	ffffe097          	auipc	ra,0xffffe
    80004f6c:	6c2080e7          	jalr	1730(ra) # 8000362a <end_op>
    return -1;
    80004f70:	557d                	li	a0,-1
    80004f72:	bfd1                	j	80004f46 <sys_chdir+0x7a>

0000000080004f74 <sys_exec>:

uint64
sys_exec(void)
{
    80004f74:	7145                	addi	sp,sp,-464
    80004f76:	e786                	sd	ra,456(sp)
    80004f78:	e3a2                	sd	s0,448(sp)
    80004f7a:	ff26                	sd	s1,440(sp)
    80004f7c:	fb4a                	sd	s2,432(sp)
    80004f7e:	f74e                	sd	s3,424(sp)
    80004f80:	f352                	sd	s4,416(sp)
    80004f82:	ef56                	sd	s5,408(sp)
    80004f84:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f86:	08000613          	li	a2,128
    80004f8a:	f4040593          	addi	a1,s0,-192
    80004f8e:	4501                	li	a0,0
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	fa8080e7          	jalr	-88(ra) # 80001f38 <argstr>
    return -1;
    80004f98:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f9a:	0c054a63          	bltz	a0,8000506e <sys_exec+0xfa>
    80004f9e:	e3840593          	addi	a1,s0,-456
    80004fa2:	4505                	li	a0,1
    80004fa4:	ffffd097          	auipc	ra,0xffffd
    80004fa8:	f72080e7          	jalr	-142(ra) # 80001f16 <argaddr>
    80004fac:	0c054163          	bltz	a0,8000506e <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fb0:	10000613          	li	a2,256
    80004fb4:	4581                	li	a1,0
    80004fb6:	e4040513          	addi	a0,s0,-448
    80004fba:	ffffb097          	auipc	ra,0xffffb
    80004fbe:	1be080e7          	jalr	446(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fc2:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fc6:	89a6                	mv	s3,s1
    80004fc8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fca:	02000a13          	li	s4,32
    80004fce:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fd2:	00391513          	slli	a0,s2,0x3
    80004fd6:	e3040593          	addi	a1,s0,-464
    80004fda:	e3843783          	ld	a5,-456(s0)
    80004fde:	953e                	add	a0,a0,a5
    80004fe0:	ffffd097          	auipc	ra,0xffffd
    80004fe4:	e7a080e7          	jalr	-390(ra) # 80001e5a <fetchaddr>
    80004fe8:	02054a63          	bltz	a0,8000501c <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004fec:	e3043783          	ld	a5,-464(s0)
    80004ff0:	c3b9                	beqz	a5,80005036 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ff2:	ffffb097          	auipc	ra,0xffffb
    80004ff6:	126080e7          	jalr	294(ra) # 80000118 <kalloc>
    80004ffa:	85aa                	mv	a1,a0
    80004ffc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005000:	cd11                	beqz	a0,8000501c <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005002:	6605                	lui	a2,0x1
    80005004:	e3043503          	ld	a0,-464(s0)
    80005008:	ffffd097          	auipc	ra,0xffffd
    8000500c:	ea4080e7          	jalr	-348(ra) # 80001eac <fetchstr>
    80005010:	00054663          	bltz	a0,8000501c <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005014:	0905                	addi	s2,s2,1
    80005016:	09a1                	addi	s3,s3,8
    80005018:	fb491be3          	bne	s2,s4,80004fce <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000501c:	10048913          	addi	s2,s1,256
    80005020:	6088                	ld	a0,0(s1)
    80005022:	c529                	beqz	a0,8000506c <sys_exec+0xf8>
    kfree(argv[i]);
    80005024:	ffffb097          	auipc	ra,0xffffb
    80005028:	ff8080e7          	jalr	-8(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000502c:	04a1                	addi	s1,s1,8
    8000502e:	ff2499e3          	bne	s1,s2,80005020 <sys_exec+0xac>
  return -1;
    80005032:	597d                	li	s2,-1
    80005034:	a82d                	j	8000506e <sys_exec+0xfa>
      argv[i] = 0;
    80005036:	0a8e                	slli	s5,s5,0x3
    80005038:	fc040793          	addi	a5,s0,-64
    8000503c:	9abe                	add	s5,s5,a5
    8000503e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005042:	e4040593          	addi	a1,s0,-448
    80005046:	f4040513          	addi	a0,s0,-192
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	08c080e7          	jalr	140(ra) # 800040d6 <exec>
    80005052:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005054:	10048993          	addi	s3,s1,256
    80005058:	6088                	ld	a0,0(s1)
    8000505a:	c911                	beqz	a0,8000506e <sys_exec+0xfa>
    kfree(argv[i]);
    8000505c:	ffffb097          	auipc	ra,0xffffb
    80005060:	fc0080e7          	jalr	-64(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005064:	04a1                	addi	s1,s1,8
    80005066:	ff3499e3          	bne	s1,s3,80005058 <sys_exec+0xe4>
    8000506a:	a011                	j	8000506e <sys_exec+0xfa>
  return -1;
    8000506c:	597d                	li	s2,-1
}
    8000506e:	854a                	mv	a0,s2
    80005070:	60be                	ld	ra,456(sp)
    80005072:	641e                	ld	s0,448(sp)
    80005074:	74fa                	ld	s1,440(sp)
    80005076:	795a                	ld	s2,432(sp)
    80005078:	79ba                	ld	s3,424(sp)
    8000507a:	7a1a                	ld	s4,416(sp)
    8000507c:	6afa                	ld	s5,408(sp)
    8000507e:	6179                	addi	sp,sp,464
    80005080:	8082                	ret

0000000080005082 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005082:	7139                	addi	sp,sp,-64
    80005084:	fc06                	sd	ra,56(sp)
    80005086:	f822                	sd	s0,48(sp)
    80005088:	f426                	sd	s1,40(sp)
    8000508a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000508c:	ffffc097          	auipc	ra,0xffffc
    80005090:	dbc080e7          	jalr	-580(ra) # 80000e48 <myproc>
    80005094:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005096:	fd840593          	addi	a1,s0,-40
    8000509a:	4501                	li	a0,0
    8000509c:	ffffd097          	auipc	ra,0xffffd
    800050a0:	e7a080e7          	jalr	-390(ra) # 80001f16 <argaddr>
    return -1;
    800050a4:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050a6:	0e054063          	bltz	a0,80005186 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050aa:	fc840593          	addi	a1,s0,-56
    800050ae:	fd040513          	addi	a0,s0,-48
    800050b2:	fffff097          	auipc	ra,0xfffff
    800050b6:	cf4080e7          	jalr	-780(ra) # 80003da6 <pipealloc>
    return -1;
    800050ba:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050bc:	0c054563          	bltz	a0,80005186 <sys_pipe+0x104>
  fd0 = -1;
    800050c0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050c4:	fd043503          	ld	a0,-48(s0)
    800050c8:	fffff097          	auipc	ra,0xfffff
    800050cc:	400080e7          	jalr	1024(ra) # 800044c8 <fdalloc>
    800050d0:	fca42223          	sw	a0,-60(s0)
    800050d4:	08054c63          	bltz	a0,8000516c <sys_pipe+0xea>
    800050d8:	fc843503          	ld	a0,-56(s0)
    800050dc:	fffff097          	auipc	ra,0xfffff
    800050e0:	3ec080e7          	jalr	1004(ra) # 800044c8 <fdalloc>
    800050e4:	fca42023          	sw	a0,-64(s0)
    800050e8:	06054863          	bltz	a0,80005158 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ec:	4691                	li	a3,4
    800050ee:	fc440613          	addi	a2,s0,-60
    800050f2:	fd843583          	ld	a1,-40(s0)
    800050f6:	68a8                	ld	a0,80(s1)
    800050f8:	ffffc097          	auipc	ra,0xffffc
    800050fc:	a12080e7          	jalr	-1518(ra) # 80000b0a <copyout>
    80005100:	02054063          	bltz	a0,80005120 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005104:	4691                	li	a3,4
    80005106:	fc040613          	addi	a2,s0,-64
    8000510a:	fd843583          	ld	a1,-40(s0)
    8000510e:	0591                	addi	a1,a1,4
    80005110:	68a8                	ld	a0,80(s1)
    80005112:	ffffc097          	auipc	ra,0xffffc
    80005116:	9f8080e7          	jalr	-1544(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000511a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000511c:	06055563          	bgez	a0,80005186 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005120:	fc442783          	lw	a5,-60(s0)
    80005124:	07e9                	addi	a5,a5,26
    80005126:	078e                	slli	a5,a5,0x3
    80005128:	97a6                	add	a5,a5,s1
    8000512a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000512e:	fc042503          	lw	a0,-64(s0)
    80005132:	0569                	addi	a0,a0,26
    80005134:	050e                	slli	a0,a0,0x3
    80005136:	9526                	add	a0,a0,s1
    80005138:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000513c:	fd043503          	ld	a0,-48(s0)
    80005140:	fffff097          	auipc	ra,0xfffff
    80005144:	936080e7          	jalr	-1738(ra) # 80003a76 <fileclose>
    fileclose(wf);
    80005148:	fc843503          	ld	a0,-56(s0)
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	92a080e7          	jalr	-1750(ra) # 80003a76 <fileclose>
    return -1;
    80005154:	57fd                	li	a5,-1
    80005156:	a805                	j	80005186 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005158:	fc442783          	lw	a5,-60(s0)
    8000515c:	0007c863          	bltz	a5,8000516c <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005160:	01a78513          	addi	a0,a5,26
    80005164:	050e                	slli	a0,a0,0x3
    80005166:	9526                	add	a0,a0,s1
    80005168:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000516c:	fd043503          	ld	a0,-48(s0)
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	906080e7          	jalr	-1786(ra) # 80003a76 <fileclose>
    fileclose(wf);
    80005178:	fc843503          	ld	a0,-56(s0)
    8000517c:	fffff097          	auipc	ra,0xfffff
    80005180:	8fa080e7          	jalr	-1798(ra) # 80003a76 <fileclose>
    return -1;
    80005184:	57fd                	li	a5,-1
}
    80005186:	853e                	mv	a0,a5
    80005188:	70e2                	ld	ra,56(sp)
    8000518a:	7442                	ld	s0,48(sp)
    8000518c:	74a2                	ld	s1,40(sp)
    8000518e:	6121                	addi	sp,sp,64
    80005190:	8082                	ret

0000000080005192 <sys_symlink>:

// lab9-2
uint64 sys_symlink(void) {
    80005192:	712d                	addi	sp,sp,-288
    80005194:	ee06                	sd	ra,280(sp)
    80005196:	ea22                	sd	s0,272(sp)
    80005198:	e626                	sd	s1,264(sp)
    8000519a:	e24a                	sd	s2,256(sp)
    8000519c:	1200                	addi	s0,sp,288
  char target[MAXPATH], path[MAXPATH];
  struct inode *ip;
  int n;

  if ((n = argstr(0, target, MAXPATH)) < 0
    8000519e:	08000613          	li	a2,128
    800051a2:	f6040593          	addi	a1,s0,-160
    800051a6:	4501                	li	a0,0
    800051a8:	ffffd097          	auipc	ra,0xffffd
    800051ac:	d90080e7          	jalr	-624(ra) # 80001f38 <argstr>
    800051b0:	84aa                	mv	s1,a0
    || argstr(1, path, MAXPATH) < 0) {
    return -1;
    800051b2:	557d                	li	a0,-1
  if ((n = argstr(0, target, MAXPATH)) < 0
    800051b4:	0604c463          	bltz	s1,8000521c <sys_symlink+0x8a>
    || argstr(1, path, MAXPATH) < 0) {
    800051b8:	08000613          	li	a2,128
    800051bc:	ee040593          	addi	a1,s0,-288
    800051c0:	4505                	li	a0,1
    800051c2:	ffffd097          	auipc	ra,0xffffd
    800051c6:	d76080e7          	jalr	-650(ra) # 80001f38 <argstr>
    800051ca:	87aa                	mv	a5,a0
    return -1;
    800051cc:	557d                	li	a0,-1
    || argstr(1, path, MAXPATH) < 0) {
    800051ce:	0407c763          	bltz	a5,8000521c <sys_symlink+0x8a>
  }

  begin_op();
    800051d2:	ffffe097          	auipc	ra,0xffffe
    800051d6:	3d8080e7          	jalr	984(ra) # 800035aa <begin_op>
  // create the symlink's inode
  if((ip = create(path, T_SYMLINK, 0, 0)) == 0) {
    800051da:	4681                	li	a3,0
    800051dc:	4601                	li	a2,0
    800051de:	4591                	li	a1,4
    800051e0:	ee040513          	addi	a0,s0,-288
    800051e4:	fffff097          	auipc	ra,0xfffff
    800051e8:	326080e7          	jalr	806(ra) # 8000450a <create>
    800051ec:	892a                	mv	s2,a0
    800051ee:	cd0d                	beqz	a0,80005228 <sys_symlink+0x96>
    end_op();
    return -1;
  }
  // write the target path to the inode
  if(writei(ip, 0, (uint64)target, 0, n) != n) {
    800051f0:	0004871b          	sext.w	a4,s1
    800051f4:	4681                	li	a3,0
    800051f6:	f6040613          	addi	a2,s0,-160
    800051fa:	4581                	li	a1,0
    800051fc:	ffffe097          	auipc	ra,0xffffe
    80005200:	d86080e7          	jalr	-634(ra) # 80002f82 <writei>
    80005204:	02951863          	bne	a0,s1,80005234 <sys_symlink+0xa2>
    iunlockput(ip);
    end_op();
    return -1;
  }

  iunlockput(ip);
    80005208:	854a                	mv	a0,s2
    8000520a:	ffffe097          	auipc	ra,0xffffe
    8000520e:	c2e080e7          	jalr	-978(ra) # 80002e38 <iunlockput>
  end_op();
    80005212:	ffffe097          	auipc	ra,0xffffe
    80005216:	418080e7          	jalr	1048(ra) # 8000362a <end_op>
  return 0;
    8000521a:	4501                	li	a0,0
}
    8000521c:	60f2                	ld	ra,280(sp)
    8000521e:	6452                	ld	s0,272(sp)
    80005220:	64b2                	ld	s1,264(sp)
    80005222:	6912                	ld	s2,256(sp)
    80005224:	6115                	addi	sp,sp,288
    80005226:	8082                	ret
    end_op();
    80005228:	ffffe097          	auipc	ra,0xffffe
    8000522c:	402080e7          	jalr	1026(ra) # 8000362a <end_op>
    return -1;
    80005230:	557d                	li	a0,-1
    80005232:	b7ed                	j	8000521c <sys_symlink+0x8a>
    iunlockput(ip);
    80005234:	854a                	mv	a0,s2
    80005236:	ffffe097          	auipc	ra,0xffffe
    8000523a:	c02080e7          	jalr	-1022(ra) # 80002e38 <iunlockput>
    end_op();
    8000523e:	ffffe097          	auipc	ra,0xffffe
    80005242:	3ec080e7          	jalr	1004(ra) # 8000362a <end_op>
    return -1;
    80005246:	557d                	li	a0,-1
    80005248:	bfd1                	j	8000521c <sys_symlink+0x8a>
    8000524a:	0000                	unimp
    8000524c:	0000                	unimp
	...

0000000080005250 <kernelvec>:
    80005250:	7111                	addi	sp,sp,-256
    80005252:	e006                	sd	ra,0(sp)
    80005254:	e40a                	sd	sp,8(sp)
    80005256:	e80e                	sd	gp,16(sp)
    80005258:	ec12                	sd	tp,24(sp)
    8000525a:	f016                	sd	t0,32(sp)
    8000525c:	f41a                	sd	t1,40(sp)
    8000525e:	f81e                	sd	t2,48(sp)
    80005260:	fc22                	sd	s0,56(sp)
    80005262:	e0a6                	sd	s1,64(sp)
    80005264:	e4aa                	sd	a0,72(sp)
    80005266:	e8ae                	sd	a1,80(sp)
    80005268:	ecb2                	sd	a2,88(sp)
    8000526a:	f0b6                	sd	a3,96(sp)
    8000526c:	f4ba                	sd	a4,104(sp)
    8000526e:	f8be                	sd	a5,112(sp)
    80005270:	fcc2                	sd	a6,120(sp)
    80005272:	e146                	sd	a7,128(sp)
    80005274:	e54a                	sd	s2,136(sp)
    80005276:	e94e                	sd	s3,144(sp)
    80005278:	ed52                	sd	s4,152(sp)
    8000527a:	f156                	sd	s5,160(sp)
    8000527c:	f55a                	sd	s6,168(sp)
    8000527e:	f95e                	sd	s7,176(sp)
    80005280:	fd62                	sd	s8,184(sp)
    80005282:	e1e6                	sd	s9,192(sp)
    80005284:	e5ea                	sd	s10,200(sp)
    80005286:	e9ee                	sd	s11,208(sp)
    80005288:	edf2                	sd	t3,216(sp)
    8000528a:	f1f6                	sd	t4,224(sp)
    8000528c:	f5fa                	sd	t5,232(sp)
    8000528e:	f9fe                	sd	t6,240(sp)
    80005290:	a97fc0ef          	jal	ra,80001d26 <kerneltrap>
    80005294:	6082                	ld	ra,0(sp)
    80005296:	6122                	ld	sp,8(sp)
    80005298:	61c2                	ld	gp,16(sp)
    8000529a:	7282                	ld	t0,32(sp)
    8000529c:	7322                	ld	t1,40(sp)
    8000529e:	73c2                	ld	t2,48(sp)
    800052a0:	7462                	ld	s0,56(sp)
    800052a2:	6486                	ld	s1,64(sp)
    800052a4:	6526                	ld	a0,72(sp)
    800052a6:	65c6                	ld	a1,80(sp)
    800052a8:	6666                	ld	a2,88(sp)
    800052aa:	7686                	ld	a3,96(sp)
    800052ac:	7726                	ld	a4,104(sp)
    800052ae:	77c6                	ld	a5,112(sp)
    800052b0:	7866                	ld	a6,120(sp)
    800052b2:	688a                	ld	a7,128(sp)
    800052b4:	692a                	ld	s2,136(sp)
    800052b6:	69ca                	ld	s3,144(sp)
    800052b8:	6a6a                	ld	s4,152(sp)
    800052ba:	7a8a                	ld	s5,160(sp)
    800052bc:	7b2a                	ld	s6,168(sp)
    800052be:	7bca                	ld	s7,176(sp)
    800052c0:	7c6a                	ld	s8,184(sp)
    800052c2:	6c8e                	ld	s9,192(sp)
    800052c4:	6d2e                	ld	s10,200(sp)
    800052c6:	6dce                	ld	s11,208(sp)
    800052c8:	6e6e                	ld	t3,216(sp)
    800052ca:	7e8e                	ld	t4,224(sp)
    800052cc:	7f2e                	ld	t5,232(sp)
    800052ce:	7fce                	ld	t6,240(sp)
    800052d0:	6111                	addi	sp,sp,256
    800052d2:	10200073          	sret
    800052d6:	00000013          	nop
    800052da:	00000013          	nop
    800052de:	0001                	nop

00000000800052e0 <timervec>:
    800052e0:	34051573          	csrrw	a0,mscratch,a0
    800052e4:	e10c                	sd	a1,0(a0)
    800052e6:	e510                	sd	a2,8(a0)
    800052e8:	e914                	sd	a3,16(a0)
    800052ea:	6d0c                	ld	a1,24(a0)
    800052ec:	7110                	ld	a2,32(a0)
    800052ee:	6194                	ld	a3,0(a1)
    800052f0:	96b2                	add	a3,a3,a2
    800052f2:	e194                	sd	a3,0(a1)
    800052f4:	4589                	li	a1,2
    800052f6:	14459073          	csrw	sip,a1
    800052fa:	6914                	ld	a3,16(a0)
    800052fc:	6510                	ld	a2,8(a0)
    800052fe:	610c                	ld	a1,0(a0)
    80005300:	34051573          	csrrw	a0,mscratch,a0
    80005304:	30200073          	mret
	...

000000008000530a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000530a:	1141                	addi	sp,sp,-16
    8000530c:	e422                	sd	s0,8(sp)
    8000530e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005310:	0c0007b7          	lui	a5,0xc000
    80005314:	4705                	li	a4,1
    80005316:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005318:	c3d8                	sw	a4,4(a5)
}
    8000531a:	6422                	ld	s0,8(sp)
    8000531c:	0141                	addi	sp,sp,16
    8000531e:	8082                	ret

0000000080005320 <plicinithart>:

void
plicinithart(void)
{
    80005320:	1141                	addi	sp,sp,-16
    80005322:	e406                	sd	ra,8(sp)
    80005324:	e022                	sd	s0,0(sp)
    80005326:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005328:	ffffc097          	auipc	ra,0xffffc
    8000532c:	af4080e7          	jalr	-1292(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005330:	0085171b          	slliw	a4,a0,0x8
    80005334:	0c0027b7          	lui	a5,0xc002
    80005338:	97ba                	add	a5,a5,a4
    8000533a:	40200713          	li	a4,1026
    8000533e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005342:	00d5151b          	slliw	a0,a0,0xd
    80005346:	0c2017b7          	lui	a5,0xc201
    8000534a:	953e                	add	a0,a0,a5
    8000534c:	00052023          	sw	zero,0(a0)
}
    80005350:	60a2                	ld	ra,8(sp)
    80005352:	6402                	ld	s0,0(sp)
    80005354:	0141                	addi	sp,sp,16
    80005356:	8082                	ret

0000000080005358 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005358:	1141                	addi	sp,sp,-16
    8000535a:	e406                	sd	ra,8(sp)
    8000535c:	e022                	sd	s0,0(sp)
    8000535e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005360:	ffffc097          	auipc	ra,0xffffc
    80005364:	abc080e7          	jalr	-1348(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005368:	00d5179b          	slliw	a5,a0,0xd
    8000536c:	0c201537          	lui	a0,0xc201
    80005370:	953e                	add	a0,a0,a5
  return irq;
}
    80005372:	4148                	lw	a0,4(a0)
    80005374:	60a2                	ld	ra,8(sp)
    80005376:	6402                	ld	s0,0(sp)
    80005378:	0141                	addi	sp,sp,16
    8000537a:	8082                	ret

000000008000537c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000537c:	1101                	addi	sp,sp,-32
    8000537e:	ec06                	sd	ra,24(sp)
    80005380:	e822                	sd	s0,16(sp)
    80005382:	e426                	sd	s1,8(sp)
    80005384:	1000                	addi	s0,sp,32
    80005386:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005388:	ffffc097          	auipc	ra,0xffffc
    8000538c:	a94080e7          	jalr	-1388(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005390:	00d5151b          	slliw	a0,a0,0xd
    80005394:	0c2017b7          	lui	a5,0xc201
    80005398:	97aa                	add	a5,a5,a0
    8000539a:	c3c4                	sw	s1,4(a5)
}
    8000539c:	60e2                	ld	ra,24(sp)
    8000539e:	6442                	ld	s0,16(sp)
    800053a0:	64a2                	ld	s1,8(sp)
    800053a2:	6105                	addi	sp,sp,32
    800053a4:	8082                	ret

00000000800053a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053a6:	1141                	addi	sp,sp,-16
    800053a8:	e406                	sd	ra,8(sp)
    800053aa:	e022                	sd	s0,0(sp)
    800053ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ae:	479d                	li	a5,7
    800053b0:	06a7c963          	blt	a5,a0,80005422 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800053b4:	00011797          	auipc	a5,0x11
    800053b8:	c4c78793          	addi	a5,a5,-948 # 80016000 <disk>
    800053bc:	00a78733          	add	a4,a5,a0
    800053c0:	6789                	lui	a5,0x2
    800053c2:	97ba                	add	a5,a5,a4
    800053c4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800053c8:	e7ad                	bnez	a5,80005432 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053ca:	00451793          	slli	a5,a0,0x4
    800053ce:	00013717          	auipc	a4,0x13
    800053d2:	c3270713          	addi	a4,a4,-974 # 80018000 <disk+0x2000>
    800053d6:	6314                	ld	a3,0(a4)
    800053d8:	96be                	add	a3,a3,a5
    800053da:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053de:	6314                	ld	a3,0(a4)
    800053e0:	96be                	add	a3,a3,a5
    800053e2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800053e6:	6314                	ld	a3,0(a4)
    800053e8:	96be                	add	a3,a3,a5
    800053ea:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800053ee:	6318                	ld	a4,0(a4)
    800053f0:	97ba                	add	a5,a5,a4
    800053f2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053f6:	00011797          	auipc	a5,0x11
    800053fa:	c0a78793          	addi	a5,a5,-1014 # 80016000 <disk>
    800053fe:	97aa                	add	a5,a5,a0
    80005400:	6509                	lui	a0,0x2
    80005402:	953e                	add	a0,a0,a5
    80005404:	4785                	li	a5,1
    80005406:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000540a:	00013517          	auipc	a0,0x13
    8000540e:	c0e50513          	addi	a0,a0,-1010 # 80018018 <disk+0x2018>
    80005412:	ffffc097          	auipc	ra,0xffffc
    80005416:	27e080e7          	jalr	638(ra) # 80001690 <wakeup>
}
    8000541a:	60a2                	ld	ra,8(sp)
    8000541c:	6402                	ld	s0,0(sp)
    8000541e:	0141                	addi	sp,sp,16
    80005420:	8082                	ret
    panic("free_desc 1");
    80005422:	00003517          	auipc	a0,0x3
    80005426:	37e50513          	addi	a0,a0,894 # 800087a0 <syscalls+0x3d8>
    8000542a:	00001097          	auipc	ra,0x1
    8000542e:	a1e080e7          	jalr	-1506(ra) # 80005e48 <panic>
    panic("free_desc 2");
    80005432:	00003517          	auipc	a0,0x3
    80005436:	37e50513          	addi	a0,a0,894 # 800087b0 <syscalls+0x3e8>
    8000543a:	00001097          	auipc	ra,0x1
    8000543e:	a0e080e7          	jalr	-1522(ra) # 80005e48 <panic>

0000000080005442 <virtio_disk_init>:
{
    80005442:	1101                	addi	sp,sp,-32
    80005444:	ec06                	sd	ra,24(sp)
    80005446:	e822                	sd	s0,16(sp)
    80005448:	e426                	sd	s1,8(sp)
    8000544a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000544c:	00003597          	auipc	a1,0x3
    80005450:	37458593          	addi	a1,a1,884 # 800087c0 <syscalls+0x3f8>
    80005454:	00013517          	auipc	a0,0x13
    80005458:	cd450513          	addi	a0,a0,-812 # 80018128 <disk+0x2128>
    8000545c:	00001097          	auipc	ra,0x1
    80005460:	ea6080e7          	jalr	-346(ra) # 80006302 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005464:	100017b7          	lui	a5,0x10001
    80005468:	4398                	lw	a4,0(a5)
    8000546a:	2701                	sext.w	a4,a4
    8000546c:	747277b7          	lui	a5,0x74727
    80005470:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005474:	0ef71163          	bne	a4,a5,80005556 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005478:	100017b7          	lui	a5,0x10001
    8000547c:	43dc                	lw	a5,4(a5)
    8000547e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005480:	4705                	li	a4,1
    80005482:	0ce79a63          	bne	a5,a4,80005556 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005486:	100017b7          	lui	a5,0x10001
    8000548a:	479c                	lw	a5,8(a5)
    8000548c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000548e:	4709                	li	a4,2
    80005490:	0ce79363          	bne	a5,a4,80005556 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005494:	100017b7          	lui	a5,0x10001
    80005498:	47d8                	lw	a4,12(a5)
    8000549a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000549c:	554d47b7          	lui	a5,0x554d4
    800054a0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054a4:	0af71963          	bne	a4,a5,80005556 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a8:	100017b7          	lui	a5,0x10001
    800054ac:	4705                	li	a4,1
    800054ae:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b0:	470d                	li	a4,3
    800054b2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054b4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054b6:	c7ffe737          	lui	a4,0xc7ffe
    800054ba:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd51f>
    800054be:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054c0:	2701                	sext.w	a4,a4
    800054c2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054c4:	472d                	li	a4,11
    800054c6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054c8:	473d                	li	a4,15
    800054ca:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800054cc:	6705                	lui	a4,0x1
    800054ce:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054d0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054d4:	5bdc                	lw	a5,52(a5)
    800054d6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054d8:	c7d9                	beqz	a5,80005566 <virtio_disk_init+0x124>
  if(max < NUM)
    800054da:	471d                	li	a4,7
    800054dc:	08f77d63          	bgeu	a4,a5,80005576 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054e0:	100014b7          	lui	s1,0x10001
    800054e4:	47a1                	li	a5,8
    800054e6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800054e8:	6609                	lui	a2,0x2
    800054ea:	4581                	li	a1,0
    800054ec:	00011517          	auipc	a0,0x11
    800054f0:	b1450513          	addi	a0,a0,-1260 # 80016000 <disk>
    800054f4:	ffffb097          	auipc	ra,0xffffb
    800054f8:	c84080e7          	jalr	-892(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054fc:	00011717          	auipc	a4,0x11
    80005500:	b0470713          	addi	a4,a4,-1276 # 80016000 <disk>
    80005504:	00c75793          	srli	a5,a4,0xc
    80005508:	2781                	sext.w	a5,a5
    8000550a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000550c:	00013797          	auipc	a5,0x13
    80005510:	af478793          	addi	a5,a5,-1292 # 80018000 <disk+0x2000>
    80005514:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005516:	00011717          	auipc	a4,0x11
    8000551a:	b6a70713          	addi	a4,a4,-1174 # 80016080 <disk+0x80>
    8000551e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005520:	00012717          	auipc	a4,0x12
    80005524:	ae070713          	addi	a4,a4,-1312 # 80017000 <disk+0x1000>
    80005528:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000552a:	4705                	li	a4,1
    8000552c:	00e78c23          	sb	a4,24(a5)
    80005530:	00e78ca3          	sb	a4,25(a5)
    80005534:	00e78d23          	sb	a4,26(a5)
    80005538:	00e78da3          	sb	a4,27(a5)
    8000553c:	00e78e23          	sb	a4,28(a5)
    80005540:	00e78ea3          	sb	a4,29(a5)
    80005544:	00e78f23          	sb	a4,30(a5)
    80005548:	00e78fa3          	sb	a4,31(a5)
}
    8000554c:	60e2                	ld	ra,24(sp)
    8000554e:	6442                	ld	s0,16(sp)
    80005550:	64a2                	ld	s1,8(sp)
    80005552:	6105                	addi	sp,sp,32
    80005554:	8082                	ret
    panic("could not find virtio disk");
    80005556:	00003517          	auipc	a0,0x3
    8000555a:	27a50513          	addi	a0,a0,634 # 800087d0 <syscalls+0x408>
    8000555e:	00001097          	auipc	ra,0x1
    80005562:	8ea080e7          	jalr	-1814(ra) # 80005e48 <panic>
    panic("virtio disk has no queue 0");
    80005566:	00003517          	auipc	a0,0x3
    8000556a:	28a50513          	addi	a0,a0,650 # 800087f0 <syscalls+0x428>
    8000556e:	00001097          	auipc	ra,0x1
    80005572:	8da080e7          	jalr	-1830(ra) # 80005e48 <panic>
    panic("virtio disk max queue too short");
    80005576:	00003517          	auipc	a0,0x3
    8000557a:	29a50513          	addi	a0,a0,666 # 80008810 <syscalls+0x448>
    8000557e:	00001097          	auipc	ra,0x1
    80005582:	8ca080e7          	jalr	-1846(ra) # 80005e48 <panic>

0000000080005586 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005586:	7159                	addi	sp,sp,-112
    80005588:	f486                	sd	ra,104(sp)
    8000558a:	f0a2                	sd	s0,96(sp)
    8000558c:	eca6                	sd	s1,88(sp)
    8000558e:	e8ca                	sd	s2,80(sp)
    80005590:	e4ce                	sd	s3,72(sp)
    80005592:	e0d2                	sd	s4,64(sp)
    80005594:	fc56                	sd	s5,56(sp)
    80005596:	f85a                	sd	s6,48(sp)
    80005598:	f45e                	sd	s7,40(sp)
    8000559a:	f062                	sd	s8,32(sp)
    8000559c:	ec66                	sd	s9,24(sp)
    8000559e:	e86a                	sd	s10,16(sp)
    800055a0:	1880                	addi	s0,sp,112
    800055a2:	892a                	mv	s2,a0
    800055a4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055a6:	00c52c83          	lw	s9,12(a0)
    800055aa:	001c9c9b          	slliw	s9,s9,0x1
    800055ae:	1c82                	slli	s9,s9,0x20
    800055b0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055b4:	00013517          	auipc	a0,0x13
    800055b8:	b7450513          	addi	a0,a0,-1164 # 80018128 <disk+0x2128>
    800055bc:	00001097          	auipc	ra,0x1
    800055c0:	dd6080e7          	jalr	-554(ra) # 80006392 <acquire>
  for(int i = 0; i < 3; i++){
    800055c4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055c6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800055c8:	00011b97          	auipc	s7,0x11
    800055cc:	a38b8b93          	addi	s7,s7,-1480 # 80016000 <disk>
    800055d0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800055d2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800055d4:	8a4e                	mv	s4,s3
    800055d6:	a051                	j	8000565a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800055d8:	00fb86b3          	add	a3,s7,a5
    800055dc:	96da                	add	a3,a3,s6
    800055de:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800055e2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800055e4:	0207c563          	bltz	a5,8000560e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055e8:	2485                	addiw	s1,s1,1
    800055ea:	0711                	addi	a4,a4,4
    800055ec:	25548063          	beq	s1,s5,8000582c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800055f0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800055f2:	00013697          	auipc	a3,0x13
    800055f6:	a2668693          	addi	a3,a3,-1498 # 80018018 <disk+0x2018>
    800055fa:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800055fc:	0006c583          	lbu	a1,0(a3)
    80005600:	fde1                	bnez	a1,800055d8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005602:	2785                	addiw	a5,a5,1
    80005604:	0685                	addi	a3,a3,1
    80005606:	ff879be3          	bne	a5,s8,800055fc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000560a:	57fd                	li	a5,-1
    8000560c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000560e:	02905a63          	blez	s1,80005642 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005612:	f9042503          	lw	a0,-112(s0)
    80005616:	00000097          	auipc	ra,0x0
    8000561a:	d90080e7          	jalr	-624(ra) # 800053a6 <free_desc>
      for(int j = 0; j < i; j++)
    8000561e:	4785                	li	a5,1
    80005620:	0297d163          	bge	a5,s1,80005642 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005624:	f9442503          	lw	a0,-108(s0)
    80005628:	00000097          	auipc	ra,0x0
    8000562c:	d7e080e7          	jalr	-642(ra) # 800053a6 <free_desc>
      for(int j = 0; j < i; j++)
    80005630:	4789                	li	a5,2
    80005632:	0097d863          	bge	a5,s1,80005642 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005636:	f9842503          	lw	a0,-104(s0)
    8000563a:	00000097          	auipc	ra,0x0
    8000563e:	d6c080e7          	jalr	-660(ra) # 800053a6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005642:	00013597          	auipc	a1,0x13
    80005646:	ae658593          	addi	a1,a1,-1306 # 80018128 <disk+0x2128>
    8000564a:	00013517          	auipc	a0,0x13
    8000564e:	9ce50513          	addi	a0,a0,-1586 # 80018018 <disk+0x2018>
    80005652:	ffffc097          	auipc	ra,0xffffc
    80005656:	eb2080e7          	jalr	-334(ra) # 80001504 <sleep>
  for(int i = 0; i < 3; i++){
    8000565a:	f9040713          	addi	a4,s0,-112
    8000565e:	84ce                	mv	s1,s3
    80005660:	bf41                	j	800055f0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005662:	20058713          	addi	a4,a1,512
    80005666:	00471693          	slli	a3,a4,0x4
    8000566a:	00011717          	auipc	a4,0x11
    8000566e:	99670713          	addi	a4,a4,-1642 # 80016000 <disk>
    80005672:	9736                	add	a4,a4,a3
    80005674:	4685                	li	a3,1
    80005676:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000567a:	20058713          	addi	a4,a1,512
    8000567e:	00471693          	slli	a3,a4,0x4
    80005682:	00011717          	auipc	a4,0x11
    80005686:	97e70713          	addi	a4,a4,-1666 # 80016000 <disk>
    8000568a:	9736                	add	a4,a4,a3
    8000568c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005690:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005694:	7679                	lui	a2,0xffffe
    80005696:	963e                	add	a2,a2,a5
    80005698:	00013697          	auipc	a3,0x13
    8000569c:	96868693          	addi	a3,a3,-1688 # 80018000 <disk+0x2000>
    800056a0:	6298                	ld	a4,0(a3)
    800056a2:	9732                	add	a4,a4,a2
    800056a4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056a6:	6298                	ld	a4,0(a3)
    800056a8:	9732                	add	a4,a4,a2
    800056aa:	4541                	li	a0,16
    800056ac:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056ae:	6298                	ld	a4,0(a3)
    800056b0:	9732                	add	a4,a4,a2
    800056b2:	4505                	li	a0,1
    800056b4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800056b8:	f9442703          	lw	a4,-108(s0)
    800056bc:	6288                	ld	a0,0(a3)
    800056be:	962a                	add	a2,a2,a0
    800056c0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffdcdce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800056c4:	0712                	slli	a4,a4,0x4
    800056c6:	6290                	ld	a2,0(a3)
    800056c8:	963a                	add	a2,a2,a4
    800056ca:	05890513          	addi	a0,s2,88
    800056ce:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800056d0:	6294                	ld	a3,0(a3)
    800056d2:	96ba                	add	a3,a3,a4
    800056d4:	40000613          	li	a2,1024
    800056d8:	c690                	sw	a2,8(a3)
  if(write)
    800056da:	140d0063          	beqz	s10,8000581a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056de:	00013697          	auipc	a3,0x13
    800056e2:	9226b683          	ld	a3,-1758(a3) # 80018000 <disk+0x2000>
    800056e6:	96ba                	add	a3,a3,a4
    800056e8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056ec:	00011817          	auipc	a6,0x11
    800056f0:	91480813          	addi	a6,a6,-1772 # 80016000 <disk>
    800056f4:	00013517          	auipc	a0,0x13
    800056f8:	90c50513          	addi	a0,a0,-1780 # 80018000 <disk+0x2000>
    800056fc:	6114                	ld	a3,0(a0)
    800056fe:	96ba                	add	a3,a3,a4
    80005700:	00c6d603          	lhu	a2,12(a3)
    80005704:	00166613          	ori	a2,a2,1
    80005708:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000570c:	f9842683          	lw	a3,-104(s0)
    80005710:	6110                	ld	a2,0(a0)
    80005712:	9732                	add	a4,a4,a2
    80005714:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005718:	20058613          	addi	a2,a1,512
    8000571c:	0612                	slli	a2,a2,0x4
    8000571e:	9642                	add	a2,a2,a6
    80005720:	577d                	li	a4,-1
    80005722:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005726:	00469713          	slli	a4,a3,0x4
    8000572a:	6114                	ld	a3,0(a0)
    8000572c:	96ba                	add	a3,a3,a4
    8000572e:	03078793          	addi	a5,a5,48
    80005732:	97c2                	add	a5,a5,a6
    80005734:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005736:	611c                	ld	a5,0(a0)
    80005738:	97ba                	add	a5,a5,a4
    8000573a:	4685                	li	a3,1
    8000573c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000573e:	611c                	ld	a5,0(a0)
    80005740:	97ba                	add	a5,a5,a4
    80005742:	4809                	li	a6,2
    80005744:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005748:	611c                	ld	a5,0(a0)
    8000574a:	973e                	add	a4,a4,a5
    8000574c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005750:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005754:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005758:	6518                	ld	a4,8(a0)
    8000575a:	00275783          	lhu	a5,2(a4)
    8000575e:	8b9d                	andi	a5,a5,7
    80005760:	0786                	slli	a5,a5,0x1
    80005762:	97ba                	add	a5,a5,a4
    80005764:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005768:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000576c:	6518                	ld	a4,8(a0)
    8000576e:	00275783          	lhu	a5,2(a4)
    80005772:	2785                	addiw	a5,a5,1
    80005774:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005778:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000577c:	100017b7          	lui	a5,0x10001
    80005780:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005784:	00492703          	lw	a4,4(s2)
    80005788:	4785                	li	a5,1
    8000578a:	02f71163          	bne	a4,a5,800057ac <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000578e:	00013997          	auipc	s3,0x13
    80005792:	99a98993          	addi	s3,s3,-1638 # 80018128 <disk+0x2128>
  while(b->disk == 1) {
    80005796:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005798:	85ce                	mv	a1,s3
    8000579a:	854a                	mv	a0,s2
    8000579c:	ffffc097          	auipc	ra,0xffffc
    800057a0:	d68080e7          	jalr	-664(ra) # 80001504 <sleep>
  while(b->disk == 1) {
    800057a4:	00492783          	lw	a5,4(s2)
    800057a8:	fe9788e3          	beq	a5,s1,80005798 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800057ac:	f9042903          	lw	s2,-112(s0)
    800057b0:	20090793          	addi	a5,s2,512
    800057b4:	00479713          	slli	a4,a5,0x4
    800057b8:	00011797          	auipc	a5,0x11
    800057bc:	84878793          	addi	a5,a5,-1976 # 80016000 <disk>
    800057c0:	97ba                	add	a5,a5,a4
    800057c2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800057c6:	00013997          	auipc	s3,0x13
    800057ca:	83a98993          	addi	s3,s3,-1990 # 80018000 <disk+0x2000>
    800057ce:	00491713          	slli	a4,s2,0x4
    800057d2:	0009b783          	ld	a5,0(s3)
    800057d6:	97ba                	add	a5,a5,a4
    800057d8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057dc:	854a                	mv	a0,s2
    800057de:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057e2:	00000097          	auipc	ra,0x0
    800057e6:	bc4080e7          	jalr	-1084(ra) # 800053a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057ea:	8885                	andi	s1,s1,1
    800057ec:	f0ed                	bnez	s1,800057ce <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057ee:	00013517          	auipc	a0,0x13
    800057f2:	93a50513          	addi	a0,a0,-1734 # 80018128 <disk+0x2128>
    800057f6:	00001097          	auipc	ra,0x1
    800057fa:	c50080e7          	jalr	-944(ra) # 80006446 <release>
}
    800057fe:	70a6                	ld	ra,104(sp)
    80005800:	7406                	ld	s0,96(sp)
    80005802:	64e6                	ld	s1,88(sp)
    80005804:	6946                	ld	s2,80(sp)
    80005806:	69a6                	ld	s3,72(sp)
    80005808:	6a06                	ld	s4,64(sp)
    8000580a:	7ae2                	ld	s5,56(sp)
    8000580c:	7b42                	ld	s6,48(sp)
    8000580e:	7ba2                	ld	s7,40(sp)
    80005810:	7c02                	ld	s8,32(sp)
    80005812:	6ce2                	ld	s9,24(sp)
    80005814:	6d42                	ld	s10,16(sp)
    80005816:	6165                	addi	sp,sp,112
    80005818:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000581a:	00012697          	auipc	a3,0x12
    8000581e:	7e66b683          	ld	a3,2022(a3) # 80018000 <disk+0x2000>
    80005822:	96ba                	add	a3,a3,a4
    80005824:	4609                	li	a2,2
    80005826:	00c69623          	sh	a2,12(a3)
    8000582a:	b5c9                	j	800056ec <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000582c:	f9042583          	lw	a1,-112(s0)
    80005830:	20058793          	addi	a5,a1,512
    80005834:	0792                	slli	a5,a5,0x4
    80005836:	00011517          	auipc	a0,0x11
    8000583a:	87250513          	addi	a0,a0,-1934 # 800160a8 <disk+0xa8>
    8000583e:	953e                	add	a0,a0,a5
  if(write)
    80005840:	e20d11e3          	bnez	s10,80005662 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005844:	20058713          	addi	a4,a1,512
    80005848:	00471693          	slli	a3,a4,0x4
    8000584c:	00010717          	auipc	a4,0x10
    80005850:	7b470713          	addi	a4,a4,1972 # 80016000 <disk>
    80005854:	9736                	add	a4,a4,a3
    80005856:	0a072423          	sw	zero,168(a4)
    8000585a:	b505                	j	8000567a <virtio_disk_rw+0xf4>

000000008000585c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000585c:	1101                	addi	sp,sp,-32
    8000585e:	ec06                	sd	ra,24(sp)
    80005860:	e822                	sd	s0,16(sp)
    80005862:	e426                	sd	s1,8(sp)
    80005864:	e04a                	sd	s2,0(sp)
    80005866:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005868:	00013517          	auipc	a0,0x13
    8000586c:	8c050513          	addi	a0,a0,-1856 # 80018128 <disk+0x2128>
    80005870:	00001097          	auipc	ra,0x1
    80005874:	b22080e7          	jalr	-1246(ra) # 80006392 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005878:	10001737          	lui	a4,0x10001
    8000587c:	533c                	lw	a5,96(a4)
    8000587e:	8b8d                	andi	a5,a5,3
    80005880:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005882:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005886:	00012797          	auipc	a5,0x12
    8000588a:	77a78793          	addi	a5,a5,1914 # 80018000 <disk+0x2000>
    8000588e:	6b94                	ld	a3,16(a5)
    80005890:	0207d703          	lhu	a4,32(a5)
    80005894:	0026d783          	lhu	a5,2(a3)
    80005898:	06f70163          	beq	a4,a5,800058fa <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000589c:	00010917          	auipc	s2,0x10
    800058a0:	76490913          	addi	s2,s2,1892 # 80016000 <disk>
    800058a4:	00012497          	auipc	s1,0x12
    800058a8:	75c48493          	addi	s1,s1,1884 # 80018000 <disk+0x2000>
    __sync_synchronize();
    800058ac:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058b0:	6898                	ld	a4,16(s1)
    800058b2:	0204d783          	lhu	a5,32(s1)
    800058b6:	8b9d                	andi	a5,a5,7
    800058b8:	078e                	slli	a5,a5,0x3
    800058ba:	97ba                	add	a5,a5,a4
    800058bc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058be:	20078713          	addi	a4,a5,512
    800058c2:	0712                	slli	a4,a4,0x4
    800058c4:	974a                	add	a4,a4,s2
    800058c6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800058ca:	e731                	bnez	a4,80005916 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058cc:	20078793          	addi	a5,a5,512
    800058d0:	0792                	slli	a5,a5,0x4
    800058d2:	97ca                	add	a5,a5,s2
    800058d4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058d6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058da:	ffffc097          	auipc	ra,0xffffc
    800058de:	db6080e7          	jalr	-586(ra) # 80001690 <wakeup>

    disk.used_idx += 1;
    800058e2:	0204d783          	lhu	a5,32(s1)
    800058e6:	2785                	addiw	a5,a5,1
    800058e8:	17c2                	slli	a5,a5,0x30
    800058ea:	93c1                	srli	a5,a5,0x30
    800058ec:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058f0:	6898                	ld	a4,16(s1)
    800058f2:	00275703          	lhu	a4,2(a4)
    800058f6:	faf71be3          	bne	a4,a5,800058ac <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800058fa:	00013517          	auipc	a0,0x13
    800058fe:	82e50513          	addi	a0,a0,-2002 # 80018128 <disk+0x2128>
    80005902:	00001097          	auipc	ra,0x1
    80005906:	b44080e7          	jalr	-1212(ra) # 80006446 <release>
}
    8000590a:	60e2                	ld	ra,24(sp)
    8000590c:	6442                	ld	s0,16(sp)
    8000590e:	64a2                	ld	s1,8(sp)
    80005910:	6902                	ld	s2,0(sp)
    80005912:	6105                	addi	sp,sp,32
    80005914:	8082                	ret
      panic("virtio_disk_intr status");
    80005916:	00003517          	auipc	a0,0x3
    8000591a:	f1a50513          	addi	a0,a0,-230 # 80008830 <syscalls+0x468>
    8000591e:	00000097          	auipc	ra,0x0
    80005922:	52a080e7          	jalr	1322(ra) # 80005e48 <panic>

0000000080005926 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005926:	1141                	addi	sp,sp,-16
    80005928:	e422                	sd	s0,8(sp)
    8000592a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000592c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005930:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005934:	0037979b          	slliw	a5,a5,0x3
    80005938:	02004737          	lui	a4,0x2004
    8000593c:	97ba                	add	a5,a5,a4
    8000593e:	0200c737          	lui	a4,0x200c
    80005942:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005946:	000f4637          	lui	a2,0xf4
    8000594a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000594e:	95b2                	add	a1,a1,a2
    80005950:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005952:	00269713          	slli	a4,a3,0x2
    80005956:	9736                	add	a4,a4,a3
    80005958:	00371693          	slli	a3,a4,0x3
    8000595c:	00013717          	auipc	a4,0x13
    80005960:	6a470713          	addi	a4,a4,1700 # 80019000 <timer_scratch>
    80005964:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005966:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005968:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000596a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000596e:	00000797          	auipc	a5,0x0
    80005972:	97278793          	addi	a5,a5,-1678 # 800052e0 <timervec>
    80005976:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000597a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000597e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005982:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005986:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000598a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000598e:	30479073          	csrw	mie,a5
}
    80005992:	6422                	ld	s0,8(sp)
    80005994:	0141                	addi	sp,sp,16
    80005996:	8082                	ret

0000000080005998 <start>:
{
    80005998:	1141                	addi	sp,sp,-16
    8000599a:	e406                	sd	ra,8(sp)
    8000599c:	e022                	sd	s0,0(sp)
    8000599e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059a0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059a4:	7779                	lui	a4,0xffffe
    800059a6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd5bf>
    800059aa:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059ac:	6705                	lui	a4,0x1
    800059ae:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059b2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059b4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059b8:	ffffb797          	auipc	a5,0xffffb
    800059bc:	96e78793          	addi	a5,a5,-1682 # 80000326 <main>
    800059c0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059c4:	4781                	li	a5,0
    800059c6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059ca:	67c1                	lui	a5,0x10
    800059cc:	17fd                	addi	a5,a5,-1
    800059ce:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059d2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059d6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059da:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059de:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059e2:	57fd                	li	a5,-1
    800059e4:	83a9                	srli	a5,a5,0xa
    800059e6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059ea:	47bd                	li	a5,15
    800059ec:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	f36080e7          	jalr	-202(ra) # 80005926 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059f8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059fc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059fe:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a00:	30200073          	mret
}
    80005a04:	60a2                	ld	ra,8(sp)
    80005a06:	6402                	ld	s0,0(sp)
    80005a08:	0141                	addi	sp,sp,16
    80005a0a:	8082                	ret

0000000080005a0c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a0c:	715d                	addi	sp,sp,-80
    80005a0e:	e486                	sd	ra,72(sp)
    80005a10:	e0a2                	sd	s0,64(sp)
    80005a12:	fc26                	sd	s1,56(sp)
    80005a14:	f84a                	sd	s2,48(sp)
    80005a16:	f44e                	sd	s3,40(sp)
    80005a18:	f052                	sd	s4,32(sp)
    80005a1a:	ec56                	sd	s5,24(sp)
    80005a1c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a1e:	04c05663          	blez	a2,80005a6a <consolewrite+0x5e>
    80005a22:	8a2a                	mv	s4,a0
    80005a24:	84ae                	mv	s1,a1
    80005a26:	89b2                	mv	s3,a2
    80005a28:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a2a:	5afd                	li	s5,-1
    80005a2c:	4685                	li	a3,1
    80005a2e:	8626                	mv	a2,s1
    80005a30:	85d2                	mv	a1,s4
    80005a32:	fbf40513          	addi	a0,s0,-65
    80005a36:	ffffc097          	auipc	ra,0xffffc
    80005a3a:	ec8080e7          	jalr	-312(ra) # 800018fe <either_copyin>
    80005a3e:	01550c63          	beq	a0,s5,80005a56 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a42:	fbf44503          	lbu	a0,-65(s0)
    80005a46:	00000097          	auipc	ra,0x0
    80005a4a:	78e080e7          	jalr	1934(ra) # 800061d4 <uartputc>
  for(i = 0; i < n; i++){
    80005a4e:	2905                	addiw	s2,s2,1
    80005a50:	0485                	addi	s1,s1,1
    80005a52:	fd299de3          	bne	s3,s2,80005a2c <consolewrite+0x20>
  }

  return i;
}
    80005a56:	854a                	mv	a0,s2
    80005a58:	60a6                	ld	ra,72(sp)
    80005a5a:	6406                	ld	s0,64(sp)
    80005a5c:	74e2                	ld	s1,56(sp)
    80005a5e:	7942                	ld	s2,48(sp)
    80005a60:	79a2                	ld	s3,40(sp)
    80005a62:	7a02                	ld	s4,32(sp)
    80005a64:	6ae2                	ld	s5,24(sp)
    80005a66:	6161                	addi	sp,sp,80
    80005a68:	8082                	ret
  for(i = 0; i < n; i++){
    80005a6a:	4901                	li	s2,0
    80005a6c:	b7ed                	j	80005a56 <consolewrite+0x4a>

0000000080005a6e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a6e:	7119                	addi	sp,sp,-128
    80005a70:	fc86                	sd	ra,120(sp)
    80005a72:	f8a2                	sd	s0,112(sp)
    80005a74:	f4a6                	sd	s1,104(sp)
    80005a76:	f0ca                	sd	s2,96(sp)
    80005a78:	ecce                	sd	s3,88(sp)
    80005a7a:	e8d2                	sd	s4,80(sp)
    80005a7c:	e4d6                	sd	s5,72(sp)
    80005a7e:	e0da                	sd	s6,64(sp)
    80005a80:	fc5e                	sd	s7,56(sp)
    80005a82:	f862                	sd	s8,48(sp)
    80005a84:	f466                	sd	s9,40(sp)
    80005a86:	f06a                	sd	s10,32(sp)
    80005a88:	ec6e                	sd	s11,24(sp)
    80005a8a:	0100                	addi	s0,sp,128
    80005a8c:	8b2a                	mv	s6,a0
    80005a8e:	8aae                	mv	s5,a1
    80005a90:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a92:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a96:	0001b517          	auipc	a0,0x1b
    80005a9a:	6aa50513          	addi	a0,a0,1706 # 80021140 <cons>
    80005a9e:	00001097          	auipc	ra,0x1
    80005aa2:	8f4080e7          	jalr	-1804(ra) # 80006392 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005aa6:	0001b497          	auipc	s1,0x1b
    80005aaa:	69a48493          	addi	s1,s1,1690 # 80021140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005aae:	89a6                	mv	s3,s1
    80005ab0:	0001b917          	auipc	s2,0x1b
    80005ab4:	72890913          	addi	s2,s2,1832 # 800211d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005ab8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005aba:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005abc:	4da9                	li	s11,10
  while(n > 0){
    80005abe:	07405863          	blez	s4,80005b2e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005ac2:	0984a783          	lw	a5,152(s1)
    80005ac6:	09c4a703          	lw	a4,156(s1)
    80005aca:	02f71463          	bne	a4,a5,80005af2 <consoleread+0x84>
      if(myproc()->killed){
    80005ace:	ffffb097          	auipc	ra,0xffffb
    80005ad2:	37a080e7          	jalr	890(ra) # 80000e48 <myproc>
    80005ad6:	551c                	lw	a5,40(a0)
    80005ad8:	e7b5                	bnez	a5,80005b44 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005ada:	85ce                	mv	a1,s3
    80005adc:	854a                	mv	a0,s2
    80005ade:	ffffc097          	auipc	ra,0xffffc
    80005ae2:	a26080e7          	jalr	-1498(ra) # 80001504 <sleep>
    while(cons.r == cons.w){
    80005ae6:	0984a783          	lw	a5,152(s1)
    80005aea:	09c4a703          	lw	a4,156(s1)
    80005aee:	fef700e3          	beq	a4,a5,80005ace <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005af2:	0017871b          	addiw	a4,a5,1
    80005af6:	08e4ac23          	sw	a4,152(s1)
    80005afa:	07f7f713          	andi	a4,a5,127
    80005afe:	9726                	add	a4,a4,s1
    80005b00:	01874703          	lbu	a4,24(a4)
    80005b04:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005b08:	079c0663          	beq	s8,s9,80005b74 <consoleread+0x106>
    cbuf = c;
    80005b0c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b10:	4685                	li	a3,1
    80005b12:	f8f40613          	addi	a2,s0,-113
    80005b16:	85d6                	mv	a1,s5
    80005b18:	855a                	mv	a0,s6
    80005b1a:	ffffc097          	auipc	ra,0xffffc
    80005b1e:	d8e080e7          	jalr	-626(ra) # 800018a8 <either_copyout>
    80005b22:	01a50663          	beq	a0,s10,80005b2e <consoleread+0xc0>
    dst++;
    80005b26:	0a85                	addi	s5,s5,1
    --n;
    80005b28:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b2a:	f9bc1ae3          	bne	s8,s11,80005abe <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b2e:	0001b517          	auipc	a0,0x1b
    80005b32:	61250513          	addi	a0,a0,1554 # 80021140 <cons>
    80005b36:	00001097          	auipc	ra,0x1
    80005b3a:	910080e7          	jalr	-1776(ra) # 80006446 <release>

  return target - n;
    80005b3e:	414b853b          	subw	a0,s7,s4
    80005b42:	a811                	j	80005b56 <consoleread+0xe8>
        release(&cons.lock);
    80005b44:	0001b517          	auipc	a0,0x1b
    80005b48:	5fc50513          	addi	a0,a0,1532 # 80021140 <cons>
    80005b4c:	00001097          	auipc	ra,0x1
    80005b50:	8fa080e7          	jalr	-1798(ra) # 80006446 <release>
        return -1;
    80005b54:	557d                	li	a0,-1
}
    80005b56:	70e6                	ld	ra,120(sp)
    80005b58:	7446                	ld	s0,112(sp)
    80005b5a:	74a6                	ld	s1,104(sp)
    80005b5c:	7906                	ld	s2,96(sp)
    80005b5e:	69e6                	ld	s3,88(sp)
    80005b60:	6a46                	ld	s4,80(sp)
    80005b62:	6aa6                	ld	s5,72(sp)
    80005b64:	6b06                	ld	s6,64(sp)
    80005b66:	7be2                	ld	s7,56(sp)
    80005b68:	7c42                	ld	s8,48(sp)
    80005b6a:	7ca2                	ld	s9,40(sp)
    80005b6c:	7d02                	ld	s10,32(sp)
    80005b6e:	6de2                	ld	s11,24(sp)
    80005b70:	6109                	addi	sp,sp,128
    80005b72:	8082                	ret
      if(n < target){
    80005b74:	000a071b          	sext.w	a4,s4
    80005b78:	fb777be3          	bgeu	a4,s7,80005b2e <consoleread+0xc0>
        cons.r--;
    80005b7c:	0001b717          	auipc	a4,0x1b
    80005b80:	64f72e23          	sw	a5,1628(a4) # 800211d8 <cons+0x98>
    80005b84:	b76d                	j	80005b2e <consoleread+0xc0>

0000000080005b86 <consputc>:
{
    80005b86:	1141                	addi	sp,sp,-16
    80005b88:	e406                	sd	ra,8(sp)
    80005b8a:	e022                	sd	s0,0(sp)
    80005b8c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b8e:	10000793          	li	a5,256
    80005b92:	00f50a63          	beq	a0,a5,80005ba6 <consputc+0x20>
    uartputc_sync(c);
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	564080e7          	jalr	1380(ra) # 800060fa <uartputc_sync>
}
    80005b9e:	60a2                	ld	ra,8(sp)
    80005ba0:	6402                	ld	s0,0(sp)
    80005ba2:	0141                	addi	sp,sp,16
    80005ba4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ba6:	4521                	li	a0,8
    80005ba8:	00000097          	auipc	ra,0x0
    80005bac:	552080e7          	jalr	1362(ra) # 800060fa <uartputc_sync>
    80005bb0:	02000513          	li	a0,32
    80005bb4:	00000097          	auipc	ra,0x0
    80005bb8:	546080e7          	jalr	1350(ra) # 800060fa <uartputc_sync>
    80005bbc:	4521                	li	a0,8
    80005bbe:	00000097          	auipc	ra,0x0
    80005bc2:	53c080e7          	jalr	1340(ra) # 800060fa <uartputc_sync>
    80005bc6:	bfe1                	j	80005b9e <consputc+0x18>

0000000080005bc8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005bc8:	1101                	addi	sp,sp,-32
    80005bca:	ec06                	sd	ra,24(sp)
    80005bcc:	e822                	sd	s0,16(sp)
    80005bce:	e426                	sd	s1,8(sp)
    80005bd0:	e04a                	sd	s2,0(sp)
    80005bd2:	1000                	addi	s0,sp,32
    80005bd4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bd6:	0001b517          	auipc	a0,0x1b
    80005bda:	56a50513          	addi	a0,a0,1386 # 80021140 <cons>
    80005bde:	00000097          	auipc	ra,0x0
    80005be2:	7b4080e7          	jalr	1972(ra) # 80006392 <acquire>

  switch(c){
    80005be6:	47d5                	li	a5,21
    80005be8:	0af48663          	beq	s1,a5,80005c94 <consoleintr+0xcc>
    80005bec:	0297ca63          	blt	a5,s1,80005c20 <consoleintr+0x58>
    80005bf0:	47a1                	li	a5,8
    80005bf2:	0ef48763          	beq	s1,a5,80005ce0 <consoleintr+0x118>
    80005bf6:	47c1                	li	a5,16
    80005bf8:	10f49a63          	bne	s1,a5,80005d0c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005bfc:	ffffc097          	auipc	ra,0xffffc
    80005c00:	d58080e7          	jalr	-680(ra) # 80001954 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c04:	0001b517          	auipc	a0,0x1b
    80005c08:	53c50513          	addi	a0,a0,1340 # 80021140 <cons>
    80005c0c:	00001097          	auipc	ra,0x1
    80005c10:	83a080e7          	jalr	-1990(ra) # 80006446 <release>
}
    80005c14:	60e2                	ld	ra,24(sp)
    80005c16:	6442                	ld	s0,16(sp)
    80005c18:	64a2                	ld	s1,8(sp)
    80005c1a:	6902                	ld	s2,0(sp)
    80005c1c:	6105                	addi	sp,sp,32
    80005c1e:	8082                	ret
  switch(c){
    80005c20:	07f00793          	li	a5,127
    80005c24:	0af48e63          	beq	s1,a5,80005ce0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c28:	0001b717          	auipc	a4,0x1b
    80005c2c:	51870713          	addi	a4,a4,1304 # 80021140 <cons>
    80005c30:	0a072783          	lw	a5,160(a4)
    80005c34:	09872703          	lw	a4,152(a4)
    80005c38:	9f99                	subw	a5,a5,a4
    80005c3a:	07f00713          	li	a4,127
    80005c3e:	fcf763e3          	bltu	a4,a5,80005c04 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c42:	47b5                	li	a5,13
    80005c44:	0cf48763          	beq	s1,a5,80005d12 <consoleintr+0x14a>
      consputc(c);
    80005c48:	8526                	mv	a0,s1
    80005c4a:	00000097          	auipc	ra,0x0
    80005c4e:	f3c080e7          	jalr	-196(ra) # 80005b86 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c52:	0001b797          	auipc	a5,0x1b
    80005c56:	4ee78793          	addi	a5,a5,1262 # 80021140 <cons>
    80005c5a:	0a07a703          	lw	a4,160(a5)
    80005c5e:	0017069b          	addiw	a3,a4,1
    80005c62:	0006861b          	sext.w	a2,a3
    80005c66:	0ad7a023          	sw	a3,160(a5)
    80005c6a:	07f77713          	andi	a4,a4,127
    80005c6e:	97ba                	add	a5,a5,a4
    80005c70:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005c74:	47a9                	li	a5,10
    80005c76:	0cf48563          	beq	s1,a5,80005d40 <consoleintr+0x178>
    80005c7a:	4791                	li	a5,4
    80005c7c:	0cf48263          	beq	s1,a5,80005d40 <consoleintr+0x178>
    80005c80:	0001b797          	auipc	a5,0x1b
    80005c84:	5587a783          	lw	a5,1368(a5) # 800211d8 <cons+0x98>
    80005c88:	0807879b          	addiw	a5,a5,128
    80005c8c:	f6f61ce3          	bne	a2,a5,80005c04 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c90:	863e                	mv	a2,a5
    80005c92:	a07d                	j	80005d40 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c94:	0001b717          	auipc	a4,0x1b
    80005c98:	4ac70713          	addi	a4,a4,1196 # 80021140 <cons>
    80005c9c:	0a072783          	lw	a5,160(a4)
    80005ca0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ca4:	0001b497          	auipc	s1,0x1b
    80005ca8:	49c48493          	addi	s1,s1,1180 # 80021140 <cons>
    while(cons.e != cons.w &&
    80005cac:	4929                	li	s2,10
    80005cae:	f4f70be3          	beq	a4,a5,80005c04 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005cb2:	37fd                	addiw	a5,a5,-1
    80005cb4:	07f7f713          	andi	a4,a5,127
    80005cb8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cba:	01874703          	lbu	a4,24(a4)
    80005cbe:	f52703e3          	beq	a4,s2,80005c04 <consoleintr+0x3c>
      cons.e--;
    80005cc2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005cc6:	10000513          	li	a0,256
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	ebc080e7          	jalr	-324(ra) # 80005b86 <consputc>
    while(cons.e != cons.w &&
    80005cd2:	0a04a783          	lw	a5,160(s1)
    80005cd6:	09c4a703          	lw	a4,156(s1)
    80005cda:	fcf71ce3          	bne	a4,a5,80005cb2 <consoleintr+0xea>
    80005cde:	b71d                	j	80005c04 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ce0:	0001b717          	auipc	a4,0x1b
    80005ce4:	46070713          	addi	a4,a4,1120 # 80021140 <cons>
    80005ce8:	0a072783          	lw	a5,160(a4)
    80005cec:	09c72703          	lw	a4,156(a4)
    80005cf0:	f0f70ae3          	beq	a4,a5,80005c04 <consoleintr+0x3c>
      cons.e--;
    80005cf4:	37fd                	addiw	a5,a5,-1
    80005cf6:	0001b717          	auipc	a4,0x1b
    80005cfa:	4ef72523          	sw	a5,1258(a4) # 800211e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005cfe:	10000513          	li	a0,256
    80005d02:	00000097          	auipc	ra,0x0
    80005d06:	e84080e7          	jalr	-380(ra) # 80005b86 <consputc>
    80005d0a:	bded                	j	80005c04 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d0c:	ee048ce3          	beqz	s1,80005c04 <consoleintr+0x3c>
    80005d10:	bf21                	j	80005c28 <consoleintr+0x60>
      consputc(c);
    80005d12:	4529                	li	a0,10
    80005d14:	00000097          	auipc	ra,0x0
    80005d18:	e72080e7          	jalr	-398(ra) # 80005b86 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d1c:	0001b797          	auipc	a5,0x1b
    80005d20:	42478793          	addi	a5,a5,1060 # 80021140 <cons>
    80005d24:	0a07a703          	lw	a4,160(a5)
    80005d28:	0017069b          	addiw	a3,a4,1
    80005d2c:	0006861b          	sext.w	a2,a3
    80005d30:	0ad7a023          	sw	a3,160(a5)
    80005d34:	07f77713          	andi	a4,a4,127
    80005d38:	97ba                	add	a5,a5,a4
    80005d3a:	4729                	li	a4,10
    80005d3c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d40:	0001b797          	auipc	a5,0x1b
    80005d44:	48c7ae23          	sw	a2,1180(a5) # 800211dc <cons+0x9c>
        wakeup(&cons.r);
    80005d48:	0001b517          	auipc	a0,0x1b
    80005d4c:	49050513          	addi	a0,a0,1168 # 800211d8 <cons+0x98>
    80005d50:	ffffc097          	auipc	ra,0xffffc
    80005d54:	940080e7          	jalr	-1728(ra) # 80001690 <wakeup>
    80005d58:	b575                	j	80005c04 <consoleintr+0x3c>

0000000080005d5a <consoleinit>:

void
consoleinit(void)
{
    80005d5a:	1141                	addi	sp,sp,-16
    80005d5c:	e406                	sd	ra,8(sp)
    80005d5e:	e022                	sd	s0,0(sp)
    80005d60:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d62:	00003597          	auipc	a1,0x3
    80005d66:	ae658593          	addi	a1,a1,-1306 # 80008848 <syscalls+0x480>
    80005d6a:	0001b517          	auipc	a0,0x1b
    80005d6e:	3d650513          	addi	a0,a0,982 # 80021140 <cons>
    80005d72:	00000097          	auipc	ra,0x0
    80005d76:	590080e7          	jalr	1424(ra) # 80006302 <initlock>

  uartinit();
    80005d7a:	00000097          	auipc	ra,0x0
    80005d7e:	330080e7          	jalr	816(ra) # 800060aa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d82:	0000e797          	auipc	a5,0xe
    80005d86:	75678793          	addi	a5,a5,1878 # 800144d8 <devsw>
    80005d8a:	00000717          	auipc	a4,0x0
    80005d8e:	ce470713          	addi	a4,a4,-796 # 80005a6e <consoleread>
    80005d92:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d94:	00000717          	auipc	a4,0x0
    80005d98:	c7870713          	addi	a4,a4,-904 # 80005a0c <consolewrite>
    80005d9c:	ef98                	sd	a4,24(a5)
}
    80005d9e:	60a2                	ld	ra,8(sp)
    80005da0:	6402                	ld	s0,0(sp)
    80005da2:	0141                	addi	sp,sp,16
    80005da4:	8082                	ret

0000000080005da6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005da6:	7179                	addi	sp,sp,-48
    80005da8:	f406                	sd	ra,40(sp)
    80005daa:	f022                	sd	s0,32(sp)
    80005dac:	ec26                	sd	s1,24(sp)
    80005dae:	e84a                	sd	s2,16(sp)
    80005db0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005db2:	c219                	beqz	a2,80005db8 <printint+0x12>
    80005db4:	08054663          	bltz	a0,80005e40 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005db8:	2501                	sext.w	a0,a0
    80005dba:	4881                	li	a7,0
    80005dbc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005dc0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005dc2:	2581                	sext.w	a1,a1
    80005dc4:	00003617          	auipc	a2,0x3
    80005dc8:	ab460613          	addi	a2,a2,-1356 # 80008878 <digits>
    80005dcc:	883a                	mv	a6,a4
    80005dce:	2705                	addiw	a4,a4,1
    80005dd0:	02b577bb          	remuw	a5,a0,a1
    80005dd4:	1782                	slli	a5,a5,0x20
    80005dd6:	9381                	srli	a5,a5,0x20
    80005dd8:	97b2                	add	a5,a5,a2
    80005dda:	0007c783          	lbu	a5,0(a5)
    80005dde:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005de2:	0005079b          	sext.w	a5,a0
    80005de6:	02b5553b          	divuw	a0,a0,a1
    80005dea:	0685                	addi	a3,a3,1
    80005dec:	feb7f0e3          	bgeu	a5,a1,80005dcc <printint+0x26>

  if(sign)
    80005df0:	00088b63          	beqz	a7,80005e06 <printint+0x60>
    buf[i++] = '-';
    80005df4:	fe040793          	addi	a5,s0,-32
    80005df8:	973e                	add	a4,a4,a5
    80005dfa:	02d00793          	li	a5,45
    80005dfe:	fef70823          	sb	a5,-16(a4)
    80005e02:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e06:	02e05763          	blez	a4,80005e34 <printint+0x8e>
    80005e0a:	fd040793          	addi	a5,s0,-48
    80005e0e:	00e784b3          	add	s1,a5,a4
    80005e12:	fff78913          	addi	s2,a5,-1
    80005e16:	993a                	add	s2,s2,a4
    80005e18:	377d                	addiw	a4,a4,-1
    80005e1a:	1702                	slli	a4,a4,0x20
    80005e1c:	9301                	srli	a4,a4,0x20
    80005e1e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e22:	fff4c503          	lbu	a0,-1(s1)
    80005e26:	00000097          	auipc	ra,0x0
    80005e2a:	d60080e7          	jalr	-672(ra) # 80005b86 <consputc>
  while(--i >= 0)
    80005e2e:	14fd                	addi	s1,s1,-1
    80005e30:	ff2499e3          	bne	s1,s2,80005e22 <printint+0x7c>
}
    80005e34:	70a2                	ld	ra,40(sp)
    80005e36:	7402                	ld	s0,32(sp)
    80005e38:	64e2                	ld	s1,24(sp)
    80005e3a:	6942                	ld	s2,16(sp)
    80005e3c:	6145                	addi	sp,sp,48
    80005e3e:	8082                	ret
    x = -xx;
    80005e40:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e44:	4885                	li	a7,1
    x = -xx;
    80005e46:	bf9d                	j	80005dbc <printint+0x16>

0000000080005e48 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e48:	1101                	addi	sp,sp,-32
    80005e4a:	ec06                	sd	ra,24(sp)
    80005e4c:	e822                	sd	s0,16(sp)
    80005e4e:	e426                	sd	s1,8(sp)
    80005e50:	1000                	addi	s0,sp,32
    80005e52:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e54:	0001b797          	auipc	a5,0x1b
    80005e58:	3a07a623          	sw	zero,940(a5) # 80021200 <pr+0x18>
  printf("panic: ");
    80005e5c:	00003517          	auipc	a0,0x3
    80005e60:	9f450513          	addi	a0,a0,-1548 # 80008850 <syscalls+0x488>
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	02e080e7          	jalr	46(ra) # 80005e92 <printf>
  printf(s);
    80005e6c:	8526                	mv	a0,s1
    80005e6e:	00000097          	auipc	ra,0x0
    80005e72:	024080e7          	jalr	36(ra) # 80005e92 <printf>
  printf("\n");
    80005e76:	00003517          	auipc	a0,0x3
    80005e7a:	8ea50513          	addi	a0,a0,-1814 # 80008760 <syscalls+0x398>
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	014080e7          	jalr	20(ra) # 80005e92 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e86:	4785                	li	a5,1
    80005e88:	00003717          	auipc	a4,0x3
    80005e8c:	18f72a23          	sw	a5,404(a4) # 8000901c <panicked>
  for(;;)
    80005e90:	a001                	j	80005e90 <panic+0x48>

0000000080005e92 <printf>:
{
    80005e92:	7131                	addi	sp,sp,-192
    80005e94:	fc86                	sd	ra,120(sp)
    80005e96:	f8a2                	sd	s0,112(sp)
    80005e98:	f4a6                	sd	s1,104(sp)
    80005e9a:	f0ca                	sd	s2,96(sp)
    80005e9c:	ecce                	sd	s3,88(sp)
    80005e9e:	e8d2                	sd	s4,80(sp)
    80005ea0:	e4d6                	sd	s5,72(sp)
    80005ea2:	e0da                	sd	s6,64(sp)
    80005ea4:	fc5e                	sd	s7,56(sp)
    80005ea6:	f862                	sd	s8,48(sp)
    80005ea8:	f466                	sd	s9,40(sp)
    80005eaa:	f06a                	sd	s10,32(sp)
    80005eac:	ec6e                	sd	s11,24(sp)
    80005eae:	0100                	addi	s0,sp,128
    80005eb0:	8a2a                	mv	s4,a0
    80005eb2:	e40c                	sd	a1,8(s0)
    80005eb4:	e810                	sd	a2,16(s0)
    80005eb6:	ec14                	sd	a3,24(s0)
    80005eb8:	f018                	sd	a4,32(s0)
    80005eba:	f41c                	sd	a5,40(s0)
    80005ebc:	03043823          	sd	a6,48(s0)
    80005ec0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ec4:	0001bd97          	auipc	s11,0x1b
    80005ec8:	33cdad83          	lw	s11,828(s11) # 80021200 <pr+0x18>
  if(locking)
    80005ecc:	020d9b63          	bnez	s11,80005f02 <printf+0x70>
  if (fmt == 0)
    80005ed0:	040a0263          	beqz	s4,80005f14 <printf+0x82>
  va_start(ap, fmt);
    80005ed4:	00840793          	addi	a5,s0,8
    80005ed8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005edc:	000a4503          	lbu	a0,0(s4)
    80005ee0:	16050263          	beqz	a0,80006044 <printf+0x1b2>
    80005ee4:	4481                	li	s1,0
    if(c != '%'){
    80005ee6:	02500a93          	li	s5,37
    switch(c){
    80005eea:	07000b13          	li	s6,112
  consputc('x');
    80005eee:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ef0:	00003b97          	auipc	s7,0x3
    80005ef4:	988b8b93          	addi	s7,s7,-1656 # 80008878 <digits>
    switch(c){
    80005ef8:	07300c93          	li	s9,115
    80005efc:	06400c13          	li	s8,100
    80005f00:	a82d                	j	80005f3a <printf+0xa8>
    acquire(&pr.lock);
    80005f02:	0001b517          	auipc	a0,0x1b
    80005f06:	2e650513          	addi	a0,a0,742 # 800211e8 <pr>
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	488080e7          	jalr	1160(ra) # 80006392 <acquire>
    80005f12:	bf7d                	j	80005ed0 <printf+0x3e>
    panic("null fmt");
    80005f14:	00003517          	auipc	a0,0x3
    80005f18:	94c50513          	addi	a0,a0,-1716 # 80008860 <syscalls+0x498>
    80005f1c:	00000097          	auipc	ra,0x0
    80005f20:	f2c080e7          	jalr	-212(ra) # 80005e48 <panic>
      consputc(c);
    80005f24:	00000097          	auipc	ra,0x0
    80005f28:	c62080e7          	jalr	-926(ra) # 80005b86 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f2c:	2485                	addiw	s1,s1,1
    80005f2e:	009a07b3          	add	a5,s4,s1
    80005f32:	0007c503          	lbu	a0,0(a5)
    80005f36:	10050763          	beqz	a0,80006044 <printf+0x1b2>
    if(c != '%'){
    80005f3a:	ff5515e3          	bne	a0,s5,80005f24 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f3e:	2485                	addiw	s1,s1,1
    80005f40:	009a07b3          	add	a5,s4,s1
    80005f44:	0007c783          	lbu	a5,0(a5)
    80005f48:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f4c:	cfe5                	beqz	a5,80006044 <printf+0x1b2>
    switch(c){
    80005f4e:	05678a63          	beq	a5,s6,80005fa2 <printf+0x110>
    80005f52:	02fb7663          	bgeu	s6,a5,80005f7e <printf+0xec>
    80005f56:	09978963          	beq	a5,s9,80005fe8 <printf+0x156>
    80005f5a:	07800713          	li	a4,120
    80005f5e:	0ce79863          	bne	a5,a4,8000602e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f62:	f8843783          	ld	a5,-120(s0)
    80005f66:	00878713          	addi	a4,a5,8
    80005f6a:	f8e43423          	sd	a4,-120(s0)
    80005f6e:	4605                	li	a2,1
    80005f70:	85ea                	mv	a1,s10
    80005f72:	4388                	lw	a0,0(a5)
    80005f74:	00000097          	auipc	ra,0x0
    80005f78:	e32080e7          	jalr	-462(ra) # 80005da6 <printint>
      break;
    80005f7c:	bf45                	j	80005f2c <printf+0x9a>
    switch(c){
    80005f7e:	0b578263          	beq	a5,s5,80006022 <printf+0x190>
    80005f82:	0b879663          	bne	a5,s8,8000602e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f86:	f8843783          	ld	a5,-120(s0)
    80005f8a:	00878713          	addi	a4,a5,8
    80005f8e:	f8e43423          	sd	a4,-120(s0)
    80005f92:	4605                	li	a2,1
    80005f94:	45a9                	li	a1,10
    80005f96:	4388                	lw	a0,0(a5)
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	e0e080e7          	jalr	-498(ra) # 80005da6 <printint>
      break;
    80005fa0:	b771                	j	80005f2c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005fa2:	f8843783          	ld	a5,-120(s0)
    80005fa6:	00878713          	addi	a4,a5,8
    80005faa:	f8e43423          	sd	a4,-120(s0)
    80005fae:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005fb2:	03000513          	li	a0,48
    80005fb6:	00000097          	auipc	ra,0x0
    80005fba:	bd0080e7          	jalr	-1072(ra) # 80005b86 <consputc>
  consputc('x');
    80005fbe:	07800513          	li	a0,120
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	bc4080e7          	jalr	-1084(ra) # 80005b86 <consputc>
    80005fca:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fcc:	03c9d793          	srli	a5,s3,0x3c
    80005fd0:	97de                	add	a5,a5,s7
    80005fd2:	0007c503          	lbu	a0,0(a5)
    80005fd6:	00000097          	auipc	ra,0x0
    80005fda:	bb0080e7          	jalr	-1104(ra) # 80005b86 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fde:	0992                	slli	s3,s3,0x4
    80005fe0:	397d                	addiw	s2,s2,-1
    80005fe2:	fe0915e3          	bnez	s2,80005fcc <printf+0x13a>
    80005fe6:	b799                	j	80005f2c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005fe8:	f8843783          	ld	a5,-120(s0)
    80005fec:	00878713          	addi	a4,a5,8
    80005ff0:	f8e43423          	sd	a4,-120(s0)
    80005ff4:	0007b903          	ld	s2,0(a5)
    80005ff8:	00090e63          	beqz	s2,80006014 <printf+0x182>
      for(; *s; s++)
    80005ffc:	00094503          	lbu	a0,0(s2)
    80006000:	d515                	beqz	a0,80005f2c <printf+0x9a>
        consputc(*s);
    80006002:	00000097          	auipc	ra,0x0
    80006006:	b84080e7          	jalr	-1148(ra) # 80005b86 <consputc>
      for(; *s; s++)
    8000600a:	0905                	addi	s2,s2,1
    8000600c:	00094503          	lbu	a0,0(s2)
    80006010:	f96d                	bnez	a0,80006002 <printf+0x170>
    80006012:	bf29                	j	80005f2c <printf+0x9a>
        s = "(null)";
    80006014:	00003917          	auipc	s2,0x3
    80006018:	84490913          	addi	s2,s2,-1980 # 80008858 <syscalls+0x490>
      for(; *s; s++)
    8000601c:	02800513          	li	a0,40
    80006020:	b7cd                	j	80006002 <printf+0x170>
      consputc('%');
    80006022:	8556                	mv	a0,s5
    80006024:	00000097          	auipc	ra,0x0
    80006028:	b62080e7          	jalr	-1182(ra) # 80005b86 <consputc>
      break;
    8000602c:	b701                	j	80005f2c <printf+0x9a>
      consputc('%');
    8000602e:	8556                	mv	a0,s5
    80006030:	00000097          	auipc	ra,0x0
    80006034:	b56080e7          	jalr	-1194(ra) # 80005b86 <consputc>
      consputc(c);
    80006038:	854a                	mv	a0,s2
    8000603a:	00000097          	auipc	ra,0x0
    8000603e:	b4c080e7          	jalr	-1204(ra) # 80005b86 <consputc>
      break;
    80006042:	b5ed                	j	80005f2c <printf+0x9a>
  if(locking)
    80006044:	020d9163          	bnez	s11,80006066 <printf+0x1d4>
}
    80006048:	70e6                	ld	ra,120(sp)
    8000604a:	7446                	ld	s0,112(sp)
    8000604c:	74a6                	ld	s1,104(sp)
    8000604e:	7906                	ld	s2,96(sp)
    80006050:	69e6                	ld	s3,88(sp)
    80006052:	6a46                	ld	s4,80(sp)
    80006054:	6aa6                	ld	s5,72(sp)
    80006056:	6b06                	ld	s6,64(sp)
    80006058:	7be2                	ld	s7,56(sp)
    8000605a:	7c42                	ld	s8,48(sp)
    8000605c:	7ca2                	ld	s9,40(sp)
    8000605e:	7d02                	ld	s10,32(sp)
    80006060:	6de2                	ld	s11,24(sp)
    80006062:	6129                	addi	sp,sp,192
    80006064:	8082                	ret
    release(&pr.lock);
    80006066:	0001b517          	auipc	a0,0x1b
    8000606a:	18250513          	addi	a0,a0,386 # 800211e8 <pr>
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	3d8080e7          	jalr	984(ra) # 80006446 <release>
}
    80006076:	bfc9                	j	80006048 <printf+0x1b6>

0000000080006078 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006078:	1101                	addi	sp,sp,-32
    8000607a:	ec06                	sd	ra,24(sp)
    8000607c:	e822                	sd	s0,16(sp)
    8000607e:	e426                	sd	s1,8(sp)
    80006080:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006082:	0001b497          	auipc	s1,0x1b
    80006086:	16648493          	addi	s1,s1,358 # 800211e8 <pr>
    8000608a:	00002597          	auipc	a1,0x2
    8000608e:	7e658593          	addi	a1,a1,2022 # 80008870 <syscalls+0x4a8>
    80006092:	8526                	mv	a0,s1
    80006094:	00000097          	auipc	ra,0x0
    80006098:	26e080e7          	jalr	622(ra) # 80006302 <initlock>
  pr.locking = 1;
    8000609c:	4785                	li	a5,1
    8000609e:	cc9c                	sw	a5,24(s1)
}
    800060a0:	60e2                	ld	ra,24(sp)
    800060a2:	6442                	ld	s0,16(sp)
    800060a4:	64a2                	ld	s1,8(sp)
    800060a6:	6105                	addi	sp,sp,32
    800060a8:	8082                	ret

00000000800060aa <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060aa:	1141                	addi	sp,sp,-16
    800060ac:	e406                	sd	ra,8(sp)
    800060ae:	e022                	sd	s0,0(sp)
    800060b0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060b2:	100007b7          	lui	a5,0x10000
    800060b6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060ba:	f8000713          	li	a4,-128
    800060be:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060c2:	470d                	li	a4,3
    800060c4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060c8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060cc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060d0:	469d                	li	a3,7
    800060d2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060d6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060da:	00002597          	auipc	a1,0x2
    800060de:	7b658593          	addi	a1,a1,1974 # 80008890 <digits+0x18>
    800060e2:	0001b517          	auipc	a0,0x1b
    800060e6:	12650513          	addi	a0,a0,294 # 80021208 <uart_tx_lock>
    800060ea:	00000097          	auipc	ra,0x0
    800060ee:	218080e7          	jalr	536(ra) # 80006302 <initlock>
}
    800060f2:	60a2                	ld	ra,8(sp)
    800060f4:	6402                	ld	s0,0(sp)
    800060f6:	0141                	addi	sp,sp,16
    800060f8:	8082                	ret

00000000800060fa <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060fa:	1101                	addi	sp,sp,-32
    800060fc:	ec06                	sd	ra,24(sp)
    800060fe:	e822                	sd	s0,16(sp)
    80006100:	e426                	sd	s1,8(sp)
    80006102:	1000                	addi	s0,sp,32
    80006104:	84aa                	mv	s1,a0
  push_off();
    80006106:	00000097          	auipc	ra,0x0
    8000610a:	240080e7          	jalr	576(ra) # 80006346 <push_off>

  if(panicked){
    8000610e:	00003797          	auipc	a5,0x3
    80006112:	f0e7a783          	lw	a5,-242(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006116:	10000737          	lui	a4,0x10000
  if(panicked){
    8000611a:	c391                	beqz	a5,8000611e <uartputc_sync+0x24>
    for(;;)
    8000611c:	a001                	j	8000611c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000611e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006122:	0ff7f793          	andi	a5,a5,255
    80006126:	0207f793          	andi	a5,a5,32
    8000612a:	dbf5                	beqz	a5,8000611e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000612c:	0ff4f793          	andi	a5,s1,255
    80006130:	10000737          	lui	a4,0x10000
    80006134:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006138:	00000097          	auipc	ra,0x0
    8000613c:	2ae080e7          	jalr	686(ra) # 800063e6 <pop_off>
}
    80006140:	60e2                	ld	ra,24(sp)
    80006142:	6442                	ld	s0,16(sp)
    80006144:	64a2                	ld	s1,8(sp)
    80006146:	6105                	addi	sp,sp,32
    80006148:	8082                	ret

000000008000614a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000614a:	00003717          	auipc	a4,0x3
    8000614e:	ed673703          	ld	a4,-298(a4) # 80009020 <uart_tx_r>
    80006152:	00003797          	auipc	a5,0x3
    80006156:	ed67b783          	ld	a5,-298(a5) # 80009028 <uart_tx_w>
    8000615a:	06e78c63          	beq	a5,a4,800061d2 <uartstart+0x88>
{
    8000615e:	7139                	addi	sp,sp,-64
    80006160:	fc06                	sd	ra,56(sp)
    80006162:	f822                	sd	s0,48(sp)
    80006164:	f426                	sd	s1,40(sp)
    80006166:	f04a                	sd	s2,32(sp)
    80006168:	ec4e                	sd	s3,24(sp)
    8000616a:	e852                	sd	s4,16(sp)
    8000616c:	e456                	sd	s5,8(sp)
    8000616e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006170:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006174:	0001ba17          	auipc	s4,0x1b
    80006178:	094a0a13          	addi	s4,s4,148 # 80021208 <uart_tx_lock>
    uart_tx_r += 1;
    8000617c:	00003497          	auipc	s1,0x3
    80006180:	ea448493          	addi	s1,s1,-348 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006184:	00003997          	auipc	s3,0x3
    80006188:	ea498993          	addi	s3,s3,-348 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000618c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006190:	0ff7f793          	andi	a5,a5,255
    80006194:	0207f793          	andi	a5,a5,32
    80006198:	c785                	beqz	a5,800061c0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000619a:	01f77793          	andi	a5,a4,31
    8000619e:	97d2                	add	a5,a5,s4
    800061a0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800061a4:	0705                	addi	a4,a4,1
    800061a6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061a8:	8526                	mv	a0,s1
    800061aa:	ffffb097          	auipc	ra,0xffffb
    800061ae:	4e6080e7          	jalr	1254(ra) # 80001690 <wakeup>
    
    WriteReg(THR, c);
    800061b2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061b6:	6098                	ld	a4,0(s1)
    800061b8:	0009b783          	ld	a5,0(s3)
    800061bc:	fce798e3          	bne	a5,a4,8000618c <uartstart+0x42>
  }
}
    800061c0:	70e2                	ld	ra,56(sp)
    800061c2:	7442                	ld	s0,48(sp)
    800061c4:	74a2                	ld	s1,40(sp)
    800061c6:	7902                	ld	s2,32(sp)
    800061c8:	69e2                	ld	s3,24(sp)
    800061ca:	6a42                	ld	s4,16(sp)
    800061cc:	6aa2                	ld	s5,8(sp)
    800061ce:	6121                	addi	sp,sp,64
    800061d0:	8082                	ret
    800061d2:	8082                	ret

00000000800061d4 <uartputc>:
{
    800061d4:	7179                	addi	sp,sp,-48
    800061d6:	f406                	sd	ra,40(sp)
    800061d8:	f022                	sd	s0,32(sp)
    800061da:	ec26                	sd	s1,24(sp)
    800061dc:	e84a                	sd	s2,16(sp)
    800061de:	e44e                	sd	s3,8(sp)
    800061e0:	e052                	sd	s4,0(sp)
    800061e2:	1800                	addi	s0,sp,48
    800061e4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800061e6:	0001b517          	auipc	a0,0x1b
    800061ea:	02250513          	addi	a0,a0,34 # 80021208 <uart_tx_lock>
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	1a4080e7          	jalr	420(ra) # 80006392 <acquire>
  if(panicked){
    800061f6:	00003797          	auipc	a5,0x3
    800061fa:	e267a783          	lw	a5,-474(a5) # 8000901c <panicked>
    800061fe:	c391                	beqz	a5,80006202 <uartputc+0x2e>
    for(;;)
    80006200:	a001                	j	80006200 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006202:	00003797          	auipc	a5,0x3
    80006206:	e267b783          	ld	a5,-474(a5) # 80009028 <uart_tx_w>
    8000620a:	00003717          	auipc	a4,0x3
    8000620e:	e1673703          	ld	a4,-490(a4) # 80009020 <uart_tx_r>
    80006212:	02070713          	addi	a4,a4,32
    80006216:	02f71b63          	bne	a4,a5,8000624c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000621a:	0001ba17          	auipc	s4,0x1b
    8000621e:	feea0a13          	addi	s4,s4,-18 # 80021208 <uart_tx_lock>
    80006222:	00003497          	auipc	s1,0x3
    80006226:	dfe48493          	addi	s1,s1,-514 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000622a:	00003917          	auipc	s2,0x3
    8000622e:	dfe90913          	addi	s2,s2,-514 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006232:	85d2                	mv	a1,s4
    80006234:	8526                	mv	a0,s1
    80006236:	ffffb097          	auipc	ra,0xffffb
    8000623a:	2ce080e7          	jalr	718(ra) # 80001504 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000623e:	00093783          	ld	a5,0(s2)
    80006242:	6098                	ld	a4,0(s1)
    80006244:	02070713          	addi	a4,a4,32
    80006248:	fef705e3          	beq	a4,a5,80006232 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000624c:	0001b497          	auipc	s1,0x1b
    80006250:	fbc48493          	addi	s1,s1,-68 # 80021208 <uart_tx_lock>
    80006254:	01f7f713          	andi	a4,a5,31
    80006258:	9726                	add	a4,a4,s1
    8000625a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000625e:	0785                	addi	a5,a5,1
    80006260:	00003717          	auipc	a4,0x3
    80006264:	dcf73423          	sd	a5,-568(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006268:	00000097          	auipc	ra,0x0
    8000626c:	ee2080e7          	jalr	-286(ra) # 8000614a <uartstart>
      release(&uart_tx_lock);
    80006270:	8526                	mv	a0,s1
    80006272:	00000097          	auipc	ra,0x0
    80006276:	1d4080e7          	jalr	468(ra) # 80006446 <release>
}
    8000627a:	70a2                	ld	ra,40(sp)
    8000627c:	7402                	ld	s0,32(sp)
    8000627e:	64e2                	ld	s1,24(sp)
    80006280:	6942                	ld	s2,16(sp)
    80006282:	69a2                	ld	s3,8(sp)
    80006284:	6a02                	ld	s4,0(sp)
    80006286:	6145                	addi	sp,sp,48
    80006288:	8082                	ret

000000008000628a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000628a:	1141                	addi	sp,sp,-16
    8000628c:	e422                	sd	s0,8(sp)
    8000628e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006290:	100007b7          	lui	a5,0x10000
    80006294:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006298:	8b85                	andi	a5,a5,1
    8000629a:	cb91                	beqz	a5,800062ae <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000629c:	100007b7          	lui	a5,0x10000
    800062a0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062a4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062a8:	6422                	ld	s0,8(sp)
    800062aa:	0141                	addi	sp,sp,16
    800062ac:	8082                	ret
    return -1;
    800062ae:	557d                	li	a0,-1
    800062b0:	bfe5                	j	800062a8 <uartgetc+0x1e>

00000000800062b2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800062b2:	1101                	addi	sp,sp,-32
    800062b4:	ec06                	sd	ra,24(sp)
    800062b6:	e822                	sd	s0,16(sp)
    800062b8:	e426                	sd	s1,8(sp)
    800062ba:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062bc:	54fd                	li	s1,-1
    int c = uartgetc();
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	fcc080e7          	jalr	-52(ra) # 8000628a <uartgetc>
    if(c == -1)
    800062c6:	00950763          	beq	a0,s1,800062d4 <uartintr+0x22>
      break;
    consoleintr(c);
    800062ca:	00000097          	auipc	ra,0x0
    800062ce:	8fe080e7          	jalr	-1794(ra) # 80005bc8 <consoleintr>
  while(1){
    800062d2:	b7f5                	j	800062be <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062d4:	0001b497          	auipc	s1,0x1b
    800062d8:	f3448493          	addi	s1,s1,-204 # 80021208 <uart_tx_lock>
    800062dc:	8526                	mv	a0,s1
    800062de:	00000097          	auipc	ra,0x0
    800062e2:	0b4080e7          	jalr	180(ra) # 80006392 <acquire>
  uartstart();
    800062e6:	00000097          	auipc	ra,0x0
    800062ea:	e64080e7          	jalr	-412(ra) # 8000614a <uartstart>
  release(&uart_tx_lock);
    800062ee:	8526                	mv	a0,s1
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	156080e7          	jalr	342(ra) # 80006446 <release>
}
    800062f8:	60e2                	ld	ra,24(sp)
    800062fa:	6442                	ld	s0,16(sp)
    800062fc:	64a2                	ld	s1,8(sp)
    800062fe:	6105                	addi	sp,sp,32
    80006300:	8082                	ret

0000000080006302 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006302:	1141                	addi	sp,sp,-16
    80006304:	e422                	sd	s0,8(sp)
    80006306:	0800                	addi	s0,sp,16
  lk->name = name;
    80006308:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000630a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000630e:	00053823          	sd	zero,16(a0)
}
    80006312:	6422                	ld	s0,8(sp)
    80006314:	0141                	addi	sp,sp,16
    80006316:	8082                	ret

0000000080006318 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006318:	411c                	lw	a5,0(a0)
    8000631a:	e399                	bnez	a5,80006320 <holding+0x8>
    8000631c:	4501                	li	a0,0
  return r;
}
    8000631e:	8082                	ret
{
    80006320:	1101                	addi	sp,sp,-32
    80006322:	ec06                	sd	ra,24(sp)
    80006324:	e822                	sd	s0,16(sp)
    80006326:	e426                	sd	s1,8(sp)
    80006328:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000632a:	6904                	ld	s1,16(a0)
    8000632c:	ffffb097          	auipc	ra,0xffffb
    80006330:	b00080e7          	jalr	-1280(ra) # 80000e2c <mycpu>
    80006334:	40a48533          	sub	a0,s1,a0
    80006338:	00153513          	seqz	a0,a0
}
    8000633c:	60e2                	ld	ra,24(sp)
    8000633e:	6442                	ld	s0,16(sp)
    80006340:	64a2                	ld	s1,8(sp)
    80006342:	6105                	addi	sp,sp,32
    80006344:	8082                	ret

0000000080006346 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006346:	1101                	addi	sp,sp,-32
    80006348:	ec06                	sd	ra,24(sp)
    8000634a:	e822                	sd	s0,16(sp)
    8000634c:	e426                	sd	s1,8(sp)
    8000634e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006350:	100024f3          	csrr	s1,sstatus
    80006354:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006358:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000635a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000635e:	ffffb097          	auipc	ra,0xffffb
    80006362:	ace080e7          	jalr	-1330(ra) # 80000e2c <mycpu>
    80006366:	5d3c                	lw	a5,120(a0)
    80006368:	cf89                	beqz	a5,80006382 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000636a:	ffffb097          	auipc	ra,0xffffb
    8000636e:	ac2080e7          	jalr	-1342(ra) # 80000e2c <mycpu>
    80006372:	5d3c                	lw	a5,120(a0)
    80006374:	2785                	addiw	a5,a5,1
    80006376:	dd3c                	sw	a5,120(a0)
}
    80006378:	60e2                	ld	ra,24(sp)
    8000637a:	6442                	ld	s0,16(sp)
    8000637c:	64a2                	ld	s1,8(sp)
    8000637e:	6105                	addi	sp,sp,32
    80006380:	8082                	ret
    mycpu()->intena = old;
    80006382:	ffffb097          	auipc	ra,0xffffb
    80006386:	aaa080e7          	jalr	-1366(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000638a:	8085                	srli	s1,s1,0x1
    8000638c:	8885                	andi	s1,s1,1
    8000638e:	dd64                	sw	s1,124(a0)
    80006390:	bfe9                	j	8000636a <push_off+0x24>

0000000080006392 <acquire>:
{
    80006392:	1101                	addi	sp,sp,-32
    80006394:	ec06                	sd	ra,24(sp)
    80006396:	e822                	sd	s0,16(sp)
    80006398:	e426                	sd	s1,8(sp)
    8000639a:	1000                	addi	s0,sp,32
    8000639c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000639e:	00000097          	auipc	ra,0x0
    800063a2:	fa8080e7          	jalr	-88(ra) # 80006346 <push_off>
  if(holding(lk))
    800063a6:	8526                	mv	a0,s1
    800063a8:	00000097          	auipc	ra,0x0
    800063ac:	f70080e7          	jalr	-144(ra) # 80006318 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063b0:	4705                	li	a4,1
  if(holding(lk))
    800063b2:	e115                	bnez	a0,800063d6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063b4:	87ba                	mv	a5,a4
    800063b6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063ba:	2781                	sext.w	a5,a5
    800063bc:	ffe5                	bnez	a5,800063b4 <acquire+0x22>
  __sync_synchronize();
    800063be:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063c2:	ffffb097          	auipc	ra,0xffffb
    800063c6:	a6a080e7          	jalr	-1430(ra) # 80000e2c <mycpu>
    800063ca:	e888                	sd	a0,16(s1)
}
    800063cc:	60e2                	ld	ra,24(sp)
    800063ce:	6442                	ld	s0,16(sp)
    800063d0:	64a2                	ld	s1,8(sp)
    800063d2:	6105                	addi	sp,sp,32
    800063d4:	8082                	ret
    panic("acquire");
    800063d6:	00002517          	auipc	a0,0x2
    800063da:	4c250513          	addi	a0,a0,1218 # 80008898 <digits+0x20>
    800063de:	00000097          	auipc	ra,0x0
    800063e2:	a6a080e7          	jalr	-1430(ra) # 80005e48 <panic>

00000000800063e6 <pop_off>:

void
pop_off(void)
{
    800063e6:	1141                	addi	sp,sp,-16
    800063e8:	e406                	sd	ra,8(sp)
    800063ea:	e022                	sd	s0,0(sp)
    800063ec:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063ee:	ffffb097          	auipc	ra,0xffffb
    800063f2:	a3e080e7          	jalr	-1474(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063f6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063fa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063fc:	e78d                	bnez	a5,80006426 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063fe:	5d3c                	lw	a5,120(a0)
    80006400:	02f05b63          	blez	a5,80006436 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006404:	37fd                	addiw	a5,a5,-1
    80006406:	0007871b          	sext.w	a4,a5
    8000640a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000640c:	eb09                	bnez	a4,8000641e <pop_off+0x38>
    8000640e:	5d7c                	lw	a5,124(a0)
    80006410:	c799                	beqz	a5,8000641e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006412:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006416:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000641a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000641e:	60a2                	ld	ra,8(sp)
    80006420:	6402                	ld	s0,0(sp)
    80006422:	0141                	addi	sp,sp,16
    80006424:	8082                	ret
    panic("pop_off - interruptible");
    80006426:	00002517          	auipc	a0,0x2
    8000642a:	47a50513          	addi	a0,a0,1146 # 800088a0 <digits+0x28>
    8000642e:	00000097          	auipc	ra,0x0
    80006432:	a1a080e7          	jalr	-1510(ra) # 80005e48 <panic>
    panic("pop_off");
    80006436:	00002517          	auipc	a0,0x2
    8000643a:	48250513          	addi	a0,a0,1154 # 800088b8 <digits+0x40>
    8000643e:	00000097          	auipc	ra,0x0
    80006442:	a0a080e7          	jalr	-1526(ra) # 80005e48 <panic>

0000000080006446 <release>:
{
    80006446:	1101                	addi	sp,sp,-32
    80006448:	ec06                	sd	ra,24(sp)
    8000644a:	e822                	sd	s0,16(sp)
    8000644c:	e426                	sd	s1,8(sp)
    8000644e:	1000                	addi	s0,sp,32
    80006450:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006452:	00000097          	auipc	ra,0x0
    80006456:	ec6080e7          	jalr	-314(ra) # 80006318 <holding>
    8000645a:	c115                	beqz	a0,8000647e <release+0x38>
  lk->cpu = 0;
    8000645c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006460:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006464:	0f50000f          	fence	iorw,ow
    80006468:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000646c:	00000097          	auipc	ra,0x0
    80006470:	f7a080e7          	jalr	-134(ra) # 800063e6 <pop_off>
}
    80006474:	60e2                	ld	ra,24(sp)
    80006476:	6442                	ld	s0,16(sp)
    80006478:	64a2                	ld	s1,8(sp)
    8000647a:	6105                	addi	sp,sp,32
    8000647c:	8082                	ret
    panic("release");
    8000647e:	00002517          	auipc	a0,0x2
    80006482:	44250513          	addi	a0,a0,1090 # 800088c0 <digits+0x48>
    80006486:	00000097          	auipc	ra,0x0
    8000648a:	9c2080e7          	jalr	-1598(ra) # 80005e48 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
