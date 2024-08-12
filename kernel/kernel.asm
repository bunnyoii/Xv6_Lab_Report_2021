
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	94013103          	ld	sp,-1728(sp) # 80008940 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	567050ef          	jal	ra,80005d7c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;
  int c;    // cpuid - lab8-1

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c9                	bnez	a5,800000b4 <kfree+0x98>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002b797          	auipc	a5,0x2b
    8000003a:	21278793          	addi	a5,a5,530 # 8002b248 <end>
    8000003e:	06f56b63          	bltu	a0,a5,800000b4 <kfree+0x98>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57763          	bgeu	a0,a5,800000b4 <kfree+0x98>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	2c4080e7          	jalr	708(ra) # 80000312 <memset>

  r = (struct run*)pa;

  // get the current core number - lab8-1
  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	6be080e7          	jalr	1726(ra) # 80006714 <push_off>
  c = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	f68080e7          	jalr	-152(ra) # 80000fc6 <cpuid>
    80000066:	8a2a                	mv	s4,a0
  pop_off();
    80000068:	00006097          	auipc	ra,0x6
    8000006c:	768080e7          	jalr	1896(ra) # 800067d0 <pop_off>
  // free the page to the current cpu's freelist - lab8-1
  acquire(&kmems[c].lock);
    80000070:	00009a97          	auipc	s5,0x9
    80000074:	fc0a8a93          	addi	s5,s5,-64 # 80009030 <kmems>
    80000078:	001a1993          	slli	s3,s4,0x1
    8000007c:	01498933          	add	s2,s3,s4
    80000080:	0912                	slli	s2,s2,0x4
    80000082:	9956                	add	s2,s2,s5
    80000084:	854a                	mv	a0,s2
    80000086:	00006097          	auipc	ra,0x6
    8000008a:	6da080e7          	jalr	1754(ra) # 80006760 <acquire>
  r->next = kmems[c].freelist;
    8000008e:	02093783          	ld	a5,32(s2)
    80000092:	e09c                	sd	a5,0(s1)
  kmems[c].freelist = r;
    80000094:	02993023          	sd	s1,32(s2)
  release(&kmems[c].lock);
    80000098:	854a                	mv	a0,s2
    8000009a:	00006097          	auipc	ra,0x6
    8000009e:	796080e7          	jalr	1942(ra) # 80006830 <release>
}
    800000a2:	70e2                	ld	ra,56(sp)
    800000a4:	7442                	ld	s0,48(sp)
    800000a6:	74a2                	ld	s1,40(sp)
    800000a8:	7902                	ld	s2,32(sp)
    800000aa:	69e2                	ld	s3,24(sp)
    800000ac:	6a42                	ld	s4,16(sp)
    800000ae:	6aa2                	ld	s5,8(sp)
    800000b0:	6121                	addi	sp,sp,64
    800000b2:	8082                	ret
    panic("kfree");
    800000b4:	00008517          	auipc	a0,0x8
    800000b8:	f5c50513          	addi	a0,a0,-164 # 80008010 <etext+0x10>
    800000bc:	00006097          	auipc	ra,0x6
    800000c0:	170080e7          	jalr	368(ra) # 8000622c <panic>

00000000800000c4 <freerange>:
{
    800000c4:	7179                	addi	sp,sp,-48
    800000c6:	f406                	sd	ra,40(sp)
    800000c8:	f022                	sd	s0,32(sp)
    800000ca:	ec26                	sd	s1,24(sp)
    800000cc:	e84a                	sd	s2,16(sp)
    800000ce:	e44e                	sd	s3,8(sp)
    800000d0:	e052                	sd	s4,0(sp)
    800000d2:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d4:	6785                	lui	a5,0x1
    800000d6:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000da:	94aa                	add	s1,s1,a0
    800000dc:	757d                	lui	a0,0xfffff
    800000de:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e0:	94be                	add	s1,s1,a5
    800000e2:	0095ee63          	bltu	a1,s1,800000fe <freerange+0x3a>
    800000e6:	892e                	mv	s2,a1
    kfree(p);
    800000e8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ea:	6985                	lui	s3,0x1
    kfree(p);
    800000ec:	01448533          	add	a0,s1,s4
    800000f0:	00000097          	auipc	ra,0x0
    800000f4:	f2c080e7          	jalr	-212(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000f8:	94ce                	add	s1,s1,s3
    800000fa:	fe9979e3          	bgeu	s2,s1,800000ec <freerange+0x28>
}
    800000fe:	70a2                	ld	ra,40(sp)
    80000100:	7402                	ld	s0,32(sp)
    80000102:	64e2                	ld	s1,24(sp)
    80000104:	6942                	ld	s2,16(sp)
    80000106:	69a2                	ld	s3,8(sp)
    80000108:	6a02                	ld	s4,0(sp)
    8000010a:	6145                	addi	sp,sp,48
    8000010c:	8082                	ret

000000008000010e <kinit>:
{
    8000010e:	7179                	addi	sp,sp,-48
    80000110:	f406                	sd	ra,40(sp)
    80000112:	f022                	sd	s0,32(sp)
    80000114:	ec26                	sd	s1,24(sp)
    80000116:	e84a                	sd	s2,16(sp)
    80000118:	e44e                	sd	s3,8(sp)
    8000011a:	e052                	sd	s4,0(sp)
    8000011c:	1800                	addi	s0,sp,48
  for (i = 0; i < NCPU; ++i) {
    8000011e:	00009917          	auipc	s2,0x9
    80000122:	f1290913          	addi	s2,s2,-238 # 80009030 <kmems>
    80000126:	4481                	li	s1,0
    snprintf(kmems[i].lockname, 8, "kmem_%d", i);    // the name of the lock
    80000128:	00008a17          	auipc	s4,0x8
    8000012c:	ef0a0a13          	addi	s4,s4,-272 # 80008018 <etext+0x18>
    80000130:	02890993          	addi	s3,s2,40
    80000134:	86a6                	mv	a3,s1
    80000136:	8652                	mv	a2,s4
    80000138:	45a1                	li	a1,8
    8000013a:	854e                	mv	a0,s3
    8000013c:	00006097          	auipc	ra,0x6
    80000140:	a56080e7          	jalr	-1450(ra) # 80005b92 <snprintf>
    initlock(&kmems[i].lock, kmems[i].lockname);
    80000144:	85ce                	mv	a1,s3
    80000146:	854a                	mv	a0,s2
    80000148:	00006097          	auipc	ra,0x6
    8000014c:	794080e7          	jalr	1940(ra) # 800068dc <initlock>
  for (i = 0; i < NCPU; ++i) {
    80000150:	2485                	addiw	s1,s1,1
    80000152:	03090913          	addi	s2,s2,48
    80000156:	47a1                	li	a5,8
    80000158:	fcf49ce3          	bne	s1,a5,80000130 <kinit+0x22>
  freerange(end, (void*)PHYSTOP);
    8000015c:	45c5                	li	a1,17
    8000015e:	05ee                	slli	a1,a1,0x1b
    80000160:	0002b517          	auipc	a0,0x2b
    80000164:	0e850513          	addi	a0,a0,232 # 8002b248 <end>
    80000168:	00000097          	auipc	ra,0x0
    8000016c:	f5c080e7          	jalr	-164(ra) # 800000c4 <freerange>
}
    80000170:	70a2                	ld	ra,40(sp)
    80000172:	7402                	ld	s0,32(sp)
    80000174:	64e2                	ld	s1,24(sp)
    80000176:	6942                	ld	s2,16(sp)
    80000178:	69a2                	ld	s3,8(sp)
    8000017a:	6a02                	ld	s4,0(sp)
    8000017c:	6145                	addi	sp,sp,48
    8000017e:	8082                	ret

0000000080000180 <steal>:

// steal half page from other cpu's freelist - lab8-1
struct run *steal(int cpu_id) {
    80000180:	715d                	addi	sp,sp,-80
    80000182:	e486                	sd	ra,72(sp)
    80000184:	e0a2                	sd	s0,64(sp)
    80000186:	fc26                	sd	s1,56(sp)
    80000188:	f84a                	sd	s2,48(sp)
    8000018a:	f44e                	sd	s3,40(sp)
    8000018c:	f052                	sd	s4,32(sp)
    8000018e:	ec56                	sd	s5,24(sp)
    80000190:	e85a                	sd	s6,16(sp)
    80000192:	e45e                	sd	s7,8(sp)
    80000194:	0880                	addi	s0,sp,80
    80000196:	892a                	mv	s2,a0
    int i;
    int c = cpu_id;
    struct run *fast, *slow, *head;
    // 若传递的cpuid和实际运行的cpuid出现不一致,则引发panic
    // 加入该判断以检查在kalloc()调用steal时CPU不会被切换
    if(cpu_id != cpuid()) {
    80000198:	00001097          	auipc	ra,0x1
    8000019c:	e2e080e7          	jalr	-466(ra) # 80000fc6 <cpuid>
    800001a0:	01251a63          	bne	a0,s2,800001b4 <steal+0x34>
    800001a4:	499d                	li	s3,7
      panic("steal");
    }    
    // 遍历其他NCPU-1个CPU的空闲物理页链表 
    for (i = 1; i < NCPU; ++i) {
        if (++c == NCPU) {
    800001a6:	4b21                	li	s6,8
            c = 0;
    800001a8:	4b81                	li	s7,0
        }
        acquire(&kmems[c].lock);
    800001aa:	00009a97          	auipc	s5,0x9
    800001ae:	e86a8a93          	addi	s5,s5,-378 # 80009030 <kmems>
    800001b2:	a83d                	j	800001f0 <steal+0x70>
      panic("steal");
    800001b4:	00008517          	auipc	a0,0x8
    800001b8:	e6c50513          	addi	a0,a0,-404 # 80008020 <etext+0x20>
    800001bc:	00006097          	auipc	ra,0x6
    800001c0:	070080e7          	jalr	112(ra) # 8000622c <panic>
        acquire(&kmems[c].lock);
    800001c4:	00191493          	slli	s1,s2,0x1
    800001c8:	94ca                	add	s1,s1,s2
    800001ca:	0492                	slli	s1,s1,0x4
    800001cc:	94d6                	add	s1,s1,s5
    800001ce:	8526                	mv	a0,s1
    800001d0:	00006097          	auipc	ra,0x6
    800001d4:	590080e7          	jalr	1424(ra) # 80006760 <acquire>
        // 若链表不为空
        if (kmems[c].freelist) {
    800001d8:	0204ba03          	ld	s4,32(s1)
    800001dc:	000a1f63          	bnez	s4,800001fa <steal+0x7a>
            // 前半部分的链表结尾清空,由于该部分链表与其他链表不再关联,因此无需加锁
            slow->next = 0;
            // 返回前半部分的链表头
            return head;
        }
        release(&kmems[c].lock);
    800001e0:	8526                	mv	a0,s1
    800001e2:	00006097          	auipc	ra,0x6
    800001e6:	64e080e7          	jalr	1614(ra) # 80006830 <release>
    for (i = 1; i < NCPU; ++i) {
    800001ea:	39fd                	addiw	s3,s3,-1
    800001ec:	04098563          	beqz	s3,80000236 <steal+0xb6>
        if (++c == NCPU) {
    800001f0:	2905                	addiw	s2,s2,1
    800001f2:	fd6919e3          	bne	s2,s6,800001c4 <steal+0x44>
            c = 0;
    800001f6:	895e                	mv	s2,s7
    800001f8:	b7f1                	j	800001c4 <steal+0x44>
            fast = slow->next;
    800001fa:	000a3783          	ld	a5,0(s4)
        if (kmems[c].freelist) {
    800001fe:	89d2                	mv	s3,s4
            while (fast) {
    80000200:	c799                	beqz	a5,8000020e <steal+0x8e>
                fast = fast->next;
    80000202:	639c                	ld	a5,0(a5)
                if (fast) {
    80000204:	dff5                	beqz	a5,80000200 <steal+0x80>
                    slow = slow->next;
    80000206:	0009b983          	ld	s3,0(s3) # 1000 <_entry-0x7ffff000>
                    fast = fast->next;
    8000020a:	639c                	ld	a5,0(a5)
    8000020c:	bfd5                	j	80000200 <steal+0x80>
            kmems[c].freelist = slow->next;
    8000020e:	0009b703          	ld	a4,0(s3)
    80000212:	00191793          	slli	a5,s2,0x1
    80000216:	993e                	add	s2,s2,a5
    80000218:	0912                	slli	s2,s2,0x4
    8000021a:	00009797          	auipc	a5,0x9
    8000021e:	e1678793          	addi	a5,a5,-490 # 80009030 <kmems>
    80000222:	993e                	add	s2,s2,a5
    80000224:	02e93023          	sd	a4,32(s2)
            release(&kmems[c].lock);
    80000228:	8526                	mv	a0,s1
    8000022a:	00006097          	auipc	ra,0x6
    8000022e:	606080e7          	jalr	1542(ra) # 80006830 <release>
            slow->next = 0;
    80000232:	0009b023          	sd	zero,0(s3)
    }
    // 若其他CPU物理页均为空则返回空指针
    return 0;
}
    80000236:	8552                	mv	a0,s4
    80000238:	60a6                	ld	ra,72(sp)
    8000023a:	6406                	ld	s0,64(sp)
    8000023c:	74e2                	ld	s1,56(sp)
    8000023e:	7942                	ld	s2,48(sp)
    80000240:	79a2                	ld	s3,40(sp)
    80000242:	7a02                	ld	s4,32(sp)
    80000244:	6ae2                	ld	s5,24(sp)
    80000246:	6b42                	ld	s6,16(sp)
    80000248:	6ba2                	ld	s7,8(sp)
    8000024a:	6161                	addi	sp,sp,80
    8000024c:	8082                	ret

000000008000024e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000024e:	7179                	addi	sp,sp,-48
    80000250:	f406                	sd	ra,40(sp)
    80000252:	f022                	sd	s0,32(sp)
    80000254:	ec26                	sd	s1,24(sp)
    80000256:	e84a                	sd	s2,16(sp)
    80000258:	e44e                	sd	s3,8(sp)
    8000025a:	1800                	addi	s0,sp,48
  struct run *r;
  // lab8-1
  int c;
  push_off();
    8000025c:	00006097          	auipc	ra,0x6
    80000260:	4b8080e7          	jalr	1208(ra) # 80006714 <push_off>
  c = cpuid();
    80000264:	00001097          	auipc	ra,0x1
    80000268:	d62080e7          	jalr	-670(ra) # 80000fc6 <cpuid>
    8000026c:	84aa                	mv	s1,a0
  pop_off();
    8000026e:	00006097          	auipc	ra,0x6
    80000272:	562080e7          	jalr	1378(ra) # 800067d0 <pop_off>
  // get the page from the current cpu's freelist
  acquire(&kmems[c].lock);
    80000276:	00149793          	slli	a5,s1,0x1
    8000027a:	97a6                	add	a5,a5,s1
    8000027c:	0792                	slli	a5,a5,0x4
    8000027e:	00009517          	auipc	a0,0x9
    80000282:	db250513          	addi	a0,a0,-590 # 80009030 <kmems>
    80000286:	00f50933          	add	s2,a0,a5
    8000028a:	854a                	mv	a0,s2
    8000028c:	00006097          	auipc	ra,0x6
    80000290:	4d4080e7          	jalr	1236(ra) # 80006760 <acquire>
  r = kmems[c].freelist;
    80000294:	02093983          	ld	s3,32(s2)
  if(r)
    80000298:	02098a63          	beqz	s3,800002cc <kalloc+0x7e>
    kmems[c].freelist = r->next;
    8000029c:	0009b703          	ld	a4,0(s3)
    800002a0:	02e93023          	sd	a4,32(s2)
  release(&kmems[c].lock);
    800002a4:	854a                	mv	a0,s2
    800002a6:	00006097          	auipc	ra,0x6
    800002aa:	58a080e7          	jalr	1418(ra) # 80006830 <release>
    kmems[c].freelist = r->next;
    release(&kmems[c].lock);
  }

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800002ae:	6605                	lui	a2,0x1
    800002b0:	4595                	li	a1,5
    800002b2:	854e                	mv	a0,s3
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	05e080e7          	jalr	94(ra) # 80000312 <memset>
  return (void*)r;
}
    800002bc:	854e                	mv	a0,s3
    800002be:	70a2                	ld	ra,40(sp)
    800002c0:	7402                	ld	s0,32(sp)
    800002c2:	64e2                	ld	s1,24(sp)
    800002c4:	6942                	ld	s2,16(sp)
    800002c6:	69a2                	ld	s3,8(sp)
    800002c8:	6145                	addi	sp,sp,48
    800002ca:	8082                	ret
  release(&kmems[c].lock);
    800002cc:	854a                	mv	a0,s2
    800002ce:	00006097          	auipc	ra,0x6
    800002d2:	562080e7          	jalr	1378(ra) # 80006830 <release>
  if(!r && (r = steal(c))) {
    800002d6:	8526                	mv	a0,s1
    800002d8:	00000097          	auipc	ra,0x0
    800002dc:	ea8080e7          	jalr	-344(ra) # 80000180 <steal>
    800002e0:	89aa                	mv	s3,a0
    800002e2:	dd69                	beqz	a0,800002bc <kalloc+0x6e>
    acquire(&kmems[c].lock);
    800002e4:	854a                	mv	a0,s2
    800002e6:	00006097          	auipc	ra,0x6
    800002ea:	47a080e7          	jalr	1146(ra) # 80006760 <acquire>
    kmems[c].freelist = r->next;
    800002ee:	0009b703          	ld	a4,0(s3)
    800002f2:	00149513          	slli	a0,s1,0x1
    800002f6:	94aa                	add	s1,s1,a0
    800002f8:	0492                	slli	s1,s1,0x4
    800002fa:	00009797          	auipc	a5,0x9
    800002fe:	d3678793          	addi	a5,a5,-714 # 80009030 <kmems>
    80000302:	94be                	add	s1,s1,a5
    80000304:	f098                	sd	a4,32(s1)
    release(&kmems[c].lock);
    80000306:	854a                	mv	a0,s2
    80000308:	00006097          	auipc	ra,0x6
    8000030c:	528080e7          	jalr	1320(ra) # 80006830 <release>
    80000310:	bf79                	j	800002ae <kalloc+0x60>

0000000080000312 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000312:	1141                	addi	sp,sp,-16
    80000314:	e422                	sd	s0,8(sp)
    80000316:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000318:	ce09                	beqz	a2,80000332 <memset+0x20>
    8000031a:	87aa                	mv	a5,a0
    8000031c:	fff6071b          	addiw	a4,a2,-1
    80000320:	1702                	slli	a4,a4,0x20
    80000322:	9301                	srli	a4,a4,0x20
    80000324:	0705                	addi	a4,a4,1
    80000326:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000328:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    8000032c:	0785                	addi	a5,a5,1
    8000032e:	fee79de3          	bne	a5,a4,80000328 <memset+0x16>
  }
  return dst;
}
    80000332:	6422                	ld	s0,8(sp)
    80000334:	0141                	addi	sp,sp,16
    80000336:	8082                	ret

0000000080000338 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000338:	1141                	addi	sp,sp,-16
    8000033a:	e422                	sd	s0,8(sp)
    8000033c:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000033e:	ca05                	beqz	a2,8000036e <memcmp+0x36>
    80000340:	fff6069b          	addiw	a3,a2,-1
    80000344:	1682                	slli	a3,a3,0x20
    80000346:	9281                	srli	a3,a3,0x20
    80000348:	0685                	addi	a3,a3,1
    8000034a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000034c:	00054783          	lbu	a5,0(a0)
    80000350:	0005c703          	lbu	a4,0(a1)
    80000354:	00e79863          	bne	a5,a4,80000364 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000358:	0505                	addi	a0,a0,1
    8000035a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000035c:	fed518e3          	bne	a0,a3,8000034c <memcmp+0x14>
  }

  return 0;
    80000360:	4501                	li	a0,0
    80000362:	a019                	j	80000368 <memcmp+0x30>
      return *s1 - *s2;
    80000364:	40e7853b          	subw	a0,a5,a4
}
    80000368:	6422                	ld	s0,8(sp)
    8000036a:	0141                	addi	sp,sp,16
    8000036c:	8082                	ret
  return 0;
    8000036e:	4501                	li	a0,0
    80000370:	bfe5                	j	80000368 <memcmp+0x30>

0000000080000372 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000372:	1141                	addi	sp,sp,-16
    80000374:	e422                	sd	s0,8(sp)
    80000376:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000378:	ca0d                	beqz	a2,800003aa <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000037a:	00a5f963          	bgeu	a1,a0,8000038c <memmove+0x1a>
    8000037e:	02061693          	slli	a3,a2,0x20
    80000382:	9281                	srli	a3,a3,0x20
    80000384:	00d58733          	add	a4,a1,a3
    80000388:	02e56463          	bltu	a0,a4,800003b0 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000038c:	fff6079b          	addiw	a5,a2,-1
    80000390:	1782                	slli	a5,a5,0x20
    80000392:	9381                	srli	a5,a5,0x20
    80000394:	0785                	addi	a5,a5,1
    80000396:	97ae                	add	a5,a5,a1
    80000398:	872a                	mv	a4,a0
      *d++ = *s++;
    8000039a:	0585                	addi	a1,a1,1
    8000039c:	0705                	addi	a4,a4,1
    8000039e:	fff5c683          	lbu	a3,-1(a1)
    800003a2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800003a6:	fef59ae3          	bne	a1,a5,8000039a <memmove+0x28>

  return dst;
}
    800003aa:	6422                	ld	s0,8(sp)
    800003ac:	0141                	addi	sp,sp,16
    800003ae:	8082                	ret
    d += n;
    800003b0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800003b2:	fff6079b          	addiw	a5,a2,-1
    800003b6:	1782                	slli	a5,a5,0x20
    800003b8:	9381                	srli	a5,a5,0x20
    800003ba:	fff7c793          	not	a5,a5
    800003be:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800003c0:	177d                	addi	a4,a4,-1
    800003c2:	16fd                	addi	a3,a3,-1
    800003c4:	00074603          	lbu	a2,0(a4)
    800003c8:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800003cc:	fef71ae3          	bne	a4,a5,800003c0 <memmove+0x4e>
    800003d0:	bfe9                	j	800003aa <memmove+0x38>

00000000800003d2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800003d2:	1141                	addi	sp,sp,-16
    800003d4:	e406                	sd	ra,8(sp)
    800003d6:	e022                	sd	s0,0(sp)
    800003d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800003da:	00000097          	auipc	ra,0x0
    800003de:	f98080e7          	jalr	-104(ra) # 80000372 <memmove>
}
    800003e2:	60a2                	ld	ra,8(sp)
    800003e4:	6402                	ld	s0,0(sp)
    800003e6:	0141                	addi	sp,sp,16
    800003e8:	8082                	ret

00000000800003ea <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800003ea:	1141                	addi	sp,sp,-16
    800003ec:	e422                	sd	s0,8(sp)
    800003ee:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800003f0:	ce11                	beqz	a2,8000040c <strncmp+0x22>
    800003f2:	00054783          	lbu	a5,0(a0)
    800003f6:	cf89                	beqz	a5,80000410 <strncmp+0x26>
    800003f8:	0005c703          	lbu	a4,0(a1)
    800003fc:	00f71a63          	bne	a4,a5,80000410 <strncmp+0x26>
    n--, p++, q++;
    80000400:	367d                	addiw	a2,a2,-1
    80000402:	0505                	addi	a0,a0,1
    80000404:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000406:	f675                	bnez	a2,800003f2 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000408:	4501                	li	a0,0
    8000040a:	a809                	j	8000041c <strncmp+0x32>
    8000040c:	4501                	li	a0,0
    8000040e:	a039                	j	8000041c <strncmp+0x32>
  if(n == 0)
    80000410:	ca09                	beqz	a2,80000422 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000412:	00054503          	lbu	a0,0(a0)
    80000416:	0005c783          	lbu	a5,0(a1)
    8000041a:	9d1d                	subw	a0,a0,a5
}
    8000041c:	6422                	ld	s0,8(sp)
    8000041e:	0141                	addi	sp,sp,16
    80000420:	8082                	ret
    return 0;
    80000422:	4501                	li	a0,0
    80000424:	bfe5                	j	8000041c <strncmp+0x32>

0000000080000426 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000426:	1141                	addi	sp,sp,-16
    80000428:	e422                	sd	s0,8(sp)
    8000042a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000042c:	872a                	mv	a4,a0
    8000042e:	8832                	mv	a6,a2
    80000430:	367d                	addiw	a2,a2,-1
    80000432:	01005963          	blez	a6,80000444 <strncpy+0x1e>
    80000436:	0705                	addi	a4,a4,1
    80000438:	0005c783          	lbu	a5,0(a1)
    8000043c:	fef70fa3          	sb	a5,-1(a4)
    80000440:	0585                	addi	a1,a1,1
    80000442:	f7f5                	bnez	a5,8000042e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000444:	00c05d63          	blez	a2,8000045e <strncpy+0x38>
    80000448:	86ba                	mv	a3,a4
    *s++ = 0;
    8000044a:	0685                	addi	a3,a3,1
    8000044c:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000450:	fff6c793          	not	a5,a3
    80000454:	9fb9                	addw	a5,a5,a4
    80000456:	010787bb          	addw	a5,a5,a6
    8000045a:	fef048e3          	bgtz	a5,8000044a <strncpy+0x24>
  return os;
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000464:	1141                	addi	sp,sp,-16
    80000466:	e422                	sd	s0,8(sp)
    80000468:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000046a:	02c05363          	blez	a2,80000490 <safestrcpy+0x2c>
    8000046e:	fff6069b          	addiw	a3,a2,-1
    80000472:	1682                	slli	a3,a3,0x20
    80000474:	9281                	srli	a3,a3,0x20
    80000476:	96ae                	add	a3,a3,a1
    80000478:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000047a:	00d58963          	beq	a1,a3,8000048c <safestrcpy+0x28>
    8000047e:	0585                	addi	a1,a1,1
    80000480:	0785                	addi	a5,a5,1
    80000482:	fff5c703          	lbu	a4,-1(a1)
    80000486:	fee78fa3          	sb	a4,-1(a5)
    8000048a:	fb65                	bnez	a4,8000047a <safestrcpy+0x16>
    ;
  *s = 0;
    8000048c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000490:	6422                	ld	s0,8(sp)
    80000492:	0141                	addi	sp,sp,16
    80000494:	8082                	ret

0000000080000496 <strlen>:

int
strlen(const char *s)
{
    80000496:	1141                	addi	sp,sp,-16
    80000498:	e422                	sd	s0,8(sp)
    8000049a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000049c:	00054783          	lbu	a5,0(a0)
    800004a0:	cf91                	beqz	a5,800004bc <strlen+0x26>
    800004a2:	0505                	addi	a0,a0,1
    800004a4:	87aa                	mv	a5,a0
    800004a6:	4685                	li	a3,1
    800004a8:	9e89                	subw	a3,a3,a0
    800004aa:	00f6853b          	addw	a0,a3,a5
    800004ae:	0785                	addi	a5,a5,1
    800004b0:	fff7c703          	lbu	a4,-1(a5)
    800004b4:	fb7d                	bnez	a4,800004aa <strlen+0x14>
    ;
  return n;
}
    800004b6:	6422                	ld	s0,8(sp)
    800004b8:	0141                	addi	sp,sp,16
    800004ba:	8082                	ret
  for(n = 0; s[n]; n++)
    800004bc:	4501                	li	a0,0
    800004be:	bfe5                	j	800004b6 <strlen+0x20>

00000000800004c0 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800004c0:	1101                	addi	sp,sp,-32
    800004c2:	ec06                	sd	ra,24(sp)
    800004c4:	e822                	sd	s0,16(sp)
    800004c6:	e426                	sd	s1,8(sp)
    800004c8:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800004ca:	00001097          	auipc	ra,0x1
    800004ce:	afc080e7          	jalr	-1284(ra) # 80000fc6 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    800004d2:	00009497          	auipc	s1,0x9
    800004d6:	b2e48493          	addi	s1,s1,-1234 # 80009000 <started>
  if(cpuid() == 0){
    800004da:	c531                	beqz	a0,80000526 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    800004dc:	8526                	mv	a0,s1
    800004de:	00006097          	auipc	ra,0x6
    800004e2:	494080e7          	jalr	1172(ra) # 80006972 <lockfree_read4>
    800004e6:	d97d                	beqz	a0,800004dc <main+0x1c>
      ;
    __sync_synchronize();
    800004e8:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800004ec:	00001097          	auipc	ra,0x1
    800004f0:	ada080e7          	jalr	-1318(ra) # 80000fc6 <cpuid>
    800004f4:	85aa                	mv	a1,a0
    800004f6:	00008517          	auipc	a0,0x8
    800004fa:	b4a50513          	addi	a0,a0,-1206 # 80008040 <etext+0x40>
    800004fe:	00006097          	auipc	ra,0x6
    80000502:	d78080e7          	jalr	-648(ra) # 80006276 <printf>
    kvminithart();    // turn on paging
    80000506:	00000097          	auipc	ra,0x0
    8000050a:	0e0080e7          	jalr	224(ra) # 800005e6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000050e:	00001097          	auipc	ra,0x1
    80000512:	730080e7          	jalr	1840(ra) # 80001c3e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000516:	00005097          	auipc	ra,0x5
    8000051a:	eba080e7          	jalr	-326(ra) # 800053d0 <plicinithart>
  }

  scheduler();        
    8000051e:	00001097          	auipc	ra,0x1
    80000522:	fde080e7          	jalr	-34(ra) # 800014fc <scheduler>
    consoleinit();
    80000526:	00006097          	auipc	ra,0x6
    8000052a:	c18080e7          	jalr	-1000(ra) # 8000613e <consoleinit>
    statsinit();
    8000052e:	00005097          	auipc	ra,0x5
    80000532:	588080e7          	jalr	1416(ra) # 80005ab6 <statsinit>
    printfinit();
    80000536:	00006097          	auipc	ra,0x6
    8000053a:	f26080e7          	jalr	-218(ra) # 8000645c <printfinit>
    printf("\n");
    8000053e:	00008517          	auipc	a0,0x8
    80000542:	35250513          	addi	a0,a0,850 # 80008890 <digits+0x88>
    80000546:	00006097          	auipc	ra,0x6
    8000054a:	d30080e7          	jalr	-720(ra) # 80006276 <printf>
    printf("xv6 kernel is booting\n");
    8000054e:	00008517          	auipc	a0,0x8
    80000552:	ada50513          	addi	a0,a0,-1318 # 80008028 <etext+0x28>
    80000556:	00006097          	auipc	ra,0x6
    8000055a:	d20080e7          	jalr	-736(ra) # 80006276 <printf>
    printf("\n");
    8000055e:	00008517          	auipc	a0,0x8
    80000562:	33250513          	addi	a0,a0,818 # 80008890 <digits+0x88>
    80000566:	00006097          	auipc	ra,0x6
    8000056a:	d10080e7          	jalr	-752(ra) # 80006276 <printf>
    kinit();         // physical page allocator
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	ba0080e7          	jalr	-1120(ra) # 8000010e <kinit>
    kvminit();       // create kernel page table
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	322080e7          	jalr	802(ra) # 80000898 <kvminit>
    kvminithart();   // turn on paging
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	068080e7          	jalr	104(ra) # 800005e6 <kvminithart>
    procinit();      // process table
    80000586:	00001097          	auipc	ra,0x1
    8000058a:	990080e7          	jalr	-1648(ra) # 80000f16 <procinit>
    trapinit();      // trap vectors
    8000058e:	00001097          	auipc	ra,0x1
    80000592:	688080e7          	jalr	1672(ra) # 80001c16 <trapinit>
    trapinithart();  // install kernel trap vector
    80000596:	00001097          	auipc	ra,0x1
    8000059a:	6a8080e7          	jalr	1704(ra) # 80001c3e <trapinithart>
    plicinit();      // set up interrupt controller
    8000059e:	00005097          	auipc	ra,0x5
    800005a2:	e1c080e7          	jalr	-484(ra) # 800053ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800005a6:	00005097          	auipc	ra,0x5
    800005aa:	e2a080e7          	jalr	-470(ra) # 800053d0 <plicinithart>
    binit();         // buffer cache
    800005ae:	00002097          	auipc	ra,0x2
    800005b2:	dd2080e7          	jalr	-558(ra) # 80002380 <binit>
    iinit();         // inode table
    800005b6:	00002097          	auipc	ra,0x2
    800005ba:	68c080e7          	jalr	1676(ra) # 80002c42 <iinit>
    fileinit();      // file table
    800005be:	00003097          	auipc	ra,0x3
    800005c2:	636080e7          	jalr	1590(ra) # 80003bf4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800005c6:	00005097          	auipc	ra,0x5
    800005ca:	f2c080e7          	jalr	-212(ra) # 800054f2 <virtio_disk_init>
    userinit();      // first user process
    800005ce:	00001097          	auipc	ra,0x1
    800005d2:	cfc080e7          	jalr	-772(ra) # 800012ca <userinit>
    __sync_synchronize();
    800005d6:	0ff0000f          	fence
    started = 1;
    800005da:	4785                	li	a5,1
    800005dc:	00009717          	auipc	a4,0x9
    800005e0:	a2f72223          	sw	a5,-1500(a4) # 80009000 <started>
    800005e4:	bf2d                	j	8000051e <main+0x5e>

00000000800005e6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800005e6:	1141                	addi	sp,sp,-16
    800005e8:	e422                	sd	s0,8(sp)
    800005ea:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800005ec:	00009797          	auipc	a5,0x9
    800005f0:	a1c7b783          	ld	a5,-1508(a5) # 80009008 <kernel_pagetable>
    800005f4:	83b1                	srli	a5,a5,0xc
    800005f6:	577d                	li	a4,-1
    800005f8:	177e                	slli	a4,a4,0x3f
    800005fa:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800005fc:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000600:	12000073          	sfence.vma
  sfence_vma();
}
    80000604:	6422                	ld	s0,8(sp)
    80000606:	0141                	addi	sp,sp,16
    80000608:	8082                	ret

000000008000060a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000060a:	7139                	addi	sp,sp,-64
    8000060c:	fc06                	sd	ra,56(sp)
    8000060e:	f822                	sd	s0,48(sp)
    80000610:	f426                	sd	s1,40(sp)
    80000612:	f04a                	sd	s2,32(sp)
    80000614:	ec4e                	sd	s3,24(sp)
    80000616:	e852                	sd	s4,16(sp)
    80000618:	e456                	sd	s5,8(sp)
    8000061a:	e05a                	sd	s6,0(sp)
    8000061c:	0080                	addi	s0,sp,64
    8000061e:	84aa                	mv	s1,a0
    80000620:	89ae                	mv	s3,a1
    80000622:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000624:	57fd                	li	a5,-1
    80000626:	83e9                	srli	a5,a5,0x1a
    80000628:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000062a:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000062c:	04b7f263          	bgeu	a5,a1,80000670 <walk+0x66>
    panic("walk");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	a2850513          	addi	a0,a0,-1496 # 80008058 <etext+0x58>
    80000638:	00006097          	auipc	ra,0x6
    8000063c:	bf4080e7          	jalr	-1036(ra) # 8000622c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000640:	060a8663          	beqz	s5,800006ac <walk+0xa2>
    80000644:	00000097          	auipc	ra,0x0
    80000648:	c0a080e7          	jalr	-1014(ra) # 8000024e <kalloc>
    8000064c:	84aa                	mv	s1,a0
    8000064e:	c529                	beqz	a0,80000698 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000650:	6605                	lui	a2,0x1
    80000652:	4581                	li	a1,0
    80000654:	00000097          	auipc	ra,0x0
    80000658:	cbe080e7          	jalr	-834(ra) # 80000312 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000065c:	00c4d793          	srli	a5,s1,0xc
    80000660:	07aa                	slli	a5,a5,0xa
    80000662:	0017e793          	ori	a5,a5,1
    80000666:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000066a:	3a5d                	addiw	s4,s4,-9
    8000066c:	036a0063          	beq	s4,s6,8000068c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000670:	0149d933          	srl	s2,s3,s4
    80000674:	1ff97913          	andi	s2,s2,511
    80000678:	090e                	slli	s2,s2,0x3
    8000067a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000067c:	00093483          	ld	s1,0(s2)
    80000680:	0014f793          	andi	a5,s1,1
    80000684:	dfd5                	beqz	a5,80000640 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000686:	80a9                	srli	s1,s1,0xa
    80000688:	04b2                	slli	s1,s1,0xc
    8000068a:	b7c5                	j	8000066a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000068c:	00c9d513          	srli	a0,s3,0xc
    80000690:	1ff57513          	andi	a0,a0,511
    80000694:	050e                	slli	a0,a0,0x3
    80000696:	9526                	add	a0,a0,s1
}
    80000698:	70e2                	ld	ra,56(sp)
    8000069a:	7442                	ld	s0,48(sp)
    8000069c:	74a2                	ld	s1,40(sp)
    8000069e:	7902                	ld	s2,32(sp)
    800006a0:	69e2                	ld	s3,24(sp)
    800006a2:	6a42                	ld	s4,16(sp)
    800006a4:	6aa2                	ld	s5,8(sp)
    800006a6:	6b02                	ld	s6,0(sp)
    800006a8:	6121                	addi	sp,sp,64
    800006aa:	8082                	ret
        return 0;
    800006ac:	4501                	li	a0,0
    800006ae:	b7ed                	j	80000698 <walk+0x8e>

00000000800006b0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800006b0:	57fd                	li	a5,-1
    800006b2:	83e9                	srli	a5,a5,0x1a
    800006b4:	00b7f463          	bgeu	a5,a1,800006bc <walkaddr+0xc>
    return 0;
    800006b8:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800006ba:	8082                	ret
{
    800006bc:	1141                	addi	sp,sp,-16
    800006be:	e406                	sd	ra,8(sp)
    800006c0:	e022                	sd	s0,0(sp)
    800006c2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800006c4:	4601                	li	a2,0
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	f44080e7          	jalr	-188(ra) # 8000060a <walk>
  if(pte == 0)
    800006ce:	c105                	beqz	a0,800006ee <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800006d0:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800006d2:	0117f693          	andi	a3,a5,17
    800006d6:	4745                	li	a4,17
    return 0;
    800006d8:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800006da:	00e68663          	beq	a3,a4,800006e6 <walkaddr+0x36>
}
    800006de:	60a2                	ld	ra,8(sp)
    800006e0:	6402                	ld	s0,0(sp)
    800006e2:	0141                	addi	sp,sp,16
    800006e4:	8082                	ret
  pa = PTE2PA(*pte);
    800006e6:	00a7d513          	srli	a0,a5,0xa
    800006ea:	0532                	slli	a0,a0,0xc
  return pa;
    800006ec:	bfcd                	j	800006de <walkaddr+0x2e>
    return 0;
    800006ee:	4501                	li	a0,0
    800006f0:	b7fd                	j	800006de <walkaddr+0x2e>

00000000800006f2 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800006f2:	715d                	addi	sp,sp,-80
    800006f4:	e486                	sd	ra,72(sp)
    800006f6:	e0a2                	sd	s0,64(sp)
    800006f8:	fc26                	sd	s1,56(sp)
    800006fa:	f84a                	sd	s2,48(sp)
    800006fc:	f44e                	sd	s3,40(sp)
    800006fe:	f052                	sd	s4,32(sp)
    80000700:	ec56                	sd	s5,24(sp)
    80000702:	e85a                	sd	s6,16(sp)
    80000704:	e45e                	sd	s7,8(sp)
    80000706:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000708:	c205                	beqz	a2,80000728 <mappages+0x36>
    8000070a:	8aaa                	mv	s5,a0
    8000070c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000070e:	77fd                	lui	a5,0xfffff
    80000710:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000714:	15fd                	addi	a1,a1,-1
    80000716:	00c589b3          	add	s3,a1,a2
    8000071a:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000071e:	8952                	mv	s2,s4
    80000720:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000724:	6b85                	lui	s7,0x1
    80000726:	a015                	j	8000074a <mappages+0x58>
    panic("mappages: size");
    80000728:	00008517          	auipc	a0,0x8
    8000072c:	93850513          	addi	a0,a0,-1736 # 80008060 <etext+0x60>
    80000730:	00006097          	auipc	ra,0x6
    80000734:	afc080e7          	jalr	-1284(ra) # 8000622c <panic>
      panic("mappages: remap");
    80000738:	00008517          	auipc	a0,0x8
    8000073c:	93850513          	addi	a0,a0,-1736 # 80008070 <etext+0x70>
    80000740:	00006097          	auipc	ra,0x6
    80000744:	aec080e7          	jalr	-1300(ra) # 8000622c <panic>
    a += PGSIZE;
    80000748:	995e                	add	s2,s2,s7
  for(;;){
    8000074a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000074e:	4605                	li	a2,1
    80000750:	85ca                	mv	a1,s2
    80000752:	8556                	mv	a0,s5
    80000754:	00000097          	auipc	ra,0x0
    80000758:	eb6080e7          	jalr	-330(ra) # 8000060a <walk>
    8000075c:	cd19                	beqz	a0,8000077a <mappages+0x88>
    if(*pte & PTE_V)
    8000075e:	611c                	ld	a5,0(a0)
    80000760:	8b85                	andi	a5,a5,1
    80000762:	fbf9                	bnez	a5,80000738 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000764:	80b1                	srli	s1,s1,0xc
    80000766:	04aa                	slli	s1,s1,0xa
    80000768:	0164e4b3          	or	s1,s1,s6
    8000076c:	0014e493          	ori	s1,s1,1
    80000770:	e104                	sd	s1,0(a0)
    if(a == last)
    80000772:	fd391be3          	bne	s2,s3,80000748 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    80000776:	4501                	li	a0,0
    80000778:	a011                	j	8000077c <mappages+0x8a>
      return -1;
    8000077a:	557d                	li	a0,-1
}
    8000077c:	60a6                	ld	ra,72(sp)
    8000077e:	6406                	ld	s0,64(sp)
    80000780:	74e2                	ld	s1,56(sp)
    80000782:	7942                	ld	s2,48(sp)
    80000784:	79a2                	ld	s3,40(sp)
    80000786:	7a02                	ld	s4,32(sp)
    80000788:	6ae2                	ld	s5,24(sp)
    8000078a:	6b42                	ld	s6,16(sp)
    8000078c:	6ba2                	ld	s7,8(sp)
    8000078e:	6161                	addi	sp,sp,80
    80000790:	8082                	ret

0000000080000792 <kvmmap>:
{
    80000792:	1141                	addi	sp,sp,-16
    80000794:	e406                	sd	ra,8(sp)
    80000796:	e022                	sd	s0,0(sp)
    80000798:	0800                	addi	s0,sp,16
    8000079a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000079c:	86b2                	mv	a3,a2
    8000079e:	863e                	mv	a2,a5
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	f52080e7          	jalr	-174(ra) # 800006f2 <mappages>
    800007a8:	e509                	bnez	a0,800007b2 <kvmmap+0x20>
}
    800007aa:	60a2                	ld	ra,8(sp)
    800007ac:	6402                	ld	s0,0(sp)
    800007ae:	0141                	addi	sp,sp,16
    800007b0:	8082                	ret
    panic("kvmmap");
    800007b2:	00008517          	auipc	a0,0x8
    800007b6:	8ce50513          	addi	a0,a0,-1842 # 80008080 <etext+0x80>
    800007ba:	00006097          	auipc	ra,0x6
    800007be:	a72080e7          	jalr	-1422(ra) # 8000622c <panic>

00000000800007c2 <kvmmake>:
{
    800007c2:	1101                	addi	sp,sp,-32
    800007c4:	ec06                	sd	ra,24(sp)
    800007c6:	e822                	sd	s0,16(sp)
    800007c8:	e426                	sd	s1,8(sp)
    800007ca:	e04a                	sd	s2,0(sp)
    800007cc:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800007ce:	00000097          	auipc	ra,0x0
    800007d2:	a80080e7          	jalr	-1408(ra) # 8000024e <kalloc>
    800007d6:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800007d8:	6605                	lui	a2,0x1
    800007da:	4581                	li	a1,0
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	b36080e7          	jalr	-1226(ra) # 80000312 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800007e4:	4719                	li	a4,6
    800007e6:	6685                	lui	a3,0x1
    800007e8:	10000637          	lui	a2,0x10000
    800007ec:	100005b7          	lui	a1,0x10000
    800007f0:	8526                	mv	a0,s1
    800007f2:	00000097          	auipc	ra,0x0
    800007f6:	fa0080e7          	jalr	-96(ra) # 80000792 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007fa:	4719                	li	a4,6
    800007fc:	6685                	lui	a3,0x1
    800007fe:	10001637          	lui	a2,0x10001
    80000802:	100015b7          	lui	a1,0x10001
    80000806:	8526                	mv	a0,s1
    80000808:	00000097          	auipc	ra,0x0
    8000080c:	f8a080e7          	jalr	-118(ra) # 80000792 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000810:	4719                	li	a4,6
    80000812:	004006b7          	lui	a3,0x400
    80000816:	0c000637          	lui	a2,0xc000
    8000081a:	0c0005b7          	lui	a1,0xc000
    8000081e:	8526                	mv	a0,s1
    80000820:	00000097          	auipc	ra,0x0
    80000824:	f72080e7          	jalr	-142(ra) # 80000792 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000828:	00007917          	auipc	s2,0x7
    8000082c:	7d890913          	addi	s2,s2,2008 # 80008000 <etext>
    80000830:	4729                	li	a4,10
    80000832:	80007697          	auipc	a3,0x80007
    80000836:	7ce68693          	addi	a3,a3,1998 # 8000 <_entry-0x7fff8000>
    8000083a:	4605                	li	a2,1
    8000083c:	067e                	slli	a2,a2,0x1f
    8000083e:	85b2                	mv	a1,a2
    80000840:	8526                	mv	a0,s1
    80000842:	00000097          	auipc	ra,0x0
    80000846:	f50080e7          	jalr	-176(ra) # 80000792 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000084a:	4719                	li	a4,6
    8000084c:	46c5                	li	a3,17
    8000084e:	06ee                	slli	a3,a3,0x1b
    80000850:	412686b3          	sub	a3,a3,s2
    80000854:	864a                	mv	a2,s2
    80000856:	85ca                	mv	a1,s2
    80000858:	8526                	mv	a0,s1
    8000085a:	00000097          	auipc	ra,0x0
    8000085e:	f38080e7          	jalr	-200(ra) # 80000792 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000862:	4729                	li	a4,10
    80000864:	6685                	lui	a3,0x1
    80000866:	00006617          	auipc	a2,0x6
    8000086a:	79a60613          	addi	a2,a2,1946 # 80007000 <_trampoline>
    8000086e:	040005b7          	lui	a1,0x4000
    80000872:	15fd                	addi	a1,a1,-1
    80000874:	05b2                	slli	a1,a1,0xc
    80000876:	8526                	mv	a0,s1
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	f1a080e7          	jalr	-230(ra) # 80000792 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000880:	8526                	mv	a0,s1
    80000882:	00000097          	auipc	ra,0x0
    80000886:	5fe080e7          	jalr	1534(ra) # 80000e80 <proc_mapstacks>
}
    8000088a:	8526                	mv	a0,s1
    8000088c:	60e2                	ld	ra,24(sp)
    8000088e:	6442                	ld	s0,16(sp)
    80000890:	64a2                	ld	s1,8(sp)
    80000892:	6902                	ld	s2,0(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret

0000000080000898 <kvminit>:
{
    80000898:	1141                	addi	sp,sp,-16
    8000089a:	e406                	sd	ra,8(sp)
    8000089c:	e022                	sd	s0,0(sp)
    8000089e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800008a0:	00000097          	auipc	ra,0x0
    800008a4:	f22080e7          	jalr	-222(ra) # 800007c2 <kvmmake>
    800008a8:	00008797          	auipc	a5,0x8
    800008ac:	76a7b023          	sd	a0,1888(a5) # 80009008 <kernel_pagetable>
}
    800008b0:	60a2                	ld	ra,8(sp)
    800008b2:	6402                	ld	s0,0(sp)
    800008b4:	0141                	addi	sp,sp,16
    800008b6:	8082                	ret

00000000800008b8 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800008b8:	715d                	addi	sp,sp,-80
    800008ba:	e486                	sd	ra,72(sp)
    800008bc:	e0a2                	sd	s0,64(sp)
    800008be:	fc26                	sd	s1,56(sp)
    800008c0:	f84a                	sd	s2,48(sp)
    800008c2:	f44e                	sd	s3,40(sp)
    800008c4:	f052                	sd	s4,32(sp)
    800008c6:	ec56                	sd	s5,24(sp)
    800008c8:	e85a                	sd	s6,16(sp)
    800008ca:	e45e                	sd	s7,8(sp)
    800008cc:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800008ce:	03459793          	slli	a5,a1,0x34
    800008d2:	e795                	bnez	a5,800008fe <uvmunmap+0x46>
    800008d4:	8a2a                	mv	s4,a0
    800008d6:	892e                	mv	s2,a1
    800008d8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008da:	0632                	slli	a2,a2,0xc
    800008dc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800008e0:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008e2:	6b05                	lui	s6,0x1
    800008e4:	0735e863          	bltu	a1,s3,80000954 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    800008e8:	60a6                	ld	ra,72(sp)
    800008ea:	6406                	ld	s0,64(sp)
    800008ec:	74e2                	ld	s1,56(sp)
    800008ee:	7942                	ld	s2,48(sp)
    800008f0:	79a2                	ld	s3,40(sp)
    800008f2:	7a02                	ld	s4,32(sp)
    800008f4:	6ae2                	ld	s5,24(sp)
    800008f6:	6b42                	ld	s6,16(sp)
    800008f8:	6ba2                	ld	s7,8(sp)
    800008fa:	6161                	addi	sp,sp,80
    800008fc:	8082                	ret
    panic("uvmunmap: not aligned");
    800008fe:	00007517          	auipc	a0,0x7
    80000902:	78a50513          	addi	a0,a0,1930 # 80008088 <etext+0x88>
    80000906:	00006097          	auipc	ra,0x6
    8000090a:	926080e7          	jalr	-1754(ra) # 8000622c <panic>
      panic("uvmunmap: walk");
    8000090e:	00007517          	auipc	a0,0x7
    80000912:	79250513          	addi	a0,a0,1938 # 800080a0 <etext+0xa0>
    80000916:	00006097          	auipc	ra,0x6
    8000091a:	916080e7          	jalr	-1770(ra) # 8000622c <panic>
      panic("uvmunmap: not mapped");
    8000091e:	00007517          	auipc	a0,0x7
    80000922:	79250513          	addi	a0,a0,1938 # 800080b0 <etext+0xb0>
    80000926:	00006097          	auipc	ra,0x6
    8000092a:	906080e7          	jalr	-1786(ra) # 8000622c <panic>
      panic("uvmunmap: not a leaf");
    8000092e:	00007517          	auipc	a0,0x7
    80000932:	79a50513          	addi	a0,a0,1946 # 800080c8 <etext+0xc8>
    80000936:	00006097          	auipc	ra,0x6
    8000093a:	8f6080e7          	jalr	-1802(ra) # 8000622c <panic>
      uint64 pa = PTE2PA(*pte);
    8000093e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000940:	0532                	slli	a0,a0,0xc
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
    *pte = 0;
    8000094a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000094e:	995a                	add	s2,s2,s6
    80000950:	f9397ce3          	bgeu	s2,s3,800008e8 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000954:	4601                	li	a2,0
    80000956:	85ca                	mv	a1,s2
    80000958:	8552                	mv	a0,s4
    8000095a:	00000097          	auipc	ra,0x0
    8000095e:	cb0080e7          	jalr	-848(ra) # 8000060a <walk>
    80000962:	84aa                	mv	s1,a0
    80000964:	d54d                	beqz	a0,8000090e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80000966:	6108                	ld	a0,0(a0)
    80000968:	00157793          	andi	a5,a0,1
    8000096c:	dbcd                	beqz	a5,8000091e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000096e:	3ff57793          	andi	a5,a0,1023
    80000972:	fb778ee3          	beq	a5,s7,8000092e <uvmunmap+0x76>
    if(do_free){
    80000976:	fc0a8ae3          	beqz	s5,8000094a <uvmunmap+0x92>
    8000097a:	b7d1                	j	8000093e <uvmunmap+0x86>

000000008000097c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000097c:	1101                	addi	sp,sp,-32
    8000097e:	ec06                	sd	ra,24(sp)
    80000980:	e822                	sd	s0,16(sp)
    80000982:	e426                	sd	s1,8(sp)
    80000984:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000986:	00000097          	auipc	ra,0x0
    8000098a:	8c8080e7          	jalr	-1848(ra) # 8000024e <kalloc>
    8000098e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000990:	c519                	beqz	a0,8000099e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000992:	6605                	lui	a2,0x1
    80000994:	4581                	li	a1,0
    80000996:	00000097          	auipc	ra,0x0
    8000099a:	97c080e7          	jalr	-1668(ra) # 80000312 <memset>
  return pagetable;
}
    8000099e:	8526                	mv	a0,s1
    800009a0:	60e2                	ld	ra,24(sp)
    800009a2:	6442                	ld	s0,16(sp)
    800009a4:	64a2                	ld	s1,8(sp)
    800009a6:	6105                	addi	sp,sp,32
    800009a8:	8082                	ret

00000000800009aa <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800009aa:	7179                	addi	sp,sp,-48
    800009ac:	f406                	sd	ra,40(sp)
    800009ae:	f022                	sd	s0,32(sp)
    800009b0:	ec26                	sd	s1,24(sp)
    800009b2:	e84a                	sd	s2,16(sp)
    800009b4:	e44e                	sd	s3,8(sp)
    800009b6:	e052                	sd	s4,0(sp)
    800009b8:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800009ba:	6785                	lui	a5,0x1
    800009bc:	04f67863          	bgeu	a2,a5,80000a0c <uvminit+0x62>
    800009c0:	8a2a                	mv	s4,a0
    800009c2:	89ae                	mv	s3,a1
    800009c4:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	888080e7          	jalr	-1912(ra) # 8000024e <kalloc>
    800009ce:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800009d0:	6605                	lui	a2,0x1
    800009d2:	4581                	li	a1,0
    800009d4:	00000097          	auipc	ra,0x0
    800009d8:	93e080e7          	jalr	-1730(ra) # 80000312 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800009dc:	4779                	li	a4,30
    800009de:	86ca                	mv	a3,s2
    800009e0:	6605                	lui	a2,0x1
    800009e2:	4581                	li	a1,0
    800009e4:	8552                	mv	a0,s4
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	d0c080e7          	jalr	-756(ra) # 800006f2 <mappages>
  memmove(mem, src, sz);
    800009ee:	8626                	mv	a2,s1
    800009f0:	85ce                	mv	a1,s3
    800009f2:	854a                	mv	a0,s2
    800009f4:	00000097          	auipc	ra,0x0
    800009f8:	97e080e7          	jalr	-1666(ra) # 80000372 <memmove>
}
    800009fc:	70a2                	ld	ra,40(sp)
    800009fe:	7402                	ld	s0,32(sp)
    80000a00:	64e2                	ld	s1,24(sp)
    80000a02:	6942                	ld	s2,16(sp)
    80000a04:	69a2                	ld	s3,8(sp)
    80000a06:	6a02                	ld	s4,0(sp)
    80000a08:	6145                	addi	sp,sp,48
    80000a0a:	8082                	ret
    panic("inituvm: more than a page");
    80000a0c:	00007517          	auipc	a0,0x7
    80000a10:	6d450513          	addi	a0,a0,1748 # 800080e0 <etext+0xe0>
    80000a14:	00006097          	auipc	ra,0x6
    80000a18:	818080e7          	jalr	-2024(ra) # 8000622c <panic>

0000000080000a1c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000a1c:	1101                	addi	sp,sp,-32
    80000a1e:	ec06                	sd	ra,24(sp)
    80000a20:	e822                	sd	s0,16(sp)
    80000a22:	e426                	sd	s1,8(sp)
    80000a24:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000a26:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000a28:	00b67d63          	bgeu	a2,a1,80000a42 <uvmdealloc+0x26>
    80000a2c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000a2e:	6785                	lui	a5,0x1
    80000a30:	17fd                	addi	a5,a5,-1
    80000a32:	00f60733          	add	a4,a2,a5
    80000a36:	767d                	lui	a2,0xfffff
    80000a38:	8f71                	and	a4,a4,a2
    80000a3a:	97ae                	add	a5,a5,a1
    80000a3c:	8ff1                	and	a5,a5,a2
    80000a3e:	00f76863          	bltu	a4,a5,80000a4e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a42:	8526                	mv	a0,s1
    80000a44:	60e2                	ld	ra,24(sp)
    80000a46:	6442                	ld	s0,16(sp)
    80000a48:	64a2                	ld	s1,8(sp)
    80000a4a:	6105                	addi	sp,sp,32
    80000a4c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a4e:	8f99                	sub	a5,a5,a4
    80000a50:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a52:	4685                	li	a3,1
    80000a54:	0007861b          	sext.w	a2,a5
    80000a58:	85ba                	mv	a1,a4
    80000a5a:	00000097          	auipc	ra,0x0
    80000a5e:	e5e080e7          	jalr	-418(ra) # 800008b8 <uvmunmap>
    80000a62:	b7c5                	j	80000a42 <uvmdealloc+0x26>

0000000080000a64 <uvmalloc>:
  if(newsz < oldsz)
    80000a64:	0ab66163          	bltu	a2,a1,80000b06 <uvmalloc+0xa2>
{
    80000a68:	7139                	addi	sp,sp,-64
    80000a6a:	fc06                	sd	ra,56(sp)
    80000a6c:	f822                	sd	s0,48(sp)
    80000a6e:	f426                	sd	s1,40(sp)
    80000a70:	f04a                	sd	s2,32(sp)
    80000a72:	ec4e                	sd	s3,24(sp)
    80000a74:	e852                	sd	s4,16(sp)
    80000a76:	e456                	sd	s5,8(sp)
    80000a78:	0080                	addi	s0,sp,64
    80000a7a:	8aaa                	mv	s5,a0
    80000a7c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a7e:	6985                	lui	s3,0x1
    80000a80:	19fd                	addi	s3,s3,-1
    80000a82:	95ce                	add	a1,a1,s3
    80000a84:	79fd                	lui	s3,0xfffff
    80000a86:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a8a:	08c9f063          	bgeu	s3,a2,80000b0a <uvmalloc+0xa6>
    80000a8e:	894e                	mv	s2,s3
    mem = kalloc();
    80000a90:	fffff097          	auipc	ra,0xfffff
    80000a94:	7be080e7          	jalr	1982(ra) # 8000024e <kalloc>
    80000a98:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a9a:	c51d                	beqz	a0,80000ac8 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a9c:	6605                	lui	a2,0x1
    80000a9e:	4581                	li	a1,0
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	872080e7          	jalr	-1934(ra) # 80000312 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000aa8:	4779                	li	a4,30
    80000aaa:	86a6                	mv	a3,s1
    80000aac:	6605                	lui	a2,0x1
    80000aae:	85ca                	mv	a1,s2
    80000ab0:	8556                	mv	a0,s5
    80000ab2:	00000097          	auipc	ra,0x0
    80000ab6:	c40080e7          	jalr	-960(ra) # 800006f2 <mappages>
    80000aba:	e905                	bnez	a0,80000aea <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000abc:	6785                	lui	a5,0x1
    80000abe:	993e                	add	s2,s2,a5
    80000ac0:	fd4968e3          	bltu	s2,s4,80000a90 <uvmalloc+0x2c>
  return newsz;
    80000ac4:	8552                	mv	a0,s4
    80000ac6:	a809                	j	80000ad8 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000ac8:	864e                	mv	a2,s3
    80000aca:	85ca                	mv	a1,s2
    80000acc:	8556                	mv	a0,s5
    80000ace:	00000097          	auipc	ra,0x0
    80000ad2:	f4e080e7          	jalr	-178(ra) # 80000a1c <uvmdealloc>
      return 0;
    80000ad6:	4501                	li	a0,0
}
    80000ad8:	70e2                	ld	ra,56(sp)
    80000ada:	7442                	ld	s0,48(sp)
    80000adc:	74a2                	ld	s1,40(sp)
    80000ade:	7902                	ld	s2,32(sp)
    80000ae0:	69e2                	ld	s3,24(sp)
    80000ae2:	6a42                	ld	s4,16(sp)
    80000ae4:	6aa2                	ld	s5,8(sp)
    80000ae6:	6121                	addi	sp,sp,64
    80000ae8:	8082                	ret
      kfree(mem);
    80000aea:	8526                	mv	a0,s1
    80000aec:	fffff097          	auipc	ra,0xfffff
    80000af0:	530080e7          	jalr	1328(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000af4:	864e                	mv	a2,s3
    80000af6:	85ca                	mv	a1,s2
    80000af8:	8556                	mv	a0,s5
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	f22080e7          	jalr	-222(ra) # 80000a1c <uvmdealloc>
      return 0;
    80000b02:	4501                	li	a0,0
    80000b04:	bfd1                	j	80000ad8 <uvmalloc+0x74>
    return oldsz;
    80000b06:	852e                	mv	a0,a1
}
    80000b08:	8082                	ret
  return newsz;
    80000b0a:	8532                	mv	a0,a2
    80000b0c:	b7f1                	j	80000ad8 <uvmalloc+0x74>

0000000080000b0e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000b0e:	7179                	addi	sp,sp,-48
    80000b10:	f406                	sd	ra,40(sp)
    80000b12:	f022                	sd	s0,32(sp)
    80000b14:	ec26                	sd	s1,24(sp)
    80000b16:	e84a                	sd	s2,16(sp)
    80000b18:	e44e                	sd	s3,8(sp)
    80000b1a:	e052                	sd	s4,0(sp)
    80000b1c:	1800                	addi	s0,sp,48
    80000b1e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000b20:	84aa                	mv	s1,a0
    80000b22:	6905                	lui	s2,0x1
    80000b24:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b26:	4985                	li	s3,1
    80000b28:	a821                	j	80000b40 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000b2a:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000b2c:	0532                	slli	a0,a0,0xc
    80000b2e:	00000097          	auipc	ra,0x0
    80000b32:	fe0080e7          	jalr	-32(ra) # 80000b0e <freewalk>
      pagetable[i] = 0;
    80000b36:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b3a:	04a1                	addi	s1,s1,8
    80000b3c:	03248163          	beq	s1,s2,80000b5e <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000b40:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b42:	00f57793          	andi	a5,a0,15
    80000b46:	ff3782e3          	beq	a5,s3,80000b2a <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b4a:	8905                	andi	a0,a0,1
    80000b4c:	d57d                	beqz	a0,80000b3a <freewalk+0x2c>
      panic("freewalk: leaf");
    80000b4e:	00007517          	auipc	a0,0x7
    80000b52:	5b250513          	addi	a0,a0,1458 # 80008100 <etext+0x100>
    80000b56:	00005097          	auipc	ra,0x5
    80000b5a:	6d6080e7          	jalr	1750(ra) # 8000622c <panic>
    }
  }
  kfree((void*)pagetable);
    80000b5e:	8552                	mv	a0,s4
    80000b60:	fffff097          	auipc	ra,0xfffff
    80000b64:	4bc080e7          	jalr	1212(ra) # 8000001c <kfree>
}
    80000b68:	70a2                	ld	ra,40(sp)
    80000b6a:	7402                	ld	s0,32(sp)
    80000b6c:	64e2                	ld	s1,24(sp)
    80000b6e:	6942                	ld	s2,16(sp)
    80000b70:	69a2                	ld	s3,8(sp)
    80000b72:	6a02                	ld	s4,0(sp)
    80000b74:	6145                	addi	sp,sp,48
    80000b76:	8082                	ret

0000000080000b78 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b78:	1101                	addi	sp,sp,-32
    80000b7a:	ec06                	sd	ra,24(sp)
    80000b7c:	e822                	sd	s0,16(sp)
    80000b7e:	e426                	sd	s1,8(sp)
    80000b80:	1000                	addi	s0,sp,32
    80000b82:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b84:	e999                	bnez	a1,80000b9a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b86:	8526                	mv	a0,s1
    80000b88:	00000097          	auipc	ra,0x0
    80000b8c:	f86080e7          	jalr	-122(ra) # 80000b0e <freewalk>
}
    80000b90:	60e2                	ld	ra,24(sp)
    80000b92:	6442                	ld	s0,16(sp)
    80000b94:	64a2                	ld	s1,8(sp)
    80000b96:	6105                	addi	sp,sp,32
    80000b98:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b9a:	6605                	lui	a2,0x1
    80000b9c:	167d                	addi	a2,a2,-1
    80000b9e:	962e                	add	a2,a2,a1
    80000ba0:	4685                	li	a3,1
    80000ba2:	8231                	srli	a2,a2,0xc
    80000ba4:	4581                	li	a1,0
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	d12080e7          	jalr	-750(ra) # 800008b8 <uvmunmap>
    80000bae:	bfe1                	j	80000b86 <uvmfree+0xe>

0000000080000bb0 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000bb0:	c679                	beqz	a2,80000c7e <uvmcopy+0xce>
{
    80000bb2:	715d                	addi	sp,sp,-80
    80000bb4:	e486                	sd	ra,72(sp)
    80000bb6:	e0a2                	sd	s0,64(sp)
    80000bb8:	fc26                	sd	s1,56(sp)
    80000bba:	f84a                	sd	s2,48(sp)
    80000bbc:	f44e                	sd	s3,40(sp)
    80000bbe:	f052                	sd	s4,32(sp)
    80000bc0:	ec56                	sd	s5,24(sp)
    80000bc2:	e85a                	sd	s6,16(sp)
    80000bc4:	e45e                	sd	s7,8(sp)
    80000bc6:	0880                	addi	s0,sp,80
    80000bc8:	8b2a                	mv	s6,a0
    80000bca:	8aae                	mv	s5,a1
    80000bcc:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000bce:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000bd0:	4601                	li	a2,0
    80000bd2:	85ce                	mv	a1,s3
    80000bd4:	855a                	mv	a0,s6
    80000bd6:	00000097          	auipc	ra,0x0
    80000bda:	a34080e7          	jalr	-1484(ra) # 8000060a <walk>
    80000bde:	c531                	beqz	a0,80000c2a <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000be0:	6118                	ld	a4,0(a0)
    80000be2:	00177793          	andi	a5,a4,1
    80000be6:	cbb1                	beqz	a5,80000c3a <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000be8:	00a75593          	srli	a1,a4,0xa
    80000bec:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000bf0:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000bf4:	fffff097          	auipc	ra,0xfffff
    80000bf8:	65a080e7          	jalr	1626(ra) # 8000024e <kalloc>
    80000bfc:	892a                	mv	s2,a0
    80000bfe:	c939                	beqz	a0,80000c54 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000c00:	6605                	lui	a2,0x1
    80000c02:	85de                	mv	a1,s7
    80000c04:	fffff097          	auipc	ra,0xfffff
    80000c08:	76e080e7          	jalr	1902(ra) # 80000372 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000c0c:	8726                	mv	a4,s1
    80000c0e:	86ca                	mv	a3,s2
    80000c10:	6605                	lui	a2,0x1
    80000c12:	85ce                	mv	a1,s3
    80000c14:	8556                	mv	a0,s5
    80000c16:	00000097          	auipc	ra,0x0
    80000c1a:	adc080e7          	jalr	-1316(ra) # 800006f2 <mappages>
    80000c1e:	e515                	bnez	a0,80000c4a <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000c20:	6785                	lui	a5,0x1
    80000c22:	99be                	add	s3,s3,a5
    80000c24:	fb49e6e3          	bltu	s3,s4,80000bd0 <uvmcopy+0x20>
    80000c28:	a081                	j	80000c68 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000c2a:	00007517          	auipc	a0,0x7
    80000c2e:	4e650513          	addi	a0,a0,1254 # 80008110 <etext+0x110>
    80000c32:	00005097          	auipc	ra,0x5
    80000c36:	5fa080e7          	jalr	1530(ra) # 8000622c <panic>
      panic("uvmcopy: page not present");
    80000c3a:	00007517          	auipc	a0,0x7
    80000c3e:	4f650513          	addi	a0,a0,1270 # 80008130 <etext+0x130>
    80000c42:	00005097          	auipc	ra,0x5
    80000c46:	5ea080e7          	jalr	1514(ra) # 8000622c <panic>
      kfree(mem);
    80000c4a:	854a                	mv	a0,s2
    80000c4c:	fffff097          	auipc	ra,0xfffff
    80000c50:	3d0080e7          	jalr	976(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c54:	4685                	li	a3,1
    80000c56:	00c9d613          	srli	a2,s3,0xc
    80000c5a:	4581                	li	a1,0
    80000c5c:	8556                	mv	a0,s5
    80000c5e:	00000097          	auipc	ra,0x0
    80000c62:	c5a080e7          	jalr	-934(ra) # 800008b8 <uvmunmap>
  return -1;
    80000c66:	557d                	li	a0,-1
}
    80000c68:	60a6                	ld	ra,72(sp)
    80000c6a:	6406                	ld	s0,64(sp)
    80000c6c:	74e2                	ld	s1,56(sp)
    80000c6e:	7942                	ld	s2,48(sp)
    80000c70:	79a2                	ld	s3,40(sp)
    80000c72:	7a02                	ld	s4,32(sp)
    80000c74:	6ae2                	ld	s5,24(sp)
    80000c76:	6b42                	ld	s6,16(sp)
    80000c78:	6ba2                	ld	s7,8(sp)
    80000c7a:	6161                	addi	sp,sp,80
    80000c7c:	8082                	ret
  return 0;
    80000c7e:	4501                	li	a0,0
}
    80000c80:	8082                	ret

0000000080000c82 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c82:	1141                	addi	sp,sp,-16
    80000c84:	e406                	sd	ra,8(sp)
    80000c86:	e022                	sd	s0,0(sp)
    80000c88:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c8a:	4601                	li	a2,0
    80000c8c:	00000097          	auipc	ra,0x0
    80000c90:	97e080e7          	jalr	-1666(ra) # 8000060a <walk>
  if(pte == 0)
    80000c94:	c901                	beqz	a0,80000ca4 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c96:	611c                	ld	a5,0(a0)
    80000c98:	9bbd                	andi	a5,a5,-17
    80000c9a:	e11c                	sd	a5,0(a0)
}
    80000c9c:	60a2                	ld	ra,8(sp)
    80000c9e:	6402                	ld	s0,0(sp)
    80000ca0:	0141                	addi	sp,sp,16
    80000ca2:	8082                	ret
    panic("uvmclear");
    80000ca4:	00007517          	auipc	a0,0x7
    80000ca8:	4ac50513          	addi	a0,a0,1196 # 80008150 <etext+0x150>
    80000cac:	00005097          	auipc	ra,0x5
    80000cb0:	580080e7          	jalr	1408(ra) # 8000622c <panic>

0000000080000cb4 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cb4:	c6bd                	beqz	a3,80000d22 <copyout+0x6e>
{
    80000cb6:	715d                	addi	sp,sp,-80
    80000cb8:	e486                	sd	ra,72(sp)
    80000cba:	e0a2                	sd	s0,64(sp)
    80000cbc:	fc26                	sd	s1,56(sp)
    80000cbe:	f84a                	sd	s2,48(sp)
    80000cc0:	f44e                	sd	s3,40(sp)
    80000cc2:	f052                	sd	s4,32(sp)
    80000cc4:	ec56                	sd	s5,24(sp)
    80000cc6:	e85a                	sd	s6,16(sp)
    80000cc8:	e45e                	sd	s7,8(sp)
    80000cca:	e062                	sd	s8,0(sp)
    80000ccc:	0880                	addi	s0,sp,80
    80000cce:	8b2a                	mv	s6,a0
    80000cd0:	8c2e                	mv	s8,a1
    80000cd2:	8a32                	mv	s4,a2
    80000cd4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000cd6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000cd8:	6a85                	lui	s5,0x1
    80000cda:	a015                	j	80000cfe <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000cdc:	9562                	add	a0,a0,s8
    80000cde:	0004861b          	sext.w	a2,s1
    80000ce2:	85d2                	mv	a1,s4
    80000ce4:	41250533          	sub	a0,a0,s2
    80000ce8:	fffff097          	auipc	ra,0xfffff
    80000cec:	68a080e7          	jalr	1674(ra) # 80000372 <memmove>

    len -= n;
    80000cf0:	409989b3          	sub	s3,s3,s1
    src += n;
    80000cf4:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000cf6:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000cfa:	02098263          	beqz	s3,80000d1e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000cfe:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d02:	85ca                	mv	a1,s2
    80000d04:	855a                	mv	a0,s6
    80000d06:	00000097          	auipc	ra,0x0
    80000d0a:	9aa080e7          	jalr	-1622(ra) # 800006b0 <walkaddr>
    if(pa0 == 0)
    80000d0e:	cd01                	beqz	a0,80000d26 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000d10:	418904b3          	sub	s1,s2,s8
    80000d14:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d16:	fc99f3e3          	bgeu	s3,s1,80000cdc <copyout+0x28>
    80000d1a:	84ce                	mv	s1,s3
    80000d1c:	b7c1                	j	80000cdc <copyout+0x28>
  }
  return 0;
    80000d1e:	4501                	li	a0,0
    80000d20:	a021                	j	80000d28 <copyout+0x74>
    80000d22:	4501                	li	a0,0
}
    80000d24:	8082                	ret
      return -1;
    80000d26:	557d                	li	a0,-1
}
    80000d28:	60a6                	ld	ra,72(sp)
    80000d2a:	6406                	ld	s0,64(sp)
    80000d2c:	74e2                	ld	s1,56(sp)
    80000d2e:	7942                	ld	s2,48(sp)
    80000d30:	79a2                	ld	s3,40(sp)
    80000d32:	7a02                	ld	s4,32(sp)
    80000d34:	6ae2                	ld	s5,24(sp)
    80000d36:	6b42                	ld	s6,16(sp)
    80000d38:	6ba2                	ld	s7,8(sp)
    80000d3a:	6c02                	ld	s8,0(sp)
    80000d3c:	6161                	addi	sp,sp,80
    80000d3e:	8082                	ret

0000000080000d40 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d40:	c6bd                	beqz	a3,80000dae <copyin+0x6e>
{
    80000d42:	715d                	addi	sp,sp,-80
    80000d44:	e486                	sd	ra,72(sp)
    80000d46:	e0a2                	sd	s0,64(sp)
    80000d48:	fc26                	sd	s1,56(sp)
    80000d4a:	f84a                	sd	s2,48(sp)
    80000d4c:	f44e                	sd	s3,40(sp)
    80000d4e:	f052                	sd	s4,32(sp)
    80000d50:	ec56                	sd	s5,24(sp)
    80000d52:	e85a                	sd	s6,16(sp)
    80000d54:	e45e                	sd	s7,8(sp)
    80000d56:	e062                	sd	s8,0(sp)
    80000d58:	0880                	addi	s0,sp,80
    80000d5a:	8b2a                	mv	s6,a0
    80000d5c:	8a2e                	mv	s4,a1
    80000d5e:	8c32                	mv	s8,a2
    80000d60:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d62:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d64:	6a85                	lui	s5,0x1
    80000d66:	a015                	j	80000d8a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d68:	9562                	add	a0,a0,s8
    80000d6a:	0004861b          	sext.w	a2,s1
    80000d6e:	412505b3          	sub	a1,a0,s2
    80000d72:	8552                	mv	a0,s4
    80000d74:	fffff097          	auipc	ra,0xfffff
    80000d78:	5fe080e7          	jalr	1534(ra) # 80000372 <memmove>

    len -= n;
    80000d7c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000d80:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000d82:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d86:	02098263          	beqz	s3,80000daa <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000d8a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d8e:	85ca                	mv	a1,s2
    80000d90:	855a                	mv	a0,s6
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	91e080e7          	jalr	-1762(ra) # 800006b0 <walkaddr>
    if(pa0 == 0)
    80000d9a:	cd01                	beqz	a0,80000db2 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000d9c:	418904b3          	sub	s1,s2,s8
    80000da0:	94d6                	add	s1,s1,s5
    if(n > len)
    80000da2:	fc99f3e3          	bgeu	s3,s1,80000d68 <copyin+0x28>
    80000da6:	84ce                	mv	s1,s3
    80000da8:	b7c1                	j	80000d68 <copyin+0x28>
  }
  return 0;
    80000daa:	4501                	li	a0,0
    80000dac:	a021                	j	80000db4 <copyin+0x74>
    80000dae:	4501                	li	a0,0
}
    80000db0:	8082                	ret
      return -1;
    80000db2:	557d                	li	a0,-1
}
    80000db4:	60a6                	ld	ra,72(sp)
    80000db6:	6406                	ld	s0,64(sp)
    80000db8:	74e2                	ld	s1,56(sp)
    80000dba:	7942                	ld	s2,48(sp)
    80000dbc:	79a2                	ld	s3,40(sp)
    80000dbe:	7a02                	ld	s4,32(sp)
    80000dc0:	6ae2                	ld	s5,24(sp)
    80000dc2:	6b42                	ld	s6,16(sp)
    80000dc4:	6ba2                	ld	s7,8(sp)
    80000dc6:	6c02                	ld	s8,0(sp)
    80000dc8:	6161                	addi	sp,sp,80
    80000dca:	8082                	ret

0000000080000dcc <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000dcc:	c6c5                	beqz	a3,80000e74 <copyinstr+0xa8>
{
    80000dce:	715d                	addi	sp,sp,-80
    80000dd0:	e486                	sd	ra,72(sp)
    80000dd2:	e0a2                	sd	s0,64(sp)
    80000dd4:	fc26                	sd	s1,56(sp)
    80000dd6:	f84a                	sd	s2,48(sp)
    80000dd8:	f44e                	sd	s3,40(sp)
    80000dda:	f052                	sd	s4,32(sp)
    80000ddc:	ec56                	sd	s5,24(sp)
    80000dde:	e85a                	sd	s6,16(sp)
    80000de0:	e45e                	sd	s7,8(sp)
    80000de2:	0880                	addi	s0,sp,80
    80000de4:	8a2a                	mv	s4,a0
    80000de6:	8b2e                	mv	s6,a1
    80000de8:	8bb2                	mv	s7,a2
    80000dea:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000dec:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000dee:	6985                	lui	s3,0x1
    80000df0:	a035                	j	80000e1c <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000df2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000df6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000df8:	0017b793          	seqz	a5,a5
    80000dfc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000e00:	60a6                	ld	ra,72(sp)
    80000e02:	6406                	ld	s0,64(sp)
    80000e04:	74e2                	ld	s1,56(sp)
    80000e06:	7942                	ld	s2,48(sp)
    80000e08:	79a2                	ld	s3,40(sp)
    80000e0a:	7a02                	ld	s4,32(sp)
    80000e0c:	6ae2                	ld	s5,24(sp)
    80000e0e:	6b42                	ld	s6,16(sp)
    80000e10:	6ba2                	ld	s7,8(sp)
    80000e12:	6161                	addi	sp,sp,80
    80000e14:	8082                	ret
    srcva = va0 + PGSIZE;
    80000e16:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000e1a:	c8a9                	beqz	s1,80000e6c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000e1c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e20:	85ca                	mv	a1,s2
    80000e22:	8552                	mv	a0,s4
    80000e24:	00000097          	auipc	ra,0x0
    80000e28:	88c080e7          	jalr	-1908(ra) # 800006b0 <walkaddr>
    if(pa0 == 0)
    80000e2c:	c131                	beqz	a0,80000e70 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000e2e:	41790833          	sub	a6,s2,s7
    80000e32:	984e                	add	a6,a6,s3
    if(n > max)
    80000e34:	0104f363          	bgeu	s1,a6,80000e3a <copyinstr+0x6e>
    80000e38:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e3a:	955e                	add	a0,a0,s7
    80000e3c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e40:	fc080be3          	beqz	a6,80000e16 <copyinstr+0x4a>
    80000e44:	985a                	add	a6,a6,s6
    80000e46:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000e48:	41650633          	sub	a2,a0,s6
    80000e4c:	14fd                	addi	s1,s1,-1
    80000e4e:	9b26                	add	s6,s6,s1
    80000e50:	00f60733          	add	a4,a2,a5
    80000e54:	00074703          	lbu	a4,0(a4)
    80000e58:	df49                	beqz	a4,80000df2 <copyinstr+0x26>
        *dst = *p;
    80000e5a:	00e78023          	sb	a4,0(a5)
      --max;
    80000e5e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e62:	0785                	addi	a5,a5,1
    while(n > 0){
    80000e64:	ff0796e3          	bne	a5,a6,80000e50 <copyinstr+0x84>
      dst++;
    80000e68:	8b42                	mv	s6,a6
    80000e6a:	b775                	j	80000e16 <copyinstr+0x4a>
    80000e6c:	4781                	li	a5,0
    80000e6e:	b769                	j	80000df8 <copyinstr+0x2c>
      return -1;
    80000e70:	557d                	li	a0,-1
    80000e72:	b779                	j	80000e00 <copyinstr+0x34>
  int got_null = 0;
    80000e74:	4781                	li	a5,0
  if(got_null){
    80000e76:	0017b793          	seqz	a5,a5
    80000e7a:	40f00533          	neg	a0,a5
}
    80000e7e:	8082                	ret

0000000080000e80 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e80:	7139                	addi	sp,sp,-64
    80000e82:	fc06                	sd	ra,56(sp)
    80000e84:	f822                	sd	s0,48(sp)
    80000e86:	f426                	sd	s1,40(sp)
    80000e88:	f04a                	sd	s2,32(sp)
    80000e8a:	ec4e                	sd	s3,24(sp)
    80000e8c:	e852                	sd	s4,16(sp)
    80000e8e:	e456                	sd	s5,8(sp)
    80000e90:	e05a                	sd	s6,0(sp)
    80000e92:	0080                	addi	s0,sp,64
    80000e94:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e96:	00008497          	auipc	s1,0x8
    80000e9a:	75a48493          	addi	s1,s1,1882 # 800095f0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e9e:	8b26                	mv	s6,s1
    80000ea0:	00007a97          	auipc	s5,0x7
    80000ea4:	160a8a93          	addi	s5,s5,352 # 80008000 <etext>
    80000ea8:	04000937          	lui	s2,0x4000
    80000eac:	197d                	addi	s2,s2,-1
    80000eae:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eb0:	0000ea17          	auipc	s4,0xe
    80000eb4:	340a0a13          	addi	s4,s4,832 # 8000f1f0 <tickslock>
    char *pa = kalloc();
    80000eb8:	fffff097          	auipc	ra,0xfffff
    80000ebc:	396080e7          	jalr	918(ra) # 8000024e <kalloc>
    80000ec0:	862a                	mv	a2,a0
    if(pa == 0)
    80000ec2:	c131                	beqz	a0,80000f06 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000ec4:	416485b3          	sub	a1,s1,s6
    80000ec8:	8591                	srai	a1,a1,0x4
    80000eca:	000ab783          	ld	a5,0(s5)
    80000ece:	02f585b3          	mul	a1,a1,a5
    80000ed2:	2585                	addiw	a1,a1,1
    80000ed4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000ed8:	4719                	li	a4,6
    80000eda:	6685                	lui	a3,0x1
    80000edc:	40b905b3          	sub	a1,s2,a1
    80000ee0:	854e                	mv	a0,s3
    80000ee2:	00000097          	auipc	ra,0x0
    80000ee6:	8b0080e7          	jalr	-1872(ra) # 80000792 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eea:	17048493          	addi	s1,s1,368
    80000eee:	fd4495e3          	bne	s1,s4,80000eb8 <proc_mapstacks+0x38>
  }
}
    80000ef2:	70e2                	ld	ra,56(sp)
    80000ef4:	7442                	ld	s0,48(sp)
    80000ef6:	74a2                	ld	s1,40(sp)
    80000ef8:	7902                	ld	s2,32(sp)
    80000efa:	69e2                	ld	s3,24(sp)
    80000efc:	6a42                	ld	s4,16(sp)
    80000efe:	6aa2                	ld	s5,8(sp)
    80000f00:	6b02                	ld	s6,0(sp)
    80000f02:	6121                	addi	sp,sp,64
    80000f04:	8082                	ret
      panic("kalloc");
    80000f06:	00007517          	auipc	a0,0x7
    80000f0a:	25a50513          	addi	a0,a0,602 # 80008160 <etext+0x160>
    80000f0e:	00005097          	auipc	ra,0x5
    80000f12:	31e080e7          	jalr	798(ra) # 8000622c <panic>

0000000080000f16 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f16:	7139                	addi	sp,sp,-64
    80000f18:	fc06                	sd	ra,56(sp)
    80000f1a:	f822                	sd	s0,48(sp)
    80000f1c:	f426                	sd	s1,40(sp)
    80000f1e:	f04a                	sd	s2,32(sp)
    80000f20:	ec4e                	sd	s3,24(sp)
    80000f22:	e852                	sd	s4,16(sp)
    80000f24:	e456                	sd	s5,8(sp)
    80000f26:	e05a                	sd	s6,0(sp)
    80000f28:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f2a:	00007597          	auipc	a1,0x7
    80000f2e:	23e58593          	addi	a1,a1,574 # 80008168 <etext+0x168>
    80000f32:	00008517          	auipc	a0,0x8
    80000f36:	27e50513          	addi	a0,a0,638 # 800091b0 <pid_lock>
    80000f3a:	00006097          	auipc	ra,0x6
    80000f3e:	9a2080e7          	jalr	-1630(ra) # 800068dc <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f42:	00007597          	auipc	a1,0x7
    80000f46:	22e58593          	addi	a1,a1,558 # 80008170 <etext+0x170>
    80000f4a:	00008517          	auipc	a0,0x8
    80000f4e:	28650513          	addi	a0,a0,646 # 800091d0 <wait_lock>
    80000f52:	00006097          	auipc	ra,0x6
    80000f56:	98a080e7          	jalr	-1654(ra) # 800068dc <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f5a:	00008497          	auipc	s1,0x8
    80000f5e:	69648493          	addi	s1,s1,1686 # 800095f0 <proc>
      initlock(&p->lock, "proc");
    80000f62:	00007b17          	auipc	s6,0x7
    80000f66:	21eb0b13          	addi	s6,s6,542 # 80008180 <etext+0x180>
      p->kstack = KSTACK((int) (p - proc));
    80000f6a:	8aa6                	mv	s5,s1
    80000f6c:	00007a17          	auipc	s4,0x7
    80000f70:	094a0a13          	addi	s4,s4,148 # 80008000 <etext>
    80000f74:	04000937          	lui	s2,0x4000
    80000f78:	197d                	addi	s2,s2,-1
    80000f7a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f7c:	0000e997          	auipc	s3,0xe
    80000f80:	27498993          	addi	s3,s3,628 # 8000f1f0 <tickslock>
      initlock(&p->lock, "proc");
    80000f84:	85da                	mv	a1,s6
    80000f86:	8526                	mv	a0,s1
    80000f88:	00006097          	auipc	ra,0x6
    80000f8c:	954080e7          	jalr	-1708(ra) # 800068dc <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f90:	415487b3          	sub	a5,s1,s5
    80000f94:	8791                	srai	a5,a5,0x4
    80000f96:	000a3703          	ld	a4,0(s4)
    80000f9a:	02e787b3          	mul	a5,a5,a4
    80000f9e:	2785                	addiw	a5,a5,1
    80000fa0:	00d7979b          	slliw	a5,a5,0xd
    80000fa4:	40f907b3          	sub	a5,s2,a5
    80000fa8:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000faa:	17048493          	addi	s1,s1,368
    80000fae:	fd349be3          	bne	s1,s3,80000f84 <procinit+0x6e>
  }
}
    80000fb2:	70e2                	ld	ra,56(sp)
    80000fb4:	7442                	ld	s0,48(sp)
    80000fb6:	74a2                	ld	s1,40(sp)
    80000fb8:	7902                	ld	s2,32(sp)
    80000fba:	69e2                	ld	s3,24(sp)
    80000fbc:	6a42                	ld	s4,16(sp)
    80000fbe:	6aa2                	ld	s5,8(sp)
    80000fc0:	6b02                	ld	s6,0(sp)
    80000fc2:	6121                	addi	sp,sp,64
    80000fc4:	8082                	ret

0000000080000fc6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000fc6:	1141                	addi	sp,sp,-16
    80000fc8:	e422                	sd	s0,8(sp)
    80000fca:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fcc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fce:	2501                	sext.w	a0,a0
    80000fd0:	6422                	ld	s0,8(sp)
    80000fd2:	0141                	addi	sp,sp,16
    80000fd4:	8082                	ret

0000000080000fd6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000fd6:	1141                	addi	sp,sp,-16
    80000fd8:	e422                	sd	s0,8(sp)
    80000fda:	0800                	addi	s0,sp,16
    80000fdc:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fde:	2781                	sext.w	a5,a5
    80000fe0:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fe2:	00008517          	auipc	a0,0x8
    80000fe6:	20e50513          	addi	a0,a0,526 # 800091f0 <cpus>
    80000fea:	953e                	add	a0,a0,a5
    80000fec:	6422                	ld	s0,8(sp)
    80000fee:	0141                	addi	sp,sp,16
    80000ff0:	8082                	ret

0000000080000ff2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000ff2:	1101                	addi	sp,sp,-32
    80000ff4:	ec06                	sd	ra,24(sp)
    80000ff6:	e822                	sd	s0,16(sp)
    80000ff8:	e426                	sd	s1,8(sp)
    80000ffa:	1000                	addi	s0,sp,32
  push_off();
    80000ffc:	00005097          	auipc	ra,0x5
    80001000:	718080e7          	jalr	1816(ra) # 80006714 <push_off>
    80001004:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001006:	2781                	sext.w	a5,a5
    80001008:	079e                	slli	a5,a5,0x7
    8000100a:	00008717          	auipc	a4,0x8
    8000100e:	1a670713          	addi	a4,a4,422 # 800091b0 <pid_lock>
    80001012:	97ba                	add	a5,a5,a4
    80001014:	63a4                	ld	s1,64(a5)
  pop_off();
    80001016:	00005097          	auipc	ra,0x5
    8000101a:	7ba080e7          	jalr	1978(ra) # 800067d0 <pop_off>
  return p;
}
    8000101e:	8526                	mv	a0,s1
    80001020:	60e2                	ld	ra,24(sp)
    80001022:	6442                	ld	s0,16(sp)
    80001024:	64a2                	ld	s1,8(sp)
    80001026:	6105                	addi	sp,sp,32
    80001028:	8082                	ret

000000008000102a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000102a:	1141                	addi	sp,sp,-16
    8000102c:	e406                	sd	ra,8(sp)
    8000102e:	e022                	sd	s0,0(sp)
    80001030:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001032:	00000097          	auipc	ra,0x0
    80001036:	fc0080e7          	jalr	-64(ra) # 80000ff2 <myproc>
    8000103a:	00005097          	auipc	ra,0x5
    8000103e:	7f6080e7          	jalr	2038(ra) # 80006830 <release>

  if (first) {
    80001042:	00008797          	auipc	a5,0x8
    80001046:	8ae7a783          	lw	a5,-1874(a5) # 800088f0 <first.1688>
    8000104a:	eb89                	bnez	a5,8000105c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    8000104c:	00001097          	auipc	ra,0x1
    80001050:	c0a080e7          	jalr	-1014(ra) # 80001c56 <usertrapret>
}
    80001054:	60a2                	ld	ra,8(sp)
    80001056:	6402                	ld	s0,0(sp)
    80001058:	0141                	addi	sp,sp,16
    8000105a:	8082                	ret
    first = 0;
    8000105c:	00008797          	auipc	a5,0x8
    80001060:	8807aa23          	sw	zero,-1900(a5) # 800088f0 <first.1688>
    fsinit(ROOTDEV);
    80001064:	4505                	li	a0,1
    80001066:	00002097          	auipc	ra,0x2
    8000106a:	b5c080e7          	jalr	-1188(ra) # 80002bc2 <fsinit>
    8000106e:	bff9                	j	8000104c <forkret+0x22>

0000000080001070 <allocpid>:
allocpid() {
    80001070:	1101                	addi	sp,sp,-32
    80001072:	ec06                	sd	ra,24(sp)
    80001074:	e822                	sd	s0,16(sp)
    80001076:	e426                	sd	s1,8(sp)
    80001078:	e04a                	sd	s2,0(sp)
    8000107a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000107c:	00008917          	auipc	s2,0x8
    80001080:	13490913          	addi	s2,s2,308 # 800091b0 <pid_lock>
    80001084:	854a                	mv	a0,s2
    80001086:	00005097          	auipc	ra,0x5
    8000108a:	6da080e7          	jalr	1754(ra) # 80006760 <acquire>
  pid = nextpid;
    8000108e:	00008797          	auipc	a5,0x8
    80001092:	86678793          	addi	a5,a5,-1946 # 800088f4 <nextpid>
    80001096:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001098:	0014871b          	addiw	a4,s1,1
    8000109c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000109e:	854a                	mv	a0,s2
    800010a0:	00005097          	auipc	ra,0x5
    800010a4:	790080e7          	jalr	1936(ra) # 80006830 <release>
}
    800010a8:	8526                	mv	a0,s1
    800010aa:	60e2                	ld	ra,24(sp)
    800010ac:	6442                	ld	s0,16(sp)
    800010ae:	64a2                	ld	s1,8(sp)
    800010b0:	6902                	ld	s2,0(sp)
    800010b2:	6105                	addi	sp,sp,32
    800010b4:	8082                	ret

00000000800010b6 <proc_pagetable>:
{
    800010b6:	1101                	addi	sp,sp,-32
    800010b8:	ec06                	sd	ra,24(sp)
    800010ba:	e822                	sd	s0,16(sp)
    800010bc:	e426                	sd	s1,8(sp)
    800010be:	e04a                	sd	s2,0(sp)
    800010c0:	1000                	addi	s0,sp,32
    800010c2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010c4:	00000097          	auipc	ra,0x0
    800010c8:	8b8080e7          	jalr	-1864(ra) # 8000097c <uvmcreate>
    800010cc:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800010ce:	c121                	beqz	a0,8000110e <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010d0:	4729                	li	a4,10
    800010d2:	00006697          	auipc	a3,0x6
    800010d6:	f2e68693          	addi	a3,a3,-210 # 80007000 <_trampoline>
    800010da:	6605                	lui	a2,0x1
    800010dc:	040005b7          	lui	a1,0x4000
    800010e0:	15fd                	addi	a1,a1,-1
    800010e2:	05b2                	slli	a1,a1,0xc
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	60e080e7          	jalr	1550(ra) # 800006f2 <mappages>
    800010ec:	02054863          	bltz	a0,8000111c <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800010f0:	4719                	li	a4,6
    800010f2:	06093683          	ld	a3,96(s2)
    800010f6:	6605                	lui	a2,0x1
    800010f8:	020005b7          	lui	a1,0x2000
    800010fc:	15fd                	addi	a1,a1,-1
    800010fe:	05b6                	slli	a1,a1,0xd
    80001100:	8526                	mv	a0,s1
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	5f0080e7          	jalr	1520(ra) # 800006f2 <mappages>
    8000110a:	02054163          	bltz	a0,8000112c <proc_pagetable+0x76>
}
    8000110e:	8526                	mv	a0,s1
    80001110:	60e2                	ld	ra,24(sp)
    80001112:	6442                	ld	s0,16(sp)
    80001114:	64a2                	ld	s1,8(sp)
    80001116:	6902                	ld	s2,0(sp)
    80001118:	6105                	addi	sp,sp,32
    8000111a:	8082                	ret
    uvmfree(pagetable, 0);
    8000111c:	4581                	li	a1,0
    8000111e:	8526                	mv	a0,s1
    80001120:	00000097          	auipc	ra,0x0
    80001124:	a58080e7          	jalr	-1448(ra) # 80000b78 <uvmfree>
    return 0;
    80001128:	4481                	li	s1,0
    8000112a:	b7d5                	j	8000110e <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000112c:	4681                	li	a3,0
    8000112e:	4605                	li	a2,1
    80001130:	040005b7          	lui	a1,0x4000
    80001134:	15fd                	addi	a1,a1,-1
    80001136:	05b2                	slli	a1,a1,0xc
    80001138:	8526                	mv	a0,s1
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	77e080e7          	jalr	1918(ra) # 800008b8 <uvmunmap>
    uvmfree(pagetable, 0);
    80001142:	4581                	li	a1,0
    80001144:	8526                	mv	a0,s1
    80001146:	00000097          	auipc	ra,0x0
    8000114a:	a32080e7          	jalr	-1486(ra) # 80000b78 <uvmfree>
    return 0;
    8000114e:	4481                	li	s1,0
    80001150:	bf7d                	j	8000110e <proc_pagetable+0x58>

0000000080001152 <proc_freepagetable>:
{
    80001152:	1101                	addi	sp,sp,-32
    80001154:	ec06                	sd	ra,24(sp)
    80001156:	e822                	sd	s0,16(sp)
    80001158:	e426                	sd	s1,8(sp)
    8000115a:	e04a                	sd	s2,0(sp)
    8000115c:	1000                	addi	s0,sp,32
    8000115e:	84aa                	mv	s1,a0
    80001160:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001162:	4681                	li	a3,0
    80001164:	4605                	li	a2,1
    80001166:	040005b7          	lui	a1,0x4000
    8000116a:	15fd                	addi	a1,a1,-1
    8000116c:	05b2                	slli	a1,a1,0xc
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	74a080e7          	jalr	1866(ra) # 800008b8 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001176:	4681                	li	a3,0
    80001178:	4605                	li	a2,1
    8000117a:	020005b7          	lui	a1,0x2000
    8000117e:	15fd                	addi	a1,a1,-1
    80001180:	05b6                	slli	a1,a1,0xd
    80001182:	8526                	mv	a0,s1
    80001184:	fffff097          	auipc	ra,0xfffff
    80001188:	734080e7          	jalr	1844(ra) # 800008b8 <uvmunmap>
  uvmfree(pagetable, sz);
    8000118c:	85ca                	mv	a1,s2
    8000118e:	8526                	mv	a0,s1
    80001190:	00000097          	auipc	ra,0x0
    80001194:	9e8080e7          	jalr	-1560(ra) # 80000b78 <uvmfree>
}
    80001198:	60e2                	ld	ra,24(sp)
    8000119a:	6442                	ld	s0,16(sp)
    8000119c:	64a2                	ld	s1,8(sp)
    8000119e:	6902                	ld	s2,0(sp)
    800011a0:	6105                	addi	sp,sp,32
    800011a2:	8082                	ret

00000000800011a4 <freeproc>:
{
    800011a4:	1101                	addi	sp,sp,-32
    800011a6:	ec06                	sd	ra,24(sp)
    800011a8:	e822                	sd	s0,16(sp)
    800011aa:	e426                	sd	s1,8(sp)
    800011ac:	1000                	addi	s0,sp,32
    800011ae:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011b0:	7128                	ld	a0,96(a0)
    800011b2:	c509                	beqz	a0,800011bc <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011b4:	fffff097          	auipc	ra,0xfffff
    800011b8:	e68080e7          	jalr	-408(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011bc:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011c0:	6ca8                	ld	a0,88(s1)
    800011c2:	c511                	beqz	a0,800011ce <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    800011c4:	68ac                	ld	a1,80(s1)
    800011c6:	00000097          	auipc	ra,0x0
    800011ca:	f8c080e7          	jalr	-116(ra) # 80001152 <proc_freepagetable>
  p->pagetable = 0;
    800011ce:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    800011d2:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    800011d6:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    800011da:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    800011de:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011e2:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    800011e6:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    800011ea:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800011ee:	0204a023          	sw	zero,32(s1)
}
    800011f2:	60e2                	ld	ra,24(sp)
    800011f4:	6442                	ld	s0,16(sp)
    800011f6:	64a2                	ld	s1,8(sp)
    800011f8:	6105                	addi	sp,sp,32
    800011fa:	8082                	ret

00000000800011fc <allocproc>:
{
    800011fc:	1101                	addi	sp,sp,-32
    800011fe:	ec06                	sd	ra,24(sp)
    80001200:	e822                	sd	s0,16(sp)
    80001202:	e426                	sd	s1,8(sp)
    80001204:	e04a                	sd	s2,0(sp)
    80001206:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001208:	00008497          	auipc	s1,0x8
    8000120c:	3e848493          	addi	s1,s1,1000 # 800095f0 <proc>
    80001210:	0000e917          	auipc	s2,0xe
    80001214:	fe090913          	addi	s2,s2,-32 # 8000f1f0 <tickslock>
    acquire(&p->lock);
    80001218:	8526                	mv	a0,s1
    8000121a:	00005097          	auipc	ra,0x5
    8000121e:	546080e7          	jalr	1350(ra) # 80006760 <acquire>
    if(p->state == UNUSED) {
    80001222:	509c                	lw	a5,32(s1)
    80001224:	cf81                	beqz	a5,8000123c <allocproc+0x40>
      release(&p->lock);
    80001226:	8526                	mv	a0,s1
    80001228:	00005097          	auipc	ra,0x5
    8000122c:	608080e7          	jalr	1544(ra) # 80006830 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001230:	17048493          	addi	s1,s1,368
    80001234:	ff2492e3          	bne	s1,s2,80001218 <allocproc+0x1c>
  return 0;
    80001238:	4481                	li	s1,0
    8000123a:	a889                	j	8000128c <allocproc+0x90>
  p->pid = allocpid();
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	e34080e7          	jalr	-460(ra) # 80001070 <allocpid>
    80001244:	dc88                	sw	a0,56(s1)
  p->state = USED;
    80001246:	4785                	li	a5,1
    80001248:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	004080e7          	jalr	4(ra) # 8000024e <kalloc>
    80001252:	892a                	mv	s2,a0
    80001254:	f0a8                	sd	a0,96(s1)
    80001256:	c131                	beqz	a0,8000129a <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001258:	8526                	mv	a0,s1
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	e5c080e7          	jalr	-420(ra) # 800010b6 <proc_pagetable>
    80001262:	892a                	mv	s2,a0
    80001264:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001266:	c531                	beqz	a0,800012b2 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001268:	07000613          	li	a2,112
    8000126c:	4581                	li	a1,0
    8000126e:	06848513          	addi	a0,s1,104
    80001272:	fffff097          	auipc	ra,0xfffff
    80001276:	0a0080e7          	jalr	160(ra) # 80000312 <memset>
  p->context.ra = (uint64)forkret;
    8000127a:	00000797          	auipc	a5,0x0
    8000127e:	db078793          	addi	a5,a5,-592 # 8000102a <forkret>
    80001282:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001284:	64bc                	ld	a5,72(s1)
    80001286:	6705                	lui	a4,0x1
    80001288:	97ba                	add	a5,a5,a4
    8000128a:	f8bc                	sd	a5,112(s1)
}
    8000128c:	8526                	mv	a0,s1
    8000128e:	60e2                	ld	ra,24(sp)
    80001290:	6442                	ld	s0,16(sp)
    80001292:	64a2                	ld	s1,8(sp)
    80001294:	6902                	ld	s2,0(sp)
    80001296:	6105                	addi	sp,sp,32
    80001298:	8082                	ret
    freeproc(p);
    8000129a:	8526                	mv	a0,s1
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	f08080e7          	jalr	-248(ra) # 800011a4 <freeproc>
    release(&p->lock);
    800012a4:	8526                	mv	a0,s1
    800012a6:	00005097          	auipc	ra,0x5
    800012aa:	58a080e7          	jalr	1418(ra) # 80006830 <release>
    return 0;
    800012ae:	84ca                	mv	s1,s2
    800012b0:	bff1                	j	8000128c <allocproc+0x90>
    freeproc(p);
    800012b2:	8526                	mv	a0,s1
    800012b4:	00000097          	auipc	ra,0x0
    800012b8:	ef0080e7          	jalr	-272(ra) # 800011a4 <freeproc>
    release(&p->lock);
    800012bc:	8526                	mv	a0,s1
    800012be:	00005097          	auipc	ra,0x5
    800012c2:	572080e7          	jalr	1394(ra) # 80006830 <release>
    return 0;
    800012c6:	84ca                	mv	s1,s2
    800012c8:	b7d1                	j	8000128c <allocproc+0x90>

00000000800012ca <userinit>:
{
    800012ca:	1101                	addi	sp,sp,-32
    800012cc:	ec06                	sd	ra,24(sp)
    800012ce:	e822                	sd	s0,16(sp)
    800012d0:	e426                	sd	s1,8(sp)
    800012d2:	1000                	addi	s0,sp,32
  p = allocproc();
    800012d4:	00000097          	auipc	ra,0x0
    800012d8:	f28080e7          	jalr	-216(ra) # 800011fc <allocproc>
    800012dc:	84aa                	mv	s1,a0
  initproc = p;
    800012de:	00008797          	auipc	a5,0x8
    800012e2:	d2a7b923          	sd	a0,-718(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800012e6:	03400613          	li	a2,52
    800012ea:	00007597          	auipc	a1,0x7
    800012ee:	61658593          	addi	a1,a1,1558 # 80008900 <initcode>
    800012f2:	6d28                	ld	a0,88(a0)
    800012f4:	fffff097          	auipc	ra,0xfffff
    800012f8:	6b6080e7          	jalr	1718(ra) # 800009aa <uvminit>
  p->sz = PGSIZE;
    800012fc:	6785                	lui	a5,0x1
    800012fe:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001300:	70b8                	ld	a4,96(s1)
    80001302:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001306:	70b8                	ld	a4,96(s1)
    80001308:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000130a:	4641                	li	a2,16
    8000130c:	00007597          	auipc	a1,0x7
    80001310:	e7c58593          	addi	a1,a1,-388 # 80008188 <etext+0x188>
    80001314:	16048513          	addi	a0,s1,352
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	14c080e7          	jalr	332(ra) # 80000464 <safestrcpy>
  p->cwd = namei("/");
    80001320:	00007517          	auipc	a0,0x7
    80001324:	e7850513          	addi	a0,a0,-392 # 80008198 <etext+0x198>
    80001328:	00002097          	auipc	ra,0x2
    8000132c:	2c8080e7          	jalr	712(ra) # 800035f0 <namei>
    80001330:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001334:	478d                	li	a5,3
    80001336:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001338:	8526                	mv	a0,s1
    8000133a:	00005097          	auipc	ra,0x5
    8000133e:	4f6080e7          	jalr	1270(ra) # 80006830 <release>
}
    80001342:	60e2                	ld	ra,24(sp)
    80001344:	6442                	ld	s0,16(sp)
    80001346:	64a2                	ld	s1,8(sp)
    80001348:	6105                	addi	sp,sp,32
    8000134a:	8082                	ret

000000008000134c <growproc>:
{
    8000134c:	1101                	addi	sp,sp,-32
    8000134e:	ec06                	sd	ra,24(sp)
    80001350:	e822                	sd	s0,16(sp)
    80001352:	e426                	sd	s1,8(sp)
    80001354:	e04a                	sd	s2,0(sp)
    80001356:	1000                	addi	s0,sp,32
    80001358:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000135a:	00000097          	auipc	ra,0x0
    8000135e:	c98080e7          	jalr	-872(ra) # 80000ff2 <myproc>
    80001362:	892a                	mv	s2,a0
  sz = p->sz;
    80001364:	692c                	ld	a1,80(a0)
    80001366:	0005861b          	sext.w	a2,a1
  if(n > 0){
    8000136a:	00904f63          	bgtz	s1,80001388 <growproc+0x3c>
  } else if(n < 0){
    8000136e:	0204cc63          	bltz	s1,800013a6 <growproc+0x5a>
  p->sz = sz;
    80001372:	1602                	slli	a2,a2,0x20
    80001374:	9201                	srli	a2,a2,0x20
    80001376:	04c93823          	sd	a2,80(s2)
  return 0;
    8000137a:	4501                	li	a0,0
}
    8000137c:	60e2                	ld	ra,24(sp)
    8000137e:	6442                	ld	s0,16(sp)
    80001380:	64a2                	ld	s1,8(sp)
    80001382:	6902                	ld	s2,0(sp)
    80001384:	6105                	addi	sp,sp,32
    80001386:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001388:	9e25                	addw	a2,a2,s1
    8000138a:	1602                	slli	a2,a2,0x20
    8000138c:	9201                	srli	a2,a2,0x20
    8000138e:	1582                	slli	a1,a1,0x20
    80001390:	9181                	srli	a1,a1,0x20
    80001392:	6d28                	ld	a0,88(a0)
    80001394:	fffff097          	auipc	ra,0xfffff
    80001398:	6d0080e7          	jalr	1744(ra) # 80000a64 <uvmalloc>
    8000139c:	0005061b          	sext.w	a2,a0
    800013a0:	fa69                	bnez	a2,80001372 <growproc+0x26>
      return -1;
    800013a2:	557d                	li	a0,-1
    800013a4:	bfe1                	j	8000137c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013a6:	9e25                	addw	a2,a2,s1
    800013a8:	1602                	slli	a2,a2,0x20
    800013aa:	9201                	srli	a2,a2,0x20
    800013ac:	1582                	slli	a1,a1,0x20
    800013ae:	9181                	srli	a1,a1,0x20
    800013b0:	6d28                	ld	a0,88(a0)
    800013b2:	fffff097          	auipc	ra,0xfffff
    800013b6:	66a080e7          	jalr	1642(ra) # 80000a1c <uvmdealloc>
    800013ba:	0005061b          	sext.w	a2,a0
    800013be:	bf55                	j	80001372 <growproc+0x26>

00000000800013c0 <fork>:
{
    800013c0:	7179                	addi	sp,sp,-48
    800013c2:	f406                	sd	ra,40(sp)
    800013c4:	f022                	sd	s0,32(sp)
    800013c6:	ec26                	sd	s1,24(sp)
    800013c8:	e84a                	sd	s2,16(sp)
    800013ca:	e44e                	sd	s3,8(sp)
    800013cc:	e052                	sd	s4,0(sp)
    800013ce:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	c22080e7          	jalr	-990(ra) # 80000ff2 <myproc>
    800013d8:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013da:	00000097          	auipc	ra,0x0
    800013de:	e22080e7          	jalr	-478(ra) # 800011fc <allocproc>
    800013e2:	10050b63          	beqz	a0,800014f8 <fork+0x138>
    800013e6:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013e8:	05093603          	ld	a2,80(s2)
    800013ec:	6d2c                	ld	a1,88(a0)
    800013ee:	05893503          	ld	a0,88(s2)
    800013f2:	fffff097          	auipc	ra,0xfffff
    800013f6:	7be080e7          	jalr	1982(ra) # 80000bb0 <uvmcopy>
    800013fa:	04054663          	bltz	a0,80001446 <fork+0x86>
  np->sz = p->sz;
    800013fe:	05093783          	ld	a5,80(s2)
    80001402:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80001406:	06093683          	ld	a3,96(s2)
    8000140a:	87b6                	mv	a5,a3
    8000140c:	0609b703          	ld	a4,96(s3)
    80001410:	12068693          	addi	a3,a3,288
    80001414:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001418:	6788                	ld	a0,8(a5)
    8000141a:	6b8c                	ld	a1,16(a5)
    8000141c:	6f90                	ld	a2,24(a5)
    8000141e:	01073023          	sd	a6,0(a4)
    80001422:	e708                	sd	a0,8(a4)
    80001424:	eb0c                	sd	a1,16(a4)
    80001426:	ef10                	sd	a2,24(a4)
    80001428:	02078793          	addi	a5,a5,32
    8000142c:	02070713          	addi	a4,a4,32
    80001430:	fed792e3          	bne	a5,a3,80001414 <fork+0x54>
  np->trapframe->a0 = 0;
    80001434:	0609b783          	ld	a5,96(s3)
    80001438:	0607b823          	sd	zero,112(a5)
    8000143c:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001440:	15800a13          	li	s4,344
    80001444:	a03d                	j	80001472 <fork+0xb2>
    freeproc(np);
    80001446:	854e                	mv	a0,s3
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	d5c080e7          	jalr	-676(ra) # 800011a4 <freeproc>
    release(&np->lock);
    80001450:	854e                	mv	a0,s3
    80001452:	00005097          	auipc	ra,0x5
    80001456:	3de080e7          	jalr	990(ra) # 80006830 <release>
    return -1;
    8000145a:	5a7d                	li	s4,-1
    8000145c:	a069                	j	800014e6 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000145e:	00003097          	auipc	ra,0x3
    80001462:	828080e7          	jalr	-2008(ra) # 80003c86 <filedup>
    80001466:	009987b3          	add	a5,s3,s1
    8000146a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    8000146c:	04a1                	addi	s1,s1,8
    8000146e:	01448763          	beq	s1,s4,8000147c <fork+0xbc>
    if(p->ofile[i])
    80001472:	009907b3          	add	a5,s2,s1
    80001476:	6388                	ld	a0,0(a5)
    80001478:	f17d                	bnez	a0,8000145e <fork+0x9e>
    8000147a:	bfcd                	j	8000146c <fork+0xac>
  np->cwd = idup(p->cwd);
    8000147c:	15893503          	ld	a0,344(s2)
    80001480:	00002097          	auipc	ra,0x2
    80001484:	97c080e7          	jalr	-1668(ra) # 80002dfc <idup>
    80001488:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000148c:	4641                	li	a2,16
    8000148e:	16090593          	addi	a1,s2,352
    80001492:	16098513          	addi	a0,s3,352
    80001496:	fffff097          	auipc	ra,0xfffff
    8000149a:	fce080e7          	jalr	-50(ra) # 80000464 <safestrcpy>
  pid = np->pid;
    8000149e:	0389aa03          	lw	s4,56(s3)
  release(&np->lock);
    800014a2:	854e                	mv	a0,s3
    800014a4:	00005097          	auipc	ra,0x5
    800014a8:	38c080e7          	jalr	908(ra) # 80006830 <release>
  acquire(&wait_lock);
    800014ac:	00008497          	auipc	s1,0x8
    800014b0:	d2448493          	addi	s1,s1,-732 # 800091d0 <wait_lock>
    800014b4:	8526                	mv	a0,s1
    800014b6:	00005097          	auipc	ra,0x5
    800014ba:	2aa080e7          	jalr	682(ra) # 80006760 <acquire>
  np->parent = p;
    800014be:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    800014c2:	8526                	mv	a0,s1
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	36c080e7          	jalr	876(ra) # 80006830 <release>
  acquire(&np->lock);
    800014cc:	854e                	mv	a0,s3
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	292080e7          	jalr	658(ra) # 80006760 <acquire>
  np->state = RUNNABLE;
    800014d6:	478d                	li	a5,3
    800014d8:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    800014dc:	854e                	mv	a0,s3
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	352080e7          	jalr	850(ra) # 80006830 <release>
}
    800014e6:	8552                	mv	a0,s4
    800014e8:	70a2                	ld	ra,40(sp)
    800014ea:	7402                	ld	s0,32(sp)
    800014ec:	64e2                	ld	s1,24(sp)
    800014ee:	6942                	ld	s2,16(sp)
    800014f0:	69a2                	ld	s3,8(sp)
    800014f2:	6a02                	ld	s4,0(sp)
    800014f4:	6145                	addi	sp,sp,48
    800014f6:	8082                	ret
    return -1;
    800014f8:	5a7d                	li	s4,-1
    800014fa:	b7f5                	j	800014e6 <fork+0x126>

00000000800014fc <scheduler>:
{
    800014fc:	7139                	addi	sp,sp,-64
    800014fe:	fc06                	sd	ra,56(sp)
    80001500:	f822                	sd	s0,48(sp)
    80001502:	f426                	sd	s1,40(sp)
    80001504:	f04a                	sd	s2,32(sp)
    80001506:	ec4e                	sd	s3,24(sp)
    80001508:	e852                	sd	s4,16(sp)
    8000150a:	e456                	sd	s5,8(sp)
    8000150c:	e05a                	sd	s6,0(sp)
    8000150e:	0080                	addi	s0,sp,64
    80001510:	8792                	mv	a5,tp
  int id = r_tp();
    80001512:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001514:	00779a93          	slli	s5,a5,0x7
    80001518:	00008717          	auipc	a4,0x8
    8000151c:	c9870713          	addi	a4,a4,-872 # 800091b0 <pid_lock>
    80001520:	9756                	add	a4,a4,s5
    80001522:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    80001526:	00008717          	auipc	a4,0x8
    8000152a:	cd270713          	addi	a4,a4,-814 # 800091f8 <cpus+0x8>
    8000152e:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001530:	498d                	li	s3,3
        p->state = RUNNING;
    80001532:	4b11                	li	s6,4
        c->proc = p;
    80001534:	079e                	slli	a5,a5,0x7
    80001536:	00008a17          	auipc	s4,0x8
    8000153a:	c7aa0a13          	addi	s4,s4,-902 # 800091b0 <pid_lock>
    8000153e:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001540:	0000e917          	auipc	s2,0xe
    80001544:	cb090913          	addi	s2,s2,-848 # 8000f1f0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001548:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000154c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001550:	10079073          	csrw	sstatus,a5
    80001554:	00008497          	auipc	s1,0x8
    80001558:	09c48493          	addi	s1,s1,156 # 800095f0 <proc>
    8000155c:	a03d                	j	8000158a <scheduler+0x8e>
        p->state = RUNNING;
    8000155e:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    80001562:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    80001566:	06848593          	addi	a1,s1,104
    8000156a:	8556                	mv	a0,s5
    8000156c:	00000097          	auipc	ra,0x0
    80001570:	640080e7          	jalr	1600(ra) # 80001bac <swtch>
        c->proc = 0;
    80001574:	040a3023          	sd	zero,64(s4)
      release(&p->lock);
    80001578:	8526                	mv	a0,s1
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	2b6080e7          	jalr	694(ra) # 80006830 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001582:	17048493          	addi	s1,s1,368
    80001586:	fd2481e3          	beq	s1,s2,80001548 <scheduler+0x4c>
      acquire(&p->lock);
    8000158a:	8526                	mv	a0,s1
    8000158c:	00005097          	auipc	ra,0x5
    80001590:	1d4080e7          	jalr	468(ra) # 80006760 <acquire>
      if(p->state == RUNNABLE) {
    80001594:	509c                	lw	a5,32(s1)
    80001596:	ff3791e3          	bne	a5,s3,80001578 <scheduler+0x7c>
    8000159a:	b7d1                	j	8000155e <scheduler+0x62>

000000008000159c <sched>:
{
    8000159c:	7179                	addi	sp,sp,-48
    8000159e:	f406                	sd	ra,40(sp)
    800015a0:	f022                	sd	s0,32(sp)
    800015a2:	ec26                	sd	s1,24(sp)
    800015a4:	e84a                	sd	s2,16(sp)
    800015a6:	e44e                	sd	s3,8(sp)
    800015a8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	a48080e7          	jalr	-1464(ra) # 80000ff2 <myproc>
    800015b2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015b4:	00005097          	auipc	ra,0x5
    800015b8:	132080e7          	jalr	306(ra) # 800066e6 <holding>
    800015bc:	c93d                	beqz	a0,80001632 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015be:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015c0:	2781                	sext.w	a5,a5
    800015c2:	079e                	slli	a5,a5,0x7
    800015c4:	00008717          	auipc	a4,0x8
    800015c8:	bec70713          	addi	a4,a4,-1044 # 800091b0 <pid_lock>
    800015cc:	97ba                	add	a5,a5,a4
    800015ce:	0b87a703          	lw	a4,184(a5)
    800015d2:	4785                	li	a5,1
    800015d4:	06f71763          	bne	a4,a5,80001642 <sched+0xa6>
  if(p->state == RUNNING)
    800015d8:	5098                	lw	a4,32(s1)
    800015da:	4791                	li	a5,4
    800015dc:	06f70b63          	beq	a4,a5,80001652 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015e4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015e6:	efb5                	bnez	a5,80001662 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015e8:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015ea:	00008917          	auipc	s2,0x8
    800015ee:	bc690913          	addi	s2,s2,-1082 # 800091b0 <pid_lock>
    800015f2:	2781                	sext.w	a5,a5
    800015f4:	079e                	slli	a5,a5,0x7
    800015f6:	97ca                	add	a5,a5,s2
    800015f8:	0bc7a983          	lw	s3,188(a5)
    800015fc:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015fe:	2781                	sext.w	a5,a5
    80001600:	079e                	slli	a5,a5,0x7
    80001602:	00008597          	auipc	a1,0x8
    80001606:	bf658593          	addi	a1,a1,-1034 # 800091f8 <cpus+0x8>
    8000160a:	95be                	add	a1,a1,a5
    8000160c:	06848513          	addi	a0,s1,104
    80001610:	00000097          	auipc	ra,0x0
    80001614:	59c080e7          	jalr	1436(ra) # 80001bac <swtch>
    80001618:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000161a:	2781                	sext.w	a5,a5
    8000161c:	079e                	slli	a5,a5,0x7
    8000161e:	97ca                	add	a5,a5,s2
    80001620:	0b37ae23          	sw	s3,188(a5)
}
    80001624:	70a2                	ld	ra,40(sp)
    80001626:	7402                	ld	s0,32(sp)
    80001628:	64e2                	ld	s1,24(sp)
    8000162a:	6942                	ld	s2,16(sp)
    8000162c:	69a2                	ld	s3,8(sp)
    8000162e:	6145                	addi	sp,sp,48
    80001630:	8082                	ret
    panic("sched p->lock");
    80001632:	00007517          	auipc	a0,0x7
    80001636:	b6e50513          	addi	a0,a0,-1170 # 800081a0 <etext+0x1a0>
    8000163a:	00005097          	auipc	ra,0x5
    8000163e:	bf2080e7          	jalr	-1038(ra) # 8000622c <panic>
    panic("sched locks");
    80001642:	00007517          	auipc	a0,0x7
    80001646:	b6e50513          	addi	a0,a0,-1170 # 800081b0 <etext+0x1b0>
    8000164a:	00005097          	auipc	ra,0x5
    8000164e:	be2080e7          	jalr	-1054(ra) # 8000622c <panic>
    panic("sched running");
    80001652:	00007517          	auipc	a0,0x7
    80001656:	b6e50513          	addi	a0,a0,-1170 # 800081c0 <etext+0x1c0>
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	bd2080e7          	jalr	-1070(ra) # 8000622c <panic>
    panic("sched interruptible");
    80001662:	00007517          	auipc	a0,0x7
    80001666:	b6e50513          	addi	a0,a0,-1170 # 800081d0 <etext+0x1d0>
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	bc2080e7          	jalr	-1086(ra) # 8000622c <panic>

0000000080001672 <yield>:
{
    80001672:	1101                	addi	sp,sp,-32
    80001674:	ec06                	sd	ra,24(sp)
    80001676:	e822                	sd	s0,16(sp)
    80001678:	e426                	sd	s1,8(sp)
    8000167a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	976080e7          	jalr	-1674(ra) # 80000ff2 <myproc>
    80001684:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	0da080e7          	jalr	218(ra) # 80006760 <acquire>
  p->state = RUNNABLE;
    8000168e:	478d                	li	a5,3
    80001690:	d09c                	sw	a5,32(s1)
  sched();
    80001692:	00000097          	auipc	ra,0x0
    80001696:	f0a080e7          	jalr	-246(ra) # 8000159c <sched>
  release(&p->lock);
    8000169a:	8526                	mv	a0,s1
    8000169c:	00005097          	auipc	ra,0x5
    800016a0:	194080e7          	jalr	404(ra) # 80006830 <release>
}
    800016a4:	60e2                	ld	ra,24(sp)
    800016a6:	6442                	ld	s0,16(sp)
    800016a8:	64a2                	ld	s1,8(sp)
    800016aa:	6105                	addi	sp,sp,32
    800016ac:	8082                	ret

00000000800016ae <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016ae:	7179                	addi	sp,sp,-48
    800016b0:	f406                	sd	ra,40(sp)
    800016b2:	f022                	sd	s0,32(sp)
    800016b4:	ec26                	sd	s1,24(sp)
    800016b6:	e84a                	sd	s2,16(sp)
    800016b8:	e44e                	sd	s3,8(sp)
    800016ba:	1800                	addi	s0,sp,48
    800016bc:	89aa                	mv	s3,a0
    800016be:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016c0:	00000097          	auipc	ra,0x0
    800016c4:	932080e7          	jalr	-1742(ra) # 80000ff2 <myproc>
    800016c8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016ca:	00005097          	auipc	ra,0x5
    800016ce:	096080e7          	jalr	150(ra) # 80006760 <acquire>
  release(lk);
    800016d2:	854a                	mv	a0,s2
    800016d4:	00005097          	auipc	ra,0x5
    800016d8:	15c080e7          	jalr	348(ra) # 80006830 <release>

  // Go to sleep.
  p->chan = chan;
    800016dc:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800016e0:	4789                	li	a5,2
    800016e2:	d09c                	sw	a5,32(s1)

  sched();
    800016e4:	00000097          	auipc	ra,0x0
    800016e8:	eb8080e7          	jalr	-328(ra) # 8000159c <sched>

  // Tidy up.
  p->chan = 0;
    800016ec:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016f0:	8526                	mv	a0,s1
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	13e080e7          	jalr	318(ra) # 80006830 <release>
  acquire(lk);
    800016fa:	854a                	mv	a0,s2
    800016fc:	00005097          	auipc	ra,0x5
    80001700:	064080e7          	jalr	100(ra) # 80006760 <acquire>
}
    80001704:	70a2                	ld	ra,40(sp)
    80001706:	7402                	ld	s0,32(sp)
    80001708:	64e2                	ld	s1,24(sp)
    8000170a:	6942                	ld	s2,16(sp)
    8000170c:	69a2                	ld	s3,8(sp)
    8000170e:	6145                	addi	sp,sp,48
    80001710:	8082                	ret

0000000080001712 <wait>:
{
    80001712:	715d                	addi	sp,sp,-80
    80001714:	e486                	sd	ra,72(sp)
    80001716:	e0a2                	sd	s0,64(sp)
    80001718:	fc26                	sd	s1,56(sp)
    8000171a:	f84a                	sd	s2,48(sp)
    8000171c:	f44e                	sd	s3,40(sp)
    8000171e:	f052                	sd	s4,32(sp)
    80001720:	ec56                	sd	s5,24(sp)
    80001722:	e85a                	sd	s6,16(sp)
    80001724:	e45e                	sd	s7,8(sp)
    80001726:	e062                	sd	s8,0(sp)
    80001728:	0880                	addi	s0,sp,80
    8000172a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000172c:	00000097          	auipc	ra,0x0
    80001730:	8c6080e7          	jalr	-1850(ra) # 80000ff2 <myproc>
    80001734:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001736:	00008517          	auipc	a0,0x8
    8000173a:	a9a50513          	addi	a0,a0,-1382 # 800091d0 <wait_lock>
    8000173e:	00005097          	auipc	ra,0x5
    80001742:	022080e7          	jalr	34(ra) # 80006760 <acquire>
    havekids = 0;
    80001746:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001748:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    8000174a:	0000e997          	auipc	s3,0xe
    8000174e:	aa698993          	addi	s3,s3,-1370 # 8000f1f0 <tickslock>
        havekids = 1;
    80001752:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001754:	00008c17          	auipc	s8,0x8
    80001758:	a7cc0c13          	addi	s8,s8,-1412 # 800091d0 <wait_lock>
    havekids = 0;
    8000175c:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000175e:	00008497          	auipc	s1,0x8
    80001762:	e9248493          	addi	s1,s1,-366 # 800095f0 <proc>
    80001766:	a0bd                	j	800017d4 <wait+0xc2>
          pid = np->pid;
    80001768:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000176c:	000b0e63          	beqz	s6,80001788 <wait+0x76>
    80001770:	4691                	li	a3,4
    80001772:	03448613          	addi	a2,s1,52
    80001776:	85da                	mv	a1,s6
    80001778:	05893503          	ld	a0,88(s2)
    8000177c:	fffff097          	auipc	ra,0xfffff
    80001780:	538080e7          	jalr	1336(ra) # 80000cb4 <copyout>
    80001784:	02054563          	bltz	a0,800017ae <wait+0x9c>
          freeproc(np);
    80001788:	8526                	mv	a0,s1
    8000178a:	00000097          	auipc	ra,0x0
    8000178e:	a1a080e7          	jalr	-1510(ra) # 800011a4 <freeproc>
          release(&np->lock);
    80001792:	8526                	mv	a0,s1
    80001794:	00005097          	auipc	ra,0x5
    80001798:	09c080e7          	jalr	156(ra) # 80006830 <release>
          release(&wait_lock);
    8000179c:	00008517          	auipc	a0,0x8
    800017a0:	a3450513          	addi	a0,a0,-1484 # 800091d0 <wait_lock>
    800017a4:	00005097          	auipc	ra,0x5
    800017a8:	08c080e7          	jalr	140(ra) # 80006830 <release>
          return pid;
    800017ac:	a09d                	j	80001812 <wait+0x100>
            release(&np->lock);
    800017ae:	8526                	mv	a0,s1
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	080080e7          	jalr	128(ra) # 80006830 <release>
            release(&wait_lock);
    800017b8:	00008517          	auipc	a0,0x8
    800017bc:	a1850513          	addi	a0,a0,-1512 # 800091d0 <wait_lock>
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	070080e7          	jalr	112(ra) # 80006830 <release>
            return -1;
    800017c8:	59fd                	li	s3,-1
    800017ca:	a0a1                	j	80001812 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    800017cc:	17048493          	addi	s1,s1,368
    800017d0:	03348463          	beq	s1,s3,800017f8 <wait+0xe6>
      if(np->parent == p){
    800017d4:	60bc                	ld	a5,64(s1)
    800017d6:	ff279be3          	bne	a5,s2,800017cc <wait+0xba>
        acquire(&np->lock);
    800017da:	8526                	mv	a0,s1
    800017dc:	00005097          	auipc	ra,0x5
    800017e0:	f84080e7          	jalr	-124(ra) # 80006760 <acquire>
        if(np->state == ZOMBIE){
    800017e4:	509c                	lw	a5,32(s1)
    800017e6:	f94781e3          	beq	a5,s4,80001768 <wait+0x56>
        release(&np->lock);
    800017ea:	8526                	mv	a0,s1
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	044080e7          	jalr	68(ra) # 80006830 <release>
        havekids = 1;
    800017f4:	8756                	mv	a4,s5
    800017f6:	bfd9                	j	800017cc <wait+0xba>
    if(!havekids || p->killed){
    800017f8:	c701                	beqz	a4,80001800 <wait+0xee>
    800017fa:	03092783          	lw	a5,48(s2)
    800017fe:	c79d                	beqz	a5,8000182c <wait+0x11a>
      release(&wait_lock);
    80001800:	00008517          	auipc	a0,0x8
    80001804:	9d050513          	addi	a0,a0,-1584 # 800091d0 <wait_lock>
    80001808:	00005097          	auipc	ra,0x5
    8000180c:	028080e7          	jalr	40(ra) # 80006830 <release>
      return -1;
    80001810:	59fd                	li	s3,-1
}
    80001812:	854e                	mv	a0,s3
    80001814:	60a6                	ld	ra,72(sp)
    80001816:	6406                	ld	s0,64(sp)
    80001818:	74e2                	ld	s1,56(sp)
    8000181a:	7942                	ld	s2,48(sp)
    8000181c:	79a2                	ld	s3,40(sp)
    8000181e:	7a02                	ld	s4,32(sp)
    80001820:	6ae2                	ld	s5,24(sp)
    80001822:	6b42                	ld	s6,16(sp)
    80001824:	6ba2                	ld	s7,8(sp)
    80001826:	6c02                	ld	s8,0(sp)
    80001828:	6161                	addi	sp,sp,80
    8000182a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000182c:	85e2                	mv	a1,s8
    8000182e:	854a                	mv	a0,s2
    80001830:	00000097          	auipc	ra,0x0
    80001834:	e7e080e7          	jalr	-386(ra) # 800016ae <sleep>
    havekids = 0;
    80001838:	b715                	j	8000175c <wait+0x4a>

000000008000183a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000183a:	7139                	addi	sp,sp,-64
    8000183c:	fc06                	sd	ra,56(sp)
    8000183e:	f822                	sd	s0,48(sp)
    80001840:	f426                	sd	s1,40(sp)
    80001842:	f04a                	sd	s2,32(sp)
    80001844:	ec4e                	sd	s3,24(sp)
    80001846:	e852                	sd	s4,16(sp)
    80001848:	e456                	sd	s5,8(sp)
    8000184a:	0080                	addi	s0,sp,64
    8000184c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000184e:	00008497          	auipc	s1,0x8
    80001852:	da248493          	addi	s1,s1,-606 # 800095f0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001856:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001858:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185a:	0000e917          	auipc	s2,0xe
    8000185e:	99690913          	addi	s2,s2,-1642 # 8000f1f0 <tickslock>
    80001862:	a821                	j	8000187a <wakeup+0x40>
        p->state = RUNNABLE;
    80001864:	0354a023          	sw	s5,32(s1)
      }
      release(&p->lock);
    80001868:	8526                	mv	a0,s1
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	fc6080e7          	jalr	-58(ra) # 80006830 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001872:	17048493          	addi	s1,s1,368
    80001876:	03248463          	beq	s1,s2,8000189e <wakeup+0x64>
    if(p != myproc()){
    8000187a:	fffff097          	auipc	ra,0xfffff
    8000187e:	778080e7          	jalr	1912(ra) # 80000ff2 <myproc>
    80001882:	fea488e3          	beq	s1,a0,80001872 <wakeup+0x38>
      acquire(&p->lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	ed8080e7          	jalr	-296(ra) # 80006760 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001890:	509c                	lw	a5,32(s1)
    80001892:	fd379be3          	bne	a5,s3,80001868 <wakeup+0x2e>
    80001896:	749c                	ld	a5,40(s1)
    80001898:	fd4798e3          	bne	a5,s4,80001868 <wakeup+0x2e>
    8000189c:	b7e1                	j	80001864 <wakeup+0x2a>
    }
  }
}
    8000189e:	70e2                	ld	ra,56(sp)
    800018a0:	7442                	ld	s0,48(sp)
    800018a2:	74a2                	ld	s1,40(sp)
    800018a4:	7902                	ld	s2,32(sp)
    800018a6:	69e2                	ld	s3,24(sp)
    800018a8:	6a42                	ld	s4,16(sp)
    800018aa:	6aa2                	ld	s5,8(sp)
    800018ac:	6121                	addi	sp,sp,64
    800018ae:	8082                	ret

00000000800018b0 <reparent>:
{
    800018b0:	7179                	addi	sp,sp,-48
    800018b2:	f406                	sd	ra,40(sp)
    800018b4:	f022                	sd	s0,32(sp)
    800018b6:	ec26                	sd	s1,24(sp)
    800018b8:	e84a                	sd	s2,16(sp)
    800018ba:	e44e                	sd	s3,8(sp)
    800018bc:	e052                	sd	s4,0(sp)
    800018be:	1800                	addi	s0,sp,48
    800018c0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018c2:	00008497          	auipc	s1,0x8
    800018c6:	d2e48493          	addi	s1,s1,-722 # 800095f0 <proc>
      pp->parent = initproc;
    800018ca:	00007a17          	auipc	s4,0x7
    800018ce:	746a0a13          	addi	s4,s4,1862 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018d2:	0000e997          	auipc	s3,0xe
    800018d6:	91e98993          	addi	s3,s3,-1762 # 8000f1f0 <tickslock>
    800018da:	a029                	j	800018e4 <reparent+0x34>
    800018dc:	17048493          	addi	s1,s1,368
    800018e0:	01348d63          	beq	s1,s3,800018fa <reparent+0x4a>
    if(pp->parent == p){
    800018e4:	60bc                	ld	a5,64(s1)
    800018e6:	ff279be3          	bne	a5,s2,800018dc <reparent+0x2c>
      pp->parent = initproc;
    800018ea:	000a3503          	ld	a0,0(s4)
    800018ee:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800018f0:	00000097          	auipc	ra,0x0
    800018f4:	f4a080e7          	jalr	-182(ra) # 8000183a <wakeup>
    800018f8:	b7d5                	j	800018dc <reparent+0x2c>
}
    800018fa:	70a2                	ld	ra,40(sp)
    800018fc:	7402                	ld	s0,32(sp)
    800018fe:	64e2                	ld	s1,24(sp)
    80001900:	6942                	ld	s2,16(sp)
    80001902:	69a2                	ld	s3,8(sp)
    80001904:	6a02                	ld	s4,0(sp)
    80001906:	6145                	addi	sp,sp,48
    80001908:	8082                	ret

000000008000190a <exit>:
{
    8000190a:	7179                	addi	sp,sp,-48
    8000190c:	f406                	sd	ra,40(sp)
    8000190e:	f022                	sd	s0,32(sp)
    80001910:	ec26                	sd	s1,24(sp)
    80001912:	e84a                	sd	s2,16(sp)
    80001914:	e44e                	sd	s3,8(sp)
    80001916:	e052                	sd	s4,0(sp)
    80001918:	1800                	addi	s0,sp,48
    8000191a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000191c:	fffff097          	auipc	ra,0xfffff
    80001920:	6d6080e7          	jalr	1750(ra) # 80000ff2 <myproc>
    80001924:	89aa                	mv	s3,a0
  if(p == initproc)
    80001926:	00007797          	auipc	a5,0x7
    8000192a:	6ea7b783          	ld	a5,1770(a5) # 80009010 <initproc>
    8000192e:	0d850493          	addi	s1,a0,216
    80001932:	15850913          	addi	s2,a0,344
    80001936:	02a79363          	bne	a5,a0,8000195c <exit+0x52>
    panic("init exiting");
    8000193a:	00007517          	auipc	a0,0x7
    8000193e:	8ae50513          	addi	a0,a0,-1874 # 800081e8 <etext+0x1e8>
    80001942:	00005097          	auipc	ra,0x5
    80001946:	8ea080e7          	jalr	-1814(ra) # 8000622c <panic>
      fileclose(f);
    8000194a:	00002097          	auipc	ra,0x2
    8000194e:	38e080e7          	jalr	910(ra) # 80003cd8 <fileclose>
      p->ofile[fd] = 0;
    80001952:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001956:	04a1                	addi	s1,s1,8
    80001958:	01248563          	beq	s1,s2,80001962 <exit+0x58>
    if(p->ofile[fd]){
    8000195c:	6088                	ld	a0,0(s1)
    8000195e:	f575                	bnez	a0,8000194a <exit+0x40>
    80001960:	bfdd                	j	80001956 <exit+0x4c>
  begin_op();
    80001962:	00002097          	auipc	ra,0x2
    80001966:	eaa080e7          	jalr	-342(ra) # 8000380c <begin_op>
  iput(p->cwd);
    8000196a:	1589b503          	ld	a0,344(s3)
    8000196e:	00001097          	auipc	ra,0x1
    80001972:	686080e7          	jalr	1670(ra) # 80002ff4 <iput>
  end_op();
    80001976:	00002097          	auipc	ra,0x2
    8000197a:	f16080e7          	jalr	-234(ra) # 8000388c <end_op>
  p->cwd = 0;
    8000197e:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001982:	00008497          	auipc	s1,0x8
    80001986:	84e48493          	addi	s1,s1,-1970 # 800091d0 <wait_lock>
    8000198a:	8526                	mv	a0,s1
    8000198c:	00005097          	auipc	ra,0x5
    80001990:	dd4080e7          	jalr	-556(ra) # 80006760 <acquire>
  reparent(p);
    80001994:	854e                	mv	a0,s3
    80001996:	00000097          	auipc	ra,0x0
    8000199a:	f1a080e7          	jalr	-230(ra) # 800018b0 <reparent>
  wakeup(p->parent);
    8000199e:	0409b503          	ld	a0,64(s3)
    800019a2:	00000097          	auipc	ra,0x0
    800019a6:	e98080e7          	jalr	-360(ra) # 8000183a <wakeup>
  acquire(&p->lock);
    800019aa:	854e                	mv	a0,s3
    800019ac:	00005097          	auipc	ra,0x5
    800019b0:	db4080e7          	jalr	-588(ra) # 80006760 <acquire>
  p->xstate = status;
    800019b4:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800019b8:	4795                	li	a5,5
    800019ba:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    800019be:	8526                	mv	a0,s1
    800019c0:	00005097          	auipc	ra,0x5
    800019c4:	e70080e7          	jalr	-400(ra) # 80006830 <release>
  sched();
    800019c8:	00000097          	auipc	ra,0x0
    800019cc:	bd4080e7          	jalr	-1068(ra) # 8000159c <sched>
  panic("zombie exit");
    800019d0:	00007517          	auipc	a0,0x7
    800019d4:	82850513          	addi	a0,a0,-2008 # 800081f8 <etext+0x1f8>
    800019d8:	00005097          	auipc	ra,0x5
    800019dc:	854080e7          	jalr	-1964(ra) # 8000622c <panic>

00000000800019e0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800019e0:	7179                	addi	sp,sp,-48
    800019e2:	f406                	sd	ra,40(sp)
    800019e4:	f022                	sd	s0,32(sp)
    800019e6:	ec26                	sd	s1,24(sp)
    800019e8:	e84a                	sd	s2,16(sp)
    800019ea:	e44e                	sd	s3,8(sp)
    800019ec:	1800                	addi	s0,sp,48
    800019ee:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019f0:	00008497          	auipc	s1,0x8
    800019f4:	c0048493          	addi	s1,s1,-1024 # 800095f0 <proc>
    800019f8:	0000d997          	auipc	s3,0xd
    800019fc:	7f898993          	addi	s3,s3,2040 # 8000f1f0 <tickslock>
    acquire(&p->lock);
    80001a00:	8526                	mv	a0,s1
    80001a02:	00005097          	auipc	ra,0x5
    80001a06:	d5e080e7          	jalr	-674(ra) # 80006760 <acquire>
    if(p->pid == pid){
    80001a0a:	5c9c                	lw	a5,56(s1)
    80001a0c:	01278d63          	beq	a5,s2,80001a26 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a10:	8526                	mv	a0,s1
    80001a12:	00005097          	auipc	ra,0x5
    80001a16:	e1e080e7          	jalr	-482(ra) # 80006830 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a1a:	17048493          	addi	s1,s1,368
    80001a1e:	ff3491e3          	bne	s1,s3,80001a00 <kill+0x20>
  }
  return -1;
    80001a22:	557d                	li	a0,-1
    80001a24:	a829                	j	80001a3e <kill+0x5e>
      p->killed = 1;
    80001a26:	4785                	li	a5,1
    80001a28:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80001a2a:	5098                	lw	a4,32(s1)
    80001a2c:	4789                	li	a5,2
    80001a2e:	00f70f63          	beq	a4,a5,80001a4c <kill+0x6c>
      release(&p->lock);
    80001a32:	8526                	mv	a0,s1
    80001a34:	00005097          	auipc	ra,0x5
    80001a38:	dfc080e7          	jalr	-516(ra) # 80006830 <release>
      return 0;
    80001a3c:	4501                	li	a0,0
}
    80001a3e:	70a2                	ld	ra,40(sp)
    80001a40:	7402                	ld	s0,32(sp)
    80001a42:	64e2                	ld	s1,24(sp)
    80001a44:	6942                	ld	s2,16(sp)
    80001a46:	69a2                	ld	s3,8(sp)
    80001a48:	6145                	addi	sp,sp,48
    80001a4a:	8082                	ret
        p->state = RUNNABLE;
    80001a4c:	478d                	li	a5,3
    80001a4e:	d09c                	sw	a5,32(s1)
    80001a50:	b7cd                	j	80001a32 <kill+0x52>

0000000080001a52 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a52:	7179                	addi	sp,sp,-48
    80001a54:	f406                	sd	ra,40(sp)
    80001a56:	f022                	sd	s0,32(sp)
    80001a58:	ec26                	sd	s1,24(sp)
    80001a5a:	e84a                	sd	s2,16(sp)
    80001a5c:	e44e                	sd	s3,8(sp)
    80001a5e:	e052                	sd	s4,0(sp)
    80001a60:	1800                	addi	s0,sp,48
    80001a62:	84aa                	mv	s1,a0
    80001a64:	892e                	mv	s2,a1
    80001a66:	89b2                	mv	s3,a2
    80001a68:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a6a:	fffff097          	auipc	ra,0xfffff
    80001a6e:	588080e7          	jalr	1416(ra) # 80000ff2 <myproc>
  if(user_dst){
    80001a72:	c08d                	beqz	s1,80001a94 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a74:	86d2                	mv	a3,s4
    80001a76:	864e                	mv	a2,s3
    80001a78:	85ca                	mv	a1,s2
    80001a7a:	6d28                	ld	a0,88(a0)
    80001a7c:	fffff097          	auipc	ra,0xfffff
    80001a80:	238080e7          	jalr	568(ra) # 80000cb4 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a84:	70a2                	ld	ra,40(sp)
    80001a86:	7402                	ld	s0,32(sp)
    80001a88:	64e2                	ld	s1,24(sp)
    80001a8a:	6942                	ld	s2,16(sp)
    80001a8c:	69a2                	ld	s3,8(sp)
    80001a8e:	6a02                	ld	s4,0(sp)
    80001a90:	6145                	addi	sp,sp,48
    80001a92:	8082                	ret
    memmove((char *)dst, src, len);
    80001a94:	000a061b          	sext.w	a2,s4
    80001a98:	85ce                	mv	a1,s3
    80001a9a:	854a                	mv	a0,s2
    80001a9c:	fffff097          	auipc	ra,0xfffff
    80001aa0:	8d6080e7          	jalr	-1834(ra) # 80000372 <memmove>
    return 0;
    80001aa4:	8526                	mv	a0,s1
    80001aa6:	bff9                	j	80001a84 <either_copyout+0x32>

0000000080001aa8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001aa8:	7179                	addi	sp,sp,-48
    80001aaa:	f406                	sd	ra,40(sp)
    80001aac:	f022                	sd	s0,32(sp)
    80001aae:	ec26                	sd	s1,24(sp)
    80001ab0:	e84a                	sd	s2,16(sp)
    80001ab2:	e44e                	sd	s3,8(sp)
    80001ab4:	e052                	sd	s4,0(sp)
    80001ab6:	1800                	addi	s0,sp,48
    80001ab8:	892a                	mv	s2,a0
    80001aba:	84ae                	mv	s1,a1
    80001abc:	89b2                	mv	s3,a2
    80001abe:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ac0:	fffff097          	auipc	ra,0xfffff
    80001ac4:	532080e7          	jalr	1330(ra) # 80000ff2 <myproc>
  if(user_src){
    80001ac8:	c08d                	beqz	s1,80001aea <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001aca:	86d2                	mv	a3,s4
    80001acc:	864e                	mv	a2,s3
    80001ace:	85ca                	mv	a1,s2
    80001ad0:	6d28                	ld	a0,88(a0)
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	26e080e7          	jalr	622(ra) # 80000d40 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001ada:	70a2                	ld	ra,40(sp)
    80001adc:	7402                	ld	s0,32(sp)
    80001ade:	64e2                	ld	s1,24(sp)
    80001ae0:	6942                	ld	s2,16(sp)
    80001ae2:	69a2                	ld	s3,8(sp)
    80001ae4:	6a02                	ld	s4,0(sp)
    80001ae6:	6145                	addi	sp,sp,48
    80001ae8:	8082                	ret
    memmove(dst, (char*)src, len);
    80001aea:	000a061b          	sext.w	a2,s4
    80001aee:	85ce                	mv	a1,s3
    80001af0:	854a                	mv	a0,s2
    80001af2:	fffff097          	auipc	ra,0xfffff
    80001af6:	880080e7          	jalr	-1920(ra) # 80000372 <memmove>
    return 0;
    80001afa:	8526                	mv	a0,s1
    80001afc:	bff9                	j	80001ada <either_copyin+0x32>

0000000080001afe <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001afe:	715d                	addi	sp,sp,-80
    80001b00:	e486                	sd	ra,72(sp)
    80001b02:	e0a2                	sd	s0,64(sp)
    80001b04:	fc26                	sd	s1,56(sp)
    80001b06:	f84a                	sd	s2,48(sp)
    80001b08:	f44e                	sd	s3,40(sp)
    80001b0a:	f052                	sd	s4,32(sp)
    80001b0c:	ec56                	sd	s5,24(sp)
    80001b0e:	e85a                	sd	s6,16(sp)
    80001b10:	e45e                	sd	s7,8(sp)
    80001b12:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b14:	00007517          	auipc	a0,0x7
    80001b18:	d7c50513          	addi	a0,a0,-644 # 80008890 <digits+0x88>
    80001b1c:	00004097          	auipc	ra,0x4
    80001b20:	75a080e7          	jalr	1882(ra) # 80006276 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b24:	00008497          	auipc	s1,0x8
    80001b28:	c2c48493          	addi	s1,s1,-980 # 80009750 <proc+0x160>
    80001b2c:	0000e917          	auipc	s2,0xe
    80001b30:	82490913          	addi	s2,s2,-2012 # 8000f350 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b34:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b36:	00006997          	auipc	s3,0x6
    80001b3a:	6d298993          	addi	s3,s3,1746 # 80008208 <etext+0x208>
    printf("%d %s %s", p->pid, state, p->name);
    80001b3e:	00006a97          	auipc	s5,0x6
    80001b42:	6d2a8a93          	addi	s5,s5,1746 # 80008210 <etext+0x210>
    printf("\n");
    80001b46:	00007a17          	auipc	s4,0x7
    80001b4a:	d4aa0a13          	addi	s4,s4,-694 # 80008890 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b4e:	00006b97          	auipc	s7,0x6
    80001b52:	6fab8b93          	addi	s7,s7,1786 # 80008248 <states.1725>
    80001b56:	a00d                	j	80001b78 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b58:	ed86a583          	lw	a1,-296(a3)
    80001b5c:	8556                	mv	a0,s5
    80001b5e:	00004097          	auipc	ra,0x4
    80001b62:	718080e7          	jalr	1816(ra) # 80006276 <printf>
    printf("\n");
    80001b66:	8552                	mv	a0,s4
    80001b68:	00004097          	auipc	ra,0x4
    80001b6c:	70e080e7          	jalr	1806(ra) # 80006276 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b70:	17048493          	addi	s1,s1,368
    80001b74:	03248163          	beq	s1,s2,80001b96 <procdump+0x98>
    if(p->state == UNUSED)
    80001b78:	86a6                	mv	a3,s1
    80001b7a:	ec04a783          	lw	a5,-320(s1)
    80001b7e:	dbed                	beqz	a5,80001b70 <procdump+0x72>
      state = "???";
    80001b80:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b82:	fcfb6be3          	bltu	s6,a5,80001b58 <procdump+0x5a>
    80001b86:	1782                	slli	a5,a5,0x20
    80001b88:	9381                	srli	a5,a5,0x20
    80001b8a:	078e                	slli	a5,a5,0x3
    80001b8c:	97de                	add	a5,a5,s7
    80001b8e:	6390                	ld	a2,0(a5)
    80001b90:	f661                	bnez	a2,80001b58 <procdump+0x5a>
      state = "???";
    80001b92:	864e                	mv	a2,s3
    80001b94:	b7d1                	j	80001b58 <procdump+0x5a>
  }
}
    80001b96:	60a6                	ld	ra,72(sp)
    80001b98:	6406                	ld	s0,64(sp)
    80001b9a:	74e2                	ld	s1,56(sp)
    80001b9c:	7942                	ld	s2,48(sp)
    80001b9e:	79a2                	ld	s3,40(sp)
    80001ba0:	7a02                	ld	s4,32(sp)
    80001ba2:	6ae2                	ld	s5,24(sp)
    80001ba4:	6b42                	ld	s6,16(sp)
    80001ba6:	6ba2                	ld	s7,8(sp)
    80001ba8:	6161                	addi	sp,sp,80
    80001baa:	8082                	ret

0000000080001bac <swtch>:
    80001bac:	00153023          	sd	ra,0(a0)
    80001bb0:	00253423          	sd	sp,8(a0)
    80001bb4:	e900                	sd	s0,16(a0)
    80001bb6:	ed04                	sd	s1,24(a0)
    80001bb8:	03253023          	sd	s2,32(a0)
    80001bbc:	03353423          	sd	s3,40(a0)
    80001bc0:	03453823          	sd	s4,48(a0)
    80001bc4:	03553c23          	sd	s5,56(a0)
    80001bc8:	05653023          	sd	s6,64(a0)
    80001bcc:	05753423          	sd	s7,72(a0)
    80001bd0:	05853823          	sd	s8,80(a0)
    80001bd4:	05953c23          	sd	s9,88(a0)
    80001bd8:	07a53023          	sd	s10,96(a0)
    80001bdc:	07b53423          	sd	s11,104(a0)
    80001be0:	0005b083          	ld	ra,0(a1)
    80001be4:	0085b103          	ld	sp,8(a1)
    80001be8:	6980                	ld	s0,16(a1)
    80001bea:	6d84                	ld	s1,24(a1)
    80001bec:	0205b903          	ld	s2,32(a1)
    80001bf0:	0285b983          	ld	s3,40(a1)
    80001bf4:	0305ba03          	ld	s4,48(a1)
    80001bf8:	0385ba83          	ld	s5,56(a1)
    80001bfc:	0405bb03          	ld	s6,64(a1)
    80001c00:	0485bb83          	ld	s7,72(a1)
    80001c04:	0505bc03          	ld	s8,80(a1)
    80001c08:	0585bc83          	ld	s9,88(a1)
    80001c0c:	0605bd03          	ld	s10,96(a1)
    80001c10:	0685bd83          	ld	s11,104(a1)
    80001c14:	8082                	ret

0000000080001c16 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c16:	1141                	addi	sp,sp,-16
    80001c18:	e406                	sd	ra,8(sp)
    80001c1a:	e022                	sd	s0,0(sp)
    80001c1c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c1e:	00006597          	auipc	a1,0x6
    80001c22:	65a58593          	addi	a1,a1,1626 # 80008278 <states.1725+0x30>
    80001c26:	0000d517          	auipc	a0,0xd
    80001c2a:	5ca50513          	addi	a0,a0,1482 # 8000f1f0 <tickslock>
    80001c2e:	00005097          	auipc	ra,0x5
    80001c32:	cae080e7          	jalr	-850(ra) # 800068dc <initlock>
}
    80001c36:	60a2                	ld	ra,8(sp)
    80001c38:	6402                	ld	s0,0(sp)
    80001c3a:	0141                	addi	sp,sp,16
    80001c3c:	8082                	ret

0000000080001c3e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c3e:	1141                	addi	sp,sp,-16
    80001c40:	e422                	sd	s0,8(sp)
    80001c42:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c44:	00003797          	auipc	a5,0x3
    80001c48:	6bc78793          	addi	a5,a5,1724 # 80005300 <kernelvec>
    80001c4c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c50:	6422                	ld	s0,8(sp)
    80001c52:	0141                	addi	sp,sp,16
    80001c54:	8082                	ret

0000000080001c56 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c56:	1141                	addi	sp,sp,-16
    80001c58:	e406                	sd	ra,8(sp)
    80001c5a:	e022                	sd	s0,0(sp)
    80001c5c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c5e:	fffff097          	auipc	ra,0xfffff
    80001c62:	394080e7          	jalr	916(ra) # 80000ff2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c66:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c6a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c6c:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001c70:	00005617          	auipc	a2,0x5
    80001c74:	39060613          	addi	a2,a2,912 # 80007000 <_trampoline>
    80001c78:	00005697          	auipc	a3,0x5
    80001c7c:	38868693          	addi	a3,a3,904 # 80007000 <_trampoline>
    80001c80:	8e91                	sub	a3,a3,a2
    80001c82:	040007b7          	lui	a5,0x4000
    80001c86:	17fd                	addi	a5,a5,-1
    80001c88:	07b2                	slli	a5,a5,0xc
    80001c8a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c8c:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c90:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c92:	180026f3          	csrr	a3,satp
    80001c96:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c98:	7138                	ld	a4,96(a0)
    80001c9a:	6534                	ld	a3,72(a0)
    80001c9c:	6585                	lui	a1,0x1
    80001c9e:	96ae                	add	a3,a3,a1
    80001ca0:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001ca2:	7138                	ld	a4,96(a0)
    80001ca4:	00000697          	auipc	a3,0x0
    80001ca8:	13868693          	addi	a3,a3,312 # 80001ddc <usertrap>
    80001cac:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cae:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cb0:	8692                	mv	a3,tp
    80001cb2:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cb4:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cb8:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cbc:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cc0:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001cc4:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001cc6:	6f18                	ld	a4,24(a4)
    80001cc8:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ccc:	6d2c                	ld	a1,88(a0)
    80001cce:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001cd0:	00005717          	auipc	a4,0x5
    80001cd4:	3c070713          	addi	a4,a4,960 # 80007090 <userret>
    80001cd8:	8f11                	sub	a4,a4,a2
    80001cda:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001cdc:	577d                	li	a4,-1
    80001cde:	177e                	slli	a4,a4,0x3f
    80001ce0:	8dd9                	or	a1,a1,a4
    80001ce2:	02000537          	lui	a0,0x2000
    80001ce6:	157d                	addi	a0,a0,-1
    80001ce8:	0536                	slli	a0,a0,0xd
    80001cea:	9782                	jalr	a5
}
    80001cec:	60a2                	ld	ra,8(sp)
    80001cee:	6402                	ld	s0,0(sp)
    80001cf0:	0141                	addi	sp,sp,16
    80001cf2:	8082                	ret

0000000080001cf4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001cf4:	1101                	addi	sp,sp,-32
    80001cf6:	ec06                	sd	ra,24(sp)
    80001cf8:	e822                	sd	s0,16(sp)
    80001cfa:	e426                	sd	s1,8(sp)
    80001cfc:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001cfe:	0000d497          	auipc	s1,0xd
    80001d02:	4f248493          	addi	s1,s1,1266 # 8000f1f0 <tickslock>
    80001d06:	8526                	mv	a0,s1
    80001d08:	00005097          	auipc	ra,0x5
    80001d0c:	a58080e7          	jalr	-1448(ra) # 80006760 <acquire>
  ticks++;
    80001d10:	00007517          	auipc	a0,0x7
    80001d14:	30850513          	addi	a0,a0,776 # 80009018 <ticks>
    80001d18:	411c                	lw	a5,0(a0)
    80001d1a:	2785                	addiw	a5,a5,1
    80001d1c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d1e:	00000097          	auipc	ra,0x0
    80001d22:	b1c080e7          	jalr	-1252(ra) # 8000183a <wakeup>
  release(&tickslock);
    80001d26:	8526                	mv	a0,s1
    80001d28:	00005097          	auipc	ra,0x5
    80001d2c:	b08080e7          	jalr	-1272(ra) # 80006830 <release>
}
    80001d30:	60e2                	ld	ra,24(sp)
    80001d32:	6442                	ld	s0,16(sp)
    80001d34:	64a2                	ld	s1,8(sp)
    80001d36:	6105                	addi	sp,sp,32
    80001d38:	8082                	ret

0000000080001d3a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d3a:	1101                	addi	sp,sp,-32
    80001d3c:	ec06                	sd	ra,24(sp)
    80001d3e:	e822                	sd	s0,16(sp)
    80001d40:	e426                	sd	s1,8(sp)
    80001d42:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d44:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d48:	00074d63          	bltz	a4,80001d62 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d4c:	57fd                	li	a5,-1
    80001d4e:	17fe                	slli	a5,a5,0x3f
    80001d50:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d52:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d54:	06f70363          	beq	a4,a5,80001dba <devintr+0x80>
  }
}
    80001d58:	60e2                	ld	ra,24(sp)
    80001d5a:	6442                	ld	s0,16(sp)
    80001d5c:	64a2                	ld	s1,8(sp)
    80001d5e:	6105                	addi	sp,sp,32
    80001d60:	8082                	ret
     (scause & 0xff) == 9){
    80001d62:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001d66:	46a5                	li	a3,9
    80001d68:	fed792e3          	bne	a5,a3,80001d4c <devintr+0x12>
    int irq = plic_claim();
    80001d6c:	00003097          	auipc	ra,0x3
    80001d70:	69c080e7          	jalr	1692(ra) # 80005408 <plic_claim>
    80001d74:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d76:	47a9                	li	a5,10
    80001d78:	02f50763          	beq	a0,a5,80001da6 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d7c:	4785                	li	a5,1
    80001d7e:	02f50963          	beq	a0,a5,80001db0 <devintr+0x76>
    return 1;
    80001d82:	4505                	li	a0,1
    } else if(irq){
    80001d84:	d8f1                	beqz	s1,80001d58 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d86:	85a6                	mv	a1,s1
    80001d88:	00006517          	auipc	a0,0x6
    80001d8c:	4f850513          	addi	a0,a0,1272 # 80008280 <states.1725+0x38>
    80001d90:	00004097          	auipc	ra,0x4
    80001d94:	4e6080e7          	jalr	1254(ra) # 80006276 <printf>
      plic_complete(irq);
    80001d98:	8526                	mv	a0,s1
    80001d9a:	00003097          	auipc	ra,0x3
    80001d9e:	692080e7          	jalr	1682(ra) # 8000542c <plic_complete>
    return 1;
    80001da2:	4505                	li	a0,1
    80001da4:	bf55                	j	80001d58 <devintr+0x1e>
      uartintr();
    80001da6:	00005097          	auipc	ra,0x5
    80001daa:	8f0080e7          	jalr	-1808(ra) # 80006696 <uartintr>
    80001dae:	b7ed                	j	80001d98 <devintr+0x5e>
      virtio_disk_intr();
    80001db0:	00004097          	auipc	ra,0x4
    80001db4:	b5c080e7          	jalr	-1188(ra) # 8000590c <virtio_disk_intr>
    80001db8:	b7c5                	j	80001d98 <devintr+0x5e>
    if(cpuid() == 0){
    80001dba:	fffff097          	auipc	ra,0xfffff
    80001dbe:	20c080e7          	jalr	524(ra) # 80000fc6 <cpuid>
    80001dc2:	c901                	beqz	a0,80001dd2 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dc4:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001dc8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dca:	14479073          	csrw	sip,a5
    return 2;
    80001dce:	4509                	li	a0,2
    80001dd0:	b761                	j	80001d58 <devintr+0x1e>
      clockintr();
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	f22080e7          	jalr	-222(ra) # 80001cf4 <clockintr>
    80001dda:	b7ed                	j	80001dc4 <devintr+0x8a>

0000000080001ddc <usertrap>:
{
    80001ddc:	1101                	addi	sp,sp,-32
    80001dde:	ec06                	sd	ra,24(sp)
    80001de0:	e822                	sd	s0,16(sp)
    80001de2:	e426                	sd	s1,8(sp)
    80001de4:	e04a                	sd	s2,0(sp)
    80001de6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001de8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001dec:	1007f793          	andi	a5,a5,256
    80001df0:	e3ad                	bnez	a5,80001e52 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001df2:	00003797          	auipc	a5,0x3
    80001df6:	50e78793          	addi	a5,a5,1294 # 80005300 <kernelvec>
    80001dfa:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001dfe:	fffff097          	auipc	ra,0xfffff
    80001e02:	1f4080e7          	jalr	500(ra) # 80000ff2 <myproc>
    80001e06:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e08:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e0a:	14102773          	csrr	a4,sepc
    80001e0e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e10:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e14:	47a1                	li	a5,8
    80001e16:	04f71c63          	bne	a4,a5,80001e6e <usertrap+0x92>
    if(p->killed)
    80001e1a:	591c                	lw	a5,48(a0)
    80001e1c:	e3b9                	bnez	a5,80001e62 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e1e:	70b8                	ld	a4,96(s1)
    80001e20:	6f1c                	ld	a5,24(a4)
    80001e22:	0791                	addi	a5,a5,4
    80001e24:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e26:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e2a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2e:	10079073          	csrw	sstatus,a5
    syscall();
    80001e32:	00000097          	auipc	ra,0x0
    80001e36:	2e0080e7          	jalr	736(ra) # 80002112 <syscall>
  if(p->killed)
    80001e3a:	589c                	lw	a5,48(s1)
    80001e3c:	ebc1                	bnez	a5,80001ecc <usertrap+0xf0>
  usertrapret();
    80001e3e:	00000097          	auipc	ra,0x0
    80001e42:	e18080e7          	jalr	-488(ra) # 80001c56 <usertrapret>
}
    80001e46:	60e2                	ld	ra,24(sp)
    80001e48:	6442                	ld	s0,16(sp)
    80001e4a:	64a2                	ld	s1,8(sp)
    80001e4c:	6902                	ld	s2,0(sp)
    80001e4e:	6105                	addi	sp,sp,32
    80001e50:	8082                	ret
    panic("usertrap: not from user mode");
    80001e52:	00006517          	auipc	a0,0x6
    80001e56:	44e50513          	addi	a0,a0,1102 # 800082a0 <states.1725+0x58>
    80001e5a:	00004097          	auipc	ra,0x4
    80001e5e:	3d2080e7          	jalr	978(ra) # 8000622c <panic>
      exit(-1);
    80001e62:	557d                	li	a0,-1
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	aa6080e7          	jalr	-1370(ra) # 8000190a <exit>
    80001e6c:	bf4d                	j	80001e1e <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001e6e:	00000097          	auipc	ra,0x0
    80001e72:	ecc080e7          	jalr	-308(ra) # 80001d3a <devintr>
    80001e76:	892a                	mv	s2,a0
    80001e78:	c501                	beqz	a0,80001e80 <usertrap+0xa4>
  if(p->killed)
    80001e7a:	589c                	lw	a5,48(s1)
    80001e7c:	c3a1                	beqz	a5,80001ebc <usertrap+0xe0>
    80001e7e:	a815                	j	80001eb2 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e80:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e84:	5c90                	lw	a2,56(s1)
    80001e86:	00006517          	auipc	a0,0x6
    80001e8a:	43a50513          	addi	a0,a0,1082 # 800082c0 <states.1725+0x78>
    80001e8e:	00004097          	auipc	ra,0x4
    80001e92:	3e8080e7          	jalr	1000(ra) # 80006276 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e96:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e9a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e9e:	00006517          	auipc	a0,0x6
    80001ea2:	45250513          	addi	a0,a0,1106 # 800082f0 <states.1725+0xa8>
    80001ea6:	00004097          	auipc	ra,0x4
    80001eaa:	3d0080e7          	jalr	976(ra) # 80006276 <printf>
    p->killed = 1;
    80001eae:	4785                	li	a5,1
    80001eb0:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001eb2:	557d                	li	a0,-1
    80001eb4:	00000097          	auipc	ra,0x0
    80001eb8:	a56080e7          	jalr	-1450(ra) # 8000190a <exit>
  if(which_dev == 2)
    80001ebc:	4789                	li	a5,2
    80001ebe:	f8f910e3          	bne	s2,a5,80001e3e <usertrap+0x62>
    yield();
    80001ec2:	fffff097          	auipc	ra,0xfffff
    80001ec6:	7b0080e7          	jalr	1968(ra) # 80001672 <yield>
    80001eca:	bf95                	j	80001e3e <usertrap+0x62>
  int which_dev = 0;
    80001ecc:	4901                	li	s2,0
    80001ece:	b7d5                	j	80001eb2 <usertrap+0xd6>

0000000080001ed0 <kerneltrap>:
{
    80001ed0:	7179                	addi	sp,sp,-48
    80001ed2:	f406                	sd	ra,40(sp)
    80001ed4:	f022                	sd	s0,32(sp)
    80001ed6:	ec26                	sd	s1,24(sp)
    80001ed8:	e84a                	sd	s2,16(sp)
    80001eda:	e44e                	sd	s3,8(sp)
    80001edc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ede:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001eea:	1004f793          	andi	a5,s1,256
    80001eee:	cb85                	beqz	a5,80001f1e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ef0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ef4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ef6:	ef85                	bnez	a5,80001f2e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001ef8:	00000097          	auipc	ra,0x0
    80001efc:	e42080e7          	jalr	-446(ra) # 80001d3a <devintr>
    80001f00:	cd1d                	beqz	a0,80001f3e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f02:	4789                	li	a5,2
    80001f04:	06f50a63          	beq	a0,a5,80001f78 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f08:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f0c:	10049073          	csrw	sstatus,s1
}
    80001f10:	70a2                	ld	ra,40(sp)
    80001f12:	7402                	ld	s0,32(sp)
    80001f14:	64e2                	ld	s1,24(sp)
    80001f16:	6942                	ld	s2,16(sp)
    80001f18:	69a2                	ld	s3,8(sp)
    80001f1a:	6145                	addi	sp,sp,48
    80001f1c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f1e:	00006517          	auipc	a0,0x6
    80001f22:	3f250513          	addi	a0,a0,1010 # 80008310 <states.1725+0xc8>
    80001f26:	00004097          	auipc	ra,0x4
    80001f2a:	306080e7          	jalr	774(ra) # 8000622c <panic>
    panic("kerneltrap: interrupts enabled");
    80001f2e:	00006517          	auipc	a0,0x6
    80001f32:	40a50513          	addi	a0,a0,1034 # 80008338 <states.1725+0xf0>
    80001f36:	00004097          	auipc	ra,0x4
    80001f3a:	2f6080e7          	jalr	758(ra) # 8000622c <panic>
    printf("scause %p\n", scause);
    80001f3e:	85ce                	mv	a1,s3
    80001f40:	00006517          	auipc	a0,0x6
    80001f44:	41850513          	addi	a0,a0,1048 # 80008358 <states.1725+0x110>
    80001f48:	00004097          	auipc	ra,0x4
    80001f4c:	32e080e7          	jalr	814(ra) # 80006276 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f50:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f54:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f58:	00006517          	auipc	a0,0x6
    80001f5c:	41050513          	addi	a0,a0,1040 # 80008368 <states.1725+0x120>
    80001f60:	00004097          	auipc	ra,0x4
    80001f64:	316080e7          	jalr	790(ra) # 80006276 <printf>
    panic("kerneltrap");
    80001f68:	00006517          	auipc	a0,0x6
    80001f6c:	41850513          	addi	a0,a0,1048 # 80008380 <states.1725+0x138>
    80001f70:	00004097          	auipc	ra,0x4
    80001f74:	2bc080e7          	jalr	700(ra) # 8000622c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f78:	fffff097          	auipc	ra,0xfffff
    80001f7c:	07a080e7          	jalr	122(ra) # 80000ff2 <myproc>
    80001f80:	d541                	beqz	a0,80001f08 <kerneltrap+0x38>
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	070080e7          	jalr	112(ra) # 80000ff2 <myproc>
    80001f8a:	5118                	lw	a4,32(a0)
    80001f8c:	4791                	li	a5,4
    80001f8e:	f6f71de3          	bne	a4,a5,80001f08 <kerneltrap+0x38>
    yield();
    80001f92:	fffff097          	auipc	ra,0xfffff
    80001f96:	6e0080e7          	jalr	1760(ra) # 80001672 <yield>
    80001f9a:	b7bd                	j	80001f08 <kerneltrap+0x38>

0000000080001f9c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f9c:	1101                	addi	sp,sp,-32
    80001f9e:	ec06                	sd	ra,24(sp)
    80001fa0:	e822                	sd	s0,16(sp)
    80001fa2:	e426                	sd	s1,8(sp)
    80001fa4:	1000                	addi	s0,sp,32
    80001fa6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fa8:	fffff097          	auipc	ra,0xfffff
    80001fac:	04a080e7          	jalr	74(ra) # 80000ff2 <myproc>
  switch (n) {
    80001fb0:	4795                	li	a5,5
    80001fb2:	0497e163          	bltu	a5,s1,80001ff4 <argraw+0x58>
    80001fb6:	048a                	slli	s1,s1,0x2
    80001fb8:	00006717          	auipc	a4,0x6
    80001fbc:	40070713          	addi	a4,a4,1024 # 800083b8 <states.1725+0x170>
    80001fc0:	94ba                	add	s1,s1,a4
    80001fc2:	409c                	lw	a5,0(s1)
    80001fc4:	97ba                	add	a5,a5,a4
    80001fc6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fc8:	713c                	ld	a5,96(a0)
    80001fca:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fcc:	60e2                	ld	ra,24(sp)
    80001fce:	6442                	ld	s0,16(sp)
    80001fd0:	64a2                	ld	s1,8(sp)
    80001fd2:	6105                	addi	sp,sp,32
    80001fd4:	8082                	ret
    return p->trapframe->a1;
    80001fd6:	713c                	ld	a5,96(a0)
    80001fd8:	7fa8                	ld	a0,120(a5)
    80001fda:	bfcd                	j	80001fcc <argraw+0x30>
    return p->trapframe->a2;
    80001fdc:	713c                	ld	a5,96(a0)
    80001fde:	63c8                	ld	a0,128(a5)
    80001fe0:	b7f5                	j	80001fcc <argraw+0x30>
    return p->trapframe->a3;
    80001fe2:	713c                	ld	a5,96(a0)
    80001fe4:	67c8                	ld	a0,136(a5)
    80001fe6:	b7dd                	j	80001fcc <argraw+0x30>
    return p->trapframe->a4;
    80001fe8:	713c                	ld	a5,96(a0)
    80001fea:	6bc8                	ld	a0,144(a5)
    80001fec:	b7c5                	j	80001fcc <argraw+0x30>
    return p->trapframe->a5;
    80001fee:	713c                	ld	a5,96(a0)
    80001ff0:	6fc8                	ld	a0,152(a5)
    80001ff2:	bfe9                	j	80001fcc <argraw+0x30>
  panic("argraw");
    80001ff4:	00006517          	auipc	a0,0x6
    80001ff8:	39c50513          	addi	a0,a0,924 # 80008390 <states.1725+0x148>
    80001ffc:	00004097          	auipc	ra,0x4
    80002000:	230080e7          	jalr	560(ra) # 8000622c <panic>

0000000080002004 <fetchaddr>:
{
    80002004:	1101                	addi	sp,sp,-32
    80002006:	ec06                	sd	ra,24(sp)
    80002008:	e822                	sd	s0,16(sp)
    8000200a:	e426                	sd	s1,8(sp)
    8000200c:	e04a                	sd	s2,0(sp)
    8000200e:	1000                	addi	s0,sp,32
    80002010:	84aa                	mv	s1,a0
    80002012:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	fde080e7          	jalr	-34(ra) # 80000ff2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000201c:	693c                	ld	a5,80(a0)
    8000201e:	02f4f863          	bgeu	s1,a5,8000204e <fetchaddr+0x4a>
    80002022:	00848713          	addi	a4,s1,8
    80002026:	02e7e663          	bltu	a5,a4,80002052 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000202a:	46a1                	li	a3,8
    8000202c:	8626                	mv	a2,s1
    8000202e:	85ca                	mv	a1,s2
    80002030:	6d28                	ld	a0,88(a0)
    80002032:	fffff097          	auipc	ra,0xfffff
    80002036:	d0e080e7          	jalr	-754(ra) # 80000d40 <copyin>
    8000203a:	00a03533          	snez	a0,a0
    8000203e:	40a00533          	neg	a0,a0
}
    80002042:	60e2                	ld	ra,24(sp)
    80002044:	6442                	ld	s0,16(sp)
    80002046:	64a2                	ld	s1,8(sp)
    80002048:	6902                	ld	s2,0(sp)
    8000204a:	6105                	addi	sp,sp,32
    8000204c:	8082                	ret
    return -1;
    8000204e:	557d                	li	a0,-1
    80002050:	bfcd                	j	80002042 <fetchaddr+0x3e>
    80002052:	557d                	li	a0,-1
    80002054:	b7fd                	j	80002042 <fetchaddr+0x3e>

0000000080002056 <fetchstr>:
{
    80002056:	7179                	addi	sp,sp,-48
    80002058:	f406                	sd	ra,40(sp)
    8000205a:	f022                	sd	s0,32(sp)
    8000205c:	ec26                	sd	s1,24(sp)
    8000205e:	e84a                	sd	s2,16(sp)
    80002060:	e44e                	sd	s3,8(sp)
    80002062:	1800                	addi	s0,sp,48
    80002064:	892a                	mv	s2,a0
    80002066:	84ae                	mv	s1,a1
    80002068:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	f88080e7          	jalr	-120(ra) # 80000ff2 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002072:	86ce                	mv	a3,s3
    80002074:	864a                	mv	a2,s2
    80002076:	85a6                	mv	a1,s1
    80002078:	6d28                	ld	a0,88(a0)
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	d52080e7          	jalr	-686(ra) # 80000dcc <copyinstr>
  if(err < 0)
    80002082:	00054763          	bltz	a0,80002090 <fetchstr+0x3a>
  return strlen(buf);
    80002086:	8526                	mv	a0,s1
    80002088:	ffffe097          	auipc	ra,0xffffe
    8000208c:	40e080e7          	jalr	1038(ra) # 80000496 <strlen>
}
    80002090:	70a2                	ld	ra,40(sp)
    80002092:	7402                	ld	s0,32(sp)
    80002094:	64e2                	ld	s1,24(sp)
    80002096:	6942                	ld	s2,16(sp)
    80002098:	69a2                	ld	s3,8(sp)
    8000209a:	6145                	addi	sp,sp,48
    8000209c:	8082                	ret

000000008000209e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    8000209e:	1101                	addi	sp,sp,-32
    800020a0:	ec06                	sd	ra,24(sp)
    800020a2:	e822                	sd	s0,16(sp)
    800020a4:	e426                	sd	s1,8(sp)
    800020a6:	1000                	addi	s0,sp,32
    800020a8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020aa:	00000097          	auipc	ra,0x0
    800020ae:	ef2080e7          	jalr	-270(ra) # 80001f9c <argraw>
    800020b2:	c088                	sw	a0,0(s1)
  return 0;
}
    800020b4:	4501                	li	a0,0
    800020b6:	60e2                	ld	ra,24(sp)
    800020b8:	6442                	ld	s0,16(sp)
    800020ba:	64a2                	ld	s1,8(sp)
    800020bc:	6105                	addi	sp,sp,32
    800020be:	8082                	ret

00000000800020c0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	e426                	sd	s1,8(sp)
    800020c8:	1000                	addi	s0,sp,32
    800020ca:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020cc:	00000097          	auipc	ra,0x0
    800020d0:	ed0080e7          	jalr	-304(ra) # 80001f9c <argraw>
    800020d4:	e088                	sd	a0,0(s1)
  return 0;
}
    800020d6:	4501                	li	a0,0
    800020d8:	60e2                	ld	ra,24(sp)
    800020da:	6442                	ld	s0,16(sp)
    800020dc:	64a2                	ld	s1,8(sp)
    800020de:	6105                	addi	sp,sp,32
    800020e0:	8082                	ret

00000000800020e2 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020e2:	1101                	addi	sp,sp,-32
    800020e4:	ec06                	sd	ra,24(sp)
    800020e6:	e822                	sd	s0,16(sp)
    800020e8:	e426                	sd	s1,8(sp)
    800020ea:	e04a                	sd	s2,0(sp)
    800020ec:	1000                	addi	s0,sp,32
    800020ee:	84ae                	mv	s1,a1
    800020f0:	8932                	mv	s2,a2
  *ip = argraw(n);
    800020f2:	00000097          	auipc	ra,0x0
    800020f6:	eaa080e7          	jalr	-342(ra) # 80001f9c <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800020fa:	864a                	mv	a2,s2
    800020fc:	85a6                	mv	a1,s1
    800020fe:	00000097          	auipc	ra,0x0
    80002102:	f58080e7          	jalr	-168(ra) # 80002056 <fetchstr>
}
    80002106:	60e2                	ld	ra,24(sp)
    80002108:	6442                	ld	s0,16(sp)
    8000210a:	64a2                	ld	s1,8(sp)
    8000210c:	6902                	ld	s2,0(sp)
    8000210e:	6105                	addi	sp,sp,32
    80002110:	8082                	ret

0000000080002112 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002112:	1101                	addi	sp,sp,-32
    80002114:	ec06                	sd	ra,24(sp)
    80002116:	e822                	sd	s0,16(sp)
    80002118:	e426                	sd	s1,8(sp)
    8000211a:	e04a                	sd	s2,0(sp)
    8000211c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	ed4080e7          	jalr	-300(ra) # 80000ff2 <myproc>
    80002126:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002128:	06053903          	ld	s2,96(a0)
    8000212c:	0a893783          	ld	a5,168(s2)
    80002130:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002134:	37fd                	addiw	a5,a5,-1
    80002136:	4751                	li	a4,20
    80002138:	00f76f63          	bltu	a4,a5,80002156 <syscall+0x44>
    8000213c:	00369713          	slli	a4,a3,0x3
    80002140:	00006797          	auipc	a5,0x6
    80002144:	29078793          	addi	a5,a5,656 # 800083d0 <syscalls>
    80002148:	97ba                	add	a5,a5,a4
    8000214a:	639c                	ld	a5,0(a5)
    8000214c:	c789                	beqz	a5,80002156 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000214e:	9782                	jalr	a5
    80002150:	06a93823          	sd	a0,112(s2)
    80002154:	a839                	j	80002172 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002156:	16048613          	addi	a2,s1,352
    8000215a:	5c8c                	lw	a1,56(s1)
    8000215c:	00006517          	auipc	a0,0x6
    80002160:	23c50513          	addi	a0,a0,572 # 80008398 <states.1725+0x150>
    80002164:	00004097          	auipc	ra,0x4
    80002168:	112080e7          	jalr	274(ra) # 80006276 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000216c:	70bc                	ld	a5,96(s1)
    8000216e:	577d                	li	a4,-1
    80002170:	fbb8                	sd	a4,112(a5)
  }
}
    80002172:	60e2                	ld	ra,24(sp)
    80002174:	6442                	ld	s0,16(sp)
    80002176:	64a2                	ld	s1,8(sp)
    80002178:	6902                	ld	s2,0(sp)
    8000217a:	6105                	addi	sp,sp,32
    8000217c:	8082                	ret

000000008000217e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000217e:	1101                	addi	sp,sp,-32
    80002180:	ec06                	sd	ra,24(sp)
    80002182:	e822                	sd	s0,16(sp)
    80002184:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002186:	fec40593          	addi	a1,s0,-20
    8000218a:	4501                	li	a0,0
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	f12080e7          	jalr	-238(ra) # 8000209e <argint>
    return -1;
    80002194:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002196:	00054963          	bltz	a0,800021a8 <sys_exit+0x2a>
  exit(n);
    8000219a:	fec42503          	lw	a0,-20(s0)
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	76c080e7          	jalr	1900(ra) # 8000190a <exit>
  return 0;  // not reached
    800021a6:	4781                	li	a5,0
}
    800021a8:	853e                	mv	a0,a5
    800021aa:	60e2                	ld	ra,24(sp)
    800021ac:	6442                	ld	s0,16(sp)
    800021ae:	6105                	addi	sp,sp,32
    800021b0:	8082                	ret

00000000800021b2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021b2:	1141                	addi	sp,sp,-16
    800021b4:	e406                	sd	ra,8(sp)
    800021b6:	e022                	sd	s0,0(sp)
    800021b8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021ba:	fffff097          	auipc	ra,0xfffff
    800021be:	e38080e7          	jalr	-456(ra) # 80000ff2 <myproc>
}
    800021c2:	5d08                	lw	a0,56(a0)
    800021c4:	60a2                	ld	ra,8(sp)
    800021c6:	6402                	ld	s0,0(sp)
    800021c8:	0141                	addi	sp,sp,16
    800021ca:	8082                	ret

00000000800021cc <sys_fork>:

uint64
sys_fork(void)
{
    800021cc:	1141                	addi	sp,sp,-16
    800021ce:	e406                	sd	ra,8(sp)
    800021d0:	e022                	sd	s0,0(sp)
    800021d2:	0800                	addi	s0,sp,16
  return fork();
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	1ec080e7          	jalr	492(ra) # 800013c0 <fork>
}
    800021dc:	60a2                	ld	ra,8(sp)
    800021de:	6402                	ld	s0,0(sp)
    800021e0:	0141                	addi	sp,sp,16
    800021e2:	8082                	ret

00000000800021e4 <sys_wait>:

uint64
sys_wait(void)
{
    800021e4:	1101                	addi	sp,sp,-32
    800021e6:	ec06                	sd	ra,24(sp)
    800021e8:	e822                	sd	s0,16(sp)
    800021ea:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800021ec:	fe840593          	addi	a1,s0,-24
    800021f0:	4501                	li	a0,0
    800021f2:	00000097          	auipc	ra,0x0
    800021f6:	ece080e7          	jalr	-306(ra) # 800020c0 <argaddr>
    800021fa:	87aa                	mv	a5,a0
    return -1;
    800021fc:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800021fe:	0007c863          	bltz	a5,8000220e <sys_wait+0x2a>
  return wait(p);
    80002202:	fe843503          	ld	a0,-24(s0)
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	50c080e7          	jalr	1292(ra) # 80001712 <wait>
}
    8000220e:	60e2                	ld	ra,24(sp)
    80002210:	6442                	ld	s0,16(sp)
    80002212:	6105                	addi	sp,sp,32
    80002214:	8082                	ret

0000000080002216 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002216:	7179                	addi	sp,sp,-48
    80002218:	f406                	sd	ra,40(sp)
    8000221a:	f022                	sd	s0,32(sp)
    8000221c:	ec26                	sd	s1,24(sp)
    8000221e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002220:	fdc40593          	addi	a1,s0,-36
    80002224:	4501                	li	a0,0
    80002226:	00000097          	auipc	ra,0x0
    8000222a:	e78080e7          	jalr	-392(ra) # 8000209e <argint>
    8000222e:	87aa                	mv	a5,a0
    return -1;
    80002230:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002232:	0207c063          	bltz	a5,80002252 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002236:	fffff097          	auipc	ra,0xfffff
    8000223a:	dbc080e7          	jalr	-580(ra) # 80000ff2 <myproc>
    8000223e:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002240:	fdc42503          	lw	a0,-36(s0)
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	108080e7          	jalr	264(ra) # 8000134c <growproc>
    8000224c:	00054863          	bltz	a0,8000225c <sys_sbrk+0x46>
    return -1;
  return addr;
    80002250:	8526                	mv	a0,s1
}
    80002252:	70a2                	ld	ra,40(sp)
    80002254:	7402                	ld	s0,32(sp)
    80002256:	64e2                	ld	s1,24(sp)
    80002258:	6145                	addi	sp,sp,48
    8000225a:	8082                	ret
    return -1;
    8000225c:	557d                	li	a0,-1
    8000225e:	bfd5                	j	80002252 <sys_sbrk+0x3c>

0000000080002260 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002260:	7139                	addi	sp,sp,-64
    80002262:	fc06                	sd	ra,56(sp)
    80002264:	f822                	sd	s0,48(sp)
    80002266:	f426                	sd	s1,40(sp)
    80002268:	f04a                	sd	s2,32(sp)
    8000226a:	ec4e                	sd	s3,24(sp)
    8000226c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    8000226e:	fcc40593          	addi	a1,s0,-52
    80002272:	4501                	li	a0,0
    80002274:	00000097          	auipc	ra,0x0
    80002278:	e2a080e7          	jalr	-470(ra) # 8000209e <argint>
    return -1;
    8000227c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000227e:	06054563          	bltz	a0,800022e8 <sys_sleep+0x88>
  acquire(&tickslock);
    80002282:	0000d517          	auipc	a0,0xd
    80002286:	f6e50513          	addi	a0,a0,-146 # 8000f1f0 <tickslock>
    8000228a:	00004097          	auipc	ra,0x4
    8000228e:	4d6080e7          	jalr	1238(ra) # 80006760 <acquire>
  ticks0 = ticks;
    80002292:	00007917          	auipc	s2,0x7
    80002296:	d8692903          	lw	s2,-634(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000229a:	fcc42783          	lw	a5,-52(s0)
    8000229e:	cf85                	beqz	a5,800022d6 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022a0:	0000d997          	auipc	s3,0xd
    800022a4:	f5098993          	addi	s3,s3,-176 # 8000f1f0 <tickslock>
    800022a8:	00007497          	auipc	s1,0x7
    800022ac:	d7048493          	addi	s1,s1,-656 # 80009018 <ticks>
    if(myproc()->killed){
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	d42080e7          	jalr	-702(ra) # 80000ff2 <myproc>
    800022b8:	591c                	lw	a5,48(a0)
    800022ba:	ef9d                	bnez	a5,800022f8 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022bc:	85ce                	mv	a1,s3
    800022be:	8526                	mv	a0,s1
    800022c0:	fffff097          	auipc	ra,0xfffff
    800022c4:	3ee080e7          	jalr	1006(ra) # 800016ae <sleep>
  while(ticks - ticks0 < n){
    800022c8:	409c                	lw	a5,0(s1)
    800022ca:	412787bb          	subw	a5,a5,s2
    800022ce:	fcc42703          	lw	a4,-52(s0)
    800022d2:	fce7efe3          	bltu	a5,a4,800022b0 <sys_sleep+0x50>
  }
  release(&tickslock);
    800022d6:	0000d517          	auipc	a0,0xd
    800022da:	f1a50513          	addi	a0,a0,-230 # 8000f1f0 <tickslock>
    800022de:	00004097          	auipc	ra,0x4
    800022e2:	552080e7          	jalr	1362(ra) # 80006830 <release>
  return 0;
    800022e6:	4781                	li	a5,0
}
    800022e8:	853e                	mv	a0,a5
    800022ea:	70e2                	ld	ra,56(sp)
    800022ec:	7442                	ld	s0,48(sp)
    800022ee:	74a2                	ld	s1,40(sp)
    800022f0:	7902                	ld	s2,32(sp)
    800022f2:	69e2                	ld	s3,24(sp)
    800022f4:	6121                	addi	sp,sp,64
    800022f6:	8082                	ret
      release(&tickslock);
    800022f8:	0000d517          	auipc	a0,0xd
    800022fc:	ef850513          	addi	a0,a0,-264 # 8000f1f0 <tickslock>
    80002300:	00004097          	auipc	ra,0x4
    80002304:	530080e7          	jalr	1328(ra) # 80006830 <release>
      return -1;
    80002308:	57fd                	li	a5,-1
    8000230a:	bff9                	j	800022e8 <sys_sleep+0x88>

000000008000230c <sys_kill>:

uint64
sys_kill(void)
{
    8000230c:	1101                	addi	sp,sp,-32
    8000230e:	ec06                	sd	ra,24(sp)
    80002310:	e822                	sd	s0,16(sp)
    80002312:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002314:	fec40593          	addi	a1,s0,-20
    80002318:	4501                	li	a0,0
    8000231a:	00000097          	auipc	ra,0x0
    8000231e:	d84080e7          	jalr	-636(ra) # 8000209e <argint>
    80002322:	87aa                	mv	a5,a0
    return -1;
    80002324:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002326:	0007c863          	bltz	a5,80002336 <sys_kill+0x2a>
  return kill(pid);
    8000232a:	fec42503          	lw	a0,-20(s0)
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	6b2080e7          	jalr	1714(ra) # 800019e0 <kill>
}
    80002336:	60e2                	ld	ra,24(sp)
    80002338:	6442                	ld	s0,16(sp)
    8000233a:	6105                	addi	sp,sp,32
    8000233c:	8082                	ret

000000008000233e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000233e:	1101                	addi	sp,sp,-32
    80002340:	ec06                	sd	ra,24(sp)
    80002342:	e822                	sd	s0,16(sp)
    80002344:	e426                	sd	s1,8(sp)
    80002346:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002348:	0000d517          	auipc	a0,0xd
    8000234c:	ea850513          	addi	a0,a0,-344 # 8000f1f0 <tickslock>
    80002350:	00004097          	auipc	ra,0x4
    80002354:	410080e7          	jalr	1040(ra) # 80006760 <acquire>
  xticks = ticks;
    80002358:	00007497          	auipc	s1,0x7
    8000235c:	cc04a483          	lw	s1,-832(s1) # 80009018 <ticks>
  release(&tickslock);
    80002360:	0000d517          	auipc	a0,0xd
    80002364:	e9050513          	addi	a0,a0,-368 # 8000f1f0 <tickslock>
    80002368:	00004097          	auipc	ra,0x4
    8000236c:	4c8080e7          	jalr	1224(ra) # 80006830 <release>
  return xticks;
}
    80002370:	02049513          	slli	a0,s1,0x20
    80002374:	9101                	srli	a0,a0,0x20
    80002376:	60e2                	ld	ra,24(sp)
    80002378:	6442                	ld	s0,16(sp)
    8000237a:	64a2                	ld	s1,8(sp)
    8000237c:	6105                	addi	sp,sp,32
    8000237e:	8082                	ret

0000000080002380 <binit>:
} bcache;


void
binit(void)
{
    80002380:	7179                	addi	sp,sp,-48
    80002382:	f406                	sd	ra,40(sp)
    80002384:	f022                	sd	s0,32(sp)
    80002386:	ec26                	sd	s1,24(sp)
    80002388:	e84a                	sd	s2,16(sp)
    8000238a:	e44e                	sd	s3,8(sp)
    8000238c:	e052                	sd	s4,0(sp)
    8000238e:	1800                	addi	s0,sp,48
  int i;
  struct buf *b;

  bcache.size = 0;  // lab8-2
    80002390:	0000d917          	auipc	s2,0xd
    80002394:	e8090913          	addi	s2,s2,-384 # 8000f210 <bcache>
    80002398:	00015797          	auipc	a5,0x15
    8000239c:	1c07ac23          	sw	zero,472(a5) # 80017570 <bcache+0x8360>
  initlock(&bcache.lock, "bcache");
    800023a0:	00006597          	auipc	a1,0x6
    800023a4:	0e058593          	addi	a1,a1,224 # 80008480 <syscalls+0xb0>
    800023a8:	854a                	mv	a0,s2
    800023aa:	00004097          	auipc	ra,0x4
    800023ae:	532080e7          	jalr	1330(ra) # 800068dc <initlock>
  initlock(&bcache.hashlock, "bcache_hash");    // init hash lock - lab8-2
    800023b2:	00006597          	auipc	a1,0x6
    800023b6:	0d658593          	addi	a1,a1,214 # 80008488 <syscalls+0xb8>
    800023ba:	00019517          	auipc	a0,0x19
    800023be:	c3e50513          	addi	a0,a0,-962 # 8001aff8 <bcache+0xbde8>
    800023c2:	00004097          	auipc	ra,0x4
    800023c6:	51a080e7          	jalr	1306(ra) # 800068dc <initlock>
  // init all buckets' locks  - lab8-2
  for(i = 0; i < NBUCKET; ++i) {
    800023ca:	00019497          	auipc	s1,0x19
    800023ce:	a8e48493          	addi	s1,s1,-1394 # 8001ae58 <bcache+0xbc48>
    800023d2:	00019a17          	auipc	s4,0x19
    800023d6:	c26a0a13          	addi	s4,s4,-986 # 8001aff8 <bcache+0xbde8>
    initlock(&bcache.locks[i], "bcache_bucket");
    800023da:	00006997          	auipc	s3,0x6
    800023de:	0be98993          	addi	s3,s3,190 # 80008498 <syscalls+0xc8>
    800023e2:	85ce                	mv	a1,s3
    800023e4:	8526                	mv	a0,s1
    800023e6:	00004097          	auipc	ra,0x4
    800023ea:	4f6080e7          	jalr	1270(ra) # 800068dc <initlock>
  for(i = 0; i < NBUCKET; ++i) {
    800023ee:	02048493          	addi	s1,s1,32
    800023f2:	ff4498e3          	bne	s1,s4,800023e2 <binit+0x62>
    800023f6:	0000d497          	auipc	s1,0xd
    800023fa:	e4a48493          	addi	s1,s1,-438 # 8000f240 <bcache+0x30>
    800023fe:	67a1                	lui	a5,0x8
    80002400:	37078793          	addi	a5,a5,880 # 8370 <_entry-0x7fff7c90>
    80002404:	993e                	add	s2,s2,a5
//  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
// lab8-2
//    b->next = bcache.head.next;
//    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    80002406:	00006997          	auipc	s3,0x6
    8000240a:	0a298993          	addi	s3,s3,162 # 800084a8 <syscalls+0xd8>
    8000240e:	85ce                	mv	a1,s3
    80002410:	8526                	mv	a0,s1
    80002412:	00001097          	auipc	ra,0x1
    80002416:	6b8080e7          	jalr	1720(ra) # 80003aca <initsleeplock>
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000241a:	46048493          	addi	s1,s1,1120
    8000241e:	ff2498e3          	bne	s1,s2,8000240e <binit+0x8e>
//    bcache.head.next->prev = b;
//    bcache.head.next = b;
  }
}
    80002422:	70a2                	ld	ra,40(sp)
    80002424:	7402                	ld	s0,32(sp)
    80002426:	64e2                	ld	s1,24(sp)
    80002428:	6942                	ld	s2,16(sp)
    8000242a:	69a2                	ld	s3,8(sp)
    8000242c:	6a02                	ld	s4,0(sp)
    8000242e:	6145                	addi	sp,sp,48
    80002430:	8082                	ret

0000000080002432 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002432:	7119                	addi	sp,sp,-128
    80002434:	fc86                	sd	ra,120(sp)
    80002436:	f8a2                	sd	s0,112(sp)
    80002438:	f4a6                	sd	s1,104(sp)
    8000243a:	f0ca                	sd	s2,96(sp)
    8000243c:	ecce                	sd	s3,88(sp)
    8000243e:	e8d2                	sd	s4,80(sp)
    80002440:	e4d6                	sd	s5,72(sp)
    80002442:	e0da                	sd	s6,64(sp)
    80002444:	fc5e                	sd	s7,56(sp)
    80002446:	f862                	sd	s8,48(sp)
    80002448:	f466                	sd	s9,40(sp)
    8000244a:	f06a                	sd	s10,32(sp)
    8000244c:	ec6e                	sd	s11,24(sp)
    8000244e:	0100                	addi	s0,sp,128
    80002450:	8baa                	mv	s7,a0
    80002452:	8b2e                	mv	s6,a1
  int idx = HASH(blockno);
    80002454:	4a35                	li	s4,13
    80002456:	0345fa3b          	remuw	s4,a1,s4
    8000245a:	000a0d1b          	sext.w	s10,s4
    8000245e:	8a6a                	mv	s4,s10
  acquire(&bcache.locks[idx]);  // lab8-2
    80002460:	5e2d0993          	addi	s3,s10,1506
    80002464:	0996                	slli	s3,s3,0x5
    80002466:	09a1                	addi	s3,s3,8
    80002468:	0000d497          	auipc	s1,0xd
    8000246c:	da848493          	addi	s1,s1,-600 # 8000f210 <bcache>
    80002470:	99a6                	add	s3,s3,s1
    80002472:	854e                	mv	a0,s3
    80002474:	00004097          	auipc	ra,0x4
    80002478:	2ec080e7          	jalr	748(ra) # 80006760 <acquire>
  for(b = bcache.buckets[idx].next; b; b = b->next){
    8000247c:	46000793          	li	a5,1120
    80002480:	02fd07b3          	mul	a5,s10,a5
    80002484:	94be                	add	s1,s1,a5
    80002486:	67a1                	lui	a5,0x8
    80002488:	94be                	add	s1,s1,a5
    8000248a:	3b84b483          	ld	s1,952(s1)
    8000248e:	ecb9                	bnez	s1,800024ec <bread+0xba>
  acquire(&bcache.lock);
    80002490:	0000d517          	auipc	a0,0xd
    80002494:	d8050513          	addi	a0,a0,-640 # 8000f210 <bcache>
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	2c8080e7          	jalr	712(ra) # 80006760 <acquire>
  if(bcache.size < NBUF) {
    800024a0:	00015517          	auipc	a0,0x15
    800024a4:	0d052503          	lw	a0,208(a0) # 80017570 <bcache+0x8360>
    800024a8:	47f5                	li	a5,29
    800024aa:	06a7d663          	bge	a5,a0,80002516 <bread+0xe4>
  release(&bcache.lock);
    800024ae:	0000d517          	auipc	a0,0xd
    800024b2:	d6250513          	addi	a0,a0,-670 # 8000f210 <bcache>
    800024b6:	00004097          	auipc	ra,0x4
    800024ba:	37a080e7          	jalr	890(ra) # 80006830 <release>
  release(&bcache.locks[idx]);
    800024be:	854e                	mv	a0,s3
    800024c0:	00004097          	auipc	ra,0x4
    800024c4:	370080e7          	jalr	880(ra) # 80006830 <release>
  acquire(&bcache.hashlock);
    800024c8:	00019517          	auipc	a0,0x19
    800024cc:	b3050513          	addi	a0,a0,-1232 # 8001aff8 <bcache+0xbde8>
    800024d0:	00004097          	auipc	ra,0x4
    800024d4:	290080e7          	jalr	656(ra) # 80006760 <acquire>
  int idx = HASH(blockno);
    800024d8:	8ad2                	mv	s5,s4
  acquire(&bcache.hashlock);
    800024da:	4cb5                	li	s9,13
      acquire(&bcache.locks[idx]);
    800024dc:	0000dc17          	auipc	s8,0xd
    800024e0:	d34c0c13          	addi	s8,s8,-716 # 8000f210 <bcache>
      for(pre = &bcache.buckets[idx], b = pre->next; b; pre = b, b = b->next) {
    800024e4:	6da1                	lui	s11,0x8
    800024e6:	aa35                	j	80002622 <bread+0x1f0>
  for(b = bcache.buckets[idx].next; b; b = b->next){
    800024e8:	68a4                	ld	s1,80(s1)
    800024ea:	d0dd                	beqz	s1,80002490 <bread+0x5e>
    if(b->dev == dev && b->blockno == blockno){
    800024ec:	449c                	lw	a5,8(s1)
    800024ee:	ff779de3          	bne	a5,s7,800024e8 <bread+0xb6>
    800024f2:	44dc                	lw	a5,12(s1)
    800024f4:	ff679ae3          	bne	a5,s6,800024e8 <bread+0xb6>
      b->refcnt++;
    800024f8:	44bc                	lw	a5,72(s1)
    800024fa:	2785                	addiw	a5,a5,1
    800024fc:	c4bc                	sw	a5,72(s1)
      release(&bcache.locks[idx]);  // lab8-2
    800024fe:	854e                	mv	a0,s3
    80002500:	00004097          	auipc	ra,0x4
    80002504:	330080e7          	jalr	816(ra) # 80006830 <release>
      acquiresleep(&b->lock);
    80002508:	01048513          	addi	a0,s1,16
    8000250c:	00001097          	auipc	ra,0x1
    80002510:	5f8080e7          	jalr	1528(ra) # 80003b04 <acquiresleep>
      return b;
    80002514:	a0bd                	j	80002582 <bread+0x150>
    b = &bcache.buf[bcache.size++];
    80002516:	0000dc17          	auipc	s8,0xd
    8000251a:	cfac0c13          	addi	s8,s8,-774 # 8000f210 <bcache>
    8000251e:	0015079b          	addiw	a5,a0,1
    80002522:	00015717          	auipc	a4,0x15
    80002526:	04f72723          	sw	a5,78(a4) # 80017570 <bcache+0x8360>
    8000252a:	46000a93          	li	s5,1120
    8000252e:	03550933          	mul	s2,a0,s5
    80002532:	02090493          	addi	s1,s2,32
    80002536:	94e2                	add	s1,s1,s8
    release(&bcache.lock);
    80002538:	8562                	mv	a0,s8
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	2f6080e7          	jalr	758(ra) # 80006830 <release>
    b->dev = dev;
    80002542:	012c07b3          	add	a5,s8,s2
    80002546:	0377a423          	sw	s7,40(a5) # 8028 <_entry-0x7fff7fd8>
    b->blockno = blockno;
    8000254a:	0367a623          	sw	s6,44(a5)
    b->valid = 0;
    8000254e:	0207a023          	sw	zero,32(a5)
    b->refcnt = 1;
    80002552:	4705                	li	a4,1
    80002554:	d7b8                	sw	a4,104(a5)
    b->next = bcache.buckets[idx].next;
    80002556:	035a0a33          	mul	s4,s4,s5
    8000255a:	9a62                	add	s4,s4,s8
    8000255c:	6aa1                	lui	s5,0x8
    8000255e:	9a56                	add	s4,s4,s5
    80002560:	3b8a3703          	ld	a4,952(s4)
    80002564:	fbb8                	sd	a4,112(a5)
    bcache.buckets[idx].next = b;
    80002566:	3a9a3c23          	sd	s1,952(s4)
    release(&bcache.locks[idx]);
    8000256a:	854e                	mv	a0,s3
    8000256c:	00004097          	auipc	ra,0x4
    80002570:	2c4080e7          	jalr	708(ra) # 80006830 <release>
    acquiresleep(&b->lock);
    80002574:	03090513          	addi	a0,s2,48
    80002578:	9562                	add	a0,a0,s8
    8000257a:	00001097          	auipc	ra,0x1
    8000257e:	58a080e7          	jalr	1418(ra) # 80003b04 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002582:	409c                	lw	a5,0(s1)
    80002584:	16078e63          	beqz	a5,80002700 <bread+0x2ce>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002588:	8526                	mv	a0,s1
    8000258a:	70e6                	ld	ra,120(sp)
    8000258c:	7446                	ld	s0,112(sp)
    8000258e:	74a6                	ld	s1,104(sp)
    80002590:	7906                	ld	s2,96(sp)
    80002592:	69e6                	ld	s3,88(sp)
    80002594:	6a46                	ld	s4,80(sp)
    80002596:	6aa6                	ld	s5,72(sp)
    80002598:	6b06                	ld	s6,64(sp)
    8000259a:	7be2                	ld	s7,56(sp)
    8000259c:	7c42                	ld	s8,48(sp)
    8000259e:	7ca2                	ld	s9,40(sp)
    800025a0:	7d02                	ld	s10,32(sp)
    800025a2:	6de2                	ld	s11,24(sp)
    800025a4:	6109                	addi	sp,sp,128
    800025a6:	8082                	ret
          if(idx == HASH(blockno) && b->dev == dev && b->blockno == blockno){
    800025a8:	449c                	lw	a5,8(s1)
    800025aa:	05779263          	bne	a5,s7,800025ee <bread+0x1bc>
    800025ae:	44dc                	lw	a5,12(s1)
    800025b0:	03679f63          	bne	a5,s6,800025ee <bread+0x1bc>
              b->refcnt++;
    800025b4:	44bc                	lw	a5,72(s1)
    800025b6:	2785                	addiw	a5,a5,1
    800025b8:	c4bc                	sw	a5,72(s1)
              release(&bcache.locks[idx]);
    800025ba:	854a                	mv	a0,s2
    800025bc:	00004097          	auipc	ra,0x4
    800025c0:	274080e7          	jalr	628(ra) # 80006830 <release>
              release(&bcache.hashlock);
    800025c4:	00019517          	auipc	a0,0x19
    800025c8:	a3450513          	addi	a0,a0,-1484 # 8001aff8 <bcache+0xbde8>
    800025cc:	00004097          	auipc	ra,0x4
    800025d0:	264080e7          	jalr	612(ra) # 80006830 <release>
              acquiresleep(&b->lock);
    800025d4:	01048513          	addi	a0,s1,16
    800025d8:	00001097          	auipc	ra,0x1
    800025dc:	52c080e7          	jalr	1324(ra) # 80003b04 <acquiresleep>
              return b;
    800025e0:	b74d                	j	80002582 <bread+0x150>
      for(pre = &bcache.buckets[idx], b = pre->next; b; pre = b, b = b->next) {
    800025e2:	68bc                	ld	a5,80(s1)
    800025e4:	c395                	beqz	a5,80002608 <bread+0x1d6>
  acquire(&bcache.hashlock);
    800025e6:	8726                	mv	a4,s1
    800025e8:	84be                	mv	s1,a5
          if(idx == HASH(blockno) && b->dev == dev && b->blockno == blockno){
    800025ea:	faad0fe3          	beq	s10,a0,800025a8 <bread+0x176>
          if(b->refcnt == 0 && b->timestamp < mintimestamp) {
    800025ee:	44bc                	lw	a5,72(s1)
    800025f0:	fbed                	bnez	a5,800025e2 <bread+0x1b0>
    800025f2:	4584a583          	lw	a1,1112(s1)
    800025f6:	fec5f6e3          	bgeu	a1,a2,800025e2 <bread+0x1b0>
      for(pre = &bcache.buckets[idx], b = pre->next; b; pre = b, b = b->next) {
    800025fa:	68bc                	ld	a5,80(s1)
    800025fc:	c3bd                	beqz	a5,80002662 <bread+0x230>
              mintimestamp = b->timestamp;
    800025fe:	862e                	mv	a2,a1
      for(pre = &bcache.buckets[idx], b = pre->next; b; pre = b, b = b->next) {
    80002600:	f8e43423          	sd	a4,-120(s0)
    80002604:	86a6                	mv	a3,s1
    80002606:	b7c5                	j	800025e6 <bread+0x1b4>
      if(minb) {
    80002608:	eab1                	bnez	a3,8000265c <bread+0x22a>
      release(&bcache.locks[idx]);
    8000260a:	854a                	mv	a0,s2
    8000260c:	00004097          	auipc	ra,0x4
    80002610:	224080e7          	jalr	548(ra) # 80006830 <release>
      if(++idx == NBUCKET) {
    80002614:	2a85                	addiw	s5,s5,1
    80002616:	47b5                	li	a5,13
    80002618:	0cfa8a63          	beq	s5,a5,800026ec <bread+0x2ba>
  for(i = 0; i < NBUCKET; ++i) {
    8000261c:	3cfd                	addiw	s9,s9,-1
    8000261e:	0c0c8963          	beqz	s9,800026f0 <bread+0x2be>
      acquire(&bcache.locks[idx]);
    80002622:	5e2a8913          	addi	s2,s5,1506 # 85e2 <_entry-0x7fff7a1e>
    80002626:	0916                	slli	s2,s2,0x5
    80002628:	0921                	addi	s2,s2,8
    8000262a:	9962                	add	s2,s2,s8
    8000262c:	854a                	mv	a0,s2
    8000262e:	00004097          	auipc	ra,0x4
    80002632:	132080e7          	jalr	306(ra) # 80006760 <acquire>
      for(pre = &bcache.buckets[idx], b = pre->next; b; pre = b, b = b->next) {
    80002636:	46000793          	li	a5,1120
    8000263a:	02fa87b3          	mul	a5,s5,a5
    8000263e:	6721                	lui	a4,0x8
    80002640:	36870713          	addi	a4,a4,872 # 8368 <_entry-0x7fff7c98>
    80002644:	973e                	add	a4,a4,a5
    80002646:	9762                	add	a4,a4,s8
    80002648:	97e2                	add	a5,a5,s8
    8000264a:	97ee                	add	a5,a5,s11
    8000264c:	3b87b483          	ld	s1,952(a5)
    80002650:	dccd                	beqz	s1,8000260a <bread+0x1d8>
    80002652:	4681                	li	a3,0
      mintimestamp = -1;
    80002654:	567d                	li	a2,-1
          if(idx == HASH(blockno) && b->dev == dev && b->blockno == blockno){
    80002656:	000a851b          	sext.w	a0,s5
    8000265a:	bf41                	j	800025ea <bread+0x1b8>
    8000265c:	f8843703          	ld	a4,-120(s0)
    80002660:	84b6                	mv	s1,a3
          minb->dev = dev;
    80002662:	0174a423          	sw	s7,8(s1)
          minb->blockno = blockno;
    80002666:	0164a623          	sw	s6,12(s1)
          minb->valid = 0;
    8000266a:	0004a023          	sw	zero,0(s1)
          minb->refcnt = 1;
    8000266e:	4785                	li	a5,1
    80002670:	c4bc                	sw	a5,72(s1)
          if(idx != HASH(blockno)) {
    80002672:	000a879b          	sext.w	a5,s5
    80002676:	02fd1d63          	bne	s10,a5,800026b0 <bread+0x27e>
          release(&bcache.locks[idx]);
    8000267a:	5e2a8a93          	addi	s5,s5,1506
    8000267e:	0a96                	slli	s5,s5,0x5
    80002680:	0000d517          	auipc	a0,0xd
    80002684:	b9850513          	addi	a0,a0,-1128 # 8000f218 <bcache+0x8>
    80002688:	9556                	add	a0,a0,s5
    8000268a:	00004097          	auipc	ra,0x4
    8000268e:	1a6080e7          	jalr	422(ra) # 80006830 <release>
          release(&bcache.hashlock);
    80002692:	00019517          	auipc	a0,0x19
    80002696:	96650513          	addi	a0,a0,-1690 # 8001aff8 <bcache+0xbde8>
    8000269a:	00004097          	auipc	ra,0x4
    8000269e:	196080e7          	jalr	406(ra) # 80006830 <release>
          acquiresleep(&minb->lock);
    800026a2:	01048513          	addi	a0,s1,16
    800026a6:	00001097          	auipc	ra,0x1
    800026aa:	45e080e7          	jalr	1118(ra) # 80003b04 <acquiresleep>
          return minb;
    800026ae:	bdd1                	j	80002582 <bread+0x150>
              minpre->next = minb->next;    // remove block
    800026b0:	68bc                	ld	a5,80(s1)
    800026b2:	eb3c                	sd	a5,80(a4)
              release(&bcache.locks[idx]);
    800026b4:	854a                	mv	a0,s2
    800026b6:	00004097          	auipc	ra,0x4
    800026ba:	17a080e7          	jalr	378(ra) # 80006830 <release>
              acquire(&bcache.locks[idx]);
    800026be:	854e                	mv	a0,s3
    800026c0:	00004097          	auipc	ra,0x4
    800026c4:	0a0080e7          	jalr	160(ra) # 80006760 <acquire>
              minb->next = bcache.buckets[idx].next;    // move block to correct bucket
    800026c8:	46000713          	li	a4,1120
    800026cc:	02ea0733          	mul	a4,s4,a4
    800026d0:	0000d797          	auipc	a5,0xd
    800026d4:	b4078793          	addi	a5,a5,-1216 # 8000f210 <bcache>
    800026d8:	973e                	add	a4,a4,a5
    800026da:	67a1                	lui	a5,0x8
    800026dc:	97ba                	add	a5,a5,a4
    800026de:	3b87b703          	ld	a4,952(a5) # 83b8 <_entry-0x7fff7c48>
    800026e2:	e8b8                	sd	a4,80(s1)
              bcache.buckets[idx].next = minb;
    800026e4:	3a97bc23          	sd	s1,952(a5)
              idx = HASH(blockno);  // the correct bucket index
    800026e8:	8ad2                	mv	s5,s4
    800026ea:	bf41                	j	8000267a <bread+0x248>
          idx = 0;
    800026ec:	4a81                	li	s5,0
    800026ee:	b73d                	j	8000261c <bread+0x1ea>
  panic("bget: no buffers");
    800026f0:	00006517          	auipc	a0,0x6
    800026f4:	dc050513          	addi	a0,a0,-576 # 800084b0 <syscalls+0xe0>
    800026f8:	00004097          	auipc	ra,0x4
    800026fc:	b34080e7          	jalr	-1228(ra) # 8000622c <panic>
    virtio_disk_rw(b, 0);
    80002700:	4581                	li	a1,0
    80002702:	8526                	mv	a0,s1
    80002704:	00003097          	auipc	ra,0x3
    80002708:	f32080e7          	jalr	-206(ra) # 80005636 <virtio_disk_rw>
    b->valid = 1;
    8000270c:	4785                	li	a5,1
    8000270e:	c09c                	sw	a5,0(s1)
  return b;
    80002710:	bda5                	j	80002588 <bread+0x156>

0000000080002712 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002712:	1101                	addi	sp,sp,-32
    80002714:	ec06                	sd	ra,24(sp)
    80002716:	e822                	sd	s0,16(sp)
    80002718:	e426                	sd	s1,8(sp)
    8000271a:	1000                	addi	s0,sp,32
    8000271c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000271e:	0541                	addi	a0,a0,16
    80002720:	00001097          	auipc	ra,0x1
    80002724:	47e080e7          	jalr	1150(ra) # 80003b9e <holdingsleep>
    80002728:	cd01                	beqz	a0,80002740 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000272a:	4585                	li	a1,1
    8000272c:	8526                	mv	a0,s1
    8000272e:	00003097          	auipc	ra,0x3
    80002732:	f08080e7          	jalr	-248(ra) # 80005636 <virtio_disk_rw>
}
    80002736:	60e2                	ld	ra,24(sp)
    80002738:	6442                	ld	s0,16(sp)
    8000273a:	64a2                	ld	s1,8(sp)
    8000273c:	6105                	addi	sp,sp,32
    8000273e:	8082                	ret
    panic("bwrite");
    80002740:	00006517          	auipc	a0,0x6
    80002744:	d8850513          	addi	a0,a0,-632 # 800084c8 <syscalls+0xf8>
    80002748:	00004097          	auipc	ra,0x4
    8000274c:	ae4080e7          	jalr	-1308(ra) # 8000622c <panic>

0000000080002750 <brelse>:
// Move to the head of the most-recently-used list.
extern uint ticks;  // lab8-2

void
brelse(struct buf *b)
{
    80002750:	1101                	addi	sp,sp,-32
    80002752:	ec06                	sd	ra,24(sp)
    80002754:	e822                	sd	s0,16(sp)
    80002756:	e426                	sd	s1,8(sp)
    80002758:	e04a                	sd	s2,0(sp)
    8000275a:	1000                	addi	s0,sp,32
    8000275c:	892a                	mv	s2,a0
  int idx;
  if(!holdingsleep(&b->lock))
    8000275e:	01050493          	addi	s1,a0,16
    80002762:	8526                	mv	a0,s1
    80002764:	00001097          	auipc	ra,0x1
    80002768:	43a080e7          	jalr	1082(ra) # 80003b9e <holdingsleep>
    8000276c:	c12d                	beqz	a0,800027ce <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
    8000276e:	8526                	mv	a0,s1
    80002770:	00001097          	auipc	ra,0x1
    80002774:	3ea080e7          	jalr	1002(ra) # 80003b5a <releasesleep>

  // change the lock - lab8-2
  idx = HASH(b->blockno);
    80002778:	00c92483          	lw	s1,12(s2)
  acquire(&bcache.locks[idx]);
    8000277c:	47b5                	li	a5,13
    8000277e:	02f4f4bb          	remuw	s1,s1,a5
    80002782:	5e248493          	addi	s1,s1,1506
    80002786:	0496                	slli	s1,s1,0x5
    80002788:	0000d797          	auipc	a5,0xd
    8000278c:	a9078793          	addi	a5,a5,-1392 # 8000f218 <bcache+0x8>
    80002790:	94be                	add	s1,s1,a5
    80002792:	8526                	mv	a0,s1
    80002794:	00004097          	auipc	ra,0x4
    80002798:	fcc080e7          	jalr	-52(ra) # 80006760 <acquire>
  b->refcnt--;
    8000279c:	04892783          	lw	a5,72(s2)
    800027a0:	37fd                	addiw	a5,a5,-1
    800027a2:	0007871b          	sext.w	a4,a5
    800027a6:	04f92423          	sw	a5,72(s2)
  if (b->refcnt == 0) {
    800027aa:	e719                	bnez	a4,800027b8 <brelse+0x68>
//    b->prev->next = b->next;
//    b->next = bcache.head.next;
//    b->prev = &bcache.head;
//    bcache.head.next->prev = b;
//    bcache.head.next = b;
    b->timestamp = ticks;
    800027ac:	00007797          	auipc	a5,0x7
    800027b0:	86c7a783          	lw	a5,-1940(a5) # 80009018 <ticks>
    800027b4:	44f92c23          	sw	a5,1112(s2)
  }
  
  release(&bcache.locks[idx]);
    800027b8:	8526                	mv	a0,s1
    800027ba:	00004097          	auipc	ra,0x4
    800027be:	076080e7          	jalr	118(ra) # 80006830 <release>
}
    800027c2:	60e2                	ld	ra,24(sp)
    800027c4:	6442                	ld	s0,16(sp)
    800027c6:	64a2                	ld	s1,8(sp)
    800027c8:	6902                	ld	s2,0(sp)
    800027ca:	6105                	addi	sp,sp,32
    800027cc:	8082                	ret
    panic("brelse");
    800027ce:	00006517          	auipc	a0,0x6
    800027d2:	d0250513          	addi	a0,a0,-766 # 800084d0 <syscalls+0x100>
    800027d6:	00004097          	auipc	ra,0x4
    800027da:	a56080e7          	jalr	-1450(ra) # 8000622c <panic>

00000000800027de <bpin>:

void
bpin(struct buf *b) {
    800027de:	1101                	addi	sp,sp,-32
    800027e0:	ec06                	sd	ra,24(sp)
    800027e2:	e822                	sd	s0,16(sp)
    800027e4:	e426                	sd	s1,8(sp)
    800027e6:	e04a                	sd	s2,0(sp)
    800027e8:	1000                	addi	s0,sp,32
    800027ea:	892a                	mv	s2,a0
  // change the lock - lab8-2
  int idx = HASH(b->blockno);
    800027ec:	4544                	lw	s1,12(a0)
  acquire(&bcache.locks[idx]);
    800027ee:	47b5                	li	a5,13
    800027f0:	02f4f4bb          	remuw	s1,s1,a5
    800027f4:	5e248493          	addi	s1,s1,1506
    800027f8:	0496                	slli	s1,s1,0x5
    800027fa:	0000d797          	auipc	a5,0xd
    800027fe:	a1e78793          	addi	a5,a5,-1506 # 8000f218 <bcache+0x8>
    80002802:	94be                	add	s1,s1,a5
    80002804:	8526                	mv	a0,s1
    80002806:	00004097          	auipc	ra,0x4
    8000280a:	f5a080e7          	jalr	-166(ra) # 80006760 <acquire>
  b->refcnt++;
    8000280e:	04892783          	lw	a5,72(s2)
    80002812:	2785                	addiw	a5,a5,1
    80002814:	04f92423          	sw	a5,72(s2)
  release(&bcache.locks[idx]);
    80002818:	8526                	mv	a0,s1
    8000281a:	00004097          	auipc	ra,0x4
    8000281e:	016080e7          	jalr	22(ra) # 80006830 <release>
}
    80002822:	60e2                	ld	ra,24(sp)
    80002824:	6442                	ld	s0,16(sp)
    80002826:	64a2                	ld	s1,8(sp)
    80002828:	6902                	ld	s2,0(sp)
    8000282a:	6105                	addi	sp,sp,32
    8000282c:	8082                	ret

000000008000282e <bunpin>:

void
bunpin(struct buf *b) {
    8000282e:	1101                	addi	sp,sp,-32
    80002830:	ec06                	sd	ra,24(sp)
    80002832:	e822                	sd	s0,16(sp)
    80002834:	e426                	sd	s1,8(sp)
    80002836:	e04a                	sd	s2,0(sp)
    80002838:	1000                	addi	s0,sp,32
    8000283a:	892a                	mv	s2,a0
  // change the lock - lab8-2
  int idx = HASH(b->blockno);
    8000283c:	4544                	lw	s1,12(a0)
  acquire(&bcache.locks[idx]);
    8000283e:	47b5                	li	a5,13
    80002840:	02f4f4bb          	remuw	s1,s1,a5
    80002844:	5e248493          	addi	s1,s1,1506
    80002848:	0496                	slli	s1,s1,0x5
    8000284a:	0000d797          	auipc	a5,0xd
    8000284e:	9ce78793          	addi	a5,a5,-1586 # 8000f218 <bcache+0x8>
    80002852:	94be                	add	s1,s1,a5
    80002854:	8526                	mv	a0,s1
    80002856:	00004097          	auipc	ra,0x4
    8000285a:	f0a080e7          	jalr	-246(ra) # 80006760 <acquire>
  b->refcnt--;
    8000285e:	04892783          	lw	a5,72(s2)
    80002862:	37fd                	addiw	a5,a5,-1
    80002864:	04f92423          	sw	a5,72(s2)
  release(&bcache.locks[idx]);
    80002868:	8526                	mv	a0,s1
    8000286a:	00004097          	auipc	ra,0x4
    8000286e:	fc6080e7          	jalr	-58(ra) # 80006830 <release>
}
    80002872:	60e2                	ld	ra,24(sp)
    80002874:	6442                	ld	s0,16(sp)
    80002876:	64a2                	ld	s1,8(sp)
    80002878:	6902                	ld	s2,0(sp)
    8000287a:	6105                	addi	sp,sp,32
    8000287c:	8082                	ret

000000008000287e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000287e:	1101                	addi	sp,sp,-32
    80002880:	ec06                	sd	ra,24(sp)
    80002882:	e822                	sd	s0,16(sp)
    80002884:	e426                	sd	s1,8(sp)
    80002886:	e04a                	sd	s2,0(sp)
    80002888:	1000                	addi	s0,sp,32
    8000288a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000288c:	00d5d59b          	srliw	a1,a1,0xd
    80002890:	00018797          	auipc	a5,0x18
    80002894:	7a47a783          	lw	a5,1956(a5) # 8001b034 <sb+0x1c>
    80002898:	9dbd                	addw	a1,a1,a5
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	b98080e7          	jalr	-1128(ra) # 80002432 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800028a2:	0074f713          	andi	a4,s1,7
    800028a6:	4785                	li	a5,1
    800028a8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800028ac:	14ce                	slli	s1,s1,0x33
    800028ae:	90d9                	srli	s1,s1,0x36
    800028b0:	00950733          	add	a4,a0,s1
    800028b4:	05874703          	lbu	a4,88(a4)
    800028b8:	00e7f6b3          	and	a3,a5,a4
    800028bc:	c69d                	beqz	a3,800028ea <bfree+0x6c>
    800028be:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800028c0:	94aa                	add	s1,s1,a0
    800028c2:	fff7c793          	not	a5,a5
    800028c6:	8ff9                	and	a5,a5,a4
    800028c8:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800028cc:	00001097          	auipc	ra,0x1
    800028d0:	118080e7          	jalr	280(ra) # 800039e4 <log_write>
  brelse(bp);
    800028d4:	854a                	mv	a0,s2
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	e7a080e7          	jalr	-390(ra) # 80002750 <brelse>
}
    800028de:	60e2                	ld	ra,24(sp)
    800028e0:	6442                	ld	s0,16(sp)
    800028e2:	64a2                	ld	s1,8(sp)
    800028e4:	6902                	ld	s2,0(sp)
    800028e6:	6105                	addi	sp,sp,32
    800028e8:	8082                	ret
    panic("freeing free block");
    800028ea:	00006517          	auipc	a0,0x6
    800028ee:	bee50513          	addi	a0,a0,-1042 # 800084d8 <syscalls+0x108>
    800028f2:	00004097          	auipc	ra,0x4
    800028f6:	93a080e7          	jalr	-1734(ra) # 8000622c <panic>

00000000800028fa <balloc>:
{
    800028fa:	711d                	addi	sp,sp,-96
    800028fc:	ec86                	sd	ra,88(sp)
    800028fe:	e8a2                	sd	s0,80(sp)
    80002900:	e4a6                	sd	s1,72(sp)
    80002902:	e0ca                	sd	s2,64(sp)
    80002904:	fc4e                	sd	s3,56(sp)
    80002906:	f852                	sd	s4,48(sp)
    80002908:	f456                	sd	s5,40(sp)
    8000290a:	f05a                	sd	s6,32(sp)
    8000290c:	ec5e                	sd	s7,24(sp)
    8000290e:	e862                	sd	s8,16(sp)
    80002910:	e466                	sd	s9,8(sp)
    80002912:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002914:	00018797          	auipc	a5,0x18
    80002918:	7087a783          	lw	a5,1800(a5) # 8001b01c <sb+0x4>
    8000291c:	cbd1                	beqz	a5,800029b0 <balloc+0xb6>
    8000291e:	8baa                	mv	s7,a0
    80002920:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002922:	00018b17          	auipc	s6,0x18
    80002926:	6f6b0b13          	addi	s6,s6,1782 # 8001b018 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000292a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000292c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000292e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002930:	6c89                	lui	s9,0x2
    80002932:	a831                	j	8000294e <balloc+0x54>
    brelse(bp);
    80002934:	854a                	mv	a0,s2
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	e1a080e7          	jalr	-486(ra) # 80002750 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000293e:	015c87bb          	addw	a5,s9,s5
    80002942:	00078a9b          	sext.w	s5,a5
    80002946:	004b2703          	lw	a4,4(s6)
    8000294a:	06eaf363          	bgeu	s5,a4,800029b0 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000294e:	41fad79b          	sraiw	a5,s5,0x1f
    80002952:	0137d79b          	srliw	a5,a5,0x13
    80002956:	015787bb          	addw	a5,a5,s5
    8000295a:	40d7d79b          	sraiw	a5,a5,0xd
    8000295e:	01cb2583          	lw	a1,28(s6)
    80002962:	9dbd                	addw	a1,a1,a5
    80002964:	855e                	mv	a0,s7
    80002966:	00000097          	auipc	ra,0x0
    8000296a:	acc080e7          	jalr	-1332(ra) # 80002432 <bread>
    8000296e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002970:	004b2503          	lw	a0,4(s6)
    80002974:	000a849b          	sext.w	s1,s5
    80002978:	8662                	mv	a2,s8
    8000297a:	faa4fde3          	bgeu	s1,a0,80002934 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000297e:	41f6579b          	sraiw	a5,a2,0x1f
    80002982:	01d7d69b          	srliw	a3,a5,0x1d
    80002986:	00c6873b          	addw	a4,a3,a2
    8000298a:	00777793          	andi	a5,a4,7
    8000298e:	9f95                	subw	a5,a5,a3
    80002990:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002994:	4037571b          	sraiw	a4,a4,0x3
    80002998:	00e906b3          	add	a3,s2,a4
    8000299c:	0586c683          	lbu	a3,88(a3)
    800029a0:	00d7f5b3          	and	a1,a5,a3
    800029a4:	cd91                	beqz	a1,800029c0 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029a6:	2605                	addiw	a2,a2,1
    800029a8:	2485                	addiw	s1,s1,1
    800029aa:	fd4618e3          	bne	a2,s4,8000297a <balloc+0x80>
    800029ae:	b759                	j	80002934 <balloc+0x3a>
  panic("balloc: out of blocks");
    800029b0:	00006517          	auipc	a0,0x6
    800029b4:	b4050513          	addi	a0,a0,-1216 # 800084f0 <syscalls+0x120>
    800029b8:	00004097          	auipc	ra,0x4
    800029bc:	874080e7          	jalr	-1932(ra) # 8000622c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800029c0:	974a                	add	a4,a4,s2
    800029c2:	8fd5                	or	a5,a5,a3
    800029c4:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800029c8:	854a                	mv	a0,s2
    800029ca:	00001097          	auipc	ra,0x1
    800029ce:	01a080e7          	jalr	26(ra) # 800039e4 <log_write>
        brelse(bp);
    800029d2:	854a                	mv	a0,s2
    800029d4:	00000097          	auipc	ra,0x0
    800029d8:	d7c080e7          	jalr	-644(ra) # 80002750 <brelse>
  bp = bread(dev, bno);
    800029dc:	85a6                	mv	a1,s1
    800029de:	855e                	mv	a0,s7
    800029e0:	00000097          	auipc	ra,0x0
    800029e4:	a52080e7          	jalr	-1454(ra) # 80002432 <bread>
    800029e8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800029ea:	40000613          	li	a2,1024
    800029ee:	4581                	li	a1,0
    800029f0:	05850513          	addi	a0,a0,88
    800029f4:	ffffe097          	auipc	ra,0xffffe
    800029f8:	91e080e7          	jalr	-1762(ra) # 80000312 <memset>
  log_write(bp);
    800029fc:	854a                	mv	a0,s2
    800029fe:	00001097          	auipc	ra,0x1
    80002a02:	fe6080e7          	jalr	-26(ra) # 800039e4 <log_write>
  brelse(bp);
    80002a06:	854a                	mv	a0,s2
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	d48080e7          	jalr	-696(ra) # 80002750 <brelse>
}
    80002a10:	8526                	mv	a0,s1
    80002a12:	60e6                	ld	ra,88(sp)
    80002a14:	6446                	ld	s0,80(sp)
    80002a16:	64a6                	ld	s1,72(sp)
    80002a18:	6906                	ld	s2,64(sp)
    80002a1a:	79e2                	ld	s3,56(sp)
    80002a1c:	7a42                	ld	s4,48(sp)
    80002a1e:	7aa2                	ld	s5,40(sp)
    80002a20:	7b02                	ld	s6,32(sp)
    80002a22:	6be2                	ld	s7,24(sp)
    80002a24:	6c42                	ld	s8,16(sp)
    80002a26:	6ca2                	ld	s9,8(sp)
    80002a28:	6125                	addi	sp,sp,96
    80002a2a:	8082                	ret

0000000080002a2c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a2c:	7179                	addi	sp,sp,-48
    80002a2e:	f406                	sd	ra,40(sp)
    80002a30:	f022                	sd	s0,32(sp)
    80002a32:	ec26                	sd	s1,24(sp)
    80002a34:	e84a                	sd	s2,16(sp)
    80002a36:	e44e                	sd	s3,8(sp)
    80002a38:	e052                	sd	s4,0(sp)
    80002a3a:	1800                	addi	s0,sp,48
    80002a3c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a3e:	47ad                	li	a5,11
    80002a40:	04b7fe63          	bgeu	a5,a1,80002a9c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002a44:	ff45849b          	addiw	s1,a1,-12
    80002a48:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a4c:	0ff00793          	li	a5,255
    80002a50:	0ae7e363          	bltu	a5,a4,80002af6 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002a54:	08852583          	lw	a1,136(a0)
    80002a58:	c5ad                	beqz	a1,80002ac2 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002a5a:	00092503          	lw	a0,0(s2)
    80002a5e:	00000097          	auipc	ra,0x0
    80002a62:	9d4080e7          	jalr	-1580(ra) # 80002432 <bread>
    80002a66:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a68:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a6c:	02049593          	slli	a1,s1,0x20
    80002a70:	9181                	srli	a1,a1,0x20
    80002a72:	058a                	slli	a1,a1,0x2
    80002a74:	00b784b3          	add	s1,a5,a1
    80002a78:	0004a983          	lw	s3,0(s1)
    80002a7c:	04098d63          	beqz	s3,80002ad6 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a80:	8552                	mv	a0,s4
    80002a82:	00000097          	auipc	ra,0x0
    80002a86:	cce080e7          	jalr	-818(ra) # 80002750 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a8a:	854e                	mv	a0,s3
    80002a8c:	70a2                	ld	ra,40(sp)
    80002a8e:	7402                	ld	s0,32(sp)
    80002a90:	64e2                	ld	s1,24(sp)
    80002a92:	6942                	ld	s2,16(sp)
    80002a94:	69a2                	ld	s3,8(sp)
    80002a96:	6a02                	ld	s4,0(sp)
    80002a98:	6145                	addi	sp,sp,48
    80002a9a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a9c:	02059493          	slli	s1,a1,0x20
    80002aa0:	9081                	srli	s1,s1,0x20
    80002aa2:	048a                	slli	s1,s1,0x2
    80002aa4:	94aa                	add	s1,s1,a0
    80002aa6:	0584a983          	lw	s3,88(s1)
    80002aaa:	fe0990e3          	bnez	s3,80002a8a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002aae:	4108                	lw	a0,0(a0)
    80002ab0:	00000097          	auipc	ra,0x0
    80002ab4:	e4a080e7          	jalr	-438(ra) # 800028fa <balloc>
    80002ab8:	0005099b          	sext.w	s3,a0
    80002abc:	0534ac23          	sw	s3,88(s1)
    80002ac0:	b7e9                	j	80002a8a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002ac2:	4108                	lw	a0,0(a0)
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	e36080e7          	jalr	-458(ra) # 800028fa <balloc>
    80002acc:	0005059b          	sext.w	a1,a0
    80002ad0:	08b92423          	sw	a1,136(s2)
    80002ad4:	b759                	j	80002a5a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002ad6:	00092503          	lw	a0,0(s2)
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	e20080e7          	jalr	-480(ra) # 800028fa <balloc>
    80002ae2:	0005099b          	sext.w	s3,a0
    80002ae6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002aea:	8552                	mv	a0,s4
    80002aec:	00001097          	auipc	ra,0x1
    80002af0:	ef8080e7          	jalr	-264(ra) # 800039e4 <log_write>
    80002af4:	b771                	j	80002a80 <bmap+0x54>
  panic("bmap: out of range");
    80002af6:	00006517          	auipc	a0,0x6
    80002afa:	a1250513          	addi	a0,a0,-1518 # 80008508 <syscalls+0x138>
    80002afe:	00003097          	auipc	ra,0x3
    80002b02:	72e080e7          	jalr	1838(ra) # 8000622c <panic>

0000000080002b06 <iget>:
{
    80002b06:	7179                	addi	sp,sp,-48
    80002b08:	f406                	sd	ra,40(sp)
    80002b0a:	f022                	sd	s0,32(sp)
    80002b0c:	ec26                	sd	s1,24(sp)
    80002b0e:	e84a                	sd	s2,16(sp)
    80002b10:	e44e                	sd	s3,8(sp)
    80002b12:	e052                	sd	s4,0(sp)
    80002b14:	1800                	addi	s0,sp,48
    80002b16:	89aa                	mv	s3,a0
    80002b18:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b1a:	00018517          	auipc	a0,0x18
    80002b1e:	51e50513          	addi	a0,a0,1310 # 8001b038 <itable>
    80002b22:	00004097          	auipc	ra,0x4
    80002b26:	c3e080e7          	jalr	-962(ra) # 80006760 <acquire>
  empty = 0;
    80002b2a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b2c:	00018497          	auipc	s1,0x18
    80002b30:	52c48493          	addi	s1,s1,1324 # 8001b058 <itable+0x20>
    80002b34:	0001a697          	auipc	a3,0x1a
    80002b38:	14468693          	addi	a3,a3,324 # 8001cc78 <log>
    80002b3c:	a039                	j	80002b4a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b3e:	02090b63          	beqz	s2,80002b74 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b42:	09048493          	addi	s1,s1,144
    80002b46:	02d48a63          	beq	s1,a3,80002b7a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b4a:	449c                	lw	a5,8(s1)
    80002b4c:	fef059e3          	blez	a5,80002b3e <iget+0x38>
    80002b50:	4098                	lw	a4,0(s1)
    80002b52:	ff3716e3          	bne	a4,s3,80002b3e <iget+0x38>
    80002b56:	40d8                	lw	a4,4(s1)
    80002b58:	ff4713e3          	bne	a4,s4,80002b3e <iget+0x38>
      ip->ref++;
    80002b5c:	2785                	addiw	a5,a5,1
    80002b5e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b60:	00018517          	auipc	a0,0x18
    80002b64:	4d850513          	addi	a0,a0,1240 # 8001b038 <itable>
    80002b68:	00004097          	auipc	ra,0x4
    80002b6c:	cc8080e7          	jalr	-824(ra) # 80006830 <release>
      return ip;
    80002b70:	8926                	mv	s2,s1
    80002b72:	a03d                	j	80002ba0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b74:	f7f9                	bnez	a5,80002b42 <iget+0x3c>
    80002b76:	8926                	mv	s2,s1
    80002b78:	b7e9                	j	80002b42 <iget+0x3c>
  if(empty == 0)
    80002b7a:	02090c63          	beqz	s2,80002bb2 <iget+0xac>
  ip->dev = dev;
    80002b7e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b82:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b86:	4785                	li	a5,1
    80002b88:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b8c:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002b90:	00018517          	auipc	a0,0x18
    80002b94:	4a850513          	addi	a0,a0,1192 # 8001b038 <itable>
    80002b98:	00004097          	auipc	ra,0x4
    80002b9c:	c98080e7          	jalr	-872(ra) # 80006830 <release>
}
    80002ba0:	854a                	mv	a0,s2
    80002ba2:	70a2                	ld	ra,40(sp)
    80002ba4:	7402                	ld	s0,32(sp)
    80002ba6:	64e2                	ld	s1,24(sp)
    80002ba8:	6942                	ld	s2,16(sp)
    80002baa:	69a2                	ld	s3,8(sp)
    80002bac:	6a02                	ld	s4,0(sp)
    80002bae:	6145                	addi	sp,sp,48
    80002bb0:	8082                	ret
    panic("iget: no inodes");
    80002bb2:	00006517          	auipc	a0,0x6
    80002bb6:	96e50513          	addi	a0,a0,-1682 # 80008520 <syscalls+0x150>
    80002bba:	00003097          	auipc	ra,0x3
    80002bbe:	672080e7          	jalr	1650(ra) # 8000622c <panic>

0000000080002bc2 <fsinit>:
fsinit(int dev) {
    80002bc2:	7179                	addi	sp,sp,-48
    80002bc4:	f406                	sd	ra,40(sp)
    80002bc6:	f022                	sd	s0,32(sp)
    80002bc8:	ec26                	sd	s1,24(sp)
    80002bca:	e84a                	sd	s2,16(sp)
    80002bcc:	e44e                	sd	s3,8(sp)
    80002bce:	1800                	addi	s0,sp,48
    80002bd0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002bd2:	4585                	li	a1,1
    80002bd4:	00000097          	auipc	ra,0x0
    80002bd8:	85e080e7          	jalr	-1954(ra) # 80002432 <bread>
    80002bdc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002bde:	00018997          	auipc	s3,0x18
    80002be2:	43a98993          	addi	s3,s3,1082 # 8001b018 <sb>
    80002be6:	02000613          	li	a2,32
    80002bea:	05850593          	addi	a1,a0,88
    80002bee:	854e                	mv	a0,s3
    80002bf0:	ffffd097          	auipc	ra,0xffffd
    80002bf4:	782080e7          	jalr	1922(ra) # 80000372 <memmove>
  brelse(bp);
    80002bf8:	8526                	mv	a0,s1
    80002bfa:	00000097          	auipc	ra,0x0
    80002bfe:	b56080e7          	jalr	-1194(ra) # 80002750 <brelse>
  if(sb.magic != FSMAGIC)
    80002c02:	0009a703          	lw	a4,0(s3)
    80002c06:	102037b7          	lui	a5,0x10203
    80002c0a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c0e:	02f71263          	bne	a4,a5,80002c32 <fsinit+0x70>
  initlog(dev, &sb);
    80002c12:	00018597          	auipc	a1,0x18
    80002c16:	40658593          	addi	a1,a1,1030 # 8001b018 <sb>
    80002c1a:	854a                	mv	a0,s2
    80002c1c:	00001097          	auipc	ra,0x1
    80002c20:	b4c080e7          	jalr	-1204(ra) # 80003768 <initlog>
}
    80002c24:	70a2                	ld	ra,40(sp)
    80002c26:	7402                	ld	s0,32(sp)
    80002c28:	64e2                	ld	s1,24(sp)
    80002c2a:	6942                	ld	s2,16(sp)
    80002c2c:	69a2                	ld	s3,8(sp)
    80002c2e:	6145                	addi	sp,sp,48
    80002c30:	8082                	ret
    panic("invalid file system");
    80002c32:	00006517          	auipc	a0,0x6
    80002c36:	8fe50513          	addi	a0,a0,-1794 # 80008530 <syscalls+0x160>
    80002c3a:	00003097          	auipc	ra,0x3
    80002c3e:	5f2080e7          	jalr	1522(ra) # 8000622c <panic>

0000000080002c42 <iinit>:
{
    80002c42:	7179                	addi	sp,sp,-48
    80002c44:	f406                	sd	ra,40(sp)
    80002c46:	f022                	sd	s0,32(sp)
    80002c48:	ec26                	sd	s1,24(sp)
    80002c4a:	e84a                	sd	s2,16(sp)
    80002c4c:	e44e                	sd	s3,8(sp)
    80002c4e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c50:	00006597          	auipc	a1,0x6
    80002c54:	8f858593          	addi	a1,a1,-1800 # 80008548 <syscalls+0x178>
    80002c58:	00018517          	auipc	a0,0x18
    80002c5c:	3e050513          	addi	a0,a0,992 # 8001b038 <itable>
    80002c60:	00004097          	auipc	ra,0x4
    80002c64:	c7c080e7          	jalr	-900(ra) # 800068dc <initlock>
  for(i = 0; i < NINODE; i++) {
    80002c68:	00018497          	auipc	s1,0x18
    80002c6c:	40048493          	addi	s1,s1,1024 # 8001b068 <itable+0x30>
    80002c70:	0001a997          	auipc	s3,0x1a
    80002c74:	01898993          	addi	s3,s3,24 # 8001cc88 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c78:	00006917          	auipc	s2,0x6
    80002c7c:	8d890913          	addi	s2,s2,-1832 # 80008550 <syscalls+0x180>
    80002c80:	85ca                	mv	a1,s2
    80002c82:	8526                	mv	a0,s1
    80002c84:	00001097          	auipc	ra,0x1
    80002c88:	e46080e7          	jalr	-442(ra) # 80003aca <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c8c:	09048493          	addi	s1,s1,144
    80002c90:	ff3498e3          	bne	s1,s3,80002c80 <iinit+0x3e>
}
    80002c94:	70a2                	ld	ra,40(sp)
    80002c96:	7402                	ld	s0,32(sp)
    80002c98:	64e2                	ld	s1,24(sp)
    80002c9a:	6942                	ld	s2,16(sp)
    80002c9c:	69a2                	ld	s3,8(sp)
    80002c9e:	6145                	addi	sp,sp,48
    80002ca0:	8082                	ret

0000000080002ca2 <ialloc>:
{
    80002ca2:	715d                	addi	sp,sp,-80
    80002ca4:	e486                	sd	ra,72(sp)
    80002ca6:	e0a2                	sd	s0,64(sp)
    80002ca8:	fc26                	sd	s1,56(sp)
    80002caa:	f84a                	sd	s2,48(sp)
    80002cac:	f44e                	sd	s3,40(sp)
    80002cae:	f052                	sd	s4,32(sp)
    80002cb0:	ec56                	sd	s5,24(sp)
    80002cb2:	e85a                	sd	s6,16(sp)
    80002cb4:	e45e                	sd	s7,8(sp)
    80002cb6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cb8:	00018717          	auipc	a4,0x18
    80002cbc:	36c72703          	lw	a4,876(a4) # 8001b024 <sb+0xc>
    80002cc0:	4785                	li	a5,1
    80002cc2:	04e7fa63          	bgeu	a5,a4,80002d16 <ialloc+0x74>
    80002cc6:	8aaa                	mv	s5,a0
    80002cc8:	8bae                	mv	s7,a1
    80002cca:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ccc:	00018a17          	auipc	s4,0x18
    80002cd0:	34ca0a13          	addi	s4,s4,844 # 8001b018 <sb>
    80002cd4:	00048b1b          	sext.w	s6,s1
    80002cd8:	0044d593          	srli	a1,s1,0x4
    80002cdc:	018a2783          	lw	a5,24(s4)
    80002ce0:	9dbd                	addw	a1,a1,a5
    80002ce2:	8556                	mv	a0,s5
    80002ce4:	fffff097          	auipc	ra,0xfffff
    80002ce8:	74e080e7          	jalr	1870(ra) # 80002432 <bread>
    80002cec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002cee:	05850993          	addi	s3,a0,88
    80002cf2:	00f4f793          	andi	a5,s1,15
    80002cf6:	079a                	slli	a5,a5,0x6
    80002cf8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002cfa:	00099783          	lh	a5,0(s3)
    80002cfe:	c785                	beqz	a5,80002d26 <ialloc+0x84>
    brelse(bp);
    80002d00:	00000097          	auipc	ra,0x0
    80002d04:	a50080e7          	jalr	-1456(ra) # 80002750 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d08:	0485                	addi	s1,s1,1
    80002d0a:	00ca2703          	lw	a4,12(s4)
    80002d0e:	0004879b          	sext.w	a5,s1
    80002d12:	fce7e1e3          	bltu	a5,a4,80002cd4 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002d16:	00006517          	auipc	a0,0x6
    80002d1a:	84250513          	addi	a0,a0,-1982 # 80008558 <syscalls+0x188>
    80002d1e:	00003097          	auipc	ra,0x3
    80002d22:	50e080e7          	jalr	1294(ra) # 8000622c <panic>
      memset(dip, 0, sizeof(*dip));
    80002d26:	04000613          	li	a2,64
    80002d2a:	4581                	li	a1,0
    80002d2c:	854e                	mv	a0,s3
    80002d2e:	ffffd097          	auipc	ra,0xffffd
    80002d32:	5e4080e7          	jalr	1508(ra) # 80000312 <memset>
      dip->type = type;
    80002d36:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d3a:	854a                	mv	a0,s2
    80002d3c:	00001097          	auipc	ra,0x1
    80002d40:	ca8080e7          	jalr	-856(ra) # 800039e4 <log_write>
      brelse(bp);
    80002d44:	854a                	mv	a0,s2
    80002d46:	00000097          	auipc	ra,0x0
    80002d4a:	a0a080e7          	jalr	-1526(ra) # 80002750 <brelse>
      return iget(dev, inum);
    80002d4e:	85da                	mv	a1,s6
    80002d50:	8556                	mv	a0,s5
    80002d52:	00000097          	auipc	ra,0x0
    80002d56:	db4080e7          	jalr	-588(ra) # 80002b06 <iget>
}
    80002d5a:	60a6                	ld	ra,72(sp)
    80002d5c:	6406                	ld	s0,64(sp)
    80002d5e:	74e2                	ld	s1,56(sp)
    80002d60:	7942                	ld	s2,48(sp)
    80002d62:	79a2                	ld	s3,40(sp)
    80002d64:	7a02                	ld	s4,32(sp)
    80002d66:	6ae2                	ld	s5,24(sp)
    80002d68:	6b42                	ld	s6,16(sp)
    80002d6a:	6ba2                	ld	s7,8(sp)
    80002d6c:	6161                	addi	sp,sp,80
    80002d6e:	8082                	ret

0000000080002d70 <iupdate>:
{
    80002d70:	1101                	addi	sp,sp,-32
    80002d72:	ec06                	sd	ra,24(sp)
    80002d74:	e822                	sd	s0,16(sp)
    80002d76:	e426                	sd	s1,8(sp)
    80002d78:	e04a                	sd	s2,0(sp)
    80002d7a:	1000                	addi	s0,sp,32
    80002d7c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d7e:	415c                	lw	a5,4(a0)
    80002d80:	0047d79b          	srliw	a5,a5,0x4
    80002d84:	00018597          	auipc	a1,0x18
    80002d88:	2ac5a583          	lw	a1,684(a1) # 8001b030 <sb+0x18>
    80002d8c:	9dbd                	addw	a1,a1,a5
    80002d8e:	4108                	lw	a0,0(a0)
    80002d90:	fffff097          	auipc	ra,0xfffff
    80002d94:	6a2080e7          	jalr	1698(ra) # 80002432 <bread>
    80002d98:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d9a:	05850793          	addi	a5,a0,88
    80002d9e:	40c8                	lw	a0,4(s1)
    80002da0:	893d                	andi	a0,a0,15
    80002da2:	051a                	slli	a0,a0,0x6
    80002da4:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002da6:	04c49703          	lh	a4,76(s1)
    80002daa:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002dae:	04e49703          	lh	a4,78(s1)
    80002db2:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002db6:	05049703          	lh	a4,80(s1)
    80002dba:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002dbe:	05249703          	lh	a4,82(s1)
    80002dc2:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002dc6:	48f8                	lw	a4,84(s1)
    80002dc8:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002dca:	03400613          	li	a2,52
    80002dce:	05848593          	addi	a1,s1,88
    80002dd2:	0531                	addi	a0,a0,12
    80002dd4:	ffffd097          	auipc	ra,0xffffd
    80002dd8:	59e080e7          	jalr	1438(ra) # 80000372 <memmove>
  log_write(bp);
    80002ddc:	854a                	mv	a0,s2
    80002dde:	00001097          	auipc	ra,0x1
    80002de2:	c06080e7          	jalr	-1018(ra) # 800039e4 <log_write>
  brelse(bp);
    80002de6:	854a                	mv	a0,s2
    80002de8:	00000097          	auipc	ra,0x0
    80002dec:	968080e7          	jalr	-1688(ra) # 80002750 <brelse>
}
    80002df0:	60e2                	ld	ra,24(sp)
    80002df2:	6442                	ld	s0,16(sp)
    80002df4:	64a2                	ld	s1,8(sp)
    80002df6:	6902                	ld	s2,0(sp)
    80002df8:	6105                	addi	sp,sp,32
    80002dfa:	8082                	ret

0000000080002dfc <idup>:
{
    80002dfc:	1101                	addi	sp,sp,-32
    80002dfe:	ec06                	sd	ra,24(sp)
    80002e00:	e822                	sd	s0,16(sp)
    80002e02:	e426                	sd	s1,8(sp)
    80002e04:	1000                	addi	s0,sp,32
    80002e06:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e08:	00018517          	auipc	a0,0x18
    80002e0c:	23050513          	addi	a0,a0,560 # 8001b038 <itable>
    80002e10:	00004097          	auipc	ra,0x4
    80002e14:	950080e7          	jalr	-1712(ra) # 80006760 <acquire>
  ip->ref++;
    80002e18:	449c                	lw	a5,8(s1)
    80002e1a:	2785                	addiw	a5,a5,1
    80002e1c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e1e:	00018517          	auipc	a0,0x18
    80002e22:	21a50513          	addi	a0,a0,538 # 8001b038 <itable>
    80002e26:	00004097          	auipc	ra,0x4
    80002e2a:	a0a080e7          	jalr	-1526(ra) # 80006830 <release>
}
    80002e2e:	8526                	mv	a0,s1
    80002e30:	60e2                	ld	ra,24(sp)
    80002e32:	6442                	ld	s0,16(sp)
    80002e34:	64a2                	ld	s1,8(sp)
    80002e36:	6105                	addi	sp,sp,32
    80002e38:	8082                	ret

0000000080002e3a <ilock>:
{
    80002e3a:	1101                	addi	sp,sp,-32
    80002e3c:	ec06                	sd	ra,24(sp)
    80002e3e:	e822                	sd	s0,16(sp)
    80002e40:	e426                	sd	s1,8(sp)
    80002e42:	e04a                	sd	s2,0(sp)
    80002e44:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e46:	c115                	beqz	a0,80002e6a <ilock+0x30>
    80002e48:	84aa                	mv	s1,a0
    80002e4a:	451c                	lw	a5,8(a0)
    80002e4c:	00f05f63          	blez	a5,80002e6a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002e50:	0541                	addi	a0,a0,16
    80002e52:	00001097          	auipc	ra,0x1
    80002e56:	cb2080e7          	jalr	-846(ra) # 80003b04 <acquiresleep>
  if(ip->valid == 0){
    80002e5a:	44bc                	lw	a5,72(s1)
    80002e5c:	cf99                	beqz	a5,80002e7a <ilock+0x40>
}
    80002e5e:	60e2                	ld	ra,24(sp)
    80002e60:	6442                	ld	s0,16(sp)
    80002e62:	64a2                	ld	s1,8(sp)
    80002e64:	6902                	ld	s2,0(sp)
    80002e66:	6105                	addi	sp,sp,32
    80002e68:	8082                	ret
    panic("ilock");
    80002e6a:	00005517          	auipc	a0,0x5
    80002e6e:	70650513          	addi	a0,a0,1798 # 80008570 <syscalls+0x1a0>
    80002e72:	00003097          	auipc	ra,0x3
    80002e76:	3ba080e7          	jalr	954(ra) # 8000622c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e7a:	40dc                	lw	a5,4(s1)
    80002e7c:	0047d79b          	srliw	a5,a5,0x4
    80002e80:	00018597          	auipc	a1,0x18
    80002e84:	1b05a583          	lw	a1,432(a1) # 8001b030 <sb+0x18>
    80002e88:	9dbd                	addw	a1,a1,a5
    80002e8a:	4088                	lw	a0,0(s1)
    80002e8c:	fffff097          	auipc	ra,0xfffff
    80002e90:	5a6080e7          	jalr	1446(ra) # 80002432 <bread>
    80002e94:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e96:	05850593          	addi	a1,a0,88
    80002e9a:	40dc                	lw	a5,4(s1)
    80002e9c:	8bbd                	andi	a5,a5,15
    80002e9e:	079a                	slli	a5,a5,0x6
    80002ea0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ea2:	00059783          	lh	a5,0(a1)
    80002ea6:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002eaa:	00259783          	lh	a5,2(a1)
    80002eae:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002eb2:	00459783          	lh	a5,4(a1)
    80002eb6:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002eba:	00659783          	lh	a5,6(a1)
    80002ebe:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002ec2:	459c                	lw	a5,8(a1)
    80002ec4:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ec6:	03400613          	li	a2,52
    80002eca:	05b1                	addi	a1,a1,12
    80002ecc:	05848513          	addi	a0,s1,88
    80002ed0:	ffffd097          	auipc	ra,0xffffd
    80002ed4:	4a2080e7          	jalr	1186(ra) # 80000372 <memmove>
    brelse(bp);
    80002ed8:	854a                	mv	a0,s2
    80002eda:	00000097          	auipc	ra,0x0
    80002ede:	876080e7          	jalr	-1930(ra) # 80002750 <brelse>
    ip->valid = 1;
    80002ee2:	4785                	li	a5,1
    80002ee4:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002ee6:	04c49783          	lh	a5,76(s1)
    80002eea:	fbb5                	bnez	a5,80002e5e <ilock+0x24>
      panic("ilock: no type");
    80002eec:	00005517          	auipc	a0,0x5
    80002ef0:	68c50513          	addi	a0,a0,1676 # 80008578 <syscalls+0x1a8>
    80002ef4:	00003097          	auipc	ra,0x3
    80002ef8:	338080e7          	jalr	824(ra) # 8000622c <panic>

0000000080002efc <iunlock>:
{
    80002efc:	1101                	addi	sp,sp,-32
    80002efe:	ec06                	sd	ra,24(sp)
    80002f00:	e822                	sd	s0,16(sp)
    80002f02:	e426                	sd	s1,8(sp)
    80002f04:	e04a                	sd	s2,0(sp)
    80002f06:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f08:	c905                	beqz	a0,80002f38 <iunlock+0x3c>
    80002f0a:	84aa                	mv	s1,a0
    80002f0c:	01050913          	addi	s2,a0,16
    80002f10:	854a                	mv	a0,s2
    80002f12:	00001097          	auipc	ra,0x1
    80002f16:	c8c080e7          	jalr	-884(ra) # 80003b9e <holdingsleep>
    80002f1a:	cd19                	beqz	a0,80002f38 <iunlock+0x3c>
    80002f1c:	449c                	lw	a5,8(s1)
    80002f1e:	00f05d63          	blez	a5,80002f38 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f22:	854a                	mv	a0,s2
    80002f24:	00001097          	auipc	ra,0x1
    80002f28:	c36080e7          	jalr	-970(ra) # 80003b5a <releasesleep>
}
    80002f2c:	60e2                	ld	ra,24(sp)
    80002f2e:	6442                	ld	s0,16(sp)
    80002f30:	64a2                	ld	s1,8(sp)
    80002f32:	6902                	ld	s2,0(sp)
    80002f34:	6105                	addi	sp,sp,32
    80002f36:	8082                	ret
    panic("iunlock");
    80002f38:	00005517          	auipc	a0,0x5
    80002f3c:	65050513          	addi	a0,a0,1616 # 80008588 <syscalls+0x1b8>
    80002f40:	00003097          	auipc	ra,0x3
    80002f44:	2ec080e7          	jalr	748(ra) # 8000622c <panic>

0000000080002f48 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f48:	7179                	addi	sp,sp,-48
    80002f4a:	f406                	sd	ra,40(sp)
    80002f4c:	f022                	sd	s0,32(sp)
    80002f4e:	ec26                	sd	s1,24(sp)
    80002f50:	e84a                	sd	s2,16(sp)
    80002f52:	e44e                	sd	s3,8(sp)
    80002f54:	e052                	sd	s4,0(sp)
    80002f56:	1800                	addi	s0,sp,48
    80002f58:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f5a:	05850493          	addi	s1,a0,88
    80002f5e:	08850913          	addi	s2,a0,136
    80002f62:	a021                	j	80002f6a <itrunc+0x22>
    80002f64:	0491                	addi	s1,s1,4
    80002f66:	01248d63          	beq	s1,s2,80002f80 <itrunc+0x38>
    if(ip->addrs[i]){
    80002f6a:	408c                	lw	a1,0(s1)
    80002f6c:	dde5                	beqz	a1,80002f64 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002f6e:	0009a503          	lw	a0,0(s3)
    80002f72:	00000097          	auipc	ra,0x0
    80002f76:	90c080e7          	jalr	-1780(ra) # 8000287e <bfree>
      ip->addrs[i] = 0;
    80002f7a:	0004a023          	sw	zero,0(s1)
    80002f7e:	b7dd                	j	80002f64 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f80:	0889a583          	lw	a1,136(s3)
    80002f84:	e185                	bnez	a1,80002fa4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f86:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002f8a:	854e                	mv	a0,s3
    80002f8c:	00000097          	auipc	ra,0x0
    80002f90:	de4080e7          	jalr	-540(ra) # 80002d70 <iupdate>
}
    80002f94:	70a2                	ld	ra,40(sp)
    80002f96:	7402                	ld	s0,32(sp)
    80002f98:	64e2                	ld	s1,24(sp)
    80002f9a:	6942                	ld	s2,16(sp)
    80002f9c:	69a2                	ld	s3,8(sp)
    80002f9e:	6a02                	ld	s4,0(sp)
    80002fa0:	6145                	addi	sp,sp,48
    80002fa2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002fa4:	0009a503          	lw	a0,0(s3)
    80002fa8:	fffff097          	auipc	ra,0xfffff
    80002fac:	48a080e7          	jalr	1162(ra) # 80002432 <bread>
    80002fb0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002fb2:	05850493          	addi	s1,a0,88
    80002fb6:	45850913          	addi	s2,a0,1112
    80002fba:	a811                	j	80002fce <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002fbc:	0009a503          	lw	a0,0(s3)
    80002fc0:	00000097          	auipc	ra,0x0
    80002fc4:	8be080e7          	jalr	-1858(ra) # 8000287e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002fc8:	0491                	addi	s1,s1,4
    80002fca:	01248563          	beq	s1,s2,80002fd4 <itrunc+0x8c>
      if(a[j])
    80002fce:	408c                	lw	a1,0(s1)
    80002fd0:	dde5                	beqz	a1,80002fc8 <itrunc+0x80>
    80002fd2:	b7ed                	j	80002fbc <itrunc+0x74>
    brelse(bp);
    80002fd4:	8552                	mv	a0,s4
    80002fd6:	fffff097          	auipc	ra,0xfffff
    80002fda:	77a080e7          	jalr	1914(ra) # 80002750 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002fde:	0889a583          	lw	a1,136(s3)
    80002fe2:	0009a503          	lw	a0,0(s3)
    80002fe6:	00000097          	auipc	ra,0x0
    80002fea:	898080e7          	jalr	-1896(ra) # 8000287e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002fee:	0809a423          	sw	zero,136(s3)
    80002ff2:	bf51                	j	80002f86 <itrunc+0x3e>

0000000080002ff4 <iput>:
{
    80002ff4:	1101                	addi	sp,sp,-32
    80002ff6:	ec06                	sd	ra,24(sp)
    80002ff8:	e822                	sd	s0,16(sp)
    80002ffa:	e426                	sd	s1,8(sp)
    80002ffc:	e04a                	sd	s2,0(sp)
    80002ffe:	1000                	addi	s0,sp,32
    80003000:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003002:	00018517          	auipc	a0,0x18
    80003006:	03650513          	addi	a0,a0,54 # 8001b038 <itable>
    8000300a:	00003097          	auipc	ra,0x3
    8000300e:	756080e7          	jalr	1878(ra) # 80006760 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003012:	4498                	lw	a4,8(s1)
    80003014:	4785                	li	a5,1
    80003016:	02f70363          	beq	a4,a5,8000303c <iput+0x48>
  ip->ref--;
    8000301a:	449c                	lw	a5,8(s1)
    8000301c:	37fd                	addiw	a5,a5,-1
    8000301e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003020:	00018517          	auipc	a0,0x18
    80003024:	01850513          	addi	a0,a0,24 # 8001b038 <itable>
    80003028:	00004097          	auipc	ra,0x4
    8000302c:	808080e7          	jalr	-2040(ra) # 80006830 <release>
}
    80003030:	60e2                	ld	ra,24(sp)
    80003032:	6442                	ld	s0,16(sp)
    80003034:	64a2                	ld	s1,8(sp)
    80003036:	6902                	ld	s2,0(sp)
    80003038:	6105                	addi	sp,sp,32
    8000303a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000303c:	44bc                	lw	a5,72(s1)
    8000303e:	dff1                	beqz	a5,8000301a <iput+0x26>
    80003040:	05249783          	lh	a5,82(s1)
    80003044:	fbf9                	bnez	a5,8000301a <iput+0x26>
    acquiresleep(&ip->lock);
    80003046:	01048913          	addi	s2,s1,16
    8000304a:	854a                	mv	a0,s2
    8000304c:	00001097          	auipc	ra,0x1
    80003050:	ab8080e7          	jalr	-1352(ra) # 80003b04 <acquiresleep>
    release(&itable.lock);
    80003054:	00018517          	auipc	a0,0x18
    80003058:	fe450513          	addi	a0,a0,-28 # 8001b038 <itable>
    8000305c:	00003097          	auipc	ra,0x3
    80003060:	7d4080e7          	jalr	2004(ra) # 80006830 <release>
    itrunc(ip);
    80003064:	8526                	mv	a0,s1
    80003066:	00000097          	auipc	ra,0x0
    8000306a:	ee2080e7          	jalr	-286(ra) # 80002f48 <itrunc>
    ip->type = 0;
    8000306e:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80003072:	8526                	mv	a0,s1
    80003074:	00000097          	auipc	ra,0x0
    80003078:	cfc080e7          	jalr	-772(ra) # 80002d70 <iupdate>
    ip->valid = 0;
    8000307c:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80003080:	854a                	mv	a0,s2
    80003082:	00001097          	auipc	ra,0x1
    80003086:	ad8080e7          	jalr	-1320(ra) # 80003b5a <releasesleep>
    acquire(&itable.lock);
    8000308a:	00018517          	auipc	a0,0x18
    8000308e:	fae50513          	addi	a0,a0,-82 # 8001b038 <itable>
    80003092:	00003097          	auipc	ra,0x3
    80003096:	6ce080e7          	jalr	1742(ra) # 80006760 <acquire>
    8000309a:	b741                	j	8000301a <iput+0x26>

000000008000309c <iunlockput>:
{
    8000309c:	1101                	addi	sp,sp,-32
    8000309e:	ec06                	sd	ra,24(sp)
    800030a0:	e822                	sd	s0,16(sp)
    800030a2:	e426                	sd	s1,8(sp)
    800030a4:	1000                	addi	s0,sp,32
    800030a6:	84aa                	mv	s1,a0
  iunlock(ip);
    800030a8:	00000097          	auipc	ra,0x0
    800030ac:	e54080e7          	jalr	-428(ra) # 80002efc <iunlock>
  iput(ip);
    800030b0:	8526                	mv	a0,s1
    800030b2:	00000097          	auipc	ra,0x0
    800030b6:	f42080e7          	jalr	-190(ra) # 80002ff4 <iput>
}
    800030ba:	60e2                	ld	ra,24(sp)
    800030bc:	6442                	ld	s0,16(sp)
    800030be:	64a2                	ld	s1,8(sp)
    800030c0:	6105                	addi	sp,sp,32
    800030c2:	8082                	ret

00000000800030c4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800030c4:	1141                	addi	sp,sp,-16
    800030c6:	e422                	sd	s0,8(sp)
    800030c8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800030ca:	411c                	lw	a5,0(a0)
    800030cc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800030ce:	415c                	lw	a5,4(a0)
    800030d0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800030d2:	04c51783          	lh	a5,76(a0)
    800030d6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800030da:	05251783          	lh	a5,82(a0)
    800030de:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800030e2:	05456783          	lwu	a5,84(a0)
    800030e6:	e99c                	sd	a5,16(a1)
}
    800030e8:	6422                	ld	s0,8(sp)
    800030ea:	0141                	addi	sp,sp,16
    800030ec:	8082                	ret

00000000800030ee <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030ee:	497c                	lw	a5,84(a0)
    800030f0:	0ed7e963          	bltu	a5,a3,800031e2 <readi+0xf4>
{
    800030f4:	7159                	addi	sp,sp,-112
    800030f6:	f486                	sd	ra,104(sp)
    800030f8:	f0a2                	sd	s0,96(sp)
    800030fa:	eca6                	sd	s1,88(sp)
    800030fc:	e8ca                	sd	s2,80(sp)
    800030fe:	e4ce                	sd	s3,72(sp)
    80003100:	e0d2                	sd	s4,64(sp)
    80003102:	fc56                	sd	s5,56(sp)
    80003104:	f85a                	sd	s6,48(sp)
    80003106:	f45e                	sd	s7,40(sp)
    80003108:	f062                	sd	s8,32(sp)
    8000310a:	ec66                	sd	s9,24(sp)
    8000310c:	e86a                	sd	s10,16(sp)
    8000310e:	e46e                	sd	s11,8(sp)
    80003110:	1880                	addi	s0,sp,112
    80003112:	8baa                	mv	s7,a0
    80003114:	8c2e                	mv	s8,a1
    80003116:	8ab2                	mv	s5,a2
    80003118:	84b6                	mv	s1,a3
    8000311a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000311c:	9f35                	addw	a4,a4,a3
    return 0;
    8000311e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003120:	0ad76063          	bltu	a4,a3,800031c0 <readi+0xd2>
  if(off + n > ip->size)
    80003124:	00e7f463          	bgeu	a5,a4,8000312c <readi+0x3e>
    n = ip->size - off;
    80003128:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000312c:	0a0b0963          	beqz	s6,800031de <readi+0xf0>
    80003130:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003132:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003136:	5cfd                	li	s9,-1
    80003138:	a82d                	j	80003172 <readi+0x84>
    8000313a:	020a1d93          	slli	s11,s4,0x20
    8000313e:	020ddd93          	srli	s11,s11,0x20
    80003142:	05890613          	addi	a2,s2,88
    80003146:	86ee                	mv	a3,s11
    80003148:	963a                	add	a2,a2,a4
    8000314a:	85d6                	mv	a1,s5
    8000314c:	8562                	mv	a0,s8
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	904080e7          	jalr	-1788(ra) # 80001a52 <either_copyout>
    80003156:	05950d63          	beq	a0,s9,800031b0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000315a:	854a                	mv	a0,s2
    8000315c:	fffff097          	auipc	ra,0xfffff
    80003160:	5f4080e7          	jalr	1524(ra) # 80002750 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003164:	013a09bb          	addw	s3,s4,s3
    80003168:	009a04bb          	addw	s1,s4,s1
    8000316c:	9aee                	add	s5,s5,s11
    8000316e:	0569f763          	bgeu	s3,s6,800031bc <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003172:	000ba903          	lw	s2,0(s7)
    80003176:	00a4d59b          	srliw	a1,s1,0xa
    8000317a:	855e                	mv	a0,s7
    8000317c:	00000097          	auipc	ra,0x0
    80003180:	8b0080e7          	jalr	-1872(ra) # 80002a2c <bmap>
    80003184:	0005059b          	sext.w	a1,a0
    80003188:	854a                	mv	a0,s2
    8000318a:	fffff097          	auipc	ra,0xfffff
    8000318e:	2a8080e7          	jalr	680(ra) # 80002432 <bread>
    80003192:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003194:	3ff4f713          	andi	a4,s1,1023
    80003198:	40ed07bb          	subw	a5,s10,a4
    8000319c:	413b06bb          	subw	a3,s6,s3
    800031a0:	8a3e                	mv	s4,a5
    800031a2:	2781                	sext.w	a5,a5
    800031a4:	0006861b          	sext.w	a2,a3
    800031a8:	f8f679e3          	bgeu	a2,a5,8000313a <readi+0x4c>
    800031ac:	8a36                	mv	s4,a3
    800031ae:	b771                	j	8000313a <readi+0x4c>
      brelse(bp);
    800031b0:	854a                	mv	a0,s2
    800031b2:	fffff097          	auipc	ra,0xfffff
    800031b6:	59e080e7          	jalr	1438(ra) # 80002750 <brelse>
      tot = -1;
    800031ba:	59fd                	li	s3,-1
  }
  return tot;
    800031bc:	0009851b          	sext.w	a0,s3
}
    800031c0:	70a6                	ld	ra,104(sp)
    800031c2:	7406                	ld	s0,96(sp)
    800031c4:	64e6                	ld	s1,88(sp)
    800031c6:	6946                	ld	s2,80(sp)
    800031c8:	69a6                	ld	s3,72(sp)
    800031ca:	6a06                	ld	s4,64(sp)
    800031cc:	7ae2                	ld	s5,56(sp)
    800031ce:	7b42                	ld	s6,48(sp)
    800031d0:	7ba2                	ld	s7,40(sp)
    800031d2:	7c02                	ld	s8,32(sp)
    800031d4:	6ce2                	ld	s9,24(sp)
    800031d6:	6d42                	ld	s10,16(sp)
    800031d8:	6da2                	ld	s11,8(sp)
    800031da:	6165                	addi	sp,sp,112
    800031dc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031de:	89da                	mv	s3,s6
    800031e0:	bff1                	j	800031bc <readi+0xce>
    return 0;
    800031e2:	4501                	li	a0,0
}
    800031e4:	8082                	ret

00000000800031e6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800031e6:	497c                	lw	a5,84(a0)
    800031e8:	10d7e863          	bltu	a5,a3,800032f8 <writei+0x112>
{
    800031ec:	7159                	addi	sp,sp,-112
    800031ee:	f486                	sd	ra,104(sp)
    800031f0:	f0a2                	sd	s0,96(sp)
    800031f2:	eca6                	sd	s1,88(sp)
    800031f4:	e8ca                	sd	s2,80(sp)
    800031f6:	e4ce                	sd	s3,72(sp)
    800031f8:	e0d2                	sd	s4,64(sp)
    800031fa:	fc56                	sd	s5,56(sp)
    800031fc:	f85a                	sd	s6,48(sp)
    800031fe:	f45e                	sd	s7,40(sp)
    80003200:	f062                	sd	s8,32(sp)
    80003202:	ec66                	sd	s9,24(sp)
    80003204:	e86a                	sd	s10,16(sp)
    80003206:	e46e                	sd	s11,8(sp)
    80003208:	1880                	addi	s0,sp,112
    8000320a:	8b2a                	mv	s6,a0
    8000320c:	8c2e                	mv	s8,a1
    8000320e:	8ab2                	mv	s5,a2
    80003210:	8936                	mv	s2,a3
    80003212:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003214:	00e687bb          	addw	a5,a3,a4
    80003218:	0ed7e263          	bltu	a5,a3,800032fc <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000321c:	00043737          	lui	a4,0x43
    80003220:	0ef76063          	bltu	a4,a5,80003300 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003224:	0c0b8863          	beqz	s7,800032f4 <writei+0x10e>
    80003228:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000322a:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000322e:	5cfd                	li	s9,-1
    80003230:	a091                	j	80003274 <writei+0x8e>
    80003232:	02099d93          	slli	s11,s3,0x20
    80003236:	020ddd93          	srli	s11,s11,0x20
    8000323a:	05848513          	addi	a0,s1,88
    8000323e:	86ee                	mv	a3,s11
    80003240:	8656                	mv	a2,s5
    80003242:	85e2                	mv	a1,s8
    80003244:	953a                	add	a0,a0,a4
    80003246:	fffff097          	auipc	ra,0xfffff
    8000324a:	862080e7          	jalr	-1950(ra) # 80001aa8 <either_copyin>
    8000324e:	07950263          	beq	a0,s9,800032b2 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003252:	8526                	mv	a0,s1
    80003254:	00000097          	auipc	ra,0x0
    80003258:	790080e7          	jalr	1936(ra) # 800039e4 <log_write>
    brelse(bp);
    8000325c:	8526                	mv	a0,s1
    8000325e:	fffff097          	auipc	ra,0xfffff
    80003262:	4f2080e7          	jalr	1266(ra) # 80002750 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003266:	01498a3b          	addw	s4,s3,s4
    8000326a:	0129893b          	addw	s2,s3,s2
    8000326e:	9aee                	add	s5,s5,s11
    80003270:	057a7663          	bgeu	s4,s7,800032bc <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003274:	000b2483          	lw	s1,0(s6)
    80003278:	00a9559b          	srliw	a1,s2,0xa
    8000327c:	855a                	mv	a0,s6
    8000327e:	fffff097          	auipc	ra,0xfffff
    80003282:	7ae080e7          	jalr	1966(ra) # 80002a2c <bmap>
    80003286:	0005059b          	sext.w	a1,a0
    8000328a:	8526                	mv	a0,s1
    8000328c:	fffff097          	auipc	ra,0xfffff
    80003290:	1a6080e7          	jalr	422(ra) # 80002432 <bread>
    80003294:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003296:	3ff97713          	andi	a4,s2,1023
    8000329a:	40ed07bb          	subw	a5,s10,a4
    8000329e:	414b86bb          	subw	a3,s7,s4
    800032a2:	89be                	mv	s3,a5
    800032a4:	2781                	sext.w	a5,a5
    800032a6:	0006861b          	sext.w	a2,a3
    800032aa:	f8f674e3          	bgeu	a2,a5,80003232 <writei+0x4c>
    800032ae:	89b6                	mv	s3,a3
    800032b0:	b749                	j	80003232 <writei+0x4c>
      brelse(bp);
    800032b2:	8526                	mv	a0,s1
    800032b4:	fffff097          	auipc	ra,0xfffff
    800032b8:	49c080e7          	jalr	1180(ra) # 80002750 <brelse>
  }

  if(off > ip->size)
    800032bc:	054b2783          	lw	a5,84(s6)
    800032c0:	0127f463          	bgeu	a5,s2,800032c8 <writei+0xe2>
    ip->size = off;
    800032c4:	052b2a23          	sw	s2,84(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800032c8:	855a                	mv	a0,s6
    800032ca:	00000097          	auipc	ra,0x0
    800032ce:	aa6080e7          	jalr	-1370(ra) # 80002d70 <iupdate>

  return tot;
    800032d2:	000a051b          	sext.w	a0,s4
}
    800032d6:	70a6                	ld	ra,104(sp)
    800032d8:	7406                	ld	s0,96(sp)
    800032da:	64e6                	ld	s1,88(sp)
    800032dc:	6946                	ld	s2,80(sp)
    800032de:	69a6                	ld	s3,72(sp)
    800032e0:	6a06                	ld	s4,64(sp)
    800032e2:	7ae2                	ld	s5,56(sp)
    800032e4:	7b42                	ld	s6,48(sp)
    800032e6:	7ba2                	ld	s7,40(sp)
    800032e8:	7c02                	ld	s8,32(sp)
    800032ea:	6ce2                	ld	s9,24(sp)
    800032ec:	6d42                	ld	s10,16(sp)
    800032ee:	6da2                	ld	s11,8(sp)
    800032f0:	6165                	addi	sp,sp,112
    800032f2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032f4:	8a5e                	mv	s4,s7
    800032f6:	bfc9                	j	800032c8 <writei+0xe2>
    return -1;
    800032f8:	557d                	li	a0,-1
}
    800032fa:	8082                	ret
    return -1;
    800032fc:	557d                	li	a0,-1
    800032fe:	bfe1                	j	800032d6 <writei+0xf0>
    return -1;
    80003300:	557d                	li	a0,-1
    80003302:	bfd1                	j	800032d6 <writei+0xf0>

0000000080003304 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003304:	1141                	addi	sp,sp,-16
    80003306:	e406                	sd	ra,8(sp)
    80003308:	e022                	sd	s0,0(sp)
    8000330a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000330c:	4639                	li	a2,14
    8000330e:	ffffd097          	auipc	ra,0xffffd
    80003312:	0dc080e7          	jalr	220(ra) # 800003ea <strncmp>
}
    80003316:	60a2                	ld	ra,8(sp)
    80003318:	6402                	ld	s0,0(sp)
    8000331a:	0141                	addi	sp,sp,16
    8000331c:	8082                	ret

000000008000331e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000331e:	7139                	addi	sp,sp,-64
    80003320:	fc06                	sd	ra,56(sp)
    80003322:	f822                	sd	s0,48(sp)
    80003324:	f426                	sd	s1,40(sp)
    80003326:	f04a                	sd	s2,32(sp)
    80003328:	ec4e                	sd	s3,24(sp)
    8000332a:	e852                	sd	s4,16(sp)
    8000332c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000332e:	04c51703          	lh	a4,76(a0)
    80003332:	4785                	li	a5,1
    80003334:	00f71a63          	bne	a4,a5,80003348 <dirlookup+0x2a>
    80003338:	892a                	mv	s2,a0
    8000333a:	89ae                	mv	s3,a1
    8000333c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000333e:	497c                	lw	a5,84(a0)
    80003340:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003342:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003344:	e79d                	bnez	a5,80003372 <dirlookup+0x54>
    80003346:	a8a5                	j	800033be <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003348:	00005517          	auipc	a0,0x5
    8000334c:	24850513          	addi	a0,a0,584 # 80008590 <syscalls+0x1c0>
    80003350:	00003097          	auipc	ra,0x3
    80003354:	edc080e7          	jalr	-292(ra) # 8000622c <panic>
      panic("dirlookup read");
    80003358:	00005517          	auipc	a0,0x5
    8000335c:	25050513          	addi	a0,a0,592 # 800085a8 <syscalls+0x1d8>
    80003360:	00003097          	auipc	ra,0x3
    80003364:	ecc080e7          	jalr	-308(ra) # 8000622c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003368:	24c1                	addiw	s1,s1,16
    8000336a:	05492783          	lw	a5,84(s2)
    8000336e:	04f4f763          	bgeu	s1,a5,800033bc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003372:	4741                	li	a4,16
    80003374:	86a6                	mv	a3,s1
    80003376:	fc040613          	addi	a2,s0,-64
    8000337a:	4581                	li	a1,0
    8000337c:	854a                	mv	a0,s2
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	d70080e7          	jalr	-656(ra) # 800030ee <readi>
    80003386:	47c1                	li	a5,16
    80003388:	fcf518e3          	bne	a0,a5,80003358 <dirlookup+0x3a>
    if(de.inum == 0)
    8000338c:	fc045783          	lhu	a5,-64(s0)
    80003390:	dfe1                	beqz	a5,80003368 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003392:	fc240593          	addi	a1,s0,-62
    80003396:	854e                	mv	a0,s3
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	f6c080e7          	jalr	-148(ra) # 80003304 <namecmp>
    800033a0:	f561                	bnez	a0,80003368 <dirlookup+0x4a>
      if(poff)
    800033a2:	000a0463          	beqz	s4,800033aa <dirlookup+0x8c>
        *poff = off;
    800033a6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033aa:	fc045583          	lhu	a1,-64(s0)
    800033ae:	00092503          	lw	a0,0(s2)
    800033b2:	fffff097          	auipc	ra,0xfffff
    800033b6:	754080e7          	jalr	1876(ra) # 80002b06 <iget>
    800033ba:	a011                	j	800033be <dirlookup+0xa0>
  return 0;
    800033bc:	4501                	li	a0,0
}
    800033be:	70e2                	ld	ra,56(sp)
    800033c0:	7442                	ld	s0,48(sp)
    800033c2:	74a2                	ld	s1,40(sp)
    800033c4:	7902                	ld	s2,32(sp)
    800033c6:	69e2                	ld	s3,24(sp)
    800033c8:	6a42                	ld	s4,16(sp)
    800033ca:	6121                	addi	sp,sp,64
    800033cc:	8082                	ret

00000000800033ce <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800033ce:	711d                	addi	sp,sp,-96
    800033d0:	ec86                	sd	ra,88(sp)
    800033d2:	e8a2                	sd	s0,80(sp)
    800033d4:	e4a6                	sd	s1,72(sp)
    800033d6:	e0ca                	sd	s2,64(sp)
    800033d8:	fc4e                	sd	s3,56(sp)
    800033da:	f852                	sd	s4,48(sp)
    800033dc:	f456                	sd	s5,40(sp)
    800033de:	f05a                	sd	s6,32(sp)
    800033e0:	ec5e                	sd	s7,24(sp)
    800033e2:	e862                	sd	s8,16(sp)
    800033e4:	e466                	sd	s9,8(sp)
    800033e6:	1080                	addi	s0,sp,96
    800033e8:	84aa                	mv	s1,a0
    800033ea:	8b2e                	mv	s6,a1
    800033ec:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800033ee:	00054703          	lbu	a4,0(a0)
    800033f2:	02f00793          	li	a5,47
    800033f6:	02f70363          	beq	a4,a5,8000341c <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800033fa:	ffffe097          	auipc	ra,0xffffe
    800033fe:	bf8080e7          	jalr	-1032(ra) # 80000ff2 <myproc>
    80003402:	15853503          	ld	a0,344(a0)
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	9f6080e7          	jalr	-1546(ra) # 80002dfc <idup>
    8000340e:	89aa                	mv	s3,a0
  while(*path == '/')
    80003410:	02f00913          	li	s2,47
  len = path - s;
    80003414:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003416:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003418:	4c05                	li	s8,1
    8000341a:	a865                	j	800034d2 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000341c:	4585                	li	a1,1
    8000341e:	4505                	li	a0,1
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	6e6080e7          	jalr	1766(ra) # 80002b06 <iget>
    80003428:	89aa                	mv	s3,a0
    8000342a:	b7dd                	j	80003410 <namex+0x42>
      iunlockput(ip);
    8000342c:	854e                	mv	a0,s3
    8000342e:	00000097          	auipc	ra,0x0
    80003432:	c6e080e7          	jalr	-914(ra) # 8000309c <iunlockput>
      return 0;
    80003436:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003438:	854e                	mv	a0,s3
    8000343a:	60e6                	ld	ra,88(sp)
    8000343c:	6446                	ld	s0,80(sp)
    8000343e:	64a6                	ld	s1,72(sp)
    80003440:	6906                	ld	s2,64(sp)
    80003442:	79e2                	ld	s3,56(sp)
    80003444:	7a42                	ld	s4,48(sp)
    80003446:	7aa2                	ld	s5,40(sp)
    80003448:	7b02                	ld	s6,32(sp)
    8000344a:	6be2                	ld	s7,24(sp)
    8000344c:	6c42                	ld	s8,16(sp)
    8000344e:	6ca2                	ld	s9,8(sp)
    80003450:	6125                	addi	sp,sp,96
    80003452:	8082                	ret
      iunlock(ip);
    80003454:	854e                	mv	a0,s3
    80003456:	00000097          	auipc	ra,0x0
    8000345a:	aa6080e7          	jalr	-1370(ra) # 80002efc <iunlock>
      return ip;
    8000345e:	bfe9                	j	80003438 <namex+0x6a>
      iunlockput(ip);
    80003460:	854e                	mv	a0,s3
    80003462:	00000097          	auipc	ra,0x0
    80003466:	c3a080e7          	jalr	-966(ra) # 8000309c <iunlockput>
      return 0;
    8000346a:	89d2                	mv	s3,s4
    8000346c:	b7f1                	j	80003438 <namex+0x6a>
  len = path - s;
    8000346e:	40b48633          	sub	a2,s1,a1
    80003472:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003476:	094cd463          	bge	s9,s4,800034fe <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000347a:	4639                	li	a2,14
    8000347c:	8556                	mv	a0,s5
    8000347e:	ffffd097          	auipc	ra,0xffffd
    80003482:	ef4080e7          	jalr	-268(ra) # 80000372 <memmove>
  while(*path == '/')
    80003486:	0004c783          	lbu	a5,0(s1)
    8000348a:	01279763          	bne	a5,s2,80003498 <namex+0xca>
    path++;
    8000348e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003490:	0004c783          	lbu	a5,0(s1)
    80003494:	ff278de3          	beq	a5,s2,8000348e <namex+0xc0>
    ilock(ip);
    80003498:	854e                	mv	a0,s3
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	9a0080e7          	jalr	-1632(ra) # 80002e3a <ilock>
    if(ip->type != T_DIR){
    800034a2:	04c99783          	lh	a5,76(s3)
    800034a6:	f98793e3          	bne	a5,s8,8000342c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800034aa:	000b0563          	beqz	s6,800034b4 <namex+0xe6>
    800034ae:	0004c783          	lbu	a5,0(s1)
    800034b2:	d3cd                	beqz	a5,80003454 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034b4:	865e                	mv	a2,s7
    800034b6:	85d6                	mv	a1,s5
    800034b8:	854e                	mv	a0,s3
    800034ba:	00000097          	auipc	ra,0x0
    800034be:	e64080e7          	jalr	-412(ra) # 8000331e <dirlookup>
    800034c2:	8a2a                	mv	s4,a0
    800034c4:	dd51                	beqz	a0,80003460 <namex+0x92>
    iunlockput(ip);
    800034c6:	854e                	mv	a0,s3
    800034c8:	00000097          	auipc	ra,0x0
    800034cc:	bd4080e7          	jalr	-1068(ra) # 8000309c <iunlockput>
    ip = next;
    800034d0:	89d2                	mv	s3,s4
  while(*path == '/')
    800034d2:	0004c783          	lbu	a5,0(s1)
    800034d6:	05279763          	bne	a5,s2,80003524 <namex+0x156>
    path++;
    800034da:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034dc:	0004c783          	lbu	a5,0(s1)
    800034e0:	ff278de3          	beq	a5,s2,800034da <namex+0x10c>
  if(*path == 0)
    800034e4:	c79d                	beqz	a5,80003512 <namex+0x144>
    path++;
    800034e6:	85a6                	mv	a1,s1
  len = path - s;
    800034e8:	8a5e                	mv	s4,s7
    800034ea:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800034ec:	01278963          	beq	a5,s2,800034fe <namex+0x130>
    800034f0:	dfbd                	beqz	a5,8000346e <namex+0xa0>
    path++;
    800034f2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800034f4:	0004c783          	lbu	a5,0(s1)
    800034f8:	ff279ce3          	bne	a5,s2,800034f0 <namex+0x122>
    800034fc:	bf8d                	j	8000346e <namex+0xa0>
    memmove(name, s, len);
    800034fe:	2601                	sext.w	a2,a2
    80003500:	8556                	mv	a0,s5
    80003502:	ffffd097          	auipc	ra,0xffffd
    80003506:	e70080e7          	jalr	-400(ra) # 80000372 <memmove>
    name[len] = 0;
    8000350a:	9a56                	add	s4,s4,s5
    8000350c:	000a0023          	sb	zero,0(s4)
    80003510:	bf9d                	j	80003486 <namex+0xb8>
  if(nameiparent){
    80003512:	f20b03e3          	beqz	s6,80003438 <namex+0x6a>
    iput(ip);
    80003516:	854e                	mv	a0,s3
    80003518:	00000097          	auipc	ra,0x0
    8000351c:	adc080e7          	jalr	-1316(ra) # 80002ff4 <iput>
    return 0;
    80003520:	4981                	li	s3,0
    80003522:	bf19                	j	80003438 <namex+0x6a>
  if(*path == 0)
    80003524:	d7fd                	beqz	a5,80003512 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003526:	0004c783          	lbu	a5,0(s1)
    8000352a:	85a6                	mv	a1,s1
    8000352c:	b7d1                	j	800034f0 <namex+0x122>

000000008000352e <dirlink>:
{
    8000352e:	7139                	addi	sp,sp,-64
    80003530:	fc06                	sd	ra,56(sp)
    80003532:	f822                	sd	s0,48(sp)
    80003534:	f426                	sd	s1,40(sp)
    80003536:	f04a                	sd	s2,32(sp)
    80003538:	ec4e                	sd	s3,24(sp)
    8000353a:	e852                	sd	s4,16(sp)
    8000353c:	0080                	addi	s0,sp,64
    8000353e:	892a                	mv	s2,a0
    80003540:	8a2e                	mv	s4,a1
    80003542:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003544:	4601                	li	a2,0
    80003546:	00000097          	auipc	ra,0x0
    8000354a:	dd8080e7          	jalr	-552(ra) # 8000331e <dirlookup>
    8000354e:	e93d                	bnez	a0,800035c4 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003550:	05492483          	lw	s1,84(s2)
    80003554:	c49d                	beqz	s1,80003582 <dirlink+0x54>
    80003556:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003558:	4741                	li	a4,16
    8000355a:	86a6                	mv	a3,s1
    8000355c:	fc040613          	addi	a2,s0,-64
    80003560:	4581                	li	a1,0
    80003562:	854a                	mv	a0,s2
    80003564:	00000097          	auipc	ra,0x0
    80003568:	b8a080e7          	jalr	-1142(ra) # 800030ee <readi>
    8000356c:	47c1                	li	a5,16
    8000356e:	06f51163          	bne	a0,a5,800035d0 <dirlink+0xa2>
    if(de.inum == 0)
    80003572:	fc045783          	lhu	a5,-64(s0)
    80003576:	c791                	beqz	a5,80003582 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003578:	24c1                	addiw	s1,s1,16
    8000357a:	05492783          	lw	a5,84(s2)
    8000357e:	fcf4ede3          	bltu	s1,a5,80003558 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003582:	4639                	li	a2,14
    80003584:	85d2                	mv	a1,s4
    80003586:	fc240513          	addi	a0,s0,-62
    8000358a:	ffffd097          	auipc	ra,0xffffd
    8000358e:	e9c080e7          	jalr	-356(ra) # 80000426 <strncpy>
  de.inum = inum;
    80003592:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003596:	4741                	li	a4,16
    80003598:	86a6                	mv	a3,s1
    8000359a:	fc040613          	addi	a2,s0,-64
    8000359e:	4581                	li	a1,0
    800035a0:	854a                	mv	a0,s2
    800035a2:	00000097          	auipc	ra,0x0
    800035a6:	c44080e7          	jalr	-956(ra) # 800031e6 <writei>
    800035aa:	872a                	mv	a4,a0
    800035ac:	47c1                	li	a5,16
  return 0;
    800035ae:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035b0:	02f71863          	bne	a4,a5,800035e0 <dirlink+0xb2>
}
    800035b4:	70e2                	ld	ra,56(sp)
    800035b6:	7442                	ld	s0,48(sp)
    800035b8:	74a2                	ld	s1,40(sp)
    800035ba:	7902                	ld	s2,32(sp)
    800035bc:	69e2                	ld	s3,24(sp)
    800035be:	6a42                	ld	s4,16(sp)
    800035c0:	6121                	addi	sp,sp,64
    800035c2:	8082                	ret
    iput(ip);
    800035c4:	00000097          	auipc	ra,0x0
    800035c8:	a30080e7          	jalr	-1488(ra) # 80002ff4 <iput>
    return -1;
    800035cc:	557d                	li	a0,-1
    800035ce:	b7dd                	j	800035b4 <dirlink+0x86>
      panic("dirlink read");
    800035d0:	00005517          	auipc	a0,0x5
    800035d4:	fe850513          	addi	a0,a0,-24 # 800085b8 <syscalls+0x1e8>
    800035d8:	00003097          	auipc	ra,0x3
    800035dc:	c54080e7          	jalr	-940(ra) # 8000622c <panic>
    panic("dirlink");
    800035e0:	00005517          	auipc	a0,0x5
    800035e4:	0e850513          	addi	a0,a0,232 # 800086c8 <syscalls+0x2f8>
    800035e8:	00003097          	auipc	ra,0x3
    800035ec:	c44080e7          	jalr	-956(ra) # 8000622c <panic>

00000000800035f0 <namei>:

struct inode*
namei(char *path)
{
    800035f0:	1101                	addi	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800035f8:	fe040613          	addi	a2,s0,-32
    800035fc:	4581                	li	a1,0
    800035fe:	00000097          	auipc	ra,0x0
    80003602:	dd0080e7          	jalr	-560(ra) # 800033ce <namex>
}
    80003606:	60e2                	ld	ra,24(sp)
    80003608:	6442                	ld	s0,16(sp)
    8000360a:	6105                	addi	sp,sp,32
    8000360c:	8082                	ret

000000008000360e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000360e:	1141                	addi	sp,sp,-16
    80003610:	e406                	sd	ra,8(sp)
    80003612:	e022                	sd	s0,0(sp)
    80003614:	0800                	addi	s0,sp,16
    80003616:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003618:	4585                	li	a1,1
    8000361a:	00000097          	auipc	ra,0x0
    8000361e:	db4080e7          	jalr	-588(ra) # 800033ce <namex>
}
    80003622:	60a2                	ld	ra,8(sp)
    80003624:	6402                	ld	s0,0(sp)
    80003626:	0141                	addi	sp,sp,16
    80003628:	8082                	ret

000000008000362a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000362a:	1101                	addi	sp,sp,-32
    8000362c:	ec06                	sd	ra,24(sp)
    8000362e:	e822                	sd	s0,16(sp)
    80003630:	e426                	sd	s1,8(sp)
    80003632:	e04a                	sd	s2,0(sp)
    80003634:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003636:	00019917          	auipc	s2,0x19
    8000363a:	64290913          	addi	s2,s2,1602 # 8001cc78 <log>
    8000363e:	02092583          	lw	a1,32(s2)
    80003642:	03092503          	lw	a0,48(s2)
    80003646:	fffff097          	auipc	ra,0xfffff
    8000364a:	dec080e7          	jalr	-532(ra) # 80002432 <bread>
    8000364e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003650:	03492683          	lw	a3,52(s2)
    80003654:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003656:	02d05763          	blez	a3,80003684 <write_head+0x5a>
    8000365a:	00019797          	auipc	a5,0x19
    8000365e:	65678793          	addi	a5,a5,1622 # 8001ccb0 <log+0x38>
    80003662:	05c50713          	addi	a4,a0,92
    80003666:	36fd                	addiw	a3,a3,-1
    80003668:	1682                	slli	a3,a3,0x20
    8000366a:	9281                	srli	a3,a3,0x20
    8000366c:	068a                	slli	a3,a3,0x2
    8000366e:	00019617          	auipc	a2,0x19
    80003672:	64660613          	addi	a2,a2,1606 # 8001ccb4 <log+0x3c>
    80003676:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003678:	4390                	lw	a2,0(a5)
    8000367a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000367c:	0791                	addi	a5,a5,4
    8000367e:	0711                	addi	a4,a4,4
    80003680:	fed79ce3          	bne	a5,a3,80003678 <write_head+0x4e>
  }
  bwrite(buf);
    80003684:	8526                	mv	a0,s1
    80003686:	fffff097          	auipc	ra,0xfffff
    8000368a:	08c080e7          	jalr	140(ra) # 80002712 <bwrite>
  brelse(buf);
    8000368e:	8526                	mv	a0,s1
    80003690:	fffff097          	auipc	ra,0xfffff
    80003694:	0c0080e7          	jalr	192(ra) # 80002750 <brelse>
}
    80003698:	60e2                	ld	ra,24(sp)
    8000369a:	6442                	ld	s0,16(sp)
    8000369c:	64a2                	ld	s1,8(sp)
    8000369e:	6902                	ld	s2,0(sp)
    800036a0:	6105                	addi	sp,sp,32
    800036a2:	8082                	ret

00000000800036a4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036a4:	00019797          	auipc	a5,0x19
    800036a8:	6087a783          	lw	a5,1544(a5) # 8001ccac <log+0x34>
    800036ac:	0af05d63          	blez	a5,80003766 <install_trans+0xc2>
{
    800036b0:	7139                	addi	sp,sp,-64
    800036b2:	fc06                	sd	ra,56(sp)
    800036b4:	f822                	sd	s0,48(sp)
    800036b6:	f426                	sd	s1,40(sp)
    800036b8:	f04a                	sd	s2,32(sp)
    800036ba:	ec4e                	sd	s3,24(sp)
    800036bc:	e852                	sd	s4,16(sp)
    800036be:	e456                	sd	s5,8(sp)
    800036c0:	e05a                	sd	s6,0(sp)
    800036c2:	0080                	addi	s0,sp,64
    800036c4:	8b2a                	mv	s6,a0
    800036c6:	00019a97          	auipc	s5,0x19
    800036ca:	5eaa8a93          	addi	s5,s5,1514 # 8001ccb0 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ce:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800036d0:	00019997          	auipc	s3,0x19
    800036d4:	5a898993          	addi	s3,s3,1448 # 8001cc78 <log>
    800036d8:	a035                	j	80003704 <install_trans+0x60>
      bunpin(dbuf);
    800036da:	8526                	mv	a0,s1
    800036dc:	fffff097          	auipc	ra,0xfffff
    800036e0:	152080e7          	jalr	338(ra) # 8000282e <bunpin>
    brelse(lbuf);
    800036e4:	854a                	mv	a0,s2
    800036e6:	fffff097          	auipc	ra,0xfffff
    800036ea:	06a080e7          	jalr	106(ra) # 80002750 <brelse>
    brelse(dbuf);
    800036ee:	8526                	mv	a0,s1
    800036f0:	fffff097          	auipc	ra,0xfffff
    800036f4:	060080e7          	jalr	96(ra) # 80002750 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f8:	2a05                	addiw	s4,s4,1
    800036fa:	0a91                	addi	s5,s5,4
    800036fc:	0349a783          	lw	a5,52(s3)
    80003700:	04fa5963          	bge	s4,a5,80003752 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003704:	0209a583          	lw	a1,32(s3)
    80003708:	014585bb          	addw	a1,a1,s4
    8000370c:	2585                	addiw	a1,a1,1
    8000370e:	0309a503          	lw	a0,48(s3)
    80003712:	fffff097          	auipc	ra,0xfffff
    80003716:	d20080e7          	jalr	-736(ra) # 80002432 <bread>
    8000371a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000371c:	000aa583          	lw	a1,0(s5)
    80003720:	0309a503          	lw	a0,48(s3)
    80003724:	fffff097          	auipc	ra,0xfffff
    80003728:	d0e080e7          	jalr	-754(ra) # 80002432 <bread>
    8000372c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000372e:	40000613          	li	a2,1024
    80003732:	05890593          	addi	a1,s2,88
    80003736:	05850513          	addi	a0,a0,88
    8000373a:	ffffd097          	auipc	ra,0xffffd
    8000373e:	c38080e7          	jalr	-968(ra) # 80000372 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003742:	8526                	mv	a0,s1
    80003744:	fffff097          	auipc	ra,0xfffff
    80003748:	fce080e7          	jalr	-50(ra) # 80002712 <bwrite>
    if(recovering == 0)
    8000374c:	f80b1ce3          	bnez	s6,800036e4 <install_trans+0x40>
    80003750:	b769                	j	800036da <install_trans+0x36>
}
    80003752:	70e2                	ld	ra,56(sp)
    80003754:	7442                	ld	s0,48(sp)
    80003756:	74a2                	ld	s1,40(sp)
    80003758:	7902                	ld	s2,32(sp)
    8000375a:	69e2                	ld	s3,24(sp)
    8000375c:	6a42                	ld	s4,16(sp)
    8000375e:	6aa2                	ld	s5,8(sp)
    80003760:	6b02                	ld	s6,0(sp)
    80003762:	6121                	addi	sp,sp,64
    80003764:	8082                	ret
    80003766:	8082                	ret

0000000080003768 <initlog>:
{
    80003768:	7179                	addi	sp,sp,-48
    8000376a:	f406                	sd	ra,40(sp)
    8000376c:	f022                	sd	s0,32(sp)
    8000376e:	ec26                	sd	s1,24(sp)
    80003770:	e84a                	sd	s2,16(sp)
    80003772:	e44e                	sd	s3,8(sp)
    80003774:	1800                	addi	s0,sp,48
    80003776:	892a                	mv	s2,a0
    80003778:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000377a:	00019497          	auipc	s1,0x19
    8000377e:	4fe48493          	addi	s1,s1,1278 # 8001cc78 <log>
    80003782:	00005597          	auipc	a1,0x5
    80003786:	e4658593          	addi	a1,a1,-442 # 800085c8 <syscalls+0x1f8>
    8000378a:	8526                	mv	a0,s1
    8000378c:	00003097          	auipc	ra,0x3
    80003790:	150080e7          	jalr	336(ra) # 800068dc <initlock>
  log.start = sb->logstart;
    80003794:	0149a583          	lw	a1,20(s3)
    80003798:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    8000379a:	0109a783          	lw	a5,16(s3)
    8000379e:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    800037a0:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037a4:	854a                	mv	a0,s2
    800037a6:	fffff097          	auipc	ra,0xfffff
    800037aa:	c8c080e7          	jalr	-884(ra) # 80002432 <bread>
  log.lh.n = lh->n;
    800037ae:	4d3c                	lw	a5,88(a0)
    800037b0:	d8dc                	sw	a5,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037b2:	02f05563          	blez	a5,800037dc <initlog+0x74>
    800037b6:	05c50713          	addi	a4,a0,92
    800037ba:	00019697          	auipc	a3,0x19
    800037be:	4f668693          	addi	a3,a3,1270 # 8001ccb0 <log+0x38>
    800037c2:	37fd                	addiw	a5,a5,-1
    800037c4:	1782                	slli	a5,a5,0x20
    800037c6:	9381                	srli	a5,a5,0x20
    800037c8:	078a                	slli	a5,a5,0x2
    800037ca:	06050613          	addi	a2,a0,96
    800037ce:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800037d0:	4310                	lw	a2,0(a4)
    800037d2:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800037d4:	0711                	addi	a4,a4,4
    800037d6:	0691                	addi	a3,a3,4
    800037d8:	fef71ce3          	bne	a4,a5,800037d0 <initlog+0x68>
  brelse(buf);
    800037dc:	fffff097          	auipc	ra,0xfffff
    800037e0:	f74080e7          	jalr	-140(ra) # 80002750 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800037e4:	4505                	li	a0,1
    800037e6:	00000097          	auipc	ra,0x0
    800037ea:	ebe080e7          	jalr	-322(ra) # 800036a4 <install_trans>
  log.lh.n = 0;
    800037ee:	00019797          	auipc	a5,0x19
    800037f2:	4a07af23          	sw	zero,1214(a5) # 8001ccac <log+0x34>
  write_head(); // clear the log
    800037f6:	00000097          	auipc	ra,0x0
    800037fa:	e34080e7          	jalr	-460(ra) # 8000362a <write_head>
}
    800037fe:	70a2                	ld	ra,40(sp)
    80003800:	7402                	ld	s0,32(sp)
    80003802:	64e2                	ld	s1,24(sp)
    80003804:	6942                	ld	s2,16(sp)
    80003806:	69a2                	ld	s3,8(sp)
    80003808:	6145                	addi	sp,sp,48
    8000380a:	8082                	ret

000000008000380c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000380c:	1101                	addi	sp,sp,-32
    8000380e:	ec06                	sd	ra,24(sp)
    80003810:	e822                	sd	s0,16(sp)
    80003812:	e426                	sd	s1,8(sp)
    80003814:	e04a                	sd	s2,0(sp)
    80003816:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003818:	00019517          	auipc	a0,0x19
    8000381c:	46050513          	addi	a0,a0,1120 # 8001cc78 <log>
    80003820:	00003097          	auipc	ra,0x3
    80003824:	f40080e7          	jalr	-192(ra) # 80006760 <acquire>
  while(1){
    if(log.committing){
    80003828:	00019497          	auipc	s1,0x19
    8000382c:	45048493          	addi	s1,s1,1104 # 8001cc78 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003830:	4979                	li	s2,30
    80003832:	a039                	j	80003840 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003834:	85a6                	mv	a1,s1
    80003836:	8526                	mv	a0,s1
    80003838:	ffffe097          	auipc	ra,0xffffe
    8000383c:	e76080e7          	jalr	-394(ra) # 800016ae <sleep>
    if(log.committing){
    80003840:	54dc                	lw	a5,44(s1)
    80003842:	fbed                	bnez	a5,80003834 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003844:	549c                	lw	a5,40(s1)
    80003846:	0017871b          	addiw	a4,a5,1
    8000384a:	0007069b          	sext.w	a3,a4
    8000384e:	0027179b          	slliw	a5,a4,0x2
    80003852:	9fb9                	addw	a5,a5,a4
    80003854:	0017979b          	slliw	a5,a5,0x1
    80003858:	58d8                	lw	a4,52(s1)
    8000385a:	9fb9                	addw	a5,a5,a4
    8000385c:	00f95963          	bge	s2,a5,8000386e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003860:	85a6                	mv	a1,s1
    80003862:	8526                	mv	a0,s1
    80003864:	ffffe097          	auipc	ra,0xffffe
    80003868:	e4a080e7          	jalr	-438(ra) # 800016ae <sleep>
    8000386c:	bfd1                	j	80003840 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000386e:	00019517          	auipc	a0,0x19
    80003872:	40a50513          	addi	a0,a0,1034 # 8001cc78 <log>
    80003876:	d514                	sw	a3,40(a0)
      release(&log.lock);
    80003878:	00003097          	auipc	ra,0x3
    8000387c:	fb8080e7          	jalr	-72(ra) # 80006830 <release>
      break;
    }
  }
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	addi	sp,sp,32
    8000388a:	8082                	ret

000000008000388c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000388c:	7139                	addi	sp,sp,-64
    8000388e:	fc06                	sd	ra,56(sp)
    80003890:	f822                	sd	s0,48(sp)
    80003892:	f426                	sd	s1,40(sp)
    80003894:	f04a                	sd	s2,32(sp)
    80003896:	ec4e                	sd	s3,24(sp)
    80003898:	e852                	sd	s4,16(sp)
    8000389a:	e456                	sd	s5,8(sp)
    8000389c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000389e:	00019497          	auipc	s1,0x19
    800038a2:	3da48493          	addi	s1,s1,986 # 8001cc78 <log>
    800038a6:	8526                	mv	a0,s1
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	eb8080e7          	jalr	-328(ra) # 80006760 <acquire>
  log.outstanding -= 1;
    800038b0:	549c                	lw	a5,40(s1)
    800038b2:	37fd                	addiw	a5,a5,-1
    800038b4:	0007891b          	sext.w	s2,a5
    800038b8:	d49c                	sw	a5,40(s1)
  if(log.committing)
    800038ba:	54dc                	lw	a5,44(s1)
    800038bc:	efb9                	bnez	a5,8000391a <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800038be:	06091663          	bnez	s2,8000392a <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800038c2:	00019497          	auipc	s1,0x19
    800038c6:	3b648493          	addi	s1,s1,950 # 8001cc78 <log>
    800038ca:	4785                	li	a5,1
    800038cc:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800038ce:	8526                	mv	a0,s1
    800038d0:	00003097          	auipc	ra,0x3
    800038d4:	f60080e7          	jalr	-160(ra) # 80006830 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800038d8:	58dc                	lw	a5,52(s1)
    800038da:	06f04763          	bgtz	a5,80003948 <end_op+0xbc>
    acquire(&log.lock);
    800038de:	00019497          	auipc	s1,0x19
    800038e2:	39a48493          	addi	s1,s1,922 # 8001cc78 <log>
    800038e6:	8526                	mv	a0,s1
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	e78080e7          	jalr	-392(ra) # 80006760 <acquire>
    log.committing = 0;
    800038f0:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    800038f4:	8526                	mv	a0,s1
    800038f6:	ffffe097          	auipc	ra,0xffffe
    800038fa:	f44080e7          	jalr	-188(ra) # 8000183a <wakeup>
    release(&log.lock);
    800038fe:	8526                	mv	a0,s1
    80003900:	00003097          	auipc	ra,0x3
    80003904:	f30080e7          	jalr	-208(ra) # 80006830 <release>
}
    80003908:	70e2                	ld	ra,56(sp)
    8000390a:	7442                	ld	s0,48(sp)
    8000390c:	74a2                	ld	s1,40(sp)
    8000390e:	7902                	ld	s2,32(sp)
    80003910:	69e2                	ld	s3,24(sp)
    80003912:	6a42                	ld	s4,16(sp)
    80003914:	6aa2                	ld	s5,8(sp)
    80003916:	6121                	addi	sp,sp,64
    80003918:	8082                	ret
    panic("log.committing");
    8000391a:	00005517          	auipc	a0,0x5
    8000391e:	cb650513          	addi	a0,a0,-842 # 800085d0 <syscalls+0x200>
    80003922:	00003097          	auipc	ra,0x3
    80003926:	90a080e7          	jalr	-1782(ra) # 8000622c <panic>
    wakeup(&log);
    8000392a:	00019497          	auipc	s1,0x19
    8000392e:	34e48493          	addi	s1,s1,846 # 8001cc78 <log>
    80003932:	8526                	mv	a0,s1
    80003934:	ffffe097          	auipc	ra,0xffffe
    80003938:	f06080e7          	jalr	-250(ra) # 8000183a <wakeup>
  release(&log.lock);
    8000393c:	8526                	mv	a0,s1
    8000393e:	00003097          	auipc	ra,0x3
    80003942:	ef2080e7          	jalr	-270(ra) # 80006830 <release>
  if(do_commit){
    80003946:	b7c9                	j	80003908 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003948:	00019a97          	auipc	s5,0x19
    8000394c:	368a8a93          	addi	s5,s5,872 # 8001ccb0 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003950:	00019a17          	auipc	s4,0x19
    80003954:	328a0a13          	addi	s4,s4,808 # 8001cc78 <log>
    80003958:	020a2583          	lw	a1,32(s4)
    8000395c:	012585bb          	addw	a1,a1,s2
    80003960:	2585                	addiw	a1,a1,1
    80003962:	030a2503          	lw	a0,48(s4)
    80003966:	fffff097          	auipc	ra,0xfffff
    8000396a:	acc080e7          	jalr	-1332(ra) # 80002432 <bread>
    8000396e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003970:	000aa583          	lw	a1,0(s5)
    80003974:	030a2503          	lw	a0,48(s4)
    80003978:	fffff097          	auipc	ra,0xfffff
    8000397c:	aba080e7          	jalr	-1350(ra) # 80002432 <bread>
    80003980:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003982:	40000613          	li	a2,1024
    80003986:	05850593          	addi	a1,a0,88
    8000398a:	05848513          	addi	a0,s1,88
    8000398e:	ffffd097          	auipc	ra,0xffffd
    80003992:	9e4080e7          	jalr	-1564(ra) # 80000372 <memmove>
    bwrite(to);  // write the log
    80003996:	8526                	mv	a0,s1
    80003998:	fffff097          	auipc	ra,0xfffff
    8000399c:	d7a080e7          	jalr	-646(ra) # 80002712 <bwrite>
    brelse(from);
    800039a0:	854e                	mv	a0,s3
    800039a2:	fffff097          	auipc	ra,0xfffff
    800039a6:	dae080e7          	jalr	-594(ra) # 80002750 <brelse>
    brelse(to);
    800039aa:	8526                	mv	a0,s1
    800039ac:	fffff097          	auipc	ra,0xfffff
    800039b0:	da4080e7          	jalr	-604(ra) # 80002750 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039b4:	2905                	addiw	s2,s2,1
    800039b6:	0a91                	addi	s5,s5,4
    800039b8:	034a2783          	lw	a5,52(s4)
    800039bc:	f8f94ee3          	blt	s2,a5,80003958 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800039c0:	00000097          	auipc	ra,0x0
    800039c4:	c6a080e7          	jalr	-918(ra) # 8000362a <write_head>
    install_trans(0); // Now install writes to home locations
    800039c8:	4501                	li	a0,0
    800039ca:	00000097          	auipc	ra,0x0
    800039ce:	cda080e7          	jalr	-806(ra) # 800036a4 <install_trans>
    log.lh.n = 0;
    800039d2:	00019797          	auipc	a5,0x19
    800039d6:	2c07ad23          	sw	zero,730(a5) # 8001ccac <log+0x34>
    write_head();    // Erase the transaction from the log
    800039da:	00000097          	auipc	ra,0x0
    800039de:	c50080e7          	jalr	-944(ra) # 8000362a <write_head>
    800039e2:	bdf5                	j	800038de <end_op+0x52>

00000000800039e4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800039e4:	1101                	addi	sp,sp,-32
    800039e6:	ec06                	sd	ra,24(sp)
    800039e8:	e822                	sd	s0,16(sp)
    800039ea:	e426                	sd	s1,8(sp)
    800039ec:	e04a                	sd	s2,0(sp)
    800039ee:	1000                	addi	s0,sp,32
    800039f0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800039f2:	00019917          	auipc	s2,0x19
    800039f6:	28690913          	addi	s2,s2,646 # 8001cc78 <log>
    800039fa:	854a                	mv	a0,s2
    800039fc:	00003097          	auipc	ra,0x3
    80003a00:	d64080e7          	jalr	-668(ra) # 80006760 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a04:	03492603          	lw	a2,52(s2)
    80003a08:	47f5                	li	a5,29
    80003a0a:	06c7c563          	blt	a5,a2,80003a74 <log_write+0x90>
    80003a0e:	00019797          	auipc	a5,0x19
    80003a12:	28e7a783          	lw	a5,654(a5) # 8001cc9c <log+0x24>
    80003a16:	37fd                	addiw	a5,a5,-1
    80003a18:	04f65e63          	bge	a2,a5,80003a74 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a1c:	00019797          	auipc	a5,0x19
    80003a20:	2847a783          	lw	a5,644(a5) # 8001cca0 <log+0x28>
    80003a24:	06f05063          	blez	a5,80003a84 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a28:	4781                	li	a5,0
    80003a2a:	06c05563          	blez	a2,80003a94 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a2e:	44cc                	lw	a1,12(s1)
    80003a30:	00019717          	auipc	a4,0x19
    80003a34:	28070713          	addi	a4,a4,640 # 8001ccb0 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    80003a38:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a3a:	4314                	lw	a3,0(a4)
    80003a3c:	04b68c63          	beq	a3,a1,80003a94 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a40:	2785                	addiw	a5,a5,1
    80003a42:	0711                	addi	a4,a4,4
    80003a44:	fef61be3          	bne	a2,a5,80003a3a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a48:	0631                	addi	a2,a2,12
    80003a4a:	060a                	slli	a2,a2,0x2
    80003a4c:	00019797          	auipc	a5,0x19
    80003a50:	22c78793          	addi	a5,a5,556 # 8001cc78 <log>
    80003a54:	963e                	add	a2,a2,a5
    80003a56:	44dc                	lw	a5,12(s1)
    80003a58:	c61c                	sw	a5,8(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	fffff097          	auipc	ra,0xfffff
    80003a60:	d82080e7          	jalr	-638(ra) # 800027de <bpin>
    log.lh.n++;
    80003a64:	00019717          	auipc	a4,0x19
    80003a68:	21470713          	addi	a4,a4,532 # 8001cc78 <log>
    80003a6c:	5b5c                	lw	a5,52(a4)
    80003a6e:	2785                	addiw	a5,a5,1
    80003a70:	db5c                	sw	a5,52(a4)
    80003a72:	a835                	j	80003aae <log_write+0xca>
    panic("too big a transaction");
    80003a74:	00005517          	auipc	a0,0x5
    80003a78:	b6c50513          	addi	a0,a0,-1172 # 800085e0 <syscalls+0x210>
    80003a7c:	00002097          	auipc	ra,0x2
    80003a80:	7b0080e7          	jalr	1968(ra) # 8000622c <panic>
    panic("log_write outside of trans");
    80003a84:	00005517          	auipc	a0,0x5
    80003a88:	b7450513          	addi	a0,a0,-1164 # 800085f8 <syscalls+0x228>
    80003a8c:	00002097          	auipc	ra,0x2
    80003a90:	7a0080e7          	jalr	1952(ra) # 8000622c <panic>
  log.lh.block[i] = b->blockno;
    80003a94:	00c78713          	addi	a4,a5,12
    80003a98:	00271693          	slli	a3,a4,0x2
    80003a9c:	00019717          	auipc	a4,0x19
    80003aa0:	1dc70713          	addi	a4,a4,476 # 8001cc78 <log>
    80003aa4:	9736                	add	a4,a4,a3
    80003aa6:	44d4                	lw	a3,12(s1)
    80003aa8:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003aaa:	faf608e3          	beq	a2,a5,80003a5a <log_write+0x76>
  }
  release(&log.lock);
    80003aae:	00019517          	auipc	a0,0x19
    80003ab2:	1ca50513          	addi	a0,a0,458 # 8001cc78 <log>
    80003ab6:	00003097          	auipc	ra,0x3
    80003aba:	d7a080e7          	jalr	-646(ra) # 80006830 <release>
}
    80003abe:	60e2                	ld	ra,24(sp)
    80003ac0:	6442                	ld	s0,16(sp)
    80003ac2:	64a2                	ld	s1,8(sp)
    80003ac4:	6902                	ld	s2,0(sp)
    80003ac6:	6105                	addi	sp,sp,32
    80003ac8:	8082                	ret

0000000080003aca <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003aca:	1101                	addi	sp,sp,-32
    80003acc:	ec06                	sd	ra,24(sp)
    80003ace:	e822                	sd	s0,16(sp)
    80003ad0:	e426                	sd	s1,8(sp)
    80003ad2:	e04a                	sd	s2,0(sp)
    80003ad4:	1000                	addi	s0,sp,32
    80003ad6:	84aa                	mv	s1,a0
    80003ad8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003ada:	00005597          	auipc	a1,0x5
    80003ade:	b3e58593          	addi	a1,a1,-1218 # 80008618 <syscalls+0x248>
    80003ae2:	0521                	addi	a0,a0,8
    80003ae4:	00003097          	auipc	ra,0x3
    80003ae8:	df8080e7          	jalr	-520(ra) # 800068dc <initlock>
  lk->name = name;
    80003aec:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003af0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003af4:	0204a823          	sw	zero,48(s1)
}
    80003af8:	60e2                	ld	ra,24(sp)
    80003afa:	6442                	ld	s0,16(sp)
    80003afc:	64a2                	ld	s1,8(sp)
    80003afe:	6902                	ld	s2,0(sp)
    80003b00:	6105                	addi	sp,sp,32
    80003b02:	8082                	ret

0000000080003b04 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b04:	1101                	addi	sp,sp,-32
    80003b06:	ec06                	sd	ra,24(sp)
    80003b08:	e822                	sd	s0,16(sp)
    80003b0a:	e426                	sd	s1,8(sp)
    80003b0c:	e04a                	sd	s2,0(sp)
    80003b0e:	1000                	addi	s0,sp,32
    80003b10:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b12:	00850913          	addi	s2,a0,8
    80003b16:	854a                	mv	a0,s2
    80003b18:	00003097          	auipc	ra,0x3
    80003b1c:	c48080e7          	jalr	-952(ra) # 80006760 <acquire>
  while (lk->locked) {
    80003b20:	409c                	lw	a5,0(s1)
    80003b22:	cb89                	beqz	a5,80003b34 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b24:	85ca                	mv	a1,s2
    80003b26:	8526                	mv	a0,s1
    80003b28:	ffffe097          	auipc	ra,0xffffe
    80003b2c:	b86080e7          	jalr	-1146(ra) # 800016ae <sleep>
  while (lk->locked) {
    80003b30:	409c                	lw	a5,0(s1)
    80003b32:	fbed                	bnez	a5,80003b24 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b34:	4785                	li	a5,1
    80003b36:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b38:	ffffd097          	auipc	ra,0xffffd
    80003b3c:	4ba080e7          	jalr	1210(ra) # 80000ff2 <myproc>
    80003b40:	5d1c                	lw	a5,56(a0)
    80003b42:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003b44:	854a                	mv	a0,s2
    80003b46:	00003097          	auipc	ra,0x3
    80003b4a:	cea080e7          	jalr	-790(ra) # 80006830 <release>
}
    80003b4e:	60e2                	ld	ra,24(sp)
    80003b50:	6442                	ld	s0,16(sp)
    80003b52:	64a2                	ld	s1,8(sp)
    80003b54:	6902                	ld	s2,0(sp)
    80003b56:	6105                	addi	sp,sp,32
    80003b58:	8082                	ret

0000000080003b5a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b5a:	1101                	addi	sp,sp,-32
    80003b5c:	ec06                	sd	ra,24(sp)
    80003b5e:	e822                	sd	s0,16(sp)
    80003b60:	e426                	sd	s1,8(sp)
    80003b62:	e04a                	sd	s2,0(sp)
    80003b64:	1000                	addi	s0,sp,32
    80003b66:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b68:	00850913          	addi	s2,a0,8
    80003b6c:	854a                	mv	a0,s2
    80003b6e:	00003097          	auipc	ra,0x3
    80003b72:	bf2080e7          	jalr	-1038(ra) # 80006760 <acquire>
  lk->locked = 0;
    80003b76:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b7a:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003b7e:	8526                	mv	a0,s1
    80003b80:	ffffe097          	auipc	ra,0xffffe
    80003b84:	cba080e7          	jalr	-838(ra) # 8000183a <wakeup>
  release(&lk->lk);
    80003b88:	854a                	mv	a0,s2
    80003b8a:	00003097          	auipc	ra,0x3
    80003b8e:	ca6080e7          	jalr	-858(ra) # 80006830 <release>
}
    80003b92:	60e2                	ld	ra,24(sp)
    80003b94:	6442                	ld	s0,16(sp)
    80003b96:	64a2                	ld	s1,8(sp)
    80003b98:	6902                	ld	s2,0(sp)
    80003b9a:	6105                	addi	sp,sp,32
    80003b9c:	8082                	ret

0000000080003b9e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b9e:	7179                	addi	sp,sp,-48
    80003ba0:	f406                	sd	ra,40(sp)
    80003ba2:	f022                	sd	s0,32(sp)
    80003ba4:	ec26                	sd	s1,24(sp)
    80003ba6:	e84a                	sd	s2,16(sp)
    80003ba8:	e44e                	sd	s3,8(sp)
    80003baa:	1800                	addi	s0,sp,48
    80003bac:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003bae:	00850913          	addi	s2,a0,8
    80003bb2:	854a                	mv	a0,s2
    80003bb4:	00003097          	auipc	ra,0x3
    80003bb8:	bac080e7          	jalr	-1108(ra) # 80006760 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bbc:	409c                	lw	a5,0(s1)
    80003bbe:	ef99                	bnez	a5,80003bdc <holdingsleep+0x3e>
    80003bc0:	4481                	li	s1,0
  release(&lk->lk);
    80003bc2:	854a                	mv	a0,s2
    80003bc4:	00003097          	auipc	ra,0x3
    80003bc8:	c6c080e7          	jalr	-916(ra) # 80006830 <release>
  return r;
}
    80003bcc:	8526                	mv	a0,s1
    80003bce:	70a2                	ld	ra,40(sp)
    80003bd0:	7402                	ld	s0,32(sp)
    80003bd2:	64e2                	ld	s1,24(sp)
    80003bd4:	6942                	ld	s2,16(sp)
    80003bd6:	69a2                	ld	s3,8(sp)
    80003bd8:	6145                	addi	sp,sp,48
    80003bda:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003bdc:	0304a983          	lw	s3,48(s1)
    80003be0:	ffffd097          	auipc	ra,0xffffd
    80003be4:	412080e7          	jalr	1042(ra) # 80000ff2 <myproc>
    80003be8:	5d04                	lw	s1,56(a0)
    80003bea:	413484b3          	sub	s1,s1,s3
    80003bee:	0014b493          	seqz	s1,s1
    80003bf2:	bfc1                	j	80003bc2 <holdingsleep+0x24>

0000000080003bf4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003bf4:	1141                	addi	sp,sp,-16
    80003bf6:	e406                	sd	ra,8(sp)
    80003bf8:	e022                	sd	s0,0(sp)
    80003bfa:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003bfc:	00005597          	auipc	a1,0x5
    80003c00:	a2c58593          	addi	a1,a1,-1492 # 80008628 <syscalls+0x258>
    80003c04:	00019517          	auipc	a0,0x19
    80003c08:	1c450513          	addi	a0,a0,452 # 8001cdc8 <ftable>
    80003c0c:	00003097          	auipc	ra,0x3
    80003c10:	cd0080e7          	jalr	-816(ra) # 800068dc <initlock>
}
    80003c14:	60a2                	ld	ra,8(sp)
    80003c16:	6402                	ld	s0,0(sp)
    80003c18:	0141                	addi	sp,sp,16
    80003c1a:	8082                	ret

0000000080003c1c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c1c:	1101                	addi	sp,sp,-32
    80003c1e:	ec06                	sd	ra,24(sp)
    80003c20:	e822                	sd	s0,16(sp)
    80003c22:	e426                	sd	s1,8(sp)
    80003c24:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c26:	00019517          	auipc	a0,0x19
    80003c2a:	1a250513          	addi	a0,a0,418 # 8001cdc8 <ftable>
    80003c2e:	00003097          	auipc	ra,0x3
    80003c32:	b32080e7          	jalr	-1230(ra) # 80006760 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c36:	00019497          	auipc	s1,0x19
    80003c3a:	1b248493          	addi	s1,s1,434 # 8001cde8 <ftable+0x20>
    80003c3e:	0001a717          	auipc	a4,0x1a
    80003c42:	14a70713          	addi	a4,a4,330 # 8001dd88 <ftable+0xfc0>
    if(f->ref == 0){
    80003c46:	40dc                	lw	a5,4(s1)
    80003c48:	cf99                	beqz	a5,80003c66 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c4a:	02848493          	addi	s1,s1,40
    80003c4e:	fee49ce3          	bne	s1,a4,80003c46 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c52:	00019517          	auipc	a0,0x19
    80003c56:	17650513          	addi	a0,a0,374 # 8001cdc8 <ftable>
    80003c5a:	00003097          	auipc	ra,0x3
    80003c5e:	bd6080e7          	jalr	-1066(ra) # 80006830 <release>
  return 0;
    80003c62:	4481                	li	s1,0
    80003c64:	a819                	j	80003c7a <filealloc+0x5e>
      f->ref = 1;
    80003c66:	4785                	li	a5,1
    80003c68:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003c6a:	00019517          	auipc	a0,0x19
    80003c6e:	15e50513          	addi	a0,a0,350 # 8001cdc8 <ftable>
    80003c72:	00003097          	auipc	ra,0x3
    80003c76:	bbe080e7          	jalr	-1090(ra) # 80006830 <release>
}
    80003c7a:	8526                	mv	a0,s1
    80003c7c:	60e2                	ld	ra,24(sp)
    80003c7e:	6442                	ld	s0,16(sp)
    80003c80:	64a2                	ld	s1,8(sp)
    80003c82:	6105                	addi	sp,sp,32
    80003c84:	8082                	ret

0000000080003c86 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c86:	1101                	addi	sp,sp,-32
    80003c88:	ec06                	sd	ra,24(sp)
    80003c8a:	e822                	sd	s0,16(sp)
    80003c8c:	e426                	sd	s1,8(sp)
    80003c8e:	1000                	addi	s0,sp,32
    80003c90:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c92:	00019517          	auipc	a0,0x19
    80003c96:	13650513          	addi	a0,a0,310 # 8001cdc8 <ftable>
    80003c9a:	00003097          	auipc	ra,0x3
    80003c9e:	ac6080e7          	jalr	-1338(ra) # 80006760 <acquire>
  if(f->ref < 1)
    80003ca2:	40dc                	lw	a5,4(s1)
    80003ca4:	02f05263          	blez	a5,80003cc8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ca8:	2785                	addiw	a5,a5,1
    80003caa:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003cac:	00019517          	auipc	a0,0x19
    80003cb0:	11c50513          	addi	a0,a0,284 # 8001cdc8 <ftable>
    80003cb4:	00003097          	auipc	ra,0x3
    80003cb8:	b7c080e7          	jalr	-1156(ra) # 80006830 <release>
  return f;
}
    80003cbc:	8526                	mv	a0,s1
    80003cbe:	60e2                	ld	ra,24(sp)
    80003cc0:	6442                	ld	s0,16(sp)
    80003cc2:	64a2                	ld	s1,8(sp)
    80003cc4:	6105                	addi	sp,sp,32
    80003cc6:	8082                	ret
    panic("filedup");
    80003cc8:	00005517          	auipc	a0,0x5
    80003ccc:	96850513          	addi	a0,a0,-1688 # 80008630 <syscalls+0x260>
    80003cd0:	00002097          	auipc	ra,0x2
    80003cd4:	55c080e7          	jalr	1372(ra) # 8000622c <panic>

0000000080003cd8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003cd8:	7139                	addi	sp,sp,-64
    80003cda:	fc06                	sd	ra,56(sp)
    80003cdc:	f822                	sd	s0,48(sp)
    80003cde:	f426                	sd	s1,40(sp)
    80003ce0:	f04a                	sd	s2,32(sp)
    80003ce2:	ec4e                	sd	s3,24(sp)
    80003ce4:	e852                	sd	s4,16(sp)
    80003ce6:	e456                	sd	s5,8(sp)
    80003ce8:	0080                	addi	s0,sp,64
    80003cea:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003cec:	00019517          	auipc	a0,0x19
    80003cf0:	0dc50513          	addi	a0,a0,220 # 8001cdc8 <ftable>
    80003cf4:	00003097          	auipc	ra,0x3
    80003cf8:	a6c080e7          	jalr	-1428(ra) # 80006760 <acquire>
  if(f->ref < 1)
    80003cfc:	40dc                	lw	a5,4(s1)
    80003cfe:	06f05163          	blez	a5,80003d60 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003d02:	37fd                	addiw	a5,a5,-1
    80003d04:	0007871b          	sext.w	a4,a5
    80003d08:	c0dc                	sw	a5,4(s1)
    80003d0a:	06e04363          	bgtz	a4,80003d70 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d0e:	0004a903          	lw	s2,0(s1)
    80003d12:	0094ca83          	lbu	s5,9(s1)
    80003d16:	0104ba03          	ld	s4,16(s1)
    80003d1a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d1e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d22:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d26:	00019517          	auipc	a0,0x19
    80003d2a:	0a250513          	addi	a0,a0,162 # 8001cdc8 <ftable>
    80003d2e:	00003097          	auipc	ra,0x3
    80003d32:	b02080e7          	jalr	-1278(ra) # 80006830 <release>

  if(ff.type == FD_PIPE){
    80003d36:	4785                	li	a5,1
    80003d38:	04f90d63          	beq	s2,a5,80003d92 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d3c:	3979                	addiw	s2,s2,-2
    80003d3e:	4785                	li	a5,1
    80003d40:	0527e063          	bltu	a5,s2,80003d80 <fileclose+0xa8>
    begin_op();
    80003d44:	00000097          	auipc	ra,0x0
    80003d48:	ac8080e7          	jalr	-1336(ra) # 8000380c <begin_op>
    iput(ff.ip);
    80003d4c:	854e                	mv	a0,s3
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	2a6080e7          	jalr	678(ra) # 80002ff4 <iput>
    end_op();
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	b36080e7          	jalr	-1226(ra) # 8000388c <end_op>
    80003d5e:	a00d                	j	80003d80 <fileclose+0xa8>
    panic("fileclose");
    80003d60:	00005517          	auipc	a0,0x5
    80003d64:	8d850513          	addi	a0,a0,-1832 # 80008638 <syscalls+0x268>
    80003d68:	00002097          	auipc	ra,0x2
    80003d6c:	4c4080e7          	jalr	1220(ra) # 8000622c <panic>
    release(&ftable.lock);
    80003d70:	00019517          	auipc	a0,0x19
    80003d74:	05850513          	addi	a0,a0,88 # 8001cdc8 <ftable>
    80003d78:	00003097          	auipc	ra,0x3
    80003d7c:	ab8080e7          	jalr	-1352(ra) # 80006830 <release>
  }
}
    80003d80:	70e2                	ld	ra,56(sp)
    80003d82:	7442                	ld	s0,48(sp)
    80003d84:	74a2                	ld	s1,40(sp)
    80003d86:	7902                	ld	s2,32(sp)
    80003d88:	69e2                	ld	s3,24(sp)
    80003d8a:	6a42                	ld	s4,16(sp)
    80003d8c:	6aa2                	ld	s5,8(sp)
    80003d8e:	6121                	addi	sp,sp,64
    80003d90:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d92:	85d6                	mv	a1,s5
    80003d94:	8552                	mv	a0,s4
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	34c080e7          	jalr	844(ra) # 800040e2 <pipeclose>
    80003d9e:	b7cd                	j	80003d80 <fileclose+0xa8>

0000000080003da0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003da0:	715d                	addi	sp,sp,-80
    80003da2:	e486                	sd	ra,72(sp)
    80003da4:	e0a2                	sd	s0,64(sp)
    80003da6:	fc26                	sd	s1,56(sp)
    80003da8:	f84a                	sd	s2,48(sp)
    80003daa:	f44e                	sd	s3,40(sp)
    80003dac:	0880                	addi	s0,sp,80
    80003dae:	84aa                	mv	s1,a0
    80003db0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003db2:	ffffd097          	auipc	ra,0xffffd
    80003db6:	240080e7          	jalr	576(ra) # 80000ff2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003dba:	409c                	lw	a5,0(s1)
    80003dbc:	37f9                	addiw	a5,a5,-2
    80003dbe:	4705                	li	a4,1
    80003dc0:	04f76763          	bltu	a4,a5,80003e0e <filestat+0x6e>
    80003dc4:	892a                	mv	s2,a0
    ilock(f->ip);
    80003dc6:	6c88                	ld	a0,24(s1)
    80003dc8:	fffff097          	auipc	ra,0xfffff
    80003dcc:	072080e7          	jalr	114(ra) # 80002e3a <ilock>
    stati(f->ip, &st);
    80003dd0:	fb840593          	addi	a1,s0,-72
    80003dd4:	6c88                	ld	a0,24(s1)
    80003dd6:	fffff097          	auipc	ra,0xfffff
    80003dda:	2ee080e7          	jalr	750(ra) # 800030c4 <stati>
    iunlock(f->ip);
    80003dde:	6c88                	ld	a0,24(s1)
    80003de0:	fffff097          	auipc	ra,0xfffff
    80003de4:	11c080e7          	jalr	284(ra) # 80002efc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003de8:	46e1                	li	a3,24
    80003dea:	fb840613          	addi	a2,s0,-72
    80003dee:	85ce                	mv	a1,s3
    80003df0:	05893503          	ld	a0,88(s2)
    80003df4:	ffffd097          	auipc	ra,0xffffd
    80003df8:	ec0080e7          	jalr	-320(ra) # 80000cb4 <copyout>
    80003dfc:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003e00:	60a6                	ld	ra,72(sp)
    80003e02:	6406                	ld	s0,64(sp)
    80003e04:	74e2                	ld	s1,56(sp)
    80003e06:	7942                	ld	s2,48(sp)
    80003e08:	79a2                	ld	s3,40(sp)
    80003e0a:	6161                	addi	sp,sp,80
    80003e0c:	8082                	ret
  return -1;
    80003e0e:	557d                	li	a0,-1
    80003e10:	bfc5                	j	80003e00 <filestat+0x60>

0000000080003e12 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e12:	7179                	addi	sp,sp,-48
    80003e14:	f406                	sd	ra,40(sp)
    80003e16:	f022                	sd	s0,32(sp)
    80003e18:	ec26                	sd	s1,24(sp)
    80003e1a:	e84a                	sd	s2,16(sp)
    80003e1c:	e44e                	sd	s3,8(sp)
    80003e1e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e20:	00854783          	lbu	a5,8(a0)
    80003e24:	c3d5                	beqz	a5,80003ec8 <fileread+0xb6>
    80003e26:	84aa                	mv	s1,a0
    80003e28:	89ae                	mv	s3,a1
    80003e2a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e2c:	411c                	lw	a5,0(a0)
    80003e2e:	4705                	li	a4,1
    80003e30:	04e78963          	beq	a5,a4,80003e82 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e34:	470d                	li	a4,3
    80003e36:	04e78d63          	beq	a5,a4,80003e90 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e3a:	4709                	li	a4,2
    80003e3c:	06e79e63          	bne	a5,a4,80003eb8 <fileread+0xa6>
    ilock(f->ip);
    80003e40:	6d08                	ld	a0,24(a0)
    80003e42:	fffff097          	auipc	ra,0xfffff
    80003e46:	ff8080e7          	jalr	-8(ra) # 80002e3a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e4a:	874a                	mv	a4,s2
    80003e4c:	5094                	lw	a3,32(s1)
    80003e4e:	864e                	mv	a2,s3
    80003e50:	4585                	li	a1,1
    80003e52:	6c88                	ld	a0,24(s1)
    80003e54:	fffff097          	auipc	ra,0xfffff
    80003e58:	29a080e7          	jalr	666(ra) # 800030ee <readi>
    80003e5c:	892a                	mv	s2,a0
    80003e5e:	00a05563          	blez	a0,80003e68 <fileread+0x56>
      f->off += r;
    80003e62:	509c                	lw	a5,32(s1)
    80003e64:	9fa9                	addw	a5,a5,a0
    80003e66:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003e68:	6c88                	ld	a0,24(s1)
    80003e6a:	fffff097          	auipc	ra,0xfffff
    80003e6e:	092080e7          	jalr	146(ra) # 80002efc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e72:	854a                	mv	a0,s2
    80003e74:	70a2                	ld	ra,40(sp)
    80003e76:	7402                	ld	s0,32(sp)
    80003e78:	64e2                	ld	s1,24(sp)
    80003e7a:	6942                	ld	s2,16(sp)
    80003e7c:	69a2                	ld	s3,8(sp)
    80003e7e:	6145                	addi	sp,sp,48
    80003e80:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e82:	6908                	ld	a0,16(a0)
    80003e84:	00000097          	auipc	ra,0x0
    80003e88:	3d2080e7          	jalr	978(ra) # 80004256 <piperead>
    80003e8c:	892a                	mv	s2,a0
    80003e8e:	b7d5                	j	80003e72 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e90:	02451783          	lh	a5,36(a0)
    80003e94:	03079693          	slli	a3,a5,0x30
    80003e98:	92c1                	srli	a3,a3,0x30
    80003e9a:	4725                	li	a4,9
    80003e9c:	02d76863          	bltu	a4,a3,80003ecc <fileread+0xba>
    80003ea0:	0792                	slli	a5,a5,0x4
    80003ea2:	00019717          	auipc	a4,0x19
    80003ea6:	e8670713          	addi	a4,a4,-378 # 8001cd28 <devsw>
    80003eaa:	97ba                	add	a5,a5,a4
    80003eac:	639c                	ld	a5,0(a5)
    80003eae:	c38d                	beqz	a5,80003ed0 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003eb0:	4505                	li	a0,1
    80003eb2:	9782                	jalr	a5
    80003eb4:	892a                	mv	s2,a0
    80003eb6:	bf75                	j	80003e72 <fileread+0x60>
    panic("fileread");
    80003eb8:	00004517          	auipc	a0,0x4
    80003ebc:	79050513          	addi	a0,a0,1936 # 80008648 <syscalls+0x278>
    80003ec0:	00002097          	auipc	ra,0x2
    80003ec4:	36c080e7          	jalr	876(ra) # 8000622c <panic>
    return -1;
    80003ec8:	597d                	li	s2,-1
    80003eca:	b765                	j	80003e72 <fileread+0x60>
      return -1;
    80003ecc:	597d                	li	s2,-1
    80003ece:	b755                	j	80003e72 <fileread+0x60>
    80003ed0:	597d                	li	s2,-1
    80003ed2:	b745                	j	80003e72 <fileread+0x60>

0000000080003ed4 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003ed4:	715d                	addi	sp,sp,-80
    80003ed6:	e486                	sd	ra,72(sp)
    80003ed8:	e0a2                	sd	s0,64(sp)
    80003eda:	fc26                	sd	s1,56(sp)
    80003edc:	f84a                	sd	s2,48(sp)
    80003ede:	f44e                	sd	s3,40(sp)
    80003ee0:	f052                	sd	s4,32(sp)
    80003ee2:	ec56                	sd	s5,24(sp)
    80003ee4:	e85a                	sd	s6,16(sp)
    80003ee6:	e45e                	sd	s7,8(sp)
    80003ee8:	e062                	sd	s8,0(sp)
    80003eea:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003eec:	00954783          	lbu	a5,9(a0)
    80003ef0:	10078663          	beqz	a5,80003ffc <filewrite+0x128>
    80003ef4:	892a                	mv	s2,a0
    80003ef6:	8aae                	mv	s5,a1
    80003ef8:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003efa:	411c                	lw	a5,0(a0)
    80003efc:	4705                	li	a4,1
    80003efe:	02e78263          	beq	a5,a4,80003f22 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f02:	470d                	li	a4,3
    80003f04:	02e78663          	beq	a5,a4,80003f30 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f08:	4709                	li	a4,2
    80003f0a:	0ee79163          	bne	a5,a4,80003fec <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f0e:	0ac05d63          	blez	a2,80003fc8 <filewrite+0xf4>
    int i = 0;
    80003f12:	4981                	li	s3,0
    80003f14:	6b05                	lui	s6,0x1
    80003f16:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003f1a:	6b85                	lui	s7,0x1
    80003f1c:	c00b8b9b          	addiw	s7,s7,-1024
    80003f20:	a861                	j	80003fb8 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003f22:	6908                	ld	a0,16(a0)
    80003f24:	00000097          	auipc	ra,0x0
    80003f28:	238080e7          	jalr	568(ra) # 8000415c <pipewrite>
    80003f2c:	8a2a                	mv	s4,a0
    80003f2e:	a045                	j	80003fce <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f30:	02451783          	lh	a5,36(a0)
    80003f34:	03079693          	slli	a3,a5,0x30
    80003f38:	92c1                	srli	a3,a3,0x30
    80003f3a:	4725                	li	a4,9
    80003f3c:	0cd76263          	bltu	a4,a3,80004000 <filewrite+0x12c>
    80003f40:	0792                	slli	a5,a5,0x4
    80003f42:	00019717          	auipc	a4,0x19
    80003f46:	de670713          	addi	a4,a4,-538 # 8001cd28 <devsw>
    80003f4a:	97ba                	add	a5,a5,a4
    80003f4c:	679c                	ld	a5,8(a5)
    80003f4e:	cbdd                	beqz	a5,80004004 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003f50:	4505                	li	a0,1
    80003f52:	9782                	jalr	a5
    80003f54:	8a2a                	mv	s4,a0
    80003f56:	a8a5                	j	80003fce <filewrite+0xfa>
    80003f58:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003f5c:	00000097          	auipc	ra,0x0
    80003f60:	8b0080e7          	jalr	-1872(ra) # 8000380c <begin_op>
      ilock(f->ip);
    80003f64:	01893503          	ld	a0,24(s2)
    80003f68:	fffff097          	auipc	ra,0xfffff
    80003f6c:	ed2080e7          	jalr	-302(ra) # 80002e3a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f70:	8762                	mv	a4,s8
    80003f72:	02092683          	lw	a3,32(s2)
    80003f76:	01598633          	add	a2,s3,s5
    80003f7a:	4585                	li	a1,1
    80003f7c:	01893503          	ld	a0,24(s2)
    80003f80:	fffff097          	auipc	ra,0xfffff
    80003f84:	266080e7          	jalr	614(ra) # 800031e6 <writei>
    80003f88:	84aa                	mv	s1,a0
    80003f8a:	00a05763          	blez	a0,80003f98 <filewrite+0xc4>
        f->off += r;
    80003f8e:	02092783          	lw	a5,32(s2)
    80003f92:	9fa9                	addw	a5,a5,a0
    80003f94:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f98:	01893503          	ld	a0,24(s2)
    80003f9c:	fffff097          	auipc	ra,0xfffff
    80003fa0:	f60080e7          	jalr	-160(ra) # 80002efc <iunlock>
      end_op();
    80003fa4:	00000097          	auipc	ra,0x0
    80003fa8:	8e8080e7          	jalr	-1816(ra) # 8000388c <end_op>

      if(r != n1){
    80003fac:	009c1f63          	bne	s8,s1,80003fca <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003fb0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003fb4:	0149db63          	bge	s3,s4,80003fca <filewrite+0xf6>
      int n1 = n - i;
    80003fb8:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003fbc:	84be                	mv	s1,a5
    80003fbe:	2781                	sext.w	a5,a5
    80003fc0:	f8fb5ce3          	bge	s6,a5,80003f58 <filewrite+0x84>
    80003fc4:	84de                	mv	s1,s7
    80003fc6:	bf49                	j	80003f58 <filewrite+0x84>
    int i = 0;
    80003fc8:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003fca:	013a1f63          	bne	s4,s3,80003fe8 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003fce:	8552                	mv	a0,s4
    80003fd0:	60a6                	ld	ra,72(sp)
    80003fd2:	6406                	ld	s0,64(sp)
    80003fd4:	74e2                	ld	s1,56(sp)
    80003fd6:	7942                	ld	s2,48(sp)
    80003fd8:	79a2                	ld	s3,40(sp)
    80003fda:	7a02                	ld	s4,32(sp)
    80003fdc:	6ae2                	ld	s5,24(sp)
    80003fde:	6b42                	ld	s6,16(sp)
    80003fe0:	6ba2                	ld	s7,8(sp)
    80003fe2:	6c02                	ld	s8,0(sp)
    80003fe4:	6161                	addi	sp,sp,80
    80003fe6:	8082                	ret
    ret = (i == n ? n : -1);
    80003fe8:	5a7d                	li	s4,-1
    80003fea:	b7d5                	j	80003fce <filewrite+0xfa>
    panic("filewrite");
    80003fec:	00004517          	auipc	a0,0x4
    80003ff0:	66c50513          	addi	a0,a0,1644 # 80008658 <syscalls+0x288>
    80003ff4:	00002097          	auipc	ra,0x2
    80003ff8:	238080e7          	jalr	568(ra) # 8000622c <panic>
    return -1;
    80003ffc:	5a7d                	li	s4,-1
    80003ffe:	bfc1                	j	80003fce <filewrite+0xfa>
      return -1;
    80004000:	5a7d                	li	s4,-1
    80004002:	b7f1                	j	80003fce <filewrite+0xfa>
    80004004:	5a7d                	li	s4,-1
    80004006:	b7e1                	j	80003fce <filewrite+0xfa>

0000000080004008 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004008:	7179                	addi	sp,sp,-48
    8000400a:	f406                	sd	ra,40(sp)
    8000400c:	f022                	sd	s0,32(sp)
    8000400e:	ec26                	sd	s1,24(sp)
    80004010:	e84a                	sd	s2,16(sp)
    80004012:	e44e                	sd	s3,8(sp)
    80004014:	e052                	sd	s4,0(sp)
    80004016:	1800                	addi	s0,sp,48
    80004018:	84aa                	mv	s1,a0
    8000401a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000401c:	0005b023          	sd	zero,0(a1)
    80004020:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004024:	00000097          	auipc	ra,0x0
    80004028:	bf8080e7          	jalr	-1032(ra) # 80003c1c <filealloc>
    8000402c:	e088                	sd	a0,0(s1)
    8000402e:	c551                	beqz	a0,800040ba <pipealloc+0xb2>
    80004030:	00000097          	auipc	ra,0x0
    80004034:	bec080e7          	jalr	-1044(ra) # 80003c1c <filealloc>
    80004038:	00aa3023          	sd	a0,0(s4)
    8000403c:	c92d                	beqz	a0,800040ae <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000403e:	ffffc097          	auipc	ra,0xffffc
    80004042:	210080e7          	jalr	528(ra) # 8000024e <kalloc>
    80004046:	892a                	mv	s2,a0
    80004048:	c125                	beqz	a0,800040a8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000404a:	4985                	li	s3,1
    8000404c:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80004050:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80004054:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80004058:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    8000405c:	00004597          	auipc	a1,0x4
    80004060:	60c58593          	addi	a1,a1,1548 # 80008668 <syscalls+0x298>
    80004064:	00003097          	auipc	ra,0x3
    80004068:	878080e7          	jalr	-1928(ra) # 800068dc <initlock>
  (*f0)->type = FD_PIPE;
    8000406c:	609c                	ld	a5,0(s1)
    8000406e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004072:	609c                	ld	a5,0(s1)
    80004074:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004078:	609c                	ld	a5,0(s1)
    8000407a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000407e:	609c                	ld	a5,0(s1)
    80004080:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004084:	000a3783          	ld	a5,0(s4)
    80004088:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000408c:	000a3783          	ld	a5,0(s4)
    80004090:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004094:	000a3783          	ld	a5,0(s4)
    80004098:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000409c:	000a3783          	ld	a5,0(s4)
    800040a0:	0127b823          	sd	s2,16(a5)
  return 0;
    800040a4:	4501                	li	a0,0
    800040a6:	a025                	j	800040ce <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040a8:	6088                	ld	a0,0(s1)
    800040aa:	e501                	bnez	a0,800040b2 <pipealloc+0xaa>
    800040ac:	a039                	j	800040ba <pipealloc+0xb2>
    800040ae:	6088                	ld	a0,0(s1)
    800040b0:	c51d                	beqz	a0,800040de <pipealloc+0xd6>
    fileclose(*f0);
    800040b2:	00000097          	auipc	ra,0x0
    800040b6:	c26080e7          	jalr	-986(ra) # 80003cd8 <fileclose>
  if(*f1)
    800040ba:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800040be:	557d                	li	a0,-1
  if(*f1)
    800040c0:	c799                	beqz	a5,800040ce <pipealloc+0xc6>
    fileclose(*f1);
    800040c2:	853e                	mv	a0,a5
    800040c4:	00000097          	auipc	ra,0x0
    800040c8:	c14080e7          	jalr	-1004(ra) # 80003cd8 <fileclose>
  return -1;
    800040cc:	557d                	li	a0,-1
}
    800040ce:	70a2                	ld	ra,40(sp)
    800040d0:	7402                	ld	s0,32(sp)
    800040d2:	64e2                	ld	s1,24(sp)
    800040d4:	6942                	ld	s2,16(sp)
    800040d6:	69a2                	ld	s3,8(sp)
    800040d8:	6a02                	ld	s4,0(sp)
    800040da:	6145                	addi	sp,sp,48
    800040dc:	8082                	ret
  return -1;
    800040de:	557d                	li	a0,-1
    800040e0:	b7fd                	j	800040ce <pipealloc+0xc6>

00000000800040e2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800040e2:	1101                	addi	sp,sp,-32
    800040e4:	ec06                	sd	ra,24(sp)
    800040e6:	e822                	sd	s0,16(sp)
    800040e8:	e426                	sd	s1,8(sp)
    800040ea:	e04a                	sd	s2,0(sp)
    800040ec:	1000                	addi	s0,sp,32
    800040ee:	84aa                	mv	s1,a0
    800040f0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800040f2:	00002097          	auipc	ra,0x2
    800040f6:	66e080e7          	jalr	1646(ra) # 80006760 <acquire>
  if(writable){
    800040fa:	04090263          	beqz	s2,8000413e <pipeclose+0x5c>
    pi->writeopen = 0;
    800040fe:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80004102:	22048513          	addi	a0,s1,544
    80004106:	ffffd097          	auipc	ra,0xffffd
    8000410a:	734080e7          	jalr	1844(ra) # 8000183a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000410e:	2284b783          	ld	a5,552(s1)
    80004112:	ef9d                	bnez	a5,80004150 <pipeclose+0x6e>
    release(&pi->lock);
    80004114:	8526                	mv	a0,s1
    80004116:	00002097          	auipc	ra,0x2
    8000411a:	71a080e7          	jalr	1818(ra) # 80006830 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    8000411e:	8526                	mv	a0,s1
    80004120:	00002097          	auipc	ra,0x2
    80004124:	758080e7          	jalr	1880(ra) # 80006878 <freelock>
#endif    
    kfree((char*)pi);
    80004128:	8526                	mv	a0,s1
    8000412a:	ffffc097          	auipc	ra,0xffffc
    8000412e:	ef2080e7          	jalr	-270(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004132:	60e2                	ld	ra,24(sp)
    80004134:	6442                	ld	s0,16(sp)
    80004136:	64a2                	ld	s1,8(sp)
    80004138:	6902                	ld	s2,0(sp)
    8000413a:	6105                	addi	sp,sp,32
    8000413c:	8082                	ret
    pi->readopen = 0;
    8000413e:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80004142:	22448513          	addi	a0,s1,548
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	6f4080e7          	jalr	1780(ra) # 8000183a <wakeup>
    8000414e:	b7c1                	j	8000410e <pipeclose+0x2c>
    release(&pi->lock);
    80004150:	8526                	mv	a0,s1
    80004152:	00002097          	auipc	ra,0x2
    80004156:	6de080e7          	jalr	1758(ra) # 80006830 <release>
}
    8000415a:	bfe1                	j	80004132 <pipeclose+0x50>

000000008000415c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000415c:	7159                	addi	sp,sp,-112
    8000415e:	f486                	sd	ra,104(sp)
    80004160:	f0a2                	sd	s0,96(sp)
    80004162:	eca6                	sd	s1,88(sp)
    80004164:	e8ca                	sd	s2,80(sp)
    80004166:	e4ce                	sd	s3,72(sp)
    80004168:	e0d2                	sd	s4,64(sp)
    8000416a:	fc56                	sd	s5,56(sp)
    8000416c:	f85a                	sd	s6,48(sp)
    8000416e:	f45e                	sd	s7,40(sp)
    80004170:	f062                	sd	s8,32(sp)
    80004172:	ec66                	sd	s9,24(sp)
    80004174:	1880                	addi	s0,sp,112
    80004176:	84aa                	mv	s1,a0
    80004178:	8aae                	mv	s5,a1
    8000417a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000417c:	ffffd097          	auipc	ra,0xffffd
    80004180:	e76080e7          	jalr	-394(ra) # 80000ff2 <myproc>
    80004184:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004186:	8526                	mv	a0,s1
    80004188:	00002097          	auipc	ra,0x2
    8000418c:	5d8080e7          	jalr	1496(ra) # 80006760 <acquire>
  while(i < n){
    80004190:	0d405163          	blez	s4,80004252 <pipewrite+0xf6>
    80004194:	8ba6                	mv	s7,s1
  int i = 0;
    80004196:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004198:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000419a:	22048c93          	addi	s9,s1,544
      sleep(&pi->nwrite, &pi->lock);
    8000419e:	22448c13          	addi	s8,s1,548
    800041a2:	a08d                	j	80004204 <pipewrite+0xa8>
      release(&pi->lock);
    800041a4:	8526                	mv	a0,s1
    800041a6:	00002097          	auipc	ra,0x2
    800041aa:	68a080e7          	jalr	1674(ra) # 80006830 <release>
      return -1;
    800041ae:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041b0:	854a                	mv	a0,s2
    800041b2:	70a6                	ld	ra,104(sp)
    800041b4:	7406                	ld	s0,96(sp)
    800041b6:	64e6                	ld	s1,88(sp)
    800041b8:	6946                	ld	s2,80(sp)
    800041ba:	69a6                	ld	s3,72(sp)
    800041bc:	6a06                	ld	s4,64(sp)
    800041be:	7ae2                	ld	s5,56(sp)
    800041c0:	7b42                	ld	s6,48(sp)
    800041c2:	7ba2                	ld	s7,40(sp)
    800041c4:	7c02                	ld	s8,32(sp)
    800041c6:	6ce2                	ld	s9,24(sp)
    800041c8:	6165                	addi	sp,sp,112
    800041ca:	8082                	ret
      wakeup(&pi->nread);
    800041cc:	8566                	mv	a0,s9
    800041ce:	ffffd097          	auipc	ra,0xffffd
    800041d2:	66c080e7          	jalr	1644(ra) # 8000183a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800041d6:	85de                	mv	a1,s7
    800041d8:	8562                	mv	a0,s8
    800041da:	ffffd097          	auipc	ra,0xffffd
    800041de:	4d4080e7          	jalr	1236(ra) # 800016ae <sleep>
    800041e2:	a839                	j	80004200 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041e4:	2244a783          	lw	a5,548(s1)
    800041e8:	0017871b          	addiw	a4,a5,1
    800041ec:	22e4a223          	sw	a4,548(s1)
    800041f0:	1ff7f793          	andi	a5,a5,511
    800041f4:	97a6                	add	a5,a5,s1
    800041f6:	f9f44703          	lbu	a4,-97(s0)
    800041fa:	02e78023          	sb	a4,32(a5)
      i++;
    800041fe:	2905                	addiw	s2,s2,1
  while(i < n){
    80004200:	03495d63          	bge	s2,s4,8000423a <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004204:	2284a783          	lw	a5,552(s1)
    80004208:	dfd1                	beqz	a5,800041a4 <pipewrite+0x48>
    8000420a:	0309a783          	lw	a5,48(s3)
    8000420e:	fbd9                	bnez	a5,800041a4 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004210:	2204a783          	lw	a5,544(s1)
    80004214:	2244a703          	lw	a4,548(s1)
    80004218:	2007879b          	addiw	a5,a5,512
    8000421c:	faf708e3          	beq	a4,a5,800041cc <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004220:	4685                	li	a3,1
    80004222:	01590633          	add	a2,s2,s5
    80004226:	f9f40593          	addi	a1,s0,-97
    8000422a:	0589b503          	ld	a0,88(s3)
    8000422e:	ffffd097          	auipc	ra,0xffffd
    80004232:	b12080e7          	jalr	-1262(ra) # 80000d40 <copyin>
    80004236:	fb6517e3          	bne	a0,s6,800041e4 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000423a:	22048513          	addi	a0,s1,544
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	5fc080e7          	jalr	1532(ra) # 8000183a <wakeup>
  release(&pi->lock);
    80004246:	8526                	mv	a0,s1
    80004248:	00002097          	auipc	ra,0x2
    8000424c:	5e8080e7          	jalr	1512(ra) # 80006830 <release>
  return i;
    80004250:	b785                	j	800041b0 <pipewrite+0x54>
  int i = 0;
    80004252:	4901                	li	s2,0
    80004254:	b7dd                	j	8000423a <pipewrite+0xde>

0000000080004256 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004256:	715d                	addi	sp,sp,-80
    80004258:	e486                	sd	ra,72(sp)
    8000425a:	e0a2                	sd	s0,64(sp)
    8000425c:	fc26                	sd	s1,56(sp)
    8000425e:	f84a                	sd	s2,48(sp)
    80004260:	f44e                	sd	s3,40(sp)
    80004262:	f052                	sd	s4,32(sp)
    80004264:	ec56                	sd	s5,24(sp)
    80004266:	e85a                	sd	s6,16(sp)
    80004268:	0880                	addi	s0,sp,80
    8000426a:	84aa                	mv	s1,a0
    8000426c:	892e                	mv	s2,a1
    8000426e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004270:	ffffd097          	auipc	ra,0xffffd
    80004274:	d82080e7          	jalr	-638(ra) # 80000ff2 <myproc>
    80004278:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000427a:	8b26                	mv	s6,s1
    8000427c:	8526                	mv	a0,s1
    8000427e:	00002097          	auipc	ra,0x2
    80004282:	4e2080e7          	jalr	1250(ra) # 80006760 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004286:	2204a703          	lw	a4,544(s1)
    8000428a:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000428e:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004292:	02f71463          	bne	a4,a5,800042ba <piperead+0x64>
    80004296:	22c4a783          	lw	a5,556(s1)
    8000429a:	c385                	beqz	a5,800042ba <piperead+0x64>
    if(pr->killed){
    8000429c:	030a2783          	lw	a5,48(s4)
    800042a0:	ebc1                	bnez	a5,80004330 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042a2:	85da                	mv	a1,s6
    800042a4:	854e                	mv	a0,s3
    800042a6:	ffffd097          	auipc	ra,0xffffd
    800042aa:	408080e7          	jalr	1032(ra) # 800016ae <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042ae:	2204a703          	lw	a4,544(s1)
    800042b2:	2244a783          	lw	a5,548(s1)
    800042b6:	fef700e3          	beq	a4,a5,80004296 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042ba:	09505263          	blez	s5,8000433e <piperead+0xe8>
    800042be:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042c0:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800042c2:	2204a783          	lw	a5,544(s1)
    800042c6:	2244a703          	lw	a4,548(s1)
    800042ca:	02f70d63          	beq	a4,a5,80004304 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042ce:	0017871b          	addiw	a4,a5,1
    800042d2:	22e4a023          	sw	a4,544(s1)
    800042d6:	1ff7f793          	andi	a5,a5,511
    800042da:	97a6                	add	a5,a5,s1
    800042dc:	0207c783          	lbu	a5,32(a5)
    800042e0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042e4:	4685                	li	a3,1
    800042e6:	fbf40613          	addi	a2,s0,-65
    800042ea:	85ca                	mv	a1,s2
    800042ec:	058a3503          	ld	a0,88(s4)
    800042f0:	ffffd097          	auipc	ra,0xffffd
    800042f4:	9c4080e7          	jalr	-1596(ra) # 80000cb4 <copyout>
    800042f8:	01650663          	beq	a0,s6,80004304 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042fc:	2985                	addiw	s3,s3,1
    800042fe:	0905                	addi	s2,s2,1
    80004300:	fd3a91e3          	bne	s5,s3,800042c2 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004304:	22448513          	addi	a0,s1,548
    80004308:	ffffd097          	auipc	ra,0xffffd
    8000430c:	532080e7          	jalr	1330(ra) # 8000183a <wakeup>
  release(&pi->lock);
    80004310:	8526                	mv	a0,s1
    80004312:	00002097          	auipc	ra,0x2
    80004316:	51e080e7          	jalr	1310(ra) # 80006830 <release>
  return i;
}
    8000431a:	854e                	mv	a0,s3
    8000431c:	60a6                	ld	ra,72(sp)
    8000431e:	6406                	ld	s0,64(sp)
    80004320:	74e2                	ld	s1,56(sp)
    80004322:	7942                	ld	s2,48(sp)
    80004324:	79a2                	ld	s3,40(sp)
    80004326:	7a02                	ld	s4,32(sp)
    80004328:	6ae2                	ld	s5,24(sp)
    8000432a:	6b42                	ld	s6,16(sp)
    8000432c:	6161                	addi	sp,sp,80
    8000432e:	8082                	ret
      release(&pi->lock);
    80004330:	8526                	mv	a0,s1
    80004332:	00002097          	auipc	ra,0x2
    80004336:	4fe080e7          	jalr	1278(ra) # 80006830 <release>
      return -1;
    8000433a:	59fd                	li	s3,-1
    8000433c:	bff9                	j	8000431a <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000433e:	4981                	li	s3,0
    80004340:	b7d1                	j	80004304 <piperead+0xae>

0000000080004342 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004342:	df010113          	addi	sp,sp,-528
    80004346:	20113423          	sd	ra,520(sp)
    8000434a:	20813023          	sd	s0,512(sp)
    8000434e:	ffa6                	sd	s1,504(sp)
    80004350:	fbca                	sd	s2,496(sp)
    80004352:	f7ce                	sd	s3,488(sp)
    80004354:	f3d2                	sd	s4,480(sp)
    80004356:	efd6                	sd	s5,472(sp)
    80004358:	ebda                	sd	s6,464(sp)
    8000435a:	e7de                	sd	s7,456(sp)
    8000435c:	e3e2                	sd	s8,448(sp)
    8000435e:	ff66                	sd	s9,440(sp)
    80004360:	fb6a                	sd	s10,432(sp)
    80004362:	f76e                	sd	s11,424(sp)
    80004364:	0c00                	addi	s0,sp,528
    80004366:	84aa                	mv	s1,a0
    80004368:	dea43c23          	sd	a0,-520(s0)
    8000436c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004370:	ffffd097          	auipc	ra,0xffffd
    80004374:	c82080e7          	jalr	-894(ra) # 80000ff2 <myproc>
    80004378:	892a                	mv	s2,a0

  begin_op();
    8000437a:	fffff097          	auipc	ra,0xfffff
    8000437e:	492080e7          	jalr	1170(ra) # 8000380c <begin_op>

  if((ip = namei(path)) == 0){
    80004382:	8526                	mv	a0,s1
    80004384:	fffff097          	auipc	ra,0xfffff
    80004388:	26c080e7          	jalr	620(ra) # 800035f0 <namei>
    8000438c:	c92d                	beqz	a0,800043fe <exec+0xbc>
    8000438e:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004390:	fffff097          	auipc	ra,0xfffff
    80004394:	aaa080e7          	jalr	-1366(ra) # 80002e3a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004398:	04000713          	li	a4,64
    8000439c:	4681                	li	a3,0
    8000439e:	e5040613          	addi	a2,s0,-432
    800043a2:	4581                	li	a1,0
    800043a4:	8526                	mv	a0,s1
    800043a6:	fffff097          	auipc	ra,0xfffff
    800043aa:	d48080e7          	jalr	-696(ra) # 800030ee <readi>
    800043ae:	04000793          	li	a5,64
    800043b2:	00f51a63          	bne	a0,a5,800043c6 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800043b6:	e5042703          	lw	a4,-432(s0)
    800043ba:	464c47b7          	lui	a5,0x464c4
    800043be:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043c2:	04f70463          	beq	a4,a5,8000440a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800043c6:	8526                	mv	a0,s1
    800043c8:	fffff097          	auipc	ra,0xfffff
    800043cc:	cd4080e7          	jalr	-812(ra) # 8000309c <iunlockput>
    end_op();
    800043d0:	fffff097          	auipc	ra,0xfffff
    800043d4:	4bc080e7          	jalr	1212(ra) # 8000388c <end_op>
  }
  return -1;
    800043d8:	557d                	li	a0,-1
}
    800043da:	20813083          	ld	ra,520(sp)
    800043de:	20013403          	ld	s0,512(sp)
    800043e2:	74fe                	ld	s1,504(sp)
    800043e4:	795e                	ld	s2,496(sp)
    800043e6:	79be                	ld	s3,488(sp)
    800043e8:	7a1e                	ld	s4,480(sp)
    800043ea:	6afe                	ld	s5,472(sp)
    800043ec:	6b5e                	ld	s6,464(sp)
    800043ee:	6bbe                	ld	s7,456(sp)
    800043f0:	6c1e                	ld	s8,448(sp)
    800043f2:	7cfa                	ld	s9,440(sp)
    800043f4:	7d5a                	ld	s10,432(sp)
    800043f6:	7dba                	ld	s11,424(sp)
    800043f8:	21010113          	addi	sp,sp,528
    800043fc:	8082                	ret
    end_op();
    800043fe:	fffff097          	auipc	ra,0xfffff
    80004402:	48e080e7          	jalr	1166(ra) # 8000388c <end_op>
    return -1;
    80004406:	557d                	li	a0,-1
    80004408:	bfc9                	j	800043da <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000440a:	854a                	mv	a0,s2
    8000440c:	ffffd097          	auipc	ra,0xffffd
    80004410:	caa080e7          	jalr	-854(ra) # 800010b6 <proc_pagetable>
    80004414:	8baa                	mv	s7,a0
    80004416:	d945                	beqz	a0,800043c6 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004418:	e7042983          	lw	s3,-400(s0)
    8000441c:	e8845783          	lhu	a5,-376(s0)
    80004420:	c7ad                	beqz	a5,8000448a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004422:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004424:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004426:	6c85                	lui	s9,0x1
    80004428:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000442c:	def43823          	sd	a5,-528(s0)
    80004430:	a42d                	j	8000465a <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004432:	00004517          	auipc	a0,0x4
    80004436:	23e50513          	addi	a0,a0,574 # 80008670 <syscalls+0x2a0>
    8000443a:	00002097          	auipc	ra,0x2
    8000443e:	df2080e7          	jalr	-526(ra) # 8000622c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004442:	8756                	mv	a4,s5
    80004444:	012d86bb          	addw	a3,s11,s2
    80004448:	4581                	li	a1,0
    8000444a:	8526                	mv	a0,s1
    8000444c:	fffff097          	auipc	ra,0xfffff
    80004450:	ca2080e7          	jalr	-862(ra) # 800030ee <readi>
    80004454:	2501                	sext.w	a0,a0
    80004456:	1aaa9963          	bne	s5,a0,80004608 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    8000445a:	6785                	lui	a5,0x1
    8000445c:	0127893b          	addw	s2,a5,s2
    80004460:	77fd                	lui	a5,0xfffff
    80004462:	01478a3b          	addw	s4,a5,s4
    80004466:	1f897163          	bgeu	s2,s8,80004648 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000446a:	02091593          	slli	a1,s2,0x20
    8000446e:	9181                	srli	a1,a1,0x20
    80004470:	95ea                	add	a1,a1,s10
    80004472:	855e                	mv	a0,s7
    80004474:	ffffc097          	auipc	ra,0xffffc
    80004478:	23c080e7          	jalr	572(ra) # 800006b0 <walkaddr>
    8000447c:	862a                	mv	a2,a0
    if(pa == 0)
    8000447e:	d955                	beqz	a0,80004432 <exec+0xf0>
      n = PGSIZE;
    80004480:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004482:	fd9a70e3          	bgeu	s4,s9,80004442 <exec+0x100>
      n = sz - i;
    80004486:	8ad2                	mv	s5,s4
    80004488:	bf6d                	j	80004442 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000448a:	4901                	li	s2,0
  iunlockput(ip);
    8000448c:	8526                	mv	a0,s1
    8000448e:	fffff097          	auipc	ra,0xfffff
    80004492:	c0e080e7          	jalr	-1010(ra) # 8000309c <iunlockput>
  end_op();
    80004496:	fffff097          	auipc	ra,0xfffff
    8000449a:	3f6080e7          	jalr	1014(ra) # 8000388c <end_op>
  p = myproc();
    8000449e:	ffffd097          	auipc	ra,0xffffd
    800044a2:	b54080e7          	jalr	-1196(ra) # 80000ff2 <myproc>
    800044a6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800044a8:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800044ac:	6785                	lui	a5,0x1
    800044ae:	17fd                	addi	a5,a5,-1
    800044b0:	993e                	add	s2,s2,a5
    800044b2:	757d                	lui	a0,0xfffff
    800044b4:	00a977b3          	and	a5,s2,a0
    800044b8:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800044bc:	6609                	lui	a2,0x2
    800044be:	963e                	add	a2,a2,a5
    800044c0:	85be                	mv	a1,a5
    800044c2:	855e                	mv	a0,s7
    800044c4:	ffffc097          	auipc	ra,0xffffc
    800044c8:	5a0080e7          	jalr	1440(ra) # 80000a64 <uvmalloc>
    800044cc:	8b2a                	mv	s6,a0
  ip = 0;
    800044ce:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800044d0:	12050c63          	beqz	a0,80004608 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    800044d4:	75f9                	lui	a1,0xffffe
    800044d6:	95aa                	add	a1,a1,a0
    800044d8:	855e                	mv	a0,s7
    800044da:	ffffc097          	auipc	ra,0xffffc
    800044de:	7a8080e7          	jalr	1960(ra) # 80000c82 <uvmclear>
  stackbase = sp - PGSIZE;
    800044e2:	7c7d                	lui	s8,0xfffff
    800044e4:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800044e6:	e0043783          	ld	a5,-512(s0)
    800044ea:	6388                	ld	a0,0(a5)
    800044ec:	c535                	beqz	a0,80004558 <exec+0x216>
    800044ee:	e9040993          	addi	s3,s0,-368
    800044f2:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800044f6:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800044f8:	ffffc097          	auipc	ra,0xffffc
    800044fc:	f9e080e7          	jalr	-98(ra) # 80000496 <strlen>
    80004500:	2505                	addiw	a0,a0,1
    80004502:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004506:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000450a:	13896363          	bltu	s2,s8,80004630 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000450e:	e0043d83          	ld	s11,-512(s0)
    80004512:	000dba03          	ld	s4,0(s11) # 8000 <_entry-0x7fff8000>
    80004516:	8552                	mv	a0,s4
    80004518:	ffffc097          	auipc	ra,0xffffc
    8000451c:	f7e080e7          	jalr	-130(ra) # 80000496 <strlen>
    80004520:	0015069b          	addiw	a3,a0,1
    80004524:	8652                	mv	a2,s4
    80004526:	85ca                	mv	a1,s2
    80004528:	855e                	mv	a0,s7
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	78a080e7          	jalr	1930(ra) # 80000cb4 <copyout>
    80004532:	10054363          	bltz	a0,80004638 <exec+0x2f6>
    ustack[argc] = sp;
    80004536:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000453a:	0485                	addi	s1,s1,1
    8000453c:	008d8793          	addi	a5,s11,8
    80004540:	e0f43023          	sd	a5,-512(s0)
    80004544:	008db503          	ld	a0,8(s11)
    80004548:	c911                	beqz	a0,8000455c <exec+0x21a>
    if(argc >= MAXARG)
    8000454a:	09a1                	addi	s3,s3,8
    8000454c:	fb3c96e3          	bne	s9,s3,800044f8 <exec+0x1b6>
  sz = sz1;
    80004550:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004554:	4481                	li	s1,0
    80004556:	a84d                	j	80004608 <exec+0x2c6>
  sp = sz;
    80004558:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000455a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000455c:	00349793          	slli	a5,s1,0x3
    80004560:	f9040713          	addi	a4,s0,-112
    80004564:	97ba                	add	a5,a5,a4
    80004566:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000456a:	00148693          	addi	a3,s1,1
    8000456e:	068e                	slli	a3,a3,0x3
    80004570:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004574:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004578:	01897663          	bgeu	s2,s8,80004584 <exec+0x242>
  sz = sz1;
    8000457c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004580:	4481                	li	s1,0
    80004582:	a059                	j	80004608 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004584:	e9040613          	addi	a2,s0,-368
    80004588:	85ca                	mv	a1,s2
    8000458a:	855e                	mv	a0,s7
    8000458c:	ffffc097          	auipc	ra,0xffffc
    80004590:	728080e7          	jalr	1832(ra) # 80000cb4 <copyout>
    80004594:	0a054663          	bltz	a0,80004640 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004598:	060ab783          	ld	a5,96(s5)
    8000459c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045a0:	df843783          	ld	a5,-520(s0)
    800045a4:	0007c703          	lbu	a4,0(a5)
    800045a8:	cf11                	beqz	a4,800045c4 <exec+0x282>
    800045aa:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045ac:	02f00693          	li	a3,47
    800045b0:	a039                	j	800045be <exec+0x27c>
      last = s+1;
    800045b2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800045b6:	0785                	addi	a5,a5,1
    800045b8:	fff7c703          	lbu	a4,-1(a5)
    800045bc:	c701                	beqz	a4,800045c4 <exec+0x282>
    if(*s == '/')
    800045be:	fed71ce3          	bne	a4,a3,800045b6 <exec+0x274>
    800045c2:	bfc5                	j	800045b2 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800045c4:	4641                	li	a2,16
    800045c6:	df843583          	ld	a1,-520(s0)
    800045ca:	160a8513          	addi	a0,s5,352
    800045ce:	ffffc097          	auipc	ra,0xffffc
    800045d2:	e96080e7          	jalr	-362(ra) # 80000464 <safestrcpy>
  oldpagetable = p->pagetable;
    800045d6:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    800045da:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    800045de:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045e2:	060ab783          	ld	a5,96(s5)
    800045e6:	e6843703          	ld	a4,-408(s0)
    800045ea:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045ec:	060ab783          	ld	a5,96(s5)
    800045f0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045f4:	85ea                	mv	a1,s10
    800045f6:	ffffd097          	auipc	ra,0xffffd
    800045fa:	b5c080e7          	jalr	-1188(ra) # 80001152 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045fe:	0004851b          	sext.w	a0,s1
    80004602:	bbe1                	j	800043da <exec+0x98>
    80004604:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004608:	e0843583          	ld	a1,-504(s0)
    8000460c:	855e                	mv	a0,s7
    8000460e:	ffffd097          	auipc	ra,0xffffd
    80004612:	b44080e7          	jalr	-1212(ra) # 80001152 <proc_freepagetable>
  if(ip){
    80004616:	da0498e3          	bnez	s1,800043c6 <exec+0x84>
  return -1;
    8000461a:	557d                	li	a0,-1
    8000461c:	bb7d                	j	800043da <exec+0x98>
    8000461e:	e1243423          	sd	s2,-504(s0)
    80004622:	b7dd                	j	80004608 <exec+0x2c6>
    80004624:	e1243423          	sd	s2,-504(s0)
    80004628:	b7c5                	j	80004608 <exec+0x2c6>
    8000462a:	e1243423          	sd	s2,-504(s0)
    8000462e:	bfe9                	j	80004608 <exec+0x2c6>
  sz = sz1;
    80004630:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004634:	4481                	li	s1,0
    80004636:	bfc9                	j	80004608 <exec+0x2c6>
  sz = sz1;
    80004638:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000463c:	4481                	li	s1,0
    8000463e:	b7e9                	j	80004608 <exec+0x2c6>
  sz = sz1;
    80004640:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004644:	4481                	li	s1,0
    80004646:	b7c9                	j	80004608 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004648:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000464c:	2b05                	addiw	s6,s6,1
    8000464e:	0389899b          	addiw	s3,s3,56
    80004652:	e8845783          	lhu	a5,-376(s0)
    80004656:	e2fb5be3          	bge	s6,a5,8000448c <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000465a:	2981                	sext.w	s3,s3
    8000465c:	03800713          	li	a4,56
    80004660:	86ce                	mv	a3,s3
    80004662:	e1840613          	addi	a2,s0,-488
    80004666:	4581                	li	a1,0
    80004668:	8526                	mv	a0,s1
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	a84080e7          	jalr	-1404(ra) # 800030ee <readi>
    80004672:	03800793          	li	a5,56
    80004676:	f8f517e3          	bne	a0,a5,80004604 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000467a:	e1842783          	lw	a5,-488(s0)
    8000467e:	4705                	li	a4,1
    80004680:	fce796e3          	bne	a5,a4,8000464c <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004684:	e4043603          	ld	a2,-448(s0)
    80004688:	e3843783          	ld	a5,-456(s0)
    8000468c:	f8f669e3          	bltu	a2,a5,8000461e <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004690:	e2843783          	ld	a5,-472(s0)
    80004694:	963e                	add	a2,a2,a5
    80004696:	f8f667e3          	bltu	a2,a5,80004624 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000469a:	85ca                	mv	a1,s2
    8000469c:	855e                	mv	a0,s7
    8000469e:	ffffc097          	auipc	ra,0xffffc
    800046a2:	3c6080e7          	jalr	966(ra) # 80000a64 <uvmalloc>
    800046a6:	e0a43423          	sd	a0,-504(s0)
    800046aa:	d141                	beqz	a0,8000462a <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800046ac:	e2843d03          	ld	s10,-472(s0)
    800046b0:	df043783          	ld	a5,-528(s0)
    800046b4:	00fd77b3          	and	a5,s10,a5
    800046b8:	fba1                	bnez	a5,80004608 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800046ba:	e2042d83          	lw	s11,-480(s0)
    800046be:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800046c2:	f80c03e3          	beqz	s8,80004648 <exec+0x306>
    800046c6:	8a62                	mv	s4,s8
    800046c8:	4901                	li	s2,0
    800046ca:	b345                	j	8000446a <exec+0x128>

00000000800046cc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800046cc:	7179                	addi	sp,sp,-48
    800046ce:	f406                	sd	ra,40(sp)
    800046d0:	f022                	sd	s0,32(sp)
    800046d2:	ec26                	sd	s1,24(sp)
    800046d4:	e84a                	sd	s2,16(sp)
    800046d6:	1800                	addi	s0,sp,48
    800046d8:	892e                	mv	s2,a1
    800046da:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800046dc:	fdc40593          	addi	a1,s0,-36
    800046e0:	ffffe097          	auipc	ra,0xffffe
    800046e4:	9be080e7          	jalr	-1602(ra) # 8000209e <argint>
    800046e8:	04054063          	bltz	a0,80004728 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046ec:	fdc42703          	lw	a4,-36(s0)
    800046f0:	47bd                	li	a5,15
    800046f2:	02e7ed63          	bltu	a5,a4,8000472c <argfd+0x60>
    800046f6:	ffffd097          	auipc	ra,0xffffd
    800046fa:	8fc080e7          	jalr	-1796(ra) # 80000ff2 <myproc>
    800046fe:	fdc42703          	lw	a4,-36(s0)
    80004702:	01a70793          	addi	a5,a4,26
    80004706:	078e                	slli	a5,a5,0x3
    80004708:	953e                	add	a0,a0,a5
    8000470a:	651c                	ld	a5,8(a0)
    8000470c:	c395                	beqz	a5,80004730 <argfd+0x64>
    return -1;
  if(pfd)
    8000470e:	00090463          	beqz	s2,80004716 <argfd+0x4a>
    *pfd = fd;
    80004712:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004716:	4501                	li	a0,0
  if(pf)
    80004718:	c091                	beqz	s1,8000471c <argfd+0x50>
    *pf = f;
    8000471a:	e09c                	sd	a5,0(s1)
}
    8000471c:	70a2                	ld	ra,40(sp)
    8000471e:	7402                	ld	s0,32(sp)
    80004720:	64e2                	ld	s1,24(sp)
    80004722:	6942                	ld	s2,16(sp)
    80004724:	6145                	addi	sp,sp,48
    80004726:	8082                	ret
    return -1;
    80004728:	557d                	li	a0,-1
    8000472a:	bfcd                	j	8000471c <argfd+0x50>
    return -1;
    8000472c:	557d                	li	a0,-1
    8000472e:	b7fd                	j	8000471c <argfd+0x50>
    80004730:	557d                	li	a0,-1
    80004732:	b7ed                	j	8000471c <argfd+0x50>

0000000080004734 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004734:	1101                	addi	sp,sp,-32
    80004736:	ec06                	sd	ra,24(sp)
    80004738:	e822                	sd	s0,16(sp)
    8000473a:	e426                	sd	s1,8(sp)
    8000473c:	1000                	addi	s0,sp,32
    8000473e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004740:	ffffd097          	auipc	ra,0xffffd
    80004744:	8b2080e7          	jalr	-1870(ra) # 80000ff2 <myproc>
    80004748:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000474a:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd3e90>
    8000474e:	4501                	li	a0,0
    80004750:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004752:	6398                	ld	a4,0(a5)
    80004754:	cb19                	beqz	a4,8000476a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004756:	2505                	addiw	a0,a0,1
    80004758:	07a1                	addi	a5,a5,8
    8000475a:	fed51ce3          	bne	a0,a3,80004752 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000475e:	557d                	li	a0,-1
}
    80004760:	60e2                	ld	ra,24(sp)
    80004762:	6442                	ld	s0,16(sp)
    80004764:	64a2                	ld	s1,8(sp)
    80004766:	6105                	addi	sp,sp,32
    80004768:	8082                	ret
      p->ofile[fd] = f;
    8000476a:	01a50793          	addi	a5,a0,26
    8000476e:	078e                	slli	a5,a5,0x3
    80004770:	963e                	add	a2,a2,a5
    80004772:	e604                	sd	s1,8(a2)
      return fd;
    80004774:	b7f5                	j	80004760 <fdalloc+0x2c>

0000000080004776 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004776:	715d                	addi	sp,sp,-80
    80004778:	e486                	sd	ra,72(sp)
    8000477a:	e0a2                	sd	s0,64(sp)
    8000477c:	fc26                	sd	s1,56(sp)
    8000477e:	f84a                	sd	s2,48(sp)
    80004780:	f44e                	sd	s3,40(sp)
    80004782:	f052                	sd	s4,32(sp)
    80004784:	ec56                	sd	s5,24(sp)
    80004786:	0880                	addi	s0,sp,80
    80004788:	89ae                	mv	s3,a1
    8000478a:	8ab2                	mv	s5,a2
    8000478c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000478e:	fb040593          	addi	a1,s0,-80
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	e7c080e7          	jalr	-388(ra) # 8000360e <nameiparent>
    8000479a:	892a                	mv	s2,a0
    8000479c:	12050f63          	beqz	a0,800048da <create+0x164>
    return 0;

  ilock(dp);
    800047a0:	ffffe097          	auipc	ra,0xffffe
    800047a4:	69a080e7          	jalr	1690(ra) # 80002e3a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800047a8:	4601                	li	a2,0
    800047aa:	fb040593          	addi	a1,s0,-80
    800047ae:	854a                	mv	a0,s2
    800047b0:	fffff097          	auipc	ra,0xfffff
    800047b4:	b6e080e7          	jalr	-1170(ra) # 8000331e <dirlookup>
    800047b8:	84aa                	mv	s1,a0
    800047ba:	c921                	beqz	a0,8000480a <create+0x94>
    iunlockput(dp);
    800047bc:	854a                	mv	a0,s2
    800047be:	fffff097          	auipc	ra,0xfffff
    800047c2:	8de080e7          	jalr	-1826(ra) # 8000309c <iunlockput>
    ilock(ip);
    800047c6:	8526                	mv	a0,s1
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	672080e7          	jalr	1650(ra) # 80002e3a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800047d0:	2981                	sext.w	s3,s3
    800047d2:	4789                	li	a5,2
    800047d4:	02f99463          	bne	s3,a5,800047fc <create+0x86>
    800047d8:	04c4d783          	lhu	a5,76(s1)
    800047dc:	37f9                	addiw	a5,a5,-2
    800047de:	17c2                	slli	a5,a5,0x30
    800047e0:	93c1                	srli	a5,a5,0x30
    800047e2:	4705                	li	a4,1
    800047e4:	00f76c63          	bltu	a4,a5,800047fc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800047e8:	8526                	mv	a0,s1
    800047ea:	60a6                	ld	ra,72(sp)
    800047ec:	6406                	ld	s0,64(sp)
    800047ee:	74e2                	ld	s1,56(sp)
    800047f0:	7942                	ld	s2,48(sp)
    800047f2:	79a2                	ld	s3,40(sp)
    800047f4:	7a02                	ld	s4,32(sp)
    800047f6:	6ae2                	ld	s5,24(sp)
    800047f8:	6161                	addi	sp,sp,80
    800047fa:	8082                	ret
    iunlockput(ip);
    800047fc:	8526                	mv	a0,s1
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	89e080e7          	jalr	-1890(ra) # 8000309c <iunlockput>
    return 0;
    80004806:	4481                	li	s1,0
    80004808:	b7c5                	j	800047e8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000480a:	85ce                	mv	a1,s3
    8000480c:	00092503          	lw	a0,0(s2)
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	492080e7          	jalr	1170(ra) # 80002ca2 <ialloc>
    80004818:	84aa                	mv	s1,a0
    8000481a:	c529                	beqz	a0,80004864 <create+0xee>
  ilock(ip);
    8000481c:	ffffe097          	auipc	ra,0xffffe
    80004820:	61e080e7          	jalr	1566(ra) # 80002e3a <ilock>
  ip->major = major;
    80004824:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    80004828:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    8000482c:	4785                	li	a5,1
    8000482e:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004832:	8526                	mv	a0,s1
    80004834:	ffffe097          	auipc	ra,0xffffe
    80004838:	53c080e7          	jalr	1340(ra) # 80002d70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000483c:	2981                	sext.w	s3,s3
    8000483e:	4785                	li	a5,1
    80004840:	02f98a63          	beq	s3,a5,80004874 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80004844:	40d0                	lw	a2,4(s1)
    80004846:	fb040593          	addi	a1,s0,-80
    8000484a:	854a                	mv	a0,s2
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	ce2080e7          	jalr	-798(ra) # 8000352e <dirlink>
    80004854:	06054b63          	bltz	a0,800048ca <create+0x154>
  iunlockput(dp);
    80004858:	854a                	mv	a0,s2
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	842080e7          	jalr	-1982(ra) # 8000309c <iunlockput>
  return ip;
    80004862:	b759                	j	800047e8 <create+0x72>
    panic("create: ialloc");
    80004864:	00004517          	auipc	a0,0x4
    80004868:	e2c50513          	addi	a0,a0,-468 # 80008690 <syscalls+0x2c0>
    8000486c:	00002097          	auipc	ra,0x2
    80004870:	9c0080e7          	jalr	-1600(ra) # 8000622c <panic>
    dp->nlink++;  // for ".."
    80004874:	05295783          	lhu	a5,82(s2)
    80004878:	2785                	addiw	a5,a5,1
    8000487a:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    8000487e:	854a                	mv	a0,s2
    80004880:	ffffe097          	auipc	ra,0xffffe
    80004884:	4f0080e7          	jalr	1264(ra) # 80002d70 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004888:	40d0                	lw	a2,4(s1)
    8000488a:	00004597          	auipc	a1,0x4
    8000488e:	e1658593          	addi	a1,a1,-490 # 800086a0 <syscalls+0x2d0>
    80004892:	8526                	mv	a0,s1
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	c9a080e7          	jalr	-870(ra) # 8000352e <dirlink>
    8000489c:	00054f63          	bltz	a0,800048ba <create+0x144>
    800048a0:	00492603          	lw	a2,4(s2)
    800048a4:	00004597          	auipc	a1,0x4
    800048a8:	e0458593          	addi	a1,a1,-508 # 800086a8 <syscalls+0x2d8>
    800048ac:	8526                	mv	a0,s1
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	c80080e7          	jalr	-896(ra) # 8000352e <dirlink>
    800048b6:	f80557e3          	bgez	a0,80004844 <create+0xce>
      panic("create dots");
    800048ba:	00004517          	auipc	a0,0x4
    800048be:	df650513          	addi	a0,a0,-522 # 800086b0 <syscalls+0x2e0>
    800048c2:	00002097          	auipc	ra,0x2
    800048c6:	96a080e7          	jalr	-1686(ra) # 8000622c <panic>
    panic("create: dirlink");
    800048ca:	00004517          	auipc	a0,0x4
    800048ce:	df650513          	addi	a0,a0,-522 # 800086c0 <syscalls+0x2f0>
    800048d2:	00002097          	auipc	ra,0x2
    800048d6:	95a080e7          	jalr	-1702(ra) # 8000622c <panic>
    return 0;
    800048da:	84aa                	mv	s1,a0
    800048dc:	b731                	j	800047e8 <create+0x72>

00000000800048de <sys_dup>:
{
    800048de:	7179                	addi	sp,sp,-48
    800048e0:	f406                	sd	ra,40(sp)
    800048e2:	f022                	sd	s0,32(sp)
    800048e4:	ec26                	sd	s1,24(sp)
    800048e6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048e8:	fd840613          	addi	a2,s0,-40
    800048ec:	4581                	li	a1,0
    800048ee:	4501                	li	a0,0
    800048f0:	00000097          	auipc	ra,0x0
    800048f4:	ddc080e7          	jalr	-548(ra) # 800046cc <argfd>
    return -1;
    800048f8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048fa:	02054363          	bltz	a0,80004920 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800048fe:	fd843503          	ld	a0,-40(s0)
    80004902:	00000097          	auipc	ra,0x0
    80004906:	e32080e7          	jalr	-462(ra) # 80004734 <fdalloc>
    8000490a:	84aa                	mv	s1,a0
    return -1;
    8000490c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000490e:	00054963          	bltz	a0,80004920 <sys_dup+0x42>
  filedup(f);
    80004912:	fd843503          	ld	a0,-40(s0)
    80004916:	fffff097          	auipc	ra,0xfffff
    8000491a:	370080e7          	jalr	880(ra) # 80003c86 <filedup>
  return fd;
    8000491e:	87a6                	mv	a5,s1
}
    80004920:	853e                	mv	a0,a5
    80004922:	70a2                	ld	ra,40(sp)
    80004924:	7402                	ld	s0,32(sp)
    80004926:	64e2                	ld	s1,24(sp)
    80004928:	6145                	addi	sp,sp,48
    8000492a:	8082                	ret

000000008000492c <sys_read>:
{
    8000492c:	7179                	addi	sp,sp,-48
    8000492e:	f406                	sd	ra,40(sp)
    80004930:	f022                	sd	s0,32(sp)
    80004932:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004934:	fe840613          	addi	a2,s0,-24
    80004938:	4581                	li	a1,0
    8000493a:	4501                	li	a0,0
    8000493c:	00000097          	auipc	ra,0x0
    80004940:	d90080e7          	jalr	-624(ra) # 800046cc <argfd>
    return -1;
    80004944:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004946:	04054163          	bltz	a0,80004988 <sys_read+0x5c>
    8000494a:	fe440593          	addi	a1,s0,-28
    8000494e:	4509                	li	a0,2
    80004950:	ffffd097          	auipc	ra,0xffffd
    80004954:	74e080e7          	jalr	1870(ra) # 8000209e <argint>
    return -1;
    80004958:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000495a:	02054763          	bltz	a0,80004988 <sys_read+0x5c>
    8000495e:	fd840593          	addi	a1,s0,-40
    80004962:	4505                	li	a0,1
    80004964:	ffffd097          	auipc	ra,0xffffd
    80004968:	75c080e7          	jalr	1884(ra) # 800020c0 <argaddr>
    return -1;
    8000496c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000496e:	00054d63          	bltz	a0,80004988 <sys_read+0x5c>
  return fileread(f, p, n);
    80004972:	fe442603          	lw	a2,-28(s0)
    80004976:	fd843583          	ld	a1,-40(s0)
    8000497a:	fe843503          	ld	a0,-24(s0)
    8000497e:	fffff097          	auipc	ra,0xfffff
    80004982:	494080e7          	jalr	1172(ra) # 80003e12 <fileread>
    80004986:	87aa                	mv	a5,a0
}
    80004988:	853e                	mv	a0,a5
    8000498a:	70a2                	ld	ra,40(sp)
    8000498c:	7402                	ld	s0,32(sp)
    8000498e:	6145                	addi	sp,sp,48
    80004990:	8082                	ret

0000000080004992 <sys_write>:
{
    80004992:	7179                	addi	sp,sp,-48
    80004994:	f406                	sd	ra,40(sp)
    80004996:	f022                	sd	s0,32(sp)
    80004998:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000499a:	fe840613          	addi	a2,s0,-24
    8000499e:	4581                	li	a1,0
    800049a0:	4501                	li	a0,0
    800049a2:	00000097          	auipc	ra,0x0
    800049a6:	d2a080e7          	jalr	-726(ra) # 800046cc <argfd>
    return -1;
    800049aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049ac:	04054163          	bltz	a0,800049ee <sys_write+0x5c>
    800049b0:	fe440593          	addi	a1,s0,-28
    800049b4:	4509                	li	a0,2
    800049b6:	ffffd097          	auipc	ra,0xffffd
    800049ba:	6e8080e7          	jalr	1768(ra) # 8000209e <argint>
    return -1;
    800049be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049c0:	02054763          	bltz	a0,800049ee <sys_write+0x5c>
    800049c4:	fd840593          	addi	a1,s0,-40
    800049c8:	4505                	li	a0,1
    800049ca:	ffffd097          	auipc	ra,0xffffd
    800049ce:	6f6080e7          	jalr	1782(ra) # 800020c0 <argaddr>
    return -1;
    800049d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049d4:	00054d63          	bltz	a0,800049ee <sys_write+0x5c>
  return filewrite(f, p, n);
    800049d8:	fe442603          	lw	a2,-28(s0)
    800049dc:	fd843583          	ld	a1,-40(s0)
    800049e0:	fe843503          	ld	a0,-24(s0)
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	4f0080e7          	jalr	1264(ra) # 80003ed4 <filewrite>
    800049ec:	87aa                	mv	a5,a0
}
    800049ee:	853e                	mv	a0,a5
    800049f0:	70a2                	ld	ra,40(sp)
    800049f2:	7402                	ld	s0,32(sp)
    800049f4:	6145                	addi	sp,sp,48
    800049f6:	8082                	ret

00000000800049f8 <sys_close>:
{
    800049f8:	1101                	addi	sp,sp,-32
    800049fa:	ec06                	sd	ra,24(sp)
    800049fc:	e822                	sd	s0,16(sp)
    800049fe:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a00:	fe040613          	addi	a2,s0,-32
    80004a04:	fec40593          	addi	a1,s0,-20
    80004a08:	4501                	li	a0,0
    80004a0a:	00000097          	auipc	ra,0x0
    80004a0e:	cc2080e7          	jalr	-830(ra) # 800046cc <argfd>
    return -1;
    80004a12:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a14:	02054463          	bltz	a0,80004a3c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a18:	ffffc097          	auipc	ra,0xffffc
    80004a1c:	5da080e7          	jalr	1498(ra) # 80000ff2 <myproc>
    80004a20:	fec42783          	lw	a5,-20(s0)
    80004a24:	07e9                	addi	a5,a5,26
    80004a26:	078e                	slli	a5,a5,0x3
    80004a28:	97aa                	add	a5,a5,a0
    80004a2a:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    80004a2e:	fe043503          	ld	a0,-32(s0)
    80004a32:	fffff097          	auipc	ra,0xfffff
    80004a36:	2a6080e7          	jalr	678(ra) # 80003cd8 <fileclose>
  return 0;
    80004a3a:	4781                	li	a5,0
}
    80004a3c:	853e                	mv	a0,a5
    80004a3e:	60e2                	ld	ra,24(sp)
    80004a40:	6442                	ld	s0,16(sp)
    80004a42:	6105                	addi	sp,sp,32
    80004a44:	8082                	ret

0000000080004a46 <sys_fstat>:
{
    80004a46:	1101                	addi	sp,sp,-32
    80004a48:	ec06                	sd	ra,24(sp)
    80004a4a:	e822                	sd	s0,16(sp)
    80004a4c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a4e:	fe840613          	addi	a2,s0,-24
    80004a52:	4581                	li	a1,0
    80004a54:	4501                	li	a0,0
    80004a56:	00000097          	auipc	ra,0x0
    80004a5a:	c76080e7          	jalr	-906(ra) # 800046cc <argfd>
    return -1;
    80004a5e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a60:	02054563          	bltz	a0,80004a8a <sys_fstat+0x44>
    80004a64:	fe040593          	addi	a1,s0,-32
    80004a68:	4505                	li	a0,1
    80004a6a:	ffffd097          	auipc	ra,0xffffd
    80004a6e:	656080e7          	jalr	1622(ra) # 800020c0 <argaddr>
    return -1;
    80004a72:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a74:	00054b63          	bltz	a0,80004a8a <sys_fstat+0x44>
  return filestat(f, st);
    80004a78:	fe043583          	ld	a1,-32(s0)
    80004a7c:	fe843503          	ld	a0,-24(s0)
    80004a80:	fffff097          	auipc	ra,0xfffff
    80004a84:	320080e7          	jalr	800(ra) # 80003da0 <filestat>
    80004a88:	87aa                	mv	a5,a0
}
    80004a8a:	853e                	mv	a0,a5
    80004a8c:	60e2                	ld	ra,24(sp)
    80004a8e:	6442                	ld	s0,16(sp)
    80004a90:	6105                	addi	sp,sp,32
    80004a92:	8082                	ret

0000000080004a94 <sys_link>:
{
    80004a94:	7169                	addi	sp,sp,-304
    80004a96:	f606                	sd	ra,296(sp)
    80004a98:	f222                	sd	s0,288(sp)
    80004a9a:	ee26                	sd	s1,280(sp)
    80004a9c:	ea4a                	sd	s2,272(sp)
    80004a9e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004aa0:	08000613          	li	a2,128
    80004aa4:	ed040593          	addi	a1,s0,-304
    80004aa8:	4501                	li	a0,0
    80004aaa:	ffffd097          	auipc	ra,0xffffd
    80004aae:	638080e7          	jalr	1592(ra) # 800020e2 <argstr>
    return -1;
    80004ab2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ab4:	10054e63          	bltz	a0,80004bd0 <sys_link+0x13c>
    80004ab8:	08000613          	li	a2,128
    80004abc:	f5040593          	addi	a1,s0,-176
    80004ac0:	4505                	li	a0,1
    80004ac2:	ffffd097          	auipc	ra,0xffffd
    80004ac6:	620080e7          	jalr	1568(ra) # 800020e2 <argstr>
    return -1;
    80004aca:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004acc:	10054263          	bltz	a0,80004bd0 <sys_link+0x13c>
  begin_op();
    80004ad0:	fffff097          	auipc	ra,0xfffff
    80004ad4:	d3c080e7          	jalr	-708(ra) # 8000380c <begin_op>
  if((ip = namei(old)) == 0){
    80004ad8:	ed040513          	addi	a0,s0,-304
    80004adc:	fffff097          	auipc	ra,0xfffff
    80004ae0:	b14080e7          	jalr	-1260(ra) # 800035f0 <namei>
    80004ae4:	84aa                	mv	s1,a0
    80004ae6:	c551                	beqz	a0,80004b72 <sys_link+0xde>
  ilock(ip);
    80004ae8:	ffffe097          	auipc	ra,0xffffe
    80004aec:	352080e7          	jalr	850(ra) # 80002e3a <ilock>
  if(ip->type == T_DIR){
    80004af0:	04c49703          	lh	a4,76(s1)
    80004af4:	4785                	li	a5,1
    80004af6:	08f70463          	beq	a4,a5,80004b7e <sys_link+0xea>
  ip->nlink++;
    80004afa:	0524d783          	lhu	a5,82(s1)
    80004afe:	2785                	addiw	a5,a5,1
    80004b00:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004b04:	8526                	mv	a0,s1
    80004b06:	ffffe097          	auipc	ra,0xffffe
    80004b0a:	26a080e7          	jalr	618(ra) # 80002d70 <iupdate>
  iunlock(ip);
    80004b0e:	8526                	mv	a0,s1
    80004b10:	ffffe097          	auipc	ra,0xffffe
    80004b14:	3ec080e7          	jalr	1004(ra) # 80002efc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b18:	fd040593          	addi	a1,s0,-48
    80004b1c:	f5040513          	addi	a0,s0,-176
    80004b20:	fffff097          	auipc	ra,0xfffff
    80004b24:	aee080e7          	jalr	-1298(ra) # 8000360e <nameiparent>
    80004b28:	892a                	mv	s2,a0
    80004b2a:	c935                	beqz	a0,80004b9e <sys_link+0x10a>
  ilock(dp);
    80004b2c:	ffffe097          	auipc	ra,0xffffe
    80004b30:	30e080e7          	jalr	782(ra) # 80002e3a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b34:	00092703          	lw	a4,0(s2)
    80004b38:	409c                	lw	a5,0(s1)
    80004b3a:	04f71d63          	bne	a4,a5,80004b94 <sys_link+0x100>
    80004b3e:	40d0                	lw	a2,4(s1)
    80004b40:	fd040593          	addi	a1,s0,-48
    80004b44:	854a                	mv	a0,s2
    80004b46:	fffff097          	auipc	ra,0xfffff
    80004b4a:	9e8080e7          	jalr	-1560(ra) # 8000352e <dirlink>
    80004b4e:	04054363          	bltz	a0,80004b94 <sys_link+0x100>
  iunlockput(dp);
    80004b52:	854a                	mv	a0,s2
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	548080e7          	jalr	1352(ra) # 8000309c <iunlockput>
  iput(ip);
    80004b5c:	8526                	mv	a0,s1
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	496080e7          	jalr	1174(ra) # 80002ff4 <iput>
  end_op();
    80004b66:	fffff097          	auipc	ra,0xfffff
    80004b6a:	d26080e7          	jalr	-730(ra) # 8000388c <end_op>
  return 0;
    80004b6e:	4781                	li	a5,0
    80004b70:	a085                	j	80004bd0 <sys_link+0x13c>
    end_op();
    80004b72:	fffff097          	auipc	ra,0xfffff
    80004b76:	d1a080e7          	jalr	-742(ra) # 8000388c <end_op>
    return -1;
    80004b7a:	57fd                	li	a5,-1
    80004b7c:	a891                	j	80004bd0 <sys_link+0x13c>
    iunlockput(ip);
    80004b7e:	8526                	mv	a0,s1
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	51c080e7          	jalr	1308(ra) # 8000309c <iunlockput>
    end_op();
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	d04080e7          	jalr	-764(ra) # 8000388c <end_op>
    return -1;
    80004b90:	57fd                	li	a5,-1
    80004b92:	a83d                	j	80004bd0 <sys_link+0x13c>
    iunlockput(dp);
    80004b94:	854a                	mv	a0,s2
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	506080e7          	jalr	1286(ra) # 8000309c <iunlockput>
  ilock(ip);
    80004b9e:	8526                	mv	a0,s1
    80004ba0:	ffffe097          	auipc	ra,0xffffe
    80004ba4:	29a080e7          	jalr	666(ra) # 80002e3a <ilock>
  ip->nlink--;
    80004ba8:	0524d783          	lhu	a5,82(s1)
    80004bac:	37fd                	addiw	a5,a5,-1
    80004bae:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	ffffe097          	auipc	ra,0xffffe
    80004bb8:	1bc080e7          	jalr	444(ra) # 80002d70 <iupdate>
  iunlockput(ip);
    80004bbc:	8526                	mv	a0,s1
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	4de080e7          	jalr	1246(ra) # 8000309c <iunlockput>
  end_op();
    80004bc6:	fffff097          	auipc	ra,0xfffff
    80004bca:	cc6080e7          	jalr	-826(ra) # 8000388c <end_op>
  return -1;
    80004bce:	57fd                	li	a5,-1
}
    80004bd0:	853e                	mv	a0,a5
    80004bd2:	70b2                	ld	ra,296(sp)
    80004bd4:	7412                	ld	s0,288(sp)
    80004bd6:	64f2                	ld	s1,280(sp)
    80004bd8:	6952                	ld	s2,272(sp)
    80004bda:	6155                	addi	sp,sp,304
    80004bdc:	8082                	ret

0000000080004bde <sys_unlink>:
{
    80004bde:	7151                	addi	sp,sp,-240
    80004be0:	f586                	sd	ra,232(sp)
    80004be2:	f1a2                	sd	s0,224(sp)
    80004be4:	eda6                	sd	s1,216(sp)
    80004be6:	e9ca                	sd	s2,208(sp)
    80004be8:	e5ce                	sd	s3,200(sp)
    80004bea:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004bec:	08000613          	li	a2,128
    80004bf0:	f3040593          	addi	a1,s0,-208
    80004bf4:	4501                	li	a0,0
    80004bf6:	ffffd097          	auipc	ra,0xffffd
    80004bfa:	4ec080e7          	jalr	1260(ra) # 800020e2 <argstr>
    80004bfe:	18054163          	bltz	a0,80004d80 <sys_unlink+0x1a2>
  begin_op();
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	c0a080e7          	jalr	-1014(ra) # 8000380c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c0a:	fb040593          	addi	a1,s0,-80
    80004c0e:	f3040513          	addi	a0,s0,-208
    80004c12:	fffff097          	auipc	ra,0xfffff
    80004c16:	9fc080e7          	jalr	-1540(ra) # 8000360e <nameiparent>
    80004c1a:	84aa                	mv	s1,a0
    80004c1c:	c979                	beqz	a0,80004cf2 <sys_unlink+0x114>
  ilock(dp);
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	21c080e7          	jalr	540(ra) # 80002e3a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c26:	00004597          	auipc	a1,0x4
    80004c2a:	a7a58593          	addi	a1,a1,-1414 # 800086a0 <syscalls+0x2d0>
    80004c2e:	fb040513          	addi	a0,s0,-80
    80004c32:	ffffe097          	auipc	ra,0xffffe
    80004c36:	6d2080e7          	jalr	1746(ra) # 80003304 <namecmp>
    80004c3a:	14050a63          	beqz	a0,80004d8e <sys_unlink+0x1b0>
    80004c3e:	00004597          	auipc	a1,0x4
    80004c42:	a6a58593          	addi	a1,a1,-1430 # 800086a8 <syscalls+0x2d8>
    80004c46:	fb040513          	addi	a0,s0,-80
    80004c4a:	ffffe097          	auipc	ra,0xffffe
    80004c4e:	6ba080e7          	jalr	1722(ra) # 80003304 <namecmp>
    80004c52:	12050e63          	beqz	a0,80004d8e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c56:	f2c40613          	addi	a2,s0,-212
    80004c5a:	fb040593          	addi	a1,s0,-80
    80004c5e:	8526                	mv	a0,s1
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	6be080e7          	jalr	1726(ra) # 8000331e <dirlookup>
    80004c68:	892a                	mv	s2,a0
    80004c6a:	12050263          	beqz	a0,80004d8e <sys_unlink+0x1b0>
  ilock(ip);
    80004c6e:	ffffe097          	auipc	ra,0xffffe
    80004c72:	1cc080e7          	jalr	460(ra) # 80002e3a <ilock>
  if(ip->nlink < 1)
    80004c76:	05291783          	lh	a5,82(s2)
    80004c7a:	08f05263          	blez	a5,80004cfe <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c7e:	04c91703          	lh	a4,76(s2)
    80004c82:	4785                	li	a5,1
    80004c84:	08f70563          	beq	a4,a5,80004d0e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c88:	4641                	li	a2,16
    80004c8a:	4581                	li	a1,0
    80004c8c:	fc040513          	addi	a0,s0,-64
    80004c90:	ffffb097          	auipc	ra,0xffffb
    80004c94:	682080e7          	jalr	1666(ra) # 80000312 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c98:	4741                	li	a4,16
    80004c9a:	f2c42683          	lw	a3,-212(s0)
    80004c9e:	fc040613          	addi	a2,s0,-64
    80004ca2:	4581                	li	a1,0
    80004ca4:	8526                	mv	a0,s1
    80004ca6:	ffffe097          	auipc	ra,0xffffe
    80004caa:	540080e7          	jalr	1344(ra) # 800031e6 <writei>
    80004cae:	47c1                	li	a5,16
    80004cb0:	0af51563          	bne	a0,a5,80004d5a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004cb4:	04c91703          	lh	a4,76(s2)
    80004cb8:	4785                	li	a5,1
    80004cba:	0af70863          	beq	a4,a5,80004d6a <sys_unlink+0x18c>
  iunlockput(dp);
    80004cbe:	8526                	mv	a0,s1
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	3dc080e7          	jalr	988(ra) # 8000309c <iunlockput>
  ip->nlink--;
    80004cc8:	05295783          	lhu	a5,82(s2)
    80004ccc:	37fd                	addiw	a5,a5,-1
    80004cce:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004cd2:	854a                	mv	a0,s2
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	09c080e7          	jalr	156(ra) # 80002d70 <iupdate>
  iunlockput(ip);
    80004cdc:	854a                	mv	a0,s2
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	3be080e7          	jalr	958(ra) # 8000309c <iunlockput>
  end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	ba6080e7          	jalr	-1114(ra) # 8000388c <end_op>
  return 0;
    80004cee:	4501                	li	a0,0
    80004cf0:	a84d                	j	80004da2 <sys_unlink+0x1c4>
    end_op();
    80004cf2:	fffff097          	auipc	ra,0xfffff
    80004cf6:	b9a080e7          	jalr	-1126(ra) # 8000388c <end_op>
    return -1;
    80004cfa:	557d                	li	a0,-1
    80004cfc:	a05d                	j	80004da2 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004cfe:	00004517          	auipc	a0,0x4
    80004d02:	9d250513          	addi	a0,a0,-1582 # 800086d0 <syscalls+0x300>
    80004d06:	00001097          	auipc	ra,0x1
    80004d0a:	526080e7          	jalr	1318(ra) # 8000622c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d0e:	05492703          	lw	a4,84(s2)
    80004d12:	02000793          	li	a5,32
    80004d16:	f6e7f9e3          	bgeu	a5,a4,80004c88 <sys_unlink+0xaa>
    80004d1a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d1e:	4741                	li	a4,16
    80004d20:	86ce                	mv	a3,s3
    80004d22:	f1840613          	addi	a2,s0,-232
    80004d26:	4581                	li	a1,0
    80004d28:	854a                	mv	a0,s2
    80004d2a:	ffffe097          	auipc	ra,0xffffe
    80004d2e:	3c4080e7          	jalr	964(ra) # 800030ee <readi>
    80004d32:	47c1                	li	a5,16
    80004d34:	00f51b63          	bne	a0,a5,80004d4a <sys_unlink+0x16c>
    if(de.inum != 0)
    80004d38:	f1845783          	lhu	a5,-232(s0)
    80004d3c:	e7a1                	bnez	a5,80004d84 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d3e:	29c1                	addiw	s3,s3,16
    80004d40:	05492783          	lw	a5,84(s2)
    80004d44:	fcf9ede3          	bltu	s3,a5,80004d1e <sys_unlink+0x140>
    80004d48:	b781                	j	80004c88 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d4a:	00004517          	auipc	a0,0x4
    80004d4e:	99e50513          	addi	a0,a0,-1634 # 800086e8 <syscalls+0x318>
    80004d52:	00001097          	auipc	ra,0x1
    80004d56:	4da080e7          	jalr	1242(ra) # 8000622c <panic>
    panic("unlink: writei");
    80004d5a:	00004517          	auipc	a0,0x4
    80004d5e:	9a650513          	addi	a0,a0,-1626 # 80008700 <syscalls+0x330>
    80004d62:	00001097          	auipc	ra,0x1
    80004d66:	4ca080e7          	jalr	1226(ra) # 8000622c <panic>
    dp->nlink--;
    80004d6a:	0524d783          	lhu	a5,82(s1)
    80004d6e:	37fd                	addiw	a5,a5,-1
    80004d70:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004d74:	8526                	mv	a0,s1
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	ffa080e7          	jalr	-6(ra) # 80002d70 <iupdate>
    80004d7e:	b781                	j	80004cbe <sys_unlink+0xe0>
    return -1;
    80004d80:	557d                	li	a0,-1
    80004d82:	a005                	j	80004da2 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d84:	854a                	mv	a0,s2
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	316080e7          	jalr	790(ra) # 8000309c <iunlockput>
  iunlockput(dp);
    80004d8e:	8526                	mv	a0,s1
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	30c080e7          	jalr	780(ra) # 8000309c <iunlockput>
  end_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	af4080e7          	jalr	-1292(ra) # 8000388c <end_op>
  return -1;
    80004da0:	557d                	li	a0,-1
}
    80004da2:	70ae                	ld	ra,232(sp)
    80004da4:	740e                	ld	s0,224(sp)
    80004da6:	64ee                	ld	s1,216(sp)
    80004da8:	694e                	ld	s2,208(sp)
    80004daa:	69ae                	ld	s3,200(sp)
    80004dac:	616d                	addi	sp,sp,240
    80004dae:	8082                	ret

0000000080004db0 <sys_open>:

uint64
sys_open(void)
{
    80004db0:	7131                	addi	sp,sp,-192
    80004db2:	fd06                	sd	ra,184(sp)
    80004db4:	f922                	sd	s0,176(sp)
    80004db6:	f526                	sd	s1,168(sp)
    80004db8:	f14a                	sd	s2,160(sp)
    80004dba:	ed4e                	sd	s3,152(sp)
    80004dbc:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004dbe:	08000613          	li	a2,128
    80004dc2:	f5040593          	addi	a1,s0,-176
    80004dc6:	4501                	li	a0,0
    80004dc8:	ffffd097          	auipc	ra,0xffffd
    80004dcc:	31a080e7          	jalr	794(ra) # 800020e2 <argstr>
    return -1;
    80004dd0:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004dd2:	0c054163          	bltz	a0,80004e94 <sys_open+0xe4>
    80004dd6:	f4c40593          	addi	a1,s0,-180
    80004dda:	4505                	li	a0,1
    80004ddc:	ffffd097          	auipc	ra,0xffffd
    80004de0:	2c2080e7          	jalr	706(ra) # 8000209e <argint>
    80004de4:	0a054863          	bltz	a0,80004e94 <sys_open+0xe4>

  begin_op();
    80004de8:	fffff097          	auipc	ra,0xfffff
    80004dec:	a24080e7          	jalr	-1500(ra) # 8000380c <begin_op>

  if(omode & O_CREATE){
    80004df0:	f4c42783          	lw	a5,-180(s0)
    80004df4:	2007f793          	andi	a5,a5,512
    80004df8:	cbdd                	beqz	a5,80004eae <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004dfa:	4681                	li	a3,0
    80004dfc:	4601                	li	a2,0
    80004dfe:	4589                	li	a1,2
    80004e00:	f5040513          	addi	a0,s0,-176
    80004e04:	00000097          	auipc	ra,0x0
    80004e08:	972080e7          	jalr	-1678(ra) # 80004776 <create>
    80004e0c:	892a                	mv	s2,a0
    if(ip == 0){
    80004e0e:	c959                	beqz	a0,80004ea4 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e10:	04c91703          	lh	a4,76(s2)
    80004e14:	478d                	li	a5,3
    80004e16:	00f71763          	bne	a4,a5,80004e24 <sys_open+0x74>
    80004e1a:	04e95703          	lhu	a4,78(s2)
    80004e1e:	47a5                	li	a5,9
    80004e20:	0ce7ec63          	bltu	a5,a4,80004ef8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e24:	fffff097          	auipc	ra,0xfffff
    80004e28:	df8080e7          	jalr	-520(ra) # 80003c1c <filealloc>
    80004e2c:	89aa                	mv	s3,a0
    80004e2e:	10050263          	beqz	a0,80004f32 <sys_open+0x182>
    80004e32:	00000097          	auipc	ra,0x0
    80004e36:	902080e7          	jalr	-1790(ra) # 80004734 <fdalloc>
    80004e3a:	84aa                	mv	s1,a0
    80004e3c:	0e054663          	bltz	a0,80004f28 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e40:	04c91703          	lh	a4,76(s2)
    80004e44:	478d                	li	a5,3
    80004e46:	0cf70463          	beq	a4,a5,80004f0e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e4a:	4789                	li	a5,2
    80004e4c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e50:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e54:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e58:	f4c42783          	lw	a5,-180(s0)
    80004e5c:	0017c713          	xori	a4,a5,1
    80004e60:	8b05                	andi	a4,a4,1
    80004e62:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e66:	0037f713          	andi	a4,a5,3
    80004e6a:	00e03733          	snez	a4,a4
    80004e6e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e72:	4007f793          	andi	a5,a5,1024
    80004e76:	c791                	beqz	a5,80004e82 <sys_open+0xd2>
    80004e78:	04c91703          	lh	a4,76(s2)
    80004e7c:	4789                	li	a5,2
    80004e7e:	08f70f63          	beq	a4,a5,80004f1c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e82:	854a                	mv	a0,s2
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	078080e7          	jalr	120(ra) # 80002efc <iunlock>
  end_op();
    80004e8c:	fffff097          	auipc	ra,0xfffff
    80004e90:	a00080e7          	jalr	-1536(ra) # 8000388c <end_op>

  return fd;
}
    80004e94:	8526                	mv	a0,s1
    80004e96:	70ea                	ld	ra,184(sp)
    80004e98:	744a                	ld	s0,176(sp)
    80004e9a:	74aa                	ld	s1,168(sp)
    80004e9c:	790a                	ld	s2,160(sp)
    80004e9e:	69ea                	ld	s3,152(sp)
    80004ea0:	6129                	addi	sp,sp,192
    80004ea2:	8082                	ret
      end_op();
    80004ea4:	fffff097          	auipc	ra,0xfffff
    80004ea8:	9e8080e7          	jalr	-1560(ra) # 8000388c <end_op>
      return -1;
    80004eac:	b7e5                	j	80004e94 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004eae:	f5040513          	addi	a0,s0,-176
    80004eb2:	ffffe097          	auipc	ra,0xffffe
    80004eb6:	73e080e7          	jalr	1854(ra) # 800035f0 <namei>
    80004eba:	892a                	mv	s2,a0
    80004ebc:	c905                	beqz	a0,80004eec <sys_open+0x13c>
    ilock(ip);
    80004ebe:	ffffe097          	auipc	ra,0xffffe
    80004ec2:	f7c080e7          	jalr	-132(ra) # 80002e3a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ec6:	04c91703          	lh	a4,76(s2)
    80004eca:	4785                	li	a5,1
    80004ecc:	f4f712e3          	bne	a4,a5,80004e10 <sys_open+0x60>
    80004ed0:	f4c42783          	lw	a5,-180(s0)
    80004ed4:	dba1                	beqz	a5,80004e24 <sys_open+0x74>
      iunlockput(ip);
    80004ed6:	854a                	mv	a0,s2
    80004ed8:	ffffe097          	auipc	ra,0xffffe
    80004edc:	1c4080e7          	jalr	452(ra) # 8000309c <iunlockput>
      end_op();
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	9ac080e7          	jalr	-1620(ra) # 8000388c <end_op>
      return -1;
    80004ee8:	54fd                	li	s1,-1
    80004eea:	b76d                	j	80004e94 <sys_open+0xe4>
      end_op();
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	9a0080e7          	jalr	-1632(ra) # 8000388c <end_op>
      return -1;
    80004ef4:	54fd                	li	s1,-1
    80004ef6:	bf79                	j	80004e94 <sys_open+0xe4>
    iunlockput(ip);
    80004ef8:	854a                	mv	a0,s2
    80004efa:	ffffe097          	auipc	ra,0xffffe
    80004efe:	1a2080e7          	jalr	418(ra) # 8000309c <iunlockput>
    end_op();
    80004f02:	fffff097          	auipc	ra,0xfffff
    80004f06:	98a080e7          	jalr	-1654(ra) # 8000388c <end_op>
    return -1;
    80004f0a:	54fd                	li	s1,-1
    80004f0c:	b761                	j	80004e94 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004f0e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f12:	04e91783          	lh	a5,78(s2)
    80004f16:	02f99223          	sh	a5,36(s3)
    80004f1a:	bf2d                	j	80004e54 <sys_open+0xa4>
    itrunc(ip);
    80004f1c:	854a                	mv	a0,s2
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	02a080e7          	jalr	42(ra) # 80002f48 <itrunc>
    80004f26:	bfb1                	j	80004e82 <sys_open+0xd2>
      fileclose(f);
    80004f28:	854e                	mv	a0,s3
    80004f2a:	fffff097          	auipc	ra,0xfffff
    80004f2e:	dae080e7          	jalr	-594(ra) # 80003cd8 <fileclose>
    iunlockput(ip);
    80004f32:	854a                	mv	a0,s2
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	168080e7          	jalr	360(ra) # 8000309c <iunlockput>
    end_op();
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	950080e7          	jalr	-1712(ra) # 8000388c <end_op>
    return -1;
    80004f44:	54fd                	li	s1,-1
    80004f46:	b7b9                	j	80004e94 <sys_open+0xe4>

0000000080004f48 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f48:	7175                	addi	sp,sp,-144
    80004f4a:	e506                	sd	ra,136(sp)
    80004f4c:	e122                	sd	s0,128(sp)
    80004f4e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f50:	fffff097          	auipc	ra,0xfffff
    80004f54:	8bc080e7          	jalr	-1860(ra) # 8000380c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f58:	08000613          	li	a2,128
    80004f5c:	f7040593          	addi	a1,s0,-144
    80004f60:	4501                	li	a0,0
    80004f62:	ffffd097          	auipc	ra,0xffffd
    80004f66:	180080e7          	jalr	384(ra) # 800020e2 <argstr>
    80004f6a:	02054963          	bltz	a0,80004f9c <sys_mkdir+0x54>
    80004f6e:	4681                	li	a3,0
    80004f70:	4601                	li	a2,0
    80004f72:	4585                	li	a1,1
    80004f74:	f7040513          	addi	a0,s0,-144
    80004f78:	fffff097          	auipc	ra,0xfffff
    80004f7c:	7fe080e7          	jalr	2046(ra) # 80004776 <create>
    80004f80:	cd11                	beqz	a0,80004f9c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f82:	ffffe097          	auipc	ra,0xffffe
    80004f86:	11a080e7          	jalr	282(ra) # 8000309c <iunlockput>
  end_op();
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	902080e7          	jalr	-1790(ra) # 8000388c <end_op>
  return 0;
    80004f92:	4501                	li	a0,0
}
    80004f94:	60aa                	ld	ra,136(sp)
    80004f96:	640a                	ld	s0,128(sp)
    80004f98:	6149                	addi	sp,sp,144
    80004f9a:	8082                	ret
    end_op();
    80004f9c:	fffff097          	auipc	ra,0xfffff
    80004fa0:	8f0080e7          	jalr	-1808(ra) # 8000388c <end_op>
    return -1;
    80004fa4:	557d                	li	a0,-1
    80004fa6:	b7fd                	j	80004f94 <sys_mkdir+0x4c>

0000000080004fa8 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004fa8:	7135                	addi	sp,sp,-160
    80004faa:	ed06                	sd	ra,152(sp)
    80004fac:	e922                	sd	s0,144(sp)
    80004fae:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fb0:	fffff097          	auipc	ra,0xfffff
    80004fb4:	85c080e7          	jalr	-1956(ra) # 8000380c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fb8:	08000613          	li	a2,128
    80004fbc:	f7040593          	addi	a1,s0,-144
    80004fc0:	4501                	li	a0,0
    80004fc2:	ffffd097          	auipc	ra,0xffffd
    80004fc6:	120080e7          	jalr	288(ra) # 800020e2 <argstr>
    80004fca:	04054a63          	bltz	a0,8000501e <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004fce:	f6c40593          	addi	a1,s0,-148
    80004fd2:	4505                	li	a0,1
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	0ca080e7          	jalr	202(ra) # 8000209e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fdc:	04054163          	bltz	a0,8000501e <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004fe0:	f6840593          	addi	a1,s0,-152
    80004fe4:	4509                	li	a0,2
    80004fe6:	ffffd097          	auipc	ra,0xffffd
    80004fea:	0b8080e7          	jalr	184(ra) # 8000209e <argint>
     argint(1, &major) < 0 ||
    80004fee:	02054863          	bltz	a0,8000501e <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ff2:	f6841683          	lh	a3,-152(s0)
    80004ff6:	f6c41603          	lh	a2,-148(s0)
    80004ffa:	458d                	li	a1,3
    80004ffc:	f7040513          	addi	a0,s0,-144
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	776080e7          	jalr	1910(ra) # 80004776 <create>
     argint(2, &minor) < 0 ||
    80005008:	c919                	beqz	a0,8000501e <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000500a:	ffffe097          	auipc	ra,0xffffe
    8000500e:	092080e7          	jalr	146(ra) # 8000309c <iunlockput>
  end_op();
    80005012:	fffff097          	auipc	ra,0xfffff
    80005016:	87a080e7          	jalr	-1926(ra) # 8000388c <end_op>
  return 0;
    8000501a:	4501                	li	a0,0
    8000501c:	a031                	j	80005028 <sys_mknod+0x80>
    end_op();
    8000501e:	fffff097          	auipc	ra,0xfffff
    80005022:	86e080e7          	jalr	-1938(ra) # 8000388c <end_op>
    return -1;
    80005026:	557d                	li	a0,-1
}
    80005028:	60ea                	ld	ra,152(sp)
    8000502a:	644a                	ld	s0,144(sp)
    8000502c:	610d                	addi	sp,sp,160
    8000502e:	8082                	ret

0000000080005030 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005030:	7135                	addi	sp,sp,-160
    80005032:	ed06                	sd	ra,152(sp)
    80005034:	e922                	sd	s0,144(sp)
    80005036:	e526                	sd	s1,136(sp)
    80005038:	e14a                	sd	s2,128(sp)
    8000503a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000503c:	ffffc097          	auipc	ra,0xffffc
    80005040:	fb6080e7          	jalr	-74(ra) # 80000ff2 <myproc>
    80005044:	892a                	mv	s2,a0
  
  begin_op();
    80005046:	ffffe097          	auipc	ra,0xffffe
    8000504a:	7c6080e7          	jalr	1990(ra) # 8000380c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000504e:	08000613          	li	a2,128
    80005052:	f6040593          	addi	a1,s0,-160
    80005056:	4501                	li	a0,0
    80005058:	ffffd097          	auipc	ra,0xffffd
    8000505c:	08a080e7          	jalr	138(ra) # 800020e2 <argstr>
    80005060:	04054b63          	bltz	a0,800050b6 <sys_chdir+0x86>
    80005064:	f6040513          	addi	a0,s0,-160
    80005068:	ffffe097          	auipc	ra,0xffffe
    8000506c:	588080e7          	jalr	1416(ra) # 800035f0 <namei>
    80005070:	84aa                	mv	s1,a0
    80005072:	c131                	beqz	a0,800050b6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005074:	ffffe097          	auipc	ra,0xffffe
    80005078:	dc6080e7          	jalr	-570(ra) # 80002e3a <ilock>
  if(ip->type != T_DIR){
    8000507c:	04c49703          	lh	a4,76(s1)
    80005080:	4785                	li	a5,1
    80005082:	04f71063          	bne	a4,a5,800050c2 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005086:	8526                	mv	a0,s1
    80005088:	ffffe097          	auipc	ra,0xffffe
    8000508c:	e74080e7          	jalr	-396(ra) # 80002efc <iunlock>
  iput(p->cwd);
    80005090:	15893503          	ld	a0,344(s2)
    80005094:	ffffe097          	auipc	ra,0xffffe
    80005098:	f60080e7          	jalr	-160(ra) # 80002ff4 <iput>
  end_op();
    8000509c:	ffffe097          	auipc	ra,0xffffe
    800050a0:	7f0080e7          	jalr	2032(ra) # 8000388c <end_op>
  p->cwd = ip;
    800050a4:	14993c23          	sd	s1,344(s2)
  return 0;
    800050a8:	4501                	li	a0,0
}
    800050aa:	60ea                	ld	ra,152(sp)
    800050ac:	644a                	ld	s0,144(sp)
    800050ae:	64aa                	ld	s1,136(sp)
    800050b0:	690a                	ld	s2,128(sp)
    800050b2:	610d                	addi	sp,sp,160
    800050b4:	8082                	ret
    end_op();
    800050b6:	ffffe097          	auipc	ra,0xffffe
    800050ba:	7d6080e7          	jalr	2006(ra) # 8000388c <end_op>
    return -1;
    800050be:	557d                	li	a0,-1
    800050c0:	b7ed                	j	800050aa <sys_chdir+0x7a>
    iunlockput(ip);
    800050c2:	8526                	mv	a0,s1
    800050c4:	ffffe097          	auipc	ra,0xffffe
    800050c8:	fd8080e7          	jalr	-40(ra) # 8000309c <iunlockput>
    end_op();
    800050cc:	ffffe097          	auipc	ra,0xffffe
    800050d0:	7c0080e7          	jalr	1984(ra) # 8000388c <end_op>
    return -1;
    800050d4:	557d                	li	a0,-1
    800050d6:	bfd1                	j	800050aa <sys_chdir+0x7a>

00000000800050d8 <sys_exec>:

uint64
sys_exec(void)
{
    800050d8:	7145                	addi	sp,sp,-464
    800050da:	e786                	sd	ra,456(sp)
    800050dc:	e3a2                	sd	s0,448(sp)
    800050de:	ff26                	sd	s1,440(sp)
    800050e0:	fb4a                	sd	s2,432(sp)
    800050e2:	f74e                	sd	s3,424(sp)
    800050e4:	f352                	sd	s4,416(sp)
    800050e6:	ef56                	sd	s5,408(sp)
    800050e8:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050ea:	08000613          	li	a2,128
    800050ee:	f4040593          	addi	a1,s0,-192
    800050f2:	4501                	li	a0,0
    800050f4:	ffffd097          	auipc	ra,0xffffd
    800050f8:	fee080e7          	jalr	-18(ra) # 800020e2 <argstr>
    return -1;
    800050fc:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050fe:	0c054a63          	bltz	a0,800051d2 <sys_exec+0xfa>
    80005102:	e3840593          	addi	a1,s0,-456
    80005106:	4505                	li	a0,1
    80005108:	ffffd097          	auipc	ra,0xffffd
    8000510c:	fb8080e7          	jalr	-72(ra) # 800020c0 <argaddr>
    80005110:	0c054163          	bltz	a0,800051d2 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005114:	10000613          	li	a2,256
    80005118:	4581                	li	a1,0
    8000511a:	e4040513          	addi	a0,s0,-448
    8000511e:	ffffb097          	auipc	ra,0xffffb
    80005122:	1f4080e7          	jalr	500(ra) # 80000312 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005126:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000512a:	89a6                	mv	s3,s1
    8000512c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000512e:	02000a13          	li	s4,32
    80005132:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005136:	00391513          	slli	a0,s2,0x3
    8000513a:	e3040593          	addi	a1,s0,-464
    8000513e:	e3843783          	ld	a5,-456(s0)
    80005142:	953e                	add	a0,a0,a5
    80005144:	ffffd097          	auipc	ra,0xffffd
    80005148:	ec0080e7          	jalr	-320(ra) # 80002004 <fetchaddr>
    8000514c:	02054a63          	bltz	a0,80005180 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005150:	e3043783          	ld	a5,-464(s0)
    80005154:	c3b9                	beqz	a5,8000519a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005156:	ffffb097          	auipc	ra,0xffffb
    8000515a:	0f8080e7          	jalr	248(ra) # 8000024e <kalloc>
    8000515e:	85aa                	mv	a1,a0
    80005160:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005164:	cd11                	beqz	a0,80005180 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005166:	6605                	lui	a2,0x1
    80005168:	e3043503          	ld	a0,-464(s0)
    8000516c:	ffffd097          	auipc	ra,0xffffd
    80005170:	eea080e7          	jalr	-278(ra) # 80002056 <fetchstr>
    80005174:	00054663          	bltz	a0,80005180 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005178:	0905                	addi	s2,s2,1
    8000517a:	09a1                	addi	s3,s3,8
    8000517c:	fb491be3          	bne	s2,s4,80005132 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005180:	10048913          	addi	s2,s1,256
    80005184:	6088                	ld	a0,0(s1)
    80005186:	c529                	beqz	a0,800051d0 <sys_exec+0xf8>
    kfree(argv[i]);
    80005188:	ffffb097          	auipc	ra,0xffffb
    8000518c:	e94080e7          	jalr	-364(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005190:	04a1                	addi	s1,s1,8
    80005192:	ff2499e3          	bne	s1,s2,80005184 <sys_exec+0xac>
  return -1;
    80005196:	597d                	li	s2,-1
    80005198:	a82d                	j	800051d2 <sys_exec+0xfa>
      argv[i] = 0;
    8000519a:	0a8e                	slli	s5,s5,0x3
    8000519c:	fc040793          	addi	a5,s0,-64
    800051a0:	9abe                	add	s5,s5,a5
    800051a2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800051a6:	e4040593          	addi	a1,s0,-448
    800051aa:	f4040513          	addi	a0,s0,-192
    800051ae:	fffff097          	auipc	ra,0xfffff
    800051b2:	194080e7          	jalr	404(ra) # 80004342 <exec>
    800051b6:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051b8:	10048993          	addi	s3,s1,256
    800051bc:	6088                	ld	a0,0(s1)
    800051be:	c911                	beqz	a0,800051d2 <sys_exec+0xfa>
    kfree(argv[i]);
    800051c0:	ffffb097          	auipc	ra,0xffffb
    800051c4:	e5c080e7          	jalr	-420(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051c8:	04a1                	addi	s1,s1,8
    800051ca:	ff3499e3          	bne	s1,s3,800051bc <sys_exec+0xe4>
    800051ce:	a011                	j	800051d2 <sys_exec+0xfa>
  return -1;
    800051d0:	597d                	li	s2,-1
}
    800051d2:	854a                	mv	a0,s2
    800051d4:	60be                	ld	ra,456(sp)
    800051d6:	641e                	ld	s0,448(sp)
    800051d8:	74fa                	ld	s1,440(sp)
    800051da:	795a                	ld	s2,432(sp)
    800051dc:	79ba                	ld	s3,424(sp)
    800051de:	7a1a                	ld	s4,416(sp)
    800051e0:	6afa                	ld	s5,408(sp)
    800051e2:	6179                	addi	sp,sp,464
    800051e4:	8082                	ret

00000000800051e6 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051e6:	7139                	addi	sp,sp,-64
    800051e8:	fc06                	sd	ra,56(sp)
    800051ea:	f822                	sd	s0,48(sp)
    800051ec:	f426                	sd	s1,40(sp)
    800051ee:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051f0:	ffffc097          	auipc	ra,0xffffc
    800051f4:	e02080e7          	jalr	-510(ra) # 80000ff2 <myproc>
    800051f8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800051fa:	fd840593          	addi	a1,s0,-40
    800051fe:	4501                	li	a0,0
    80005200:	ffffd097          	auipc	ra,0xffffd
    80005204:	ec0080e7          	jalr	-320(ra) # 800020c0 <argaddr>
    return -1;
    80005208:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000520a:	0e054063          	bltz	a0,800052ea <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000520e:	fc840593          	addi	a1,s0,-56
    80005212:	fd040513          	addi	a0,s0,-48
    80005216:	fffff097          	auipc	ra,0xfffff
    8000521a:	df2080e7          	jalr	-526(ra) # 80004008 <pipealloc>
    return -1;
    8000521e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005220:	0c054563          	bltz	a0,800052ea <sys_pipe+0x104>
  fd0 = -1;
    80005224:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005228:	fd043503          	ld	a0,-48(s0)
    8000522c:	fffff097          	auipc	ra,0xfffff
    80005230:	508080e7          	jalr	1288(ra) # 80004734 <fdalloc>
    80005234:	fca42223          	sw	a0,-60(s0)
    80005238:	08054c63          	bltz	a0,800052d0 <sys_pipe+0xea>
    8000523c:	fc843503          	ld	a0,-56(s0)
    80005240:	fffff097          	auipc	ra,0xfffff
    80005244:	4f4080e7          	jalr	1268(ra) # 80004734 <fdalloc>
    80005248:	fca42023          	sw	a0,-64(s0)
    8000524c:	06054863          	bltz	a0,800052bc <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005250:	4691                	li	a3,4
    80005252:	fc440613          	addi	a2,s0,-60
    80005256:	fd843583          	ld	a1,-40(s0)
    8000525a:	6ca8                	ld	a0,88(s1)
    8000525c:	ffffc097          	auipc	ra,0xffffc
    80005260:	a58080e7          	jalr	-1448(ra) # 80000cb4 <copyout>
    80005264:	02054063          	bltz	a0,80005284 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005268:	4691                	li	a3,4
    8000526a:	fc040613          	addi	a2,s0,-64
    8000526e:	fd843583          	ld	a1,-40(s0)
    80005272:	0591                	addi	a1,a1,4
    80005274:	6ca8                	ld	a0,88(s1)
    80005276:	ffffc097          	auipc	ra,0xffffc
    8000527a:	a3e080e7          	jalr	-1474(ra) # 80000cb4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000527e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005280:	06055563          	bgez	a0,800052ea <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005284:	fc442783          	lw	a5,-60(s0)
    80005288:	07e9                	addi	a5,a5,26
    8000528a:	078e                	slli	a5,a5,0x3
    8000528c:	97a6                	add	a5,a5,s1
    8000528e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005292:	fc042503          	lw	a0,-64(s0)
    80005296:	0569                	addi	a0,a0,26
    80005298:	050e                	slli	a0,a0,0x3
    8000529a:	9526                	add	a0,a0,s1
    8000529c:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800052a0:	fd043503          	ld	a0,-48(s0)
    800052a4:	fffff097          	auipc	ra,0xfffff
    800052a8:	a34080e7          	jalr	-1484(ra) # 80003cd8 <fileclose>
    fileclose(wf);
    800052ac:	fc843503          	ld	a0,-56(s0)
    800052b0:	fffff097          	auipc	ra,0xfffff
    800052b4:	a28080e7          	jalr	-1496(ra) # 80003cd8 <fileclose>
    return -1;
    800052b8:	57fd                	li	a5,-1
    800052ba:	a805                	j	800052ea <sys_pipe+0x104>
    if(fd0 >= 0)
    800052bc:	fc442783          	lw	a5,-60(s0)
    800052c0:	0007c863          	bltz	a5,800052d0 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800052c4:	01a78513          	addi	a0,a5,26
    800052c8:	050e                	slli	a0,a0,0x3
    800052ca:	9526                	add	a0,a0,s1
    800052cc:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    800052d0:	fd043503          	ld	a0,-48(s0)
    800052d4:	fffff097          	auipc	ra,0xfffff
    800052d8:	a04080e7          	jalr	-1532(ra) # 80003cd8 <fileclose>
    fileclose(wf);
    800052dc:	fc843503          	ld	a0,-56(s0)
    800052e0:	fffff097          	auipc	ra,0xfffff
    800052e4:	9f8080e7          	jalr	-1544(ra) # 80003cd8 <fileclose>
    return -1;
    800052e8:	57fd                	li	a5,-1
}
    800052ea:	853e                	mv	a0,a5
    800052ec:	70e2                	ld	ra,56(sp)
    800052ee:	7442                	ld	s0,48(sp)
    800052f0:	74a2                	ld	s1,40(sp)
    800052f2:	6121                	addi	sp,sp,64
    800052f4:	8082                	ret
	...

0000000080005300 <kernelvec>:
    80005300:	7111                	addi	sp,sp,-256
    80005302:	e006                	sd	ra,0(sp)
    80005304:	e40a                	sd	sp,8(sp)
    80005306:	e80e                	sd	gp,16(sp)
    80005308:	ec12                	sd	tp,24(sp)
    8000530a:	f016                	sd	t0,32(sp)
    8000530c:	f41a                	sd	t1,40(sp)
    8000530e:	f81e                	sd	t2,48(sp)
    80005310:	fc22                	sd	s0,56(sp)
    80005312:	e0a6                	sd	s1,64(sp)
    80005314:	e4aa                	sd	a0,72(sp)
    80005316:	e8ae                	sd	a1,80(sp)
    80005318:	ecb2                	sd	a2,88(sp)
    8000531a:	f0b6                	sd	a3,96(sp)
    8000531c:	f4ba                	sd	a4,104(sp)
    8000531e:	f8be                	sd	a5,112(sp)
    80005320:	fcc2                	sd	a6,120(sp)
    80005322:	e146                	sd	a7,128(sp)
    80005324:	e54a                	sd	s2,136(sp)
    80005326:	e94e                	sd	s3,144(sp)
    80005328:	ed52                	sd	s4,152(sp)
    8000532a:	f156                	sd	s5,160(sp)
    8000532c:	f55a                	sd	s6,168(sp)
    8000532e:	f95e                	sd	s7,176(sp)
    80005330:	fd62                	sd	s8,184(sp)
    80005332:	e1e6                	sd	s9,192(sp)
    80005334:	e5ea                	sd	s10,200(sp)
    80005336:	e9ee                	sd	s11,208(sp)
    80005338:	edf2                	sd	t3,216(sp)
    8000533a:	f1f6                	sd	t4,224(sp)
    8000533c:	f5fa                	sd	t5,232(sp)
    8000533e:	f9fe                	sd	t6,240(sp)
    80005340:	b91fc0ef          	jal	ra,80001ed0 <kerneltrap>
    80005344:	6082                	ld	ra,0(sp)
    80005346:	6122                	ld	sp,8(sp)
    80005348:	61c2                	ld	gp,16(sp)
    8000534a:	7282                	ld	t0,32(sp)
    8000534c:	7322                	ld	t1,40(sp)
    8000534e:	73c2                	ld	t2,48(sp)
    80005350:	7462                	ld	s0,56(sp)
    80005352:	6486                	ld	s1,64(sp)
    80005354:	6526                	ld	a0,72(sp)
    80005356:	65c6                	ld	a1,80(sp)
    80005358:	6666                	ld	a2,88(sp)
    8000535a:	7686                	ld	a3,96(sp)
    8000535c:	7726                	ld	a4,104(sp)
    8000535e:	77c6                	ld	a5,112(sp)
    80005360:	7866                	ld	a6,120(sp)
    80005362:	688a                	ld	a7,128(sp)
    80005364:	692a                	ld	s2,136(sp)
    80005366:	69ca                	ld	s3,144(sp)
    80005368:	6a6a                	ld	s4,152(sp)
    8000536a:	7a8a                	ld	s5,160(sp)
    8000536c:	7b2a                	ld	s6,168(sp)
    8000536e:	7bca                	ld	s7,176(sp)
    80005370:	7c6a                	ld	s8,184(sp)
    80005372:	6c8e                	ld	s9,192(sp)
    80005374:	6d2e                	ld	s10,200(sp)
    80005376:	6dce                	ld	s11,208(sp)
    80005378:	6e6e                	ld	t3,216(sp)
    8000537a:	7e8e                	ld	t4,224(sp)
    8000537c:	7f2e                	ld	t5,232(sp)
    8000537e:	7fce                	ld	t6,240(sp)
    80005380:	6111                	addi	sp,sp,256
    80005382:	10200073          	sret
    80005386:	00000013          	nop
    8000538a:	00000013          	nop
    8000538e:	0001                	nop

0000000080005390 <timervec>:
    80005390:	34051573          	csrrw	a0,mscratch,a0
    80005394:	e10c                	sd	a1,0(a0)
    80005396:	e510                	sd	a2,8(a0)
    80005398:	e914                	sd	a3,16(a0)
    8000539a:	6d0c                	ld	a1,24(a0)
    8000539c:	7110                	ld	a2,32(a0)
    8000539e:	6194                	ld	a3,0(a1)
    800053a0:	96b2                	add	a3,a3,a2
    800053a2:	e194                	sd	a3,0(a1)
    800053a4:	4589                	li	a1,2
    800053a6:	14459073          	csrw	sip,a1
    800053aa:	6914                	ld	a3,16(a0)
    800053ac:	6510                	ld	a2,8(a0)
    800053ae:	610c                	ld	a1,0(a0)
    800053b0:	34051573          	csrrw	a0,mscratch,a0
    800053b4:	30200073          	mret
	...

00000000800053ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053ba:	1141                	addi	sp,sp,-16
    800053bc:	e422                	sd	s0,8(sp)
    800053be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053c0:	0c0007b7          	lui	a5,0xc000
    800053c4:	4705                	li	a4,1
    800053c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053c8:	c3d8                	sw	a4,4(a5)
}
    800053ca:	6422                	ld	s0,8(sp)
    800053cc:	0141                	addi	sp,sp,16
    800053ce:	8082                	ret

00000000800053d0 <plicinithart>:

void
plicinithart(void)
{
    800053d0:	1141                	addi	sp,sp,-16
    800053d2:	e406                	sd	ra,8(sp)
    800053d4:	e022                	sd	s0,0(sp)
    800053d6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053d8:	ffffc097          	auipc	ra,0xffffc
    800053dc:	bee080e7          	jalr	-1042(ra) # 80000fc6 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053e0:	0085171b          	slliw	a4,a0,0x8
    800053e4:	0c0027b7          	lui	a5,0xc002
    800053e8:	97ba                	add	a5,a5,a4
    800053ea:	40200713          	li	a4,1026
    800053ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053f2:	00d5151b          	slliw	a0,a0,0xd
    800053f6:	0c2017b7          	lui	a5,0xc201
    800053fa:	953e                	add	a0,a0,a5
    800053fc:	00052023          	sw	zero,0(a0)
}
    80005400:	60a2                	ld	ra,8(sp)
    80005402:	6402                	ld	s0,0(sp)
    80005404:	0141                	addi	sp,sp,16
    80005406:	8082                	ret

0000000080005408 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005408:	1141                	addi	sp,sp,-16
    8000540a:	e406                	sd	ra,8(sp)
    8000540c:	e022                	sd	s0,0(sp)
    8000540e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005410:	ffffc097          	auipc	ra,0xffffc
    80005414:	bb6080e7          	jalr	-1098(ra) # 80000fc6 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005418:	00d5179b          	slliw	a5,a0,0xd
    8000541c:	0c201537          	lui	a0,0xc201
    80005420:	953e                	add	a0,a0,a5
  return irq;
}
    80005422:	4148                	lw	a0,4(a0)
    80005424:	60a2                	ld	ra,8(sp)
    80005426:	6402                	ld	s0,0(sp)
    80005428:	0141                	addi	sp,sp,16
    8000542a:	8082                	ret

000000008000542c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000542c:	1101                	addi	sp,sp,-32
    8000542e:	ec06                	sd	ra,24(sp)
    80005430:	e822                	sd	s0,16(sp)
    80005432:	e426                	sd	s1,8(sp)
    80005434:	1000                	addi	s0,sp,32
    80005436:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005438:	ffffc097          	auipc	ra,0xffffc
    8000543c:	b8e080e7          	jalr	-1138(ra) # 80000fc6 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005440:	00d5151b          	slliw	a0,a0,0xd
    80005444:	0c2017b7          	lui	a5,0xc201
    80005448:	97aa                	add	a5,a5,a0
    8000544a:	c3c4                	sw	s1,4(a5)
}
    8000544c:	60e2                	ld	ra,24(sp)
    8000544e:	6442                	ld	s0,16(sp)
    80005450:	64a2                	ld	s1,8(sp)
    80005452:	6105                	addi	sp,sp,32
    80005454:	8082                	ret

0000000080005456 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005456:	1141                	addi	sp,sp,-16
    80005458:	e406                	sd	ra,8(sp)
    8000545a:	e022                	sd	s0,0(sp)
    8000545c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000545e:	479d                	li	a5,7
    80005460:	06a7c963          	blt	a5,a0,800054d2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005464:	00019797          	auipc	a5,0x19
    80005468:	b9c78793          	addi	a5,a5,-1124 # 8001e000 <disk>
    8000546c:	00a78733          	add	a4,a5,a0
    80005470:	6789                	lui	a5,0x2
    80005472:	97ba                	add	a5,a5,a4
    80005474:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005478:	e7ad                	bnez	a5,800054e2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000547a:	00451793          	slli	a5,a0,0x4
    8000547e:	0001b717          	auipc	a4,0x1b
    80005482:	b8270713          	addi	a4,a4,-1150 # 80020000 <disk+0x2000>
    80005486:	6314                	ld	a3,0(a4)
    80005488:	96be                	add	a3,a3,a5
    8000548a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000548e:	6314                	ld	a3,0(a4)
    80005490:	96be                	add	a3,a3,a5
    80005492:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005496:	6314                	ld	a3,0(a4)
    80005498:	96be                	add	a3,a3,a5
    8000549a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000549e:	6318                	ld	a4,0(a4)
    800054a0:	97ba                	add	a5,a5,a4
    800054a2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800054a6:	00019797          	auipc	a5,0x19
    800054aa:	b5a78793          	addi	a5,a5,-1190 # 8001e000 <disk>
    800054ae:	97aa                	add	a5,a5,a0
    800054b0:	6509                	lui	a0,0x2
    800054b2:	953e                	add	a0,a0,a5
    800054b4:	4785                	li	a5,1
    800054b6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800054ba:	0001b517          	auipc	a0,0x1b
    800054be:	b5e50513          	addi	a0,a0,-1186 # 80020018 <disk+0x2018>
    800054c2:	ffffc097          	auipc	ra,0xffffc
    800054c6:	378080e7          	jalr	888(ra) # 8000183a <wakeup>
}
    800054ca:	60a2                	ld	ra,8(sp)
    800054cc:	6402                	ld	s0,0(sp)
    800054ce:	0141                	addi	sp,sp,16
    800054d0:	8082                	ret
    panic("free_desc 1");
    800054d2:	00003517          	auipc	a0,0x3
    800054d6:	23e50513          	addi	a0,a0,574 # 80008710 <syscalls+0x340>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	d52080e7          	jalr	-686(ra) # 8000622c <panic>
    panic("free_desc 2");
    800054e2:	00003517          	auipc	a0,0x3
    800054e6:	23e50513          	addi	a0,a0,574 # 80008720 <syscalls+0x350>
    800054ea:	00001097          	auipc	ra,0x1
    800054ee:	d42080e7          	jalr	-702(ra) # 8000622c <panic>

00000000800054f2 <virtio_disk_init>:
{
    800054f2:	1101                	addi	sp,sp,-32
    800054f4:	ec06                	sd	ra,24(sp)
    800054f6:	e822                	sd	s0,16(sp)
    800054f8:	e426                	sd	s1,8(sp)
    800054fa:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054fc:	00003597          	auipc	a1,0x3
    80005500:	23458593          	addi	a1,a1,564 # 80008730 <syscalls+0x360>
    80005504:	0001b517          	auipc	a0,0x1b
    80005508:	c2450513          	addi	a0,a0,-988 # 80020128 <disk+0x2128>
    8000550c:	00001097          	auipc	ra,0x1
    80005510:	3d0080e7          	jalr	976(ra) # 800068dc <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005514:	100017b7          	lui	a5,0x10001
    80005518:	4398                	lw	a4,0(a5)
    8000551a:	2701                	sext.w	a4,a4
    8000551c:	747277b7          	lui	a5,0x74727
    80005520:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005524:	0ef71163          	bne	a4,a5,80005606 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005528:	100017b7          	lui	a5,0x10001
    8000552c:	43dc                	lw	a5,4(a5)
    8000552e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005530:	4705                	li	a4,1
    80005532:	0ce79a63          	bne	a5,a4,80005606 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005536:	100017b7          	lui	a5,0x10001
    8000553a:	479c                	lw	a5,8(a5)
    8000553c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000553e:	4709                	li	a4,2
    80005540:	0ce79363          	bne	a5,a4,80005606 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005544:	100017b7          	lui	a5,0x10001
    80005548:	47d8                	lw	a4,12(a5)
    8000554a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000554c:	554d47b7          	lui	a5,0x554d4
    80005550:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005554:	0af71963          	bne	a4,a5,80005606 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005558:	100017b7          	lui	a5,0x10001
    8000555c:	4705                	li	a4,1
    8000555e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005560:	470d                	li	a4,3
    80005562:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005564:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005566:	c7ffe737          	lui	a4,0xc7ffe
    8000556a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd3517>
    8000556e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005570:	2701                	sext.w	a4,a4
    80005572:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005574:	472d                	li	a4,11
    80005576:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005578:	473d                	li	a4,15
    8000557a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000557c:	6705                	lui	a4,0x1
    8000557e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005580:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005584:	5bdc                	lw	a5,52(a5)
    80005586:	2781                	sext.w	a5,a5
  if(max == 0)
    80005588:	c7d9                	beqz	a5,80005616 <virtio_disk_init+0x124>
  if(max < NUM)
    8000558a:	471d                	li	a4,7
    8000558c:	08f77d63          	bgeu	a4,a5,80005626 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005590:	100014b7          	lui	s1,0x10001
    80005594:	47a1                	li	a5,8
    80005596:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005598:	6609                	lui	a2,0x2
    8000559a:	4581                	li	a1,0
    8000559c:	00019517          	auipc	a0,0x19
    800055a0:	a6450513          	addi	a0,a0,-1436 # 8001e000 <disk>
    800055a4:	ffffb097          	auipc	ra,0xffffb
    800055a8:	d6e080e7          	jalr	-658(ra) # 80000312 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800055ac:	00019717          	auipc	a4,0x19
    800055b0:	a5470713          	addi	a4,a4,-1452 # 8001e000 <disk>
    800055b4:	00c75793          	srli	a5,a4,0xc
    800055b8:	2781                	sext.w	a5,a5
    800055ba:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800055bc:	0001b797          	auipc	a5,0x1b
    800055c0:	a4478793          	addi	a5,a5,-1468 # 80020000 <disk+0x2000>
    800055c4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800055c6:	00019717          	auipc	a4,0x19
    800055ca:	aba70713          	addi	a4,a4,-1350 # 8001e080 <disk+0x80>
    800055ce:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800055d0:	0001a717          	auipc	a4,0x1a
    800055d4:	a3070713          	addi	a4,a4,-1488 # 8001f000 <disk+0x1000>
    800055d8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800055da:	4705                	li	a4,1
    800055dc:	00e78c23          	sb	a4,24(a5)
    800055e0:	00e78ca3          	sb	a4,25(a5)
    800055e4:	00e78d23          	sb	a4,26(a5)
    800055e8:	00e78da3          	sb	a4,27(a5)
    800055ec:	00e78e23          	sb	a4,28(a5)
    800055f0:	00e78ea3          	sb	a4,29(a5)
    800055f4:	00e78f23          	sb	a4,30(a5)
    800055f8:	00e78fa3          	sb	a4,31(a5)
}
    800055fc:	60e2                	ld	ra,24(sp)
    800055fe:	6442                	ld	s0,16(sp)
    80005600:	64a2                	ld	s1,8(sp)
    80005602:	6105                	addi	sp,sp,32
    80005604:	8082                	ret
    panic("could not find virtio disk");
    80005606:	00003517          	auipc	a0,0x3
    8000560a:	13a50513          	addi	a0,a0,314 # 80008740 <syscalls+0x370>
    8000560e:	00001097          	auipc	ra,0x1
    80005612:	c1e080e7          	jalr	-994(ra) # 8000622c <panic>
    panic("virtio disk has no queue 0");
    80005616:	00003517          	auipc	a0,0x3
    8000561a:	14a50513          	addi	a0,a0,330 # 80008760 <syscalls+0x390>
    8000561e:	00001097          	auipc	ra,0x1
    80005622:	c0e080e7          	jalr	-1010(ra) # 8000622c <panic>
    panic("virtio disk max queue too short");
    80005626:	00003517          	auipc	a0,0x3
    8000562a:	15a50513          	addi	a0,a0,346 # 80008780 <syscalls+0x3b0>
    8000562e:	00001097          	auipc	ra,0x1
    80005632:	bfe080e7          	jalr	-1026(ra) # 8000622c <panic>

0000000080005636 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005636:	7159                	addi	sp,sp,-112
    80005638:	f486                	sd	ra,104(sp)
    8000563a:	f0a2                	sd	s0,96(sp)
    8000563c:	eca6                	sd	s1,88(sp)
    8000563e:	e8ca                	sd	s2,80(sp)
    80005640:	e4ce                	sd	s3,72(sp)
    80005642:	e0d2                	sd	s4,64(sp)
    80005644:	fc56                	sd	s5,56(sp)
    80005646:	f85a                	sd	s6,48(sp)
    80005648:	f45e                	sd	s7,40(sp)
    8000564a:	f062                	sd	s8,32(sp)
    8000564c:	ec66                	sd	s9,24(sp)
    8000564e:	e86a                	sd	s10,16(sp)
    80005650:	1880                	addi	s0,sp,112
    80005652:	892a                	mv	s2,a0
    80005654:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005656:	00c52c83          	lw	s9,12(a0)
    8000565a:	001c9c9b          	slliw	s9,s9,0x1
    8000565e:	1c82                	slli	s9,s9,0x20
    80005660:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005664:	0001b517          	auipc	a0,0x1b
    80005668:	ac450513          	addi	a0,a0,-1340 # 80020128 <disk+0x2128>
    8000566c:	00001097          	auipc	ra,0x1
    80005670:	0f4080e7          	jalr	244(ra) # 80006760 <acquire>
  for(int i = 0; i < 3; i++){
    80005674:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005676:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005678:	00019b97          	auipc	s7,0x19
    8000567c:	988b8b93          	addi	s7,s7,-1656 # 8001e000 <disk>
    80005680:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005682:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005684:	8a4e                	mv	s4,s3
    80005686:	a051                	j	8000570a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005688:	00fb86b3          	add	a3,s7,a5
    8000568c:	96da                	add	a3,a3,s6
    8000568e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005692:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005694:	0207c563          	bltz	a5,800056be <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005698:	2485                	addiw	s1,s1,1
    8000569a:	0711                	addi	a4,a4,4
    8000569c:	25548063          	beq	s1,s5,800058dc <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800056a0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800056a2:	0001b697          	auipc	a3,0x1b
    800056a6:	97668693          	addi	a3,a3,-1674 # 80020018 <disk+0x2018>
    800056aa:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800056ac:	0006c583          	lbu	a1,0(a3)
    800056b0:	fde1                	bnez	a1,80005688 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800056b2:	2785                	addiw	a5,a5,1
    800056b4:	0685                	addi	a3,a3,1
    800056b6:	ff879be3          	bne	a5,s8,800056ac <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800056ba:	57fd                	li	a5,-1
    800056bc:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800056be:	02905a63          	blez	s1,800056f2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800056c2:	f9042503          	lw	a0,-112(s0)
    800056c6:	00000097          	auipc	ra,0x0
    800056ca:	d90080e7          	jalr	-624(ra) # 80005456 <free_desc>
      for(int j = 0; j < i; j++)
    800056ce:	4785                	li	a5,1
    800056d0:	0297d163          	bge	a5,s1,800056f2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800056d4:	f9442503          	lw	a0,-108(s0)
    800056d8:	00000097          	auipc	ra,0x0
    800056dc:	d7e080e7          	jalr	-642(ra) # 80005456 <free_desc>
      for(int j = 0; j < i; j++)
    800056e0:	4789                	li	a5,2
    800056e2:	0097d863          	bge	a5,s1,800056f2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800056e6:	f9842503          	lw	a0,-104(s0)
    800056ea:	00000097          	auipc	ra,0x0
    800056ee:	d6c080e7          	jalr	-660(ra) # 80005456 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056f2:	0001b597          	auipc	a1,0x1b
    800056f6:	a3658593          	addi	a1,a1,-1482 # 80020128 <disk+0x2128>
    800056fa:	0001b517          	auipc	a0,0x1b
    800056fe:	91e50513          	addi	a0,a0,-1762 # 80020018 <disk+0x2018>
    80005702:	ffffc097          	auipc	ra,0xffffc
    80005706:	fac080e7          	jalr	-84(ra) # 800016ae <sleep>
  for(int i = 0; i < 3; i++){
    8000570a:	f9040713          	addi	a4,s0,-112
    8000570e:	84ce                	mv	s1,s3
    80005710:	bf41                	j	800056a0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005712:	20058713          	addi	a4,a1,512
    80005716:	00471693          	slli	a3,a4,0x4
    8000571a:	00019717          	auipc	a4,0x19
    8000571e:	8e670713          	addi	a4,a4,-1818 # 8001e000 <disk>
    80005722:	9736                	add	a4,a4,a3
    80005724:	4685                	li	a3,1
    80005726:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000572a:	20058713          	addi	a4,a1,512
    8000572e:	00471693          	slli	a3,a4,0x4
    80005732:	00019717          	auipc	a4,0x19
    80005736:	8ce70713          	addi	a4,a4,-1842 # 8001e000 <disk>
    8000573a:	9736                	add	a4,a4,a3
    8000573c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005740:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005744:	7679                	lui	a2,0xffffe
    80005746:	963e                	add	a2,a2,a5
    80005748:	0001b697          	auipc	a3,0x1b
    8000574c:	8b868693          	addi	a3,a3,-1864 # 80020000 <disk+0x2000>
    80005750:	6298                	ld	a4,0(a3)
    80005752:	9732                	add	a4,a4,a2
    80005754:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005756:	6298                	ld	a4,0(a3)
    80005758:	9732                	add	a4,a4,a2
    8000575a:	4541                	li	a0,16
    8000575c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000575e:	6298                	ld	a4,0(a3)
    80005760:	9732                	add	a4,a4,a2
    80005762:	4505                	li	a0,1
    80005764:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005768:	f9442703          	lw	a4,-108(s0)
    8000576c:	6288                	ld	a0,0(a3)
    8000576e:	962a                	add	a2,a2,a0
    80005770:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd2dc6>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005774:	0712                	slli	a4,a4,0x4
    80005776:	6290                	ld	a2,0(a3)
    80005778:	963a                	add	a2,a2,a4
    8000577a:	05890513          	addi	a0,s2,88
    8000577e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005780:	6294                	ld	a3,0(a3)
    80005782:	96ba                	add	a3,a3,a4
    80005784:	40000613          	li	a2,1024
    80005788:	c690                	sw	a2,8(a3)
  if(write)
    8000578a:	140d0063          	beqz	s10,800058ca <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000578e:	0001b697          	auipc	a3,0x1b
    80005792:	8726b683          	ld	a3,-1934(a3) # 80020000 <disk+0x2000>
    80005796:	96ba                	add	a3,a3,a4
    80005798:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000579c:	00019817          	auipc	a6,0x19
    800057a0:	86480813          	addi	a6,a6,-1948 # 8001e000 <disk>
    800057a4:	0001b517          	auipc	a0,0x1b
    800057a8:	85c50513          	addi	a0,a0,-1956 # 80020000 <disk+0x2000>
    800057ac:	6114                	ld	a3,0(a0)
    800057ae:	96ba                	add	a3,a3,a4
    800057b0:	00c6d603          	lhu	a2,12(a3)
    800057b4:	00166613          	ori	a2,a2,1
    800057b8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800057bc:	f9842683          	lw	a3,-104(s0)
    800057c0:	6110                	ld	a2,0(a0)
    800057c2:	9732                	add	a4,a4,a2
    800057c4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800057c8:	20058613          	addi	a2,a1,512
    800057cc:	0612                	slli	a2,a2,0x4
    800057ce:	9642                	add	a2,a2,a6
    800057d0:	577d                	li	a4,-1
    800057d2:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057d6:	00469713          	slli	a4,a3,0x4
    800057da:	6114                	ld	a3,0(a0)
    800057dc:	96ba                	add	a3,a3,a4
    800057de:	03078793          	addi	a5,a5,48
    800057e2:	97c2                	add	a5,a5,a6
    800057e4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    800057e6:	611c                	ld	a5,0(a0)
    800057e8:	97ba                	add	a5,a5,a4
    800057ea:	4685                	li	a3,1
    800057ec:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057ee:	611c                	ld	a5,0(a0)
    800057f0:	97ba                	add	a5,a5,a4
    800057f2:	4809                	li	a6,2
    800057f4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800057f8:	611c                	ld	a5,0(a0)
    800057fa:	973e                	add	a4,a4,a5
    800057fc:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005800:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005804:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005808:	6518                	ld	a4,8(a0)
    8000580a:	00275783          	lhu	a5,2(a4)
    8000580e:	8b9d                	andi	a5,a5,7
    80005810:	0786                	slli	a5,a5,0x1
    80005812:	97ba                	add	a5,a5,a4
    80005814:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005818:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000581c:	6518                	ld	a4,8(a0)
    8000581e:	00275783          	lhu	a5,2(a4)
    80005822:	2785                	addiw	a5,a5,1
    80005824:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005828:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000582c:	100017b7          	lui	a5,0x10001
    80005830:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005834:	00492703          	lw	a4,4(s2)
    80005838:	4785                	li	a5,1
    8000583a:	02f71163          	bne	a4,a5,8000585c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000583e:	0001b997          	auipc	s3,0x1b
    80005842:	8ea98993          	addi	s3,s3,-1814 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    80005846:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005848:	85ce                	mv	a1,s3
    8000584a:	854a                	mv	a0,s2
    8000584c:	ffffc097          	auipc	ra,0xffffc
    80005850:	e62080e7          	jalr	-414(ra) # 800016ae <sleep>
  while(b->disk == 1) {
    80005854:	00492783          	lw	a5,4(s2)
    80005858:	fe9788e3          	beq	a5,s1,80005848 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000585c:	f9042903          	lw	s2,-112(s0)
    80005860:	20090793          	addi	a5,s2,512
    80005864:	00479713          	slli	a4,a5,0x4
    80005868:	00018797          	auipc	a5,0x18
    8000586c:	79878793          	addi	a5,a5,1944 # 8001e000 <disk>
    80005870:	97ba                	add	a5,a5,a4
    80005872:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005876:	0001a997          	auipc	s3,0x1a
    8000587a:	78a98993          	addi	s3,s3,1930 # 80020000 <disk+0x2000>
    8000587e:	00491713          	slli	a4,s2,0x4
    80005882:	0009b783          	ld	a5,0(s3)
    80005886:	97ba                	add	a5,a5,a4
    80005888:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000588c:	854a                	mv	a0,s2
    8000588e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005892:	00000097          	auipc	ra,0x0
    80005896:	bc4080e7          	jalr	-1084(ra) # 80005456 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000589a:	8885                	andi	s1,s1,1
    8000589c:	f0ed                	bnez	s1,8000587e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000589e:	0001b517          	auipc	a0,0x1b
    800058a2:	88a50513          	addi	a0,a0,-1910 # 80020128 <disk+0x2128>
    800058a6:	00001097          	auipc	ra,0x1
    800058aa:	f8a080e7          	jalr	-118(ra) # 80006830 <release>
}
    800058ae:	70a6                	ld	ra,104(sp)
    800058b0:	7406                	ld	s0,96(sp)
    800058b2:	64e6                	ld	s1,88(sp)
    800058b4:	6946                	ld	s2,80(sp)
    800058b6:	69a6                	ld	s3,72(sp)
    800058b8:	6a06                	ld	s4,64(sp)
    800058ba:	7ae2                	ld	s5,56(sp)
    800058bc:	7b42                	ld	s6,48(sp)
    800058be:	7ba2                	ld	s7,40(sp)
    800058c0:	7c02                	ld	s8,32(sp)
    800058c2:	6ce2                	ld	s9,24(sp)
    800058c4:	6d42                	ld	s10,16(sp)
    800058c6:	6165                	addi	sp,sp,112
    800058c8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058ca:	0001a697          	auipc	a3,0x1a
    800058ce:	7366b683          	ld	a3,1846(a3) # 80020000 <disk+0x2000>
    800058d2:	96ba                	add	a3,a3,a4
    800058d4:	4609                	li	a2,2
    800058d6:	00c69623          	sh	a2,12(a3)
    800058da:	b5c9                	j	8000579c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058dc:	f9042583          	lw	a1,-112(s0)
    800058e0:	20058793          	addi	a5,a1,512
    800058e4:	0792                	slli	a5,a5,0x4
    800058e6:	00018517          	auipc	a0,0x18
    800058ea:	7c250513          	addi	a0,a0,1986 # 8001e0a8 <disk+0xa8>
    800058ee:	953e                	add	a0,a0,a5
  if(write)
    800058f0:	e20d11e3          	bnez	s10,80005712 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800058f4:	20058713          	addi	a4,a1,512
    800058f8:	00471693          	slli	a3,a4,0x4
    800058fc:	00018717          	auipc	a4,0x18
    80005900:	70470713          	addi	a4,a4,1796 # 8001e000 <disk>
    80005904:	9736                	add	a4,a4,a3
    80005906:	0a072423          	sw	zero,168(a4)
    8000590a:	b505                	j	8000572a <virtio_disk_rw+0xf4>

000000008000590c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000590c:	1101                	addi	sp,sp,-32
    8000590e:	ec06                	sd	ra,24(sp)
    80005910:	e822                	sd	s0,16(sp)
    80005912:	e426                	sd	s1,8(sp)
    80005914:	e04a                	sd	s2,0(sp)
    80005916:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005918:	0001b517          	auipc	a0,0x1b
    8000591c:	81050513          	addi	a0,a0,-2032 # 80020128 <disk+0x2128>
    80005920:	00001097          	auipc	ra,0x1
    80005924:	e40080e7          	jalr	-448(ra) # 80006760 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005928:	10001737          	lui	a4,0x10001
    8000592c:	533c                	lw	a5,96(a4)
    8000592e:	8b8d                	andi	a5,a5,3
    80005930:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005932:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005936:	0001a797          	auipc	a5,0x1a
    8000593a:	6ca78793          	addi	a5,a5,1738 # 80020000 <disk+0x2000>
    8000593e:	6b94                	ld	a3,16(a5)
    80005940:	0207d703          	lhu	a4,32(a5)
    80005944:	0026d783          	lhu	a5,2(a3)
    80005948:	06f70163          	beq	a4,a5,800059aa <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000594c:	00018917          	auipc	s2,0x18
    80005950:	6b490913          	addi	s2,s2,1716 # 8001e000 <disk>
    80005954:	0001a497          	auipc	s1,0x1a
    80005958:	6ac48493          	addi	s1,s1,1708 # 80020000 <disk+0x2000>
    __sync_synchronize();
    8000595c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005960:	6898                	ld	a4,16(s1)
    80005962:	0204d783          	lhu	a5,32(s1)
    80005966:	8b9d                	andi	a5,a5,7
    80005968:	078e                	slli	a5,a5,0x3
    8000596a:	97ba                	add	a5,a5,a4
    8000596c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000596e:	20078713          	addi	a4,a5,512
    80005972:	0712                	slli	a4,a4,0x4
    80005974:	974a                	add	a4,a4,s2
    80005976:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000597a:	e731                	bnez	a4,800059c6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000597c:	20078793          	addi	a5,a5,512
    80005980:	0792                	slli	a5,a5,0x4
    80005982:	97ca                	add	a5,a5,s2
    80005984:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005986:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000598a:	ffffc097          	auipc	ra,0xffffc
    8000598e:	eb0080e7          	jalr	-336(ra) # 8000183a <wakeup>

    disk.used_idx += 1;
    80005992:	0204d783          	lhu	a5,32(s1)
    80005996:	2785                	addiw	a5,a5,1
    80005998:	17c2                	slli	a5,a5,0x30
    8000599a:	93c1                	srli	a5,a5,0x30
    8000599c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800059a0:	6898                	ld	a4,16(s1)
    800059a2:	00275703          	lhu	a4,2(a4)
    800059a6:	faf71be3          	bne	a4,a5,8000595c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800059aa:	0001a517          	auipc	a0,0x1a
    800059ae:	77e50513          	addi	a0,a0,1918 # 80020128 <disk+0x2128>
    800059b2:	00001097          	auipc	ra,0x1
    800059b6:	e7e080e7          	jalr	-386(ra) # 80006830 <release>
}
    800059ba:	60e2                	ld	ra,24(sp)
    800059bc:	6442                	ld	s0,16(sp)
    800059be:	64a2                	ld	s1,8(sp)
    800059c0:	6902                	ld	s2,0(sp)
    800059c2:	6105                	addi	sp,sp,32
    800059c4:	8082                	ret
      panic("virtio_disk_intr status");
    800059c6:	00003517          	auipc	a0,0x3
    800059ca:	dda50513          	addi	a0,a0,-550 # 800087a0 <syscalls+0x3d0>
    800059ce:	00001097          	auipc	ra,0x1
    800059d2:	85e080e7          	jalr	-1954(ra) # 8000622c <panic>

00000000800059d6 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    800059d6:	1141                	addi	sp,sp,-16
    800059d8:	e422                	sd	s0,8(sp)
    800059da:	0800                	addi	s0,sp,16
  return -1;
}
    800059dc:	557d                	li	a0,-1
    800059de:	6422                	ld	s0,8(sp)
    800059e0:	0141                	addi	sp,sp,16
    800059e2:	8082                	ret

00000000800059e4 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    800059e4:	7179                	addi	sp,sp,-48
    800059e6:	f406                	sd	ra,40(sp)
    800059e8:	f022                	sd	s0,32(sp)
    800059ea:	ec26                	sd	s1,24(sp)
    800059ec:	e84a                	sd	s2,16(sp)
    800059ee:	e44e                	sd	s3,8(sp)
    800059f0:	e052                	sd	s4,0(sp)
    800059f2:	1800                	addi	s0,sp,48
    800059f4:	892a                	mv	s2,a0
    800059f6:	89ae                	mv	s3,a1
    800059f8:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    800059fa:	0001b517          	auipc	a0,0x1b
    800059fe:	60650513          	addi	a0,a0,1542 # 80021000 <stats>
    80005a02:	00001097          	auipc	ra,0x1
    80005a06:	d5e080e7          	jalr	-674(ra) # 80006760 <acquire>

  if(stats.sz == 0) {
    80005a0a:	0001c797          	auipc	a5,0x1c
    80005a0e:	6167a783          	lw	a5,1558(a5) # 80022020 <stats+0x1020>
    80005a12:	cbb5                	beqz	a5,80005a86 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80005a14:	0001c797          	auipc	a5,0x1c
    80005a18:	5ec78793          	addi	a5,a5,1516 # 80022000 <stats+0x1000>
    80005a1c:	53d8                	lw	a4,36(a5)
    80005a1e:	539c                	lw	a5,32(a5)
    80005a20:	9f99                	subw	a5,a5,a4
    80005a22:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    80005a26:	06d05e63          	blez	a3,80005aa2 <statsread+0xbe>
    if(m > n)
    80005a2a:	8a3e                	mv	s4,a5
    80005a2c:	00d4d363          	bge	s1,a3,80005a32 <statsread+0x4e>
    80005a30:	8a26                	mv	s4,s1
    80005a32:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005a36:	86a6                	mv	a3,s1
    80005a38:	0001b617          	auipc	a2,0x1b
    80005a3c:	5e860613          	addi	a2,a2,1512 # 80021020 <stats+0x20>
    80005a40:	963a                	add	a2,a2,a4
    80005a42:	85ce                	mv	a1,s3
    80005a44:	854a                	mv	a0,s2
    80005a46:	ffffc097          	auipc	ra,0xffffc
    80005a4a:	00c080e7          	jalr	12(ra) # 80001a52 <either_copyout>
    80005a4e:	57fd                	li	a5,-1
    80005a50:	00f50a63          	beq	a0,a5,80005a64 <statsread+0x80>
      stats.off += m;
    80005a54:	0001c717          	auipc	a4,0x1c
    80005a58:	5ac70713          	addi	a4,a4,1452 # 80022000 <stats+0x1000>
    80005a5c:	535c                	lw	a5,36(a4)
    80005a5e:	014787bb          	addw	a5,a5,s4
    80005a62:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005a64:	0001b517          	auipc	a0,0x1b
    80005a68:	59c50513          	addi	a0,a0,1436 # 80021000 <stats>
    80005a6c:	00001097          	auipc	ra,0x1
    80005a70:	dc4080e7          	jalr	-572(ra) # 80006830 <release>
  return m;
}
    80005a74:	8526                	mv	a0,s1
    80005a76:	70a2                	ld	ra,40(sp)
    80005a78:	7402                	ld	s0,32(sp)
    80005a7a:	64e2                	ld	s1,24(sp)
    80005a7c:	6942                	ld	s2,16(sp)
    80005a7e:	69a2                	ld	s3,8(sp)
    80005a80:	6a02                	ld	s4,0(sp)
    80005a82:	6145                	addi	sp,sp,48
    80005a84:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005a86:	6585                	lui	a1,0x1
    80005a88:	0001b517          	auipc	a0,0x1b
    80005a8c:	59850513          	addi	a0,a0,1432 # 80021020 <stats+0x20>
    80005a90:	00001097          	auipc	ra,0x1
    80005a94:	f28080e7          	jalr	-216(ra) # 800069b8 <statslock>
    80005a98:	0001c797          	auipc	a5,0x1c
    80005a9c:	58a7a423          	sw	a0,1416(a5) # 80022020 <stats+0x1020>
    80005aa0:	bf95                	j	80005a14 <statsread+0x30>
    stats.sz = 0;
    80005aa2:	0001c797          	auipc	a5,0x1c
    80005aa6:	55e78793          	addi	a5,a5,1374 # 80022000 <stats+0x1000>
    80005aaa:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005aae:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005ab2:	54fd                	li	s1,-1
    80005ab4:	bf45                	j	80005a64 <statsread+0x80>

0000000080005ab6 <statsinit>:

void
statsinit(void)
{
    80005ab6:	1141                	addi	sp,sp,-16
    80005ab8:	e406                	sd	ra,8(sp)
    80005aba:	e022                	sd	s0,0(sp)
    80005abc:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005abe:	00003597          	auipc	a1,0x3
    80005ac2:	cfa58593          	addi	a1,a1,-774 # 800087b8 <syscalls+0x3e8>
    80005ac6:	0001b517          	auipc	a0,0x1b
    80005aca:	53a50513          	addi	a0,a0,1338 # 80021000 <stats>
    80005ace:	00001097          	auipc	ra,0x1
    80005ad2:	e0e080e7          	jalr	-498(ra) # 800068dc <initlock>

  devsw[STATS].read = statsread;
    80005ad6:	00017797          	auipc	a5,0x17
    80005ada:	25278793          	addi	a5,a5,594 # 8001cd28 <devsw>
    80005ade:	00000717          	auipc	a4,0x0
    80005ae2:	f0670713          	addi	a4,a4,-250 # 800059e4 <statsread>
    80005ae6:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005ae8:	00000717          	auipc	a4,0x0
    80005aec:	eee70713          	addi	a4,a4,-274 # 800059d6 <statswrite>
    80005af0:	f798                	sd	a4,40(a5)
}
    80005af2:	60a2                	ld	ra,8(sp)
    80005af4:	6402                	ld	s0,0(sp)
    80005af6:	0141                	addi	sp,sp,16
    80005af8:	8082                	ret

0000000080005afa <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005afa:	1101                	addi	sp,sp,-32
    80005afc:	ec22                	sd	s0,24(sp)
    80005afe:	1000                	addi	s0,sp,32
    80005b00:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005b02:	c299                	beqz	a3,80005b08 <sprintint+0xe>
    80005b04:	0805c163          	bltz	a1,80005b86 <sprintint+0x8c>
    x = -xx;
  else
    x = xx;
    80005b08:	2581                	sext.w	a1,a1
    80005b0a:	4301                	li	t1,0

  i = 0;
    80005b0c:	fe040713          	addi	a4,s0,-32
    80005b10:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005b12:	2601                	sext.w	a2,a2
    80005b14:	00003697          	auipc	a3,0x3
    80005b18:	cc468693          	addi	a3,a3,-828 # 800087d8 <digits>
    80005b1c:	88aa                	mv	a7,a0
    80005b1e:	2505                	addiw	a0,a0,1
    80005b20:	02c5f7bb          	remuw	a5,a1,a2
    80005b24:	1782                	slli	a5,a5,0x20
    80005b26:	9381                	srli	a5,a5,0x20
    80005b28:	97b6                	add	a5,a5,a3
    80005b2a:	0007c783          	lbu	a5,0(a5)
    80005b2e:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005b32:	0005879b          	sext.w	a5,a1
    80005b36:	02c5d5bb          	divuw	a1,a1,a2
    80005b3a:	0705                	addi	a4,a4,1
    80005b3c:	fec7f0e3          	bgeu	a5,a2,80005b1c <sprintint+0x22>

  if(sign)
    80005b40:	00030b63          	beqz	t1,80005b56 <sprintint+0x5c>
    buf[i++] = '-';
    80005b44:	ff040793          	addi	a5,s0,-16
    80005b48:	97aa                	add	a5,a5,a0
    80005b4a:	02d00713          	li	a4,45
    80005b4e:	fee78823          	sb	a4,-16(a5)
    80005b52:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005b56:	02a05c63          	blez	a0,80005b8e <sprintint+0x94>
    80005b5a:	fe040793          	addi	a5,s0,-32
    80005b5e:	00a78733          	add	a4,a5,a0
    80005b62:	87c2                	mv	a5,a6
    80005b64:	0805                	addi	a6,a6,1
    80005b66:	fff5061b          	addiw	a2,a0,-1
    80005b6a:	1602                	slli	a2,a2,0x20
    80005b6c:	9201                	srli	a2,a2,0x20
    80005b6e:	9642                	add	a2,a2,a6
  *s = c;
    80005b70:	fff74683          	lbu	a3,-1(a4)
    80005b74:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005b78:	177d                	addi	a4,a4,-1
    80005b7a:	0785                	addi	a5,a5,1
    80005b7c:	fec79ae3          	bne	a5,a2,80005b70 <sprintint+0x76>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005b80:	6462                	ld	s0,24(sp)
    80005b82:	6105                	addi	sp,sp,32
    80005b84:	8082                	ret
    x = -xx;
    80005b86:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005b8a:	4305                	li	t1,1
    x = -xx;
    80005b8c:	b741                	j	80005b0c <sprintint+0x12>
  while(--i >= 0)
    80005b8e:	4501                	li	a0,0
    80005b90:	bfc5                	j	80005b80 <sprintint+0x86>

0000000080005b92 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005b92:	7171                	addi	sp,sp,-176
    80005b94:	fc86                	sd	ra,120(sp)
    80005b96:	f8a2                	sd	s0,112(sp)
    80005b98:	f4a6                	sd	s1,104(sp)
    80005b9a:	f0ca                	sd	s2,96(sp)
    80005b9c:	ecce                	sd	s3,88(sp)
    80005b9e:	e8d2                	sd	s4,80(sp)
    80005ba0:	e4d6                	sd	s5,72(sp)
    80005ba2:	e0da                	sd	s6,64(sp)
    80005ba4:	fc5e                	sd	s7,56(sp)
    80005ba6:	f862                	sd	s8,48(sp)
    80005ba8:	f466                	sd	s9,40(sp)
    80005baa:	f06a                	sd	s10,32(sp)
    80005bac:	ec6e                	sd	s11,24(sp)
    80005bae:	0100                	addi	s0,sp,128
    80005bb0:	e414                	sd	a3,8(s0)
    80005bb2:	e818                	sd	a4,16(s0)
    80005bb4:	ec1c                	sd	a5,24(s0)
    80005bb6:	03043023          	sd	a6,32(s0)
    80005bba:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005bbe:	ca0d                	beqz	a2,80005bf0 <snprintf+0x5e>
    80005bc0:	8baa                	mv	s7,a0
    80005bc2:	89ae                	mv	s3,a1
    80005bc4:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005bc6:	00840793          	addi	a5,s0,8
    80005bca:	f8f43423          	sd	a5,-120(s0)
  int off = 0;
    80005bce:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005bd0:	4901                	li	s2,0
    80005bd2:	02b05763          	blez	a1,80005c00 <snprintf+0x6e>
    if(c != '%'){
    80005bd6:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005bda:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005bde:	02800d93          	li	s11,40
  *s = c;
    80005be2:	02500d13          	li	s10,37
    switch(c){
    80005be6:	07800c93          	li	s9,120
    80005bea:	06400c13          	li	s8,100
    80005bee:	a01d                	j	80005c14 <snprintf+0x82>
    panic("null fmt");
    80005bf0:	00003517          	auipc	a0,0x3
    80005bf4:	bd850513          	addi	a0,a0,-1064 # 800087c8 <syscalls+0x3f8>
    80005bf8:	00000097          	auipc	ra,0x0
    80005bfc:	634080e7          	jalr	1588(ra) # 8000622c <panic>
  int off = 0;
    80005c00:	4481                	li	s1,0
    80005c02:	a86d                	j	80005cbc <snprintf+0x12a>
  *s = c;
    80005c04:	009b8733          	add	a4,s7,s1
    80005c08:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005c0c:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005c0e:	2905                	addiw	s2,s2,1
    80005c10:	0b34d663          	bge	s1,s3,80005cbc <snprintf+0x12a>
    80005c14:	012a07b3          	add	a5,s4,s2
    80005c18:	0007c783          	lbu	a5,0(a5)
    80005c1c:	0007871b          	sext.w	a4,a5
    80005c20:	cfd1                	beqz	a5,80005cbc <snprintf+0x12a>
    if(c != '%'){
    80005c22:	ff5711e3          	bne	a4,s5,80005c04 <snprintf+0x72>
    c = fmt[++i] & 0xff;
    80005c26:	2905                	addiw	s2,s2,1
    80005c28:	012a07b3          	add	a5,s4,s2
    80005c2c:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005c30:	c7d1                	beqz	a5,80005cbc <snprintf+0x12a>
    switch(c){
    80005c32:	05678c63          	beq	a5,s6,80005c8a <snprintf+0xf8>
    80005c36:	02fb6763          	bltu	s6,a5,80005c64 <snprintf+0xd2>
    80005c3a:	0b578763          	beq	a5,s5,80005ce8 <snprintf+0x156>
    80005c3e:	0b879b63          	bne	a5,s8,80005cf4 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005c42:	f8843783          	ld	a5,-120(s0)
    80005c46:	00878713          	addi	a4,a5,8
    80005c4a:	f8e43423          	sd	a4,-120(s0)
    80005c4e:	4685                	li	a3,1
    80005c50:	4629                	li	a2,10
    80005c52:	438c                	lw	a1,0(a5)
    80005c54:	009b8533          	add	a0,s7,s1
    80005c58:	00000097          	auipc	ra,0x0
    80005c5c:	ea2080e7          	jalr	-350(ra) # 80005afa <sprintint>
    80005c60:	9ca9                	addw	s1,s1,a0
      break;
    80005c62:	b775                	j	80005c0e <snprintf+0x7c>
    switch(c){
    80005c64:	09979863          	bne	a5,s9,80005cf4 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005c68:	f8843783          	ld	a5,-120(s0)
    80005c6c:	00878713          	addi	a4,a5,8
    80005c70:	f8e43423          	sd	a4,-120(s0)
    80005c74:	4685                	li	a3,1
    80005c76:	4641                	li	a2,16
    80005c78:	438c                	lw	a1,0(a5)
    80005c7a:	009b8533          	add	a0,s7,s1
    80005c7e:	00000097          	auipc	ra,0x0
    80005c82:	e7c080e7          	jalr	-388(ra) # 80005afa <sprintint>
    80005c86:	9ca9                	addw	s1,s1,a0
      break;
    80005c88:	b759                	j	80005c0e <snprintf+0x7c>
      if((s = va_arg(ap, char*)) == 0)
    80005c8a:	f8843783          	ld	a5,-120(s0)
    80005c8e:	00878713          	addi	a4,a5,8
    80005c92:	f8e43423          	sd	a4,-120(s0)
    80005c96:	639c                	ld	a5,0(a5)
    80005c98:	c3b1                	beqz	a5,80005cdc <snprintf+0x14a>
      for(; *s && off < sz; s++)
    80005c9a:	0007c703          	lbu	a4,0(a5)
    80005c9e:	db25                	beqz	a4,80005c0e <snprintf+0x7c>
    80005ca0:	0134de63          	bge	s1,s3,80005cbc <snprintf+0x12a>
    80005ca4:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005ca8:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005cac:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005cae:	0785                	addi	a5,a5,1
    80005cb0:	0007c703          	lbu	a4,0(a5)
    80005cb4:	df29                	beqz	a4,80005c0e <snprintf+0x7c>
    80005cb6:	0685                	addi	a3,a3,1
    80005cb8:	fe9998e3          	bne	s3,s1,80005ca8 <snprintf+0x116>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005cbc:	8526                	mv	a0,s1
    80005cbe:	70e6                	ld	ra,120(sp)
    80005cc0:	7446                	ld	s0,112(sp)
    80005cc2:	74a6                	ld	s1,104(sp)
    80005cc4:	7906                	ld	s2,96(sp)
    80005cc6:	69e6                	ld	s3,88(sp)
    80005cc8:	6a46                	ld	s4,80(sp)
    80005cca:	6aa6                	ld	s5,72(sp)
    80005ccc:	6b06                	ld	s6,64(sp)
    80005cce:	7be2                	ld	s7,56(sp)
    80005cd0:	7c42                	ld	s8,48(sp)
    80005cd2:	7ca2                	ld	s9,40(sp)
    80005cd4:	7d02                	ld	s10,32(sp)
    80005cd6:	6de2                	ld	s11,24(sp)
    80005cd8:	614d                	addi	sp,sp,176
    80005cda:	8082                	ret
        s = "(null)";
    80005cdc:	00003797          	auipc	a5,0x3
    80005ce0:	ae478793          	addi	a5,a5,-1308 # 800087c0 <syscalls+0x3f0>
      for(; *s && off < sz; s++)
    80005ce4:	876e                	mv	a4,s11
    80005ce6:	bf6d                	j	80005ca0 <snprintf+0x10e>
  *s = c;
    80005ce8:	009b87b3          	add	a5,s7,s1
    80005cec:	01a78023          	sb	s10,0(a5)
      off += sputc(buf+off, '%');
    80005cf0:	2485                	addiw	s1,s1,1
      break;
    80005cf2:	bf31                	j	80005c0e <snprintf+0x7c>
  *s = c;
    80005cf4:	009b8733          	add	a4,s7,s1
    80005cf8:	01a70023          	sb	s10,0(a4)
      off += sputc(buf+off, c);
    80005cfc:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005d00:	975e                	add	a4,a4,s7
    80005d02:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005d06:	2489                	addiw	s1,s1,2
      break;
    80005d08:	b719                	j	80005c0e <snprintf+0x7c>

0000000080005d0a <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005d0a:	1141                	addi	sp,sp,-16
    80005d0c:	e422                	sd	s0,8(sp)
    80005d0e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d10:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005d14:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005d18:	0037979b          	slliw	a5,a5,0x3
    80005d1c:	02004737          	lui	a4,0x2004
    80005d20:	97ba                	add	a5,a5,a4
    80005d22:	0200c737          	lui	a4,0x200c
    80005d26:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005d2a:	000f4637          	lui	a2,0xf4
    80005d2e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005d32:	95b2                	add	a1,a1,a2
    80005d34:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005d36:	00269713          	slli	a4,a3,0x2
    80005d3a:	9736                	add	a4,a4,a3
    80005d3c:	00371693          	slli	a3,a4,0x3
    80005d40:	0001c717          	auipc	a4,0x1c
    80005d44:	2f070713          	addi	a4,a4,752 # 80022030 <timer_scratch>
    80005d48:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005d4a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005d4c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005d4e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005d52:	fffff797          	auipc	a5,0xfffff
    80005d56:	63e78793          	addi	a5,a5,1598 # 80005390 <timervec>
    80005d5a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005d5e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005d62:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d66:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005d6a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005d6e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005d72:	30479073          	csrw	mie,a5
}
    80005d76:	6422                	ld	s0,8(sp)
    80005d78:	0141                	addi	sp,sp,16
    80005d7a:	8082                	ret

0000000080005d7c <start>:
{
    80005d7c:	1141                	addi	sp,sp,-16
    80005d7e:	e406                	sd	ra,8(sp)
    80005d80:	e022                	sd	s0,0(sp)
    80005d82:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005d84:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005d88:	7779                	lui	a4,0xffffe
    80005d8a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd35b7>
    80005d8e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005d90:	6705                	lui	a4,0x1
    80005d92:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005d96:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d98:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005d9c:	ffffa797          	auipc	a5,0xffffa
    80005da0:	72478793          	addi	a5,a5,1828 # 800004c0 <main>
    80005da4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005da8:	4781                	li	a5,0
    80005daa:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005dae:	67c1                	lui	a5,0x10
    80005db0:	17fd                	addi	a5,a5,-1
    80005db2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005db6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005dba:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005dbe:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005dc2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005dc6:	57fd                	li	a5,-1
    80005dc8:	83a9                	srli	a5,a5,0xa
    80005dca:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005dce:	47bd                	li	a5,15
    80005dd0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	f36080e7          	jalr	-202(ra) # 80005d0a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ddc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005de0:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005de2:	823e                	mv	tp,a5
  asm volatile("mret");
    80005de4:	30200073          	mret
}
    80005de8:	60a2                	ld	ra,8(sp)
    80005dea:	6402                	ld	s0,0(sp)
    80005dec:	0141                	addi	sp,sp,16
    80005dee:	8082                	ret

0000000080005df0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005df0:	715d                	addi	sp,sp,-80
    80005df2:	e486                	sd	ra,72(sp)
    80005df4:	e0a2                	sd	s0,64(sp)
    80005df6:	fc26                	sd	s1,56(sp)
    80005df8:	f84a                	sd	s2,48(sp)
    80005dfa:	f44e                	sd	s3,40(sp)
    80005dfc:	f052                	sd	s4,32(sp)
    80005dfe:	ec56                	sd	s5,24(sp)
    80005e00:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005e02:	04c05663          	blez	a2,80005e4e <consolewrite+0x5e>
    80005e06:	8a2a                	mv	s4,a0
    80005e08:	84ae                	mv	s1,a1
    80005e0a:	89b2                	mv	s3,a2
    80005e0c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005e0e:	5afd                	li	s5,-1
    80005e10:	4685                	li	a3,1
    80005e12:	8626                	mv	a2,s1
    80005e14:	85d2                	mv	a1,s4
    80005e16:	fbf40513          	addi	a0,s0,-65
    80005e1a:	ffffc097          	auipc	ra,0xffffc
    80005e1e:	c8e080e7          	jalr	-882(ra) # 80001aa8 <either_copyin>
    80005e22:	01550c63          	beq	a0,s5,80005e3a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005e26:	fbf44503          	lbu	a0,-65(s0)
    80005e2a:	00000097          	auipc	ra,0x0
    80005e2e:	78e080e7          	jalr	1934(ra) # 800065b8 <uartputc>
  for(i = 0; i < n; i++){
    80005e32:	2905                	addiw	s2,s2,1
    80005e34:	0485                	addi	s1,s1,1
    80005e36:	fd299de3          	bne	s3,s2,80005e10 <consolewrite+0x20>
  }

  return i;
}
    80005e3a:	854a                	mv	a0,s2
    80005e3c:	60a6                	ld	ra,72(sp)
    80005e3e:	6406                	ld	s0,64(sp)
    80005e40:	74e2                	ld	s1,56(sp)
    80005e42:	7942                	ld	s2,48(sp)
    80005e44:	79a2                	ld	s3,40(sp)
    80005e46:	7a02                	ld	s4,32(sp)
    80005e48:	6ae2                	ld	s5,24(sp)
    80005e4a:	6161                	addi	sp,sp,80
    80005e4c:	8082                	ret
  for(i = 0; i < n; i++){
    80005e4e:	4901                	li	s2,0
    80005e50:	b7ed                	j	80005e3a <consolewrite+0x4a>

0000000080005e52 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005e52:	7119                	addi	sp,sp,-128
    80005e54:	fc86                	sd	ra,120(sp)
    80005e56:	f8a2                	sd	s0,112(sp)
    80005e58:	f4a6                	sd	s1,104(sp)
    80005e5a:	f0ca                	sd	s2,96(sp)
    80005e5c:	ecce                	sd	s3,88(sp)
    80005e5e:	e8d2                	sd	s4,80(sp)
    80005e60:	e4d6                	sd	s5,72(sp)
    80005e62:	e0da                	sd	s6,64(sp)
    80005e64:	fc5e                	sd	s7,56(sp)
    80005e66:	f862                	sd	s8,48(sp)
    80005e68:	f466                	sd	s9,40(sp)
    80005e6a:	f06a                	sd	s10,32(sp)
    80005e6c:	ec6e                	sd	s11,24(sp)
    80005e6e:	0100                	addi	s0,sp,128
    80005e70:	8b2a                	mv	s6,a0
    80005e72:	8aae                	mv	s5,a1
    80005e74:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005e76:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005e7a:	00024517          	auipc	a0,0x24
    80005e7e:	2f650513          	addi	a0,a0,758 # 8002a170 <cons>
    80005e82:	00001097          	auipc	ra,0x1
    80005e86:	8de080e7          	jalr	-1826(ra) # 80006760 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005e8a:	00024497          	auipc	s1,0x24
    80005e8e:	2e648493          	addi	s1,s1,742 # 8002a170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005e92:	89a6                	mv	s3,s1
    80005e94:	00024917          	auipc	s2,0x24
    80005e98:	37c90913          	addi	s2,s2,892 # 8002a210 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005e9c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e9e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005ea0:	4da9                	li	s11,10
  while(n > 0){
    80005ea2:	07405863          	blez	s4,80005f12 <consoleread+0xc0>
    while(cons.r == cons.w){
    80005ea6:	0a04a783          	lw	a5,160(s1)
    80005eaa:	0a44a703          	lw	a4,164(s1)
    80005eae:	02f71463          	bne	a4,a5,80005ed6 <consoleread+0x84>
      if(myproc()->killed){
    80005eb2:	ffffb097          	auipc	ra,0xffffb
    80005eb6:	140080e7          	jalr	320(ra) # 80000ff2 <myproc>
    80005eba:	591c                	lw	a5,48(a0)
    80005ebc:	e7b5                	bnez	a5,80005f28 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005ebe:	85ce                	mv	a1,s3
    80005ec0:	854a                	mv	a0,s2
    80005ec2:	ffffb097          	auipc	ra,0xffffb
    80005ec6:	7ec080e7          	jalr	2028(ra) # 800016ae <sleep>
    while(cons.r == cons.w){
    80005eca:	0a04a783          	lw	a5,160(s1)
    80005ece:	0a44a703          	lw	a4,164(s1)
    80005ed2:	fef700e3          	beq	a4,a5,80005eb2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005ed6:	0017871b          	addiw	a4,a5,1
    80005eda:	0ae4a023          	sw	a4,160(s1)
    80005ede:	07f7f713          	andi	a4,a5,127
    80005ee2:	9726                	add	a4,a4,s1
    80005ee4:	02074703          	lbu	a4,32(a4)
    80005ee8:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005eec:	079c0663          	beq	s8,s9,80005f58 <consoleread+0x106>
    cbuf = c;
    80005ef0:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ef4:	4685                	li	a3,1
    80005ef6:	f8f40613          	addi	a2,s0,-113
    80005efa:	85d6                	mv	a1,s5
    80005efc:	855a                	mv	a0,s6
    80005efe:	ffffc097          	auipc	ra,0xffffc
    80005f02:	b54080e7          	jalr	-1196(ra) # 80001a52 <either_copyout>
    80005f06:	01a50663          	beq	a0,s10,80005f12 <consoleread+0xc0>
    dst++;
    80005f0a:	0a85                	addi	s5,s5,1
    --n;
    80005f0c:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005f0e:	f9bc1ae3          	bne	s8,s11,80005ea2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005f12:	00024517          	auipc	a0,0x24
    80005f16:	25e50513          	addi	a0,a0,606 # 8002a170 <cons>
    80005f1a:	00001097          	auipc	ra,0x1
    80005f1e:	916080e7          	jalr	-1770(ra) # 80006830 <release>

  return target - n;
    80005f22:	414b853b          	subw	a0,s7,s4
    80005f26:	a811                	j	80005f3a <consoleread+0xe8>
        release(&cons.lock);
    80005f28:	00024517          	auipc	a0,0x24
    80005f2c:	24850513          	addi	a0,a0,584 # 8002a170 <cons>
    80005f30:	00001097          	auipc	ra,0x1
    80005f34:	900080e7          	jalr	-1792(ra) # 80006830 <release>
        return -1;
    80005f38:	557d                	li	a0,-1
}
    80005f3a:	70e6                	ld	ra,120(sp)
    80005f3c:	7446                	ld	s0,112(sp)
    80005f3e:	74a6                	ld	s1,104(sp)
    80005f40:	7906                	ld	s2,96(sp)
    80005f42:	69e6                	ld	s3,88(sp)
    80005f44:	6a46                	ld	s4,80(sp)
    80005f46:	6aa6                	ld	s5,72(sp)
    80005f48:	6b06                	ld	s6,64(sp)
    80005f4a:	7be2                	ld	s7,56(sp)
    80005f4c:	7c42                	ld	s8,48(sp)
    80005f4e:	7ca2                	ld	s9,40(sp)
    80005f50:	7d02                	ld	s10,32(sp)
    80005f52:	6de2                	ld	s11,24(sp)
    80005f54:	6109                	addi	sp,sp,128
    80005f56:	8082                	ret
      if(n < target){
    80005f58:	000a071b          	sext.w	a4,s4
    80005f5c:	fb777be3          	bgeu	a4,s7,80005f12 <consoleread+0xc0>
        cons.r--;
    80005f60:	00024717          	auipc	a4,0x24
    80005f64:	2af72823          	sw	a5,688(a4) # 8002a210 <cons+0xa0>
    80005f68:	b76d                	j	80005f12 <consoleread+0xc0>

0000000080005f6a <consputc>:
{
    80005f6a:	1141                	addi	sp,sp,-16
    80005f6c:	e406                	sd	ra,8(sp)
    80005f6e:	e022                	sd	s0,0(sp)
    80005f70:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005f72:	10000793          	li	a5,256
    80005f76:	00f50a63          	beq	a0,a5,80005f8a <consputc+0x20>
    uartputc_sync(c);
    80005f7a:	00000097          	auipc	ra,0x0
    80005f7e:	564080e7          	jalr	1380(ra) # 800064de <uartputc_sync>
}
    80005f82:	60a2                	ld	ra,8(sp)
    80005f84:	6402                	ld	s0,0(sp)
    80005f86:	0141                	addi	sp,sp,16
    80005f88:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005f8a:	4521                	li	a0,8
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	552080e7          	jalr	1362(ra) # 800064de <uartputc_sync>
    80005f94:	02000513          	li	a0,32
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	546080e7          	jalr	1350(ra) # 800064de <uartputc_sync>
    80005fa0:	4521                	li	a0,8
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	53c080e7          	jalr	1340(ra) # 800064de <uartputc_sync>
    80005faa:	bfe1                	j	80005f82 <consputc+0x18>

0000000080005fac <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005fac:	1101                	addi	sp,sp,-32
    80005fae:	ec06                	sd	ra,24(sp)
    80005fb0:	e822                	sd	s0,16(sp)
    80005fb2:	e426                	sd	s1,8(sp)
    80005fb4:	e04a                	sd	s2,0(sp)
    80005fb6:	1000                	addi	s0,sp,32
    80005fb8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005fba:	00024517          	auipc	a0,0x24
    80005fbe:	1b650513          	addi	a0,a0,438 # 8002a170 <cons>
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	79e080e7          	jalr	1950(ra) # 80006760 <acquire>

  switch(c){
    80005fca:	47d5                	li	a5,21
    80005fcc:	0af48663          	beq	s1,a5,80006078 <consoleintr+0xcc>
    80005fd0:	0297ca63          	blt	a5,s1,80006004 <consoleintr+0x58>
    80005fd4:	47a1                	li	a5,8
    80005fd6:	0ef48763          	beq	s1,a5,800060c4 <consoleintr+0x118>
    80005fda:	47c1                	li	a5,16
    80005fdc:	10f49a63          	bne	s1,a5,800060f0 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005fe0:	ffffc097          	auipc	ra,0xffffc
    80005fe4:	b1e080e7          	jalr	-1250(ra) # 80001afe <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005fe8:	00024517          	auipc	a0,0x24
    80005fec:	18850513          	addi	a0,a0,392 # 8002a170 <cons>
    80005ff0:	00001097          	auipc	ra,0x1
    80005ff4:	840080e7          	jalr	-1984(ra) # 80006830 <release>
}
    80005ff8:	60e2                	ld	ra,24(sp)
    80005ffa:	6442                	ld	s0,16(sp)
    80005ffc:	64a2                	ld	s1,8(sp)
    80005ffe:	6902                	ld	s2,0(sp)
    80006000:	6105                	addi	sp,sp,32
    80006002:	8082                	ret
  switch(c){
    80006004:	07f00793          	li	a5,127
    80006008:	0af48e63          	beq	s1,a5,800060c4 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000600c:	00024717          	auipc	a4,0x24
    80006010:	16470713          	addi	a4,a4,356 # 8002a170 <cons>
    80006014:	0a872783          	lw	a5,168(a4)
    80006018:	0a072703          	lw	a4,160(a4)
    8000601c:	9f99                	subw	a5,a5,a4
    8000601e:	07f00713          	li	a4,127
    80006022:	fcf763e3          	bltu	a4,a5,80005fe8 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80006026:	47b5                	li	a5,13
    80006028:	0cf48763          	beq	s1,a5,800060f6 <consoleintr+0x14a>
      consputc(c);
    8000602c:	8526                	mv	a0,s1
    8000602e:	00000097          	auipc	ra,0x0
    80006032:	f3c080e7          	jalr	-196(ra) # 80005f6a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006036:	00024797          	auipc	a5,0x24
    8000603a:	13a78793          	addi	a5,a5,314 # 8002a170 <cons>
    8000603e:	0a87a703          	lw	a4,168(a5)
    80006042:	0017069b          	addiw	a3,a4,1
    80006046:	0006861b          	sext.w	a2,a3
    8000604a:	0ad7a423          	sw	a3,168(a5)
    8000604e:	07f77713          	andi	a4,a4,127
    80006052:	97ba                	add	a5,a5,a4
    80006054:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80006058:	47a9                	li	a5,10
    8000605a:	0cf48563          	beq	s1,a5,80006124 <consoleintr+0x178>
    8000605e:	4791                	li	a5,4
    80006060:	0cf48263          	beq	s1,a5,80006124 <consoleintr+0x178>
    80006064:	00024797          	auipc	a5,0x24
    80006068:	1ac7a783          	lw	a5,428(a5) # 8002a210 <cons+0xa0>
    8000606c:	0807879b          	addiw	a5,a5,128
    80006070:	f6f61ce3          	bne	a2,a5,80005fe8 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006074:	863e                	mv	a2,a5
    80006076:	a07d                	j	80006124 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80006078:	00024717          	auipc	a4,0x24
    8000607c:	0f870713          	addi	a4,a4,248 # 8002a170 <cons>
    80006080:	0a872783          	lw	a5,168(a4)
    80006084:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006088:	00024497          	auipc	s1,0x24
    8000608c:	0e848493          	addi	s1,s1,232 # 8002a170 <cons>
    while(cons.e != cons.w &&
    80006090:	4929                	li	s2,10
    80006092:	f4f70be3          	beq	a4,a5,80005fe8 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006096:	37fd                	addiw	a5,a5,-1
    80006098:	07f7f713          	andi	a4,a5,127
    8000609c:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000609e:	02074703          	lbu	a4,32(a4)
    800060a2:	f52703e3          	beq	a4,s2,80005fe8 <consoleintr+0x3c>
      cons.e--;
    800060a6:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    800060aa:	10000513          	li	a0,256
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	ebc080e7          	jalr	-324(ra) # 80005f6a <consputc>
    while(cons.e != cons.w &&
    800060b6:	0a84a783          	lw	a5,168(s1)
    800060ba:	0a44a703          	lw	a4,164(s1)
    800060be:	fcf71ce3          	bne	a4,a5,80006096 <consoleintr+0xea>
    800060c2:	b71d                	j	80005fe8 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800060c4:	00024717          	auipc	a4,0x24
    800060c8:	0ac70713          	addi	a4,a4,172 # 8002a170 <cons>
    800060cc:	0a872783          	lw	a5,168(a4)
    800060d0:	0a472703          	lw	a4,164(a4)
    800060d4:	f0f70ae3          	beq	a4,a5,80005fe8 <consoleintr+0x3c>
      cons.e--;
    800060d8:	37fd                	addiw	a5,a5,-1
    800060da:	00024717          	auipc	a4,0x24
    800060de:	12f72f23          	sw	a5,318(a4) # 8002a218 <cons+0xa8>
      consputc(BACKSPACE);
    800060e2:	10000513          	li	a0,256
    800060e6:	00000097          	auipc	ra,0x0
    800060ea:	e84080e7          	jalr	-380(ra) # 80005f6a <consputc>
    800060ee:	bded                	j	80005fe8 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800060f0:	ee048ce3          	beqz	s1,80005fe8 <consoleintr+0x3c>
    800060f4:	bf21                	j	8000600c <consoleintr+0x60>
      consputc(c);
    800060f6:	4529                	li	a0,10
    800060f8:	00000097          	auipc	ra,0x0
    800060fc:	e72080e7          	jalr	-398(ra) # 80005f6a <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006100:	00024797          	auipc	a5,0x24
    80006104:	07078793          	addi	a5,a5,112 # 8002a170 <cons>
    80006108:	0a87a703          	lw	a4,168(a5)
    8000610c:	0017069b          	addiw	a3,a4,1
    80006110:	0006861b          	sext.w	a2,a3
    80006114:	0ad7a423          	sw	a3,168(a5)
    80006118:	07f77713          	andi	a4,a4,127
    8000611c:	97ba                	add	a5,a5,a4
    8000611e:	4729                	li	a4,10
    80006120:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80006124:	00024797          	auipc	a5,0x24
    80006128:	0ec7a823          	sw	a2,240(a5) # 8002a214 <cons+0xa4>
        wakeup(&cons.r);
    8000612c:	00024517          	auipc	a0,0x24
    80006130:	0e450513          	addi	a0,a0,228 # 8002a210 <cons+0xa0>
    80006134:	ffffb097          	auipc	ra,0xffffb
    80006138:	706080e7          	jalr	1798(ra) # 8000183a <wakeup>
    8000613c:	b575                	j	80005fe8 <consoleintr+0x3c>

000000008000613e <consoleinit>:

void
consoleinit(void)
{
    8000613e:	1141                	addi	sp,sp,-16
    80006140:	e406                	sd	ra,8(sp)
    80006142:	e022                	sd	s0,0(sp)
    80006144:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80006146:	00002597          	auipc	a1,0x2
    8000614a:	6aa58593          	addi	a1,a1,1706 # 800087f0 <digits+0x18>
    8000614e:	00024517          	auipc	a0,0x24
    80006152:	02250513          	addi	a0,a0,34 # 8002a170 <cons>
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	786080e7          	jalr	1926(ra) # 800068dc <initlock>

  uartinit();
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	330080e7          	jalr	816(ra) # 8000648e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80006166:	00017797          	auipc	a5,0x17
    8000616a:	bc278793          	addi	a5,a5,-1086 # 8001cd28 <devsw>
    8000616e:	00000717          	auipc	a4,0x0
    80006172:	ce470713          	addi	a4,a4,-796 # 80005e52 <consoleread>
    80006176:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006178:	00000717          	auipc	a4,0x0
    8000617c:	c7870713          	addi	a4,a4,-904 # 80005df0 <consolewrite>
    80006180:	ef98                	sd	a4,24(a5)
}
    80006182:	60a2                	ld	ra,8(sp)
    80006184:	6402                	ld	s0,0(sp)
    80006186:	0141                	addi	sp,sp,16
    80006188:	8082                	ret

000000008000618a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000618a:	7179                	addi	sp,sp,-48
    8000618c:	f406                	sd	ra,40(sp)
    8000618e:	f022                	sd	s0,32(sp)
    80006190:	ec26                	sd	s1,24(sp)
    80006192:	e84a                	sd	s2,16(sp)
    80006194:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006196:	c219                	beqz	a2,8000619c <printint+0x12>
    80006198:	08054663          	bltz	a0,80006224 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8000619c:	2501                	sext.w	a0,a0
    8000619e:	4881                	li	a7,0
    800061a0:	fd040693          	addi	a3,s0,-48

  i = 0;
    800061a4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800061a6:	2581                	sext.w	a1,a1
    800061a8:	00002617          	auipc	a2,0x2
    800061ac:	66060613          	addi	a2,a2,1632 # 80008808 <digits>
    800061b0:	883a                	mv	a6,a4
    800061b2:	2705                	addiw	a4,a4,1
    800061b4:	02b577bb          	remuw	a5,a0,a1
    800061b8:	1782                	slli	a5,a5,0x20
    800061ba:	9381                	srli	a5,a5,0x20
    800061bc:	97b2                	add	a5,a5,a2
    800061be:	0007c783          	lbu	a5,0(a5)
    800061c2:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800061c6:	0005079b          	sext.w	a5,a0
    800061ca:	02b5553b          	divuw	a0,a0,a1
    800061ce:	0685                	addi	a3,a3,1
    800061d0:	feb7f0e3          	bgeu	a5,a1,800061b0 <printint+0x26>

  if(sign)
    800061d4:	00088b63          	beqz	a7,800061ea <printint+0x60>
    buf[i++] = '-';
    800061d8:	fe040793          	addi	a5,s0,-32
    800061dc:	973e                	add	a4,a4,a5
    800061de:	02d00793          	li	a5,45
    800061e2:	fef70823          	sb	a5,-16(a4)
    800061e6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800061ea:	02e05763          	blez	a4,80006218 <printint+0x8e>
    800061ee:	fd040793          	addi	a5,s0,-48
    800061f2:	00e784b3          	add	s1,a5,a4
    800061f6:	fff78913          	addi	s2,a5,-1
    800061fa:	993a                	add	s2,s2,a4
    800061fc:	377d                	addiw	a4,a4,-1
    800061fe:	1702                	slli	a4,a4,0x20
    80006200:	9301                	srli	a4,a4,0x20
    80006202:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006206:	fff4c503          	lbu	a0,-1(s1)
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	d60080e7          	jalr	-672(ra) # 80005f6a <consputc>
  while(--i >= 0)
    80006212:	14fd                	addi	s1,s1,-1
    80006214:	ff2499e3          	bne	s1,s2,80006206 <printint+0x7c>
}
    80006218:	70a2                	ld	ra,40(sp)
    8000621a:	7402                	ld	s0,32(sp)
    8000621c:	64e2                	ld	s1,24(sp)
    8000621e:	6942                	ld	s2,16(sp)
    80006220:	6145                	addi	sp,sp,48
    80006222:	8082                	ret
    x = -xx;
    80006224:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80006228:	4885                	li	a7,1
    x = -xx;
    8000622a:	bf9d                	j	800061a0 <printint+0x16>

000000008000622c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000622c:	1101                	addi	sp,sp,-32
    8000622e:	ec06                	sd	ra,24(sp)
    80006230:	e822                	sd	s0,16(sp)
    80006232:	e426                	sd	s1,8(sp)
    80006234:	1000                	addi	s0,sp,32
    80006236:	84aa                	mv	s1,a0
  pr.locking = 0;
    80006238:	00024797          	auipc	a5,0x24
    8000623c:	0007a423          	sw	zero,8(a5) # 8002a240 <pr+0x20>
  printf("panic: ");
    80006240:	00002517          	auipc	a0,0x2
    80006244:	5b850513          	addi	a0,a0,1464 # 800087f8 <digits+0x20>
    80006248:	00000097          	auipc	ra,0x0
    8000624c:	02e080e7          	jalr	46(ra) # 80006276 <printf>
  printf(s);
    80006250:	8526                	mv	a0,s1
    80006252:	00000097          	auipc	ra,0x0
    80006256:	024080e7          	jalr	36(ra) # 80006276 <printf>
  printf("\n");
    8000625a:	00002517          	auipc	a0,0x2
    8000625e:	63650513          	addi	a0,a0,1590 # 80008890 <digits+0x88>
    80006262:	00000097          	auipc	ra,0x0
    80006266:	014080e7          	jalr	20(ra) # 80006276 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000626a:	4785                	li	a5,1
    8000626c:	00003717          	auipc	a4,0x3
    80006270:	daf72823          	sw	a5,-592(a4) # 8000901c <panicked>
  for(;;)
    80006274:	a001                	j	80006274 <panic+0x48>

0000000080006276 <printf>:
{
    80006276:	7131                	addi	sp,sp,-192
    80006278:	fc86                	sd	ra,120(sp)
    8000627a:	f8a2                	sd	s0,112(sp)
    8000627c:	f4a6                	sd	s1,104(sp)
    8000627e:	f0ca                	sd	s2,96(sp)
    80006280:	ecce                	sd	s3,88(sp)
    80006282:	e8d2                	sd	s4,80(sp)
    80006284:	e4d6                	sd	s5,72(sp)
    80006286:	e0da                	sd	s6,64(sp)
    80006288:	fc5e                	sd	s7,56(sp)
    8000628a:	f862                	sd	s8,48(sp)
    8000628c:	f466                	sd	s9,40(sp)
    8000628e:	f06a                	sd	s10,32(sp)
    80006290:	ec6e                	sd	s11,24(sp)
    80006292:	0100                	addi	s0,sp,128
    80006294:	8a2a                	mv	s4,a0
    80006296:	e40c                	sd	a1,8(s0)
    80006298:	e810                	sd	a2,16(s0)
    8000629a:	ec14                	sd	a3,24(s0)
    8000629c:	f018                	sd	a4,32(s0)
    8000629e:	f41c                	sd	a5,40(s0)
    800062a0:	03043823          	sd	a6,48(s0)
    800062a4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800062a8:	00024d97          	auipc	s11,0x24
    800062ac:	f98dad83          	lw	s11,-104(s11) # 8002a240 <pr+0x20>
  if(locking)
    800062b0:	020d9b63          	bnez	s11,800062e6 <printf+0x70>
  if (fmt == 0)
    800062b4:	040a0263          	beqz	s4,800062f8 <printf+0x82>
  va_start(ap, fmt);
    800062b8:	00840793          	addi	a5,s0,8
    800062bc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800062c0:	000a4503          	lbu	a0,0(s4)
    800062c4:	16050263          	beqz	a0,80006428 <printf+0x1b2>
    800062c8:	4481                	li	s1,0
    if(c != '%'){
    800062ca:	02500a93          	li	s5,37
    switch(c){
    800062ce:	07000b13          	li	s6,112
  consputc('x');
    800062d2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800062d4:	00002b97          	auipc	s7,0x2
    800062d8:	534b8b93          	addi	s7,s7,1332 # 80008808 <digits>
    switch(c){
    800062dc:	07300c93          	li	s9,115
    800062e0:	06400c13          	li	s8,100
    800062e4:	a82d                	j	8000631e <printf+0xa8>
    acquire(&pr.lock);
    800062e6:	00024517          	auipc	a0,0x24
    800062ea:	f3a50513          	addi	a0,a0,-198 # 8002a220 <pr>
    800062ee:	00000097          	auipc	ra,0x0
    800062f2:	472080e7          	jalr	1138(ra) # 80006760 <acquire>
    800062f6:	bf7d                	j	800062b4 <printf+0x3e>
    panic("null fmt");
    800062f8:	00002517          	auipc	a0,0x2
    800062fc:	4d050513          	addi	a0,a0,1232 # 800087c8 <syscalls+0x3f8>
    80006300:	00000097          	auipc	ra,0x0
    80006304:	f2c080e7          	jalr	-212(ra) # 8000622c <panic>
      consputc(c);
    80006308:	00000097          	auipc	ra,0x0
    8000630c:	c62080e7          	jalr	-926(ra) # 80005f6a <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006310:	2485                	addiw	s1,s1,1
    80006312:	009a07b3          	add	a5,s4,s1
    80006316:	0007c503          	lbu	a0,0(a5)
    8000631a:	10050763          	beqz	a0,80006428 <printf+0x1b2>
    if(c != '%'){
    8000631e:	ff5515e3          	bne	a0,s5,80006308 <printf+0x92>
    c = fmt[++i] & 0xff;
    80006322:	2485                	addiw	s1,s1,1
    80006324:	009a07b3          	add	a5,s4,s1
    80006328:	0007c783          	lbu	a5,0(a5)
    8000632c:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006330:	cfe5                	beqz	a5,80006428 <printf+0x1b2>
    switch(c){
    80006332:	05678a63          	beq	a5,s6,80006386 <printf+0x110>
    80006336:	02fb7663          	bgeu	s6,a5,80006362 <printf+0xec>
    8000633a:	09978963          	beq	a5,s9,800063cc <printf+0x156>
    8000633e:	07800713          	li	a4,120
    80006342:	0ce79863          	bne	a5,a4,80006412 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80006346:	f8843783          	ld	a5,-120(s0)
    8000634a:	00878713          	addi	a4,a5,8
    8000634e:	f8e43423          	sd	a4,-120(s0)
    80006352:	4605                	li	a2,1
    80006354:	85ea                	mv	a1,s10
    80006356:	4388                	lw	a0,0(a5)
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	e32080e7          	jalr	-462(ra) # 8000618a <printint>
      break;
    80006360:	bf45                	j	80006310 <printf+0x9a>
    switch(c){
    80006362:	0b578263          	beq	a5,s5,80006406 <printf+0x190>
    80006366:	0b879663          	bne	a5,s8,80006412 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    8000636a:	f8843783          	ld	a5,-120(s0)
    8000636e:	00878713          	addi	a4,a5,8
    80006372:	f8e43423          	sd	a4,-120(s0)
    80006376:	4605                	li	a2,1
    80006378:	45a9                	li	a1,10
    8000637a:	4388                	lw	a0,0(a5)
    8000637c:	00000097          	auipc	ra,0x0
    80006380:	e0e080e7          	jalr	-498(ra) # 8000618a <printint>
      break;
    80006384:	b771                	j	80006310 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006386:	f8843783          	ld	a5,-120(s0)
    8000638a:	00878713          	addi	a4,a5,8
    8000638e:	f8e43423          	sd	a4,-120(s0)
    80006392:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006396:	03000513          	li	a0,48
    8000639a:	00000097          	auipc	ra,0x0
    8000639e:	bd0080e7          	jalr	-1072(ra) # 80005f6a <consputc>
  consputc('x');
    800063a2:	07800513          	li	a0,120
    800063a6:	00000097          	auipc	ra,0x0
    800063aa:	bc4080e7          	jalr	-1084(ra) # 80005f6a <consputc>
    800063ae:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800063b0:	03c9d793          	srli	a5,s3,0x3c
    800063b4:	97de                	add	a5,a5,s7
    800063b6:	0007c503          	lbu	a0,0(a5)
    800063ba:	00000097          	auipc	ra,0x0
    800063be:	bb0080e7          	jalr	-1104(ra) # 80005f6a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800063c2:	0992                	slli	s3,s3,0x4
    800063c4:	397d                	addiw	s2,s2,-1
    800063c6:	fe0915e3          	bnez	s2,800063b0 <printf+0x13a>
    800063ca:	b799                	j	80006310 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800063cc:	f8843783          	ld	a5,-120(s0)
    800063d0:	00878713          	addi	a4,a5,8
    800063d4:	f8e43423          	sd	a4,-120(s0)
    800063d8:	0007b903          	ld	s2,0(a5)
    800063dc:	00090e63          	beqz	s2,800063f8 <printf+0x182>
      for(; *s; s++)
    800063e0:	00094503          	lbu	a0,0(s2)
    800063e4:	d515                	beqz	a0,80006310 <printf+0x9a>
        consputc(*s);
    800063e6:	00000097          	auipc	ra,0x0
    800063ea:	b84080e7          	jalr	-1148(ra) # 80005f6a <consputc>
      for(; *s; s++)
    800063ee:	0905                	addi	s2,s2,1
    800063f0:	00094503          	lbu	a0,0(s2)
    800063f4:	f96d                	bnez	a0,800063e6 <printf+0x170>
    800063f6:	bf29                	j	80006310 <printf+0x9a>
        s = "(null)";
    800063f8:	00002917          	auipc	s2,0x2
    800063fc:	3c890913          	addi	s2,s2,968 # 800087c0 <syscalls+0x3f0>
      for(; *s; s++)
    80006400:	02800513          	li	a0,40
    80006404:	b7cd                	j	800063e6 <printf+0x170>
      consputc('%');
    80006406:	8556                	mv	a0,s5
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	b62080e7          	jalr	-1182(ra) # 80005f6a <consputc>
      break;
    80006410:	b701                	j	80006310 <printf+0x9a>
      consputc('%');
    80006412:	8556                	mv	a0,s5
    80006414:	00000097          	auipc	ra,0x0
    80006418:	b56080e7          	jalr	-1194(ra) # 80005f6a <consputc>
      consputc(c);
    8000641c:	854a                	mv	a0,s2
    8000641e:	00000097          	auipc	ra,0x0
    80006422:	b4c080e7          	jalr	-1204(ra) # 80005f6a <consputc>
      break;
    80006426:	b5ed                	j	80006310 <printf+0x9a>
  if(locking)
    80006428:	020d9163          	bnez	s11,8000644a <printf+0x1d4>
}
    8000642c:	70e6                	ld	ra,120(sp)
    8000642e:	7446                	ld	s0,112(sp)
    80006430:	74a6                	ld	s1,104(sp)
    80006432:	7906                	ld	s2,96(sp)
    80006434:	69e6                	ld	s3,88(sp)
    80006436:	6a46                	ld	s4,80(sp)
    80006438:	6aa6                	ld	s5,72(sp)
    8000643a:	6b06                	ld	s6,64(sp)
    8000643c:	7be2                	ld	s7,56(sp)
    8000643e:	7c42                	ld	s8,48(sp)
    80006440:	7ca2                	ld	s9,40(sp)
    80006442:	7d02                	ld	s10,32(sp)
    80006444:	6de2                	ld	s11,24(sp)
    80006446:	6129                	addi	sp,sp,192
    80006448:	8082                	ret
    release(&pr.lock);
    8000644a:	00024517          	auipc	a0,0x24
    8000644e:	dd650513          	addi	a0,a0,-554 # 8002a220 <pr>
    80006452:	00000097          	auipc	ra,0x0
    80006456:	3de080e7          	jalr	990(ra) # 80006830 <release>
}
    8000645a:	bfc9                	j	8000642c <printf+0x1b6>

000000008000645c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000645c:	1101                	addi	sp,sp,-32
    8000645e:	ec06                	sd	ra,24(sp)
    80006460:	e822                	sd	s0,16(sp)
    80006462:	e426                	sd	s1,8(sp)
    80006464:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006466:	00024497          	auipc	s1,0x24
    8000646a:	dba48493          	addi	s1,s1,-582 # 8002a220 <pr>
    8000646e:	00002597          	auipc	a1,0x2
    80006472:	39258593          	addi	a1,a1,914 # 80008800 <digits+0x28>
    80006476:	8526                	mv	a0,s1
    80006478:	00000097          	auipc	ra,0x0
    8000647c:	464080e7          	jalr	1124(ra) # 800068dc <initlock>
  pr.locking = 1;
    80006480:	4785                	li	a5,1
    80006482:	d09c                	sw	a5,32(s1)
}
    80006484:	60e2                	ld	ra,24(sp)
    80006486:	6442                	ld	s0,16(sp)
    80006488:	64a2                	ld	s1,8(sp)
    8000648a:	6105                	addi	sp,sp,32
    8000648c:	8082                	ret

000000008000648e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000648e:	1141                	addi	sp,sp,-16
    80006490:	e406                	sd	ra,8(sp)
    80006492:	e022                	sd	s0,0(sp)
    80006494:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006496:	100007b7          	lui	a5,0x10000
    8000649a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000649e:	f8000713          	li	a4,-128
    800064a2:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800064a6:	470d                	li	a4,3
    800064a8:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800064ac:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800064b0:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800064b4:	469d                	li	a3,7
    800064b6:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800064ba:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800064be:	00002597          	auipc	a1,0x2
    800064c2:	36258593          	addi	a1,a1,866 # 80008820 <digits+0x18>
    800064c6:	00024517          	auipc	a0,0x24
    800064ca:	d8250513          	addi	a0,a0,-638 # 8002a248 <uart_tx_lock>
    800064ce:	00000097          	auipc	ra,0x0
    800064d2:	40e080e7          	jalr	1038(ra) # 800068dc <initlock>
}
    800064d6:	60a2                	ld	ra,8(sp)
    800064d8:	6402                	ld	s0,0(sp)
    800064da:	0141                	addi	sp,sp,16
    800064dc:	8082                	ret

00000000800064de <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800064de:	1101                	addi	sp,sp,-32
    800064e0:	ec06                	sd	ra,24(sp)
    800064e2:	e822                	sd	s0,16(sp)
    800064e4:	e426                	sd	s1,8(sp)
    800064e6:	1000                	addi	s0,sp,32
    800064e8:	84aa                	mv	s1,a0
  push_off();
    800064ea:	00000097          	auipc	ra,0x0
    800064ee:	22a080e7          	jalr	554(ra) # 80006714 <push_off>

  if(panicked){
    800064f2:	00003797          	auipc	a5,0x3
    800064f6:	b2a7a783          	lw	a5,-1238(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800064fa:	10000737          	lui	a4,0x10000
  if(panicked){
    800064fe:	c391                	beqz	a5,80006502 <uartputc_sync+0x24>
    for(;;)
    80006500:	a001                	j	80006500 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006502:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006506:	0ff7f793          	andi	a5,a5,255
    8000650a:	0207f793          	andi	a5,a5,32
    8000650e:	dbf5                	beqz	a5,80006502 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006510:	0ff4f793          	andi	a5,s1,255
    80006514:	10000737          	lui	a4,0x10000
    80006518:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000651c:	00000097          	auipc	ra,0x0
    80006520:	2b4080e7          	jalr	692(ra) # 800067d0 <pop_off>
}
    80006524:	60e2                	ld	ra,24(sp)
    80006526:	6442                	ld	s0,16(sp)
    80006528:	64a2                	ld	s1,8(sp)
    8000652a:	6105                	addi	sp,sp,32
    8000652c:	8082                	ret

000000008000652e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000652e:	00003717          	auipc	a4,0x3
    80006532:	af273703          	ld	a4,-1294(a4) # 80009020 <uart_tx_r>
    80006536:	00003797          	auipc	a5,0x3
    8000653a:	af27b783          	ld	a5,-1294(a5) # 80009028 <uart_tx_w>
    8000653e:	06e78c63          	beq	a5,a4,800065b6 <uartstart+0x88>
{
    80006542:	7139                	addi	sp,sp,-64
    80006544:	fc06                	sd	ra,56(sp)
    80006546:	f822                	sd	s0,48(sp)
    80006548:	f426                	sd	s1,40(sp)
    8000654a:	f04a                	sd	s2,32(sp)
    8000654c:	ec4e                	sd	s3,24(sp)
    8000654e:	e852                	sd	s4,16(sp)
    80006550:	e456                	sd	s5,8(sp)
    80006552:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006554:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006558:	00024a17          	auipc	s4,0x24
    8000655c:	cf0a0a13          	addi	s4,s4,-784 # 8002a248 <uart_tx_lock>
    uart_tx_r += 1;
    80006560:	00003497          	auipc	s1,0x3
    80006564:	ac048493          	addi	s1,s1,-1344 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006568:	00003997          	auipc	s3,0x3
    8000656c:	ac098993          	addi	s3,s3,-1344 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006570:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006574:	0ff7f793          	andi	a5,a5,255
    80006578:	0207f793          	andi	a5,a5,32
    8000657c:	c785                	beqz	a5,800065a4 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000657e:	01f77793          	andi	a5,a4,31
    80006582:	97d2                	add	a5,a5,s4
    80006584:	0207ca83          	lbu	s5,32(a5)
    uart_tx_r += 1;
    80006588:	0705                	addi	a4,a4,1
    8000658a:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000658c:	8526                	mv	a0,s1
    8000658e:	ffffb097          	auipc	ra,0xffffb
    80006592:	2ac080e7          	jalr	684(ra) # 8000183a <wakeup>
    
    WriteReg(THR, c);
    80006596:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000659a:	6098                	ld	a4,0(s1)
    8000659c:	0009b783          	ld	a5,0(s3)
    800065a0:	fce798e3          	bne	a5,a4,80006570 <uartstart+0x42>
  }
}
    800065a4:	70e2                	ld	ra,56(sp)
    800065a6:	7442                	ld	s0,48(sp)
    800065a8:	74a2                	ld	s1,40(sp)
    800065aa:	7902                	ld	s2,32(sp)
    800065ac:	69e2                	ld	s3,24(sp)
    800065ae:	6a42                	ld	s4,16(sp)
    800065b0:	6aa2                	ld	s5,8(sp)
    800065b2:	6121                	addi	sp,sp,64
    800065b4:	8082                	ret
    800065b6:	8082                	ret

00000000800065b8 <uartputc>:
{
    800065b8:	7179                	addi	sp,sp,-48
    800065ba:	f406                	sd	ra,40(sp)
    800065bc:	f022                	sd	s0,32(sp)
    800065be:	ec26                	sd	s1,24(sp)
    800065c0:	e84a                	sd	s2,16(sp)
    800065c2:	e44e                	sd	s3,8(sp)
    800065c4:	e052                	sd	s4,0(sp)
    800065c6:	1800                	addi	s0,sp,48
    800065c8:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800065ca:	00024517          	auipc	a0,0x24
    800065ce:	c7e50513          	addi	a0,a0,-898 # 8002a248 <uart_tx_lock>
    800065d2:	00000097          	auipc	ra,0x0
    800065d6:	18e080e7          	jalr	398(ra) # 80006760 <acquire>
  if(panicked){
    800065da:	00003797          	auipc	a5,0x3
    800065de:	a427a783          	lw	a5,-1470(a5) # 8000901c <panicked>
    800065e2:	c391                	beqz	a5,800065e6 <uartputc+0x2e>
    for(;;)
    800065e4:	a001                	j	800065e4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065e6:	00003797          	auipc	a5,0x3
    800065ea:	a427b783          	ld	a5,-1470(a5) # 80009028 <uart_tx_w>
    800065ee:	00003717          	auipc	a4,0x3
    800065f2:	a3273703          	ld	a4,-1486(a4) # 80009020 <uart_tx_r>
    800065f6:	02070713          	addi	a4,a4,32
    800065fa:	02f71b63          	bne	a4,a5,80006630 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800065fe:	00024a17          	auipc	s4,0x24
    80006602:	c4aa0a13          	addi	s4,s4,-950 # 8002a248 <uart_tx_lock>
    80006606:	00003497          	auipc	s1,0x3
    8000660a:	a1a48493          	addi	s1,s1,-1510 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000660e:	00003917          	auipc	s2,0x3
    80006612:	a1a90913          	addi	s2,s2,-1510 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006616:	85d2                	mv	a1,s4
    80006618:	8526                	mv	a0,s1
    8000661a:	ffffb097          	auipc	ra,0xffffb
    8000661e:	094080e7          	jalr	148(ra) # 800016ae <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006622:	00093783          	ld	a5,0(s2)
    80006626:	6098                	ld	a4,0(s1)
    80006628:	02070713          	addi	a4,a4,32
    8000662c:	fef705e3          	beq	a4,a5,80006616 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006630:	00024497          	auipc	s1,0x24
    80006634:	c1848493          	addi	s1,s1,-1000 # 8002a248 <uart_tx_lock>
    80006638:	01f7f713          	andi	a4,a5,31
    8000663c:	9726                	add	a4,a4,s1
    8000663e:	03370023          	sb	s3,32(a4)
      uart_tx_w += 1;
    80006642:	0785                	addi	a5,a5,1
    80006644:	00003717          	auipc	a4,0x3
    80006648:	9ef73223          	sd	a5,-1564(a4) # 80009028 <uart_tx_w>
      uartstart();
    8000664c:	00000097          	auipc	ra,0x0
    80006650:	ee2080e7          	jalr	-286(ra) # 8000652e <uartstart>
      release(&uart_tx_lock);
    80006654:	8526                	mv	a0,s1
    80006656:	00000097          	auipc	ra,0x0
    8000665a:	1da080e7          	jalr	474(ra) # 80006830 <release>
}
    8000665e:	70a2                	ld	ra,40(sp)
    80006660:	7402                	ld	s0,32(sp)
    80006662:	64e2                	ld	s1,24(sp)
    80006664:	6942                	ld	s2,16(sp)
    80006666:	69a2                	ld	s3,8(sp)
    80006668:	6a02                	ld	s4,0(sp)
    8000666a:	6145                	addi	sp,sp,48
    8000666c:	8082                	ret

000000008000666e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000666e:	1141                	addi	sp,sp,-16
    80006670:	e422                	sd	s0,8(sp)
    80006672:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006674:	100007b7          	lui	a5,0x10000
    80006678:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000667c:	8b85                	andi	a5,a5,1
    8000667e:	cb91                	beqz	a5,80006692 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006680:	100007b7          	lui	a5,0x10000
    80006684:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006688:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000668c:	6422                	ld	s0,8(sp)
    8000668e:	0141                	addi	sp,sp,16
    80006690:	8082                	ret
    return -1;
    80006692:	557d                	li	a0,-1
    80006694:	bfe5                	j	8000668c <uartgetc+0x1e>

0000000080006696 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006696:	1101                	addi	sp,sp,-32
    80006698:	ec06                	sd	ra,24(sp)
    8000669a:	e822                	sd	s0,16(sp)
    8000669c:	e426                	sd	s1,8(sp)
    8000669e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800066a0:	54fd                	li	s1,-1
    int c = uartgetc();
    800066a2:	00000097          	auipc	ra,0x0
    800066a6:	fcc080e7          	jalr	-52(ra) # 8000666e <uartgetc>
    if(c == -1)
    800066aa:	00950763          	beq	a0,s1,800066b8 <uartintr+0x22>
      break;
    consoleintr(c);
    800066ae:	00000097          	auipc	ra,0x0
    800066b2:	8fe080e7          	jalr	-1794(ra) # 80005fac <consoleintr>
  while(1){
    800066b6:	b7f5                	j	800066a2 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800066b8:	00024497          	auipc	s1,0x24
    800066bc:	b9048493          	addi	s1,s1,-1136 # 8002a248 <uart_tx_lock>
    800066c0:	8526                	mv	a0,s1
    800066c2:	00000097          	auipc	ra,0x0
    800066c6:	09e080e7          	jalr	158(ra) # 80006760 <acquire>
  uartstart();
    800066ca:	00000097          	auipc	ra,0x0
    800066ce:	e64080e7          	jalr	-412(ra) # 8000652e <uartstart>
  release(&uart_tx_lock);
    800066d2:	8526                	mv	a0,s1
    800066d4:	00000097          	auipc	ra,0x0
    800066d8:	15c080e7          	jalr	348(ra) # 80006830 <release>
}
    800066dc:	60e2                	ld	ra,24(sp)
    800066de:	6442                	ld	s0,16(sp)
    800066e0:	64a2                	ld	s1,8(sp)
    800066e2:	6105                	addi	sp,sp,32
    800066e4:	8082                	ret

00000000800066e6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800066e6:	411c                	lw	a5,0(a0)
    800066e8:	e399                	bnez	a5,800066ee <holding+0x8>
    800066ea:	4501                	li	a0,0
  return r;
}
    800066ec:	8082                	ret
{
    800066ee:	1101                	addi	sp,sp,-32
    800066f0:	ec06                	sd	ra,24(sp)
    800066f2:	e822                	sd	s0,16(sp)
    800066f4:	e426                	sd	s1,8(sp)
    800066f6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800066f8:	6904                	ld	s1,16(a0)
    800066fa:	ffffb097          	auipc	ra,0xffffb
    800066fe:	8dc080e7          	jalr	-1828(ra) # 80000fd6 <mycpu>
    80006702:	40a48533          	sub	a0,s1,a0
    80006706:	00153513          	seqz	a0,a0
}
    8000670a:	60e2                	ld	ra,24(sp)
    8000670c:	6442                	ld	s0,16(sp)
    8000670e:	64a2                	ld	s1,8(sp)
    80006710:	6105                	addi	sp,sp,32
    80006712:	8082                	ret

0000000080006714 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006714:	1101                	addi	sp,sp,-32
    80006716:	ec06                	sd	ra,24(sp)
    80006718:	e822                	sd	s0,16(sp)
    8000671a:	e426                	sd	s1,8(sp)
    8000671c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000671e:	100024f3          	csrr	s1,sstatus
    80006722:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006726:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006728:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000672c:	ffffb097          	auipc	ra,0xffffb
    80006730:	8aa080e7          	jalr	-1878(ra) # 80000fd6 <mycpu>
    80006734:	5d3c                	lw	a5,120(a0)
    80006736:	cf89                	beqz	a5,80006750 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006738:	ffffb097          	auipc	ra,0xffffb
    8000673c:	89e080e7          	jalr	-1890(ra) # 80000fd6 <mycpu>
    80006740:	5d3c                	lw	a5,120(a0)
    80006742:	2785                	addiw	a5,a5,1
    80006744:	dd3c                	sw	a5,120(a0)
}
    80006746:	60e2                	ld	ra,24(sp)
    80006748:	6442                	ld	s0,16(sp)
    8000674a:	64a2                	ld	s1,8(sp)
    8000674c:	6105                	addi	sp,sp,32
    8000674e:	8082                	ret
    mycpu()->intena = old;
    80006750:	ffffb097          	auipc	ra,0xffffb
    80006754:	886080e7          	jalr	-1914(ra) # 80000fd6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006758:	8085                	srli	s1,s1,0x1
    8000675a:	8885                	andi	s1,s1,1
    8000675c:	dd64                	sw	s1,124(a0)
    8000675e:	bfe9                	j	80006738 <push_off+0x24>

0000000080006760 <acquire>:
{
    80006760:	1101                	addi	sp,sp,-32
    80006762:	ec06                	sd	ra,24(sp)
    80006764:	e822                	sd	s0,16(sp)
    80006766:	e426                	sd	s1,8(sp)
    80006768:	1000                	addi	s0,sp,32
    8000676a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000676c:	00000097          	auipc	ra,0x0
    80006770:	fa8080e7          	jalr	-88(ra) # 80006714 <push_off>
  if(holding(lk))
    80006774:	8526                	mv	a0,s1
    80006776:	00000097          	auipc	ra,0x0
    8000677a:	f70080e7          	jalr	-144(ra) # 800066e6 <holding>
    8000677e:	e911                	bnez	a0,80006792 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    80006780:	4785                	li	a5,1
    80006782:	01c48713          	addi	a4,s1,28
    80006786:	0f50000f          	fence	iorw,ow
    8000678a:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000678e:	4705                	li	a4,1
    80006790:	a839                	j	800067ae <acquire+0x4e>
    panic("acquire");
    80006792:	00002517          	auipc	a0,0x2
    80006796:	09650513          	addi	a0,a0,150 # 80008828 <digits+0x20>
    8000679a:	00000097          	auipc	ra,0x0
    8000679e:	a92080e7          	jalr	-1390(ra) # 8000622c <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    800067a2:	01848793          	addi	a5,s1,24
    800067a6:	0f50000f          	fence	iorw,ow
    800067aa:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    800067ae:	87ba                	mv	a5,a4
    800067b0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800067b4:	2781                	sext.w	a5,a5
    800067b6:	f7f5                	bnez	a5,800067a2 <acquire+0x42>
  __sync_synchronize();
    800067b8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800067bc:	ffffb097          	auipc	ra,0xffffb
    800067c0:	81a080e7          	jalr	-2022(ra) # 80000fd6 <mycpu>
    800067c4:	e888                	sd	a0,16(s1)
}
    800067c6:	60e2                	ld	ra,24(sp)
    800067c8:	6442                	ld	s0,16(sp)
    800067ca:	64a2                	ld	s1,8(sp)
    800067cc:	6105                	addi	sp,sp,32
    800067ce:	8082                	ret

00000000800067d0 <pop_off>:

void
pop_off(void)
{
    800067d0:	1141                	addi	sp,sp,-16
    800067d2:	e406                	sd	ra,8(sp)
    800067d4:	e022                	sd	s0,0(sp)
    800067d6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800067d8:	ffffa097          	auipc	ra,0xffffa
    800067dc:	7fe080e7          	jalr	2046(ra) # 80000fd6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800067e4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800067e6:	e78d                	bnez	a5,80006810 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800067e8:	5d3c                	lw	a5,120(a0)
    800067ea:	02f05b63          	blez	a5,80006820 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800067ee:	37fd                	addiw	a5,a5,-1
    800067f0:	0007871b          	sext.w	a4,a5
    800067f4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800067f6:	eb09                	bnez	a4,80006808 <pop_off+0x38>
    800067f8:	5d7c                	lw	a5,124(a0)
    800067fa:	c799                	beqz	a5,80006808 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800067fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006800:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006804:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006808:	60a2                	ld	ra,8(sp)
    8000680a:	6402                	ld	s0,0(sp)
    8000680c:	0141                	addi	sp,sp,16
    8000680e:	8082                	ret
    panic("pop_off - interruptible");
    80006810:	00002517          	auipc	a0,0x2
    80006814:	02050513          	addi	a0,a0,32 # 80008830 <digits+0x28>
    80006818:	00000097          	auipc	ra,0x0
    8000681c:	a14080e7          	jalr	-1516(ra) # 8000622c <panic>
    panic("pop_off");
    80006820:	00002517          	auipc	a0,0x2
    80006824:	02850513          	addi	a0,a0,40 # 80008848 <digits+0x40>
    80006828:	00000097          	auipc	ra,0x0
    8000682c:	a04080e7          	jalr	-1532(ra) # 8000622c <panic>

0000000080006830 <release>:
{
    80006830:	1101                	addi	sp,sp,-32
    80006832:	ec06                	sd	ra,24(sp)
    80006834:	e822                	sd	s0,16(sp)
    80006836:	e426                	sd	s1,8(sp)
    80006838:	1000                	addi	s0,sp,32
    8000683a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000683c:	00000097          	auipc	ra,0x0
    80006840:	eaa080e7          	jalr	-342(ra) # 800066e6 <holding>
    80006844:	c115                	beqz	a0,80006868 <release+0x38>
  lk->cpu = 0;
    80006846:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000684a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000684e:	0f50000f          	fence	iorw,ow
    80006852:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006856:	00000097          	auipc	ra,0x0
    8000685a:	f7a080e7          	jalr	-134(ra) # 800067d0 <pop_off>
}
    8000685e:	60e2                	ld	ra,24(sp)
    80006860:	6442                	ld	s0,16(sp)
    80006862:	64a2                	ld	s1,8(sp)
    80006864:	6105                	addi	sp,sp,32
    80006866:	8082                	ret
    panic("release");
    80006868:	00002517          	auipc	a0,0x2
    8000686c:	fe850513          	addi	a0,a0,-24 # 80008850 <digits+0x48>
    80006870:	00000097          	auipc	ra,0x0
    80006874:	9bc080e7          	jalr	-1604(ra) # 8000622c <panic>

0000000080006878 <freelock>:
{
    80006878:	1101                	addi	sp,sp,-32
    8000687a:	ec06                	sd	ra,24(sp)
    8000687c:	e822                	sd	s0,16(sp)
    8000687e:	e426                	sd	s1,8(sp)
    80006880:	1000                	addi	s0,sp,32
    80006882:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    80006884:	00024517          	auipc	a0,0x24
    80006888:	a0450513          	addi	a0,a0,-1532 # 8002a288 <lock_locks>
    8000688c:	00000097          	auipc	ra,0x0
    80006890:	ed4080e7          	jalr	-300(ra) # 80006760 <acquire>
  for (i = 0; i < NLOCK; i++) {
    80006894:	00024717          	auipc	a4,0x24
    80006898:	a1470713          	addi	a4,a4,-1516 # 8002a2a8 <locks>
    8000689c:	4781                	li	a5,0
    8000689e:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    800068a2:	6314                	ld	a3,0(a4)
    800068a4:	00968763          	beq	a3,s1,800068b2 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    800068a8:	2785                	addiw	a5,a5,1
    800068aa:	0721                	addi	a4,a4,8
    800068ac:	fec79be3          	bne	a5,a2,800068a2 <freelock+0x2a>
    800068b0:	a809                	j	800068c2 <freelock+0x4a>
      locks[i] = 0;
    800068b2:	078e                	slli	a5,a5,0x3
    800068b4:	00024717          	auipc	a4,0x24
    800068b8:	9f470713          	addi	a4,a4,-1548 # 8002a2a8 <locks>
    800068bc:	97ba                	add	a5,a5,a4
    800068be:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    800068c2:	00024517          	auipc	a0,0x24
    800068c6:	9c650513          	addi	a0,a0,-1594 # 8002a288 <lock_locks>
    800068ca:	00000097          	auipc	ra,0x0
    800068ce:	f66080e7          	jalr	-154(ra) # 80006830 <release>
}
    800068d2:	60e2                	ld	ra,24(sp)
    800068d4:	6442                	ld	s0,16(sp)
    800068d6:	64a2                	ld	s1,8(sp)
    800068d8:	6105                	addi	sp,sp,32
    800068da:	8082                	ret

00000000800068dc <initlock>:
{
    800068dc:	1101                	addi	sp,sp,-32
    800068de:	ec06                	sd	ra,24(sp)
    800068e0:	e822                	sd	s0,16(sp)
    800068e2:	e426                	sd	s1,8(sp)
    800068e4:	1000                	addi	s0,sp,32
    800068e6:	84aa                	mv	s1,a0
  lk->name = name;
    800068e8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800068ea:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800068ee:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    800068f2:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    800068f6:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    800068fa:	00024517          	auipc	a0,0x24
    800068fe:	98e50513          	addi	a0,a0,-1650 # 8002a288 <lock_locks>
    80006902:	00000097          	auipc	ra,0x0
    80006906:	e5e080e7          	jalr	-418(ra) # 80006760 <acquire>
  for (i = 0; i < NLOCK; i++) {
    8000690a:	00024717          	auipc	a4,0x24
    8000690e:	99e70713          	addi	a4,a4,-1634 # 8002a2a8 <locks>
    80006912:	4781                	li	a5,0
    80006914:	1f400693          	li	a3,500
    if(locks[i] == 0) {
    80006918:	6310                	ld	a2,0(a4)
    8000691a:	ce09                	beqz	a2,80006934 <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    8000691c:	2785                	addiw	a5,a5,1
    8000691e:	0721                	addi	a4,a4,8
    80006920:	fed79ce3          	bne	a5,a3,80006918 <initlock+0x3c>
  panic("findslot");
    80006924:	00002517          	auipc	a0,0x2
    80006928:	f3450513          	addi	a0,a0,-204 # 80008858 <digits+0x50>
    8000692c:	00000097          	auipc	ra,0x0
    80006930:	900080e7          	jalr	-1792(ra) # 8000622c <panic>
      locks[i] = lk;
    80006934:	078e                	slli	a5,a5,0x3
    80006936:	00024717          	auipc	a4,0x24
    8000693a:	97270713          	addi	a4,a4,-1678 # 8002a2a8 <locks>
    8000693e:	97ba                	add	a5,a5,a4
    80006940:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80006942:	00024517          	auipc	a0,0x24
    80006946:	94650513          	addi	a0,a0,-1722 # 8002a288 <lock_locks>
    8000694a:	00000097          	auipc	ra,0x0
    8000694e:	ee6080e7          	jalr	-282(ra) # 80006830 <release>
}
    80006952:	60e2                	ld	ra,24(sp)
    80006954:	6442                	ld	s0,16(sp)
    80006956:	64a2                	ld	s1,8(sp)
    80006958:	6105                	addi	sp,sp,32
    8000695a:	8082                	ret

000000008000695c <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    8000695c:	1141                	addi	sp,sp,-16
    8000695e:	e422                	sd	s0,8(sp)
    80006960:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006962:	0ff0000f          	fence
    80006966:	6108                	ld	a0,0(a0)
    80006968:	0ff0000f          	fence
  return val;
}
    8000696c:	6422                	ld	s0,8(sp)
    8000696e:	0141                	addi	sp,sp,16
    80006970:	8082                	ret

0000000080006972 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80006972:	1141                	addi	sp,sp,-16
    80006974:	e422                	sd	s0,8(sp)
    80006976:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006978:	0ff0000f          	fence
    8000697c:	4108                	lw	a0,0(a0)
    8000697e:	0ff0000f          	fence
  return val;
}
    80006982:	2501                	sext.w	a0,a0
    80006984:	6422                	ld	s0,8(sp)
    80006986:	0141                	addi	sp,sp,16
    80006988:	8082                	ret

000000008000698a <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    8000698a:	4e5c                	lw	a5,28(a2)
    8000698c:	00f04463          	bgtz	a5,80006994 <snprint_lock+0xa>
  int n = 0;
    80006990:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    80006992:	8082                	ret
{
    80006994:	1141                	addi	sp,sp,-16
    80006996:	e406                	sd	ra,8(sp)
    80006998:	e022                	sd	s0,0(sp)
    8000699a:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    8000699c:	4e18                	lw	a4,24(a2)
    8000699e:	6614                	ld	a3,8(a2)
    800069a0:	00002617          	auipc	a2,0x2
    800069a4:	ec860613          	addi	a2,a2,-312 # 80008868 <digits+0x60>
    800069a8:	fffff097          	auipc	ra,0xfffff
    800069ac:	1ea080e7          	jalr	490(ra) # 80005b92 <snprintf>
}
    800069b0:	60a2                	ld	ra,8(sp)
    800069b2:	6402                	ld	s0,0(sp)
    800069b4:	0141                	addi	sp,sp,16
    800069b6:	8082                	ret

00000000800069b8 <statslock>:

int
statslock(char *buf, int sz) {
    800069b8:	7159                	addi	sp,sp,-112
    800069ba:	f486                	sd	ra,104(sp)
    800069bc:	f0a2                	sd	s0,96(sp)
    800069be:	eca6                	sd	s1,88(sp)
    800069c0:	e8ca                	sd	s2,80(sp)
    800069c2:	e4ce                	sd	s3,72(sp)
    800069c4:	e0d2                	sd	s4,64(sp)
    800069c6:	fc56                	sd	s5,56(sp)
    800069c8:	f85a                	sd	s6,48(sp)
    800069ca:	f45e                	sd	s7,40(sp)
    800069cc:	f062                	sd	s8,32(sp)
    800069ce:	ec66                	sd	s9,24(sp)
    800069d0:	e86a                	sd	s10,16(sp)
    800069d2:	e46e                	sd	s11,8(sp)
    800069d4:	1880                	addi	s0,sp,112
    800069d6:	8aaa                	mv	s5,a0
    800069d8:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    800069da:	00024517          	auipc	a0,0x24
    800069de:	8ae50513          	addi	a0,a0,-1874 # 8002a288 <lock_locks>
    800069e2:	00000097          	auipc	ra,0x0
    800069e6:	d7e080e7          	jalr	-642(ra) # 80006760 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800069ea:	00002617          	auipc	a2,0x2
    800069ee:	eae60613          	addi	a2,a2,-338 # 80008898 <digits+0x90>
    800069f2:	85da                	mv	a1,s6
    800069f4:	8556                	mv	a0,s5
    800069f6:	fffff097          	auipc	ra,0xfffff
    800069fa:	19c080e7          	jalr	412(ra) # 80005b92 <snprintf>
    800069fe:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    80006a00:	00024c97          	auipc	s9,0x24
    80006a04:	8a8c8c93          	addi	s9,s9,-1880 # 8002a2a8 <locks>
    80006a08:	00025c17          	auipc	s8,0x25
    80006a0c:	840c0c13          	addi	s8,s8,-1984 # 8002b248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    80006a10:	84e6                	mv	s1,s9
  int tot = 0;
    80006a12:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a14:	00002b97          	auipc	s7,0x2
    80006a18:	a6cb8b93          	addi	s7,s7,-1428 # 80008480 <syscalls+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a1c:	00002d17          	auipc	s10,0x2
    80006a20:	e9cd0d13          	addi	s10,s10,-356 # 800088b8 <digits+0xb0>
    80006a24:	a01d                	j	80006a4a <statslock+0x92>
      tot += locks[i]->nts;
    80006a26:	0009b603          	ld	a2,0(s3)
    80006a2a:	4e1c                	lw	a5,24(a2)
    80006a2c:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    80006a30:	412b05bb          	subw	a1,s6,s2
    80006a34:	012a8533          	add	a0,s5,s2
    80006a38:	00000097          	auipc	ra,0x0
    80006a3c:	f52080e7          	jalr	-174(ra) # 8000698a <snprint_lock>
    80006a40:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    80006a44:	04a1                	addi	s1,s1,8
    80006a46:	05848763          	beq	s1,s8,80006a94 <statslock+0xdc>
    if(locks[i] == 0)
    80006a4a:	89a6                	mv	s3,s1
    80006a4c:	609c                	ld	a5,0(s1)
    80006a4e:	c3b9                	beqz	a5,80006a94 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a50:	0087bd83          	ld	s11,8(a5)
    80006a54:	855e                	mv	a0,s7
    80006a56:	ffffa097          	auipc	ra,0xffffa
    80006a5a:	a40080e7          	jalr	-1472(ra) # 80000496 <strlen>
    80006a5e:	0005061b          	sext.w	a2,a0
    80006a62:	85de                	mv	a1,s7
    80006a64:	856e                	mv	a0,s11
    80006a66:	ffffa097          	auipc	ra,0xffffa
    80006a6a:	984080e7          	jalr	-1660(ra) # 800003ea <strncmp>
    80006a6e:	dd45                	beqz	a0,80006a26 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a70:	609c                	ld	a5,0(s1)
    80006a72:	0087bd83          	ld	s11,8(a5)
    80006a76:	856a                	mv	a0,s10
    80006a78:	ffffa097          	auipc	ra,0xffffa
    80006a7c:	a1e080e7          	jalr	-1506(ra) # 80000496 <strlen>
    80006a80:	0005061b          	sext.w	a2,a0
    80006a84:	85ea                	mv	a1,s10
    80006a86:	856e                	mv	a0,s11
    80006a88:	ffffa097          	auipc	ra,0xffffa
    80006a8c:	962080e7          	jalr	-1694(ra) # 800003ea <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a90:	f955                	bnez	a0,80006a44 <statslock+0x8c>
    80006a92:	bf51                	j	80006a26 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    80006a94:	00002617          	auipc	a2,0x2
    80006a98:	e2c60613          	addi	a2,a2,-468 # 800088c0 <digits+0xb8>
    80006a9c:	412b05bb          	subw	a1,s6,s2
    80006aa0:	012a8533          	add	a0,s5,s2
    80006aa4:	fffff097          	auipc	ra,0xfffff
    80006aa8:	0ee080e7          	jalr	238(ra) # 80005b92 <snprintf>
    80006aac:	012509bb          	addw	s3,a0,s2
    80006ab0:	4b95                	li	s7,5
  int last = 100000000;
    80006ab2:	05f5e537          	lui	a0,0x5f5e
    80006ab6:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80006aba:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006abc:	00023497          	auipc	s1,0x23
    80006ac0:	7ec48493          	addi	s1,s1,2028 # 8002a2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006ac4:	1f400913          	li	s2,500
    80006ac8:	a881                	j	80006b18 <statslock+0x160>
    80006aca:	2705                	addiw	a4,a4,1
    80006acc:	06a1                	addi	a3,a3,8
    80006ace:	03270063          	beq	a4,s2,80006aee <statslock+0x136>
      if(locks[i] == 0)
    80006ad2:	629c                	ld	a5,0(a3)
    80006ad4:	cf89                	beqz	a5,80006aee <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006ad6:	4f90                	lw	a2,24(a5)
    80006ad8:	00359793          	slli	a5,a1,0x3
    80006adc:	97a6                	add	a5,a5,s1
    80006ade:	639c                	ld	a5,0(a5)
    80006ae0:	4f9c                	lw	a5,24(a5)
    80006ae2:	fec7d4e3          	bge	a5,a2,80006aca <statslock+0x112>
    80006ae6:	fea652e3          	bge	a2,a0,80006aca <statslock+0x112>
    80006aea:	85ba                	mv	a1,a4
    80006aec:	bff9                	j	80006aca <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    80006aee:	058e                	slli	a1,a1,0x3
    80006af0:	00b48d33          	add	s10,s1,a1
    80006af4:	000d3603          	ld	a2,0(s10)
    80006af8:	413b05bb          	subw	a1,s6,s3
    80006afc:	013a8533          	add	a0,s5,s3
    80006b00:	00000097          	auipc	ra,0x0
    80006b04:	e8a080e7          	jalr	-374(ra) # 8000698a <snprint_lock>
    80006b08:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    80006b0c:	000d3783          	ld	a5,0(s10)
    80006b10:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006b12:	3bfd                	addiw	s7,s7,-1
    80006b14:	000b8663          	beqz	s7,80006b20 <statslock+0x168>
  int tot = 0;
    80006b18:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006b1a:	8762                	mv	a4,s8
    int top = 0;
    80006b1c:	85e2                	mv	a1,s8
    80006b1e:	bf55                	j	80006ad2 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006b20:	86d2                	mv	a3,s4
    80006b22:	00002617          	auipc	a2,0x2
    80006b26:	dbe60613          	addi	a2,a2,-578 # 800088e0 <digits+0xd8>
    80006b2a:	413b05bb          	subw	a1,s6,s3
    80006b2e:	013a8533          	add	a0,s5,s3
    80006b32:	fffff097          	auipc	ra,0xfffff
    80006b36:	060080e7          	jalr	96(ra) # 80005b92 <snprintf>
    80006b3a:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    80006b3e:	00023517          	auipc	a0,0x23
    80006b42:	74a50513          	addi	a0,a0,1866 # 8002a288 <lock_locks>
    80006b46:	00000097          	auipc	ra,0x0
    80006b4a:	cea080e7          	jalr	-790(ra) # 80006830 <release>
  return n;
}
    80006b4e:	854e                	mv	a0,s3
    80006b50:	70a6                	ld	ra,104(sp)
    80006b52:	7406                	ld	s0,96(sp)
    80006b54:	64e6                	ld	s1,88(sp)
    80006b56:	6946                	ld	s2,80(sp)
    80006b58:	69a6                	ld	s3,72(sp)
    80006b5a:	6a06                	ld	s4,64(sp)
    80006b5c:	7ae2                	ld	s5,56(sp)
    80006b5e:	7b42                	ld	s6,48(sp)
    80006b60:	7ba2                	ld	s7,40(sp)
    80006b62:	7c02                	ld	s8,32(sp)
    80006b64:	6ce2                	ld	s9,24(sp)
    80006b66:	6d42                	ld	s10,16(sp)
    80006b68:	6da2                	ld	s11,8(sp)
    80006b6a:	6165                	addi	sp,sp,112
    80006b6c:	8082                	ret
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
