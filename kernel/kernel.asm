
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	85013103          	ld	sp,-1968(sp) # 80008850 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	303050ef          	jal	ra,80005b18 <start>

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
    80000030:	00030797          	auipc	a5,0x30
    80000034:	21078793          	addi	a5,a5,528 # 80030240 <end>
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
    8000005e:	4b8080e7          	jalr	1208(ra) # 80006512 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	558080e7          	jalr	1368(ra) # 800065c6 <release>
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
    8000008e:	f3e080e7          	jalr	-194(ra) # 80005fc8 <panic>

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
    800000f8:	38e080e7          	jalr	910(ra) # 80006482 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00030517          	auipc	a0,0x30
    80000104:	14050513          	addi	a0,a0,320 # 80030240 <end>
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
    80000130:	3e6080e7          	jalr	998(ra) # 80006512 <acquire>
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
    80000148:	482080e7          	jalr	1154(ra) # 800065c6 <release>

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
    80000172:	458080e7          	jalr	1112(ra) # 800065c6 <release>
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
    80000332:	ad4080e7          	jalr	-1324(ra) # 80000e02 <cpuid>
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
    8000034e:	ab8080e7          	jalr	-1352(ra) # 80000e02 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	cb6080e7          	jalr	-842(ra) # 80006012 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	90c080e7          	jalr	-1780(ra) # 80001c78 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	12c080e7          	jalr	300(ra) # 800054a0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	01e080e7          	jalr	30(ra) # 8000139a <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	b56080e7          	jalr	-1194(ra) # 80005eda <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	e6c080e7          	jalr	-404(ra) # 800061f8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	c76080e7          	jalr	-906(ra) # 80006012 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	c66080e7          	jalr	-922(ra) # 80006012 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	c56080e7          	jalr	-938(ra) # 80006012 <printf>
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
    800003e0:	976080e7          	jalr	-1674(ra) # 80000d52 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	86c080e7          	jalr	-1940(ra) # 80001c50 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	88c080e7          	jalr	-1908(ra) # 80001c78 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	096080e7          	jalr	150(ra) # 8000548a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	0a4080e7          	jalr	164(ra) # 800054a0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	fd4080e7          	jalr	-44(ra) # 800023d8 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	664080e7          	jalr	1636(ra) # 80002a70 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	60e080e7          	jalr	1550(ra) # 80003a22 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	1a6080e7          	jalr	422(ra) # 800055c2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cfa080e7          	jalr	-774(ra) # 8000111e <userinit>
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
    80000492:	b3a080e7          	jalr	-1222(ra) # 80005fc8 <panic>
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
    8000058a:	a42080e7          	jalr	-1470(ra) # 80005fc8 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	a32080e7          	jalr	-1486(ra) # 80005fc8 <panic>
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
    80000614:	9b8080e7          	jalr	-1608(ra) # 80005fc8 <panic>

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
    800006dc:	5e4080e7          	jalr	1508(ra) # 80000cbc <proc_mapstacks>
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
    8000072e:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      continue;
      // panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6a85                	lui	s5,0x1
    8000073a:	0735e163          	bltu	a1,s3,8000079c <uvmunmap+0x8e>
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
    8000075c:	00006097          	auipc	ra,0x6
    80000760:	86c080e7          	jalr	-1940(ra) # 80005fc8 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00006097          	auipc	ra,0x6
    80000770:	85c080e7          	jalr	-1956(ra) # 80005fc8 <panic>
      panic("uvmunmap: not a leaf");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00006097          	auipc	ra,0x6
    80000780:	84c080e7          	jalr	-1972(ra) # 80005fc8 <panic>
      uint64 pa = PTE2PA(*pte);
    80000784:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80000786:	00c79513          	slli	a0,a5,0xc
    8000078a:	00000097          	auipc	ra,0x0
    8000078e:	892080e7          	jalr	-1902(ra) # 8000001c <kfree>
    *pte = 0;
    80000792:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000796:	9956                	add	s2,s2,s5
    80000798:	fb3973e3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079c:	4601                	li	a2,0
    8000079e:	85ca                	mv	a1,s2
    800007a0:	8552                	mv	a0,s4
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	cbe080e7          	jalr	-834(ra) # 80000460 <walk>
    800007aa:	84aa                	mv	s1,a0
    800007ac:	dd45                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ae:	611c                	ld	a5,0(a0)
    800007b0:	0017f713          	andi	a4,a5,1
    800007b4:	d36d                	beqz	a4,80000796 <uvmunmap+0x88>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b6:	3ff7f713          	andi	a4,a5,1023
    800007ba:	fb770de3          	beq	a4,s7,80000774 <uvmunmap+0x66>
    if(do_free){
    800007be:	fc0b0ae3          	beqz	s6,80000792 <uvmunmap+0x84>
    800007c2:	b7c9                	j	80000784 <uvmunmap+0x76>

00000000800007c4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007c4:	1101                	addi	sp,sp,-32
    800007c6:	ec06                	sd	ra,24(sp)
    800007c8:	e822                	sd	s0,16(sp)
    800007ca:	e426                	sd	s1,8(sp)
    800007cc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	94a080e7          	jalr	-1718(ra) # 80000118 <kalloc>
    800007d6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007d8:	c519                	beqz	a0,800007e6 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007da:	6605                	lui	a2,0x1
    800007dc:	4581                	li	a1,0
    800007de:	00000097          	auipc	ra,0x0
    800007e2:	99a080e7          	jalr	-1638(ra) # 80000178 <memset>
  return pagetable;
}
    800007e6:	8526                	mv	a0,s1
    800007e8:	60e2                	ld	ra,24(sp)
    800007ea:	6442                	ld	s0,16(sp)
    800007ec:	64a2                	ld	s1,8(sp)
    800007ee:	6105                	addi	sp,sp,32
    800007f0:	8082                	ret

00000000800007f2 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f2:	7179                	addi	sp,sp,-48
    800007f4:	f406                	sd	ra,40(sp)
    800007f6:	f022                	sd	s0,32(sp)
    800007f8:	ec26                	sd	s1,24(sp)
    800007fa:	e84a                	sd	s2,16(sp)
    800007fc:	e44e                	sd	s3,8(sp)
    800007fe:	e052                	sd	s4,0(sp)
    80000800:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000802:	6785                	lui	a5,0x1
    80000804:	04f67863          	bgeu	a2,a5,80000854 <uvminit+0x62>
    80000808:	8a2a                	mv	s4,a0
    8000080a:	89ae                	mv	s3,a1
    8000080c:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000080e:	00000097          	auipc	ra,0x0
    80000812:	90a080e7          	jalr	-1782(ra) # 80000118 <kalloc>
    80000816:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000818:	6605                	lui	a2,0x1
    8000081a:	4581                	li	a1,0
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	95c080e7          	jalr	-1700(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000824:	4779                	li	a4,30
    80000826:	86ca                	mv	a3,s2
    80000828:	6605                	lui	a2,0x1
    8000082a:	4581                	li	a1,0
    8000082c:	8552                	mv	a0,s4
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	d1a080e7          	jalr	-742(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000836:	8626                	mv	a2,s1
    80000838:	85ce                	mv	a1,s3
    8000083a:	854a                	mv	a0,s2
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	99c080e7          	jalr	-1636(ra) # 800001d8 <memmove>
}
    80000844:	70a2                	ld	ra,40(sp)
    80000846:	7402                	ld	s0,32(sp)
    80000848:	64e2                	ld	s1,24(sp)
    8000084a:	6942                	ld	s2,16(sp)
    8000084c:	69a2                	ld	s3,8(sp)
    8000084e:	6a02                	ld	s4,0(sp)
    80000850:	6145                	addi	sp,sp,48
    80000852:	8082                	ret
    panic("inituvm: more than a page");
    80000854:	00008517          	auipc	a0,0x8
    80000858:	86c50513          	addi	a0,a0,-1940 # 800080c0 <etext+0xc0>
    8000085c:	00005097          	auipc	ra,0x5
    80000860:	76c080e7          	jalr	1900(ra) # 80005fc8 <panic>

0000000080000864 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000864:	1101                	addi	sp,sp,-32
    80000866:	ec06                	sd	ra,24(sp)
    80000868:	e822                	sd	s0,16(sp)
    8000086a:	e426                	sd	s1,8(sp)
    8000086c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000086e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000870:	00b67d63          	bgeu	a2,a1,8000088a <uvmdealloc+0x26>
    80000874:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000876:	6785                	lui	a5,0x1
    80000878:	17fd                	addi	a5,a5,-1
    8000087a:	00f60733          	add	a4,a2,a5
    8000087e:	767d                	lui	a2,0xfffff
    80000880:	8f71                	and	a4,a4,a2
    80000882:	97ae                	add	a5,a5,a1
    80000884:	8ff1                	and	a5,a5,a2
    80000886:	00f76863          	bltu	a4,a5,80000896 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000088a:	8526                	mv	a0,s1
    8000088c:	60e2                	ld	ra,24(sp)
    8000088e:	6442                	ld	s0,16(sp)
    80000890:	64a2                	ld	s1,8(sp)
    80000892:	6105                	addi	sp,sp,32
    80000894:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000896:	8f99                	sub	a5,a5,a4
    80000898:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000089a:	4685                	li	a3,1
    8000089c:	0007861b          	sext.w	a2,a5
    800008a0:	85ba                	mv	a1,a4
    800008a2:	00000097          	auipc	ra,0x0
    800008a6:	e6c080e7          	jalr	-404(ra) # 8000070e <uvmunmap>
    800008aa:	b7c5                	j	8000088a <uvmdealloc+0x26>

00000000800008ac <uvmalloc>:
  if(newsz < oldsz)
    800008ac:	0ab66163          	bltu	a2,a1,8000094e <uvmalloc+0xa2>
{
    800008b0:	7139                	addi	sp,sp,-64
    800008b2:	fc06                	sd	ra,56(sp)
    800008b4:	f822                	sd	s0,48(sp)
    800008b6:	f426                	sd	s1,40(sp)
    800008b8:	f04a                	sd	s2,32(sp)
    800008ba:	ec4e                	sd	s3,24(sp)
    800008bc:	e852                	sd	s4,16(sp)
    800008be:	e456                	sd	s5,8(sp)
    800008c0:	0080                	addi	s0,sp,64
    800008c2:	8aaa                	mv	s5,a0
    800008c4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008c6:	6985                	lui	s3,0x1
    800008c8:	19fd                	addi	s3,s3,-1
    800008ca:	95ce                	add	a1,a1,s3
    800008cc:	79fd                	lui	s3,0xfffff
    800008ce:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008d2:	08c9f063          	bgeu	s3,a2,80000952 <uvmalloc+0xa6>
    800008d6:	894e                	mv	s2,s3
    mem = kalloc();
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	840080e7          	jalr	-1984(ra) # 80000118 <kalloc>
    800008e0:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e2:	c51d                	beqz	a0,80000910 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008e4:	6605                	lui	a2,0x1
    800008e6:	4581                	li	a1,0
    800008e8:	00000097          	auipc	ra,0x0
    800008ec:	890080e7          	jalr	-1904(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008f0:	4779                	li	a4,30
    800008f2:	86a6                	mv	a3,s1
    800008f4:	6605                	lui	a2,0x1
    800008f6:	85ca                	mv	a1,s2
    800008f8:	8556                	mv	a0,s5
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	c4e080e7          	jalr	-946(ra) # 80000548 <mappages>
    80000902:	e905                	bnez	a0,80000932 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000904:	6785                	lui	a5,0x1
    80000906:	993e                	add	s2,s2,a5
    80000908:	fd4968e3          	bltu	s2,s4,800008d8 <uvmalloc+0x2c>
  return newsz;
    8000090c:	8552                	mv	a0,s4
    8000090e:	a809                	j	80000920 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000910:	864e                	mv	a2,s3
    80000912:	85ca                	mv	a1,s2
    80000914:	8556                	mv	a0,s5
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	f4e080e7          	jalr	-178(ra) # 80000864 <uvmdealloc>
      return 0;
    8000091e:	4501                	li	a0,0
}
    80000920:	70e2                	ld	ra,56(sp)
    80000922:	7442                	ld	s0,48(sp)
    80000924:	74a2                	ld	s1,40(sp)
    80000926:	7902                	ld	s2,32(sp)
    80000928:	69e2                	ld	s3,24(sp)
    8000092a:	6a42                	ld	s4,16(sp)
    8000092c:	6aa2                	ld	s5,8(sp)
    8000092e:	6121                	addi	sp,sp,64
    80000930:	8082                	ret
      kfree(mem);
    80000932:	8526                	mv	a0,s1
    80000934:	fffff097          	auipc	ra,0xfffff
    80000938:	6e8080e7          	jalr	1768(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000093c:	864e                	mv	a2,s3
    8000093e:	85ca                	mv	a1,s2
    80000940:	8556                	mv	a0,s5
    80000942:	00000097          	auipc	ra,0x0
    80000946:	f22080e7          	jalr	-222(ra) # 80000864 <uvmdealloc>
      return 0;
    8000094a:	4501                	li	a0,0
    8000094c:	bfd1                	j	80000920 <uvmalloc+0x74>
    return oldsz;
    8000094e:	852e                	mv	a0,a1
}
    80000950:	8082                	ret
  return newsz;
    80000952:	8532                	mv	a0,a2
    80000954:	b7f1                	j	80000920 <uvmalloc+0x74>

0000000080000956 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000956:	7179                	addi	sp,sp,-48
    80000958:	f406                	sd	ra,40(sp)
    8000095a:	f022                	sd	s0,32(sp)
    8000095c:	ec26                	sd	s1,24(sp)
    8000095e:	e84a                	sd	s2,16(sp)
    80000960:	e44e                	sd	s3,8(sp)
    80000962:	e052                	sd	s4,0(sp)
    80000964:	1800                	addi	s0,sp,48
    80000966:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000968:	84aa                	mv	s1,a0
    8000096a:	6905                	lui	s2,0x1
    8000096c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000096e:	4985                	li	s3,1
    80000970:	a821                	j	80000988 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000972:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000974:	0532                	slli	a0,a0,0xc
    80000976:	00000097          	auipc	ra,0x0
    8000097a:	fe0080e7          	jalr	-32(ra) # 80000956 <freewalk>
      pagetable[i] = 0;
    8000097e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000982:	04a1                	addi	s1,s1,8
    80000984:	03248163          	beq	s1,s2,800009a6 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000988:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000098a:	00f57793          	andi	a5,a0,15
    8000098e:	ff3782e3          	beq	a5,s3,80000972 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000992:	8905                	andi	a0,a0,1
    80000994:	d57d                	beqz	a0,80000982 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000996:	00007517          	auipc	a0,0x7
    8000099a:	74a50513          	addi	a0,a0,1866 # 800080e0 <etext+0xe0>
    8000099e:	00005097          	auipc	ra,0x5
    800009a2:	62a080e7          	jalr	1578(ra) # 80005fc8 <panic>
    }
  }
  kfree((void*)pagetable);
    800009a6:	8552                	mv	a0,s4
    800009a8:	fffff097          	auipc	ra,0xfffff
    800009ac:	674080e7          	jalr	1652(ra) # 8000001c <kfree>
}
    800009b0:	70a2                	ld	ra,40(sp)
    800009b2:	7402                	ld	s0,32(sp)
    800009b4:	64e2                	ld	s1,24(sp)
    800009b6:	6942                	ld	s2,16(sp)
    800009b8:	69a2                	ld	s3,8(sp)
    800009ba:	6a02                	ld	s4,0(sp)
    800009bc:	6145                	addi	sp,sp,48
    800009be:	8082                	ret

00000000800009c0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009c0:	1101                	addi	sp,sp,-32
    800009c2:	ec06                	sd	ra,24(sp)
    800009c4:	e822                	sd	s0,16(sp)
    800009c6:	e426                	sd	s1,8(sp)
    800009c8:	1000                	addi	s0,sp,32
    800009ca:	84aa                	mv	s1,a0
  if(sz > 0)
    800009cc:	e999                	bnez	a1,800009e2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009ce:	8526                	mv	a0,s1
    800009d0:	00000097          	auipc	ra,0x0
    800009d4:	f86080e7          	jalr	-122(ra) # 80000956 <freewalk>
}
    800009d8:	60e2                	ld	ra,24(sp)
    800009da:	6442                	ld	s0,16(sp)
    800009dc:	64a2                	ld	s1,8(sp)
    800009de:	6105                	addi	sp,sp,32
    800009e0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009e2:	6605                	lui	a2,0x1
    800009e4:	167d                	addi	a2,a2,-1
    800009e6:	962e                	add	a2,a2,a1
    800009e8:	4685                	li	a3,1
    800009ea:	8231                	srli	a2,a2,0xc
    800009ec:	4581                	li	a1,0
    800009ee:	00000097          	auipc	ra,0x0
    800009f2:	d20080e7          	jalr	-736(ra) # 8000070e <uvmunmap>
    800009f6:	bfe1                	j	800009ce <uvmfree+0xe>

00000000800009f8 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800009f8:	c269                	beqz	a2,80000aba <uvmcopy+0xc2>
{
    800009fa:	715d                	addi	sp,sp,-80
    800009fc:	e486                	sd	ra,72(sp)
    800009fe:	e0a2                	sd	s0,64(sp)
    80000a00:	fc26                	sd	s1,56(sp)
    80000a02:	f84a                	sd	s2,48(sp)
    80000a04:	f44e                	sd	s3,40(sp)
    80000a06:	f052                	sd	s4,32(sp)
    80000a08:	ec56                	sd	s5,24(sp)
    80000a0a:	e85a                	sd	s6,16(sp)
    80000a0c:	e45e                	sd	s7,8(sp)
    80000a0e:	0880                	addi	s0,sp,80
    80000a10:	8aaa                	mv	s5,a0
    80000a12:	8b2e                	mv	s6,a1
    80000a14:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a16:	4481                	li	s1,0
    80000a18:	a829                	j	80000a32 <uvmcopy+0x3a>
    if((pte = walk(old, i, 0)) == 0)
      panic("uvmcopy: pte should exist");
    80000a1a:	00007517          	auipc	a0,0x7
    80000a1e:	6d650513          	addi	a0,a0,1750 # 800080f0 <etext+0xf0>
    80000a22:	00005097          	auipc	ra,0x5
    80000a26:	5a6080e7          	jalr	1446(ra) # 80005fc8 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    80000a2a:	6785                	lui	a5,0x1
    80000a2c:	94be                	add	s1,s1,a5
    80000a2e:	0944f463          	bgeu	s1,s4,80000ab6 <uvmcopy+0xbe>
    if((pte = walk(old, i, 0)) == 0)
    80000a32:	4601                	li	a2,0
    80000a34:	85a6                	mv	a1,s1
    80000a36:	8556                	mv	a0,s5
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	a28080e7          	jalr	-1496(ra) # 80000460 <walk>
    80000a40:	dd69                	beqz	a0,80000a1a <uvmcopy+0x22>
    if((*pte & PTE_V) == 0)
    80000a42:	6118                	ld	a4,0(a0)
    80000a44:	00177793          	andi	a5,a4,1
    80000a48:	d3ed                	beqz	a5,80000a2a <uvmcopy+0x32>
      continue;
      // panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4a:	00a75593          	srli	a1,a4,0xa
    80000a4e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a52:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80000a56:	fffff097          	auipc	ra,0xfffff
    80000a5a:	6c2080e7          	jalr	1730(ra) # 80000118 <kalloc>
    80000a5e:	89aa                	mv	s3,a0
    80000a60:	c515                	beqz	a0,80000a8c <uvmcopy+0x94>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85de                	mv	a1,s7
    80000a66:	fffff097          	auipc	ra,0xfffff
    80000a6a:	772080e7          	jalr	1906(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6e:	874a                	mv	a4,s2
    80000a70:	86ce                	mv	a3,s3
    80000a72:	6605                	lui	a2,0x1
    80000a74:	85a6                	mv	a1,s1
    80000a76:	855a                	mv	a0,s6
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	ad0080e7          	jalr	-1328(ra) # 80000548 <mappages>
    80000a80:	d54d                	beqz	a0,80000a2a <uvmcopy+0x32>
      kfree(mem);
    80000a82:	854e                	mv	a0,s3
    80000a84:	fffff097          	auipc	ra,0xfffff
    80000a88:	598080e7          	jalr	1432(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a8c:	4685                	li	a3,1
    80000a8e:	00c4d613          	srli	a2,s1,0xc
    80000a92:	4581                	li	a1,0
    80000a94:	855a                	mv	a0,s6
    80000a96:	00000097          	auipc	ra,0x0
    80000a9a:	c78080e7          	jalr	-904(ra) # 8000070e <uvmunmap>
  return -1;
    80000a9e:	557d                	li	a0,-1
}
    80000aa0:	60a6                	ld	ra,72(sp)
    80000aa2:	6406                	ld	s0,64(sp)
    80000aa4:	74e2                	ld	s1,56(sp)
    80000aa6:	7942                	ld	s2,48(sp)
    80000aa8:	79a2                	ld	s3,40(sp)
    80000aaa:	7a02                	ld	s4,32(sp)
    80000aac:	6ae2                	ld	s5,24(sp)
    80000aae:	6b42                	ld	s6,16(sp)
    80000ab0:	6ba2                	ld	s7,8(sp)
    80000ab2:	6161                	addi	sp,sp,80
    80000ab4:	8082                	ret
  return 0;
    80000ab6:	4501                	li	a0,0
    80000ab8:	b7e5                	j	80000aa0 <uvmcopy+0xa8>
    80000aba:	4501                	li	a0,0
}
    80000abc:	8082                	ret

0000000080000abe <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000abe:	1141                	addi	sp,sp,-16
    80000ac0:	e406                	sd	ra,8(sp)
    80000ac2:	e022                	sd	s0,0(sp)
    80000ac4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ac6:	4601                	li	a2,0
    80000ac8:	00000097          	auipc	ra,0x0
    80000acc:	998080e7          	jalr	-1640(ra) # 80000460 <walk>
  if(pte == 0)
    80000ad0:	c901                	beqz	a0,80000ae0 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ad2:	611c                	ld	a5,0(a0)
    80000ad4:	9bbd                	andi	a5,a5,-17
    80000ad6:	e11c                	sd	a5,0(a0)
}
    80000ad8:	60a2                	ld	ra,8(sp)
    80000ada:	6402                	ld	s0,0(sp)
    80000adc:	0141                	addi	sp,sp,16
    80000ade:	8082                	ret
    panic("uvmclear");
    80000ae0:	00007517          	auipc	a0,0x7
    80000ae4:	63050513          	addi	a0,a0,1584 # 80008110 <etext+0x110>
    80000ae8:	00005097          	auipc	ra,0x5
    80000aec:	4e0080e7          	jalr	1248(ra) # 80005fc8 <panic>

0000000080000af0 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000af0:	c6bd                	beqz	a3,80000b5e <copyout+0x6e>
{
    80000af2:	715d                	addi	sp,sp,-80
    80000af4:	e486                	sd	ra,72(sp)
    80000af6:	e0a2                	sd	s0,64(sp)
    80000af8:	fc26                	sd	s1,56(sp)
    80000afa:	f84a                	sd	s2,48(sp)
    80000afc:	f44e                	sd	s3,40(sp)
    80000afe:	f052                	sd	s4,32(sp)
    80000b00:	ec56                	sd	s5,24(sp)
    80000b02:	e85a                	sd	s6,16(sp)
    80000b04:	e45e                	sd	s7,8(sp)
    80000b06:	e062                	sd	s8,0(sp)
    80000b08:	0880                	addi	s0,sp,80
    80000b0a:	8b2a                	mv	s6,a0
    80000b0c:	8c2e                	mv	s8,a1
    80000b0e:	8a32                	mv	s4,a2
    80000b10:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b12:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b14:	6a85                	lui	s5,0x1
    80000b16:	a015                	j	80000b3a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b18:	9562                	add	a0,a0,s8
    80000b1a:	0004861b          	sext.w	a2,s1
    80000b1e:	85d2                	mv	a1,s4
    80000b20:	41250533          	sub	a0,a0,s2
    80000b24:	fffff097          	auipc	ra,0xfffff
    80000b28:	6b4080e7          	jalr	1716(ra) # 800001d8 <memmove>

    len -= n;
    80000b2c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b30:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b32:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b36:	02098263          	beqz	s3,80000b5a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b3a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b3e:	85ca                	mv	a1,s2
    80000b40:	855a                	mv	a0,s6
    80000b42:	00000097          	auipc	ra,0x0
    80000b46:	9c4080e7          	jalr	-1596(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b4a:	cd01                	beqz	a0,80000b62 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b4c:	418904b3          	sub	s1,s2,s8
    80000b50:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b52:	fc99f3e3          	bgeu	s3,s1,80000b18 <copyout+0x28>
    80000b56:	84ce                	mv	s1,s3
    80000b58:	b7c1                	j	80000b18 <copyout+0x28>
  }
  return 0;
    80000b5a:	4501                	li	a0,0
    80000b5c:	a021                	j	80000b64 <copyout+0x74>
    80000b5e:	4501                	li	a0,0
}
    80000b60:	8082                	ret
      return -1;
    80000b62:	557d                	li	a0,-1
}
    80000b64:	60a6                	ld	ra,72(sp)
    80000b66:	6406                	ld	s0,64(sp)
    80000b68:	74e2                	ld	s1,56(sp)
    80000b6a:	7942                	ld	s2,48(sp)
    80000b6c:	79a2                	ld	s3,40(sp)
    80000b6e:	7a02                	ld	s4,32(sp)
    80000b70:	6ae2                	ld	s5,24(sp)
    80000b72:	6b42                	ld	s6,16(sp)
    80000b74:	6ba2                	ld	s7,8(sp)
    80000b76:	6c02                	ld	s8,0(sp)
    80000b78:	6161                	addi	sp,sp,80
    80000b7a:	8082                	ret

0000000080000b7c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b7c:	c6bd                	beqz	a3,80000bea <copyin+0x6e>
{
    80000b7e:	715d                	addi	sp,sp,-80
    80000b80:	e486                	sd	ra,72(sp)
    80000b82:	e0a2                	sd	s0,64(sp)
    80000b84:	fc26                	sd	s1,56(sp)
    80000b86:	f84a                	sd	s2,48(sp)
    80000b88:	f44e                	sd	s3,40(sp)
    80000b8a:	f052                	sd	s4,32(sp)
    80000b8c:	ec56                	sd	s5,24(sp)
    80000b8e:	e85a                	sd	s6,16(sp)
    80000b90:	e45e                	sd	s7,8(sp)
    80000b92:	e062                	sd	s8,0(sp)
    80000b94:	0880                	addi	s0,sp,80
    80000b96:	8b2a                	mv	s6,a0
    80000b98:	8a2e                	mv	s4,a1
    80000b9a:	8c32                	mv	s8,a2
    80000b9c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b9e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ba0:	6a85                	lui	s5,0x1
    80000ba2:	a015                	j	80000bc6 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba4:	9562                	add	a0,a0,s8
    80000ba6:	0004861b          	sext.w	a2,s1
    80000baa:	412505b3          	sub	a1,a0,s2
    80000bae:	8552                	mv	a0,s4
    80000bb0:	fffff097          	auipc	ra,0xfffff
    80000bb4:	628080e7          	jalr	1576(ra) # 800001d8 <memmove>

    len -= n;
    80000bb8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bbc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bbe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bc2:	02098263          	beqz	s3,80000be6 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bc6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bca:	85ca                	mv	a1,s2
    80000bcc:	855a                	mv	a0,s6
    80000bce:	00000097          	auipc	ra,0x0
    80000bd2:	938080e7          	jalr	-1736(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bd6:	cd01                	beqz	a0,80000bee <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bd8:	418904b3          	sub	s1,s2,s8
    80000bdc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bde:	fc99f3e3          	bgeu	s3,s1,80000ba4 <copyin+0x28>
    80000be2:	84ce                	mv	s1,s3
    80000be4:	b7c1                	j	80000ba4 <copyin+0x28>
  }
  return 0;
    80000be6:	4501                	li	a0,0
    80000be8:	a021                	j	80000bf0 <copyin+0x74>
    80000bea:	4501                	li	a0,0
}
    80000bec:	8082                	ret
      return -1;
    80000bee:	557d                	li	a0,-1
}
    80000bf0:	60a6                	ld	ra,72(sp)
    80000bf2:	6406                	ld	s0,64(sp)
    80000bf4:	74e2                	ld	s1,56(sp)
    80000bf6:	7942                	ld	s2,48(sp)
    80000bf8:	79a2                	ld	s3,40(sp)
    80000bfa:	7a02                	ld	s4,32(sp)
    80000bfc:	6ae2                	ld	s5,24(sp)
    80000bfe:	6b42                	ld	s6,16(sp)
    80000c00:	6ba2                	ld	s7,8(sp)
    80000c02:	6c02                	ld	s8,0(sp)
    80000c04:	6161                	addi	sp,sp,80
    80000c06:	8082                	ret

0000000080000c08 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c08:	c6c5                	beqz	a3,80000cb0 <copyinstr+0xa8>
{
    80000c0a:	715d                	addi	sp,sp,-80
    80000c0c:	e486                	sd	ra,72(sp)
    80000c0e:	e0a2                	sd	s0,64(sp)
    80000c10:	fc26                	sd	s1,56(sp)
    80000c12:	f84a                	sd	s2,48(sp)
    80000c14:	f44e                	sd	s3,40(sp)
    80000c16:	f052                	sd	s4,32(sp)
    80000c18:	ec56                	sd	s5,24(sp)
    80000c1a:	e85a                	sd	s6,16(sp)
    80000c1c:	e45e                	sd	s7,8(sp)
    80000c1e:	0880                	addi	s0,sp,80
    80000c20:	8a2a                	mv	s4,a0
    80000c22:	8b2e                	mv	s6,a1
    80000c24:	8bb2                	mv	s7,a2
    80000c26:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c28:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c2a:	6985                	lui	s3,0x1
    80000c2c:	a035                	j	80000c58 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c2e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c32:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c34:	0017b793          	seqz	a5,a5
    80000c38:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c3c:	60a6                	ld	ra,72(sp)
    80000c3e:	6406                	ld	s0,64(sp)
    80000c40:	74e2                	ld	s1,56(sp)
    80000c42:	7942                	ld	s2,48(sp)
    80000c44:	79a2                	ld	s3,40(sp)
    80000c46:	7a02                	ld	s4,32(sp)
    80000c48:	6ae2                	ld	s5,24(sp)
    80000c4a:	6b42                	ld	s6,16(sp)
    80000c4c:	6ba2                	ld	s7,8(sp)
    80000c4e:	6161                	addi	sp,sp,80
    80000c50:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c52:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c56:	c8a9                	beqz	s1,80000ca8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c58:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c5c:	85ca                	mv	a1,s2
    80000c5e:	8552                	mv	a0,s4
    80000c60:	00000097          	auipc	ra,0x0
    80000c64:	8a6080e7          	jalr	-1882(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c68:	c131                	beqz	a0,80000cac <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c6a:	41790833          	sub	a6,s2,s7
    80000c6e:	984e                	add	a6,a6,s3
    if(n > max)
    80000c70:	0104f363          	bgeu	s1,a6,80000c76 <copyinstr+0x6e>
    80000c74:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c76:	955e                	add	a0,a0,s7
    80000c78:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c7c:	fc080be3          	beqz	a6,80000c52 <copyinstr+0x4a>
    80000c80:	985a                	add	a6,a6,s6
    80000c82:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c84:	41650633          	sub	a2,a0,s6
    80000c88:	14fd                	addi	s1,s1,-1
    80000c8a:	9b26                	add	s6,s6,s1
    80000c8c:	00f60733          	add	a4,a2,a5
    80000c90:	00074703          	lbu	a4,0(a4)
    80000c94:	df49                	beqz	a4,80000c2e <copyinstr+0x26>
        *dst = *p;
    80000c96:	00e78023          	sb	a4,0(a5)
      --max;
    80000c9a:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000c9e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000ca0:	ff0796e3          	bne	a5,a6,80000c8c <copyinstr+0x84>
      dst++;
    80000ca4:	8b42                	mv	s6,a6
    80000ca6:	b775                	j	80000c52 <copyinstr+0x4a>
    80000ca8:	4781                	li	a5,0
    80000caa:	b769                	j	80000c34 <copyinstr+0x2c>
      return -1;
    80000cac:	557d                	li	a0,-1
    80000cae:	b779                	j	80000c3c <copyinstr+0x34>
  int got_null = 0;
    80000cb0:	4781                	li	a5,0
  if(got_null){
    80000cb2:	0017b793          	seqz	a5,a5
    80000cb6:	40f00533          	neg	a0,a5
}
    80000cba:	8082                	ret

0000000080000cbc <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cbc:	7139                	addi	sp,sp,-64
    80000cbe:	fc06                	sd	ra,56(sp)
    80000cc0:	f822                	sd	s0,48(sp)
    80000cc2:	f426                	sd	s1,40(sp)
    80000cc4:	f04a                	sd	s2,32(sp)
    80000cc6:	ec4e                	sd	s3,24(sp)
    80000cc8:	e852                	sd	s4,16(sp)
    80000cca:	e456                	sd	s5,8(sp)
    80000ccc:	e05a                	sd	s6,0(sp)
    80000cce:	0080                	addi	s0,sp,64
    80000cd0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd2:	00008497          	auipc	s1,0x8
    80000cd6:	7ae48493          	addi	s1,s1,1966 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cda:	8b26                	mv	s6,s1
    80000cdc:	00007a97          	auipc	s5,0x7
    80000ce0:	324a8a93          	addi	s5,s5,804 # 80008000 <etext>
    80000ce4:	04000937          	lui	s2,0x4000
    80000ce8:	197d                	addi	s2,s2,-1
    80000cea:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00018a17          	auipc	s4,0x18
    80000cf0:	194a0a13          	addi	s4,s4,404 # 80018e80 <tickslock>
    char *pa = kalloc();
    80000cf4:	fffff097          	auipc	ra,0xfffff
    80000cf8:	424080e7          	jalr	1060(ra) # 80000118 <kalloc>
    80000cfc:	862a                	mv	a2,a0
    if(pa == 0)
    80000cfe:	c131                	beqz	a0,80000d42 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d00:	416485b3          	sub	a1,s1,s6
    80000d04:	858d                	srai	a1,a1,0x3
    80000d06:	000ab783          	ld	a5,0(s5)
    80000d0a:	02f585b3          	mul	a1,a1,a5
    80000d0e:	2585                	addiw	a1,a1,1
    80000d10:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d14:	4719                	li	a4,6
    80000d16:	6685                	lui	a3,0x1
    80000d18:	40b905b3          	sub	a1,s2,a1
    80000d1c:	854e                	mv	a0,s3
    80000d1e:	00000097          	auipc	ra,0x0
    80000d22:	8ca080e7          	jalr	-1846(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d26:	3e848493          	addi	s1,s1,1000
    80000d2a:	fd4495e3          	bne	s1,s4,80000cf4 <proc_mapstacks+0x38>
  }
}
    80000d2e:	70e2                	ld	ra,56(sp)
    80000d30:	7442                	ld	s0,48(sp)
    80000d32:	74a2                	ld	s1,40(sp)
    80000d34:	7902                	ld	s2,32(sp)
    80000d36:	69e2                	ld	s3,24(sp)
    80000d38:	6a42                	ld	s4,16(sp)
    80000d3a:	6aa2                	ld	s5,8(sp)
    80000d3c:	6b02                	ld	s6,0(sp)
    80000d3e:	6121                	addi	sp,sp,64
    80000d40:	8082                	ret
      panic("kalloc");
    80000d42:	00007517          	auipc	a0,0x7
    80000d46:	3de50513          	addi	a0,a0,990 # 80008120 <etext+0x120>
    80000d4a:	00005097          	auipc	ra,0x5
    80000d4e:	27e080e7          	jalr	638(ra) # 80005fc8 <panic>

0000000080000d52 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d52:	7139                	addi	sp,sp,-64
    80000d54:	fc06                	sd	ra,56(sp)
    80000d56:	f822                	sd	s0,48(sp)
    80000d58:	f426                	sd	s1,40(sp)
    80000d5a:	f04a                	sd	s2,32(sp)
    80000d5c:	ec4e                	sd	s3,24(sp)
    80000d5e:	e852                	sd	s4,16(sp)
    80000d60:	e456                	sd	s5,8(sp)
    80000d62:	e05a                	sd	s6,0(sp)
    80000d64:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d66:	00007597          	auipc	a1,0x7
    80000d6a:	3c258593          	addi	a1,a1,962 # 80008128 <etext+0x128>
    80000d6e:	00008517          	auipc	a0,0x8
    80000d72:	2e250513          	addi	a0,a0,738 # 80009050 <pid_lock>
    80000d76:	00005097          	auipc	ra,0x5
    80000d7a:	70c080e7          	jalr	1804(ra) # 80006482 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d7e:	00007597          	auipc	a1,0x7
    80000d82:	3b258593          	addi	a1,a1,946 # 80008130 <etext+0x130>
    80000d86:	00008517          	auipc	a0,0x8
    80000d8a:	2e250513          	addi	a0,a0,738 # 80009068 <wait_lock>
    80000d8e:	00005097          	auipc	ra,0x5
    80000d92:	6f4080e7          	jalr	1780(ra) # 80006482 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d96:	00008497          	auipc	s1,0x8
    80000d9a:	6ea48493          	addi	s1,s1,1770 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000d9e:	00007b17          	auipc	s6,0x7
    80000da2:	3a2b0b13          	addi	s6,s6,930 # 80008140 <etext+0x140>
      p->kstack = KSTACK((int) (p - proc));
    80000da6:	8aa6                	mv	s5,s1
    80000da8:	00007a17          	auipc	s4,0x7
    80000dac:	258a0a13          	addi	s4,s4,600 # 80008000 <etext>
    80000db0:	04000937          	lui	s2,0x4000
    80000db4:	197d                	addi	s2,s2,-1
    80000db6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db8:	00018997          	auipc	s3,0x18
    80000dbc:	0c898993          	addi	s3,s3,200 # 80018e80 <tickslock>
      initlock(&p->lock, "proc");
    80000dc0:	85da                	mv	a1,s6
    80000dc2:	8526                	mv	a0,s1
    80000dc4:	00005097          	auipc	ra,0x5
    80000dc8:	6be080e7          	jalr	1726(ra) # 80006482 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000dcc:	415487b3          	sub	a5,s1,s5
    80000dd0:	878d                	srai	a5,a5,0x3
    80000dd2:	000a3703          	ld	a4,0(s4)
    80000dd6:	02e787b3          	mul	a5,a5,a4
    80000dda:	2785                	addiw	a5,a5,1
    80000ddc:	00d7979b          	slliw	a5,a5,0xd
    80000de0:	40f907b3          	sub	a5,s2,a5
    80000de4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de6:	3e848493          	addi	s1,s1,1000
    80000dea:	fd349be3          	bne	s1,s3,80000dc0 <procinit+0x6e>
  }
}
    80000dee:	70e2                	ld	ra,56(sp)
    80000df0:	7442                	ld	s0,48(sp)
    80000df2:	74a2                	ld	s1,40(sp)
    80000df4:	7902                	ld	s2,32(sp)
    80000df6:	69e2                	ld	s3,24(sp)
    80000df8:	6a42                	ld	s4,16(sp)
    80000dfa:	6aa2                	ld	s5,8(sp)
    80000dfc:	6b02                	ld	s6,0(sp)
    80000dfe:	6121                	addi	sp,sp,64
    80000e00:	8082                	ret

0000000080000e02 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e02:	1141                	addi	sp,sp,-16
    80000e04:	e422                	sd	s0,8(sp)
    80000e06:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e08:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e0a:	2501                	sext.w	a0,a0
    80000e0c:	6422                	ld	s0,8(sp)
    80000e0e:	0141                	addi	sp,sp,16
    80000e10:	8082                	ret

0000000080000e12 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e12:	1141                	addi	sp,sp,-16
    80000e14:	e422                	sd	s0,8(sp)
    80000e16:	0800                	addi	s0,sp,16
    80000e18:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e1a:	2781                	sext.w	a5,a5
    80000e1c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e1e:	00008517          	auipc	a0,0x8
    80000e22:	26250513          	addi	a0,a0,610 # 80009080 <cpus>
    80000e26:	953e                	add	a0,a0,a5
    80000e28:	6422                	ld	s0,8(sp)
    80000e2a:	0141                	addi	sp,sp,16
    80000e2c:	8082                	ret

0000000080000e2e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e2e:	1101                	addi	sp,sp,-32
    80000e30:	ec06                	sd	ra,24(sp)
    80000e32:	e822                	sd	s0,16(sp)
    80000e34:	e426                	sd	s1,8(sp)
    80000e36:	1000                	addi	s0,sp,32
  push_off();
    80000e38:	00005097          	auipc	ra,0x5
    80000e3c:	68e080e7          	jalr	1678(ra) # 800064c6 <push_off>
    80000e40:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e42:	2781                	sext.w	a5,a5
    80000e44:	079e                	slli	a5,a5,0x7
    80000e46:	00008717          	auipc	a4,0x8
    80000e4a:	20a70713          	addi	a4,a4,522 # 80009050 <pid_lock>
    80000e4e:	97ba                	add	a5,a5,a4
    80000e50:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	714080e7          	jalr	1812(ra) # 80006566 <pop_off>
  return p;
}
    80000e5a:	8526                	mv	a0,s1
    80000e5c:	60e2                	ld	ra,24(sp)
    80000e5e:	6442                	ld	s0,16(sp)
    80000e60:	64a2                	ld	s1,8(sp)
    80000e62:	6105                	addi	sp,sp,32
    80000e64:	8082                	ret

0000000080000e66 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e406                	sd	ra,8(sp)
    80000e6a:	e022                	sd	s0,0(sp)
    80000e6c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e6e:	00000097          	auipc	ra,0x0
    80000e72:	fc0080e7          	jalr	-64(ra) # 80000e2e <myproc>
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	750080e7          	jalr	1872(ra) # 800065c6 <release>

  if (first) {
    80000e7e:	00008797          	auipc	a5,0x8
    80000e82:	9827a783          	lw	a5,-1662(a5) # 80008800 <first.1702>
    80000e86:	eb89                	bnez	a5,80000e98 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000e88:	00001097          	auipc	ra,0x1
    80000e8c:	e08080e7          	jalr	-504(ra) # 80001c90 <usertrapret>
}
    80000e90:	60a2                	ld	ra,8(sp)
    80000e92:	6402                	ld	s0,0(sp)
    80000e94:	0141                	addi	sp,sp,16
    80000e96:	8082                	ret
    first = 0;
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9607a423          	sw	zero,-1688(a5) # 80008800 <first.1702>
    fsinit(ROOTDEV);
    80000ea0:	4505                	li	a0,1
    80000ea2:	00002097          	auipc	ra,0x2
    80000ea6:	b4e080e7          	jalr	-1202(ra) # 800029f0 <fsinit>
    80000eaa:	bff9                	j	80000e88 <forkret+0x22>

0000000080000eac <allocpid>:
allocpid() {
    80000eac:	1101                	addi	sp,sp,-32
    80000eae:	ec06                	sd	ra,24(sp)
    80000eb0:	e822                	sd	s0,16(sp)
    80000eb2:	e426                	sd	s1,8(sp)
    80000eb4:	e04a                	sd	s2,0(sp)
    80000eb6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000eb8:	00008917          	auipc	s2,0x8
    80000ebc:	19890913          	addi	s2,s2,408 # 80009050 <pid_lock>
    80000ec0:	854a                	mv	a0,s2
    80000ec2:	00005097          	auipc	ra,0x5
    80000ec6:	650080e7          	jalr	1616(ra) # 80006512 <acquire>
  pid = nextpid;
    80000eca:	00008797          	auipc	a5,0x8
    80000ece:	93a78793          	addi	a5,a5,-1734 # 80008804 <nextpid>
    80000ed2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ed4:	0014871b          	addiw	a4,s1,1
    80000ed8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	6ea080e7          	jalr	1770(ra) # 800065c6 <release>
}
    80000ee4:	8526                	mv	a0,s1
    80000ee6:	60e2                	ld	ra,24(sp)
    80000ee8:	6442                	ld	s0,16(sp)
    80000eea:	64a2                	ld	s1,8(sp)
    80000eec:	6902                	ld	s2,0(sp)
    80000eee:	6105                	addi	sp,sp,32
    80000ef0:	8082                	ret

0000000080000ef2 <proc_pagetable>:
{
    80000ef2:	1101                	addi	sp,sp,-32
    80000ef4:	ec06                	sd	ra,24(sp)
    80000ef6:	e822                	sd	s0,16(sp)
    80000ef8:	e426                	sd	s1,8(sp)
    80000efa:	e04a                	sd	s2,0(sp)
    80000efc:	1000                	addi	s0,sp,32
    80000efe:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f00:	00000097          	auipc	ra,0x0
    80000f04:	8c4080e7          	jalr	-1852(ra) # 800007c4 <uvmcreate>
    80000f08:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f0a:	c121                	beqz	a0,80000f4a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f0c:	4729                	li	a4,10
    80000f0e:	00006697          	auipc	a3,0x6
    80000f12:	0f268693          	addi	a3,a3,242 # 80007000 <_trampoline>
    80000f16:	6605                	lui	a2,0x1
    80000f18:	040005b7          	lui	a1,0x4000
    80000f1c:	15fd                	addi	a1,a1,-1
    80000f1e:	05b2                	slli	a1,a1,0xc
    80000f20:	fffff097          	auipc	ra,0xfffff
    80000f24:	628080e7          	jalr	1576(ra) # 80000548 <mappages>
    80000f28:	02054863          	bltz	a0,80000f58 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f2c:	4719                	li	a4,6
    80000f2e:	05893683          	ld	a3,88(s2)
    80000f32:	6605                	lui	a2,0x1
    80000f34:	020005b7          	lui	a1,0x2000
    80000f38:	15fd                	addi	a1,a1,-1
    80000f3a:	05b6                	slli	a1,a1,0xd
    80000f3c:	8526                	mv	a0,s1
    80000f3e:	fffff097          	auipc	ra,0xfffff
    80000f42:	60a080e7          	jalr	1546(ra) # 80000548 <mappages>
    80000f46:	02054163          	bltz	a0,80000f68 <proc_pagetable+0x76>
}
    80000f4a:	8526                	mv	a0,s1
    80000f4c:	60e2                	ld	ra,24(sp)
    80000f4e:	6442                	ld	s0,16(sp)
    80000f50:	64a2                	ld	s1,8(sp)
    80000f52:	6902                	ld	s2,0(sp)
    80000f54:	6105                	addi	sp,sp,32
    80000f56:	8082                	ret
    uvmfree(pagetable, 0);
    80000f58:	4581                	li	a1,0
    80000f5a:	8526                	mv	a0,s1
    80000f5c:	00000097          	auipc	ra,0x0
    80000f60:	a64080e7          	jalr	-1436(ra) # 800009c0 <uvmfree>
    return 0;
    80000f64:	4481                	li	s1,0
    80000f66:	b7d5                	j	80000f4a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f68:	4681                	li	a3,0
    80000f6a:	4605                	li	a2,1
    80000f6c:	040005b7          	lui	a1,0x4000
    80000f70:	15fd                	addi	a1,a1,-1
    80000f72:	05b2                	slli	a1,a1,0xc
    80000f74:	8526                	mv	a0,s1
    80000f76:	fffff097          	auipc	ra,0xfffff
    80000f7a:	798080e7          	jalr	1944(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f7e:	4581                	li	a1,0
    80000f80:	8526                	mv	a0,s1
    80000f82:	00000097          	auipc	ra,0x0
    80000f86:	a3e080e7          	jalr	-1474(ra) # 800009c0 <uvmfree>
    return 0;
    80000f8a:	4481                	li	s1,0
    80000f8c:	bf7d                	j	80000f4a <proc_pagetable+0x58>

0000000080000f8e <proc_freepagetable>:
{
    80000f8e:	1101                	addi	sp,sp,-32
    80000f90:	ec06                	sd	ra,24(sp)
    80000f92:	e822                	sd	s0,16(sp)
    80000f94:	e426                	sd	s1,8(sp)
    80000f96:	e04a                	sd	s2,0(sp)
    80000f98:	1000                	addi	s0,sp,32
    80000f9a:	84aa                	mv	s1,a0
    80000f9c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f9e:	4681                	li	a3,0
    80000fa0:	4605                	li	a2,1
    80000fa2:	040005b7          	lui	a1,0x4000
    80000fa6:	15fd                	addi	a1,a1,-1
    80000fa8:	05b2                	slli	a1,a1,0xc
    80000faa:	fffff097          	auipc	ra,0xfffff
    80000fae:	764080e7          	jalr	1892(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fb2:	4681                	li	a3,0
    80000fb4:	4605                	li	a2,1
    80000fb6:	020005b7          	lui	a1,0x2000
    80000fba:	15fd                	addi	a1,a1,-1
    80000fbc:	05b6                	slli	a1,a1,0xd
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	fffff097          	auipc	ra,0xfffff
    80000fc4:	74e080e7          	jalr	1870(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fc8:	85ca                	mv	a1,s2
    80000fca:	8526                	mv	a0,s1
    80000fcc:	00000097          	auipc	ra,0x0
    80000fd0:	9f4080e7          	jalr	-1548(ra) # 800009c0 <uvmfree>
}
    80000fd4:	60e2                	ld	ra,24(sp)
    80000fd6:	6442                	ld	s0,16(sp)
    80000fd8:	64a2                	ld	s1,8(sp)
    80000fda:	6902                	ld	s2,0(sp)
    80000fdc:	6105                	addi	sp,sp,32
    80000fde:	8082                	ret

0000000080000fe0 <freeproc>:
{
    80000fe0:	1101                	addi	sp,sp,-32
    80000fe2:	ec06                	sd	ra,24(sp)
    80000fe4:	e822                	sd	s0,16(sp)
    80000fe6:	e426                	sd	s1,8(sp)
    80000fe8:	1000                	addi	s0,sp,32
    80000fea:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000fec:	6d28                	ld	a0,88(a0)
    80000fee:	c509                	beqz	a0,80000ff8 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80000ff0:	fffff097          	auipc	ra,0xfffff
    80000ff4:	02c080e7          	jalr	44(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80000ff8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ffc:	68a8                	ld	a0,80(s1)
    80000ffe:	c511                	beqz	a0,8000100a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001000:	64ac                	ld	a1,72(s1)
    80001002:	00000097          	auipc	ra,0x0
    80001006:	f8c080e7          	jalr	-116(ra) # 80000f8e <proc_freepagetable>
  p->pagetable = 0;
    8000100a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000100e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001012:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001016:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000101a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000101e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001022:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001026:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000102a:	0004ac23          	sw	zero,24(s1)
}
    8000102e:	60e2                	ld	ra,24(sp)
    80001030:	6442                	ld	s0,16(sp)
    80001032:	64a2                	ld	s1,8(sp)
    80001034:	6105                	addi	sp,sp,32
    80001036:	8082                	ret

0000000080001038 <allocproc>:
{
    80001038:	7179                	addi	sp,sp,-48
    8000103a:	f406                	sd	ra,40(sp)
    8000103c:	f022                	sd	s0,32(sp)
    8000103e:	ec26                	sd	s1,24(sp)
    80001040:	e84a                	sd	s2,16(sp)
    80001042:	e44e                	sd	s3,8(sp)
    80001044:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001046:	00008497          	auipc	s1,0x8
    8000104a:	43a48493          	addi	s1,s1,1082 # 80009480 <proc>
    8000104e:	00018997          	auipc	s3,0x18
    80001052:	e3298993          	addi	s3,s3,-462 # 80018e80 <tickslock>
    acquire(&p->lock);
    80001056:	8526                	mv	a0,s1
    80001058:	00005097          	auipc	ra,0x5
    8000105c:	4ba080e7          	jalr	1210(ra) # 80006512 <acquire>
    if(p->state == UNUSED) {
    80001060:	4c9c                	lw	a5,24(s1)
    80001062:	cf81                	beqz	a5,8000107a <allocproc+0x42>
      release(&p->lock);
    80001064:	8526                	mv	a0,s1
    80001066:	00005097          	auipc	ra,0x5
    8000106a:	560080e7          	jalr	1376(ra) # 800065c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000106e:	3e848493          	addi	s1,s1,1000
    80001072:	ff3492e3          	bne	s1,s3,80001056 <allocproc+0x1e>
  return 0;
    80001076:	4481                	li	s1,0
    80001078:	a09d                	j	800010de <allocproc+0xa6>
  p->pid = allocpid();
    8000107a:	00000097          	auipc	ra,0x0
    8000107e:	e32080e7          	jalr	-462(ra) # 80000eac <allocpid>
    80001082:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001084:	4785                	li	a5,1
    80001086:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001088:	fffff097          	auipc	ra,0xfffff
    8000108c:	090080e7          	jalr	144(ra) # 80000118 <kalloc>
    80001090:	89aa                	mv	s3,a0
    80001092:	eca8                	sd	a0,88(s1)
    80001094:	cd29                	beqz	a0,800010ee <allocproc+0xb6>
  p->pagetable = proc_pagetable(p);
    80001096:	8526                	mv	a0,s1
    80001098:	00000097          	auipc	ra,0x0
    8000109c:	e5a080e7          	jalr	-422(ra) # 80000ef2 <proc_pagetable>
    800010a0:	89aa                	mv	s3,a0
    800010a2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010a4:	c12d                	beqz	a0,80001106 <allocproc+0xce>
  memset(&p->context, 0, sizeof(p->context));
    800010a6:	07000613          	li	a2,112
    800010aa:	4581                	li	a1,0
    800010ac:	06048513          	addi	a0,s1,96
    800010b0:	fffff097          	auipc	ra,0xfffff
    800010b4:	0c8080e7          	jalr	200(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010b8:	00000797          	auipc	a5,0x0
    800010bc:	dae78793          	addi	a5,a5,-594 # 80000e66 <forkret>
    800010c0:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010c2:	60bc                	ld	a5,64(s1)
    800010c4:	6705                	lui	a4,0x1
    800010c6:	97ba                	add	a5,a5,a4
    800010c8:	f4bc                	sd	a5,104(s1)
  for(int i = 0; i < MAX_VMA_POOL; i++){
    800010ca:	16848793          	addi	a5,s1,360
    800010ce:	3e848913          	addi	s2,s1,1000
    p->vma_pool[i].used = 0;
    800010d2:	0007a023          	sw	zero,0(a5)
  for(int i = 0; i < MAX_VMA_POOL; i++){
    800010d6:	02878793          	addi	a5,a5,40
    800010da:	ff279ce3          	bne	a5,s2,800010d2 <allocproc+0x9a>
}
    800010de:	8526                	mv	a0,s1
    800010e0:	70a2                	ld	ra,40(sp)
    800010e2:	7402                	ld	s0,32(sp)
    800010e4:	64e2                	ld	s1,24(sp)
    800010e6:	6942                	ld	s2,16(sp)
    800010e8:	69a2                	ld	s3,8(sp)
    800010ea:	6145                	addi	sp,sp,48
    800010ec:	8082                	ret
    freeproc(p);
    800010ee:	8526                	mv	a0,s1
    800010f0:	00000097          	auipc	ra,0x0
    800010f4:	ef0080e7          	jalr	-272(ra) # 80000fe0 <freeproc>
    release(&p->lock);
    800010f8:	8526                	mv	a0,s1
    800010fa:	00005097          	auipc	ra,0x5
    800010fe:	4cc080e7          	jalr	1228(ra) # 800065c6 <release>
    return 0;
    80001102:	84ce                	mv	s1,s3
    80001104:	bfe9                	j	800010de <allocproc+0xa6>
    freeproc(p);
    80001106:	8526                	mv	a0,s1
    80001108:	00000097          	auipc	ra,0x0
    8000110c:	ed8080e7          	jalr	-296(ra) # 80000fe0 <freeproc>
    release(&p->lock);
    80001110:	8526                	mv	a0,s1
    80001112:	00005097          	auipc	ra,0x5
    80001116:	4b4080e7          	jalr	1204(ra) # 800065c6 <release>
    return 0;
    8000111a:	84ce                	mv	s1,s3
    8000111c:	b7c9                	j	800010de <allocproc+0xa6>

000000008000111e <userinit>:
{
    8000111e:	1101                	addi	sp,sp,-32
    80001120:	ec06                	sd	ra,24(sp)
    80001122:	e822                	sd	s0,16(sp)
    80001124:	e426                	sd	s1,8(sp)
    80001126:	1000                	addi	s0,sp,32
  p = allocproc();
    80001128:	00000097          	auipc	ra,0x0
    8000112c:	f10080e7          	jalr	-240(ra) # 80001038 <allocproc>
    80001130:	84aa                	mv	s1,a0
  initproc = p;
    80001132:	00008797          	auipc	a5,0x8
    80001136:	eca7bf23          	sd	a0,-290(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000113a:	03400613          	li	a2,52
    8000113e:	00007597          	auipc	a1,0x7
    80001142:	6d258593          	addi	a1,a1,1746 # 80008810 <initcode>
    80001146:	6928                	ld	a0,80(a0)
    80001148:	fffff097          	auipc	ra,0xfffff
    8000114c:	6aa080e7          	jalr	1706(ra) # 800007f2 <uvminit>
  p->sz = PGSIZE;
    80001150:	6785                	lui	a5,0x1
    80001152:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001154:	6cb8                	ld	a4,88(s1)
    80001156:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000115a:	6cb8                	ld	a4,88(s1)
    8000115c:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000115e:	4641                	li	a2,16
    80001160:	00007597          	auipc	a1,0x7
    80001164:	fe858593          	addi	a1,a1,-24 # 80008148 <etext+0x148>
    80001168:	15848513          	addi	a0,s1,344
    8000116c:	fffff097          	auipc	ra,0xfffff
    80001170:	15e080e7          	jalr	350(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001174:	00007517          	auipc	a0,0x7
    80001178:	fe450513          	addi	a0,a0,-28 # 80008158 <etext+0x158>
    8000117c:	00002097          	auipc	ra,0x2
    80001180:	2a2080e7          	jalr	674(ra) # 8000341e <namei>
    80001184:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001188:	478d                	li	a5,3
    8000118a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000118c:	8526                	mv	a0,s1
    8000118e:	00005097          	auipc	ra,0x5
    80001192:	438080e7          	jalr	1080(ra) # 800065c6 <release>
}
    80001196:	60e2                	ld	ra,24(sp)
    80001198:	6442                	ld	s0,16(sp)
    8000119a:	64a2                	ld	s1,8(sp)
    8000119c:	6105                	addi	sp,sp,32
    8000119e:	8082                	ret

00000000800011a0 <growproc>:
{
    800011a0:	1101                	addi	sp,sp,-32
    800011a2:	ec06                	sd	ra,24(sp)
    800011a4:	e822                	sd	s0,16(sp)
    800011a6:	e426                	sd	s1,8(sp)
    800011a8:	e04a                	sd	s2,0(sp)
    800011aa:	1000                	addi	s0,sp,32
    800011ac:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011ae:	00000097          	auipc	ra,0x0
    800011b2:	c80080e7          	jalr	-896(ra) # 80000e2e <myproc>
    800011b6:	892a                	mv	s2,a0
  sz = p->sz;
    800011b8:	652c                	ld	a1,72(a0)
    800011ba:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011be:	00904f63          	bgtz	s1,800011dc <growproc+0x3c>
  } else if(n < 0){
    800011c2:	0204cc63          	bltz	s1,800011fa <growproc+0x5a>
  p->sz = sz;
    800011c6:	1602                	slli	a2,a2,0x20
    800011c8:	9201                	srli	a2,a2,0x20
    800011ca:	04c93423          	sd	a2,72(s2)
  return 0;
    800011ce:	4501                	li	a0,0
}
    800011d0:	60e2                	ld	ra,24(sp)
    800011d2:	6442                	ld	s0,16(sp)
    800011d4:	64a2                	ld	s1,8(sp)
    800011d6:	6902                	ld	s2,0(sp)
    800011d8:	6105                	addi	sp,sp,32
    800011da:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011dc:	9e25                	addw	a2,a2,s1
    800011de:	1602                	slli	a2,a2,0x20
    800011e0:	9201                	srli	a2,a2,0x20
    800011e2:	1582                	slli	a1,a1,0x20
    800011e4:	9181                	srli	a1,a1,0x20
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	6c4080e7          	jalr	1732(ra) # 800008ac <uvmalloc>
    800011f0:	0005061b          	sext.w	a2,a0
    800011f4:	fa69                	bnez	a2,800011c6 <growproc+0x26>
      return -1;
    800011f6:	557d                	li	a0,-1
    800011f8:	bfe1                	j	800011d0 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011fa:	9e25                	addw	a2,a2,s1
    800011fc:	1602                	slli	a2,a2,0x20
    800011fe:	9201                	srli	a2,a2,0x20
    80001200:	1582                	slli	a1,a1,0x20
    80001202:	9181                	srli	a1,a1,0x20
    80001204:	6928                	ld	a0,80(a0)
    80001206:	fffff097          	auipc	ra,0xfffff
    8000120a:	65e080e7          	jalr	1630(ra) # 80000864 <uvmdealloc>
    8000120e:	0005061b          	sext.w	a2,a0
    80001212:	bf55                	j	800011c6 <growproc+0x26>

0000000080001214 <fork>:
{
    80001214:	7139                	addi	sp,sp,-64
    80001216:	fc06                	sd	ra,56(sp)
    80001218:	f822                	sd	s0,48(sp)
    8000121a:	f426                	sd	s1,40(sp)
    8000121c:	f04a                	sd	s2,32(sp)
    8000121e:	ec4e                	sd	s3,24(sp)
    80001220:	e852                	sd	s4,16(sp)
    80001222:	e456                	sd	s5,8(sp)
    80001224:	e05a                	sd	s6,0(sp)
    80001226:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	c06080e7          	jalr	-1018(ra) # 80000e2e <myproc>
    80001230:	89aa                	mv	s3,a0
  if((np = allocproc()) == 0){
    80001232:	00000097          	auipc	ra,0x0
    80001236:	e06080e7          	jalr	-506(ra) # 80001038 <allocproc>
    8000123a:	14050e63          	beqz	a0,80001396 <fork+0x182>
    8000123e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001240:	0489b603          	ld	a2,72(s3)
    80001244:	692c                	ld	a1,80(a0)
    80001246:	0509b503          	ld	a0,80(s3)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	7ae080e7          	jalr	1966(ra) # 800009f8 <uvmcopy>
    80001252:	04054663          	bltz	a0,8000129e <fork+0x8a>
  np->sz = p->sz;
    80001256:	0489b783          	ld	a5,72(s3)
    8000125a:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000125e:	0589b683          	ld	a3,88(s3)
    80001262:	87b6                	mv	a5,a3
    80001264:	058a3703          	ld	a4,88(s4)
    80001268:	12068693          	addi	a3,a3,288
    8000126c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001270:	6788                	ld	a0,8(a5)
    80001272:	6b8c                	ld	a1,16(a5)
    80001274:	6f90                	ld	a2,24(a5)
    80001276:	01073023          	sd	a6,0(a4)
    8000127a:	e708                	sd	a0,8(a4)
    8000127c:	eb0c                	sd	a1,16(a4)
    8000127e:	ef10                	sd	a2,24(a4)
    80001280:	02078793          	addi	a5,a5,32
    80001284:	02070713          	addi	a4,a4,32
    80001288:	fed792e3          	bne	a5,a3,8000126c <fork+0x58>
  np->trapframe->a0 = 0;
    8000128c:	058a3783          	ld	a5,88(s4)
    80001290:	0607b823          	sd	zero,112(a5)
    80001294:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001298:	15000913          	li	s2,336
    8000129c:	a03d                	j	800012ca <fork+0xb6>
    freeproc(np);
    8000129e:	8552                	mv	a0,s4
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	d40080e7          	jalr	-704(ra) # 80000fe0 <freeproc>
    release(&np->lock);
    800012a8:	8552                	mv	a0,s4
    800012aa:	00005097          	auipc	ra,0x5
    800012ae:	31c080e7          	jalr	796(ra) # 800065c6 <release>
    return -1;
    800012b2:	597d                	li	s2,-1
    800012b4:	a0f1                	j	80001380 <fork+0x16c>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b6:	00002097          	auipc	ra,0x2
    800012ba:	7fe080e7          	jalr	2046(ra) # 80003ab4 <filedup>
    800012be:	009a07b3          	add	a5,s4,s1
    800012c2:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012c4:	04a1                	addi	s1,s1,8
    800012c6:	01248763          	beq	s1,s2,800012d4 <fork+0xc0>
    if(p->ofile[i])
    800012ca:	009987b3          	add	a5,s3,s1
    800012ce:	6388                	ld	a0,0(a5)
    800012d0:	f17d                	bnez	a0,800012b6 <fork+0xa2>
    800012d2:	bfcd                	j	800012c4 <fork+0xb0>
  np->cwd = idup(p->cwd);
    800012d4:	1509b503          	ld	a0,336(s3)
    800012d8:	00002097          	auipc	ra,0x2
    800012dc:	952080e7          	jalr	-1710(ra) # 80002c2a <idup>
    800012e0:	14aa3823          	sd	a0,336(s4)
  for (int i = 0; i < MAX_VMA_POOL; i++) {
    800012e4:	16898913          	addi	s2,s3,360
    800012e8:	188a0493          	addi	s1,s4,392
    800012ec:	408a0b13          	addi	s6,s4,1032
    if (vma->used == 1) {
    800012f0:	4a85                	li	s5,1
    800012f2:	a02d                	j	8000131c <fork+0x108>
        memmove(np->vma_pool + i, p->vma_pool + i, sizeof(struct VMA));
    800012f4:	02800613          	li	a2,40
    800012f8:	85ca                	mv	a1,s2
    800012fa:	fe048513          	addi	a0,s1,-32
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	eda080e7          	jalr	-294(ra) # 800001d8 <memmove>
        filedup(np->vma_pool[i].f);
    80001306:	6088                	ld	a0,0(s1)
    80001308:	00002097          	auipc	ra,0x2
    8000130c:	7ac080e7          	jalr	1964(ra) # 80003ab4 <filedup>
  for (int i = 0; i < MAX_VMA_POOL; i++) {
    80001310:	02890913          	addi	s2,s2,40
    80001314:	02848493          	addi	s1,s1,40
    80001318:	01648763          	beq	s1,s6,80001326 <fork+0x112>
    if (vma->used == 1) {
    8000131c:	00092783          	lw	a5,0(s2)
    80001320:	ff5798e3          	bne	a5,s5,80001310 <fork+0xfc>
    80001324:	bfc1                	j	800012f4 <fork+0xe0>
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001326:	4641                	li	a2,16
    80001328:	15898593          	addi	a1,s3,344
    8000132c:	158a0513          	addi	a0,s4,344
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	f9a080e7          	jalr	-102(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001338:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000133c:	8552                	mv	a0,s4
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	288080e7          	jalr	648(ra) # 800065c6 <release>
  acquire(&wait_lock);
    80001346:	00008497          	auipc	s1,0x8
    8000134a:	d2248493          	addi	s1,s1,-734 # 80009068 <wait_lock>
    8000134e:	8526                	mv	a0,s1
    80001350:	00005097          	auipc	ra,0x5
    80001354:	1c2080e7          	jalr	450(ra) # 80006512 <acquire>
  np->parent = p;
    80001358:	033a3c23          	sd	s3,56(s4)
  release(&wait_lock);
    8000135c:	8526                	mv	a0,s1
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	268080e7          	jalr	616(ra) # 800065c6 <release>
  acquire(&np->lock);
    80001366:	8552                	mv	a0,s4
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	1aa080e7          	jalr	426(ra) # 80006512 <acquire>
  np->state = RUNNABLE;
    80001370:	478d                	li	a5,3
    80001372:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001376:	8552                	mv	a0,s4
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	24e080e7          	jalr	590(ra) # 800065c6 <release>
}
    80001380:	854a                	mv	a0,s2
    80001382:	70e2                	ld	ra,56(sp)
    80001384:	7442                	ld	s0,48(sp)
    80001386:	74a2                	ld	s1,40(sp)
    80001388:	7902                	ld	s2,32(sp)
    8000138a:	69e2                	ld	s3,24(sp)
    8000138c:	6a42                	ld	s4,16(sp)
    8000138e:	6aa2                	ld	s5,8(sp)
    80001390:	6b02                	ld	s6,0(sp)
    80001392:	6121                	addi	sp,sp,64
    80001394:	8082                	ret
    return -1;
    80001396:	597d                	li	s2,-1
    80001398:	b7e5                	j	80001380 <fork+0x16c>

000000008000139a <scheduler>:
{
    8000139a:	7139                	addi	sp,sp,-64
    8000139c:	fc06                	sd	ra,56(sp)
    8000139e:	f822                	sd	s0,48(sp)
    800013a0:	f426                	sd	s1,40(sp)
    800013a2:	f04a                	sd	s2,32(sp)
    800013a4:	ec4e                	sd	s3,24(sp)
    800013a6:	e852                	sd	s4,16(sp)
    800013a8:	e456                	sd	s5,8(sp)
    800013aa:	e05a                	sd	s6,0(sp)
    800013ac:	0080                	addi	s0,sp,64
    800013ae:	8792                	mv	a5,tp
  int id = r_tp();
    800013b0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013b2:	00779a93          	slli	s5,a5,0x7
    800013b6:	00008717          	auipc	a4,0x8
    800013ba:	c9a70713          	addi	a4,a4,-870 # 80009050 <pid_lock>
    800013be:	9756                	add	a4,a4,s5
    800013c0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013c4:	00008717          	auipc	a4,0x8
    800013c8:	cc470713          	addi	a4,a4,-828 # 80009088 <cpus+0x8>
    800013cc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013ce:	498d                	li	s3,3
        p->state = RUNNING;
    800013d0:	4b11                	li	s6,4
        c->proc = p;
    800013d2:	079e                	slli	a5,a5,0x7
    800013d4:	00008a17          	auipc	s4,0x8
    800013d8:	c7ca0a13          	addi	s4,s4,-900 # 80009050 <pid_lock>
    800013dc:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013de:	00018917          	auipc	s2,0x18
    800013e2:	aa290913          	addi	s2,s2,-1374 # 80018e80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013e6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013ea:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013ee:	10079073          	csrw	sstatus,a5
    800013f2:	00008497          	auipc	s1,0x8
    800013f6:	08e48493          	addi	s1,s1,142 # 80009480 <proc>
    800013fa:	a03d                	j	80001428 <scheduler+0x8e>
        p->state = RUNNING;
    800013fc:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001400:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001404:	06048593          	addi	a1,s1,96
    80001408:	8556                	mv	a0,s5
    8000140a:	00000097          	auipc	ra,0x0
    8000140e:	6e0080e7          	jalr	1760(ra) # 80001aea <swtch>
        c->proc = 0;
    80001412:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001416:	8526                	mv	a0,s1
    80001418:	00005097          	auipc	ra,0x5
    8000141c:	1ae080e7          	jalr	430(ra) # 800065c6 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001420:	3e848493          	addi	s1,s1,1000
    80001424:	fd2481e3          	beq	s1,s2,800013e6 <scheduler+0x4c>
      acquire(&p->lock);
    80001428:	8526                	mv	a0,s1
    8000142a:	00005097          	auipc	ra,0x5
    8000142e:	0e8080e7          	jalr	232(ra) # 80006512 <acquire>
      if(p->state == RUNNABLE) {
    80001432:	4c9c                	lw	a5,24(s1)
    80001434:	ff3791e3          	bne	a5,s3,80001416 <scheduler+0x7c>
    80001438:	b7d1                	j	800013fc <scheduler+0x62>

000000008000143a <sched>:
{
    8000143a:	7179                	addi	sp,sp,-48
    8000143c:	f406                	sd	ra,40(sp)
    8000143e:	f022                	sd	s0,32(sp)
    80001440:	ec26                	sd	s1,24(sp)
    80001442:	e84a                	sd	s2,16(sp)
    80001444:	e44e                	sd	s3,8(sp)
    80001446:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	9e6080e7          	jalr	-1562(ra) # 80000e2e <myproc>
    80001450:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001452:	00005097          	auipc	ra,0x5
    80001456:	046080e7          	jalr	70(ra) # 80006498 <holding>
    8000145a:	c93d                	beqz	a0,800014d0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000145c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000145e:	2781                	sext.w	a5,a5
    80001460:	079e                	slli	a5,a5,0x7
    80001462:	00008717          	auipc	a4,0x8
    80001466:	bee70713          	addi	a4,a4,-1042 # 80009050 <pid_lock>
    8000146a:	97ba                	add	a5,a5,a4
    8000146c:	0a87a703          	lw	a4,168(a5)
    80001470:	4785                	li	a5,1
    80001472:	06f71763          	bne	a4,a5,800014e0 <sched+0xa6>
  if(p->state == RUNNING)
    80001476:	4c98                	lw	a4,24(s1)
    80001478:	4791                	li	a5,4
    8000147a:	06f70b63          	beq	a4,a5,800014f0 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000147e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001482:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001484:	efb5                	bnez	a5,80001500 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001486:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001488:	00008917          	auipc	s2,0x8
    8000148c:	bc890913          	addi	s2,s2,-1080 # 80009050 <pid_lock>
    80001490:	2781                	sext.w	a5,a5
    80001492:	079e                	slli	a5,a5,0x7
    80001494:	97ca                	add	a5,a5,s2
    80001496:	0ac7a983          	lw	s3,172(a5)
    8000149a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000149c:	2781                	sext.w	a5,a5
    8000149e:	079e                	slli	a5,a5,0x7
    800014a0:	00008597          	auipc	a1,0x8
    800014a4:	be858593          	addi	a1,a1,-1048 # 80009088 <cpus+0x8>
    800014a8:	95be                	add	a1,a1,a5
    800014aa:	06048513          	addi	a0,s1,96
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	63c080e7          	jalr	1596(ra) # 80001aea <swtch>
    800014b6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014b8:	2781                	sext.w	a5,a5
    800014ba:	079e                	slli	a5,a5,0x7
    800014bc:	97ca                	add	a5,a5,s2
    800014be:	0b37a623          	sw	s3,172(a5)
}
    800014c2:	70a2                	ld	ra,40(sp)
    800014c4:	7402                	ld	s0,32(sp)
    800014c6:	64e2                	ld	s1,24(sp)
    800014c8:	6942                	ld	s2,16(sp)
    800014ca:	69a2                	ld	s3,8(sp)
    800014cc:	6145                	addi	sp,sp,48
    800014ce:	8082                	ret
    panic("sched p->lock");
    800014d0:	00007517          	auipc	a0,0x7
    800014d4:	c9050513          	addi	a0,a0,-880 # 80008160 <etext+0x160>
    800014d8:	00005097          	auipc	ra,0x5
    800014dc:	af0080e7          	jalr	-1296(ra) # 80005fc8 <panic>
    panic("sched locks");
    800014e0:	00007517          	auipc	a0,0x7
    800014e4:	c9050513          	addi	a0,a0,-880 # 80008170 <etext+0x170>
    800014e8:	00005097          	auipc	ra,0x5
    800014ec:	ae0080e7          	jalr	-1312(ra) # 80005fc8 <panic>
    panic("sched running");
    800014f0:	00007517          	auipc	a0,0x7
    800014f4:	c9050513          	addi	a0,a0,-880 # 80008180 <etext+0x180>
    800014f8:	00005097          	auipc	ra,0x5
    800014fc:	ad0080e7          	jalr	-1328(ra) # 80005fc8 <panic>
    panic("sched interruptible");
    80001500:	00007517          	auipc	a0,0x7
    80001504:	c9050513          	addi	a0,a0,-880 # 80008190 <etext+0x190>
    80001508:	00005097          	auipc	ra,0x5
    8000150c:	ac0080e7          	jalr	-1344(ra) # 80005fc8 <panic>

0000000080001510 <yield>:
{
    80001510:	1101                	addi	sp,sp,-32
    80001512:	ec06                	sd	ra,24(sp)
    80001514:	e822                	sd	s0,16(sp)
    80001516:	e426                	sd	s1,8(sp)
    80001518:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	914080e7          	jalr	-1772(ra) # 80000e2e <myproc>
    80001522:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001524:	00005097          	auipc	ra,0x5
    80001528:	fee080e7          	jalr	-18(ra) # 80006512 <acquire>
  p->state = RUNNABLE;
    8000152c:	478d                	li	a5,3
    8000152e:	cc9c                	sw	a5,24(s1)
  sched();
    80001530:	00000097          	auipc	ra,0x0
    80001534:	f0a080e7          	jalr	-246(ra) # 8000143a <sched>
  release(&p->lock);
    80001538:	8526                	mv	a0,s1
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	08c080e7          	jalr	140(ra) # 800065c6 <release>
}
    80001542:	60e2                	ld	ra,24(sp)
    80001544:	6442                	ld	s0,16(sp)
    80001546:	64a2                	ld	s1,8(sp)
    80001548:	6105                	addi	sp,sp,32
    8000154a:	8082                	ret

000000008000154c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000154c:	7179                	addi	sp,sp,-48
    8000154e:	f406                	sd	ra,40(sp)
    80001550:	f022                	sd	s0,32(sp)
    80001552:	ec26                	sd	s1,24(sp)
    80001554:	e84a                	sd	s2,16(sp)
    80001556:	e44e                	sd	s3,8(sp)
    80001558:	1800                	addi	s0,sp,48
    8000155a:	89aa                	mv	s3,a0
    8000155c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	8d0080e7          	jalr	-1840(ra) # 80000e2e <myproc>
    80001566:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001568:	00005097          	auipc	ra,0x5
    8000156c:	faa080e7          	jalr	-86(ra) # 80006512 <acquire>
  release(lk);
    80001570:	854a                	mv	a0,s2
    80001572:	00005097          	auipc	ra,0x5
    80001576:	054080e7          	jalr	84(ra) # 800065c6 <release>

  // Go to sleep.
  p->chan = chan;
    8000157a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000157e:	4789                	li	a5,2
    80001580:	cc9c                	sw	a5,24(s1)

  sched();
    80001582:	00000097          	auipc	ra,0x0
    80001586:	eb8080e7          	jalr	-328(ra) # 8000143a <sched>

  // Tidy up.
  p->chan = 0;
    8000158a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	00005097          	auipc	ra,0x5
    80001594:	036080e7          	jalr	54(ra) # 800065c6 <release>
  acquire(lk);
    80001598:	854a                	mv	a0,s2
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	f78080e7          	jalr	-136(ra) # 80006512 <acquire>
}
    800015a2:	70a2                	ld	ra,40(sp)
    800015a4:	7402                	ld	s0,32(sp)
    800015a6:	64e2                	ld	s1,24(sp)
    800015a8:	6942                	ld	s2,16(sp)
    800015aa:	69a2                	ld	s3,8(sp)
    800015ac:	6145                	addi	sp,sp,48
    800015ae:	8082                	ret

00000000800015b0 <wait>:
{
    800015b0:	715d                	addi	sp,sp,-80
    800015b2:	e486                	sd	ra,72(sp)
    800015b4:	e0a2                	sd	s0,64(sp)
    800015b6:	fc26                	sd	s1,56(sp)
    800015b8:	f84a                	sd	s2,48(sp)
    800015ba:	f44e                	sd	s3,40(sp)
    800015bc:	f052                	sd	s4,32(sp)
    800015be:	ec56                	sd	s5,24(sp)
    800015c0:	e85a                	sd	s6,16(sp)
    800015c2:	e45e                	sd	s7,8(sp)
    800015c4:	e062                	sd	s8,0(sp)
    800015c6:	0880                	addi	s0,sp,80
    800015c8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	864080e7          	jalr	-1948(ra) # 80000e2e <myproc>
    800015d2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015d4:	00008517          	auipc	a0,0x8
    800015d8:	a9450513          	addi	a0,a0,-1388 # 80009068 <wait_lock>
    800015dc:	00005097          	auipc	ra,0x5
    800015e0:	f36080e7          	jalr	-202(ra) # 80006512 <acquire>
    havekids = 0;
    800015e4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015e6:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015e8:	00018997          	auipc	s3,0x18
    800015ec:	89898993          	addi	s3,s3,-1896 # 80018e80 <tickslock>
        havekids = 1;
    800015f0:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015f2:	00008c17          	auipc	s8,0x8
    800015f6:	a76c0c13          	addi	s8,s8,-1418 # 80009068 <wait_lock>
    havekids = 0;
    800015fa:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015fc:	00008497          	auipc	s1,0x8
    80001600:	e8448493          	addi	s1,s1,-380 # 80009480 <proc>
    80001604:	a0bd                	j	80001672 <wait+0xc2>
          pid = np->pid;
    80001606:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000160a:	000b0e63          	beqz	s6,80001626 <wait+0x76>
    8000160e:	4691                	li	a3,4
    80001610:	02c48613          	addi	a2,s1,44
    80001614:	85da                	mv	a1,s6
    80001616:	05093503          	ld	a0,80(s2)
    8000161a:	fffff097          	auipc	ra,0xfffff
    8000161e:	4d6080e7          	jalr	1238(ra) # 80000af0 <copyout>
    80001622:	02054563          	bltz	a0,8000164c <wait+0x9c>
          freeproc(np);
    80001626:	8526                	mv	a0,s1
    80001628:	00000097          	auipc	ra,0x0
    8000162c:	9b8080e7          	jalr	-1608(ra) # 80000fe0 <freeproc>
          release(&np->lock);
    80001630:	8526                	mv	a0,s1
    80001632:	00005097          	auipc	ra,0x5
    80001636:	f94080e7          	jalr	-108(ra) # 800065c6 <release>
          release(&wait_lock);
    8000163a:	00008517          	auipc	a0,0x8
    8000163e:	a2e50513          	addi	a0,a0,-1490 # 80009068 <wait_lock>
    80001642:	00005097          	auipc	ra,0x5
    80001646:	f84080e7          	jalr	-124(ra) # 800065c6 <release>
          return pid;
    8000164a:	a09d                	j	800016b0 <wait+0x100>
            release(&np->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	00005097          	auipc	ra,0x5
    80001652:	f78080e7          	jalr	-136(ra) # 800065c6 <release>
            release(&wait_lock);
    80001656:	00008517          	auipc	a0,0x8
    8000165a:	a1250513          	addi	a0,a0,-1518 # 80009068 <wait_lock>
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	f68080e7          	jalr	-152(ra) # 800065c6 <release>
            return -1;
    80001666:	59fd                	li	s3,-1
    80001668:	a0a1                	j	800016b0 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000166a:	3e848493          	addi	s1,s1,1000
    8000166e:	03348463          	beq	s1,s3,80001696 <wait+0xe6>
      if(np->parent == p){
    80001672:	7c9c                	ld	a5,56(s1)
    80001674:	ff279be3          	bne	a5,s2,8000166a <wait+0xba>
        acquire(&np->lock);
    80001678:	8526                	mv	a0,s1
    8000167a:	00005097          	auipc	ra,0x5
    8000167e:	e98080e7          	jalr	-360(ra) # 80006512 <acquire>
        if(np->state == ZOMBIE){
    80001682:	4c9c                	lw	a5,24(s1)
    80001684:	f94781e3          	beq	a5,s4,80001606 <wait+0x56>
        release(&np->lock);
    80001688:	8526                	mv	a0,s1
    8000168a:	00005097          	auipc	ra,0x5
    8000168e:	f3c080e7          	jalr	-196(ra) # 800065c6 <release>
        havekids = 1;
    80001692:	8756                	mv	a4,s5
    80001694:	bfd9                	j	8000166a <wait+0xba>
    if(!havekids || p->killed){
    80001696:	c701                	beqz	a4,8000169e <wait+0xee>
    80001698:	02892783          	lw	a5,40(s2)
    8000169c:	c79d                	beqz	a5,800016ca <wait+0x11a>
      release(&wait_lock);
    8000169e:	00008517          	auipc	a0,0x8
    800016a2:	9ca50513          	addi	a0,a0,-1590 # 80009068 <wait_lock>
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	f20080e7          	jalr	-224(ra) # 800065c6 <release>
      return -1;
    800016ae:	59fd                	li	s3,-1
}
    800016b0:	854e                	mv	a0,s3
    800016b2:	60a6                	ld	ra,72(sp)
    800016b4:	6406                	ld	s0,64(sp)
    800016b6:	74e2                	ld	s1,56(sp)
    800016b8:	7942                	ld	s2,48(sp)
    800016ba:	79a2                	ld	s3,40(sp)
    800016bc:	7a02                	ld	s4,32(sp)
    800016be:	6ae2                	ld	s5,24(sp)
    800016c0:	6b42                	ld	s6,16(sp)
    800016c2:	6ba2                	ld	s7,8(sp)
    800016c4:	6c02                	ld	s8,0(sp)
    800016c6:	6161                	addi	sp,sp,80
    800016c8:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ca:	85e2                	mv	a1,s8
    800016cc:	854a                	mv	a0,s2
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	e7e080e7          	jalr	-386(ra) # 8000154c <sleep>
    havekids = 0;
    800016d6:	b715                	j	800015fa <wait+0x4a>

00000000800016d8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016d8:	7139                	addi	sp,sp,-64
    800016da:	fc06                	sd	ra,56(sp)
    800016dc:	f822                	sd	s0,48(sp)
    800016de:	f426                	sd	s1,40(sp)
    800016e0:	f04a                	sd	s2,32(sp)
    800016e2:	ec4e                	sd	s3,24(sp)
    800016e4:	e852                	sd	s4,16(sp)
    800016e6:	e456                	sd	s5,8(sp)
    800016e8:	0080                	addi	s0,sp,64
    800016ea:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016ec:	00008497          	auipc	s1,0x8
    800016f0:	d9448493          	addi	s1,s1,-620 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016f4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016f6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016f8:	00017917          	auipc	s2,0x17
    800016fc:	78890913          	addi	s2,s2,1928 # 80018e80 <tickslock>
    80001700:	a821                	j	80001718 <wakeup+0x40>
        p->state = RUNNABLE;
    80001702:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001706:	8526                	mv	a0,s1
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	ebe080e7          	jalr	-322(ra) # 800065c6 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001710:	3e848493          	addi	s1,s1,1000
    80001714:	03248463          	beq	s1,s2,8000173c <wakeup+0x64>
    if(p != myproc()){
    80001718:	fffff097          	auipc	ra,0xfffff
    8000171c:	716080e7          	jalr	1814(ra) # 80000e2e <myproc>
    80001720:	fea488e3          	beq	s1,a0,80001710 <wakeup+0x38>
      acquire(&p->lock);
    80001724:	8526                	mv	a0,s1
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	dec080e7          	jalr	-532(ra) # 80006512 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000172e:	4c9c                	lw	a5,24(s1)
    80001730:	fd379be3          	bne	a5,s3,80001706 <wakeup+0x2e>
    80001734:	709c                	ld	a5,32(s1)
    80001736:	fd4798e3          	bne	a5,s4,80001706 <wakeup+0x2e>
    8000173a:	b7e1                	j	80001702 <wakeup+0x2a>
    }
  }
}
    8000173c:	70e2                	ld	ra,56(sp)
    8000173e:	7442                	ld	s0,48(sp)
    80001740:	74a2                	ld	s1,40(sp)
    80001742:	7902                	ld	s2,32(sp)
    80001744:	69e2                	ld	s3,24(sp)
    80001746:	6a42                	ld	s4,16(sp)
    80001748:	6aa2                	ld	s5,8(sp)
    8000174a:	6121                	addi	sp,sp,64
    8000174c:	8082                	ret

000000008000174e <reparent>:
{
    8000174e:	7179                	addi	sp,sp,-48
    80001750:	f406                	sd	ra,40(sp)
    80001752:	f022                	sd	s0,32(sp)
    80001754:	ec26                	sd	s1,24(sp)
    80001756:	e84a                	sd	s2,16(sp)
    80001758:	e44e                	sd	s3,8(sp)
    8000175a:	e052                	sd	s4,0(sp)
    8000175c:	1800                	addi	s0,sp,48
    8000175e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001760:	00008497          	auipc	s1,0x8
    80001764:	d2048493          	addi	s1,s1,-736 # 80009480 <proc>
      pp->parent = initproc;
    80001768:	00008a17          	auipc	s4,0x8
    8000176c:	8a8a0a13          	addi	s4,s4,-1880 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001770:	00017997          	auipc	s3,0x17
    80001774:	71098993          	addi	s3,s3,1808 # 80018e80 <tickslock>
    80001778:	a029                	j	80001782 <reparent+0x34>
    8000177a:	3e848493          	addi	s1,s1,1000
    8000177e:	01348d63          	beq	s1,s3,80001798 <reparent+0x4a>
    if(pp->parent == p){
    80001782:	7c9c                	ld	a5,56(s1)
    80001784:	ff279be3          	bne	a5,s2,8000177a <reparent+0x2c>
      pp->parent = initproc;
    80001788:	000a3503          	ld	a0,0(s4)
    8000178c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000178e:	00000097          	auipc	ra,0x0
    80001792:	f4a080e7          	jalr	-182(ra) # 800016d8 <wakeup>
    80001796:	b7d5                	j	8000177a <reparent+0x2c>
}
    80001798:	70a2                	ld	ra,40(sp)
    8000179a:	7402                	ld	s0,32(sp)
    8000179c:	64e2                	ld	s1,24(sp)
    8000179e:	6942                	ld	s2,16(sp)
    800017a0:	69a2                	ld	s3,8(sp)
    800017a2:	6a02                	ld	s4,0(sp)
    800017a4:	6145                	addi	sp,sp,48
    800017a6:	8082                	ret

00000000800017a8 <exit>:
{
    800017a8:	7139                	addi	sp,sp,-64
    800017aa:	fc06                	sd	ra,56(sp)
    800017ac:	f822                	sd	s0,48(sp)
    800017ae:	f426                	sd	s1,40(sp)
    800017b0:	f04a                	sd	s2,32(sp)
    800017b2:	ec4e                	sd	s3,24(sp)
    800017b4:	e852                	sd	s4,16(sp)
    800017b6:	e456                	sd	s5,8(sp)
    800017b8:	0080                	addi	s0,sp,64
    800017ba:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    800017bc:	fffff097          	auipc	ra,0xfffff
    800017c0:	672080e7          	jalr	1650(ra) # 80000e2e <myproc>
    800017c4:	89aa                	mv	s3,a0
  if(p == initproc)
    800017c6:	00008797          	auipc	a5,0x8
    800017ca:	84a7b783          	ld	a5,-1974(a5) # 80009010 <initproc>
    800017ce:	0d050493          	addi	s1,a0,208
    800017d2:	15050913          	addi	s2,a0,336
    800017d6:	02a79363          	bne	a5,a0,800017fc <exit+0x54>
    panic("init exiting");
    800017da:	00007517          	auipc	a0,0x7
    800017de:	9ce50513          	addi	a0,a0,-1586 # 800081a8 <etext+0x1a8>
    800017e2:	00004097          	auipc	ra,0x4
    800017e6:	7e6080e7          	jalr	2022(ra) # 80005fc8 <panic>
          fileclose(f);
    800017ea:	00002097          	auipc	ra,0x2
    800017ee:	31c080e7          	jalr	796(ra) # 80003b06 <fileclose>
          p->ofile[fd] = 0;
    800017f2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017f6:	04a1                	addi	s1,s1,8
    800017f8:	01248563          	beq	s1,s2,80001802 <exit+0x5a>
      if(p->ofile[fd]){
    800017fc:	6088                	ld	a0,0(s1)
    800017fe:	f575                	bnez	a0,800017ea <exit+0x42>
    80001800:	bfdd                	j	800017f6 <exit+0x4e>
    80001802:	16898493          	addi	s1,s3,360
    80001806:	3e898a13          	addi	s4,s3,1000
      if (vma->used != 1) {
    8000180a:	4905                	li	s2,1
    8000180c:	a029                	j	80001816 <exit+0x6e>
  for (int i = 0; i < MAX_VMA_POOL; i++) {
    8000180e:	02848493          	addi	s1,s1,40
    80001812:	03448463          	beq	s1,s4,8000183a <exit+0x92>
      if (vma->used != 1) {
    80001816:	409c                	lw	a5,0(s1)
    80001818:	ff279be3          	bne	a5,s2,8000180e <exit+0x66>
      if (munmap_impl(vma->addr, vma->length) != 0)
    8000181c:	488c                	lw	a1,16(s1)
    8000181e:	6488                	ld	a0,8(s1)
    80001820:	00004097          	auipc	ra,0x4
    80001824:	8fa080e7          	jalr	-1798(ra) # 8000511a <munmap_impl>
    80001828:	d17d                	beqz	a0,8000180e <exit+0x66>
          panic("exit munmap");
    8000182a:	00007517          	auipc	a0,0x7
    8000182e:	98e50513          	addi	a0,a0,-1650 # 800081b8 <etext+0x1b8>
    80001832:	00004097          	auipc	ra,0x4
    80001836:	796080e7          	jalr	1942(ra) # 80005fc8 <panic>
  begin_op();
    8000183a:	00002097          	auipc	ra,0x2
    8000183e:	e00080e7          	jalr	-512(ra) # 8000363a <begin_op>
  iput(p->cwd);
    80001842:	1509b503          	ld	a0,336(s3)
    80001846:	00001097          	auipc	ra,0x1
    8000184a:	5dc080e7          	jalr	1500(ra) # 80002e22 <iput>
  end_op();
    8000184e:	00002097          	auipc	ra,0x2
    80001852:	e6c080e7          	jalr	-404(ra) # 800036ba <end_op>
  p->cwd = 0;
    80001856:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000185a:	00008497          	auipc	s1,0x8
    8000185e:	80e48493          	addi	s1,s1,-2034 # 80009068 <wait_lock>
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	cae080e7          	jalr	-850(ra) # 80006512 <acquire>
  reparent(p);
    8000186c:	854e                	mv	a0,s3
    8000186e:	00000097          	auipc	ra,0x0
    80001872:	ee0080e7          	jalr	-288(ra) # 8000174e <reparent>
  wakeup(p->parent);
    80001876:	0389b503          	ld	a0,56(s3)
    8000187a:	00000097          	auipc	ra,0x0
    8000187e:	e5e080e7          	jalr	-418(ra) # 800016d8 <wakeup>
  acquire(&p->lock);
    80001882:	854e                	mv	a0,s3
    80001884:	00005097          	auipc	ra,0x5
    80001888:	c8e080e7          	jalr	-882(ra) # 80006512 <acquire>
  p->xstate = status;
    8000188c:	0359a623          	sw	s5,44(s3)
  p->state = ZOMBIE;
    80001890:	4795                	li	a5,5
    80001892:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001896:	8526                	mv	a0,s1
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	d2e080e7          	jalr	-722(ra) # 800065c6 <release>
  sched();
    800018a0:	00000097          	auipc	ra,0x0
    800018a4:	b9a080e7          	jalr	-1126(ra) # 8000143a <sched>
  panic("zombie exit");
    800018a8:	00007517          	auipc	a0,0x7
    800018ac:	92050513          	addi	a0,a0,-1760 # 800081c8 <etext+0x1c8>
    800018b0:	00004097          	auipc	ra,0x4
    800018b4:	718080e7          	jalr	1816(ra) # 80005fc8 <panic>

00000000800018b8 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018b8:	7179                	addi	sp,sp,-48
    800018ba:	f406                	sd	ra,40(sp)
    800018bc:	f022                	sd	s0,32(sp)
    800018be:	ec26                	sd	s1,24(sp)
    800018c0:	e84a                	sd	s2,16(sp)
    800018c2:	e44e                	sd	s3,8(sp)
    800018c4:	1800                	addi	s0,sp,48
    800018c6:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018c8:	00008497          	auipc	s1,0x8
    800018cc:	bb848493          	addi	s1,s1,-1096 # 80009480 <proc>
    800018d0:	00017997          	auipc	s3,0x17
    800018d4:	5b098993          	addi	s3,s3,1456 # 80018e80 <tickslock>
    acquire(&p->lock);
    800018d8:	8526                	mv	a0,s1
    800018da:	00005097          	auipc	ra,0x5
    800018de:	c38080e7          	jalr	-968(ra) # 80006512 <acquire>
    if(p->pid == pid){
    800018e2:	589c                	lw	a5,48(s1)
    800018e4:	01278d63          	beq	a5,s2,800018fe <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018e8:	8526                	mv	a0,s1
    800018ea:	00005097          	auipc	ra,0x5
    800018ee:	cdc080e7          	jalr	-804(ra) # 800065c6 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018f2:	3e848493          	addi	s1,s1,1000
    800018f6:	ff3491e3          	bne	s1,s3,800018d8 <kill+0x20>
  }
  return -1;
    800018fa:	557d                	li	a0,-1
    800018fc:	a829                	j	80001916 <kill+0x5e>
      p->killed = 1;
    800018fe:	4785                	li	a5,1
    80001900:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001902:	4c98                	lw	a4,24(s1)
    80001904:	4789                	li	a5,2
    80001906:	00f70f63          	beq	a4,a5,80001924 <kill+0x6c>
      release(&p->lock);
    8000190a:	8526                	mv	a0,s1
    8000190c:	00005097          	auipc	ra,0x5
    80001910:	cba080e7          	jalr	-838(ra) # 800065c6 <release>
      return 0;
    80001914:	4501                	li	a0,0
}
    80001916:	70a2                	ld	ra,40(sp)
    80001918:	7402                	ld	s0,32(sp)
    8000191a:	64e2                	ld	s1,24(sp)
    8000191c:	6942                	ld	s2,16(sp)
    8000191e:	69a2                	ld	s3,8(sp)
    80001920:	6145                	addi	sp,sp,48
    80001922:	8082                	ret
        p->state = RUNNABLE;
    80001924:	478d                	li	a5,3
    80001926:	cc9c                	sw	a5,24(s1)
    80001928:	b7cd                	j	8000190a <kill+0x52>

000000008000192a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000192a:	7179                	addi	sp,sp,-48
    8000192c:	f406                	sd	ra,40(sp)
    8000192e:	f022                	sd	s0,32(sp)
    80001930:	ec26                	sd	s1,24(sp)
    80001932:	e84a                	sd	s2,16(sp)
    80001934:	e44e                	sd	s3,8(sp)
    80001936:	e052                	sd	s4,0(sp)
    80001938:	1800                	addi	s0,sp,48
    8000193a:	84aa                	mv	s1,a0
    8000193c:	892e                	mv	s2,a1
    8000193e:	89b2                	mv	s3,a2
    80001940:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001942:	fffff097          	auipc	ra,0xfffff
    80001946:	4ec080e7          	jalr	1260(ra) # 80000e2e <myproc>
  if(user_dst){
    8000194a:	c08d                	beqz	s1,8000196c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000194c:	86d2                	mv	a3,s4
    8000194e:	864e                	mv	a2,s3
    80001950:	85ca                	mv	a1,s2
    80001952:	6928                	ld	a0,80(a0)
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	19c080e7          	jalr	412(ra) # 80000af0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000195c:	70a2                	ld	ra,40(sp)
    8000195e:	7402                	ld	s0,32(sp)
    80001960:	64e2                	ld	s1,24(sp)
    80001962:	6942                	ld	s2,16(sp)
    80001964:	69a2                	ld	s3,8(sp)
    80001966:	6a02                	ld	s4,0(sp)
    80001968:	6145                	addi	sp,sp,48
    8000196a:	8082                	ret
    memmove((char *)dst, src, len);
    8000196c:	000a061b          	sext.w	a2,s4
    80001970:	85ce                	mv	a1,s3
    80001972:	854a                	mv	a0,s2
    80001974:	fffff097          	auipc	ra,0xfffff
    80001978:	864080e7          	jalr	-1948(ra) # 800001d8 <memmove>
    return 0;
    8000197c:	8526                	mv	a0,s1
    8000197e:	bff9                	j	8000195c <either_copyout+0x32>

0000000080001980 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001980:	7179                	addi	sp,sp,-48
    80001982:	f406                	sd	ra,40(sp)
    80001984:	f022                	sd	s0,32(sp)
    80001986:	ec26                	sd	s1,24(sp)
    80001988:	e84a                	sd	s2,16(sp)
    8000198a:	e44e                	sd	s3,8(sp)
    8000198c:	e052                	sd	s4,0(sp)
    8000198e:	1800                	addi	s0,sp,48
    80001990:	892a                	mv	s2,a0
    80001992:	84ae                	mv	s1,a1
    80001994:	89b2                	mv	s3,a2
    80001996:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	496080e7          	jalr	1174(ra) # 80000e2e <myproc>
  if(user_src){
    800019a0:	c08d                	beqz	s1,800019c2 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019a2:	86d2                	mv	a3,s4
    800019a4:	864e                	mv	a2,s3
    800019a6:	85ca                	mv	a1,s2
    800019a8:	6928                	ld	a0,80(a0)
    800019aa:	fffff097          	auipc	ra,0xfffff
    800019ae:	1d2080e7          	jalr	466(ra) # 80000b7c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019b2:	70a2                	ld	ra,40(sp)
    800019b4:	7402                	ld	s0,32(sp)
    800019b6:	64e2                	ld	s1,24(sp)
    800019b8:	6942                	ld	s2,16(sp)
    800019ba:	69a2                	ld	s3,8(sp)
    800019bc:	6a02                	ld	s4,0(sp)
    800019be:	6145                	addi	sp,sp,48
    800019c0:	8082                	ret
    memmove(dst, (char*)src, len);
    800019c2:	000a061b          	sext.w	a2,s4
    800019c6:	85ce                	mv	a1,s3
    800019c8:	854a                	mv	a0,s2
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	80e080e7          	jalr	-2034(ra) # 800001d8 <memmove>
    return 0;
    800019d2:	8526                	mv	a0,s1
    800019d4:	bff9                	j	800019b2 <either_copyin+0x32>

00000000800019d6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019d6:	715d                	addi	sp,sp,-80
    800019d8:	e486                	sd	ra,72(sp)
    800019da:	e0a2                	sd	s0,64(sp)
    800019dc:	fc26                	sd	s1,56(sp)
    800019de:	f84a                	sd	s2,48(sp)
    800019e0:	f44e                	sd	s3,40(sp)
    800019e2:	f052                	sd	s4,32(sp)
    800019e4:	ec56                	sd	s5,24(sp)
    800019e6:	e85a                	sd	s6,16(sp)
    800019e8:	e45e                	sd	s7,8(sp)
    800019ea:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019ec:	00006517          	auipc	a0,0x6
    800019f0:	65c50513          	addi	a0,a0,1628 # 80008048 <etext+0x48>
    800019f4:	00004097          	auipc	ra,0x4
    800019f8:	61e080e7          	jalr	1566(ra) # 80006012 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019fc:	00008497          	auipc	s1,0x8
    80001a00:	bdc48493          	addi	s1,s1,-1060 # 800095d8 <proc+0x158>
    80001a04:	00017917          	auipc	s2,0x17
    80001a08:	5d490913          	addi	s2,s2,1492 # 80018fd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a0c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a0e:	00006997          	auipc	s3,0x6
    80001a12:	7ca98993          	addi	s3,s3,1994 # 800081d8 <etext+0x1d8>
    printf("%d %s %s", p->pid, state, p->name);
    80001a16:	00006a97          	auipc	s5,0x6
    80001a1a:	7caa8a93          	addi	s5,s5,1994 # 800081e0 <etext+0x1e0>
    printf("\n");
    80001a1e:	00006a17          	auipc	s4,0x6
    80001a22:	62aa0a13          	addi	s4,s4,1578 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a26:	00006b97          	auipc	s7,0x6
    80001a2a:	7f2b8b93          	addi	s7,s7,2034 # 80008218 <states.1739>
    80001a2e:	a00d                	j	80001a50 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a30:	ed86a583          	lw	a1,-296(a3)
    80001a34:	8556                	mv	a0,s5
    80001a36:	00004097          	auipc	ra,0x4
    80001a3a:	5dc080e7          	jalr	1500(ra) # 80006012 <printf>
    printf("\n");
    80001a3e:	8552                	mv	a0,s4
    80001a40:	00004097          	auipc	ra,0x4
    80001a44:	5d2080e7          	jalr	1490(ra) # 80006012 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a48:	3e848493          	addi	s1,s1,1000
    80001a4c:	03248163          	beq	s1,s2,80001a6e <procdump+0x98>
    if(p->state == UNUSED)
    80001a50:	86a6                	mv	a3,s1
    80001a52:	ec04a783          	lw	a5,-320(s1)
    80001a56:	dbed                	beqz	a5,80001a48 <procdump+0x72>
      state = "???";
    80001a58:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a5a:	fcfb6be3          	bltu	s6,a5,80001a30 <procdump+0x5a>
    80001a5e:	1782                	slli	a5,a5,0x20
    80001a60:	9381                	srli	a5,a5,0x20
    80001a62:	078e                	slli	a5,a5,0x3
    80001a64:	97de                	add	a5,a5,s7
    80001a66:	6390                	ld	a2,0(a5)
    80001a68:	f661                	bnez	a2,80001a30 <procdump+0x5a>
      state = "???";
    80001a6a:	864e                	mv	a2,s3
    80001a6c:	b7d1                	j	80001a30 <procdump+0x5a>
  }
}
    80001a6e:	60a6                	ld	ra,72(sp)
    80001a70:	6406                	ld	s0,64(sp)
    80001a72:	74e2                	ld	s1,56(sp)
    80001a74:	7942                	ld	s2,48(sp)
    80001a76:	79a2                	ld	s3,40(sp)
    80001a78:	7a02                	ld	s4,32(sp)
    80001a7a:	6ae2                	ld	s5,24(sp)
    80001a7c:	6b42                	ld	s6,16(sp)
    80001a7e:	6ba2                	ld	s7,8(sp)
    80001a80:	6161                	addi	sp,sp,80
    80001a82:	8082                	ret

0000000080001a84 <get_vma_pool>:

struct VMA* get_vma_pool() {
    80001a84:	1141                	addi	sp,sp,-16
    80001a86:	e406                	sd	ra,8(sp)
    80001a88:	e022                	sd	s0,0(sp)
    80001a8a:	0800                	addi	s0,sp,16
    return myproc()->vma_pool;
    80001a8c:	fffff097          	auipc	ra,0xfffff
    80001a90:	3a2080e7          	jalr	930(ra) # 80000e2e <myproc>
}
    80001a94:	16850513          	addi	a0,a0,360
    80001a98:	60a2                	ld	ra,8(sp)
    80001a9a:	6402                	ld	s0,0(sp)
    80001a9c:	0141                	addi	sp,sp,16
    80001a9e:	8082                	ret

0000000080001aa0 <vma_alloc>:

uint64 vma_alloc() {
    80001aa0:	1141                	addi	sp,sp,-16
    80001aa2:	e406                	sd	ra,8(sp)
    80001aa4:	e022                	sd	s0,0(sp)
    80001aa6:	0800                	addi	s0,sp,16
    return myproc()->vma_pool;
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	386080e7          	jalr	902(ra) # 80000e2e <myproc>
    80001ab0:	87aa                	mv	a5,a0
    struct VMA* vma_pool = get_vma_pool();
    for (int i = 0; i < MAX_VMA_POOL; i++) {
    80001ab2:	16850513          	addi	a0,a0,360
    80001ab6:	3e878793          	addi	a5,a5,1000
        struct VMA *vma = vma_pool + i;
        if (vma->used == 1) {
    80001aba:	4685                	li	a3,1
    80001abc:	4118                	lw	a4,0(a0)
    80001abe:	00d70863          	beq	a4,a3,80001ace <vma_alloc+0x2e>
            continue;
        }
        vma->used = 1;
    80001ac2:	4785                	li	a5,1
    80001ac4:	c11c                	sw	a5,0(a0)
        return (uint64) vma;
    }
    return 0;
}
    80001ac6:	60a2                	ld	ra,8(sp)
    80001ac8:	6402                	ld	s0,0(sp)
    80001aca:	0141                	addi	sp,sp,16
    80001acc:	8082                	ret
    for (int i = 0; i < MAX_VMA_POOL; i++) {
    80001ace:	02850513          	addi	a0,a0,40
    80001ad2:	fef515e3          	bne	a0,a5,80001abc <vma_alloc+0x1c>
    return 0;
    80001ad6:	4501                	li	a0,0
    80001ad8:	b7fd                	j	80001ac6 <vma_alloc+0x26>

0000000080001ada <vma_free>:

void vma_free(uint64 vma) {
    80001ada:	1141                	addi	sp,sp,-16
    80001adc:	e422                	sd	s0,8(sp)
    80001ade:	0800                	addi	s0,sp,16
    ((struct VMA*) vma)->used = 0;
    80001ae0:	00052023          	sw	zero,0(a0)
}
    80001ae4:	6422                	ld	s0,8(sp)
    80001ae6:	0141                	addi	sp,sp,16
    80001ae8:	8082                	ret

0000000080001aea <swtch>:
    80001aea:	00153023          	sd	ra,0(a0)
    80001aee:	00253423          	sd	sp,8(a0)
    80001af2:	e900                	sd	s0,16(a0)
    80001af4:	ed04                	sd	s1,24(a0)
    80001af6:	03253023          	sd	s2,32(a0)
    80001afa:	03353423          	sd	s3,40(a0)
    80001afe:	03453823          	sd	s4,48(a0)
    80001b02:	03553c23          	sd	s5,56(a0)
    80001b06:	05653023          	sd	s6,64(a0)
    80001b0a:	05753423          	sd	s7,72(a0)
    80001b0e:	05853823          	sd	s8,80(a0)
    80001b12:	05953c23          	sd	s9,88(a0)
    80001b16:	07a53023          	sd	s10,96(a0)
    80001b1a:	07b53423          	sd	s11,104(a0)
    80001b1e:	0005b083          	ld	ra,0(a1)
    80001b22:	0085b103          	ld	sp,8(a1)
    80001b26:	6980                	ld	s0,16(a1)
    80001b28:	6d84                	ld	s1,24(a1)
    80001b2a:	0205b903          	ld	s2,32(a1)
    80001b2e:	0285b983          	ld	s3,40(a1)
    80001b32:	0305ba03          	ld	s4,48(a1)
    80001b36:	0385ba83          	ld	s5,56(a1)
    80001b3a:	0405bb03          	ld	s6,64(a1)
    80001b3e:	0485bb83          	ld	s7,72(a1)
    80001b42:	0505bc03          	ld	s8,80(a1)
    80001b46:	0585bc83          	ld	s9,88(a1)
    80001b4a:	0605bd03          	ld	s10,96(a1)
    80001b4e:	0685bd83          	ld	s11,104(a1)
    80001b52:	8082                	ret

0000000080001b54 <page_fault_handler>:
#include "fcntl.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"

void page_fault_handler() {
    80001b54:	7179                	addi	sp,sp,-48
    80001b56:	f406                	sd	ra,40(sp)
    80001b58:	f022                	sd	s0,32(sp)
    80001b5a:	ec26                	sd	s1,24(sp)
    80001b5c:	e84a                	sd	s2,16(sp)
    80001b5e:	e44e                	sd	s3,8(sp)
    80001b60:	e052                	sd	s4,0(sp)
    80001b62:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001b64:	fffff097          	auipc	ra,0xfffff
    80001b68:	2ca080e7          	jalr	714(ra) # 80000e2e <myproc>
    80001b6c:	89aa                	mv	s3,a0
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b6e:	14302973          	csrr	s2,stval
  // 检查 va 合法性
  uint64 va = r_stval();
  if (va >= p->sz || va < PGROUNDDOWN(p->trapframe->sp)) {
    80001b72:	653c                	ld	a5,72(a0)
    80001b74:	02f97163          	bgeu	s2,a5,80001b96 <page_fault_handler+0x42>
    80001b78:	6d3c                	ld	a5,88(a0)
    80001b7a:	7b98                	ld	a4,48(a5)
    80001b7c:	77fd                	lui	a5,0xfffff
    80001b7e:	8ff9                	and	a5,a5,a4
    80001b80:	00f96b63          	bltu	s2,a5,80001b96 <page_fault_handler+0x42>
    p->killed = 1;
    return;
  }
  va = PGROUNDDOWN(va);
    80001b84:	77fd                	lui	a5,0xfffff
    80001b86:	00f97933          	and	s2,s2,a5
  // 遍历 vma pool，判断 va 是否是被 mmapp 的
  struct VMA *vma = 0;
  for (int i = 0; i < MAX_VMA_POOL; i++) {
    80001b8a:	16850793          	addi	a5,a0,360
    80001b8e:	3e850613          	addi	a2,a0,1000
    vma = p->vma_pool + i;
    if (vma->used == 1 && (va >= vma->addr) && (va < (vma->addr + vma->length))) {
    80001b92:	4685                	li	a3,1
    80001b94:	a005                	j	80001bb4 <page_fault_handler+0x60>
    p->killed = 1;
    80001b96:	4785                	li	a5,1
    80001b98:	02f9a423          	sw	a5,40(s3)
    // 将映射文件的数据读入 kmem page 中
    ilock(vma->f->ip);
    readi(vma->f->ip, 0, (uint64) kmem, va - vma->addr, PGSIZE);
    iunlock(vma->f->ip);
  }
}
    80001b9c:	70a2                	ld	ra,40(sp)
    80001b9e:	7402                	ld	s0,32(sp)
    80001ba0:	64e2                	ld	s1,24(sp)
    80001ba2:	6942                	ld	s2,16(sp)
    80001ba4:	69a2                	ld	s3,8(sp)
    80001ba6:	6a02                	ld	s4,0(sp)
    80001ba8:	6145                	addi	sp,sp,48
    80001baa:	8082                	ret
  for (int i = 0; i < MAX_VMA_POOL; i++) {
    80001bac:	02878793          	addi	a5,a5,40 # fffffffffffff028 <end+0xffffffff7ffcede8>
    80001bb0:	00c78e63          	beq	a5,a2,80001bcc <page_fault_handler+0x78>
    vma = p->vma_pool + i;
    80001bb4:	84be                	mv	s1,a5
    if (vma->used == 1 && (va >= vma->addr) && (va < (vma->addr + vma->length))) {
    80001bb6:	4398                	lw	a4,0(a5)
    80001bb8:	fed71ae3          	bne	a4,a3,80001bac <page_fault_handler+0x58>
    80001bbc:	6798                	ld	a4,8(a5)
    80001bbe:	fee967e3          	bltu	s2,a4,80001bac <page_fault_handler+0x58>
    80001bc2:	0107e583          	lwu	a1,16(a5)
    80001bc6:	972e                	add	a4,a4,a1
    80001bc8:	fee972e3          	bgeu	s2,a4,80001bac <page_fault_handler+0x58>
    char *kmem = kalloc();
    80001bcc:	ffffe097          	auipc	ra,0xffffe
    80001bd0:	54c080e7          	jalr	1356(ra) # 80000118 <kalloc>
    80001bd4:	8a2a                	mv	s4,a0
    if (kmem == 0) {
    80001bd6:	c125                	beqz	a0,80001c36 <page_fault_handler+0xe2>
    memset(kmem, 0, PGSIZE); 
    80001bd8:	6605                	lui	a2,0x1
    80001bda:	4581                	li	a1,0
    80001bdc:	ffffe097          	auipc	ra,0xffffe
    80001be0:	59c080e7          	jalr	1436(ra) # 80000178 <memset>
    if (mappages(p->pagetable, va, PGSIZE, (uint64) kmem, (vma->prot << 1) | PTE_U) != 0) { 
    80001be4:	48d8                	lw	a4,20(s1)
    80001be6:	0017171b          	slliw	a4,a4,0x1
    80001bea:	01076713          	ori	a4,a4,16
    80001bee:	2701                	sext.w	a4,a4
    80001bf0:	86d2                	mv	a3,s4
    80001bf2:	6605                	lui	a2,0x1
    80001bf4:	85ca                	mv	a1,s2
    80001bf6:	0509b503          	ld	a0,80(s3)
    80001bfa:	fffff097          	auipc	ra,0xfffff
    80001bfe:	94e080e7          	jalr	-1714(ra) # 80000548 <mappages>
    80001c02:	ed15                	bnez	a0,80001c3e <page_fault_handler+0xea>
    ilock(vma->f->ip);
    80001c04:	709c                	ld	a5,32(s1)
    80001c06:	6f88                	ld	a0,24(a5)
    80001c08:	00001097          	auipc	ra,0x1
    80001c0c:	060080e7          	jalr	96(ra) # 80002c68 <ilock>
    readi(vma->f->ip, 0, (uint64) kmem, va - vma->addr, PGSIZE);
    80001c10:	6494                	ld	a3,8(s1)
    80001c12:	709c                	ld	a5,32(s1)
    80001c14:	6705                	lui	a4,0x1
    80001c16:	40d906bb          	subw	a3,s2,a3
    80001c1a:	8652                	mv	a2,s4
    80001c1c:	4581                	li	a1,0
    80001c1e:	6f88                	ld	a0,24(a5)
    80001c20:	00001097          	auipc	ra,0x1
    80001c24:	2fc080e7          	jalr	764(ra) # 80002f1c <readi>
    iunlock(vma->f->ip);
    80001c28:	709c                	ld	a5,32(s1)
    80001c2a:	6f88                	ld	a0,24(a5)
    80001c2c:	00001097          	auipc	ra,0x1
    80001c30:	0fe080e7          	jalr	254(ra) # 80002d2a <iunlock>
    80001c34:	b7a5                	j	80001b9c <page_fault_handler+0x48>
      p->killed = 1;
    80001c36:	4785                	li	a5,1
    80001c38:	02f9a423          	sw	a5,40(s3)
      return;
    80001c3c:	b785                	j	80001b9c <page_fault_handler+0x48>
      kfree(kmem);
    80001c3e:	8552                	mv	a0,s4
    80001c40:	ffffe097          	auipc	ra,0xffffe
    80001c44:	3dc080e7          	jalr	988(ra) # 8000001c <kfree>
      p->killed = 1;
    80001c48:	4785                	li	a5,1
    80001c4a:	02f9a423          	sw	a5,40(s3)
      return;
    80001c4e:	b7b9                	j	80001b9c <page_fault_handler+0x48>

0000000080001c50 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c50:	1141                	addi	sp,sp,-16
    80001c52:	e406                	sd	ra,8(sp)
    80001c54:	e022                	sd	s0,0(sp)
    80001c56:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c58:	00006597          	auipc	a1,0x6
    80001c5c:	5f058593          	addi	a1,a1,1520 # 80008248 <states.1739+0x30>
    80001c60:	00017517          	auipc	a0,0x17
    80001c64:	22050513          	addi	a0,a0,544 # 80018e80 <tickslock>
    80001c68:	00005097          	auipc	ra,0x5
    80001c6c:	81a080e7          	jalr	-2022(ra) # 80006482 <initlock>
}
    80001c70:	60a2                	ld	ra,8(sp)
    80001c72:	6402                	ld	s0,0(sp)
    80001c74:	0141                	addi	sp,sp,16
    80001c76:	8082                	ret

0000000080001c78 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c78:	1141                	addi	sp,sp,-16
    80001c7a:	e422                	sd	s0,8(sp)
    80001c7c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c7e:	00003797          	auipc	a5,0x3
    80001c82:	75278793          	addi	a5,a5,1874 # 800053d0 <kernelvec>
    80001c86:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c8a:	6422                	ld	s0,8(sp)
    80001c8c:	0141                	addi	sp,sp,16
    80001c8e:	8082                	ret

0000000080001c90 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c90:	1141                	addi	sp,sp,-16
    80001c92:	e406                	sd	ra,8(sp)
    80001c94:	e022                	sd	s0,0(sp)
    80001c96:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c98:	fffff097          	auipc	ra,0xfffff
    80001c9c:	196080e7          	jalr	406(ra) # 80000e2e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ca4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ca6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001caa:	00005617          	auipc	a2,0x5
    80001cae:	35660613          	addi	a2,a2,854 # 80007000 <_trampoline>
    80001cb2:	00005697          	auipc	a3,0x5
    80001cb6:	34e68693          	addi	a3,a3,846 # 80007000 <_trampoline>
    80001cba:	8e91                	sub	a3,a3,a2
    80001cbc:	040007b7          	lui	a5,0x4000
    80001cc0:	17fd                	addi	a5,a5,-1
    80001cc2:	07b2                	slli	a5,a5,0xc
    80001cc4:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc6:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cca:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ccc:	180026f3          	csrr	a3,satp
    80001cd0:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cd2:	6d38                	ld	a4,88(a0)
    80001cd4:	6134                	ld	a3,64(a0)
    80001cd6:	6585                	lui	a1,0x1
    80001cd8:	96ae                	add	a3,a3,a1
    80001cda:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cdc:	6d38                	ld	a4,88(a0)
    80001cde:	00000697          	auipc	a3,0x0
    80001ce2:	13868693          	addi	a3,a3,312 # 80001e16 <usertrap>
    80001ce6:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001ce8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cea:	8692                	mv	a3,tp
    80001cec:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cee:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cf2:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cf6:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cfa:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cfe:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d00:	6f18                	ld	a4,24(a4)
    80001d02:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d06:	692c                	ld	a1,80(a0)
    80001d08:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d0a:	00005717          	auipc	a4,0x5
    80001d0e:	38670713          	addi	a4,a4,902 # 80007090 <userret>
    80001d12:	8f11                	sub	a4,a4,a2
    80001d14:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d16:	577d                	li	a4,-1
    80001d18:	177e                	slli	a4,a4,0x3f
    80001d1a:	8dd9                	or	a1,a1,a4
    80001d1c:	02000537          	lui	a0,0x2000
    80001d20:	157d                	addi	a0,a0,-1
    80001d22:	0536                	slli	a0,a0,0xd
    80001d24:	9782                	jalr	a5
}
    80001d26:	60a2                	ld	ra,8(sp)
    80001d28:	6402                	ld	s0,0(sp)
    80001d2a:	0141                	addi	sp,sp,16
    80001d2c:	8082                	ret

0000000080001d2e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d2e:	1101                	addi	sp,sp,-32
    80001d30:	ec06                	sd	ra,24(sp)
    80001d32:	e822                	sd	s0,16(sp)
    80001d34:	e426                	sd	s1,8(sp)
    80001d36:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d38:	00017497          	auipc	s1,0x17
    80001d3c:	14848493          	addi	s1,s1,328 # 80018e80 <tickslock>
    80001d40:	8526                	mv	a0,s1
    80001d42:	00004097          	auipc	ra,0x4
    80001d46:	7d0080e7          	jalr	2000(ra) # 80006512 <acquire>
  ticks++;
    80001d4a:	00007517          	auipc	a0,0x7
    80001d4e:	2ce50513          	addi	a0,a0,718 # 80009018 <ticks>
    80001d52:	411c                	lw	a5,0(a0)
    80001d54:	2785                	addiw	a5,a5,1
    80001d56:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d58:	00000097          	auipc	ra,0x0
    80001d5c:	980080e7          	jalr	-1664(ra) # 800016d8 <wakeup>
  release(&tickslock);
    80001d60:	8526                	mv	a0,s1
    80001d62:	00005097          	auipc	ra,0x5
    80001d66:	864080e7          	jalr	-1948(ra) # 800065c6 <release>
}
    80001d6a:	60e2                	ld	ra,24(sp)
    80001d6c:	6442                	ld	s0,16(sp)
    80001d6e:	64a2                	ld	s1,8(sp)
    80001d70:	6105                	addi	sp,sp,32
    80001d72:	8082                	ret

0000000080001d74 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d74:	1101                	addi	sp,sp,-32
    80001d76:	ec06                	sd	ra,24(sp)
    80001d78:	e822                	sd	s0,16(sp)
    80001d7a:	e426                	sd	s1,8(sp)
    80001d7c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d7e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d82:	00074d63          	bltz	a4,80001d9c <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d86:	57fd                	li	a5,-1
    80001d88:	17fe                	slli	a5,a5,0x3f
    80001d8a:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d8c:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d8e:	06f70363          	beq	a4,a5,80001df4 <devintr+0x80>
  }
}
    80001d92:	60e2                	ld	ra,24(sp)
    80001d94:	6442                	ld	s0,16(sp)
    80001d96:	64a2                	ld	s1,8(sp)
    80001d98:	6105                	addi	sp,sp,32
    80001d9a:	8082                	ret
     (scause & 0xff) == 9){
    80001d9c:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001da0:	46a5                	li	a3,9
    80001da2:	fed792e3          	bne	a5,a3,80001d86 <devintr+0x12>
    int irq = plic_claim();
    80001da6:	00003097          	auipc	ra,0x3
    80001daa:	732080e7          	jalr	1842(ra) # 800054d8 <plic_claim>
    80001dae:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001db0:	47a9                	li	a5,10
    80001db2:	02f50763          	beq	a0,a5,80001de0 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001db6:	4785                	li	a5,1
    80001db8:	02f50963          	beq	a0,a5,80001dea <devintr+0x76>
    return 1;
    80001dbc:	4505                	li	a0,1
    } else if(irq){
    80001dbe:	d8f1                	beqz	s1,80001d92 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dc0:	85a6                	mv	a1,s1
    80001dc2:	00006517          	auipc	a0,0x6
    80001dc6:	48e50513          	addi	a0,a0,1166 # 80008250 <states.1739+0x38>
    80001dca:	00004097          	auipc	ra,0x4
    80001dce:	248080e7          	jalr	584(ra) # 80006012 <printf>
      plic_complete(irq);
    80001dd2:	8526                	mv	a0,s1
    80001dd4:	00003097          	auipc	ra,0x3
    80001dd8:	728080e7          	jalr	1832(ra) # 800054fc <plic_complete>
    return 1;
    80001ddc:	4505                	li	a0,1
    80001dde:	bf55                	j	80001d92 <devintr+0x1e>
      uartintr();
    80001de0:	00004097          	auipc	ra,0x4
    80001de4:	652080e7          	jalr	1618(ra) # 80006432 <uartintr>
    80001de8:	b7ed                	j	80001dd2 <devintr+0x5e>
      virtio_disk_intr();
    80001dea:	00004097          	auipc	ra,0x4
    80001dee:	bf2080e7          	jalr	-1038(ra) # 800059dc <virtio_disk_intr>
    80001df2:	b7c5                	j	80001dd2 <devintr+0x5e>
    if(cpuid() == 0){
    80001df4:	fffff097          	auipc	ra,0xfffff
    80001df8:	00e080e7          	jalr	14(ra) # 80000e02 <cpuid>
    80001dfc:	c901                	beqz	a0,80001e0c <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dfe:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e02:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e04:	14479073          	csrw	sip,a5
    return 2;
    80001e08:	4509                	li	a0,2
    80001e0a:	b761                	j	80001d92 <devintr+0x1e>
      clockintr();
    80001e0c:	00000097          	auipc	ra,0x0
    80001e10:	f22080e7          	jalr	-222(ra) # 80001d2e <clockintr>
    80001e14:	b7ed                	j	80001dfe <devintr+0x8a>

0000000080001e16 <usertrap>:
{
    80001e16:	1101                	addi	sp,sp,-32
    80001e18:	ec06                	sd	ra,24(sp)
    80001e1a:	e822                	sd	s0,16(sp)
    80001e1c:	e426                	sd	s1,8(sp)
    80001e1e:	e04a                	sd	s2,0(sp)
    80001e20:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e22:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e26:	1007f793          	andi	a5,a5,256
    80001e2a:	efb9                	bnez	a5,80001e88 <usertrap+0x72>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e2c:	00003797          	auipc	a5,0x3
    80001e30:	5a478793          	addi	a5,a5,1444 # 800053d0 <kernelvec>
    80001e34:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	ff6080e7          	jalr	-10(ra) # 80000e2e <myproc>
    80001e40:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e42:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e44:	14102773          	csrr	a4,sepc
    80001e48:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e4a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e4e:	47a1                	li	a5,8
    80001e50:	04f70463          	beq	a4,a5,80001e98 <usertrap+0x82>
    80001e54:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15){
    80001e58:	47b5                	li	a5,13
    80001e5a:	00f70763          	beq	a4,a5,80001e68 <usertrap+0x52>
    80001e5e:	14202773          	csrr	a4,scause
    80001e62:	47bd                	li	a5,15
    80001e64:	06f71163          	bne	a4,a5,80001ec6 <usertrap+0xb0>
    page_fault_handler();
    80001e68:	00000097          	auipc	ra,0x0
    80001e6c:	cec080e7          	jalr	-788(ra) # 80001b54 <page_fault_handler>
  if(p->killed)
    80001e70:	549c                	lw	a5,40(s1)
    80001e72:	efc9                	bnez	a5,80001f0c <usertrap+0xf6>
  usertrapret();
    80001e74:	00000097          	auipc	ra,0x0
    80001e78:	e1c080e7          	jalr	-484(ra) # 80001c90 <usertrapret>
}
    80001e7c:	60e2                	ld	ra,24(sp)
    80001e7e:	6442                	ld	s0,16(sp)
    80001e80:	64a2                	ld	s1,8(sp)
    80001e82:	6902                	ld	s2,0(sp)
    80001e84:	6105                	addi	sp,sp,32
    80001e86:	8082                	ret
    panic("usertrap: not from user mode");
    80001e88:	00006517          	auipc	a0,0x6
    80001e8c:	3e850513          	addi	a0,a0,1000 # 80008270 <states.1739+0x58>
    80001e90:	00004097          	auipc	ra,0x4
    80001e94:	138080e7          	jalr	312(ra) # 80005fc8 <panic>
    if(p->killed)
    80001e98:	551c                	lw	a5,40(a0)
    80001e9a:	e385                	bnez	a5,80001eba <usertrap+0xa4>
    p->trapframe->epc += 4;
    80001e9c:	6cb8                	ld	a4,88(s1)
    80001e9e:	6f1c                	ld	a5,24(a4)
    80001ea0:	0791                	addi	a5,a5,4
    80001ea2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ea8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eac:	10079073          	csrw	sstatus,a5
    syscall();
    80001eb0:	00000097          	auipc	ra,0x0
    80001eb4:	2ba080e7          	jalr	698(ra) # 8000216a <syscall>
    80001eb8:	bf65                	j	80001e70 <usertrap+0x5a>
      exit(-1);
    80001eba:	557d                	li	a0,-1
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	8ec080e7          	jalr	-1812(ra) # 800017a8 <exit>
    80001ec4:	bfe1                	j	80001e9c <usertrap+0x86>
  } else if((which_dev = devintr()) != 0){
    80001ec6:	00000097          	auipc	ra,0x0
    80001eca:	eae080e7          	jalr	-338(ra) # 80001d74 <devintr>
    80001ece:	892a                	mv	s2,a0
    80001ed0:	c501                	beqz	a0,80001ed8 <usertrap+0xc2>
  if(p->killed)
    80001ed2:	549c                	lw	a5,40(s1)
    80001ed4:	c3b1                	beqz	a5,80001f18 <usertrap+0x102>
    80001ed6:	a825                	j	80001f0e <usertrap+0xf8>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ed8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001edc:	5890                	lw	a2,48(s1)
    80001ede:	00006517          	auipc	a0,0x6
    80001ee2:	3b250513          	addi	a0,a0,946 # 80008290 <states.1739+0x78>
    80001ee6:	00004097          	auipc	ra,0x4
    80001eea:	12c080e7          	jalr	300(ra) # 80006012 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eee:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ef2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ef6:	00006517          	auipc	a0,0x6
    80001efa:	3ca50513          	addi	a0,a0,970 # 800082c0 <states.1739+0xa8>
    80001efe:	00004097          	auipc	ra,0x4
    80001f02:	114080e7          	jalr	276(ra) # 80006012 <printf>
    p->killed = 1;
    80001f06:	4785                	li	a5,1
    80001f08:	d49c                	sw	a5,40(s1)
  if(p->killed)
    80001f0a:	a011                	j	80001f0e <usertrap+0xf8>
    80001f0c:	4901                	li	s2,0
    exit(-1);
    80001f0e:	557d                	li	a0,-1
    80001f10:	00000097          	auipc	ra,0x0
    80001f14:	898080e7          	jalr	-1896(ra) # 800017a8 <exit>
  if(which_dev == 2)
    80001f18:	4789                	li	a5,2
    80001f1a:	f4f91de3          	bne	s2,a5,80001e74 <usertrap+0x5e>
    yield();
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	5f2080e7          	jalr	1522(ra) # 80001510 <yield>
    80001f26:	b7b9                	j	80001e74 <usertrap+0x5e>

0000000080001f28 <kerneltrap>:
{
    80001f28:	7179                	addi	sp,sp,-48
    80001f2a:	f406                	sd	ra,40(sp)
    80001f2c:	f022                	sd	s0,32(sp)
    80001f2e:	ec26                	sd	s1,24(sp)
    80001f30:	e84a                	sd	s2,16(sp)
    80001f32:	e44e                	sd	s3,8(sp)
    80001f34:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f36:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f3a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f3e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f42:	1004f793          	andi	a5,s1,256
    80001f46:	cb85                	beqz	a5,80001f76 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f48:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f4c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f4e:	ef85                	bnez	a5,80001f86 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	e24080e7          	jalr	-476(ra) # 80001d74 <devintr>
    80001f58:	cd1d                	beqz	a0,80001f96 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f5a:	4789                	li	a5,2
    80001f5c:	06f50a63          	beq	a0,a5,80001fd0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f60:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f64:	10049073          	csrw	sstatus,s1
}
    80001f68:	70a2                	ld	ra,40(sp)
    80001f6a:	7402                	ld	s0,32(sp)
    80001f6c:	64e2                	ld	s1,24(sp)
    80001f6e:	6942                	ld	s2,16(sp)
    80001f70:	69a2                	ld	s3,8(sp)
    80001f72:	6145                	addi	sp,sp,48
    80001f74:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f76:	00006517          	auipc	a0,0x6
    80001f7a:	36a50513          	addi	a0,a0,874 # 800082e0 <states.1739+0xc8>
    80001f7e:	00004097          	auipc	ra,0x4
    80001f82:	04a080e7          	jalr	74(ra) # 80005fc8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f86:	00006517          	auipc	a0,0x6
    80001f8a:	38250513          	addi	a0,a0,898 # 80008308 <states.1739+0xf0>
    80001f8e:	00004097          	auipc	ra,0x4
    80001f92:	03a080e7          	jalr	58(ra) # 80005fc8 <panic>
    printf("scause %p\n", scause);
    80001f96:	85ce                	mv	a1,s3
    80001f98:	00006517          	auipc	a0,0x6
    80001f9c:	39050513          	addi	a0,a0,912 # 80008328 <states.1739+0x110>
    80001fa0:	00004097          	auipc	ra,0x4
    80001fa4:	072080e7          	jalr	114(ra) # 80006012 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fa8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fac:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fb0:	00006517          	auipc	a0,0x6
    80001fb4:	38850513          	addi	a0,a0,904 # 80008338 <states.1739+0x120>
    80001fb8:	00004097          	auipc	ra,0x4
    80001fbc:	05a080e7          	jalr	90(ra) # 80006012 <printf>
    panic("kerneltrap");
    80001fc0:	00006517          	auipc	a0,0x6
    80001fc4:	39050513          	addi	a0,a0,912 # 80008350 <states.1739+0x138>
    80001fc8:	00004097          	auipc	ra,0x4
    80001fcc:	000080e7          	jalr	ra # 80005fc8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	e5e080e7          	jalr	-418(ra) # 80000e2e <myproc>
    80001fd8:	d541                	beqz	a0,80001f60 <kerneltrap+0x38>
    80001fda:	fffff097          	auipc	ra,0xfffff
    80001fde:	e54080e7          	jalr	-428(ra) # 80000e2e <myproc>
    80001fe2:	4d18                	lw	a4,24(a0)
    80001fe4:	4791                	li	a5,4
    80001fe6:	f6f71de3          	bne	a4,a5,80001f60 <kerneltrap+0x38>
    yield();
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	526080e7          	jalr	1318(ra) # 80001510 <yield>
    80001ff2:	b7bd                	j	80001f60 <kerneltrap+0x38>

0000000080001ff4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ff4:	1101                	addi	sp,sp,-32
    80001ff6:	ec06                	sd	ra,24(sp)
    80001ff8:	e822                	sd	s0,16(sp)
    80001ffa:	e426                	sd	s1,8(sp)
    80001ffc:	1000                	addi	s0,sp,32
    80001ffe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002000:	fffff097          	auipc	ra,0xfffff
    80002004:	e2e080e7          	jalr	-466(ra) # 80000e2e <myproc>
  switch (n) {
    80002008:	4795                	li	a5,5
    8000200a:	0497e163          	bltu	a5,s1,8000204c <argraw+0x58>
    8000200e:	048a                	slli	s1,s1,0x2
    80002010:	00006717          	auipc	a4,0x6
    80002014:	37870713          	addi	a4,a4,888 # 80008388 <states.1739+0x170>
    80002018:	94ba                	add	s1,s1,a4
    8000201a:	409c                	lw	a5,0(s1)
    8000201c:	97ba                	add	a5,a5,a4
    8000201e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002020:	6d3c                	ld	a5,88(a0)
    80002022:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	64a2                	ld	s1,8(sp)
    8000202a:	6105                	addi	sp,sp,32
    8000202c:	8082                	ret
    return p->trapframe->a1;
    8000202e:	6d3c                	ld	a5,88(a0)
    80002030:	7fa8                	ld	a0,120(a5)
    80002032:	bfcd                	j	80002024 <argraw+0x30>
    return p->trapframe->a2;
    80002034:	6d3c                	ld	a5,88(a0)
    80002036:	63c8                	ld	a0,128(a5)
    80002038:	b7f5                	j	80002024 <argraw+0x30>
    return p->trapframe->a3;
    8000203a:	6d3c                	ld	a5,88(a0)
    8000203c:	67c8                	ld	a0,136(a5)
    8000203e:	b7dd                	j	80002024 <argraw+0x30>
    return p->trapframe->a4;
    80002040:	6d3c                	ld	a5,88(a0)
    80002042:	6bc8                	ld	a0,144(a5)
    80002044:	b7c5                	j	80002024 <argraw+0x30>
    return p->trapframe->a5;
    80002046:	6d3c                	ld	a5,88(a0)
    80002048:	6fc8                	ld	a0,152(a5)
    8000204a:	bfe9                	j	80002024 <argraw+0x30>
  panic("argraw");
    8000204c:	00006517          	auipc	a0,0x6
    80002050:	31450513          	addi	a0,a0,788 # 80008360 <states.1739+0x148>
    80002054:	00004097          	auipc	ra,0x4
    80002058:	f74080e7          	jalr	-140(ra) # 80005fc8 <panic>

000000008000205c <fetchaddr>:
{
    8000205c:	1101                	addi	sp,sp,-32
    8000205e:	ec06                	sd	ra,24(sp)
    80002060:	e822                	sd	s0,16(sp)
    80002062:	e426                	sd	s1,8(sp)
    80002064:	e04a                	sd	s2,0(sp)
    80002066:	1000                	addi	s0,sp,32
    80002068:	84aa                	mv	s1,a0
    8000206a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	dc2080e7          	jalr	-574(ra) # 80000e2e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002074:	653c                	ld	a5,72(a0)
    80002076:	02f4f863          	bgeu	s1,a5,800020a6 <fetchaddr+0x4a>
    8000207a:	00848713          	addi	a4,s1,8
    8000207e:	02e7e663          	bltu	a5,a4,800020aa <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002082:	46a1                	li	a3,8
    80002084:	8626                	mv	a2,s1
    80002086:	85ca                	mv	a1,s2
    80002088:	6928                	ld	a0,80(a0)
    8000208a:	fffff097          	auipc	ra,0xfffff
    8000208e:	af2080e7          	jalr	-1294(ra) # 80000b7c <copyin>
    80002092:	00a03533          	snez	a0,a0
    80002096:	40a00533          	neg	a0,a0
}
    8000209a:	60e2                	ld	ra,24(sp)
    8000209c:	6442                	ld	s0,16(sp)
    8000209e:	64a2                	ld	s1,8(sp)
    800020a0:	6902                	ld	s2,0(sp)
    800020a2:	6105                	addi	sp,sp,32
    800020a4:	8082                	ret
    return -1;
    800020a6:	557d                	li	a0,-1
    800020a8:	bfcd                	j	8000209a <fetchaddr+0x3e>
    800020aa:	557d                	li	a0,-1
    800020ac:	b7fd                	j	8000209a <fetchaddr+0x3e>

00000000800020ae <fetchstr>:
{
    800020ae:	7179                	addi	sp,sp,-48
    800020b0:	f406                	sd	ra,40(sp)
    800020b2:	f022                	sd	s0,32(sp)
    800020b4:	ec26                	sd	s1,24(sp)
    800020b6:	e84a                	sd	s2,16(sp)
    800020b8:	e44e                	sd	s3,8(sp)
    800020ba:	1800                	addi	s0,sp,48
    800020bc:	892a                	mv	s2,a0
    800020be:	84ae                	mv	s1,a1
    800020c0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020c2:	fffff097          	auipc	ra,0xfffff
    800020c6:	d6c080e7          	jalr	-660(ra) # 80000e2e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020ca:	86ce                	mv	a3,s3
    800020cc:	864a                	mv	a2,s2
    800020ce:	85a6                	mv	a1,s1
    800020d0:	6928                	ld	a0,80(a0)
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	b36080e7          	jalr	-1226(ra) # 80000c08 <copyinstr>
  if(err < 0)
    800020da:	00054763          	bltz	a0,800020e8 <fetchstr+0x3a>
  return strlen(buf);
    800020de:	8526                	mv	a0,s1
    800020e0:	ffffe097          	auipc	ra,0xffffe
    800020e4:	21c080e7          	jalr	540(ra) # 800002fc <strlen>
}
    800020e8:	70a2                	ld	ra,40(sp)
    800020ea:	7402                	ld	s0,32(sp)
    800020ec:	64e2                	ld	s1,24(sp)
    800020ee:	6942                	ld	s2,16(sp)
    800020f0:	69a2                	ld	s3,8(sp)
    800020f2:	6145                	addi	sp,sp,48
    800020f4:	8082                	ret

00000000800020f6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	e426                	sd	s1,8(sp)
    800020fe:	1000                	addi	s0,sp,32
    80002100:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002102:	00000097          	auipc	ra,0x0
    80002106:	ef2080e7          	jalr	-270(ra) # 80001ff4 <argraw>
    8000210a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000210c:	4501                	li	a0,0
    8000210e:	60e2                	ld	ra,24(sp)
    80002110:	6442                	ld	s0,16(sp)
    80002112:	64a2                	ld	s1,8(sp)
    80002114:	6105                	addi	sp,sp,32
    80002116:	8082                	ret

0000000080002118 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	e426                	sd	s1,8(sp)
    80002120:	1000                	addi	s0,sp,32
    80002122:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002124:	00000097          	auipc	ra,0x0
    80002128:	ed0080e7          	jalr	-304(ra) # 80001ff4 <argraw>
    8000212c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000212e:	4501                	li	a0,0
    80002130:	60e2                	ld	ra,24(sp)
    80002132:	6442                	ld	s0,16(sp)
    80002134:	64a2                	ld	s1,8(sp)
    80002136:	6105                	addi	sp,sp,32
    80002138:	8082                	ret

000000008000213a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000213a:	1101                	addi	sp,sp,-32
    8000213c:	ec06                	sd	ra,24(sp)
    8000213e:	e822                	sd	s0,16(sp)
    80002140:	e426                	sd	s1,8(sp)
    80002142:	e04a                	sd	s2,0(sp)
    80002144:	1000                	addi	s0,sp,32
    80002146:	84ae                	mv	s1,a1
    80002148:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000214a:	00000097          	auipc	ra,0x0
    8000214e:	eaa080e7          	jalr	-342(ra) # 80001ff4 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002152:	864a                	mv	a2,s2
    80002154:	85a6                	mv	a1,s1
    80002156:	00000097          	auipc	ra,0x0
    8000215a:	f58080e7          	jalr	-168(ra) # 800020ae <fetchstr>
}
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	64a2                	ld	s1,8(sp)
    80002164:	6902                	ld	s2,0(sp)
    80002166:	6105                	addi	sp,sp,32
    80002168:	8082                	ret

000000008000216a <syscall>:
[SYS_munmap]  sys_munmap,
};

void
syscall(void)
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	e426                	sd	s1,8(sp)
    80002172:	e04a                	sd	s2,0(sp)
    80002174:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	cb8080e7          	jalr	-840(ra) # 80000e2e <myproc>
    8000217e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002180:	05853903          	ld	s2,88(a0)
    80002184:	0a893783          	ld	a5,168(s2)
    80002188:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000218c:	37fd                	addiw	a5,a5,-1
    8000218e:	4759                	li	a4,22
    80002190:	00f76f63          	bltu	a4,a5,800021ae <syscall+0x44>
    80002194:	00369713          	slli	a4,a3,0x3
    80002198:	00006797          	auipc	a5,0x6
    8000219c:	20878793          	addi	a5,a5,520 # 800083a0 <syscalls>
    800021a0:	97ba                	add	a5,a5,a4
    800021a2:	639c                	ld	a5,0(a5)
    800021a4:	c789                	beqz	a5,800021ae <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021a6:	9782                	jalr	a5
    800021a8:	06a93823          	sd	a0,112(s2)
    800021ac:	a839                	j	800021ca <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021ae:	15848613          	addi	a2,s1,344
    800021b2:	588c                	lw	a1,48(s1)
    800021b4:	00006517          	auipc	a0,0x6
    800021b8:	1b450513          	addi	a0,a0,436 # 80008368 <states.1739+0x150>
    800021bc:	00004097          	auipc	ra,0x4
    800021c0:	e56080e7          	jalr	-426(ra) # 80006012 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021c4:	6cbc                	ld	a5,88(s1)
    800021c6:	577d                	li	a4,-1
    800021c8:	fbb8                	sd	a4,112(a5)
  }
}
    800021ca:	60e2                	ld	ra,24(sp)
    800021cc:	6442                	ld	s0,16(sp)
    800021ce:	64a2                	ld	s1,8(sp)
    800021d0:	6902                	ld	s2,0(sp)
    800021d2:	6105                	addi	sp,sp,32
    800021d4:	8082                	ret

00000000800021d6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021d6:	1101                	addi	sp,sp,-32
    800021d8:	ec06                	sd	ra,24(sp)
    800021da:	e822                	sd	s0,16(sp)
    800021dc:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021de:	fec40593          	addi	a1,s0,-20
    800021e2:	4501                	li	a0,0
    800021e4:	00000097          	auipc	ra,0x0
    800021e8:	f12080e7          	jalr	-238(ra) # 800020f6 <argint>
    return -1;
    800021ec:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021ee:	00054963          	bltz	a0,80002200 <sys_exit+0x2a>
  exit(n);
    800021f2:	fec42503          	lw	a0,-20(s0)
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	5b2080e7          	jalr	1458(ra) # 800017a8 <exit>
  return 0;  // not reached
    800021fe:	4781                	li	a5,0
}
    80002200:	853e                	mv	a0,a5
    80002202:	60e2                	ld	ra,24(sp)
    80002204:	6442                	ld	s0,16(sp)
    80002206:	6105                	addi	sp,sp,32
    80002208:	8082                	ret

000000008000220a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000220a:	1141                	addi	sp,sp,-16
    8000220c:	e406                	sd	ra,8(sp)
    8000220e:	e022                	sd	s0,0(sp)
    80002210:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002212:	fffff097          	auipc	ra,0xfffff
    80002216:	c1c080e7          	jalr	-996(ra) # 80000e2e <myproc>
}
    8000221a:	5908                	lw	a0,48(a0)
    8000221c:	60a2                	ld	ra,8(sp)
    8000221e:	6402                	ld	s0,0(sp)
    80002220:	0141                	addi	sp,sp,16
    80002222:	8082                	ret

0000000080002224 <sys_fork>:

uint64
sys_fork(void)
{
    80002224:	1141                	addi	sp,sp,-16
    80002226:	e406                	sd	ra,8(sp)
    80002228:	e022                	sd	s0,0(sp)
    8000222a:	0800                	addi	s0,sp,16
  return fork();
    8000222c:	fffff097          	auipc	ra,0xfffff
    80002230:	fe8080e7          	jalr	-24(ra) # 80001214 <fork>
}
    80002234:	60a2                	ld	ra,8(sp)
    80002236:	6402                	ld	s0,0(sp)
    80002238:	0141                	addi	sp,sp,16
    8000223a:	8082                	ret

000000008000223c <sys_wait>:

uint64
sys_wait(void)
{
    8000223c:	1101                	addi	sp,sp,-32
    8000223e:	ec06                	sd	ra,24(sp)
    80002240:	e822                	sd	s0,16(sp)
    80002242:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002244:	fe840593          	addi	a1,s0,-24
    80002248:	4501                	li	a0,0
    8000224a:	00000097          	auipc	ra,0x0
    8000224e:	ece080e7          	jalr	-306(ra) # 80002118 <argaddr>
    80002252:	87aa                	mv	a5,a0
    return -1;
    80002254:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002256:	0007c863          	bltz	a5,80002266 <sys_wait+0x2a>
  return wait(p);
    8000225a:	fe843503          	ld	a0,-24(s0)
    8000225e:	fffff097          	auipc	ra,0xfffff
    80002262:	352080e7          	jalr	850(ra) # 800015b0 <wait>
}
    80002266:	60e2                	ld	ra,24(sp)
    80002268:	6442                	ld	s0,16(sp)
    8000226a:	6105                	addi	sp,sp,32
    8000226c:	8082                	ret

000000008000226e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000226e:	7179                	addi	sp,sp,-48
    80002270:	f406                	sd	ra,40(sp)
    80002272:	f022                	sd	s0,32(sp)
    80002274:	ec26                	sd	s1,24(sp)
    80002276:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002278:	fdc40593          	addi	a1,s0,-36
    8000227c:	4501                	li	a0,0
    8000227e:	00000097          	auipc	ra,0x0
    80002282:	e78080e7          	jalr	-392(ra) # 800020f6 <argint>
    80002286:	87aa                	mv	a5,a0
    return -1;
    80002288:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000228a:	0207c063          	bltz	a5,800022aa <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	ba0080e7          	jalr	-1120(ra) # 80000e2e <myproc>
    80002296:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002298:	fdc42503          	lw	a0,-36(s0)
    8000229c:	fffff097          	auipc	ra,0xfffff
    800022a0:	f04080e7          	jalr	-252(ra) # 800011a0 <growproc>
    800022a4:	00054863          	bltz	a0,800022b4 <sys_sbrk+0x46>
    return -1;
  return addr;
    800022a8:	8526                	mv	a0,s1
}
    800022aa:	70a2                	ld	ra,40(sp)
    800022ac:	7402                	ld	s0,32(sp)
    800022ae:	64e2                	ld	s1,24(sp)
    800022b0:	6145                	addi	sp,sp,48
    800022b2:	8082                	ret
    return -1;
    800022b4:	557d                	li	a0,-1
    800022b6:	bfd5                	j	800022aa <sys_sbrk+0x3c>

00000000800022b8 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022b8:	7139                	addi	sp,sp,-64
    800022ba:	fc06                	sd	ra,56(sp)
    800022bc:	f822                	sd	s0,48(sp)
    800022be:	f426                	sd	s1,40(sp)
    800022c0:	f04a                	sd	s2,32(sp)
    800022c2:	ec4e                	sd	s3,24(sp)
    800022c4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800022c6:	fcc40593          	addi	a1,s0,-52
    800022ca:	4501                	li	a0,0
    800022cc:	00000097          	auipc	ra,0x0
    800022d0:	e2a080e7          	jalr	-470(ra) # 800020f6 <argint>
    return -1;
    800022d4:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022d6:	06054563          	bltz	a0,80002340 <sys_sleep+0x88>
  acquire(&tickslock);
    800022da:	00017517          	auipc	a0,0x17
    800022de:	ba650513          	addi	a0,a0,-1114 # 80018e80 <tickslock>
    800022e2:	00004097          	auipc	ra,0x4
    800022e6:	230080e7          	jalr	560(ra) # 80006512 <acquire>
  ticks0 = ticks;
    800022ea:	00007917          	auipc	s2,0x7
    800022ee:	d2e92903          	lw	s2,-722(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022f2:	fcc42783          	lw	a5,-52(s0)
    800022f6:	cf85                	beqz	a5,8000232e <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022f8:	00017997          	auipc	s3,0x17
    800022fc:	b8898993          	addi	s3,s3,-1144 # 80018e80 <tickslock>
    80002300:	00007497          	auipc	s1,0x7
    80002304:	d1848493          	addi	s1,s1,-744 # 80009018 <ticks>
    if(myproc()->killed){
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	b26080e7          	jalr	-1242(ra) # 80000e2e <myproc>
    80002310:	551c                	lw	a5,40(a0)
    80002312:	ef9d                	bnez	a5,80002350 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002314:	85ce                	mv	a1,s3
    80002316:	8526                	mv	a0,s1
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	234080e7          	jalr	564(ra) # 8000154c <sleep>
  while(ticks - ticks0 < n){
    80002320:	409c                	lw	a5,0(s1)
    80002322:	412787bb          	subw	a5,a5,s2
    80002326:	fcc42703          	lw	a4,-52(s0)
    8000232a:	fce7efe3          	bltu	a5,a4,80002308 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000232e:	00017517          	auipc	a0,0x17
    80002332:	b5250513          	addi	a0,a0,-1198 # 80018e80 <tickslock>
    80002336:	00004097          	auipc	ra,0x4
    8000233a:	290080e7          	jalr	656(ra) # 800065c6 <release>
  return 0;
    8000233e:	4781                	li	a5,0
}
    80002340:	853e                	mv	a0,a5
    80002342:	70e2                	ld	ra,56(sp)
    80002344:	7442                	ld	s0,48(sp)
    80002346:	74a2                	ld	s1,40(sp)
    80002348:	7902                	ld	s2,32(sp)
    8000234a:	69e2                	ld	s3,24(sp)
    8000234c:	6121                	addi	sp,sp,64
    8000234e:	8082                	ret
      release(&tickslock);
    80002350:	00017517          	auipc	a0,0x17
    80002354:	b3050513          	addi	a0,a0,-1232 # 80018e80 <tickslock>
    80002358:	00004097          	auipc	ra,0x4
    8000235c:	26e080e7          	jalr	622(ra) # 800065c6 <release>
      return -1;
    80002360:	57fd                	li	a5,-1
    80002362:	bff9                	j	80002340 <sys_sleep+0x88>

0000000080002364 <sys_kill>:

uint64
sys_kill(void)
{
    80002364:	1101                	addi	sp,sp,-32
    80002366:	ec06                	sd	ra,24(sp)
    80002368:	e822                	sd	s0,16(sp)
    8000236a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000236c:	fec40593          	addi	a1,s0,-20
    80002370:	4501                	li	a0,0
    80002372:	00000097          	auipc	ra,0x0
    80002376:	d84080e7          	jalr	-636(ra) # 800020f6 <argint>
    8000237a:	87aa                	mv	a5,a0
    return -1;
    8000237c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000237e:	0007c863          	bltz	a5,8000238e <sys_kill+0x2a>
  return kill(pid);
    80002382:	fec42503          	lw	a0,-20(s0)
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	532080e7          	jalr	1330(ra) # 800018b8 <kill>
}
    8000238e:	60e2                	ld	ra,24(sp)
    80002390:	6442                	ld	s0,16(sp)
    80002392:	6105                	addi	sp,sp,32
    80002394:	8082                	ret

0000000080002396 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002396:	1101                	addi	sp,sp,-32
    80002398:	ec06                	sd	ra,24(sp)
    8000239a:	e822                	sd	s0,16(sp)
    8000239c:	e426                	sd	s1,8(sp)
    8000239e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800023a0:	00017517          	auipc	a0,0x17
    800023a4:	ae050513          	addi	a0,a0,-1312 # 80018e80 <tickslock>
    800023a8:	00004097          	auipc	ra,0x4
    800023ac:	16a080e7          	jalr	362(ra) # 80006512 <acquire>
  xticks = ticks;
    800023b0:	00007497          	auipc	s1,0x7
    800023b4:	c684a483          	lw	s1,-920(s1) # 80009018 <ticks>
  release(&tickslock);
    800023b8:	00017517          	auipc	a0,0x17
    800023bc:	ac850513          	addi	a0,a0,-1336 # 80018e80 <tickslock>
    800023c0:	00004097          	auipc	ra,0x4
    800023c4:	206080e7          	jalr	518(ra) # 800065c6 <release>
  return xticks;
}
    800023c8:	02049513          	slli	a0,s1,0x20
    800023cc:	9101                	srli	a0,a0,0x20
    800023ce:	60e2                	ld	ra,24(sp)
    800023d0:	6442                	ld	s0,16(sp)
    800023d2:	64a2                	ld	s1,8(sp)
    800023d4:	6105                	addi	sp,sp,32
    800023d6:	8082                	ret

00000000800023d8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023d8:	7179                	addi	sp,sp,-48
    800023da:	f406                	sd	ra,40(sp)
    800023dc:	f022                	sd	s0,32(sp)
    800023de:	ec26                	sd	s1,24(sp)
    800023e0:	e84a                	sd	s2,16(sp)
    800023e2:	e44e                	sd	s3,8(sp)
    800023e4:	e052                	sd	s4,0(sp)
    800023e6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023e8:	00006597          	auipc	a1,0x6
    800023ec:	07858593          	addi	a1,a1,120 # 80008460 <syscalls+0xc0>
    800023f0:	00017517          	auipc	a0,0x17
    800023f4:	aa850513          	addi	a0,a0,-1368 # 80018e98 <bcache>
    800023f8:	00004097          	auipc	ra,0x4
    800023fc:	08a080e7          	jalr	138(ra) # 80006482 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002400:	0001f797          	auipc	a5,0x1f
    80002404:	a9878793          	addi	a5,a5,-1384 # 80020e98 <bcache+0x8000>
    80002408:	0001f717          	auipc	a4,0x1f
    8000240c:	cf870713          	addi	a4,a4,-776 # 80021100 <bcache+0x8268>
    80002410:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002414:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002418:	00017497          	auipc	s1,0x17
    8000241c:	a9848493          	addi	s1,s1,-1384 # 80018eb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002420:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002422:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002424:	00006a17          	auipc	s4,0x6
    80002428:	044a0a13          	addi	s4,s4,68 # 80008468 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000242c:	2b893783          	ld	a5,696(s2)
    80002430:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002432:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002436:	85d2                	mv	a1,s4
    80002438:	01048513          	addi	a0,s1,16
    8000243c:	00001097          	auipc	ra,0x1
    80002440:	4bc080e7          	jalr	1212(ra) # 800038f8 <initsleeplock>
    bcache.head.next->prev = b;
    80002444:	2b893783          	ld	a5,696(s2)
    80002448:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000244a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000244e:	45848493          	addi	s1,s1,1112
    80002452:	fd349de3          	bne	s1,s3,8000242c <binit+0x54>
  }
}
    80002456:	70a2                	ld	ra,40(sp)
    80002458:	7402                	ld	s0,32(sp)
    8000245a:	64e2                	ld	s1,24(sp)
    8000245c:	6942                	ld	s2,16(sp)
    8000245e:	69a2                	ld	s3,8(sp)
    80002460:	6a02                	ld	s4,0(sp)
    80002462:	6145                	addi	sp,sp,48
    80002464:	8082                	ret

0000000080002466 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002466:	7179                	addi	sp,sp,-48
    80002468:	f406                	sd	ra,40(sp)
    8000246a:	f022                	sd	s0,32(sp)
    8000246c:	ec26                	sd	s1,24(sp)
    8000246e:	e84a                	sd	s2,16(sp)
    80002470:	e44e                	sd	s3,8(sp)
    80002472:	1800                	addi	s0,sp,48
    80002474:	89aa                	mv	s3,a0
    80002476:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002478:	00017517          	auipc	a0,0x17
    8000247c:	a2050513          	addi	a0,a0,-1504 # 80018e98 <bcache>
    80002480:	00004097          	auipc	ra,0x4
    80002484:	092080e7          	jalr	146(ra) # 80006512 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002488:	0001f497          	auipc	s1,0x1f
    8000248c:	cc84b483          	ld	s1,-824(s1) # 80021150 <bcache+0x82b8>
    80002490:	0001f797          	auipc	a5,0x1f
    80002494:	c7078793          	addi	a5,a5,-912 # 80021100 <bcache+0x8268>
    80002498:	02f48f63          	beq	s1,a5,800024d6 <bread+0x70>
    8000249c:	873e                	mv	a4,a5
    8000249e:	a021                	j	800024a6 <bread+0x40>
    800024a0:	68a4                	ld	s1,80(s1)
    800024a2:	02e48a63          	beq	s1,a4,800024d6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024a6:	449c                	lw	a5,8(s1)
    800024a8:	ff379ce3          	bne	a5,s3,800024a0 <bread+0x3a>
    800024ac:	44dc                	lw	a5,12(s1)
    800024ae:	ff2799e3          	bne	a5,s2,800024a0 <bread+0x3a>
      b->refcnt++;
    800024b2:	40bc                	lw	a5,64(s1)
    800024b4:	2785                	addiw	a5,a5,1
    800024b6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024b8:	00017517          	auipc	a0,0x17
    800024bc:	9e050513          	addi	a0,a0,-1568 # 80018e98 <bcache>
    800024c0:	00004097          	auipc	ra,0x4
    800024c4:	106080e7          	jalr	262(ra) # 800065c6 <release>
      acquiresleep(&b->lock);
    800024c8:	01048513          	addi	a0,s1,16
    800024cc:	00001097          	auipc	ra,0x1
    800024d0:	466080e7          	jalr	1126(ra) # 80003932 <acquiresleep>
      return b;
    800024d4:	a8b9                	j	80002532 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024d6:	0001f497          	auipc	s1,0x1f
    800024da:	c724b483          	ld	s1,-910(s1) # 80021148 <bcache+0x82b0>
    800024de:	0001f797          	auipc	a5,0x1f
    800024e2:	c2278793          	addi	a5,a5,-990 # 80021100 <bcache+0x8268>
    800024e6:	00f48863          	beq	s1,a5,800024f6 <bread+0x90>
    800024ea:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024ec:	40bc                	lw	a5,64(s1)
    800024ee:	cf81                	beqz	a5,80002506 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024f0:	64a4                	ld	s1,72(s1)
    800024f2:	fee49de3          	bne	s1,a4,800024ec <bread+0x86>
  panic("bget: no buffers");
    800024f6:	00006517          	auipc	a0,0x6
    800024fa:	f7a50513          	addi	a0,a0,-134 # 80008470 <syscalls+0xd0>
    800024fe:	00004097          	auipc	ra,0x4
    80002502:	aca080e7          	jalr	-1334(ra) # 80005fc8 <panic>
      b->dev = dev;
    80002506:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000250a:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000250e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002512:	4785                	li	a5,1
    80002514:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002516:	00017517          	auipc	a0,0x17
    8000251a:	98250513          	addi	a0,a0,-1662 # 80018e98 <bcache>
    8000251e:	00004097          	auipc	ra,0x4
    80002522:	0a8080e7          	jalr	168(ra) # 800065c6 <release>
      acquiresleep(&b->lock);
    80002526:	01048513          	addi	a0,s1,16
    8000252a:	00001097          	auipc	ra,0x1
    8000252e:	408080e7          	jalr	1032(ra) # 80003932 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002532:	409c                	lw	a5,0(s1)
    80002534:	cb89                	beqz	a5,80002546 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002536:	8526                	mv	a0,s1
    80002538:	70a2                	ld	ra,40(sp)
    8000253a:	7402                	ld	s0,32(sp)
    8000253c:	64e2                	ld	s1,24(sp)
    8000253e:	6942                	ld	s2,16(sp)
    80002540:	69a2                	ld	s3,8(sp)
    80002542:	6145                	addi	sp,sp,48
    80002544:	8082                	ret
    virtio_disk_rw(b, 0);
    80002546:	4581                	li	a1,0
    80002548:	8526                	mv	a0,s1
    8000254a:	00003097          	auipc	ra,0x3
    8000254e:	1bc080e7          	jalr	444(ra) # 80005706 <virtio_disk_rw>
    b->valid = 1;
    80002552:	4785                	li	a5,1
    80002554:	c09c                	sw	a5,0(s1)
  return b;
    80002556:	b7c5                	j	80002536 <bread+0xd0>

0000000080002558 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002558:	1101                	addi	sp,sp,-32
    8000255a:	ec06                	sd	ra,24(sp)
    8000255c:	e822                	sd	s0,16(sp)
    8000255e:	e426                	sd	s1,8(sp)
    80002560:	1000                	addi	s0,sp,32
    80002562:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002564:	0541                	addi	a0,a0,16
    80002566:	00001097          	auipc	ra,0x1
    8000256a:	466080e7          	jalr	1126(ra) # 800039cc <holdingsleep>
    8000256e:	cd01                	beqz	a0,80002586 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002570:	4585                	li	a1,1
    80002572:	8526                	mv	a0,s1
    80002574:	00003097          	auipc	ra,0x3
    80002578:	192080e7          	jalr	402(ra) # 80005706 <virtio_disk_rw>
}
    8000257c:	60e2                	ld	ra,24(sp)
    8000257e:	6442                	ld	s0,16(sp)
    80002580:	64a2                	ld	s1,8(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret
    panic("bwrite");
    80002586:	00006517          	auipc	a0,0x6
    8000258a:	f0250513          	addi	a0,a0,-254 # 80008488 <syscalls+0xe8>
    8000258e:	00004097          	auipc	ra,0x4
    80002592:	a3a080e7          	jalr	-1478(ra) # 80005fc8 <panic>

0000000080002596 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002596:	1101                	addi	sp,sp,-32
    80002598:	ec06                	sd	ra,24(sp)
    8000259a:	e822                	sd	s0,16(sp)
    8000259c:	e426                	sd	s1,8(sp)
    8000259e:	e04a                	sd	s2,0(sp)
    800025a0:	1000                	addi	s0,sp,32
    800025a2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a4:	01050913          	addi	s2,a0,16
    800025a8:	854a                	mv	a0,s2
    800025aa:	00001097          	auipc	ra,0x1
    800025ae:	422080e7          	jalr	1058(ra) # 800039cc <holdingsleep>
    800025b2:	c92d                	beqz	a0,80002624 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025b4:	854a                	mv	a0,s2
    800025b6:	00001097          	auipc	ra,0x1
    800025ba:	3d2080e7          	jalr	978(ra) # 80003988 <releasesleep>

  acquire(&bcache.lock);
    800025be:	00017517          	auipc	a0,0x17
    800025c2:	8da50513          	addi	a0,a0,-1830 # 80018e98 <bcache>
    800025c6:	00004097          	auipc	ra,0x4
    800025ca:	f4c080e7          	jalr	-180(ra) # 80006512 <acquire>
  b->refcnt--;
    800025ce:	40bc                	lw	a5,64(s1)
    800025d0:	37fd                	addiw	a5,a5,-1
    800025d2:	0007871b          	sext.w	a4,a5
    800025d6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025d8:	eb05                	bnez	a4,80002608 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025da:	68bc                	ld	a5,80(s1)
    800025dc:	64b8                	ld	a4,72(s1)
    800025de:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025e0:	64bc                	ld	a5,72(s1)
    800025e2:	68b8                	ld	a4,80(s1)
    800025e4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025e6:	0001f797          	auipc	a5,0x1f
    800025ea:	8b278793          	addi	a5,a5,-1870 # 80020e98 <bcache+0x8000>
    800025ee:	2b87b703          	ld	a4,696(a5)
    800025f2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025f4:	0001f717          	auipc	a4,0x1f
    800025f8:	b0c70713          	addi	a4,a4,-1268 # 80021100 <bcache+0x8268>
    800025fc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025fe:	2b87b703          	ld	a4,696(a5)
    80002602:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002604:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002608:	00017517          	auipc	a0,0x17
    8000260c:	89050513          	addi	a0,a0,-1904 # 80018e98 <bcache>
    80002610:	00004097          	auipc	ra,0x4
    80002614:	fb6080e7          	jalr	-74(ra) # 800065c6 <release>
}
    80002618:	60e2                	ld	ra,24(sp)
    8000261a:	6442                	ld	s0,16(sp)
    8000261c:	64a2                	ld	s1,8(sp)
    8000261e:	6902                	ld	s2,0(sp)
    80002620:	6105                	addi	sp,sp,32
    80002622:	8082                	ret
    panic("brelse");
    80002624:	00006517          	auipc	a0,0x6
    80002628:	e6c50513          	addi	a0,a0,-404 # 80008490 <syscalls+0xf0>
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	99c080e7          	jalr	-1636(ra) # 80005fc8 <panic>

0000000080002634 <bpin>:

void
bpin(struct buf *b) {
    80002634:	1101                	addi	sp,sp,-32
    80002636:	ec06                	sd	ra,24(sp)
    80002638:	e822                	sd	s0,16(sp)
    8000263a:	e426                	sd	s1,8(sp)
    8000263c:	1000                	addi	s0,sp,32
    8000263e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002640:	00017517          	auipc	a0,0x17
    80002644:	85850513          	addi	a0,a0,-1960 # 80018e98 <bcache>
    80002648:	00004097          	auipc	ra,0x4
    8000264c:	eca080e7          	jalr	-310(ra) # 80006512 <acquire>
  b->refcnt++;
    80002650:	40bc                	lw	a5,64(s1)
    80002652:	2785                	addiw	a5,a5,1
    80002654:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002656:	00017517          	auipc	a0,0x17
    8000265a:	84250513          	addi	a0,a0,-1982 # 80018e98 <bcache>
    8000265e:	00004097          	auipc	ra,0x4
    80002662:	f68080e7          	jalr	-152(ra) # 800065c6 <release>
}
    80002666:	60e2                	ld	ra,24(sp)
    80002668:	6442                	ld	s0,16(sp)
    8000266a:	64a2                	ld	s1,8(sp)
    8000266c:	6105                	addi	sp,sp,32
    8000266e:	8082                	ret

0000000080002670 <bunpin>:

void
bunpin(struct buf *b) {
    80002670:	1101                	addi	sp,sp,-32
    80002672:	ec06                	sd	ra,24(sp)
    80002674:	e822                	sd	s0,16(sp)
    80002676:	e426                	sd	s1,8(sp)
    80002678:	1000                	addi	s0,sp,32
    8000267a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000267c:	00017517          	auipc	a0,0x17
    80002680:	81c50513          	addi	a0,a0,-2020 # 80018e98 <bcache>
    80002684:	00004097          	auipc	ra,0x4
    80002688:	e8e080e7          	jalr	-370(ra) # 80006512 <acquire>
  b->refcnt--;
    8000268c:	40bc                	lw	a5,64(s1)
    8000268e:	37fd                	addiw	a5,a5,-1
    80002690:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002692:	00017517          	auipc	a0,0x17
    80002696:	80650513          	addi	a0,a0,-2042 # 80018e98 <bcache>
    8000269a:	00004097          	auipc	ra,0x4
    8000269e:	f2c080e7          	jalr	-212(ra) # 800065c6 <release>
}
    800026a2:	60e2                	ld	ra,24(sp)
    800026a4:	6442                	ld	s0,16(sp)
    800026a6:	64a2                	ld	s1,8(sp)
    800026a8:	6105                	addi	sp,sp,32
    800026aa:	8082                	ret

00000000800026ac <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026ac:	1101                	addi	sp,sp,-32
    800026ae:	ec06                	sd	ra,24(sp)
    800026b0:	e822                	sd	s0,16(sp)
    800026b2:	e426                	sd	s1,8(sp)
    800026b4:	e04a                	sd	s2,0(sp)
    800026b6:	1000                	addi	s0,sp,32
    800026b8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026ba:	00d5d59b          	srliw	a1,a1,0xd
    800026be:	0001f797          	auipc	a5,0x1f
    800026c2:	eb67a783          	lw	a5,-330(a5) # 80021574 <sb+0x1c>
    800026c6:	9dbd                	addw	a1,a1,a5
    800026c8:	00000097          	auipc	ra,0x0
    800026cc:	d9e080e7          	jalr	-610(ra) # 80002466 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026d0:	0074f713          	andi	a4,s1,7
    800026d4:	4785                	li	a5,1
    800026d6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026da:	14ce                	slli	s1,s1,0x33
    800026dc:	90d9                	srli	s1,s1,0x36
    800026de:	00950733          	add	a4,a0,s1
    800026e2:	05874703          	lbu	a4,88(a4)
    800026e6:	00e7f6b3          	and	a3,a5,a4
    800026ea:	c69d                	beqz	a3,80002718 <bfree+0x6c>
    800026ec:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026ee:	94aa                	add	s1,s1,a0
    800026f0:	fff7c793          	not	a5,a5
    800026f4:	8ff9                	and	a5,a5,a4
    800026f6:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026fa:	00001097          	auipc	ra,0x1
    800026fe:	118080e7          	jalr	280(ra) # 80003812 <log_write>
  brelse(bp);
    80002702:	854a                	mv	a0,s2
    80002704:	00000097          	auipc	ra,0x0
    80002708:	e92080e7          	jalr	-366(ra) # 80002596 <brelse>
}
    8000270c:	60e2                	ld	ra,24(sp)
    8000270e:	6442                	ld	s0,16(sp)
    80002710:	64a2                	ld	s1,8(sp)
    80002712:	6902                	ld	s2,0(sp)
    80002714:	6105                	addi	sp,sp,32
    80002716:	8082                	ret
    panic("freeing free block");
    80002718:	00006517          	auipc	a0,0x6
    8000271c:	d8050513          	addi	a0,a0,-640 # 80008498 <syscalls+0xf8>
    80002720:	00004097          	auipc	ra,0x4
    80002724:	8a8080e7          	jalr	-1880(ra) # 80005fc8 <panic>

0000000080002728 <balloc>:
{
    80002728:	711d                	addi	sp,sp,-96
    8000272a:	ec86                	sd	ra,88(sp)
    8000272c:	e8a2                	sd	s0,80(sp)
    8000272e:	e4a6                	sd	s1,72(sp)
    80002730:	e0ca                	sd	s2,64(sp)
    80002732:	fc4e                	sd	s3,56(sp)
    80002734:	f852                	sd	s4,48(sp)
    80002736:	f456                	sd	s5,40(sp)
    80002738:	f05a                	sd	s6,32(sp)
    8000273a:	ec5e                	sd	s7,24(sp)
    8000273c:	e862                	sd	s8,16(sp)
    8000273e:	e466                	sd	s9,8(sp)
    80002740:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002742:	0001f797          	auipc	a5,0x1f
    80002746:	e1a7a783          	lw	a5,-486(a5) # 8002155c <sb+0x4>
    8000274a:	cbd1                	beqz	a5,800027de <balloc+0xb6>
    8000274c:	8baa                	mv	s7,a0
    8000274e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002750:	0001fb17          	auipc	s6,0x1f
    80002754:	e08b0b13          	addi	s6,s6,-504 # 80021558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002758:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000275a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000275e:	6c89                	lui	s9,0x2
    80002760:	a831                	j	8000277c <balloc+0x54>
    brelse(bp);
    80002762:	854a                	mv	a0,s2
    80002764:	00000097          	auipc	ra,0x0
    80002768:	e32080e7          	jalr	-462(ra) # 80002596 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000276c:	015c87bb          	addw	a5,s9,s5
    80002770:	00078a9b          	sext.w	s5,a5
    80002774:	004b2703          	lw	a4,4(s6)
    80002778:	06eaf363          	bgeu	s5,a4,800027de <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000277c:	41fad79b          	sraiw	a5,s5,0x1f
    80002780:	0137d79b          	srliw	a5,a5,0x13
    80002784:	015787bb          	addw	a5,a5,s5
    80002788:	40d7d79b          	sraiw	a5,a5,0xd
    8000278c:	01cb2583          	lw	a1,28(s6)
    80002790:	9dbd                	addw	a1,a1,a5
    80002792:	855e                	mv	a0,s7
    80002794:	00000097          	auipc	ra,0x0
    80002798:	cd2080e7          	jalr	-814(ra) # 80002466 <bread>
    8000279c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000279e:	004b2503          	lw	a0,4(s6)
    800027a2:	000a849b          	sext.w	s1,s5
    800027a6:	8662                	mv	a2,s8
    800027a8:	faa4fde3          	bgeu	s1,a0,80002762 <balloc+0x3a>
      m = 1 << (bi % 8);
    800027ac:	41f6579b          	sraiw	a5,a2,0x1f
    800027b0:	01d7d69b          	srliw	a3,a5,0x1d
    800027b4:	00c6873b          	addw	a4,a3,a2
    800027b8:	00777793          	andi	a5,a4,7
    800027bc:	9f95                	subw	a5,a5,a3
    800027be:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027c2:	4037571b          	sraiw	a4,a4,0x3
    800027c6:	00e906b3          	add	a3,s2,a4
    800027ca:	0586c683          	lbu	a3,88(a3)
    800027ce:	00d7f5b3          	and	a1,a5,a3
    800027d2:	cd91                	beqz	a1,800027ee <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027d4:	2605                	addiw	a2,a2,1
    800027d6:	2485                	addiw	s1,s1,1
    800027d8:	fd4618e3          	bne	a2,s4,800027a8 <balloc+0x80>
    800027dc:	b759                	j	80002762 <balloc+0x3a>
  panic("balloc: out of blocks");
    800027de:	00006517          	auipc	a0,0x6
    800027e2:	cd250513          	addi	a0,a0,-814 # 800084b0 <syscalls+0x110>
    800027e6:	00003097          	auipc	ra,0x3
    800027ea:	7e2080e7          	jalr	2018(ra) # 80005fc8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800027ee:	974a                	add	a4,a4,s2
    800027f0:	8fd5                	or	a5,a5,a3
    800027f2:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800027f6:	854a                	mv	a0,s2
    800027f8:	00001097          	auipc	ra,0x1
    800027fc:	01a080e7          	jalr	26(ra) # 80003812 <log_write>
        brelse(bp);
    80002800:	854a                	mv	a0,s2
    80002802:	00000097          	auipc	ra,0x0
    80002806:	d94080e7          	jalr	-620(ra) # 80002596 <brelse>
  bp = bread(dev, bno);
    8000280a:	85a6                	mv	a1,s1
    8000280c:	855e                	mv	a0,s7
    8000280e:	00000097          	auipc	ra,0x0
    80002812:	c58080e7          	jalr	-936(ra) # 80002466 <bread>
    80002816:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002818:	40000613          	li	a2,1024
    8000281c:	4581                	li	a1,0
    8000281e:	05850513          	addi	a0,a0,88
    80002822:	ffffe097          	auipc	ra,0xffffe
    80002826:	956080e7          	jalr	-1706(ra) # 80000178 <memset>
  log_write(bp);
    8000282a:	854a                	mv	a0,s2
    8000282c:	00001097          	auipc	ra,0x1
    80002830:	fe6080e7          	jalr	-26(ra) # 80003812 <log_write>
  brelse(bp);
    80002834:	854a                	mv	a0,s2
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	d60080e7          	jalr	-672(ra) # 80002596 <brelse>
}
    8000283e:	8526                	mv	a0,s1
    80002840:	60e6                	ld	ra,88(sp)
    80002842:	6446                	ld	s0,80(sp)
    80002844:	64a6                	ld	s1,72(sp)
    80002846:	6906                	ld	s2,64(sp)
    80002848:	79e2                	ld	s3,56(sp)
    8000284a:	7a42                	ld	s4,48(sp)
    8000284c:	7aa2                	ld	s5,40(sp)
    8000284e:	7b02                	ld	s6,32(sp)
    80002850:	6be2                	ld	s7,24(sp)
    80002852:	6c42                	ld	s8,16(sp)
    80002854:	6ca2                	ld	s9,8(sp)
    80002856:	6125                	addi	sp,sp,96
    80002858:	8082                	ret

000000008000285a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000285a:	7179                	addi	sp,sp,-48
    8000285c:	f406                	sd	ra,40(sp)
    8000285e:	f022                	sd	s0,32(sp)
    80002860:	ec26                	sd	s1,24(sp)
    80002862:	e84a                	sd	s2,16(sp)
    80002864:	e44e                	sd	s3,8(sp)
    80002866:	e052                	sd	s4,0(sp)
    80002868:	1800                	addi	s0,sp,48
    8000286a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000286c:	47ad                	li	a5,11
    8000286e:	04b7fe63          	bgeu	a5,a1,800028ca <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002872:	ff45849b          	addiw	s1,a1,-12
    80002876:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000287a:	0ff00793          	li	a5,255
    8000287e:	0ae7e363          	bltu	a5,a4,80002924 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002882:	08052583          	lw	a1,128(a0)
    80002886:	c5ad                	beqz	a1,800028f0 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002888:	00092503          	lw	a0,0(s2)
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	bda080e7          	jalr	-1062(ra) # 80002466 <bread>
    80002894:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002896:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000289a:	02049593          	slli	a1,s1,0x20
    8000289e:	9181                	srli	a1,a1,0x20
    800028a0:	058a                	slli	a1,a1,0x2
    800028a2:	00b784b3          	add	s1,a5,a1
    800028a6:	0004a983          	lw	s3,0(s1)
    800028aa:	04098d63          	beqz	s3,80002904 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800028ae:	8552                	mv	a0,s4
    800028b0:	00000097          	auipc	ra,0x0
    800028b4:	ce6080e7          	jalr	-794(ra) # 80002596 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028b8:	854e                	mv	a0,s3
    800028ba:	70a2                	ld	ra,40(sp)
    800028bc:	7402                	ld	s0,32(sp)
    800028be:	64e2                	ld	s1,24(sp)
    800028c0:	6942                	ld	s2,16(sp)
    800028c2:	69a2                	ld	s3,8(sp)
    800028c4:	6a02                	ld	s4,0(sp)
    800028c6:	6145                	addi	sp,sp,48
    800028c8:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800028ca:	02059493          	slli	s1,a1,0x20
    800028ce:	9081                	srli	s1,s1,0x20
    800028d0:	048a                	slli	s1,s1,0x2
    800028d2:	94aa                	add	s1,s1,a0
    800028d4:	0504a983          	lw	s3,80(s1)
    800028d8:	fe0990e3          	bnez	s3,800028b8 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800028dc:	4108                	lw	a0,0(a0)
    800028de:	00000097          	auipc	ra,0x0
    800028e2:	e4a080e7          	jalr	-438(ra) # 80002728 <balloc>
    800028e6:	0005099b          	sext.w	s3,a0
    800028ea:	0534a823          	sw	s3,80(s1)
    800028ee:	b7e9                	j	800028b8 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800028f0:	4108                	lw	a0,0(a0)
    800028f2:	00000097          	auipc	ra,0x0
    800028f6:	e36080e7          	jalr	-458(ra) # 80002728 <balloc>
    800028fa:	0005059b          	sext.w	a1,a0
    800028fe:	08b92023          	sw	a1,128(s2)
    80002902:	b759                	j	80002888 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002904:	00092503          	lw	a0,0(s2)
    80002908:	00000097          	auipc	ra,0x0
    8000290c:	e20080e7          	jalr	-480(ra) # 80002728 <balloc>
    80002910:	0005099b          	sext.w	s3,a0
    80002914:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002918:	8552                	mv	a0,s4
    8000291a:	00001097          	auipc	ra,0x1
    8000291e:	ef8080e7          	jalr	-264(ra) # 80003812 <log_write>
    80002922:	b771                	j	800028ae <bmap+0x54>
  panic("bmap: out of range");
    80002924:	00006517          	auipc	a0,0x6
    80002928:	ba450513          	addi	a0,a0,-1116 # 800084c8 <syscalls+0x128>
    8000292c:	00003097          	auipc	ra,0x3
    80002930:	69c080e7          	jalr	1692(ra) # 80005fc8 <panic>

0000000080002934 <iget>:
{
    80002934:	7179                	addi	sp,sp,-48
    80002936:	f406                	sd	ra,40(sp)
    80002938:	f022                	sd	s0,32(sp)
    8000293a:	ec26                	sd	s1,24(sp)
    8000293c:	e84a                	sd	s2,16(sp)
    8000293e:	e44e                	sd	s3,8(sp)
    80002940:	e052                	sd	s4,0(sp)
    80002942:	1800                	addi	s0,sp,48
    80002944:	89aa                	mv	s3,a0
    80002946:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002948:	0001f517          	auipc	a0,0x1f
    8000294c:	c3050513          	addi	a0,a0,-976 # 80021578 <itable>
    80002950:	00004097          	auipc	ra,0x4
    80002954:	bc2080e7          	jalr	-1086(ra) # 80006512 <acquire>
  empty = 0;
    80002958:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000295a:	0001f497          	auipc	s1,0x1f
    8000295e:	c3648493          	addi	s1,s1,-970 # 80021590 <itable+0x18>
    80002962:	00020697          	auipc	a3,0x20
    80002966:	6be68693          	addi	a3,a3,1726 # 80023020 <log>
    8000296a:	a039                	j	80002978 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000296c:	02090b63          	beqz	s2,800029a2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002970:	08848493          	addi	s1,s1,136
    80002974:	02d48a63          	beq	s1,a3,800029a8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002978:	449c                	lw	a5,8(s1)
    8000297a:	fef059e3          	blez	a5,8000296c <iget+0x38>
    8000297e:	4098                	lw	a4,0(s1)
    80002980:	ff3716e3          	bne	a4,s3,8000296c <iget+0x38>
    80002984:	40d8                	lw	a4,4(s1)
    80002986:	ff4713e3          	bne	a4,s4,8000296c <iget+0x38>
      ip->ref++;
    8000298a:	2785                	addiw	a5,a5,1
    8000298c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000298e:	0001f517          	auipc	a0,0x1f
    80002992:	bea50513          	addi	a0,a0,-1046 # 80021578 <itable>
    80002996:	00004097          	auipc	ra,0x4
    8000299a:	c30080e7          	jalr	-976(ra) # 800065c6 <release>
      return ip;
    8000299e:	8926                	mv	s2,s1
    800029a0:	a03d                	j	800029ce <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029a2:	f7f9                	bnez	a5,80002970 <iget+0x3c>
    800029a4:	8926                	mv	s2,s1
    800029a6:	b7e9                	j	80002970 <iget+0x3c>
  if(empty == 0)
    800029a8:	02090c63          	beqz	s2,800029e0 <iget+0xac>
  ip->dev = dev;
    800029ac:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029b0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029b4:	4785                	li	a5,1
    800029b6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029ba:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029be:	0001f517          	auipc	a0,0x1f
    800029c2:	bba50513          	addi	a0,a0,-1094 # 80021578 <itable>
    800029c6:	00004097          	auipc	ra,0x4
    800029ca:	c00080e7          	jalr	-1024(ra) # 800065c6 <release>
}
    800029ce:	854a                	mv	a0,s2
    800029d0:	70a2                	ld	ra,40(sp)
    800029d2:	7402                	ld	s0,32(sp)
    800029d4:	64e2                	ld	s1,24(sp)
    800029d6:	6942                	ld	s2,16(sp)
    800029d8:	69a2                	ld	s3,8(sp)
    800029da:	6a02                	ld	s4,0(sp)
    800029dc:	6145                	addi	sp,sp,48
    800029de:	8082                	ret
    panic("iget: no inodes");
    800029e0:	00006517          	auipc	a0,0x6
    800029e4:	b0050513          	addi	a0,a0,-1280 # 800084e0 <syscalls+0x140>
    800029e8:	00003097          	auipc	ra,0x3
    800029ec:	5e0080e7          	jalr	1504(ra) # 80005fc8 <panic>

00000000800029f0 <fsinit>:
fsinit(int dev) {
    800029f0:	7179                	addi	sp,sp,-48
    800029f2:	f406                	sd	ra,40(sp)
    800029f4:	f022                	sd	s0,32(sp)
    800029f6:	ec26                	sd	s1,24(sp)
    800029f8:	e84a                	sd	s2,16(sp)
    800029fa:	e44e                	sd	s3,8(sp)
    800029fc:	1800                	addi	s0,sp,48
    800029fe:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a00:	4585                	li	a1,1
    80002a02:	00000097          	auipc	ra,0x0
    80002a06:	a64080e7          	jalr	-1436(ra) # 80002466 <bread>
    80002a0a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a0c:	0001f997          	auipc	s3,0x1f
    80002a10:	b4c98993          	addi	s3,s3,-1204 # 80021558 <sb>
    80002a14:	02000613          	li	a2,32
    80002a18:	05850593          	addi	a1,a0,88
    80002a1c:	854e                	mv	a0,s3
    80002a1e:	ffffd097          	auipc	ra,0xffffd
    80002a22:	7ba080e7          	jalr	1978(ra) # 800001d8 <memmove>
  brelse(bp);
    80002a26:	8526                	mv	a0,s1
    80002a28:	00000097          	auipc	ra,0x0
    80002a2c:	b6e080e7          	jalr	-1170(ra) # 80002596 <brelse>
  if(sb.magic != FSMAGIC)
    80002a30:	0009a703          	lw	a4,0(s3)
    80002a34:	102037b7          	lui	a5,0x10203
    80002a38:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a3c:	02f71263          	bne	a4,a5,80002a60 <fsinit+0x70>
  initlog(dev, &sb);
    80002a40:	0001f597          	auipc	a1,0x1f
    80002a44:	b1858593          	addi	a1,a1,-1256 # 80021558 <sb>
    80002a48:	854a                	mv	a0,s2
    80002a4a:	00001097          	auipc	ra,0x1
    80002a4e:	b4c080e7          	jalr	-1204(ra) # 80003596 <initlog>
}
    80002a52:	70a2                	ld	ra,40(sp)
    80002a54:	7402                	ld	s0,32(sp)
    80002a56:	64e2                	ld	s1,24(sp)
    80002a58:	6942                	ld	s2,16(sp)
    80002a5a:	69a2                	ld	s3,8(sp)
    80002a5c:	6145                	addi	sp,sp,48
    80002a5e:	8082                	ret
    panic("invalid file system");
    80002a60:	00006517          	auipc	a0,0x6
    80002a64:	a9050513          	addi	a0,a0,-1392 # 800084f0 <syscalls+0x150>
    80002a68:	00003097          	auipc	ra,0x3
    80002a6c:	560080e7          	jalr	1376(ra) # 80005fc8 <panic>

0000000080002a70 <iinit>:
{
    80002a70:	7179                	addi	sp,sp,-48
    80002a72:	f406                	sd	ra,40(sp)
    80002a74:	f022                	sd	s0,32(sp)
    80002a76:	ec26                	sd	s1,24(sp)
    80002a78:	e84a                	sd	s2,16(sp)
    80002a7a:	e44e                	sd	s3,8(sp)
    80002a7c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a7e:	00006597          	auipc	a1,0x6
    80002a82:	a8a58593          	addi	a1,a1,-1398 # 80008508 <syscalls+0x168>
    80002a86:	0001f517          	auipc	a0,0x1f
    80002a8a:	af250513          	addi	a0,a0,-1294 # 80021578 <itable>
    80002a8e:	00004097          	auipc	ra,0x4
    80002a92:	9f4080e7          	jalr	-1548(ra) # 80006482 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a96:	0001f497          	auipc	s1,0x1f
    80002a9a:	b0a48493          	addi	s1,s1,-1270 # 800215a0 <itable+0x28>
    80002a9e:	00020997          	auipc	s3,0x20
    80002aa2:	59298993          	addi	s3,s3,1426 # 80023030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002aa6:	00006917          	auipc	s2,0x6
    80002aaa:	a6a90913          	addi	s2,s2,-1430 # 80008510 <syscalls+0x170>
    80002aae:	85ca                	mv	a1,s2
    80002ab0:	8526                	mv	a0,s1
    80002ab2:	00001097          	auipc	ra,0x1
    80002ab6:	e46080e7          	jalr	-442(ra) # 800038f8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002aba:	08848493          	addi	s1,s1,136
    80002abe:	ff3498e3          	bne	s1,s3,80002aae <iinit+0x3e>
}
    80002ac2:	70a2                	ld	ra,40(sp)
    80002ac4:	7402                	ld	s0,32(sp)
    80002ac6:	64e2                	ld	s1,24(sp)
    80002ac8:	6942                	ld	s2,16(sp)
    80002aca:	69a2                	ld	s3,8(sp)
    80002acc:	6145                	addi	sp,sp,48
    80002ace:	8082                	ret

0000000080002ad0 <ialloc>:
{
    80002ad0:	715d                	addi	sp,sp,-80
    80002ad2:	e486                	sd	ra,72(sp)
    80002ad4:	e0a2                	sd	s0,64(sp)
    80002ad6:	fc26                	sd	s1,56(sp)
    80002ad8:	f84a                	sd	s2,48(sp)
    80002ada:	f44e                	sd	s3,40(sp)
    80002adc:	f052                	sd	s4,32(sp)
    80002ade:	ec56                	sd	s5,24(sp)
    80002ae0:	e85a                	sd	s6,16(sp)
    80002ae2:	e45e                	sd	s7,8(sp)
    80002ae4:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ae6:	0001f717          	auipc	a4,0x1f
    80002aea:	a7e72703          	lw	a4,-1410(a4) # 80021564 <sb+0xc>
    80002aee:	4785                	li	a5,1
    80002af0:	04e7fa63          	bgeu	a5,a4,80002b44 <ialloc+0x74>
    80002af4:	8aaa                	mv	s5,a0
    80002af6:	8bae                	mv	s7,a1
    80002af8:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002afa:	0001fa17          	auipc	s4,0x1f
    80002afe:	a5ea0a13          	addi	s4,s4,-1442 # 80021558 <sb>
    80002b02:	00048b1b          	sext.w	s6,s1
    80002b06:	0044d593          	srli	a1,s1,0x4
    80002b0a:	018a2783          	lw	a5,24(s4)
    80002b0e:	9dbd                	addw	a1,a1,a5
    80002b10:	8556                	mv	a0,s5
    80002b12:	00000097          	auipc	ra,0x0
    80002b16:	954080e7          	jalr	-1708(ra) # 80002466 <bread>
    80002b1a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b1c:	05850993          	addi	s3,a0,88
    80002b20:	00f4f793          	andi	a5,s1,15
    80002b24:	079a                	slli	a5,a5,0x6
    80002b26:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b28:	00099783          	lh	a5,0(s3)
    80002b2c:	c785                	beqz	a5,80002b54 <ialloc+0x84>
    brelse(bp);
    80002b2e:	00000097          	auipc	ra,0x0
    80002b32:	a68080e7          	jalr	-1432(ra) # 80002596 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b36:	0485                	addi	s1,s1,1
    80002b38:	00ca2703          	lw	a4,12(s4)
    80002b3c:	0004879b          	sext.w	a5,s1
    80002b40:	fce7e1e3          	bltu	a5,a4,80002b02 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002b44:	00006517          	auipc	a0,0x6
    80002b48:	9d450513          	addi	a0,a0,-1580 # 80008518 <syscalls+0x178>
    80002b4c:	00003097          	auipc	ra,0x3
    80002b50:	47c080e7          	jalr	1148(ra) # 80005fc8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002b54:	04000613          	li	a2,64
    80002b58:	4581                	li	a1,0
    80002b5a:	854e                	mv	a0,s3
    80002b5c:	ffffd097          	auipc	ra,0xffffd
    80002b60:	61c080e7          	jalr	1564(ra) # 80000178 <memset>
      dip->type = type;
    80002b64:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b68:	854a                	mv	a0,s2
    80002b6a:	00001097          	auipc	ra,0x1
    80002b6e:	ca8080e7          	jalr	-856(ra) # 80003812 <log_write>
      brelse(bp);
    80002b72:	854a                	mv	a0,s2
    80002b74:	00000097          	auipc	ra,0x0
    80002b78:	a22080e7          	jalr	-1502(ra) # 80002596 <brelse>
      return iget(dev, inum);
    80002b7c:	85da                	mv	a1,s6
    80002b7e:	8556                	mv	a0,s5
    80002b80:	00000097          	auipc	ra,0x0
    80002b84:	db4080e7          	jalr	-588(ra) # 80002934 <iget>
}
    80002b88:	60a6                	ld	ra,72(sp)
    80002b8a:	6406                	ld	s0,64(sp)
    80002b8c:	74e2                	ld	s1,56(sp)
    80002b8e:	7942                	ld	s2,48(sp)
    80002b90:	79a2                	ld	s3,40(sp)
    80002b92:	7a02                	ld	s4,32(sp)
    80002b94:	6ae2                	ld	s5,24(sp)
    80002b96:	6b42                	ld	s6,16(sp)
    80002b98:	6ba2                	ld	s7,8(sp)
    80002b9a:	6161                	addi	sp,sp,80
    80002b9c:	8082                	ret

0000000080002b9e <iupdate>:
{
    80002b9e:	1101                	addi	sp,sp,-32
    80002ba0:	ec06                	sd	ra,24(sp)
    80002ba2:	e822                	sd	s0,16(sp)
    80002ba4:	e426                	sd	s1,8(sp)
    80002ba6:	e04a                	sd	s2,0(sp)
    80002ba8:	1000                	addi	s0,sp,32
    80002baa:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bac:	415c                	lw	a5,4(a0)
    80002bae:	0047d79b          	srliw	a5,a5,0x4
    80002bb2:	0001f597          	auipc	a1,0x1f
    80002bb6:	9be5a583          	lw	a1,-1602(a1) # 80021570 <sb+0x18>
    80002bba:	9dbd                	addw	a1,a1,a5
    80002bbc:	4108                	lw	a0,0(a0)
    80002bbe:	00000097          	auipc	ra,0x0
    80002bc2:	8a8080e7          	jalr	-1880(ra) # 80002466 <bread>
    80002bc6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bc8:	05850793          	addi	a5,a0,88
    80002bcc:	40c8                	lw	a0,4(s1)
    80002bce:	893d                	andi	a0,a0,15
    80002bd0:	051a                	slli	a0,a0,0x6
    80002bd2:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002bd4:	04449703          	lh	a4,68(s1)
    80002bd8:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002bdc:	04649703          	lh	a4,70(s1)
    80002be0:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002be4:	04849703          	lh	a4,72(s1)
    80002be8:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002bec:	04a49703          	lh	a4,74(s1)
    80002bf0:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002bf4:	44f8                	lw	a4,76(s1)
    80002bf6:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bf8:	03400613          	li	a2,52
    80002bfc:	05048593          	addi	a1,s1,80
    80002c00:	0531                	addi	a0,a0,12
    80002c02:	ffffd097          	auipc	ra,0xffffd
    80002c06:	5d6080e7          	jalr	1494(ra) # 800001d8 <memmove>
  log_write(bp);
    80002c0a:	854a                	mv	a0,s2
    80002c0c:	00001097          	auipc	ra,0x1
    80002c10:	c06080e7          	jalr	-1018(ra) # 80003812 <log_write>
  brelse(bp);
    80002c14:	854a                	mv	a0,s2
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	980080e7          	jalr	-1664(ra) # 80002596 <brelse>
}
    80002c1e:	60e2                	ld	ra,24(sp)
    80002c20:	6442                	ld	s0,16(sp)
    80002c22:	64a2                	ld	s1,8(sp)
    80002c24:	6902                	ld	s2,0(sp)
    80002c26:	6105                	addi	sp,sp,32
    80002c28:	8082                	ret

0000000080002c2a <idup>:
{
    80002c2a:	1101                	addi	sp,sp,-32
    80002c2c:	ec06                	sd	ra,24(sp)
    80002c2e:	e822                	sd	s0,16(sp)
    80002c30:	e426                	sd	s1,8(sp)
    80002c32:	1000                	addi	s0,sp,32
    80002c34:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c36:	0001f517          	auipc	a0,0x1f
    80002c3a:	94250513          	addi	a0,a0,-1726 # 80021578 <itable>
    80002c3e:	00004097          	auipc	ra,0x4
    80002c42:	8d4080e7          	jalr	-1836(ra) # 80006512 <acquire>
  ip->ref++;
    80002c46:	449c                	lw	a5,8(s1)
    80002c48:	2785                	addiw	a5,a5,1
    80002c4a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c4c:	0001f517          	auipc	a0,0x1f
    80002c50:	92c50513          	addi	a0,a0,-1748 # 80021578 <itable>
    80002c54:	00004097          	auipc	ra,0x4
    80002c58:	972080e7          	jalr	-1678(ra) # 800065c6 <release>
}
    80002c5c:	8526                	mv	a0,s1
    80002c5e:	60e2                	ld	ra,24(sp)
    80002c60:	6442                	ld	s0,16(sp)
    80002c62:	64a2                	ld	s1,8(sp)
    80002c64:	6105                	addi	sp,sp,32
    80002c66:	8082                	ret

0000000080002c68 <ilock>:
{
    80002c68:	1101                	addi	sp,sp,-32
    80002c6a:	ec06                	sd	ra,24(sp)
    80002c6c:	e822                	sd	s0,16(sp)
    80002c6e:	e426                	sd	s1,8(sp)
    80002c70:	e04a                	sd	s2,0(sp)
    80002c72:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c74:	c115                	beqz	a0,80002c98 <ilock+0x30>
    80002c76:	84aa                	mv	s1,a0
    80002c78:	451c                	lw	a5,8(a0)
    80002c7a:	00f05f63          	blez	a5,80002c98 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c7e:	0541                	addi	a0,a0,16
    80002c80:	00001097          	auipc	ra,0x1
    80002c84:	cb2080e7          	jalr	-846(ra) # 80003932 <acquiresleep>
  if(ip->valid == 0){
    80002c88:	40bc                	lw	a5,64(s1)
    80002c8a:	cf99                	beqz	a5,80002ca8 <ilock+0x40>
}
    80002c8c:	60e2                	ld	ra,24(sp)
    80002c8e:	6442                	ld	s0,16(sp)
    80002c90:	64a2                	ld	s1,8(sp)
    80002c92:	6902                	ld	s2,0(sp)
    80002c94:	6105                	addi	sp,sp,32
    80002c96:	8082                	ret
    panic("ilock");
    80002c98:	00006517          	auipc	a0,0x6
    80002c9c:	89850513          	addi	a0,a0,-1896 # 80008530 <syscalls+0x190>
    80002ca0:	00003097          	auipc	ra,0x3
    80002ca4:	328080e7          	jalr	808(ra) # 80005fc8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ca8:	40dc                	lw	a5,4(s1)
    80002caa:	0047d79b          	srliw	a5,a5,0x4
    80002cae:	0001f597          	auipc	a1,0x1f
    80002cb2:	8c25a583          	lw	a1,-1854(a1) # 80021570 <sb+0x18>
    80002cb6:	9dbd                	addw	a1,a1,a5
    80002cb8:	4088                	lw	a0,0(s1)
    80002cba:	fffff097          	auipc	ra,0xfffff
    80002cbe:	7ac080e7          	jalr	1964(ra) # 80002466 <bread>
    80002cc2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cc4:	05850593          	addi	a1,a0,88
    80002cc8:	40dc                	lw	a5,4(s1)
    80002cca:	8bbd                	andi	a5,a5,15
    80002ccc:	079a                	slli	a5,a5,0x6
    80002cce:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cd0:	00059783          	lh	a5,0(a1)
    80002cd4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cd8:	00259783          	lh	a5,2(a1)
    80002cdc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ce0:	00459783          	lh	a5,4(a1)
    80002ce4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ce8:	00659783          	lh	a5,6(a1)
    80002cec:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cf0:	459c                	lw	a5,8(a1)
    80002cf2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cf4:	03400613          	li	a2,52
    80002cf8:	05b1                	addi	a1,a1,12
    80002cfa:	05048513          	addi	a0,s1,80
    80002cfe:	ffffd097          	auipc	ra,0xffffd
    80002d02:	4da080e7          	jalr	1242(ra) # 800001d8 <memmove>
    brelse(bp);
    80002d06:	854a                	mv	a0,s2
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	88e080e7          	jalr	-1906(ra) # 80002596 <brelse>
    ip->valid = 1;
    80002d10:	4785                	li	a5,1
    80002d12:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d14:	04449783          	lh	a5,68(s1)
    80002d18:	fbb5                	bnez	a5,80002c8c <ilock+0x24>
      panic("ilock: no type");
    80002d1a:	00006517          	auipc	a0,0x6
    80002d1e:	81e50513          	addi	a0,a0,-2018 # 80008538 <syscalls+0x198>
    80002d22:	00003097          	auipc	ra,0x3
    80002d26:	2a6080e7          	jalr	678(ra) # 80005fc8 <panic>

0000000080002d2a <iunlock>:
{
    80002d2a:	1101                	addi	sp,sp,-32
    80002d2c:	ec06                	sd	ra,24(sp)
    80002d2e:	e822                	sd	s0,16(sp)
    80002d30:	e426                	sd	s1,8(sp)
    80002d32:	e04a                	sd	s2,0(sp)
    80002d34:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d36:	c905                	beqz	a0,80002d66 <iunlock+0x3c>
    80002d38:	84aa                	mv	s1,a0
    80002d3a:	01050913          	addi	s2,a0,16
    80002d3e:	854a                	mv	a0,s2
    80002d40:	00001097          	auipc	ra,0x1
    80002d44:	c8c080e7          	jalr	-884(ra) # 800039cc <holdingsleep>
    80002d48:	cd19                	beqz	a0,80002d66 <iunlock+0x3c>
    80002d4a:	449c                	lw	a5,8(s1)
    80002d4c:	00f05d63          	blez	a5,80002d66 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d50:	854a                	mv	a0,s2
    80002d52:	00001097          	auipc	ra,0x1
    80002d56:	c36080e7          	jalr	-970(ra) # 80003988 <releasesleep>
}
    80002d5a:	60e2                	ld	ra,24(sp)
    80002d5c:	6442                	ld	s0,16(sp)
    80002d5e:	64a2                	ld	s1,8(sp)
    80002d60:	6902                	ld	s2,0(sp)
    80002d62:	6105                	addi	sp,sp,32
    80002d64:	8082                	ret
    panic("iunlock");
    80002d66:	00005517          	auipc	a0,0x5
    80002d6a:	7e250513          	addi	a0,a0,2018 # 80008548 <syscalls+0x1a8>
    80002d6e:	00003097          	auipc	ra,0x3
    80002d72:	25a080e7          	jalr	602(ra) # 80005fc8 <panic>

0000000080002d76 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d76:	7179                	addi	sp,sp,-48
    80002d78:	f406                	sd	ra,40(sp)
    80002d7a:	f022                	sd	s0,32(sp)
    80002d7c:	ec26                	sd	s1,24(sp)
    80002d7e:	e84a                	sd	s2,16(sp)
    80002d80:	e44e                	sd	s3,8(sp)
    80002d82:	e052                	sd	s4,0(sp)
    80002d84:	1800                	addi	s0,sp,48
    80002d86:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d88:	05050493          	addi	s1,a0,80
    80002d8c:	08050913          	addi	s2,a0,128
    80002d90:	a021                	j	80002d98 <itrunc+0x22>
    80002d92:	0491                	addi	s1,s1,4
    80002d94:	01248d63          	beq	s1,s2,80002dae <itrunc+0x38>
    if(ip->addrs[i]){
    80002d98:	408c                	lw	a1,0(s1)
    80002d9a:	dde5                	beqz	a1,80002d92 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d9c:	0009a503          	lw	a0,0(s3)
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	90c080e7          	jalr	-1780(ra) # 800026ac <bfree>
      ip->addrs[i] = 0;
    80002da8:	0004a023          	sw	zero,0(s1)
    80002dac:	b7dd                	j	80002d92 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dae:	0809a583          	lw	a1,128(s3)
    80002db2:	e185                	bnez	a1,80002dd2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002db4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002db8:	854e                	mv	a0,s3
    80002dba:	00000097          	auipc	ra,0x0
    80002dbe:	de4080e7          	jalr	-540(ra) # 80002b9e <iupdate>
}
    80002dc2:	70a2                	ld	ra,40(sp)
    80002dc4:	7402                	ld	s0,32(sp)
    80002dc6:	64e2                	ld	s1,24(sp)
    80002dc8:	6942                	ld	s2,16(sp)
    80002dca:	69a2                	ld	s3,8(sp)
    80002dcc:	6a02                	ld	s4,0(sp)
    80002dce:	6145                	addi	sp,sp,48
    80002dd0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dd2:	0009a503          	lw	a0,0(s3)
    80002dd6:	fffff097          	auipc	ra,0xfffff
    80002dda:	690080e7          	jalr	1680(ra) # 80002466 <bread>
    80002dde:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002de0:	05850493          	addi	s1,a0,88
    80002de4:	45850913          	addi	s2,a0,1112
    80002de8:	a811                	j	80002dfc <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002dea:	0009a503          	lw	a0,0(s3)
    80002dee:	00000097          	auipc	ra,0x0
    80002df2:	8be080e7          	jalr	-1858(ra) # 800026ac <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002df6:	0491                	addi	s1,s1,4
    80002df8:	01248563          	beq	s1,s2,80002e02 <itrunc+0x8c>
      if(a[j])
    80002dfc:	408c                	lw	a1,0(s1)
    80002dfe:	dde5                	beqz	a1,80002df6 <itrunc+0x80>
    80002e00:	b7ed                	j	80002dea <itrunc+0x74>
    brelse(bp);
    80002e02:	8552                	mv	a0,s4
    80002e04:	fffff097          	auipc	ra,0xfffff
    80002e08:	792080e7          	jalr	1938(ra) # 80002596 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e0c:	0809a583          	lw	a1,128(s3)
    80002e10:	0009a503          	lw	a0,0(s3)
    80002e14:	00000097          	auipc	ra,0x0
    80002e18:	898080e7          	jalr	-1896(ra) # 800026ac <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e1c:	0809a023          	sw	zero,128(s3)
    80002e20:	bf51                	j	80002db4 <itrunc+0x3e>

0000000080002e22 <iput>:
{
    80002e22:	1101                	addi	sp,sp,-32
    80002e24:	ec06                	sd	ra,24(sp)
    80002e26:	e822                	sd	s0,16(sp)
    80002e28:	e426                	sd	s1,8(sp)
    80002e2a:	e04a                	sd	s2,0(sp)
    80002e2c:	1000                	addi	s0,sp,32
    80002e2e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e30:	0001e517          	auipc	a0,0x1e
    80002e34:	74850513          	addi	a0,a0,1864 # 80021578 <itable>
    80002e38:	00003097          	auipc	ra,0x3
    80002e3c:	6da080e7          	jalr	1754(ra) # 80006512 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e40:	4498                	lw	a4,8(s1)
    80002e42:	4785                	li	a5,1
    80002e44:	02f70363          	beq	a4,a5,80002e6a <iput+0x48>
  ip->ref--;
    80002e48:	449c                	lw	a5,8(s1)
    80002e4a:	37fd                	addiw	a5,a5,-1
    80002e4c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e4e:	0001e517          	auipc	a0,0x1e
    80002e52:	72a50513          	addi	a0,a0,1834 # 80021578 <itable>
    80002e56:	00003097          	auipc	ra,0x3
    80002e5a:	770080e7          	jalr	1904(ra) # 800065c6 <release>
}
    80002e5e:	60e2                	ld	ra,24(sp)
    80002e60:	6442                	ld	s0,16(sp)
    80002e62:	64a2                	ld	s1,8(sp)
    80002e64:	6902                	ld	s2,0(sp)
    80002e66:	6105                	addi	sp,sp,32
    80002e68:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e6a:	40bc                	lw	a5,64(s1)
    80002e6c:	dff1                	beqz	a5,80002e48 <iput+0x26>
    80002e6e:	04a49783          	lh	a5,74(s1)
    80002e72:	fbf9                	bnez	a5,80002e48 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e74:	01048913          	addi	s2,s1,16
    80002e78:	854a                	mv	a0,s2
    80002e7a:	00001097          	auipc	ra,0x1
    80002e7e:	ab8080e7          	jalr	-1352(ra) # 80003932 <acquiresleep>
    release(&itable.lock);
    80002e82:	0001e517          	auipc	a0,0x1e
    80002e86:	6f650513          	addi	a0,a0,1782 # 80021578 <itable>
    80002e8a:	00003097          	auipc	ra,0x3
    80002e8e:	73c080e7          	jalr	1852(ra) # 800065c6 <release>
    itrunc(ip);
    80002e92:	8526                	mv	a0,s1
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	ee2080e7          	jalr	-286(ra) # 80002d76 <itrunc>
    ip->type = 0;
    80002e9c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ea0:	8526                	mv	a0,s1
    80002ea2:	00000097          	auipc	ra,0x0
    80002ea6:	cfc080e7          	jalr	-772(ra) # 80002b9e <iupdate>
    ip->valid = 0;
    80002eaa:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002eae:	854a                	mv	a0,s2
    80002eb0:	00001097          	auipc	ra,0x1
    80002eb4:	ad8080e7          	jalr	-1320(ra) # 80003988 <releasesleep>
    acquire(&itable.lock);
    80002eb8:	0001e517          	auipc	a0,0x1e
    80002ebc:	6c050513          	addi	a0,a0,1728 # 80021578 <itable>
    80002ec0:	00003097          	auipc	ra,0x3
    80002ec4:	652080e7          	jalr	1618(ra) # 80006512 <acquire>
    80002ec8:	b741                	j	80002e48 <iput+0x26>

0000000080002eca <iunlockput>:
{
    80002eca:	1101                	addi	sp,sp,-32
    80002ecc:	ec06                	sd	ra,24(sp)
    80002ece:	e822                	sd	s0,16(sp)
    80002ed0:	e426                	sd	s1,8(sp)
    80002ed2:	1000                	addi	s0,sp,32
    80002ed4:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ed6:	00000097          	auipc	ra,0x0
    80002eda:	e54080e7          	jalr	-428(ra) # 80002d2a <iunlock>
  iput(ip);
    80002ede:	8526                	mv	a0,s1
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	f42080e7          	jalr	-190(ra) # 80002e22 <iput>
}
    80002ee8:	60e2                	ld	ra,24(sp)
    80002eea:	6442                	ld	s0,16(sp)
    80002eec:	64a2                	ld	s1,8(sp)
    80002eee:	6105                	addi	sp,sp,32
    80002ef0:	8082                	ret

0000000080002ef2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ef2:	1141                	addi	sp,sp,-16
    80002ef4:	e422                	sd	s0,8(sp)
    80002ef6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ef8:	411c                	lw	a5,0(a0)
    80002efa:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002efc:	415c                	lw	a5,4(a0)
    80002efe:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f00:	04451783          	lh	a5,68(a0)
    80002f04:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f08:	04a51783          	lh	a5,74(a0)
    80002f0c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f10:	04c56783          	lwu	a5,76(a0)
    80002f14:	e99c                	sd	a5,16(a1)
}
    80002f16:	6422                	ld	s0,8(sp)
    80002f18:	0141                	addi	sp,sp,16
    80002f1a:	8082                	ret

0000000080002f1c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f1c:	457c                	lw	a5,76(a0)
    80002f1e:	0ed7e963          	bltu	a5,a3,80003010 <readi+0xf4>
{
    80002f22:	7159                	addi	sp,sp,-112
    80002f24:	f486                	sd	ra,104(sp)
    80002f26:	f0a2                	sd	s0,96(sp)
    80002f28:	eca6                	sd	s1,88(sp)
    80002f2a:	e8ca                	sd	s2,80(sp)
    80002f2c:	e4ce                	sd	s3,72(sp)
    80002f2e:	e0d2                	sd	s4,64(sp)
    80002f30:	fc56                	sd	s5,56(sp)
    80002f32:	f85a                	sd	s6,48(sp)
    80002f34:	f45e                	sd	s7,40(sp)
    80002f36:	f062                	sd	s8,32(sp)
    80002f38:	ec66                	sd	s9,24(sp)
    80002f3a:	e86a                	sd	s10,16(sp)
    80002f3c:	e46e                	sd	s11,8(sp)
    80002f3e:	1880                	addi	s0,sp,112
    80002f40:	8baa                	mv	s7,a0
    80002f42:	8c2e                	mv	s8,a1
    80002f44:	8ab2                	mv	s5,a2
    80002f46:	84b6                	mv	s1,a3
    80002f48:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002f4a:	9f35                	addw	a4,a4,a3
    return 0;
    80002f4c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f4e:	0ad76063          	bltu	a4,a3,80002fee <readi+0xd2>
  if(off + n > ip->size)
    80002f52:	00e7f463          	bgeu	a5,a4,80002f5a <readi+0x3e>
    n = ip->size - off;
    80002f56:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f5a:	0a0b0963          	beqz	s6,8000300c <readi+0xf0>
    80002f5e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f60:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f64:	5cfd                	li	s9,-1
    80002f66:	a82d                	j	80002fa0 <readi+0x84>
    80002f68:	020a1d93          	slli	s11,s4,0x20
    80002f6c:	020ddd93          	srli	s11,s11,0x20
    80002f70:	05890613          	addi	a2,s2,88
    80002f74:	86ee                	mv	a3,s11
    80002f76:	963a                	add	a2,a2,a4
    80002f78:	85d6                	mv	a1,s5
    80002f7a:	8562                	mv	a0,s8
    80002f7c:	fffff097          	auipc	ra,0xfffff
    80002f80:	9ae080e7          	jalr	-1618(ra) # 8000192a <either_copyout>
    80002f84:	05950d63          	beq	a0,s9,80002fde <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f88:	854a                	mv	a0,s2
    80002f8a:	fffff097          	auipc	ra,0xfffff
    80002f8e:	60c080e7          	jalr	1548(ra) # 80002596 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f92:	013a09bb          	addw	s3,s4,s3
    80002f96:	009a04bb          	addw	s1,s4,s1
    80002f9a:	9aee                	add	s5,s5,s11
    80002f9c:	0569f763          	bgeu	s3,s6,80002fea <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fa0:	000ba903          	lw	s2,0(s7)
    80002fa4:	00a4d59b          	srliw	a1,s1,0xa
    80002fa8:	855e                	mv	a0,s7
    80002faa:	00000097          	auipc	ra,0x0
    80002fae:	8b0080e7          	jalr	-1872(ra) # 8000285a <bmap>
    80002fb2:	0005059b          	sext.w	a1,a0
    80002fb6:	854a                	mv	a0,s2
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	4ae080e7          	jalr	1198(ra) # 80002466 <bread>
    80002fc0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fc2:	3ff4f713          	andi	a4,s1,1023
    80002fc6:	40ed07bb          	subw	a5,s10,a4
    80002fca:	413b06bb          	subw	a3,s6,s3
    80002fce:	8a3e                	mv	s4,a5
    80002fd0:	2781                	sext.w	a5,a5
    80002fd2:	0006861b          	sext.w	a2,a3
    80002fd6:	f8f679e3          	bgeu	a2,a5,80002f68 <readi+0x4c>
    80002fda:	8a36                	mv	s4,a3
    80002fdc:	b771                	j	80002f68 <readi+0x4c>
      brelse(bp);
    80002fde:	854a                	mv	a0,s2
    80002fe0:	fffff097          	auipc	ra,0xfffff
    80002fe4:	5b6080e7          	jalr	1462(ra) # 80002596 <brelse>
      tot = -1;
    80002fe8:	59fd                	li	s3,-1
  }
  return tot;
    80002fea:	0009851b          	sext.w	a0,s3
}
    80002fee:	70a6                	ld	ra,104(sp)
    80002ff0:	7406                	ld	s0,96(sp)
    80002ff2:	64e6                	ld	s1,88(sp)
    80002ff4:	6946                	ld	s2,80(sp)
    80002ff6:	69a6                	ld	s3,72(sp)
    80002ff8:	6a06                	ld	s4,64(sp)
    80002ffa:	7ae2                	ld	s5,56(sp)
    80002ffc:	7b42                	ld	s6,48(sp)
    80002ffe:	7ba2                	ld	s7,40(sp)
    80003000:	7c02                	ld	s8,32(sp)
    80003002:	6ce2                	ld	s9,24(sp)
    80003004:	6d42                	ld	s10,16(sp)
    80003006:	6da2                	ld	s11,8(sp)
    80003008:	6165                	addi	sp,sp,112
    8000300a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000300c:	89da                	mv	s3,s6
    8000300e:	bff1                	j	80002fea <readi+0xce>
    return 0;
    80003010:	4501                	li	a0,0
}
    80003012:	8082                	ret

0000000080003014 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003014:	457c                	lw	a5,76(a0)
    80003016:	10d7e863          	bltu	a5,a3,80003126 <writei+0x112>
{
    8000301a:	7159                	addi	sp,sp,-112
    8000301c:	f486                	sd	ra,104(sp)
    8000301e:	f0a2                	sd	s0,96(sp)
    80003020:	eca6                	sd	s1,88(sp)
    80003022:	e8ca                	sd	s2,80(sp)
    80003024:	e4ce                	sd	s3,72(sp)
    80003026:	e0d2                	sd	s4,64(sp)
    80003028:	fc56                	sd	s5,56(sp)
    8000302a:	f85a                	sd	s6,48(sp)
    8000302c:	f45e                	sd	s7,40(sp)
    8000302e:	f062                	sd	s8,32(sp)
    80003030:	ec66                	sd	s9,24(sp)
    80003032:	e86a                	sd	s10,16(sp)
    80003034:	e46e                	sd	s11,8(sp)
    80003036:	1880                	addi	s0,sp,112
    80003038:	8b2a                	mv	s6,a0
    8000303a:	8c2e                	mv	s8,a1
    8000303c:	8ab2                	mv	s5,a2
    8000303e:	8936                	mv	s2,a3
    80003040:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003042:	00e687bb          	addw	a5,a3,a4
    80003046:	0ed7e263          	bltu	a5,a3,8000312a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000304a:	00043737          	lui	a4,0x43
    8000304e:	0ef76063          	bltu	a4,a5,8000312e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003052:	0c0b8863          	beqz	s7,80003122 <writei+0x10e>
    80003056:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003058:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000305c:	5cfd                	li	s9,-1
    8000305e:	a091                	j	800030a2 <writei+0x8e>
    80003060:	02099d93          	slli	s11,s3,0x20
    80003064:	020ddd93          	srli	s11,s11,0x20
    80003068:	05848513          	addi	a0,s1,88
    8000306c:	86ee                	mv	a3,s11
    8000306e:	8656                	mv	a2,s5
    80003070:	85e2                	mv	a1,s8
    80003072:	953a                	add	a0,a0,a4
    80003074:	fffff097          	auipc	ra,0xfffff
    80003078:	90c080e7          	jalr	-1780(ra) # 80001980 <either_copyin>
    8000307c:	07950263          	beq	a0,s9,800030e0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003080:	8526                	mv	a0,s1
    80003082:	00000097          	auipc	ra,0x0
    80003086:	790080e7          	jalr	1936(ra) # 80003812 <log_write>
    brelse(bp);
    8000308a:	8526                	mv	a0,s1
    8000308c:	fffff097          	auipc	ra,0xfffff
    80003090:	50a080e7          	jalr	1290(ra) # 80002596 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003094:	01498a3b          	addw	s4,s3,s4
    80003098:	0129893b          	addw	s2,s3,s2
    8000309c:	9aee                	add	s5,s5,s11
    8000309e:	057a7663          	bgeu	s4,s7,800030ea <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030a2:	000b2483          	lw	s1,0(s6)
    800030a6:	00a9559b          	srliw	a1,s2,0xa
    800030aa:	855a                	mv	a0,s6
    800030ac:	fffff097          	auipc	ra,0xfffff
    800030b0:	7ae080e7          	jalr	1966(ra) # 8000285a <bmap>
    800030b4:	0005059b          	sext.w	a1,a0
    800030b8:	8526                	mv	a0,s1
    800030ba:	fffff097          	auipc	ra,0xfffff
    800030be:	3ac080e7          	jalr	940(ra) # 80002466 <bread>
    800030c2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c4:	3ff97713          	andi	a4,s2,1023
    800030c8:	40ed07bb          	subw	a5,s10,a4
    800030cc:	414b86bb          	subw	a3,s7,s4
    800030d0:	89be                	mv	s3,a5
    800030d2:	2781                	sext.w	a5,a5
    800030d4:	0006861b          	sext.w	a2,a3
    800030d8:	f8f674e3          	bgeu	a2,a5,80003060 <writei+0x4c>
    800030dc:	89b6                	mv	s3,a3
    800030de:	b749                	j	80003060 <writei+0x4c>
      brelse(bp);
    800030e0:	8526                	mv	a0,s1
    800030e2:	fffff097          	auipc	ra,0xfffff
    800030e6:	4b4080e7          	jalr	1204(ra) # 80002596 <brelse>
  }

  if(off > ip->size)
    800030ea:	04cb2783          	lw	a5,76(s6)
    800030ee:	0127f463          	bgeu	a5,s2,800030f6 <writei+0xe2>
    ip->size = off;
    800030f2:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030f6:	855a                	mv	a0,s6
    800030f8:	00000097          	auipc	ra,0x0
    800030fc:	aa6080e7          	jalr	-1370(ra) # 80002b9e <iupdate>

  return tot;
    80003100:	000a051b          	sext.w	a0,s4
}
    80003104:	70a6                	ld	ra,104(sp)
    80003106:	7406                	ld	s0,96(sp)
    80003108:	64e6                	ld	s1,88(sp)
    8000310a:	6946                	ld	s2,80(sp)
    8000310c:	69a6                	ld	s3,72(sp)
    8000310e:	6a06                	ld	s4,64(sp)
    80003110:	7ae2                	ld	s5,56(sp)
    80003112:	7b42                	ld	s6,48(sp)
    80003114:	7ba2                	ld	s7,40(sp)
    80003116:	7c02                	ld	s8,32(sp)
    80003118:	6ce2                	ld	s9,24(sp)
    8000311a:	6d42                	ld	s10,16(sp)
    8000311c:	6da2                	ld	s11,8(sp)
    8000311e:	6165                	addi	sp,sp,112
    80003120:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003122:	8a5e                	mv	s4,s7
    80003124:	bfc9                	j	800030f6 <writei+0xe2>
    return -1;
    80003126:	557d                	li	a0,-1
}
    80003128:	8082                	ret
    return -1;
    8000312a:	557d                	li	a0,-1
    8000312c:	bfe1                	j	80003104 <writei+0xf0>
    return -1;
    8000312e:	557d                	li	a0,-1
    80003130:	bfd1                	j	80003104 <writei+0xf0>

0000000080003132 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003132:	1141                	addi	sp,sp,-16
    80003134:	e406                	sd	ra,8(sp)
    80003136:	e022                	sd	s0,0(sp)
    80003138:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000313a:	4639                	li	a2,14
    8000313c:	ffffd097          	auipc	ra,0xffffd
    80003140:	114080e7          	jalr	276(ra) # 80000250 <strncmp>
}
    80003144:	60a2                	ld	ra,8(sp)
    80003146:	6402                	ld	s0,0(sp)
    80003148:	0141                	addi	sp,sp,16
    8000314a:	8082                	ret

000000008000314c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000314c:	7139                	addi	sp,sp,-64
    8000314e:	fc06                	sd	ra,56(sp)
    80003150:	f822                	sd	s0,48(sp)
    80003152:	f426                	sd	s1,40(sp)
    80003154:	f04a                	sd	s2,32(sp)
    80003156:	ec4e                	sd	s3,24(sp)
    80003158:	e852                	sd	s4,16(sp)
    8000315a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000315c:	04451703          	lh	a4,68(a0)
    80003160:	4785                	li	a5,1
    80003162:	00f71a63          	bne	a4,a5,80003176 <dirlookup+0x2a>
    80003166:	892a                	mv	s2,a0
    80003168:	89ae                	mv	s3,a1
    8000316a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000316c:	457c                	lw	a5,76(a0)
    8000316e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003170:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003172:	e79d                	bnez	a5,800031a0 <dirlookup+0x54>
    80003174:	a8a5                	j	800031ec <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003176:	00005517          	auipc	a0,0x5
    8000317a:	3da50513          	addi	a0,a0,986 # 80008550 <syscalls+0x1b0>
    8000317e:	00003097          	auipc	ra,0x3
    80003182:	e4a080e7          	jalr	-438(ra) # 80005fc8 <panic>
      panic("dirlookup read");
    80003186:	00005517          	auipc	a0,0x5
    8000318a:	3e250513          	addi	a0,a0,994 # 80008568 <syscalls+0x1c8>
    8000318e:	00003097          	auipc	ra,0x3
    80003192:	e3a080e7          	jalr	-454(ra) # 80005fc8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003196:	24c1                	addiw	s1,s1,16
    80003198:	04c92783          	lw	a5,76(s2)
    8000319c:	04f4f763          	bgeu	s1,a5,800031ea <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031a0:	4741                	li	a4,16
    800031a2:	86a6                	mv	a3,s1
    800031a4:	fc040613          	addi	a2,s0,-64
    800031a8:	4581                	li	a1,0
    800031aa:	854a                	mv	a0,s2
    800031ac:	00000097          	auipc	ra,0x0
    800031b0:	d70080e7          	jalr	-656(ra) # 80002f1c <readi>
    800031b4:	47c1                	li	a5,16
    800031b6:	fcf518e3          	bne	a0,a5,80003186 <dirlookup+0x3a>
    if(de.inum == 0)
    800031ba:	fc045783          	lhu	a5,-64(s0)
    800031be:	dfe1                	beqz	a5,80003196 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031c0:	fc240593          	addi	a1,s0,-62
    800031c4:	854e                	mv	a0,s3
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	f6c080e7          	jalr	-148(ra) # 80003132 <namecmp>
    800031ce:	f561                	bnez	a0,80003196 <dirlookup+0x4a>
      if(poff)
    800031d0:	000a0463          	beqz	s4,800031d8 <dirlookup+0x8c>
        *poff = off;
    800031d4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031d8:	fc045583          	lhu	a1,-64(s0)
    800031dc:	00092503          	lw	a0,0(s2)
    800031e0:	fffff097          	auipc	ra,0xfffff
    800031e4:	754080e7          	jalr	1876(ra) # 80002934 <iget>
    800031e8:	a011                	j	800031ec <dirlookup+0xa0>
  return 0;
    800031ea:	4501                	li	a0,0
}
    800031ec:	70e2                	ld	ra,56(sp)
    800031ee:	7442                	ld	s0,48(sp)
    800031f0:	74a2                	ld	s1,40(sp)
    800031f2:	7902                	ld	s2,32(sp)
    800031f4:	69e2                	ld	s3,24(sp)
    800031f6:	6a42                	ld	s4,16(sp)
    800031f8:	6121                	addi	sp,sp,64
    800031fa:	8082                	ret

00000000800031fc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031fc:	711d                	addi	sp,sp,-96
    800031fe:	ec86                	sd	ra,88(sp)
    80003200:	e8a2                	sd	s0,80(sp)
    80003202:	e4a6                	sd	s1,72(sp)
    80003204:	e0ca                	sd	s2,64(sp)
    80003206:	fc4e                	sd	s3,56(sp)
    80003208:	f852                	sd	s4,48(sp)
    8000320a:	f456                	sd	s5,40(sp)
    8000320c:	f05a                	sd	s6,32(sp)
    8000320e:	ec5e                	sd	s7,24(sp)
    80003210:	e862                	sd	s8,16(sp)
    80003212:	e466                	sd	s9,8(sp)
    80003214:	1080                	addi	s0,sp,96
    80003216:	84aa                	mv	s1,a0
    80003218:	8b2e                	mv	s6,a1
    8000321a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000321c:	00054703          	lbu	a4,0(a0)
    80003220:	02f00793          	li	a5,47
    80003224:	02f70363          	beq	a4,a5,8000324a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003228:	ffffe097          	auipc	ra,0xffffe
    8000322c:	c06080e7          	jalr	-1018(ra) # 80000e2e <myproc>
    80003230:	15053503          	ld	a0,336(a0)
    80003234:	00000097          	auipc	ra,0x0
    80003238:	9f6080e7          	jalr	-1546(ra) # 80002c2a <idup>
    8000323c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000323e:	02f00913          	li	s2,47
  len = path - s;
    80003242:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003244:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003246:	4c05                	li	s8,1
    80003248:	a865                	j	80003300 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000324a:	4585                	li	a1,1
    8000324c:	4505                	li	a0,1
    8000324e:	fffff097          	auipc	ra,0xfffff
    80003252:	6e6080e7          	jalr	1766(ra) # 80002934 <iget>
    80003256:	89aa                	mv	s3,a0
    80003258:	b7dd                	j	8000323e <namex+0x42>
      iunlockput(ip);
    8000325a:	854e                	mv	a0,s3
    8000325c:	00000097          	auipc	ra,0x0
    80003260:	c6e080e7          	jalr	-914(ra) # 80002eca <iunlockput>
      return 0;
    80003264:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003266:	854e                	mv	a0,s3
    80003268:	60e6                	ld	ra,88(sp)
    8000326a:	6446                	ld	s0,80(sp)
    8000326c:	64a6                	ld	s1,72(sp)
    8000326e:	6906                	ld	s2,64(sp)
    80003270:	79e2                	ld	s3,56(sp)
    80003272:	7a42                	ld	s4,48(sp)
    80003274:	7aa2                	ld	s5,40(sp)
    80003276:	7b02                	ld	s6,32(sp)
    80003278:	6be2                	ld	s7,24(sp)
    8000327a:	6c42                	ld	s8,16(sp)
    8000327c:	6ca2                	ld	s9,8(sp)
    8000327e:	6125                	addi	sp,sp,96
    80003280:	8082                	ret
      iunlock(ip);
    80003282:	854e                	mv	a0,s3
    80003284:	00000097          	auipc	ra,0x0
    80003288:	aa6080e7          	jalr	-1370(ra) # 80002d2a <iunlock>
      return ip;
    8000328c:	bfe9                	j	80003266 <namex+0x6a>
      iunlockput(ip);
    8000328e:	854e                	mv	a0,s3
    80003290:	00000097          	auipc	ra,0x0
    80003294:	c3a080e7          	jalr	-966(ra) # 80002eca <iunlockput>
      return 0;
    80003298:	89d2                	mv	s3,s4
    8000329a:	b7f1                	j	80003266 <namex+0x6a>
  len = path - s;
    8000329c:	40b48633          	sub	a2,s1,a1
    800032a0:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032a4:	094cd463          	bge	s9,s4,8000332c <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032a8:	4639                	li	a2,14
    800032aa:	8556                	mv	a0,s5
    800032ac:	ffffd097          	auipc	ra,0xffffd
    800032b0:	f2c080e7          	jalr	-212(ra) # 800001d8 <memmove>
  while(*path == '/')
    800032b4:	0004c783          	lbu	a5,0(s1)
    800032b8:	01279763          	bne	a5,s2,800032c6 <namex+0xca>
    path++;
    800032bc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032be:	0004c783          	lbu	a5,0(s1)
    800032c2:	ff278de3          	beq	a5,s2,800032bc <namex+0xc0>
    ilock(ip);
    800032c6:	854e                	mv	a0,s3
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	9a0080e7          	jalr	-1632(ra) # 80002c68 <ilock>
    if(ip->type != T_DIR){
    800032d0:	04499783          	lh	a5,68(s3)
    800032d4:	f98793e3          	bne	a5,s8,8000325a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032d8:	000b0563          	beqz	s6,800032e2 <namex+0xe6>
    800032dc:	0004c783          	lbu	a5,0(s1)
    800032e0:	d3cd                	beqz	a5,80003282 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032e2:	865e                	mv	a2,s7
    800032e4:	85d6                	mv	a1,s5
    800032e6:	854e                	mv	a0,s3
    800032e8:	00000097          	auipc	ra,0x0
    800032ec:	e64080e7          	jalr	-412(ra) # 8000314c <dirlookup>
    800032f0:	8a2a                	mv	s4,a0
    800032f2:	dd51                	beqz	a0,8000328e <namex+0x92>
    iunlockput(ip);
    800032f4:	854e                	mv	a0,s3
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	bd4080e7          	jalr	-1068(ra) # 80002eca <iunlockput>
    ip = next;
    800032fe:	89d2                	mv	s3,s4
  while(*path == '/')
    80003300:	0004c783          	lbu	a5,0(s1)
    80003304:	05279763          	bne	a5,s2,80003352 <namex+0x156>
    path++;
    80003308:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000330a:	0004c783          	lbu	a5,0(s1)
    8000330e:	ff278de3          	beq	a5,s2,80003308 <namex+0x10c>
  if(*path == 0)
    80003312:	c79d                	beqz	a5,80003340 <namex+0x144>
    path++;
    80003314:	85a6                	mv	a1,s1
  len = path - s;
    80003316:	8a5e                	mv	s4,s7
    80003318:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000331a:	01278963          	beq	a5,s2,8000332c <namex+0x130>
    8000331e:	dfbd                	beqz	a5,8000329c <namex+0xa0>
    path++;
    80003320:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003322:	0004c783          	lbu	a5,0(s1)
    80003326:	ff279ce3          	bne	a5,s2,8000331e <namex+0x122>
    8000332a:	bf8d                	j	8000329c <namex+0xa0>
    memmove(name, s, len);
    8000332c:	2601                	sext.w	a2,a2
    8000332e:	8556                	mv	a0,s5
    80003330:	ffffd097          	auipc	ra,0xffffd
    80003334:	ea8080e7          	jalr	-344(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003338:	9a56                	add	s4,s4,s5
    8000333a:	000a0023          	sb	zero,0(s4)
    8000333e:	bf9d                	j	800032b4 <namex+0xb8>
  if(nameiparent){
    80003340:	f20b03e3          	beqz	s6,80003266 <namex+0x6a>
    iput(ip);
    80003344:	854e                	mv	a0,s3
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	adc080e7          	jalr	-1316(ra) # 80002e22 <iput>
    return 0;
    8000334e:	4981                	li	s3,0
    80003350:	bf19                	j	80003266 <namex+0x6a>
  if(*path == 0)
    80003352:	d7fd                	beqz	a5,80003340 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003354:	0004c783          	lbu	a5,0(s1)
    80003358:	85a6                	mv	a1,s1
    8000335a:	b7d1                	j	8000331e <namex+0x122>

000000008000335c <dirlink>:
{
    8000335c:	7139                	addi	sp,sp,-64
    8000335e:	fc06                	sd	ra,56(sp)
    80003360:	f822                	sd	s0,48(sp)
    80003362:	f426                	sd	s1,40(sp)
    80003364:	f04a                	sd	s2,32(sp)
    80003366:	ec4e                	sd	s3,24(sp)
    80003368:	e852                	sd	s4,16(sp)
    8000336a:	0080                	addi	s0,sp,64
    8000336c:	892a                	mv	s2,a0
    8000336e:	8a2e                	mv	s4,a1
    80003370:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003372:	4601                	li	a2,0
    80003374:	00000097          	auipc	ra,0x0
    80003378:	dd8080e7          	jalr	-552(ra) # 8000314c <dirlookup>
    8000337c:	e93d                	bnez	a0,800033f2 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000337e:	04c92483          	lw	s1,76(s2)
    80003382:	c49d                	beqz	s1,800033b0 <dirlink+0x54>
    80003384:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003386:	4741                	li	a4,16
    80003388:	86a6                	mv	a3,s1
    8000338a:	fc040613          	addi	a2,s0,-64
    8000338e:	4581                	li	a1,0
    80003390:	854a                	mv	a0,s2
    80003392:	00000097          	auipc	ra,0x0
    80003396:	b8a080e7          	jalr	-1142(ra) # 80002f1c <readi>
    8000339a:	47c1                	li	a5,16
    8000339c:	06f51163          	bne	a0,a5,800033fe <dirlink+0xa2>
    if(de.inum == 0)
    800033a0:	fc045783          	lhu	a5,-64(s0)
    800033a4:	c791                	beqz	a5,800033b0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033a6:	24c1                	addiw	s1,s1,16
    800033a8:	04c92783          	lw	a5,76(s2)
    800033ac:	fcf4ede3          	bltu	s1,a5,80003386 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033b0:	4639                	li	a2,14
    800033b2:	85d2                	mv	a1,s4
    800033b4:	fc240513          	addi	a0,s0,-62
    800033b8:	ffffd097          	auipc	ra,0xffffd
    800033bc:	ed4080e7          	jalr	-300(ra) # 8000028c <strncpy>
  de.inum = inum;
    800033c0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033c4:	4741                	li	a4,16
    800033c6:	86a6                	mv	a3,s1
    800033c8:	fc040613          	addi	a2,s0,-64
    800033cc:	4581                	li	a1,0
    800033ce:	854a                	mv	a0,s2
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	c44080e7          	jalr	-956(ra) # 80003014 <writei>
    800033d8:	872a                	mv	a4,a0
    800033da:	47c1                	li	a5,16
  return 0;
    800033dc:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033de:	02f71863          	bne	a4,a5,8000340e <dirlink+0xb2>
}
    800033e2:	70e2                	ld	ra,56(sp)
    800033e4:	7442                	ld	s0,48(sp)
    800033e6:	74a2                	ld	s1,40(sp)
    800033e8:	7902                	ld	s2,32(sp)
    800033ea:	69e2                	ld	s3,24(sp)
    800033ec:	6a42                	ld	s4,16(sp)
    800033ee:	6121                	addi	sp,sp,64
    800033f0:	8082                	ret
    iput(ip);
    800033f2:	00000097          	auipc	ra,0x0
    800033f6:	a30080e7          	jalr	-1488(ra) # 80002e22 <iput>
    return -1;
    800033fa:	557d                	li	a0,-1
    800033fc:	b7dd                	j	800033e2 <dirlink+0x86>
      panic("dirlink read");
    800033fe:	00005517          	auipc	a0,0x5
    80003402:	17a50513          	addi	a0,a0,378 # 80008578 <syscalls+0x1d8>
    80003406:	00003097          	auipc	ra,0x3
    8000340a:	bc2080e7          	jalr	-1086(ra) # 80005fc8 <panic>
    panic("dirlink");
    8000340e:	00005517          	auipc	a0,0x5
    80003412:	27a50513          	addi	a0,a0,634 # 80008688 <syscalls+0x2e8>
    80003416:	00003097          	auipc	ra,0x3
    8000341a:	bb2080e7          	jalr	-1102(ra) # 80005fc8 <panic>

000000008000341e <namei>:

struct inode*
namei(char *path)
{
    8000341e:	1101                	addi	sp,sp,-32
    80003420:	ec06                	sd	ra,24(sp)
    80003422:	e822                	sd	s0,16(sp)
    80003424:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003426:	fe040613          	addi	a2,s0,-32
    8000342a:	4581                	li	a1,0
    8000342c:	00000097          	auipc	ra,0x0
    80003430:	dd0080e7          	jalr	-560(ra) # 800031fc <namex>
}
    80003434:	60e2                	ld	ra,24(sp)
    80003436:	6442                	ld	s0,16(sp)
    80003438:	6105                	addi	sp,sp,32
    8000343a:	8082                	ret

000000008000343c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000343c:	1141                	addi	sp,sp,-16
    8000343e:	e406                	sd	ra,8(sp)
    80003440:	e022                	sd	s0,0(sp)
    80003442:	0800                	addi	s0,sp,16
    80003444:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003446:	4585                	li	a1,1
    80003448:	00000097          	auipc	ra,0x0
    8000344c:	db4080e7          	jalr	-588(ra) # 800031fc <namex>
}
    80003450:	60a2                	ld	ra,8(sp)
    80003452:	6402                	ld	s0,0(sp)
    80003454:	0141                	addi	sp,sp,16
    80003456:	8082                	ret

0000000080003458 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003458:	1101                	addi	sp,sp,-32
    8000345a:	ec06                	sd	ra,24(sp)
    8000345c:	e822                	sd	s0,16(sp)
    8000345e:	e426                	sd	s1,8(sp)
    80003460:	e04a                	sd	s2,0(sp)
    80003462:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003464:	00020917          	auipc	s2,0x20
    80003468:	bbc90913          	addi	s2,s2,-1092 # 80023020 <log>
    8000346c:	01892583          	lw	a1,24(s2)
    80003470:	02892503          	lw	a0,40(s2)
    80003474:	fffff097          	auipc	ra,0xfffff
    80003478:	ff2080e7          	jalr	-14(ra) # 80002466 <bread>
    8000347c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000347e:	02c92683          	lw	a3,44(s2)
    80003482:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003484:	02d05763          	blez	a3,800034b2 <write_head+0x5a>
    80003488:	00020797          	auipc	a5,0x20
    8000348c:	bc878793          	addi	a5,a5,-1080 # 80023050 <log+0x30>
    80003490:	05c50713          	addi	a4,a0,92
    80003494:	36fd                	addiw	a3,a3,-1
    80003496:	1682                	slli	a3,a3,0x20
    80003498:	9281                	srli	a3,a3,0x20
    8000349a:	068a                	slli	a3,a3,0x2
    8000349c:	00020617          	auipc	a2,0x20
    800034a0:	bb860613          	addi	a2,a2,-1096 # 80023054 <log+0x34>
    800034a4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034a6:	4390                	lw	a2,0(a5)
    800034a8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034aa:	0791                	addi	a5,a5,4
    800034ac:	0711                	addi	a4,a4,4
    800034ae:	fed79ce3          	bne	a5,a3,800034a6 <write_head+0x4e>
  }
  bwrite(buf);
    800034b2:	8526                	mv	a0,s1
    800034b4:	fffff097          	auipc	ra,0xfffff
    800034b8:	0a4080e7          	jalr	164(ra) # 80002558 <bwrite>
  brelse(buf);
    800034bc:	8526                	mv	a0,s1
    800034be:	fffff097          	auipc	ra,0xfffff
    800034c2:	0d8080e7          	jalr	216(ra) # 80002596 <brelse>
}
    800034c6:	60e2                	ld	ra,24(sp)
    800034c8:	6442                	ld	s0,16(sp)
    800034ca:	64a2                	ld	s1,8(sp)
    800034cc:	6902                	ld	s2,0(sp)
    800034ce:	6105                	addi	sp,sp,32
    800034d0:	8082                	ret

00000000800034d2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d2:	00020797          	auipc	a5,0x20
    800034d6:	b7a7a783          	lw	a5,-1158(a5) # 8002304c <log+0x2c>
    800034da:	0af05d63          	blez	a5,80003594 <install_trans+0xc2>
{
    800034de:	7139                	addi	sp,sp,-64
    800034e0:	fc06                	sd	ra,56(sp)
    800034e2:	f822                	sd	s0,48(sp)
    800034e4:	f426                	sd	s1,40(sp)
    800034e6:	f04a                	sd	s2,32(sp)
    800034e8:	ec4e                	sd	s3,24(sp)
    800034ea:	e852                	sd	s4,16(sp)
    800034ec:	e456                	sd	s5,8(sp)
    800034ee:	e05a                	sd	s6,0(sp)
    800034f0:	0080                	addi	s0,sp,64
    800034f2:	8b2a                	mv	s6,a0
    800034f4:	00020a97          	auipc	s5,0x20
    800034f8:	b5ca8a93          	addi	s5,s5,-1188 # 80023050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034fc:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034fe:	00020997          	auipc	s3,0x20
    80003502:	b2298993          	addi	s3,s3,-1246 # 80023020 <log>
    80003506:	a035                	j	80003532 <install_trans+0x60>
      bunpin(dbuf);
    80003508:	8526                	mv	a0,s1
    8000350a:	fffff097          	auipc	ra,0xfffff
    8000350e:	166080e7          	jalr	358(ra) # 80002670 <bunpin>
    brelse(lbuf);
    80003512:	854a                	mv	a0,s2
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	082080e7          	jalr	130(ra) # 80002596 <brelse>
    brelse(dbuf);
    8000351c:	8526                	mv	a0,s1
    8000351e:	fffff097          	auipc	ra,0xfffff
    80003522:	078080e7          	jalr	120(ra) # 80002596 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003526:	2a05                	addiw	s4,s4,1
    80003528:	0a91                	addi	s5,s5,4
    8000352a:	02c9a783          	lw	a5,44(s3)
    8000352e:	04fa5963          	bge	s4,a5,80003580 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003532:	0189a583          	lw	a1,24(s3)
    80003536:	014585bb          	addw	a1,a1,s4
    8000353a:	2585                	addiw	a1,a1,1
    8000353c:	0289a503          	lw	a0,40(s3)
    80003540:	fffff097          	auipc	ra,0xfffff
    80003544:	f26080e7          	jalr	-218(ra) # 80002466 <bread>
    80003548:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000354a:	000aa583          	lw	a1,0(s5)
    8000354e:	0289a503          	lw	a0,40(s3)
    80003552:	fffff097          	auipc	ra,0xfffff
    80003556:	f14080e7          	jalr	-236(ra) # 80002466 <bread>
    8000355a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000355c:	40000613          	li	a2,1024
    80003560:	05890593          	addi	a1,s2,88
    80003564:	05850513          	addi	a0,a0,88
    80003568:	ffffd097          	auipc	ra,0xffffd
    8000356c:	c70080e7          	jalr	-912(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003570:	8526                	mv	a0,s1
    80003572:	fffff097          	auipc	ra,0xfffff
    80003576:	fe6080e7          	jalr	-26(ra) # 80002558 <bwrite>
    if(recovering == 0)
    8000357a:	f80b1ce3          	bnez	s6,80003512 <install_trans+0x40>
    8000357e:	b769                	j	80003508 <install_trans+0x36>
}
    80003580:	70e2                	ld	ra,56(sp)
    80003582:	7442                	ld	s0,48(sp)
    80003584:	74a2                	ld	s1,40(sp)
    80003586:	7902                	ld	s2,32(sp)
    80003588:	69e2                	ld	s3,24(sp)
    8000358a:	6a42                	ld	s4,16(sp)
    8000358c:	6aa2                	ld	s5,8(sp)
    8000358e:	6b02                	ld	s6,0(sp)
    80003590:	6121                	addi	sp,sp,64
    80003592:	8082                	ret
    80003594:	8082                	ret

0000000080003596 <initlog>:
{
    80003596:	7179                	addi	sp,sp,-48
    80003598:	f406                	sd	ra,40(sp)
    8000359a:	f022                	sd	s0,32(sp)
    8000359c:	ec26                	sd	s1,24(sp)
    8000359e:	e84a                	sd	s2,16(sp)
    800035a0:	e44e                	sd	s3,8(sp)
    800035a2:	1800                	addi	s0,sp,48
    800035a4:	892a                	mv	s2,a0
    800035a6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035a8:	00020497          	auipc	s1,0x20
    800035ac:	a7848493          	addi	s1,s1,-1416 # 80023020 <log>
    800035b0:	00005597          	auipc	a1,0x5
    800035b4:	fd858593          	addi	a1,a1,-40 # 80008588 <syscalls+0x1e8>
    800035b8:	8526                	mv	a0,s1
    800035ba:	00003097          	auipc	ra,0x3
    800035be:	ec8080e7          	jalr	-312(ra) # 80006482 <initlock>
  log.start = sb->logstart;
    800035c2:	0149a583          	lw	a1,20(s3)
    800035c6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035c8:	0109a783          	lw	a5,16(s3)
    800035cc:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035ce:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035d2:	854a                	mv	a0,s2
    800035d4:	fffff097          	auipc	ra,0xfffff
    800035d8:	e92080e7          	jalr	-366(ra) # 80002466 <bread>
  log.lh.n = lh->n;
    800035dc:	4d3c                	lw	a5,88(a0)
    800035de:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035e0:	02f05563          	blez	a5,8000360a <initlog+0x74>
    800035e4:	05c50713          	addi	a4,a0,92
    800035e8:	00020697          	auipc	a3,0x20
    800035ec:	a6868693          	addi	a3,a3,-1432 # 80023050 <log+0x30>
    800035f0:	37fd                	addiw	a5,a5,-1
    800035f2:	1782                	slli	a5,a5,0x20
    800035f4:	9381                	srli	a5,a5,0x20
    800035f6:	078a                	slli	a5,a5,0x2
    800035f8:	06050613          	addi	a2,a0,96
    800035fc:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800035fe:	4310                	lw	a2,0(a4)
    80003600:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003602:	0711                	addi	a4,a4,4
    80003604:	0691                	addi	a3,a3,4
    80003606:	fef71ce3          	bne	a4,a5,800035fe <initlog+0x68>
  brelse(buf);
    8000360a:	fffff097          	auipc	ra,0xfffff
    8000360e:	f8c080e7          	jalr	-116(ra) # 80002596 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003612:	4505                	li	a0,1
    80003614:	00000097          	auipc	ra,0x0
    80003618:	ebe080e7          	jalr	-322(ra) # 800034d2 <install_trans>
  log.lh.n = 0;
    8000361c:	00020797          	auipc	a5,0x20
    80003620:	a207a823          	sw	zero,-1488(a5) # 8002304c <log+0x2c>
  write_head(); // clear the log
    80003624:	00000097          	auipc	ra,0x0
    80003628:	e34080e7          	jalr	-460(ra) # 80003458 <write_head>
}
    8000362c:	70a2                	ld	ra,40(sp)
    8000362e:	7402                	ld	s0,32(sp)
    80003630:	64e2                	ld	s1,24(sp)
    80003632:	6942                	ld	s2,16(sp)
    80003634:	69a2                	ld	s3,8(sp)
    80003636:	6145                	addi	sp,sp,48
    80003638:	8082                	ret

000000008000363a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000363a:	1101                	addi	sp,sp,-32
    8000363c:	ec06                	sd	ra,24(sp)
    8000363e:	e822                	sd	s0,16(sp)
    80003640:	e426                	sd	s1,8(sp)
    80003642:	e04a                	sd	s2,0(sp)
    80003644:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003646:	00020517          	auipc	a0,0x20
    8000364a:	9da50513          	addi	a0,a0,-1574 # 80023020 <log>
    8000364e:	00003097          	auipc	ra,0x3
    80003652:	ec4080e7          	jalr	-316(ra) # 80006512 <acquire>
  while(1){
    if(log.committing){
    80003656:	00020497          	auipc	s1,0x20
    8000365a:	9ca48493          	addi	s1,s1,-1590 # 80023020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000365e:	4979                	li	s2,30
    80003660:	a039                	j	8000366e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003662:	85a6                	mv	a1,s1
    80003664:	8526                	mv	a0,s1
    80003666:	ffffe097          	auipc	ra,0xffffe
    8000366a:	ee6080e7          	jalr	-282(ra) # 8000154c <sleep>
    if(log.committing){
    8000366e:	50dc                	lw	a5,36(s1)
    80003670:	fbed                	bnez	a5,80003662 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003672:	509c                	lw	a5,32(s1)
    80003674:	0017871b          	addiw	a4,a5,1
    80003678:	0007069b          	sext.w	a3,a4
    8000367c:	0027179b          	slliw	a5,a4,0x2
    80003680:	9fb9                	addw	a5,a5,a4
    80003682:	0017979b          	slliw	a5,a5,0x1
    80003686:	54d8                	lw	a4,44(s1)
    80003688:	9fb9                	addw	a5,a5,a4
    8000368a:	00f95963          	bge	s2,a5,8000369c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000368e:	85a6                	mv	a1,s1
    80003690:	8526                	mv	a0,s1
    80003692:	ffffe097          	auipc	ra,0xffffe
    80003696:	eba080e7          	jalr	-326(ra) # 8000154c <sleep>
    8000369a:	bfd1                	j	8000366e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000369c:	00020517          	auipc	a0,0x20
    800036a0:	98450513          	addi	a0,a0,-1660 # 80023020 <log>
    800036a4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036a6:	00003097          	auipc	ra,0x3
    800036aa:	f20080e7          	jalr	-224(ra) # 800065c6 <release>
      break;
    }
  }
}
    800036ae:	60e2                	ld	ra,24(sp)
    800036b0:	6442                	ld	s0,16(sp)
    800036b2:	64a2                	ld	s1,8(sp)
    800036b4:	6902                	ld	s2,0(sp)
    800036b6:	6105                	addi	sp,sp,32
    800036b8:	8082                	ret

00000000800036ba <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036ba:	7139                	addi	sp,sp,-64
    800036bc:	fc06                	sd	ra,56(sp)
    800036be:	f822                	sd	s0,48(sp)
    800036c0:	f426                	sd	s1,40(sp)
    800036c2:	f04a                	sd	s2,32(sp)
    800036c4:	ec4e                	sd	s3,24(sp)
    800036c6:	e852                	sd	s4,16(sp)
    800036c8:	e456                	sd	s5,8(sp)
    800036ca:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036cc:	00020497          	auipc	s1,0x20
    800036d0:	95448493          	addi	s1,s1,-1708 # 80023020 <log>
    800036d4:	8526                	mv	a0,s1
    800036d6:	00003097          	auipc	ra,0x3
    800036da:	e3c080e7          	jalr	-452(ra) # 80006512 <acquire>
  log.outstanding -= 1;
    800036de:	509c                	lw	a5,32(s1)
    800036e0:	37fd                	addiw	a5,a5,-1
    800036e2:	0007891b          	sext.w	s2,a5
    800036e6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036e8:	50dc                	lw	a5,36(s1)
    800036ea:	efb9                	bnez	a5,80003748 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036ec:	06091663          	bnez	s2,80003758 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036f0:	00020497          	auipc	s1,0x20
    800036f4:	93048493          	addi	s1,s1,-1744 # 80023020 <log>
    800036f8:	4785                	li	a5,1
    800036fa:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036fc:	8526                	mv	a0,s1
    800036fe:	00003097          	auipc	ra,0x3
    80003702:	ec8080e7          	jalr	-312(ra) # 800065c6 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003706:	54dc                	lw	a5,44(s1)
    80003708:	06f04763          	bgtz	a5,80003776 <end_op+0xbc>
    acquire(&log.lock);
    8000370c:	00020497          	auipc	s1,0x20
    80003710:	91448493          	addi	s1,s1,-1772 # 80023020 <log>
    80003714:	8526                	mv	a0,s1
    80003716:	00003097          	auipc	ra,0x3
    8000371a:	dfc080e7          	jalr	-516(ra) # 80006512 <acquire>
    log.committing = 0;
    8000371e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003722:	8526                	mv	a0,s1
    80003724:	ffffe097          	auipc	ra,0xffffe
    80003728:	fb4080e7          	jalr	-76(ra) # 800016d8 <wakeup>
    release(&log.lock);
    8000372c:	8526                	mv	a0,s1
    8000372e:	00003097          	auipc	ra,0x3
    80003732:	e98080e7          	jalr	-360(ra) # 800065c6 <release>
}
    80003736:	70e2                	ld	ra,56(sp)
    80003738:	7442                	ld	s0,48(sp)
    8000373a:	74a2                	ld	s1,40(sp)
    8000373c:	7902                	ld	s2,32(sp)
    8000373e:	69e2                	ld	s3,24(sp)
    80003740:	6a42                	ld	s4,16(sp)
    80003742:	6aa2                	ld	s5,8(sp)
    80003744:	6121                	addi	sp,sp,64
    80003746:	8082                	ret
    panic("log.committing");
    80003748:	00005517          	auipc	a0,0x5
    8000374c:	e4850513          	addi	a0,a0,-440 # 80008590 <syscalls+0x1f0>
    80003750:	00003097          	auipc	ra,0x3
    80003754:	878080e7          	jalr	-1928(ra) # 80005fc8 <panic>
    wakeup(&log);
    80003758:	00020497          	auipc	s1,0x20
    8000375c:	8c848493          	addi	s1,s1,-1848 # 80023020 <log>
    80003760:	8526                	mv	a0,s1
    80003762:	ffffe097          	auipc	ra,0xffffe
    80003766:	f76080e7          	jalr	-138(ra) # 800016d8 <wakeup>
  release(&log.lock);
    8000376a:	8526                	mv	a0,s1
    8000376c:	00003097          	auipc	ra,0x3
    80003770:	e5a080e7          	jalr	-422(ra) # 800065c6 <release>
  if(do_commit){
    80003774:	b7c9                	j	80003736 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003776:	00020a97          	auipc	s5,0x20
    8000377a:	8daa8a93          	addi	s5,s5,-1830 # 80023050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000377e:	00020a17          	auipc	s4,0x20
    80003782:	8a2a0a13          	addi	s4,s4,-1886 # 80023020 <log>
    80003786:	018a2583          	lw	a1,24(s4)
    8000378a:	012585bb          	addw	a1,a1,s2
    8000378e:	2585                	addiw	a1,a1,1
    80003790:	028a2503          	lw	a0,40(s4)
    80003794:	fffff097          	auipc	ra,0xfffff
    80003798:	cd2080e7          	jalr	-814(ra) # 80002466 <bread>
    8000379c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000379e:	000aa583          	lw	a1,0(s5)
    800037a2:	028a2503          	lw	a0,40(s4)
    800037a6:	fffff097          	auipc	ra,0xfffff
    800037aa:	cc0080e7          	jalr	-832(ra) # 80002466 <bread>
    800037ae:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037b0:	40000613          	li	a2,1024
    800037b4:	05850593          	addi	a1,a0,88
    800037b8:	05848513          	addi	a0,s1,88
    800037bc:	ffffd097          	auipc	ra,0xffffd
    800037c0:	a1c080e7          	jalr	-1508(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800037c4:	8526                	mv	a0,s1
    800037c6:	fffff097          	auipc	ra,0xfffff
    800037ca:	d92080e7          	jalr	-622(ra) # 80002558 <bwrite>
    brelse(from);
    800037ce:	854e                	mv	a0,s3
    800037d0:	fffff097          	auipc	ra,0xfffff
    800037d4:	dc6080e7          	jalr	-570(ra) # 80002596 <brelse>
    brelse(to);
    800037d8:	8526                	mv	a0,s1
    800037da:	fffff097          	auipc	ra,0xfffff
    800037de:	dbc080e7          	jalr	-580(ra) # 80002596 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037e2:	2905                	addiw	s2,s2,1
    800037e4:	0a91                	addi	s5,s5,4
    800037e6:	02ca2783          	lw	a5,44(s4)
    800037ea:	f8f94ee3          	blt	s2,a5,80003786 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037ee:	00000097          	auipc	ra,0x0
    800037f2:	c6a080e7          	jalr	-918(ra) # 80003458 <write_head>
    install_trans(0); // Now install writes to home locations
    800037f6:	4501                	li	a0,0
    800037f8:	00000097          	auipc	ra,0x0
    800037fc:	cda080e7          	jalr	-806(ra) # 800034d2 <install_trans>
    log.lh.n = 0;
    80003800:	00020797          	auipc	a5,0x20
    80003804:	8407a623          	sw	zero,-1972(a5) # 8002304c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003808:	00000097          	auipc	ra,0x0
    8000380c:	c50080e7          	jalr	-944(ra) # 80003458 <write_head>
    80003810:	bdf5                	j	8000370c <end_op+0x52>

0000000080003812 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003812:	1101                	addi	sp,sp,-32
    80003814:	ec06                	sd	ra,24(sp)
    80003816:	e822                	sd	s0,16(sp)
    80003818:	e426                	sd	s1,8(sp)
    8000381a:	e04a                	sd	s2,0(sp)
    8000381c:	1000                	addi	s0,sp,32
    8000381e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003820:	00020917          	auipc	s2,0x20
    80003824:	80090913          	addi	s2,s2,-2048 # 80023020 <log>
    80003828:	854a                	mv	a0,s2
    8000382a:	00003097          	auipc	ra,0x3
    8000382e:	ce8080e7          	jalr	-792(ra) # 80006512 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003832:	02c92603          	lw	a2,44(s2)
    80003836:	47f5                	li	a5,29
    80003838:	06c7c563          	blt	a5,a2,800038a2 <log_write+0x90>
    8000383c:	00020797          	auipc	a5,0x20
    80003840:	8007a783          	lw	a5,-2048(a5) # 8002303c <log+0x1c>
    80003844:	37fd                	addiw	a5,a5,-1
    80003846:	04f65e63          	bge	a2,a5,800038a2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000384a:	0001f797          	auipc	a5,0x1f
    8000384e:	7f67a783          	lw	a5,2038(a5) # 80023040 <log+0x20>
    80003852:	06f05063          	blez	a5,800038b2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003856:	4781                	li	a5,0
    80003858:	06c05563          	blez	a2,800038c2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000385c:	44cc                	lw	a1,12(s1)
    8000385e:	0001f717          	auipc	a4,0x1f
    80003862:	7f270713          	addi	a4,a4,2034 # 80023050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003866:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003868:	4314                	lw	a3,0(a4)
    8000386a:	04b68c63          	beq	a3,a1,800038c2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000386e:	2785                	addiw	a5,a5,1
    80003870:	0711                	addi	a4,a4,4
    80003872:	fef61be3          	bne	a2,a5,80003868 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003876:	0621                	addi	a2,a2,8
    80003878:	060a                	slli	a2,a2,0x2
    8000387a:	0001f797          	auipc	a5,0x1f
    8000387e:	7a678793          	addi	a5,a5,1958 # 80023020 <log>
    80003882:	963e                	add	a2,a2,a5
    80003884:	44dc                	lw	a5,12(s1)
    80003886:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003888:	8526                	mv	a0,s1
    8000388a:	fffff097          	auipc	ra,0xfffff
    8000388e:	daa080e7          	jalr	-598(ra) # 80002634 <bpin>
    log.lh.n++;
    80003892:	0001f717          	auipc	a4,0x1f
    80003896:	78e70713          	addi	a4,a4,1934 # 80023020 <log>
    8000389a:	575c                	lw	a5,44(a4)
    8000389c:	2785                	addiw	a5,a5,1
    8000389e:	d75c                	sw	a5,44(a4)
    800038a0:	a835                	j	800038dc <log_write+0xca>
    panic("too big a transaction");
    800038a2:	00005517          	auipc	a0,0x5
    800038a6:	cfe50513          	addi	a0,a0,-770 # 800085a0 <syscalls+0x200>
    800038aa:	00002097          	auipc	ra,0x2
    800038ae:	71e080e7          	jalr	1822(ra) # 80005fc8 <panic>
    panic("log_write outside of trans");
    800038b2:	00005517          	auipc	a0,0x5
    800038b6:	d0650513          	addi	a0,a0,-762 # 800085b8 <syscalls+0x218>
    800038ba:	00002097          	auipc	ra,0x2
    800038be:	70e080e7          	jalr	1806(ra) # 80005fc8 <panic>
  log.lh.block[i] = b->blockno;
    800038c2:	00878713          	addi	a4,a5,8
    800038c6:	00271693          	slli	a3,a4,0x2
    800038ca:	0001f717          	auipc	a4,0x1f
    800038ce:	75670713          	addi	a4,a4,1878 # 80023020 <log>
    800038d2:	9736                	add	a4,a4,a3
    800038d4:	44d4                	lw	a3,12(s1)
    800038d6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038d8:	faf608e3          	beq	a2,a5,80003888 <log_write+0x76>
  }
  release(&log.lock);
    800038dc:	0001f517          	auipc	a0,0x1f
    800038e0:	74450513          	addi	a0,a0,1860 # 80023020 <log>
    800038e4:	00003097          	auipc	ra,0x3
    800038e8:	ce2080e7          	jalr	-798(ra) # 800065c6 <release>
}
    800038ec:	60e2                	ld	ra,24(sp)
    800038ee:	6442                	ld	s0,16(sp)
    800038f0:	64a2                	ld	s1,8(sp)
    800038f2:	6902                	ld	s2,0(sp)
    800038f4:	6105                	addi	sp,sp,32
    800038f6:	8082                	ret

00000000800038f8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038f8:	1101                	addi	sp,sp,-32
    800038fa:	ec06                	sd	ra,24(sp)
    800038fc:	e822                	sd	s0,16(sp)
    800038fe:	e426                	sd	s1,8(sp)
    80003900:	e04a                	sd	s2,0(sp)
    80003902:	1000                	addi	s0,sp,32
    80003904:	84aa                	mv	s1,a0
    80003906:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003908:	00005597          	auipc	a1,0x5
    8000390c:	cd058593          	addi	a1,a1,-816 # 800085d8 <syscalls+0x238>
    80003910:	0521                	addi	a0,a0,8
    80003912:	00003097          	auipc	ra,0x3
    80003916:	b70080e7          	jalr	-1168(ra) # 80006482 <initlock>
  lk->name = name;
    8000391a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000391e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003922:	0204a423          	sw	zero,40(s1)
}
    80003926:	60e2                	ld	ra,24(sp)
    80003928:	6442                	ld	s0,16(sp)
    8000392a:	64a2                	ld	s1,8(sp)
    8000392c:	6902                	ld	s2,0(sp)
    8000392e:	6105                	addi	sp,sp,32
    80003930:	8082                	ret

0000000080003932 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003932:	1101                	addi	sp,sp,-32
    80003934:	ec06                	sd	ra,24(sp)
    80003936:	e822                	sd	s0,16(sp)
    80003938:	e426                	sd	s1,8(sp)
    8000393a:	e04a                	sd	s2,0(sp)
    8000393c:	1000                	addi	s0,sp,32
    8000393e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003940:	00850913          	addi	s2,a0,8
    80003944:	854a                	mv	a0,s2
    80003946:	00003097          	auipc	ra,0x3
    8000394a:	bcc080e7          	jalr	-1076(ra) # 80006512 <acquire>
  while (lk->locked) {
    8000394e:	409c                	lw	a5,0(s1)
    80003950:	cb89                	beqz	a5,80003962 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003952:	85ca                	mv	a1,s2
    80003954:	8526                	mv	a0,s1
    80003956:	ffffe097          	auipc	ra,0xffffe
    8000395a:	bf6080e7          	jalr	-1034(ra) # 8000154c <sleep>
  while (lk->locked) {
    8000395e:	409c                	lw	a5,0(s1)
    80003960:	fbed                	bnez	a5,80003952 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003962:	4785                	li	a5,1
    80003964:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003966:	ffffd097          	auipc	ra,0xffffd
    8000396a:	4c8080e7          	jalr	1224(ra) # 80000e2e <myproc>
    8000396e:	591c                	lw	a5,48(a0)
    80003970:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003972:	854a                	mv	a0,s2
    80003974:	00003097          	auipc	ra,0x3
    80003978:	c52080e7          	jalr	-942(ra) # 800065c6 <release>
}
    8000397c:	60e2                	ld	ra,24(sp)
    8000397e:	6442                	ld	s0,16(sp)
    80003980:	64a2                	ld	s1,8(sp)
    80003982:	6902                	ld	s2,0(sp)
    80003984:	6105                	addi	sp,sp,32
    80003986:	8082                	ret

0000000080003988 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003988:	1101                	addi	sp,sp,-32
    8000398a:	ec06                	sd	ra,24(sp)
    8000398c:	e822                	sd	s0,16(sp)
    8000398e:	e426                	sd	s1,8(sp)
    80003990:	e04a                	sd	s2,0(sp)
    80003992:	1000                	addi	s0,sp,32
    80003994:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003996:	00850913          	addi	s2,a0,8
    8000399a:	854a                	mv	a0,s2
    8000399c:	00003097          	auipc	ra,0x3
    800039a0:	b76080e7          	jalr	-1162(ra) # 80006512 <acquire>
  lk->locked = 0;
    800039a4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039a8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039ac:	8526                	mv	a0,s1
    800039ae:	ffffe097          	auipc	ra,0xffffe
    800039b2:	d2a080e7          	jalr	-726(ra) # 800016d8 <wakeup>
  release(&lk->lk);
    800039b6:	854a                	mv	a0,s2
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	c0e080e7          	jalr	-1010(ra) # 800065c6 <release>
}
    800039c0:	60e2                	ld	ra,24(sp)
    800039c2:	6442                	ld	s0,16(sp)
    800039c4:	64a2                	ld	s1,8(sp)
    800039c6:	6902                	ld	s2,0(sp)
    800039c8:	6105                	addi	sp,sp,32
    800039ca:	8082                	ret

00000000800039cc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039cc:	7179                	addi	sp,sp,-48
    800039ce:	f406                	sd	ra,40(sp)
    800039d0:	f022                	sd	s0,32(sp)
    800039d2:	ec26                	sd	s1,24(sp)
    800039d4:	e84a                	sd	s2,16(sp)
    800039d6:	e44e                	sd	s3,8(sp)
    800039d8:	1800                	addi	s0,sp,48
    800039da:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039dc:	00850913          	addi	s2,a0,8
    800039e0:	854a                	mv	a0,s2
    800039e2:	00003097          	auipc	ra,0x3
    800039e6:	b30080e7          	jalr	-1232(ra) # 80006512 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ea:	409c                	lw	a5,0(s1)
    800039ec:	ef99                	bnez	a5,80003a0a <holdingsleep+0x3e>
    800039ee:	4481                	li	s1,0
  release(&lk->lk);
    800039f0:	854a                	mv	a0,s2
    800039f2:	00003097          	auipc	ra,0x3
    800039f6:	bd4080e7          	jalr	-1068(ra) # 800065c6 <release>
  return r;
}
    800039fa:	8526                	mv	a0,s1
    800039fc:	70a2                	ld	ra,40(sp)
    800039fe:	7402                	ld	s0,32(sp)
    80003a00:	64e2                	ld	s1,24(sp)
    80003a02:	6942                	ld	s2,16(sp)
    80003a04:	69a2                	ld	s3,8(sp)
    80003a06:	6145                	addi	sp,sp,48
    80003a08:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a0a:	0284a983          	lw	s3,40(s1)
    80003a0e:	ffffd097          	auipc	ra,0xffffd
    80003a12:	420080e7          	jalr	1056(ra) # 80000e2e <myproc>
    80003a16:	5904                	lw	s1,48(a0)
    80003a18:	413484b3          	sub	s1,s1,s3
    80003a1c:	0014b493          	seqz	s1,s1
    80003a20:	bfc1                	j	800039f0 <holdingsleep+0x24>

0000000080003a22 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a22:	1141                	addi	sp,sp,-16
    80003a24:	e406                	sd	ra,8(sp)
    80003a26:	e022                	sd	s0,0(sp)
    80003a28:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a2a:	00005597          	auipc	a1,0x5
    80003a2e:	bbe58593          	addi	a1,a1,-1090 # 800085e8 <syscalls+0x248>
    80003a32:	0001f517          	auipc	a0,0x1f
    80003a36:	73650513          	addi	a0,a0,1846 # 80023168 <ftable>
    80003a3a:	00003097          	auipc	ra,0x3
    80003a3e:	a48080e7          	jalr	-1464(ra) # 80006482 <initlock>
}
    80003a42:	60a2                	ld	ra,8(sp)
    80003a44:	6402                	ld	s0,0(sp)
    80003a46:	0141                	addi	sp,sp,16
    80003a48:	8082                	ret

0000000080003a4a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a4a:	1101                	addi	sp,sp,-32
    80003a4c:	ec06                	sd	ra,24(sp)
    80003a4e:	e822                	sd	s0,16(sp)
    80003a50:	e426                	sd	s1,8(sp)
    80003a52:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a54:	0001f517          	auipc	a0,0x1f
    80003a58:	71450513          	addi	a0,a0,1812 # 80023168 <ftable>
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	ab6080e7          	jalr	-1354(ra) # 80006512 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a64:	0001f497          	auipc	s1,0x1f
    80003a68:	71c48493          	addi	s1,s1,1820 # 80023180 <ftable+0x18>
    80003a6c:	00020717          	auipc	a4,0x20
    80003a70:	6b470713          	addi	a4,a4,1716 # 80024120 <ftable+0xfb8>
    if(f->ref == 0){
    80003a74:	40dc                	lw	a5,4(s1)
    80003a76:	cf99                	beqz	a5,80003a94 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a78:	02848493          	addi	s1,s1,40
    80003a7c:	fee49ce3          	bne	s1,a4,80003a74 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a80:	0001f517          	auipc	a0,0x1f
    80003a84:	6e850513          	addi	a0,a0,1768 # 80023168 <ftable>
    80003a88:	00003097          	auipc	ra,0x3
    80003a8c:	b3e080e7          	jalr	-1218(ra) # 800065c6 <release>
  return 0;
    80003a90:	4481                	li	s1,0
    80003a92:	a819                	j	80003aa8 <filealloc+0x5e>
      f->ref = 1;
    80003a94:	4785                	li	a5,1
    80003a96:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a98:	0001f517          	auipc	a0,0x1f
    80003a9c:	6d050513          	addi	a0,a0,1744 # 80023168 <ftable>
    80003aa0:	00003097          	auipc	ra,0x3
    80003aa4:	b26080e7          	jalr	-1242(ra) # 800065c6 <release>
}
    80003aa8:	8526                	mv	a0,s1
    80003aaa:	60e2                	ld	ra,24(sp)
    80003aac:	6442                	ld	s0,16(sp)
    80003aae:	64a2                	ld	s1,8(sp)
    80003ab0:	6105                	addi	sp,sp,32
    80003ab2:	8082                	ret

0000000080003ab4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ab4:	1101                	addi	sp,sp,-32
    80003ab6:	ec06                	sd	ra,24(sp)
    80003ab8:	e822                	sd	s0,16(sp)
    80003aba:	e426                	sd	s1,8(sp)
    80003abc:	1000                	addi	s0,sp,32
    80003abe:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ac0:	0001f517          	auipc	a0,0x1f
    80003ac4:	6a850513          	addi	a0,a0,1704 # 80023168 <ftable>
    80003ac8:	00003097          	auipc	ra,0x3
    80003acc:	a4a080e7          	jalr	-1462(ra) # 80006512 <acquire>
  if(f->ref < 1)
    80003ad0:	40dc                	lw	a5,4(s1)
    80003ad2:	02f05263          	blez	a5,80003af6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ad6:	2785                	addiw	a5,a5,1
    80003ad8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ada:	0001f517          	auipc	a0,0x1f
    80003ade:	68e50513          	addi	a0,a0,1678 # 80023168 <ftable>
    80003ae2:	00003097          	auipc	ra,0x3
    80003ae6:	ae4080e7          	jalr	-1308(ra) # 800065c6 <release>
  return f;
}
    80003aea:	8526                	mv	a0,s1
    80003aec:	60e2                	ld	ra,24(sp)
    80003aee:	6442                	ld	s0,16(sp)
    80003af0:	64a2                	ld	s1,8(sp)
    80003af2:	6105                	addi	sp,sp,32
    80003af4:	8082                	ret
    panic("filedup");
    80003af6:	00005517          	auipc	a0,0x5
    80003afa:	afa50513          	addi	a0,a0,-1286 # 800085f0 <syscalls+0x250>
    80003afe:	00002097          	auipc	ra,0x2
    80003b02:	4ca080e7          	jalr	1226(ra) # 80005fc8 <panic>

0000000080003b06 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b06:	7139                	addi	sp,sp,-64
    80003b08:	fc06                	sd	ra,56(sp)
    80003b0a:	f822                	sd	s0,48(sp)
    80003b0c:	f426                	sd	s1,40(sp)
    80003b0e:	f04a                	sd	s2,32(sp)
    80003b10:	ec4e                	sd	s3,24(sp)
    80003b12:	e852                	sd	s4,16(sp)
    80003b14:	e456                	sd	s5,8(sp)
    80003b16:	0080                	addi	s0,sp,64
    80003b18:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b1a:	0001f517          	auipc	a0,0x1f
    80003b1e:	64e50513          	addi	a0,a0,1614 # 80023168 <ftable>
    80003b22:	00003097          	auipc	ra,0x3
    80003b26:	9f0080e7          	jalr	-1552(ra) # 80006512 <acquire>
  if(f->ref < 1)
    80003b2a:	40dc                	lw	a5,4(s1)
    80003b2c:	06f05163          	blez	a5,80003b8e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b30:	37fd                	addiw	a5,a5,-1
    80003b32:	0007871b          	sext.w	a4,a5
    80003b36:	c0dc                	sw	a5,4(s1)
    80003b38:	06e04363          	bgtz	a4,80003b9e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b3c:	0004a903          	lw	s2,0(s1)
    80003b40:	0094ca83          	lbu	s5,9(s1)
    80003b44:	0104ba03          	ld	s4,16(s1)
    80003b48:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b4c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b50:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b54:	0001f517          	auipc	a0,0x1f
    80003b58:	61450513          	addi	a0,a0,1556 # 80023168 <ftable>
    80003b5c:	00003097          	auipc	ra,0x3
    80003b60:	a6a080e7          	jalr	-1430(ra) # 800065c6 <release>

  if(ff.type == FD_PIPE){
    80003b64:	4785                	li	a5,1
    80003b66:	04f90d63          	beq	s2,a5,80003bc0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b6a:	3979                	addiw	s2,s2,-2
    80003b6c:	4785                	li	a5,1
    80003b6e:	0527e063          	bltu	a5,s2,80003bae <fileclose+0xa8>
    begin_op();
    80003b72:	00000097          	auipc	ra,0x0
    80003b76:	ac8080e7          	jalr	-1336(ra) # 8000363a <begin_op>
    iput(ff.ip);
    80003b7a:	854e                	mv	a0,s3
    80003b7c:	fffff097          	auipc	ra,0xfffff
    80003b80:	2a6080e7          	jalr	678(ra) # 80002e22 <iput>
    end_op();
    80003b84:	00000097          	auipc	ra,0x0
    80003b88:	b36080e7          	jalr	-1226(ra) # 800036ba <end_op>
    80003b8c:	a00d                	j	80003bae <fileclose+0xa8>
    panic("fileclose");
    80003b8e:	00005517          	auipc	a0,0x5
    80003b92:	a6a50513          	addi	a0,a0,-1430 # 800085f8 <syscalls+0x258>
    80003b96:	00002097          	auipc	ra,0x2
    80003b9a:	432080e7          	jalr	1074(ra) # 80005fc8 <panic>
    release(&ftable.lock);
    80003b9e:	0001f517          	auipc	a0,0x1f
    80003ba2:	5ca50513          	addi	a0,a0,1482 # 80023168 <ftable>
    80003ba6:	00003097          	auipc	ra,0x3
    80003baa:	a20080e7          	jalr	-1504(ra) # 800065c6 <release>
  }
}
    80003bae:	70e2                	ld	ra,56(sp)
    80003bb0:	7442                	ld	s0,48(sp)
    80003bb2:	74a2                	ld	s1,40(sp)
    80003bb4:	7902                	ld	s2,32(sp)
    80003bb6:	69e2                	ld	s3,24(sp)
    80003bb8:	6a42                	ld	s4,16(sp)
    80003bba:	6aa2                	ld	s5,8(sp)
    80003bbc:	6121                	addi	sp,sp,64
    80003bbe:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bc0:	85d6                	mv	a1,s5
    80003bc2:	8552                	mv	a0,s4
    80003bc4:	00000097          	auipc	ra,0x0
    80003bc8:	34c080e7          	jalr	844(ra) # 80003f10 <pipeclose>
    80003bcc:	b7cd                	j	80003bae <fileclose+0xa8>

0000000080003bce <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bce:	715d                	addi	sp,sp,-80
    80003bd0:	e486                	sd	ra,72(sp)
    80003bd2:	e0a2                	sd	s0,64(sp)
    80003bd4:	fc26                	sd	s1,56(sp)
    80003bd6:	f84a                	sd	s2,48(sp)
    80003bd8:	f44e                	sd	s3,40(sp)
    80003bda:	0880                	addi	s0,sp,80
    80003bdc:	84aa                	mv	s1,a0
    80003bde:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003be0:	ffffd097          	auipc	ra,0xffffd
    80003be4:	24e080e7          	jalr	590(ra) # 80000e2e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003be8:	409c                	lw	a5,0(s1)
    80003bea:	37f9                	addiw	a5,a5,-2
    80003bec:	4705                	li	a4,1
    80003bee:	04f76763          	bltu	a4,a5,80003c3c <filestat+0x6e>
    80003bf2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bf4:	6c88                	ld	a0,24(s1)
    80003bf6:	fffff097          	auipc	ra,0xfffff
    80003bfa:	072080e7          	jalr	114(ra) # 80002c68 <ilock>
    stati(f->ip, &st);
    80003bfe:	fb840593          	addi	a1,s0,-72
    80003c02:	6c88                	ld	a0,24(s1)
    80003c04:	fffff097          	auipc	ra,0xfffff
    80003c08:	2ee080e7          	jalr	750(ra) # 80002ef2 <stati>
    iunlock(f->ip);
    80003c0c:	6c88                	ld	a0,24(s1)
    80003c0e:	fffff097          	auipc	ra,0xfffff
    80003c12:	11c080e7          	jalr	284(ra) # 80002d2a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c16:	46e1                	li	a3,24
    80003c18:	fb840613          	addi	a2,s0,-72
    80003c1c:	85ce                	mv	a1,s3
    80003c1e:	05093503          	ld	a0,80(s2)
    80003c22:	ffffd097          	auipc	ra,0xffffd
    80003c26:	ece080e7          	jalr	-306(ra) # 80000af0 <copyout>
    80003c2a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c2e:	60a6                	ld	ra,72(sp)
    80003c30:	6406                	ld	s0,64(sp)
    80003c32:	74e2                	ld	s1,56(sp)
    80003c34:	7942                	ld	s2,48(sp)
    80003c36:	79a2                	ld	s3,40(sp)
    80003c38:	6161                	addi	sp,sp,80
    80003c3a:	8082                	ret
  return -1;
    80003c3c:	557d                	li	a0,-1
    80003c3e:	bfc5                	j	80003c2e <filestat+0x60>

0000000080003c40 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c40:	7179                	addi	sp,sp,-48
    80003c42:	f406                	sd	ra,40(sp)
    80003c44:	f022                	sd	s0,32(sp)
    80003c46:	ec26                	sd	s1,24(sp)
    80003c48:	e84a                	sd	s2,16(sp)
    80003c4a:	e44e                	sd	s3,8(sp)
    80003c4c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c4e:	00854783          	lbu	a5,8(a0)
    80003c52:	c3d5                	beqz	a5,80003cf6 <fileread+0xb6>
    80003c54:	84aa                	mv	s1,a0
    80003c56:	89ae                	mv	s3,a1
    80003c58:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c5a:	411c                	lw	a5,0(a0)
    80003c5c:	4705                	li	a4,1
    80003c5e:	04e78963          	beq	a5,a4,80003cb0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c62:	470d                	li	a4,3
    80003c64:	04e78d63          	beq	a5,a4,80003cbe <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c68:	4709                	li	a4,2
    80003c6a:	06e79e63          	bne	a5,a4,80003ce6 <fileread+0xa6>
    ilock(f->ip);
    80003c6e:	6d08                	ld	a0,24(a0)
    80003c70:	fffff097          	auipc	ra,0xfffff
    80003c74:	ff8080e7          	jalr	-8(ra) # 80002c68 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c78:	874a                	mv	a4,s2
    80003c7a:	5094                	lw	a3,32(s1)
    80003c7c:	864e                	mv	a2,s3
    80003c7e:	4585                	li	a1,1
    80003c80:	6c88                	ld	a0,24(s1)
    80003c82:	fffff097          	auipc	ra,0xfffff
    80003c86:	29a080e7          	jalr	666(ra) # 80002f1c <readi>
    80003c8a:	892a                	mv	s2,a0
    80003c8c:	00a05563          	blez	a0,80003c96 <fileread+0x56>
      f->off += r;
    80003c90:	509c                	lw	a5,32(s1)
    80003c92:	9fa9                	addw	a5,a5,a0
    80003c94:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c96:	6c88                	ld	a0,24(s1)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	092080e7          	jalr	146(ra) # 80002d2a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ca0:	854a                	mv	a0,s2
    80003ca2:	70a2                	ld	ra,40(sp)
    80003ca4:	7402                	ld	s0,32(sp)
    80003ca6:	64e2                	ld	s1,24(sp)
    80003ca8:	6942                	ld	s2,16(sp)
    80003caa:	69a2                	ld	s3,8(sp)
    80003cac:	6145                	addi	sp,sp,48
    80003cae:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cb0:	6908                	ld	a0,16(a0)
    80003cb2:	00000097          	auipc	ra,0x0
    80003cb6:	3c8080e7          	jalr	968(ra) # 8000407a <piperead>
    80003cba:	892a                	mv	s2,a0
    80003cbc:	b7d5                	j	80003ca0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cbe:	02451783          	lh	a5,36(a0)
    80003cc2:	03079693          	slli	a3,a5,0x30
    80003cc6:	92c1                	srli	a3,a3,0x30
    80003cc8:	4725                	li	a4,9
    80003cca:	02d76863          	bltu	a4,a3,80003cfa <fileread+0xba>
    80003cce:	0792                	slli	a5,a5,0x4
    80003cd0:	0001f717          	auipc	a4,0x1f
    80003cd4:	3f870713          	addi	a4,a4,1016 # 800230c8 <devsw>
    80003cd8:	97ba                	add	a5,a5,a4
    80003cda:	639c                	ld	a5,0(a5)
    80003cdc:	c38d                	beqz	a5,80003cfe <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cde:	4505                	li	a0,1
    80003ce0:	9782                	jalr	a5
    80003ce2:	892a                	mv	s2,a0
    80003ce4:	bf75                	j	80003ca0 <fileread+0x60>
    panic("fileread");
    80003ce6:	00005517          	auipc	a0,0x5
    80003cea:	92250513          	addi	a0,a0,-1758 # 80008608 <syscalls+0x268>
    80003cee:	00002097          	auipc	ra,0x2
    80003cf2:	2da080e7          	jalr	730(ra) # 80005fc8 <panic>
    return -1;
    80003cf6:	597d                	li	s2,-1
    80003cf8:	b765                	j	80003ca0 <fileread+0x60>
      return -1;
    80003cfa:	597d                	li	s2,-1
    80003cfc:	b755                	j	80003ca0 <fileread+0x60>
    80003cfe:	597d                	li	s2,-1
    80003d00:	b745                	j	80003ca0 <fileread+0x60>

0000000080003d02 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d02:	715d                	addi	sp,sp,-80
    80003d04:	e486                	sd	ra,72(sp)
    80003d06:	e0a2                	sd	s0,64(sp)
    80003d08:	fc26                	sd	s1,56(sp)
    80003d0a:	f84a                	sd	s2,48(sp)
    80003d0c:	f44e                	sd	s3,40(sp)
    80003d0e:	f052                	sd	s4,32(sp)
    80003d10:	ec56                	sd	s5,24(sp)
    80003d12:	e85a                	sd	s6,16(sp)
    80003d14:	e45e                	sd	s7,8(sp)
    80003d16:	e062                	sd	s8,0(sp)
    80003d18:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d1a:	00954783          	lbu	a5,9(a0)
    80003d1e:	10078663          	beqz	a5,80003e2a <filewrite+0x128>
    80003d22:	892a                	mv	s2,a0
    80003d24:	8aae                	mv	s5,a1
    80003d26:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d28:	411c                	lw	a5,0(a0)
    80003d2a:	4705                	li	a4,1
    80003d2c:	02e78263          	beq	a5,a4,80003d50 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d30:	470d                	li	a4,3
    80003d32:	02e78663          	beq	a5,a4,80003d5e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d36:	4709                	li	a4,2
    80003d38:	0ee79163          	bne	a5,a4,80003e1a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d3c:	0ac05d63          	blez	a2,80003df6 <filewrite+0xf4>
    int i = 0;
    80003d40:	4981                	li	s3,0
    80003d42:	6b05                	lui	s6,0x1
    80003d44:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d48:	6b85                	lui	s7,0x1
    80003d4a:	c00b8b9b          	addiw	s7,s7,-1024
    80003d4e:	a861                	j	80003de6 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d50:	6908                	ld	a0,16(a0)
    80003d52:	00000097          	auipc	ra,0x0
    80003d56:	22e080e7          	jalr	558(ra) # 80003f80 <pipewrite>
    80003d5a:	8a2a                	mv	s4,a0
    80003d5c:	a045                	j	80003dfc <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d5e:	02451783          	lh	a5,36(a0)
    80003d62:	03079693          	slli	a3,a5,0x30
    80003d66:	92c1                	srli	a3,a3,0x30
    80003d68:	4725                	li	a4,9
    80003d6a:	0cd76263          	bltu	a4,a3,80003e2e <filewrite+0x12c>
    80003d6e:	0792                	slli	a5,a5,0x4
    80003d70:	0001f717          	auipc	a4,0x1f
    80003d74:	35870713          	addi	a4,a4,856 # 800230c8 <devsw>
    80003d78:	97ba                	add	a5,a5,a4
    80003d7a:	679c                	ld	a5,8(a5)
    80003d7c:	cbdd                	beqz	a5,80003e32 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d7e:	4505                	li	a0,1
    80003d80:	9782                	jalr	a5
    80003d82:	8a2a                	mv	s4,a0
    80003d84:	a8a5                	j	80003dfc <filewrite+0xfa>
    80003d86:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d8a:	00000097          	auipc	ra,0x0
    80003d8e:	8b0080e7          	jalr	-1872(ra) # 8000363a <begin_op>
      ilock(f->ip);
    80003d92:	01893503          	ld	a0,24(s2)
    80003d96:	fffff097          	auipc	ra,0xfffff
    80003d9a:	ed2080e7          	jalr	-302(ra) # 80002c68 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d9e:	8762                	mv	a4,s8
    80003da0:	02092683          	lw	a3,32(s2)
    80003da4:	01598633          	add	a2,s3,s5
    80003da8:	4585                	li	a1,1
    80003daa:	01893503          	ld	a0,24(s2)
    80003dae:	fffff097          	auipc	ra,0xfffff
    80003db2:	266080e7          	jalr	614(ra) # 80003014 <writei>
    80003db6:	84aa                	mv	s1,a0
    80003db8:	00a05763          	blez	a0,80003dc6 <filewrite+0xc4>
        f->off += r;
    80003dbc:	02092783          	lw	a5,32(s2)
    80003dc0:	9fa9                	addw	a5,a5,a0
    80003dc2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dc6:	01893503          	ld	a0,24(s2)
    80003dca:	fffff097          	auipc	ra,0xfffff
    80003dce:	f60080e7          	jalr	-160(ra) # 80002d2a <iunlock>
      end_op();
    80003dd2:	00000097          	auipc	ra,0x0
    80003dd6:	8e8080e7          	jalr	-1816(ra) # 800036ba <end_op>

      if(r != n1){
    80003dda:	009c1f63          	bne	s8,s1,80003df8 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003dde:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003de2:	0149db63          	bge	s3,s4,80003df8 <filewrite+0xf6>
      int n1 = n - i;
    80003de6:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003dea:	84be                	mv	s1,a5
    80003dec:	2781                	sext.w	a5,a5
    80003dee:	f8fb5ce3          	bge	s6,a5,80003d86 <filewrite+0x84>
    80003df2:	84de                	mv	s1,s7
    80003df4:	bf49                	j	80003d86 <filewrite+0x84>
    int i = 0;
    80003df6:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003df8:	013a1f63          	bne	s4,s3,80003e16 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dfc:	8552                	mv	a0,s4
    80003dfe:	60a6                	ld	ra,72(sp)
    80003e00:	6406                	ld	s0,64(sp)
    80003e02:	74e2                	ld	s1,56(sp)
    80003e04:	7942                	ld	s2,48(sp)
    80003e06:	79a2                	ld	s3,40(sp)
    80003e08:	7a02                	ld	s4,32(sp)
    80003e0a:	6ae2                	ld	s5,24(sp)
    80003e0c:	6b42                	ld	s6,16(sp)
    80003e0e:	6ba2                	ld	s7,8(sp)
    80003e10:	6c02                	ld	s8,0(sp)
    80003e12:	6161                	addi	sp,sp,80
    80003e14:	8082                	ret
    ret = (i == n ? n : -1);
    80003e16:	5a7d                	li	s4,-1
    80003e18:	b7d5                	j	80003dfc <filewrite+0xfa>
    panic("filewrite");
    80003e1a:	00004517          	auipc	a0,0x4
    80003e1e:	7fe50513          	addi	a0,a0,2046 # 80008618 <syscalls+0x278>
    80003e22:	00002097          	auipc	ra,0x2
    80003e26:	1a6080e7          	jalr	422(ra) # 80005fc8 <panic>
    return -1;
    80003e2a:	5a7d                	li	s4,-1
    80003e2c:	bfc1                	j	80003dfc <filewrite+0xfa>
      return -1;
    80003e2e:	5a7d                	li	s4,-1
    80003e30:	b7f1                	j	80003dfc <filewrite+0xfa>
    80003e32:	5a7d                	li	s4,-1
    80003e34:	b7e1                	j	80003dfc <filewrite+0xfa>

0000000080003e36 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e36:	7179                	addi	sp,sp,-48
    80003e38:	f406                	sd	ra,40(sp)
    80003e3a:	f022                	sd	s0,32(sp)
    80003e3c:	ec26                	sd	s1,24(sp)
    80003e3e:	e84a                	sd	s2,16(sp)
    80003e40:	e44e                	sd	s3,8(sp)
    80003e42:	e052                	sd	s4,0(sp)
    80003e44:	1800                	addi	s0,sp,48
    80003e46:	84aa                	mv	s1,a0
    80003e48:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e4a:	0005b023          	sd	zero,0(a1)
    80003e4e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e52:	00000097          	auipc	ra,0x0
    80003e56:	bf8080e7          	jalr	-1032(ra) # 80003a4a <filealloc>
    80003e5a:	e088                	sd	a0,0(s1)
    80003e5c:	c551                	beqz	a0,80003ee8 <pipealloc+0xb2>
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	bec080e7          	jalr	-1044(ra) # 80003a4a <filealloc>
    80003e66:	00aa3023          	sd	a0,0(s4)
    80003e6a:	c92d                	beqz	a0,80003edc <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e6c:	ffffc097          	auipc	ra,0xffffc
    80003e70:	2ac080e7          	jalr	684(ra) # 80000118 <kalloc>
    80003e74:	892a                	mv	s2,a0
    80003e76:	c125                	beqz	a0,80003ed6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e78:	4985                	li	s3,1
    80003e7a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e7e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e82:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e86:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e8a:	00004597          	auipc	a1,0x4
    80003e8e:	79e58593          	addi	a1,a1,1950 # 80008628 <syscalls+0x288>
    80003e92:	00002097          	auipc	ra,0x2
    80003e96:	5f0080e7          	jalr	1520(ra) # 80006482 <initlock>
  (*f0)->type = FD_PIPE;
    80003e9a:	609c                	ld	a5,0(s1)
    80003e9c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ea0:	609c                	ld	a5,0(s1)
    80003ea2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ea6:	609c                	ld	a5,0(s1)
    80003ea8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eac:	609c                	ld	a5,0(s1)
    80003eae:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eb2:	000a3783          	ld	a5,0(s4)
    80003eb6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003eba:	000a3783          	ld	a5,0(s4)
    80003ebe:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ec2:	000a3783          	ld	a5,0(s4)
    80003ec6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eca:	000a3783          	ld	a5,0(s4)
    80003ece:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ed2:	4501                	li	a0,0
    80003ed4:	a025                	j	80003efc <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ed6:	6088                	ld	a0,0(s1)
    80003ed8:	e501                	bnez	a0,80003ee0 <pipealloc+0xaa>
    80003eda:	a039                	j	80003ee8 <pipealloc+0xb2>
    80003edc:	6088                	ld	a0,0(s1)
    80003ede:	c51d                	beqz	a0,80003f0c <pipealloc+0xd6>
    fileclose(*f0);
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	c26080e7          	jalr	-986(ra) # 80003b06 <fileclose>
  if(*f1)
    80003ee8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eec:	557d                	li	a0,-1
  if(*f1)
    80003eee:	c799                	beqz	a5,80003efc <pipealloc+0xc6>
    fileclose(*f1);
    80003ef0:	853e                	mv	a0,a5
    80003ef2:	00000097          	auipc	ra,0x0
    80003ef6:	c14080e7          	jalr	-1004(ra) # 80003b06 <fileclose>
  return -1;
    80003efa:	557d                	li	a0,-1
}
    80003efc:	70a2                	ld	ra,40(sp)
    80003efe:	7402                	ld	s0,32(sp)
    80003f00:	64e2                	ld	s1,24(sp)
    80003f02:	6942                	ld	s2,16(sp)
    80003f04:	69a2                	ld	s3,8(sp)
    80003f06:	6a02                	ld	s4,0(sp)
    80003f08:	6145                	addi	sp,sp,48
    80003f0a:	8082                	ret
  return -1;
    80003f0c:	557d                	li	a0,-1
    80003f0e:	b7fd                	j	80003efc <pipealloc+0xc6>

0000000080003f10 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f10:	1101                	addi	sp,sp,-32
    80003f12:	ec06                	sd	ra,24(sp)
    80003f14:	e822                	sd	s0,16(sp)
    80003f16:	e426                	sd	s1,8(sp)
    80003f18:	e04a                	sd	s2,0(sp)
    80003f1a:	1000                	addi	s0,sp,32
    80003f1c:	84aa                	mv	s1,a0
    80003f1e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f20:	00002097          	auipc	ra,0x2
    80003f24:	5f2080e7          	jalr	1522(ra) # 80006512 <acquire>
  if(writable){
    80003f28:	02090d63          	beqz	s2,80003f62 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f2c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f30:	21848513          	addi	a0,s1,536
    80003f34:	ffffd097          	auipc	ra,0xffffd
    80003f38:	7a4080e7          	jalr	1956(ra) # 800016d8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f3c:	2204b783          	ld	a5,544(s1)
    80003f40:	eb95                	bnez	a5,80003f74 <pipeclose+0x64>
    release(&pi->lock);
    80003f42:	8526                	mv	a0,s1
    80003f44:	00002097          	auipc	ra,0x2
    80003f48:	682080e7          	jalr	1666(ra) # 800065c6 <release>
    kfree((char*)pi);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	ffffc097          	auipc	ra,0xffffc
    80003f52:	0ce080e7          	jalr	206(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f56:	60e2                	ld	ra,24(sp)
    80003f58:	6442                	ld	s0,16(sp)
    80003f5a:	64a2                	ld	s1,8(sp)
    80003f5c:	6902                	ld	s2,0(sp)
    80003f5e:	6105                	addi	sp,sp,32
    80003f60:	8082                	ret
    pi->readopen = 0;
    80003f62:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f66:	21c48513          	addi	a0,s1,540
    80003f6a:	ffffd097          	auipc	ra,0xffffd
    80003f6e:	76e080e7          	jalr	1902(ra) # 800016d8 <wakeup>
    80003f72:	b7e9                	j	80003f3c <pipeclose+0x2c>
    release(&pi->lock);
    80003f74:	8526                	mv	a0,s1
    80003f76:	00002097          	auipc	ra,0x2
    80003f7a:	650080e7          	jalr	1616(ra) # 800065c6 <release>
}
    80003f7e:	bfe1                	j	80003f56 <pipeclose+0x46>

0000000080003f80 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f80:	7159                	addi	sp,sp,-112
    80003f82:	f486                	sd	ra,104(sp)
    80003f84:	f0a2                	sd	s0,96(sp)
    80003f86:	eca6                	sd	s1,88(sp)
    80003f88:	e8ca                	sd	s2,80(sp)
    80003f8a:	e4ce                	sd	s3,72(sp)
    80003f8c:	e0d2                	sd	s4,64(sp)
    80003f8e:	fc56                	sd	s5,56(sp)
    80003f90:	f85a                	sd	s6,48(sp)
    80003f92:	f45e                	sd	s7,40(sp)
    80003f94:	f062                	sd	s8,32(sp)
    80003f96:	ec66                	sd	s9,24(sp)
    80003f98:	1880                	addi	s0,sp,112
    80003f9a:	84aa                	mv	s1,a0
    80003f9c:	8aae                	mv	s5,a1
    80003f9e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fa0:	ffffd097          	auipc	ra,0xffffd
    80003fa4:	e8e080e7          	jalr	-370(ra) # 80000e2e <myproc>
    80003fa8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003faa:	8526                	mv	a0,s1
    80003fac:	00002097          	auipc	ra,0x2
    80003fb0:	566080e7          	jalr	1382(ra) # 80006512 <acquire>
  while(i < n){
    80003fb4:	0d405163          	blez	s4,80004076 <pipewrite+0xf6>
    80003fb8:	8ba6                	mv	s7,s1
  int i = 0;
    80003fba:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fbc:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fbe:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fc2:	21c48c13          	addi	s8,s1,540
    80003fc6:	a08d                	j	80004028 <pipewrite+0xa8>
      release(&pi->lock);
    80003fc8:	8526                	mv	a0,s1
    80003fca:	00002097          	auipc	ra,0x2
    80003fce:	5fc080e7          	jalr	1532(ra) # 800065c6 <release>
      return -1;
    80003fd2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fd4:	854a                	mv	a0,s2
    80003fd6:	70a6                	ld	ra,104(sp)
    80003fd8:	7406                	ld	s0,96(sp)
    80003fda:	64e6                	ld	s1,88(sp)
    80003fdc:	6946                	ld	s2,80(sp)
    80003fde:	69a6                	ld	s3,72(sp)
    80003fe0:	6a06                	ld	s4,64(sp)
    80003fe2:	7ae2                	ld	s5,56(sp)
    80003fe4:	7b42                	ld	s6,48(sp)
    80003fe6:	7ba2                	ld	s7,40(sp)
    80003fe8:	7c02                	ld	s8,32(sp)
    80003fea:	6ce2                	ld	s9,24(sp)
    80003fec:	6165                	addi	sp,sp,112
    80003fee:	8082                	ret
      wakeup(&pi->nread);
    80003ff0:	8566                	mv	a0,s9
    80003ff2:	ffffd097          	auipc	ra,0xffffd
    80003ff6:	6e6080e7          	jalr	1766(ra) # 800016d8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ffa:	85de                	mv	a1,s7
    80003ffc:	8562                	mv	a0,s8
    80003ffe:	ffffd097          	auipc	ra,0xffffd
    80004002:	54e080e7          	jalr	1358(ra) # 8000154c <sleep>
    80004006:	a839                	j	80004024 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004008:	21c4a783          	lw	a5,540(s1)
    8000400c:	0017871b          	addiw	a4,a5,1
    80004010:	20e4ae23          	sw	a4,540(s1)
    80004014:	1ff7f793          	andi	a5,a5,511
    80004018:	97a6                	add	a5,a5,s1
    8000401a:	f9f44703          	lbu	a4,-97(s0)
    8000401e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004022:	2905                	addiw	s2,s2,1
  while(i < n){
    80004024:	03495d63          	bge	s2,s4,8000405e <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004028:	2204a783          	lw	a5,544(s1)
    8000402c:	dfd1                	beqz	a5,80003fc8 <pipewrite+0x48>
    8000402e:	0289a783          	lw	a5,40(s3)
    80004032:	fbd9                	bnez	a5,80003fc8 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004034:	2184a783          	lw	a5,536(s1)
    80004038:	21c4a703          	lw	a4,540(s1)
    8000403c:	2007879b          	addiw	a5,a5,512
    80004040:	faf708e3          	beq	a4,a5,80003ff0 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004044:	4685                	li	a3,1
    80004046:	01590633          	add	a2,s2,s5
    8000404a:	f9f40593          	addi	a1,s0,-97
    8000404e:	0509b503          	ld	a0,80(s3)
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	b2a080e7          	jalr	-1238(ra) # 80000b7c <copyin>
    8000405a:	fb6517e3          	bne	a0,s6,80004008 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000405e:	21848513          	addi	a0,s1,536
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	676080e7          	jalr	1654(ra) # 800016d8 <wakeup>
  release(&pi->lock);
    8000406a:	8526                	mv	a0,s1
    8000406c:	00002097          	auipc	ra,0x2
    80004070:	55a080e7          	jalr	1370(ra) # 800065c6 <release>
  return i;
    80004074:	b785                	j	80003fd4 <pipewrite+0x54>
  int i = 0;
    80004076:	4901                	li	s2,0
    80004078:	b7dd                	j	8000405e <pipewrite+0xde>

000000008000407a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000407a:	715d                	addi	sp,sp,-80
    8000407c:	e486                	sd	ra,72(sp)
    8000407e:	e0a2                	sd	s0,64(sp)
    80004080:	fc26                	sd	s1,56(sp)
    80004082:	f84a                	sd	s2,48(sp)
    80004084:	f44e                	sd	s3,40(sp)
    80004086:	f052                	sd	s4,32(sp)
    80004088:	ec56                	sd	s5,24(sp)
    8000408a:	e85a                	sd	s6,16(sp)
    8000408c:	0880                	addi	s0,sp,80
    8000408e:	84aa                	mv	s1,a0
    80004090:	892e                	mv	s2,a1
    80004092:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004094:	ffffd097          	auipc	ra,0xffffd
    80004098:	d9a080e7          	jalr	-614(ra) # 80000e2e <myproc>
    8000409c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000409e:	8b26                	mv	s6,s1
    800040a0:	8526                	mv	a0,s1
    800040a2:	00002097          	auipc	ra,0x2
    800040a6:	470080e7          	jalr	1136(ra) # 80006512 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040aa:	2184a703          	lw	a4,536(s1)
    800040ae:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040b2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b6:	02f71463          	bne	a4,a5,800040de <piperead+0x64>
    800040ba:	2244a783          	lw	a5,548(s1)
    800040be:	c385                	beqz	a5,800040de <piperead+0x64>
    if(pr->killed){
    800040c0:	028a2783          	lw	a5,40(s4)
    800040c4:	ebc1                	bnez	a5,80004154 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040c6:	85da                	mv	a1,s6
    800040c8:	854e                	mv	a0,s3
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	482080e7          	jalr	1154(ra) # 8000154c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040d2:	2184a703          	lw	a4,536(s1)
    800040d6:	21c4a783          	lw	a5,540(s1)
    800040da:	fef700e3          	beq	a4,a5,800040ba <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040de:	09505263          	blez	s5,80004162 <piperead+0xe8>
    800040e2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040e4:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040e6:	2184a783          	lw	a5,536(s1)
    800040ea:	21c4a703          	lw	a4,540(s1)
    800040ee:	02f70d63          	beq	a4,a5,80004128 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040f2:	0017871b          	addiw	a4,a5,1
    800040f6:	20e4ac23          	sw	a4,536(s1)
    800040fa:	1ff7f793          	andi	a5,a5,511
    800040fe:	97a6                	add	a5,a5,s1
    80004100:	0187c783          	lbu	a5,24(a5)
    80004104:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004108:	4685                	li	a3,1
    8000410a:	fbf40613          	addi	a2,s0,-65
    8000410e:	85ca                	mv	a1,s2
    80004110:	050a3503          	ld	a0,80(s4)
    80004114:	ffffd097          	auipc	ra,0xffffd
    80004118:	9dc080e7          	jalr	-1572(ra) # 80000af0 <copyout>
    8000411c:	01650663          	beq	a0,s6,80004128 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004120:	2985                	addiw	s3,s3,1
    80004122:	0905                	addi	s2,s2,1
    80004124:	fd3a91e3          	bne	s5,s3,800040e6 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004128:	21c48513          	addi	a0,s1,540
    8000412c:	ffffd097          	auipc	ra,0xffffd
    80004130:	5ac080e7          	jalr	1452(ra) # 800016d8 <wakeup>
  release(&pi->lock);
    80004134:	8526                	mv	a0,s1
    80004136:	00002097          	auipc	ra,0x2
    8000413a:	490080e7          	jalr	1168(ra) # 800065c6 <release>
  return i;
}
    8000413e:	854e                	mv	a0,s3
    80004140:	60a6                	ld	ra,72(sp)
    80004142:	6406                	ld	s0,64(sp)
    80004144:	74e2                	ld	s1,56(sp)
    80004146:	7942                	ld	s2,48(sp)
    80004148:	79a2                	ld	s3,40(sp)
    8000414a:	7a02                	ld	s4,32(sp)
    8000414c:	6ae2                	ld	s5,24(sp)
    8000414e:	6b42                	ld	s6,16(sp)
    80004150:	6161                	addi	sp,sp,80
    80004152:	8082                	ret
      release(&pi->lock);
    80004154:	8526                	mv	a0,s1
    80004156:	00002097          	auipc	ra,0x2
    8000415a:	470080e7          	jalr	1136(ra) # 800065c6 <release>
      return -1;
    8000415e:	59fd                	li	s3,-1
    80004160:	bff9                	j	8000413e <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004162:	4981                	li	s3,0
    80004164:	b7d1                	j	80004128 <piperead+0xae>

0000000080004166 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004166:	df010113          	addi	sp,sp,-528
    8000416a:	20113423          	sd	ra,520(sp)
    8000416e:	20813023          	sd	s0,512(sp)
    80004172:	ffa6                	sd	s1,504(sp)
    80004174:	fbca                	sd	s2,496(sp)
    80004176:	f7ce                	sd	s3,488(sp)
    80004178:	f3d2                	sd	s4,480(sp)
    8000417a:	efd6                	sd	s5,472(sp)
    8000417c:	ebda                	sd	s6,464(sp)
    8000417e:	e7de                	sd	s7,456(sp)
    80004180:	e3e2                	sd	s8,448(sp)
    80004182:	ff66                	sd	s9,440(sp)
    80004184:	fb6a                	sd	s10,432(sp)
    80004186:	f76e                	sd	s11,424(sp)
    80004188:	0c00                	addi	s0,sp,528
    8000418a:	84aa                	mv	s1,a0
    8000418c:	dea43c23          	sd	a0,-520(s0)
    80004190:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004194:	ffffd097          	auipc	ra,0xffffd
    80004198:	c9a080e7          	jalr	-870(ra) # 80000e2e <myproc>
    8000419c:	892a                	mv	s2,a0

  begin_op();
    8000419e:	fffff097          	auipc	ra,0xfffff
    800041a2:	49c080e7          	jalr	1180(ra) # 8000363a <begin_op>

  if((ip = namei(path)) == 0){
    800041a6:	8526                	mv	a0,s1
    800041a8:	fffff097          	auipc	ra,0xfffff
    800041ac:	276080e7          	jalr	630(ra) # 8000341e <namei>
    800041b0:	c92d                	beqz	a0,80004222 <exec+0xbc>
    800041b2:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	ab4080e7          	jalr	-1356(ra) # 80002c68 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041bc:	04000713          	li	a4,64
    800041c0:	4681                	li	a3,0
    800041c2:	e5040613          	addi	a2,s0,-432
    800041c6:	4581                	li	a1,0
    800041c8:	8526                	mv	a0,s1
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	d52080e7          	jalr	-686(ra) # 80002f1c <readi>
    800041d2:	04000793          	li	a5,64
    800041d6:	00f51a63          	bne	a0,a5,800041ea <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041da:	e5042703          	lw	a4,-432(s0)
    800041de:	464c47b7          	lui	a5,0x464c4
    800041e2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041e6:	04f70463          	beq	a4,a5,8000422e <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041ea:	8526                	mv	a0,s1
    800041ec:	fffff097          	auipc	ra,0xfffff
    800041f0:	cde080e7          	jalr	-802(ra) # 80002eca <iunlockput>
    end_op();
    800041f4:	fffff097          	auipc	ra,0xfffff
    800041f8:	4c6080e7          	jalr	1222(ra) # 800036ba <end_op>
  }
  return -1;
    800041fc:	557d                	li	a0,-1
}
    800041fe:	20813083          	ld	ra,520(sp)
    80004202:	20013403          	ld	s0,512(sp)
    80004206:	74fe                	ld	s1,504(sp)
    80004208:	795e                	ld	s2,496(sp)
    8000420a:	79be                	ld	s3,488(sp)
    8000420c:	7a1e                	ld	s4,480(sp)
    8000420e:	6afe                	ld	s5,472(sp)
    80004210:	6b5e                	ld	s6,464(sp)
    80004212:	6bbe                	ld	s7,456(sp)
    80004214:	6c1e                	ld	s8,448(sp)
    80004216:	7cfa                	ld	s9,440(sp)
    80004218:	7d5a                	ld	s10,432(sp)
    8000421a:	7dba                	ld	s11,424(sp)
    8000421c:	21010113          	addi	sp,sp,528
    80004220:	8082                	ret
    end_op();
    80004222:	fffff097          	auipc	ra,0xfffff
    80004226:	498080e7          	jalr	1176(ra) # 800036ba <end_op>
    return -1;
    8000422a:	557d                	li	a0,-1
    8000422c:	bfc9                	j	800041fe <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000422e:	854a                	mv	a0,s2
    80004230:	ffffd097          	auipc	ra,0xffffd
    80004234:	cc2080e7          	jalr	-830(ra) # 80000ef2 <proc_pagetable>
    80004238:	8baa                	mv	s7,a0
    8000423a:	d945                	beqz	a0,800041ea <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000423c:	e7042983          	lw	s3,-400(s0)
    80004240:	e8845783          	lhu	a5,-376(s0)
    80004244:	c7ad                	beqz	a5,800042ae <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004246:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004248:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000424a:	6c85                	lui	s9,0x1
    8000424c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004250:	def43823          	sd	a5,-528(s0)
    80004254:	a42d                	j	8000447e <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004256:	00004517          	auipc	a0,0x4
    8000425a:	3da50513          	addi	a0,a0,986 # 80008630 <syscalls+0x290>
    8000425e:	00002097          	auipc	ra,0x2
    80004262:	d6a080e7          	jalr	-662(ra) # 80005fc8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004266:	8756                	mv	a4,s5
    80004268:	012d86bb          	addw	a3,s11,s2
    8000426c:	4581                	li	a1,0
    8000426e:	8526                	mv	a0,s1
    80004270:	fffff097          	auipc	ra,0xfffff
    80004274:	cac080e7          	jalr	-852(ra) # 80002f1c <readi>
    80004278:	2501                	sext.w	a0,a0
    8000427a:	1aaa9963          	bne	s5,a0,8000442c <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    8000427e:	6785                	lui	a5,0x1
    80004280:	0127893b          	addw	s2,a5,s2
    80004284:	77fd                	lui	a5,0xfffff
    80004286:	01478a3b          	addw	s4,a5,s4
    8000428a:	1f897163          	bgeu	s2,s8,8000446c <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000428e:	02091593          	slli	a1,s2,0x20
    80004292:	9181                	srli	a1,a1,0x20
    80004294:	95ea                	add	a1,a1,s10
    80004296:	855e                	mv	a0,s7
    80004298:	ffffc097          	auipc	ra,0xffffc
    8000429c:	26e080e7          	jalr	622(ra) # 80000506 <walkaddr>
    800042a0:	862a                	mv	a2,a0
    if(pa == 0)
    800042a2:	d955                	beqz	a0,80004256 <exec+0xf0>
      n = PGSIZE;
    800042a4:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042a6:	fd9a70e3          	bgeu	s4,s9,80004266 <exec+0x100>
      n = sz - i;
    800042aa:	8ad2                	mv	s5,s4
    800042ac:	bf6d                	j	80004266 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ae:	4901                	li	s2,0
  iunlockput(ip);
    800042b0:	8526                	mv	a0,s1
    800042b2:	fffff097          	auipc	ra,0xfffff
    800042b6:	c18080e7          	jalr	-1000(ra) # 80002eca <iunlockput>
  end_op();
    800042ba:	fffff097          	auipc	ra,0xfffff
    800042be:	400080e7          	jalr	1024(ra) # 800036ba <end_op>
  p = myproc();
    800042c2:	ffffd097          	auipc	ra,0xffffd
    800042c6:	b6c080e7          	jalr	-1172(ra) # 80000e2e <myproc>
    800042ca:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042cc:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042d0:	6785                	lui	a5,0x1
    800042d2:	17fd                	addi	a5,a5,-1
    800042d4:	993e                	add	s2,s2,a5
    800042d6:	757d                	lui	a0,0xfffff
    800042d8:	00a977b3          	and	a5,s2,a0
    800042dc:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042e0:	6609                	lui	a2,0x2
    800042e2:	963e                	add	a2,a2,a5
    800042e4:	85be                	mv	a1,a5
    800042e6:	855e                	mv	a0,s7
    800042e8:	ffffc097          	auipc	ra,0xffffc
    800042ec:	5c4080e7          	jalr	1476(ra) # 800008ac <uvmalloc>
    800042f0:	8b2a                	mv	s6,a0
  ip = 0;
    800042f2:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800042f4:	12050c63          	beqz	a0,8000442c <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042f8:	75f9                	lui	a1,0xffffe
    800042fa:	95aa                	add	a1,a1,a0
    800042fc:	855e                	mv	a0,s7
    800042fe:	ffffc097          	auipc	ra,0xffffc
    80004302:	7c0080e7          	jalr	1984(ra) # 80000abe <uvmclear>
  stackbase = sp - PGSIZE;
    80004306:	7c7d                	lui	s8,0xfffff
    80004308:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000430a:	e0043783          	ld	a5,-512(s0)
    8000430e:	6388                	ld	a0,0(a5)
    80004310:	c535                	beqz	a0,8000437c <exec+0x216>
    80004312:	e9040993          	addi	s3,s0,-368
    80004316:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000431a:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000431c:	ffffc097          	auipc	ra,0xffffc
    80004320:	fe0080e7          	jalr	-32(ra) # 800002fc <strlen>
    80004324:	2505                	addiw	a0,a0,1
    80004326:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000432a:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000432e:	13896363          	bltu	s2,s8,80004454 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004332:	e0043d83          	ld	s11,-512(s0)
    80004336:	000dba03          	ld	s4,0(s11)
    8000433a:	8552                	mv	a0,s4
    8000433c:	ffffc097          	auipc	ra,0xffffc
    80004340:	fc0080e7          	jalr	-64(ra) # 800002fc <strlen>
    80004344:	0015069b          	addiw	a3,a0,1
    80004348:	8652                	mv	a2,s4
    8000434a:	85ca                	mv	a1,s2
    8000434c:	855e                	mv	a0,s7
    8000434e:	ffffc097          	auipc	ra,0xffffc
    80004352:	7a2080e7          	jalr	1954(ra) # 80000af0 <copyout>
    80004356:	10054363          	bltz	a0,8000445c <exec+0x2f6>
    ustack[argc] = sp;
    8000435a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000435e:	0485                	addi	s1,s1,1
    80004360:	008d8793          	addi	a5,s11,8
    80004364:	e0f43023          	sd	a5,-512(s0)
    80004368:	008db503          	ld	a0,8(s11)
    8000436c:	c911                	beqz	a0,80004380 <exec+0x21a>
    if(argc >= MAXARG)
    8000436e:	09a1                	addi	s3,s3,8
    80004370:	fb3c96e3          	bne	s9,s3,8000431c <exec+0x1b6>
  sz = sz1;
    80004374:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004378:	4481                	li	s1,0
    8000437a:	a84d                	j	8000442c <exec+0x2c6>
  sp = sz;
    8000437c:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000437e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004380:	00349793          	slli	a5,s1,0x3
    80004384:	f9040713          	addi	a4,s0,-112
    80004388:	97ba                	add	a5,a5,a4
    8000438a:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000438e:	00148693          	addi	a3,s1,1
    80004392:	068e                	slli	a3,a3,0x3
    80004394:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004398:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000439c:	01897663          	bgeu	s2,s8,800043a8 <exec+0x242>
  sz = sz1;
    800043a0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a4:	4481                	li	s1,0
    800043a6:	a059                	j	8000442c <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043a8:	e9040613          	addi	a2,s0,-368
    800043ac:	85ca                	mv	a1,s2
    800043ae:	855e                	mv	a0,s7
    800043b0:	ffffc097          	auipc	ra,0xffffc
    800043b4:	740080e7          	jalr	1856(ra) # 80000af0 <copyout>
    800043b8:	0a054663          	bltz	a0,80004464 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800043bc:	058ab783          	ld	a5,88(s5)
    800043c0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043c4:	df843783          	ld	a5,-520(s0)
    800043c8:	0007c703          	lbu	a4,0(a5)
    800043cc:	cf11                	beqz	a4,800043e8 <exec+0x282>
    800043ce:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043d0:	02f00693          	li	a3,47
    800043d4:	a039                	j	800043e2 <exec+0x27c>
      last = s+1;
    800043d6:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043da:	0785                	addi	a5,a5,1
    800043dc:	fff7c703          	lbu	a4,-1(a5)
    800043e0:	c701                	beqz	a4,800043e8 <exec+0x282>
    if(*s == '/')
    800043e2:	fed71ce3          	bne	a4,a3,800043da <exec+0x274>
    800043e6:	bfc5                	j	800043d6 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800043e8:	4641                	li	a2,16
    800043ea:	df843583          	ld	a1,-520(s0)
    800043ee:	158a8513          	addi	a0,s5,344
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	ed8080e7          	jalr	-296(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800043fa:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043fe:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004402:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004406:	058ab783          	ld	a5,88(s5)
    8000440a:	e6843703          	ld	a4,-408(s0)
    8000440e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004410:	058ab783          	ld	a5,88(s5)
    80004414:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004418:	85ea                	mv	a1,s10
    8000441a:	ffffd097          	auipc	ra,0xffffd
    8000441e:	b74080e7          	jalr	-1164(ra) # 80000f8e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004422:	0004851b          	sext.w	a0,s1
    80004426:	bbe1                	j	800041fe <exec+0x98>
    80004428:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000442c:	e0843583          	ld	a1,-504(s0)
    80004430:	855e                	mv	a0,s7
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	b5c080e7          	jalr	-1188(ra) # 80000f8e <proc_freepagetable>
  if(ip){
    8000443a:	da0498e3          	bnez	s1,800041ea <exec+0x84>
  return -1;
    8000443e:	557d                	li	a0,-1
    80004440:	bb7d                	j	800041fe <exec+0x98>
    80004442:	e1243423          	sd	s2,-504(s0)
    80004446:	b7dd                	j	8000442c <exec+0x2c6>
    80004448:	e1243423          	sd	s2,-504(s0)
    8000444c:	b7c5                	j	8000442c <exec+0x2c6>
    8000444e:	e1243423          	sd	s2,-504(s0)
    80004452:	bfe9                	j	8000442c <exec+0x2c6>
  sz = sz1;
    80004454:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004458:	4481                	li	s1,0
    8000445a:	bfc9                	j	8000442c <exec+0x2c6>
  sz = sz1;
    8000445c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004460:	4481                	li	s1,0
    80004462:	b7e9                	j	8000442c <exec+0x2c6>
  sz = sz1;
    80004464:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004468:	4481                	li	s1,0
    8000446a:	b7c9                	j	8000442c <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000446c:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004470:	2b05                	addiw	s6,s6,1
    80004472:	0389899b          	addiw	s3,s3,56
    80004476:	e8845783          	lhu	a5,-376(s0)
    8000447a:	e2fb5be3          	bge	s6,a5,800042b0 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000447e:	2981                	sext.w	s3,s3
    80004480:	03800713          	li	a4,56
    80004484:	86ce                	mv	a3,s3
    80004486:	e1840613          	addi	a2,s0,-488
    8000448a:	4581                	li	a1,0
    8000448c:	8526                	mv	a0,s1
    8000448e:	fffff097          	auipc	ra,0xfffff
    80004492:	a8e080e7          	jalr	-1394(ra) # 80002f1c <readi>
    80004496:	03800793          	li	a5,56
    8000449a:	f8f517e3          	bne	a0,a5,80004428 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000449e:	e1842783          	lw	a5,-488(s0)
    800044a2:	4705                	li	a4,1
    800044a4:	fce796e3          	bne	a5,a4,80004470 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800044a8:	e4043603          	ld	a2,-448(s0)
    800044ac:	e3843783          	ld	a5,-456(s0)
    800044b0:	f8f669e3          	bltu	a2,a5,80004442 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044b4:	e2843783          	ld	a5,-472(s0)
    800044b8:	963e                	add	a2,a2,a5
    800044ba:	f8f667e3          	bltu	a2,a5,80004448 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044be:	85ca                	mv	a1,s2
    800044c0:	855e                	mv	a0,s7
    800044c2:	ffffc097          	auipc	ra,0xffffc
    800044c6:	3ea080e7          	jalr	1002(ra) # 800008ac <uvmalloc>
    800044ca:	e0a43423          	sd	a0,-504(s0)
    800044ce:	d141                	beqz	a0,8000444e <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800044d0:	e2843d03          	ld	s10,-472(s0)
    800044d4:	df043783          	ld	a5,-528(s0)
    800044d8:	00fd77b3          	and	a5,s10,a5
    800044dc:	fba1                	bnez	a5,8000442c <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044de:	e2042d83          	lw	s11,-480(s0)
    800044e2:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044e6:	f80c03e3          	beqz	s8,8000446c <exec+0x306>
    800044ea:	8a62                	mv	s4,s8
    800044ec:	4901                	li	s2,0
    800044ee:	b345                	j	8000428e <exec+0x128>

00000000800044f0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044f0:	7179                	addi	sp,sp,-48
    800044f2:	f406                	sd	ra,40(sp)
    800044f4:	f022                	sd	s0,32(sp)
    800044f6:	ec26                	sd	s1,24(sp)
    800044f8:	e84a                	sd	s2,16(sp)
    800044fa:	1800                	addi	s0,sp,48
    800044fc:	892e                	mv	s2,a1
    800044fe:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004500:	fdc40593          	addi	a1,s0,-36
    80004504:	ffffe097          	auipc	ra,0xffffe
    80004508:	bf2080e7          	jalr	-1038(ra) # 800020f6 <argint>
    8000450c:	04054063          	bltz	a0,8000454c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004510:	fdc42703          	lw	a4,-36(s0)
    80004514:	47bd                	li	a5,15
    80004516:	02e7ed63          	bltu	a5,a4,80004550 <argfd+0x60>
    8000451a:	ffffd097          	auipc	ra,0xffffd
    8000451e:	914080e7          	jalr	-1772(ra) # 80000e2e <myproc>
    80004522:	fdc42703          	lw	a4,-36(s0)
    80004526:	01a70793          	addi	a5,a4,26
    8000452a:	078e                	slli	a5,a5,0x3
    8000452c:	953e                	add	a0,a0,a5
    8000452e:	611c                	ld	a5,0(a0)
    80004530:	c395                	beqz	a5,80004554 <argfd+0x64>
    return -1;
  if(pfd)
    80004532:	00090463          	beqz	s2,8000453a <argfd+0x4a>
    *pfd = fd;
    80004536:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000453a:	4501                	li	a0,0
  if(pf)
    8000453c:	c091                	beqz	s1,80004540 <argfd+0x50>
    *pf = f;
    8000453e:	e09c                	sd	a5,0(s1)
}
    80004540:	70a2                	ld	ra,40(sp)
    80004542:	7402                	ld	s0,32(sp)
    80004544:	64e2                	ld	s1,24(sp)
    80004546:	6942                	ld	s2,16(sp)
    80004548:	6145                	addi	sp,sp,48
    8000454a:	8082                	ret
    return -1;
    8000454c:	557d                	li	a0,-1
    8000454e:	bfcd                	j	80004540 <argfd+0x50>
    return -1;
    80004550:	557d                	li	a0,-1
    80004552:	b7fd                	j	80004540 <argfd+0x50>
    80004554:	557d                	li	a0,-1
    80004556:	b7ed                	j	80004540 <argfd+0x50>

0000000080004558 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004558:	1101                	addi	sp,sp,-32
    8000455a:	ec06                	sd	ra,24(sp)
    8000455c:	e822                	sd	s0,16(sp)
    8000455e:	e426                	sd	s1,8(sp)
    80004560:	1000                	addi	s0,sp,32
    80004562:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004564:	ffffd097          	auipc	ra,0xffffd
    80004568:	8ca080e7          	jalr	-1846(ra) # 80000e2e <myproc>
    8000456c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000456e:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffcee90>
    80004572:	4501                	li	a0,0
    80004574:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004576:	6398                	ld	a4,0(a5)
    80004578:	cb19                	beqz	a4,8000458e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000457a:	2505                	addiw	a0,a0,1
    8000457c:	07a1                	addi	a5,a5,8
    8000457e:	fed51ce3          	bne	a0,a3,80004576 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004582:	557d                	li	a0,-1
}
    80004584:	60e2                	ld	ra,24(sp)
    80004586:	6442                	ld	s0,16(sp)
    80004588:	64a2                	ld	s1,8(sp)
    8000458a:	6105                	addi	sp,sp,32
    8000458c:	8082                	ret
      p->ofile[fd] = f;
    8000458e:	01a50793          	addi	a5,a0,26
    80004592:	078e                	slli	a5,a5,0x3
    80004594:	963e                	add	a2,a2,a5
    80004596:	e204                	sd	s1,0(a2)
      return fd;
    80004598:	b7f5                	j	80004584 <fdalloc+0x2c>

000000008000459a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000459a:	715d                	addi	sp,sp,-80
    8000459c:	e486                	sd	ra,72(sp)
    8000459e:	e0a2                	sd	s0,64(sp)
    800045a0:	fc26                	sd	s1,56(sp)
    800045a2:	f84a                	sd	s2,48(sp)
    800045a4:	f44e                	sd	s3,40(sp)
    800045a6:	f052                	sd	s4,32(sp)
    800045a8:	ec56                	sd	s5,24(sp)
    800045aa:	0880                	addi	s0,sp,80
    800045ac:	89ae                	mv	s3,a1
    800045ae:	8ab2                	mv	s5,a2
    800045b0:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045b2:	fb040593          	addi	a1,s0,-80
    800045b6:	fffff097          	auipc	ra,0xfffff
    800045ba:	e86080e7          	jalr	-378(ra) # 8000343c <nameiparent>
    800045be:	892a                	mv	s2,a0
    800045c0:	12050f63          	beqz	a0,800046fe <create+0x164>
    return 0;

  ilock(dp);
    800045c4:	ffffe097          	auipc	ra,0xffffe
    800045c8:	6a4080e7          	jalr	1700(ra) # 80002c68 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045cc:	4601                	li	a2,0
    800045ce:	fb040593          	addi	a1,s0,-80
    800045d2:	854a                	mv	a0,s2
    800045d4:	fffff097          	auipc	ra,0xfffff
    800045d8:	b78080e7          	jalr	-1160(ra) # 8000314c <dirlookup>
    800045dc:	84aa                	mv	s1,a0
    800045de:	c921                	beqz	a0,8000462e <create+0x94>
    iunlockput(dp);
    800045e0:	854a                	mv	a0,s2
    800045e2:	fffff097          	auipc	ra,0xfffff
    800045e6:	8e8080e7          	jalr	-1816(ra) # 80002eca <iunlockput>
    ilock(ip);
    800045ea:	8526                	mv	a0,s1
    800045ec:	ffffe097          	auipc	ra,0xffffe
    800045f0:	67c080e7          	jalr	1660(ra) # 80002c68 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045f4:	2981                	sext.w	s3,s3
    800045f6:	4789                	li	a5,2
    800045f8:	02f99463          	bne	s3,a5,80004620 <create+0x86>
    800045fc:	0444d783          	lhu	a5,68(s1)
    80004600:	37f9                	addiw	a5,a5,-2
    80004602:	17c2                	slli	a5,a5,0x30
    80004604:	93c1                	srli	a5,a5,0x30
    80004606:	4705                	li	a4,1
    80004608:	00f76c63          	bltu	a4,a5,80004620 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000460c:	8526                	mv	a0,s1
    8000460e:	60a6                	ld	ra,72(sp)
    80004610:	6406                	ld	s0,64(sp)
    80004612:	74e2                	ld	s1,56(sp)
    80004614:	7942                	ld	s2,48(sp)
    80004616:	79a2                	ld	s3,40(sp)
    80004618:	7a02                	ld	s4,32(sp)
    8000461a:	6ae2                	ld	s5,24(sp)
    8000461c:	6161                	addi	sp,sp,80
    8000461e:	8082                	ret
    iunlockput(ip);
    80004620:	8526                	mv	a0,s1
    80004622:	fffff097          	auipc	ra,0xfffff
    80004626:	8a8080e7          	jalr	-1880(ra) # 80002eca <iunlockput>
    return 0;
    8000462a:	4481                	li	s1,0
    8000462c:	b7c5                	j	8000460c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000462e:	85ce                	mv	a1,s3
    80004630:	00092503          	lw	a0,0(s2)
    80004634:	ffffe097          	auipc	ra,0xffffe
    80004638:	49c080e7          	jalr	1180(ra) # 80002ad0 <ialloc>
    8000463c:	84aa                	mv	s1,a0
    8000463e:	c529                	beqz	a0,80004688 <create+0xee>
  ilock(ip);
    80004640:	ffffe097          	auipc	ra,0xffffe
    80004644:	628080e7          	jalr	1576(ra) # 80002c68 <ilock>
  ip->major = major;
    80004648:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000464c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004650:	4785                	li	a5,1
    80004652:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004656:	8526                	mv	a0,s1
    80004658:	ffffe097          	auipc	ra,0xffffe
    8000465c:	546080e7          	jalr	1350(ra) # 80002b9e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004660:	2981                	sext.w	s3,s3
    80004662:	4785                	li	a5,1
    80004664:	02f98a63          	beq	s3,a5,80004698 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004668:	40d0                	lw	a2,4(s1)
    8000466a:	fb040593          	addi	a1,s0,-80
    8000466e:	854a                	mv	a0,s2
    80004670:	fffff097          	auipc	ra,0xfffff
    80004674:	cec080e7          	jalr	-788(ra) # 8000335c <dirlink>
    80004678:	06054b63          	bltz	a0,800046ee <create+0x154>
  iunlockput(dp);
    8000467c:	854a                	mv	a0,s2
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	84c080e7          	jalr	-1972(ra) # 80002eca <iunlockput>
  return ip;
    80004686:	b759                	j	8000460c <create+0x72>
    panic("create: ialloc");
    80004688:	00004517          	auipc	a0,0x4
    8000468c:	fc850513          	addi	a0,a0,-56 # 80008650 <syscalls+0x2b0>
    80004690:	00002097          	auipc	ra,0x2
    80004694:	938080e7          	jalr	-1736(ra) # 80005fc8 <panic>
    dp->nlink++;  // for ".."
    80004698:	04a95783          	lhu	a5,74(s2)
    8000469c:	2785                	addiw	a5,a5,1
    8000469e:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046a2:	854a                	mv	a0,s2
    800046a4:	ffffe097          	auipc	ra,0xffffe
    800046a8:	4fa080e7          	jalr	1274(ra) # 80002b9e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046ac:	40d0                	lw	a2,4(s1)
    800046ae:	00004597          	auipc	a1,0x4
    800046b2:	fb258593          	addi	a1,a1,-78 # 80008660 <syscalls+0x2c0>
    800046b6:	8526                	mv	a0,s1
    800046b8:	fffff097          	auipc	ra,0xfffff
    800046bc:	ca4080e7          	jalr	-860(ra) # 8000335c <dirlink>
    800046c0:	00054f63          	bltz	a0,800046de <create+0x144>
    800046c4:	00492603          	lw	a2,4(s2)
    800046c8:	00004597          	auipc	a1,0x4
    800046cc:	fa058593          	addi	a1,a1,-96 # 80008668 <syscalls+0x2c8>
    800046d0:	8526                	mv	a0,s1
    800046d2:	fffff097          	auipc	ra,0xfffff
    800046d6:	c8a080e7          	jalr	-886(ra) # 8000335c <dirlink>
    800046da:	f80557e3          	bgez	a0,80004668 <create+0xce>
      panic("create dots");
    800046de:	00004517          	auipc	a0,0x4
    800046e2:	f9250513          	addi	a0,a0,-110 # 80008670 <syscalls+0x2d0>
    800046e6:	00002097          	auipc	ra,0x2
    800046ea:	8e2080e7          	jalr	-1822(ra) # 80005fc8 <panic>
    panic("create: dirlink");
    800046ee:	00004517          	auipc	a0,0x4
    800046f2:	f9250513          	addi	a0,a0,-110 # 80008680 <syscalls+0x2e0>
    800046f6:	00002097          	auipc	ra,0x2
    800046fa:	8d2080e7          	jalr	-1838(ra) # 80005fc8 <panic>
    return 0;
    800046fe:	84aa                	mv	s1,a0
    80004700:	b731                	j	8000460c <create+0x72>

0000000080004702 <sys_dup>:
{
    80004702:	7179                	addi	sp,sp,-48
    80004704:	f406                	sd	ra,40(sp)
    80004706:	f022                	sd	s0,32(sp)
    80004708:	ec26                	sd	s1,24(sp)
    8000470a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000470c:	fd840613          	addi	a2,s0,-40
    80004710:	4581                	li	a1,0
    80004712:	4501                	li	a0,0
    80004714:	00000097          	auipc	ra,0x0
    80004718:	ddc080e7          	jalr	-548(ra) # 800044f0 <argfd>
    return -1;
    8000471c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000471e:	02054363          	bltz	a0,80004744 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004722:	fd843503          	ld	a0,-40(s0)
    80004726:	00000097          	auipc	ra,0x0
    8000472a:	e32080e7          	jalr	-462(ra) # 80004558 <fdalloc>
    8000472e:	84aa                	mv	s1,a0
    return -1;
    80004730:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004732:	00054963          	bltz	a0,80004744 <sys_dup+0x42>
  filedup(f);
    80004736:	fd843503          	ld	a0,-40(s0)
    8000473a:	fffff097          	auipc	ra,0xfffff
    8000473e:	37a080e7          	jalr	890(ra) # 80003ab4 <filedup>
  return fd;
    80004742:	87a6                	mv	a5,s1
}
    80004744:	853e                	mv	a0,a5
    80004746:	70a2                	ld	ra,40(sp)
    80004748:	7402                	ld	s0,32(sp)
    8000474a:	64e2                	ld	s1,24(sp)
    8000474c:	6145                	addi	sp,sp,48
    8000474e:	8082                	ret

0000000080004750 <sys_read>:
{
    80004750:	7179                	addi	sp,sp,-48
    80004752:	f406                	sd	ra,40(sp)
    80004754:	f022                	sd	s0,32(sp)
    80004756:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004758:	fe840613          	addi	a2,s0,-24
    8000475c:	4581                	li	a1,0
    8000475e:	4501                	li	a0,0
    80004760:	00000097          	auipc	ra,0x0
    80004764:	d90080e7          	jalr	-624(ra) # 800044f0 <argfd>
    return -1;
    80004768:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000476a:	04054163          	bltz	a0,800047ac <sys_read+0x5c>
    8000476e:	fe440593          	addi	a1,s0,-28
    80004772:	4509                	li	a0,2
    80004774:	ffffe097          	auipc	ra,0xffffe
    80004778:	982080e7          	jalr	-1662(ra) # 800020f6 <argint>
    return -1;
    8000477c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000477e:	02054763          	bltz	a0,800047ac <sys_read+0x5c>
    80004782:	fd840593          	addi	a1,s0,-40
    80004786:	4505                	li	a0,1
    80004788:	ffffe097          	auipc	ra,0xffffe
    8000478c:	990080e7          	jalr	-1648(ra) # 80002118 <argaddr>
    return -1;
    80004790:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004792:	00054d63          	bltz	a0,800047ac <sys_read+0x5c>
  return fileread(f, p, n);
    80004796:	fe442603          	lw	a2,-28(s0)
    8000479a:	fd843583          	ld	a1,-40(s0)
    8000479e:	fe843503          	ld	a0,-24(s0)
    800047a2:	fffff097          	auipc	ra,0xfffff
    800047a6:	49e080e7          	jalr	1182(ra) # 80003c40 <fileread>
    800047aa:	87aa                	mv	a5,a0
}
    800047ac:	853e                	mv	a0,a5
    800047ae:	70a2                	ld	ra,40(sp)
    800047b0:	7402                	ld	s0,32(sp)
    800047b2:	6145                	addi	sp,sp,48
    800047b4:	8082                	ret

00000000800047b6 <sys_write>:
{
    800047b6:	7179                	addi	sp,sp,-48
    800047b8:	f406                	sd	ra,40(sp)
    800047ba:	f022                	sd	s0,32(sp)
    800047bc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047be:	fe840613          	addi	a2,s0,-24
    800047c2:	4581                	li	a1,0
    800047c4:	4501                	li	a0,0
    800047c6:	00000097          	auipc	ra,0x0
    800047ca:	d2a080e7          	jalr	-726(ra) # 800044f0 <argfd>
    return -1;
    800047ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047d0:	04054163          	bltz	a0,80004812 <sys_write+0x5c>
    800047d4:	fe440593          	addi	a1,s0,-28
    800047d8:	4509                	li	a0,2
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	91c080e7          	jalr	-1764(ra) # 800020f6 <argint>
    return -1;
    800047e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047e4:	02054763          	bltz	a0,80004812 <sys_write+0x5c>
    800047e8:	fd840593          	addi	a1,s0,-40
    800047ec:	4505                	li	a0,1
    800047ee:	ffffe097          	auipc	ra,0xffffe
    800047f2:	92a080e7          	jalr	-1750(ra) # 80002118 <argaddr>
    return -1;
    800047f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047f8:	00054d63          	bltz	a0,80004812 <sys_write+0x5c>
  return filewrite(f, p, n);
    800047fc:	fe442603          	lw	a2,-28(s0)
    80004800:	fd843583          	ld	a1,-40(s0)
    80004804:	fe843503          	ld	a0,-24(s0)
    80004808:	fffff097          	auipc	ra,0xfffff
    8000480c:	4fa080e7          	jalr	1274(ra) # 80003d02 <filewrite>
    80004810:	87aa                	mv	a5,a0
}
    80004812:	853e                	mv	a0,a5
    80004814:	70a2                	ld	ra,40(sp)
    80004816:	7402                	ld	s0,32(sp)
    80004818:	6145                	addi	sp,sp,48
    8000481a:	8082                	ret

000000008000481c <sys_close>:
{
    8000481c:	1101                	addi	sp,sp,-32
    8000481e:	ec06                	sd	ra,24(sp)
    80004820:	e822                	sd	s0,16(sp)
    80004822:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004824:	fe040613          	addi	a2,s0,-32
    80004828:	fec40593          	addi	a1,s0,-20
    8000482c:	4501                	li	a0,0
    8000482e:	00000097          	auipc	ra,0x0
    80004832:	cc2080e7          	jalr	-830(ra) # 800044f0 <argfd>
    return -1;
    80004836:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004838:	02054463          	bltz	a0,80004860 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000483c:	ffffc097          	auipc	ra,0xffffc
    80004840:	5f2080e7          	jalr	1522(ra) # 80000e2e <myproc>
    80004844:	fec42783          	lw	a5,-20(s0)
    80004848:	07e9                	addi	a5,a5,26
    8000484a:	078e                	slli	a5,a5,0x3
    8000484c:	97aa                	add	a5,a5,a0
    8000484e:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004852:	fe043503          	ld	a0,-32(s0)
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	2b0080e7          	jalr	688(ra) # 80003b06 <fileclose>
  return 0;
    8000485e:	4781                	li	a5,0
}
    80004860:	853e                	mv	a0,a5
    80004862:	60e2                	ld	ra,24(sp)
    80004864:	6442                	ld	s0,16(sp)
    80004866:	6105                	addi	sp,sp,32
    80004868:	8082                	ret

000000008000486a <sys_fstat>:
{
    8000486a:	1101                	addi	sp,sp,-32
    8000486c:	ec06                	sd	ra,24(sp)
    8000486e:	e822                	sd	s0,16(sp)
    80004870:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004872:	fe840613          	addi	a2,s0,-24
    80004876:	4581                	li	a1,0
    80004878:	4501                	li	a0,0
    8000487a:	00000097          	auipc	ra,0x0
    8000487e:	c76080e7          	jalr	-906(ra) # 800044f0 <argfd>
    return -1;
    80004882:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004884:	02054563          	bltz	a0,800048ae <sys_fstat+0x44>
    80004888:	fe040593          	addi	a1,s0,-32
    8000488c:	4505                	li	a0,1
    8000488e:	ffffe097          	auipc	ra,0xffffe
    80004892:	88a080e7          	jalr	-1910(ra) # 80002118 <argaddr>
    return -1;
    80004896:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004898:	00054b63          	bltz	a0,800048ae <sys_fstat+0x44>
  return filestat(f, st);
    8000489c:	fe043583          	ld	a1,-32(s0)
    800048a0:	fe843503          	ld	a0,-24(s0)
    800048a4:	fffff097          	auipc	ra,0xfffff
    800048a8:	32a080e7          	jalr	810(ra) # 80003bce <filestat>
    800048ac:	87aa                	mv	a5,a0
}
    800048ae:	853e                	mv	a0,a5
    800048b0:	60e2                	ld	ra,24(sp)
    800048b2:	6442                	ld	s0,16(sp)
    800048b4:	6105                	addi	sp,sp,32
    800048b6:	8082                	ret

00000000800048b8 <sys_link>:
{
    800048b8:	7169                	addi	sp,sp,-304
    800048ba:	f606                	sd	ra,296(sp)
    800048bc:	f222                	sd	s0,288(sp)
    800048be:	ee26                	sd	s1,280(sp)
    800048c0:	ea4a                	sd	s2,272(sp)
    800048c2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048c4:	08000613          	li	a2,128
    800048c8:	ed040593          	addi	a1,s0,-304
    800048cc:	4501                	li	a0,0
    800048ce:	ffffe097          	auipc	ra,0xffffe
    800048d2:	86c080e7          	jalr	-1940(ra) # 8000213a <argstr>
    return -1;
    800048d6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048d8:	10054e63          	bltz	a0,800049f4 <sys_link+0x13c>
    800048dc:	08000613          	li	a2,128
    800048e0:	f5040593          	addi	a1,s0,-176
    800048e4:	4505                	li	a0,1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	854080e7          	jalr	-1964(ra) # 8000213a <argstr>
    return -1;
    800048ee:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048f0:	10054263          	bltz	a0,800049f4 <sys_link+0x13c>
  begin_op();
    800048f4:	fffff097          	auipc	ra,0xfffff
    800048f8:	d46080e7          	jalr	-698(ra) # 8000363a <begin_op>
  if((ip = namei(old)) == 0){
    800048fc:	ed040513          	addi	a0,s0,-304
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	b1e080e7          	jalr	-1250(ra) # 8000341e <namei>
    80004908:	84aa                	mv	s1,a0
    8000490a:	c551                	beqz	a0,80004996 <sys_link+0xde>
  ilock(ip);
    8000490c:	ffffe097          	auipc	ra,0xffffe
    80004910:	35c080e7          	jalr	860(ra) # 80002c68 <ilock>
  if(ip->type == T_DIR){
    80004914:	04449703          	lh	a4,68(s1)
    80004918:	4785                	li	a5,1
    8000491a:	08f70463          	beq	a4,a5,800049a2 <sys_link+0xea>
  ip->nlink++;
    8000491e:	04a4d783          	lhu	a5,74(s1)
    80004922:	2785                	addiw	a5,a5,1
    80004924:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004928:	8526                	mv	a0,s1
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	274080e7          	jalr	628(ra) # 80002b9e <iupdate>
  iunlock(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	3f6080e7          	jalr	1014(ra) # 80002d2a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000493c:	fd040593          	addi	a1,s0,-48
    80004940:	f5040513          	addi	a0,s0,-176
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	af8080e7          	jalr	-1288(ra) # 8000343c <nameiparent>
    8000494c:	892a                	mv	s2,a0
    8000494e:	c935                	beqz	a0,800049c2 <sys_link+0x10a>
  ilock(dp);
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	318080e7          	jalr	792(ra) # 80002c68 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004958:	00092703          	lw	a4,0(s2)
    8000495c:	409c                	lw	a5,0(s1)
    8000495e:	04f71d63          	bne	a4,a5,800049b8 <sys_link+0x100>
    80004962:	40d0                	lw	a2,4(s1)
    80004964:	fd040593          	addi	a1,s0,-48
    80004968:	854a                	mv	a0,s2
    8000496a:	fffff097          	auipc	ra,0xfffff
    8000496e:	9f2080e7          	jalr	-1550(ra) # 8000335c <dirlink>
    80004972:	04054363          	bltz	a0,800049b8 <sys_link+0x100>
  iunlockput(dp);
    80004976:	854a                	mv	a0,s2
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	552080e7          	jalr	1362(ra) # 80002eca <iunlockput>
  iput(ip);
    80004980:	8526                	mv	a0,s1
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	4a0080e7          	jalr	1184(ra) # 80002e22 <iput>
  end_op();
    8000498a:	fffff097          	auipc	ra,0xfffff
    8000498e:	d30080e7          	jalr	-720(ra) # 800036ba <end_op>
  return 0;
    80004992:	4781                	li	a5,0
    80004994:	a085                	j	800049f4 <sys_link+0x13c>
    end_op();
    80004996:	fffff097          	auipc	ra,0xfffff
    8000499a:	d24080e7          	jalr	-732(ra) # 800036ba <end_op>
    return -1;
    8000499e:	57fd                	li	a5,-1
    800049a0:	a891                	j	800049f4 <sys_link+0x13c>
    iunlockput(ip);
    800049a2:	8526                	mv	a0,s1
    800049a4:	ffffe097          	auipc	ra,0xffffe
    800049a8:	526080e7          	jalr	1318(ra) # 80002eca <iunlockput>
    end_op();
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	d0e080e7          	jalr	-754(ra) # 800036ba <end_op>
    return -1;
    800049b4:	57fd                	li	a5,-1
    800049b6:	a83d                	j	800049f4 <sys_link+0x13c>
    iunlockput(dp);
    800049b8:	854a                	mv	a0,s2
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	510080e7          	jalr	1296(ra) # 80002eca <iunlockput>
  ilock(ip);
    800049c2:	8526                	mv	a0,s1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	2a4080e7          	jalr	676(ra) # 80002c68 <ilock>
  ip->nlink--;
    800049cc:	04a4d783          	lhu	a5,74(s1)
    800049d0:	37fd                	addiw	a5,a5,-1
    800049d2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049d6:	8526                	mv	a0,s1
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	1c6080e7          	jalr	454(ra) # 80002b9e <iupdate>
  iunlockput(ip);
    800049e0:	8526                	mv	a0,s1
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	4e8080e7          	jalr	1256(ra) # 80002eca <iunlockput>
  end_op();
    800049ea:	fffff097          	auipc	ra,0xfffff
    800049ee:	cd0080e7          	jalr	-816(ra) # 800036ba <end_op>
  return -1;
    800049f2:	57fd                	li	a5,-1
}
    800049f4:	853e                	mv	a0,a5
    800049f6:	70b2                	ld	ra,296(sp)
    800049f8:	7412                	ld	s0,288(sp)
    800049fa:	64f2                	ld	s1,280(sp)
    800049fc:	6952                	ld	s2,272(sp)
    800049fe:	6155                	addi	sp,sp,304
    80004a00:	8082                	ret

0000000080004a02 <sys_unlink>:
{
    80004a02:	7151                	addi	sp,sp,-240
    80004a04:	f586                	sd	ra,232(sp)
    80004a06:	f1a2                	sd	s0,224(sp)
    80004a08:	eda6                	sd	s1,216(sp)
    80004a0a:	e9ca                	sd	s2,208(sp)
    80004a0c:	e5ce                	sd	s3,200(sp)
    80004a0e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a10:	08000613          	li	a2,128
    80004a14:	f3040593          	addi	a1,s0,-208
    80004a18:	4501                	li	a0,0
    80004a1a:	ffffd097          	auipc	ra,0xffffd
    80004a1e:	720080e7          	jalr	1824(ra) # 8000213a <argstr>
    80004a22:	18054163          	bltz	a0,80004ba4 <sys_unlink+0x1a2>
  begin_op();
    80004a26:	fffff097          	auipc	ra,0xfffff
    80004a2a:	c14080e7          	jalr	-1004(ra) # 8000363a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a2e:	fb040593          	addi	a1,s0,-80
    80004a32:	f3040513          	addi	a0,s0,-208
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	a06080e7          	jalr	-1530(ra) # 8000343c <nameiparent>
    80004a3e:	84aa                	mv	s1,a0
    80004a40:	c979                	beqz	a0,80004b16 <sys_unlink+0x114>
  ilock(dp);
    80004a42:	ffffe097          	auipc	ra,0xffffe
    80004a46:	226080e7          	jalr	550(ra) # 80002c68 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a4a:	00004597          	auipc	a1,0x4
    80004a4e:	c1658593          	addi	a1,a1,-1002 # 80008660 <syscalls+0x2c0>
    80004a52:	fb040513          	addi	a0,s0,-80
    80004a56:	ffffe097          	auipc	ra,0xffffe
    80004a5a:	6dc080e7          	jalr	1756(ra) # 80003132 <namecmp>
    80004a5e:	14050a63          	beqz	a0,80004bb2 <sys_unlink+0x1b0>
    80004a62:	00004597          	auipc	a1,0x4
    80004a66:	c0658593          	addi	a1,a1,-1018 # 80008668 <syscalls+0x2c8>
    80004a6a:	fb040513          	addi	a0,s0,-80
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	6c4080e7          	jalr	1732(ra) # 80003132 <namecmp>
    80004a76:	12050e63          	beqz	a0,80004bb2 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a7a:	f2c40613          	addi	a2,s0,-212
    80004a7e:	fb040593          	addi	a1,s0,-80
    80004a82:	8526                	mv	a0,s1
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	6c8080e7          	jalr	1736(ra) # 8000314c <dirlookup>
    80004a8c:	892a                	mv	s2,a0
    80004a8e:	12050263          	beqz	a0,80004bb2 <sys_unlink+0x1b0>
  ilock(ip);
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	1d6080e7          	jalr	470(ra) # 80002c68 <ilock>
  if(ip->nlink < 1)
    80004a9a:	04a91783          	lh	a5,74(s2)
    80004a9e:	08f05263          	blez	a5,80004b22 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004aa2:	04491703          	lh	a4,68(s2)
    80004aa6:	4785                	li	a5,1
    80004aa8:	08f70563          	beq	a4,a5,80004b32 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004aac:	4641                	li	a2,16
    80004aae:	4581                	li	a1,0
    80004ab0:	fc040513          	addi	a0,s0,-64
    80004ab4:	ffffb097          	auipc	ra,0xffffb
    80004ab8:	6c4080e7          	jalr	1732(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004abc:	4741                	li	a4,16
    80004abe:	f2c42683          	lw	a3,-212(s0)
    80004ac2:	fc040613          	addi	a2,s0,-64
    80004ac6:	4581                	li	a1,0
    80004ac8:	8526                	mv	a0,s1
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	54a080e7          	jalr	1354(ra) # 80003014 <writei>
    80004ad2:	47c1                	li	a5,16
    80004ad4:	0af51563          	bne	a0,a5,80004b7e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004ad8:	04491703          	lh	a4,68(s2)
    80004adc:	4785                	li	a5,1
    80004ade:	0af70863          	beq	a4,a5,80004b8e <sys_unlink+0x18c>
  iunlockput(dp);
    80004ae2:	8526                	mv	a0,s1
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	3e6080e7          	jalr	998(ra) # 80002eca <iunlockput>
  ip->nlink--;
    80004aec:	04a95783          	lhu	a5,74(s2)
    80004af0:	37fd                	addiw	a5,a5,-1
    80004af2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004af6:	854a                	mv	a0,s2
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	0a6080e7          	jalr	166(ra) # 80002b9e <iupdate>
  iunlockput(ip);
    80004b00:	854a                	mv	a0,s2
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	3c8080e7          	jalr	968(ra) # 80002eca <iunlockput>
  end_op();
    80004b0a:	fffff097          	auipc	ra,0xfffff
    80004b0e:	bb0080e7          	jalr	-1104(ra) # 800036ba <end_op>
  return 0;
    80004b12:	4501                	li	a0,0
    80004b14:	a84d                	j	80004bc6 <sys_unlink+0x1c4>
    end_op();
    80004b16:	fffff097          	auipc	ra,0xfffff
    80004b1a:	ba4080e7          	jalr	-1116(ra) # 800036ba <end_op>
    return -1;
    80004b1e:	557d                	li	a0,-1
    80004b20:	a05d                	j	80004bc6 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b22:	00004517          	auipc	a0,0x4
    80004b26:	b6e50513          	addi	a0,a0,-1170 # 80008690 <syscalls+0x2f0>
    80004b2a:	00001097          	auipc	ra,0x1
    80004b2e:	49e080e7          	jalr	1182(ra) # 80005fc8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b32:	04c92703          	lw	a4,76(s2)
    80004b36:	02000793          	li	a5,32
    80004b3a:	f6e7f9e3          	bgeu	a5,a4,80004aac <sys_unlink+0xaa>
    80004b3e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b42:	4741                	li	a4,16
    80004b44:	86ce                	mv	a3,s3
    80004b46:	f1840613          	addi	a2,s0,-232
    80004b4a:	4581                	li	a1,0
    80004b4c:	854a                	mv	a0,s2
    80004b4e:	ffffe097          	auipc	ra,0xffffe
    80004b52:	3ce080e7          	jalr	974(ra) # 80002f1c <readi>
    80004b56:	47c1                	li	a5,16
    80004b58:	00f51b63          	bne	a0,a5,80004b6e <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b5c:	f1845783          	lhu	a5,-232(s0)
    80004b60:	e7a1                	bnez	a5,80004ba8 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b62:	29c1                	addiw	s3,s3,16
    80004b64:	04c92783          	lw	a5,76(s2)
    80004b68:	fcf9ede3          	bltu	s3,a5,80004b42 <sys_unlink+0x140>
    80004b6c:	b781                	j	80004aac <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b6e:	00004517          	auipc	a0,0x4
    80004b72:	b3a50513          	addi	a0,a0,-1222 # 800086a8 <syscalls+0x308>
    80004b76:	00001097          	auipc	ra,0x1
    80004b7a:	452080e7          	jalr	1106(ra) # 80005fc8 <panic>
    panic("unlink: writei");
    80004b7e:	00004517          	auipc	a0,0x4
    80004b82:	b4250513          	addi	a0,a0,-1214 # 800086c0 <syscalls+0x320>
    80004b86:	00001097          	auipc	ra,0x1
    80004b8a:	442080e7          	jalr	1090(ra) # 80005fc8 <panic>
    dp->nlink--;
    80004b8e:	04a4d783          	lhu	a5,74(s1)
    80004b92:	37fd                	addiw	a5,a5,-1
    80004b94:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b98:	8526                	mv	a0,s1
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	004080e7          	jalr	4(ra) # 80002b9e <iupdate>
    80004ba2:	b781                	j	80004ae2 <sys_unlink+0xe0>
    return -1;
    80004ba4:	557d                	li	a0,-1
    80004ba6:	a005                	j	80004bc6 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ba8:	854a                	mv	a0,s2
    80004baa:	ffffe097          	auipc	ra,0xffffe
    80004bae:	320080e7          	jalr	800(ra) # 80002eca <iunlockput>
  iunlockput(dp);
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	ffffe097          	auipc	ra,0xffffe
    80004bb8:	316080e7          	jalr	790(ra) # 80002eca <iunlockput>
  end_op();
    80004bbc:	fffff097          	auipc	ra,0xfffff
    80004bc0:	afe080e7          	jalr	-1282(ra) # 800036ba <end_op>
  return -1;
    80004bc4:	557d                	li	a0,-1
}
    80004bc6:	70ae                	ld	ra,232(sp)
    80004bc8:	740e                	ld	s0,224(sp)
    80004bca:	64ee                	ld	s1,216(sp)
    80004bcc:	694e                	ld	s2,208(sp)
    80004bce:	69ae                	ld	s3,200(sp)
    80004bd0:	616d                	addi	sp,sp,240
    80004bd2:	8082                	ret

0000000080004bd4 <sys_open>:

uint64
sys_open(void)
{
    80004bd4:	7131                	addi	sp,sp,-192
    80004bd6:	fd06                	sd	ra,184(sp)
    80004bd8:	f922                	sd	s0,176(sp)
    80004bda:	f526                	sd	s1,168(sp)
    80004bdc:	f14a                	sd	s2,160(sp)
    80004bde:	ed4e                	sd	s3,152(sp)
    80004be0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004be2:	08000613          	li	a2,128
    80004be6:	f5040593          	addi	a1,s0,-176
    80004bea:	4501                	li	a0,0
    80004bec:	ffffd097          	auipc	ra,0xffffd
    80004bf0:	54e080e7          	jalr	1358(ra) # 8000213a <argstr>
    return -1;
    80004bf4:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004bf6:	0c054163          	bltz	a0,80004cb8 <sys_open+0xe4>
    80004bfa:	f4c40593          	addi	a1,s0,-180
    80004bfe:	4505                	li	a0,1
    80004c00:	ffffd097          	auipc	ra,0xffffd
    80004c04:	4f6080e7          	jalr	1270(ra) # 800020f6 <argint>
    80004c08:	0a054863          	bltz	a0,80004cb8 <sys_open+0xe4>

  begin_op();
    80004c0c:	fffff097          	auipc	ra,0xfffff
    80004c10:	a2e080e7          	jalr	-1490(ra) # 8000363a <begin_op>

  if(omode & O_CREATE){
    80004c14:	f4c42783          	lw	a5,-180(s0)
    80004c18:	2007f793          	andi	a5,a5,512
    80004c1c:	cbdd                	beqz	a5,80004cd2 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c1e:	4681                	li	a3,0
    80004c20:	4601                	li	a2,0
    80004c22:	4589                	li	a1,2
    80004c24:	f5040513          	addi	a0,s0,-176
    80004c28:	00000097          	auipc	ra,0x0
    80004c2c:	972080e7          	jalr	-1678(ra) # 8000459a <create>
    80004c30:	892a                	mv	s2,a0
    if(ip == 0){
    80004c32:	c959                	beqz	a0,80004cc8 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c34:	04491703          	lh	a4,68(s2)
    80004c38:	478d                	li	a5,3
    80004c3a:	00f71763          	bne	a4,a5,80004c48 <sys_open+0x74>
    80004c3e:	04695703          	lhu	a4,70(s2)
    80004c42:	47a5                	li	a5,9
    80004c44:	0ce7ec63          	bltu	a5,a4,80004d1c <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	e02080e7          	jalr	-510(ra) # 80003a4a <filealloc>
    80004c50:	89aa                	mv	s3,a0
    80004c52:	10050263          	beqz	a0,80004d56 <sys_open+0x182>
    80004c56:	00000097          	auipc	ra,0x0
    80004c5a:	902080e7          	jalr	-1790(ra) # 80004558 <fdalloc>
    80004c5e:	84aa                	mv	s1,a0
    80004c60:	0e054663          	bltz	a0,80004d4c <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c64:	04491703          	lh	a4,68(s2)
    80004c68:	478d                	li	a5,3
    80004c6a:	0cf70463          	beq	a4,a5,80004d32 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c6e:	4789                	li	a5,2
    80004c70:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c74:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c78:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c7c:	f4c42783          	lw	a5,-180(s0)
    80004c80:	0017c713          	xori	a4,a5,1
    80004c84:	8b05                	andi	a4,a4,1
    80004c86:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c8a:	0037f713          	andi	a4,a5,3
    80004c8e:	00e03733          	snez	a4,a4
    80004c92:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c96:	4007f793          	andi	a5,a5,1024
    80004c9a:	c791                	beqz	a5,80004ca6 <sys_open+0xd2>
    80004c9c:	04491703          	lh	a4,68(s2)
    80004ca0:	4789                	li	a5,2
    80004ca2:	08f70f63          	beq	a4,a5,80004d40 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004ca6:	854a                	mv	a0,s2
    80004ca8:	ffffe097          	auipc	ra,0xffffe
    80004cac:	082080e7          	jalr	130(ra) # 80002d2a <iunlock>
  end_op();
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	a0a080e7          	jalr	-1526(ra) # 800036ba <end_op>

  return fd;
}
    80004cb8:	8526                	mv	a0,s1
    80004cba:	70ea                	ld	ra,184(sp)
    80004cbc:	744a                	ld	s0,176(sp)
    80004cbe:	74aa                	ld	s1,168(sp)
    80004cc0:	790a                	ld	s2,160(sp)
    80004cc2:	69ea                	ld	s3,152(sp)
    80004cc4:	6129                	addi	sp,sp,192
    80004cc6:	8082                	ret
      end_op();
    80004cc8:	fffff097          	auipc	ra,0xfffff
    80004ccc:	9f2080e7          	jalr	-1550(ra) # 800036ba <end_op>
      return -1;
    80004cd0:	b7e5                	j	80004cb8 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004cd2:	f5040513          	addi	a0,s0,-176
    80004cd6:	ffffe097          	auipc	ra,0xffffe
    80004cda:	748080e7          	jalr	1864(ra) # 8000341e <namei>
    80004cde:	892a                	mv	s2,a0
    80004ce0:	c905                	beqz	a0,80004d10 <sys_open+0x13c>
    ilock(ip);
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	f86080e7          	jalr	-122(ra) # 80002c68 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004cea:	04491703          	lh	a4,68(s2)
    80004cee:	4785                	li	a5,1
    80004cf0:	f4f712e3          	bne	a4,a5,80004c34 <sys_open+0x60>
    80004cf4:	f4c42783          	lw	a5,-180(s0)
    80004cf8:	dba1                	beqz	a5,80004c48 <sys_open+0x74>
      iunlockput(ip);
    80004cfa:	854a                	mv	a0,s2
    80004cfc:	ffffe097          	auipc	ra,0xffffe
    80004d00:	1ce080e7          	jalr	462(ra) # 80002eca <iunlockput>
      end_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	9b6080e7          	jalr	-1610(ra) # 800036ba <end_op>
      return -1;
    80004d0c:	54fd                	li	s1,-1
    80004d0e:	b76d                	j	80004cb8 <sys_open+0xe4>
      end_op();
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	9aa080e7          	jalr	-1622(ra) # 800036ba <end_op>
      return -1;
    80004d18:	54fd                	li	s1,-1
    80004d1a:	bf79                	j	80004cb8 <sys_open+0xe4>
    iunlockput(ip);
    80004d1c:	854a                	mv	a0,s2
    80004d1e:	ffffe097          	auipc	ra,0xffffe
    80004d22:	1ac080e7          	jalr	428(ra) # 80002eca <iunlockput>
    end_op();
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	994080e7          	jalr	-1644(ra) # 800036ba <end_op>
    return -1;
    80004d2e:	54fd                	li	s1,-1
    80004d30:	b761                	j	80004cb8 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d32:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d36:	04691783          	lh	a5,70(s2)
    80004d3a:	02f99223          	sh	a5,36(s3)
    80004d3e:	bf2d                	j	80004c78 <sys_open+0xa4>
    itrunc(ip);
    80004d40:	854a                	mv	a0,s2
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	034080e7          	jalr	52(ra) # 80002d76 <itrunc>
    80004d4a:	bfb1                	j	80004ca6 <sys_open+0xd2>
      fileclose(f);
    80004d4c:	854e                	mv	a0,s3
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	db8080e7          	jalr	-584(ra) # 80003b06 <fileclose>
    iunlockput(ip);
    80004d56:	854a                	mv	a0,s2
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	172080e7          	jalr	370(ra) # 80002eca <iunlockput>
    end_op();
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	95a080e7          	jalr	-1702(ra) # 800036ba <end_op>
    return -1;
    80004d68:	54fd                	li	s1,-1
    80004d6a:	b7b9                	j	80004cb8 <sys_open+0xe4>

0000000080004d6c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d6c:	7175                	addi	sp,sp,-144
    80004d6e:	e506                	sd	ra,136(sp)
    80004d70:	e122                	sd	s0,128(sp)
    80004d72:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d74:	fffff097          	auipc	ra,0xfffff
    80004d78:	8c6080e7          	jalr	-1850(ra) # 8000363a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d7c:	08000613          	li	a2,128
    80004d80:	f7040593          	addi	a1,s0,-144
    80004d84:	4501                	li	a0,0
    80004d86:	ffffd097          	auipc	ra,0xffffd
    80004d8a:	3b4080e7          	jalr	948(ra) # 8000213a <argstr>
    80004d8e:	02054963          	bltz	a0,80004dc0 <sys_mkdir+0x54>
    80004d92:	4681                	li	a3,0
    80004d94:	4601                	li	a2,0
    80004d96:	4585                	li	a1,1
    80004d98:	f7040513          	addi	a0,s0,-144
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	7fe080e7          	jalr	2046(ra) # 8000459a <create>
    80004da4:	cd11                	beqz	a0,80004dc0 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	124080e7          	jalr	292(ra) # 80002eca <iunlockput>
  end_op();
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	90c080e7          	jalr	-1780(ra) # 800036ba <end_op>
  return 0;
    80004db6:	4501                	li	a0,0
}
    80004db8:	60aa                	ld	ra,136(sp)
    80004dba:	640a                	ld	s0,128(sp)
    80004dbc:	6149                	addi	sp,sp,144
    80004dbe:	8082                	ret
    end_op();
    80004dc0:	fffff097          	auipc	ra,0xfffff
    80004dc4:	8fa080e7          	jalr	-1798(ra) # 800036ba <end_op>
    return -1;
    80004dc8:	557d                	li	a0,-1
    80004dca:	b7fd                	j	80004db8 <sys_mkdir+0x4c>

0000000080004dcc <sys_mknod>:

uint64
sys_mknod(void)
{
    80004dcc:	7135                	addi	sp,sp,-160
    80004dce:	ed06                	sd	ra,152(sp)
    80004dd0:	e922                	sd	s0,144(sp)
    80004dd2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	866080e7          	jalr	-1946(ra) # 8000363a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ddc:	08000613          	li	a2,128
    80004de0:	f7040593          	addi	a1,s0,-144
    80004de4:	4501                	li	a0,0
    80004de6:	ffffd097          	auipc	ra,0xffffd
    80004dea:	354080e7          	jalr	852(ra) # 8000213a <argstr>
    80004dee:	04054a63          	bltz	a0,80004e42 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004df2:	f6c40593          	addi	a1,s0,-148
    80004df6:	4505                	li	a0,1
    80004df8:	ffffd097          	auipc	ra,0xffffd
    80004dfc:	2fe080e7          	jalr	766(ra) # 800020f6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e00:	04054163          	bltz	a0,80004e42 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e04:	f6840593          	addi	a1,s0,-152
    80004e08:	4509                	li	a0,2
    80004e0a:	ffffd097          	auipc	ra,0xffffd
    80004e0e:	2ec080e7          	jalr	748(ra) # 800020f6 <argint>
     argint(1, &major) < 0 ||
    80004e12:	02054863          	bltz	a0,80004e42 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e16:	f6841683          	lh	a3,-152(s0)
    80004e1a:	f6c41603          	lh	a2,-148(s0)
    80004e1e:	458d                	li	a1,3
    80004e20:	f7040513          	addi	a0,s0,-144
    80004e24:	fffff097          	auipc	ra,0xfffff
    80004e28:	776080e7          	jalr	1910(ra) # 8000459a <create>
     argint(2, &minor) < 0 ||
    80004e2c:	c919                	beqz	a0,80004e42 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	09c080e7          	jalr	156(ra) # 80002eca <iunlockput>
  end_op();
    80004e36:	fffff097          	auipc	ra,0xfffff
    80004e3a:	884080e7          	jalr	-1916(ra) # 800036ba <end_op>
  return 0;
    80004e3e:	4501                	li	a0,0
    80004e40:	a031                	j	80004e4c <sys_mknod+0x80>
    end_op();
    80004e42:	fffff097          	auipc	ra,0xfffff
    80004e46:	878080e7          	jalr	-1928(ra) # 800036ba <end_op>
    return -1;
    80004e4a:	557d                	li	a0,-1
}
    80004e4c:	60ea                	ld	ra,152(sp)
    80004e4e:	644a                	ld	s0,144(sp)
    80004e50:	610d                	addi	sp,sp,160
    80004e52:	8082                	ret

0000000080004e54 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e54:	7135                	addi	sp,sp,-160
    80004e56:	ed06                	sd	ra,152(sp)
    80004e58:	e922                	sd	s0,144(sp)
    80004e5a:	e526                	sd	s1,136(sp)
    80004e5c:	e14a                	sd	s2,128(sp)
    80004e5e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e60:	ffffc097          	auipc	ra,0xffffc
    80004e64:	fce080e7          	jalr	-50(ra) # 80000e2e <myproc>
    80004e68:	892a                	mv	s2,a0
  
  begin_op();
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	7d0080e7          	jalr	2000(ra) # 8000363a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e72:	08000613          	li	a2,128
    80004e76:	f6040593          	addi	a1,s0,-160
    80004e7a:	4501                	li	a0,0
    80004e7c:	ffffd097          	auipc	ra,0xffffd
    80004e80:	2be080e7          	jalr	702(ra) # 8000213a <argstr>
    80004e84:	04054b63          	bltz	a0,80004eda <sys_chdir+0x86>
    80004e88:	f6040513          	addi	a0,s0,-160
    80004e8c:	ffffe097          	auipc	ra,0xffffe
    80004e90:	592080e7          	jalr	1426(ra) # 8000341e <namei>
    80004e94:	84aa                	mv	s1,a0
    80004e96:	c131                	beqz	a0,80004eda <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e98:	ffffe097          	auipc	ra,0xffffe
    80004e9c:	dd0080e7          	jalr	-560(ra) # 80002c68 <ilock>
  if(ip->type != T_DIR){
    80004ea0:	04449703          	lh	a4,68(s1)
    80004ea4:	4785                	li	a5,1
    80004ea6:	04f71063          	bne	a4,a5,80004ee6 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004eaa:	8526                	mv	a0,s1
    80004eac:	ffffe097          	auipc	ra,0xffffe
    80004eb0:	e7e080e7          	jalr	-386(ra) # 80002d2a <iunlock>
  iput(p->cwd);
    80004eb4:	15093503          	ld	a0,336(s2)
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	f6a080e7          	jalr	-150(ra) # 80002e22 <iput>
  end_op();
    80004ec0:	ffffe097          	auipc	ra,0xffffe
    80004ec4:	7fa080e7          	jalr	2042(ra) # 800036ba <end_op>
  p->cwd = ip;
    80004ec8:	14993823          	sd	s1,336(s2)
  return 0;
    80004ecc:	4501                	li	a0,0
}
    80004ece:	60ea                	ld	ra,152(sp)
    80004ed0:	644a                	ld	s0,144(sp)
    80004ed2:	64aa                	ld	s1,136(sp)
    80004ed4:	690a                	ld	s2,128(sp)
    80004ed6:	610d                	addi	sp,sp,160
    80004ed8:	8082                	ret
    end_op();
    80004eda:	ffffe097          	auipc	ra,0xffffe
    80004ede:	7e0080e7          	jalr	2016(ra) # 800036ba <end_op>
    return -1;
    80004ee2:	557d                	li	a0,-1
    80004ee4:	b7ed                	j	80004ece <sys_chdir+0x7a>
    iunlockput(ip);
    80004ee6:	8526                	mv	a0,s1
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	fe2080e7          	jalr	-30(ra) # 80002eca <iunlockput>
    end_op();
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	7ca080e7          	jalr	1994(ra) # 800036ba <end_op>
    return -1;
    80004ef8:	557d                	li	a0,-1
    80004efa:	bfd1                	j	80004ece <sys_chdir+0x7a>

0000000080004efc <sys_exec>:

uint64
sys_exec(void)
{
    80004efc:	7145                	addi	sp,sp,-464
    80004efe:	e786                	sd	ra,456(sp)
    80004f00:	e3a2                	sd	s0,448(sp)
    80004f02:	ff26                	sd	s1,440(sp)
    80004f04:	fb4a                	sd	s2,432(sp)
    80004f06:	f74e                	sd	s3,424(sp)
    80004f08:	f352                	sd	s4,416(sp)
    80004f0a:	ef56                	sd	s5,408(sp)
    80004f0c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f0e:	08000613          	li	a2,128
    80004f12:	f4040593          	addi	a1,s0,-192
    80004f16:	4501                	li	a0,0
    80004f18:	ffffd097          	auipc	ra,0xffffd
    80004f1c:	222080e7          	jalr	546(ra) # 8000213a <argstr>
    return -1;
    80004f20:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f22:	0c054a63          	bltz	a0,80004ff6 <sys_exec+0xfa>
    80004f26:	e3840593          	addi	a1,s0,-456
    80004f2a:	4505                	li	a0,1
    80004f2c:	ffffd097          	auipc	ra,0xffffd
    80004f30:	1ec080e7          	jalr	492(ra) # 80002118 <argaddr>
    80004f34:	0c054163          	bltz	a0,80004ff6 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f38:	10000613          	li	a2,256
    80004f3c:	4581                	li	a1,0
    80004f3e:	e4040513          	addi	a0,s0,-448
    80004f42:	ffffb097          	auipc	ra,0xffffb
    80004f46:	236080e7          	jalr	566(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f4a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f4e:	89a6                	mv	s3,s1
    80004f50:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f52:	02000a13          	li	s4,32
    80004f56:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f5a:	00391513          	slli	a0,s2,0x3
    80004f5e:	e3040593          	addi	a1,s0,-464
    80004f62:	e3843783          	ld	a5,-456(s0)
    80004f66:	953e                	add	a0,a0,a5
    80004f68:	ffffd097          	auipc	ra,0xffffd
    80004f6c:	0f4080e7          	jalr	244(ra) # 8000205c <fetchaddr>
    80004f70:	02054a63          	bltz	a0,80004fa4 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004f74:	e3043783          	ld	a5,-464(s0)
    80004f78:	c3b9                	beqz	a5,80004fbe <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f7a:	ffffb097          	auipc	ra,0xffffb
    80004f7e:	19e080e7          	jalr	414(ra) # 80000118 <kalloc>
    80004f82:	85aa                	mv	a1,a0
    80004f84:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f88:	cd11                	beqz	a0,80004fa4 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f8a:	6605                	lui	a2,0x1
    80004f8c:	e3043503          	ld	a0,-464(s0)
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	11e080e7          	jalr	286(ra) # 800020ae <fetchstr>
    80004f98:	00054663          	bltz	a0,80004fa4 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004f9c:	0905                	addi	s2,s2,1
    80004f9e:	09a1                	addi	s3,s3,8
    80004fa0:	fb491be3          	bne	s2,s4,80004f56 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fa4:	10048913          	addi	s2,s1,256
    80004fa8:	6088                	ld	a0,0(s1)
    80004faa:	c529                	beqz	a0,80004ff4 <sys_exec+0xf8>
    kfree(argv[i]);
    80004fac:	ffffb097          	auipc	ra,0xffffb
    80004fb0:	070080e7          	jalr	112(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fb4:	04a1                	addi	s1,s1,8
    80004fb6:	ff2499e3          	bne	s1,s2,80004fa8 <sys_exec+0xac>
  return -1;
    80004fba:	597d                	li	s2,-1
    80004fbc:	a82d                	j	80004ff6 <sys_exec+0xfa>
      argv[i] = 0;
    80004fbe:	0a8e                	slli	s5,s5,0x3
    80004fc0:	fc040793          	addi	a5,s0,-64
    80004fc4:	9abe                	add	s5,s5,a5
    80004fc6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004fca:	e4040593          	addi	a1,s0,-448
    80004fce:	f4040513          	addi	a0,s0,-192
    80004fd2:	fffff097          	auipc	ra,0xfffff
    80004fd6:	194080e7          	jalr	404(ra) # 80004166 <exec>
    80004fda:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fdc:	10048993          	addi	s3,s1,256
    80004fe0:	6088                	ld	a0,0(s1)
    80004fe2:	c911                	beqz	a0,80004ff6 <sys_exec+0xfa>
    kfree(argv[i]);
    80004fe4:	ffffb097          	auipc	ra,0xffffb
    80004fe8:	038080e7          	jalr	56(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fec:	04a1                	addi	s1,s1,8
    80004fee:	ff3499e3          	bne	s1,s3,80004fe0 <sys_exec+0xe4>
    80004ff2:	a011                	j	80004ff6 <sys_exec+0xfa>
  return -1;
    80004ff4:	597d                	li	s2,-1
}
    80004ff6:	854a                	mv	a0,s2
    80004ff8:	60be                	ld	ra,456(sp)
    80004ffa:	641e                	ld	s0,448(sp)
    80004ffc:	74fa                	ld	s1,440(sp)
    80004ffe:	795a                	ld	s2,432(sp)
    80005000:	79ba                	ld	s3,424(sp)
    80005002:	7a1a                	ld	s4,416(sp)
    80005004:	6afa                	ld	s5,408(sp)
    80005006:	6179                	addi	sp,sp,464
    80005008:	8082                	ret

000000008000500a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000500a:	7139                	addi	sp,sp,-64
    8000500c:	fc06                	sd	ra,56(sp)
    8000500e:	f822                	sd	s0,48(sp)
    80005010:	f426                	sd	s1,40(sp)
    80005012:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005014:	ffffc097          	auipc	ra,0xffffc
    80005018:	e1a080e7          	jalr	-486(ra) # 80000e2e <myproc>
    8000501c:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000501e:	fd840593          	addi	a1,s0,-40
    80005022:	4501                	li	a0,0
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	0f4080e7          	jalr	244(ra) # 80002118 <argaddr>
    return -1;
    8000502c:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000502e:	0e054063          	bltz	a0,8000510e <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005032:	fc840593          	addi	a1,s0,-56
    80005036:	fd040513          	addi	a0,s0,-48
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	dfc080e7          	jalr	-516(ra) # 80003e36 <pipealloc>
    return -1;
    80005042:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005044:	0c054563          	bltz	a0,8000510e <sys_pipe+0x104>
  fd0 = -1;
    80005048:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000504c:	fd043503          	ld	a0,-48(s0)
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	508080e7          	jalr	1288(ra) # 80004558 <fdalloc>
    80005058:	fca42223          	sw	a0,-60(s0)
    8000505c:	08054c63          	bltz	a0,800050f4 <sys_pipe+0xea>
    80005060:	fc843503          	ld	a0,-56(s0)
    80005064:	fffff097          	auipc	ra,0xfffff
    80005068:	4f4080e7          	jalr	1268(ra) # 80004558 <fdalloc>
    8000506c:	fca42023          	sw	a0,-64(s0)
    80005070:	06054863          	bltz	a0,800050e0 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005074:	4691                	li	a3,4
    80005076:	fc440613          	addi	a2,s0,-60
    8000507a:	fd843583          	ld	a1,-40(s0)
    8000507e:	68a8                	ld	a0,80(s1)
    80005080:	ffffc097          	auipc	ra,0xffffc
    80005084:	a70080e7          	jalr	-1424(ra) # 80000af0 <copyout>
    80005088:	02054063          	bltz	a0,800050a8 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000508c:	4691                	li	a3,4
    8000508e:	fc040613          	addi	a2,s0,-64
    80005092:	fd843583          	ld	a1,-40(s0)
    80005096:	0591                	addi	a1,a1,4
    80005098:	68a8                	ld	a0,80(s1)
    8000509a:	ffffc097          	auipc	ra,0xffffc
    8000509e:	a56080e7          	jalr	-1450(ra) # 80000af0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050a2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050a4:	06055563          	bgez	a0,8000510e <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800050a8:	fc442783          	lw	a5,-60(s0)
    800050ac:	07e9                	addi	a5,a5,26
    800050ae:	078e                	slli	a5,a5,0x3
    800050b0:	97a6                	add	a5,a5,s1
    800050b2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050b6:	fc042503          	lw	a0,-64(s0)
    800050ba:	0569                	addi	a0,a0,26
    800050bc:	050e                	slli	a0,a0,0x3
    800050be:	9526                	add	a0,a0,s1
    800050c0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050c4:	fd043503          	ld	a0,-48(s0)
    800050c8:	fffff097          	auipc	ra,0xfffff
    800050cc:	a3e080e7          	jalr	-1474(ra) # 80003b06 <fileclose>
    fileclose(wf);
    800050d0:	fc843503          	ld	a0,-56(s0)
    800050d4:	fffff097          	auipc	ra,0xfffff
    800050d8:	a32080e7          	jalr	-1486(ra) # 80003b06 <fileclose>
    return -1;
    800050dc:	57fd                	li	a5,-1
    800050de:	a805                	j	8000510e <sys_pipe+0x104>
    if(fd0 >= 0)
    800050e0:	fc442783          	lw	a5,-60(s0)
    800050e4:	0007c863          	bltz	a5,800050f4 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800050e8:	01a78513          	addi	a0,a5,26
    800050ec:	050e                	slli	a0,a0,0x3
    800050ee:	9526                	add	a0,a0,s1
    800050f0:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800050f4:	fd043503          	ld	a0,-48(s0)
    800050f8:	fffff097          	auipc	ra,0xfffff
    800050fc:	a0e080e7          	jalr	-1522(ra) # 80003b06 <fileclose>
    fileclose(wf);
    80005100:	fc843503          	ld	a0,-56(s0)
    80005104:	fffff097          	auipc	ra,0xfffff
    80005108:	a02080e7          	jalr	-1534(ra) # 80003b06 <fileclose>
    return -1;
    8000510c:	57fd                	li	a5,-1
}
    8000510e:	853e                	mv	a0,a5
    80005110:	70e2                	ld	ra,56(sp)
    80005112:	7442                	ld	s0,48(sp)
    80005114:	74a2                	ld	s1,40(sp)
    80005116:	6121                	addi	sp,sp,64
    80005118:	8082                	ret

000000008000511a <munmap_impl>:

int
munmap_impl(uint64 addr, int length)
{
    8000511a:	715d                	addi	sp,sp,-80
    8000511c:	e486                	sd	ra,72(sp)
    8000511e:	e0a2                	sd	s0,64(sp)
    80005120:	fc26                	sd	s1,56(sp)
    80005122:	f84a                	sd	s2,48(sp)
    80005124:	f44e                	sd	s3,40(sp)
    80005126:	f052                	sd	s4,32(sp)
    80005128:	ec56                	sd	s5,24(sp)
    8000512a:	e85a                	sd	s6,16(sp)
    8000512c:	e45e                	sd	s7,8(sp)
    8000512e:	e062                	sd	s8,0(sp)
    80005130:	0880                	addi	s0,sp,80
    80005132:	892a                	mv	s2,a0
    80005134:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80005136:	ffffc097          	auipc	ra,0xffffc
    8000513a:	cf8080e7          	jalr	-776(ra) # 80000e2e <myproc>
    8000513e:	8aaa                	mv	s5,a0

  // 在 vma pool 中找到 addr 对应的 vma
  struct VMA *vma = 0;
  int i;
  for (i = 0; i < MAX_VMA_POOL; i++) {
    80005140:	16850793          	addi	a5,a0,360
    80005144:	4701                	li	a4,0
    vma = p->vma_pool + i;
    if (vma->used == 1 && addr >= vma->addr && (addr + length) < (vma->addr + vma->length)) {
    80005146:	4605                	li	a2,1
    80005148:	012a0533          	add	a0,s4,s2
  for (i = 0; i < MAX_VMA_POOL; i++) {
    8000514c:	4841                	li	a6,16
    8000514e:	a031                	j	8000515a <munmap_impl+0x40>
    80005150:	2705                	addiw	a4,a4,1
    80005152:	02878793          	addi	a5,a5,40
    80005156:	03070163          	beq	a4,a6,80005178 <munmap_impl+0x5e>
    vma = p->vma_pool + i;
    8000515a:	84be                	mv	s1,a5
    if (vma->used == 1 && addr >= vma->addr && (addr + length) < (vma->addr + vma->length)) {
    8000515c:	4394                	lw	a3,0(a5)
    8000515e:	fec699e3          	bne	a3,a2,80005150 <munmap_impl+0x36>
    80005162:	6794                	ld	a3,8(a5)
    80005164:	fed966e3          	bltu	s2,a3,80005150 <munmap_impl+0x36>
    80005168:	0107e583          	lwu	a1,16(a5)
    8000516c:	96ae                	add	a3,a3,a1
    8000516e:	fed571e3          	bgeu	a0,a3,80005150 <munmap_impl+0x36>
      break;
    }
  }
  if (i > MAX_VMA_POOL) {
    80005172:	47c1                	li	a5,16
    80005174:	0ee7c863          	blt	a5,a4,80005264 <munmap_impl+0x14a>
    return -1;
  }
  // 根据 vma 的信息，将数据回写入文件中
  uint64 begin_addr = addr;
  uint64 end_addr = addr + length;
    80005178:	012a0bb3          	add	s7,s4,s2
  if (vma->flags == MAP_SHARED && vma->f->writable) {
    8000517c:	4c98                	lw	a4,24(s1)
    8000517e:	4785                	li	a5,1
    80005180:	02f70f63          	beq	a4,a5,800051be <munmap_impl+0xa4>
      uvmunmap(p->pagetable, cur_addr, 1, 1);
      cur_addr += PGSIZE;
    }
  }
  // 完成回写后，更新 vma 中的信息
  if (addr == vma->addr) {  // 说明 addr 是 mmap 内存的头部
    80005184:	649c                	ld	a5,8(s1)
    80005186:	0b278a63          	beq	a5,s2,8000523a <munmap_impl+0x120>
    vma->addr += length;
    vma->length -= length;
  } else if (addr + length == vma->addr + vma->length) { // 说明 addr 是 mmap 的尾部
    8000518a:	4894                	lw	a3,16(s1)
    8000518c:	02069713          	slli	a4,a3,0x20
    80005190:	9301                	srli	a4,a4,0x20
    80005192:	97ba                	add	a5,a5,a4
    80005194:	0b778b63          	beq	a5,s7,8000524a <munmap_impl+0x130>
    vma->length -= length;
  }
  // 如果 mmap 的内存全部被 munmmap，那需要释放 vma 以及对 file 的引用
  if (vma->length == 0 && vma->used == 1) {
    80005198:	489c                	lw	a5,16(s1)
    filedup(vma->f);
    vma->used = 0;
  }
  return 0;
    8000519a:	4501                	li	a0,0
  if (vma->length == 0 && vma->used == 1) {
    8000519c:	e789                	bnez	a5,800051a6 <munmap_impl+0x8c>
    8000519e:	4098                	lw	a4,0(s1)
    800051a0:	4785                	li	a5,1
    800051a2:	0af70863          	beq	a4,a5,80005252 <munmap_impl+0x138>
}
    800051a6:	60a6                	ld	ra,72(sp)
    800051a8:	6406                	ld	s0,64(sp)
    800051aa:	74e2                	ld	s1,56(sp)
    800051ac:	7942                	ld	s2,48(sp)
    800051ae:	79a2                	ld	s3,40(sp)
    800051b0:	7a02                	ld	s4,32(sp)
    800051b2:	6ae2                	ld	s5,24(sp)
    800051b4:	6b42                	ld	s6,16(sp)
    800051b6:	6ba2                	ld	s7,8(sp)
    800051b8:	6c02                	ld	s8,0(sp)
    800051ba:	6161                	addi	sp,sp,80
    800051bc:	8082                	ret
  if (vma->flags == MAP_SHARED && vma->f->writable) {
    800051be:	709c                	ld	a5,32(s1)
    800051c0:	0097c783          	lbu	a5,9(a5)
    800051c4:	d3e1                	beqz	a5,80005184 <munmap_impl+0x6a>
    while (cur_addr < end_addr) {
    800051c6:	fb797fe3          	bgeu	s2,s7,80005184 <munmap_impl+0x6a>
    uint64 cur_addr = begin_addr;
    800051ca:	89ca                	mv	s3,s2
      int sz = end_addr - cur_addr >= PGSIZE? PGSIZE: end_addr - cur_addr;
    800051cc:	6c05                	lui	s8,0x1
    800051ce:	a085                	j	8000522e <munmap_impl+0x114>
      begin_op();
    800051d0:	ffffe097          	auipc	ra,0xffffe
    800051d4:	46a080e7          	jalr	1130(ra) # 8000363a <begin_op>
      ilock(vma->f->ip);
    800051d8:	709c                	ld	a5,32(s1)
    800051da:	6f88                	ld	a0,24(a5)
    800051dc:	ffffe097          	auipc	ra,0xffffe
    800051e0:	a8c080e7          	jalr	-1396(ra) # 80002c68 <ilock>
      if (writei(vma->f->ip, 1, cur_addr, cur_addr - vma->addr, sz) != sz) {
    800051e4:	2b01                	sext.w	s6,s6
    800051e6:	6494                	ld	a3,8(s1)
    800051e8:	709c                	ld	a5,32(s1)
    800051ea:	875a                	mv	a4,s6
    800051ec:	40d986bb          	subw	a3,s3,a3
    800051f0:	864e                	mv	a2,s3
    800051f2:	4585                	li	a1,1
    800051f4:	6f88                	ld	a0,24(a5)
    800051f6:	ffffe097          	auipc	ra,0xffffe
    800051fa:	e1e080e7          	jalr	-482(ra) # 80003014 <writei>
    800051fe:	07651563          	bne	a0,s6,80005268 <munmap_impl+0x14e>
      iunlock(vma->f->ip);
    80005202:	709c                	ld	a5,32(s1)
    80005204:	6f88                	ld	a0,24(a5)
    80005206:	ffffe097          	auipc	ra,0xffffe
    8000520a:	b24080e7          	jalr	-1244(ra) # 80002d2a <iunlock>
      end_op();
    8000520e:	ffffe097          	auipc	ra,0xffffe
    80005212:	4ac080e7          	jalr	1196(ra) # 800036ba <end_op>
      uvmunmap(p->pagetable, cur_addr, 1, 1);
    80005216:	4685                	li	a3,1
    80005218:	4605                	li	a2,1
    8000521a:	85ce                	mv	a1,s3
    8000521c:	050ab503          	ld	a0,80(s5)
    80005220:	ffffb097          	auipc	ra,0xffffb
    80005224:	4ee080e7          	jalr	1262(ra) # 8000070e <uvmunmap>
      cur_addr += PGSIZE;
    80005228:	99e2                	add	s3,s3,s8
    while (cur_addr < end_addr) {
    8000522a:	f579fde3          	bgeu	s3,s7,80005184 <munmap_impl+0x6a>
      int sz = end_addr - cur_addr >= PGSIZE? PGSIZE: end_addr - cur_addr;
    8000522e:	413b8b33          	sub	s6,s7,s3
    80005232:	f96c7fe3          	bgeu	s8,s6,800051d0 <munmap_impl+0xb6>
    80005236:	8b62                	mv	s6,s8
    80005238:	bf61                	j	800051d0 <munmap_impl+0xb6>
    vma->addr += length;
    8000523a:	0174b423          	sd	s7,8(s1)
    vma->length -= length;
    8000523e:	489c                	lw	a5,16(s1)
    80005240:	41478a3b          	subw	s4,a5,s4
    80005244:	0144a823          	sw	s4,16(s1)
    80005248:	bf81                	j	80005198 <munmap_impl+0x7e>
    vma->length -= length;
    8000524a:	414686bb          	subw	a3,a3,s4
    8000524e:	c894                	sw	a3,16(s1)
    80005250:	b7a1                	j	80005198 <munmap_impl+0x7e>
    filedup(vma->f);
    80005252:	7088                	ld	a0,32(s1)
    80005254:	fffff097          	auipc	ra,0xfffff
    80005258:	860080e7          	jalr	-1952(ra) # 80003ab4 <filedup>
    vma->used = 0;
    8000525c:	0004a023          	sw	zero,0(s1)
  return 0;
    80005260:	4501                	li	a0,0
    80005262:	b791                	j	800051a6 <munmap_impl+0x8c>
    return -1;
    80005264:	557d                	li	a0,-1
    80005266:	b781                	j	800051a6 <munmap_impl+0x8c>
        return -1;
    80005268:	557d                	li	a0,-1
    8000526a:	bf35                	j	800051a6 <munmap_impl+0x8c>

000000008000526c <sys_mmap>:

uint64
sys_mmap(void)
{
    8000526c:	7139                	addi	sp,sp,-64
    8000526e:	fc06                	sd	ra,56(sp)
    80005270:	f822                	sd	s0,48(sp)
    80005272:	f426                	sd	s1,40(sp)
    80005274:	f04a                	sd	s2,32(sp)
    80005276:	0080                	addi	s0,sp,64
    uint64 addr;    // 假定传入的 addr 参数永远为 0
    int length, prot, flags, offset;
    struct file *f;

    // system call 的参数检验
    if (argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argint(2, &prot) < 0
    80005278:	fd840593          	addi	a1,s0,-40
    8000527c:	4501                	li	a0,0
    8000527e:	ffffd097          	auipc	ra,0xffffd
    80005282:	e9a080e7          	jalr	-358(ra) # 80002118 <argaddr>
        || argint(3, &flags) < 0 || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0) {
        return -1;
    80005286:	57fd                	li	a5,-1
    if (argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argint(2, &prot) < 0
    80005288:	0e054063          	bltz	a0,80005368 <sys_mmap+0xfc>
    8000528c:	fd440593          	addi	a1,s0,-44
    80005290:	4505                	li	a0,1
    80005292:	ffffd097          	auipc	ra,0xffffd
    80005296:	e64080e7          	jalr	-412(ra) # 800020f6 <argint>
        return -1;
    8000529a:	57fd                	li	a5,-1
    if (argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argint(2, &prot) < 0
    8000529c:	0c054663          	bltz	a0,80005368 <sys_mmap+0xfc>
    800052a0:	fd040593          	addi	a1,s0,-48
    800052a4:	4509                	li	a0,2
    800052a6:	ffffd097          	auipc	ra,0xffffd
    800052aa:	e50080e7          	jalr	-432(ra) # 800020f6 <argint>
        return -1;
    800052ae:	57fd                	li	a5,-1
    if (argaddr(0, &addr) < 0 || argint(1, &length) < 0 || argint(2, &prot) < 0
    800052b0:	0a054c63          	bltz	a0,80005368 <sys_mmap+0xfc>
        || argint(3, &flags) < 0 || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0) {
    800052b4:	fcc40593          	addi	a1,s0,-52
    800052b8:	450d                	li	a0,3
    800052ba:	ffffd097          	auipc	ra,0xffffd
    800052be:	e3c080e7          	jalr	-452(ra) # 800020f6 <argint>
        return -1;
    800052c2:	57fd                	li	a5,-1
        || argint(3, &flags) < 0 || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0) {
    800052c4:	0a054263          	bltz	a0,80005368 <sys_mmap+0xfc>
    800052c8:	fc040613          	addi	a2,s0,-64
    800052cc:	4581                	li	a1,0
    800052ce:	4511                	li	a0,4
    800052d0:	fffff097          	auipc	ra,0xfffff
    800052d4:	220080e7          	jalr	544(ra) # 800044f0 <argfd>
        return -1;
    800052d8:	57fd                	li	a5,-1
        || argint(3, &flags) < 0 || argfd(4, 0, &f) < 0 || argint(5, &offset) < 0) {
    800052da:	08054763          	bltz	a0,80005368 <sys_mmap+0xfc>
    800052de:	fc840593          	addi	a1,s0,-56
    800052e2:	4515                	li	a0,5
    800052e4:	ffffd097          	auipc	ra,0xffffd
    800052e8:	e12080e7          	jalr	-494(ra) # 800020f6 <argint>
    800052ec:	08054563          	bltz	a0,80005376 <sys_mmap+0x10a>
    }

    // 检查权限
    if (!f->writable && (prot & PROT_WRITE) && flags == MAP_SHARED) {
    800052f0:	fc043783          	ld	a5,-64(s0)
    800052f4:	0097c783          	lbu	a5,9(a5)
    800052f8:	eb91                	bnez	a5,8000530c <sys_mmap+0xa0>
    800052fa:	fd042783          	lw	a5,-48(s0)
    800052fe:	8b89                	andi	a5,a5,2
    80005300:	c791                	beqz	a5,8000530c <sys_mmap+0xa0>
    80005302:	fcc42703          	lw	a4,-52(s0)
    80005306:	4785                	li	a5,1
    80005308:	06f70963          	beq	a4,a5,8000537a <sys_mmap+0x10e>
        return -1;
    }

    // 从 vma pool 中分配一个 vma，并填充
    uint64 vma_addr = vma_alloc();
    8000530c:	ffffc097          	auipc	ra,0xffffc
    80005310:	794080e7          	jalr	1940(ra) # 80001aa0 <vma_alloc>
    80005314:	84aa                	mv	s1,a0
    if (vma_addr == 0) {
        return -1;
    80005316:	57fd                	li	a5,-1
    if (vma_addr == 0) {
    80005318:	c921                	beqz	a0,80005368 <sys_mmap+0xfc>
    }

    struct VMA* vma = (struct VMA*) vma_addr;
    struct proc *p = myproc();
    8000531a:	ffffc097          	auipc	ra,0xffffc
    8000531e:	b14080e7          	jalr	-1260(ra) # 80000e2e <myproc>
    80005322:	892a                	mv	s2,a0
    vma->addr = p->sz;
    80005324:	653c                	ld	a5,72(a0)
    80005326:	e49c                	sd	a5,8(s1)
    vma->length = PGROUNDUP(length);
    80005328:	fd442783          	lw	a5,-44(s0)
    8000532c:	6705                	lui	a4,0x1
    8000532e:	377d                	addiw	a4,a4,-1
    80005330:	9fb9                	addw	a5,a5,a4
    80005332:	777d                	lui	a4,0xfffff
    80005334:	8ff9                	and	a5,a5,a4
    80005336:	c89c                	sw	a5,16(s1)
    vma->prot = prot;
    80005338:	fd042783          	lw	a5,-48(s0)
    8000533c:	c8dc                	sw	a5,20(s1)
    vma->flags = flags;
    8000533e:	fcc42783          	lw	a5,-52(s0)
    80005342:	cc9c                	sw	a5,24(s1)
    vma->offset = offset;
    80005344:	fc842783          	lw	a5,-56(s0)
    80005348:	ccdc                	sw	a5,28(s1)
    vma->f = filedup(f);  // 对 f 的引用 +1
    8000534a:	fc043503          	ld	a0,-64(s0)
    8000534e:	ffffe097          	auipc	ra,0xffffe
    80005352:	766080e7          	jalr	1894(ra) # 80003ab4 <filedup>
    80005356:	f088                	sd	a0,32(s1)

    // 调整分配出去，增加 proc 的 sz
    p->sz += vma->length;
    80005358:	0104e703          	lwu	a4,16(s1)
    8000535c:	04893783          	ld	a5,72(s2)
    80005360:	97ba                	add	a5,a5,a4
    80005362:	04f93423          	sd	a5,72(s2)
    return vma->addr;
    80005366:	649c                	ld	a5,8(s1)
}
    80005368:	853e                	mv	a0,a5
    8000536a:	70e2                	ld	ra,56(sp)
    8000536c:	7442                	ld	s0,48(sp)
    8000536e:	74a2                	ld	s1,40(sp)
    80005370:	7902                	ld	s2,32(sp)
    80005372:	6121                	addi	sp,sp,64
    80005374:	8082                	ret
        return -1;
    80005376:	57fd                	li	a5,-1
    80005378:	bfc5                	j	80005368 <sys_mmap+0xfc>
        return -1;
    8000537a:	57fd                	li	a5,-1
    8000537c:	b7f5                	j	80005368 <sys_mmap+0xfc>

000000008000537e <sys_munmap>:

uint64
sys_munmap(void)
{
    8000537e:	1101                	addi	sp,sp,-32
    80005380:	ec06                	sd	ra,24(sp)
    80005382:	e822                	sd	s0,16(sp)
    80005384:	1000                	addi	s0,sp,32
    uint64 addr;
    int length;

    // 校验 system call 的参数
    if (argaddr(0, &addr) < 0 || argint(1, &length)) {
    80005386:	fe840593          	addi	a1,s0,-24
    8000538a:	4501                	li	a0,0
    8000538c:	ffffd097          	auipc	ra,0xffffd
    80005390:	d8c080e7          	jalr	-628(ra) # 80002118 <argaddr>
        return -1;
    80005394:	57fd                	li	a5,-1
    if (argaddr(0, &addr) < 0 || argint(1, &length)) {
    80005396:	02054463          	bltz	a0,800053be <sys_munmap+0x40>
    8000539a:	fe440593          	addi	a1,s0,-28
    8000539e:	4505                	li	a0,1
    800053a0:	ffffd097          	auipc	ra,0xffffd
    800053a4:	d56080e7          	jalr	-682(ra) # 800020f6 <argint>
        return -1;
    800053a8:	57fd                	li	a5,-1
    if (argaddr(0, &addr) < 0 || argint(1, &length)) {
    800053aa:	e911                	bnez	a0,800053be <sys_munmap+0x40>
    }

    return (uint64) munmap_impl(addr, length);
    800053ac:	fe442583          	lw	a1,-28(s0)
    800053b0:	fe843503          	ld	a0,-24(s0)
    800053b4:	00000097          	auipc	ra,0x0
    800053b8:	d66080e7          	jalr	-666(ra) # 8000511a <munmap_impl>
    800053bc:	87aa                	mv	a5,a0
}
    800053be:	853e                	mv	a0,a5
    800053c0:	60e2                	ld	ra,24(sp)
    800053c2:	6442                	ld	s0,16(sp)
    800053c4:	6105                	addi	sp,sp,32
    800053c6:	8082                	ret
	...

00000000800053d0 <kernelvec>:
    800053d0:	7111                	addi	sp,sp,-256
    800053d2:	e006                	sd	ra,0(sp)
    800053d4:	e40a                	sd	sp,8(sp)
    800053d6:	e80e                	sd	gp,16(sp)
    800053d8:	ec12                	sd	tp,24(sp)
    800053da:	f016                	sd	t0,32(sp)
    800053dc:	f41a                	sd	t1,40(sp)
    800053de:	f81e                	sd	t2,48(sp)
    800053e0:	fc22                	sd	s0,56(sp)
    800053e2:	e0a6                	sd	s1,64(sp)
    800053e4:	e4aa                	sd	a0,72(sp)
    800053e6:	e8ae                	sd	a1,80(sp)
    800053e8:	ecb2                	sd	a2,88(sp)
    800053ea:	f0b6                	sd	a3,96(sp)
    800053ec:	f4ba                	sd	a4,104(sp)
    800053ee:	f8be                	sd	a5,112(sp)
    800053f0:	fcc2                	sd	a6,120(sp)
    800053f2:	e146                	sd	a7,128(sp)
    800053f4:	e54a                	sd	s2,136(sp)
    800053f6:	e94e                	sd	s3,144(sp)
    800053f8:	ed52                	sd	s4,152(sp)
    800053fa:	f156                	sd	s5,160(sp)
    800053fc:	f55a                	sd	s6,168(sp)
    800053fe:	f95e                	sd	s7,176(sp)
    80005400:	fd62                	sd	s8,184(sp)
    80005402:	e1e6                	sd	s9,192(sp)
    80005404:	e5ea                	sd	s10,200(sp)
    80005406:	e9ee                	sd	s11,208(sp)
    80005408:	edf2                	sd	t3,216(sp)
    8000540a:	f1f6                	sd	t4,224(sp)
    8000540c:	f5fa                	sd	t5,232(sp)
    8000540e:	f9fe                	sd	t6,240(sp)
    80005410:	b19fc0ef          	jal	ra,80001f28 <kerneltrap>
    80005414:	6082                	ld	ra,0(sp)
    80005416:	6122                	ld	sp,8(sp)
    80005418:	61c2                	ld	gp,16(sp)
    8000541a:	7282                	ld	t0,32(sp)
    8000541c:	7322                	ld	t1,40(sp)
    8000541e:	73c2                	ld	t2,48(sp)
    80005420:	7462                	ld	s0,56(sp)
    80005422:	6486                	ld	s1,64(sp)
    80005424:	6526                	ld	a0,72(sp)
    80005426:	65c6                	ld	a1,80(sp)
    80005428:	6666                	ld	a2,88(sp)
    8000542a:	7686                	ld	a3,96(sp)
    8000542c:	7726                	ld	a4,104(sp)
    8000542e:	77c6                	ld	a5,112(sp)
    80005430:	7866                	ld	a6,120(sp)
    80005432:	688a                	ld	a7,128(sp)
    80005434:	692a                	ld	s2,136(sp)
    80005436:	69ca                	ld	s3,144(sp)
    80005438:	6a6a                	ld	s4,152(sp)
    8000543a:	7a8a                	ld	s5,160(sp)
    8000543c:	7b2a                	ld	s6,168(sp)
    8000543e:	7bca                	ld	s7,176(sp)
    80005440:	7c6a                	ld	s8,184(sp)
    80005442:	6c8e                	ld	s9,192(sp)
    80005444:	6d2e                	ld	s10,200(sp)
    80005446:	6dce                	ld	s11,208(sp)
    80005448:	6e6e                	ld	t3,216(sp)
    8000544a:	7e8e                	ld	t4,224(sp)
    8000544c:	7f2e                	ld	t5,232(sp)
    8000544e:	7fce                	ld	t6,240(sp)
    80005450:	6111                	addi	sp,sp,256
    80005452:	10200073          	sret
    80005456:	00000013          	nop
    8000545a:	00000013          	nop
    8000545e:	0001                	nop

0000000080005460 <timervec>:
    80005460:	34051573          	csrrw	a0,mscratch,a0
    80005464:	e10c                	sd	a1,0(a0)
    80005466:	e510                	sd	a2,8(a0)
    80005468:	e914                	sd	a3,16(a0)
    8000546a:	6d0c                	ld	a1,24(a0)
    8000546c:	7110                	ld	a2,32(a0)
    8000546e:	6194                	ld	a3,0(a1)
    80005470:	96b2                	add	a3,a3,a2
    80005472:	e194                	sd	a3,0(a1)
    80005474:	4589                	li	a1,2
    80005476:	14459073          	csrw	sip,a1
    8000547a:	6914                	ld	a3,16(a0)
    8000547c:	6510                	ld	a2,8(a0)
    8000547e:	610c                	ld	a1,0(a0)
    80005480:	34051573          	csrrw	a0,mscratch,a0
    80005484:	30200073          	mret
	...

000000008000548a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000548a:	1141                	addi	sp,sp,-16
    8000548c:	e422                	sd	s0,8(sp)
    8000548e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005490:	0c0007b7          	lui	a5,0xc000
    80005494:	4705                	li	a4,1
    80005496:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005498:	c3d8                	sw	a4,4(a5)
}
    8000549a:	6422                	ld	s0,8(sp)
    8000549c:	0141                	addi	sp,sp,16
    8000549e:	8082                	ret

00000000800054a0 <plicinithart>:

void
plicinithart(void)
{
    800054a0:	1141                	addi	sp,sp,-16
    800054a2:	e406                	sd	ra,8(sp)
    800054a4:	e022                	sd	s0,0(sp)
    800054a6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054a8:	ffffc097          	auipc	ra,0xffffc
    800054ac:	95a080e7          	jalr	-1702(ra) # 80000e02 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054b0:	0085171b          	slliw	a4,a0,0x8
    800054b4:	0c0027b7          	lui	a5,0xc002
    800054b8:	97ba                	add	a5,a5,a4
    800054ba:	40200713          	li	a4,1026
    800054be:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054c2:	00d5151b          	slliw	a0,a0,0xd
    800054c6:	0c2017b7          	lui	a5,0xc201
    800054ca:	953e                	add	a0,a0,a5
    800054cc:	00052023          	sw	zero,0(a0)
}
    800054d0:	60a2                	ld	ra,8(sp)
    800054d2:	6402                	ld	s0,0(sp)
    800054d4:	0141                	addi	sp,sp,16
    800054d6:	8082                	ret

00000000800054d8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054d8:	1141                	addi	sp,sp,-16
    800054da:	e406                	sd	ra,8(sp)
    800054dc:	e022                	sd	s0,0(sp)
    800054de:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054e0:	ffffc097          	auipc	ra,0xffffc
    800054e4:	922080e7          	jalr	-1758(ra) # 80000e02 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054e8:	00d5179b          	slliw	a5,a0,0xd
    800054ec:	0c201537          	lui	a0,0xc201
    800054f0:	953e                	add	a0,a0,a5
  return irq;
}
    800054f2:	4148                	lw	a0,4(a0)
    800054f4:	60a2                	ld	ra,8(sp)
    800054f6:	6402                	ld	s0,0(sp)
    800054f8:	0141                	addi	sp,sp,16
    800054fa:	8082                	ret

00000000800054fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054fc:	1101                	addi	sp,sp,-32
    800054fe:	ec06                	sd	ra,24(sp)
    80005500:	e822                	sd	s0,16(sp)
    80005502:	e426                	sd	s1,8(sp)
    80005504:	1000                	addi	s0,sp,32
    80005506:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005508:	ffffc097          	auipc	ra,0xffffc
    8000550c:	8fa080e7          	jalr	-1798(ra) # 80000e02 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005510:	00d5151b          	slliw	a0,a0,0xd
    80005514:	0c2017b7          	lui	a5,0xc201
    80005518:	97aa                	add	a5,a5,a0
    8000551a:	c3c4                	sw	s1,4(a5)
}
    8000551c:	60e2                	ld	ra,24(sp)
    8000551e:	6442                	ld	s0,16(sp)
    80005520:	64a2                	ld	s1,8(sp)
    80005522:	6105                	addi	sp,sp,32
    80005524:	8082                	ret

0000000080005526 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005526:	1141                	addi	sp,sp,-16
    80005528:	e406                	sd	ra,8(sp)
    8000552a:	e022                	sd	s0,0(sp)
    8000552c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000552e:	479d                	li	a5,7
    80005530:	06a7c963          	blt	a5,a0,800055a2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005534:	00020797          	auipc	a5,0x20
    80005538:	acc78793          	addi	a5,a5,-1332 # 80025000 <disk>
    8000553c:	00a78733          	add	a4,a5,a0
    80005540:	6789                	lui	a5,0x2
    80005542:	97ba                	add	a5,a5,a4
    80005544:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005548:	e7ad                	bnez	a5,800055b2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000554a:	00451793          	slli	a5,a0,0x4
    8000554e:	00022717          	auipc	a4,0x22
    80005552:	ab270713          	addi	a4,a4,-1358 # 80027000 <disk+0x2000>
    80005556:	6314                	ld	a3,0(a4)
    80005558:	96be                	add	a3,a3,a5
    8000555a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000555e:	6314                	ld	a3,0(a4)
    80005560:	96be                	add	a3,a3,a5
    80005562:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005566:	6314                	ld	a3,0(a4)
    80005568:	96be                	add	a3,a3,a5
    8000556a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000556e:	6318                	ld	a4,0(a4)
    80005570:	97ba                	add	a5,a5,a4
    80005572:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005576:	00020797          	auipc	a5,0x20
    8000557a:	a8a78793          	addi	a5,a5,-1398 # 80025000 <disk>
    8000557e:	97aa                	add	a5,a5,a0
    80005580:	6509                	lui	a0,0x2
    80005582:	953e                	add	a0,a0,a5
    80005584:	4785                	li	a5,1
    80005586:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000558a:	00022517          	auipc	a0,0x22
    8000558e:	a8e50513          	addi	a0,a0,-1394 # 80027018 <disk+0x2018>
    80005592:	ffffc097          	auipc	ra,0xffffc
    80005596:	146080e7          	jalr	326(ra) # 800016d8 <wakeup>
}
    8000559a:	60a2                	ld	ra,8(sp)
    8000559c:	6402                	ld	s0,0(sp)
    8000559e:	0141                	addi	sp,sp,16
    800055a0:	8082                	ret
    panic("free_desc 1");
    800055a2:	00003517          	auipc	a0,0x3
    800055a6:	12e50513          	addi	a0,a0,302 # 800086d0 <syscalls+0x330>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	a1e080e7          	jalr	-1506(ra) # 80005fc8 <panic>
    panic("free_desc 2");
    800055b2:	00003517          	auipc	a0,0x3
    800055b6:	12e50513          	addi	a0,a0,302 # 800086e0 <syscalls+0x340>
    800055ba:	00001097          	auipc	ra,0x1
    800055be:	a0e080e7          	jalr	-1522(ra) # 80005fc8 <panic>

00000000800055c2 <virtio_disk_init>:
{
    800055c2:	1101                	addi	sp,sp,-32
    800055c4:	ec06                	sd	ra,24(sp)
    800055c6:	e822                	sd	s0,16(sp)
    800055c8:	e426                	sd	s1,8(sp)
    800055ca:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055cc:	00003597          	auipc	a1,0x3
    800055d0:	12458593          	addi	a1,a1,292 # 800086f0 <syscalls+0x350>
    800055d4:	00022517          	auipc	a0,0x22
    800055d8:	b5450513          	addi	a0,a0,-1196 # 80027128 <disk+0x2128>
    800055dc:	00001097          	auipc	ra,0x1
    800055e0:	ea6080e7          	jalr	-346(ra) # 80006482 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055e4:	100017b7          	lui	a5,0x10001
    800055e8:	4398                	lw	a4,0(a5)
    800055ea:	2701                	sext.w	a4,a4
    800055ec:	747277b7          	lui	a5,0x74727
    800055f0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055f4:	0ef71163          	bne	a4,a5,800056d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800055f8:	100017b7          	lui	a5,0x10001
    800055fc:	43dc                	lw	a5,4(a5)
    800055fe:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005600:	4705                	li	a4,1
    80005602:	0ce79a63          	bne	a5,a4,800056d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005606:	100017b7          	lui	a5,0x10001
    8000560a:	479c                	lw	a5,8(a5)
    8000560c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000560e:	4709                	li	a4,2
    80005610:	0ce79363          	bne	a5,a4,800056d6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005614:	100017b7          	lui	a5,0x10001
    80005618:	47d8                	lw	a4,12(a5)
    8000561a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000561c:	554d47b7          	lui	a5,0x554d4
    80005620:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005624:	0af71963          	bne	a4,a5,800056d6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005628:	100017b7          	lui	a5,0x10001
    8000562c:	4705                	li	a4,1
    8000562e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005630:	470d                	li	a4,3
    80005632:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005634:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005636:	c7ffe737          	lui	a4,0xc7ffe
    8000563a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fce51f>
    8000563e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005640:	2701                	sext.w	a4,a4
    80005642:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005644:	472d                	li	a4,11
    80005646:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005648:	473d                	li	a4,15
    8000564a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000564c:	6705                	lui	a4,0x1
    8000564e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005650:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005654:	5bdc                	lw	a5,52(a5)
    80005656:	2781                	sext.w	a5,a5
  if(max == 0)
    80005658:	c7d9                	beqz	a5,800056e6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000565a:	471d                	li	a4,7
    8000565c:	08f77d63          	bgeu	a4,a5,800056f6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005660:	100014b7          	lui	s1,0x10001
    80005664:	47a1                	li	a5,8
    80005666:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005668:	6609                	lui	a2,0x2
    8000566a:	4581                	li	a1,0
    8000566c:	00020517          	auipc	a0,0x20
    80005670:	99450513          	addi	a0,a0,-1644 # 80025000 <disk>
    80005674:	ffffb097          	auipc	ra,0xffffb
    80005678:	b04080e7          	jalr	-1276(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000567c:	00020717          	auipc	a4,0x20
    80005680:	98470713          	addi	a4,a4,-1660 # 80025000 <disk>
    80005684:	00c75793          	srli	a5,a4,0xc
    80005688:	2781                	sext.w	a5,a5
    8000568a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000568c:	00022797          	auipc	a5,0x22
    80005690:	97478793          	addi	a5,a5,-1676 # 80027000 <disk+0x2000>
    80005694:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005696:	00020717          	auipc	a4,0x20
    8000569a:	9ea70713          	addi	a4,a4,-1558 # 80025080 <disk+0x80>
    8000569e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800056a0:	00021717          	auipc	a4,0x21
    800056a4:	96070713          	addi	a4,a4,-1696 # 80026000 <disk+0x1000>
    800056a8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800056aa:	4705                	li	a4,1
    800056ac:	00e78c23          	sb	a4,24(a5)
    800056b0:	00e78ca3          	sb	a4,25(a5)
    800056b4:	00e78d23          	sb	a4,26(a5)
    800056b8:	00e78da3          	sb	a4,27(a5)
    800056bc:	00e78e23          	sb	a4,28(a5)
    800056c0:	00e78ea3          	sb	a4,29(a5)
    800056c4:	00e78f23          	sb	a4,30(a5)
    800056c8:	00e78fa3          	sb	a4,31(a5)
}
    800056cc:	60e2                	ld	ra,24(sp)
    800056ce:	6442                	ld	s0,16(sp)
    800056d0:	64a2                	ld	s1,8(sp)
    800056d2:	6105                	addi	sp,sp,32
    800056d4:	8082                	ret
    panic("could not find virtio disk");
    800056d6:	00003517          	auipc	a0,0x3
    800056da:	02a50513          	addi	a0,a0,42 # 80008700 <syscalls+0x360>
    800056de:	00001097          	auipc	ra,0x1
    800056e2:	8ea080e7          	jalr	-1814(ra) # 80005fc8 <panic>
    panic("virtio disk has no queue 0");
    800056e6:	00003517          	auipc	a0,0x3
    800056ea:	03a50513          	addi	a0,a0,58 # 80008720 <syscalls+0x380>
    800056ee:	00001097          	auipc	ra,0x1
    800056f2:	8da080e7          	jalr	-1830(ra) # 80005fc8 <panic>
    panic("virtio disk max queue too short");
    800056f6:	00003517          	auipc	a0,0x3
    800056fa:	04a50513          	addi	a0,a0,74 # 80008740 <syscalls+0x3a0>
    800056fe:	00001097          	auipc	ra,0x1
    80005702:	8ca080e7          	jalr	-1846(ra) # 80005fc8 <panic>

0000000080005706 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005706:	7159                	addi	sp,sp,-112
    80005708:	f486                	sd	ra,104(sp)
    8000570a:	f0a2                	sd	s0,96(sp)
    8000570c:	eca6                	sd	s1,88(sp)
    8000570e:	e8ca                	sd	s2,80(sp)
    80005710:	e4ce                	sd	s3,72(sp)
    80005712:	e0d2                	sd	s4,64(sp)
    80005714:	fc56                	sd	s5,56(sp)
    80005716:	f85a                	sd	s6,48(sp)
    80005718:	f45e                	sd	s7,40(sp)
    8000571a:	f062                	sd	s8,32(sp)
    8000571c:	ec66                	sd	s9,24(sp)
    8000571e:	e86a                	sd	s10,16(sp)
    80005720:	1880                	addi	s0,sp,112
    80005722:	892a                	mv	s2,a0
    80005724:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005726:	00c52c83          	lw	s9,12(a0)
    8000572a:	001c9c9b          	slliw	s9,s9,0x1
    8000572e:	1c82                	slli	s9,s9,0x20
    80005730:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005734:	00022517          	auipc	a0,0x22
    80005738:	9f450513          	addi	a0,a0,-1548 # 80027128 <disk+0x2128>
    8000573c:	00001097          	auipc	ra,0x1
    80005740:	dd6080e7          	jalr	-554(ra) # 80006512 <acquire>
  for(int i = 0; i < 3; i++){
    80005744:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005746:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005748:	00020b97          	auipc	s7,0x20
    8000574c:	8b8b8b93          	addi	s7,s7,-1864 # 80025000 <disk>
    80005750:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005752:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005754:	8a4e                	mv	s4,s3
    80005756:	a051                	j	800057da <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005758:	00fb86b3          	add	a3,s7,a5
    8000575c:	96da                	add	a3,a3,s6
    8000575e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005762:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005764:	0207c563          	bltz	a5,8000578e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005768:	2485                	addiw	s1,s1,1
    8000576a:	0711                	addi	a4,a4,4
    8000576c:	25548063          	beq	s1,s5,800059ac <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005770:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005772:	00022697          	auipc	a3,0x22
    80005776:	8a668693          	addi	a3,a3,-1882 # 80027018 <disk+0x2018>
    8000577a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000577c:	0006c583          	lbu	a1,0(a3)
    80005780:	fde1                	bnez	a1,80005758 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005782:	2785                	addiw	a5,a5,1
    80005784:	0685                	addi	a3,a3,1
    80005786:	ff879be3          	bne	a5,s8,8000577c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000578a:	57fd                	li	a5,-1
    8000578c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000578e:	02905a63          	blez	s1,800057c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005792:	f9042503          	lw	a0,-112(s0)
    80005796:	00000097          	auipc	ra,0x0
    8000579a:	d90080e7          	jalr	-624(ra) # 80005526 <free_desc>
      for(int j = 0; j < i; j++)
    8000579e:	4785                	li	a5,1
    800057a0:	0297d163          	bge	a5,s1,800057c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800057a4:	f9442503          	lw	a0,-108(s0)
    800057a8:	00000097          	auipc	ra,0x0
    800057ac:	d7e080e7          	jalr	-642(ra) # 80005526 <free_desc>
      for(int j = 0; j < i; j++)
    800057b0:	4789                	li	a5,2
    800057b2:	0097d863          	bge	a5,s1,800057c2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800057b6:	f9842503          	lw	a0,-104(s0)
    800057ba:	00000097          	auipc	ra,0x0
    800057be:	d6c080e7          	jalr	-660(ra) # 80005526 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057c2:	00022597          	auipc	a1,0x22
    800057c6:	96658593          	addi	a1,a1,-1690 # 80027128 <disk+0x2128>
    800057ca:	00022517          	auipc	a0,0x22
    800057ce:	84e50513          	addi	a0,a0,-1970 # 80027018 <disk+0x2018>
    800057d2:	ffffc097          	auipc	ra,0xffffc
    800057d6:	d7a080e7          	jalr	-646(ra) # 8000154c <sleep>
  for(int i = 0; i < 3; i++){
    800057da:	f9040713          	addi	a4,s0,-112
    800057de:	84ce                	mv	s1,s3
    800057e0:	bf41                	j	80005770 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800057e2:	20058713          	addi	a4,a1,512
    800057e6:	00471693          	slli	a3,a4,0x4
    800057ea:	00020717          	auipc	a4,0x20
    800057ee:	81670713          	addi	a4,a4,-2026 # 80025000 <disk>
    800057f2:	9736                	add	a4,a4,a3
    800057f4:	4685                	li	a3,1
    800057f6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800057fa:	20058713          	addi	a4,a1,512
    800057fe:	00471693          	slli	a3,a4,0x4
    80005802:	0001f717          	auipc	a4,0x1f
    80005806:	7fe70713          	addi	a4,a4,2046 # 80025000 <disk>
    8000580a:	9736                	add	a4,a4,a3
    8000580c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005810:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005814:	7679                	lui	a2,0xffffe
    80005816:	963e                	add	a2,a2,a5
    80005818:	00021697          	auipc	a3,0x21
    8000581c:	7e868693          	addi	a3,a3,2024 # 80027000 <disk+0x2000>
    80005820:	6298                	ld	a4,0(a3)
    80005822:	9732                	add	a4,a4,a2
    80005824:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005826:	6298                	ld	a4,0(a3)
    80005828:	9732                	add	a4,a4,a2
    8000582a:	4541                	li	a0,16
    8000582c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000582e:	6298                	ld	a4,0(a3)
    80005830:	9732                	add	a4,a4,a2
    80005832:	4505                	li	a0,1
    80005834:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005838:	f9442703          	lw	a4,-108(s0)
    8000583c:	6288                	ld	a0,0(a3)
    8000583e:	962a                	add	a2,a2,a0
    80005840:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffcddce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005844:	0712                	slli	a4,a4,0x4
    80005846:	6290                	ld	a2,0(a3)
    80005848:	963a                	add	a2,a2,a4
    8000584a:	05890513          	addi	a0,s2,88
    8000584e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005850:	6294                	ld	a3,0(a3)
    80005852:	96ba                	add	a3,a3,a4
    80005854:	40000613          	li	a2,1024
    80005858:	c690                	sw	a2,8(a3)
  if(write)
    8000585a:	140d0063          	beqz	s10,8000599a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000585e:	00021697          	auipc	a3,0x21
    80005862:	7a26b683          	ld	a3,1954(a3) # 80027000 <disk+0x2000>
    80005866:	96ba                	add	a3,a3,a4
    80005868:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000586c:	0001f817          	auipc	a6,0x1f
    80005870:	79480813          	addi	a6,a6,1940 # 80025000 <disk>
    80005874:	00021517          	auipc	a0,0x21
    80005878:	78c50513          	addi	a0,a0,1932 # 80027000 <disk+0x2000>
    8000587c:	6114                	ld	a3,0(a0)
    8000587e:	96ba                	add	a3,a3,a4
    80005880:	00c6d603          	lhu	a2,12(a3)
    80005884:	00166613          	ori	a2,a2,1
    80005888:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000588c:	f9842683          	lw	a3,-104(s0)
    80005890:	6110                	ld	a2,0(a0)
    80005892:	9732                	add	a4,a4,a2
    80005894:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005898:	20058613          	addi	a2,a1,512
    8000589c:	0612                	slli	a2,a2,0x4
    8000589e:	9642                	add	a2,a2,a6
    800058a0:	577d                	li	a4,-1
    800058a2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058a6:	00469713          	slli	a4,a3,0x4
    800058aa:	6114                	ld	a3,0(a0)
    800058ac:	96ba                	add	a3,a3,a4
    800058ae:	03078793          	addi	a5,a5,48
    800058b2:	97c2                	add	a5,a5,a6
    800058b4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800058b6:	611c                	ld	a5,0(a0)
    800058b8:	97ba                	add	a5,a5,a4
    800058ba:	4685                	li	a3,1
    800058bc:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058be:	611c                	ld	a5,0(a0)
    800058c0:	97ba                	add	a5,a5,a4
    800058c2:	4809                	li	a6,2
    800058c4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800058c8:	611c                	ld	a5,0(a0)
    800058ca:	973e                	add	a4,a4,a5
    800058cc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058d0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800058d4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058d8:	6518                	ld	a4,8(a0)
    800058da:	00275783          	lhu	a5,2(a4)
    800058de:	8b9d                	andi	a5,a5,7
    800058e0:	0786                	slli	a5,a5,0x1
    800058e2:	97ba                	add	a5,a5,a4
    800058e4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800058e8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800058ec:	6518                	ld	a4,8(a0)
    800058ee:	00275783          	lhu	a5,2(a4)
    800058f2:	2785                	addiw	a5,a5,1
    800058f4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800058f8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800058fc:	100017b7          	lui	a5,0x10001
    80005900:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005904:	00492703          	lw	a4,4(s2)
    80005908:	4785                	li	a5,1
    8000590a:	02f71163          	bne	a4,a5,8000592c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000590e:	00022997          	auipc	s3,0x22
    80005912:	81a98993          	addi	s3,s3,-2022 # 80027128 <disk+0x2128>
  while(b->disk == 1) {
    80005916:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005918:	85ce                	mv	a1,s3
    8000591a:	854a                	mv	a0,s2
    8000591c:	ffffc097          	auipc	ra,0xffffc
    80005920:	c30080e7          	jalr	-976(ra) # 8000154c <sleep>
  while(b->disk == 1) {
    80005924:	00492783          	lw	a5,4(s2)
    80005928:	fe9788e3          	beq	a5,s1,80005918 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000592c:	f9042903          	lw	s2,-112(s0)
    80005930:	20090793          	addi	a5,s2,512
    80005934:	00479713          	slli	a4,a5,0x4
    80005938:	0001f797          	auipc	a5,0x1f
    8000593c:	6c878793          	addi	a5,a5,1736 # 80025000 <disk>
    80005940:	97ba                	add	a5,a5,a4
    80005942:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005946:	00021997          	auipc	s3,0x21
    8000594a:	6ba98993          	addi	s3,s3,1722 # 80027000 <disk+0x2000>
    8000594e:	00491713          	slli	a4,s2,0x4
    80005952:	0009b783          	ld	a5,0(s3)
    80005956:	97ba                	add	a5,a5,a4
    80005958:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000595c:	854a                	mv	a0,s2
    8000595e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005962:	00000097          	auipc	ra,0x0
    80005966:	bc4080e7          	jalr	-1084(ra) # 80005526 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000596a:	8885                	andi	s1,s1,1
    8000596c:	f0ed                	bnez	s1,8000594e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000596e:	00021517          	auipc	a0,0x21
    80005972:	7ba50513          	addi	a0,a0,1978 # 80027128 <disk+0x2128>
    80005976:	00001097          	auipc	ra,0x1
    8000597a:	c50080e7          	jalr	-944(ra) # 800065c6 <release>
}
    8000597e:	70a6                	ld	ra,104(sp)
    80005980:	7406                	ld	s0,96(sp)
    80005982:	64e6                	ld	s1,88(sp)
    80005984:	6946                	ld	s2,80(sp)
    80005986:	69a6                	ld	s3,72(sp)
    80005988:	6a06                	ld	s4,64(sp)
    8000598a:	7ae2                	ld	s5,56(sp)
    8000598c:	7b42                	ld	s6,48(sp)
    8000598e:	7ba2                	ld	s7,40(sp)
    80005990:	7c02                	ld	s8,32(sp)
    80005992:	6ce2                	ld	s9,24(sp)
    80005994:	6d42                	ld	s10,16(sp)
    80005996:	6165                	addi	sp,sp,112
    80005998:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000599a:	00021697          	auipc	a3,0x21
    8000599e:	6666b683          	ld	a3,1638(a3) # 80027000 <disk+0x2000>
    800059a2:	96ba                	add	a3,a3,a4
    800059a4:	4609                	li	a2,2
    800059a6:	00c69623          	sh	a2,12(a3)
    800059aa:	b5c9                	j	8000586c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059ac:	f9042583          	lw	a1,-112(s0)
    800059b0:	20058793          	addi	a5,a1,512
    800059b4:	0792                	slli	a5,a5,0x4
    800059b6:	0001f517          	auipc	a0,0x1f
    800059ba:	6f250513          	addi	a0,a0,1778 # 800250a8 <disk+0xa8>
    800059be:	953e                	add	a0,a0,a5
  if(write)
    800059c0:	e20d11e3          	bnez	s10,800057e2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800059c4:	20058713          	addi	a4,a1,512
    800059c8:	00471693          	slli	a3,a4,0x4
    800059cc:	0001f717          	auipc	a4,0x1f
    800059d0:	63470713          	addi	a4,a4,1588 # 80025000 <disk>
    800059d4:	9736                	add	a4,a4,a3
    800059d6:	0a072423          	sw	zero,168(a4)
    800059da:	b505                	j	800057fa <virtio_disk_rw+0xf4>

00000000800059dc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059dc:	1101                	addi	sp,sp,-32
    800059de:	ec06                	sd	ra,24(sp)
    800059e0:	e822                	sd	s0,16(sp)
    800059e2:	e426                	sd	s1,8(sp)
    800059e4:	e04a                	sd	s2,0(sp)
    800059e6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059e8:	00021517          	auipc	a0,0x21
    800059ec:	74050513          	addi	a0,a0,1856 # 80027128 <disk+0x2128>
    800059f0:	00001097          	auipc	ra,0x1
    800059f4:	b22080e7          	jalr	-1246(ra) # 80006512 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059f8:	10001737          	lui	a4,0x10001
    800059fc:	533c                	lw	a5,96(a4)
    800059fe:	8b8d                	andi	a5,a5,3
    80005a00:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005a02:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a06:	00021797          	auipc	a5,0x21
    80005a0a:	5fa78793          	addi	a5,a5,1530 # 80027000 <disk+0x2000>
    80005a0e:	6b94                	ld	a3,16(a5)
    80005a10:	0207d703          	lhu	a4,32(a5)
    80005a14:	0026d783          	lhu	a5,2(a3)
    80005a18:	06f70163          	beq	a4,a5,80005a7a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a1c:	0001f917          	auipc	s2,0x1f
    80005a20:	5e490913          	addi	s2,s2,1508 # 80025000 <disk>
    80005a24:	00021497          	auipc	s1,0x21
    80005a28:	5dc48493          	addi	s1,s1,1500 # 80027000 <disk+0x2000>
    __sync_synchronize();
    80005a2c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a30:	6898                	ld	a4,16(s1)
    80005a32:	0204d783          	lhu	a5,32(s1)
    80005a36:	8b9d                	andi	a5,a5,7
    80005a38:	078e                	slli	a5,a5,0x3
    80005a3a:	97ba                	add	a5,a5,a4
    80005a3c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a3e:	20078713          	addi	a4,a5,512
    80005a42:	0712                	slli	a4,a4,0x4
    80005a44:	974a                	add	a4,a4,s2
    80005a46:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005a4a:	e731                	bnez	a4,80005a96 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a4c:	20078793          	addi	a5,a5,512
    80005a50:	0792                	slli	a5,a5,0x4
    80005a52:	97ca                	add	a5,a5,s2
    80005a54:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005a56:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a5a:	ffffc097          	auipc	ra,0xffffc
    80005a5e:	c7e080e7          	jalr	-898(ra) # 800016d8 <wakeup>

    disk.used_idx += 1;
    80005a62:	0204d783          	lhu	a5,32(s1)
    80005a66:	2785                	addiw	a5,a5,1
    80005a68:	17c2                	slli	a5,a5,0x30
    80005a6a:	93c1                	srli	a5,a5,0x30
    80005a6c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a70:	6898                	ld	a4,16(s1)
    80005a72:	00275703          	lhu	a4,2(a4)
    80005a76:	faf71be3          	bne	a4,a5,80005a2c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    80005a7a:	00021517          	auipc	a0,0x21
    80005a7e:	6ae50513          	addi	a0,a0,1710 # 80027128 <disk+0x2128>
    80005a82:	00001097          	auipc	ra,0x1
    80005a86:	b44080e7          	jalr	-1212(ra) # 800065c6 <release>
}
    80005a8a:	60e2                	ld	ra,24(sp)
    80005a8c:	6442                	ld	s0,16(sp)
    80005a8e:	64a2                	ld	s1,8(sp)
    80005a90:	6902                	ld	s2,0(sp)
    80005a92:	6105                	addi	sp,sp,32
    80005a94:	8082                	ret
      panic("virtio_disk_intr status");
    80005a96:	00003517          	auipc	a0,0x3
    80005a9a:	cca50513          	addi	a0,a0,-822 # 80008760 <syscalls+0x3c0>
    80005a9e:	00000097          	auipc	ra,0x0
    80005aa2:	52a080e7          	jalr	1322(ra) # 80005fc8 <panic>

0000000080005aa6 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005aa6:	1141                	addi	sp,sp,-16
    80005aa8:	e422                	sd	s0,8(sp)
    80005aaa:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005aac:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005ab0:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005ab4:	0037979b          	slliw	a5,a5,0x3
    80005ab8:	02004737          	lui	a4,0x2004
    80005abc:	97ba                	add	a5,a5,a4
    80005abe:	0200c737          	lui	a4,0x200c
    80005ac2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005ac6:	000f4637          	lui	a2,0xf4
    80005aca:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005ace:	95b2                	add	a1,a1,a2
    80005ad0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005ad2:	00269713          	slli	a4,a3,0x2
    80005ad6:	9736                	add	a4,a4,a3
    80005ad8:	00371693          	slli	a3,a4,0x3
    80005adc:	00022717          	auipc	a4,0x22
    80005ae0:	52470713          	addi	a4,a4,1316 # 80028000 <timer_scratch>
    80005ae4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005ae6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005ae8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005aea:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005aee:	00000797          	auipc	a5,0x0
    80005af2:	97278793          	addi	a5,a5,-1678 # 80005460 <timervec>
    80005af6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005afa:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005afe:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b02:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b06:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b0a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b0e:	30479073          	csrw	mie,a5
}
    80005b12:	6422                	ld	s0,8(sp)
    80005b14:	0141                	addi	sp,sp,16
    80005b16:	8082                	ret

0000000080005b18 <start>:
{
    80005b18:	1141                	addi	sp,sp,-16
    80005b1a:	e406                	sd	ra,8(sp)
    80005b1c:	e022                	sd	s0,0(sp)
    80005b1e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b20:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b24:	7779                	lui	a4,0xffffe
    80005b26:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffce5bf>
    80005b2a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b2c:	6705                	lui	a4,0x1
    80005b2e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b32:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b34:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b38:	ffffa797          	auipc	a5,0xffffa
    80005b3c:	7ee78793          	addi	a5,a5,2030 # 80000326 <main>
    80005b40:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b44:	4781                	li	a5,0
    80005b46:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b4a:	67c1                	lui	a5,0x10
    80005b4c:	17fd                	addi	a5,a5,-1
    80005b4e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b52:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b56:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b5a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b5e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b62:	57fd                	li	a5,-1
    80005b64:	83a9                	srli	a5,a5,0xa
    80005b66:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b6a:	47bd                	li	a5,15
    80005b6c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b70:	00000097          	auipc	ra,0x0
    80005b74:	f36080e7          	jalr	-202(ra) # 80005aa6 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b78:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b7c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b7e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b80:	30200073          	mret
}
    80005b84:	60a2                	ld	ra,8(sp)
    80005b86:	6402                	ld	s0,0(sp)
    80005b88:	0141                	addi	sp,sp,16
    80005b8a:	8082                	ret

0000000080005b8c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005b8c:	715d                	addi	sp,sp,-80
    80005b8e:	e486                	sd	ra,72(sp)
    80005b90:	e0a2                	sd	s0,64(sp)
    80005b92:	fc26                	sd	s1,56(sp)
    80005b94:	f84a                	sd	s2,48(sp)
    80005b96:	f44e                	sd	s3,40(sp)
    80005b98:	f052                	sd	s4,32(sp)
    80005b9a:	ec56                	sd	s5,24(sp)
    80005b9c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005b9e:	04c05663          	blez	a2,80005bea <consolewrite+0x5e>
    80005ba2:	8a2a                	mv	s4,a0
    80005ba4:	84ae                	mv	s1,a1
    80005ba6:	89b2                	mv	s3,a2
    80005ba8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005baa:	5afd                	li	s5,-1
    80005bac:	4685                	li	a3,1
    80005bae:	8626                	mv	a2,s1
    80005bb0:	85d2                	mv	a1,s4
    80005bb2:	fbf40513          	addi	a0,s0,-65
    80005bb6:	ffffc097          	auipc	ra,0xffffc
    80005bba:	dca080e7          	jalr	-566(ra) # 80001980 <either_copyin>
    80005bbe:	01550c63          	beq	a0,s5,80005bd6 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005bc2:	fbf44503          	lbu	a0,-65(s0)
    80005bc6:	00000097          	auipc	ra,0x0
    80005bca:	78e080e7          	jalr	1934(ra) # 80006354 <uartputc>
  for(i = 0; i < n; i++){
    80005bce:	2905                	addiw	s2,s2,1
    80005bd0:	0485                	addi	s1,s1,1
    80005bd2:	fd299de3          	bne	s3,s2,80005bac <consolewrite+0x20>
  }

  return i;
}
    80005bd6:	854a                	mv	a0,s2
    80005bd8:	60a6                	ld	ra,72(sp)
    80005bda:	6406                	ld	s0,64(sp)
    80005bdc:	74e2                	ld	s1,56(sp)
    80005bde:	7942                	ld	s2,48(sp)
    80005be0:	79a2                	ld	s3,40(sp)
    80005be2:	7a02                	ld	s4,32(sp)
    80005be4:	6ae2                	ld	s5,24(sp)
    80005be6:	6161                	addi	sp,sp,80
    80005be8:	8082                	ret
  for(i = 0; i < n; i++){
    80005bea:	4901                	li	s2,0
    80005bec:	b7ed                	j	80005bd6 <consolewrite+0x4a>

0000000080005bee <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005bee:	7119                	addi	sp,sp,-128
    80005bf0:	fc86                	sd	ra,120(sp)
    80005bf2:	f8a2                	sd	s0,112(sp)
    80005bf4:	f4a6                	sd	s1,104(sp)
    80005bf6:	f0ca                	sd	s2,96(sp)
    80005bf8:	ecce                	sd	s3,88(sp)
    80005bfa:	e8d2                	sd	s4,80(sp)
    80005bfc:	e4d6                	sd	s5,72(sp)
    80005bfe:	e0da                	sd	s6,64(sp)
    80005c00:	fc5e                	sd	s7,56(sp)
    80005c02:	f862                	sd	s8,48(sp)
    80005c04:	f466                	sd	s9,40(sp)
    80005c06:	f06a                	sd	s10,32(sp)
    80005c08:	ec6e                	sd	s11,24(sp)
    80005c0a:	0100                	addi	s0,sp,128
    80005c0c:	8b2a                	mv	s6,a0
    80005c0e:	8aae                	mv	s5,a1
    80005c10:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c12:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005c16:	0002a517          	auipc	a0,0x2a
    80005c1a:	52a50513          	addi	a0,a0,1322 # 80030140 <cons>
    80005c1e:	00001097          	auipc	ra,0x1
    80005c22:	8f4080e7          	jalr	-1804(ra) # 80006512 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c26:	0002a497          	auipc	s1,0x2a
    80005c2a:	51a48493          	addi	s1,s1,1306 # 80030140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c2e:	89a6                	mv	s3,s1
    80005c30:	0002a917          	auipc	s2,0x2a
    80005c34:	5a890913          	addi	s2,s2,1448 # 800301d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005c38:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c3a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005c3c:	4da9                	li	s11,10
  while(n > 0){
    80005c3e:	07405863          	blez	s4,80005cae <consoleread+0xc0>
    while(cons.r == cons.w){
    80005c42:	0984a783          	lw	a5,152(s1)
    80005c46:	09c4a703          	lw	a4,156(s1)
    80005c4a:	02f71463          	bne	a4,a5,80005c72 <consoleread+0x84>
      if(myproc()->killed){
    80005c4e:	ffffb097          	auipc	ra,0xffffb
    80005c52:	1e0080e7          	jalr	480(ra) # 80000e2e <myproc>
    80005c56:	551c                	lw	a5,40(a0)
    80005c58:	e7b5                	bnez	a5,80005cc4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005c5a:	85ce                	mv	a1,s3
    80005c5c:	854a                	mv	a0,s2
    80005c5e:	ffffc097          	auipc	ra,0xffffc
    80005c62:	8ee080e7          	jalr	-1810(ra) # 8000154c <sleep>
    while(cons.r == cons.w){
    80005c66:	0984a783          	lw	a5,152(s1)
    80005c6a:	09c4a703          	lw	a4,156(s1)
    80005c6e:	fef700e3          	beq	a4,a5,80005c4e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005c72:	0017871b          	addiw	a4,a5,1
    80005c76:	08e4ac23          	sw	a4,152(s1)
    80005c7a:	07f7f713          	andi	a4,a5,127
    80005c7e:	9726                	add	a4,a4,s1
    80005c80:	01874703          	lbu	a4,24(a4)
    80005c84:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005c88:	079c0663          	beq	s8,s9,80005cf4 <consoleread+0x106>
    cbuf = c;
    80005c8c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c90:	4685                	li	a3,1
    80005c92:	f8f40613          	addi	a2,s0,-113
    80005c96:	85d6                	mv	a1,s5
    80005c98:	855a                	mv	a0,s6
    80005c9a:	ffffc097          	auipc	ra,0xffffc
    80005c9e:	c90080e7          	jalr	-880(ra) # 8000192a <either_copyout>
    80005ca2:	01a50663          	beq	a0,s10,80005cae <consoleread+0xc0>
    dst++;
    80005ca6:	0a85                	addi	s5,s5,1
    --n;
    80005ca8:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005caa:	f9bc1ae3          	bne	s8,s11,80005c3e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005cae:	0002a517          	auipc	a0,0x2a
    80005cb2:	49250513          	addi	a0,a0,1170 # 80030140 <cons>
    80005cb6:	00001097          	auipc	ra,0x1
    80005cba:	910080e7          	jalr	-1776(ra) # 800065c6 <release>

  return target - n;
    80005cbe:	414b853b          	subw	a0,s7,s4
    80005cc2:	a811                	j	80005cd6 <consoleread+0xe8>
        release(&cons.lock);
    80005cc4:	0002a517          	auipc	a0,0x2a
    80005cc8:	47c50513          	addi	a0,a0,1148 # 80030140 <cons>
    80005ccc:	00001097          	auipc	ra,0x1
    80005cd0:	8fa080e7          	jalr	-1798(ra) # 800065c6 <release>
        return -1;
    80005cd4:	557d                	li	a0,-1
}
    80005cd6:	70e6                	ld	ra,120(sp)
    80005cd8:	7446                	ld	s0,112(sp)
    80005cda:	74a6                	ld	s1,104(sp)
    80005cdc:	7906                	ld	s2,96(sp)
    80005cde:	69e6                	ld	s3,88(sp)
    80005ce0:	6a46                	ld	s4,80(sp)
    80005ce2:	6aa6                	ld	s5,72(sp)
    80005ce4:	6b06                	ld	s6,64(sp)
    80005ce6:	7be2                	ld	s7,56(sp)
    80005ce8:	7c42                	ld	s8,48(sp)
    80005cea:	7ca2                	ld	s9,40(sp)
    80005cec:	7d02                	ld	s10,32(sp)
    80005cee:	6de2                	ld	s11,24(sp)
    80005cf0:	6109                	addi	sp,sp,128
    80005cf2:	8082                	ret
      if(n < target){
    80005cf4:	000a071b          	sext.w	a4,s4
    80005cf8:	fb777be3          	bgeu	a4,s7,80005cae <consoleread+0xc0>
        cons.r--;
    80005cfc:	0002a717          	auipc	a4,0x2a
    80005d00:	4cf72e23          	sw	a5,1244(a4) # 800301d8 <cons+0x98>
    80005d04:	b76d                	j	80005cae <consoleread+0xc0>

0000000080005d06 <consputc>:
{
    80005d06:	1141                	addi	sp,sp,-16
    80005d08:	e406                	sd	ra,8(sp)
    80005d0a:	e022                	sd	s0,0(sp)
    80005d0c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005d0e:	10000793          	li	a5,256
    80005d12:	00f50a63          	beq	a0,a5,80005d26 <consputc+0x20>
    uartputc_sync(c);
    80005d16:	00000097          	auipc	ra,0x0
    80005d1a:	564080e7          	jalr	1380(ra) # 8000627a <uartputc_sync>
}
    80005d1e:	60a2                	ld	ra,8(sp)
    80005d20:	6402                	ld	s0,0(sp)
    80005d22:	0141                	addi	sp,sp,16
    80005d24:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d26:	4521                	li	a0,8
    80005d28:	00000097          	auipc	ra,0x0
    80005d2c:	552080e7          	jalr	1362(ra) # 8000627a <uartputc_sync>
    80005d30:	02000513          	li	a0,32
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	546080e7          	jalr	1350(ra) # 8000627a <uartputc_sync>
    80005d3c:	4521                	li	a0,8
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	53c080e7          	jalr	1340(ra) # 8000627a <uartputc_sync>
    80005d46:	bfe1                	j	80005d1e <consputc+0x18>

0000000080005d48 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d48:	1101                	addi	sp,sp,-32
    80005d4a:	ec06                	sd	ra,24(sp)
    80005d4c:	e822                	sd	s0,16(sp)
    80005d4e:	e426                	sd	s1,8(sp)
    80005d50:	e04a                	sd	s2,0(sp)
    80005d52:	1000                	addi	s0,sp,32
    80005d54:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d56:	0002a517          	auipc	a0,0x2a
    80005d5a:	3ea50513          	addi	a0,a0,1002 # 80030140 <cons>
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	7b4080e7          	jalr	1972(ra) # 80006512 <acquire>

  switch(c){
    80005d66:	47d5                	li	a5,21
    80005d68:	0af48663          	beq	s1,a5,80005e14 <consoleintr+0xcc>
    80005d6c:	0297ca63          	blt	a5,s1,80005da0 <consoleintr+0x58>
    80005d70:	47a1                	li	a5,8
    80005d72:	0ef48763          	beq	s1,a5,80005e60 <consoleintr+0x118>
    80005d76:	47c1                	li	a5,16
    80005d78:	10f49a63          	bne	s1,a5,80005e8c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005d7c:	ffffc097          	auipc	ra,0xffffc
    80005d80:	c5a080e7          	jalr	-934(ra) # 800019d6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d84:	0002a517          	auipc	a0,0x2a
    80005d88:	3bc50513          	addi	a0,a0,956 # 80030140 <cons>
    80005d8c:	00001097          	auipc	ra,0x1
    80005d90:	83a080e7          	jalr	-1990(ra) # 800065c6 <release>
}
    80005d94:	60e2                	ld	ra,24(sp)
    80005d96:	6442                	ld	s0,16(sp)
    80005d98:	64a2                	ld	s1,8(sp)
    80005d9a:	6902                	ld	s2,0(sp)
    80005d9c:	6105                	addi	sp,sp,32
    80005d9e:	8082                	ret
  switch(c){
    80005da0:	07f00793          	li	a5,127
    80005da4:	0af48e63          	beq	s1,a5,80005e60 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005da8:	0002a717          	auipc	a4,0x2a
    80005dac:	39870713          	addi	a4,a4,920 # 80030140 <cons>
    80005db0:	0a072783          	lw	a5,160(a4)
    80005db4:	09872703          	lw	a4,152(a4)
    80005db8:	9f99                	subw	a5,a5,a4
    80005dba:	07f00713          	li	a4,127
    80005dbe:	fcf763e3          	bltu	a4,a5,80005d84 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005dc2:	47b5                	li	a5,13
    80005dc4:	0cf48763          	beq	s1,a5,80005e92 <consoleintr+0x14a>
      consputc(c);
    80005dc8:	8526                	mv	a0,s1
    80005dca:	00000097          	auipc	ra,0x0
    80005dce:	f3c080e7          	jalr	-196(ra) # 80005d06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005dd2:	0002a797          	auipc	a5,0x2a
    80005dd6:	36e78793          	addi	a5,a5,878 # 80030140 <cons>
    80005dda:	0a07a703          	lw	a4,160(a5)
    80005dde:	0017069b          	addiw	a3,a4,1
    80005de2:	0006861b          	sext.w	a2,a3
    80005de6:	0ad7a023          	sw	a3,160(a5)
    80005dea:	07f77713          	andi	a4,a4,127
    80005dee:	97ba                	add	a5,a5,a4
    80005df0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005df4:	47a9                	li	a5,10
    80005df6:	0cf48563          	beq	s1,a5,80005ec0 <consoleintr+0x178>
    80005dfa:	4791                	li	a5,4
    80005dfc:	0cf48263          	beq	s1,a5,80005ec0 <consoleintr+0x178>
    80005e00:	0002a797          	auipc	a5,0x2a
    80005e04:	3d87a783          	lw	a5,984(a5) # 800301d8 <cons+0x98>
    80005e08:	0807879b          	addiw	a5,a5,128
    80005e0c:	f6f61ce3          	bne	a2,a5,80005d84 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e10:	863e                	mv	a2,a5
    80005e12:	a07d                	j	80005ec0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005e14:	0002a717          	auipc	a4,0x2a
    80005e18:	32c70713          	addi	a4,a4,812 # 80030140 <cons>
    80005e1c:	0a072783          	lw	a5,160(a4)
    80005e20:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e24:	0002a497          	auipc	s1,0x2a
    80005e28:	31c48493          	addi	s1,s1,796 # 80030140 <cons>
    while(cons.e != cons.w &&
    80005e2c:	4929                	li	s2,10
    80005e2e:	f4f70be3          	beq	a4,a5,80005d84 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005e32:	37fd                	addiw	a5,a5,-1
    80005e34:	07f7f713          	andi	a4,a5,127
    80005e38:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e3a:	01874703          	lbu	a4,24(a4)
    80005e3e:	f52703e3          	beq	a4,s2,80005d84 <consoleintr+0x3c>
      cons.e--;
    80005e42:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e46:	10000513          	li	a0,256
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	ebc080e7          	jalr	-324(ra) # 80005d06 <consputc>
    while(cons.e != cons.w &&
    80005e52:	0a04a783          	lw	a5,160(s1)
    80005e56:	09c4a703          	lw	a4,156(s1)
    80005e5a:	fcf71ce3          	bne	a4,a5,80005e32 <consoleintr+0xea>
    80005e5e:	b71d                	j	80005d84 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005e60:	0002a717          	auipc	a4,0x2a
    80005e64:	2e070713          	addi	a4,a4,736 # 80030140 <cons>
    80005e68:	0a072783          	lw	a5,160(a4)
    80005e6c:	09c72703          	lw	a4,156(a4)
    80005e70:	f0f70ae3          	beq	a4,a5,80005d84 <consoleintr+0x3c>
      cons.e--;
    80005e74:	37fd                	addiw	a5,a5,-1
    80005e76:	0002a717          	auipc	a4,0x2a
    80005e7a:	36f72523          	sw	a5,874(a4) # 800301e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005e7e:	10000513          	li	a0,256
    80005e82:	00000097          	auipc	ra,0x0
    80005e86:	e84080e7          	jalr	-380(ra) # 80005d06 <consputc>
    80005e8a:	bded                	j	80005d84 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005e8c:	ee048ce3          	beqz	s1,80005d84 <consoleintr+0x3c>
    80005e90:	bf21                	j	80005da8 <consoleintr+0x60>
      consputc(c);
    80005e92:	4529                	li	a0,10
    80005e94:	00000097          	auipc	ra,0x0
    80005e98:	e72080e7          	jalr	-398(ra) # 80005d06 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005e9c:	0002a797          	auipc	a5,0x2a
    80005ea0:	2a478793          	addi	a5,a5,676 # 80030140 <cons>
    80005ea4:	0a07a703          	lw	a4,160(a5)
    80005ea8:	0017069b          	addiw	a3,a4,1
    80005eac:	0006861b          	sext.w	a2,a3
    80005eb0:	0ad7a023          	sw	a3,160(a5)
    80005eb4:	07f77713          	andi	a4,a4,127
    80005eb8:	97ba                	add	a5,a5,a4
    80005eba:	4729                	li	a4,10
    80005ebc:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ec0:	0002a797          	auipc	a5,0x2a
    80005ec4:	30c7ae23          	sw	a2,796(a5) # 800301dc <cons+0x9c>
        wakeup(&cons.r);
    80005ec8:	0002a517          	auipc	a0,0x2a
    80005ecc:	31050513          	addi	a0,a0,784 # 800301d8 <cons+0x98>
    80005ed0:	ffffc097          	auipc	ra,0xffffc
    80005ed4:	808080e7          	jalr	-2040(ra) # 800016d8 <wakeup>
    80005ed8:	b575                	j	80005d84 <consoleintr+0x3c>

0000000080005eda <consoleinit>:

void
consoleinit(void)
{
    80005eda:	1141                	addi	sp,sp,-16
    80005edc:	e406                	sd	ra,8(sp)
    80005ede:	e022                	sd	s0,0(sp)
    80005ee0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ee2:	00003597          	auipc	a1,0x3
    80005ee6:	89658593          	addi	a1,a1,-1898 # 80008778 <syscalls+0x3d8>
    80005eea:	0002a517          	auipc	a0,0x2a
    80005eee:	25650513          	addi	a0,a0,598 # 80030140 <cons>
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	590080e7          	jalr	1424(ra) # 80006482 <initlock>

  uartinit();
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	330080e7          	jalr	816(ra) # 8000622a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f02:	0001d797          	auipc	a5,0x1d
    80005f06:	1c678793          	addi	a5,a5,454 # 800230c8 <devsw>
    80005f0a:	00000717          	auipc	a4,0x0
    80005f0e:	ce470713          	addi	a4,a4,-796 # 80005bee <consoleread>
    80005f12:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f14:	00000717          	auipc	a4,0x0
    80005f18:	c7870713          	addi	a4,a4,-904 # 80005b8c <consolewrite>
    80005f1c:	ef98                	sd	a4,24(a5)
}
    80005f1e:	60a2                	ld	ra,8(sp)
    80005f20:	6402                	ld	s0,0(sp)
    80005f22:	0141                	addi	sp,sp,16
    80005f24:	8082                	ret

0000000080005f26 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f26:	7179                	addi	sp,sp,-48
    80005f28:	f406                	sd	ra,40(sp)
    80005f2a:	f022                	sd	s0,32(sp)
    80005f2c:	ec26                	sd	s1,24(sp)
    80005f2e:	e84a                	sd	s2,16(sp)
    80005f30:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f32:	c219                	beqz	a2,80005f38 <printint+0x12>
    80005f34:	08054663          	bltz	a0,80005fc0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005f38:	2501                	sext.w	a0,a0
    80005f3a:	4881                	li	a7,0
    80005f3c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f40:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f42:	2581                	sext.w	a1,a1
    80005f44:	00003617          	auipc	a2,0x3
    80005f48:	86460613          	addi	a2,a2,-1948 # 800087a8 <digits>
    80005f4c:	883a                	mv	a6,a4
    80005f4e:	2705                	addiw	a4,a4,1
    80005f50:	02b577bb          	remuw	a5,a0,a1
    80005f54:	1782                	slli	a5,a5,0x20
    80005f56:	9381                	srli	a5,a5,0x20
    80005f58:	97b2                	add	a5,a5,a2
    80005f5a:	0007c783          	lbu	a5,0(a5)
    80005f5e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f62:	0005079b          	sext.w	a5,a0
    80005f66:	02b5553b          	divuw	a0,a0,a1
    80005f6a:	0685                	addi	a3,a3,1
    80005f6c:	feb7f0e3          	bgeu	a5,a1,80005f4c <printint+0x26>

  if(sign)
    80005f70:	00088b63          	beqz	a7,80005f86 <printint+0x60>
    buf[i++] = '-';
    80005f74:	fe040793          	addi	a5,s0,-32
    80005f78:	973e                	add	a4,a4,a5
    80005f7a:	02d00793          	li	a5,45
    80005f7e:	fef70823          	sb	a5,-16(a4)
    80005f82:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005f86:	02e05763          	blez	a4,80005fb4 <printint+0x8e>
    80005f8a:	fd040793          	addi	a5,s0,-48
    80005f8e:	00e784b3          	add	s1,a5,a4
    80005f92:	fff78913          	addi	s2,a5,-1
    80005f96:	993a                	add	s2,s2,a4
    80005f98:	377d                	addiw	a4,a4,-1
    80005f9a:	1702                	slli	a4,a4,0x20
    80005f9c:	9301                	srli	a4,a4,0x20
    80005f9e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005fa2:	fff4c503          	lbu	a0,-1(s1)
    80005fa6:	00000097          	auipc	ra,0x0
    80005faa:	d60080e7          	jalr	-672(ra) # 80005d06 <consputc>
  while(--i >= 0)
    80005fae:	14fd                	addi	s1,s1,-1
    80005fb0:	ff2499e3          	bne	s1,s2,80005fa2 <printint+0x7c>
}
    80005fb4:	70a2                	ld	ra,40(sp)
    80005fb6:	7402                	ld	s0,32(sp)
    80005fb8:	64e2                	ld	s1,24(sp)
    80005fba:	6942                	ld	s2,16(sp)
    80005fbc:	6145                	addi	sp,sp,48
    80005fbe:	8082                	ret
    x = -xx;
    80005fc0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005fc4:	4885                	li	a7,1
    x = -xx;
    80005fc6:	bf9d                	j	80005f3c <printint+0x16>

0000000080005fc8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005fc8:	1101                	addi	sp,sp,-32
    80005fca:	ec06                	sd	ra,24(sp)
    80005fcc:	e822                	sd	s0,16(sp)
    80005fce:	e426                	sd	s1,8(sp)
    80005fd0:	1000                	addi	s0,sp,32
    80005fd2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005fd4:	0002a797          	auipc	a5,0x2a
    80005fd8:	2207a623          	sw	zero,556(a5) # 80030200 <pr+0x18>
  printf("panic: ");
    80005fdc:	00002517          	auipc	a0,0x2
    80005fe0:	7a450513          	addi	a0,a0,1956 # 80008780 <syscalls+0x3e0>
    80005fe4:	00000097          	auipc	ra,0x0
    80005fe8:	02e080e7          	jalr	46(ra) # 80006012 <printf>
  printf(s);
    80005fec:	8526                	mv	a0,s1
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	024080e7          	jalr	36(ra) # 80006012 <printf>
  printf("\n");
    80005ff6:	00002517          	auipc	a0,0x2
    80005ffa:	05250513          	addi	a0,a0,82 # 80008048 <etext+0x48>
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	014080e7          	jalr	20(ra) # 80006012 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006006:	4785                	li	a5,1
    80006008:	00003717          	auipc	a4,0x3
    8000600c:	00f72a23          	sw	a5,20(a4) # 8000901c <panicked>
  for(;;)
    80006010:	a001                	j	80006010 <panic+0x48>

0000000080006012 <printf>:
{
    80006012:	7131                	addi	sp,sp,-192
    80006014:	fc86                	sd	ra,120(sp)
    80006016:	f8a2                	sd	s0,112(sp)
    80006018:	f4a6                	sd	s1,104(sp)
    8000601a:	f0ca                	sd	s2,96(sp)
    8000601c:	ecce                	sd	s3,88(sp)
    8000601e:	e8d2                	sd	s4,80(sp)
    80006020:	e4d6                	sd	s5,72(sp)
    80006022:	e0da                	sd	s6,64(sp)
    80006024:	fc5e                	sd	s7,56(sp)
    80006026:	f862                	sd	s8,48(sp)
    80006028:	f466                	sd	s9,40(sp)
    8000602a:	f06a                	sd	s10,32(sp)
    8000602c:	ec6e                	sd	s11,24(sp)
    8000602e:	0100                	addi	s0,sp,128
    80006030:	8a2a                	mv	s4,a0
    80006032:	e40c                	sd	a1,8(s0)
    80006034:	e810                	sd	a2,16(s0)
    80006036:	ec14                	sd	a3,24(s0)
    80006038:	f018                	sd	a4,32(s0)
    8000603a:	f41c                	sd	a5,40(s0)
    8000603c:	03043823          	sd	a6,48(s0)
    80006040:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006044:	0002ad97          	auipc	s11,0x2a
    80006048:	1bcdad83          	lw	s11,444(s11) # 80030200 <pr+0x18>
  if(locking)
    8000604c:	020d9b63          	bnez	s11,80006082 <printf+0x70>
  if (fmt == 0)
    80006050:	040a0263          	beqz	s4,80006094 <printf+0x82>
  va_start(ap, fmt);
    80006054:	00840793          	addi	a5,s0,8
    80006058:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000605c:	000a4503          	lbu	a0,0(s4)
    80006060:	16050263          	beqz	a0,800061c4 <printf+0x1b2>
    80006064:	4481                	li	s1,0
    if(c != '%'){
    80006066:	02500a93          	li	s5,37
    switch(c){
    8000606a:	07000b13          	li	s6,112
  consputc('x');
    8000606e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006070:	00002b97          	auipc	s7,0x2
    80006074:	738b8b93          	addi	s7,s7,1848 # 800087a8 <digits>
    switch(c){
    80006078:	07300c93          	li	s9,115
    8000607c:	06400c13          	li	s8,100
    80006080:	a82d                	j	800060ba <printf+0xa8>
    acquire(&pr.lock);
    80006082:	0002a517          	auipc	a0,0x2a
    80006086:	16650513          	addi	a0,a0,358 # 800301e8 <pr>
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	488080e7          	jalr	1160(ra) # 80006512 <acquire>
    80006092:	bf7d                	j	80006050 <printf+0x3e>
    panic("null fmt");
    80006094:	00002517          	auipc	a0,0x2
    80006098:	6fc50513          	addi	a0,a0,1788 # 80008790 <syscalls+0x3f0>
    8000609c:	00000097          	auipc	ra,0x0
    800060a0:	f2c080e7          	jalr	-212(ra) # 80005fc8 <panic>
      consputc(c);
    800060a4:	00000097          	auipc	ra,0x0
    800060a8:	c62080e7          	jalr	-926(ra) # 80005d06 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060ac:	2485                	addiw	s1,s1,1
    800060ae:	009a07b3          	add	a5,s4,s1
    800060b2:	0007c503          	lbu	a0,0(a5)
    800060b6:	10050763          	beqz	a0,800061c4 <printf+0x1b2>
    if(c != '%'){
    800060ba:	ff5515e3          	bne	a0,s5,800060a4 <printf+0x92>
    c = fmt[++i] & 0xff;
    800060be:	2485                	addiw	s1,s1,1
    800060c0:	009a07b3          	add	a5,s4,s1
    800060c4:	0007c783          	lbu	a5,0(a5)
    800060c8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    800060cc:	cfe5                	beqz	a5,800061c4 <printf+0x1b2>
    switch(c){
    800060ce:	05678a63          	beq	a5,s6,80006122 <printf+0x110>
    800060d2:	02fb7663          	bgeu	s6,a5,800060fe <printf+0xec>
    800060d6:	09978963          	beq	a5,s9,80006168 <printf+0x156>
    800060da:	07800713          	li	a4,120
    800060de:	0ce79863          	bne	a5,a4,800061ae <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800060e2:	f8843783          	ld	a5,-120(s0)
    800060e6:	00878713          	addi	a4,a5,8
    800060ea:	f8e43423          	sd	a4,-120(s0)
    800060ee:	4605                	li	a2,1
    800060f0:	85ea                	mv	a1,s10
    800060f2:	4388                	lw	a0,0(a5)
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	e32080e7          	jalr	-462(ra) # 80005f26 <printint>
      break;
    800060fc:	bf45                	j	800060ac <printf+0x9a>
    switch(c){
    800060fe:	0b578263          	beq	a5,s5,800061a2 <printf+0x190>
    80006102:	0b879663          	bne	a5,s8,800061ae <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006106:	f8843783          	ld	a5,-120(s0)
    8000610a:	00878713          	addi	a4,a5,8
    8000610e:	f8e43423          	sd	a4,-120(s0)
    80006112:	4605                	li	a2,1
    80006114:	45a9                	li	a1,10
    80006116:	4388                	lw	a0,0(a5)
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	e0e080e7          	jalr	-498(ra) # 80005f26 <printint>
      break;
    80006120:	b771                	j	800060ac <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006122:	f8843783          	ld	a5,-120(s0)
    80006126:	00878713          	addi	a4,a5,8
    8000612a:	f8e43423          	sd	a4,-120(s0)
    8000612e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006132:	03000513          	li	a0,48
    80006136:	00000097          	auipc	ra,0x0
    8000613a:	bd0080e7          	jalr	-1072(ra) # 80005d06 <consputc>
  consputc('x');
    8000613e:	07800513          	li	a0,120
    80006142:	00000097          	auipc	ra,0x0
    80006146:	bc4080e7          	jalr	-1084(ra) # 80005d06 <consputc>
    8000614a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000614c:	03c9d793          	srli	a5,s3,0x3c
    80006150:	97de                	add	a5,a5,s7
    80006152:	0007c503          	lbu	a0,0(a5)
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	bb0080e7          	jalr	-1104(ra) # 80005d06 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000615e:	0992                	slli	s3,s3,0x4
    80006160:	397d                	addiw	s2,s2,-1
    80006162:	fe0915e3          	bnez	s2,8000614c <printf+0x13a>
    80006166:	b799                	j	800060ac <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006168:	f8843783          	ld	a5,-120(s0)
    8000616c:	00878713          	addi	a4,a5,8
    80006170:	f8e43423          	sd	a4,-120(s0)
    80006174:	0007b903          	ld	s2,0(a5)
    80006178:	00090e63          	beqz	s2,80006194 <printf+0x182>
      for(; *s; s++)
    8000617c:	00094503          	lbu	a0,0(s2)
    80006180:	d515                	beqz	a0,800060ac <printf+0x9a>
        consputc(*s);
    80006182:	00000097          	auipc	ra,0x0
    80006186:	b84080e7          	jalr	-1148(ra) # 80005d06 <consputc>
      for(; *s; s++)
    8000618a:	0905                	addi	s2,s2,1
    8000618c:	00094503          	lbu	a0,0(s2)
    80006190:	f96d                	bnez	a0,80006182 <printf+0x170>
    80006192:	bf29                	j	800060ac <printf+0x9a>
        s = "(null)";
    80006194:	00002917          	auipc	s2,0x2
    80006198:	5f490913          	addi	s2,s2,1524 # 80008788 <syscalls+0x3e8>
      for(; *s; s++)
    8000619c:	02800513          	li	a0,40
    800061a0:	b7cd                	j	80006182 <printf+0x170>
      consputc('%');
    800061a2:	8556                	mv	a0,s5
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	b62080e7          	jalr	-1182(ra) # 80005d06 <consputc>
      break;
    800061ac:	b701                	j	800060ac <printf+0x9a>
      consputc('%');
    800061ae:	8556                	mv	a0,s5
    800061b0:	00000097          	auipc	ra,0x0
    800061b4:	b56080e7          	jalr	-1194(ra) # 80005d06 <consputc>
      consputc(c);
    800061b8:	854a                	mv	a0,s2
    800061ba:	00000097          	auipc	ra,0x0
    800061be:	b4c080e7          	jalr	-1204(ra) # 80005d06 <consputc>
      break;
    800061c2:	b5ed                	j	800060ac <printf+0x9a>
  if(locking)
    800061c4:	020d9163          	bnez	s11,800061e6 <printf+0x1d4>
}
    800061c8:	70e6                	ld	ra,120(sp)
    800061ca:	7446                	ld	s0,112(sp)
    800061cc:	74a6                	ld	s1,104(sp)
    800061ce:	7906                	ld	s2,96(sp)
    800061d0:	69e6                	ld	s3,88(sp)
    800061d2:	6a46                	ld	s4,80(sp)
    800061d4:	6aa6                	ld	s5,72(sp)
    800061d6:	6b06                	ld	s6,64(sp)
    800061d8:	7be2                	ld	s7,56(sp)
    800061da:	7c42                	ld	s8,48(sp)
    800061dc:	7ca2                	ld	s9,40(sp)
    800061de:	7d02                	ld	s10,32(sp)
    800061e0:	6de2                	ld	s11,24(sp)
    800061e2:	6129                	addi	sp,sp,192
    800061e4:	8082                	ret
    release(&pr.lock);
    800061e6:	0002a517          	auipc	a0,0x2a
    800061ea:	00250513          	addi	a0,a0,2 # 800301e8 <pr>
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	3d8080e7          	jalr	984(ra) # 800065c6 <release>
}
    800061f6:	bfc9                	j	800061c8 <printf+0x1b6>

00000000800061f8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800061f8:	1101                	addi	sp,sp,-32
    800061fa:	ec06                	sd	ra,24(sp)
    800061fc:	e822                	sd	s0,16(sp)
    800061fe:	e426                	sd	s1,8(sp)
    80006200:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006202:	0002a497          	auipc	s1,0x2a
    80006206:	fe648493          	addi	s1,s1,-26 # 800301e8 <pr>
    8000620a:	00002597          	auipc	a1,0x2
    8000620e:	59658593          	addi	a1,a1,1430 # 800087a0 <syscalls+0x400>
    80006212:	8526                	mv	a0,s1
    80006214:	00000097          	auipc	ra,0x0
    80006218:	26e080e7          	jalr	622(ra) # 80006482 <initlock>
  pr.locking = 1;
    8000621c:	4785                	li	a5,1
    8000621e:	cc9c                	sw	a5,24(s1)
}
    80006220:	60e2                	ld	ra,24(sp)
    80006222:	6442                	ld	s0,16(sp)
    80006224:	64a2                	ld	s1,8(sp)
    80006226:	6105                	addi	sp,sp,32
    80006228:	8082                	ret

000000008000622a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000622a:	1141                	addi	sp,sp,-16
    8000622c:	e406                	sd	ra,8(sp)
    8000622e:	e022                	sd	s0,0(sp)
    80006230:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006232:	100007b7          	lui	a5,0x10000
    80006236:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000623a:	f8000713          	li	a4,-128
    8000623e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006242:	470d                	li	a4,3
    80006244:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006248:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000624c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006250:	469d                	li	a3,7
    80006252:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006256:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000625a:	00002597          	auipc	a1,0x2
    8000625e:	56658593          	addi	a1,a1,1382 # 800087c0 <digits+0x18>
    80006262:	0002a517          	auipc	a0,0x2a
    80006266:	fa650513          	addi	a0,a0,-90 # 80030208 <uart_tx_lock>
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	218080e7          	jalr	536(ra) # 80006482 <initlock>
}
    80006272:	60a2                	ld	ra,8(sp)
    80006274:	6402                	ld	s0,0(sp)
    80006276:	0141                	addi	sp,sp,16
    80006278:	8082                	ret

000000008000627a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000627a:	1101                	addi	sp,sp,-32
    8000627c:	ec06                	sd	ra,24(sp)
    8000627e:	e822                	sd	s0,16(sp)
    80006280:	e426                	sd	s1,8(sp)
    80006282:	1000                	addi	s0,sp,32
    80006284:	84aa                	mv	s1,a0
  push_off();
    80006286:	00000097          	auipc	ra,0x0
    8000628a:	240080e7          	jalr	576(ra) # 800064c6 <push_off>

  if(panicked){
    8000628e:	00003797          	auipc	a5,0x3
    80006292:	d8e7a783          	lw	a5,-626(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006296:	10000737          	lui	a4,0x10000
  if(panicked){
    8000629a:	c391                	beqz	a5,8000629e <uartputc_sync+0x24>
    for(;;)
    8000629c:	a001                	j	8000629c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000629e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800062a2:	0ff7f793          	andi	a5,a5,255
    800062a6:	0207f793          	andi	a5,a5,32
    800062aa:	dbf5                	beqz	a5,8000629e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800062ac:	0ff4f793          	andi	a5,s1,255
    800062b0:	10000737          	lui	a4,0x10000
    800062b4:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800062b8:	00000097          	auipc	ra,0x0
    800062bc:	2ae080e7          	jalr	686(ra) # 80006566 <pop_off>
}
    800062c0:	60e2                	ld	ra,24(sp)
    800062c2:	6442                	ld	s0,16(sp)
    800062c4:	64a2                	ld	s1,8(sp)
    800062c6:	6105                	addi	sp,sp,32
    800062c8:	8082                	ret

00000000800062ca <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800062ca:	00003717          	auipc	a4,0x3
    800062ce:	d5673703          	ld	a4,-682(a4) # 80009020 <uart_tx_r>
    800062d2:	00003797          	auipc	a5,0x3
    800062d6:	d567b783          	ld	a5,-682(a5) # 80009028 <uart_tx_w>
    800062da:	06e78c63          	beq	a5,a4,80006352 <uartstart+0x88>
{
    800062de:	7139                	addi	sp,sp,-64
    800062e0:	fc06                	sd	ra,56(sp)
    800062e2:	f822                	sd	s0,48(sp)
    800062e4:	f426                	sd	s1,40(sp)
    800062e6:	f04a                	sd	s2,32(sp)
    800062e8:	ec4e                	sd	s3,24(sp)
    800062ea:	e852                	sd	s4,16(sp)
    800062ec:	e456                	sd	s5,8(sp)
    800062ee:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062f0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062f4:	0002aa17          	auipc	s4,0x2a
    800062f8:	f14a0a13          	addi	s4,s4,-236 # 80030208 <uart_tx_lock>
    uart_tx_r += 1;
    800062fc:	00003497          	auipc	s1,0x3
    80006300:	d2448493          	addi	s1,s1,-732 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006304:	00003997          	auipc	s3,0x3
    80006308:	d2498993          	addi	s3,s3,-732 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000630c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006310:	0ff7f793          	andi	a5,a5,255
    80006314:	0207f793          	andi	a5,a5,32
    80006318:	c785                	beqz	a5,80006340 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000631a:	01f77793          	andi	a5,a4,31
    8000631e:	97d2                	add	a5,a5,s4
    80006320:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006324:	0705                	addi	a4,a4,1
    80006326:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006328:	8526                	mv	a0,s1
    8000632a:	ffffb097          	auipc	ra,0xffffb
    8000632e:	3ae080e7          	jalr	942(ra) # 800016d8 <wakeup>
    
    WriteReg(THR, c);
    80006332:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006336:	6098                	ld	a4,0(s1)
    80006338:	0009b783          	ld	a5,0(s3)
    8000633c:	fce798e3          	bne	a5,a4,8000630c <uartstart+0x42>
  }
}
    80006340:	70e2                	ld	ra,56(sp)
    80006342:	7442                	ld	s0,48(sp)
    80006344:	74a2                	ld	s1,40(sp)
    80006346:	7902                	ld	s2,32(sp)
    80006348:	69e2                	ld	s3,24(sp)
    8000634a:	6a42                	ld	s4,16(sp)
    8000634c:	6aa2                	ld	s5,8(sp)
    8000634e:	6121                	addi	sp,sp,64
    80006350:	8082                	ret
    80006352:	8082                	ret

0000000080006354 <uartputc>:
{
    80006354:	7179                	addi	sp,sp,-48
    80006356:	f406                	sd	ra,40(sp)
    80006358:	f022                	sd	s0,32(sp)
    8000635a:	ec26                	sd	s1,24(sp)
    8000635c:	e84a                	sd	s2,16(sp)
    8000635e:	e44e                	sd	s3,8(sp)
    80006360:	e052                	sd	s4,0(sp)
    80006362:	1800                	addi	s0,sp,48
    80006364:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006366:	0002a517          	auipc	a0,0x2a
    8000636a:	ea250513          	addi	a0,a0,-350 # 80030208 <uart_tx_lock>
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	1a4080e7          	jalr	420(ra) # 80006512 <acquire>
  if(panicked){
    80006376:	00003797          	auipc	a5,0x3
    8000637a:	ca67a783          	lw	a5,-858(a5) # 8000901c <panicked>
    8000637e:	c391                	beqz	a5,80006382 <uartputc+0x2e>
    for(;;)
    80006380:	a001                	j	80006380 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006382:	00003797          	auipc	a5,0x3
    80006386:	ca67b783          	ld	a5,-858(a5) # 80009028 <uart_tx_w>
    8000638a:	00003717          	auipc	a4,0x3
    8000638e:	c9673703          	ld	a4,-874(a4) # 80009020 <uart_tx_r>
    80006392:	02070713          	addi	a4,a4,32
    80006396:	02f71b63          	bne	a4,a5,800063cc <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000639a:	0002aa17          	auipc	s4,0x2a
    8000639e:	e6ea0a13          	addi	s4,s4,-402 # 80030208 <uart_tx_lock>
    800063a2:	00003497          	auipc	s1,0x3
    800063a6:	c7e48493          	addi	s1,s1,-898 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063aa:	00003917          	auipc	s2,0x3
    800063ae:	c7e90913          	addi	s2,s2,-898 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800063b2:	85d2                	mv	a1,s4
    800063b4:	8526                	mv	a0,s1
    800063b6:	ffffb097          	auipc	ra,0xffffb
    800063ba:	196080e7          	jalr	406(ra) # 8000154c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063be:	00093783          	ld	a5,0(s2)
    800063c2:	6098                	ld	a4,0(s1)
    800063c4:	02070713          	addi	a4,a4,32
    800063c8:	fef705e3          	beq	a4,a5,800063b2 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800063cc:	0002a497          	auipc	s1,0x2a
    800063d0:	e3c48493          	addi	s1,s1,-452 # 80030208 <uart_tx_lock>
    800063d4:	01f7f713          	andi	a4,a5,31
    800063d8:	9726                	add	a4,a4,s1
    800063da:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800063de:	0785                	addi	a5,a5,1
    800063e0:	00003717          	auipc	a4,0x3
    800063e4:	c4f73423          	sd	a5,-952(a4) # 80009028 <uart_tx_w>
      uartstart();
    800063e8:	00000097          	auipc	ra,0x0
    800063ec:	ee2080e7          	jalr	-286(ra) # 800062ca <uartstart>
      release(&uart_tx_lock);
    800063f0:	8526                	mv	a0,s1
    800063f2:	00000097          	auipc	ra,0x0
    800063f6:	1d4080e7          	jalr	468(ra) # 800065c6 <release>
}
    800063fa:	70a2                	ld	ra,40(sp)
    800063fc:	7402                	ld	s0,32(sp)
    800063fe:	64e2                	ld	s1,24(sp)
    80006400:	6942                	ld	s2,16(sp)
    80006402:	69a2                	ld	s3,8(sp)
    80006404:	6a02                	ld	s4,0(sp)
    80006406:	6145                	addi	sp,sp,48
    80006408:	8082                	ret

000000008000640a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000640a:	1141                	addi	sp,sp,-16
    8000640c:	e422                	sd	s0,8(sp)
    8000640e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006410:	100007b7          	lui	a5,0x10000
    80006414:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006418:	8b85                	andi	a5,a5,1
    8000641a:	cb91                	beqz	a5,8000642e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000641c:	100007b7          	lui	a5,0x10000
    80006420:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006424:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006428:	6422                	ld	s0,8(sp)
    8000642a:	0141                	addi	sp,sp,16
    8000642c:	8082                	ret
    return -1;
    8000642e:	557d                	li	a0,-1
    80006430:	bfe5                	j	80006428 <uartgetc+0x1e>

0000000080006432 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006432:	1101                	addi	sp,sp,-32
    80006434:	ec06                	sd	ra,24(sp)
    80006436:	e822                	sd	s0,16(sp)
    80006438:	e426                	sd	s1,8(sp)
    8000643a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000643c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000643e:	00000097          	auipc	ra,0x0
    80006442:	fcc080e7          	jalr	-52(ra) # 8000640a <uartgetc>
    if(c == -1)
    80006446:	00950763          	beq	a0,s1,80006454 <uartintr+0x22>
      break;
    consoleintr(c);
    8000644a:	00000097          	auipc	ra,0x0
    8000644e:	8fe080e7          	jalr	-1794(ra) # 80005d48 <consoleintr>
  while(1){
    80006452:	b7f5                	j	8000643e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006454:	0002a497          	auipc	s1,0x2a
    80006458:	db448493          	addi	s1,s1,-588 # 80030208 <uart_tx_lock>
    8000645c:	8526                	mv	a0,s1
    8000645e:	00000097          	auipc	ra,0x0
    80006462:	0b4080e7          	jalr	180(ra) # 80006512 <acquire>
  uartstart();
    80006466:	00000097          	auipc	ra,0x0
    8000646a:	e64080e7          	jalr	-412(ra) # 800062ca <uartstart>
  release(&uart_tx_lock);
    8000646e:	8526                	mv	a0,s1
    80006470:	00000097          	auipc	ra,0x0
    80006474:	156080e7          	jalr	342(ra) # 800065c6 <release>
}
    80006478:	60e2                	ld	ra,24(sp)
    8000647a:	6442                	ld	s0,16(sp)
    8000647c:	64a2                	ld	s1,8(sp)
    8000647e:	6105                	addi	sp,sp,32
    80006480:	8082                	ret

0000000080006482 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006482:	1141                	addi	sp,sp,-16
    80006484:	e422                	sd	s0,8(sp)
    80006486:	0800                	addi	s0,sp,16
  lk->name = name;
    80006488:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000648a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000648e:	00053823          	sd	zero,16(a0)
}
    80006492:	6422                	ld	s0,8(sp)
    80006494:	0141                	addi	sp,sp,16
    80006496:	8082                	ret

0000000080006498 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006498:	411c                	lw	a5,0(a0)
    8000649a:	e399                	bnez	a5,800064a0 <holding+0x8>
    8000649c:	4501                	li	a0,0
  return r;
}
    8000649e:	8082                	ret
{
    800064a0:	1101                	addi	sp,sp,-32
    800064a2:	ec06                	sd	ra,24(sp)
    800064a4:	e822                	sd	s0,16(sp)
    800064a6:	e426                	sd	s1,8(sp)
    800064a8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800064aa:	6904                	ld	s1,16(a0)
    800064ac:	ffffb097          	auipc	ra,0xffffb
    800064b0:	966080e7          	jalr	-1690(ra) # 80000e12 <mycpu>
    800064b4:	40a48533          	sub	a0,s1,a0
    800064b8:	00153513          	seqz	a0,a0
}
    800064bc:	60e2                	ld	ra,24(sp)
    800064be:	6442                	ld	s0,16(sp)
    800064c0:	64a2                	ld	s1,8(sp)
    800064c2:	6105                	addi	sp,sp,32
    800064c4:	8082                	ret

00000000800064c6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800064c6:	1101                	addi	sp,sp,-32
    800064c8:	ec06                	sd	ra,24(sp)
    800064ca:	e822                	sd	s0,16(sp)
    800064cc:	e426                	sd	s1,8(sp)
    800064ce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064d0:	100024f3          	csrr	s1,sstatus
    800064d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800064d8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064da:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800064de:	ffffb097          	auipc	ra,0xffffb
    800064e2:	934080e7          	jalr	-1740(ra) # 80000e12 <mycpu>
    800064e6:	5d3c                	lw	a5,120(a0)
    800064e8:	cf89                	beqz	a5,80006502 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800064ea:	ffffb097          	auipc	ra,0xffffb
    800064ee:	928080e7          	jalr	-1752(ra) # 80000e12 <mycpu>
    800064f2:	5d3c                	lw	a5,120(a0)
    800064f4:	2785                	addiw	a5,a5,1
    800064f6:	dd3c                	sw	a5,120(a0)
}
    800064f8:	60e2                	ld	ra,24(sp)
    800064fa:	6442                	ld	s0,16(sp)
    800064fc:	64a2                	ld	s1,8(sp)
    800064fe:	6105                	addi	sp,sp,32
    80006500:	8082                	ret
    mycpu()->intena = old;
    80006502:	ffffb097          	auipc	ra,0xffffb
    80006506:	910080e7          	jalr	-1776(ra) # 80000e12 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000650a:	8085                	srli	s1,s1,0x1
    8000650c:	8885                	andi	s1,s1,1
    8000650e:	dd64                	sw	s1,124(a0)
    80006510:	bfe9                	j	800064ea <push_off+0x24>

0000000080006512 <acquire>:
{
    80006512:	1101                	addi	sp,sp,-32
    80006514:	ec06                	sd	ra,24(sp)
    80006516:	e822                	sd	s0,16(sp)
    80006518:	e426                	sd	s1,8(sp)
    8000651a:	1000                	addi	s0,sp,32
    8000651c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000651e:	00000097          	auipc	ra,0x0
    80006522:	fa8080e7          	jalr	-88(ra) # 800064c6 <push_off>
  if(holding(lk))
    80006526:	8526                	mv	a0,s1
    80006528:	00000097          	auipc	ra,0x0
    8000652c:	f70080e7          	jalr	-144(ra) # 80006498 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006530:	4705                	li	a4,1
  if(holding(lk))
    80006532:	e115                	bnez	a0,80006556 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006534:	87ba                	mv	a5,a4
    80006536:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000653a:	2781                	sext.w	a5,a5
    8000653c:	ffe5                	bnez	a5,80006534 <acquire+0x22>
  __sync_synchronize();
    8000653e:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006542:	ffffb097          	auipc	ra,0xffffb
    80006546:	8d0080e7          	jalr	-1840(ra) # 80000e12 <mycpu>
    8000654a:	e888                	sd	a0,16(s1)
}
    8000654c:	60e2                	ld	ra,24(sp)
    8000654e:	6442                	ld	s0,16(sp)
    80006550:	64a2                	ld	s1,8(sp)
    80006552:	6105                	addi	sp,sp,32
    80006554:	8082                	ret
    panic("acquire");
    80006556:	00002517          	auipc	a0,0x2
    8000655a:	27250513          	addi	a0,a0,626 # 800087c8 <digits+0x20>
    8000655e:	00000097          	auipc	ra,0x0
    80006562:	a6a080e7          	jalr	-1430(ra) # 80005fc8 <panic>

0000000080006566 <pop_off>:

void
pop_off(void)
{
    80006566:	1141                	addi	sp,sp,-16
    80006568:	e406                	sd	ra,8(sp)
    8000656a:	e022                	sd	s0,0(sp)
    8000656c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000656e:	ffffb097          	auipc	ra,0xffffb
    80006572:	8a4080e7          	jalr	-1884(ra) # 80000e12 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006576:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000657a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000657c:	e78d                	bnez	a5,800065a6 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000657e:	5d3c                	lw	a5,120(a0)
    80006580:	02f05b63          	blez	a5,800065b6 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006584:	37fd                	addiw	a5,a5,-1
    80006586:	0007871b          	sext.w	a4,a5
    8000658a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000658c:	eb09                	bnez	a4,8000659e <pop_off+0x38>
    8000658e:	5d7c                	lw	a5,124(a0)
    80006590:	c799                	beqz	a5,8000659e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006592:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006596:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000659a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000659e:	60a2                	ld	ra,8(sp)
    800065a0:	6402                	ld	s0,0(sp)
    800065a2:	0141                	addi	sp,sp,16
    800065a4:	8082                	ret
    panic("pop_off - interruptible");
    800065a6:	00002517          	auipc	a0,0x2
    800065aa:	22a50513          	addi	a0,a0,554 # 800087d0 <digits+0x28>
    800065ae:	00000097          	auipc	ra,0x0
    800065b2:	a1a080e7          	jalr	-1510(ra) # 80005fc8 <panic>
    panic("pop_off");
    800065b6:	00002517          	auipc	a0,0x2
    800065ba:	23250513          	addi	a0,a0,562 # 800087e8 <digits+0x40>
    800065be:	00000097          	auipc	ra,0x0
    800065c2:	a0a080e7          	jalr	-1526(ra) # 80005fc8 <panic>

00000000800065c6 <release>:
{
    800065c6:	1101                	addi	sp,sp,-32
    800065c8:	ec06                	sd	ra,24(sp)
    800065ca:	e822                	sd	s0,16(sp)
    800065cc:	e426                	sd	s1,8(sp)
    800065ce:	1000                	addi	s0,sp,32
    800065d0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800065d2:	00000097          	auipc	ra,0x0
    800065d6:	ec6080e7          	jalr	-314(ra) # 80006498 <holding>
    800065da:	c115                	beqz	a0,800065fe <release+0x38>
  lk->cpu = 0;
    800065dc:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800065e0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800065e4:	0f50000f          	fence	iorw,ow
    800065e8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800065ec:	00000097          	auipc	ra,0x0
    800065f0:	f7a080e7          	jalr	-134(ra) # 80006566 <pop_off>
}
    800065f4:	60e2                	ld	ra,24(sp)
    800065f6:	6442                	ld	s0,16(sp)
    800065f8:	64a2                	ld	s1,8(sp)
    800065fa:	6105                	addi	sp,sp,32
    800065fc:	8082                	ret
    panic("release");
    800065fe:	00002517          	auipc	a0,0x2
    80006602:	1f250513          	addi	a0,a0,498 # 800087f0 <digits+0x48>
    80006606:	00000097          	auipc	ra,0x0
    8000660a:	9c2080e7          	jalr	-1598(ra) # 80005fc8 <panic>
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
