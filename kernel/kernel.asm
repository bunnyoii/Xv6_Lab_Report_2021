
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	88013103          	ld	sp,-1920(sp) # 80008880 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	772050ef          	jal	ra,80005788 <start>

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
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
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
    8000005e:	18c080e7          	jalr	396(ra) # 800061e6 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	22c080e7          	jalr	556(ra) # 8000629a <release>
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
    8000008e:	c3c080e7          	jalr	-964(ra) # 80005cc6 <panic>

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
    800000f8:	062080e7          	jalr	98(ra) # 80006156 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
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
    80000130:	0ba080e7          	jalr	186(ra) # 800061e6 <acquire>
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
    80000148:	156080e7          	jalr	342(ra) # 8000629a <release>

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
    80000172:	12c080e7          	jalr	300(ra) # 8000629a <release>
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
    80000360:	9bc080e7          	jalr	-1604(ra) # 80005d18 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	75e080e7          	jalr	1886(ra) # 80001aca <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	d9c080e7          	jalr	-612(ra) # 80005110 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	00c080e7          	jalr	12(ra) # 80001388 <scheduler>
    consoleinit();
    80000384:	00005097          	auipc	ra,0x5
    80000388:	7c6080e7          	jalr	1990(ra) # 80005b4a <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	8ac080e7          	jalr	-1876(ra) # 80005c38 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	97c080e7          	jalr	-1668(ra) # 80005d18 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	96c080e7          	jalr	-1684(ra) # 80005d18 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	95c080e7          	jalr	-1700(ra) # 80005d18 <printf>
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
    800003e8:	6be080e7          	jalr	1726(ra) # 80001aa2 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6de080e7          	jalr	1758(ra) # 80001aca <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d06080e7          	jalr	-762(ra) # 800050fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d14080e7          	jalr	-748(ra) # 80005110 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	efa080e7          	jalr	-262(ra) # 800022fe <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	58a080e7          	jalr	1418(ra) # 80002996 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	534080e7          	jalr	1332(ra) # 80003948 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e16080e7          	jalr	-490(ra) # 80005232 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d32080e7          	jalr	-718(ra) # 80001156 <userinit>
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
    80000492:	838080e7          	jalr	-1992(ra) # 80005cc6 <panic>
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
    80000586:	00005097          	auipc	ra,0x5
    8000058a:	740080e7          	jalr	1856(ra) # 80005cc6 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00005097          	auipc	ra,0x5
    8000059a:	730080e7          	jalr	1840(ra) # 80005cc6 <panic>
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
    80000610:	00005097          	auipc	ra,0x5
    80000614:	6b6080e7          	jalr	1718(ra) # 80005cc6 <panic>

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
    80000760:	56a080e7          	jalr	1386(ra) # 80005cc6 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	55a080e7          	jalr	1370(ra) # 80005cc6 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	54a080e7          	jalr	1354(ra) # 80005cc6 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	53a080e7          	jalr	1338(ra) # 80005cc6 <panic>
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
    8000086e:	45c080e7          	jalr	1116(ra) # 80005cc6 <panic>

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
    800009b0:	31a080e7          	jalr	794(ra) # 80005cc6 <panic>
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
    80000a8c:	23e080e7          	jalr	574(ra) # 80005cc6 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	22e080e7          	jalr	558(ra) # 80005cc6 <panic>
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
    80000b06:	1c4080e7          	jalr	452(ra) # 80005cc6 <panic>

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
    80000d06:	0000fa17          	auipc	s4,0xf
    80000d0a:	97aa0a13          	addi	s4,s4,-1670 # 8000f680 <tickslock>
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
    80000d40:	18848493          	addi	s1,s1,392
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
    80000d68:	f62080e7          	jalr	-158(ra) # 80005cc6 <panic>

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
    80000d94:	3c6080e7          	jalr	966(ra) # 80006156 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	3ae080e7          	jalr	942(ra) # 80006156 <initlock>
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
    80000dd2:	0000f997          	auipc	s3,0xf
    80000dd6:	8ae98993          	addi	s3,s3,-1874 # 8000f680 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	378080e7          	jalr	888(ra) # 80006156 <initlock>
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
    80000e00:	18848493          	addi	s1,s1,392
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
    80000e56:	348080e7          	jalr	840(ra) # 8000619a <push_off>
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
    80000e70:	3ce080e7          	jalr	974(ra) # 8000623a <pop_off>
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
    80000e94:	40a080e7          	jalr	1034(ra) # 8000629a <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9987a783          	lw	a5,-1640(a5) # 80008830 <first.1680>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c40080e7          	jalr	-960(ra) # 80001ae2 <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9607af23          	sw	zero,-1666(a5) # 80008830 <first.1680>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	a5a080e7          	jalr	-1446(ra) # 80002916 <fsinit>
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
    80000ee0:	30a080e7          	jalr	778(ra) # 800061e6 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	95078793          	addi	a5,a5,-1712 # 80008834 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	3a4080e7          	jalr	932(ra) # 8000629a <release>
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
    80001052:	7179                	addi	sp,sp,-48
    80001054:	f406                	sd	ra,40(sp)
    80001056:	f022                	sd	s0,32(sp)
    80001058:	ec26                	sd	s1,24(sp)
    8000105a:	e84a                	sd	s2,16(sp)
    8000105c:	e44e                	sd	s3,8(sp)
    8000105e:	e052                	sd	s4,0(sp)
    80001060:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80001062:	00008497          	auipc	s1,0x8
    80001066:	41e48493          	addi	s1,s1,1054 # 80009480 <proc>
    8000106a:	0000e917          	auipc	s2,0xe
    8000106e:	61690913          	addi	s2,s2,1558 # 8000f680 <tickslock>
    acquire(&p->lock);
    80001072:	8526                	mv	a0,s1
    80001074:	00005097          	auipc	ra,0x5
    80001078:	172080e7          	jalr	370(ra) # 800061e6 <acquire>
    if(p->state == UNUSED) {
    8000107c:	4c9c                	lw	a5,24(s1)
    8000107e:	cf81                	beqz	a5,80001096 <allocproc+0x44>
      release(&p->lock);
    80001080:	8526                	mv	a0,s1
    80001082:	00005097          	auipc	ra,0x5
    80001086:	218080e7          	jalr	536(ra) # 8000629a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000108a:	18848493          	addi	s1,s1,392
    8000108e:	ff2492e3          	bne	s1,s2,80001072 <allocproc+0x20>
  return 0;
    80001092:	4481                	li	s1,0
    80001094:	a041                	j	80001114 <allocproc+0xc2>
  p->pid = allocpid();
    80001096:	00000097          	auipc	ra,0x0
    8000109a:	e30080e7          	jalr	-464(ra) # 80000ec6 <allocpid>
    8000109e:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010a0:	4785                	li	a5,1
    800010a2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010a4:	fffff097          	auipc	ra,0xfffff
    800010a8:	074080e7          	jalr	116(ra) # 80000118 <kalloc>
    800010ac:	892a                	mv	s2,a0
    800010ae:	eca8                	sd	a0,88(s1)
    800010b0:	c93d                	beqz	a0,80001126 <allocproc+0xd4>
  p->pagetable = proc_pagetable(p);
    800010b2:	8526                	mv	a0,s1
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	e58080e7          	jalr	-424(ra) # 80000f0c <proc_pagetable>
    800010bc:	892a                	mv	s2,a0
    800010be:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010c0:	cd3d                	beqz	a0,8000113e <allocproc+0xec>
  memset(&p->context, 0, sizeof(p->context));
    800010c2:	06048913          	addi	s2,s1,96
    800010c6:	07000613          	li	a2,112
    800010ca:	4581                	li	a1,0
    800010cc:	854a                	mv	a0,s2
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	0aa080e7          	jalr	170(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010d6:	00000a17          	auipc	s4,0x0
    800010da:	daaa0a13          	addi	s4,s4,-598 # 80000e80 <forkret>
    800010de:	0744b023          	sd	s4,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e2:	6985                	lui	s3,0x1
    800010e4:	60bc                	ld	a5,64(s1)
    800010e6:	97ce                	add	a5,a5,s3
    800010e8:	f4bc                	sd	a5,104(s1)
  memset(&p->context, 0, sizeof(p->context));
    800010ea:	07000613          	li	a2,112
    800010ee:	4581                	li	a1,0
    800010f0:	854a                	mv	a0,s2
    800010f2:	fffff097          	auipc	ra,0xfffff
    800010f6:	086080e7          	jalr	134(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010fa:	0744b023          	sd	s4,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010fe:	60bc                	ld	a5,64(s1)
    80001100:	97ce                	add	a5,a5,s3
    80001102:	f4bc                	sd	a5,104(s1)
  p->interval = 0;
    80001104:	1604a423          	sw	zero,360(s1)
  p->handler = 0;
    80001108:	1604b823          	sd	zero,368(s1)
  p->passedticks = 0;
    8000110c:	1604ac23          	sw	zero,376(s1)
  p->trapframecopy = 0;
    80001110:	1804b023          	sd	zero,384(s1)
}
    80001114:	8526                	mv	a0,s1
    80001116:	70a2                	ld	ra,40(sp)
    80001118:	7402                	ld	s0,32(sp)
    8000111a:	64e2                	ld	s1,24(sp)
    8000111c:	6942                	ld	s2,16(sp)
    8000111e:	69a2                	ld	s3,8(sp)
    80001120:	6a02                	ld	s4,0(sp)
    80001122:	6145                	addi	sp,sp,48
    80001124:	8082                	ret
    freeproc(p);
    80001126:	8526                	mv	a0,s1
    80001128:	00000097          	auipc	ra,0x0
    8000112c:	ed2080e7          	jalr	-302(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001130:	8526                	mv	a0,s1
    80001132:	00005097          	auipc	ra,0x5
    80001136:	168080e7          	jalr	360(ra) # 8000629a <release>
    return 0;
    8000113a:	84ca                	mv	s1,s2
    8000113c:	bfe1                	j	80001114 <allocproc+0xc2>
    freeproc(p);
    8000113e:	8526                	mv	a0,s1
    80001140:	00000097          	auipc	ra,0x0
    80001144:	eba080e7          	jalr	-326(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001148:	8526                	mv	a0,s1
    8000114a:	00005097          	auipc	ra,0x5
    8000114e:	150080e7          	jalr	336(ra) # 8000629a <release>
    return 0;
    80001152:	84ca                	mv	s1,s2
    80001154:	b7c1                	j	80001114 <allocproc+0xc2>

0000000080001156 <userinit>:
{
    80001156:	1101                	addi	sp,sp,-32
    80001158:	ec06                	sd	ra,24(sp)
    8000115a:	e822                	sd	s0,16(sp)
    8000115c:	e426                	sd	s1,8(sp)
    8000115e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001160:	00000097          	auipc	ra,0x0
    80001164:	ef2080e7          	jalr	-270(ra) # 80001052 <allocproc>
    80001168:	84aa                	mv	s1,a0
  initproc = p;
    8000116a:	00008797          	auipc	a5,0x8
    8000116e:	eaa7b323          	sd	a0,-346(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001172:	03400613          	li	a2,52
    80001176:	00007597          	auipc	a1,0x7
    8000117a:	6ca58593          	addi	a1,a1,1738 # 80008840 <initcode>
    8000117e:	6928                	ld	a0,80(a0)
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	680080e7          	jalr	1664(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001188:	6785                	lui	a5,0x1
    8000118a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000118c:	6cb8                	ld	a4,88(s1)
    8000118e:	00073c23          	sd	zero,24(a4)
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001192:	6cb8                	ld	a4,88(s1)
    80001194:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001196:	4641                	li	a2,16
    80001198:	00007597          	auipc	a1,0x7
    8000119c:	fe858593          	addi	a1,a1,-24 # 80008180 <etext+0x180>
    800011a0:	15848513          	addi	a0,s1,344
    800011a4:	fffff097          	auipc	ra,0xfffff
    800011a8:	126080e7          	jalr	294(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    800011ac:	00007517          	auipc	a0,0x7
    800011b0:	fe450513          	addi	a0,a0,-28 # 80008190 <etext+0x190>
    800011b4:	00002097          	auipc	ra,0x2
    800011b8:	190080e7          	jalr	400(ra) # 80003344 <namei>
    800011bc:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011c0:	478d                	li	a5,3
    800011c2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011c4:	8526                	mv	a0,s1
    800011c6:	00005097          	auipc	ra,0x5
    800011ca:	0d4080e7          	jalr	212(ra) # 8000629a <release>
}
    800011ce:	60e2                	ld	ra,24(sp)
    800011d0:	6442                	ld	s0,16(sp)
    800011d2:	64a2                	ld	s1,8(sp)
    800011d4:	6105                	addi	sp,sp,32
    800011d6:	8082                	ret

00000000800011d8 <growproc>:
{
    800011d8:	1101                	addi	sp,sp,-32
    800011da:	ec06                	sd	ra,24(sp)
    800011dc:	e822                	sd	s0,16(sp)
    800011de:	e426                	sd	s1,8(sp)
    800011e0:	e04a                	sd	s2,0(sp)
    800011e2:	1000                	addi	s0,sp,32
    800011e4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011e6:	00000097          	auipc	ra,0x0
    800011ea:	c62080e7          	jalr	-926(ra) # 80000e48 <myproc>
    800011ee:	892a                	mv	s2,a0
  sz = p->sz;
    800011f0:	652c                	ld	a1,72(a0)
    800011f2:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011f6:	00904f63          	bgtz	s1,80001214 <growproc+0x3c>
  } else if(n < 0){
    800011fa:	0204cc63          	bltz	s1,80001232 <growproc+0x5a>
  p->sz = sz;
    800011fe:	1602                	slli	a2,a2,0x20
    80001200:	9201                	srli	a2,a2,0x20
    80001202:	04c93423          	sd	a2,72(s2)
  return 0;
    80001206:	4501                	li	a0,0
}
    80001208:	60e2                	ld	ra,24(sp)
    8000120a:	6442                	ld	s0,16(sp)
    8000120c:	64a2                	ld	s1,8(sp)
    8000120e:	6902                	ld	s2,0(sp)
    80001210:	6105                	addi	sp,sp,32
    80001212:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001214:	9e25                	addw	a2,a2,s1
    80001216:	1602                	slli	a2,a2,0x20
    80001218:	9201                	srli	a2,a2,0x20
    8000121a:	1582                	slli	a1,a1,0x20
    8000121c:	9181                	srli	a1,a1,0x20
    8000121e:	6928                	ld	a0,80(a0)
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	69a080e7          	jalr	1690(ra) # 800008ba <uvmalloc>
    80001228:	0005061b          	sext.w	a2,a0
    8000122c:	fa69                	bnez	a2,800011fe <growproc+0x26>
      return -1;
    8000122e:	557d                	li	a0,-1
    80001230:	bfe1                	j	80001208 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001232:	9e25                	addw	a2,a2,s1
    80001234:	1602                	slli	a2,a2,0x20
    80001236:	9201                	srli	a2,a2,0x20
    80001238:	1582                	slli	a1,a1,0x20
    8000123a:	9181                	srli	a1,a1,0x20
    8000123c:	6928                	ld	a0,80(a0)
    8000123e:	fffff097          	auipc	ra,0xfffff
    80001242:	634080e7          	jalr	1588(ra) # 80000872 <uvmdealloc>
    80001246:	0005061b          	sext.w	a2,a0
    8000124a:	bf55                	j	800011fe <growproc+0x26>

000000008000124c <fork>:
{
    8000124c:	7179                	addi	sp,sp,-48
    8000124e:	f406                	sd	ra,40(sp)
    80001250:	f022                	sd	s0,32(sp)
    80001252:	ec26                	sd	s1,24(sp)
    80001254:	e84a                	sd	s2,16(sp)
    80001256:	e44e                	sd	s3,8(sp)
    80001258:	e052                	sd	s4,0(sp)
    8000125a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	bec080e7          	jalr	-1044(ra) # 80000e48 <myproc>
    80001264:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001266:	00000097          	auipc	ra,0x0
    8000126a:	dec080e7          	jalr	-532(ra) # 80001052 <allocproc>
    8000126e:	10050b63          	beqz	a0,80001384 <fork+0x138>
    80001272:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001274:	04893603          	ld	a2,72(s2)
    80001278:	692c                	ld	a1,80(a0)
    8000127a:	05093503          	ld	a0,80(s2)
    8000127e:	fffff097          	auipc	ra,0xfffff
    80001282:	788080e7          	jalr	1928(ra) # 80000a06 <uvmcopy>
    80001286:	04054663          	bltz	a0,800012d2 <fork+0x86>
  np->sz = p->sz;
    8000128a:	04893783          	ld	a5,72(s2)
    8000128e:	04f9b423          	sd	a5,72(s3) # 1048 <_entry-0x7fffefb8>
  *(np->trapframe) = *(p->trapframe);
    80001292:	05893683          	ld	a3,88(s2)
    80001296:	87b6                	mv	a5,a3
    80001298:	0589b703          	ld	a4,88(s3)
    8000129c:	12068693          	addi	a3,a3,288
    800012a0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012a4:	6788                	ld	a0,8(a5)
    800012a6:	6b8c                	ld	a1,16(a5)
    800012a8:	6f90                	ld	a2,24(a5)
    800012aa:	01073023          	sd	a6,0(a4)
    800012ae:	e708                	sd	a0,8(a4)
    800012b0:	eb0c                	sd	a1,16(a4)
    800012b2:	ef10                	sd	a2,24(a4)
    800012b4:	02078793          	addi	a5,a5,32
    800012b8:	02070713          	addi	a4,a4,32
    800012bc:	fed792e3          	bne	a5,a3,800012a0 <fork+0x54>
  np->trapframe->a0 = 0;
    800012c0:	0589b783          	ld	a5,88(s3)
    800012c4:	0607b823          	sd	zero,112(a5)
    800012c8:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012cc:	15000a13          	li	s4,336
    800012d0:	a03d                	j	800012fe <fork+0xb2>
    freeproc(np);
    800012d2:	854e                	mv	a0,s3
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	d26080e7          	jalr	-730(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012dc:	854e                	mv	a0,s3
    800012de:	00005097          	auipc	ra,0x5
    800012e2:	fbc080e7          	jalr	-68(ra) # 8000629a <release>
    return -1;
    800012e6:	5a7d                	li	s4,-1
    800012e8:	a069                	j	80001372 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012ea:	00002097          	auipc	ra,0x2
    800012ee:	6f0080e7          	jalr	1776(ra) # 800039da <filedup>
    800012f2:	009987b3          	add	a5,s3,s1
    800012f6:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012f8:	04a1                	addi	s1,s1,8
    800012fa:	01448763          	beq	s1,s4,80001308 <fork+0xbc>
    if(p->ofile[i])
    800012fe:	009907b3          	add	a5,s2,s1
    80001302:	6388                	ld	a0,0(a5)
    80001304:	f17d                	bnez	a0,800012ea <fork+0x9e>
    80001306:	bfcd                	j	800012f8 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001308:	15093503          	ld	a0,336(s2)
    8000130c:	00002097          	auipc	ra,0x2
    80001310:	844080e7          	jalr	-1980(ra) # 80002b50 <idup>
    80001314:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001318:	4641                	li	a2,16
    8000131a:	15890593          	addi	a1,s2,344
    8000131e:	15898513          	addi	a0,s3,344
    80001322:	fffff097          	auipc	ra,0xfffff
    80001326:	fa8080e7          	jalr	-88(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    8000132a:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000132e:	854e                	mv	a0,s3
    80001330:	00005097          	auipc	ra,0x5
    80001334:	f6a080e7          	jalr	-150(ra) # 8000629a <release>
  acquire(&wait_lock);
    80001338:	00008497          	auipc	s1,0x8
    8000133c:	d3048493          	addi	s1,s1,-720 # 80009068 <wait_lock>
    80001340:	8526                	mv	a0,s1
    80001342:	00005097          	auipc	ra,0x5
    80001346:	ea4080e7          	jalr	-348(ra) # 800061e6 <acquire>
  np->parent = p;
    8000134a:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000134e:	8526                	mv	a0,s1
    80001350:	00005097          	auipc	ra,0x5
    80001354:	f4a080e7          	jalr	-182(ra) # 8000629a <release>
  acquire(&np->lock);
    80001358:	854e                	mv	a0,s3
    8000135a:	00005097          	auipc	ra,0x5
    8000135e:	e8c080e7          	jalr	-372(ra) # 800061e6 <acquire>
  np->state = RUNNABLE;
    80001362:	478d                	li	a5,3
    80001364:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001368:	854e                	mv	a0,s3
    8000136a:	00005097          	auipc	ra,0x5
    8000136e:	f30080e7          	jalr	-208(ra) # 8000629a <release>
}
    80001372:	8552                	mv	a0,s4
    80001374:	70a2                	ld	ra,40(sp)
    80001376:	7402                	ld	s0,32(sp)
    80001378:	64e2                	ld	s1,24(sp)
    8000137a:	6942                	ld	s2,16(sp)
    8000137c:	69a2                	ld	s3,8(sp)
    8000137e:	6a02                	ld	s4,0(sp)
    80001380:	6145                	addi	sp,sp,48
    80001382:	8082                	ret
    return -1;
    80001384:	5a7d                	li	s4,-1
    80001386:	b7f5                	j	80001372 <fork+0x126>

0000000080001388 <scheduler>:
{
    80001388:	7139                	addi	sp,sp,-64
    8000138a:	fc06                	sd	ra,56(sp)
    8000138c:	f822                	sd	s0,48(sp)
    8000138e:	f426                	sd	s1,40(sp)
    80001390:	f04a                	sd	s2,32(sp)
    80001392:	ec4e                	sd	s3,24(sp)
    80001394:	e852                	sd	s4,16(sp)
    80001396:	e456                	sd	s5,8(sp)
    80001398:	e05a                	sd	s6,0(sp)
    8000139a:	0080                	addi	s0,sp,64
    8000139c:	8792                	mv	a5,tp
  int id = r_tp();
    8000139e:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a0:	00779a93          	slli	s5,a5,0x7
    800013a4:	00008717          	auipc	a4,0x8
    800013a8:	cac70713          	addi	a4,a4,-852 # 80009050 <pid_lock>
    800013ac:	9756                	add	a4,a4,s5
    800013ae:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013b2:	00008717          	auipc	a4,0x8
    800013b6:	cd670713          	addi	a4,a4,-810 # 80009088 <cpus+0x8>
    800013ba:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013bc:	498d                	li	s3,3
        p->state = RUNNING;
    800013be:	4b11                	li	s6,4
        c->proc = p;
    800013c0:	079e                	slli	a5,a5,0x7
    800013c2:	00008a17          	auipc	s4,0x8
    800013c6:	c8ea0a13          	addi	s4,s4,-882 # 80009050 <pid_lock>
    800013ca:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013cc:	0000e917          	auipc	s2,0xe
    800013d0:	2b490913          	addi	s2,s2,692 # 8000f680 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013d8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013dc:	10079073          	csrw	sstatus,a5
    800013e0:	00008497          	auipc	s1,0x8
    800013e4:	0a048493          	addi	s1,s1,160 # 80009480 <proc>
    800013e8:	a03d                	j	80001416 <scheduler+0x8e>
        p->state = RUNNING;
    800013ea:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013ee:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013f2:	06048593          	addi	a1,s1,96
    800013f6:	8556                	mv	a0,s5
    800013f8:	00000097          	auipc	ra,0x0
    800013fc:	640080e7          	jalr	1600(ra) # 80001a38 <swtch>
        c->proc = 0;
    80001400:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	e94080e7          	jalr	-364(ra) # 8000629a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000140e:	18848493          	addi	s1,s1,392
    80001412:	fd2481e3          	beq	s1,s2,800013d4 <scheduler+0x4c>
      acquire(&p->lock);
    80001416:	8526                	mv	a0,s1
    80001418:	00005097          	auipc	ra,0x5
    8000141c:	dce080e7          	jalr	-562(ra) # 800061e6 <acquire>
      if(p->state == RUNNABLE) {
    80001420:	4c9c                	lw	a5,24(s1)
    80001422:	ff3791e3          	bne	a5,s3,80001404 <scheduler+0x7c>
    80001426:	b7d1                	j	800013ea <scheduler+0x62>

0000000080001428 <sched>:
{
    80001428:	7179                	addi	sp,sp,-48
    8000142a:	f406                	sd	ra,40(sp)
    8000142c:	f022                	sd	s0,32(sp)
    8000142e:	ec26                	sd	s1,24(sp)
    80001430:	e84a                	sd	s2,16(sp)
    80001432:	e44e                	sd	s3,8(sp)
    80001434:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	a12080e7          	jalr	-1518(ra) # 80000e48 <myproc>
    8000143e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001440:	00005097          	auipc	ra,0x5
    80001444:	d2c080e7          	jalr	-724(ra) # 8000616c <holding>
    80001448:	c93d                	beqz	a0,800014be <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	00008717          	auipc	a4,0x8
    80001454:	c0070713          	addi	a4,a4,-1024 # 80009050 <pid_lock>
    80001458:	97ba                	add	a5,a5,a4
    8000145a:	0a87a703          	lw	a4,168(a5)
    8000145e:	4785                	li	a5,1
    80001460:	06f71763          	bne	a4,a5,800014ce <sched+0xa6>
  if(p->state == RUNNING)
    80001464:	4c98                	lw	a4,24(s1)
    80001466:	4791                	li	a5,4
    80001468:	06f70b63          	beq	a4,a5,800014de <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000146c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001470:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001472:	efb5                	bnez	a5,800014ee <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001474:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001476:	00008917          	auipc	s2,0x8
    8000147a:	bda90913          	addi	s2,s2,-1062 # 80009050 <pid_lock>
    8000147e:	2781                	sext.w	a5,a5
    80001480:	079e                	slli	a5,a5,0x7
    80001482:	97ca                	add	a5,a5,s2
    80001484:	0ac7a983          	lw	s3,172(a5)
    80001488:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000148a:	2781                	sext.w	a5,a5
    8000148c:	079e                	slli	a5,a5,0x7
    8000148e:	00008597          	auipc	a1,0x8
    80001492:	bfa58593          	addi	a1,a1,-1030 # 80009088 <cpus+0x8>
    80001496:	95be                	add	a1,a1,a5
    80001498:	06048513          	addi	a0,s1,96
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	59c080e7          	jalr	1436(ra) # 80001a38 <swtch>
    800014a4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	97ca                	add	a5,a5,s2
    800014ac:	0b37a623          	sw	s3,172(a5)
}
    800014b0:	70a2                	ld	ra,40(sp)
    800014b2:	7402                	ld	s0,32(sp)
    800014b4:	64e2                	ld	s1,24(sp)
    800014b6:	6942                	ld	s2,16(sp)
    800014b8:	69a2                	ld	s3,8(sp)
    800014ba:	6145                	addi	sp,sp,48
    800014bc:	8082                	ret
    panic("sched p->lock");
    800014be:	00007517          	auipc	a0,0x7
    800014c2:	cda50513          	addi	a0,a0,-806 # 80008198 <etext+0x198>
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	800080e7          	jalr	-2048(ra) # 80005cc6 <panic>
    panic("sched locks");
    800014ce:	00007517          	auipc	a0,0x7
    800014d2:	cda50513          	addi	a0,a0,-806 # 800081a8 <etext+0x1a8>
    800014d6:	00004097          	auipc	ra,0x4
    800014da:	7f0080e7          	jalr	2032(ra) # 80005cc6 <panic>
    panic("sched running");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	cda50513          	addi	a0,a0,-806 # 800081b8 <etext+0x1b8>
    800014e6:	00004097          	auipc	ra,0x4
    800014ea:	7e0080e7          	jalr	2016(ra) # 80005cc6 <panic>
    panic("sched interruptible");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	cda50513          	addi	a0,a0,-806 # 800081c8 <etext+0x1c8>
    800014f6:	00004097          	auipc	ra,0x4
    800014fa:	7d0080e7          	jalr	2000(ra) # 80005cc6 <panic>

00000000800014fe <yield>:
{
    800014fe:	1101                	addi	sp,sp,-32
    80001500:	ec06                	sd	ra,24(sp)
    80001502:	e822                	sd	s0,16(sp)
    80001504:	e426                	sd	s1,8(sp)
    80001506:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001508:	00000097          	auipc	ra,0x0
    8000150c:	940080e7          	jalr	-1728(ra) # 80000e48 <myproc>
    80001510:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001512:	00005097          	auipc	ra,0x5
    80001516:	cd4080e7          	jalr	-812(ra) # 800061e6 <acquire>
  p->state = RUNNABLE;
    8000151a:	478d                	li	a5,3
    8000151c:	cc9c                	sw	a5,24(s1)
  sched();
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	f0a080e7          	jalr	-246(ra) # 80001428 <sched>
  release(&p->lock);
    80001526:	8526                	mv	a0,s1
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	d72080e7          	jalr	-654(ra) # 8000629a <release>
}
    80001530:	60e2                	ld	ra,24(sp)
    80001532:	6442                	ld	s0,16(sp)
    80001534:	64a2                	ld	s1,8(sp)
    80001536:	6105                	addi	sp,sp,32
    80001538:	8082                	ret

000000008000153a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000153a:	7179                	addi	sp,sp,-48
    8000153c:	f406                	sd	ra,40(sp)
    8000153e:	f022                	sd	s0,32(sp)
    80001540:	ec26                	sd	s1,24(sp)
    80001542:	e84a                	sd	s2,16(sp)
    80001544:	e44e                	sd	s3,8(sp)
    80001546:	1800                	addi	s0,sp,48
    80001548:	89aa                	mv	s3,a0
    8000154a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	8fc080e7          	jalr	-1796(ra) # 80000e48 <myproc>
    80001554:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	c90080e7          	jalr	-880(ra) # 800061e6 <acquire>
  release(lk);
    8000155e:	854a                	mv	a0,s2
    80001560:	00005097          	auipc	ra,0x5
    80001564:	d3a080e7          	jalr	-710(ra) # 8000629a <release>

  // Go to sleep.
  p->chan = chan;
    80001568:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000156c:	4789                	li	a5,2
    8000156e:	cc9c                	sw	a5,24(s1)

  sched();
    80001570:	00000097          	auipc	ra,0x0
    80001574:	eb8080e7          	jalr	-328(ra) # 80001428 <sched>

  // Tidy up.
  p->chan = 0;
    80001578:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000157c:	8526                	mv	a0,s1
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	d1c080e7          	jalr	-740(ra) # 8000629a <release>
  acquire(lk);
    80001586:	854a                	mv	a0,s2
    80001588:	00005097          	auipc	ra,0x5
    8000158c:	c5e080e7          	jalr	-930(ra) # 800061e6 <acquire>
}
    80001590:	70a2                	ld	ra,40(sp)
    80001592:	7402                	ld	s0,32(sp)
    80001594:	64e2                	ld	s1,24(sp)
    80001596:	6942                	ld	s2,16(sp)
    80001598:	69a2                	ld	s3,8(sp)
    8000159a:	6145                	addi	sp,sp,48
    8000159c:	8082                	ret

000000008000159e <wait>:
{
    8000159e:	715d                	addi	sp,sp,-80
    800015a0:	e486                	sd	ra,72(sp)
    800015a2:	e0a2                	sd	s0,64(sp)
    800015a4:	fc26                	sd	s1,56(sp)
    800015a6:	f84a                	sd	s2,48(sp)
    800015a8:	f44e                	sd	s3,40(sp)
    800015aa:	f052                	sd	s4,32(sp)
    800015ac:	ec56                	sd	s5,24(sp)
    800015ae:	e85a                	sd	s6,16(sp)
    800015b0:	e45e                	sd	s7,8(sp)
    800015b2:	e062                	sd	s8,0(sp)
    800015b4:	0880                	addi	s0,sp,80
    800015b6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015b8:	00000097          	auipc	ra,0x0
    800015bc:	890080e7          	jalr	-1904(ra) # 80000e48 <myproc>
    800015c0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015c2:	00008517          	auipc	a0,0x8
    800015c6:	aa650513          	addi	a0,a0,-1370 # 80009068 <wait_lock>
    800015ca:	00005097          	auipc	ra,0x5
    800015ce:	c1c080e7          	jalr	-996(ra) # 800061e6 <acquire>
    havekids = 0;
    800015d2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015d4:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015d6:	0000e997          	auipc	s3,0xe
    800015da:	0aa98993          	addi	s3,s3,170 # 8000f680 <tickslock>
        havekids = 1;
    800015de:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015e0:	00008c17          	auipc	s8,0x8
    800015e4:	a88c0c13          	addi	s8,s8,-1400 # 80009068 <wait_lock>
    havekids = 0;
    800015e8:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015ea:	00008497          	auipc	s1,0x8
    800015ee:	e9648493          	addi	s1,s1,-362 # 80009480 <proc>
    800015f2:	a0bd                	j	80001660 <wait+0xc2>
          pid = np->pid;
    800015f4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015f8:	000b0e63          	beqz	s6,80001614 <wait+0x76>
    800015fc:	4691                	li	a3,4
    800015fe:	02c48613          	addi	a2,s1,44
    80001602:	85da                	mv	a1,s6
    80001604:	05093503          	ld	a0,80(s2)
    80001608:	fffff097          	auipc	ra,0xfffff
    8000160c:	502080e7          	jalr	1282(ra) # 80000b0a <copyout>
    80001610:	02054563          	bltz	a0,8000163a <wait+0x9c>
          freeproc(np);
    80001614:	8526                	mv	a0,s1
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	9e4080e7          	jalr	-1564(ra) # 80000ffa <freeproc>
          release(&np->lock);
    8000161e:	8526                	mv	a0,s1
    80001620:	00005097          	auipc	ra,0x5
    80001624:	c7a080e7          	jalr	-902(ra) # 8000629a <release>
          release(&wait_lock);
    80001628:	00008517          	auipc	a0,0x8
    8000162c:	a4050513          	addi	a0,a0,-1472 # 80009068 <wait_lock>
    80001630:	00005097          	auipc	ra,0x5
    80001634:	c6a080e7          	jalr	-918(ra) # 8000629a <release>
          return pid;
    80001638:	a09d                	j	8000169e <wait+0x100>
            release(&np->lock);
    8000163a:	8526                	mv	a0,s1
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	c5e080e7          	jalr	-930(ra) # 8000629a <release>
            release(&wait_lock);
    80001644:	00008517          	auipc	a0,0x8
    80001648:	a2450513          	addi	a0,a0,-1500 # 80009068 <wait_lock>
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	c4e080e7          	jalr	-946(ra) # 8000629a <release>
            return -1;
    80001654:	59fd                	li	s3,-1
    80001656:	a0a1                	j	8000169e <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001658:	18848493          	addi	s1,s1,392
    8000165c:	03348463          	beq	s1,s3,80001684 <wait+0xe6>
      if(np->parent == p){
    80001660:	7c9c                	ld	a5,56(s1)
    80001662:	ff279be3          	bne	a5,s2,80001658 <wait+0xba>
        acquire(&np->lock);
    80001666:	8526                	mv	a0,s1
    80001668:	00005097          	auipc	ra,0x5
    8000166c:	b7e080e7          	jalr	-1154(ra) # 800061e6 <acquire>
        if(np->state == ZOMBIE){
    80001670:	4c9c                	lw	a5,24(s1)
    80001672:	f94781e3          	beq	a5,s4,800015f4 <wait+0x56>
        release(&np->lock);
    80001676:	8526                	mv	a0,s1
    80001678:	00005097          	auipc	ra,0x5
    8000167c:	c22080e7          	jalr	-990(ra) # 8000629a <release>
        havekids = 1;
    80001680:	8756                	mv	a4,s5
    80001682:	bfd9                	j	80001658 <wait+0xba>
    if(!havekids || p->killed){
    80001684:	c701                	beqz	a4,8000168c <wait+0xee>
    80001686:	02892783          	lw	a5,40(s2)
    8000168a:	c79d                	beqz	a5,800016b8 <wait+0x11a>
      release(&wait_lock);
    8000168c:	00008517          	auipc	a0,0x8
    80001690:	9dc50513          	addi	a0,a0,-1572 # 80009068 <wait_lock>
    80001694:	00005097          	auipc	ra,0x5
    80001698:	c06080e7          	jalr	-1018(ra) # 8000629a <release>
      return -1;
    8000169c:	59fd                	li	s3,-1
}
    8000169e:	854e                	mv	a0,s3
    800016a0:	60a6                	ld	ra,72(sp)
    800016a2:	6406                	ld	s0,64(sp)
    800016a4:	74e2                	ld	s1,56(sp)
    800016a6:	7942                	ld	s2,48(sp)
    800016a8:	79a2                	ld	s3,40(sp)
    800016aa:	7a02                	ld	s4,32(sp)
    800016ac:	6ae2                	ld	s5,24(sp)
    800016ae:	6b42                	ld	s6,16(sp)
    800016b0:	6ba2                	ld	s7,8(sp)
    800016b2:	6c02                	ld	s8,0(sp)
    800016b4:	6161                	addi	sp,sp,80
    800016b6:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016b8:	85e2                	mv	a1,s8
    800016ba:	854a                	mv	a0,s2
    800016bc:	00000097          	auipc	ra,0x0
    800016c0:	e7e080e7          	jalr	-386(ra) # 8000153a <sleep>
    havekids = 0;
    800016c4:	b715                	j	800015e8 <wait+0x4a>

00000000800016c6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016c6:	7139                	addi	sp,sp,-64
    800016c8:	fc06                	sd	ra,56(sp)
    800016ca:	f822                	sd	s0,48(sp)
    800016cc:	f426                	sd	s1,40(sp)
    800016ce:	f04a                	sd	s2,32(sp)
    800016d0:	ec4e                	sd	s3,24(sp)
    800016d2:	e852                	sd	s4,16(sp)
    800016d4:	e456                	sd	s5,8(sp)
    800016d6:	0080                	addi	s0,sp,64
    800016d8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016da:	00008497          	auipc	s1,0x8
    800016de:	da648493          	addi	s1,s1,-602 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016e2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016e4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e6:	0000e917          	auipc	s2,0xe
    800016ea:	f9a90913          	addi	s2,s2,-102 # 8000f680 <tickslock>
    800016ee:	a821                	j	80001706 <wakeup+0x40>
        p->state = RUNNABLE;
    800016f0:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016f4:	8526                	mv	a0,s1
    800016f6:	00005097          	auipc	ra,0x5
    800016fa:	ba4080e7          	jalr	-1116(ra) # 8000629a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016fe:	18848493          	addi	s1,s1,392
    80001702:	03248463          	beq	s1,s2,8000172a <wakeup+0x64>
    if(p != myproc()){
    80001706:	fffff097          	auipc	ra,0xfffff
    8000170a:	742080e7          	jalr	1858(ra) # 80000e48 <myproc>
    8000170e:	fea488e3          	beq	s1,a0,800016fe <wakeup+0x38>
      acquire(&p->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	ad2080e7          	jalr	-1326(ra) # 800061e6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000171c:	4c9c                	lw	a5,24(s1)
    8000171e:	fd379be3          	bne	a5,s3,800016f4 <wakeup+0x2e>
    80001722:	709c                	ld	a5,32(s1)
    80001724:	fd4798e3          	bne	a5,s4,800016f4 <wakeup+0x2e>
    80001728:	b7e1                	j	800016f0 <wakeup+0x2a>
    }
  }
}
    8000172a:	70e2                	ld	ra,56(sp)
    8000172c:	7442                	ld	s0,48(sp)
    8000172e:	74a2                	ld	s1,40(sp)
    80001730:	7902                	ld	s2,32(sp)
    80001732:	69e2                	ld	s3,24(sp)
    80001734:	6a42                	ld	s4,16(sp)
    80001736:	6aa2                	ld	s5,8(sp)
    80001738:	6121                	addi	sp,sp,64
    8000173a:	8082                	ret

000000008000173c <reparent>:
{
    8000173c:	7179                	addi	sp,sp,-48
    8000173e:	f406                	sd	ra,40(sp)
    80001740:	f022                	sd	s0,32(sp)
    80001742:	ec26                	sd	s1,24(sp)
    80001744:	e84a                	sd	s2,16(sp)
    80001746:	e44e                	sd	s3,8(sp)
    80001748:	e052                	sd	s4,0(sp)
    8000174a:	1800                	addi	s0,sp,48
    8000174c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000174e:	00008497          	auipc	s1,0x8
    80001752:	d3248493          	addi	s1,s1,-718 # 80009480 <proc>
      pp->parent = initproc;
    80001756:	00008a17          	auipc	s4,0x8
    8000175a:	8baa0a13          	addi	s4,s4,-1862 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000175e:	0000e997          	auipc	s3,0xe
    80001762:	f2298993          	addi	s3,s3,-222 # 8000f680 <tickslock>
    80001766:	a029                	j	80001770 <reparent+0x34>
    80001768:	18848493          	addi	s1,s1,392
    8000176c:	01348d63          	beq	s1,s3,80001786 <reparent+0x4a>
    if(pp->parent == p){
    80001770:	7c9c                	ld	a5,56(s1)
    80001772:	ff279be3          	bne	a5,s2,80001768 <reparent+0x2c>
      pp->parent = initproc;
    80001776:	000a3503          	ld	a0,0(s4)
    8000177a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000177c:	00000097          	auipc	ra,0x0
    80001780:	f4a080e7          	jalr	-182(ra) # 800016c6 <wakeup>
    80001784:	b7d5                	j	80001768 <reparent+0x2c>
}
    80001786:	70a2                	ld	ra,40(sp)
    80001788:	7402                	ld	s0,32(sp)
    8000178a:	64e2                	ld	s1,24(sp)
    8000178c:	6942                	ld	s2,16(sp)
    8000178e:	69a2                	ld	s3,8(sp)
    80001790:	6a02                	ld	s4,0(sp)
    80001792:	6145                	addi	sp,sp,48
    80001794:	8082                	ret

0000000080001796 <exit>:
{
    80001796:	7179                	addi	sp,sp,-48
    80001798:	f406                	sd	ra,40(sp)
    8000179a:	f022                	sd	s0,32(sp)
    8000179c:	ec26                	sd	s1,24(sp)
    8000179e:	e84a                	sd	s2,16(sp)
    800017a0:	e44e                	sd	s3,8(sp)
    800017a2:	e052                	sd	s4,0(sp)
    800017a4:	1800                	addi	s0,sp,48
    800017a6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017a8:	fffff097          	auipc	ra,0xfffff
    800017ac:	6a0080e7          	jalr	1696(ra) # 80000e48 <myproc>
    800017b0:	89aa                	mv	s3,a0
  if(p == initproc)
    800017b2:	00008797          	auipc	a5,0x8
    800017b6:	85e7b783          	ld	a5,-1954(a5) # 80009010 <initproc>
    800017ba:	0d050493          	addi	s1,a0,208
    800017be:	15050913          	addi	s2,a0,336
    800017c2:	02a79363          	bne	a5,a0,800017e8 <exit+0x52>
    panic("init exiting");
    800017c6:	00007517          	auipc	a0,0x7
    800017ca:	a1a50513          	addi	a0,a0,-1510 # 800081e0 <etext+0x1e0>
    800017ce:	00004097          	auipc	ra,0x4
    800017d2:	4f8080e7          	jalr	1272(ra) # 80005cc6 <panic>
      fileclose(f);
    800017d6:	00002097          	auipc	ra,0x2
    800017da:	256080e7          	jalr	598(ra) # 80003a2c <fileclose>
      p->ofile[fd] = 0;
    800017de:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017e2:	04a1                	addi	s1,s1,8
    800017e4:	01248563          	beq	s1,s2,800017ee <exit+0x58>
    if(p->ofile[fd]){
    800017e8:	6088                	ld	a0,0(s1)
    800017ea:	f575                	bnez	a0,800017d6 <exit+0x40>
    800017ec:	bfdd                	j	800017e2 <exit+0x4c>
  begin_op();
    800017ee:	00002097          	auipc	ra,0x2
    800017f2:	d72080e7          	jalr	-654(ra) # 80003560 <begin_op>
  iput(p->cwd);
    800017f6:	1509b503          	ld	a0,336(s3)
    800017fa:	00001097          	auipc	ra,0x1
    800017fe:	54e080e7          	jalr	1358(ra) # 80002d48 <iput>
  end_op();
    80001802:	00002097          	auipc	ra,0x2
    80001806:	dde080e7          	jalr	-546(ra) # 800035e0 <end_op>
  p->cwd = 0;
    8000180a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000180e:	00008497          	auipc	s1,0x8
    80001812:	85a48493          	addi	s1,s1,-1958 # 80009068 <wait_lock>
    80001816:	8526                	mv	a0,s1
    80001818:	00005097          	auipc	ra,0x5
    8000181c:	9ce080e7          	jalr	-1586(ra) # 800061e6 <acquire>
  reparent(p);
    80001820:	854e                	mv	a0,s3
    80001822:	00000097          	auipc	ra,0x0
    80001826:	f1a080e7          	jalr	-230(ra) # 8000173c <reparent>
  wakeup(p->parent);
    8000182a:	0389b503          	ld	a0,56(s3)
    8000182e:	00000097          	auipc	ra,0x0
    80001832:	e98080e7          	jalr	-360(ra) # 800016c6 <wakeup>
  acquire(&p->lock);
    80001836:	854e                	mv	a0,s3
    80001838:	00005097          	auipc	ra,0x5
    8000183c:	9ae080e7          	jalr	-1618(ra) # 800061e6 <acquire>
  p->xstate = status;
    80001840:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001844:	4795                	li	a5,5
    80001846:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000184a:	8526                	mv	a0,s1
    8000184c:	00005097          	auipc	ra,0x5
    80001850:	a4e080e7          	jalr	-1458(ra) # 8000629a <release>
  sched();
    80001854:	00000097          	auipc	ra,0x0
    80001858:	bd4080e7          	jalr	-1068(ra) # 80001428 <sched>
  panic("zombie exit");
    8000185c:	00007517          	auipc	a0,0x7
    80001860:	99450513          	addi	a0,a0,-1644 # 800081f0 <etext+0x1f0>
    80001864:	00004097          	auipc	ra,0x4
    80001868:	462080e7          	jalr	1122(ra) # 80005cc6 <panic>

000000008000186c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000186c:	7179                	addi	sp,sp,-48
    8000186e:	f406                	sd	ra,40(sp)
    80001870:	f022                	sd	s0,32(sp)
    80001872:	ec26                	sd	s1,24(sp)
    80001874:	e84a                	sd	s2,16(sp)
    80001876:	e44e                	sd	s3,8(sp)
    80001878:	1800                	addi	s0,sp,48
    8000187a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000187c:	00008497          	auipc	s1,0x8
    80001880:	c0448493          	addi	s1,s1,-1020 # 80009480 <proc>
    80001884:	0000e997          	auipc	s3,0xe
    80001888:	dfc98993          	addi	s3,s3,-516 # 8000f680 <tickslock>
    acquire(&p->lock);
    8000188c:	8526                	mv	a0,s1
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	958080e7          	jalr	-1704(ra) # 800061e6 <acquire>
    if(p->pid == pid){
    80001896:	589c                	lw	a5,48(s1)
    80001898:	01278d63          	beq	a5,s2,800018b2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000189c:	8526                	mv	a0,s1
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	9fc080e7          	jalr	-1540(ra) # 8000629a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018a6:	18848493          	addi	s1,s1,392
    800018aa:	ff3491e3          	bne	s1,s3,8000188c <kill+0x20>
  }
  return -1;
    800018ae:	557d                	li	a0,-1
    800018b0:	a829                	j	800018ca <kill+0x5e>
      p->killed = 1;
    800018b2:	4785                	li	a5,1
    800018b4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018b6:	4c98                	lw	a4,24(s1)
    800018b8:	4789                	li	a5,2
    800018ba:	00f70f63          	beq	a4,a5,800018d8 <kill+0x6c>
      release(&p->lock);
    800018be:	8526                	mv	a0,s1
    800018c0:	00005097          	auipc	ra,0x5
    800018c4:	9da080e7          	jalr	-1574(ra) # 8000629a <release>
      return 0;
    800018c8:	4501                	li	a0,0
}
    800018ca:	70a2                	ld	ra,40(sp)
    800018cc:	7402                	ld	s0,32(sp)
    800018ce:	64e2                	ld	s1,24(sp)
    800018d0:	6942                	ld	s2,16(sp)
    800018d2:	69a2                	ld	s3,8(sp)
    800018d4:	6145                	addi	sp,sp,48
    800018d6:	8082                	ret
        p->state = RUNNABLE;
    800018d8:	478d                	li	a5,3
    800018da:	cc9c                	sw	a5,24(s1)
    800018dc:	b7cd                	j	800018be <kill+0x52>

00000000800018de <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018de:	7179                	addi	sp,sp,-48
    800018e0:	f406                	sd	ra,40(sp)
    800018e2:	f022                	sd	s0,32(sp)
    800018e4:	ec26                	sd	s1,24(sp)
    800018e6:	e84a                	sd	s2,16(sp)
    800018e8:	e44e                	sd	s3,8(sp)
    800018ea:	e052                	sd	s4,0(sp)
    800018ec:	1800                	addi	s0,sp,48
    800018ee:	84aa                	mv	s1,a0
    800018f0:	892e                	mv	s2,a1
    800018f2:	89b2                	mv	s3,a2
    800018f4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018f6:	fffff097          	auipc	ra,0xfffff
    800018fa:	552080e7          	jalr	1362(ra) # 80000e48 <myproc>
  if(user_dst){
    800018fe:	c08d                	beqz	s1,80001920 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001900:	86d2                	mv	a3,s4
    80001902:	864e                	mv	a2,s3
    80001904:	85ca                	mv	a1,s2
    80001906:	6928                	ld	a0,80(a0)
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	202080e7          	jalr	514(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001910:	70a2                	ld	ra,40(sp)
    80001912:	7402                	ld	s0,32(sp)
    80001914:	64e2                	ld	s1,24(sp)
    80001916:	6942                	ld	s2,16(sp)
    80001918:	69a2                	ld	s3,8(sp)
    8000191a:	6a02                	ld	s4,0(sp)
    8000191c:	6145                	addi	sp,sp,48
    8000191e:	8082                	ret
    memmove((char *)dst, src, len);
    80001920:	000a061b          	sext.w	a2,s4
    80001924:	85ce                	mv	a1,s3
    80001926:	854a                	mv	a0,s2
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	8b0080e7          	jalr	-1872(ra) # 800001d8 <memmove>
    return 0;
    80001930:	8526                	mv	a0,s1
    80001932:	bff9                	j	80001910 <either_copyout+0x32>

0000000080001934 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001934:	7179                	addi	sp,sp,-48
    80001936:	f406                	sd	ra,40(sp)
    80001938:	f022                	sd	s0,32(sp)
    8000193a:	ec26                	sd	s1,24(sp)
    8000193c:	e84a                	sd	s2,16(sp)
    8000193e:	e44e                	sd	s3,8(sp)
    80001940:	e052                	sd	s4,0(sp)
    80001942:	1800                	addi	s0,sp,48
    80001944:	892a                	mv	s2,a0
    80001946:	84ae                	mv	s1,a1
    80001948:	89b2                	mv	s3,a2
    8000194a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000194c:	fffff097          	auipc	ra,0xfffff
    80001950:	4fc080e7          	jalr	1276(ra) # 80000e48 <myproc>
  if(user_src){
    80001954:	c08d                	beqz	s1,80001976 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001956:	86d2                	mv	a3,s4
    80001958:	864e                	mv	a2,s3
    8000195a:	85ca                	mv	a1,s2
    8000195c:	6928                	ld	a0,80(a0)
    8000195e:	fffff097          	auipc	ra,0xfffff
    80001962:	238080e7          	jalr	568(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001966:	70a2                	ld	ra,40(sp)
    80001968:	7402                	ld	s0,32(sp)
    8000196a:	64e2                	ld	s1,24(sp)
    8000196c:	6942                	ld	s2,16(sp)
    8000196e:	69a2                	ld	s3,8(sp)
    80001970:	6a02                	ld	s4,0(sp)
    80001972:	6145                	addi	sp,sp,48
    80001974:	8082                	ret
    memmove(dst, (char*)src, len);
    80001976:	000a061b          	sext.w	a2,s4
    8000197a:	85ce                	mv	a1,s3
    8000197c:	854a                	mv	a0,s2
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	85a080e7          	jalr	-1958(ra) # 800001d8 <memmove>
    return 0;
    80001986:	8526                	mv	a0,s1
    80001988:	bff9                	j	80001966 <either_copyin+0x32>

000000008000198a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000198a:	715d                	addi	sp,sp,-80
    8000198c:	e486                	sd	ra,72(sp)
    8000198e:	e0a2                	sd	s0,64(sp)
    80001990:	fc26                	sd	s1,56(sp)
    80001992:	f84a                	sd	s2,48(sp)
    80001994:	f44e                	sd	s3,40(sp)
    80001996:	f052                	sd	s4,32(sp)
    80001998:	ec56                	sd	s5,24(sp)
    8000199a:	e85a                	sd	s6,16(sp)
    8000199c:	e45e                	sd	s7,8(sp)
    8000199e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019a0:	00006517          	auipc	a0,0x6
    800019a4:	6a850513          	addi	a0,a0,1704 # 80008048 <etext+0x48>
    800019a8:	00004097          	auipc	ra,0x4
    800019ac:	370080e7          	jalr	880(ra) # 80005d18 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019b0:	00008497          	auipc	s1,0x8
    800019b4:	c2848493          	addi	s1,s1,-984 # 800095d8 <proc+0x158>
    800019b8:	0000e917          	auipc	s2,0xe
    800019bc:	e2090913          	addi	s2,s2,-480 # 8000f7d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019c0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019c2:	00007997          	auipc	s3,0x7
    800019c6:	83e98993          	addi	s3,s3,-1986 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019ca:	00007a97          	auipc	s5,0x7
    800019ce:	83ea8a93          	addi	s5,s5,-1986 # 80008208 <etext+0x208>
    printf("\n");
    800019d2:	00006a17          	auipc	s4,0x6
    800019d6:	676a0a13          	addi	s4,s4,1654 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019da:	00007b97          	auipc	s7,0x7
    800019de:	866b8b93          	addi	s7,s7,-1946 # 80008240 <states.1717>
    800019e2:	a00d                	j	80001a04 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019e4:	ed86a583          	lw	a1,-296(a3)
    800019e8:	8556                	mv	a0,s5
    800019ea:	00004097          	auipc	ra,0x4
    800019ee:	32e080e7          	jalr	814(ra) # 80005d18 <printf>
    printf("\n");
    800019f2:	8552                	mv	a0,s4
    800019f4:	00004097          	auipc	ra,0x4
    800019f8:	324080e7          	jalr	804(ra) # 80005d18 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019fc:	18848493          	addi	s1,s1,392
    80001a00:	03248163          	beq	s1,s2,80001a22 <procdump+0x98>
    if(p->state == UNUSED)
    80001a04:	86a6                	mv	a3,s1
    80001a06:	ec04a783          	lw	a5,-320(s1)
    80001a0a:	dbed                	beqz	a5,800019fc <procdump+0x72>
      state = "???";
    80001a0c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a0e:	fcfb6be3          	bltu	s6,a5,800019e4 <procdump+0x5a>
    80001a12:	1782                	slli	a5,a5,0x20
    80001a14:	9381                	srli	a5,a5,0x20
    80001a16:	078e                	slli	a5,a5,0x3
    80001a18:	97de                	add	a5,a5,s7
    80001a1a:	6390                	ld	a2,0(a5)
    80001a1c:	f661                	bnez	a2,800019e4 <procdump+0x5a>
      state = "???";
    80001a1e:	864e                	mv	a2,s3
    80001a20:	b7d1                	j	800019e4 <procdump+0x5a>
  }
}
    80001a22:	60a6                	ld	ra,72(sp)
    80001a24:	6406                	ld	s0,64(sp)
    80001a26:	74e2                	ld	s1,56(sp)
    80001a28:	7942                	ld	s2,48(sp)
    80001a2a:	79a2                	ld	s3,40(sp)
    80001a2c:	7a02                	ld	s4,32(sp)
    80001a2e:	6ae2                	ld	s5,24(sp)
    80001a30:	6b42                	ld	s6,16(sp)
    80001a32:	6ba2                	ld	s7,8(sp)
    80001a34:	6161                	addi	sp,sp,80
    80001a36:	8082                	ret

0000000080001a38 <swtch>:
    80001a38:	00153023          	sd	ra,0(a0)
    80001a3c:	00253423          	sd	sp,8(a0)
    80001a40:	e900                	sd	s0,16(a0)
    80001a42:	ed04                	sd	s1,24(a0)
    80001a44:	03253023          	sd	s2,32(a0)
    80001a48:	03353423          	sd	s3,40(a0)
    80001a4c:	03453823          	sd	s4,48(a0)
    80001a50:	03553c23          	sd	s5,56(a0)
    80001a54:	05653023          	sd	s6,64(a0)
    80001a58:	05753423          	sd	s7,72(a0)
    80001a5c:	05853823          	sd	s8,80(a0)
    80001a60:	05953c23          	sd	s9,88(a0)
    80001a64:	07a53023          	sd	s10,96(a0)
    80001a68:	07b53423          	sd	s11,104(a0)
    80001a6c:	0005b083          	ld	ra,0(a1)
    80001a70:	0085b103          	ld	sp,8(a1)
    80001a74:	6980                	ld	s0,16(a1)
    80001a76:	6d84                	ld	s1,24(a1)
    80001a78:	0205b903          	ld	s2,32(a1)
    80001a7c:	0285b983          	ld	s3,40(a1)
    80001a80:	0305ba03          	ld	s4,48(a1)
    80001a84:	0385ba83          	ld	s5,56(a1)
    80001a88:	0405bb03          	ld	s6,64(a1)
    80001a8c:	0485bb83          	ld	s7,72(a1)
    80001a90:	0505bc03          	ld	s8,80(a1)
    80001a94:	0585bc83          	ld	s9,88(a1)
    80001a98:	0605bd03          	ld	s10,96(a1)
    80001a9c:	0685bd83          	ld	s11,104(a1)
    80001aa0:	8082                	ret

0000000080001aa2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001aa2:	1141                	addi	sp,sp,-16
    80001aa4:	e406                	sd	ra,8(sp)
    80001aa6:	e022                	sd	s0,0(sp)
    80001aa8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001aaa:	00006597          	auipc	a1,0x6
    80001aae:	7c658593          	addi	a1,a1,1990 # 80008270 <states.1717+0x30>
    80001ab2:	0000e517          	auipc	a0,0xe
    80001ab6:	bce50513          	addi	a0,a0,-1074 # 8000f680 <tickslock>
    80001aba:	00004097          	auipc	ra,0x4
    80001abe:	69c080e7          	jalr	1692(ra) # 80006156 <initlock>
}
    80001ac2:	60a2                	ld	ra,8(sp)
    80001ac4:	6402                	ld	s0,0(sp)
    80001ac6:	0141                	addi	sp,sp,16
    80001ac8:	8082                	ret

0000000080001aca <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aca:	1141                	addi	sp,sp,-16
    80001acc:	e422                	sd	s0,8(sp)
    80001ace:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ad0:	00003797          	auipc	a5,0x3
    80001ad4:	57078793          	addi	a5,a5,1392 # 80005040 <kernelvec>
    80001ad8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001adc:	6422                	ld	s0,8(sp)
    80001ade:	0141                	addi	sp,sp,16
    80001ae0:	8082                	ret

0000000080001ae2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ae2:	1141                	addi	sp,sp,-16
    80001ae4:	e406                	sd	ra,8(sp)
    80001ae6:	e022                	sd	s0,0(sp)
    80001ae8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001aea:	fffff097          	auipc	ra,0xfffff
    80001aee:	35e080e7          	jalr	862(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001af2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001af6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001af8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001afc:	00005617          	auipc	a2,0x5
    80001b00:	50460613          	addi	a2,a2,1284 # 80007000 <_trampoline>
    80001b04:	00005697          	auipc	a3,0x5
    80001b08:	4fc68693          	addi	a3,a3,1276 # 80007000 <_trampoline>
    80001b0c:	8e91                	sub	a3,a3,a2
    80001b0e:	040007b7          	lui	a5,0x4000
    80001b12:	17fd                	addi	a5,a5,-1
    80001b14:	07b2                	slli	a5,a5,0xc
    80001b16:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b18:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b1c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b1e:	180026f3          	csrr	a3,satp
    80001b22:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b24:	6d38                	ld	a4,88(a0)
    80001b26:	6134                	ld	a3,64(a0)
    80001b28:	6585                	lui	a1,0x1
    80001b2a:	96ae                	add	a3,a3,a1
    80001b2c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b2e:	6d38                	ld	a4,88(a0)
    80001b30:	00000697          	auipc	a3,0x0
    80001b34:	13868693          	addi	a3,a3,312 # 80001c68 <usertrap>
    80001b38:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b3a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b3c:	8692                	mv	a3,tp
    80001b3e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b40:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b44:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b48:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b4c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b50:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b52:	6f18                	ld	a4,24(a4)
    80001b54:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b58:	692c                	ld	a1,80(a0)
    80001b5a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b5c:	00005717          	auipc	a4,0x5
    80001b60:	53470713          	addi	a4,a4,1332 # 80007090 <userret>
    80001b64:	8f11                	sub	a4,a4,a2
    80001b66:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b68:	577d                	li	a4,-1
    80001b6a:	177e                	slli	a4,a4,0x3f
    80001b6c:	8dd9                	or	a1,a1,a4
    80001b6e:	02000537          	lui	a0,0x2000
    80001b72:	157d                	addi	a0,a0,-1
    80001b74:	0536                	slli	a0,a0,0xd
    80001b76:	9782                	jalr	a5
}
    80001b78:	60a2                	ld	ra,8(sp)
    80001b7a:	6402                	ld	s0,0(sp)
    80001b7c:	0141                	addi	sp,sp,16
    80001b7e:	8082                	ret

0000000080001b80 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b80:	1101                	addi	sp,sp,-32
    80001b82:	ec06                	sd	ra,24(sp)
    80001b84:	e822                	sd	s0,16(sp)
    80001b86:	e426                	sd	s1,8(sp)
    80001b88:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b8a:	0000e497          	auipc	s1,0xe
    80001b8e:	af648493          	addi	s1,s1,-1290 # 8000f680 <tickslock>
    80001b92:	8526                	mv	a0,s1
    80001b94:	00004097          	auipc	ra,0x4
    80001b98:	652080e7          	jalr	1618(ra) # 800061e6 <acquire>
  ticks++;
    80001b9c:	00007517          	auipc	a0,0x7
    80001ba0:	47c50513          	addi	a0,a0,1148 # 80009018 <ticks>
    80001ba4:	411c                	lw	a5,0(a0)
    80001ba6:	2785                	addiw	a5,a5,1
    80001ba8:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001baa:	00000097          	auipc	ra,0x0
    80001bae:	b1c080e7          	jalr	-1252(ra) # 800016c6 <wakeup>
  release(&tickslock);
    80001bb2:	8526                	mv	a0,s1
    80001bb4:	00004097          	auipc	ra,0x4
    80001bb8:	6e6080e7          	jalr	1766(ra) # 8000629a <release>
}
    80001bbc:	60e2                	ld	ra,24(sp)
    80001bbe:	6442                	ld	s0,16(sp)
    80001bc0:	64a2                	ld	s1,8(sp)
    80001bc2:	6105                	addi	sp,sp,32
    80001bc4:	8082                	ret

0000000080001bc6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bc6:	1101                	addi	sp,sp,-32
    80001bc8:	ec06                	sd	ra,24(sp)
    80001bca:	e822                	sd	s0,16(sp)
    80001bcc:	e426                	sd	s1,8(sp)
    80001bce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bd0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bd4:	00074d63          	bltz	a4,80001bee <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bd8:	57fd                	li	a5,-1
    80001bda:	17fe                	slli	a5,a5,0x3f
    80001bdc:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bde:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001be0:	06f70363          	beq	a4,a5,80001c46 <devintr+0x80>
  }
}
    80001be4:	60e2                	ld	ra,24(sp)
    80001be6:	6442                	ld	s0,16(sp)
    80001be8:	64a2                	ld	s1,8(sp)
    80001bea:	6105                	addi	sp,sp,32
    80001bec:	8082                	ret
     (scause & 0xff) == 9){
    80001bee:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bf2:	46a5                	li	a3,9
    80001bf4:	fed792e3          	bne	a5,a3,80001bd8 <devintr+0x12>
    int irq = plic_claim();
    80001bf8:	00003097          	auipc	ra,0x3
    80001bfc:	550080e7          	jalr	1360(ra) # 80005148 <plic_claim>
    80001c00:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c02:	47a9                	li	a5,10
    80001c04:	02f50763          	beq	a0,a5,80001c32 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c08:	4785                	li	a5,1
    80001c0a:	02f50963          	beq	a0,a5,80001c3c <devintr+0x76>
    return 1;
    80001c0e:	4505                	li	a0,1
    } else if(irq){
    80001c10:	d8f1                	beqz	s1,80001be4 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c12:	85a6                	mv	a1,s1
    80001c14:	00006517          	auipc	a0,0x6
    80001c18:	66450513          	addi	a0,a0,1636 # 80008278 <states.1717+0x38>
    80001c1c:	00004097          	auipc	ra,0x4
    80001c20:	0fc080e7          	jalr	252(ra) # 80005d18 <printf>
      plic_complete(irq);
    80001c24:	8526                	mv	a0,s1
    80001c26:	00003097          	auipc	ra,0x3
    80001c2a:	546080e7          	jalr	1350(ra) # 8000516c <plic_complete>
    return 1;
    80001c2e:	4505                	li	a0,1
    80001c30:	bf55                	j	80001be4 <devintr+0x1e>
      uartintr();
    80001c32:	00004097          	auipc	ra,0x4
    80001c36:	4d4080e7          	jalr	1236(ra) # 80006106 <uartintr>
    80001c3a:	b7ed                	j	80001c24 <devintr+0x5e>
      virtio_disk_intr();
    80001c3c:	00004097          	auipc	ra,0x4
    80001c40:	a10080e7          	jalr	-1520(ra) # 8000564c <virtio_disk_intr>
    80001c44:	b7c5                	j	80001c24 <devintr+0x5e>
    if(cpuid() == 0){
    80001c46:	fffff097          	auipc	ra,0xfffff
    80001c4a:	1d6080e7          	jalr	470(ra) # 80000e1c <cpuid>
    80001c4e:	c901                	beqz	a0,80001c5e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c50:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c54:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c56:	14479073          	csrw	sip,a5
    return 2;
    80001c5a:	4509                	li	a0,2
    80001c5c:	b761                	j	80001be4 <devintr+0x1e>
      clockintr();
    80001c5e:	00000097          	auipc	ra,0x0
    80001c62:	f22080e7          	jalr	-222(ra) # 80001b80 <clockintr>
    80001c66:	b7ed                	j	80001c50 <devintr+0x8a>

0000000080001c68 <usertrap>:
{
    80001c68:	1101                	addi	sp,sp,-32
    80001c6a:	ec06                	sd	ra,24(sp)
    80001c6c:	e822                	sd	s0,16(sp)
    80001c6e:	e426                	sd	s1,8(sp)
    80001c70:	e04a                	sd	s2,0(sp)
    80001c72:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c74:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c78:	1007f793          	andi	a5,a5,256
    80001c7c:	e3ad                	bnez	a5,80001cde <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c7e:	00003797          	auipc	a5,0x3
    80001c82:	3c278793          	addi	a5,a5,962 # 80005040 <kernelvec>
    80001c86:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	1be080e7          	jalr	446(ra) # 80000e48 <myproc>
    80001c92:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c94:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c96:	14102773          	csrr	a4,sepc
    80001c9a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c9c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ca0:	47a1                	li	a5,8
    80001ca2:	04f71c63          	bne	a4,a5,80001cfa <usertrap+0x92>
    if(p->killed)
    80001ca6:	551c                	lw	a5,40(a0)
    80001ca8:	e3b9                	bnez	a5,80001cee <usertrap+0x86>
    p->trapframe->epc += 4;
    80001caa:	6cb8                	ld	a4,88(s1)
    80001cac:	6f1c                	ld	a5,24(a4)
    80001cae:	0791                	addi	a5,a5,4
    80001cb0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cb2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cb6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cba:	10079073          	csrw	sstatus,a5
    syscall();
    80001cbe:	00000097          	auipc	ra,0x0
    80001cc2:	31a080e7          	jalr	794(ra) # 80001fd8 <syscall>
  if(p->killed)
    80001cc6:	549c                	lw	a5,40(s1)
    80001cc8:	e7c5                	bnez	a5,80001d70 <usertrap+0x108>
  usertrapret();
    80001cca:	00000097          	auipc	ra,0x0
    80001cce:	e18080e7          	jalr	-488(ra) # 80001ae2 <usertrapret>
}
    80001cd2:	60e2                	ld	ra,24(sp)
    80001cd4:	6442                	ld	s0,16(sp)
    80001cd6:	64a2                	ld	s1,8(sp)
    80001cd8:	6902                	ld	s2,0(sp)
    80001cda:	6105                	addi	sp,sp,32
    80001cdc:	8082                	ret
    panic("usertrap: not from user mode");
    80001cde:	00006517          	auipc	a0,0x6
    80001ce2:	5ba50513          	addi	a0,a0,1466 # 80008298 <states.1717+0x58>
    80001ce6:	00004097          	auipc	ra,0x4
    80001cea:	fe0080e7          	jalr	-32(ra) # 80005cc6 <panic>
      exit(-1);
    80001cee:	557d                	li	a0,-1
    80001cf0:	00000097          	auipc	ra,0x0
    80001cf4:	aa6080e7          	jalr	-1370(ra) # 80001796 <exit>
    80001cf8:	bf4d                	j	80001caa <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cfa:	00000097          	auipc	ra,0x0
    80001cfe:	ecc080e7          	jalr	-308(ra) # 80001bc6 <devintr>
    80001d02:	892a                	mv	s2,a0
    80001d04:	c501                	beqz	a0,80001d0c <usertrap+0xa4>
  if(p->killed)
    80001d06:	549c                	lw	a5,40(s1)
    80001d08:	c3a1                	beqz	a5,80001d48 <usertrap+0xe0>
    80001d0a:	a815                	j	80001d3e <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d0c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d10:	5890                	lw	a2,48(s1)
    80001d12:	00006517          	auipc	a0,0x6
    80001d16:	5a650513          	addi	a0,a0,1446 # 800082b8 <states.1717+0x78>
    80001d1a:	00004097          	auipc	ra,0x4
    80001d1e:	ffe080e7          	jalr	-2(ra) # 80005d18 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d22:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d26:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d2a:	00006517          	auipc	a0,0x6
    80001d2e:	5be50513          	addi	a0,a0,1470 # 800082e8 <states.1717+0xa8>
    80001d32:	00004097          	auipc	ra,0x4
    80001d36:	fe6080e7          	jalr	-26(ra) # 80005d18 <printf>
    p->killed = 1;
    80001d3a:	4785                	li	a5,1
    80001d3c:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d3e:	557d                	li	a0,-1
    80001d40:	00000097          	auipc	ra,0x0
    80001d44:	a56080e7          	jalr	-1450(ra) # 80001796 <exit>
  if(which_dev == 2){   // timer interrupt
    80001d48:	4789                	li	a5,2
    80001d4a:	f8f910e3          	bne	s2,a5,80001cca <usertrap+0x62>
    if(p->interval != 0 && ++p->passedticks == p->interval){  
    80001d4e:	1684a783          	lw	a5,360(s1)
    80001d52:	cb91                	beqz	a5,80001d66 <usertrap+0xfe>
    80001d54:	1784a703          	lw	a4,376(s1)
    80001d58:	2705                	addiw	a4,a4,1
    80001d5a:	0007069b          	sext.w	a3,a4
    80001d5e:	16e4ac23          	sw	a4,376(s1)
    80001d62:	00d78963          	beq	a5,a3,80001d74 <usertrap+0x10c>
    yield();
    80001d66:	fffff097          	auipc	ra,0xfffff
    80001d6a:	798080e7          	jalr	1944(ra) # 800014fe <yield>
    80001d6e:	bfb1                	j	80001cca <usertrap+0x62>
  int which_dev = 0;
    80001d70:	4901                	li	s2,0
    80001d72:	b7f1                	j	80001d3e <usertrap+0xd6>
      p->trapframecopy = p->trapframe + 512;  
    80001d74:	6cac                	ld	a1,88(s1)
    80001d76:	00024537          	lui	a0,0x24
    80001d7a:	952e                	add	a0,a0,a1
    80001d7c:	18a4b023          	sd	a0,384(s1)
      memmove(p->trapframecopy,p->trapframe,sizeof(struct trapframe));    // copy trapframe
    80001d80:	12000613          	li	a2,288
    80001d84:	ffffe097          	auipc	ra,0xffffe
    80001d88:	454080e7          	jalr	1108(ra) # 800001d8 <memmove>
      p->trapframe->epc = p->handler;   // execute handler() when return to user space
    80001d8c:	6cbc                	ld	a5,88(s1)
    80001d8e:	1704b703          	ld	a4,368(s1)
    80001d92:	ef98                	sd	a4,24(a5)
    80001d94:	bfc9                	j	80001d66 <usertrap+0xfe>

0000000080001d96 <kerneltrap>:
{
    80001d96:	7179                	addi	sp,sp,-48
    80001d98:	f406                	sd	ra,40(sp)
    80001d9a:	f022                	sd	s0,32(sp)
    80001d9c:	ec26                	sd	s1,24(sp)
    80001d9e:	e84a                	sd	s2,16(sp)
    80001da0:	e44e                	sd	s3,8(sp)
    80001da2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001da4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dac:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001db0:	1004f793          	andi	a5,s1,256
    80001db4:	cb85                	beqz	a5,80001de4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001db6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001dba:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dbc:	ef85                	bnez	a5,80001df4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dbe:	00000097          	auipc	ra,0x0
    80001dc2:	e08080e7          	jalr	-504(ra) # 80001bc6 <devintr>
    80001dc6:	cd1d                	beqz	a0,80001e04 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001dc8:	4789                	li	a5,2
    80001dca:	06f50a63          	beq	a0,a5,80001e3e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dce:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dd2:	10049073          	csrw	sstatus,s1
}
    80001dd6:	70a2                	ld	ra,40(sp)
    80001dd8:	7402                	ld	s0,32(sp)
    80001dda:	64e2                	ld	s1,24(sp)
    80001ddc:	6942                	ld	s2,16(sp)
    80001dde:	69a2                	ld	s3,8(sp)
    80001de0:	6145                	addi	sp,sp,48
    80001de2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001de4:	00006517          	auipc	a0,0x6
    80001de8:	52450513          	addi	a0,a0,1316 # 80008308 <states.1717+0xc8>
    80001dec:	00004097          	auipc	ra,0x4
    80001df0:	eda080e7          	jalr	-294(ra) # 80005cc6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001df4:	00006517          	auipc	a0,0x6
    80001df8:	53c50513          	addi	a0,a0,1340 # 80008330 <states.1717+0xf0>
    80001dfc:	00004097          	auipc	ra,0x4
    80001e00:	eca080e7          	jalr	-310(ra) # 80005cc6 <panic>
    printf("scause %p\n", scause);
    80001e04:	85ce                	mv	a1,s3
    80001e06:	00006517          	auipc	a0,0x6
    80001e0a:	54a50513          	addi	a0,a0,1354 # 80008350 <states.1717+0x110>
    80001e0e:	00004097          	auipc	ra,0x4
    80001e12:	f0a080e7          	jalr	-246(ra) # 80005d18 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e16:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e1a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e1e:	00006517          	auipc	a0,0x6
    80001e22:	54250513          	addi	a0,a0,1346 # 80008360 <states.1717+0x120>
    80001e26:	00004097          	auipc	ra,0x4
    80001e2a:	ef2080e7          	jalr	-270(ra) # 80005d18 <printf>
    panic("kerneltrap");
    80001e2e:	00006517          	auipc	a0,0x6
    80001e32:	54a50513          	addi	a0,a0,1354 # 80008378 <states.1717+0x138>
    80001e36:	00004097          	auipc	ra,0x4
    80001e3a:	e90080e7          	jalr	-368(ra) # 80005cc6 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e3e:	fffff097          	auipc	ra,0xfffff
    80001e42:	00a080e7          	jalr	10(ra) # 80000e48 <myproc>
    80001e46:	d541                	beqz	a0,80001dce <kerneltrap+0x38>
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	000080e7          	jalr	ra # 80000e48 <myproc>
    80001e50:	4d18                	lw	a4,24(a0)
    80001e52:	4791                	li	a5,4
    80001e54:	f6f71de3          	bne	a4,a5,80001dce <kerneltrap+0x38>
    yield();
    80001e58:	fffff097          	auipc	ra,0xfffff
    80001e5c:	6a6080e7          	jalr	1702(ra) # 800014fe <yield>
    80001e60:	b7bd                	j	80001dce <kerneltrap+0x38>

0000000080001e62 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e62:	1101                	addi	sp,sp,-32
    80001e64:	ec06                	sd	ra,24(sp)
    80001e66:	e822                	sd	s0,16(sp)
    80001e68:	e426                	sd	s1,8(sp)
    80001e6a:	1000                	addi	s0,sp,32
    80001e6c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	fda080e7          	jalr	-38(ra) # 80000e48 <myproc>
  switch (n) {
    80001e76:	4795                	li	a5,5
    80001e78:	0497e163          	bltu	a5,s1,80001eba <argraw+0x58>
    80001e7c:	048a                	slli	s1,s1,0x2
    80001e7e:	00006717          	auipc	a4,0x6
    80001e82:	53270713          	addi	a4,a4,1330 # 800083b0 <states.1717+0x170>
    80001e86:	94ba                	add	s1,s1,a4
    80001e88:	409c                	lw	a5,0(s1)
    80001e8a:	97ba                	add	a5,a5,a4
    80001e8c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e8e:	6d3c                	ld	a5,88(a0)
    80001e90:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e92:	60e2                	ld	ra,24(sp)
    80001e94:	6442                	ld	s0,16(sp)
    80001e96:	64a2                	ld	s1,8(sp)
    80001e98:	6105                	addi	sp,sp,32
    80001e9a:	8082                	ret
    return p->trapframe->a1;
    80001e9c:	6d3c                	ld	a5,88(a0)
    80001e9e:	7fa8                	ld	a0,120(a5)
    80001ea0:	bfcd                	j	80001e92 <argraw+0x30>
    return p->trapframe->a2;
    80001ea2:	6d3c                	ld	a5,88(a0)
    80001ea4:	63c8                	ld	a0,128(a5)
    80001ea6:	b7f5                	j	80001e92 <argraw+0x30>
    return p->trapframe->a3;
    80001ea8:	6d3c                	ld	a5,88(a0)
    80001eaa:	67c8                	ld	a0,136(a5)
    80001eac:	b7dd                	j	80001e92 <argraw+0x30>
    return p->trapframe->a4;
    80001eae:	6d3c                	ld	a5,88(a0)
    80001eb0:	6bc8                	ld	a0,144(a5)
    80001eb2:	b7c5                	j	80001e92 <argraw+0x30>
    return p->trapframe->a5;
    80001eb4:	6d3c                	ld	a5,88(a0)
    80001eb6:	6fc8                	ld	a0,152(a5)
    80001eb8:	bfe9                	j	80001e92 <argraw+0x30>
  panic("argraw");
    80001eba:	00006517          	auipc	a0,0x6
    80001ebe:	4ce50513          	addi	a0,a0,1230 # 80008388 <states.1717+0x148>
    80001ec2:	00004097          	auipc	ra,0x4
    80001ec6:	e04080e7          	jalr	-508(ra) # 80005cc6 <panic>

0000000080001eca <fetchaddr>:
{
    80001eca:	1101                	addi	sp,sp,-32
    80001ecc:	ec06                	sd	ra,24(sp)
    80001ece:	e822                	sd	s0,16(sp)
    80001ed0:	e426                	sd	s1,8(sp)
    80001ed2:	e04a                	sd	s2,0(sp)
    80001ed4:	1000                	addi	s0,sp,32
    80001ed6:	84aa                	mv	s1,a0
    80001ed8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eda:	fffff097          	auipc	ra,0xfffff
    80001ede:	f6e080e7          	jalr	-146(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ee2:	653c                	ld	a5,72(a0)
    80001ee4:	02f4f863          	bgeu	s1,a5,80001f14 <fetchaddr+0x4a>
    80001ee8:	00848713          	addi	a4,s1,8
    80001eec:	02e7e663          	bltu	a5,a4,80001f18 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ef0:	46a1                	li	a3,8
    80001ef2:	8626                	mv	a2,s1
    80001ef4:	85ca                	mv	a1,s2
    80001ef6:	6928                	ld	a0,80(a0)
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	c9e080e7          	jalr	-866(ra) # 80000b96 <copyin>
    80001f00:	00a03533          	snez	a0,a0
    80001f04:	40a00533          	neg	a0,a0
}
    80001f08:	60e2                	ld	ra,24(sp)
    80001f0a:	6442                	ld	s0,16(sp)
    80001f0c:	64a2                	ld	s1,8(sp)
    80001f0e:	6902                	ld	s2,0(sp)
    80001f10:	6105                	addi	sp,sp,32
    80001f12:	8082                	ret
    return -1;
    80001f14:	557d                	li	a0,-1
    80001f16:	bfcd                	j	80001f08 <fetchaddr+0x3e>
    80001f18:	557d                	li	a0,-1
    80001f1a:	b7fd                	j	80001f08 <fetchaddr+0x3e>

0000000080001f1c <fetchstr>:
{
    80001f1c:	7179                	addi	sp,sp,-48
    80001f1e:	f406                	sd	ra,40(sp)
    80001f20:	f022                	sd	s0,32(sp)
    80001f22:	ec26                	sd	s1,24(sp)
    80001f24:	e84a                	sd	s2,16(sp)
    80001f26:	e44e                	sd	s3,8(sp)
    80001f28:	1800                	addi	s0,sp,48
    80001f2a:	892a                	mv	s2,a0
    80001f2c:	84ae                	mv	s1,a1
    80001f2e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	f18080e7          	jalr	-232(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f38:	86ce                	mv	a3,s3
    80001f3a:	864a                	mv	a2,s2
    80001f3c:	85a6                	mv	a1,s1
    80001f3e:	6928                	ld	a0,80(a0)
    80001f40:	fffff097          	auipc	ra,0xfffff
    80001f44:	ce2080e7          	jalr	-798(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001f48:	00054763          	bltz	a0,80001f56 <fetchstr+0x3a>
  return strlen(buf);
    80001f4c:	8526                	mv	a0,s1
    80001f4e:	ffffe097          	auipc	ra,0xffffe
    80001f52:	3ae080e7          	jalr	942(ra) # 800002fc <strlen>
}
    80001f56:	70a2                	ld	ra,40(sp)
    80001f58:	7402                	ld	s0,32(sp)
    80001f5a:	64e2                	ld	s1,24(sp)
    80001f5c:	6942                	ld	s2,16(sp)
    80001f5e:	69a2                	ld	s3,8(sp)
    80001f60:	6145                	addi	sp,sp,48
    80001f62:	8082                	ret

0000000080001f64 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f64:	1101                	addi	sp,sp,-32
    80001f66:	ec06                	sd	ra,24(sp)
    80001f68:	e822                	sd	s0,16(sp)
    80001f6a:	e426                	sd	s1,8(sp)
    80001f6c:	1000                	addi	s0,sp,32
    80001f6e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f70:	00000097          	auipc	ra,0x0
    80001f74:	ef2080e7          	jalr	-270(ra) # 80001e62 <argraw>
    80001f78:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f7a:	4501                	li	a0,0
    80001f7c:	60e2                	ld	ra,24(sp)
    80001f7e:	6442                	ld	s0,16(sp)
    80001f80:	64a2                	ld	s1,8(sp)
    80001f82:	6105                	addi	sp,sp,32
    80001f84:	8082                	ret

0000000080001f86 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f86:	1101                	addi	sp,sp,-32
    80001f88:	ec06                	sd	ra,24(sp)
    80001f8a:	e822                	sd	s0,16(sp)
    80001f8c:	e426                	sd	s1,8(sp)
    80001f8e:	1000                	addi	s0,sp,32
    80001f90:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f92:	00000097          	auipc	ra,0x0
    80001f96:	ed0080e7          	jalr	-304(ra) # 80001e62 <argraw>
    80001f9a:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f9c:	4501                	li	a0,0
    80001f9e:	60e2                	ld	ra,24(sp)
    80001fa0:	6442                	ld	s0,16(sp)
    80001fa2:	64a2                	ld	s1,8(sp)
    80001fa4:	6105                	addi	sp,sp,32
    80001fa6:	8082                	ret

0000000080001fa8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001fa8:	1101                	addi	sp,sp,-32
    80001faa:	ec06                	sd	ra,24(sp)
    80001fac:	e822                	sd	s0,16(sp)
    80001fae:	e426                	sd	s1,8(sp)
    80001fb0:	e04a                	sd	s2,0(sp)
    80001fb2:	1000                	addi	s0,sp,32
    80001fb4:	84ae                	mv	s1,a1
    80001fb6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fb8:	00000097          	auipc	ra,0x0
    80001fbc:	eaa080e7          	jalr	-342(ra) # 80001e62 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fc0:	864a                	mv	a2,s2
    80001fc2:	85a6                	mv	a1,s1
    80001fc4:	00000097          	auipc	ra,0x0
    80001fc8:	f58080e7          	jalr	-168(ra) # 80001f1c <fetchstr>
}
    80001fcc:	60e2                	ld	ra,24(sp)
    80001fce:	6442                	ld	s0,16(sp)
    80001fd0:	64a2                	ld	s1,8(sp)
    80001fd2:	6902                	ld	s2,0(sp)
    80001fd4:	6105                	addi	sp,sp,32
    80001fd6:	8082                	ret

0000000080001fd8 <syscall>:
[SYS_sigreturn] sys_sigreturn,
};

void
syscall(void)
{
    80001fd8:	1101                	addi	sp,sp,-32
    80001fda:	ec06                	sd	ra,24(sp)
    80001fdc:	e822                	sd	s0,16(sp)
    80001fde:	e426                	sd	s1,8(sp)
    80001fe0:	e04a                	sd	s2,0(sp)
    80001fe2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fe4:	fffff097          	auipc	ra,0xfffff
    80001fe8:	e64080e7          	jalr	-412(ra) # 80000e48 <myproc>
    80001fec:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fee:	05853903          	ld	s2,88(a0)
    80001ff2:	0a893783          	ld	a5,168(s2)
    80001ff6:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001ffa:	37fd                	addiw	a5,a5,-1
    80001ffc:	4759                	li	a4,22
    80001ffe:	00f76f63          	bltu	a4,a5,8000201c <syscall+0x44>
    80002002:	00369713          	slli	a4,a3,0x3
    80002006:	00006797          	auipc	a5,0x6
    8000200a:	3c278793          	addi	a5,a5,962 # 800083c8 <syscalls>
    8000200e:	97ba                	add	a5,a5,a4
    80002010:	639c                	ld	a5,0(a5)
    80002012:	c789                	beqz	a5,8000201c <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002014:	9782                	jalr	a5
    80002016:	06a93823          	sd	a0,112(s2)
    8000201a:	a839                	j	80002038 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000201c:	15848613          	addi	a2,s1,344
    80002020:	588c                	lw	a1,48(s1)
    80002022:	00006517          	auipc	a0,0x6
    80002026:	36e50513          	addi	a0,a0,878 # 80008390 <states.1717+0x150>
    8000202a:	00004097          	auipc	ra,0x4
    8000202e:	cee080e7          	jalr	-786(ra) # 80005d18 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002032:	6cbc                	ld	a5,88(s1)
    80002034:	577d                	li	a4,-1
    80002036:	fbb8                	sd	a4,112(a5)
  }
}
    80002038:	60e2                	ld	ra,24(sp)
    8000203a:	6442                	ld	s0,16(sp)
    8000203c:	64a2                	ld	s1,8(sp)
    8000203e:	6902                	ld	s2,0(sp)
    80002040:	6105                	addi	sp,sp,32
    80002042:	8082                	ret

0000000080002044 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002044:	1101                	addi	sp,sp,-32
    80002046:	ec06                	sd	ra,24(sp)
    80002048:	e822                	sd	s0,16(sp)
    8000204a:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000204c:	fec40593          	addi	a1,s0,-20
    80002050:	4501                	li	a0,0
    80002052:	00000097          	auipc	ra,0x0
    80002056:	f12080e7          	jalr	-238(ra) # 80001f64 <argint>
    return -1;
    8000205a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000205c:	00054963          	bltz	a0,8000206e <sys_exit+0x2a>
  exit(n);
    80002060:	fec42503          	lw	a0,-20(s0)
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	732080e7          	jalr	1842(ra) # 80001796 <exit>
  return 0;  // not reached
    8000206c:	4781                	li	a5,0
}
    8000206e:	853e                	mv	a0,a5
    80002070:	60e2                	ld	ra,24(sp)
    80002072:	6442                	ld	s0,16(sp)
    80002074:	6105                	addi	sp,sp,32
    80002076:	8082                	ret

0000000080002078 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002078:	1141                	addi	sp,sp,-16
    8000207a:	e406                	sd	ra,8(sp)
    8000207c:	e022                	sd	s0,0(sp)
    8000207e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002080:	fffff097          	auipc	ra,0xfffff
    80002084:	dc8080e7          	jalr	-568(ra) # 80000e48 <myproc>
}
    80002088:	5908                	lw	a0,48(a0)
    8000208a:	60a2                	ld	ra,8(sp)
    8000208c:	6402                	ld	s0,0(sp)
    8000208e:	0141                	addi	sp,sp,16
    80002090:	8082                	ret

0000000080002092 <sys_fork>:

uint64
sys_fork(void)
{
    80002092:	1141                	addi	sp,sp,-16
    80002094:	e406                	sd	ra,8(sp)
    80002096:	e022                	sd	s0,0(sp)
    80002098:	0800                	addi	s0,sp,16
  return fork();
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	1b2080e7          	jalr	434(ra) # 8000124c <fork>
}
    800020a2:	60a2                	ld	ra,8(sp)
    800020a4:	6402                	ld	s0,0(sp)
    800020a6:	0141                	addi	sp,sp,16
    800020a8:	8082                	ret

00000000800020aa <sys_wait>:

uint64
sys_wait(void)
{
    800020aa:	1101                	addi	sp,sp,-32
    800020ac:	ec06                	sd	ra,24(sp)
    800020ae:	e822                	sd	s0,16(sp)
    800020b0:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020b2:	fe840593          	addi	a1,s0,-24
    800020b6:	4501                	li	a0,0
    800020b8:	00000097          	auipc	ra,0x0
    800020bc:	ece080e7          	jalr	-306(ra) # 80001f86 <argaddr>
    800020c0:	87aa                	mv	a5,a0
    return -1;
    800020c2:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020c4:	0007c863          	bltz	a5,800020d4 <sys_wait+0x2a>
  return wait(p);
    800020c8:	fe843503          	ld	a0,-24(s0)
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	4d2080e7          	jalr	1234(ra) # 8000159e <wait>
}
    800020d4:	60e2                	ld	ra,24(sp)
    800020d6:	6442                	ld	s0,16(sp)
    800020d8:	6105                	addi	sp,sp,32
    800020da:	8082                	ret

00000000800020dc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020dc:	7179                	addi	sp,sp,-48
    800020de:	f406                	sd	ra,40(sp)
    800020e0:	f022                	sd	s0,32(sp)
    800020e2:	ec26                	sd	s1,24(sp)
    800020e4:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800020e6:	fdc40593          	addi	a1,s0,-36
    800020ea:	4501                	li	a0,0
    800020ec:	00000097          	auipc	ra,0x0
    800020f0:	e78080e7          	jalr	-392(ra) # 80001f64 <argint>
    800020f4:	87aa                	mv	a5,a0
    return -1;
    800020f6:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800020f8:	0207c063          	bltz	a5,80002118 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	d4c080e7          	jalr	-692(ra) # 80000e48 <myproc>
    80002104:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002106:	fdc42503          	lw	a0,-36(s0)
    8000210a:	fffff097          	auipc	ra,0xfffff
    8000210e:	0ce080e7          	jalr	206(ra) # 800011d8 <growproc>
    80002112:	00054863          	bltz	a0,80002122 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002116:	8526                	mv	a0,s1
}
    80002118:	70a2                	ld	ra,40(sp)
    8000211a:	7402                	ld	s0,32(sp)
    8000211c:	64e2                	ld	s1,24(sp)
    8000211e:	6145                	addi	sp,sp,48
    80002120:	8082                	ret
    return -1;
    80002122:	557d                	li	a0,-1
    80002124:	bfd5                	j	80002118 <sys_sbrk+0x3c>

0000000080002126 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002126:	7139                	addi	sp,sp,-64
    80002128:	fc06                	sd	ra,56(sp)
    8000212a:	f822                	sd	s0,48(sp)
    8000212c:	f426                	sd	s1,40(sp)
    8000212e:	f04a                	sd	s2,32(sp)
    80002130:	ec4e                	sd	s3,24(sp)
    80002132:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002134:	fcc40593          	addi	a1,s0,-52
    80002138:	4501                	li	a0,0
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	e2a080e7          	jalr	-470(ra) # 80001f64 <argint>
    return -1;
    80002142:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002144:	06054963          	bltz	a0,800021b6 <sys_sleep+0x90>
  acquire(&tickslock);
    80002148:	0000d517          	auipc	a0,0xd
    8000214c:	53850513          	addi	a0,a0,1336 # 8000f680 <tickslock>
    80002150:	00004097          	auipc	ra,0x4
    80002154:	096080e7          	jalr	150(ra) # 800061e6 <acquire>
  ticks0 = ticks;
    80002158:	00007917          	auipc	s2,0x7
    8000215c:	ec092903          	lw	s2,-320(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002160:	fcc42783          	lw	a5,-52(s0)
    80002164:	cf85                	beqz	a5,8000219c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002166:	0000d997          	auipc	s3,0xd
    8000216a:	51a98993          	addi	s3,s3,1306 # 8000f680 <tickslock>
    8000216e:	00007497          	auipc	s1,0x7
    80002172:	eaa48493          	addi	s1,s1,-342 # 80009018 <ticks>
    if(myproc()->killed){
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	cd2080e7          	jalr	-814(ra) # 80000e48 <myproc>
    8000217e:	551c                	lw	a5,40(a0)
    80002180:	e3b9                	bnez	a5,800021c6 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    80002182:	85ce                	mv	a1,s3
    80002184:	8526                	mv	a0,s1
    80002186:	fffff097          	auipc	ra,0xfffff
    8000218a:	3b4080e7          	jalr	948(ra) # 8000153a <sleep>
  while(ticks - ticks0 < n){
    8000218e:	409c                	lw	a5,0(s1)
    80002190:	412787bb          	subw	a5,a5,s2
    80002194:	fcc42703          	lw	a4,-52(s0)
    80002198:	fce7efe3          	bltu	a5,a4,80002176 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000219c:	0000d517          	auipc	a0,0xd
    800021a0:	4e450513          	addi	a0,a0,1252 # 8000f680 <tickslock>
    800021a4:	00004097          	auipc	ra,0x4
    800021a8:	0f6080e7          	jalr	246(ra) # 8000629a <release>
  backtrace();
    800021ac:	00004097          	auipc	ra,0x4
    800021b0:	abe080e7          	jalr	-1346(ra) # 80005c6a <backtrace>
  return 0;
    800021b4:	4781                	li	a5,0
}
    800021b6:	853e                	mv	a0,a5
    800021b8:	70e2                	ld	ra,56(sp)
    800021ba:	7442                	ld	s0,48(sp)
    800021bc:	74a2                	ld	s1,40(sp)
    800021be:	7902                	ld	s2,32(sp)
    800021c0:	69e2                	ld	s3,24(sp)
    800021c2:	6121                	addi	sp,sp,64
    800021c4:	8082                	ret
      release(&tickslock);
    800021c6:	0000d517          	auipc	a0,0xd
    800021ca:	4ba50513          	addi	a0,a0,1210 # 8000f680 <tickslock>
    800021ce:	00004097          	auipc	ra,0x4
    800021d2:	0cc080e7          	jalr	204(ra) # 8000629a <release>
      return -1;
    800021d6:	57fd                	li	a5,-1
    800021d8:	bff9                	j	800021b6 <sys_sleep+0x90>

00000000800021da <sys_kill>:

uint64
sys_kill(void)
{
    800021da:	1101                	addi	sp,sp,-32
    800021dc:	ec06                	sd	ra,24(sp)
    800021de:	e822                	sd	s0,16(sp)
    800021e0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800021e2:	fec40593          	addi	a1,s0,-20
    800021e6:	4501                	li	a0,0
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	d7c080e7          	jalr	-644(ra) # 80001f64 <argint>
    800021f0:	87aa                	mv	a5,a0
    return -1;
    800021f2:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800021f4:	0007c863          	bltz	a5,80002204 <sys_kill+0x2a>
  return kill(pid);
    800021f8:	fec42503          	lw	a0,-20(s0)
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	670080e7          	jalr	1648(ra) # 8000186c <kill>
}
    80002204:	60e2                	ld	ra,24(sp)
    80002206:	6442                	ld	s0,16(sp)
    80002208:	6105                	addi	sp,sp,32
    8000220a:	8082                	ret

000000008000220c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000220c:	1101                	addi	sp,sp,-32
    8000220e:	ec06                	sd	ra,24(sp)
    80002210:	e822                	sd	s0,16(sp)
    80002212:	e426                	sd	s1,8(sp)
    80002214:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002216:	0000d517          	auipc	a0,0xd
    8000221a:	46a50513          	addi	a0,a0,1130 # 8000f680 <tickslock>
    8000221e:	00004097          	auipc	ra,0x4
    80002222:	fc8080e7          	jalr	-56(ra) # 800061e6 <acquire>
  xticks = ticks;
    80002226:	00007497          	auipc	s1,0x7
    8000222a:	df24a483          	lw	s1,-526(s1) # 80009018 <ticks>
  release(&tickslock);
    8000222e:	0000d517          	auipc	a0,0xd
    80002232:	45250513          	addi	a0,a0,1106 # 8000f680 <tickslock>
    80002236:	00004097          	auipc	ra,0x4
    8000223a:	064080e7          	jalr	100(ra) # 8000629a <release>
  return xticks;
}
    8000223e:	02049513          	slli	a0,s1,0x20
    80002242:	9101                	srli	a0,a0,0x20
    80002244:	60e2                	ld	ra,24(sp)
    80002246:	6442                	ld	s0,16(sp)
    80002248:	64a2                	ld	s1,8(sp)
    8000224a:	6105                	addi	sp,sp,32
    8000224c:	8082                	ret

000000008000224e <sys_sigalarm>:

uint64 sys_sigalarm(void) {
    8000224e:	1101                	addi	sp,sp,-32
    80002250:	ec06                	sd	ra,24(sp)
    80002252:	e822                	sd	s0,16(sp)
    80002254:	1000                	addi	s0,sp,32
  int interval;
  uint64 handler;
  struct proc *p;
  // 要求时间间隔非负
  if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    80002256:	fec40593          	addi	a1,s0,-20
    8000225a:	4501                	li	a0,0
    8000225c:	00000097          	auipc	ra,0x0
    80002260:	d08080e7          	jalr	-760(ra) # 80001f64 <argint>
      return -1;
    80002264:	57fd                	li	a5,-1
  if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    80002266:	02054f63          	bltz	a0,800022a4 <sys_sigalarm+0x56>
    8000226a:	fe040593          	addi	a1,s0,-32
    8000226e:	4505                	li	a0,1
    80002270:	00000097          	auipc	ra,0x0
    80002274:	d16080e7          	jalr	-746(ra) # 80001f86 <argaddr>
    80002278:	02054b63          	bltz	a0,800022ae <sys_sigalarm+0x60>
    8000227c:	fec42703          	lw	a4,-20(s0)
      return -1;
    80002280:	57fd                	li	a5,-1
  if (argint(0, &interval) < 0 || argaddr(1, &handler) < 0 || interval < 0) {
    80002282:	02074163          	bltz	a4,800022a4 <sys_sigalarm+0x56>
  }

  p = myproc();
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	bc2080e7          	jalr	-1086(ra) # 80000e48 <myproc>
  p->interval = interval;
    8000228e:	fec42783          	lw	a5,-20(s0)
    80002292:	16f52423          	sw	a5,360(a0)
  p->handler = handler;
    80002296:	fe043783          	ld	a5,-32(s0)
    8000229a:	16f53823          	sd	a5,368(a0)
  p->passedticks = 0;    // 重置过去时钟数
    8000229e:	16052c23          	sw	zero,376(a0)

  return 0;
    800022a2:	4781                	li	a5,0
}
    800022a4:	853e                	mv	a0,a5
    800022a6:	60e2                	ld	ra,24(sp)
    800022a8:	6442                	ld	s0,16(sp)
    800022aa:	6105                	addi	sp,sp,32
    800022ac:	8082                	ret
      return -1;
    800022ae:	57fd                	li	a5,-1
    800022b0:	bfd5                	j	800022a4 <sys_sigalarm+0x56>

00000000800022b2 <sys_sigreturn>:

uint64 sys_sigreturn(void) {
    800022b2:	1101                	addi	sp,sp,-32
    800022b4:	ec06                	sd	ra,24(sp)
    800022b6:	e822                	sd	s0,16(sp)
    800022b8:	e426                	sd	s1,8(sp)
    800022ba:	1000                	addi	s0,sp,32
    struct proc* p = myproc();
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	b8c080e7          	jalr	-1140(ra) # 80000e48 <myproc>
    800022c4:	84aa                	mv	s1,a0
    // trapframecopy must have the copy of trapframe
    if(p->trapframecopy != p->trapframe + 512) {
    800022c6:	18053583          	ld	a1,384(a0)
    800022ca:	6d38                	ld	a4,88(a0)
    800022cc:	000247b7          	lui	a5,0x24
    800022d0:	97ba                	add	a5,a5,a4
        return -1;
    800022d2:	557d                	li	a0,-1
    if(p->trapframecopy != p->trapframe + 512) {
    800022d4:	00f58763          	beq	a1,a5,800022e2 <sys_sigreturn+0x30>
    }
    memmove(p->trapframe, p->trapframecopy, sizeof(struct trapframe));   // restore the trapframe
    p->passedticks = 0;     // prevent re-entrant
    p->trapframecopy = 0;    // 置零
    return p->trapframe->a0;	// 返回a0,避免被返回值覆盖
}
    800022d8:	60e2                	ld	ra,24(sp)
    800022da:	6442                	ld	s0,16(sp)
    800022dc:	64a2                	ld	s1,8(sp)
    800022de:	6105                	addi	sp,sp,32
    800022e0:	8082                	ret
    memmove(p->trapframe, p->trapframecopy, sizeof(struct trapframe));   // restore the trapframe
    800022e2:	12000613          	li	a2,288
    800022e6:	853a                	mv	a0,a4
    800022e8:	ffffe097          	auipc	ra,0xffffe
    800022ec:	ef0080e7          	jalr	-272(ra) # 800001d8 <memmove>
    p->passedticks = 0;     // prevent re-entrant
    800022f0:	1604ac23          	sw	zero,376(s1)
    p->trapframecopy = 0;    // 置零
    800022f4:	1804b023          	sd	zero,384(s1)
    return p->trapframe->a0;	// 返回a0,避免被返回值覆盖
    800022f8:	6cbc                	ld	a5,88(s1)
    800022fa:	7ba8                	ld	a0,112(a5)
    800022fc:	bff1                	j	800022d8 <sys_sigreturn+0x26>

00000000800022fe <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022fe:	7179                	addi	sp,sp,-48
    80002300:	f406                	sd	ra,40(sp)
    80002302:	f022                	sd	s0,32(sp)
    80002304:	ec26                	sd	s1,24(sp)
    80002306:	e84a                	sd	s2,16(sp)
    80002308:	e44e                	sd	s3,8(sp)
    8000230a:	e052                	sd	s4,0(sp)
    8000230c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000230e:	00006597          	auipc	a1,0x6
    80002312:	17a58593          	addi	a1,a1,378 # 80008488 <syscalls+0xc0>
    80002316:	0000d517          	auipc	a0,0xd
    8000231a:	38250513          	addi	a0,a0,898 # 8000f698 <bcache>
    8000231e:	00004097          	auipc	ra,0x4
    80002322:	e38080e7          	jalr	-456(ra) # 80006156 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002326:	00015797          	auipc	a5,0x15
    8000232a:	37278793          	addi	a5,a5,882 # 80017698 <bcache+0x8000>
    8000232e:	00015717          	auipc	a4,0x15
    80002332:	5d270713          	addi	a4,a4,1490 # 80017900 <bcache+0x8268>
    80002336:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000233a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000233e:	0000d497          	auipc	s1,0xd
    80002342:	37248493          	addi	s1,s1,882 # 8000f6b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002346:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002348:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000234a:	00006a17          	auipc	s4,0x6
    8000234e:	146a0a13          	addi	s4,s4,326 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002352:	2b893783          	ld	a5,696(s2)
    80002356:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002358:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000235c:	85d2                	mv	a1,s4
    8000235e:	01048513          	addi	a0,s1,16
    80002362:	00001097          	auipc	ra,0x1
    80002366:	4bc080e7          	jalr	1212(ra) # 8000381e <initsleeplock>
    bcache.head.next->prev = b;
    8000236a:	2b893783          	ld	a5,696(s2)
    8000236e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002370:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002374:	45848493          	addi	s1,s1,1112
    80002378:	fd349de3          	bne	s1,s3,80002352 <binit+0x54>
  }
}
    8000237c:	70a2                	ld	ra,40(sp)
    8000237e:	7402                	ld	s0,32(sp)
    80002380:	64e2                	ld	s1,24(sp)
    80002382:	6942                	ld	s2,16(sp)
    80002384:	69a2                	ld	s3,8(sp)
    80002386:	6a02                	ld	s4,0(sp)
    80002388:	6145                	addi	sp,sp,48
    8000238a:	8082                	ret

000000008000238c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000238c:	7179                	addi	sp,sp,-48
    8000238e:	f406                	sd	ra,40(sp)
    80002390:	f022                	sd	s0,32(sp)
    80002392:	ec26                	sd	s1,24(sp)
    80002394:	e84a                	sd	s2,16(sp)
    80002396:	e44e                	sd	s3,8(sp)
    80002398:	1800                	addi	s0,sp,48
    8000239a:	89aa                	mv	s3,a0
    8000239c:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000239e:	0000d517          	auipc	a0,0xd
    800023a2:	2fa50513          	addi	a0,a0,762 # 8000f698 <bcache>
    800023a6:	00004097          	auipc	ra,0x4
    800023aa:	e40080e7          	jalr	-448(ra) # 800061e6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023ae:	00015497          	auipc	s1,0x15
    800023b2:	5a24b483          	ld	s1,1442(s1) # 80017950 <bcache+0x82b8>
    800023b6:	00015797          	auipc	a5,0x15
    800023ba:	54a78793          	addi	a5,a5,1354 # 80017900 <bcache+0x8268>
    800023be:	02f48f63          	beq	s1,a5,800023fc <bread+0x70>
    800023c2:	873e                	mv	a4,a5
    800023c4:	a021                	j	800023cc <bread+0x40>
    800023c6:	68a4                	ld	s1,80(s1)
    800023c8:	02e48a63          	beq	s1,a4,800023fc <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023cc:	449c                	lw	a5,8(s1)
    800023ce:	ff379ce3          	bne	a5,s3,800023c6 <bread+0x3a>
    800023d2:	44dc                	lw	a5,12(s1)
    800023d4:	ff2799e3          	bne	a5,s2,800023c6 <bread+0x3a>
      b->refcnt++;
    800023d8:	40bc                	lw	a5,64(s1)
    800023da:	2785                	addiw	a5,a5,1
    800023dc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023de:	0000d517          	auipc	a0,0xd
    800023e2:	2ba50513          	addi	a0,a0,698 # 8000f698 <bcache>
    800023e6:	00004097          	auipc	ra,0x4
    800023ea:	eb4080e7          	jalr	-332(ra) # 8000629a <release>
      acquiresleep(&b->lock);
    800023ee:	01048513          	addi	a0,s1,16
    800023f2:	00001097          	auipc	ra,0x1
    800023f6:	466080e7          	jalr	1126(ra) # 80003858 <acquiresleep>
      return b;
    800023fa:	a8b9                	j	80002458 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023fc:	00015497          	auipc	s1,0x15
    80002400:	54c4b483          	ld	s1,1356(s1) # 80017948 <bcache+0x82b0>
    80002404:	00015797          	auipc	a5,0x15
    80002408:	4fc78793          	addi	a5,a5,1276 # 80017900 <bcache+0x8268>
    8000240c:	00f48863          	beq	s1,a5,8000241c <bread+0x90>
    80002410:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002412:	40bc                	lw	a5,64(s1)
    80002414:	cf81                	beqz	a5,8000242c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002416:	64a4                	ld	s1,72(s1)
    80002418:	fee49de3          	bne	s1,a4,80002412 <bread+0x86>
  panic("bget: no buffers");
    8000241c:	00006517          	auipc	a0,0x6
    80002420:	07c50513          	addi	a0,a0,124 # 80008498 <syscalls+0xd0>
    80002424:	00004097          	auipc	ra,0x4
    80002428:	8a2080e7          	jalr	-1886(ra) # 80005cc6 <panic>
      b->dev = dev;
    8000242c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002430:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002434:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002438:	4785                	li	a5,1
    8000243a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000243c:	0000d517          	auipc	a0,0xd
    80002440:	25c50513          	addi	a0,a0,604 # 8000f698 <bcache>
    80002444:	00004097          	auipc	ra,0x4
    80002448:	e56080e7          	jalr	-426(ra) # 8000629a <release>
      acquiresleep(&b->lock);
    8000244c:	01048513          	addi	a0,s1,16
    80002450:	00001097          	auipc	ra,0x1
    80002454:	408080e7          	jalr	1032(ra) # 80003858 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002458:	409c                	lw	a5,0(s1)
    8000245a:	cb89                	beqz	a5,8000246c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000245c:	8526                	mv	a0,s1
    8000245e:	70a2                	ld	ra,40(sp)
    80002460:	7402                	ld	s0,32(sp)
    80002462:	64e2                	ld	s1,24(sp)
    80002464:	6942                	ld	s2,16(sp)
    80002466:	69a2                	ld	s3,8(sp)
    80002468:	6145                	addi	sp,sp,48
    8000246a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000246c:	4581                	li	a1,0
    8000246e:	8526                	mv	a0,s1
    80002470:	00003097          	auipc	ra,0x3
    80002474:	f06080e7          	jalr	-250(ra) # 80005376 <virtio_disk_rw>
    b->valid = 1;
    80002478:	4785                	li	a5,1
    8000247a:	c09c                	sw	a5,0(s1)
  return b;
    8000247c:	b7c5                	j	8000245c <bread+0xd0>

000000008000247e <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000247e:	1101                	addi	sp,sp,-32
    80002480:	ec06                	sd	ra,24(sp)
    80002482:	e822                	sd	s0,16(sp)
    80002484:	e426                	sd	s1,8(sp)
    80002486:	1000                	addi	s0,sp,32
    80002488:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000248a:	0541                	addi	a0,a0,16
    8000248c:	00001097          	auipc	ra,0x1
    80002490:	466080e7          	jalr	1126(ra) # 800038f2 <holdingsleep>
    80002494:	cd01                	beqz	a0,800024ac <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002496:	4585                	li	a1,1
    80002498:	8526                	mv	a0,s1
    8000249a:	00003097          	auipc	ra,0x3
    8000249e:	edc080e7          	jalr	-292(ra) # 80005376 <virtio_disk_rw>
}
    800024a2:	60e2                	ld	ra,24(sp)
    800024a4:	6442                	ld	s0,16(sp)
    800024a6:	64a2                	ld	s1,8(sp)
    800024a8:	6105                	addi	sp,sp,32
    800024aa:	8082                	ret
    panic("bwrite");
    800024ac:	00006517          	auipc	a0,0x6
    800024b0:	00450513          	addi	a0,a0,4 # 800084b0 <syscalls+0xe8>
    800024b4:	00004097          	auipc	ra,0x4
    800024b8:	812080e7          	jalr	-2030(ra) # 80005cc6 <panic>

00000000800024bc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024bc:	1101                	addi	sp,sp,-32
    800024be:	ec06                	sd	ra,24(sp)
    800024c0:	e822                	sd	s0,16(sp)
    800024c2:	e426                	sd	s1,8(sp)
    800024c4:	e04a                	sd	s2,0(sp)
    800024c6:	1000                	addi	s0,sp,32
    800024c8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ca:	01050913          	addi	s2,a0,16
    800024ce:	854a                	mv	a0,s2
    800024d0:	00001097          	auipc	ra,0x1
    800024d4:	422080e7          	jalr	1058(ra) # 800038f2 <holdingsleep>
    800024d8:	c92d                	beqz	a0,8000254a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024da:	854a                	mv	a0,s2
    800024dc:	00001097          	auipc	ra,0x1
    800024e0:	3d2080e7          	jalr	978(ra) # 800038ae <releasesleep>

  acquire(&bcache.lock);
    800024e4:	0000d517          	auipc	a0,0xd
    800024e8:	1b450513          	addi	a0,a0,436 # 8000f698 <bcache>
    800024ec:	00004097          	auipc	ra,0x4
    800024f0:	cfa080e7          	jalr	-774(ra) # 800061e6 <acquire>
  b->refcnt--;
    800024f4:	40bc                	lw	a5,64(s1)
    800024f6:	37fd                	addiw	a5,a5,-1
    800024f8:	0007871b          	sext.w	a4,a5
    800024fc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024fe:	eb05                	bnez	a4,8000252e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002500:	68bc                	ld	a5,80(s1)
    80002502:	64b8                	ld	a4,72(s1)
    80002504:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002506:	64bc                	ld	a5,72(s1)
    80002508:	68b8                	ld	a4,80(s1)
    8000250a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000250c:	00015797          	auipc	a5,0x15
    80002510:	18c78793          	addi	a5,a5,396 # 80017698 <bcache+0x8000>
    80002514:	2b87b703          	ld	a4,696(a5)
    80002518:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000251a:	00015717          	auipc	a4,0x15
    8000251e:	3e670713          	addi	a4,a4,998 # 80017900 <bcache+0x8268>
    80002522:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002524:	2b87b703          	ld	a4,696(a5)
    80002528:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000252a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000252e:	0000d517          	auipc	a0,0xd
    80002532:	16a50513          	addi	a0,a0,362 # 8000f698 <bcache>
    80002536:	00004097          	auipc	ra,0x4
    8000253a:	d64080e7          	jalr	-668(ra) # 8000629a <release>
}
    8000253e:	60e2                	ld	ra,24(sp)
    80002540:	6442                	ld	s0,16(sp)
    80002542:	64a2                	ld	s1,8(sp)
    80002544:	6902                	ld	s2,0(sp)
    80002546:	6105                	addi	sp,sp,32
    80002548:	8082                	ret
    panic("brelse");
    8000254a:	00006517          	auipc	a0,0x6
    8000254e:	f6e50513          	addi	a0,a0,-146 # 800084b8 <syscalls+0xf0>
    80002552:	00003097          	auipc	ra,0x3
    80002556:	774080e7          	jalr	1908(ra) # 80005cc6 <panic>

000000008000255a <bpin>:

void
bpin(struct buf *b) {
    8000255a:	1101                	addi	sp,sp,-32
    8000255c:	ec06                	sd	ra,24(sp)
    8000255e:	e822                	sd	s0,16(sp)
    80002560:	e426                	sd	s1,8(sp)
    80002562:	1000                	addi	s0,sp,32
    80002564:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002566:	0000d517          	auipc	a0,0xd
    8000256a:	13250513          	addi	a0,a0,306 # 8000f698 <bcache>
    8000256e:	00004097          	auipc	ra,0x4
    80002572:	c78080e7          	jalr	-904(ra) # 800061e6 <acquire>
  b->refcnt++;
    80002576:	40bc                	lw	a5,64(s1)
    80002578:	2785                	addiw	a5,a5,1
    8000257a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000257c:	0000d517          	auipc	a0,0xd
    80002580:	11c50513          	addi	a0,a0,284 # 8000f698 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	d16080e7          	jalr	-746(ra) # 8000629a <release>
}
    8000258c:	60e2                	ld	ra,24(sp)
    8000258e:	6442                	ld	s0,16(sp)
    80002590:	64a2                	ld	s1,8(sp)
    80002592:	6105                	addi	sp,sp,32
    80002594:	8082                	ret

0000000080002596 <bunpin>:

void
bunpin(struct buf *b) {
    80002596:	1101                	addi	sp,sp,-32
    80002598:	ec06                	sd	ra,24(sp)
    8000259a:	e822                	sd	s0,16(sp)
    8000259c:	e426                	sd	s1,8(sp)
    8000259e:	1000                	addi	s0,sp,32
    800025a0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025a2:	0000d517          	auipc	a0,0xd
    800025a6:	0f650513          	addi	a0,a0,246 # 8000f698 <bcache>
    800025aa:	00004097          	auipc	ra,0x4
    800025ae:	c3c080e7          	jalr	-964(ra) # 800061e6 <acquire>
  b->refcnt--;
    800025b2:	40bc                	lw	a5,64(s1)
    800025b4:	37fd                	addiw	a5,a5,-1
    800025b6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025b8:	0000d517          	auipc	a0,0xd
    800025bc:	0e050513          	addi	a0,a0,224 # 8000f698 <bcache>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	cda080e7          	jalr	-806(ra) # 8000629a <release>
}
    800025c8:	60e2                	ld	ra,24(sp)
    800025ca:	6442                	ld	s0,16(sp)
    800025cc:	64a2                	ld	s1,8(sp)
    800025ce:	6105                	addi	sp,sp,32
    800025d0:	8082                	ret

00000000800025d2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025d2:	1101                	addi	sp,sp,-32
    800025d4:	ec06                	sd	ra,24(sp)
    800025d6:	e822                	sd	s0,16(sp)
    800025d8:	e426                	sd	s1,8(sp)
    800025da:	e04a                	sd	s2,0(sp)
    800025dc:	1000                	addi	s0,sp,32
    800025de:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025e0:	00d5d59b          	srliw	a1,a1,0xd
    800025e4:	00015797          	auipc	a5,0x15
    800025e8:	7907a783          	lw	a5,1936(a5) # 80017d74 <sb+0x1c>
    800025ec:	9dbd                	addw	a1,a1,a5
    800025ee:	00000097          	auipc	ra,0x0
    800025f2:	d9e080e7          	jalr	-610(ra) # 8000238c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025f6:	0074f713          	andi	a4,s1,7
    800025fa:	4785                	li	a5,1
    800025fc:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002600:	14ce                	slli	s1,s1,0x33
    80002602:	90d9                	srli	s1,s1,0x36
    80002604:	00950733          	add	a4,a0,s1
    80002608:	05874703          	lbu	a4,88(a4)
    8000260c:	00e7f6b3          	and	a3,a5,a4
    80002610:	c69d                	beqz	a3,8000263e <bfree+0x6c>
    80002612:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002614:	94aa                	add	s1,s1,a0
    80002616:	fff7c793          	not	a5,a5
    8000261a:	8ff9                	and	a5,a5,a4
    8000261c:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002620:	00001097          	auipc	ra,0x1
    80002624:	118080e7          	jalr	280(ra) # 80003738 <log_write>
  brelse(bp);
    80002628:	854a                	mv	a0,s2
    8000262a:	00000097          	auipc	ra,0x0
    8000262e:	e92080e7          	jalr	-366(ra) # 800024bc <brelse>
}
    80002632:	60e2                	ld	ra,24(sp)
    80002634:	6442                	ld	s0,16(sp)
    80002636:	64a2                	ld	s1,8(sp)
    80002638:	6902                	ld	s2,0(sp)
    8000263a:	6105                	addi	sp,sp,32
    8000263c:	8082                	ret
    panic("freeing free block");
    8000263e:	00006517          	auipc	a0,0x6
    80002642:	e8250513          	addi	a0,a0,-382 # 800084c0 <syscalls+0xf8>
    80002646:	00003097          	auipc	ra,0x3
    8000264a:	680080e7          	jalr	1664(ra) # 80005cc6 <panic>

000000008000264e <balloc>:
{
    8000264e:	711d                	addi	sp,sp,-96
    80002650:	ec86                	sd	ra,88(sp)
    80002652:	e8a2                	sd	s0,80(sp)
    80002654:	e4a6                	sd	s1,72(sp)
    80002656:	e0ca                	sd	s2,64(sp)
    80002658:	fc4e                	sd	s3,56(sp)
    8000265a:	f852                	sd	s4,48(sp)
    8000265c:	f456                	sd	s5,40(sp)
    8000265e:	f05a                	sd	s6,32(sp)
    80002660:	ec5e                	sd	s7,24(sp)
    80002662:	e862                	sd	s8,16(sp)
    80002664:	e466                	sd	s9,8(sp)
    80002666:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002668:	00015797          	auipc	a5,0x15
    8000266c:	6f47a783          	lw	a5,1780(a5) # 80017d5c <sb+0x4>
    80002670:	cbd1                	beqz	a5,80002704 <balloc+0xb6>
    80002672:	8baa                	mv	s7,a0
    80002674:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002676:	00015b17          	auipc	s6,0x15
    8000267a:	6e2b0b13          	addi	s6,s6,1762 # 80017d58 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000267e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002680:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002682:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002684:	6c89                	lui	s9,0x2
    80002686:	a831                	j	800026a2 <balloc+0x54>
    brelse(bp);
    80002688:	854a                	mv	a0,s2
    8000268a:	00000097          	auipc	ra,0x0
    8000268e:	e32080e7          	jalr	-462(ra) # 800024bc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002692:	015c87bb          	addw	a5,s9,s5
    80002696:	00078a9b          	sext.w	s5,a5
    8000269a:	004b2703          	lw	a4,4(s6)
    8000269e:	06eaf363          	bgeu	s5,a4,80002704 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026a2:	41fad79b          	sraiw	a5,s5,0x1f
    800026a6:	0137d79b          	srliw	a5,a5,0x13
    800026aa:	015787bb          	addw	a5,a5,s5
    800026ae:	40d7d79b          	sraiw	a5,a5,0xd
    800026b2:	01cb2583          	lw	a1,28(s6)
    800026b6:	9dbd                	addw	a1,a1,a5
    800026b8:	855e                	mv	a0,s7
    800026ba:	00000097          	auipc	ra,0x0
    800026be:	cd2080e7          	jalr	-814(ra) # 8000238c <bread>
    800026c2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026c4:	004b2503          	lw	a0,4(s6)
    800026c8:	000a849b          	sext.w	s1,s5
    800026cc:	8662                	mv	a2,s8
    800026ce:	faa4fde3          	bgeu	s1,a0,80002688 <balloc+0x3a>
      m = 1 << (bi % 8);
    800026d2:	41f6579b          	sraiw	a5,a2,0x1f
    800026d6:	01d7d69b          	srliw	a3,a5,0x1d
    800026da:	00c6873b          	addw	a4,a3,a2
    800026de:	00777793          	andi	a5,a4,7
    800026e2:	9f95                	subw	a5,a5,a3
    800026e4:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026e8:	4037571b          	sraiw	a4,a4,0x3
    800026ec:	00e906b3          	add	a3,s2,a4
    800026f0:	0586c683          	lbu	a3,88(a3)
    800026f4:	00d7f5b3          	and	a1,a5,a3
    800026f8:	cd91                	beqz	a1,80002714 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026fa:	2605                	addiw	a2,a2,1
    800026fc:	2485                	addiw	s1,s1,1
    800026fe:	fd4618e3          	bne	a2,s4,800026ce <balloc+0x80>
    80002702:	b759                	j	80002688 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002704:	00006517          	auipc	a0,0x6
    80002708:	dd450513          	addi	a0,a0,-556 # 800084d8 <syscalls+0x110>
    8000270c:	00003097          	auipc	ra,0x3
    80002710:	5ba080e7          	jalr	1466(ra) # 80005cc6 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002714:	974a                	add	a4,a4,s2
    80002716:	8fd5                	or	a5,a5,a3
    80002718:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    8000271c:	854a                	mv	a0,s2
    8000271e:	00001097          	auipc	ra,0x1
    80002722:	01a080e7          	jalr	26(ra) # 80003738 <log_write>
        brelse(bp);
    80002726:	854a                	mv	a0,s2
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	d94080e7          	jalr	-620(ra) # 800024bc <brelse>
  bp = bread(dev, bno);
    80002730:	85a6                	mv	a1,s1
    80002732:	855e                	mv	a0,s7
    80002734:	00000097          	auipc	ra,0x0
    80002738:	c58080e7          	jalr	-936(ra) # 8000238c <bread>
    8000273c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000273e:	40000613          	li	a2,1024
    80002742:	4581                	li	a1,0
    80002744:	05850513          	addi	a0,a0,88
    80002748:	ffffe097          	auipc	ra,0xffffe
    8000274c:	a30080e7          	jalr	-1488(ra) # 80000178 <memset>
  log_write(bp);
    80002750:	854a                	mv	a0,s2
    80002752:	00001097          	auipc	ra,0x1
    80002756:	fe6080e7          	jalr	-26(ra) # 80003738 <log_write>
  brelse(bp);
    8000275a:	854a                	mv	a0,s2
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	d60080e7          	jalr	-672(ra) # 800024bc <brelse>
}
    80002764:	8526                	mv	a0,s1
    80002766:	60e6                	ld	ra,88(sp)
    80002768:	6446                	ld	s0,80(sp)
    8000276a:	64a6                	ld	s1,72(sp)
    8000276c:	6906                	ld	s2,64(sp)
    8000276e:	79e2                	ld	s3,56(sp)
    80002770:	7a42                	ld	s4,48(sp)
    80002772:	7aa2                	ld	s5,40(sp)
    80002774:	7b02                	ld	s6,32(sp)
    80002776:	6be2                	ld	s7,24(sp)
    80002778:	6c42                	ld	s8,16(sp)
    8000277a:	6ca2                	ld	s9,8(sp)
    8000277c:	6125                	addi	sp,sp,96
    8000277e:	8082                	ret

0000000080002780 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002780:	7179                	addi	sp,sp,-48
    80002782:	f406                	sd	ra,40(sp)
    80002784:	f022                	sd	s0,32(sp)
    80002786:	ec26                	sd	s1,24(sp)
    80002788:	e84a                	sd	s2,16(sp)
    8000278a:	e44e                	sd	s3,8(sp)
    8000278c:	e052                	sd	s4,0(sp)
    8000278e:	1800                	addi	s0,sp,48
    80002790:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002792:	47ad                	li	a5,11
    80002794:	04b7fe63          	bgeu	a5,a1,800027f0 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002798:	ff45849b          	addiw	s1,a1,-12
    8000279c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027a0:	0ff00793          	li	a5,255
    800027a4:	0ae7e363          	bltu	a5,a4,8000284a <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027a8:	08052583          	lw	a1,128(a0)
    800027ac:	c5ad                	beqz	a1,80002816 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027ae:	00092503          	lw	a0,0(s2)
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	bda080e7          	jalr	-1062(ra) # 8000238c <bread>
    800027ba:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027bc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027c0:	02049593          	slli	a1,s1,0x20
    800027c4:	9181                	srli	a1,a1,0x20
    800027c6:	058a                	slli	a1,a1,0x2
    800027c8:	00b784b3          	add	s1,a5,a1
    800027cc:	0004a983          	lw	s3,0(s1)
    800027d0:	04098d63          	beqz	s3,8000282a <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027d4:	8552                	mv	a0,s4
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	ce6080e7          	jalr	-794(ra) # 800024bc <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027de:	854e                	mv	a0,s3
    800027e0:	70a2                	ld	ra,40(sp)
    800027e2:	7402                	ld	s0,32(sp)
    800027e4:	64e2                	ld	s1,24(sp)
    800027e6:	6942                	ld	s2,16(sp)
    800027e8:	69a2                	ld	s3,8(sp)
    800027ea:	6a02                	ld	s4,0(sp)
    800027ec:	6145                	addi	sp,sp,48
    800027ee:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800027f0:	02059493          	slli	s1,a1,0x20
    800027f4:	9081                	srli	s1,s1,0x20
    800027f6:	048a                	slli	s1,s1,0x2
    800027f8:	94aa                	add	s1,s1,a0
    800027fa:	0504a983          	lw	s3,80(s1)
    800027fe:	fe0990e3          	bnez	s3,800027de <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002802:	4108                	lw	a0,0(a0)
    80002804:	00000097          	auipc	ra,0x0
    80002808:	e4a080e7          	jalr	-438(ra) # 8000264e <balloc>
    8000280c:	0005099b          	sext.w	s3,a0
    80002810:	0534a823          	sw	s3,80(s1)
    80002814:	b7e9                	j	800027de <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002816:	4108                	lw	a0,0(a0)
    80002818:	00000097          	auipc	ra,0x0
    8000281c:	e36080e7          	jalr	-458(ra) # 8000264e <balloc>
    80002820:	0005059b          	sext.w	a1,a0
    80002824:	08b92023          	sw	a1,128(s2)
    80002828:	b759                	j	800027ae <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    8000282a:	00092503          	lw	a0,0(s2)
    8000282e:	00000097          	auipc	ra,0x0
    80002832:	e20080e7          	jalr	-480(ra) # 8000264e <balloc>
    80002836:	0005099b          	sext.w	s3,a0
    8000283a:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    8000283e:	8552                	mv	a0,s4
    80002840:	00001097          	auipc	ra,0x1
    80002844:	ef8080e7          	jalr	-264(ra) # 80003738 <log_write>
    80002848:	b771                	j	800027d4 <bmap+0x54>
  panic("bmap: out of range");
    8000284a:	00006517          	auipc	a0,0x6
    8000284e:	ca650513          	addi	a0,a0,-858 # 800084f0 <syscalls+0x128>
    80002852:	00003097          	auipc	ra,0x3
    80002856:	474080e7          	jalr	1140(ra) # 80005cc6 <panic>

000000008000285a <iget>:
{
    8000285a:	7179                	addi	sp,sp,-48
    8000285c:	f406                	sd	ra,40(sp)
    8000285e:	f022                	sd	s0,32(sp)
    80002860:	ec26                	sd	s1,24(sp)
    80002862:	e84a                	sd	s2,16(sp)
    80002864:	e44e                	sd	s3,8(sp)
    80002866:	e052                	sd	s4,0(sp)
    80002868:	1800                	addi	s0,sp,48
    8000286a:	89aa                	mv	s3,a0
    8000286c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000286e:	00015517          	auipc	a0,0x15
    80002872:	50a50513          	addi	a0,a0,1290 # 80017d78 <itable>
    80002876:	00004097          	auipc	ra,0x4
    8000287a:	970080e7          	jalr	-1680(ra) # 800061e6 <acquire>
  empty = 0;
    8000287e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002880:	00015497          	auipc	s1,0x15
    80002884:	51048493          	addi	s1,s1,1296 # 80017d90 <itable+0x18>
    80002888:	00017697          	auipc	a3,0x17
    8000288c:	f9868693          	addi	a3,a3,-104 # 80019820 <log>
    80002890:	a039                	j	8000289e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002892:	02090b63          	beqz	s2,800028c8 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002896:	08848493          	addi	s1,s1,136
    8000289a:	02d48a63          	beq	s1,a3,800028ce <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000289e:	449c                	lw	a5,8(s1)
    800028a0:	fef059e3          	blez	a5,80002892 <iget+0x38>
    800028a4:	4098                	lw	a4,0(s1)
    800028a6:	ff3716e3          	bne	a4,s3,80002892 <iget+0x38>
    800028aa:	40d8                	lw	a4,4(s1)
    800028ac:	ff4713e3          	bne	a4,s4,80002892 <iget+0x38>
      ip->ref++;
    800028b0:	2785                	addiw	a5,a5,1
    800028b2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028b4:	00015517          	auipc	a0,0x15
    800028b8:	4c450513          	addi	a0,a0,1220 # 80017d78 <itable>
    800028bc:	00004097          	auipc	ra,0x4
    800028c0:	9de080e7          	jalr	-1570(ra) # 8000629a <release>
      return ip;
    800028c4:	8926                	mv	s2,s1
    800028c6:	a03d                	j	800028f4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028c8:	f7f9                	bnez	a5,80002896 <iget+0x3c>
    800028ca:	8926                	mv	s2,s1
    800028cc:	b7e9                	j	80002896 <iget+0x3c>
  if(empty == 0)
    800028ce:	02090c63          	beqz	s2,80002906 <iget+0xac>
  ip->dev = dev;
    800028d2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028d6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028da:	4785                	li	a5,1
    800028dc:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028e0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028e4:	00015517          	auipc	a0,0x15
    800028e8:	49450513          	addi	a0,a0,1172 # 80017d78 <itable>
    800028ec:	00004097          	auipc	ra,0x4
    800028f0:	9ae080e7          	jalr	-1618(ra) # 8000629a <release>
}
    800028f4:	854a                	mv	a0,s2
    800028f6:	70a2                	ld	ra,40(sp)
    800028f8:	7402                	ld	s0,32(sp)
    800028fa:	64e2                	ld	s1,24(sp)
    800028fc:	6942                	ld	s2,16(sp)
    800028fe:	69a2                	ld	s3,8(sp)
    80002900:	6a02                	ld	s4,0(sp)
    80002902:	6145                	addi	sp,sp,48
    80002904:	8082                	ret
    panic("iget: no inodes");
    80002906:	00006517          	auipc	a0,0x6
    8000290a:	c0250513          	addi	a0,a0,-1022 # 80008508 <syscalls+0x140>
    8000290e:	00003097          	auipc	ra,0x3
    80002912:	3b8080e7          	jalr	952(ra) # 80005cc6 <panic>

0000000080002916 <fsinit>:
fsinit(int dev) {
    80002916:	7179                	addi	sp,sp,-48
    80002918:	f406                	sd	ra,40(sp)
    8000291a:	f022                	sd	s0,32(sp)
    8000291c:	ec26                	sd	s1,24(sp)
    8000291e:	e84a                	sd	s2,16(sp)
    80002920:	e44e                	sd	s3,8(sp)
    80002922:	1800                	addi	s0,sp,48
    80002924:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002926:	4585                	li	a1,1
    80002928:	00000097          	auipc	ra,0x0
    8000292c:	a64080e7          	jalr	-1436(ra) # 8000238c <bread>
    80002930:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002932:	00015997          	auipc	s3,0x15
    80002936:	42698993          	addi	s3,s3,1062 # 80017d58 <sb>
    8000293a:	02000613          	li	a2,32
    8000293e:	05850593          	addi	a1,a0,88
    80002942:	854e                	mv	a0,s3
    80002944:	ffffe097          	auipc	ra,0xffffe
    80002948:	894080e7          	jalr	-1900(ra) # 800001d8 <memmove>
  brelse(bp);
    8000294c:	8526                	mv	a0,s1
    8000294e:	00000097          	auipc	ra,0x0
    80002952:	b6e080e7          	jalr	-1170(ra) # 800024bc <brelse>
  if(sb.magic != FSMAGIC)
    80002956:	0009a703          	lw	a4,0(s3)
    8000295a:	102037b7          	lui	a5,0x10203
    8000295e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002962:	02f71263          	bne	a4,a5,80002986 <fsinit+0x70>
  initlog(dev, &sb);
    80002966:	00015597          	auipc	a1,0x15
    8000296a:	3f258593          	addi	a1,a1,1010 # 80017d58 <sb>
    8000296e:	854a                	mv	a0,s2
    80002970:	00001097          	auipc	ra,0x1
    80002974:	b4c080e7          	jalr	-1204(ra) # 800034bc <initlog>
}
    80002978:	70a2                	ld	ra,40(sp)
    8000297a:	7402                	ld	s0,32(sp)
    8000297c:	64e2                	ld	s1,24(sp)
    8000297e:	6942                	ld	s2,16(sp)
    80002980:	69a2                	ld	s3,8(sp)
    80002982:	6145                	addi	sp,sp,48
    80002984:	8082                	ret
    panic("invalid file system");
    80002986:	00006517          	auipc	a0,0x6
    8000298a:	b9250513          	addi	a0,a0,-1134 # 80008518 <syscalls+0x150>
    8000298e:	00003097          	auipc	ra,0x3
    80002992:	338080e7          	jalr	824(ra) # 80005cc6 <panic>

0000000080002996 <iinit>:
{
    80002996:	7179                	addi	sp,sp,-48
    80002998:	f406                	sd	ra,40(sp)
    8000299a:	f022                	sd	s0,32(sp)
    8000299c:	ec26                	sd	s1,24(sp)
    8000299e:	e84a                	sd	s2,16(sp)
    800029a0:	e44e                	sd	s3,8(sp)
    800029a2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029a4:	00006597          	auipc	a1,0x6
    800029a8:	b8c58593          	addi	a1,a1,-1140 # 80008530 <syscalls+0x168>
    800029ac:	00015517          	auipc	a0,0x15
    800029b0:	3cc50513          	addi	a0,a0,972 # 80017d78 <itable>
    800029b4:	00003097          	auipc	ra,0x3
    800029b8:	7a2080e7          	jalr	1954(ra) # 80006156 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029bc:	00015497          	auipc	s1,0x15
    800029c0:	3e448493          	addi	s1,s1,996 # 80017da0 <itable+0x28>
    800029c4:	00017997          	auipc	s3,0x17
    800029c8:	e6c98993          	addi	s3,s3,-404 # 80019830 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029cc:	00006917          	auipc	s2,0x6
    800029d0:	b6c90913          	addi	s2,s2,-1172 # 80008538 <syscalls+0x170>
    800029d4:	85ca                	mv	a1,s2
    800029d6:	8526                	mv	a0,s1
    800029d8:	00001097          	auipc	ra,0x1
    800029dc:	e46080e7          	jalr	-442(ra) # 8000381e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029e0:	08848493          	addi	s1,s1,136
    800029e4:	ff3498e3          	bne	s1,s3,800029d4 <iinit+0x3e>
}
    800029e8:	70a2                	ld	ra,40(sp)
    800029ea:	7402                	ld	s0,32(sp)
    800029ec:	64e2                	ld	s1,24(sp)
    800029ee:	6942                	ld	s2,16(sp)
    800029f0:	69a2                	ld	s3,8(sp)
    800029f2:	6145                	addi	sp,sp,48
    800029f4:	8082                	ret

00000000800029f6 <ialloc>:
{
    800029f6:	715d                	addi	sp,sp,-80
    800029f8:	e486                	sd	ra,72(sp)
    800029fa:	e0a2                	sd	s0,64(sp)
    800029fc:	fc26                	sd	s1,56(sp)
    800029fe:	f84a                	sd	s2,48(sp)
    80002a00:	f44e                	sd	s3,40(sp)
    80002a02:	f052                	sd	s4,32(sp)
    80002a04:	ec56                	sd	s5,24(sp)
    80002a06:	e85a                	sd	s6,16(sp)
    80002a08:	e45e                	sd	s7,8(sp)
    80002a0a:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a0c:	00015717          	auipc	a4,0x15
    80002a10:	35872703          	lw	a4,856(a4) # 80017d64 <sb+0xc>
    80002a14:	4785                	li	a5,1
    80002a16:	04e7fa63          	bgeu	a5,a4,80002a6a <ialloc+0x74>
    80002a1a:	8aaa                	mv	s5,a0
    80002a1c:	8bae                	mv	s7,a1
    80002a1e:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a20:	00015a17          	auipc	s4,0x15
    80002a24:	338a0a13          	addi	s4,s4,824 # 80017d58 <sb>
    80002a28:	00048b1b          	sext.w	s6,s1
    80002a2c:	0044d593          	srli	a1,s1,0x4
    80002a30:	018a2783          	lw	a5,24(s4)
    80002a34:	9dbd                	addw	a1,a1,a5
    80002a36:	8556                	mv	a0,s5
    80002a38:	00000097          	auipc	ra,0x0
    80002a3c:	954080e7          	jalr	-1708(ra) # 8000238c <bread>
    80002a40:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a42:	05850993          	addi	s3,a0,88
    80002a46:	00f4f793          	andi	a5,s1,15
    80002a4a:	079a                	slli	a5,a5,0x6
    80002a4c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a4e:	00099783          	lh	a5,0(s3)
    80002a52:	c785                	beqz	a5,80002a7a <ialloc+0x84>
    brelse(bp);
    80002a54:	00000097          	auipc	ra,0x0
    80002a58:	a68080e7          	jalr	-1432(ra) # 800024bc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a5c:	0485                	addi	s1,s1,1
    80002a5e:	00ca2703          	lw	a4,12(s4)
    80002a62:	0004879b          	sext.w	a5,s1
    80002a66:	fce7e1e3          	bltu	a5,a4,80002a28 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a6a:	00006517          	auipc	a0,0x6
    80002a6e:	ad650513          	addi	a0,a0,-1322 # 80008540 <syscalls+0x178>
    80002a72:	00003097          	auipc	ra,0x3
    80002a76:	254080e7          	jalr	596(ra) # 80005cc6 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a7a:	04000613          	li	a2,64
    80002a7e:	4581                	li	a1,0
    80002a80:	854e                	mv	a0,s3
    80002a82:	ffffd097          	auipc	ra,0xffffd
    80002a86:	6f6080e7          	jalr	1782(ra) # 80000178 <memset>
      dip->type = type;
    80002a8a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a8e:	854a                	mv	a0,s2
    80002a90:	00001097          	auipc	ra,0x1
    80002a94:	ca8080e7          	jalr	-856(ra) # 80003738 <log_write>
      brelse(bp);
    80002a98:	854a                	mv	a0,s2
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	a22080e7          	jalr	-1502(ra) # 800024bc <brelse>
      return iget(dev, inum);
    80002aa2:	85da                	mv	a1,s6
    80002aa4:	8556                	mv	a0,s5
    80002aa6:	00000097          	auipc	ra,0x0
    80002aaa:	db4080e7          	jalr	-588(ra) # 8000285a <iget>
}
    80002aae:	60a6                	ld	ra,72(sp)
    80002ab0:	6406                	ld	s0,64(sp)
    80002ab2:	74e2                	ld	s1,56(sp)
    80002ab4:	7942                	ld	s2,48(sp)
    80002ab6:	79a2                	ld	s3,40(sp)
    80002ab8:	7a02                	ld	s4,32(sp)
    80002aba:	6ae2                	ld	s5,24(sp)
    80002abc:	6b42                	ld	s6,16(sp)
    80002abe:	6ba2                	ld	s7,8(sp)
    80002ac0:	6161                	addi	sp,sp,80
    80002ac2:	8082                	ret

0000000080002ac4 <iupdate>:
{
    80002ac4:	1101                	addi	sp,sp,-32
    80002ac6:	ec06                	sd	ra,24(sp)
    80002ac8:	e822                	sd	s0,16(sp)
    80002aca:	e426                	sd	s1,8(sp)
    80002acc:	e04a                	sd	s2,0(sp)
    80002ace:	1000                	addi	s0,sp,32
    80002ad0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ad2:	415c                	lw	a5,4(a0)
    80002ad4:	0047d79b          	srliw	a5,a5,0x4
    80002ad8:	00015597          	auipc	a1,0x15
    80002adc:	2985a583          	lw	a1,664(a1) # 80017d70 <sb+0x18>
    80002ae0:	9dbd                	addw	a1,a1,a5
    80002ae2:	4108                	lw	a0,0(a0)
    80002ae4:	00000097          	auipc	ra,0x0
    80002ae8:	8a8080e7          	jalr	-1880(ra) # 8000238c <bread>
    80002aec:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002aee:	05850793          	addi	a5,a0,88
    80002af2:	40c8                	lw	a0,4(s1)
    80002af4:	893d                	andi	a0,a0,15
    80002af6:	051a                	slli	a0,a0,0x6
    80002af8:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002afa:	04449703          	lh	a4,68(s1)
    80002afe:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b02:	04649703          	lh	a4,70(s1)
    80002b06:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b0a:	04849703          	lh	a4,72(s1)
    80002b0e:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b12:	04a49703          	lh	a4,74(s1)
    80002b16:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b1a:	44f8                	lw	a4,76(s1)
    80002b1c:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b1e:	03400613          	li	a2,52
    80002b22:	05048593          	addi	a1,s1,80
    80002b26:	0531                	addi	a0,a0,12
    80002b28:	ffffd097          	auipc	ra,0xffffd
    80002b2c:	6b0080e7          	jalr	1712(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b30:	854a                	mv	a0,s2
    80002b32:	00001097          	auipc	ra,0x1
    80002b36:	c06080e7          	jalr	-1018(ra) # 80003738 <log_write>
  brelse(bp);
    80002b3a:	854a                	mv	a0,s2
    80002b3c:	00000097          	auipc	ra,0x0
    80002b40:	980080e7          	jalr	-1664(ra) # 800024bc <brelse>
}
    80002b44:	60e2                	ld	ra,24(sp)
    80002b46:	6442                	ld	s0,16(sp)
    80002b48:	64a2                	ld	s1,8(sp)
    80002b4a:	6902                	ld	s2,0(sp)
    80002b4c:	6105                	addi	sp,sp,32
    80002b4e:	8082                	ret

0000000080002b50 <idup>:
{
    80002b50:	1101                	addi	sp,sp,-32
    80002b52:	ec06                	sd	ra,24(sp)
    80002b54:	e822                	sd	s0,16(sp)
    80002b56:	e426                	sd	s1,8(sp)
    80002b58:	1000                	addi	s0,sp,32
    80002b5a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b5c:	00015517          	auipc	a0,0x15
    80002b60:	21c50513          	addi	a0,a0,540 # 80017d78 <itable>
    80002b64:	00003097          	auipc	ra,0x3
    80002b68:	682080e7          	jalr	1666(ra) # 800061e6 <acquire>
  ip->ref++;
    80002b6c:	449c                	lw	a5,8(s1)
    80002b6e:	2785                	addiw	a5,a5,1
    80002b70:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b72:	00015517          	auipc	a0,0x15
    80002b76:	20650513          	addi	a0,a0,518 # 80017d78 <itable>
    80002b7a:	00003097          	auipc	ra,0x3
    80002b7e:	720080e7          	jalr	1824(ra) # 8000629a <release>
}
    80002b82:	8526                	mv	a0,s1
    80002b84:	60e2                	ld	ra,24(sp)
    80002b86:	6442                	ld	s0,16(sp)
    80002b88:	64a2                	ld	s1,8(sp)
    80002b8a:	6105                	addi	sp,sp,32
    80002b8c:	8082                	ret

0000000080002b8e <ilock>:
{
    80002b8e:	1101                	addi	sp,sp,-32
    80002b90:	ec06                	sd	ra,24(sp)
    80002b92:	e822                	sd	s0,16(sp)
    80002b94:	e426                	sd	s1,8(sp)
    80002b96:	e04a                	sd	s2,0(sp)
    80002b98:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b9a:	c115                	beqz	a0,80002bbe <ilock+0x30>
    80002b9c:	84aa                	mv	s1,a0
    80002b9e:	451c                	lw	a5,8(a0)
    80002ba0:	00f05f63          	blez	a5,80002bbe <ilock+0x30>
  acquiresleep(&ip->lock);
    80002ba4:	0541                	addi	a0,a0,16
    80002ba6:	00001097          	auipc	ra,0x1
    80002baa:	cb2080e7          	jalr	-846(ra) # 80003858 <acquiresleep>
  if(ip->valid == 0){
    80002bae:	40bc                	lw	a5,64(s1)
    80002bb0:	cf99                	beqz	a5,80002bce <ilock+0x40>
}
    80002bb2:	60e2                	ld	ra,24(sp)
    80002bb4:	6442                	ld	s0,16(sp)
    80002bb6:	64a2                	ld	s1,8(sp)
    80002bb8:	6902                	ld	s2,0(sp)
    80002bba:	6105                	addi	sp,sp,32
    80002bbc:	8082                	ret
    panic("ilock");
    80002bbe:	00006517          	auipc	a0,0x6
    80002bc2:	99a50513          	addi	a0,a0,-1638 # 80008558 <syscalls+0x190>
    80002bc6:	00003097          	auipc	ra,0x3
    80002bca:	100080e7          	jalr	256(ra) # 80005cc6 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bce:	40dc                	lw	a5,4(s1)
    80002bd0:	0047d79b          	srliw	a5,a5,0x4
    80002bd4:	00015597          	auipc	a1,0x15
    80002bd8:	19c5a583          	lw	a1,412(a1) # 80017d70 <sb+0x18>
    80002bdc:	9dbd                	addw	a1,a1,a5
    80002bde:	4088                	lw	a0,0(s1)
    80002be0:	fffff097          	auipc	ra,0xfffff
    80002be4:	7ac080e7          	jalr	1964(ra) # 8000238c <bread>
    80002be8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bea:	05850593          	addi	a1,a0,88
    80002bee:	40dc                	lw	a5,4(s1)
    80002bf0:	8bbd                	andi	a5,a5,15
    80002bf2:	079a                	slli	a5,a5,0x6
    80002bf4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002bf6:	00059783          	lh	a5,0(a1)
    80002bfa:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bfe:	00259783          	lh	a5,2(a1)
    80002c02:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c06:	00459783          	lh	a5,4(a1)
    80002c0a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c0e:	00659783          	lh	a5,6(a1)
    80002c12:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c16:	459c                	lw	a5,8(a1)
    80002c18:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c1a:	03400613          	li	a2,52
    80002c1e:	05b1                	addi	a1,a1,12
    80002c20:	05048513          	addi	a0,s1,80
    80002c24:	ffffd097          	auipc	ra,0xffffd
    80002c28:	5b4080e7          	jalr	1460(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c2c:	854a                	mv	a0,s2
    80002c2e:	00000097          	auipc	ra,0x0
    80002c32:	88e080e7          	jalr	-1906(ra) # 800024bc <brelse>
    ip->valid = 1;
    80002c36:	4785                	li	a5,1
    80002c38:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c3a:	04449783          	lh	a5,68(s1)
    80002c3e:	fbb5                	bnez	a5,80002bb2 <ilock+0x24>
      panic("ilock: no type");
    80002c40:	00006517          	auipc	a0,0x6
    80002c44:	92050513          	addi	a0,a0,-1760 # 80008560 <syscalls+0x198>
    80002c48:	00003097          	auipc	ra,0x3
    80002c4c:	07e080e7          	jalr	126(ra) # 80005cc6 <panic>

0000000080002c50 <iunlock>:
{
    80002c50:	1101                	addi	sp,sp,-32
    80002c52:	ec06                	sd	ra,24(sp)
    80002c54:	e822                	sd	s0,16(sp)
    80002c56:	e426                	sd	s1,8(sp)
    80002c58:	e04a                	sd	s2,0(sp)
    80002c5a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c5c:	c905                	beqz	a0,80002c8c <iunlock+0x3c>
    80002c5e:	84aa                	mv	s1,a0
    80002c60:	01050913          	addi	s2,a0,16
    80002c64:	854a                	mv	a0,s2
    80002c66:	00001097          	auipc	ra,0x1
    80002c6a:	c8c080e7          	jalr	-884(ra) # 800038f2 <holdingsleep>
    80002c6e:	cd19                	beqz	a0,80002c8c <iunlock+0x3c>
    80002c70:	449c                	lw	a5,8(s1)
    80002c72:	00f05d63          	blez	a5,80002c8c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c76:	854a                	mv	a0,s2
    80002c78:	00001097          	auipc	ra,0x1
    80002c7c:	c36080e7          	jalr	-970(ra) # 800038ae <releasesleep>
}
    80002c80:	60e2                	ld	ra,24(sp)
    80002c82:	6442                	ld	s0,16(sp)
    80002c84:	64a2                	ld	s1,8(sp)
    80002c86:	6902                	ld	s2,0(sp)
    80002c88:	6105                	addi	sp,sp,32
    80002c8a:	8082                	ret
    panic("iunlock");
    80002c8c:	00006517          	auipc	a0,0x6
    80002c90:	8e450513          	addi	a0,a0,-1820 # 80008570 <syscalls+0x1a8>
    80002c94:	00003097          	auipc	ra,0x3
    80002c98:	032080e7          	jalr	50(ra) # 80005cc6 <panic>

0000000080002c9c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c9c:	7179                	addi	sp,sp,-48
    80002c9e:	f406                	sd	ra,40(sp)
    80002ca0:	f022                	sd	s0,32(sp)
    80002ca2:	ec26                	sd	s1,24(sp)
    80002ca4:	e84a                	sd	s2,16(sp)
    80002ca6:	e44e                	sd	s3,8(sp)
    80002ca8:	e052                	sd	s4,0(sp)
    80002caa:	1800                	addi	s0,sp,48
    80002cac:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cae:	05050493          	addi	s1,a0,80
    80002cb2:	08050913          	addi	s2,a0,128
    80002cb6:	a021                	j	80002cbe <itrunc+0x22>
    80002cb8:	0491                	addi	s1,s1,4
    80002cba:	01248d63          	beq	s1,s2,80002cd4 <itrunc+0x38>
    if(ip->addrs[i]){
    80002cbe:	408c                	lw	a1,0(s1)
    80002cc0:	dde5                	beqz	a1,80002cb8 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cc2:	0009a503          	lw	a0,0(s3)
    80002cc6:	00000097          	auipc	ra,0x0
    80002cca:	90c080e7          	jalr	-1780(ra) # 800025d2 <bfree>
      ip->addrs[i] = 0;
    80002cce:	0004a023          	sw	zero,0(s1)
    80002cd2:	b7dd                	j	80002cb8 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cd4:	0809a583          	lw	a1,128(s3)
    80002cd8:	e185                	bnez	a1,80002cf8 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cda:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cde:	854e                	mv	a0,s3
    80002ce0:	00000097          	auipc	ra,0x0
    80002ce4:	de4080e7          	jalr	-540(ra) # 80002ac4 <iupdate>
}
    80002ce8:	70a2                	ld	ra,40(sp)
    80002cea:	7402                	ld	s0,32(sp)
    80002cec:	64e2                	ld	s1,24(sp)
    80002cee:	6942                	ld	s2,16(sp)
    80002cf0:	69a2                	ld	s3,8(sp)
    80002cf2:	6a02                	ld	s4,0(sp)
    80002cf4:	6145                	addi	sp,sp,48
    80002cf6:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002cf8:	0009a503          	lw	a0,0(s3)
    80002cfc:	fffff097          	auipc	ra,0xfffff
    80002d00:	690080e7          	jalr	1680(ra) # 8000238c <bread>
    80002d04:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d06:	05850493          	addi	s1,a0,88
    80002d0a:	45850913          	addi	s2,a0,1112
    80002d0e:	a811                	j	80002d22 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d10:	0009a503          	lw	a0,0(s3)
    80002d14:	00000097          	auipc	ra,0x0
    80002d18:	8be080e7          	jalr	-1858(ra) # 800025d2 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d1c:	0491                	addi	s1,s1,4
    80002d1e:	01248563          	beq	s1,s2,80002d28 <itrunc+0x8c>
      if(a[j])
    80002d22:	408c                	lw	a1,0(s1)
    80002d24:	dde5                	beqz	a1,80002d1c <itrunc+0x80>
    80002d26:	b7ed                	j	80002d10 <itrunc+0x74>
    brelse(bp);
    80002d28:	8552                	mv	a0,s4
    80002d2a:	fffff097          	auipc	ra,0xfffff
    80002d2e:	792080e7          	jalr	1938(ra) # 800024bc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d32:	0809a583          	lw	a1,128(s3)
    80002d36:	0009a503          	lw	a0,0(s3)
    80002d3a:	00000097          	auipc	ra,0x0
    80002d3e:	898080e7          	jalr	-1896(ra) # 800025d2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d42:	0809a023          	sw	zero,128(s3)
    80002d46:	bf51                	j	80002cda <itrunc+0x3e>

0000000080002d48 <iput>:
{
    80002d48:	1101                	addi	sp,sp,-32
    80002d4a:	ec06                	sd	ra,24(sp)
    80002d4c:	e822                	sd	s0,16(sp)
    80002d4e:	e426                	sd	s1,8(sp)
    80002d50:	e04a                	sd	s2,0(sp)
    80002d52:	1000                	addi	s0,sp,32
    80002d54:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d56:	00015517          	auipc	a0,0x15
    80002d5a:	02250513          	addi	a0,a0,34 # 80017d78 <itable>
    80002d5e:	00003097          	auipc	ra,0x3
    80002d62:	488080e7          	jalr	1160(ra) # 800061e6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d66:	4498                	lw	a4,8(s1)
    80002d68:	4785                	li	a5,1
    80002d6a:	02f70363          	beq	a4,a5,80002d90 <iput+0x48>
  ip->ref--;
    80002d6e:	449c                	lw	a5,8(s1)
    80002d70:	37fd                	addiw	a5,a5,-1
    80002d72:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d74:	00015517          	auipc	a0,0x15
    80002d78:	00450513          	addi	a0,a0,4 # 80017d78 <itable>
    80002d7c:	00003097          	auipc	ra,0x3
    80002d80:	51e080e7          	jalr	1310(ra) # 8000629a <release>
}
    80002d84:	60e2                	ld	ra,24(sp)
    80002d86:	6442                	ld	s0,16(sp)
    80002d88:	64a2                	ld	s1,8(sp)
    80002d8a:	6902                	ld	s2,0(sp)
    80002d8c:	6105                	addi	sp,sp,32
    80002d8e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d90:	40bc                	lw	a5,64(s1)
    80002d92:	dff1                	beqz	a5,80002d6e <iput+0x26>
    80002d94:	04a49783          	lh	a5,74(s1)
    80002d98:	fbf9                	bnez	a5,80002d6e <iput+0x26>
    acquiresleep(&ip->lock);
    80002d9a:	01048913          	addi	s2,s1,16
    80002d9e:	854a                	mv	a0,s2
    80002da0:	00001097          	auipc	ra,0x1
    80002da4:	ab8080e7          	jalr	-1352(ra) # 80003858 <acquiresleep>
    release(&itable.lock);
    80002da8:	00015517          	auipc	a0,0x15
    80002dac:	fd050513          	addi	a0,a0,-48 # 80017d78 <itable>
    80002db0:	00003097          	auipc	ra,0x3
    80002db4:	4ea080e7          	jalr	1258(ra) # 8000629a <release>
    itrunc(ip);
    80002db8:	8526                	mv	a0,s1
    80002dba:	00000097          	auipc	ra,0x0
    80002dbe:	ee2080e7          	jalr	-286(ra) # 80002c9c <itrunc>
    ip->type = 0;
    80002dc2:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dc6:	8526                	mv	a0,s1
    80002dc8:	00000097          	auipc	ra,0x0
    80002dcc:	cfc080e7          	jalr	-772(ra) # 80002ac4 <iupdate>
    ip->valid = 0;
    80002dd0:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dd4:	854a                	mv	a0,s2
    80002dd6:	00001097          	auipc	ra,0x1
    80002dda:	ad8080e7          	jalr	-1320(ra) # 800038ae <releasesleep>
    acquire(&itable.lock);
    80002dde:	00015517          	auipc	a0,0x15
    80002de2:	f9a50513          	addi	a0,a0,-102 # 80017d78 <itable>
    80002de6:	00003097          	auipc	ra,0x3
    80002dea:	400080e7          	jalr	1024(ra) # 800061e6 <acquire>
    80002dee:	b741                	j	80002d6e <iput+0x26>

0000000080002df0 <iunlockput>:
{
    80002df0:	1101                	addi	sp,sp,-32
    80002df2:	ec06                	sd	ra,24(sp)
    80002df4:	e822                	sd	s0,16(sp)
    80002df6:	e426                	sd	s1,8(sp)
    80002df8:	1000                	addi	s0,sp,32
    80002dfa:	84aa                	mv	s1,a0
  iunlock(ip);
    80002dfc:	00000097          	auipc	ra,0x0
    80002e00:	e54080e7          	jalr	-428(ra) # 80002c50 <iunlock>
  iput(ip);
    80002e04:	8526                	mv	a0,s1
    80002e06:	00000097          	auipc	ra,0x0
    80002e0a:	f42080e7          	jalr	-190(ra) # 80002d48 <iput>
}
    80002e0e:	60e2                	ld	ra,24(sp)
    80002e10:	6442                	ld	s0,16(sp)
    80002e12:	64a2                	ld	s1,8(sp)
    80002e14:	6105                	addi	sp,sp,32
    80002e16:	8082                	ret

0000000080002e18 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e18:	1141                	addi	sp,sp,-16
    80002e1a:	e422                	sd	s0,8(sp)
    80002e1c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e1e:	411c                	lw	a5,0(a0)
    80002e20:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e22:	415c                	lw	a5,4(a0)
    80002e24:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e26:	04451783          	lh	a5,68(a0)
    80002e2a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e2e:	04a51783          	lh	a5,74(a0)
    80002e32:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e36:	04c56783          	lwu	a5,76(a0)
    80002e3a:	e99c                	sd	a5,16(a1)
}
    80002e3c:	6422                	ld	s0,8(sp)
    80002e3e:	0141                	addi	sp,sp,16
    80002e40:	8082                	ret

0000000080002e42 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e42:	457c                	lw	a5,76(a0)
    80002e44:	0ed7e963          	bltu	a5,a3,80002f36 <readi+0xf4>
{
    80002e48:	7159                	addi	sp,sp,-112
    80002e4a:	f486                	sd	ra,104(sp)
    80002e4c:	f0a2                	sd	s0,96(sp)
    80002e4e:	eca6                	sd	s1,88(sp)
    80002e50:	e8ca                	sd	s2,80(sp)
    80002e52:	e4ce                	sd	s3,72(sp)
    80002e54:	e0d2                	sd	s4,64(sp)
    80002e56:	fc56                	sd	s5,56(sp)
    80002e58:	f85a                	sd	s6,48(sp)
    80002e5a:	f45e                	sd	s7,40(sp)
    80002e5c:	f062                	sd	s8,32(sp)
    80002e5e:	ec66                	sd	s9,24(sp)
    80002e60:	e86a                	sd	s10,16(sp)
    80002e62:	e46e                	sd	s11,8(sp)
    80002e64:	1880                	addi	s0,sp,112
    80002e66:	8baa                	mv	s7,a0
    80002e68:	8c2e                	mv	s8,a1
    80002e6a:	8ab2                	mv	s5,a2
    80002e6c:	84b6                	mv	s1,a3
    80002e6e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e70:	9f35                	addw	a4,a4,a3
    return 0;
    80002e72:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e74:	0ad76063          	bltu	a4,a3,80002f14 <readi+0xd2>
  if(off + n > ip->size)
    80002e78:	00e7f463          	bgeu	a5,a4,80002e80 <readi+0x3e>
    n = ip->size - off;
    80002e7c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e80:	0a0b0963          	beqz	s6,80002f32 <readi+0xf0>
    80002e84:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e86:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e8a:	5cfd                	li	s9,-1
    80002e8c:	a82d                	j	80002ec6 <readi+0x84>
    80002e8e:	020a1d93          	slli	s11,s4,0x20
    80002e92:	020ddd93          	srli	s11,s11,0x20
    80002e96:	05890613          	addi	a2,s2,88
    80002e9a:	86ee                	mv	a3,s11
    80002e9c:	963a                	add	a2,a2,a4
    80002e9e:	85d6                	mv	a1,s5
    80002ea0:	8562                	mv	a0,s8
    80002ea2:	fffff097          	auipc	ra,0xfffff
    80002ea6:	a3c080e7          	jalr	-1476(ra) # 800018de <either_copyout>
    80002eaa:	05950d63          	beq	a0,s9,80002f04 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eae:	854a                	mv	a0,s2
    80002eb0:	fffff097          	auipc	ra,0xfffff
    80002eb4:	60c080e7          	jalr	1548(ra) # 800024bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eb8:	013a09bb          	addw	s3,s4,s3
    80002ebc:	009a04bb          	addw	s1,s4,s1
    80002ec0:	9aee                	add	s5,s5,s11
    80002ec2:	0569f763          	bgeu	s3,s6,80002f10 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002ec6:	000ba903          	lw	s2,0(s7)
    80002eca:	00a4d59b          	srliw	a1,s1,0xa
    80002ece:	855e                	mv	a0,s7
    80002ed0:	00000097          	auipc	ra,0x0
    80002ed4:	8b0080e7          	jalr	-1872(ra) # 80002780 <bmap>
    80002ed8:	0005059b          	sext.w	a1,a0
    80002edc:	854a                	mv	a0,s2
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	4ae080e7          	jalr	1198(ra) # 8000238c <bread>
    80002ee6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ee8:	3ff4f713          	andi	a4,s1,1023
    80002eec:	40ed07bb          	subw	a5,s10,a4
    80002ef0:	413b06bb          	subw	a3,s6,s3
    80002ef4:	8a3e                	mv	s4,a5
    80002ef6:	2781                	sext.w	a5,a5
    80002ef8:	0006861b          	sext.w	a2,a3
    80002efc:	f8f679e3          	bgeu	a2,a5,80002e8e <readi+0x4c>
    80002f00:	8a36                	mv	s4,a3
    80002f02:	b771                	j	80002e8e <readi+0x4c>
      brelse(bp);
    80002f04:	854a                	mv	a0,s2
    80002f06:	fffff097          	auipc	ra,0xfffff
    80002f0a:	5b6080e7          	jalr	1462(ra) # 800024bc <brelse>
      tot = -1;
    80002f0e:	59fd                	li	s3,-1
  }
  return tot;
    80002f10:	0009851b          	sext.w	a0,s3
}
    80002f14:	70a6                	ld	ra,104(sp)
    80002f16:	7406                	ld	s0,96(sp)
    80002f18:	64e6                	ld	s1,88(sp)
    80002f1a:	6946                	ld	s2,80(sp)
    80002f1c:	69a6                	ld	s3,72(sp)
    80002f1e:	6a06                	ld	s4,64(sp)
    80002f20:	7ae2                	ld	s5,56(sp)
    80002f22:	7b42                	ld	s6,48(sp)
    80002f24:	7ba2                	ld	s7,40(sp)
    80002f26:	7c02                	ld	s8,32(sp)
    80002f28:	6ce2                	ld	s9,24(sp)
    80002f2a:	6d42                	ld	s10,16(sp)
    80002f2c:	6da2                	ld	s11,8(sp)
    80002f2e:	6165                	addi	sp,sp,112
    80002f30:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f32:	89da                	mv	s3,s6
    80002f34:	bff1                	j	80002f10 <readi+0xce>
    return 0;
    80002f36:	4501                	li	a0,0
}
    80002f38:	8082                	ret

0000000080002f3a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f3a:	457c                	lw	a5,76(a0)
    80002f3c:	10d7e863          	bltu	a5,a3,8000304c <writei+0x112>
{
    80002f40:	7159                	addi	sp,sp,-112
    80002f42:	f486                	sd	ra,104(sp)
    80002f44:	f0a2                	sd	s0,96(sp)
    80002f46:	eca6                	sd	s1,88(sp)
    80002f48:	e8ca                	sd	s2,80(sp)
    80002f4a:	e4ce                	sd	s3,72(sp)
    80002f4c:	e0d2                	sd	s4,64(sp)
    80002f4e:	fc56                	sd	s5,56(sp)
    80002f50:	f85a                	sd	s6,48(sp)
    80002f52:	f45e                	sd	s7,40(sp)
    80002f54:	f062                	sd	s8,32(sp)
    80002f56:	ec66                	sd	s9,24(sp)
    80002f58:	e86a                	sd	s10,16(sp)
    80002f5a:	e46e                	sd	s11,8(sp)
    80002f5c:	1880                	addi	s0,sp,112
    80002f5e:	8b2a                	mv	s6,a0
    80002f60:	8c2e                	mv	s8,a1
    80002f62:	8ab2                	mv	s5,a2
    80002f64:	8936                	mv	s2,a3
    80002f66:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f68:	00e687bb          	addw	a5,a3,a4
    80002f6c:	0ed7e263          	bltu	a5,a3,80003050 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f70:	00043737          	lui	a4,0x43
    80002f74:	0ef76063          	bltu	a4,a5,80003054 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f78:	0c0b8863          	beqz	s7,80003048 <writei+0x10e>
    80002f7c:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f7e:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f82:	5cfd                	li	s9,-1
    80002f84:	a091                	j	80002fc8 <writei+0x8e>
    80002f86:	02099d93          	slli	s11,s3,0x20
    80002f8a:	020ddd93          	srli	s11,s11,0x20
    80002f8e:	05848513          	addi	a0,s1,88
    80002f92:	86ee                	mv	a3,s11
    80002f94:	8656                	mv	a2,s5
    80002f96:	85e2                	mv	a1,s8
    80002f98:	953a                	add	a0,a0,a4
    80002f9a:	fffff097          	auipc	ra,0xfffff
    80002f9e:	99a080e7          	jalr	-1638(ra) # 80001934 <either_copyin>
    80002fa2:	07950263          	beq	a0,s9,80003006 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fa6:	8526                	mv	a0,s1
    80002fa8:	00000097          	auipc	ra,0x0
    80002fac:	790080e7          	jalr	1936(ra) # 80003738 <log_write>
    brelse(bp);
    80002fb0:	8526                	mv	a0,s1
    80002fb2:	fffff097          	auipc	ra,0xfffff
    80002fb6:	50a080e7          	jalr	1290(ra) # 800024bc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fba:	01498a3b          	addw	s4,s3,s4
    80002fbe:	0129893b          	addw	s2,s3,s2
    80002fc2:	9aee                	add	s5,s5,s11
    80002fc4:	057a7663          	bgeu	s4,s7,80003010 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fc8:	000b2483          	lw	s1,0(s6)
    80002fcc:	00a9559b          	srliw	a1,s2,0xa
    80002fd0:	855a                	mv	a0,s6
    80002fd2:	fffff097          	auipc	ra,0xfffff
    80002fd6:	7ae080e7          	jalr	1966(ra) # 80002780 <bmap>
    80002fda:	0005059b          	sext.w	a1,a0
    80002fde:	8526                	mv	a0,s1
    80002fe0:	fffff097          	auipc	ra,0xfffff
    80002fe4:	3ac080e7          	jalr	940(ra) # 8000238c <bread>
    80002fe8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fea:	3ff97713          	andi	a4,s2,1023
    80002fee:	40ed07bb          	subw	a5,s10,a4
    80002ff2:	414b86bb          	subw	a3,s7,s4
    80002ff6:	89be                	mv	s3,a5
    80002ff8:	2781                	sext.w	a5,a5
    80002ffa:	0006861b          	sext.w	a2,a3
    80002ffe:	f8f674e3          	bgeu	a2,a5,80002f86 <writei+0x4c>
    80003002:	89b6                	mv	s3,a3
    80003004:	b749                	j	80002f86 <writei+0x4c>
      brelse(bp);
    80003006:	8526                	mv	a0,s1
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	4b4080e7          	jalr	1204(ra) # 800024bc <brelse>
  }

  if(off > ip->size)
    80003010:	04cb2783          	lw	a5,76(s6)
    80003014:	0127f463          	bgeu	a5,s2,8000301c <writei+0xe2>
    ip->size = off;
    80003018:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000301c:	855a                	mv	a0,s6
    8000301e:	00000097          	auipc	ra,0x0
    80003022:	aa6080e7          	jalr	-1370(ra) # 80002ac4 <iupdate>

  return tot;
    80003026:	000a051b          	sext.w	a0,s4
}
    8000302a:	70a6                	ld	ra,104(sp)
    8000302c:	7406                	ld	s0,96(sp)
    8000302e:	64e6                	ld	s1,88(sp)
    80003030:	6946                	ld	s2,80(sp)
    80003032:	69a6                	ld	s3,72(sp)
    80003034:	6a06                	ld	s4,64(sp)
    80003036:	7ae2                	ld	s5,56(sp)
    80003038:	7b42                	ld	s6,48(sp)
    8000303a:	7ba2                	ld	s7,40(sp)
    8000303c:	7c02                	ld	s8,32(sp)
    8000303e:	6ce2                	ld	s9,24(sp)
    80003040:	6d42                	ld	s10,16(sp)
    80003042:	6da2                	ld	s11,8(sp)
    80003044:	6165                	addi	sp,sp,112
    80003046:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003048:	8a5e                	mv	s4,s7
    8000304a:	bfc9                	j	8000301c <writei+0xe2>
    return -1;
    8000304c:	557d                	li	a0,-1
}
    8000304e:	8082                	ret
    return -1;
    80003050:	557d                	li	a0,-1
    80003052:	bfe1                	j	8000302a <writei+0xf0>
    return -1;
    80003054:	557d                	li	a0,-1
    80003056:	bfd1                	j	8000302a <writei+0xf0>

0000000080003058 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003058:	1141                	addi	sp,sp,-16
    8000305a:	e406                	sd	ra,8(sp)
    8000305c:	e022                	sd	s0,0(sp)
    8000305e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003060:	4639                	li	a2,14
    80003062:	ffffd097          	auipc	ra,0xffffd
    80003066:	1ee080e7          	jalr	494(ra) # 80000250 <strncmp>
}
    8000306a:	60a2                	ld	ra,8(sp)
    8000306c:	6402                	ld	s0,0(sp)
    8000306e:	0141                	addi	sp,sp,16
    80003070:	8082                	ret

0000000080003072 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003072:	7139                	addi	sp,sp,-64
    80003074:	fc06                	sd	ra,56(sp)
    80003076:	f822                	sd	s0,48(sp)
    80003078:	f426                	sd	s1,40(sp)
    8000307a:	f04a                	sd	s2,32(sp)
    8000307c:	ec4e                	sd	s3,24(sp)
    8000307e:	e852                	sd	s4,16(sp)
    80003080:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003082:	04451703          	lh	a4,68(a0)
    80003086:	4785                	li	a5,1
    80003088:	00f71a63          	bne	a4,a5,8000309c <dirlookup+0x2a>
    8000308c:	892a                	mv	s2,a0
    8000308e:	89ae                	mv	s3,a1
    80003090:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003092:	457c                	lw	a5,76(a0)
    80003094:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003096:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003098:	e79d                	bnez	a5,800030c6 <dirlookup+0x54>
    8000309a:	a8a5                	j	80003112 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000309c:	00005517          	auipc	a0,0x5
    800030a0:	4dc50513          	addi	a0,a0,1244 # 80008578 <syscalls+0x1b0>
    800030a4:	00003097          	auipc	ra,0x3
    800030a8:	c22080e7          	jalr	-990(ra) # 80005cc6 <panic>
      panic("dirlookup read");
    800030ac:	00005517          	auipc	a0,0x5
    800030b0:	4e450513          	addi	a0,a0,1252 # 80008590 <syscalls+0x1c8>
    800030b4:	00003097          	auipc	ra,0x3
    800030b8:	c12080e7          	jalr	-1006(ra) # 80005cc6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030bc:	24c1                	addiw	s1,s1,16
    800030be:	04c92783          	lw	a5,76(s2)
    800030c2:	04f4f763          	bgeu	s1,a5,80003110 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030c6:	4741                	li	a4,16
    800030c8:	86a6                	mv	a3,s1
    800030ca:	fc040613          	addi	a2,s0,-64
    800030ce:	4581                	li	a1,0
    800030d0:	854a                	mv	a0,s2
    800030d2:	00000097          	auipc	ra,0x0
    800030d6:	d70080e7          	jalr	-656(ra) # 80002e42 <readi>
    800030da:	47c1                	li	a5,16
    800030dc:	fcf518e3          	bne	a0,a5,800030ac <dirlookup+0x3a>
    if(de.inum == 0)
    800030e0:	fc045783          	lhu	a5,-64(s0)
    800030e4:	dfe1                	beqz	a5,800030bc <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030e6:	fc240593          	addi	a1,s0,-62
    800030ea:	854e                	mv	a0,s3
    800030ec:	00000097          	auipc	ra,0x0
    800030f0:	f6c080e7          	jalr	-148(ra) # 80003058 <namecmp>
    800030f4:	f561                	bnez	a0,800030bc <dirlookup+0x4a>
      if(poff)
    800030f6:	000a0463          	beqz	s4,800030fe <dirlookup+0x8c>
        *poff = off;
    800030fa:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030fe:	fc045583          	lhu	a1,-64(s0)
    80003102:	00092503          	lw	a0,0(s2)
    80003106:	fffff097          	auipc	ra,0xfffff
    8000310a:	754080e7          	jalr	1876(ra) # 8000285a <iget>
    8000310e:	a011                	j	80003112 <dirlookup+0xa0>
  return 0;
    80003110:	4501                	li	a0,0
}
    80003112:	70e2                	ld	ra,56(sp)
    80003114:	7442                	ld	s0,48(sp)
    80003116:	74a2                	ld	s1,40(sp)
    80003118:	7902                	ld	s2,32(sp)
    8000311a:	69e2                	ld	s3,24(sp)
    8000311c:	6a42                	ld	s4,16(sp)
    8000311e:	6121                	addi	sp,sp,64
    80003120:	8082                	ret

0000000080003122 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003122:	711d                	addi	sp,sp,-96
    80003124:	ec86                	sd	ra,88(sp)
    80003126:	e8a2                	sd	s0,80(sp)
    80003128:	e4a6                	sd	s1,72(sp)
    8000312a:	e0ca                	sd	s2,64(sp)
    8000312c:	fc4e                	sd	s3,56(sp)
    8000312e:	f852                	sd	s4,48(sp)
    80003130:	f456                	sd	s5,40(sp)
    80003132:	f05a                	sd	s6,32(sp)
    80003134:	ec5e                	sd	s7,24(sp)
    80003136:	e862                	sd	s8,16(sp)
    80003138:	e466                	sd	s9,8(sp)
    8000313a:	1080                	addi	s0,sp,96
    8000313c:	84aa                	mv	s1,a0
    8000313e:	8b2e                	mv	s6,a1
    80003140:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003142:	00054703          	lbu	a4,0(a0)
    80003146:	02f00793          	li	a5,47
    8000314a:	02f70363          	beq	a4,a5,80003170 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000314e:	ffffe097          	auipc	ra,0xffffe
    80003152:	cfa080e7          	jalr	-774(ra) # 80000e48 <myproc>
    80003156:	15053503          	ld	a0,336(a0)
    8000315a:	00000097          	auipc	ra,0x0
    8000315e:	9f6080e7          	jalr	-1546(ra) # 80002b50 <idup>
    80003162:	89aa                	mv	s3,a0
  while(*path == '/')
    80003164:	02f00913          	li	s2,47
  len = path - s;
    80003168:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    8000316a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000316c:	4c05                	li	s8,1
    8000316e:	a865                	j	80003226 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003170:	4585                	li	a1,1
    80003172:	4505                	li	a0,1
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	6e6080e7          	jalr	1766(ra) # 8000285a <iget>
    8000317c:	89aa                	mv	s3,a0
    8000317e:	b7dd                	j	80003164 <namex+0x42>
      iunlockput(ip);
    80003180:	854e                	mv	a0,s3
    80003182:	00000097          	auipc	ra,0x0
    80003186:	c6e080e7          	jalr	-914(ra) # 80002df0 <iunlockput>
      return 0;
    8000318a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000318c:	854e                	mv	a0,s3
    8000318e:	60e6                	ld	ra,88(sp)
    80003190:	6446                	ld	s0,80(sp)
    80003192:	64a6                	ld	s1,72(sp)
    80003194:	6906                	ld	s2,64(sp)
    80003196:	79e2                	ld	s3,56(sp)
    80003198:	7a42                	ld	s4,48(sp)
    8000319a:	7aa2                	ld	s5,40(sp)
    8000319c:	7b02                	ld	s6,32(sp)
    8000319e:	6be2                	ld	s7,24(sp)
    800031a0:	6c42                	ld	s8,16(sp)
    800031a2:	6ca2                	ld	s9,8(sp)
    800031a4:	6125                	addi	sp,sp,96
    800031a6:	8082                	ret
      iunlock(ip);
    800031a8:	854e                	mv	a0,s3
    800031aa:	00000097          	auipc	ra,0x0
    800031ae:	aa6080e7          	jalr	-1370(ra) # 80002c50 <iunlock>
      return ip;
    800031b2:	bfe9                	j	8000318c <namex+0x6a>
      iunlockput(ip);
    800031b4:	854e                	mv	a0,s3
    800031b6:	00000097          	auipc	ra,0x0
    800031ba:	c3a080e7          	jalr	-966(ra) # 80002df0 <iunlockput>
      return 0;
    800031be:	89d2                	mv	s3,s4
    800031c0:	b7f1                	j	8000318c <namex+0x6a>
  len = path - s;
    800031c2:	40b48633          	sub	a2,s1,a1
    800031c6:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031ca:	094cd463          	bge	s9,s4,80003252 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031ce:	4639                	li	a2,14
    800031d0:	8556                	mv	a0,s5
    800031d2:	ffffd097          	auipc	ra,0xffffd
    800031d6:	006080e7          	jalr	6(ra) # 800001d8 <memmove>
  while(*path == '/')
    800031da:	0004c783          	lbu	a5,0(s1)
    800031de:	01279763          	bne	a5,s2,800031ec <namex+0xca>
    path++;
    800031e2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031e4:	0004c783          	lbu	a5,0(s1)
    800031e8:	ff278de3          	beq	a5,s2,800031e2 <namex+0xc0>
    ilock(ip);
    800031ec:	854e                	mv	a0,s3
    800031ee:	00000097          	auipc	ra,0x0
    800031f2:	9a0080e7          	jalr	-1632(ra) # 80002b8e <ilock>
    if(ip->type != T_DIR){
    800031f6:	04499783          	lh	a5,68(s3)
    800031fa:	f98793e3          	bne	a5,s8,80003180 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800031fe:	000b0563          	beqz	s6,80003208 <namex+0xe6>
    80003202:	0004c783          	lbu	a5,0(s1)
    80003206:	d3cd                	beqz	a5,800031a8 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003208:	865e                	mv	a2,s7
    8000320a:	85d6                	mv	a1,s5
    8000320c:	854e                	mv	a0,s3
    8000320e:	00000097          	auipc	ra,0x0
    80003212:	e64080e7          	jalr	-412(ra) # 80003072 <dirlookup>
    80003216:	8a2a                	mv	s4,a0
    80003218:	dd51                	beqz	a0,800031b4 <namex+0x92>
    iunlockput(ip);
    8000321a:	854e                	mv	a0,s3
    8000321c:	00000097          	auipc	ra,0x0
    80003220:	bd4080e7          	jalr	-1068(ra) # 80002df0 <iunlockput>
    ip = next;
    80003224:	89d2                	mv	s3,s4
  while(*path == '/')
    80003226:	0004c783          	lbu	a5,0(s1)
    8000322a:	05279763          	bne	a5,s2,80003278 <namex+0x156>
    path++;
    8000322e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003230:	0004c783          	lbu	a5,0(s1)
    80003234:	ff278de3          	beq	a5,s2,8000322e <namex+0x10c>
  if(*path == 0)
    80003238:	c79d                	beqz	a5,80003266 <namex+0x144>
    path++;
    8000323a:	85a6                	mv	a1,s1
  len = path - s;
    8000323c:	8a5e                	mv	s4,s7
    8000323e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003240:	01278963          	beq	a5,s2,80003252 <namex+0x130>
    80003244:	dfbd                	beqz	a5,800031c2 <namex+0xa0>
    path++;
    80003246:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003248:	0004c783          	lbu	a5,0(s1)
    8000324c:	ff279ce3          	bne	a5,s2,80003244 <namex+0x122>
    80003250:	bf8d                	j	800031c2 <namex+0xa0>
    memmove(name, s, len);
    80003252:	2601                	sext.w	a2,a2
    80003254:	8556                	mv	a0,s5
    80003256:	ffffd097          	auipc	ra,0xffffd
    8000325a:	f82080e7          	jalr	-126(ra) # 800001d8 <memmove>
    name[len] = 0;
    8000325e:	9a56                	add	s4,s4,s5
    80003260:	000a0023          	sb	zero,0(s4)
    80003264:	bf9d                	j	800031da <namex+0xb8>
  if(nameiparent){
    80003266:	f20b03e3          	beqz	s6,8000318c <namex+0x6a>
    iput(ip);
    8000326a:	854e                	mv	a0,s3
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	adc080e7          	jalr	-1316(ra) # 80002d48 <iput>
    return 0;
    80003274:	4981                	li	s3,0
    80003276:	bf19                	j	8000318c <namex+0x6a>
  if(*path == 0)
    80003278:	d7fd                	beqz	a5,80003266 <namex+0x144>
  while(*path != '/' && *path != 0)
    8000327a:	0004c783          	lbu	a5,0(s1)
    8000327e:	85a6                	mv	a1,s1
    80003280:	b7d1                	j	80003244 <namex+0x122>

0000000080003282 <dirlink>:
{
    80003282:	7139                	addi	sp,sp,-64
    80003284:	fc06                	sd	ra,56(sp)
    80003286:	f822                	sd	s0,48(sp)
    80003288:	f426                	sd	s1,40(sp)
    8000328a:	f04a                	sd	s2,32(sp)
    8000328c:	ec4e                	sd	s3,24(sp)
    8000328e:	e852                	sd	s4,16(sp)
    80003290:	0080                	addi	s0,sp,64
    80003292:	892a                	mv	s2,a0
    80003294:	8a2e                	mv	s4,a1
    80003296:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003298:	4601                	li	a2,0
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	dd8080e7          	jalr	-552(ra) # 80003072 <dirlookup>
    800032a2:	e93d                	bnez	a0,80003318 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a4:	04c92483          	lw	s1,76(s2)
    800032a8:	c49d                	beqz	s1,800032d6 <dirlink+0x54>
    800032aa:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ac:	4741                	li	a4,16
    800032ae:	86a6                	mv	a3,s1
    800032b0:	fc040613          	addi	a2,s0,-64
    800032b4:	4581                	li	a1,0
    800032b6:	854a                	mv	a0,s2
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	b8a080e7          	jalr	-1142(ra) # 80002e42 <readi>
    800032c0:	47c1                	li	a5,16
    800032c2:	06f51163          	bne	a0,a5,80003324 <dirlink+0xa2>
    if(de.inum == 0)
    800032c6:	fc045783          	lhu	a5,-64(s0)
    800032ca:	c791                	beqz	a5,800032d6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032cc:	24c1                	addiw	s1,s1,16
    800032ce:	04c92783          	lw	a5,76(s2)
    800032d2:	fcf4ede3          	bltu	s1,a5,800032ac <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032d6:	4639                	li	a2,14
    800032d8:	85d2                	mv	a1,s4
    800032da:	fc240513          	addi	a0,s0,-62
    800032de:	ffffd097          	auipc	ra,0xffffd
    800032e2:	fae080e7          	jalr	-82(ra) # 8000028c <strncpy>
  de.inum = inum;
    800032e6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ea:	4741                	li	a4,16
    800032ec:	86a6                	mv	a3,s1
    800032ee:	fc040613          	addi	a2,s0,-64
    800032f2:	4581                	li	a1,0
    800032f4:	854a                	mv	a0,s2
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	c44080e7          	jalr	-956(ra) # 80002f3a <writei>
    800032fe:	872a                	mv	a4,a0
    80003300:	47c1                	li	a5,16
  return 0;
    80003302:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003304:	02f71863          	bne	a4,a5,80003334 <dirlink+0xb2>
}
    80003308:	70e2                	ld	ra,56(sp)
    8000330a:	7442                	ld	s0,48(sp)
    8000330c:	74a2                	ld	s1,40(sp)
    8000330e:	7902                	ld	s2,32(sp)
    80003310:	69e2                	ld	s3,24(sp)
    80003312:	6a42                	ld	s4,16(sp)
    80003314:	6121                	addi	sp,sp,64
    80003316:	8082                	ret
    iput(ip);
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	a30080e7          	jalr	-1488(ra) # 80002d48 <iput>
    return -1;
    80003320:	557d                	li	a0,-1
    80003322:	b7dd                	j	80003308 <dirlink+0x86>
      panic("dirlink read");
    80003324:	00005517          	auipc	a0,0x5
    80003328:	27c50513          	addi	a0,a0,636 # 800085a0 <syscalls+0x1d8>
    8000332c:	00003097          	auipc	ra,0x3
    80003330:	99a080e7          	jalr	-1638(ra) # 80005cc6 <panic>
    panic("dirlink");
    80003334:	00005517          	auipc	a0,0x5
    80003338:	37c50513          	addi	a0,a0,892 # 800086b0 <syscalls+0x2e8>
    8000333c:	00003097          	auipc	ra,0x3
    80003340:	98a080e7          	jalr	-1654(ra) # 80005cc6 <panic>

0000000080003344 <namei>:

struct inode*
namei(char *path)
{
    80003344:	1101                	addi	sp,sp,-32
    80003346:	ec06                	sd	ra,24(sp)
    80003348:	e822                	sd	s0,16(sp)
    8000334a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000334c:	fe040613          	addi	a2,s0,-32
    80003350:	4581                	li	a1,0
    80003352:	00000097          	auipc	ra,0x0
    80003356:	dd0080e7          	jalr	-560(ra) # 80003122 <namex>
}
    8000335a:	60e2                	ld	ra,24(sp)
    8000335c:	6442                	ld	s0,16(sp)
    8000335e:	6105                	addi	sp,sp,32
    80003360:	8082                	ret

0000000080003362 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003362:	1141                	addi	sp,sp,-16
    80003364:	e406                	sd	ra,8(sp)
    80003366:	e022                	sd	s0,0(sp)
    80003368:	0800                	addi	s0,sp,16
    8000336a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000336c:	4585                	li	a1,1
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	db4080e7          	jalr	-588(ra) # 80003122 <namex>
}
    80003376:	60a2                	ld	ra,8(sp)
    80003378:	6402                	ld	s0,0(sp)
    8000337a:	0141                	addi	sp,sp,16
    8000337c:	8082                	ret

000000008000337e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000337e:	1101                	addi	sp,sp,-32
    80003380:	ec06                	sd	ra,24(sp)
    80003382:	e822                	sd	s0,16(sp)
    80003384:	e426                	sd	s1,8(sp)
    80003386:	e04a                	sd	s2,0(sp)
    80003388:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000338a:	00016917          	auipc	s2,0x16
    8000338e:	49690913          	addi	s2,s2,1174 # 80019820 <log>
    80003392:	01892583          	lw	a1,24(s2)
    80003396:	02892503          	lw	a0,40(s2)
    8000339a:	fffff097          	auipc	ra,0xfffff
    8000339e:	ff2080e7          	jalr	-14(ra) # 8000238c <bread>
    800033a2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033a4:	02c92683          	lw	a3,44(s2)
    800033a8:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033aa:	02d05763          	blez	a3,800033d8 <write_head+0x5a>
    800033ae:	00016797          	auipc	a5,0x16
    800033b2:	4a278793          	addi	a5,a5,1186 # 80019850 <log+0x30>
    800033b6:	05c50713          	addi	a4,a0,92
    800033ba:	36fd                	addiw	a3,a3,-1
    800033bc:	1682                	slli	a3,a3,0x20
    800033be:	9281                	srli	a3,a3,0x20
    800033c0:	068a                	slli	a3,a3,0x2
    800033c2:	00016617          	auipc	a2,0x16
    800033c6:	49260613          	addi	a2,a2,1170 # 80019854 <log+0x34>
    800033ca:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033cc:	4390                	lw	a2,0(a5)
    800033ce:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033d0:	0791                	addi	a5,a5,4
    800033d2:	0711                	addi	a4,a4,4
    800033d4:	fed79ce3          	bne	a5,a3,800033cc <write_head+0x4e>
  }
  bwrite(buf);
    800033d8:	8526                	mv	a0,s1
    800033da:	fffff097          	auipc	ra,0xfffff
    800033de:	0a4080e7          	jalr	164(ra) # 8000247e <bwrite>
  brelse(buf);
    800033e2:	8526                	mv	a0,s1
    800033e4:	fffff097          	auipc	ra,0xfffff
    800033e8:	0d8080e7          	jalr	216(ra) # 800024bc <brelse>
}
    800033ec:	60e2                	ld	ra,24(sp)
    800033ee:	6442                	ld	s0,16(sp)
    800033f0:	64a2                	ld	s1,8(sp)
    800033f2:	6902                	ld	s2,0(sp)
    800033f4:	6105                	addi	sp,sp,32
    800033f6:	8082                	ret

00000000800033f8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033f8:	00016797          	auipc	a5,0x16
    800033fc:	4547a783          	lw	a5,1108(a5) # 8001984c <log+0x2c>
    80003400:	0af05d63          	blez	a5,800034ba <install_trans+0xc2>
{
    80003404:	7139                	addi	sp,sp,-64
    80003406:	fc06                	sd	ra,56(sp)
    80003408:	f822                	sd	s0,48(sp)
    8000340a:	f426                	sd	s1,40(sp)
    8000340c:	f04a                	sd	s2,32(sp)
    8000340e:	ec4e                	sd	s3,24(sp)
    80003410:	e852                	sd	s4,16(sp)
    80003412:	e456                	sd	s5,8(sp)
    80003414:	e05a                	sd	s6,0(sp)
    80003416:	0080                	addi	s0,sp,64
    80003418:	8b2a                	mv	s6,a0
    8000341a:	00016a97          	auipc	s5,0x16
    8000341e:	436a8a93          	addi	s5,s5,1078 # 80019850 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003422:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003424:	00016997          	auipc	s3,0x16
    80003428:	3fc98993          	addi	s3,s3,1020 # 80019820 <log>
    8000342c:	a035                	j	80003458 <install_trans+0x60>
      bunpin(dbuf);
    8000342e:	8526                	mv	a0,s1
    80003430:	fffff097          	auipc	ra,0xfffff
    80003434:	166080e7          	jalr	358(ra) # 80002596 <bunpin>
    brelse(lbuf);
    80003438:	854a                	mv	a0,s2
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	082080e7          	jalr	130(ra) # 800024bc <brelse>
    brelse(dbuf);
    80003442:	8526                	mv	a0,s1
    80003444:	fffff097          	auipc	ra,0xfffff
    80003448:	078080e7          	jalr	120(ra) # 800024bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000344c:	2a05                	addiw	s4,s4,1
    8000344e:	0a91                	addi	s5,s5,4
    80003450:	02c9a783          	lw	a5,44(s3)
    80003454:	04fa5963          	bge	s4,a5,800034a6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003458:	0189a583          	lw	a1,24(s3)
    8000345c:	014585bb          	addw	a1,a1,s4
    80003460:	2585                	addiw	a1,a1,1
    80003462:	0289a503          	lw	a0,40(s3)
    80003466:	fffff097          	auipc	ra,0xfffff
    8000346a:	f26080e7          	jalr	-218(ra) # 8000238c <bread>
    8000346e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003470:	000aa583          	lw	a1,0(s5)
    80003474:	0289a503          	lw	a0,40(s3)
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	f14080e7          	jalr	-236(ra) # 8000238c <bread>
    80003480:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003482:	40000613          	li	a2,1024
    80003486:	05890593          	addi	a1,s2,88
    8000348a:	05850513          	addi	a0,a0,88
    8000348e:	ffffd097          	auipc	ra,0xffffd
    80003492:	d4a080e7          	jalr	-694(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003496:	8526                	mv	a0,s1
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	fe6080e7          	jalr	-26(ra) # 8000247e <bwrite>
    if(recovering == 0)
    800034a0:	f80b1ce3          	bnez	s6,80003438 <install_trans+0x40>
    800034a4:	b769                	j	8000342e <install_trans+0x36>
}
    800034a6:	70e2                	ld	ra,56(sp)
    800034a8:	7442                	ld	s0,48(sp)
    800034aa:	74a2                	ld	s1,40(sp)
    800034ac:	7902                	ld	s2,32(sp)
    800034ae:	69e2                	ld	s3,24(sp)
    800034b0:	6a42                	ld	s4,16(sp)
    800034b2:	6aa2                	ld	s5,8(sp)
    800034b4:	6b02                	ld	s6,0(sp)
    800034b6:	6121                	addi	sp,sp,64
    800034b8:	8082                	ret
    800034ba:	8082                	ret

00000000800034bc <initlog>:
{
    800034bc:	7179                	addi	sp,sp,-48
    800034be:	f406                	sd	ra,40(sp)
    800034c0:	f022                	sd	s0,32(sp)
    800034c2:	ec26                	sd	s1,24(sp)
    800034c4:	e84a                	sd	s2,16(sp)
    800034c6:	e44e                	sd	s3,8(sp)
    800034c8:	1800                	addi	s0,sp,48
    800034ca:	892a                	mv	s2,a0
    800034cc:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034ce:	00016497          	auipc	s1,0x16
    800034d2:	35248493          	addi	s1,s1,850 # 80019820 <log>
    800034d6:	00005597          	auipc	a1,0x5
    800034da:	0da58593          	addi	a1,a1,218 # 800085b0 <syscalls+0x1e8>
    800034de:	8526                	mv	a0,s1
    800034e0:	00003097          	auipc	ra,0x3
    800034e4:	c76080e7          	jalr	-906(ra) # 80006156 <initlock>
  log.start = sb->logstart;
    800034e8:	0149a583          	lw	a1,20(s3)
    800034ec:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034ee:	0109a783          	lw	a5,16(s3)
    800034f2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034f4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034f8:	854a                	mv	a0,s2
    800034fa:	fffff097          	auipc	ra,0xfffff
    800034fe:	e92080e7          	jalr	-366(ra) # 8000238c <bread>
  log.lh.n = lh->n;
    80003502:	4d3c                	lw	a5,88(a0)
    80003504:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003506:	02f05563          	blez	a5,80003530 <initlog+0x74>
    8000350a:	05c50713          	addi	a4,a0,92
    8000350e:	00016697          	auipc	a3,0x16
    80003512:	34268693          	addi	a3,a3,834 # 80019850 <log+0x30>
    80003516:	37fd                	addiw	a5,a5,-1
    80003518:	1782                	slli	a5,a5,0x20
    8000351a:	9381                	srli	a5,a5,0x20
    8000351c:	078a                	slli	a5,a5,0x2
    8000351e:	06050613          	addi	a2,a0,96
    80003522:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003524:	4310                	lw	a2,0(a4)
    80003526:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003528:	0711                	addi	a4,a4,4
    8000352a:	0691                	addi	a3,a3,4
    8000352c:	fef71ce3          	bne	a4,a5,80003524 <initlog+0x68>
  brelse(buf);
    80003530:	fffff097          	auipc	ra,0xfffff
    80003534:	f8c080e7          	jalr	-116(ra) # 800024bc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003538:	4505                	li	a0,1
    8000353a:	00000097          	auipc	ra,0x0
    8000353e:	ebe080e7          	jalr	-322(ra) # 800033f8 <install_trans>
  log.lh.n = 0;
    80003542:	00016797          	auipc	a5,0x16
    80003546:	3007a523          	sw	zero,778(a5) # 8001984c <log+0x2c>
  write_head(); // clear the log
    8000354a:	00000097          	auipc	ra,0x0
    8000354e:	e34080e7          	jalr	-460(ra) # 8000337e <write_head>
}
    80003552:	70a2                	ld	ra,40(sp)
    80003554:	7402                	ld	s0,32(sp)
    80003556:	64e2                	ld	s1,24(sp)
    80003558:	6942                	ld	s2,16(sp)
    8000355a:	69a2                	ld	s3,8(sp)
    8000355c:	6145                	addi	sp,sp,48
    8000355e:	8082                	ret

0000000080003560 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003560:	1101                	addi	sp,sp,-32
    80003562:	ec06                	sd	ra,24(sp)
    80003564:	e822                	sd	s0,16(sp)
    80003566:	e426                	sd	s1,8(sp)
    80003568:	e04a                	sd	s2,0(sp)
    8000356a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000356c:	00016517          	auipc	a0,0x16
    80003570:	2b450513          	addi	a0,a0,692 # 80019820 <log>
    80003574:	00003097          	auipc	ra,0x3
    80003578:	c72080e7          	jalr	-910(ra) # 800061e6 <acquire>
  while(1){
    if(log.committing){
    8000357c:	00016497          	auipc	s1,0x16
    80003580:	2a448493          	addi	s1,s1,676 # 80019820 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003584:	4979                	li	s2,30
    80003586:	a039                	j	80003594 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003588:	85a6                	mv	a1,s1
    8000358a:	8526                	mv	a0,s1
    8000358c:	ffffe097          	auipc	ra,0xffffe
    80003590:	fae080e7          	jalr	-82(ra) # 8000153a <sleep>
    if(log.committing){
    80003594:	50dc                	lw	a5,36(s1)
    80003596:	fbed                	bnez	a5,80003588 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003598:	509c                	lw	a5,32(s1)
    8000359a:	0017871b          	addiw	a4,a5,1
    8000359e:	0007069b          	sext.w	a3,a4
    800035a2:	0027179b          	slliw	a5,a4,0x2
    800035a6:	9fb9                	addw	a5,a5,a4
    800035a8:	0017979b          	slliw	a5,a5,0x1
    800035ac:	54d8                	lw	a4,44(s1)
    800035ae:	9fb9                	addw	a5,a5,a4
    800035b0:	00f95963          	bge	s2,a5,800035c2 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035b4:	85a6                	mv	a1,s1
    800035b6:	8526                	mv	a0,s1
    800035b8:	ffffe097          	auipc	ra,0xffffe
    800035bc:	f82080e7          	jalr	-126(ra) # 8000153a <sleep>
    800035c0:	bfd1                	j	80003594 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035c2:	00016517          	auipc	a0,0x16
    800035c6:	25e50513          	addi	a0,a0,606 # 80019820 <log>
    800035ca:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035cc:	00003097          	auipc	ra,0x3
    800035d0:	cce080e7          	jalr	-818(ra) # 8000629a <release>
      break;
    }
  }
}
    800035d4:	60e2                	ld	ra,24(sp)
    800035d6:	6442                	ld	s0,16(sp)
    800035d8:	64a2                	ld	s1,8(sp)
    800035da:	6902                	ld	s2,0(sp)
    800035dc:	6105                	addi	sp,sp,32
    800035de:	8082                	ret

00000000800035e0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035e0:	7139                	addi	sp,sp,-64
    800035e2:	fc06                	sd	ra,56(sp)
    800035e4:	f822                	sd	s0,48(sp)
    800035e6:	f426                	sd	s1,40(sp)
    800035e8:	f04a                	sd	s2,32(sp)
    800035ea:	ec4e                	sd	s3,24(sp)
    800035ec:	e852                	sd	s4,16(sp)
    800035ee:	e456                	sd	s5,8(sp)
    800035f0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800035f2:	00016497          	auipc	s1,0x16
    800035f6:	22e48493          	addi	s1,s1,558 # 80019820 <log>
    800035fa:	8526                	mv	a0,s1
    800035fc:	00003097          	auipc	ra,0x3
    80003600:	bea080e7          	jalr	-1046(ra) # 800061e6 <acquire>
  log.outstanding -= 1;
    80003604:	509c                	lw	a5,32(s1)
    80003606:	37fd                	addiw	a5,a5,-1
    80003608:	0007891b          	sext.w	s2,a5
    8000360c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000360e:	50dc                	lw	a5,36(s1)
    80003610:	efb9                	bnez	a5,8000366e <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003612:	06091663          	bnez	s2,8000367e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003616:	00016497          	auipc	s1,0x16
    8000361a:	20a48493          	addi	s1,s1,522 # 80019820 <log>
    8000361e:	4785                	li	a5,1
    80003620:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003622:	8526                	mv	a0,s1
    80003624:	00003097          	auipc	ra,0x3
    80003628:	c76080e7          	jalr	-906(ra) # 8000629a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000362c:	54dc                	lw	a5,44(s1)
    8000362e:	06f04763          	bgtz	a5,8000369c <end_op+0xbc>
    acquire(&log.lock);
    80003632:	00016497          	auipc	s1,0x16
    80003636:	1ee48493          	addi	s1,s1,494 # 80019820 <log>
    8000363a:	8526                	mv	a0,s1
    8000363c:	00003097          	auipc	ra,0x3
    80003640:	baa080e7          	jalr	-1110(ra) # 800061e6 <acquire>
    log.committing = 0;
    80003644:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003648:	8526                	mv	a0,s1
    8000364a:	ffffe097          	auipc	ra,0xffffe
    8000364e:	07c080e7          	jalr	124(ra) # 800016c6 <wakeup>
    release(&log.lock);
    80003652:	8526                	mv	a0,s1
    80003654:	00003097          	auipc	ra,0x3
    80003658:	c46080e7          	jalr	-954(ra) # 8000629a <release>
}
    8000365c:	70e2                	ld	ra,56(sp)
    8000365e:	7442                	ld	s0,48(sp)
    80003660:	74a2                	ld	s1,40(sp)
    80003662:	7902                	ld	s2,32(sp)
    80003664:	69e2                	ld	s3,24(sp)
    80003666:	6a42                	ld	s4,16(sp)
    80003668:	6aa2                	ld	s5,8(sp)
    8000366a:	6121                	addi	sp,sp,64
    8000366c:	8082                	ret
    panic("log.committing");
    8000366e:	00005517          	auipc	a0,0x5
    80003672:	f4a50513          	addi	a0,a0,-182 # 800085b8 <syscalls+0x1f0>
    80003676:	00002097          	auipc	ra,0x2
    8000367a:	650080e7          	jalr	1616(ra) # 80005cc6 <panic>
    wakeup(&log);
    8000367e:	00016497          	auipc	s1,0x16
    80003682:	1a248493          	addi	s1,s1,418 # 80019820 <log>
    80003686:	8526                	mv	a0,s1
    80003688:	ffffe097          	auipc	ra,0xffffe
    8000368c:	03e080e7          	jalr	62(ra) # 800016c6 <wakeup>
  release(&log.lock);
    80003690:	8526                	mv	a0,s1
    80003692:	00003097          	auipc	ra,0x3
    80003696:	c08080e7          	jalr	-1016(ra) # 8000629a <release>
  if(do_commit){
    8000369a:	b7c9                	j	8000365c <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000369c:	00016a97          	auipc	s5,0x16
    800036a0:	1b4a8a93          	addi	s5,s5,436 # 80019850 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036a4:	00016a17          	auipc	s4,0x16
    800036a8:	17ca0a13          	addi	s4,s4,380 # 80019820 <log>
    800036ac:	018a2583          	lw	a1,24(s4)
    800036b0:	012585bb          	addw	a1,a1,s2
    800036b4:	2585                	addiw	a1,a1,1
    800036b6:	028a2503          	lw	a0,40(s4)
    800036ba:	fffff097          	auipc	ra,0xfffff
    800036be:	cd2080e7          	jalr	-814(ra) # 8000238c <bread>
    800036c2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036c4:	000aa583          	lw	a1,0(s5)
    800036c8:	028a2503          	lw	a0,40(s4)
    800036cc:	fffff097          	auipc	ra,0xfffff
    800036d0:	cc0080e7          	jalr	-832(ra) # 8000238c <bread>
    800036d4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036d6:	40000613          	li	a2,1024
    800036da:	05850593          	addi	a1,a0,88
    800036de:	05848513          	addi	a0,s1,88
    800036e2:	ffffd097          	auipc	ra,0xffffd
    800036e6:	af6080e7          	jalr	-1290(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800036ea:	8526                	mv	a0,s1
    800036ec:	fffff097          	auipc	ra,0xfffff
    800036f0:	d92080e7          	jalr	-622(ra) # 8000247e <bwrite>
    brelse(from);
    800036f4:	854e                	mv	a0,s3
    800036f6:	fffff097          	auipc	ra,0xfffff
    800036fa:	dc6080e7          	jalr	-570(ra) # 800024bc <brelse>
    brelse(to);
    800036fe:	8526                	mv	a0,s1
    80003700:	fffff097          	auipc	ra,0xfffff
    80003704:	dbc080e7          	jalr	-580(ra) # 800024bc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003708:	2905                	addiw	s2,s2,1
    8000370a:	0a91                	addi	s5,s5,4
    8000370c:	02ca2783          	lw	a5,44(s4)
    80003710:	f8f94ee3          	blt	s2,a5,800036ac <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003714:	00000097          	auipc	ra,0x0
    80003718:	c6a080e7          	jalr	-918(ra) # 8000337e <write_head>
    install_trans(0); // Now install writes to home locations
    8000371c:	4501                	li	a0,0
    8000371e:	00000097          	auipc	ra,0x0
    80003722:	cda080e7          	jalr	-806(ra) # 800033f8 <install_trans>
    log.lh.n = 0;
    80003726:	00016797          	auipc	a5,0x16
    8000372a:	1207a323          	sw	zero,294(a5) # 8001984c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000372e:	00000097          	auipc	ra,0x0
    80003732:	c50080e7          	jalr	-944(ra) # 8000337e <write_head>
    80003736:	bdf5                	j	80003632 <end_op+0x52>

0000000080003738 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003738:	1101                	addi	sp,sp,-32
    8000373a:	ec06                	sd	ra,24(sp)
    8000373c:	e822                	sd	s0,16(sp)
    8000373e:	e426                	sd	s1,8(sp)
    80003740:	e04a                	sd	s2,0(sp)
    80003742:	1000                	addi	s0,sp,32
    80003744:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003746:	00016917          	auipc	s2,0x16
    8000374a:	0da90913          	addi	s2,s2,218 # 80019820 <log>
    8000374e:	854a                	mv	a0,s2
    80003750:	00003097          	auipc	ra,0x3
    80003754:	a96080e7          	jalr	-1386(ra) # 800061e6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003758:	02c92603          	lw	a2,44(s2)
    8000375c:	47f5                	li	a5,29
    8000375e:	06c7c563          	blt	a5,a2,800037c8 <log_write+0x90>
    80003762:	00016797          	auipc	a5,0x16
    80003766:	0da7a783          	lw	a5,218(a5) # 8001983c <log+0x1c>
    8000376a:	37fd                	addiw	a5,a5,-1
    8000376c:	04f65e63          	bge	a2,a5,800037c8 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003770:	00016797          	auipc	a5,0x16
    80003774:	0d07a783          	lw	a5,208(a5) # 80019840 <log+0x20>
    80003778:	06f05063          	blez	a5,800037d8 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000377c:	4781                	li	a5,0
    8000377e:	06c05563          	blez	a2,800037e8 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003782:	44cc                	lw	a1,12(s1)
    80003784:	00016717          	auipc	a4,0x16
    80003788:	0cc70713          	addi	a4,a4,204 # 80019850 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000378c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000378e:	4314                	lw	a3,0(a4)
    80003790:	04b68c63          	beq	a3,a1,800037e8 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003794:	2785                	addiw	a5,a5,1
    80003796:	0711                	addi	a4,a4,4
    80003798:	fef61be3          	bne	a2,a5,8000378e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000379c:	0621                	addi	a2,a2,8
    8000379e:	060a                	slli	a2,a2,0x2
    800037a0:	00016797          	auipc	a5,0x16
    800037a4:	08078793          	addi	a5,a5,128 # 80019820 <log>
    800037a8:	963e                	add	a2,a2,a5
    800037aa:	44dc                	lw	a5,12(s1)
    800037ac:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037ae:	8526                	mv	a0,s1
    800037b0:	fffff097          	auipc	ra,0xfffff
    800037b4:	daa080e7          	jalr	-598(ra) # 8000255a <bpin>
    log.lh.n++;
    800037b8:	00016717          	auipc	a4,0x16
    800037bc:	06870713          	addi	a4,a4,104 # 80019820 <log>
    800037c0:	575c                	lw	a5,44(a4)
    800037c2:	2785                	addiw	a5,a5,1
    800037c4:	d75c                	sw	a5,44(a4)
    800037c6:	a835                	j	80003802 <log_write+0xca>
    panic("too big a transaction");
    800037c8:	00005517          	auipc	a0,0x5
    800037cc:	e0050513          	addi	a0,a0,-512 # 800085c8 <syscalls+0x200>
    800037d0:	00002097          	auipc	ra,0x2
    800037d4:	4f6080e7          	jalr	1270(ra) # 80005cc6 <panic>
    panic("log_write outside of trans");
    800037d8:	00005517          	auipc	a0,0x5
    800037dc:	e0850513          	addi	a0,a0,-504 # 800085e0 <syscalls+0x218>
    800037e0:	00002097          	auipc	ra,0x2
    800037e4:	4e6080e7          	jalr	1254(ra) # 80005cc6 <panic>
  log.lh.block[i] = b->blockno;
    800037e8:	00878713          	addi	a4,a5,8
    800037ec:	00271693          	slli	a3,a4,0x2
    800037f0:	00016717          	auipc	a4,0x16
    800037f4:	03070713          	addi	a4,a4,48 # 80019820 <log>
    800037f8:	9736                	add	a4,a4,a3
    800037fa:	44d4                	lw	a3,12(s1)
    800037fc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037fe:	faf608e3          	beq	a2,a5,800037ae <log_write+0x76>
  }
  release(&log.lock);
    80003802:	00016517          	auipc	a0,0x16
    80003806:	01e50513          	addi	a0,a0,30 # 80019820 <log>
    8000380a:	00003097          	auipc	ra,0x3
    8000380e:	a90080e7          	jalr	-1392(ra) # 8000629a <release>
}
    80003812:	60e2                	ld	ra,24(sp)
    80003814:	6442                	ld	s0,16(sp)
    80003816:	64a2                	ld	s1,8(sp)
    80003818:	6902                	ld	s2,0(sp)
    8000381a:	6105                	addi	sp,sp,32
    8000381c:	8082                	ret

000000008000381e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000381e:	1101                	addi	sp,sp,-32
    80003820:	ec06                	sd	ra,24(sp)
    80003822:	e822                	sd	s0,16(sp)
    80003824:	e426                	sd	s1,8(sp)
    80003826:	e04a                	sd	s2,0(sp)
    80003828:	1000                	addi	s0,sp,32
    8000382a:	84aa                	mv	s1,a0
    8000382c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000382e:	00005597          	auipc	a1,0x5
    80003832:	dd258593          	addi	a1,a1,-558 # 80008600 <syscalls+0x238>
    80003836:	0521                	addi	a0,a0,8
    80003838:	00003097          	auipc	ra,0x3
    8000383c:	91e080e7          	jalr	-1762(ra) # 80006156 <initlock>
  lk->name = name;
    80003840:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003844:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003848:	0204a423          	sw	zero,40(s1)
}
    8000384c:	60e2                	ld	ra,24(sp)
    8000384e:	6442                	ld	s0,16(sp)
    80003850:	64a2                	ld	s1,8(sp)
    80003852:	6902                	ld	s2,0(sp)
    80003854:	6105                	addi	sp,sp,32
    80003856:	8082                	ret

0000000080003858 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003858:	1101                	addi	sp,sp,-32
    8000385a:	ec06                	sd	ra,24(sp)
    8000385c:	e822                	sd	s0,16(sp)
    8000385e:	e426                	sd	s1,8(sp)
    80003860:	e04a                	sd	s2,0(sp)
    80003862:	1000                	addi	s0,sp,32
    80003864:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003866:	00850913          	addi	s2,a0,8
    8000386a:	854a                	mv	a0,s2
    8000386c:	00003097          	auipc	ra,0x3
    80003870:	97a080e7          	jalr	-1670(ra) # 800061e6 <acquire>
  while (lk->locked) {
    80003874:	409c                	lw	a5,0(s1)
    80003876:	cb89                	beqz	a5,80003888 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003878:	85ca                	mv	a1,s2
    8000387a:	8526                	mv	a0,s1
    8000387c:	ffffe097          	auipc	ra,0xffffe
    80003880:	cbe080e7          	jalr	-834(ra) # 8000153a <sleep>
  while (lk->locked) {
    80003884:	409c                	lw	a5,0(s1)
    80003886:	fbed                	bnez	a5,80003878 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003888:	4785                	li	a5,1
    8000388a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000388c:	ffffd097          	auipc	ra,0xffffd
    80003890:	5bc080e7          	jalr	1468(ra) # 80000e48 <myproc>
    80003894:	591c                	lw	a5,48(a0)
    80003896:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003898:	854a                	mv	a0,s2
    8000389a:	00003097          	auipc	ra,0x3
    8000389e:	a00080e7          	jalr	-1536(ra) # 8000629a <release>
}
    800038a2:	60e2                	ld	ra,24(sp)
    800038a4:	6442                	ld	s0,16(sp)
    800038a6:	64a2                	ld	s1,8(sp)
    800038a8:	6902                	ld	s2,0(sp)
    800038aa:	6105                	addi	sp,sp,32
    800038ac:	8082                	ret

00000000800038ae <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038ae:	1101                	addi	sp,sp,-32
    800038b0:	ec06                	sd	ra,24(sp)
    800038b2:	e822                	sd	s0,16(sp)
    800038b4:	e426                	sd	s1,8(sp)
    800038b6:	e04a                	sd	s2,0(sp)
    800038b8:	1000                	addi	s0,sp,32
    800038ba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038bc:	00850913          	addi	s2,a0,8
    800038c0:	854a                	mv	a0,s2
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	924080e7          	jalr	-1756(ra) # 800061e6 <acquire>
  lk->locked = 0;
    800038ca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038ce:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038d2:	8526                	mv	a0,s1
    800038d4:	ffffe097          	auipc	ra,0xffffe
    800038d8:	df2080e7          	jalr	-526(ra) # 800016c6 <wakeup>
  release(&lk->lk);
    800038dc:	854a                	mv	a0,s2
    800038de:	00003097          	auipc	ra,0x3
    800038e2:	9bc080e7          	jalr	-1604(ra) # 8000629a <release>
}
    800038e6:	60e2                	ld	ra,24(sp)
    800038e8:	6442                	ld	s0,16(sp)
    800038ea:	64a2                	ld	s1,8(sp)
    800038ec:	6902                	ld	s2,0(sp)
    800038ee:	6105                	addi	sp,sp,32
    800038f0:	8082                	ret

00000000800038f2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800038f2:	7179                	addi	sp,sp,-48
    800038f4:	f406                	sd	ra,40(sp)
    800038f6:	f022                	sd	s0,32(sp)
    800038f8:	ec26                	sd	s1,24(sp)
    800038fa:	e84a                	sd	s2,16(sp)
    800038fc:	e44e                	sd	s3,8(sp)
    800038fe:	1800                	addi	s0,sp,48
    80003900:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003902:	00850913          	addi	s2,a0,8
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	8de080e7          	jalr	-1826(ra) # 800061e6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003910:	409c                	lw	a5,0(s1)
    80003912:	ef99                	bnez	a5,80003930 <holdingsleep+0x3e>
    80003914:	4481                	li	s1,0
  release(&lk->lk);
    80003916:	854a                	mv	a0,s2
    80003918:	00003097          	auipc	ra,0x3
    8000391c:	982080e7          	jalr	-1662(ra) # 8000629a <release>
  return r;
}
    80003920:	8526                	mv	a0,s1
    80003922:	70a2                	ld	ra,40(sp)
    80003924:	7402                	ld	s0,32(sp)
    80003926:	64e2                	ld	s1,24(sp)
    80003928:	6942                	ld	s2,16(sp)
    8000392a:	69a2                	ld	s3,8(sp)
    8000392c:	6145                	addi	sp,sp,48
    8000392e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003930:	0284a983          	lw	s3,40(s1)
    80003934:	ffffd097          	auipc	ra,0xffffd
    80003938:	514080e7          	jalr	1300(ra) # 80000e48 <myproc>
    8000393c:	5904                	lw	s1,48(a0)
    8000393e:	413484b3          	sub	s1,s1,s3
    80003942:	0014b493          	seqz	s1,s1
    80003946:	bfc1                	j	80003916 <holdingsleep+0x24>

0000000080003948 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003948:	1141                	addi	sp,sp,-16
    8000394a:	e406                	sd	ra,8(sp)
    8000394c:	e022                	sd	s0,0(sp)
    8000394e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003950:	00005597          	auipc	a1,0x5
    80003954:	cc058593          	addi	a1,a1,-832 # 80008610 <syscalls+0x248>
    80003958:	00016517          	auipc	a0,0x16
    8000395c:	01050513          	addi	a0,a0,16 # 80019968 <ftable>
    80003960:	00002097          	auipc	ra,0x2
    80003964:	7f6080e7          	jalr	2038(ra) # 80006156 <initlock>
}
    80003968:	60a2                	ld	ra,8(sp)
    8000396a:	6402                	ld	s0,0(sp)
    8000396c:	0141                	addi	sp,sp,16
    8000396e:	8082                	ret

0000000080003970 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003970:	1101                	addi	sp,sp,-32
    80003972:	ec06                	sd	ra,24(sp)
    80003974:	e822                	sd	s0,16(sp)
    80003976:	e426                	sd	s1,8(sp)
    80003978:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000397a:	00016517          	auipc	a0,0x16
    8000397e:	fee50513          	addi	a0,a0,-18 # 80019968 <ftable>
    80003982:	00003097          	auipc	ra,0x3
    80003986:	864080e7          	jalr	-1948(ra) # 800061e6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000398a:	00016497          	auipc	s1,0x16
    8000398e:	ff648493          	addi	s1,s1,-10 # 80019980 <ftable+0x18>
    80003992:	00017717          	auipc	a4,0x17
    80003996:	f8e70713          	addi	a4,a4,-114 # 8001a920 <ftable+0xfb8>
    if(f->ref == 0){
    8000399a:	40dc                	lw	a5,4(s1)
    8000399c:	cf99                	beqz	a5,800039ba <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000399e:	02848493          	addi	s1,s1,40
    800039a2:	fee49ce3          	bne	s1,a4,8000399a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039a6:	00016517          	auipc	a0,0x16
    800039aa:	fc250513          	addi	a0,a0,-62 # 80019968 <ftable>
    800039ae:	00003097          	auipc	ra,0x3
    800039b2:	8ec080e7          	jalr	-1812(ra) # 8000629a <release>
  return 0;
    800039b6:	4481                	li	s1,0
    800039b8:	a819                	j	800039ce <filealloc+0x5e>
      f->ref = 1;
    800039ba:	4785                	li	a5,1
    800039bc:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039be:	00016517          	auipc	a0,0x16
    800039c2:	faa50513          	addi	a0,a0,-86 # 80019968 <ftable>
    800039c6:	00003097          	auipc	ra,0x3
    800039ca:	8d4080e7          	jalr	-1836(ra) # 8000629a <release>
}
    800039ce:	8526                	mv	a0,s1
    800039d0:	60e2                	ld	ra,24(sp)
    800039d2:	6442                	ld	s0,16(sp)
    800039d4:	64a2                	ld	s1,8(sp)
    800039d6:	6105                	addi	sp,sp,32
    800039d8:	8082                	ret

00000000800039da <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039da:	1101                	addi	sp,sp,-32
    800039dc:	ec06                	sd	ra,24(sp)
    800039de:	e822                	sd	s0,16(sp)
    800039e0:	e426                	sd	s1,8(sp)
    800039e2:	1000                	addi	s0,sp,32
    800039e4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039e6:	00016517          	auipc	a0,0x16
    800039ea:	f8250513          	addi	a0,a0,-126 # 80019968 <ftable>
    800039ee:	00002097          	auipc	ra,0x2
    800039f2:	7f8080e7          	jalr	2040(ra) # 800061e6 <acquire>
  if(f->ref < 1)
    800039f6:	40dc                	lw	a5,4(s1)
    800039f8:	02f05263          	blez	a5,80003a1c <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039fc:	2785                	addiw	a5,a5,1
    800039fe:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a00:	00016517          	auipc	a0,0x16
    80003a04:	f6850513          	addi	a0,a0,-152 # 80019968 <ftable>
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	892080e7          	jalr	-1902(ra) # 8000629a <release>
  return f;
}
    80003a10:	8526                	mv	a0,s1
    80003a12:	60e2                	ld	ra,24(sp)
    80003a14:	6442                	ld	s0,16(sp)
    80003a16:	64a2                	ld	s1,8(sp)
    80003a18:	6105                	addi	sp,sp,32
    80003a1a:	8082                	ret
    panic("filedup");
    80003a1c:	00005517          	auipc	a0,0x5
    80003a20:	bfc50513          	addi	a0,a0,-1028 # 80008618 <syscalls+0x250>
    80003a24:	00002097          	auipc	ra,0x2
    80003a28:	2a2080e7          	jalr	674(ra) # 80005cc6 <panic>

0000000080003a2c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a2c:	7139                	addi	sp,sp,-64
    80003a2e:	fc06                	sd	ra,56(sp)
    80003a30:	f822                	sd	s0,48(sp)
    80003a32:	f426                	sd	s1,40(sp)
    80003a34:	f04a                	sd	s2,32(sp)
    80003a36:	ec4e                	sd	s3,24(sp)
    80003a38:	e852                	sd	s4,16(sp)
    80003a3a:	e456                	sd	s5,8(sp)
    80003a3c:	0080                	addi	s0,sp,64
    80003a3e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a40:	00016517          	auipc	a0,0x16
    80003a44:	f2850513          	addi	a0,a0,-216 # 80019968 <ftable>
    80003a48:	00002097          	auipc	ra,0x2
    80003a4c:	79e080e7          	jalr	1950(ra) # 800061e6 <acquire>
  if(f->ref < 1)
    80003a50:	40dc                	lw	a5,4(s1)
    80003a52:	06f05163          	blez	a5,80003ab4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a56:	37fd                	addiw	a5,a5,-1
    80003a58:	0007871b          	sext.w	a4,a5
    80003a5c:	c0dc                	sw	a5,4(s1)
    80003a5e:	06e04363          	bgtz	a4,80003ac4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a62:	0004a903          	lw	s2,0(s1)
    80003a66:	0094ca83          	lbu	s5,9(s1)
    80003a6a:	0104ba03          	ld	s4,16(s1)
    80003a6e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a72:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a76:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a7a:	00016517          	auipc	a0,0x16
    80003a7e:	eee50513          	addi	a0,a0,-274 # 80019968 <ftable>
    80003a82:	00003097          	auipc	ra,0x3
    80003a86:	818080e7          	jalr	-2024(ra) # 8000629a <release>

  if(ff.type == FD_PIPE){
    80003a8a:	4785                	li	a5,1
    80003a8c:	04f90d63          	beq	s2,a5,80003ae6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a90:	3979                	addiw	s2,s2,-2
    80003a92:	4785                	li	a5,1
    80003a94:	0527e063          	bltu	a5,s2,80003ad4 <fileclose+0xa8>
    begin_op();
    80003a98:	00000097          	auipc	ra,0x0
    80003a9c:	ac8080e7          	jalr	-1336(ra) # 80003560 <begin_op>
    iput(ff.ip);
    80003aa0:	854e                	mv	a0,s3
    80003aa2:	fffff097          	auipc	ra,0xfffff
    80003aa6:	2a6080e7          	jalr	678(ra) # 80002d48 <iput>
    end_op();
    80003aaa:	00000097          	auipc	ra,0x0
    80003aae:	b36080e7          	jalr	-1226(ra) # 800035e0 <end_op>
    80003ab2:	a00d                	j	80003ad4 <fileclose+0xa8>
    panic("fileclose");
    80003ab4:	00005517          	auipc	a0,0x5
    80003ab8:	b6c50513          	addi	a0,a0,-1172 # 80008620 <syscalls+0x258>
    80003abc:	00002097          	auipc	ra,0x2
    80003ac0:	20a080e7          	jalr	522(ra) # 80005cc6 <panic>
    release(&ftable.lock);
    80003ac4:	00016517          	auipc	a0,0x16
    80003ac8:	ea450513          	addi	a0,a0,-348 # 80019968 <ftable>
    80003acc:	00002097          	auipc	ra,0x2
    80003ad0:	7ce080e7          	jalr	1998(ra) # 8000629a <release>
  }
}
    80003ad4:	70e2                	ld	ra,56(sp)
    80003ad6:	7442                	ld	s0,48(sp)
    80003ad8:	74a2                	ld	s1,40(sp)
    80003ada:	7902                	ld	s2,32(sp)
    80003adc:	69e2                	ld	s3,24(sp)
    80003ade:	6a42                	ld	s4,16(sp)
    80003ae0:	6aa2                	ld	s5,8(sp)
    80003ae2:	6121                	addi	sp,sp,64
    80003ae4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ae6:	85d6                	mv	a1,s5
    80003ae8:	8552                	mv	a0,s4
    80003aea:	00000097          	auipc	ra,0x0
    80003aee:	34c080e7          	jalr	844(ra) # 80003e36 <pipeclose>
    80003af2:	b7cd                	j	80003ad4 <fileclose+0xa8>

0000000080003af4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003af4:	715d                	addi	sp,sp,-80
    80003af6:	e486                	sd	ra,72(sp)
    80003af8:	e0a2                	sd	s0,64(sp)
    80003afa:	fc26                	sd	s1,56(sp)
    80003afc:	f84a                	sd	s2,48(sp)
    80003afe:	f44e                	sd	s3,40(sp)
    80003b00:	0880                	addi	s0,sp,80
    80003b02:	84aa                	mv	s1,a0
    80003b04:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b06:	ffffd097          	auipc	ra,0xffffd
    80003b0a:	342080e7          	jalr	834(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b0e:	409c                	lw	a5,0(s1)
    80003b10:	37f9                	addiw	a5,a5,-2
    80003b12:	4705                	li	a4,1
    80003b14:	04f76763          	bltu	a4,a5,80003b62 <filestat+0x6e>
    80003b18:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b1a:	6c88                	ld	a0,24(s1)
    80003b1c:	fffff097          	auipc	ra,0xfffff
    80003b20:	072080e7          	jalr	114(ra) # 80002b8e <ilock>
    stati(f->ip, &st);
    80003b24:	fb840593          	addi	a1,s0,-72
    80003b28:	6c88                	ld	a0,24(s1)
    80003b2a:	fffff097          	auipc	ra,0xfffff
    80003b2e:	2ee080e7          	jalr	750(ra) # 80002e18 <stati>
    iunlock(f->ip);
    80003b32:	6c88                	ld	a0,24(s1)
    80003b34:	fffff097          	auipc	ra,0xfffff
    80003b38:	11c080e7          	jalr	284(ra) # 80002c50 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b3c:	46e1                	li	a3,24
    80003b3e:	fb840613          	addi	a2,s0,-72
    80003b42:	85ce                	mv	a1,s3
    80003b44:	05093503          	ld	a0,80(s2)
    80003b48:	ffffd097          	auipc	ra,0xffffd
    80003b4c:	fc2080e7          	jalr	-62(ra) # 80000b0a <copyout>
    80003b50:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b54:	60a6                	ld	ra,72(sp)
    80003b56:	6406                	ld	s0,64(sp)
    80003b58:	74e2                	ld	s1,56(sp)
    80003b5a:	7942                	ld	s2,48(sp)
    80003b5c:	79a2                	ld	s3,40(sp)
    80003b5e:	6161                	addi	sp,sp,80
    80003b60:	8082                	ret
  return -1;
    80003b62:	557d                	li	a0,-1
    80003b64:	bfc5                	j	80003b54 <filestat+0x60>

0000000080003b66 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b66:	7179                	addi	sp,sp,-48
    80003b68:	f406                	sd	ra,40(sp)
    80003b6a:	f022                	sd	s0,32(sp)
    80003b6c:	ec26                	sd	s1,24(sp)
    80003b6e:	e84a                	sd	s2,16(sp)
    80003b70:	e44e                	sd	s3,8(sp)
    80003b72:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b74:	00854783          	lbu	a5,8(a0)
    80003b78:	c3d5                	beqz	a5,80003c1c <fileread+0xb6>
    80003b7a:	84aa                	mv	s1,a0
    80003b7c:	89ae                	mv	s3,a1
    80003b7e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b80:	411c                	lw	a5,0(a0)
    80003b82:	4705                	li	a4,1
    80003b84:	04e78963          	beq	a5,a4,80003bd6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b88:	470d                	li	a4,3
    80003b8a:	04e78d63          	beq	a5,a4,80003be4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b8e:	4709                	li	a4,2
    80003b90:	06e79e63          	bne	a5,a4,80003c0c <fileread+0xa6>
    ilock(f->ip);
    80003b94:	6d08                	ld	a0,24(a0)
    80003b96:	fffff097          	auipc	ra,0xfffff
    80003b9a:	ff8080e7          	jalr	-8(ra) # 80002b8e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b9e:	874a                	mv	a4,s2
    80003ba0:	5094                	lw	a3,32(s1)
    80003ba2:	864e                	mv	a2,s3
    80003ba4:	4585                	li	a1,1
    80003ba6:	6c88                	ld	a0,24(s1)
    80003ba8:	fffff097          	auipc	ra,0xfffff
    80003bac:	29a080e7          	jalr	666(ra) # 80002e42 <readi>
    80003bb0:	892a                	mv	s2,a0
    80003bb2:	00a05563          	blez	a0,80003bbc <fileread+0x56>
      f->off += r;
    80003bb6:	509c                	lw	a5,32(s1)
    80003bb8:	9fa9                	addw	a5,a5,a0
    80003bba:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bbc:	6c88                	ld	a0,24(s1)
    80003bbe:	fffff097          	auipc	ra,0xfffff
    80003bc2:	092080e7          	jalr	146(ra) # 80002c50 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bc6:	854a                	mv	a0,s2
    80003bc8:	70a2                	ld	ra,40(sp)
    80003bca:	7402                	ld	s0,32(sp)
    80003bcc:	64e2                	ld	s1,24(sp)
    80003bce:	6942                	ld	s2,16(sp)
    80003bd0:	69a2                	ld	s3,8(sp)
    80003bd2:	6145                	addi	sp,sp,48
    80003bd4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bd6:	6908                	ld	a0,16(a0)
    80003bd8:	00000097          	auipc	ra,0x0
    80003bdc:	3c8080e7          	jalr	968(ra) # 80003fa0 <piperead>
    80003be0:	892a                	mv	s2,a0
    80003be2:	b7d5                	j	80003bc6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003be4:	02451783          	lh	a5,36(a0)
    80003be8:	03079693          	slli	a3,a5,0x30
    80003bec:	92c1                	srli	a3,a3,0x30
    80003bee:	4725                	li	a4,9
    80003bf0:	02d76863          	bltu	a4,a3,80003c20 <fileread+0xba>
    80003bf4:	0792                	slli	a5,a5,0x4
    80003bf6:	00016717          	auipc	a4,0x16
    80003bfa:	cd270713          	addi	a4,a4,-814 # 800198c8 <devsw>
    80003bfe:	97ba                	add	a5,a5,a4
    80003c00:	639c                	ld	a5,0(a5)
    80003c02:	c38d                	beqz	a5,80003c24 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c04:	4505                	li	a0,1
    80003c06:	9782                	jalr	a5
    80003c08:	892a                	mv	s2,a0
    80003c0a:	bf75                	j	80003bc6 <fileread+0x60>
    panic("fileread");
    80003c0c:	00005517          	auipc	a0,0x5
    80003c10:	a2450513          	addi	a0,a0,-1500 # 80008630 <syscalls+0x268>
    80003c14:	00002097          	auipc	ra,0x2
    80003c18:	0b2080e7          	jalr	178(ra) # 80005cc6 <panic>
    return -1;
    80003c1c:	597d                	li	s2,-1
    80003c1e:	b765                	j	80003bc6 <fileread+0x60>
      return -1;
    80003c20:	597d                	li	s2,-1
    80003c22:	b755                	j	80003bc6 <fileread+0x60>
    80003c24:	597d                	li	s2,-1
    80003c26:	b745                	j	80003bc6 <fileread+0x60>

0000000080003c28 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c28:	715d                	addi	sp,sp,-80
    80003c2a:	e486                	sd	ra,72(sp)
    80003c2c:	e0a2                	sd	s0,64(sp)
    80003c2e:	fc26                	sd	s1,56(sp)
    80003c30:	f84a                	sd	s2,48(sp)
    80003c32:	f44e                	sd	s3,40(sp)
    80003c34:	f052                	sd	s4,32(sp)
    80003c36:	ec56                	sd	s5,24(sp)
    80003c38:	e85a                	sd	s6,16(sp)
    80003c3a:	e45e                	sd	s7,8(sp)
    80003c3c:	e062                	sd	s8,0(sp)
    80003c3e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c40:	00954783          	lbu	a5,9(a0)
    80003c44:	10078663          	beqz	a5,80003d50 <filewrite+0x128>
    80003c48:	892a                	mv	s2,a0
    80003c4a:	8aae                	mv	s5,a1
    80003c4c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c4e:	411c                	lw	a5,0(a0)
    80003c50:	4705                	li	a4,1
    80003c52:	02e78263          	beq	a5,a4,80003c76 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c56:	470d                	li	a4,3
    80003c58:	02e78663          	beq	a5,a4,80003c84 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c5c:	4709                	li	a4,2
    80003c5e:	0ee79163          	bne	a5,a4,80003d40 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c62:	0ac05d63          	blez	a2,80003d1c <filewrite+0xf4>
    int i = 0;
    80003c66:	4981                	li	s3,0
    80003c68:	6b05                	lui	s6,0x1
    80003c6a:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c6e:	6b85                	lui	s7,0x1
    80003c70:	c00b8b9b          	addiw	s7,s7,-1024
    80003c74:	a861                	j	80003d0c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c76:	6908                	ld	a0,16(a0)
    80003c78:	00000097          	auipc	ra,0x0
    80003c7c:	22e080e7          	jalr	558(ra) # 80003ea6 <pipewrite>
    80003c80:	8a2a                	mv	s4,a0
    80003c82:	a045                	j	80003d22 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c84:	02451783          	lh	a5,36(a0)
    80003c88:	03079693          	slli	a3,a5,0x30
    80003c8c:	92c1                	srli	a3,a3,0x30
    80003c8e:	4725                	li	a4,9
    80003c90:	0cd76263          	bltu	a4,a3,80003d54 <filewrite+0x12c>
    80003c94:	0792                	slli	a5,a5,0x4
    80003c96:	00016717          	auipc	a4,0x16
    80003c9a:	c3270713          	addi	a4,a4,-974 # 800198c8 <devsw>
    80003c9e:	97ba                	add	a5,a5,a4
    80003ca0:	679c                	ld	a5,8(a5)
    80003ca2:	cbdd                	beqz	a5,80003d58 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ca4:	4505                	li	a0,1
    80003ca6:	9782                	jalr	a5
    80003ca8:	8a2a                	mv	s4,a0
    80003caa:	a8a5                	j	80003d22 <filewrite+0xfa>
    80003cac:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cb0:	00000097          	auipc	ra,0x0
    80003cb4:	8b0080e7          	jalr	-1872(ra) # 80003560 <begin_op>
      ilock(f->ip);
    80003cb8:	01893503          	ld	a0,24(s2)
    80003cbc:	fffff097          	auipc	ra,0xfffff
    80003cc0:	ed2080e7          	jalr	-302(ra) # 80002b8e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cc4:	8762                	mv	a4,s8
    80003cc6:	02092683          	lw	a3,32(s2)
    80003cca:	01598633          	add	a2,s3,s5
    80003cce:	4585                	li	a1,1
    80003cd0:	01893503          	ld	a0,24(s2)
    80003cd4:	fffff097          	auipc	ra,0xfffff
    80003cd8:	266080e7          	jalr	614(ra) # 80002f3a <writei>
    80003cdc:	84aa                	mv	s1,a0
    80003cde:	00a05763          	blez	a0,80003cec <filewrite+0xc4>
        f->off += r;
    80003ce2:	02092783          	lw	a5,32(s2)
    80003ce6:	9fa9                	addw	a5,a5,a0
    80003ce8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cec:	01893503          	ld	a0,24(s2)
    80003cf0:	fffff097          	auipc	ra,0xfffff
    80003cf4:	f60080e7          	jalr	-160(ra) # 80002c50 <iunlock>
      end_op();
    80003cf8:	00000097          	auipc	ra,0x0
    80003cfc:	8e8080e7          	jalr	-1816(ra) # 800035e0 <end_op>

      if(r != n1){
    80003d00:	009c1f63          	bne	s8,s1,80003d1e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d04:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d08:	0149db63          	bge	s3,s4,80003d1e <filewrite+0xf6>
      int n1 = n - i;
    80003d0c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d10:	84be                	mv	s1,a5
    80003d12:	2781                	sext.w	a5,a5
    80003d14:	f8fb5ce3          	bge	s6,a5,80003cac <filewrite+0x84>
    80003d18:	84de                	mv	s1,s7
    80003d1a:	bf49                	j	80003cac <filewrite+0x84>
    int i = 0;
    80003d1c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d1e:	013a1f63          	bne	s4,s3,80003d3c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d22:	8552                	mv	a0,s4
    80003d24:	60a6                	ld	ra,72(sp)
    80003d26:	6406                	ld	s0,64(sp)
    80003d28:	74e2                	ld	s1,56(sp)
    80003d2a:	7942                	ld	s2,48(sp)
    80003d2c:	79a2                	ld	s3,40(sp)
    80003d2e:	7a02                	ld	s4,32(sp)
    80003d30:	6ae2                	ld	s5,24(sp)
    80003d32:	6b42                	ld	s6,16(sp)
    80003d34:	6ba2                	ld	s7,8(sp)
    80003d36:	6c02                	ld	s8,0(sp)
    80003d38:	6161                	addi	sp,sp,80
    80003d3a:	8082                	ret
    ret = (i == n ? n : -1);
    80003d3c:	5a7d                	li	s4,-1
    80003d3e:	b7d5                	j	80003d22 <filewrite+0xfa>
    panic("filewrite");
    80003d40:	00005517          	auipc	a0,0x5
    80003d44:	90050513          	addi	a0,a0,-1792 # 80008640 <syscalls+0x278>
    80003d48:	00002097          	auipc	ra,0x2
    80003d4c:	f7e080e7          	jalr	-130(ra) # 80005cc6 <panic>
    return -1;
    80003d50:	5a7d                	li	s4,-1
    80003d52:	bfc1                	j	80003d22 <filewrite+0xfa>
      return -1;
    80003d54:	5a7d                	li	s4,-1
    80003d56:	b7f1                	j	80003d22 <filewrite+0xfa>
    80003d58:	5a7d                	li	s4,-1
    80003d5a:	b7e1                	j	80003d22 <filewrite+0xfa>

0000000080003d5c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d5c:	7179                	addi	sp,sp,-48
    80003d5e:	f406                	sd	ra,40(sp)
    80003d60:	f022                	sd	s0,32(sp)
    80003d62:	ec26                	sd	s1,24(sp)
    80003d64:	e84a                	sd	s2,16(sp)
    80003d66:	e44e                	sd	s3,8(sp)
    80003d68:	e052                	sd	s4,0(sp)
    80003d6a:	1800                	addi	s0,sp,48
    80003d6c:	84aa                	mv	s1,a0
    80003d6e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d70:	0005b023          	sd	zero,0(a1)
    80003d74:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	bf8080e7          	jalr	-1032(ra) # 80003970 <filealloc>
    80003d80:	e088                	sd	a0,0(s1)
    80003d82:	c551                	beqz	a0,80003e0e <pipealloc+0xb2>
    80003d84:	00000097          	auipc	ra,0x0
    80003d88:	bec080e7          	jalr	-1044(ra) # 80003970 <filealloc>
    80003d8c:	00aa3023          	sd	a0,0(s4)
    80003d90:	c92d                	beqz	a0,80003e02 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d92:	ffffc097          	auipc	ra,0xffffc
    80003d96:	386080e7          	jalr	902(ra) # 80000118 <kalloc>
    80003d9a:	892a                	mv	s2,a0
    80003d9c:	c125                	beqz	a0,80003dfc <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003d9e:	4985                	li	s3,1
    80003da0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003da4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003da8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dac:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003db0:	00005597          	auipc	a1,0x5
    80003db4:	8a058593          	addi	a1,a1,-1888 # 80008650 <syscalls+0x288>
    80003db8:	00002097          	auipc	ra,0x2
    80003dbc:	39e080e7          	jalr	926(ra) # 80006156 <initlock>
  (*f0)->type = FD_PIPE;
    80003dc0:	609c                	ld	a5,0(s1)
    80003dc2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003dc6:	609c                	ld	a5,0(s1)
    80003dc8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003dcc:	609c                	ld	a5,0(s1)
    80003dce:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dd2:	609c                	ld	a5,0(s1)
    80003dd4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dd8:	000a3783          	ld	a5,0(s4)
    80003ddc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003de0:	000a3783          	ld	a5,0(s4)
    80003de4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003de8:	000a3783          	ld	a5,0(s4)
    80003dec:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003df0:	000a3783          	ld	a5,0(s4)
    80003df4:	0127b823          	sd	s2,16(a5)
  return 0;
    80003df8:	4501                	li	a0,0
    80003dfa:	a025                	j	80003e22 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003dfc:	6088                	ld	a0,0(s1)
    80003dfe:	e501                	bnez	a0,80003e06 <pipealloc+0xaa>
    80003e00:	a039                	j	80003e0e <pipealloc+0xb2>
    80003e02:	6088                	ld	a0,0(s1)
    80003e04:	c51d                	beqz	a0,80003e32 <pipealloc+0xd6>
    fileclose(*f0);
    80003e06:	00000097          	auipc	ra,0x0
    80003e0a:	c26080e7          	jalr	-986(ra) # 80003a2c <fileclose>
  if(*f1)
    80003e0e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e12:	557d                	li	a0,-1
  if(*f1)
    80003e14:	c799                	beqz	a5,80003e22 <pipealloc+0xc6>
    fileclose(*f1);
    80003e16:	853e                	mv	a0,a5
    80003e18:	00000097          	auipc	ra,0x0
    80003e1c:	c14080e7          	jalr	-1004(ra) # 80003a2c <fileclose>
  return -1;
    80003e20:	557d                	li	a0,-1
}
    80003e22:	70a2                	ld	ra,40(sp)
    80003e24:	7402                	ld	s0,32(sp)
    80003e26:	64e2                	ld	s1,24(sp)
    80003e28:	6942                	ld	s2,16(sp)
    80003e2a:	69a2                	ld	s3,8(sp)
    80003e2c:	6a02                	ld	s4,0(sp)
    80003e2e:	6145                	addi	sp,sp,48
    80003e30:	8082                	ret
  return -1;
    80003e32:	557d                	li	a0,-1
    80003e34:	b7fd                	j	80003e22 <pipealloc+0xc6>

0000000080003e36 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e36:	1101                	addi	sp,sp,-32
    80003e38:	ec06                	sd	ra,24(sp)
    80003e3a:	e822                	sd	s0,16(sp)
    80003e3c:	e426                	sd	s1,8(sp)
    80003e3e:	e04a                	sd	s2,0(sp)
    80003e40:	1000                	addi	s0,sp,32
    80003e42:	84aa                	mv	s1,a0
    80003e44:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e46:	00002097          	auipc	ra,0x2
    80003e4a:	3a0080e7          	jalr	928(ra) # 800061e6 <acquire>
  if(writable){
    80003e4e:	02090d63          	beqz	s2,80003e88 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e52:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e56:	21848513          	addi	a0,s1,536
    80003e5a:	ffffe097          	auipc	ra,0xffffe
    80003e5e:	86c080e7          	jalr	-1940(ra) # 800016c6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e62:	2204b783          	ld	a5,544(s1)
    80003e66:	eb95                	bnez	a5,80003e9a <pipeclose+0x64>
    release(&pi->lock);
    80003e68:	8526                	mv	a0,s1
    80003e6a:	00002097          	auipc	ra,0x2
    80003e6e:	430080e7          	jalr	1072(ra) # 8000629a <release>
    kfree((char*)pi);
    80003e72:	8526                	mv	a0,s1
    80003e74:	ffffc097          	auipc	ra,0xffffc
    80003e78:	1a8080e7          	jalr	424(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e7c:	60e2                	ld	ra,24(sp)
    80003e7e:	6442                	ld	s0,16(sp)
    80003e80:	64a2                	ld	s1,8(sp)
    80003e82:	6902                	ld	s2,0(sp)
    80003e84:	6105                	addi	sp,sp,32
    80003e86:	8082                	ret
    pi->readopen = 0;
    80003e88:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e8c:	21c48513          	addi	a0,s1,540
    80003e90:	ffffe097          	auipc	ra,0xffffe
    80003e94:	836080e7          	jalr	-1994(ra) # 800016c6 <wakeup>
    80003e98:	b7e9                	j	80003e62 <pipeclose+0x2c>
    release(&pi->lock);
    80003e9a:	8526                	mv	a0,s1
    80003e9c:	00002097          	auipc	ra,0x2
    80003ea0:	3fe080e7          	jalr	1022(ra) # 8000629a <release>
}
    80003ea4:	bfe1                	j	80003e7c <pipeclose+0x46>

0000000080003ea6 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ea6:	7159                	addi	sp,sp,-112
    80003ea8:	f486                	sd	ra,104(sp)
    80003eaa:	f0a2                	sd	s0,96(sp)
    80003eac:	eca6                	sd	s1,88(sp)
    80003eae:	e8ca                	sd	s2,80(sp)
    80003eb0:	e4ce                	sd	s3,72(sp)
    80003eb2:	e0d2                	sd	s4,64(sp)
    80003eb4:	fc56                	sd	s5,56(sp)
    80003eb6:	f85a                	sd	s6,48(sp)
    80003eb8:	f45e                	sd	s7,40(sp)
    80003eba:	f062                	sd	s8,32(sp)
    80003ebc:	ec66                	sd	s9,24(sp)
    80003ebe:	1880                	addi	s0,sp,112
    80003ec0:	84aa                	mv	s1,a0
    80003ec2:	8aae                	mv	s5,a1
    80003ec4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ec6:	ffffd097          	auipc	ra,0xffffd
    80003eca:	f82080e7          	jalr	-126(ra) # 80000e48 <myproc>
    80003ece:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	00002097          	auipc	ra,0x2
    80003ed6:	314080e7          	jalr	788(ra) # 800061e6 <acquire>
  while(i < n){
    80003eda:	0d405163          	blez	s4,80003f9c <pipewrite+0xf6>
    80003ede:	8ba6                	mv	s7,s1
  int i = 0;
    80003ee0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ee2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ee4:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ee8:	21c48c13          	addi	s8,s1,540
    80003eec:	a08d                	j	80003f4e <pipewrite+0xa8>
      release(&pi->lock);
    80003eee:	8526                	mv	a0,s1
    80003ef0:	00002097          	auipc	ra,0x2
    80003ef4:	3aa080e7          	jalr	938(ra) # 8000629a <release>
      return -1;
    80003ef8:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003efa:	854a                	mv	a0,s2
    80003efc:	70a6                	ld	ra,104(sp)
    80003efe:	7406                	ld	s0,96(sp)
    80003f00:	64e6                	ld	s1,88(sp)
    80003f02:	6946                	ld	s2,80(sp)
    80003f04:	69a6                	ld	s3,72(sp)
    80003f06:	6a06                	ld	s4,64(sp)
    80003f08:	7ae2                	ld	s5,56(sp)
    80003f0a:	7b42                	ld	s6,48(sp)
    80003f0c:	7ba2                	ld	s7,40(sp)
    80003f0e:	7c02                	ld	s8,32(sp)
    80003f10:	6ce2                	ld	s9,24(sp)
    80003f12:	6165                	addi	sp,sp,112
    80003f14:	8082                	ret
      wakeup(&pi->nread);
    80003f16:	8566                	mv	a0,s9
    80003f18:	ffffd097          	auipc	ra,0xffffd
    80003f1c:	7ae080e7          	jalr	1966(ra) # 800016c6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f20:	85de                	mv	a1,s7
    80003f22:	8562                	mv	a0,s8
    80003f24:	ffffd097          	auipc	ra,0xffffd
    80003f28:	616080e7          	jalr	1558(ra) # 8000153a <sleep>
    80003f2c:	a839                	j	80003f4a <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f2e:	21c4a783          	lw	a5,540(s1)
    80003f32:	0017871b          	addiw	a4,a5,1
    80003f36:	20e4ae23          	sw	a4,540(s1)
    80003f3a:	1ff7f793          	andi	a5,a5,511
    80003f3e:	97a6                	add	a5,a5,s1
    80003f40:	f9f44703          	lbu	a4,-97(s0)
    80003f44:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f48:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f4a:	03495d63          	bge	s2,s4,80003f84 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f4e:	2204a783          	lw	a5,544(s1)
    80003f52:	dfd1                	beqz	a5,80003eee <pipewrite+0x48>
    80003f54:	0289a783          	lw	a5,40(s3)
    80003f58:	fbd9                	bnez	a5,80003eee <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f5a:	2184a783          	lw	a5,536(s1)
    80003f5e:	21c4a703          	lw	a4,540(s1)
    80003f62:	2007879b          	addiw	a5,a5,512
    80003f66:	faf708e3          	beq	a4,a5,80003f16 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f6a:	4685                	li	a3,1
    80003f6c:	01590633          	add	a2,s2,s5
    80003f70:	f9f40593          	addi	a1,s0,-97
    80003f74:	0509b503          	ld	a0,80(s3)
    80003f78:	ffffd097          	auipc	ra,0xffffd
    80003f7c:	c1e080e7          	jalr	-994(ra) # 80000b96 <copyin>
    80003f80:	fb6517e3          	bne	a0,s6,80003f2e <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f84:	21848513          	addi	a0,s1,536
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	73e080e7          	jalr	1854(ra) # 800016c6 <wakeup>
  release(&pi->lock);
    80003f90:	8526                	mv	a0,s1
    80003f92:	00002097          	auipc	ra,0x2
    80003f96:	308080e7          	jalr	776(ra) # 8000629a <release>
  return i;
    80003f9a:	b785                	j	80003efa <pipewrite+0x54>
  int i = 0;
    80003f9c:	4901                	li	s2,0
    80003f9e:	b7dd                	j	80003f84 <pipewrite+0xde>

0000000080003fa0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fa0:	715d                	addi	sp,sp,-80
    80003fa2:	e486                	sd	ra,72(sp)
    80003fa4:	e0a2                	sd	s0,64(sp)
    80003fa6:	fc26                	sd	s1,56(sp)
    80003fa8:	f84a                	sd	s2,48(sp)
    80003faa:	f44e                	sd	s3,40(sp)
    80003fac:	f052                	sd	s4,32(sp)
    80003fae:	ec56                	sd	s5,24(sp)
    80003fb0:	e85a                	sd	s6,16(sp)
    80003fb2:	0880                	addi	s0,sp,80
    80003fb4:	84aa                	mv	s1,a0
    80003fb6:	892e                	mv	s2,a1
    80003fb8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fba:	ffffd097          	auipc	ra,0xffffd
    80003fbe:	e8e080e7          	jalr	-370(ra) # 80000e48 <myproc>
    80003fc2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fc4:	8b26                	mv	s6,s1
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	00002097          	auipc	ra,0x2
    80003fcc:	21e080e7          	jalr	542(ra) # 800061e6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fd0:	2184a703          	lw	a4,536(s1)
    80003fd4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fd8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fdc:	02f71463          	bne	a4,a5,80004004 <piperead+0x64>
    80003fe0:	2244a783          	lw	a5,548(s1)
    80003fe4:	c385                	beqz	a5,80004004 <piperead+0x64>
    if(pr->killed){
    80003fe6:	028a2783          	lw	a5,40(s4)
    80003fea:	ebc1                	bnez	a5,8000407a <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fec:	85da                	mv	a1,s6
    80003fee:	854e                	mv	a0,s3
    80003ff0:	ffffd097          	auipc	ra,0xffffd
    80003ff4:	54a080e7          	jalr	1354(ra) # 8000153a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff8:	2184a703          	lw	a4,536(s1)
    80003ffc:	21c4a783          	lw	a5,540(s1)
    80004000:	fef700e3          	beq	a4,a5,80003fe0 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004004:	09505263          	blez	s5,80004088 <piperead+0xe8>
    80004008:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000400a:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000400c:	2184a783          	lw	a5,536(s1)
    80004010:	21c4a703          	lw	a4,540(s1)
    80004014:	02f70d63          	beq	a4,a5,8000404e <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004018:	0017871b          	addiw	a4,a5,1
    8000401c:	20e4ac23          	sw	a4,536(s1)
    80004020:	1ff7f793          	andi	a5,a5,511
    80004024:	97a6                	add	a5,a5,s1
    80004026:	0187c783          	lbu	a5,24(a5)
    8000402a:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000402e:	4685                	li	a3,1
    80004030:	fbf40613          	addi	a2,s0,-65
    80004034:	85ca                	mv	a1,s2
    80004036:	050a3503          	ld	a0,80(s4)
    8000403a:	ffffd097          	auipc	ra,0xffffd
    8000403e:	ad0080e7          	jalr	-1328(ra) # 80000b0a <copyout>
    80004042:	01650663          	beq	a0,s6,8000404e <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004046:	2985                	addiw	s3,s3,1
    80004048:	0905                	addi	s2,s2,1
    8000404a:	fd3a91e3          	bne	s5,s3,8000400c <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000404e:	21c48513          	addi	a0,s1,540
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	674080e7          	jalr	1652(ra) # 800016c6 <wakeup>
  release(&pi->lock);
    8000405a:	8526                	mv	a0,s1
    8000405c:	00002097          	auipc	ra,0x2
    80004060:	23e080e7          	jalr	574(ra) # 8000629a <release>
  return i;
}
    80004064:	854e                	mv	a0,s3
    80004066:	60a6                	ld	ra,72(sp)
    80004068:	6406                	ld	s0,64(sp)
    8000406a:	74e2                	ld	s1,56(sp)
    8000406c:	7942                	ld	s2,48(sp)
    8000406e:	79a2                	ld	s3,40(sp)
    80004070:	7a02                	ld	s4,32(sp)
    80004072:	6ae2                	ld	s5,24(sp)
    80004074:	6b42                	ld	s6,16(sp)
    80004076:	6161                	addi	sp,sp,80
    80004078:	8082                	ret
      release(&pi->lock);
    8000407a:	8526                	mv	a0,s1
    8000407c:	00002097          	auipc	ra,0x2
    80004080:	21e080e7          	jalr	542(ra) # 8000629a <release>
      return -1;
    80004084:	59fd                	li	s3,-1
    80004086:	bff9                	j	80004064 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004088:	4981                	li	s3,0
    8000408a:	b7d1                	j	8000404e <piperead+0xae>

000000008000408c <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000408c:	df010113          	addi	sp,sp,-528
    80004090:	20113423          	sd	ra,520(sp)
    80004094:	20813023          	sd	s0,512(sp)
    80004098:	ffa6                	sd	s1,504(sp)
    8000409a:	fbca                	sd	s2,496(sp)
    8000409c:	f7ce                	sd	s3,488(sp)
    8000409e:	f3d2                	sd	s4,480(sp)
    800040a0:	efd6                	sd	s5,472(sp)
    800040a2:	ebda                	sd	s6,464(sp)
    800040a4:	e7de                	sd	s7,456(sp)
    800040a6:	e3e2                	sd	s8,448(sp)
    800040a8:	ff66                	sd	s9,440(sp)
    800040aa:	fb6a                	sd	s10,432(sp)
    800040ac:	f76e                	sd	s11,424(sp)
    800040ae:	0c00                	addi	s0,sp,528
    800040b0:	84aa                	mv	s1,a0
    800040b2:	dea43c23          	sd	a0,-520(s0)
    800040b6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040ba:	ffffd097          	auipc	ra,0xffffd
    800040be:	d8e080e7          	jalr	-626(ra) # 80000e48 <myproc>
    800040c2:	892a                	mv	s2,a0

  begin_op();
    800040c4:	fffff097          	auipc	ra,0xfffff
    800040c8:	49c080e7          	jalr	1180(ra) # 80003560 <begin_op>

  if((ip = namei(path)) == 0){
    800040cc:	8526                	mv	a0,s1
    800040ce:	fffff097          	auipc	ra,0xfffff
    800040d2:	276080e7          	jalr	630(ra) # 80003344 <namei>
    800040d6:	c92d                	beqz	a0,80004148 <exec+0xbc>
    800040d8:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040da:	fffff097          	auipc	ra,0xfffff
    800040de:	ab4080e7          	jalr	-1356(ra) # 80002b8e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040e2:	04000713          	li	a4,64
    800040e6:	4681                	li	a3,0
    800040e8:	e5040613          	addi	a2,s0,-432
    800040ec:	4581                	li	a1,0
    800040ee:	8526                	mv	a0,s1
    800040f0:	fffff097          	auipc	ra,0xfffff
    800040f4:	d52080e7          	jalr	-686(ra) # 80002e42 <readi>
    800040f8:	04000793          	li	a5,64
    800040fc:	00f51a63          	bne	a0,a5,80004110 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004100:	e5042703          	lw	a4,-432(s0)
    80004104:	464c47b7          	lui	a5,0x464c4
    80004108:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000410c:	04f70463          	beq	a4,a5,80004154 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004110:	8526                	mv	a0,s1
    80004112:	fffff097          	auipc	ra,0xfffff
    80004116:	cde080e7          	jalr	-802(ra) # 80002df0 <iunlockput>
    end_op();
    8000411a:	fffff097          	auipc	ra,0xfffff
    8000411e:	4c6080e7          	jalr	1222(ra) # 800035e0 <end_op>
  }
  return -1;
    80004122:	557d                	li	a0,-1
}
    80004124:	20813083          	ld	ra,520(sp)
    80004128:	20013403          	ld	s0,512(sp)
    8000412c:	74fe                	ld	s1,504(sp)
    8000412e:	795e                	ld	s2,496(sp)
    80004130:	79be                	ld	s3,488(sp)
    80004132:	7a1e                	ld	s4,480(sp)
    80004134:	6afe                	ld	s5,472(sp)
    80004136:	6b5e                	ld	s6,464(sp)
    80004138:	6bbe                	ld	s7,456(sp)
    8000413a:	6c1e                	ld	s8,448(sp)
    8000413c:	7cfa                	ld	s9,440(sp)
    8000413e:	7d5a                	ld	s10,432(sp)
    80004140:	7dba                	ld	s11,424(sp)
    80004142:	21010113          	addi	sp,sp,528
    80004146:	8082                	ret
    end_op();
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	498080e7          	jalr	1176(ra) # 800035e0 <end_op>
    return -1;
    80004150:	557d                	li	a0,-1
    80004152:	bfc9                	j	80004124 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004154:	854a                	mv	a0,s2
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	db6080e7          	jalr	-586(ra) # 80000f0c <proc_pagetable>
    8000415e:	8baa                	mv	s7,a0
    80004160:	d945                	beqz	a0,80004110 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004162:	e7042983          	lw	s3,-400(s0)
    80004166:	e8845783          	lhu	a5,-376(s0)
    8000416a:	c7ad                	beqz	a5,800041d4 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000416c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000416e:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004170:	6c85                	lui	s9,0x1
    80004172:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004176:	def43823          	sd	a5,-528(s0)
    8000417a:	a42d                	j	800043a4 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000417c:	00004517          	auipc	a0,0x4
    80004180:	4dc50513          	addi	a0,a0,1244 # 80008658 <syscalls+0x290>
    80004184:	00002097          	auipc	ra,0x2
    80004188:	b42080e7          	jalr	-1214(ra) # 80005cc6 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000418c:	8756                	mv	a4,s5
    8000418e:	012d86bb          	addw	a3,s11,s2
    80004192:	4581                	li	a1,0
    80004194:	8526                	mv	a0,s1
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	cac080e7          	jalr	-852(ra) # 80002e42 <readi>
    8000419e:	2501                	sext.w	a0,a0
    800041a0:	1aaa9963          	bne	s5,a0,80004352 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041a4:	6785                	lui	a5,0x1
    800041a6:	0127893b          	addw	s2,a5,s2
    800041aa:	77fd                	lui	a5,0xfffff
    800041ac:	01478a3b          	addw	s4,a5,s4
    800041b0:	1f897163          	bgeu	s2,s8,80004392 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041b4:	02091593          	slli	a1,s2,0x20
    800041b8:	9181                	srli	a1,a1,0x20
    800041ba:	95ea                	add	a1,a1,s10
    800041bc:	855e                	mv	a0,s7
    800041be:	ffffc097          	auipc	ra,0xffffc
    800041c2:	348080e7          	jalr	840(ra) # 80000506 <walkaddr>
    800041c6:	862a                	mv	a2,a0
    if(pa == 0)
    800041c8:	d955                	beqz	a0,8000417c <exec+0xf0>
      n = PGSIZE;
    800041ca:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800041cc:	fd9a70e3          	bgeu	s4,s9,8000418c <exec+0x100>
      n = sz - i;
    800041d0:	8ad2                	mv	s5,s4
    800041d2:	bf6d                	j	8000418c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041d4:	4901                	li	s2,0
  iunlockput(ip);
    800041d6:	8526                	mv	a0,s1
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	c18080e7          	jalr	-1000(ra) # 80002df0 <iunlockput>
  end_op();
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	400080e7          	jalr	1024(ra) # 800035e0 <end_op>
  p = myproc();
    800041e8:	ffffd097          	auipc	ra,0xffffd
    800041ec:	c60080e7          	jalr	-928(ra) # 80000e48 <myproc>
    800041f0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800041f2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800041f6:	6785                	lui	a5,0x1
    800041f8:	17fd                	addi	a5,a5,-1
    800041fa:	993e                	add	s2,s2,a5
    800041fc:	757d                	lui	a0,0xfffff
    800041fe:	00a977b3          	and	a5,s2,a0
    80004202:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004206:	6609                	lui	a2,0x2
    80004208:	963e                	add	a2,a2,a5
    8000420a:	85be                	mv	a1,a5
    8000420c:	855e                	mv	a0,s7
    8000420e:	ffffc097          	auipc	ra,0xffffc
    80004212:	6ac080e7          	jalr	1708(ra) # 800008ba <uvmalloc>
    80004216:	8b2a                	mv	s6,a0
  ip = 0;
    80004218:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000421a:	12050c63          	beqz	a0,80004352 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000421e:	75f9                	lui	a1,0xffffe
    80004220:	95aa                	add	a1,a1,a0
    80004222:	855e                	mv	a0,s7
    80004224:	ffffd097          	auipc	ra,0xffffd
    80004228:	8b4080e7          	jalr	-1868(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    8000422c:	7c7d                	lui	s8,0xfffff
    8000422e:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004230:	e0043783          	ld	a5,-512(s0)
    80004234:	6388                	ld	a0,0(a5)
    80004236:	c535                	beqz	a0,800042a2 <exec+0x216>
    80004238:	e9040993          	addi	s3,s0,-368
    8000423c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004240:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004242:	ffffc097          	auipc	ra,0xffffc
    80004246:	0ba080e7          	jalr	186(ra) # 800002fc <strlen>
    8000424a:	2505                	addiw	a0,a0,1
    8000424c:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004250:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004254:	13896363          	bltu	s2,s8,8000437a <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004258:	e0043d83          	ld	s11,-512(s0)
    8000425c:	000dba03          	ld	s4,0(s11)
    80004260:	8552                	mv	a0,s4
    80004262:	ffffc097          	auipc	ra,0xffffc
    80004266:	09a080e7          	jalr	154(ra) # 800002fc <strlen>
    8000426a:	0015069b          	addiw	a3,a0,1
    8000426e:	8652                	mv	a2,s4
    80004270:	85ca                	mv	a1,s2
    80004272:	855e                	mv	a0,s7
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	896080e7          	jalr	-1898(ra) # 80000b0a <copyout>
    8000427c:	10054363          	bltz	a0,80004382 <exec+0x2f6>
    ustack[argc] = sp;
    80004280:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004284:	0485                	addi	s1,s1,1
    80004286:	008d8793          	addi	a5,s11,8
    8000428a:	e0f43023          	sd	a5,-512(s0)
    8000428e:	008db503          	ld	a0,8(s11)
    80004292:	c911                	beqz	a0,800042a6 <exec+0x21a>
    if(argc >= MAXARG)
    80004294:	09a1                	addi	s3,s3,8
    80004296:	fb3c96e3          	bne	s9,s3,80004242 <exec+0x1b6>
  sz = sz1;
    8000429a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000429e:	4481                	li	s1,0
    800042a0:	a84d                	j	80004352 <exec+0x2c6>
  sp = sz;
    800042a2:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042a4:	4481                	li	s1,0
  ustack[argc] = 0;
    800042a6:	00349793          	slli	a5,s1,0x3
    800042aa:	f9040713          	addi	a4,s0,-112
    800042ae:	97ba                	add	a5,a5,a4
    800042b0:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042b4:	00148693          	addi	a3,s1,1
    800042b8:	068e                	slli	a3,a3,0x3
    800042ba:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042be:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042c2:	01897663          	bgeu	s2,s8,800042ce <exec+0x242>
  sz = sz1;
    800042c6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042ca:	4481                	li	s1,0
    800042cc:	a059                	j	80004352 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042ce:	e9040613          	addi	a2,s0,-368
    800042d2:	85ca                	mv	a1,s2
    800042d4:	855e                	mv	a0,s7
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	834080e7          	jalr	-1996(ra) # 80000b0a <copyout>
    800042de:	0a054663          	bltz	a0,8000438a <exec+0x2fe>
  p->trapframe->a1 = sp;
    800042e2:	058ab783          	ld	a5,88(s5)
    800042e6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800042ea:	df843783          	ld	a5,-520(s0)
    800042ee:	0007c703          	lbu	a4,0(a5)
    800042f2:	cf11                	beqz	a4,8000430e <exec+0x282>
    800042f4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800042f6:	02f00693          	li	a3,47
    800042fa:	a039                	j	80004308 <exec+0x27c>
      last = s+1;
    800042fc:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004300:	0785                	addi	a5,a5,1
    80004302:	fff7c703          	lbu	a4,-1(a5)
    80004306:	c701                	beqz	a4,8000430e <exec+0x282>
    if(*s == '/')
    80004308:	fed71ce3          	bne	a4,a3,80004300 <exec+0x274>
    8000430c:	bfc5                	j	800042fc <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    8000430e:	4641                	li	a2,16
    80004310:	df843583          	ld	a1,-520(s0)
    80004314:	158a8513          	addi	a0,s5,344
    80004318:	ffffc097          	auipc	ra,0xffffc
    8000431c:	fb2080e7          	jalr	-78(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004320:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004324:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004328:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000432c:	058ab783          	ld	a5,88(s5)
    80004330:	e6843703          	ld	a4,-408(s0)
    80004334:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004336:	058ab783          	ld	a5,88(s5)
    8000433a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000433e:	85ea                	mv	a1,s10
    80004340:	ffffd097          	auipc	ra,0xffffd
    80004344:	c68080e7          	jalr	-920(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004348:	0004851b          	sext.w	a0,s1
    8000434c:	bbe1                	j	80004124 <exec+0x98>
    8000434e:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004352:	e0843583          	ld	a1,-504(s0)
    80004356:	855e                	mv	a0,s7
    80004358:	ffffd097          	auipc	ra,0xffffd
    8000435c:	c50080e7          	jalr	-944(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    80004360:	da0498e3          	bnez	s1,80004110 <exec+0x84>
  return -1;
    80004364:	557d                	li	a0,-1
    80004366:	bb7d                	j	80004124 <exec+0x98>
    80004368:	e1243423          	sd	s2,-504(s0)
    8000436c:	b7dd                	j	80004352 <exec+0x2c6>
    8000436e:	e1243423          	sd	s2,-504(s0)
    80004372:	b7c5                	j	80004352 <exec+0x2c6>
    80004374:	e1243423          	sd	s2,-504(s0)
    80004378:	bfe9                	j	80004352 <exec+0x2c6>
  sz = sz1;
    8000437a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000437e:	4481                	li	s1,0
    80004380:	bfc9                	j	80004352 <exec+0x2c6>
  sz = sz1;
    80004382:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004386:	4481                	li	s1,0
    80004388:	b7e9                	j	80004352 <exec+0x2c6>
  sz = sz1;
    8000438a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000438e:	4481                	li	s1,0
    80004390:	b7c9                	j	80004352 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004392:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004396:	2b05                	addiw	s6,s6,1
    80004398:	0389899b          	addiw	s3,s3,56
    8000439c:	e8845783          	lhu	a5,-376(s0)
    800043a0:	e2fb5be3          	bge	s6,a5,800041d6 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043a4:	2981                	sext.w	s3,s3
    800043a6:	03800713          	li	a4,56
    800043aa:	86ce                	mv	a3,s3
    800043ac:	e1840613          	addi	a2,s0,-488
    800043b0:	4581                	li	a1,0
    800043b2:	8526                	mv	a0,s1
    800043b4:	fffff097          	auipc	ra,0xfffff
    800043b8:	a8e080e7          	jalr	-1394(ra) # 80002e42 <readi>
    800043bc:	03800793          	li	a5,56
    800043c0:	f8f517e3          	bne	a0,a5,8000434e <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800043c4:	e1842783          	lw	a5,-488(s0)
    800043c8:	4705                	li	a4,1
    800043ca:	fce796e3          	bne	a5,a4,80004396 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800043ce:	e4043603          	ld	a2,-448(s0)
    800043d2:	e3843783          	ld	a5,-456(s0)
    800043d6:	f8f669e3          	bltu	a2,a5,80004368 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043da:	e2843783          	ld	a5,-472(s0)
    800043de:	963e                	add	a2,a2,a5
    800043e0:	f8f667e3          	bltu	a2,a5,8000436e <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043e4:	85ca                	mv	a1,s2
    800043e6:	855e                	mv	a0,s7
    800043e8:	ffffc097          	auipc	ra,0xffffc
    800043ec:	4d2080e7          	jalr	1234(ra) # 800008ba <uvmalloc>
    800043f0:	e0a43423          	sd	a0,-504(s0)
    800043f4:	d141                	beqz	a0,80004374 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800043f6:	e2843d03          	ld	s10,-472(s0)
    800043fa:	df043783          	ld	a5,-528(s0)
    800043fe:	00fd77b3          	and	a5,s10,a5
    80004402:	fba1                	bnez	a5,80004352 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004404:	e2042d83          	lw	s11,-480(s0)
    80004408:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000440c:	f80c03e3          	beqz	s8,80004392 <exec+0x306>
    80004410:	8a62                	mv	s4,s8
    80004412:	4901                	li	s2,0
    80004414:	b345                	j	800041b4 <exec+0x128>

0000000080004416 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004416:	7179                	addi	sp,sp,-48
    80004418:	f406                	sd	ra,40(sp)
    8000441a:	f022                	sd	s0,32(sp)
    8000441c:	ec26                	sd	s1,24(sp)
    8000441e:	e84a                	sd	s2,16(sp)
    80004420:	1800                	addi	s0,sp,48
    80004422:	892e                	mv	s2,a1
    80004424:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004426:	fdc40593          	addi	a1,s0,-36
    8000442a:	ffffe097          	auipc	ra,0xffffe
    8000442e:	b3a080e7          	jalr	-1222(ra) # 80001f64 <argint>
    80004432:	04054063          	bltz	a0,80004472 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004436:	fdc42703          	lw	a4,-36(s0)
    8000443a:	47bd                	li	a5,15
    8000443c:	02e7ed63          	bltu	a5,a4,80004476 <argfd+0x60>
    80004440:	ffffd097          	auipc	ra,0xffffd
    80004444:	a08080e7          	jalr	-1528(ra) # 80000e48 <myproc>
    80004448:	fdc42703          	lw	a4,-36(s0)
    8000444c:	01a70793          	addi	a5,a4,26
    80004450:	078e                	slli	a5,a5,0x3
    80004452:	953e                	add	a0,a0,a5
    80004454:	611c                	ld	a5,0(a0)
    80004456:	c395                	beqz	a5,8000447a <argfd+0x64>
    return -1;
  if(pfd)
    80004458:	00090463          	beqz	s2,80004460 <argfd+0x4a>
    *pfd = fd;
    8000445c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004460:	4501                	li	a0,0
  if(pf)
    80004462:	c091                	beqz	s1,80004466 <argfd+0x50>
    *pf = f;
    80004464:	e09c                	sd	a5,0(s1)
}
    80004466:	70a2                	ld	ra,40(sp)
    80004468:	7402                	ld	s0,32(sp)
    8000446a:	64e2                	ld	s1,24(sp)
    8000446c:	6942                	ld	s2,16(sp)
    8000446e:	6145                	addi	sp,sp,48
    80004470:	8082                	ret
    return -1;
    80004472:	557d                	li	a0,-1
    80004474:	bfcd                	j	80004466 <argfd+0x50>
    return -1;
    80004476:	557d                	li	a0,-1
    80004478:	b7fd                	j	80004466 <argfd+0x50>
    8000447a:	557d                	li	a0,-1
    8000447c:	b7ed                	j	80004466 <argfd+0x50>

000000008000447e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000447e:	1101                	addi	sp,sp,-32
    80004480:	ec06                	sd	ra,24(sp)
    80004482:	e822                	sd	s0,16(sp)
    80004484:	e426                	sd	s1,8(sp)
    80004486:	1000                	addi	s0,sp,32
    80004488:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000448a:	ffffd097          	auipc	ra,0xffffd
    8000448e:	9be080e7          	jalr	-1602(ra) # 80000e48 <myproc>
    80004492:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004494:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    80004498:	4501                	li	a0,0
    8000449a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000449c:	6398                	ld	a4,0(a5)
    8000449e:	cb19                	beqz	a4,800044b4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044a0:	2505                	addiw	a0,a0,1
    800044a2:	07a1                	addi	a5,a5,8
    800044a4:	fed51ce3          	bne	a0,a3,8000449c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044a8:	557d                	li	a0,-1
}
    800044aa:	60e2                	ld	ra,24(sp)
    800044ac:	6442                	ld	s0,16(sp)
    800044ae:	64a2                	ld	s1,8(sp)
    800044b0:	6105                	addi	sp,sp,32
    800044b2:	8082                	ret
      p->ofile[fd] = f;
    800044b4:	01a50793          	addi	a5,a0,26
    800044b8:	078e                	slli	a5,a5,0x3
    800044ba:	963e                	add	a2,a2,a5
    800044bc:	e204                	sd	s1,0(a2)
      return fd;
    800044be:	b7f5                	j	800044aa <fdalloc+0x2c>

00000000800044c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044c0:	715d                	addi	sp,sp,-80
    800044c2:	e486                	sd	ra,72(sp)
    800044c4:	e0a2                	sd	s0,64(sp)
    800044c6:	fc26                	sd	s1,56(sp)
    800044c8:	f84a                	sd	s2,48(sp)
    800044ca:	f44e                	sd	s3,40(sp)
    800044cc:	f052                	sd	s4,32(sp)
    800044ce:	ec56                	sd	s5,24(sp)
    800044d0:	0880                	addi	s0,sp,80
    800044d2:	89ae                	mv	s3,a1
    800044d4:	8ab2                	mv	s5,a2
    800044d6:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044d8:	fb040593          	addi	a1,s0,-80
    800044dc:	fffff097          	auipc	ra,0xfffff
    800044e0:	e86080e7          	jalr	-378(ra) # 80003362 <nameiparent>
    800044e4:	892a                	mv	s2,a0
    800044e6:	12050f63          	beqz	a0,80004624 <create+0x164>
    return 0;

  ilock(dp);
    800044ea:	ffffe097          	auipc	ra,0xffffe
    800044ee:	6a4080e7          	jalr	1700(ra) # 80002b8e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044f2:	4601                	li	a2,0
    800044f4:	fb040593          	addi	a1,s0,-80
    800044f8:	854a                	mv	a0,s2
    800044fa:	fffff097          	auipc	ra,0xfffff
    800044fe:	b78080e7          	jalr	-1160(ra) # 80003072 <dirlookup>
    80004502:	84aa                	mv	s1,a0
    80004504:	c921                	beqz	a0,80004554 <create+0x94>
    iunlockput(dp);
    80004506:	854a                	mv	a0,s2
    80004508:	fffff097          	auipc	ra,0xfffff
    8000450c:	8e8080e7          	jalr	-1816(ra) # 80002df0 <iunlockput>
    ilock(ip);
    80004510:	8526                	mv	a0,s1
    80004512:	ffffe097          	auipc	ra,0xffffe
    80004516:	67c080e7          	jalr	1660(ra) # 80002b8e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000451a:	2981                	sext.w	s3,s3
    8000451c:	4789                	li	a5,2
    8000451e:	02f99463          	bne	s3,a5,80004546 <create+0x86>
    80004522:	0444d783          	lhu	a5,68(s1)
    80004526:	37f9                	addiw	a5,a5,-2
    80004528:	17c2                	slli	a5,a5,0x30
    8000452a:	93c1                	srli	a5,a5,0x30
    8000452c:	4705                	li	a4,1
    8000452e:	00f76c63          	bltu	a4,a5,80004546 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004532:	8526                	mv	a0,s1
    80004534:	60a6                	ld	ra,72(sp)
    80004536:	6406                	ld	s0,64(sp)
    80004538:	74e2                	ld	s1,56(sp)
    8000453a:	7942                	ld	s2,48(sp)
    8000453c:	79a2                	ld	s3,40(sp)
    8000453e:	7a02                	ld	s4,32(sp)
    80004540:	6ae2                	ld	s5,24(sp)
    80004542:	6161                	addi	sp,sp,80
    80004544:	8082                	ret
    iunlockput(ip);
    80004546:	8526                	mv	a0,s1
    80004548:	fffff097          	auipc	ra,0xfffff
    8000454c:	8a8080e7          	jalr	-1880(ra) # 80002df0 <iunlockput>
    return 0;
    80004550:	4481                	li	s1,0
    80004552:	b7c5                	j	80004532 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004554:	85ce                	mv	a1,s3
    80004556:	00092503          	lw	a0,0(s2)
    8000455a:	ffffe097          	auipc	ra,0xffffe
    8000455e:	49c080e7          	jalr	1180(ra) # 800029f6 <ialloc>
    80004562:	84aa                	mv	s1,a0
    80004564:	c529                	beqz	a0,800045ae <create+0xee>
  ilock(ip);
    80004566:	ffffe097          	auipc	ra,0xffffe
    8000456a:	628080e7          	jalr	1576(ra) # 80002b8e <ilock>
  ip->major = major;
    8000456e:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004572:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004576:	4785                	li	a5,1
    80004578:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000457c:	8526                	mv	a0,s1
    8000457e:	ffffe097          	auipc	ra,0xffffe
    80004582:	546080e7          	jalr	1350(ra) # 80002ac4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004586:	2981                	sext.w	s3,s3
    80004588:	4785                	li	a5,1
    8000458a:	02f98a63          	beq	s3,a5,800045be <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000458e:	40d0                	lw	a2,4(s1)
    80004590:	fb040593          	addi	a1,s0,-80
    80004594:	854a                	mv	a0,s2
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	cec080e7          	jalr	-788(ra) # 80003282 <dirlink>
    8000459e:	06054b63          	bltz	a0,80004614 <create+0x154>
  iunlockput(dp);
    800045a2:	854a                	mv	a0,s2
    800045a4:	fffff097          	auipc	ra,0xfffff
    800045a8:	84c080e7          	jalr	-1972(ra) # 80002df0 <iunlockput>
  return ip;
    800045ac:	b759                	j	80004532 <create+0x72>
    panic("create: ialloc");
    800045ae:	00004517          	auipc	a0,0x4
    800045b2:	0ca50513          	addi	a0,a0,202 # 80008678 <syscalls+0x2b0>
    800045b6:	00001097          	auipc	ra,0x1
    800045ba:	710080e7          	jalr	1808(ra) # 80005cc6 <panic>
    dp->nlink++;  // for ".."
    800045be:	04a95783          	lhu	a5,74(s2)
    800045c2:	2785                	addiw	a5,a5,1
    800045c4:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045c8:	854a                	mv	a0,s2
    800045ca:	ffffe097          	auipc	ra,0xffffe
    800045ce:	4fa080e7          	jalr	1274(ra) # 80002ac4 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045d2:	40d0                	lw	a2,4(s1)
    800045d4:	00004597          	auipc	a1,0x4
    800045d8:	0b458593          	addi	a1,a1,180 # 80008688 <syscalls+0x2c0>
    800045dc:	8526                	mv	a0,s1
    800045de:	fffff097          	auipc	ra,0xfffff
    800045e2:	ca4080e7          	jalr	-860(ra) # 80003282 <dirlink>
    800045e6:	00054f63          	bltz	a0,80004604 <create+0x144>
    800045ea:	00492603          	lw	a2,4(s2)
    800045ee:	00004597          	auipc	a1,0x4
    800045f2:	0a258593          	addi	a1,a1,162 # 80008690 <syscalls+0x2c8>
    800045f6:	8526                	mv	a0,s1
    800045f8:	fffff097          	auipc	ra,0xfffff
    800045fc:	c8a080e7          	jalr	-886(ra) # 80003282 <dirlink>
    80004600:	f80557e3          	bgez	a0,8000458e <create+0xce>
      panic("create dots");
    80004604:	00004517          	auipc	a0,0x4
    80004608:	09450513          	addi	a0,a0,148 # 80008698 <syscalls+0x2d0>
    8000460c:	00001097          	auipc	ra,0x1
    80004610:	6ba080e7          	jalr	1722(ra) # 80005cc6 <panic>
    panic("create: dirlink");
    80004614:	00004517          	auipc	a0,0x4
    80004618:	09450513          	addi	a0,a0,148 # 800086a8 <syscalls+0x2e0>
    8000461c:	00001097          	auipc	ra,0x1
    80004620:	6aa080e7          	jalr	1706(ra) # 80005cc6 <panic>
    return 0;
    80004624:	84aa                	mv	s1,a0
    80004626:	b731                	j	80004532 <create+0x72>

0000000080004628 <sys_dup>:
{
    80004628:	7179                	addi	sp,sp,-48
    8000462a:	f406                	sd	ra,40(sp)
    8000462c:	f022                	sd	s0,32(sp)
    8000462e:	ec26                	sd	s1,24(sp)
    80004630:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004632:	fd840613          	addi	a2,s0,-40
    80004636:	4581                	li	a1,0
    80004638:	4501                	li	a0,0
    8000463a:	00000097          	auipc	ra,0x0
    8000463e:	ddc080e7          	jalr	-548(ra) # 80004416 <argfd>
    return -1;
    80004642:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004644:	02054363          	bltz	a0,8000466a <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004648:	fd843503          	ld	a0,-40(s0)
    8000464c:	00000097          	auipc	ra,0x0
    80004650:	e32080e7          	jalr	-462(ra) # 8000447e <fdalloc>
    80004654:	84aa                	mv	s1,a0
    return -1;
    80004656:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004658:	00054963          	bltz	a0,8000466a <sys_dup+0x42>
  filedup(f);
    8000465c:	fd843503          	ld	a0,-40(s0)
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	37a080e7          	jalr	890(ra) # 800039da <filedup>
  return fd;
    80004668:	87a6                	mv	a5,s1
}
    8000466a:	853e                	mv	a0,a5
    8000466c:	70a2                	ld	ra,40(sp)
    8000466e:	7402                	ld	s0,32(sp)
    80004670:	64e2                	ld	s1,24(sp)
    80004672:	6145                	addi	sp,sp,48
    80004674:	8082                	ret

0000000080004676 <sys_read>:
{
    80004676:	7179                	addi	sp,sp,-48
    80004678:	f406                	sd	ra,40(sp)
    8000467a:	f022                	sd	s0,32(sp)
    8000467c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000467e:	fe840613          	addi	a2,s0,-24
    80004682:	4581                	li	a1,0
    80004684:	4501                	li	a0,0
    80004686:	00000097          	auipc	ra,0x0
    8000468a:	d90080e7          	jalr	-624(ra) # 80004416 <argfd>
    return -1;
    8000468e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004690:	04054163          	bltz	a0,800046d2 <sys_read+0x5c>
    80004694:	fe440593          	addi	a1,s0,-28
    80004698:	4509                	li	a0,2
    8000469a:	ffffe097          	auipc	ra,0xffffe
    8000469e:	8ca080e7          	jalr	-1846(ra) # 80001f64 <argint>
    return -1;
    800046a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a4:	02054763          	bltz	a0,800046d2 <sys_read+0x5c>
    800046a8:	fd840593          	addi	a1,s0,-40
    800046ac:	4505                	li	a0,1
    800046ae:	ffffe097          	auipc	ra,0xffffe
    800046b2:	8d8080e7          	jalr	-1832(ra) # 80001f86 <argaddr>
    return -1;
    800046b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046b8:	00054d63          	bltz	a0,800046d2 <sys_read+0x5c>
  return fileread(f, p, n);
    800046bc:	fe442603          	lw	a2,-28(s0)
    800046c0:	fd843583          	ld	a1,-40(s0)
    800046c4:	fe843503          	ld	a0,-24(s0)
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	49e080e7          	jalr	1182(ra) # 80003b66 <fileread>
    800046d0:	87aa                	mv	a5,a0
}
    800046d2:	853e                	mv	a0,a5
    800046d4:	70a2                	ld	ra,40(sp)
    800046d6:	7402                	ld	s0,32(sp)
    800046d8:	6145                	addi	sp,sp,48
    800046da:	8082                	ret

00000000800046dc <sys_write>:
{
    800046dc:	7179                	addi	sp,sp,-48
    800046de:	f406                	sd	ra,40(sp)
    800046e0:	f022                	sd	s0,32(sp)
    800046e2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e4:	fe840613          	addi	a2,s0,-24
    800046e8:	4581                	li	a1,0
    800046ea:	4501                	li	a0,0
    800046ec:	00000097          	auipc	ra,0x0
    800046f0:	d2a080e7          	jalr	-726(ra) # 80004416 <argfd>
    return -1;
    800046f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f6:	04054163          	bltz	a0,80004738 <sys_write+0x5c>
    800046fa:	fe440593          	addi	a1,s0,-28
    800046fe:	4509                	li	a0,2
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	864080e7          	jalr	-1948(ra) # 80001f64 <argint>
    return -1;
    80004708:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000470a:	02054763          	bltz	a0,80004738 <sys_write+0x5c>
    8000470e:	fd840593          	addi	a1,s0,-40
    80004712:	4505                	li	a0,1
    80004714:	ffffe097          	auipc	ra,0xffffe
    80004718:	872080e7          	jalr	-1934(ra) # 80001f86 <argaddr>
    return -1;
    8000471c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000471e:	00054d63          	bltz	a0,80004738 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004722:	fe442603          	lw	a2,-28(s0)
    80004726:	fd843583          	ld	a1,-40(s0)
    8000472a:	fe843503          	ld	a0,-24(s0)
    8000472e:	fffff097          	auipc	ra,0xfffff
    80004732:	4fa080e7          	jalr	1274(ra) # 80003c28 <filewrite>
    80004736:	87aa                	mv	a5,a0
}
    80004738:	853e                	mv	a0,a5
    8000473a:	70a2                	ld	ra,40(sp)
    8000473c:	7402                	ld	s0,32(sp)
    8000473e:	6145                	addi	sp,sp,48
    80004740:	8082                	ret

0000000080004742 <sys_close>:
{
    80004742:	1101                	addi	sp,sp,-32
    80004744:	ec06                	sd	ra,24(sp)
    80004746:	e822                	sd	s0,16(sp)
    80004748:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000474a:	fe040613          	addi	a2,s0,-32
    8000474e:	fec40593          	addi	a1,s0,-20
    80004752:	4501                	li	a0,0
    80004754:	00000097          	auipc	ra,0x0
    80004758:	cc2080e7          	jalr	-830(ra) # 80004416 <argfd>
    return -1;
    8000475c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000475e:	02054463          	bltz	a0,80004786 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004762:	ffffc097          	auipc	ra,0xffffc
    80004766:	6e6080e7          	jalr	1766(ra) # 80000e48 <myproc>
    8000476a:	fec42783          	lw	a5,-20(s0)
    8000476e:	07e9                	addi	a5,a5,26
    80004770:	078e                	slli	a5,a5,0x3
    80004772:	97aa                	add	a5,a5,a0
    80004774:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004778:	fe043503          	ld	a0,-32(s0)
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	2b0080e7          	jalr	688(ra) # 80003a2c <fileclose>
  return 0;
    80004784:	4781                	li	a5,0
}
    80004786:	853e                	mv	a0,a5
    80004788:	60e2                	ld	ra,24(sp)
    8000478a:	6442                	ld	s0,16(sp)
    8000478c:	6105                	addi	sp,sp,32
    8000478e:	8082                	ret

0000000080004790 <sys_fstat>:
{
    80004790:	1101                	addi	sp,sp,-32
    80004792:	ec06                	sd	ra,24(sp)
    80004794:	e822                	sd	s0,16(sp)
    80004796:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004798:	fe840613          	addi	a2,s0,-24
    8000479c:	4581                	li	a1,0
    8000479e:	4501                	li	a0,0
    800047a0:	00000097          	auipc	ra,0x0
    800047a4:	c76080e7          	jalr	-906(ra) # 80004416 <argfd>
    return -1;
    800047a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047aa:	02054563          	bltz	a0,800047d4 <sys_fstat+0x44>
    800047ae:	fe040593          	addi	a1,s0,-32
    800047b2:	4505                	li	a0,1
    800047b4:	ffffd097          	auipc	ra,0xffffd
    800047b8:	7d2080e7          	jalr	2002(ra) # 80001f86 <argaddr>
    return -1;
    800047bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047be:	00054b63          	bltz	a0,800047d4 <sys_fstat+0x44>
  return filestat(f, st);
    800047c2:	fe043583          	ld	a1,-32(s0)
    800047c6:	fe843503          	ld	a0,-24(s0)
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	32a080e7          	jalr	810(ra) # 80003af4 <filestat>
    800047d2:	87aa                	mv	a5,a0
}
    800047d4:	853e                	mv	a0,a5
    800047d6:	60e2                	ld	ra,24(sp)
    800047d8:	6442                	ld	s0,16(sp)
    800047da:	6105                	addi	sp,sp,32
    800047dc:	8082                	ret

00000000800047de <sys_link>:
{
    800047de:	7169                	addi	sp,sp,-304
    800047e0:	f606                	sd	ra,296(sp)
    800047e2:	f222                	sd	s0,288(sp)
    800047e4:	ee26                	sd	s1,280(sp)
    800047e6:	ea4a                	sd	s2,272(sp)
    800047e8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ea:	08000613          	li	a2,128
    800047ee:	ed040593          	addi	a1,s0,-304
    800047f2:	4501                	li	a0,0
    800047f4:	ffffd097          	auipc	ra,0xffffd
    800047f8:	7b4080e7          	jalr	1972(ra) # 80001fa8 <argstr>
    return -1;
    800047fc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047fe:	10054e63          	bltz	a0,8000491a <sys_link+0x13c>
    80004802:	08000613          	li	a2,128
    80004806:	f5040593          	addi	a1,s0,-176
    8000480a:	4505                	li	a0,1
    8000480c:	ffffd097          	auipc	ra,0xffffd
    80004810:	79c080e7          	jalr	1948(ra) # 80001fa8 <argstr>
    return -1;
    80004814:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004816:	10054263          	bltz	a0,8000491a <sys_link+0x13c>
  begin_op();
    8000481a:	fffff097          	auipc	ra,0xfffff
    8000481e:	d46080e7          	jalr	-698(ra) # 80003560 <begin_op>
  if((ip = namei(old)) == 0){
    80004822:	ed040513          	addi	a0,s0,-304
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	b1e080e7          	jalr	-1250(ra) # 80003344 <namei>
    8000482e:	84aa                	mv	s1,a0
    80004830:	c551                	beqz	a0,800048bc <sys_link+0xde>
  ilock(ip);
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	35c080e7          	jalr	860(ra) # 80002b8e <ilock>
  if(ip->type == T_DIR){
    8000483a:	04449703          	lh	a4,68(s1)
    8000483e:	4785                	li	a5,1
    80004840:	08f70463          	beq	a4,a5,800048c8 <sys_link+0xea>
  ip->nlink++;
    80004844:	04a4d783          	lhu	a5,74(s1)
    80004848:	2785                	addiw	a5,a5,1
    8000484a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000484e:	8526                	mv	a0,s1
    80004850:	ffffe097          	auipc	ra,0xffffe
    80004854:	274080e7          	jalr	628(ra) # 80002ac4 <iupdate>
  iunlock(ip);
    80004858:	8526                	mv	a0,s1
    8000485a:	ffffe097          	auipc	ra,0xffffe
    8000485e:	3f6080e7          	jalr	1014(ra) # 80002c50 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004862:	fd040593          	addi	a1,s0,-48
    80004866:	f5040513          	addi	a0,s0,-176
    8000486a:	fffff097          	auipc	ra,0xfffff
    8000486e:	af8080e7          	jalr	-1288(ra) # 80003362 <nameiparent>
    80004872:	892a                	mv	s2,a0
    80004874:	c935                	beqz	a0,800048e8 <sys_link+0x10a>
  ilock(dp);
    80004876:	ffffe097          	auipc	ra,0xffffe
    8000487a:	318080e7          	jalr	792(ra) # 80002b8e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000487e:	00092703          	lw	a4,0(s2)
    80004882:	409c                	lw	a5,0(s1)
    80004884:	04f71d63          	bne	a4,a5,800048de <sys_link+0x100>
    80004888:	40d0                	lw	a2,4(s1)
    8000488a:	fd040593          	addi	a1,s0,-48
    8000488e:	854a                	mv	a0,s2
    80004890:	fffff097          	auipc	ra,0xfffff
    80004894:	9f2080e7          	jalr	-1550(ra) # 80003282 <dirlink>
    80004898:	04054363          	bltz	a0,800048de <sys_link+0x100>
  iunlockput(dp);
    8000489c:	854a                	mv	a0,s2
    8000489e:	ffffe097          	auipc	ra,0xffffe
    800048a2:	552080e7          	jalr	1362(ra) # 80002df0 <iunlockput>
  iput(ip);
    800048a6:	8526                	mv	a0,s1
    800048a8:	ffffe097          	auipc	ra,0xffffe
    800048ac:	4a0080e7          	jalr	1184(ra) # 80002d48 <iput>
  end_op();
    800048b0:	fffff097          	auipc	ra,0xfffff
    800048b4:	d30080e7          	jalr	-720(ra) # 800035e0 <end_op>
  return 0;
    800048b8:	4781                	li	a5,0
    800048ba:	a085                	j	8000491a <sys_link+0x13c>
    end_op();
    800048bc:	fffff097          	auipc	ra,0xfffff
    800048c0:	d24080e7          	jalr	-732(ra) # 800035e0 <end_op>
    return -1;
    800048c4:	57fd                	li	a5,-1
    800048c6:	a891                	j	8000491a <sys_link+0x13c>
    iunlockput(ip);
    800048c8:	8526                	mv	a0,s1
    800048ca:	ffffe097          	auipc	ra,0xffffe
    800048ce:	526080e7          	jalr	1318(ra) # 80002df0 <iunlockput>
    end_op();
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	d0e080e7          	jalr	-754(ra) # 800035e0 <end_op>
    return -1;
    800048da:	57fd                	li	a5,-1
    800048dc:	a83d                	j	8000491a <sys_link+0x13c>
    iunlockput(dp);
    800048de:	854a                	mv	a0,s2
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	510080e7          	jalr	1296(ra) # 80002df0 <iunlockput>
  ilock(ip);
    800048e8:	8526                	mv	a0,s1
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	2a4080e7          	jalr	676(ra) # 80002b8e <ilock>
  ip->nlink--;
    800048f2:	04a4d783          	lhu	a5,74(s1)
    800048f6:	37fd                	addiw	a5,a5,-1
    800048f8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048fc:	8526                	mv	a0,s1
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	1c6080e7          	jalr	454(ra) # 80002ac4 <iupdate>
  iunlockput(ip);
    80004906:	8526                	mv	a0,s1
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	4e8080e7          	jalr	1256(ra) # 80002df0 <iunlockput>
  end_op();
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	cd0080e7          	jalr	-816(ra) # 800035e0 <end_op>
  return -1;
    80004918:	57fd                	li	a5,-1
}
    8000491a:	853e                	mv	a0,a5
    8000491c:	70b2                	ld	ra,296(sp)
    8000491e:	7412                	ld	s0,288(sp)
    80004920:	64f2                	ld	s1,280(sp)
    80004922:	6952                	ld	s2,272(sp)
    80004924:	6155                	addi	sp,sp,304
    80004926:	8082                	ret

0000000080004928 <sys_unlink>:
{
    80004928:	7151                	addi	sp,sp,-240
    8000492a:	f586                	sd	ra,232(sp)
    8000492c:	f1a2                	sd	s0,224(sp)
    8000492e:	eda6                	sd	s1,216(sp)
    80004930:	e9ca                	sd	s2,208(sp)
    80004932:	e5ce                	sd	s3,200(sp)
    80004934:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004936:	08000613          	li	a2,128
    8000493a:	f3040593          	addi	a1,s0,-208
    8000493e:	4501                	li	a0,0
    80004940:	ffffd097          	auipc	ra,0xffffd
    80004944:	668080e7          	jalr	1640(ra) # 80001fa8 <argstr>
    80004948:	18054163          	bltz	a0,80004aca <sys_unlink+0x1a2>
  begin_op();
    8000494c:	fffff097          	auipc	ra,0xfffff
    80004950:	c14080e7          	jalr	-1004(ra) # 80003560 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004954:	fb040593          	addi	a1,s0,-80
    80004958:	f3040513          	addi	a0,s0,-208
    8000495c:	fffff097          	auipc	ra,0xfffff
    80004960:	a06080e7          	jalr	-1530(ra) # 80003362 <nameiparent>
    80004964:	84aa                	mv	s1,a0
    80004966:	c979                	beqz	a0,80004a3c <sys_unlink+0x114>
  ilock(dp);
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	226080e7          	jalr	550(ra) # 80002b8e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004970:	00004597          	auipc	a1,0x4
    80004974:	d1858593          	addi	a1,a1,-744 # 80008688 <syscalls+0x2c0>
    80004978:	fb040513          	addi	a0,s0,-80
    8000497c:	ffffe097          	auipc	ra,0xffffe
    80004980:	6dc080e7          	jalr	1756(ra) # 80003058 <namecmp>
    80004984:	14050a63          	beqz	a0,80004ad8 <sys_unlink+0x1b0>
    80004988:	00004597          	auipc	a1,0x4
    8000498c:	d0858593          	addi	a1,a1,-760 # 80008690 <syscalls+0x2c8>
    80004990:	fb040513          	addi	a0,s0,-80
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	6c4080e7          	jalr	1732(ra) # 80003058 <namecmp>
    8000499c:	12050e63          	beqz	a0,80004ad8 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049a0:	f2c40613          	addi	a2,s0,-212
    800049a4:	fb040593          	addi	a1,s0,-80
    800049a8:	8526                	mv	a0,s1
    800049aa:	ffffe097          	auipc	ra,0xffffe
    800049ae:	6c8080e7          	jalr	1736(ra) # 80003072 <dirlookup>
    800049b2:	892a                	mv	s2,a0
    800049b4:	12050263          	beqz	a0,80004ad8 <sys_unlink+0x1b0>
  ilock(ip);
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	1d6080e7          	jalr	470(ra) # 80002b8e <ilock>
  if(ip->nlink < 1)
    800049c0:	04a91783          	lh	a5,74(s2)
    800049c4:	08f05263          	blez	a5,80004a48 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049c8:	04491703          	lh	a4,68(s2)
    800049cc:	4785                	li	a5,1
    800049ce:	08f70563          	beq	a4,a5,80004a58 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049d2:	4641                	li	a2,16
    800049d4:	4581                	li	a1,0
    800049d6:	fc040513          	addi	a0,s0,-64
    800049da:	ffffb097          	auipc	ra,0xffffb
    800049de:	79e080e7          	jalr	1950(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049e2:	4741                	li	a4,16
    800049e4:	f2c42683          	lw	a3,-212(s0)
    800049e8:	fc040613          	addi	a2,s0,-64
    800049ec:	4581                	li	a1,0
    800049ee:	8526                	mv	a0,s1
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	54a080e7          	jalr	1354(ra) # 80002f3a <writei>
    800049f8:	47c1                	li	a5,16
    800049fa:	0af51563          	bne	a0,a5,80004aa4 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800049fe:	04491703          	lh	a4,68(s2)
    80004a02:	4785                	li	a5,1
    80004a04:	0af70863          	beq	a4,a5,80004ab4 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	3e6080e7          	jalr	998(ra) # 80002df0 <iunlockput>
  ip->nlink--;
    80004a12:	04a95783          	lhu	a5,74(s2)
    80004a16:	37fd                	addiw	a5,a5,-1
    80004a18:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a1c:	854a                	mv	a0,s2
    80004a1e:	ffffe097          	auipc	ra,0xffffe
    80004a22:	0a6080e7          	jalr	166(ra) # 80002ac4 <iupdate>
  iunlockput(ip);
    80004a26:	854a                	mv	a0,s2
    80004a28:	ffffe097          	auipc	ra,0xffffe
    80004a2c:	3c8080e7          	jalr	968(ra) # 80002df0 <iunlockput>
  end_op();
    80004a30:	fffff097          	auipc	ra,0xfffff
    80004a34:	bb0080e7          	jalr	-1104(ra) # 800035e0 <end_op>
  return 0;
    80004a38:	4501                	li	a0,0
    80004a3a:	a84d                	j	80004aec <sys_unlink+0x1c4>
    end_op();
    80004a3c:	fffff097          	auipc	ra,0xfffff
    80004a40:	ba4080e7          	jalr	-1116(ra) # 800035e0 <end_op>
    return -1;
    80004a44:	557d                	li	a0,-1
    80004a46:	a05d                	j	80004aec <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a48:	00004517          	auipc	a0,0x4
    80004a4c:	c7050513          	addi	a0,a0,-912 # 800086b8 <syscalls+0x2f0>
    80004a50:	00001097          	auipc	ra,0x1
    80004a54:	276080e7          	jalr	630(ra) # 80005cc6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a58:	04c92703          	lw	a4,76(s2)
    80004a5c:	02000793          	li	a5,32
    80004a60:	f6e7f9e3          	bgeu	a5,a4,800049d2 <sys_unlink+0xaa>
    80004a64:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a68:	4741                	li	a4,16
    80004a6a:	86ce                	mv	a3,s3
    80004a6c:	f1840613          	addi	a2,s0,-232
    80004a70:	4581                	li	a1,0
    80004a72:	854a                	mv	a0,s2
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	3ce080e7          	jalr	974(ra) # 80002e42 <readi>
    80004a7c:	47c1                	li	a5,16
    80004a7e:	00f51b63          	bne	a0,a5,80004a94 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a82:	f1845783          	lhu	a5,-232(s0)
    80004a86:	e7a1                	bnez	a5,80004ace <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a88:	29c1                	addiw	s3,s3,16
    80004a8a:	04c92783          	lw	a5,76(s2)
    80004a8e:	fcf9ede3          	bltu	s3,a5,80004a68 <sys_unlink+0x140>
    80004a92:	b781                	j	800049d2 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004a94:	00004517          	auipc	a0,0x4
    80004a98:	c3c50513          	addi	a0,a0,-964 # 800086d0 <syscalls+0x308>
    80004a9c:	00001097          	auipc	ra,0x1
    80004aa0:	22a080e7          	jalr	554(ra) # 80005cc6 <panic>
    panic("unlink: writei");
    80004aa4:	00004517          	auipc	a0,0x4
    80004aa8:	c4450513          	addi	a0,a0,-956 # 800086e8 <syscalls+0x320>
    80004aac:	00001097          	auipc	ra,0x1
    80004ab0:	21a080e7          	jalr	538(ra) # 80005cc6 <panic>
    dp->nlink--;
    80004ab4:	04a4d783          	lhu	a5,74(s1)
    80004ab8:	37fd                	addiw	a5,a5,-1
    80004aba:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004abe:	8526                	mv	a0,s1
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	004080e7          	jalr	4(ra) # 80002ac4 <iupdate>
    80004ac8:	b781                	j	80004a08 <sys_unlink+0xe0>
    return -1;
    80004aca:	557d                	li	a0,-1
    80004acc:	a005                	j	80004aec <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ace:	854a                	mv	a0,s2
    80004ad0:	ffffe097          	auipc	ra,0xffffe
    80004ad4:	320080e7          	jalr	800(ra) # 80002df0 <iunlockput>
  iunlockput(dp);
    80004ad8:	8526                	mv	a0,s1
    80004ada:	ffffe097          	auipc	ra,0xffffe
    80004ade:	316080e7          	jalr	790(ra) # 80002df0 <iunlockput>
  end_op();
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	afe080e7          	jalr	-1282(ra) # 800035e0 <end_op>
  return -1;
    80004aea:	557d                	li	a0,-1
}
    80004aec:	70ae                	ld	ra,232(sp)
    80004aee:	740e                	ld	s0,224(sp)
    80004af0:	64ee                	ld	s1,216(sp)
    80004af2:	694e                	ld	s2,208(sp)
    80004af4:	69ae                	ld	s3,200(sp)
    80004af6:	616d                	addi	sp,sp,240
    80004af8:	8082                	ret

0000000080004afa <sys_open>:

uint64
sys_open(void)
{
    80004afa:	7131                	addi	sp,sp,-192
    80004afc:	fd06                	sd	ra,184(sp)
    80004afe:	f922                	sd	s0,176(sp)
    80004b00:	f526                	sd	s1,168(sp)
    80004b02:	f14a                	sd	s2,160(sp)
    80004b04:	ed4e                	sd	s3,152(sp)
    80004b06:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b08:	08000613          	li	a2,128
    80004b0c:	f5040593          	addi	a1,s0,-176
    80004b10:	4501                	li	a0,0
    80004b12:	ffffd097          	auipc	ra,0xffffd
    80004b16:	496080e7          	jalr	1174(ra) # 80001fa8 <argstr>
    return -1;
    80004b1a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b1c:	0c054163          	bltz	a0,80004bde <sys_open+0xe4>
    80004b20:	f4c40593          	addi	a1,s0,-180
    80004b24:	4505                	li	a0,1
    80004b26:	ffffd097          	auipc	ra,0xffffd
    80004b2a:	43e080e7          	jalr	1086(ra) # 80001f64 <argint>
    80004b2e:	0a054863          	bltz	a0,80004bde <sys_open+0xe4>

  begin_op();
    80004b32:	fffff097          	auipc	ra,0xfffff
    80004b36:	a2e080e7          	jalr	-1490(ra) # 80003560 <begin_op>

  if(omode & O_CREATE){
    80004b3a:	f4c42783          	lw	a5,-180(s0)
    80004b3e:	2007f793          	andi	a5,a5,512
    80004b42:	cbdd                	beqz	a5,80004bf8 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b44:	4681                	li	a3,0
    80004b46:	4601                	li	a2,0
    80004b48:	4589                	li	a1,2
    80004b4a:	f5040513          	addi	a0,s0,-176
    80004b4e:	00000097          	auipc	ra,0x0
    80004b52:	972080e7          	jalr	-1678(ra) # 800044c0 <create>
    80004b56:	892a                	mv	s2,a0
    if(ip == 0){
    80004b58:	c959                	beqz	a0,80004bee <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b5a:	04491703          	lh	a4,68(s2)
    80004b5e:	478d                	li	a5,3
    80004b60:	00f71763          	bne	a4,a5,80004b6e <sys_open+0x74>
    80004b64:	04695703          	lhu	a4,70(s2)
    80004b68:	47a5                	li	a5,9
    80004b6a:	0ce7ec63          	bltu	a5,a4,80004c42 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	e02080e7          	jalr	-510(ra) # 80003970 <filealloc>
    80004b76:	89aa                	mv	s3,a0
    80004b78:	10050263          	beqz	a0,80004c7c <sys_open+0x182>
    80004b7c:	00000097          	auipc	ra,0x0
    80004b80:	902080e7          	jalr	-1790(ra) # 8000447e <fdalloc>
    80004b84:	84aa                	mv	s1,a0
    80004b86:	0e054663          	bltz	a0,80004c72 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004b8a:	04491703          	lh	a4,68(s2)
    80004b8e:	478d                	li	a5,3
    80004b90:	0cf70463          	beq	a4,a5,80004c58 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004b94:	4789                	li	a5,2
    80004b96:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004b9a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004b9e:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ba2:	f4c42783          	lw	a5,-180(s0)
    80004ba6:	0017c713          	xori	a4,a5,1
    80004baa:	8b05                	andi	a4,a4,1
    80004bac:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bb0:	0037f713          	andi	a4,a5,3
    80004bb4:	00e03733          	snez	a4,a4
    80004bb8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bbc:	4007f793          	andi	a5,a5,1024
    80004bc0:	c791                	beqz	a5,80004bcc <sys_open+0xd2>
    80004bc2:	04491703          	lh	a4,68(s2)
    80004bc6:	4789                	li	a5,2
    80004bc8:	08f70f63          	beq	a4,a5,80004c66 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004bcc:	854a                	mv	a0,s2
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	082080e7          	jalr	130(ra) # 80002c50 <iunlock>
  end_op();
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	a0a080e7          	jalr	-1526(ra) # 800035e0 <end_op>

  return fd;
}
    80004bde:	8526                	mv	a0,s1
    80004be0:	70ea                	ld	ra,184(sp)
    80004be2:	744a                	ld	s0,176(sp)
    80004be4:	74aa                	ld	s1,168(sp)
    80004be6:	790a                	ld	s2,160(sp)
    80004be8:	69ea                	ld	s3,152(sp)
    80004bea:	6129                	addi	sp,sp,192
    80004bec:	8082                	ret
      end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	9f2080e7          	jalr	-1550(ra) # 800035e0 <end_op>
      return -1;
    80004bf6:	b7e5                	j	80004bde <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004bf8:	f5040513          	addi	a0,s0,-176
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	748080e7          	jalr	1864(ra) # 80003344 <namei>
    80004c04:	892a                	mv	s2,a0
    80004c06:	c905                	beqz	a0,80004c36 <sys_open+0x13c>
    ilock(ip);
    80004c08:	ffffe097          	auipc	ra,0xffffe
    80004c0c:	f86080e7          	jalr	-122(ra) # 80002b8e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c10:	04491703          	lh	a4,68(s2)
    80004c14:	4785                	li	a5,1
    80004c16:	f4f712e3          	bne	a4,a5,80004b5a <sys_open+0x60>
    80004c1a:	f4c42783          	lw	a5,-180(s0)
    80004c1e:	dba1                	beqz	a5,80004b6e <sys_open+0x74>
      iunlockput(ip);
    80004c20:	854a                	mv	a0,s2
    80004c22:	ffffe097          	auipc	ra,0xffffe
    80004c26:	1ce080e7          	jalr	462(ra) # 80002df0 <iunlockput>
      end_op();
    80004c2a:	fffff097          	auipc	ra,0xfffff
    80004c2e:	9b6080e7          	jalr	-1610(ra) # 800035e0 <end_op>
      return -1;
    80004c32:	54fd                	li	s1,-1
    80004c34:	b76d                	j	80004bde <sys_open+0xe4>
      end_op();
    80004c36:	fffff097          	auipc	ra,0xfffff
    80004c3a:	9aa080e7          	jalr	-1622(ra) # 800035e0 <end_op>
      return -1;
    80004c3e:	54fd                	li	s1,-1
    80004c40:	bf79                	j	80004bde <sys_open+0xe4>
    iunlockput(ip);
    80004c42:	854a                	mv	a0,s2
    80004c44:	ffffe097          	auipc	ra,0xffffe
    80004c48:	1ac080e7          	jalr	428(ra) # 80002df0 <iunlockput>
    end_op();
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	994080e7          	jalr	-1644(ra) # 800035e0 <end_op>
    return -1;
    80004c54:	54fd                	li	s1,-1
    80004c56:	b761                	j	80004bde <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c58:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c5c:	04691783          	lh	a5,70(s2)
    80004c60:	02f99223          	sh	a5,36(s3)
    80004c64:	bf2d                	j	80004b9e <sys_open+0xa4>
    itrunc(ip);
    80004c66:	854a                	mv	a0,s2
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	034080e7          	jalr	52(ra) # 80002c9c <itrunc>
    80004c70:	bfb1                	j	80004bcc <sys_open+0xd2>
      fileclose(f);
    80004c72:	854e                	mv	a0,s3
    80004c74:	fffff097          	auipc	ra,0xfffff
    80004c78:	db8080e7          	jalr	-584(ra) # 80003a2c <fileclose>
    iunlockput(ip);
    80004c7c:	854a                	mv	a0,s2
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	172080e7          	jalr	370(ra) # 80002df0 <iunlockput>
    end_op();
    80004c86:	fffff097          	auipc	ra,0xfffff
    80004c8a:	95a080e7          	jalr	-1702(ra) # 800035e0 <end_op>
    return -1;
    80004c8e:	54fd                	li	s1,-1
    80004c90:	b7b9                	j	80004bde <sys_open+0xe4>

0000000080004c92 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004c92:	7175                	addi	sp,sp,-144
    80004c94:	e506                	sd	ra,136(sp)
    80004c96:	e122                	sd	s0,128(sp)
    80004c98:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004c9a:	fffff097          	auipc	ra,0xfffff
    80004c9e:	8c6080e7          	jalr	-1850(ra) # 80003560 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ca2:	08000613          	li	a2,128
    80004ca6:	f7040593          	addi	a1,s0,-144
    80004caa:	4501                	li	a0,0
    80004cac:	ffffd097          	auipc	ra,0xffffd
    80004cb0:	2fc080e7          	jalr	764(ra) # 80001fa8 <argstr>
    80004cb4:	02054963          	bltz	a0,80004ce6 <sys_mkdir+0x54>
    80004cb8:	4681                	li	a3,0
    80004cba:	4601                	li	a2,0
    80004cbc:	4585                	li	a1,1
    80004cbe:	f7040513          	addi	a0,s0,-144
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	7fe080e7          	jalr	2046(ra) # 800044c0 <create>
    80004cca:	cd11                	beqz	a0,80004ce6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ccc:	ffffe097          	auipc	ra,0xffffe
    80004cd0:	124080e7          	jalr	292(ra) # 80002df0 <iunlockput>
  end_op();
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	90c080e7          	jalr	-1780(ra) # 800035e0 <end_op>
  return 0;
    80004cdc:	4501                	li	a0,0
}
    80004cde:	60aa                	ld	ra,136(sp)
    80004ce0:	640a                	ld	s0,128(sp)
    80004ce2:	6149                	addi	sp,sp,144
    80004ce4:	8082                	ret
    end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	8fa080e7          	jalr	-1798(ra) # 800035e0 <end_op>
    return -1;
    80004cee:	557d                	li	a0,-1
    80004cf0:	b7fd                	j	80004cde <sys_mkdir+0x4c>

0000000080004cf2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004cf2:	7135                	addi	sp,sp,-160
    80004cf4:	ed06                	sd	ra,152(sp)
    80004cf6:	e922                	sd	s0,144(sp)
    80004cf8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	866080e7          	jalr	-1946(ra) # 80003560 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d02:	08000613          	li	a2,128
    80004d06:	f7040593          	addi	a1,s0,-144
    80004d0a:	4501                	li	a0,0
    80004d0c:	ffffd097          	auipc	ra,0xffffd
    80004d10:	29c080e7          	jalr	668(ra) # 80001fa8 <argstr>
    80004d14:	04054a63          	bltz	a0,80004d68 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d18:	f6c40593          	addi	a1,s0,-148
    80004d1c:	4505                	li	a0,1
    80004d1e:	ffffd097          	auipc	ra,0xffffd
    80004d22:	246080e7          	jalr	582(ra) # 80001f64 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d26:	04054163          	bltz	a0,80004d68 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d2a:	f6840593          	addi	a1,s0,-152
    80004d2e:	4509                	li	a0,2
    80004d30:	ffffd097          	auipc	ra,0xffffd
    80004d34:	234080e7          	jalr	564(ra) # 80001f64 <argint>
     argint(1, &major) < 0 ||
    80004d38:	02054863          	bltz	a0,80004d68 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d3c:	f6841683          	lh	a3,-152(s0)
    80004d40:	f6c41603          	lh	a2,-148(s0)
    80004d44:	458d                	li	a1,3
    80004d46:	f7040513          	addi	a0,s0,-144
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	776080e7          	jalr	1910(ra) # 800044c0 <create>
     argint(2, &minor) < 0 ||
    80004d52:	c919                	beqz	a0,80004d68 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	09c080e7          	jalr	156(ra) # 80002df0 <iunlockput>
  end_op();
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	884080e7          	jalr	-1916(ra) # 800035e0 <end_op>
  return 0;
    80004d64:	4501                	li	a0,0
    80004d66:	a031                	j	80004d72 <sys_mknod+0x80>
    end_op();
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	878080e7          	jalr	-1928(ra) # 800035e0 <end_op>
    return -1;
    80004d70:	557d                	li	a0,-1
}
    80004d72:	60ea                	ld	ra,152(sp)
    80004d74:	644a                	ld	s0,144(sp)
    80004d76:	610d                	addi	sp,sp,160
    80004d78:	8082                	ret

0000000080004d7a <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d7a:	7135                	addi	sp,sp,-160
    80004d7c:	ed06                	sd	ra,152(sp)
    80004d7e:	e922                	sd	s0,144(sp)
    80004d80:	e526                	sd	s1,136(sp)
    80004d82:	e14a                	sd	s2,128(sp)
    80004d84:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d86:	ffffc097          	auipc	ra,0xffffc
    80004d8a:	0c2080e7          	jalr	194(ra) # 80000e48 <myproc>
    80004d8e:	892a                	mv	s2,a0
  
  begin_op();
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	7d0080e7          	jalr	2000(ra) # 80003560 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004d98:	08000613          	li	a2,128
    80004d9c:	f6040593          	addi	a1,s0,-160
    80004da0:	4501                	li	a0,0
    80004da2:	ffffd097          	auipc	ra,0xffffd
    80004da6:	206080e7          	jalr	518(ra) # 80001fa8 <argstr>
    80004daa:	04054b63          	bltz	a0,80004e00 <sys_chdir+0x86>
    80004dae:	f6040513          	addi	a0,s0,-160
    80004db2:	ffffe097          	auipc	ra,0xffffe
    80004db6:	592080e7          	jalr	1426(ra) # 80003344 <namei>
    80004dba:	84aa                	mv	s1,a0
    80004dbc:	c131                	beqz	a0,80004e00 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	dd0080e7          	jalr	-560(ra) # 80002b8e <ilock>
  if(ip->type != T_DIR){
    80004dc6:	04449703          	lh	a4,68(s1)
    80004dca:	4785                	li	a5,1
    80004dcc:	04f71063          	bne	a4,a5,80004e0c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004dd0:	8526                	mv	a0,s1
    80004dd2:	ffffe097          	auipc	ra,0xffffe
    80004dd6:	e7e080e7          	jalr	-386(ra) # 80002c50 <iunlock>
  iput(p->cwd);
    80004dda:	15093503          	ld	a0,336(s2)
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	f6a080e7          	jalr	-150(ra) # 80002d48 <iput>
  end_op();
    80004de6:	ffffe097          	auipc	ra,0xffffe
    80004dea:	7fa080e7          	jalr	2042(ra) # 800035e0 <end_op>
  p->cwd = ip;
    80004dee:	14993823          	sd	s1,336(s2)
  return 0;
    80004df2:	4501                	li	a0,0
}
    80004df4:	60ea                	ld	ra,152(sp)
    80004df6:	644a                	ld	s0,144(sp)
    80004df8:	64aa                	ld	s1,136(sp)
    80004dfa:	690a                	ld	s2,128(sp)
    80004dfc:	610d                	addi	sp,sp,160
    80004dfe:	8082                	ret
    end_op();
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	7e0080e7          	jalr	2016(ra) # 800035e0 <end_op>
    return -1;
    80004e08:	557d                	li	a0,-1
    80004e0a:	b7ed                	j	80004df4 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e0c:	8526                	mv	a0,s1
    80004e0e:	ffffe097          	auipc	ra,0xffffe
    80004e12:	fe2080e7          	jalr	-30(ra) # 80002df0 <iunlockput>
    end_op();
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	7ca080e7          	jalr	1994(ra) # 800035e0 <end_op>
    return -1;
    80004e1e:	557d                	li	a0,-1
    80004e20:	bfd1                	j	80004df4 <sys_chdir+0x7a>

0000000080004e22 <sys_exec>:

uint64
sys_exec(void)
{
    80004e22:	7145                	addi	sp,sp,-464
    80004e24:	e786                	sd	ra,456(sp)
    80004e26:	e3a2                	sd	s0,448(sp)
    80004e28:	ff26                	sd	s1,440(sp)
    80004e2a:	fb4a                	sd	s2,432(sp)
    80004e2c:	f74e                	sd	s3,424(sp)
    80004e2e:	f352                	sd	s4,416(sp)
    80004e30:	ef56                	sd	s5,408(sp)
    80004e32:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e34:	08000613          	li	a2,128
    80004e38:	f4040593          	addi	a1,s0,-192
    80004e3c:	4501                	li	a0,0
    80004e3e:	ffffd097          	auipc	ra,0xffffd
    80004e42:	16a080e7          	jalr	362(ra) # 80001fa8 <argstr>
    return -1;
    80004e46:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e48:	0c054a63          	bltz	a0,80004f1c <sys_exec+0xfa>
    80004e4c:	e3840593          	addi	a1,s0,-456
    80004e50:	4505                	li	a0,1
    80004e52:	ffffd097          	auipc	ra,0xffffd
    80004e56:	134080e7          	jalr	308(ra) # 80001f86 <argaddr>
    80004e5a:	0c054163          	bltz	a0,80004f1c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e5e:	10000613          	li	a2,256
    80004e62:	4581                	li	a1,0
    80004e64:	e4040513          	addi	a0,s0,-448
    80004e68:	ffffb097          	auipc	ra,0xffffb
    80004e6c:	310080e7          	jalr	784(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e70:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e74:	89a6                	mv	s3,s1
    80004e76:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e78:	02000a13          	li	s4,32
    80004e7c:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e80:	00391513          	slli	a0,s2,0x3
    80004e84:	e3040593          	addi	a1,s0,-464
    80004e88:	e3843783          	ld	a5,-456(s0)
    80004e8c:	953e                	add	a0,a0,a5
    80004e8e:	ffffd097          	auipc	ra,0xffffd
    80004e92:	03c080e7          	jalr	60(ra) # 80001eca <fetchaddr>
    80004e96:	02054a63          	bltz	a0,80004eca <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004e9a:	e3043783          	ld	a5,-464(s0)
    80004e9e:	c3b9                	beqz	a5,80004ee4 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ea0:	ffffb097          	auipc	ra,0xffffb
    80004ea4:	278080e7          	jalr	632(ra) # 80000118 <kalloc>
    80004ea8:	85aa                	mv	a1,a0
    80004eaa:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004eae:	cd11                	beqz	a0,80004eca <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004eb0:	6605                	lui	a2,0x1
    80004eb2:	e3043503          	ld	a0,-464(s0)
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	066080e7          	jalr	102(ra) # 80001f1c <fetchstr>
    80004ebe:	00054663          	bltz	a0,80004eca <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004ec2:	0905                	addi	s2,s2,1
    80004ec4:	09a1                	addi	s3,s3,8
    80004ec6:	fb491be3          	bne	s2,s4,80004e7c <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eca:	10048913          	addi	s2,s1,256
    80004ece:	6088                	ld	a0,0(s1)
    80004ed0:	c529                	beqz	a0,80004f1a <sys_exec+0xf8>
    kfree(argv[i]);
    80004ed2:	ffffb097          	auipc	ra,0xffffb
    80004ed6:	14a080e7          	jalr	330(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004eda:	04a1                	addi	s1,s1,8
    80004edc:	ff2499e3          	bne	s1,s2,80004ece <sys_exec+0xac>
  return -1;
    80004ee0:	597d                	li	s2,-1
    80004ee2:	a82d                	j	80004f1c <sys_exec+0xfa>
      argv[i] = 0;
    80004ee4:	0a8e                	slli	s5,s5,0x3
    80004ee6:	fc040793          	addi	a5,s0,-64
    80004eea:	9abe                	add	s5,s5,a5
    80004eec:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ef0:	e4040593          	addi	a1,s0,-448
    80004ef4:	f4040513          	addi	a0,s0,-192
    80004ef8:	fffff097          	auipc	ra,0xfffff
    80004efc:	194080e7          	jalr	404(ra) # 8000408c <exec>
    80004f00:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f02:	10048993          	addi	s3,s1,256
    80004f06:	6088                	ld	a0,0(s1)
    80004f08:	c911                	beqz	a0,80004f1c <sys_exec+0xfa>
    kfree(argv[i]);
    80004f0a:	ffffb097          	auipc	ra,0xffffb
    80004f0e:	112080e7          	jalr	274(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f12:	04a1                	addi	s1,s1,8
    80004f14:	ff3499e3          	bne	s1,s3,80004f06 <sys_exec+0xe4>
    80004f18:	a011                	j	80004f1c <sys_exec+0xfa>
  return -1;
    80004f1a:	597d                	li	s2,-1
}
    80004f1c:	854a                	mv	a0,s2
    80004f1e:	60be                	ld	ra,456(sp)
    80004f20:	641e                	ld	s0,448(sp)
    80004f22:	74fa                	ld	s1,440(sp)
    80004f24:	795a                	ld	s2,432(sp)
    80004f26:	79ba                	ld	s3,424(sp)
    80004f28:	7a1a                	ld	s4,416(sp)
    80004f2a:	6afa                	ld	s5,408(sp)
    80004f2c:	6179                	addi	sp,sp,464
    80004f2e:	8082                	ret

0000000080004f30 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f30:	7139                	addi	sp,sp,-64
    80004f32:	fc06                	sd	ra,56(sp)
    80004f34:	f822                	sd	s0,48(sp)
    80004f36:	f426                	sd	s1,40(sp)
    80004f38:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f3a:	ffffc097          	auipc	ra,0xffffc
    80004f3e:	f0e080e7          	jalr	-242(ra) # 80000e48 <myproc>
    80004f42:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f44:	fd840593          	addi	a1,s0,-40
    80004f48:	4501                	li	a0,0
    80004f4a:	ffffd097          	auipc	ra,0xffffd
    80004f4e:	03c080e7          	jalr	60(ra) # 80001f86 <argaddr>
    return -1;
    80004f52:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f54:	0e054063          	bltz	a0,80005034 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f58:	fc840593          	addi	a1,s0,-56
    80004f5c:	fd040513          	addi	a0,s0,-48
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	dfc080e7          	jalr	-516(ra) # 80003d5c <pipealloc>
    return -1;
    80004f68:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f6a:	0c054563          	bltz	a0,80005034 <sys_pipe+0x104>
  fd0 = -1;
    80004f6e:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f72:	fd043503          	ld	a0,-48(s0)
    80004f76:	fffff097          	auipc	ra,0xfffff
    80004f7a:	508080e7          	jalr	1288(ra) # 8000447e <fdalloc>
    80004f7e:	fca42223          	sw	a0,-60(s0)
    80004f82:	08054c63          	bltz	a0,8000501a <sys_pipe+0xea>
    80004f86:	fc843503          	ld	a0,-56(s0)
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	4f4080e7          	jalr	1268(ra) # 8000447e <fdalloc>
    80004f92:	fca42023          	sw	a0,-64(s0)
    80004f96:	06054863          	bltz	a0,80005006 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004f9a:	4691                	li	a3,4
    80004f9c:	fc440613          	addi	a2,s0,-60
    80004fa0:	fd843583          	ld	a1,-40(s0)
    80004fa4:	68a8                	ld	a0,80(s1)
    80004fa6:	ffffc097          	auipc	ra,0xffffc
    80004faa:	b64080e7          	jalr	-1180(ra) # 80000b0a <copyout>
    80004fae:	02054063          	bltz	a0,80004fce <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fb2:	4691                	li	a3,4
    80004fb4:	fc040613          	addi	a2,s0,-64
    80004fb8:	fd843583          	ld	a1,-40(s0)
    80004fbc:	0591                	addi	a1,a1,4
    80004fbe:	68a8                	ld	a0,80(s1)
    80004fc0:	ffffc097          	auipc	ra,0xffffc
    80004fc4:	b4a080e7          	jalr	-1206(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fc8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fca:	06055563          	bgez	a0,80005034 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fce:	fc442783          	lw	a5,-60(s0)
    80004fd2:	07e9                	addi	a5,a5,26
    80004fd4:	078e                	slli	a5,a5,0x3
    80004fd6:	97a6                	add	a5,a5,s1
    80004fd8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004fdc:	fc042503          	lw	a0,-64(s0)
    80004fe0:	0569                	addi	a0,a0,26
    80004fe2:	050e                	slli	a0,a0,0x3
    80004fe4:	9526                	add	a0,a0,s1
    80004fe6:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80004fea:	fd043503          	ld	a0,-48(s0)
    80004fee:	fffff097          	auipc	ra,0xfffff
    80004ff2:	a3e080e7          	jalr	-1474(ra) # 80003a2c <fileclose>
    fileclose(wf);
    80004ff6:	fc843503          	ld	a0,-56(s0)
    80004ffa:	fffff097          	auipc	ra,0xfffff
    80004ffe:	a32080e7          	jalr	-1486(ra) # 80003a2c <fileclose>
    return -1;
    80005002:	57fd                	li	a5,-1
    80005004:	a805                	j	80005034 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005006:	fc442783          	lw	a5,-60(s0)
    8000500a:	0007c863          	bltz	a5,8000501a <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000500e:	01a78513          	addi	a0,a5,26
    80005012:	050e                	slli	a0,a0,0x3
    80005014:	9526                	add	a0,a0,s1
    80005016:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000501a:	fd043503          	ld	a0,-48(s0)
    8000501e:	fffff097          	auipc	ra,0xfffff
    80005022:	a0e080e7          	jalr	-1522(ra) # 80003a2c <fileclose>
    fileclose(wf);
    80005026:	fc843503          	ld	a0,-56(s0)
    8000502a:	fffff097          	auipc	ra,0xfffff
    8000502e:	a02080e7          	jalr	-1534(ra) # 80003a2c <fileclose>
    return -1;
    80005032:	57fd                	li	a5,-1
}
    80005034:	853e                	mv	a0,a5
    80005036:	70e2                	ld	ra,56(sp)
    80005038:	7442                	ld	s0,48(sp)
    8000503a:	74a2                	ld	s1,40(sp)
    8000503c:	6121                	addi	sp,sp,64
    8000503e:	8082                	ret

0000000080005040 <kernelvec>:
    80005040:	7111                	addi	sp,sp,-256
    80005042:	e006                	sd	ra,0(sp)
    80005044:	e40a                	sd	sp,8(sp)
    80005046:	e80e                	sd	gp,16(sp)
    80005048:	ec12                	sd	tp,24(sp)
    8000504a:	f016                	sd	t0,32(sp)
    8000504c:	f41a                	sd	t1,40(sp)
    8000504e:	f81e                	sd	t2,48(sp)
    80005050:	fc22                	sd	s0,56(sp)
    80005052:	e0a6                	sd	s1,64(sp)
    80005054:	e4aa                	sd	a0,72(sp)
    80005056:	e8ae                	sd	a1,80(sp)
    80005058:	ecb2                	sd	a2,88(sp)
    8000505a:	f0b6                	sd	a3,96(sp)
    8000505c:	f4ba                	sd	a4,104(sp)
    8000505e:	f8be                	sd	a5,112(sp)
    80005060:	fcc2                	sd	a6,120(sp)
    80005062:	e146                	sd	a7,128(sp)
    80005064:	e54a                	sd	s2,136(sp)
    80005066:	e94e                	sd	s3,144(sp)
    80005068:	ed52                	sd	s4,152(sp)
    8000506a:	f156                	sd	s5,160(sp)
    8000506c:	f55a                	sd	s6,168(sp)
    8000506e:	f95e                	sd	s7,176(sp)
    80005070:	fd62                	sd	s8,184(sp)
    80005072:	e1e6                	sd	s9,192(sp)
    80005074:	e5ea                	sd	s10,200(sp)
    80005076:	e9ee                	sd	s11,208(sp)
    80005078:	edf2                	sd	t3,216(sp)
    8000507a:	f1f6                	sd	t4,224(sp)
    8000507c:	f5fa                	sd	t5,232(sp)
    8000507e:	f9fe                	sd	t6,240(sp)
    80005080:	d17fc0ef          	jal	ra,80001d96 <kerneltrap>
    80005084:	6082                	ld	ra,0(sp)
    80005086:	6122                	ld	sp,8(sp)
    80005088:	61c2                	ld	gp,16(sp)
    8000508a:	7282                	ld	t0,32(sp)
    8000508c:	7322                	ld	t1,40(sp)
    8000508e:	73c2                	ld	t2,48(sp)
    80005090:	7462                	ld	s0,56(sp)
    80005092:	6486                	ld	s1,64(sp)
    80005094:	6526                	ld	a0,72(sp)
    80005096:	65c6                	ld	a1,80(sp)
    80005098:	6666                	ld	a2,88(sp)
    8000509a:	7686                	ld	a3,96(sp)
    8000509c:	7726                	ld	a4,104(sp)
    8000509e:	77c6                	ld	a5,112(sp)
    800050a0:	7866                	ld	a6,120(sp)
    800050a2:	688a                	ld	a7,128(sp)
    800050a4:	692a                	ld	s2,136(sp)
    800050a6:	69ca                	ld	s3,144(sp)
    800050a8:	6a6a                	ld	s4,152(sp)
    800050aa:	7a8a                	ld	s5,160(sp)
    800050ac:	7b2a                	ld	s6,168(sp)
    800050ae:	7bca                	ld	s7,176(sp)
    800050b0:	7c6a                	ld	s8,184(sp)
    800050b2:	6c8e                	ld	s9,192(sp)
    800050b4:	6d2e                	ld	s10,200(sp)
    800050b6:	6dce                	ld	s11,208(sp)
    800050b8:	6e6e                	ld	t3,216(sp)
    800050ba:	7e8e                	ld	t4,224(sp)
    800050bc:	7f2e                	ld	t5,232(sp)
    800050be:	7fce                	ld	t6,240(sp)
    800050c0:	6111                	addi	sp,sp,256
    800050c2:	10200073          	sret
    800050c6:	00000013          	nop
    800050ca:	00000013          	nop
    800050ce:	0001                	nop

00000000800050d0 <timervec>:
    800050d0:	34051573          	csrrw	a0,mscratch,a0
    800050d4:	e10c                	sd	a1,0(a0)
    800050d6:	e510                	sd	a2,8(a0)
    800050d8:	e914                	sd	a3,16(a0)
    800050da:	6d0c                	ld	a1,24(a0)
    800050dc:	7110                	ld	a2,32(a0)
    800050de:	6194                	ld	a3,0(a1)
    800050e0:	96b2                	add	a3,a3,a2
    800050e2:	e194                	sd	a3,0(a1)
    800050e4:	4589                	li	a1,2
    800050e6:	14459073          	csrw	sip,a1
    800050ea:	6914                	ld	a3,16(a0)
    800050ec:	6510                	ld	a2,8(a0)
    800050ee:	610c                	ld	a1,0(a0)
    800050f0:	34051573          	csrrw	a0,mscratch,a0
    800050f4:	30200073          	mret
	...

00000000800050fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800050fa:	1141                	addi	sp,sp,-16
    800050fc:	e422                	sd	s0,8(sp)
    800050fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005100:	0c0007b7          	lui	a5,0xc000
    80005104:	4705                	li	a4,1
    80005106:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005108:	c3d8                	sw	a4,4(a5)
}
    8000510a:	6422                	ld	s0,8(sp)
    8000510c:	0141                	addi	sp,sp,16
    8000510e:	8082                	ret

0000000080005110 <plicinithart>:

void
plicinithart(void)
{
    80005110:	1141                	addi	sp,sp,-16
    80005112:	e406                	sd	ra,8(sp)
    80005114:	e022                	sd	s0,0(sp)
    80005116:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005118:	ffffc097          	auipc	ra,0xffffc
    8000511c:	d04080e7          	jalr	-764(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005120:	0085171b          	slliw	a4,a0,0x8
    80005124:	0c0027b7          	lui	a5,0xc002
    80005128:	97ba                	add	a5,a5,a4
    8000512a:	40200713          	li	a4,1026
    8000512e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005132:	00d5151b          	slliw	a0,a0,0xd
    80005136:	0c2017b7          	lui	a5,0xc201
    8000513a:	953e                	add	a0,a0,a5
    8000513c:	00052023          	sw	zero,0(a0)
}
    80005140:	60a2                	ld	ra,8(sp)
    80005142:	6402                	ld	s0,0(sp)
    80005144:	0141                	addi	sp,sp,16
    80005146:	8082                	ret

0000000080005148 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005148:	1141                	addi	sp,sp,-16
    8000514a:	e406                	sd	ra,8(sp)
    8000514c:	e022                	sd	s0,0(sp)
    8000514e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005150:	ffffc097          	auipc	ra,0xffffc
    80005154:	ccc080e7          	jalr	-820(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005158:	00d5179b          	slliw	a5,a0,0xd
    8000515c:	0c201537          	lui	a0,0xc201
    80005160:	953e                	add	a0,a0,a5
  return irq;
}
    80005162:	4148                	lw	a0,4(a0)
    80005164:	60a2                	ld	ra,8(sp)
    80005166:	6402                	ld	s0,0(sp)
    80005168:	0141                	addi	sp,sp,16
    8000516a:	8082                	ret

000000008000516c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000516c:	1101                	addi	sp,sp,-32
    8000516e:	ec06                	sd	ra,24(sp)
    80005170:	e822                	sd	s0,16(sp)
    80005172:	e426                	sd	s1,8(sp)
    80005174:	1000                	addi	s0,sp,32
    80005176:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	ca4080e7          	jalr	-860(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005180:	00d5151b          	slliw	a0,a0,0xd
    80005184:	0c2017b7          	lui	a5,0xc201
    80005188:	97aa                	add	a5,a5,a0
    8000518a:	c3c4                	sw	s1,4(a5)
}
    8000518c:	60e2                	ld	ra,24(sp)
    8000518e:	6442                	ld	s0,16(sp)
    80005190:	64a2                	ld	s1,8(sp)
    80005192:	6105                	addi	sp,sp,32
    80005194:	8082                	ret

0000000080005196 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005196:	1141                	addi	sp,sp,-16
    80005198:	e406                	sd	ra,8(sp)
    8000519a:	e022                	sd	s0,0(sp)
    8000519c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000519e:	479d                	li	a5,7
    800051a0:	06a7c963          	blt	a5,a0,80005212 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051a4:	00016797          	auipc	a5,0x16
    800051a8:	e5c78793          	addi	a5,a5,-420 # 8001b000 <disk>
    800051ac:	00a78733          	add	a4,a5,a0
    800051b0:	6789                	lui	a5,0x2
    800051b2:	97ba                	add	a5,a5,a4
    800051b4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051b8:	e7ad                	bnez	a5,80005222 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051ba:	00451793          	slli	a5,a0,0x4
    800051be:	00018717          	auipc	a4,0x18
    800051c2:	e4270713          	addi	a4,a4,-446 # 8001d000 <disk+0x2000>
    800051c6:	6314                	ld	a3,0(a4)
    800051c8:	96be                	add	a3,a3,a5
    800051ca:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051ce:	6314                	ld	a3,0(a4)
    800051d0:	96be                	add	a3,a3,a5
    800051d2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051d6:	6314                	ld	a3,0(a4)
    800051d8:	96be                	add	a3,a3,a5
    800051da:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051de:	6318                	ld	a4,0(a4)
    800051e0:	97ba                	add	a5,a5,a4
    800051e2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800051e6:	00016797          	auipc	a5,0x16
    800051ea:	e1a78793          	addi	a5,a5,-486 # 8001b000 <disk>
    800051ee:	97aa                	add	a5,a5,a0
    800051f0:	6509                	lui	a0,0x2
    800051f2:	953e                	add	a0,a0,a5
    800051f4:	4785                	li	a5,1
    800051f6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800051fa:	00018517          	auipc	a0,0x18
    800051fe:	e1e50513          	addi	a0,a0,-482 # 8001d018 <disk+0x2018>
    80005202:	ffffc097          	auipc	ra,0xffffc
    80005206:	4c4080e7          	jalr	1220(ra) # 800016c6 <wakeup>
}
    8000520a:	60a2                	ld	ra,8(sp)
    8000520c:	6402                	ld	s0,0(sp)
    8000520e:	0141                	addi	sp,sp,16
    80005210:	8082                	ret
    panic("free_desc 1");
    80005212:	00003517          	auipc	a0,0x3
    80005216:	4e650513          	addi	a0,a0,1254 # 800086f8 <syscalls+0x330>
    8000521a:	00001097          	auipc	ra,0x1
    8000521e:	aac080e7          	jalr	-1364(ra) # 80005cc6 <panic>
    panic("free_desc 2");
    80005222:	00003517          	auipc	a0,0x3
    80005226:	4e650513          	addi	a0,a0,1254 # 80008708 <syscalls+0x340>
    8000522a:	00001097          	auipc	ra,0x1
    8000522e:	a9c080e7          	jalr	-1380(ra) # 80005cc6 <panic>

0000000080005232 <virtio_disk_init>:
{
    80005232:	1101                	addi	sp,sp,-32
    80005234:	ec06                	sd	ra,24(sp)
    80005236:	e822                	sd	s0,16(sp)
    80005238:	e426                	sd	s1,8(sp)
    8000523a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000523c:	00003597          	auipc	a1,0x3
    80005240:	4dc58593          	addi	a1,a1,1244 # 80008718 <syscalls+0x350>
    80005244:	00018517          	auipc	a0,0x18
    80005248:	ee450513          	addi	a0,a0,-284 # 8001d128 <disk+0x2128>
    8000524c:	00001097          	auipc	ra,0x1
    80005250:	f0a080e7          	jalr	-246(ra) # 80006156 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005254:	100017b7          	lui	a5,0x10001
    80005258:	4398                	lw	a4,0(a5)
    8000525a:	2701                	sext.w	a4,a4
    8000525c:	747277b7          	lui	a5,0x74727
    80005260:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005264:	0ef71163          	bne	a4,a5,80005346 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005268:	100017b7          	lui	a5,0x10001
    8000526c:	43dc                	lw	a5,4(a5)
    8000526e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005270:	4705                	li	a4,1
    80005272:	0ce79a63          	bne	a5,a4,80005346 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005276:	100017b7          	lui	a5,0x10001
    8000527a:	479c                	lw	a5,8(a5)
    8000527c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000527e:	4709                	li	a4,2
    80005280:	0ce79363          	bne	a5,a4,80005346 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005284:	100017b7          	lui	a5,0x10001
    80005288:	47d8                	lw	a4,12(a5)
    8000528a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000528c:	554d47b7          	lui	a5,0x554d4
    80005290:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005294:	0af71963          	bne	a4,a5,80005346 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005298:	100017b7          	lui	a5,0x10001
    8000529c:	4705                	li	a4,1
    8000529e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052a0:	470d                	li	a4,3
    800052a2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052a4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052a6:	c7ffe737          	lui	a4,0xc7ffe
    800052aa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052ae:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052b0:	2701                	sext.w	a4,a4
    800052b2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b4:	472d                	li	a4,11
    800052b6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b8:	473d                	li	a4,15
    800052ba:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052bc:	6705                	lui	a4,0x1
    800052be:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052c0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052c4:	5bdc                	lw	a5,52(a5)
    800052c6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052c8:	c7d9                	beqz	a5,80005356 <virtio_disk_init+0x124>
  if(max < NUM)
    800052ca:	471d                	li	a4,7
    800052cc:	08f77d63          	bgeu	a4,a5,80005366 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052d0:	100014b7          	lui	s1,0x10001
    800052d4:	47a1                	li	a5,8
    800052d6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052d8:	6609                	lui	a2,0x2
    800052da:	4581                	li	a1,0
    800052dc:	00016517          	auipc	a0,0x16
    800052e0:	d2450513          	addi	a0,a0,-732 # 8001b000 <disk>
    800052e4:	ffffb097          	auipc	ra,0xffffb
    800052e8:	e94080e7          	jalr	-364(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800052ec:	00016717          	auipc	a4,0x16
    800052f0:	d1470713          	addi	a4,a4,-748 # 8001b000 <disk>
    800052f4:	00c75793          	srli	a5,a4,0xc
    800052f8:	2781                	sext.w	a5,a5
    800052fa:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800052fc:	00018797          	auipc	a5,0x18
    80005300:	d0478793          	addi	a5,a5,-764 # 8001d000 <disk+0x2000>
    80005304:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005306:	00016717          	auipc	a4,0x16
    8000530a:	d7a70713          	addi	a4,a4,-646 # 8001b080 <disk+0x80>
    8000530e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005310:	00017717          	auipc	a4,0x17
    80005314:	cf070713          	addi	a4,a4,-784 # 8001c000 <disk+0x1000>
    80005318:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000531a:	4705                	li	a4,1
    8000531c:	00e78c23          	sb	a4,24(a5)
    80005320:	00e78ca3          	sb	a4,25(a5)
    80005324:	00e78d23          	sb	a4,26(a5)
    80005328:	00e78da3          	sb	a4,27(a5)
    8000532c:	00e78e23          	sb	a4,28(a5)
    80005330:	00e78ea3          	sb	a4,29(a5)
    80005334:	00e78f23          	sb	a4,30(a5)
    80005338:	00e78fa3          	sb	a4,31(a5)
}
    8000533c:	60e2                	ld	ra,24(sp)
    8000533e:	6442                	ld	s0,16(sp)
    80005340:	64a2                	ld	s1,8(sp)
    80005342:	6105                	addi	sp,sp,32
    80005344:	8082                	ret
    panic("could not find virtio disk");
    80005346:	00003517          	auipc	a0,0x3
    8000534a:	3e250513          	addi	a0,a0,994 # 80008728 <syscalls+0x360>
    8000534e:	00001097          	auipc	ra,0x1
    80005352:	978080e7          	jalr	-1672(ra) # 80005cc6 <panic>
    panic("virtio disk has no queue 0");
    80005356:	00003517          	auipc	a0,0x3
    8000535a:	3f250513          	addi	a0,a0,1010 # 80008748 <syscalls+0x380>
    8000535e:	00001097          	auipc	ra,0x1
    80005362:	968080e7          	jalr	-1688(ra) # 80005cc6 <panic>
    panic("virtio disk max queue too short");
    80005366:	00003517          	auipc	a0,0x3
    8000536a:	40250513          	addi	a0,a0,1026 # 80008768 <syscalls+0x3a0>
    8000536e:	00001097          	auipc	ra,0x1
    80005372:	958080e7          	jalr	-1704(ra) # 80005cc6 <panic>

0000000080005376 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005376:	7159                	addi	sp,sp,-112
    80005378:	f486                	sd	ra,104(sp)
    8000537a:	f0a2                	sd	s0,96(sp)
    8000537c:	eca6                	sd	s1,88(sp)
    8000537e:	e8ca                	sd	s2,80(sp)
    80005380:	e4ce                	sd	s3,72(sp)
    80005382:	e0d2                	sd	s4,64(sp)
    80005384:	fc56                	sd	s5,56(sp)
    80005386:	f85a                	sd	s6,48(sp)
    80005388:	f45e                	sd	s7,40(sp)
    8000538a:	f062                	sd	s8,32(sp)
    8000538c:	ec66                	sd	s9,24(sp)
    8000538e:	e86a                	sd	s10,16(sp)
    80005390:	1880                	addi	s0,sp,112
    80005392:	892a                	mv	s2,a0
    80005394:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005396:	00c52c83          	lw	s9,12(a0)
    8000539a:	001c9c9b          	slliw	s9,s9,0x1
    8000539e:	1c82                	slli	s9,s9,0x20
    800053a0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053a4:	00018517          	auipc	a0,0x18
    800053a8:	d8450513          	addi	a0,a0,-636 # 8001d128 <disk+0x2128>
    800053ac:	00001097          	auipc	ra,0x1
    800053b0:	e3a080e7          	jalr	-454(ra) # 800061e6 <acquire>
  for(int i = 0; i < 3; i++){
    800053b4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053b6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800053b8:	00016b97          	auipc	s7,0x16
    800053bc:	c48b8b93          	addi	s7,s7,-952 # 8001b000 <disk>
    800053c0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053c2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053c4:	8a4e                	mv	s4,s3
    800053c6:	a051                	j	8000544a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800053c8:	00fb86b3          	add	a3,s7,a5
    800053cc:	96da                	add	a3,a3,s6
    800053ce:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800053d2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800053d4:	0207c563          	bltz	a5,800053fe <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053d8:	2485                	addiw	s1,s1,1
    800053da:	0711                	addi	a4,a4,4
    800053dc:	25548063          	beq	s1,s5,8000561c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800053e0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800053e2:	00018697          	auipc	a3,0x18
    800053e6:	c3668693          	addi	a3,a3,-970 # 8001d018 <disk+0x2018>
    800053ea:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800053ec:	0006c583          	lbu	a1,0(a3)
    800053f0:	fde1                	bnez	a1,800053c8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800053f2:	2785                	addiw	a5,a5,1
    800053f4:	0685                	addi	a3,a3,1
    800053f6:	ff879be3          	bne	a5,s8,800053ec <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800053fa:	57fd                	li	a5,-1
    800053fc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800053fe:	02905a63          	blez	s1,80005432 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005402:	f9042503          	lw	a0,-112(s0)
    80005406:	00000097          	auipc	ra,0x0
    8000540a:	d90080e7          	jalr	-624(ra) # 80005196 <free_desc>
      for(int j = 0; j < i; j++)
    8000540e:	4785                	li	a5,1
    80005410:	0297d163          	bge	a5,s1,80005432 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005414:	f9442503          	lw	a0,-108(s0)
    80005418:	00000097          	auipc	ra,0x0
    8000541c:	d7e080e7          	jalr	-642(ra) # 80005196 <free_desc>
      for(int j = 0; j < i; j++)
    80005420:	4789                	li	a5,2
    80005422:	0097d863          	bge	a5,s1,80005432 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005426:	f9842503          	lw	a0,-104(s0)
    8000542a:	00000097          	auipc	ra,0x0
    8000542e:	d6c080e7          	jalr	-660(ra) # 80005196 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005432:	00018597          	auipc	a1,0x18
    80005436:	cf658593          	addi	a1,a1,-778 # 8001d128 <disk+0x2128>
    8000543a:	00018517          	auipc	a0,0x18
    8000543e:	bde50513          	addi	a0,a0,-1058 # 8001d018 <disk+0x2018>
    80005442:	ffffc097          	auipc	ra,0xffffc
    80005446:	0f8080e7          	jalr	248(ra) # 8000153a <sleep>
  for(int i = 0; i < 3; i++){
    8000544a:	f9040713          	addi	a4,s0,-112
    8000544e:	84ce                	mv	s1,s3
    80005450:	bf41                	j	800053e0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005452:	20058713          	addi	a4,a1,512
    80005456:	00471693          	slli	a3,a4,0x4
    8000545a:	00016717          	auipc	a4,0x16
    8000545e:	ba670713          	addi	a4,a4,-1114 # 8001b000 <disk>
    80005462:	9736                	add	a4,a4,a3
    80005464:	4685                	li	a3,1
    80005466:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000546a:	20058713          	addi	a4,a1,512
    8000546e:	00471693          	slli	a3,a4,0x4
    80005472:	00016717          	auipc	a4,0x16
    80005476:	b8e70713          	addi	a4,a4,-1138 # 8001b000 <disk>
    8000547a:	9736                	add	a4,a4,a3
    8000547c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005480:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005484:	7679                	lui	a2,0xffffe
    80005486:	963e                	add	a2,a2,a5
    80005488:	00018697          	auipc	a3,0x18
    8000548c:	b7868693          	addi	a3,a3,-1160 # 8001d000 <disk+0x2000>
    80005490:	6298                	ld	a4,0(a3)
    80005492:	9732                	add	a4,a4,a2
    80005494:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005496:	6298                	ld	a4,0(a3)
    80005498:	9732                	add	a4,a4,a2
    8000549a:	4541                	li	a0,16
    8000549c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000549e:	6298                	ld	a4,0(a3)
    800054a0:	9732                	add	a4,a4,a2
    800054a2:	4505                	li	a0,1
    800054a4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054a8:	f9442703          	lw	a4,-108(s0)
    800054ac:	6288                	ld	a0,0(a3)
    800054ae:	962a                	add	a2,a2,a0
    800054b0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054b4:	0712                	slli	a4,a4,0x4
    800054b6:	6290                	ld	a2,0(a3)
    800054b8:	963a                	add	a2,a2,a4
    800054ba:	05890513          	addi	a0,s2,88
    800054be:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800054c0:	6294                	ld	a3,0(a3)
    800054c2:	96ba                	add	a3,a3,a4
    800054c4:	40000613          	li	a2,1024
    800054c8:	c690                	sw	a2,8(a3)
  if(write)
    800054ca:	140d0063          	beqz	s10,8000560a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054ce:	00018697          	auipc	a3,0x18
    800054d2:	b326b683          	ld	a3,-1230(a3) # 8001d000 <disk+0x2000>
    800054d6:	96ba                	add	a3,a3,a4
    800054d8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054dc:	00016817          	auipc	a6,0x16
    800054e0:	b2480813          	addi	a6,a6,-1244 # 8001b000 <disk>
    800054e4:	00018517          	auipc	a0,0x18
    800054e8:	b1c50513          	addi	a0,a0,-1252 # 8001d000 <disk+0x2000>
    800054ec:	6114                	ld	a3,0(a0)
    800054ee:	96ba                	add	a3,a3,a4
    800054f0:	00c6d603          	lhu	a2,12(a3)
    800054f4:	00166613          	ori	a2,a2,1
    800054f8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800054fc:	f9842683          	lw	a3,-104(s0)
    80005500:	6110                	ld	a2,0(a0)
    80005502:	9732                	add	a4,a4,a2
    80005504:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005508:	20058613          	addi	a2,a1,512
    8000550c:	0612                	slli	a2,a2,0x4
    8000550e:	9642                	add	a2,a2,a6
    80005510:	577d                	li	a4,-1
    80005512:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005516:	00469713          	slli	a4,a3,0x4
    8000551a:	6114                	ld	a3,0(a0)
    8000551c:	96ba                	add	a3,a3,a4
    8000551e:	03078793          	addi	a5,a5,48
    80005522:	97c2                	add	a5,a5,a6
    80005524:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005526:	611c                	ld	a5,0(a0)
    80005528:	97ba                	add	a5,a5,a4
    8000552a:	4685                	li	a3,1
    8000552c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000552e:	611c                	ld	a5,0(a0)
    80005530:	97ba                	add	a5,a5,a4
    80005532:	4809                	li	a6,2
    80005534:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005538:	611c                	ld	a5,0(a0)
    8000553a:	973e                	add	a4,a4,a5
    8000553c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005540:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005544:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005548:	6518                	ld	a4,8(a0)
    8000554a:	00275783          	lhu	a5,2(a4)
    8000554e:	8b9d                	andi	a5,a5,7
    80005550:	0786                	slli	a5,a5,0x1
    80005552:	97ba                	add	a5,a5,a4
    80005554:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005558:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000555c:	6518                	ld	a4,8(a0)
    8000555e:	00275783          	lhu	a5,2(a4)
    80005562:	2785                	addiw	a5,a5,1
    80005564:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005568:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000556c:	100017b7          	lui	a5,0x10001
    80005570:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005574:	00492703          	lw	a4,4(s2)
    80005578:	4785                	li	a5,1
    8000557a:	02f71163          	bne	a4,a5,8000559c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000557e:	00018997          	auipc	s3,0x18
    80005582:	baa98993          	addi	s3,s3,-1110 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005586:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005588:	85ce                	mv	a1,s3
    8000558a:	854a                	mv	a0,s2
    8000558c:	ffffc097          	auipc	ra,0xffffc
    80005590:	fae080e7          	jalr	-82(ra) # 8000153a <sleep>
  while(b->disk == 1) {
    80005594:	00492783          	lw	a5,4(s2)
    80005598:	fe9788e3          	beq	a5,s1,80005588 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000559c:	f9042903          	lw	s2,-112(s0)
    800055a0:	20090793          	addi	a5,s2,512
    800055a4:	00479713          	slli	a4,a5,0x4
    800055a8:	00016797          	auipc	a5,0x16
    800055ac:	a5878793          	addi	a5,a5,-1448 # 8001b000 <disk>
    800055b0:	97ba                	add	a5,a5,a4
    800055b2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055b6:	00018997          	auipc	s3,0x18
    800055ba:	a4a98993          	addi	s3,s3,-1462 # 8001d000 <disk+0x2000>
    800055be:	00491713          	slli	a4,s2,0x4
    800055c2:	0009b783          	ld	a5,0(s3)
    800055c6:	97ba                	add	a5,a5,a4
    800055c8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055cc:	854a                	mv	a0,s2
    800055ce:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055d2:	00000097          	auipc	ra,0x0
    800055d6:	bc4080e7          	jalr	-1084(ra) # 80005196 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055da:	8885                	andi	s1,s1,1
    800055dc:	f0ed                	bnez	s1,800055be <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055de:	00018517          	auipc	a0,0x18
    800055e2:	b4a50513          	addi	a0,a0,-1206 # 8001d128 <disk+0x2128>
    800055e6:	00001097          	auipc	ra,0x1
    800055ea:	cb4080e7          	jalr	-844(ra) # 8000629a <release>
}
    800055ee:	70a6                	ld	ra,104(sp)
    800055f0:	7406                	ld	s0,96(sp)
    800055f2:	64e6                	ld	s1,88(sp)
    800055f4:	6946                	ld	s2,80(sp)
    800055f6:	69a6                	ld	s3,72(sp)
    800055f8:	6a06                	ld	s4,64(sp)
    800055fa:	7ae2                	ld	s5,56(sp)
    800055fc:	7b42                	ld	s6,48(sp)
    800055fe:	7ba2                	ld	s7,40(sp)
    80005600:	7c02                	ld	s8,32(sp)
    80005602:	6ce2                	ld	s9,24(sp)
    80005604:	6d42                	ld	s10,16(sp)
    80005606:	6165                	addi	sp,sp,112
    80005608:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000560a:	00018697          	auipc	a3,0x18
    8000560e:	9f66b683          	ld	a3,-1546(a3) # 8001d000 <disk+0x2000>
    80005612:	96ba                	add	a3,a3,a4
    80005614:	4609                	li	a2,2
    80005616:	00c69623          	sh	a2,12(a3)
    8000561a:	b5c9                	j	800054dc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000561c:	f9042583          	lw	a1,-112(s0)
    80005620:	20058793          	addi	a5,a1,512
    80005624:	0792                	slli	a5,a5,0x4
    80005626:	00016517          	auipc	a0,0x16
    8000562a:	a8250513          	addi	a0,a0,-1406 # 8001b0a8 <disk+0xa8>
    8000562e:	953e                	add	a0,a0,a5
  if(write)
    80005630:	e20d11e3          	bnez	s10,80005452 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005634:	20058713          	addi	a4,a1,512
    80005638:	00471693          	slli	a3,a4,0x4
    8000563c:	00016717          	auipc	a4,0x16
    80005640:	9c470713          	addi	a4,a4,-1596 # 8001b000 <disk>
    80005644:	9736                	add	a4,a4,a3
    80005646:	0a072423          	sw	zero,168(a4)
    8000564a:	b505                	j	8000546a <virtio_disk_rw+0xf4>

000000008000564c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000564c:	1101                	addi	sp,sp,-32
    8000564e:	ec06                	sd	ra,24(sp)
    80005650:	e822                	sd	s0,16(sp)
    80005652:	e426                	sd	s1,8(sp)
    80005654:	e04a                	sd	s2,0(sp)
    80005656:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005658:	00018517          	auipc	a0,0x18
    8000565c:	ad050513          	addi	a0,a0,-1328 # 8001d128 <disk+0x2128>
    80005660:	00001097          	auipc	ra,0x1
    80005664:	b86080e7          	jalr	-1146(ra) # 800061e6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005668:	10001737          	lui	a4,0x10001
    8000566c:	533c                	lw	a5,96(a4)
    8000566e:	8b8d                	andi	a5,a5,3
    80005670:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005672:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005676:	00018797          	auipc	a5,0x18
    8000567a:	98a78793          	addi	a5,a5,-1654 # 8001d000 <disk+0x2000>
    8000567e:	6b94                	ld	a3,16(a5)
    80005680:	0207d703          	lhu	a4,32(a5)
    80005684:	0026d783          	lhu	a5,2(a3)
    80005688:	06f70163          	beq	a4,a5,800056ea <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000568c:	00016917          	auipc	s2,0x16
    80005690:	97490913          	addi	s2,s2,-1676 # 8001b000 <disk>
    80005694:	00018497          	auipc	s1,0x18
    80005698:	96c48493          	addi	s1,s1,-1684 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    8000569c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056a0:	6898                	ld	a4,16(s1)
    800056a2:	0204d783          	lhu	a5,32(s1)
    800056a6:	8b9d                	andi	a5,a5,7
    800056a8:	078e                	slli	a5,a5,0x3
    800056aa:	97ba                	add	a5,a5,a4
    800056ac:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056ae:	20078713          	addi	a4,a5,512
    800056b2:	0712                	slli	a4,a4,0x4
    800056b4:	974a                	add	a4,a4,s2
    800056b6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056ba:	e731                	bnez	a4,80005706 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056bc:	20078793          	addi	a5,a5,512
    800056c0:	0792                	slli	a5,a5,0x4
    800056c2:	97ca                	add	a5,a5,s2
    800056c4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056c6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056ca:	ffffc097          	auipc	ra,0xffffc
    800056ce:	ffc080e7          	jalr	-4(ra) # 800016c6 <wakeup>

    disk.used_idx += 1;
    800056d2:	0204d783          	lhu	a5,32(s1)
    800056d6:	2785                	addiw	a5,a5,1
    800056d8:	17c2                	slli	a5,a5,0x30
    800056da:	93c1                	srli	a5,a5,0x30
    800056dc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800056e0:	6898                	ld	a4,16(s1)
    800056e2:	00275703          	lhu	a4,2(a4)
    800056e6:	faf71be3          	bne	a4,a5,8000569c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800056ea:	00018517          	auipc	a0,0x18
    800056ee:	a3e50513          	addi	a0,a0,-1474 # 8001d128 <disk+0x2128>
    800056f2:	00001097          	auipc	ra,0x1
    800056f6:	ba8080e7          	jalr	-1112(ra) # 8000629a <release>
}
    800056fa:	60e2                	ld	ra,24(sp)
    800056fc:	6442                	ld	s0,16(sp)
    800056fe:	64a2                	ld	s1,8(sp)
    80005700:	6902                	ld	s2,0(sp)
    80005702:	6105                	addi	sp,sp,32
    80005704:	8082                	ret
      panic("virtio_disk_intr status");
    80005706:	00003517          	auipc	a0,0x3
    8000570a:	08250513          	addi	a0,a0,130 # 80008788 <syscalls+0x3c0>
    8000570e:	00000097          	auipc	ra,0x0
    80005712:	5b8080e7          	jalr	1464(ra) # 80005cc6 <panic>

0000000080005716 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005716:	1141                	addi	sp,sp,-16
    80005718:	e422                	sd	s0,8(sp)
    8000571a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000571c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005720:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005724:	0037979b          	slliw	a5,a5,0x3
    80005728:	02004737          	lui	a4,0x2004
    8000572c:	97ba                	add	a5,a5,a4
    8000572e:	0200c737          	lui	a4,0x200c
    80005732:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005736:	000f4637          	lui	a2,0xf4
    8000573a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000573e:	95b2                	add	a1,a1,a2
    80005740:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005742:	00269713          	slli	a4,a3,0x2
    80005746:	9736                	add	a4,a4,a3
    80005748:	00371693          	slli	a3,a4,0x3
    8000574c:	00019717          	auipc	a4,0x19
    80005750:	8b470713          	addi	a4,a4,-1868 # 8001e000 <timer_scratch>
    80005754:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005756:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005758:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000575a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000575e:	00000797          	auipc	a5,0x0
    80005762:	97278793          	addi	a5,a5,-1678 # 800050d0 <timervec>
    80005766:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000576a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000576e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005772:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005776:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000577a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000577e:	30479073          	csrw	mie,a5
}
    80005782:	6422                	ld	s0,8(sp)
    80005784:	0141                	addi	sp,sp,16
    80005786:	8082                	ret

0000000080005788 <start>:
{
    80005788:	1141                	addi	sp,sp,-16
    8000578a:	e406                	sd	ra,8(sp)
    8000578c:	e022                	sd	s0,0(sp)
    8000578e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005790:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005794:	7779                	lui	a4,0xffffe
    80005796:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    8000579a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000579c:	6705                	lui	a4,0x1
    8000579e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057a2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057a4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057a8:	ffffb797          	auipc	a5,0xffffb
    800057ac:	b7e78793          	addi	a5,a5,-1154 # 80000326 <main>
    800057b0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057b4:	4781                	li	a5,0
    800057b6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057ba:	67c1                	lui	a5,0x10
    800057bc:	17fd                	addi	a5,a5,-1
    800057be:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057c2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057c6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057ca:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057ce:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057d2:	57fd                	li	a5,-1
    800057d4:	83a9                	srli	a5,a5,0xa
    800057d6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057da:	47bd                	li	a5,15
    800057dc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800057e0:	00000097          	auipc	ra,0x0
    800057e4:	f36080e7          	jalr	-202(ra) # 80005716 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057e8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800057ec:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800057ee:	823e                	mv	tp,a5
  asm volatile("mret");
    800057f0:	30200073          	mret
}
    800057f4:	60a2                	ld	ra,8(sp)
    800057f6:	6402                	ld	s0,0(sp)
    800057f8:	0141                	addi	sp,sp,16
    800057fa:	8082                	ret

00000000800057fc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800057fc:	715d                	addi	sp,sp,-80
    800057fe:	e486                	sd	ra,72(sp)
    80005800:	e0a2                	sd	s0,64(sp)
    80005802:	fc26                	sd	s1,56(sp)
    80005804:	f84a                	sd	s2,48(sp)
    80005806:	f44e                	sd	s3,40(sp)
    80005808:	f052                	sd	s4,32(sp)
    8000580a:	ec56                	sd	s5,24(sp)
    8000580c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000580e:	04c05663          	blez	a2,8000585a <consolewrite+0x5e>
    80005812:	8a2a                	mv	s4,a0
    80005814:	84ae                	mv	s1,a1
    80005816:	89b2                	mv	s3,a2
    80005818:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000581a:	5afd                	li	s5,-1
    8000581c:	4685                	li	a3,1
    8000581e:	8626                	mv	a2,s1
    80005820:	85d2                	mv	a1,s4
    80005822:	fbf40513          	addi	a0,s0,-65
    80005826:	ffffc097          	auipc	ra,0xffffc
    8000582a:	10e080e7          	jalr	270(ra) # 80001934 <either_copyin>
    8000582e:	01550c63          	beq	a0,s5,80005846 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005832:	fbf44503          	lbu	a0,-65(s0)
    80005836:	00000097          	auipc	ra,0x0
    8000583a:	7f2080e7          	jalr	2034(ra) # 80006028 <uartputc>
  for(i = 0; i < n; i++){
    8000583e:	2905                	addiw	s2,s2,1
    80005840:	0485                	addi	s1,s1,1
    80005842:	fd299de3          	bne	s3,s2,8000581c <consolewrite+0x20>
  }

  return i;
}
    80005846:	854a                	mv	a0,s2
    80005848:	60a6                	ld	ra,72(sp)
    8000584a:	6406                	ld	s0,64(sp)
    8000584c:	74e2                	ld	s1,56(sp)
    8000584e:	7942                	ld	s2,48(sp)
    80005850:	79a2                	ld	s3,40(sp)
    80005852:	7a02                	ld	s4,32(sp)
    80005854:	6ae2                	ld	s5,24(sp)
    80005856:	6161                	addi	sp,sp,80
    80005858:	8082                	ret
  for(i = 0; i < n; i++){
    8000585a:	4901                	li	s2,0
    8000585c:	b7ed                	j	80005846 <consolewrite+0x4a>

000000008000585e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000585e:	7119                	addi	sp,sp,-128
    80005860:	fc86                	sd	ra,120(sp)
    80005862:	f8a2                	sd	s0,112(sp)
    80005864:	f4a6                	sd	s1,104(sp)
    80005866:	f0ca                	sd	s2,96(sp)
    80005868:	ecce                	sd	s3,88(sp)
    8000586a:	e8d2                	sd	s4,80(sp)
    8000586c:	e4d6                	sd	s5,72(sp)
    8000586e:	e0da                	sd	s6,64(sp)
    80005870:	fc5e                	sd	s7,56(sp)
    80005872:	f862                	sd	s8,48(sp)
    80005874:	f466                	sd	s9,40(sp)
    80005876:	f06a                	sd	s10,32(sp)
    80005878:	ec6e                	sd	s11,24(sp)
    8000587a:	0100                	addi	s0,sp,128
    8000587c:	8b2a                	mv	s6,a0
    8000587e:	8aae                	mv	s5,a1
    80005880:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005882:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005886:	00021517          	auipc	a0,0x21
    8000588a:	8ba50513          	addi	a0,a0,-1862 # 80026140 <cons>
    8000588e:	00001097          	auipc	ra,0x1
    80005892:	958080e7          	jalr	-1704(ra) # 800061e6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005896:	00021497          	auipc	s1,0x21
    8000589a:	8aa48493          	addi	s1,s1,-1878 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000589e:	89a6                	mv	s3,s1
    800058a0:	00021917          	auipc	s2,0x21
    800058a4:	93890913          	addi	s2,s2,-1736 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058a8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058aa:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058ac:	4da9                	li	s11,10
  while(n > 0){
    800058ae:	07405863          	blez	s4,8000591e <consoleread+0xc0>
    while(cons.r == cons.w){
    800058b2:	0984a783          	lw	a5,152(s1)
    800058b6:	09c4a703          	lw	a4,156(s1)
    800058ba:	02f71463          	bne	a4,a5,800058e2 <consoleread+0x84>
      if(myproc()->killed){
    800058be:	ffffb097          	auipc	ra,0xffffb
    800058c2:	58a080e7          	jalr	1418(ra) # 80000e48 <myproc>
    800058c6:	551c                	lw	a5,40(a0)
    800058c8:	e7b5                	bnez	a5,80005934 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800058ca:	85ce                	mv	a1,s3
    800058cc:	854a                	mv	a0,s2
    800058ce:	ffffc097          	auipc	ra,0xffffc
    800058d2:	c6c080e7          	jalr	-916(ra) # 8000153a <sleep>
    while(cons.r == cons.w){
    800058d6:	0984a783          	lw	a5,152(s1)
    800058da:	09c4a703          	lw	a4,156(s1)
    800058de:	fef700e3          	beq	a4,a5,800058be <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800058e2:	0017871b          	addiw	a4,a5,1
    800058e6:	08e4ac23          	sw	a4,152(s1)
    800058ea:	07f7f713          	andi	a4,a5,127
    800058ee:	9726                	add	a4,a4,s1
    800058f0:	01874703          	lbu	a4,24(a4)
    800058f4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800058f8:	079c0663          	beq	s8,s9,80005964 <consoleread+0x106>
    cbuf = c;
    800058fc:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005900:	4685                	li	a3,1
    80005902:	f8f40613          	addi	a2,s0,-113
    80005906:	85d6                	mv	a1,s5
    80005908:	855a                	mv	a0,s6
    8000590a:	ffffc097          	auipc	ra,0xffffc
    8000590e:	fd4080e7          	jalr	-44(ra) # 800018de <either_copyout>
    80005912:	01a50663          	beq	a0,s10,8000591e <consoleread+0xc0>
    dst++;
    80005916:	0a85                	addi	s5,s5,1
    --n;
    80005918:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000591a:	f9bc1ae3          	bne	s8,s11,800058ae <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000591e:	00021517          	auipc	a0,0x21
    80005922:	82250513          	addi	a0,a0,-2014 # 80026140 <cons>
    80005926:	00001097          	auipc	ra,0x1
    8000592a:	974080e7          	jalr	-1676(ra) # 8000629a <release>

  return target - n;
    8000592e:	414b853b          	subw	a0,s7,s4
    80005932:	a811                	j	80005946 <consoleread+0xe8>
        release(&cons.lock);
    80005934:	00021517          	auipc	a0,0x21
    80005938:	80c50513          	addi	a0,a0,-2036 # 80026140 <cons>
    8000593c:	00001097          	auipc	ra,0x1
    80005940:	95e080e7          	jalr	-1698(ra) # 8000629a <release>
        return -1;
    80005944:	557d                	li	a0,-1
}
    80005946:	70e6                	ld	ra,120(sp)
    80005948:	7446                	ld	s0,112(sp)
    8000594a:	74a6                	ld	s1,104(sp)
    8000594c:	7906                	ld	s2,96(sp)
    8000594e:	69e6                	ld	s3,88(sp)
    80005950:	6a46                	ld	s4,80(sp)
    80005952:	6aa6                	ld	s5,72(sp)
    80005954:	6b06                	ld	s6,64(sp)
    80005956:	7be2                	ld	s7,56(sp)
    80005958:	7c42                	ld	s8,48(sp)
    8000595a:	7ca2                	ld	s9,40(sp)
    8000595c:	7d02                	ld	s10,32(sp)
    8000595e:	6de2                	ld	s11,24(sp)
    80005960:	6109                	addi	sp,sp,128
    80005962:	8082                	ret
      if(n < target){
    80005964:	000a071b          	sext.w	a4,s4
    80005968:	fb777be3          	bgeu	a4,s7,8000591e <consoleread+0xc0>
        cons.r--;
    8000596c:	00021717          	auipc	a4,0x21
    80005970:	86f72623          	sw	a5,-1940(a4) # 800261d8 <cons+0x98>
    80005974:	b76d                	j	8000591e <consoleread+0xc0>

0000000080005976 <consputc>:
{
    80005976:	1141                	addi	sp,sp,-16
    80005978:	e406                	sd	ra,8(sp)
    8000597a:	e022                	sd	s0,0(sp)
    8000597c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000597e:	10000793          	li	a5,256
    80005982:	00f50a63          	beq	a0,a5,80005996 <consputc+0x20>
    uartputc_sync(c);
    80005986:	00000097          	auipc	ra,0x0
    8000598a:	5c8080e7          	jalr	1480(ra) # 80005f4e <uartputc_sync>
}
    8000598e:	60a2                	ld	ra,8(sp)
    80005990:	6402                	ld	s0,0(sp)
    80005992:	0141                	addi	sp,sp,16
    80005994:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005996:	4521                	li	a0,8
    80005998:	00000097          	auipc	ra,0x0
    8000599c:	5b6080e7          	jalr	1462(ra) # 80005f4e <uartputc_sync>
    800059a0:	02000513          	li	a0,32
    800059a4:	00000097          	auipc	ra,0x0
    800059a8:	5aa080e7          	jalr	1450(ra) # 80005f4e <uartputc_sync>
    800059ac:	4521                	li	a0,8
    800059ae:	00000097          	auipc	ra,0x0
    800059b2:	5a0080e7          	jalr	1440(ra) # 80005f4e <uartputc_sync>
    800059b6:	bfe1                	j	8000598e <consputc+0x18>

00000000800059b8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059b8:	1101                	addi	sp,sp,-32
    800059ba:	ec06                	sd	ra,24(sp)
    800059bc:	e822                	sd	s0,16(sp)
    800059be:	e426                	sd	s1,8(sp)
    800059c0:	e04a                	sd	s2,0(sp)
    800059c2:	1000                	addi	s0,sp,32
    800059c4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059c6:	00020517          	auipc	a0,0x20
    800059ca:	77a50513          	addi	a0,a0,1914 # 80026140 <cons>
    800059ce:	00001097          	auipc	ra,0x1
    800059d2:	818080e7          	jalr	-2024(ra) # 800061e6 <acquire>

  switch(c){
    800059d6:	47d5                	li	a5,21
    800059d8:	0af48663          	beq	s1,a5,80005a84 <consoleintr+0xcc>
    800059dc:	0297ca63          	blt	a5,s1,80005a10 <consoleintr+0x58>
    800059e0:	47a1                	li	a5,8
    800059e2:	0ef48763          	beq	s1,a5,80005ad0 <consoleintr+0x118>
    800059e6:	47c1                	li	a5,16
    800059e8:	10f49a63          	bne	s1,a5,80005afc <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800059ec:	ffffc097          	auipc	ra,0xffffc
    800059f0:	f9e080e7          	jalr	-98(ra) # 8000198a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800059f4:	00020517          	auipc	a0,0x20
    800059f8:	74c50513          	addi	a0,a0,1868 # 80026140 <cons>
    800059fc:	00001097          	auipc	ra,0x1
    80005a00:	89e080e7          	jalr	-1890(ra) # 8000629a <release>
}
    80005a04:	60e2                	ld	ra,24(sp)
    80005a06:	6442                	ld	s0,16(sp)
    80005a08:	64a2                	ld	s1,8(sp)
    80005a0a:	6902                	ld	s2,0(sp)
    80005a0c:	6105                	addi	sp,sp,32
    80005a0e:	8082                	ret
  switch(c){
    80005a10:	07f00793          	li	a5,127
    80005a14:	0af48e63          	beq	s1,a5,80005ad0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a18:	00020717          	auipc	a4,0x20
    80005a1c:	72870713          	addi	a4,a4,1832 # 80026140 <cons>
    80005a20:	0a072783          	lw	a5,160(a4)
    80005a24:	09872703          	lw	a4,152(a4)
    80005a28:	9f99                	subw	a5,a5,a4
    80005a2a:	07f00713          	li	a4,127
    80005a2e:	fcf763e3          	bltu	a4,a5,800059f4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a32:	47b5                	li	a5,13
    80005a34:	0cf48763          	beq	s1,a5,80005b02 <consoleintr+0x14a>
      consputc(c);
    80005a38:	8526                	mv	a0,s1
    80005a3a:	00000097          	auipc	ra,0x0
    80005a3e:	f3c080e7          	jalr	-196(ra) # 80005976 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a42:	00020797          	auipc	a5,0x20
    80005a46:	6fe78793          	addi	a5,a5,1790 # 80026140 <cons>
    80005a4a:	0a07a703          	lw	a4,160(a5)
    80005a4e:	0017069b          	addiw	a3,a4,1
    80005a52:	0006861b          	sext.w	a2,a3
    80005a56:	0ad7a023          	sw	a3,160(a5)
    80005a5a:	07f77713          	andi	a4,a4,127
    80005a5e:	97ba                	add	a5,a5,a4
    80005a60:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a64:	47a9                	li	a5,10
    80005a66:	0cf48563          	beq	s1,a5,80005b30 <consoleintr+0x178>
    80005a6a:	4791                	li	a5,4
    80005a6c:	0cf48263          	beq	s1,a5,80005b30 <consoleintr+0x178>
    80005a70:	00020797          	auipc	a5,0x20
    80005a74:	7687a783          	lw	a5,1896(a5) # 800261d8 <cons+0x98>
    80005a78:	0807879b          	addiw	a5,a5,128
    80005a7c:	f6f61ce3          	bne	a2,a5,800059f4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a80:	863e                	mv	a2,a5
    80005a82:	a07d                	j	80005b30 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005a84:	00020717          	auipc	a4,0x20
    80005a88:	6bc70713          	addi	a4,a4,1724 # 80026140 <cons>
    80005a8c:	0a072783          	lw	a5,160(a4)
    80005a90:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005a94:	00020497          	auipc	s1,0x20
    80005a98:	6ac48493          	addi	s1,s1,1708 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005a9c:	4929                	li	s2,10
    80005a9e:	f4f70be3          	beq	a4,a5,800059f4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005aa2:	37fd                	addiw	a5,a5,-1
    80005aa4:	07f7f713          	andi	a4,a5,127
    80005aa8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005aaa:	01874703          	lbu	a4,24(a4)
    80005aae:	f52703e3          	beq	a4,s2,800059f4 <consoleintr+0x3c>
      cons.e--;
    80005ab2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ab6:	10000513          	li	a0,256
    80005aba:	00000097          	auipc	ra,0x0
    80005abe:	ebc080e7          	jalr	-324(ra) # 80005976 <consputc>
    while(cons.e != cons.w &&
    80005ac2:	0a04a783          	lw	a5,160(s1)
    80005ac6:	09c4a703          	lw	a4,156(s1)
    80005aca:	fcf71ce3          	bne	a4,a5,80005aa2 <consoleintr+0xea>
    80005ace:	b71d                	j	800059f4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005ad0:	00020717          	auipc	a4,0x20
    80005ad4:	67070713          	addi	a4,a4,1648 # 80026140 <cons>
    80005ad8:	0a072783          	lw	a5,160(a4)
    80005adc:	09c72703          	lw	a4,156(a4)
    80005ae0:	f0f70ae3          	beq	a4,a5,800059f4 <consoleintr+0x3c>
      cons.e--;
    80005ae4:	37fd                	addiw	a5,a5,-1
    80005ae6:	00020717          	auipc	a4,0x20
    80005aea:	6ef72d23          	sw	a5,1786(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005aee:	10000513          	li	a0,256
    80005af2:	00000097          	auipc	ra,0x0
    80005af6:	e84080e7          	jalr	-380(ra) # 80005976 <consputc>
    80005afa:	bded                	j	800059f4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005afc:	ee048ce3          	beqz	s1,800059f4 <consoleintr+0x3c>
    80005b00:	bf21                	j	80005a18 <consoleintr+0x60>
      consputc(c);
    80005b02:	4529                	li	a0,10
    80005b04:	00000097          	auipc	ra,0x0
    80005b08:	e72080e7          	jalr	-398(ra) # 80005976 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b0c:	00020797          	auipc	a5,0x20
    80005b10:	63478793          	addi	a5,a5,1588 # 80026140 <cons>
    80005b14:	0a07a703          	lw	a4,160(a5)
    80005b18:	0017069b          	addiw	a3,a4,1
    80005b1c:	0006861b          	sext.w	a2,a3
    80005b20:	0ad7a023          	sw	a3,160(a5)
    80005b24:	07f77713          	andi	a4,a4,127
    80005b28:	97ba                	add	a5,a5,a4
    80005b2a:	4729                	li	a4,10
    80005b2c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b30:	00020797          	auipc	a5,0x20
    80005b34:	6ac7a623          	sw	a2,1708(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b38:	00020517          	auipc	a0,0x20
    80005b3c:	6a050513          	addi	a0,a0,1696 # 800261d8 <cons+0x98>
    80005b40:	ffffc097          	auipc	ra,0xffffc
    80005b44:	b86080e7          	jalr	-1146(ra) # 800016c6 <wakeup>
    80005b48:	b575                	j	800059f4 <consoleintr+0x3c>

0000000080005b4a <consoleinit>:

void
consoleinit(void)
{
    80005b4a:	1141                	addi	sp,sp,-16
    80005b4c:	e406                	sd	ra,8(sp)
    80005b4e:	e022                	sd	s0,0(sp)
    80005b50:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b52:	00003597          	auipc	a1,0x3
    80005b56:	c4e58593          	addi	a1,a1,-946 # 800087a0 <syscalls+0x3d8>
    80005b5a:	00020517          	auipc	a0,0x20
    80005b5e:	5e650513          	addi	a0,a0,1510 # 80026140 <cons>
    80005b62:	00000097          	auipc	ra,0x0
    80005b66:	5f4080e7          	jalr	1524(ra) # 80006156 <initlock>

  uartinit();
    80005b6a:	00000097          	auipc	ra,0x0
    80005b6e:	394080e7          	jalr	916(ra) # 80005efe <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b72:	00014797          	auipc	a5,0x14
    80005b76:	d5678793          	addi	a5,a5,-682 # 800198c8 <devsw>
    80005b7a:	00000717          	auipc	a4,0x0
    80005b7e:	ce470713          	addi	a4,a4,-796 # 8000585e <consoleread>
    80005b82:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005b84:	00000717          	auipc	a4,0x0
    80005b88:	c7870713          	addi	a4,a4,-904 # 800057fc <consolewrite>
    80005b8c:	ef98                	sd	a4,24(a5)
}
    80005b8e:	60a2                	ld	ra,8(sp)
    80005b90:	6402                	ld	s0,0(sp)
    80005b92:	0141                	addi	sp,sp,16
    80005b94:	8082                	ret

0000000080005b96 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005b96:	7179                	addi	sp,sp,-48
    80005b98:	f406                	sd	ra,40(sp)
    80005b9a:	f022                	sd	s0,32(sp)
    80005b9c:	ec26                	sd	s1,24(sp)
    80005b9e:	e84a                	sd	s2,16(sp)
    80005ba0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ba2:	c219                	beqz	a2,80005ba8 <printint+0x12>
    80005ba4:	08054663          	bltz	a0,80005c30 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005ba8:	2501                	sext.w	a0,a0
    80005baa:	4881                	li	a7,0
    80005bac:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bb0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bb2:	2581                	sext.w	a1,a1
    80005bb4:	00003617          	auipc	a2,0x3
    80005bb8:	c2460613          	addi	a2,a2,-988 # 800087d8 <digits>
    80005bbc:	883a                	mv	a6,a4
    80005bbe:	2705                	addiw	a4,a4,1
    80005bc0:	02b577bb          	remuw	a5,a0,a1
    80005bc4:	1782                	slli	a5,a5,0x20
    80005bc6:	9381                	srli	a5,a5,0x20
    80005bc8:	97b2                	add	a5,a5,a2
    80005bca:	0007c783          	lbu	a5,0(a5)
    80005bce:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bd2:	0005079b          	sext.w	a5,a0
    80005bd6:	02b5553b          	divuw	a0,a0,a1
    80005bda:	0685                	addi	a3,a3,1
    80005bdc:	feb7f0e3          	bgeu	a5,a1,80005bbc <printint+0x26>

  if(sign)
    80005be0:	00088b63          	beqz	a7,80005bf6 <printint+0x60>
    buf[i++] = '-';
    80005be4:	fe040793          	addi	a5,s0,-32
    80005be8:	973e                	add	a4,a4,a5
    80005bea:	02d00793          	li	a5,45
    80005bee:	fef70823          	sb	a5,-16(a4)
    80005bf2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005bf6:	02e05763          	blez	a4,80005c24 <printint+0x8e>
    80005bfa:	fd040793          	addi	a5,s0,-48
    80005bfe:	00e784b3          	add	s1,a5,a4
    80005c02:	fff78913          	addi	s2,a5,-1
    80005c06:	993a                	add	s2,s2,a4
    80005c08:	377d                	addiw	a4,a4,-1
    80005c0a:	1702                	slli	a4,a4,0x20
    80005c0c:	9301                	srli	a4,a4,0x20
    80005c0e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c12:	fff4c503          	lbu	a0,-1(s1)
    80005c16:	00000097          	auipc	ra,0x0
    80005c1a:	d60080e7          	jalr	-672(ra) # 80005976 <consputc>
  while(--i >= 0)
    80005c1e:	14fd                	addi	s1,s1,-1
    80005c20:	ff2499e3          	bne	s1,s2,80005c12 <printint+0x7c>
}
    80005c24:	70a2                	ld	ra,40(sp)
    80005c26:	7402                	ld	s0,32(sp)
    80005c28:	64e2                	ld	s1,24(sp)
    80005c2a:	6942                	ld	s2,16(sp)
    80005c2c:	6145                	addi	sp,sp,48
    80005c2e:	8082                	ret
    x = -xx;
    80005c30:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c34:	4885                	li	a7,1
    x = -xx;
    80005c36:	bf9d                	j	80005bac <printint+0x16>

0000000080005c38 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005c38:	1101                	addi	sp,sp,-32
    80005c3a:	ec06                	sd	ra,24(sp)
    80005c3c:	e822                	sd	s0,16(sp)
    80005c3e:	e426                	sd	s1,8(sp)
    80005c40:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005c42:	00020497          	auipc	s1,0x20
    80005c46:	5a648493          	addi	s1,s1,1446 # 800261e8 <pr>
    80005c4a:	00003597          	auipc	a1,0x3
    80005c4e:	b5e58593          	addi	a1,a1,-1186 # 800087a8 <syscalls+0x3e0>
    80005c52:	8526                	mv	a0,s1
    80005c54:	00000097          	auipc	ra,0x0
    80005c58:	502080e7          	jalr	1282(ra) # 80006156 <initlock>
  pr.locking = 1;
    80005c5c:	4785                	li	a5,1
    80005c5e:	cc9c                	sw	a5,24(s1)
}
    80005c60:	60e2                	ld	ra,24(sp)
    80005c62:	6442                	ld	s0,16(sp)
    80005c64:	64a2                	ld	s1,8(sp)
    80005c66:	6105                	addi	sp,sp,32
    80005c68:	8082                	ret

0000000080005c6a <backtrace>:

// print the return address - lab4-2
void backtrace() {
    80005c6a:	7179                	addi	sp,sp,-48
    80005c6c:	f406                	sd	ra,40(sp)
    80005c6e:	f022                	sd	s0,32(sp)
    80005c70:	ec26                	sd	s1,24(sp)
    80005c72:	e84a                	sd	s2,16(sp)
    80005c74:	e44e                	sd	s3,8(sp)
    80005c76:	e052                	sd	s4,0(sp)
    80005c78:	1800                	addi	s0,sp,48
}

// read the current frame pointer from s0 register - lab4-2
static inline uint64 r_fp() {
    uint64 x;
    asm volatile("mv %0, s0" : "=r" (x) );
    80005c7a:	84a2                	mv	s1,s0
    uint64 fp = r_fp();    // 获取当前栈帧
    uint64 top = PGROUNDUP(fp);    // 获取用户栈最高地址
    80005c7c:	6905                	lui	s2,0x1
    80005c7e:	197d                	addi	s2,s2,-1
    80005c80:	9926                	add	s2,s2,s1
    80005c82:	79fd                	lui	s3,0xfffff
    80005c84:	01397933          	and	s2,s2,s3
    uint64 bottom = PGROUNDDOWN(fp);    // 获取用户栈最低地址
    80005c88:	0134f9b3          	and	s3,s1,s3
    for (; 
    80005c8c:	0334e563          	bltu	s1,s3,80005cb6 <backtrace+0x4c>
        fp >= bottom && fp < top;     // 终止条件
    80005c90:	0324f363          	bgeu	s1,s2,80005cb6 <backtrace+0x4c>
        fp = *((uint64 *) (fp - 16))    // 获取下一栈帧
        ) {
        printf("%p\n", *((uint64 *) (fp - 8)));    // 输出当前栈中返回地址
    80005c94:	00003a17          	auipc	s4,0x3
    80005c98:	b1ca0a13          	addi	s4,s4,-1252 # 800087b0 <syscalls+0x3e8>
    80005c9c:	ff84b583          	ld	a1,-8(s1)
    80005ca0:	8552                	mv	a0,s4
    80005ca2:	00000097          	auipc	ra,0x0
    80005ca6:	076080e7          	jalr	118(ra) # 80005d18 <printf>
        fp = *((uint64 *) (fp - 16))    // 获取下一栈帧
    80005caa:	ff04b483          	ld	s1,-16(s1)
    for (; 
    80005cae:	0134e463          	bltu	s1,s3,80005cb6 <backtrace+0x4c>
        fp >= bottom && fp < top;     // 终止条件
    80005cb2:	ff24e5e3          	bltu	s1,s2,80005c9c <backtrace+0x32>
    }
}
    80005cb6:	70a2                	ld	ra,40(sp)
    80005cb8:	7402                	ld	s0,32(sp)
    80005cba:	64e2                	ld	s1,24(sp)
    80005cbc:	6942                	ld	s2,16(sp)
    80005cbe:	69a2                	ld	s3,8(sp)
    80005cc0:	6a02                	ld	s4,0(sp)
    80005cc2:	6145                	addi	sp,sp,48
    80005cc4:	8082                	ret

0000000080005cc6 <panic>:
{
    80005cc6:	1101                	addi	sp,sp,-32
    80005cc8:	ec06                	sd	ra,24(sp)
    80005cca:	e822                	sd	s0,16(sp)
    80005ccc:	e426                	sd	s1,8(sp)
    80005cce:	1000                	addi	s0,sp,32
    80005cd0:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cd2:	00020797          	auipc	a5,0x20
    80005cd6:	5207a723          	sw	zero,1326(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cda:	00003517          	auipc	a0,0x3
    80005cde:	ade50513          	addi	a0,a0,-1314 # 800087b8 <syscalls+0x3f0>
    80005ce2:	00000097          	auipc	ra,0x0
    80005ce6:	036080e7          	jalr	54(ra) # 80005d18 <printf>
  printf(s);
    80005cea:	8526                	mv	a0,s1
    80005cec:	00000097          	auipc	ra,0x0
    80005cf0:	02c080e7          	jalr	44(ra) # 80005d18 <printf>
  printf("\n");
    80005cf4:	00002517          	auipc	a0,0x2
    80005cf8:	35450513          	addi	a0,a0,852 # 80008048 <etext+0x48>
    80005cfc:	00000097          	auipc	ra,0x0
    80005d00:	01c080e7          	jalr	28(ra) # 80005d18 <printf>
  backtrace();
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	f66080e7          	jalr	-154(ra) # 80005c6a <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005d0c:	4785                	li	a5,1
    80005d0e:	00003717          	auipc	a4,0x3
    80005d12:	30f72723          	sw	a5,782(a4) # 8000901c <panicked>
  for(;;)
    80005d16:	a001                	j	80005d16 <panic+0x50>

0000000080005d18 <printf>:
{
    80005d18:	7131                	addi	sp,sp,-192
    80005d1a:	fc86                	sd	ra,120(sp)
    80005d1c:	f8a2                	sd	s0,112(sp)
    80005d1e:	f4a6                	sd	s1,104(sp)
    80005d20:	f0ca                	sd	s2,96(sp)
    80005d22:	ecce                	sd	s3,88(sp)
    80005d24:	e8d2                	sd	s4,80(sp)
    80005d26:	e4d6                	sd	s5,72(sp)
    80005d28:	e0da                	sd	s6,64(sp)
    80005d2a:	fc5e                	sd	s7,56(sp)
    80005d2c:	f862                	sd	s8,48(sp)
    80005d2e:	f466                	sd	s9,40(sp)
    80005d30:	f06a                	sd	s10,32(sp)
    80005d32:	ec6e                	sd	s11,24(sp)
    80005d34:	0100                	addi	s0,sp,128
    80005d36:	8a2a                	mv	s4,a0
    80005d38:	e40c                	sd	a1,8(s0)
    80005d3a:	e810                	sd	a2,16(s0)
    80005d3c:	ec14                	sd	a3,24(s0)
    80005d3e:	f018                	sd	a4,32(s0)
    80005d40:	f41c                	sd	a5,40(s0)
    80005d42:	03043823          	sd	a6,48(s0)
    80005d46:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d4a:	00020d97          	auipc	s11,0x20
    80005d4e:	4b6dad83          	lw	s11,1206(s11) # 80026200 <pr+0x18>
  if(locking)
    80005d52:	020d9b63          	bnez	s11,80005d88 <printf+0x70>
  if (fmt == 0)
    80005d56:	040a0263          	beqz	s4,80005d9a <printf+0x82>
  va_start(ap, fmt);
    80005d5a:	00840793          	addi	a5,s0,8
    80005d5e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d62:	000a4503          	lbu	a0,0(s4)
    80005d66:	16050263          	beqz	a0,80005eca <printf+0x1b2>
    80005d6a:	4481                	li	s1,0
    if(c != '%'){
    80005d6c:	02500a93          	li	s5,37
    switch(c){
    80005d70:	07000b13          	li	s6,112
  consputc('x');
    80005d74:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d76:	00003b97          	auipc	s7,0x3
    80005d7a:	a62b8b93          	addi	s7,s7,-1438 # 800087d8 <digits>
    switch(c){
    80005d7e:	07300c93          	li	s9,115
    80005d82:	06400c13          	li	s8,100
    80005d86:	a82d                	j	80005dc0 <printf+0xa8>
    acquire(&pr.lock);
    80005d88:	00020517          	auipc	a0,0x20
    80005d8c:	46050513          	addi	a0,a0,1120 # 800261e8 <pr>
    80005d90:	00000097          	auipc	ra,0x0
    80005d94:	456080e7          	jalr	1110(ra) # 800061e6 <acquire>
    80005d98:	bf7d                	j	80005d56 <printf+0x3e>
    panic("null fmt");
    80005d9a:	00003517          	auipc	a0,0x3
    80005d9e:	a2e50513          	addi	a0,a0,-1490 # 800087c8 <syscalls+0x400>
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	f24080e7          	jalr	-220(ra) # 80005cc6 <panic>
      consputc(c);
    80005daa:	00000097          	auipc	ra,0x0
    80005dae:	bcc080e7          	jalr	-1076(ra) # 80005976 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005db2:	2485                	addiw	s1,s1,1
    80005db4:	009a07b3          	add	a5,s4,s1
    80005db8:	0007c503          	lbu	a0,0(a5)
    80005dbc:	10050763          	beqz	a0,80005eca <printf+0x1b2>
    if(c != '%'){
    80005dc0:	ff5515e3          	bne	a0,s5,80005daa <printf+0x92>
    c = fmt[++i] & 0xff;
    80005dc4:	2485                	addiw	s1,s1,1
    80005dc6:	009a07b3          	add	a5,s4,s1
    80005dca:	0007c783          	lbu	a5,0(a5)
    80005dce:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005dd2:	cfe5                	beqz	a5,80005eca <printf+0x1b2>
    switch(c){
    80005dd4:	05678a63          	beq	a5,s6,80005e28 <printf+0x110>
    80005dd8:	02fb7663          	bgeu	s6,a5,80005e04 <printf+0xec>
    80005ddc:	09978963          	beq	a5,s9,80005e6e <printf+0x156>
    80005de0:	07800713          	li	a4,120
    80005de4:	0ce79863          	bne	a5,a4,80005eb4 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005de8:	f8843783          	ld	a5,-120(s0)
    80005dec:	00878713          	addi	a4,a5,8
    80005df0:	f8e43423          	sd	a4,-120(s0)
    80005df4:	4605                	li	a2,1
    80005df6:	85ea                	mv	a1,s10
    80005df8:	4388                	lw	a0,0(a5)
    80005dfa:	00000097          	auipc	ra,0x0
    80005dfe:	d9c080e7          	jalr	-612(ra) # 80005b96 <printint>
      break;
    80005e02:	bf45                	j	80005db2 <printf+0x9a>
    switch(c){
    80005e04:	0b578263          	beq	a5,s5,80005ea8 <printf+0x190>
    80005e08:	0b879663          	bne	a5,s8,80005eb4 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e0c:	f8843783          	ld	a5,-120(s0)
    80005e10:	00878713          	addi	a4,a5,8
    80005e14:	f8e43423          	sd	a4,-120(s0)
    80005e18:	4605                	li	a2,1
    80005e1a:	45a9                	li	a1,10
    80005e1c:	4388                	lw	a0,0(a5)
    80005e1e:	00000097          	auipc	ra,0x0
    80005e22:	d78080e7          	jalr	-648(ra) # 80005b96 <printint>
      break;
    80005e26:	b771                	j	80005db2 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e28:	f8843783          	ld	a5,-120(s0)
    80005e2c:	00878713          	addi	a4,a5,8
    80005e30:	f8e43423          	sd	a4,-120(s0)
    80005e34:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e38:	03000513          	li	a0,48
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	b3a080e7          	jalr	-1222(ra) # 80005976 <consputc>
  consputc('x');
    80005e44:	07800513          	li	a0,120
    80005e48:	00000097          	auipc	ra,0x0
    80005e4c:	b2e080e7          	jalr	-1234(ra) # 80005976 <consputc>
    80005e50:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e52:	03c9d793          	srli	a5,s3,0x3c
    80005e56:	97de                	add	a5,a5,s7
    80005e58:	0007c503          	lbu	a0,0(a5)
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	b1a080e7          	jalr	-1254(ra) # 80005976 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e64:	0992                	slli	s3,s3,0x4
    80005e66:	397d                	addiw	s2,s2,-1
    80005e68:	fe0915e3          	bnez	s2,80005e52 <printf+0x13a>
    80005e6c:	b799                	j	80005db2 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e6e:	f8843783          	ld	a5,-120(s0)
    80005e72:	00878713          	addi	a4,a5,8
    80005e76:	f8e43423          	sd	a4,-120(s0)
    80005e7a:	0007b903          	ld	s2,0(a5)
    80005e7e:	00090e63          	beqz	s2,80005e9a <printf+0x182>
      for(; *s; s++)
    80005e82:	00094503          	lbu	a0,0(s2) # 1000 <_entry-0x7ffff000>
    80005e86:	d515                	beqz	a0,80005db2 <printf+0x9a>
        consputc(*s);
    80005e88:	00000097          	auipc	ra,0x0
    80005e8c:	aee080e7          	jalr	-1298(ra) # 80005976 <consputc>
      for(; *s; s++)
    80005e90:	0905                	addi	s2,s2,1
    80005e92:	00094503          	lbu	a0,0(s2)
    80005e96:	f96d                	bnez	a0,80005e88 <printf+0x170>
    80005e98:	bf29                	j	80005db2 <printf+0x9a>
        s = "(null)";
    80005e9a:	00003917          	auipc	s2,0x3
    80005e9e:	92690913          	addi	s2,s2,-1754 # 800087c0 <syscalls+0x3f8>
      for(; *s; s++)
    80005ea2:	02800513          	li	a0,40
    80005ea6:	b7cd                	j	80005e88 <printf+0x170>
      consputc('%');
    80005ea8:	8556                	mv	a0,s5
    80005eaa:	00000097          	auipc	ra,0x0
    80005eae:	acc080e7          	jalr	-1332(ra) # 80005976 <consputc>
      break;
    80005eb2:	b701                	j	80005db2 <printf+0x9a>
      consputc('%');
    80005eb4:	8556                	mv	a0,s5
    80005eb6:	00000097          	auipc	ra,0x0
    80005eba:	ac0080e7          	jalr	-1344(ra) # 80005976 <consputc>
      consputc(c);
    80005ebe:	854a                	mv	a0,s2
    80005ec0:	00000097          	auipc	ra,0x0
    80005ec4:	ab6080e7          	jalr	-1354(ra) # 80005976 <consputc>
      break;
    80005ec8:	b5ed                	j	80005db2 <printf+0x9a>
  if(locking)
    80005eca:	020d9163          	bnez	s11,80005eec <printf+0x1d4>
}
    80005ece:	70e6                	ld	ra,120(sp)
    80005ed0:	7446                	ld	s0,112(sp)
    80005ed2:	74a6                	ld	s1,104(sp)
    80005ed4:	7906                	ld	s2,96(sp)
    80005ed6:	69e6                	ld	s3,88(sp)
    80005ed8:	6a46                	ld	s4,80(sp)
    80005eda:	6aa6                	ld	s5,72(sp)
    80005edc:	6b06                	ld	s6,64(sp)
    80005ede:	7be2                	ld	s7,56(sp)
    80005ee0:	7c42                	ld	s8,48(sp)
    80005ee2:	7ca2                	ld	s9,40(sp)
    80005ee4:	7d02                	ld	s10,32(sp)
    80005ee6:	6de2                	ld	s11,24(sp)
    80005ee8:	6129                	addi	sp,sp,192
    80005eea:	8082                	ret
    release(&pr.lock);
    80005eec:	00020517          	auipc	a0,0x20
    80005ef0:	2fc50513          	addi	a0,a0,764 # 800261e8 <pr>
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	3a6080e7          	jalr	934(ra) # 8000629a <release>
}
    80005efc:	bfc9                	j	80005ece <printf+0x1b6>

0000000080005efe <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005efe:	1141                	addi	sp,sp,-16
    80005f00:	e406                	sd	ra,8(sp)
    80005f02:	e022                	sd	s0,0(sp)
    80005f04:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f06:	100007b7          	lui	a5,0x10000
    80005f0a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f0e:	f8000713          	li	a4,-128
    80005f12:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f16:	470d                	li	a4,3
    80005f18:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f1c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f20:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f24:	469d                	li	a3,7
    80005f26:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f2a:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f2e:	00003597          	auipc	a1,0x3
    80005f32:	8c258593          	addi	a1,a1,-1854 # 800087f0 <digits+0x18>
    80005f36:	00020517          	auipc	a0,0x20
    80005f3a:	2d250513          	addi	a0,a0,722 # 80026208 <uart_tx_lock>
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	218080e7          	jalr	536(ra) # 80006156 <initlock>
}
    80005f46:	60a2                	ld	ra,8(sp)
    80005f48:	6402                	ld	s0,0(sp)
    80005f4a:	0141                	addi	sp,sp,16
    80005f4c:	8082                	ret

0000000080005f4e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f4e:	1101                	addi	sp,sp,-32
    80005f50:	ec06                	sd	ra,24(sp)
    80005f52:	e822                	sd	s0,16(sp)
    80005f54:	e426                	sd	s1,8(sp)
    80005f56:	1000                	addi	s0,sp,32
    80005f58:	84aa                	mv	s1,a0
  push_off();
    80005f5a:	00000097          	auipc	ra,0x0
    80005f5e:	240080e7          	jalr	576(ra) # 8000619a <push_off>

  if(panicked){
    80005f62:	00003797          	auipc	a5,0x3
    80005f66:	0ba7a783          	lw	a5,186(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f6a:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f6e:	c391                	beqz	a5,80005f72 <uartputc_sync+0x24>
    for(;;)
    80005f70:	a001                	j	80005f70 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f72:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f76:	0ff7f793          	andi	a5,a5,255
    80005f7a:	0207f793          	andi	a5,a5,32
    80005f7e:	dbf5                	beqz	a5,80005f72 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f80:	0ff4f793          	andi	a5,s1,255
    80005f84:	10000737          	lui	a4,0x10000
    80005f88:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	2ae080e7          	jalr	686(ra) # 8000623a <pop_off>
}
    80005f94:	60e2                	ld	ra,24(sp)
    80005f96:	6442                	ld	s0,16(sp)
    80005f98:	64a2                	ld	s1,8(sp)
    80005f9a:	6105                	addi	sp,sp,32
    80005f9c:	8082                	ret

0000000080005f9e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f9e:	00003717          	auipc	a4,0x3
    80005fa2:	08273703          	ld	a4,130(a4) # 80009020 <uart_tx_r>
    80005fa6:	00003797          	auipc	a5,0x3
    80005faa:	0827b783          	ld	a5,130(a5) # 80009028 <uart_tx_w>
    80005fae:	06e78c63          	beq	a5,a4,80006026 <uartstart+0x88>
{
    80005fb2:	7139                	addi	sp,sp,-64
    80005fb4:	fc06                	sd	ra,56(sp)
    80005fb6:	f822                	sd	s0,48(sp)
    80005fb8:	f426                	sd	s1,40(sp)
    80005fba:	f04a                	sd	s2,32(sp)
    80005fbc:	ec4e                	sd	s3,24(sp)
    80005fbe:	e852                	sd	s4,16(sp)
    80005fc0:	e456                	sd	s5,8(sp)
    80005fc2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fc4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fc8:	00020a17          	auipc	s4,0x20
    80005fcc:	240a0a13          	addi	s4,s4,576 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fd0:	00003497          	auipc	s1,0x3
    80005fd4:	05048493          	addi	s1,s1,80 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005fd8:	00003997          	auipc	s3,0x3
    80005fdc:	05098993          	addi	s3,s3,80 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fe0:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fe4:	0ff7f793          	andi	a5,a5,255
    80005fe8:	0207f793          	andi	a5,a5,32
    80005fec:	c785                	beqz	a5,80006014 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fee:	01f77793          	andi	a5,a4,31
    80005ff2:	97d2                	add	a5,a5,s4
    80005ff4:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005ff8:	0705                	addi	a4,a4,1
    80005ffa:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005ffc:	8526                	mv	a0,s1
    80005ffe:	ffffb097          	auipc	ra,0xffffb
    80006002:	6c8080e7          	jalr	1736(ra) # 800016c6 <wakeup>
    
    WriteReg(THR, c);
    80006006:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000600a:	6098                	ld	a4,0(s1)
    8000600c:	0009b783          	ld	a5,0(s3)
    80006010:	fce798e3          	bne	a5,a4,80005fe0 <uartstart+0x42>
  }
}
    80006014:	70e2                	ld	ra,56(sp)
    80006016:	7442                	ld	s0,48(sp)
    80006018:	74a2                	ld	s1,40(sp)
    8000601a:	7902                	ld	s2,32(sp)
    8000601c:	69e2                	ld	s3,24(sp)
    8000601e:	6a42                	ld	s4,16(sp)
    80006020:	6aa2                	ld	s5,8(sp)
    80006022:	6121                	addi	sp,sp,64
    80006024:	8082                	ret
    80006026:	8082                	ret

0000000080006028 <uartputc>:
{
    80006028:	7179                	addi	sp,sp,-48
    8000602a:	f406                	sd	ra,40(sp)
    8000602c:	f022                	sd	s0,32(sp)
    8000602e:	ec26                	sd	s1,24(sp)
    80006030:	e84a                	sd	s2,16(sp)
    80006032:	e44e                	sd	s3,8(sp)
    80006034:	e052                	sd	s4,0(sp)
    80006036:	1800                	addi	s0,sp,48
    80006038:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    8000603a:	00020517          	auipc	a0,0x20
    8000603e:	1ce50513          	addi	a0,a0,462 # 80026208 <uart_tx_lock>
    80006042:	00000097          	auipc	ra,0x0
    80006046:	1a4080e7          	jalr	420(ra) # 800061e6 <acquire>
  if(panicked){
    8000604a:	00003797          	auipc	a5,0x3
    8000604e:	fd27a783          	lw	a5,-46(a5) # 8000901c <panicked>
    80006052:	c391                	beqz	a5,80006056 <uartputc+0x2e>
    for(;;)
    80006054:	a001                	j	80006054 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006056:	00003797          	auipc	a5,0x3
    8000605a:	fd27b783          	ld	a5,-46(a5) # 80009028 <uart_tx_w>
    8000605e:	00003717          	auipc	a4,0x3
    80006062:	fc273703          	ld	a4,-62(a4) # 80009020 <uart_tx_r>
    80006066:	02070713          	addi	a4,a4,32
    8000606a:	02f71b63          	bne	a4,a5,800060a0 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000606e:	00020a17          	auipc	s4,0x20
    80006072:	19aa0a13          	addi	s4,s4,410 # 80026208 <uart_tx_lock>
    80006076:	00003497          	auipc	s1,0x3
    8000607a:	faa48493          	addi	s1,s1,-86 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000607e:	00003917          	auipc	s2,0x3
    80006082:	faa90913          	addi	s2,s2,-86 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006086:	85d2                	mv	a1,s4
    80006088:	8526                	mv	a0,s1
    8000608a:	ffffb097          	auipc	ra,0xffffb
    8000608e:	4b0080e7          	jalr	1200(ra) # 8000153a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006092:	00093783          	ld	a5,0(s2)
    80006096:	6098                	ld	a4,0(s1)
    80006098:	02070713          	addi	a4,a4,32
    8000609c:	fef705e3          	beq	a4,a5,80006086 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060a0:	00020497          	auipc	s1,0x20
    800060a4:	16848493          	addi	s1,s1,360 # 80026208 <uart_tx_lock>
    800060a8:	01f7f713          	andi	a4,a5,31
    800060ac:	9726                	add	a4,a4,s1
    800060ae:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    800060b2:	0785                	addi	a5,a5,1
    800060b4:	00003717          	auipc	a4,0x3
    800060b8:	f6f73a23          	sd	a5,-140(a4) # 80009028 <uart_tx_w>
      uartstart();
    800060bc:	00000097          	auipc	ra,0x0
    800060c0:	ee2080e7          	jalr	-286(ra) # 80005f9e <uartstart>
      release(&uart_tx_lock);
    800060c4:	8526                	mv	a0,s1
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	1d4080e7          	jalr	468(ra) # 8000629a <release>
}
    800060ce:	70a2                	ld	ra,40(sp)
    800060d0:	7402                	ld	s0,32(sp)
    800060d2:	64e2                	ld	s1,24(sp)
    800060d4:	6942                	ld	s2,16(sp)
    800060d6:	69a2                	ld	s3,8(sp)
    800060d8:	6a02                	ld	s4,0(sp)
    800060da:	6145                	addi	sp,sp,48
    800060dc:	8082                	ret

00000000800060de <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060de:	1141                	addi	sp,sp,-16
    800060e0:	e422                	sd	s0,8(sp)
    800060e2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060e4:	100007b7          	lui	a5,0x10000
    800060e8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060ec:	8b85                	andi	a5,a5,1
    800060ee:	cb91                	beqz	a5,80006102 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060f0:	100007b7          	lui	a5,0x10000
    800060f4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060f8:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060fc:	6422                	ld	s0,8(sp)
    800060fe:	0141                	addi	sp,sp,16
    80006100:	8082                	ret
    return -1;
    80006102:	557d                	li	a0,-1
    80006104:	bfe5                	j	800060fc <uartgetc+0x1e>

0000000080006106 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006106:	1101                	addi	sp,sp,-32
    80006108:	ec06                	sd	ra,24(sp)
    8000610a:	e822                	sd	s0,16(sp)
    8000610c:	e426                	sd	s1,8(sp)
    8000610e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006110:	54fd                	li	s1,-1
    int c = uartgetc();
    80006112:	00000097          	auipc	ra,0x0
    80006116:	fcc080e7          	jalr	-52(ra) # 800060de <uartgetc>
    if(c == -1)
    8000611a:	00950763          	beq	a0,s1,80006128 <uartintr+0x22>
      break;
    consoleintr(c);
    8000611e:	00000097          	auipc	ra,0x0
    80006122:	89a080e7          	jalr	-1894(ra) # 800059b8 <consoleintr>
  while(1){
    80006126:	b7f5                	j	80006112 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006128:	00020497          	auipc	s1,0x20
    8000612c:	0e048493          	addi	s1,s1,224 # 80026208 <uart_tx_lock>
    80006130:	8526                	mv	a0,s1
    80006132:	00000097          	auipc	ra,0x0
    80006136:	0b4080e7          	jalr	180(ra) # 800061e6 <acquire>
  uartstart();
    8000613a:	00000097          	auipc	ra,0x0
    8000613e:	e64080e7          	jalr	-412(ra) # 80005f9e <uartstart>
  release(&uart_tx_lock);
    80006142:	8526                	mv	a0,s1
    80006144:	00000097          	auipc	ra,0x0
    80006148:	156080e7          	jalr	342(ra) # 8000629a <release>
}
    8000614c:	60e2                	ld	ra,24(sp)
    8000614e:	6442                	ld	s0,16(sp)
    80006150:	64a2                	ld	s1,8(sp)
    80006152:	6105                	addi	sp,sp,32
    80006154:	8082                	ret

0000000080006156 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006156:	1141                	addi	sp,sp,-16
    80006158:	e422                	sd	s0,8(sp)
    8000615a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000615c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000615e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006162:	00053823          	sd	zero,16(a0)
}
    80006166:	6422                	ld	s0,8(sp)
    80006168:	0141                	addi	sp,sp,16
    8000616a:	8082                	ret

000000008000616c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000616c:	411c                	lw	a5,0(a0)
    8000616e:	e399                	bnez	a5,80006174 <holding+0x8>
    80006170:	4501                	li	a0,0
  return r;
}
    80006172:	8082                	ret
{
    80006174:	1101                	addi	sp,sp,-32
    80006176:	ec06                	sd	ra,24(sp)
    80006178:	e822                	sd	s0,16(sp)
    8000617a:	e426                	sd	s1,8(sp)
    8000617c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000617e:	6904                	ld	s1,16(a0)
    80006180:	ffffb097          	auipc	ra,0xffffb
    80006184:	cac080e7          	jalr	-852(ra) # 80000e2c <mycpu>
    80006188:	40a48533          	sub	a0,s1,a0
    8000618c:	00153513          	seqz	a0,a0
}
    80006190:	60e2                	ld	ra,24(sp)
    80006192:	6442                	ld	s0,16(sp)
    80006194:	64a2                	ld	s1,8(sp)
    80006196:	6105                	addi	sp,sp,32
    80006198:	8082                	ret

000000008000619a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000619a:	1101                	addi	sp,sp,-32
    8000619c:	ec06                	sd	ra,24(sp)
    8000619e:	e822                	sd	s0,16(sp)
    800061a0:	e426                	sd	s1,8(sp)
    800061a2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061a4:	100024f3          	csrr	s1,sstatus
    800061a8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061ac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061ae:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061b2:	ffffb097          	auipc	ra,0xffffb
    800061b6:	c7a080e7          	jalr	-902(ra) # 80000e2c <mycpu>
    800061ba:	5d3c                	lw	a5,120(a0)
    800061bc:	cf89                	beqz	a5,800061d6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061be:	ffffb097          	auipc	ra,0xffffb
    800061c2:	c6e080e7          	jalr	-914(ra) # 80000e2c <mycpu>
    800061c6:	5d3c                	lw	a5,120(a0)
    800061c8:	2785                	addiw	a5,a5,1
    800061ca:	dd3c                	sw	a5,120(a0)
}
    800061cc:	60e2                	ld	ra,24(sp)
    800061ce:	6442                	ld	s0,16(sp)
    800061d0:	64a2                	ld	s1,8(sp)
    800061d2:	6105                	addi	sp,sp,32
    800061d4:	8082                	ret
    mycpu()->intena = old;
    800061d6:	ffffb097          	auipc	ra,0xffffb
    800061da:	c56080e7          	jalr	-938(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061de:	8085                	srli	s1,s1,0x1
    800061e0:	8885                	andi	s1,s1,1
    800061e2:	dd64                	sw	s1,124(a0)
    800061e4:	bfe9                	j	800061be <push_off+0x24>

00000000800061e6 <acquire>:
{
    800061e6:	1101                	addi	sp,sp,-32
    800061e8:	ec06                	sd	ra,24(sp)
    800061ea:	e822                	sd	s0,16(sp)
    800061ec:	e426                	sd	s1,8(sp)
    800061ee:	1000                	addi	s0,sp,32
    800061f0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	fa8080e7          	jalr	-88(ra) # 8000619a <push_off>
  if(holding(lk))
    800061fa:	8526                	mv	a0,s1
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	f70080e7          	jalr	-144(ra) # 8000616c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006204:	4705                	li	a4,1
  if(holding(lk))
    80006206:	e115                	bnez	a0,8000622a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006208:	87ba                	mv	a5,a4
    8000620a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000620e:	2781                	sext.w	a5,a5
    80006210:	ffe5                	bnez	a5,80006208 <acquire+0x22>
  __sync_synchronize();
    80006212:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006216:	ffffb097          	auipc	ra,0xffffb
    8000621a:	c16080e7          	jalr	-1002(ra) # 80000e2c <mycpu>
    8000621e:	e888                	sd	a0,16(s1)
}
    80006220:	60e2                	ld	ra,24(sp)
    80006222:	6442                	ld	s0,16(sp)
    80006224:	64a2                	ld	s1,8(sp)
    80006226:	6105                	addi	sp,sp,32
    80006228:	8082                	ret
    panic("acquire");
    8000622a:	00002517          	auipc	a0,0x2
    8000622e:	5ce50513          	addi	a0,a0,1486 # 800087f8 <digits+0x20>
    80006232:	00000097          	auipc	ra,0x0
    80006236:	a94080e7          	jalr	-1388(ra) # 80005cc6 <panic>

000000008000623a <pop_off>:

void
pop_off(void)
{
    8000623a:	1141                	addi	sp,sp,-16
    8000623c:	e406                	sd	ra,8(sp)
    8000623e:	e022                	sd	s0,0(sp)
    80006240:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006242:	ffffb097          	auipc	ra,0xffffb
    80006246:	bea080e7          	jalr	-1046(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000624a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000624e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006250:	e78d                	bnez	a5,8000627a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006252:	5d3c                	lw	a5,120(a0)
    80006254:	02f05b63          	blez	a5,8000628a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006258:	37fd                	addiw	a5,a5,-1
    8000625a:	0007871b          	sext.w	a4,a5
    8000625e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006260:	eb09                	bnez	a4,80006272 <pop_off+0x38>
    80006262:	5d7c                	lw	a5,124(a0)
    80006264:	c799                	beqz	a5,80006272 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006266:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000626a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000626e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006272:	60a2                	ld	ra,8(sp)
    80006274:	6402                	ld	s0,0(sp)
    80006276:	0141                	addi	sp,sp,16
    80006278:	8082                	ret
    panic("pop_off - interruptible");
    8000627a:	00002517          	auipc	a0,0x2
    8000627e:	58650513          	addi	a0,a0,1414 # 80008800 <digits+0x28>
    80006282:	00000097          	auipc	ra,0x0
    80006286:	a44080e7          	jalr	-1468(ra) # 80005cc6 <panic>
    panic("pop_off");
    8000628a:	00002517          	auipc	a0,0x2
    8000628e:	58e50513          	addi	a0,a0,1422 # 80008818 <digits+0x40>
    80006292:	00000097          	auipc	ra,0x0
    80006296:	a34080e7          	jalr	-1484(ra) # 80005cc6 <panic>

000000008000629a <release>:
{
    8000629a:	1101                	addi	sp,sp,-32
    8000629c:	ec06                	sd	ra,24(sp)
    8000629e:	e822                	sd	s0,16(sp)
    800062a0:	e426                	sd	s1,8(sp)
    800062a2:	1000                	addi	s0,sp,32
    800062a4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062a6:	00000097          	auipc	ra,0x0
    800062aa:	ec6080e7          	jalr	-314(ra) # 8000616c <holding>
    800062ae:	c115                	beqz	a0,800062d2 <release+0x38>
  lk->cpu = 0;
    800062b0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062b4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062b8:	0f50000f          	fence	iorw,ow
    800062bc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062c0:	00000097          	auipc	ra,0x0
    800062c4:	f7a080e7          	jalr	-134(ra) # 8000623a <pop_off>
}
    800062c8:	60e2                	ld	ra,24(sp)
    800062ca:	6442                	ld	s0,16(sp)
    800062cc:	64a2                	ld	s1,8(sp)
    800062ce:	6105                	addi	sp,sp,32
    800062d0:	8082                	ret
    panic("release");
    800062d2:	00002517          	auipc	a0,0x2
    800062d6:	54e50513          	addi	a0,a0,1358 # 80008820 <digits+0x48>
    800062da:	00000097          	auipc	ra,0x0
    800062de:	9ec080e7          	jalr	-1556(ra) # 80005cc6 <panic>
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
