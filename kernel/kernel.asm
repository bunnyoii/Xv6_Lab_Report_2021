
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8d013103          	ld	sp,-1840(sp) # 800088d0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	163050ef          	jal	ra,80005978 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <get_mem_count>:
    kmem.freelist = r;
    release(&kmem.lock);
  }
}

int get_mem_count(uint64 pa){
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	1000                	addi	s0,sp,32
    80000026:	84aa                	mv	s1,a0
    int count; 
    acquire(&mem_ref_struct.lock);
    80000028:	00009517          	auipc	a0,0x9
    8000002c:	02850513          	addi	a0,a0,40 # 80009050 <mem_ref_struct>
    80000030:	00006097          	auipc	ra,0x6
    80000034:	342080e7          	jalr	834(ra) # 80006372 <acquire>
    count = mem_ref_struct.mem_count[(uint64)pa / PGSIZE];
    80000038:	00009517          	auipc	a0,0x9
    8000003c:	01850513          	addi	a0,a0,24 # 80009050 <mem_ref_struct>
    80000040:	80b1                	srli	s1,s1,0xc
    80000042:	0491                	addi	s1,s1,4
    80000044:	048a                	slli	s1,s1,0x2
    80000046:	94aa                	add	s1,s1,a0
    80000048:	4484                	lw	s1,8(s1)
    release(&mem_ref_struct.lock);
    8000004a:	00006097          	auipc	ra,0x6
    8000004e:	3dc080e7          	jalr	988(ra) # 80006426 <release>
    return count;
}
    80000052:	8526                	mv	a0,s1
    80000054:	60e2                	ld	ra,24(sp)
    80000056:	6442                	ld	s0,16(sp)
    80000058:	64a2                	ld	s1,8(sp)
    8000005a:	6105                	addi	sp,sp,32
    8000005c:	8082                	ret

000000008000005e <mem_count_up>:
void mem_count_up(uint64 pa){
    8000005e:	1101                	addi	sp,sp,-32
    80000060:	ec06                	sd	ra,24(sp)
    80000062:	e822                	sd	s0,16(sp)
    80000064:	e426                	sd	s1,8(sp)
    80000066:	1000                	addi	s0,sp,32
    80000068:	84aa                	mv	s1,a0
    acquire(&mem_ref_struct.lock);
    8000006a:	00009517          	auipc	a0,0x9
    8000006e:	fe650513          	addi	a0,a0,-26 # 80009050 <mem_ref_struct>
    80000072:	00006097          	auipc	ra,0x6
    80000076:	300080e7          	jalr	768(ra) # 80006372 <acquire>
    ++ mem_ref_struct.mem_count[(uint64)pa / PGSIZE];
    8000007a:	00c4d793          	srli	a5,s1,0xc
    8000007e:	00009517          	auipc	a0,0x9
    80000082:	fd250513          	addi	a0,a0,-46 # 80009050 <mem_ref_struct>
    80000086:	0791                	addi	a5,a5,4
    80000088:	078a                	slli	a5,a5,0x2
    8000008a:	97aa                	add	a5,a5,a0
    8000008c:	4798                	lw	a4,8(a5)
    8000008e:	2705                	addiw	a4,a4,1
    80000090:	c798                	sw	a4,8(a5)
    release(&mem_ref_struct.lock);
    80000092:	00006097          	auipc	ra,0x6
    80000096:	394080e7          	jalr	916(ra) # 80006426 <release>
}
    8000009a:	60e2                	ld	ra,24(sp)
    8000009c:	6442                	ld	s0,16(sp)
    8000009e:	64a2                	ld	s1,8(sp)
    800000a0:	6105                	addi	sp,sp,32
    800000a2:	8082                	ret

00000000800000a4 <mem_count_down>:

int mem_count_down(uint64 pa){
    800000a4:	1101                	addi	sp,sp,-32
    800000a6:	ec06                	sd	ra,24(sp)
    800000a8:	e822                	sd	s0,16(sp)
    800000aa:	e426                	sd	s1,8(sp)
    800000ac:	1000                	addi	s0,sp,32
    800000ae:	84aa                	mv	s1,a0
    int flag = 0;
    acquire(&mem_ref_struct.lock);
    800000b0:	00009517          	auipc	a0,0x9
    800000b4:	fa050513          	addi	a0,a0,-96 # 80009050 <mem_ref_struct>
    800000b8:	00006097          	auipc	ra,0x6
    800000bc:	2ba080e7          	jalr	698(ra) # 80006372 <acquire>
    if((-- mem_ref_struct.mem_count[(uint64)pa / PGSIZE]) == 0){
    800000c0:	00c4d793          	srli	a5,s1,0xc
    800000c4:	00009517          	auipc	a0,0x9
    800000c8:	f8c50513          	addi	a0,a0,-116 # 80009050 <mem_ref_struct>
    800000cc:	0791                	addi	a5,a5,4
    800000ce:	078a                	slli	a5,a5,0x2
    800000d0:	97aa                	add	a5,a5,a0
    800000d2:	4798                	lw	a4,8(a5)
    800000d4:	377d                	addiw	a4,a4,-1
    800000d6:	0007049b          	sext.w	s1,a4
    800000da:	c798                	sw	a4,8(a5)
        flag = 1;
    }
    release(&mem_ref_struct.lock);
    800000dc:	00006097          	auipc	ra,0x6
    800000e0:	34a080e7          	jalr	842(ra) # 80006426 <release>
    return flag;
}
    800000e4:	0014b513          	seqz	a0,s1
    800000e8:	60e2                	ld	ra,24(sp)
    800000ea:	6442                	ld	s0,16(sp)
    800000ec:	64a2                	ld	s1,8(sp)
    800000ee:	6105                	addi	sp,sp,32
    800000f0:	8082                	ret

00000000800000f2 <kfree>:
{
    800000f2:	1101                	addi	sp,sp,-32
    800000f4:	ec06                	sd	ra,24(sp)
    800000f6:	e822                	sd	s0,16(sp)
    800000f8:	e426                	sd	s1,8(sp)
    800000fa:	e04a                	sd	s2,0(sp)
    800000fc:	1000                	addi	s0,sp,32
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800000fe:	03451793          	slli	a5,a0,0x34
    80000102:	eb8d                	bnez	a5,80000134 <kfree+0x42>
    80000104:	84aa                	mv	s1,a0
    80000106:	00246797          	auipc	a5,0x246
    8000010a:	13a78793          	addi	a5,a5,314 # 80246240 <end>
    8000010e:	02f56363          	bltu	a0,a5,80000134 <kfree+0x42>
    80000112:	47c5                	li	a5,17
    80000114:	07ee                	slli	a5,a5,0x1b
    80000116:	00f57f63          	bgeu	a0,a5,80000134 <kfree+0x42>
  if(mem_count_down((uint64)pa) == 1){
    8000011a:	00000097          	auipc	ra,0x0
    8000011e:	f8a080e7          	jalr	-118(ra) # 800000a4 <mem_count_down>
    80000122:	4785                	li	a5,1
    80000124:	02f50063          	beq	a0,a5,80000144 <kfree+0x52>
}
    80000128:	60e2                	ld	ra,24(sp)
    8000012a:	6442                	ld	s0,16(sp)
    8000012c:	64a2                	ld	s1,8(sp)
    8000012e:	6902                	ld	s2,0(sp)
    80000130:	6105                	addi	sp,sp,32
    80000132:	8082                	ret
    panic("kfree");
    80000134:	00008517          	auipc	a0,0x8
    80000138:	edc50513          	addi	a0,a0,-292 # 80008010 <etext+0x10>
    8000013c:	00006097          	auipc	ra,0x6
    80000140:	cec080e7          	jalr	-788(ra) # 80005e28 <panic>
    memset(pa, 1, PGSIZE);
    80000144:	6605                	lui	a2,0x1
    80000146:	4585                	li	a1,1
    80000148:	8526                	mv	a0,s1
    8000014a:	00000097          	auipc	ra,0x0
    8000014e:	18e080e7          	jalr	398(ra) # 800002d8 <memset>
    acquire(&kmem.lock);
    80000152:	00009917          	auipc	s2,0x9
    80000156:	ede90913          	addi	s2,s2,-290 # 80009030 <kmem>
    8000015a:	854a                	mv	a0,s2
    8000015c:	00006097          	auipc	ra,0x6
    80000160:	216080e7          	jalr	534(ra) # 80006372 <acquire>
    r->next = kmem.freelist;
    80000164:	01893783          	ld	a5,24(s2)
    80000168:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    8000016a:	00993c23          	sd	s1,24(s2)
    release(&kmem.lock);
    8000016e:	854a                	mv	a0,s2
    80000170:	00006097          	auipc	ra,0x6
    80000174:	2b6080e7          	jalr	694(ra) # 80006426 <release>
}
    80000178:	bf45                	j	80000128 <kfree+0x36>

000000008000017a <mem_count_set_one>:

void mem_count_set_one(uint64 pa){
    8000017a:	1101                	addi	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	addi	s0,sp,32
    80000184:	84aa                	mv	s1,a0
    acquire(&mem_ref_struct.lock);
    80000186:	00009517          	auipc	a0,0x9
    8000018a:	eca50513          	addi	a0,a0,-310 # 80009050 <mem_ref_struct>
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	1e4080e7          	jalr	484(ra) # 80006372 <acquire>
    mem_ref_struct.mem_count[(uint64)pa / PGSIZE] = 1;
    80000196:	00009517          	auipc	a0,0x9
    8000019a:	eba50513          	addi	a0,a0,-326 # 80009050 <mem_ref_struct>
    8000019e:	80b1                	srli	s1,s1,0xc
    800001a0:	0491                	addi	s1,s1,4
    800001a2:	048a                	slli	s1,s1,0x2
    800001a4:	94aa                	add	s1,s1,a0
    800001a6:	4785                	li	a5,1
    800001a8:	c49c                	sw	a5,8(s1)
    release(&mem_ref_struct.lock);
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	27c080e7          	jalr	636(ra) # 80006426 <release>
    800001b2:	60e2                	ld	ra,24(sp)
    800001b4:	6442                	ld	s0,16(sp)
    800001b6:	64a2                	ld	s1,8(sp)
    800001b8:	6105                	addi	sp,sp,32
    800001ba:	8082                	ret

00000000800001bc <freerange>:
{
    800001bc:	7179                	addi	sp,sp,-48
    800001be:	f406                	sd	ra,40(sp)
    800001c0:	f022                	sd	s0,32(sp)
    800001c2:	ec26                	sd	s1,24(sp)
    800001c4:	e84a                	sd	s2,16(sp)
    800001c6:	e44e                	sd	s3,8(sp)
    800001c8:	e052                	sd	s4,0(sp)
    800001ca:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800001cc:	6785                	lui	a5,0x1
    800001ce:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800001d2:	9526                	add	a0,a0,s1
    800001d4:	74fd                	lui	s1,0xfffff
    800001d6:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    800001d8:	97a6                	add	a5,a5,s1
    800001da:	02f5e463          	bltu	a1,a5,80000202 <freerange+0x46>
    800001de:	892e                	mv	s2,a1
    800001e0:	6a05                	lui	s4,0x1
    800001e2:	6989                	lui	s3,0x2
    mem_count_set_one((uint64)p);
    800001e4:	8526                	mv	a0,s1
    800001e6:	00000097          	auipc	ra,0x0
    800001ea:	f94080e7          	jalr	-108(ra) # 8000017a <mem_count_set_one>
    kfree(p);
    800001ee:	8526                	mv	a0,s1
    800001f0:	00000097          	auipc	ra,0x0
    800001f4:	f02080e7          	jalr	-254(ra) # 800000f2 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE){
    800001f8:	87a6                	mv	a5,s1
    800001fa:	94d2                	add	s1,s1,s4
    800001fc:	97ce                	add	a5,a5,s3
    800001fe:	fef973e3          	bgeu	s2,a5,800001e4 <freerange+0x28>
}
    80000202:	70a2                	ld	ra,40(sp)
    80000204:	7402                	ld	s0,32(sp)
    80000206:	64e2                	ld	s1,24(sp)
    80000208:	6942                	ld	s2,16(sp)
    8000020a:	69a2                	ld	s3,8(sp)
    8000020c:	6a02                	ld	s4,0(sp)
    8000020e:	6145                	addi	sp,sp,48
    80000210:	8082                	ret

0000000080000212 <kinit>:
{
    80000212:	1141                	addi	sp,sp,-16
    80000214:	e406                	sd	ra,8(sp)
    80000216:	e022                	sd	s0,0(sp)
    80000218:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000021a:	00008597          	auipc	a1,0x8
    8000021e:	dfe58593          	addi	a1,a1,-514 # 80008018 <etext+0x18>
    80000222:	00009517          	auipc	a0,0x9
    80000226:	e0e50513          	addi	a0,a0,-498 # 80009030 <kmem>
    8000022a:	00006097          	auipc	ra,0x6
    8000022e:	0b8080e7          	jalr	184(ra) # 800062e2 <initlock>
  initlock(&mem_ref_struct.lock, "mem_ref");
    80000232:	00008597          	auipc	a1,0x8
    80000236:	dee58593          	addi	a1,a1,-530 # 80008020 <etext+0x20>
    8000023a:	00009517          	auipc	a0,0x9
    8000023e:	e1650513          	addi	a0,a0,-490 # 80009050 <mem_ref_struct>
    80000242:	00006097          	auipc	ra,0x6
    80000246:	0a0080e7          	jalr	160(ra) # 800062e2 <initlock>
  freerange(end, (void*)PHYSTOP);
    8000024a:	45c5                	li	a1,17
    8000024c:	05ee                	slli	a1,a1,0x1b
    8000024e:	00246517          	auipc	a0,0x246
    80000252:	ff250513          	addi	a0,a0,-14 # 80246240 <end>
    80000256:	00000097          	auipc	ra,0x0
    8000025a:	f66080e7          	jalr	-154(ra) # 800001bc <freerange>
}
    8000025e:	60a2                	ld	ra,8(sp)
    80000260:	6402                	ld	s0,0(sp)
    80000262:	0141                	addi	sp,sp,16
    80000264:	8082                	ret

0000000080000266 <kalloc>:
{
    80000266:	1101                	addi	sp,sp,-32
    80000268:	ec06                	sd	ra,24(sp)
    8000026a:	e822                	sd	s0,16(sp)
    8000026c:	e426                	sd	s1,8(sp)
    8000026e:	e04a                	sd	s2,0(sp)
    80000270:	1000                	addi	s0,sp,32
  acquire(&kmem.lock);
    80000272:	00009497          	auipc	s1,0x9
    80000276:	dbe48493          	addi	s1,s1,-578 # 80009030 <kmem>
    8000027a:	8526                	mv	a0,s1
    8000027c:	00006097          	auipc	ra,0x6
    80000280:	0f6080e7          	jalr	246(ra) # 80006372 <acquire>
  r = kmem.freelist;
    80000284:	6c84                	ld	s1,24(s1)
  if(r){
    80000286:	c0a1                	beqz	s1,800002c6 <kalloc+0x60>
    kmem.freelist = r->next;
    80000288:	609c                	ld	a5,0(s1)
    8000028a:	00009917          	auipc	s2,0x9
    8000028e:	da690913          	addi	s2,s2,-602 # 80009030 <kmem>
    80000292:	00f93c23          	sd	a5,24(s2)
    mem_count_set_one((uint64)r);
    80000296:	8526                	mv	a0,s1
    80000298:	00000097          	auipc	ra,0x0
    8000029c:	ee2080e7          	jalr	-286(ra) # 8000017a <mem_count_set_one>
  release(&kmem.lock);
    800002a0:	854a                	mv	a0,s2
    800002a2:	00006097          	auipc	ra,0x6
    800002a6:	184080e7          	jalr	388(ra) # 80006426 <release>
    memset((char*)r, 5, PGSIZE); // fill with junk
    800002aa:	6605                	lui	a2,0x1
    800002ac:	4595                	li	a1,5
    800002ae:	8526                	mv	a0,s1
    800002b0:	00000097          	auipc	ra,0x0
    800002b4:	028080e7          	jalr	40(ra) # 800002d8 <memset>
}
    800002b8:	8526                	mv	a0,s1
    800002ba:	60e2                	ld	ra,24(sp)
    800002bc:	6442                	ld	s0,16(sp)
    800002be:	64a2                	ld	s1,8(sp)
    800002c0:	6902                	ld	s2,0(sp)
    800002c2:	6105                	addi	sp,sp,32
    800002c4:	8082                	ret
  release(&kmem.lock);
    800002c6:	00009517          	auipc	a0,0x9
    800002ca:	d6a50513          	addi	a0,a0,-662 # 80009030 <kmem>
    800002ce:	00006097          	auipc	ra,0x6
    800002d2:	158080e7          	jalr	344(ra) # 80006426 <release>
  if(r)
    800002d6:	b7cd                	j	800002b8 <kalloc+0x52>

00000000800002d8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002d8:	1141                	addi	sp,sp,-16
    800002da:	e422                	sd	s0,8(sp)
    800002dc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002de:	ce09                	beqz	a2,800002f8 <memset+0x20>
    800002e0:	87aa                	mv	a5,a0
    800002e2:	fff6071b          	addiw	a4,a2,-1
    800002e6:	1702                	slli	a4,a4,0x20
    800002e8:	9301                	srli	a4,a4,0x20
    800002ea:	0705                	addi	a4,a4,1
    800002ec:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800002ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002f2:	0785                	addi	a5,a5,1
    800002f4:	fee79de3          	bne	a5,a4,800002ee <memset+0x16>
  }
  return dst;
}
    800002f8:	6422                	ld	s0,8(sp)
    800002fa:	0141                	addi	sp,sp,16
    800002fc:	8082                	ret

00000000800002fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002fe:	1141                	addi	sp,sp,-16
    80000300:	e422                	sd	s0,8(sp)
    80000302:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000304:	ca05                	beqz	a2,80000334 <memcmp+0x36>
    80000306:	fff6069b          	addiw	a3,a2,-1
    8000030a:	1682                	slli	a3,a3,0x20
    8000030c:	9281                	srli	a3,a3,0x20
    8000030e:	0685                	addi	a3,a3,1
    80000310:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000312:	00054783          	lbu	a5,0(a0)
    80000316:	0005c703          	lbu	a4,0(a1)
    8000031a:	00e79863          	bne	a5,a4,8000032a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    8000031e:	0505                	addi	a0,a0,1
    80000320:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000322:	fed518e3          	bne	a0,a3,80000312 <memcmp+0x14>
  }

  return 0;
    80000326:	4501                	li	a0,0
    80000328:	a019                	j	8000032e <memcmp+0x30>
      return *s1 - *s2;
    8000032a:	40e7853b          	subw	a0,a5,a4
}
    8000032e:	6422                	ld	s0,8(sp)
    80000330:	0141                	addi	sp,sp,16
    80000332:	8082                	ret
  return 0;
    80000334:	4501                	li	a0,0
    80000336:	bfe5                	j	8000032e <memcmp+0x30>

0000000080000338 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000338:	1141                	addi	sp,sp,-16
    8000033a:	e422                	sd	s0,8(sp)
    8000033c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    8000033e:	ca0d                	beqz	a2,80000370 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000340:	00a5f963          	bgeu	a1,a0,80000352 <memmove+0x1a>
    80000344:	02061693          	slli	a3,a2,0x20
    80000348:	9281                	srli	a3,a3,0x20
    8000034a:	00d58733          	add	a4,a1,a3
    8000034e:	02e56463          	bltu	a0,a4,80000376 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000352:	fff6079b          	addiw	a5,a2,-1
    80000356:	1782                	slli	a5,a5,0x20
    80000358:	9381                	srli	a5,a5,0x20
    8000035a:	0785                	addi	a5,a5,1
    8000035c:	97ae                	add	a5,a5,a1
    8000035e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000360:	0585                	addi	a1,a1,1
    80000362:	0705                	addi	a4,a4,1
    80000364:	fff5c683          	lbu	a3,-1(a1)
    80000368:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000036c:	fef59ae3          	bne	a1,a5,80000360 <memmove+0x28>

  return dst;
}
    80000370:	6422                	ld	s0,8(sp)
    80000372:	0141                	addi	sp,sp,16
    80000374:	8082                	ret
    d += n;
    80000376:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000378:	fff6079b          	addiw	a5,a2,-1
    8000037c:	1782                	slli	a5,a5,0x20
    8000037e:	9381                	srli	a5,a5,0x20
    80000380:	fff7c793          	not	a5,a5
    80000384:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000386:	177d                	addi	a4,a4,-1
    80000388:	16fd                	addi	a3,a3,-1
    8000038a:	00074603          	lbu	a2,0(a4)
    8000038e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000392:	fef71ae3          	bne	a4,a5,80000386 <memmove+0x4e>
    80000396:	bfe9                	j	80000370 <memmove+0x38>

0000000080000398 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000398:	1141                	addi	sp,sp,-16
    8000039a:	e406                	sd	ra,8(sp)
    8000039c:	e022                	sd	s0,0(sp)
    8000039e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800003a0:	00000097          	auipc	ra,0x0
    800003a4:	f98080e7          	jalr	-104(ra) # 80000338 <memmove>
}
    800003a8:	60a2                	ld	ra,8(sp)
    800003aa:	6402                	ld	s0,0(sp)
    800003ac:	0141                	addi	sp,sp,16
    800003ae:	8082                	ret

00000000800003b0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800003b0:	1141                	addi	sp,sp,-16
    800003b2:	e422                	sd	s0,8(sp)
    800003b4:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800003b6:	ce11                	beqz	a2,800003d2 <strncmp+0x22>
    800003b8:	00054783          	lbu	a5,0(a0)
    800003bc:	cf89                	beqz	a5,800003d6 <strncmp+0x26>
    800003be:	0005c703          	lbu	a4,0(a1)
    800003c2:	00f71a63          	bne	a4,a5,800003d6 <strncmp+0x26>
    n--, p++, q++;
    800003c6:	367d                	addiw	a2,a2,-1
    800003c8:	0505                	addi	a0,a0,1
    800003ca:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003cc:	f675                	bnez	a2,800003b8 <strncmp+0x8>
  if(n == 0)
    return 0;
    800003ce:	4501                	li	a0,0
    800003d0:	a809                	j	800003e2 <strncmp+0x32>
    800003d2:	4501                	li	a0,0
    800003d4:	a039                	j	800003e2 <strncmp+0x32>
  if(n == 0)
    800003d6:	ca09                	beqz	a2,800003e8 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800003d8:	00054503          	lbu	a0,0(a0)
    800003dc:	0005c783          	lbu	a5,0(a1)
    800003e0:	9d1d                	subw	a0,a0,a5
}
    800003e2:	6422                	ld	s0,8(sp)
    800003e4:	0141                	addi	sp,sp,16
    800003e6:	8082                	ret
    return 0;
    800003e8:	4501                	li	a0,0
    800003ea:	bfe5                	j	800003e2 <strncmp+0x32>

00000000800003ec <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e422                	sd	s0,8(sp)
    800003f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003f2:	872a                	mv	a4,a0
    800003f4:	8832                	mv	a6,a2
    800003f6:	367d                	addiw	a2,a2,-1
    800003f8:	01005963          	blez	a6,8000040a <strncpy+0x1e>
    800003fc:	0705                	addi	a4,a4,1
    800003fe:	0005c783          	lbu	a5,0(a1)
    80000402:	fef70fa3          	sb	a5,-1(a4)
    80000406:	0585                	addi	a1,a1,1
    80000408:	f7f5                	bnez	a5,800003f4 <strncpy+0x8>
    ;
  while(n-- > 0)
    8000040a:	00c05d63          	blez	a2,80000424 <strncpy+0x38>
    8000040e:	86ba                	mv	a3,a4
    *s++ = 0;
    80000410:	0685                	addi	a3,a3,1
    80000412:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000416:	fff6c793          	not	a5,a3
    8000041a:	9fb9                	addw	a5,a5,a4
    8000041c:	010787bb          	addw	a5,a5,a6
    80000420:	fef048e3          	bgtz	a5,80000410 <strncpy+0x24>
  return os;
}
    80000424:	6422                	ld	s0,8(sp)
    80000426:	0141                	addi	sp,sp,16
    80000428:	8082                	ret

000000008000042a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000042a:	1141                	addi	sp,sp,-16
    8000042c:	e422                	sd	s0,8(sp)
    8000042e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000430:	02c05363          	blez	a2,80000456 <safestrcpy+0x2c>
    80000434:	fff6069b          	addiw	a3,a2,-1
    80000438:	1682                	slli	a3,a3,0x20
    8000043a:	9281                	srli	a3,a3,0x20
    8000043c:	96ae                	add	a3,a3,a1
    8000043e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000440:	00d58963          	beq	a1,a3,80000452 <safestrcpy+0x28>
    80000444:	0585                	addi	a1,a1,1
    80000446:	0785                	addi	a5,a5,1
    80000448:	fff5c703          	lbu	a4,-1(a1)
    8000044c:	fee78fa3          	sb	a4,-1(a5)
    80000450:	fb65                	bnez	a4,80000440 <safestrcpy+0x16>
    ;
  *s = 0;
    80000452:	00078023          	sb	zero,0(a5)
  return os;
}
    80000456:	6422                	ld	s0,8(sp)
    80000458:	0141                	addi	sp,sp,16
    8000045a:	8082                	ret

000000008000045c <strlen>:

int
strlen(const char *s)
{
    8000045c:	1141                	addi	sp,sp,-16
    8000045e:	e422                	sd	s0,8(sp)
    80000460:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000462:	00054783          	lbu	a5,0(a0)
    80000466:	cf91                	beqz	a5,80000482 <strlen+0x26>
    80000468:	0505                	addi	a0,a0,1
    8000046a:	87aa                	mv	a5,a0
    8000046c:	4685                	li	a3,1
    8000046e:	9e89                	subw	a3,a3,a0
    80000470:	00f6853b          	addw	a0,a3,a5
    80000474:	0785                	addi	a5,a5,1
    80000476:	fff7c703          	lbu	a4,-1(a5)
    8000047a:	fb7d                	bnez	a4,80000470 <strlen+0x14>
    ;
  return n;
}
    8000047c:	6422                	ld	s0,8(sp)
    8000047e:	0141                	addi	sp,sp,16
    80000480:	8082                	ret
  for(n = 0; s[n]; n++)
    80000482:	4501                	li	a0,0
    80000484:	bfe5                	j	8000047c <strlen+0x20>

0000000080000486 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000486:	1141                	addi	sp,sp,-16
    80000488:	e406                	sd	ra,8(sp)
    8000048a:	e022                	sd	s0,0(sp)
    8000048c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000048e:	00001097          	auipc	ra,0x1
    80000492:	ba0080e7          	jalr	-1120(ra) # 8000102e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000496:	00009717          	auipc	a4,0x9
    8000049a:	b6a70713          	addi	a4,a4,-1174 # 80009000 <started>
  if(cpuid() == 0){
    8000049e:	c139                	beqz	a0,800004e4 <main+0x5e>
    while(started == 0)
    800004a0:	431c                	lw	a5,0(a4)
    800004a2:	2781                	sext.w	a5,a5
    800004a4:	dff5                	beqz	a5,800004a0 <main+0x1a>
      ;
    __sync_synchronize();
    800004a6:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    800004aa:	00001097          	auipc	ra,0x1
    800004ae:	b84080e7          	jalr	-1148(ra) # 8000102e <cpuid>
    800004b2:	85aa                	mv	a1,a0
    800004b4:	00008517          	auipc	a0,0x8
    800004b8:	b8c50513          	addi	a0,a0,-1140 # 80008040 <etext+0x40>
    800004bc:	00006097          	auipc	ra,0x6
    800004c0:	9b6080e7          	jalr	-1610(ra) # 80005e72 <printf>
    kvminithart();    // turn on paging
    800004c4:	00000097          	auipc	ra,0x0
    800004c8:	0d8080e7          	jalr	216(ra) # 8000059c <kvminithart>
    trapinithart();   // install kernel trap vector
    800004cc:	00001097          	auipc	ra,0x1
    800004d0:	7da080e7          	jalr	2010(ra) # 80001ca6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004d4:	00005097          	auipc	ra,0x5
    800004d8:	e2c080e7          	jalr	-468(ra) # 80005300 <plicinithart>
  }

  scheduler();        
    800004dc:	00001097          	auipc	ra,0x1
    800004e0:	088080e7          	jalr	136(ra) # 80001564 <scheduler>
    consoleinit();
    800004e4:	00006097          	auipc	ra,0x6
    800004e8:	856080e7          	jalr	-1962(ra) # 80005d3a <consoleinit>
    printfinit();
    800004ec:	00006097          	auipc	ra,0x6
    800004f0:	b6c080e7          	jalr	-1172(ra) # 80006058 <printfinit>
    printf("\n");
    800004f4:	00008517          	auipc	a0,0x8
    800004f8:	b5c50513          	addi	a0,a0,-1188 # 80008050 <etext+0x50>
    800004fc:	00006097          	auipc	ra,0x6
    80000500:	976080e7          	jalr	-1674(ra) # 80005e72 <printf>
    printf("xv6 kernel is booting\n");
    80000504:	00008517          	auipc	a0,0x8
    80000508:	b2450513          	addi	a0,a0,-1244 # 80008028 <etext+0x28>
    8000050c:	00006097          	auipc	ra,0x6
    80000510:	966080e7          	jalr	-1690(ra) # 80005e72 <printf>
    printf("\n");
    80000514:	00008517          	auipc	a0,0x8
    80000518:	b3c50513          	addi	a0,a0,-1220 # 80008050 <etext+0x50>
    8000051c:	00006097          	auipc	ra,0x6
    80000520:	956080e7          	jalr	-1706(ra) # 80005e72 <printf>
    kinit();         // physical page allocator
    80000524:	00000097          	auipc	ra,0x0
    80000528:	cee080e7          	jalr	-786(ra) # 80000212 <kinit>
    kvminit();       // create kernel page table
    8000052c:	00000097          	auipc	ra,0x0
    80000530:	322080e7          	jalr	802(ra) # 8000084e <kvminit>
    kvminithart();   // turn on paging
    80000534:	00000097          	auipc	ra,0x0
    80000538:	068080e7          	jalr	104(ra) # 8000059c <kvminithart>
    procinit();      // process table
    8000053c:	00001097          	auipc	ra,0x1
    80000540:	a42080e7          	jalr	-1470(ra) # 80000f7e <procinit>
    trapinit();      // trap vectors
    80000544:	00001097          	auipc	ra,0x1
    80000548:	73a080e7          	jalr	1850(ra) # 80001c7e <trapinit>
    trapinithart();  // install kernel trap vector
    8000054c:	00001097          	auipc	ra,0x1
    80000550:	75a080e7          	jalr	1882(ra) # 80001ca6 <trapinithart>
    plicinit();      // set up interrupt controller
    80000554:	00005097          	auipc	ra,0x5
    80000558:	d96080e7          	jalr	-618(ra) # 800052ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000055c:	00005097          	auipc	ra,0x5
    80000560:	da4080e7          	jalr	-604(ra) # 80005300 <plicinithart>
    binit();         // buffer cache
    80000564:	00002097          	auipc	ra,0x2
    80000568:	f86080e7          	jalr	-122(ra) # 800024ea <binit>
    iinit();         // inode table
    8000056c:	00002097          	auipc	ra,0x2
    80000570:	616080e7          	jalr	1558(ra) # 80002b82 <iinit>
    fileinit();      // file table
    80000574:	00003097          	auipc	ra,0x3
    80000578:	5c0080e7          	jalr	1472(ra) # 80003b34 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000057c:	00005097          	auipc	ra,0x5
    80000580:	ea6080e7          	jalr	-346(ra) # 80005422 <virtio_disk_init>
    userinit();      // first user process
    80000584:	00001097          	auipc	ra,0x1
    80000588:	dae080e7          	jalr	-594(ra) # 80001332 <userinit>
    __sync_synchronize();
    8000058c:	0ff0000f          	fence
    started = 1;
    80000590:	4785                	li	a5,1
    80000592:	00009717          	auipc	a4,0x9
    80000596:	a6f72723          	sw	a5,-1426(a4) # 80009000 <started>
    8000059a:	b789                	j	800004dc <main+0x56>

000000008000059c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000059c:	1141                	addi	sp,sp,-16
    8000059e:	e422                	sd	s0,8(sp)
    800005a0:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800005a2:	00009797          	auipc	a5,0x9
    800005a6:	a667b783          	ld	a5,-1434(a5) # 80009008 <kernel_pagetable>
    800005aa:	83b1                	srli	a5,a5,0xc
    800005ac:	577d                	li	a4,-1
    800005ae:	177e                	slli	a4,a4,0x3f
    800005b0:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800005b2:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800005b6:	12000073          	sfence.vma
  sfence_vma();
}
    800005ba:	6422                	ld	s0,8(sp)
    800005bc:	0141                	addi	sp,sp,16
    800005be:	8082                	ret

00000000800005c0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005c0:	7139                	addi	sp,sp,-64
    800005c2:	fc06                	sd	ra,56(sp)
    800005c4:	f822                	sd	s0,48(sp)
    800005c6:	f426                	sd	s1,40(sp)
    800005c8:	f04a                	sd	s2,32(sp)
    800005ca:	ec4e                	sd	s3,24(sp)
    800005cc:	e852                	sd	s4,16(sp)
    800005ce:	e456                	sd	s5,8(sp)
    800005d0:	e05a                	sd	s6,0(sp)
    800005d2:	0080                	addi	s0,sp,64
    800005d4:	84aa                	mv	s1,a0
    800005d6:	89ae                	mv	s3,a1
    800005d8:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800005da:	57fd                	li	a5,-1
    800005dc:	83e9                	srli	a5,a5,0x1a
    800005de:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800005e0:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005e2:	04b7f263          	bgeu	a5,a1,80000626 <walk+0x66>
    panic("walk");
    800005e6:	00008517          	auipc	a0,0x8
    800005ea:	a7250513          	addi	a0,a0,-1422 # 80008058 <etext+0x58>
    800005ee:	00006097          	auipc	ra,0x6
    800005f2:	83a080e7          	jalr	-1990(ra) # 80005e28 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005f6:	060a8663          	beqz	s5,80000662 <walk+0xa2>
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	c6c080e7          	jalr	-916(ra) # 80000266 <kalloc>
    80000602:	84aa                	mv	s1,a0
    80000604:	c529                	beqz	a0,8000064e <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000606:	6605                	lui	a2,0x1
    80000608:	4581                	li	a1,0
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	cce080e7          	jalr	-818(ra) # 800002d8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000612:	00c4d793          	srli	a5,s1,0xc
    80000616:	07aa                	slli	a5,a5,0xa
    80000618:	0017e793          	ori	a5,a5,1
    8000061c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000620:	3a5d                	addiw	s4,s4,-9
    80000622:	036a0063          	beq	s4,s6,80000642 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000626:	0149d933          	srl	s2,s3,s4
    8000062a:	1ff97913          	andi	s2,s2,511
    8000062e:	090e                	slli	s2,s2,0x3
    80000630:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000632:	00093483          	ld	s1,0(s2)
    80000636:	0014f793          	andi	a5,s1,1
    8000063a:	dfd5                	beqz	a5,800005f6 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000063c:	80a9                	srli	s1,s1,0xa
    8000063e:	04b2                	slli	s1,s1,0xc
    80000640:	b7c5                	j	80000620 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000642:	00c9d513          	srli	a0,s3,0xc
    80000646:	1ff57513          	andi	a0,a0,511
    8000064a:	050e                	slli	a0,a0,0x3
    8000064c:	9526                	add	a0,a0,s1
}
    8000064e:	70e2                	ld	ra,56(sp)
    80000650:	7442                	ld	s0,48(sp)
    80000652:	74a2                	ld	s1,40(sp)
    80000654:	7902                	ld	s2,32(sp)
    80000656:	69e2                	ld	s3,24(sp)
    80000658:	6a42                	ld	s4,16(sp)
    8000065a:	6aa2                	ld	s5,8(sp)
    8000065c:	6b02                	ld	s6,0(sp)
    8000065e:	6121                	addi	sp,sp,64
    80000660:	8082                	ret
        return 0;
    80000662:	4501                	li	a0,0
    80000664:	b7ed                	j	8000064e <walk+0x8e>

0000000080000666 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000666:	57fd                	li	a5,-1
    80000668:	83e9                	srli	a5,a5,0x1a
    8000066a:	00b7f463          	bgeu	a5,a1,80000672 <walkaddr+0xc>
    return 0;
    8000066e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000670:	8082                	ret
{
    80000672:	1141                	addi	sp,sp,-16
    80000674:	e406                	sd	ra,8(sp)
    80000676:	e022                	sd	s0,0(sp)
    80000678:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000067a:	4601                	li	a2,0
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	f44080e7          	jalr	-188(ra) # 800005c0 <walk>
  if(pte == 0)
    80000684:	c105                	beqz	a0,800006a4 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000686:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000688:	0117f693          	andi	a3,a5,17
    8000068c:	4745                	li	a4,17
    return 0;
    8000068e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000690:	00e68663          	beq	a3,a4,8000069c <walkaddr+0x36>
}
    80000694:	60a2                	ld	ra,8(sp)
    80000696:	6402                	ld	s0,0(sp)
    80000698:	0141                	addi	sp,sp,16
    8000069a:	8082                	ret
  pa = PTE2PA(*pte);
    8000069c:	00a7d513          	srli	a0,a5,0xa
    800006a0:	0532                	slli	a0,a0,0xc
  return pa;
    800006a2:	bfcd                	j	80000694 <walkaddr+0x2e>
    return 0;
    800006a4:	4501                	li	a0,0
    800006a6:	b7fd                	j	80000694 <walkaddr+0x2e>

00000000800006a8 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800006a8:	715d                	addi	sp,sp,-80
    800006aa:	e486                	sd	ra,72(sp)
    800006ac:	e0a2                	sd	s0,64(sp)
    800006ae:	fc26                	sd	s1,56(sp)
    800006b0:	f84a                	sd	s2,48(sp)
    800006b2:	f44e                	sd	s3,40(sp)
    800006b4:	f052                	sd	s4,32(sp)
    800006b6:	ec56                	sd	s5,24(sp)
    800006b8:	e85a                	sd	s6,16(sp)
    800006ba:	e45e                	sd	s7,8(sp)
    800006bc:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800006be:	c205                	beqz	a2,800006de <mappages+0x36>
    800006c0:	8aaa                	mv	s5,a0
    800006c2:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800006c4:	77fd                	lui	a5,0xfffff
    800006c6:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800006ca:	15fd                	addi	a1,a1,-1
    800006cc:	00c589b3          	add	s3,a1,a2
    800006d0:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800006d4:	8952                	mv	s2,s4
    800006d6:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800006da:	6b85                	lui	s7,0x1
    800006dc:	a015                	j	80000700 <mappages+0x58>
    panic("mappages: size");
    800006de:	00008517          	auipc	a0,0x8
    800006e2:	98250513          	addi	a0,a0,-1662 # 80008060 <etext+0x60>
    800006e6:	00005097          	auipc	ra,0x5
    800006ea:	742080e7          	jalr	1858(ra) # 80005e28 <panic>
      panic("mappages: remap");
    800006ee:	00008517          	auipc	a0,0x8
    800006f2:	98250513          	addi	a0,a0,-1662 # 80008070 <etext+0x70>
    800006f6:	00005097          	auipc	ra,0x5
    800006fa:	732080e7          	jalr	1842(ra) # 80005e28 <panic>
    a += PGSIZE;
    800006fe:	995e                	add	s2,s2,s7
  for(;;){
    80000700:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80000704:	4605                	li	a2,1
    80000706:	85ca                	mv	a1,s2
    80000708:	8556                	mv	a0,s5
    8000070a:	00000097          	auipc	ra,0x0
    8000070e:	eb6080e7          	jalr	-330(ra) # 800005c0 <walk>
    80000712:	cd19                	beqz	a0,80000730 <mappages+0x88>
    if(*pte & PTE_V)
    80000714:	611c                	ld	a5,0(a0)
    80000716:	8b85                	andi	a5,a5,1
    80000718:	fbf9                	bnez	a5,800006ee <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000071a:	80b1                	srli	s1,s1,0xc
    8000071c:	04aa                	slli	s1,s1,0xa
    8000071e:	0164e4b3          	or	s1,s1,s6
    80000722:	0014e493          	ori	s1,s1,1
    80000726:	e104                	sd	s1,0(a0)
    if(a == last)
    80000728:	fd391be3          	bne	s2,s3,800006fe <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    8000072c:	4501                	li	a0,0
    8000072e:	a011                	j	80000732 <mappages+0x8a>
      return -1;
    80000730:	557d                	li	a0,-1
}
    80000732:	60a6                	ld	ra,72(sp)
    80000734:	6406                	ld	s0,64(sp)
    80000736:	74e2                	ld	s1,56(sp)
    80000738:	7942                	ld	s2,48(sp)
    8000073a:	79a2                	ld	s3,40(sp)
    8000073c:	7a02                	ld	s4,32(sp)
    8000073e:	6ae2                	ld	s5,24(sp)
    80000740:	6b42                	ld	s6,16(sp)
    80000742:	6ba2                	ld	s7,8(sp)
    80000744:	6161                	addi	sp,sp,80
    80000746:	8082                	ret

0000000080000748 <kvmmap>:
{
    80000748:	1141                	addi	sp,sp,-16
    8000074a:	e406                	sd	ra,8(sp)
    8000074c:	e022                	sd	s0,0(sp)
    8000074e:	0800                	addi	s0,sp,16
    80000750:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000752:	86b2                	mv	a3,a2
    80000754:	863e                	mv	a2,a5
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	f52080e7          	jalr	-174(ra) # 800006a8 <mappages>
    8000075e:	e509                	bnez	a0,80000768 <kvmmap+0x20>
}
    80000760:	60a2                	ld	ra,8(sp)
    80000762:	6402                	ld	s0,0(sp)
    80000764:	0141                	addi	sp,sp,16
    80000766:	8082                	ret
    panic("kvmmap");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	91850513          	addi	a0,a0,-1768 # 80008080 <etext+0x80>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	6b8080e7          	jalr	1720(ra) # 80005e28 <panic>

0000000080000778 <kvmmake>:
{
    80000778:	1101                	addi	sp,sp,-32
    8000077a:	ec06                	sd	ra,24(sp)
    8000077c:	e822                	sd	s0,16(sp)
    8000077e:	e426                	sd	s1,8(sp)
    80000780:	e04a                	sd	s2,0(sp)
    80000782:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000784:	00000097          	auipc	ra,0x0
    80000788:	ae2080e7          	jalr	-1310(ra) # 80000266 <kalloc>
    8000078c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000078e:	6605                	lui	a2,0x1
    80000790:	4581                	li	a1,0
    80000792:	00000097          	auipc	ra,0x0
    80000796:	b46080e7          	jalr	-1210(ra) # 800002d8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000079a:	4719                	li	a4,6
    8000079c:	6685                	lui	a3,0x1
    8000079e:	10000637          	lui	a2,0x10000
    800007a2:	100005b7          	lui	a1,0x10000
    800007a6:	8526                	mv	a0,s1
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	fa0080e7          	jalr	-96(ra) # 80000748 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007b0:	4719                	li	a4,6
    800007b2:	6685                	lui	a3,0x1
    800007b4:	10001637          	lui	a2,0x10001
    800007b8:	100015b7          	lui	a1,0x10001
    800007bc:	8526                	mv	a0,s1
    800007be:	00000097          	auipc	ra,0x0
    800007c2:	f8a080e7          	jalr	-118(ra) # 80000748 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007c6:	4719                	li	a4,6
    800007c8:	004006b7          	lui	a3,0x400
    800007cc:	0c000637          	lui	a2,0xc000
    800007d0:	0c0005b7          	lui	a1,0xc000
    800007d4:	8526                	mv	a0,s1
    800007d6:	00000097          	auipc	ra,0x0
    800007da:	f72080e7          	jalr	-142(ra) # 80000748 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800007de:	00008917          	auipc	s2,0x8
    800007e2:	82290913          	addi	s2,s2,-2014 # 80008000 <etext>
    800007e6:	4729                	li	a4,10
    800007e8:	80008697          	auipc	a3,0x80008
    800007ec:	81868693          	addi	a3,a3,-2024 # 8000 <_entry-0x7fff8000>
    800007f0:	4605                	li	a2,1
    800007f2:	067e                	slli	a2,a2,0x1f
    800007f4:	85b2                	mv	a1,a2
    800007f6:	8526                	mv	a0,s1
    800007f8:	00000097          	auipc	ra,0x0
    800007fc:	f50080e7          	jalr	-176(ra) # 80000748 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000800:	4719                	li	a4,6
    80000802:	46c5                	li	a3,17
    80000804:	06ee                	slli	a3,a3,0x1b
    80000806:	412686b3          	sub	a3,a3,s2
    8000080a:	864a                	mv	a2,s2
    8000080c:	85ca                	mv	a1,s2
    8000080e:	8526                	mv	a0,s1
    80000810:	00000097          	auipc	ra,0x0
    80000814:	f38080e7          	jalr	-200(ra) # 80000748 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000818:	4729                	li	a4,10
    8000081a:	6685                	lui	a3,0x1
    8000081c:	00006617          	auipc	a2,0x6
    80000820:	7e460613          	addi	a2,a2,2020 # 80007000 <_trampoline>
    80000824:	040005b7          	lui	a1,0x4000
    80000828:	15fd                	addi	a1,a1,-1
    8000082a:	05b2                	slli	a1,a1,0xc
    8000082c:	8526                	mv	a0,s1
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	f1a080e7          	jalr	-230(ra) # 80000748 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000836:	8526                	mv	a0,s1
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	6b0080e7          	jalr	1712(ra) # 80000ee8 <proc_mapstacks>
}
    80000840:	8526                	mv	a0,s1
    80000842:	60e2                	ld	ra,24(sp)
    80000844:	6442                	ld	s0,16(sp)
    80000846:	64a2                	ld	s1,8(sp)
    80000848:	6902                	ld	s2,0(sp)
    8000084a:	6105                	addi	sp,sp,32
    8000084c:	8082                	ret

000000008000084e <kvminit>:
{
    8000084e:	1141                	addi	sp,sp,-16
    80000850:	e406                	sd	ra,8(sp)
    80000852:	e022                	sd	s0,0(sp)
    80000854:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000856:	00000097          	auipc	ra,0x0
    8000085a:	f22080e7          	jalr	-222(ra) # 80000778 <kvmmake>
    8000085e:	00008797          	auipc	a5,0x8
    80000862:	7aa7b523          	sd	a0,1962(a5) # 80009008 <kernel_pagetable>
}
    80000866:	60a2                	ld	ra,8(sp)
    80000868:	6402                	ld	s0,0(sp)
    8000086a:	0141                	addi	sp,sp,16
    8000086c:	8082                	ret

000000008000086e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000086e:	715d                	addi	sp,sp,-80
    80000870:	e486                	sd	ra,72(sp)
    80000872:	e0a2                	sd	s0,64(sp)
    80000874:	fc26                	sd	s1,56(sp)
    80000876:	f84a                	sd	s2,48(sp)
    80000878:	f44e                	sd	s3,40(sp)
    8000087a:	f052                	sd	s4,32(sp)
    8000087c:	ec56                	sd	s5,24(sp)
    8000087e:	e85a                	sd	s6,16(sp)
    80000880:	e45e                	sd	s7,8(sp)
    80000882:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000884:	03459793          	slli	a5,a1,0x34
    80000888:	e795                	bnez	a5,800008b4 <uvmunmap+0x46>
    8000088a:	8a2a                	mv	s4,a0
    8000088c:	892e                	mv	s2,a1
    8000088e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000890:	0632                	slli	a2,a2,0xc
    80000892:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000896:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000898:	6b05                	lui	s6,0x1
    8000089a:	0735e863          	bltu	a1,s3,8000090a <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000089e:	60a6                	ld	ra,72(sp)
    800008a0:	6406                	ld	s0,64(sp)
    800008a2:	74e2                	ld	s1,56(sp)
    800008a4:	7942                	ld	s2,48(sp)
    800008a6:	79a2                	ld	s3,40(sp)
    800008a8:	7a02                	ld	s4,32(sp)
    800008aa:	6ae2                	ld	s5,24(sp)
    800008ac:	6b42                	ld	s6,16(sp)
    800008ae:	6ba2                	ld	s7,8(sp)
    800008b0:	6161                	addi	sp,sp,80
    800008b2:	8082                	ret
    panic("uvmunmap: not aligned");
    800008b4:	00007517          	auipc	a0,0x7
    800008b8:	7d450513          	addi	a0,a0,2004 # 80008088 <etext+0x88>
    800008bc:	00005097          	auipc	ra,0x5
    800008c0:	56c080e7          	jalr	1388(ra) # 80005e28 <panic>
      panic("uvmunmap: walk");
    800008c4:	00007517          	auipc	a0,0x7
    800008c8:	7dc50513          	addi	a0,a0,2012 # 800080a0 <etext+0xa0>
    800008cc:	00005097          	auipc	ra,0x5
    800008d0:	55c080e7          	jalr	1372(ra) # 80005e28 <panic>
      panic("uvmunmap: not mapped");
    800008d4:	00007517          	auipc	a0,0x7
    800008d8:	7dc50513          	addi	a0,a0,2012 # 800080b0 <etext+0xb0>
    800008dc:	00005097          	auipc	ra,0x5
    800008e0:	54c080e7          	jalr	1356(ra) # 80005e28 <panic>
      panic("uvmunmap: not a leaf");
    800008e4:	00007517          	auipc	a0,0x7
    800008e8:	7e450513          	addi	a0,a0,2020 # 800080c8 <etext+0xc8>
    800008ec:	00005097          	auipc	ra,0x5
    800008f0:	53c080e7          	jalr	1340(ra) # 80005e28 <panic>
      uint64 pa = PTE2PA(*pte);
    800008f4:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008f6:	0532                	slli	a0,a0,0xc
    800008f8:	fffff097          	auipc	ra,0xfffff
    800008fc:	7fa080e7          	jalr	2042(ra) # 800000f2 <kfree>
    *pte = 0;
    80000900:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000904:	995a                	add	s2,s2,s6
    80000906:	f9397ce3          	bgeu	s2,s3,8000089e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000090a:	4601                	li	a2,0
    8000090c:	85ca                	mv	a1,s2
    8000090e:	8552                	mv	a0,s4
    80000910:	00000097          	auipc	ra,0x0
    80000914:	cb0080e7          	jalr	-848(ra) # 800005c0 <walk>
    80000918:	84aa                	mv	s1,a0
    8000091a:	d54d                	beqz	a0,800008c4 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    8000091c:	6108                	ld	a0,0(a0)
    8000091e:	00157793          	andi	a5,a0,1
    80000922:	dbcd                	beqz	a5,800008d4 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000924:	3ff57793          	andi	a5,a0,1023
    80000928:	fb778ee3          	beq	a5,s7,800008e4 <uvmunmap+0x76>
    if(do_free){
    8000092c:	fc0a8ae3          	beqz	s5,80000900 <uvmunmap+0x92>
    80000930:	b7d1                	j	800008f4 <uvmunmap+0x86>

0000000080000932 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000932:	1101                	addi	sp,sp,-32
    80000934:	ec06                	sd	ra,24(sp)
    80000936:	e822                	sd	s0,16(sp)
    80000938:	e426                	sd	s1,8(sp)
    8000093a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	92a080e7          	jalr	-1750(ra) # 80000266 <kalloc>
    80000944:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000946:	c519                	beqz	a0,80000954 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000948:	6605                	lui	a2,0x1
    8000094a:	4581                	li	a1,0
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	98c080e7          	jalr	-1652(ra) # 800002d8 <memset>
  return pagetable;
}
    80000954:	8526                	mv	a0,s1
    80000956:	60e2                	ld	ra,24(sp)
    80000958:	6442                	ld	s0,16(sp)
    8000095a:	64a2                	ld	s1,8(sp)
    8000095c:	6105                	addi	sp,sp,32
    8000095e:	8082                	ret

0000000080000960 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000960:	7179                	addi	sp,sp,-48
    80000962:	f406                	sd	ra,40(sp)
    80000964:	f022                	sd	s0,32(sp)
    80000966:	ec26                	sd	s1,24(sp)
    80000968:	e84a                	sd	s2,16(sp)
    8000096a:	e44e                	sd	s3,8(sp)
    8000096c:	e052                	sd	s4,0(sp)
    8000096e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000970:	6785                	lui	a5,0x1
    80000972:	04f67863          	bgeu	a2,a5,800009c2 <uvminit+0x62>
    80000976:	8a2a                	mv	s4,a0
    80000978:	89ae                	mv	s3,a1
    8000097a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	8ea080e7          	jalr	-1814(ra) # 80000266 <kalloc>
    80000984:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000986:	6605                	lui	a2,0x1
    80000988:	4581                	li	a1,0
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	94e080e7          	jalr	-1714(ra) # 800002d8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000992:	4779                	li	a4,30
    80000994:	86ca                	mv	a3,s2
    80000996:	6605                	lui	a2,0x1
    80000998:	4581                	li	a1,0
    8000099a:	8552                	mv	a0,s4
    8000099c:	00000097          	auipc	ra,0x0
    800009a0:	d0c080e7          	jalr	-756(ra) # 800006a8 <mappages>
  memmove(mem, src, sz);
    800009a4:	8626                	mv	a2,s1
    800009a6:	85ce                	mv	a1,s3
    800009a8:	854a                	mv	a0,s2
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	98e080e7          	jalr	-1650(ra) # 80000338 <memmove>
}
    800009b2:	70a2                	ld	ra,40(sp)
    800009b4:	7402                	ld	s0,32(sp)
    800009b6:	64e2                	ld	s1,24(sp)
    800009b8:	6942                	ld	s2,16(sp)
    800009ba:	69a2                	ld	s3,8(sp)
    800009bc:	6a02                	ld	s4,0(sp)
    800009be:	6145                	addi	sp,sp,48
    800009c0:	8082                	ret
    panic("inituvm: more than a page");
    800009c2:	00007517          	auipc	a0,0x7
    800009c6:	71e50513          	addi	a0,a0,1822 # 800080e0 <etext+0xe0>
    800009ca:	00005097          	auipc	ra,0x5
    800009ce:	45e080e7          	jalr	1118(ra) # 80005e28 <panic>

00000000800009d2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009d2:	1101                	addi	sp,sp,-32
    800009d4:	ec06                	sd	ra,24(sp)
    800009d6:	e822                	sd	s0,16(sp)
    800009d8:	e426                	sd	s1,8(sp)
    800009da:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800009dc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800009de:	00b67d63          	bgeu	a2,a1,800009f8 <uvmdealloc+0x26>
    800009e2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009e4:	6785                	lui	a5,0x1
    800009e6:	17fd                	addi	a5,a5,-1
    800009e8:	00f60733          	add	a4,a2,a5
    800009ec:	767d                	lui	a2,0xfffff
    800009ee:	8f71                	and	a4,a4,a2
    800009f0:	97ae                	add	a5,a5,a1
    800009f2:	8ff1                	and	a5,a5,a2
    800009f4:	00f76863          	bltu	a4,a5,80000a04 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009f8:	8526                	mv	a0,s1
    800009fa:	60e2                	ld	ra,24(sp)
    800009fc:	6442                	ld	s0,16(sp)
    800009fe:	64a2                	ld	s1,8(sp)
    80000a00:	6105                	addi	sp,sp,32
    80000a02:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a04:	8f99                	sub	a5,a5,a4
    80000a06:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a08:	4685                	li	a3,1
    80000a0a:	0007861b          	sext.w	a2,a5
    80000a0e:	85ba                	mv	a1,a4
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	e5e080e7          	jalr	-418(ra) # 8000086e <uvmunmap>
    80000a18:	b7c5                	j	800009f8 <uvmdealloc+0x26>

0000000080000a1a <uvmalloc>:
  if(newsz < oldsz)
    80000a1a:	0ab66163          	bltu	a2,a1,80000abc <uvmalloc+0xa2>
{
    80000a1e:	7139                	addi	sp,sp,-64
    80000a20:	fc06                	sd	ra,56(sp)
    80000a22:	f822                	sd	s0,48(sp)
    80000a24:	f426                	sd	s1,40(sp)
    80000a26:	f04a                	sd	s2,32(sp)
    80000a28:	ec4e                	sd	s3,24(sp)
    80000a2a:	e852                	sd	s4,16(sp)
    80000a2c:	e456                	sd	s5,8(sp)
    80000a2e:	0080                	addi	s0,sp,64
    80000a30:	8aaa                	mv	s5,a0
    80000a32:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000a34:	6985                	lui	s3,0x1
    80000a36:	19fd                	addi	s3,s3,-1
    80000a38:	95ce                	add	a1,a1,s3
    80000a3a:	79fd                	lui	s3,0xfffff
    80000a3c:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a40:	08c9f063          	bgeu	s3,a2,80000ac0 <uvmalloc+0xa6>
    80000a44:	894e                	mv	s2,s3
    mem = kalloc();
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	820080e7          	jalr	-2016(ra) # 80000266 <kalloc>
    80000a4e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a50:	c51d                	beqz	a0,80000a7e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a52:	6605                	lui	a2,0x1
    80000a54:	4581                	li	a1,0
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	882080e7          	jalr	-1918(ra) # 800002d8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a5e:	4779                	li	a4,30
    80000a60:	86a6                	mv	a3,s1
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85ca                	mv	a1,s2
    80000a66:	8556                	mv	a0,s5
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	c40080e7          	jalr	-960(ra) # 800006a8 <mappages>
    80000a70:	e905                	bnez	a0,80000aa0 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a72:	6785                	lui	a5,0x1
    80000a74:	993e                	add	s2,s2,a5
    80000a76:	fd4968e3          	bltu	s2,s4,80000a46 <uvmalloc+0x2c>
  return newsz;
    80000a7a:	8552                	mv	a0,s4
    80000a7c:	a809                	j	80000a8e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a7e:	864e                	mv	a2,s3
    80000a80:	85ca                	mv	a1,s2
    80000a82:	8556                	mv	a0,s5
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	f4e080e7          	jalr	-178(ra) # 800009d2 <uvmdealloc>
      return 0;
    80000a8c:	4501                	li	a0,0
}
    80000a8e:	70e2                	ld	ra,56(sp)
    80000a90:	7442                	ld	s0,48(sp)
    80000a92:	74a2                	ld	s1,40(sp)
    80000a94:	7902                	ld	s2,32(sp)
    80000a96:	69e2                	ld	s3,24(sp)
    80000a98:	6a42                	ld	s4,16(sp)
    80000a9a:	6aa2                	ld	s5,8(sp)
    80000a9c:	6121                	addi	sp,sp,64
    80000a9e:	8082                	ret
      kfree(mem);
    80000aa0:	8526                	mv	a0,s1
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	650080e7          	jalr	1616(ra) # 800000f2 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000aaa:	864e                	mv	a2,s3
    80000aac:	85ca                	mv	a1,s2
    80000aae:	8556                	mv	a0,s5
    80000ab0:	00000097          	auipc	ra,0x0
    80000ab4:	f22080e7          	jalr	-222(ra) # 800009d2 <uvmdealloc>
      return 0;
    80000ab8:	4501                	li	a0,0
    80000aba:	bfd1                	j	80000a8e <uvmalloc+0x74>
    return oldsz;
    80000abc:	852e                	mv	a0,a1
}
    80000abe:	8082                	ret
  return newsz;
    80000ac0:	8532                	mv	a0,a2
    80000ac2:	b7f1                	j	80000a8e <uvmalloc+0x74>

0000000080000ac4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000ac4:	7179                	addi	sp,sp,-48
    80000ac6:	f406                	sd	ra,40(sp)
    80000ac8:	f022                	sd	s0,32(sp)
    80000aca:	ec26                	sd	s1,24(sp)
    80000acc:	e84a                	sd	s2,16(sp)
    80000ace:	e44e                	sd	s3,8(sp)
    80000ad0:	e052                	sd	s4,0(sp)
    80000ad2:	1800                	addi	s0,sp,48
    80000ad4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000ad6:	84aa                	mv	s1,a0
    80000ad8:	6905                	lui	s2,0x1
    80000ada:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000adc:	4985                	li	s3,1
    80000ade:	a821                	j	80000af6 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000ae0:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000ae2:	0532                	slli	a0,a0,0xc
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	fe0080e7          	jalr	-32(ra) # 80000ac4 <freewalk>
      pagetable[i] = 0;
    80000aec:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000af0:	04a1                	addi	s1,s1,8
    80000af2:	03248163          	beq	s1,s2,80000b14 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000af6:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000af8:	00f57793          	andi	a5,a0,15
    80000afc:	ff3782e3          	beq	a5,s3,80000ae0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b00:	8905                	andi	a0,a0,1
    80000b02:	d57d                	beqz	a0,80000af0 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000b04:	00007517          	auipc	a0,0x7
    80000b08:	5fc50513          	addi	a0,a0,1532 # 80008100 <etext+0x100>
    80000b0c:	00005097          	auipc	ra,0x5
    80000b10:	31c080e7          	jalr	796(ra) # 80005e28 <panic>
    }
  }
  kfree((void*)pagetable);
    80000b14:	8552                	mv	a0,s4
    80000b16:	fffff097          	auipc	ra,0xfffff
    80000b1a:	5dc080e7          	jalr	1500(ra) # 800000f2 <kfree>
}
    80000b1e:	70a2                	ld	ra,40(sp)
    80000b20:	7402                	ld	s0,32(sp)
    80000b22:	64e2                	ld	s1,24(sp)
    80000b24:	6942                	ld	s2,16(sp)
    80000b26:	69a2                	ld	s3,8(sp)
    80000b28:	6a02                	ld	s4,0(sp)
    80000b2a:	6145                	addi	sp,sp,48
    80000b2c:	8082                	ret

0000000080000b2e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b2e:	1101                	addi	sp,sp,-32
    80000b30:	ec06                	sd	ra,24(sp)
    80000b32:	e822                	sd	s0,16(sp)
    80000b34:	e426                	sd	s1,8(sp)
    80000b36:	1000                	addi	s0,sp,32
    80000b38:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b3a:	e999                	bnez	a1,80000b50 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b3c:	8526                	mv	a0,s1
    80000b3e:	00000097          	auipc	ra,0x0
    80000b42:	f86080e7          	jalr	-122(ra) # 80000ac4 <freewalk>
}
    80000b46:	60e2                	ld	ra,24(sp)
    80000b48:	6442                	ld	s0,16(sp)
    80000b4a:	64a2                	ld	s1,8(sp)
    80000b4c:	6105                	addi	sp,sp,32
    80000b4e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b50:	6605                	lui	a2,0x1
    80000b52:	167d                	addi	a2,a2,-1
    80000b54:	962e                	add	a2,a2,a1
    80000b56:	4685                	li	a3,1
    80000b58:	8231                	srli	a2,a2,0xc
    80000b5a:	4581                	li	a1,0
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	d12080e7          	jalr	-750(ra) # 8000086e <uvmunmap>
    80000b64:	bfe1                	j	80000b3c <uvmfree+0xe>

0000000080000b66 <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000b66:	7139                	addi	sp,sp,-64
    80000b68:	fc06                	sd	ra,56(sp)
    80000b6a:	f822                	sd	s0,48(sp)
    80000b6c:	f426                	sd	s1,40(sp)
    80000b6e:	f04a                	sd	s2,32(sp)
    80000b70:	ec4e                	sd	s3,24(sp)
    80000b72:	e852                	sd	s4,16(sp)
    80000b74:	e456                	sd	s5,8(sp)
    80000b76:	e05a                	sd	s6,0(sp)
    80000b78:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  // char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000b7a:	c64d                	beqz	a2,80000c24 <uvmcopy+0xbe>
    80000b7c:	8b2a                	mv	s6,a0
    80000b7e:	8aae                	mv	s5,a1
    80000b80:	8a32                	mv	s4,a2
    80000b82:	4481                	li	s1,0
    if((pte = walk(old, i, 0)) == 0)
    80000b84:	4601                	li	a2,0
    80000b86:	85a6                	mv	a1,s1
    80000b88:	855a                	mv	a0,s6
    80000b8a:	00000097          	auipc	ra,0x0
    80000b8e:	a36080e7          	jalr	-1482(ra) # 800005c0 <walk>
    80000b92:	c521                	beqz	a0,80000bda <uvmcopy+0x74>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b94:	611c                	ld	a5,0(a0)
    80000b96:	0017f713          	andi	a4,a5,1
    80000b9a:	cb21                	beqz	a4,80000bea <uvmcopy+0x84>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000b9c:	00a7d913          	srli	s2,a5,0xa
    80000ba0:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    // 清除PTE_W标志
    flags &= (~PTE_W);
    80000ba2:	3fb7f713          	andi	a4,a5,1019
    // 添加PTE_RSW标志
    flags |= PTE_RSW;  
    // 清除父进程PTE的PTE_W标志
    *pte &= (~PTE_W);
    80000ba6:	9bed                	andi	a5,a5,-5
    // 父进程PTE添加PTE_RSW标志
    *pte |= PTE_RSW;
    80000ba8:	1007e793          	ori	a5,a5,256
    80000bac:	e11c                	sd	a5,0(a0)
    // 将父进程的物理内存映射到子进程的虚拟内存
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000bae:	10076713          	ori	a4,a4,256
    80000bb2:	86ca                	mv	a3,s2
    80000bb4:	6605                	lui	a2,0x1
    80000bb6:	85a6                	mv	a1,s1
    80000bb8:	8556                	mv	a0,s5
    80000bba:	00000097          	auipc	ra,0x0
    80000bbe:	aee080e7          	jalr	-1298(ra) # 800006a8 <mappages>
    80000bc2:	89aa                	mv	s3,a0
    80000bc4:	e91d                	bnez	a0,80000bfa <uvmcopy+0x94>
      // kfree((void*)pa);
      goto err;
    }
    // 映射成功，父进程的物理内存引用计数增加
    mem_count_up(pa);
    80000bc6:	854a                	mv	a0,s2
    80000bc8:	fffff097          	auipc	ra,0xfffff
    80000bcc:	496080e7          	jalr	1174(ra) # 8000005e <mem_count_up>
  for(i = 0; i < sz; i += PGSIZE){
    80000bd0:	6785                	lui	a5,0x1
    80000bd2:	94be                	add	s1,s1,a5
    80000bd4:	fb44e8e3          	bltu	s1,s4,80000b84 <uvmcopy+0x1e>
    80000bd8:	a81d                	j	80000c0e <uvmcopy+0xa8>
      panic("uvmcopy: pte should exist");
    80000bda:	00007517          	auipc	a0,0x7
    80000bde:	53650513          	addi	a0,a0,1334 # 80008110 <etext+0x110>
    80000be2:	00005097          	auipc	ra,0x5
    80000be6:	246080e7          	jalr	582(ra) # 80005e28 <panic>
      panic("uvmcopy: page not present");
    80000bea:	00007517          	auipc	a0,0x7
    80000bee:	54650513          	addi	a0,a0,1350 # 80008130 <etext+0x130>
    80000bf2:	00005097          	auipc	ra,0x5
    80000bf6:	236080e7          	jalr	566(ra) # 80005e28 <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bfa:	4685                	li	a3,1
    80000bfc:	00c4d613          	srli	a2,s1,0xc
    80000c00:	4581                	li	a1,0
    80000c02:	8556                	mv	a0,s5
    80000c04:	00000097          	auipc	ra,0x0
    80000c08:	c6a080e7          	jalr	-918(ra) # 8000086e <uvmunmap>
  return -1;
    80000c0c:	59fd                	li	s3,-1
}
    80000c0e:	854e                	mv	a0,s3
    80000c10:	70e2                	ld	ra,56(sp)
    80000c12:	7442                	ld	s0,48(sp)
    80000c14:	74a2                	ld	s1,40(sp)
    80000c16:	7902                	ld	s2,32(sp)
    80000c18:	69e2                	ld	s3,24(sp)
    80000c1a:	6a42                	ld	s4,16(sp)
    80000c1c:	6aa2                	ld	s5,8(sp)
    80000c1e:	6b02                	ld	s6,0(sp)
    80000c20:	6121                	addi	sp,sp,64
    80000c22:	8082                	ret
  return 0;
    80000c24:	4981                	li	s3,0
    80000c26:	b7e5                	j	80000c0e <uvmcopy+0xa8>

0000000080000c28 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c28:	1141                	addi	sp,sp,-16
    80000c2a:	e406                	sd	ra,8(sp)
    80000c2c:	e022                	sd	s0,0(sp)
    80000c2e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000c30:	4601                	li	a2,0
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	98e080e7          	jalr	-1650(ra) # 800005c0 <walk>
  if(pte == 0)
    80000c3a:	c901                	beqz	a0,80000c4a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c3c:	611c                	ld	a5,0(a0)
    80000c3e:	9bbd                	andi	a5,a5,-17
    80000c40:	e11c                	sd	a5,0(a0)
}
    80000c42:	60a2                	ld	ra,8(sp)
    80000c44:	6402                	ld	s0,0(sp)
    80000c46:	0141                	addi	sp,sp,16
    80000c48:	8082                	ret
    panic("uvmclear");
    80000c4a:	00007517          	auipc	a0,0x7
    80000c4e:	50650513          	addi	a0,a0,1286 # 80008150 <etext+0x150>
    80000c52:	00005097          	auipc	ra,0x5
    80000c56:	1d6080e7          	jalr	470(ra) # 80005e28 <panic>

0000000080000c5a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c5a:	c6bd                	beqz	a3,80000cc8 <copyin+0x6e>
{
    80000c5c:	715d                	addi	sp,sp,-80
    80000c5e:	e486                	sd	ra,72(sp)
    80000c60:	e0a2                	sd	s0,64(sp)
    80000c62:	fc26                	sd	s1,56(sp)
    80000c64:	f84a                	sd	s2,48(sp)
    80000c66:	f44e                	sd	s3,40(sp)
    80000c68:	f052                	sd	s4,32(sp)
    80000c6a:	ec56                	sd	s5,24(sp)
    80000c6c:	e85a                	sd	s6,16(sp)
    80000c6e:	e45e                	sd	s7,8(sp)
    80000c70:	e062                	sd	s8,0(sp)
    80000c72:	0880                	addi	s0,sp,80
    80000c74:	8b2a                	mv	s6,a0
    80000c76:	8a2e                	mv	s4,a1
    80000c78:	8c32                	mv	s8,a2
    80000c7a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c7c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c7e:	6a85                	lui	s5,0x1
    80000c80:	a015                	j	80000ca4 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c82:	9562                	add	a0,a0,s8
    80000c84:	0004861b          	sext.w	a2,s1
    80000c88:	412505b3          	sub	a1,a0,s2
    80000c8c:	8552                	mv	a0,s4
    80000c8e:	fffff097          	auipc	ra,0xfffff
    80000c92:	6aa080e7          	jalr	1706(ra) # 80000338 <memmove>

    len -= n;
    80000c96:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c9a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c9c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ca0:	02098263          	beqz	s3,80000cc4 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000ca4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ca8:	85ca                	mv	a1,s2
    80000caa:	855a                	mv	a0,s6
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	9ba080e7          	jalr	-1606(ra) # 80000666 <walkaddr>
    if(pa0 == 0)
    80000cb4:	cd01                	beqz	a0,80000ccc <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000cb6:	418904b3          	sub	s1,s2,s8
    80000cba:	94d6                	add	s1,s1,s5
    if(n > len)
    80000cbc:	fc99f3e3          	bgeu	s3,s1,80000c82 <copyin+0x28>
    80000cc0:	84ce                	mv	s1,s3
    80000cc2:	b7c1                	j	80000c82 <copyin+0x28>
  }
  return 0;
    80000cc4:	4501                	li	a0,0
    80000cc6:	a021                	j	80000cce <copyin+0x74>
    80000cc8:	4501                	li	a0,0
}
    80000cca:	8082                	ret
      return -1;
    80000ccc:	557d                	li	a0,-1
}
    80000cce:	60a6                	ld	ra,72(sp)
    80000cd0:	6406                	ld	s0,64(sp)
    80000cd2:	74e2                	ld	s1,56(sp)
    80000cd4:	7942                	ld	s2,48(sp)
    80000cd6:	79a2                	ld	s3,40(sp)
    80000cd8:	7a02                	ld	s4,32(sp)
    80000cda:	6ae2                	ld	s5,24(sp)
    80000cdc:	6b42                	ld	s6,16(sp)
    80000cde:	6ba2                	ld	s7,8(sp)
    80000ce0:	6c02                	ld	s8,0(sp)
    80000ce2:	6161                	addi	sp,sp,80
    80000ce4:	8082                	ret

0000000080000ce6 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000ce6:	c6c5                	beqz	a3,80000d8e <copyinstr+0xa8>
{
    80000ce8:	715d                	addi	sp,sp,-80
    80000cea:	e486                	sd	ra,72(sp)
    80000cec:	e0a2                	sd	s0,64(sp)
    80000cee:	fc26                	sd	s1,56(sp)
    80000cf0:	f84a                	sd	s2,48(sp)
    80000cf2:	f44e                	sd	s3,40(sp)
    80000cf4:	f052                	sd	s4,32(sp)
    80000cf6:	ec56                	sd	s5,24(sp)
    80000cf8:	e85a                	sd	s6,16(sp)
    80000cfa:	e45e                	sd	s7,8(sp)
    80000cfc:	0880                	addi	s0,sp,80
    80000cfe:	8a2a                	mv	s4,a0
    80000d00:	8b2e                	mv	s6,a1
    80000d02:	8bb2                	mv	s7,a2
    80000d04:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000d06:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000d08:	6985                	lui	s3,0x1
    80000d0a:	a035                	j	80000d36 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000d0c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000d10:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000d12:	0017b793          	seqz	a5,a5
    80000d16:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000d1a:	60a6                	ld	ra,72(sp)
    80000d1c:	6406                	ld	s0,64(sp)
    80000d1e:	74e2                	ld	s1,56(sp)
    80000d20:	7942                	ld	s2,48(sp)
    80000d22:	79a2                	ld	s3,40(sp)
    80000d24:	7a02                	ld	s4,32(sp)
    80000d26:	6ae2                	ld	s5,24(sp)
    80000d28:	6b42                	ld	s6,16(sp)
    80000d2a:	6ba2                	ld	s7,8(sp)
    80000d2c:	6161                	addi	sp,sp,80
    80000d2e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000d30:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000d34:	c8a9                	beqz	s1,80000d86 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000d36:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d3a:	85ca                	mv	a1,s2
    80000d3c:	8552                	mv	a0,s4
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	928080e7          	jalr	-1752(ra) # 80000666 <walkaddr>
    if(pa0 == 0)
    80000d46:	c131                	beqz	a0,80000d8a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d48:	41790833          	sub	a6,s2,s7
    80000d4c:	984e                	add	a6,a6,s3
    if(n > max)
    80000d4e:	0104f363          	bgeu	s1,a6,80000d54 <copyinstr+0x6e>
    80000d52:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d54:	955e                	add	a0,a0,s7
    80000d56:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d5a:	fc080be3          	beqz	a6,80000d30 <copyinstr+0x4a>
    80000d5e:	985a                	add	a6,a6,s6
    80000d60:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d62:	41650633          	sub	a2,a0,s6
    80000d66:	14fd                	addi	s1,s1,-1
    80000d68:	9b26                	add	s6,s6,s1
    80000d6a:	00f60733          	add	a4,a2,a5
    80000d6e:	00074703          	lbu	a4,0(a4)
    80000d72:	df49                	beqz	a4,80000d0c <copyinstr+0x26>
        *dst = *p;
    80000d74:	00e78023          	sb	a4,0(a5)
      --max;
    80000d78:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d7c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d7e:	ff0796e3          	bne	a5,a6,80000d6a <copyinstr+0x84>
      dst++;
    80000d82:	8b42                	mv	s6,a6
    80000d84:	b775                	j	80000d30 <copyinstr+0x4a>
    80000d86:	4781                	li	a5,0
    80000d88:	b769                	j	80000d12 <copyinstr+0x2c>
      return -1;
    80000d8a:	557d                	li	a0,-1
    80000d8c:	b779                	j	80000d1a <copyinstr+0x34>
  int got_null = 0;
    80000d8e:	4781                	li	a5,0
  if(got_null){
    80000d90:	0017b793          	seqz	a5,a5
    80000d94:	40f00533          	neg	a0,a5
}
    80000d98:	8082                	ret

0000000080000d9a <cow_walk>:
pte_t*
cow_walk(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;

  if(va >= MAXVA)
    80000d9a:	57fd                	li	a5,-1
    80000d9c:	83e9                	srli	a5,a5,0x1a
    80000d9e:	02b7e963          	bltu	a5,a1,80000dd0 <cow_walk+0x36>
{
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e406                	sd	ra,8(sp)
    80000da6:	e022                	sd	s0,0(sp)
    80000da8:	0800                	addi	s0,sp,16
    return 0;

  pte = walk(pagetable, va, 0);
    80000daa:	4601                	li	a2,0
    80000dac:	00000097          	auipc	ra,0x0
    80000db0:	814080e7          	jalr	-2028(ra) # 800005c0 <walk>
  if(pte == 0)
    80000db4:	c911                	beqz	a0,80000dc8 <cow_walk+0x2e>
    return 0;
  if((*pte & PTE_V) == 0)
    80000db6:	611c                	ld	a5,0(a0)
    return 0;
  if((*pte & PTE_U) == 0)
    80000db8:	0117f693          	andi	a3,a5,17
    80000dbc:	4745                	li	a4,17
    80000dbe:	00e69b63          	bne	a3,a4,80000dd4 <cow_walk+0x3a>
    return 0;
  // 检查是否来自cow的页面错误
  if((*pte & PTE_RSW) == 0)
    return 0;
    80000dc2:	17de                	slli	a5,a5,0x37
    80000dc4:	97fd                	srai	a5,a5,0x3f
    80000dc6:	8d7d                	and	a0,a0,a5
  return pte;
}
    80000dc8:	60a2                	ld	ra,8(sp)
    80000dca:	6402                	ld	s0,0(sp)
    80000dcc:	0141                	addi	sp,sp,16
    80000dce:	8082                	ret
    return 0;
    80000dd0:	4501                	li	a0,0
}
    80000dd2:	8082                	ret
    return 0;
    80000dd4:	4501                	li	a0,0
    80000dd6:	bfcd                	j	80000dc8 <cow_walk+0x2e>

0000000080000dd8 <copyout>:
{
    80000dd8:	715d                	addi	sp,sp,-80
    80000dda:	e486                	sd	ra,72(sp)
    80000ddc:	e0a2                	sd	s0,64(sp)
    80000dde:	fc26                	sd	s1,56(sp)
    80000de0:	f84a                	sd	s2,48(sp)
    80000de2:	f44e                	sd	s3,40(sp)
    80000de4:	f052                	sd	s4,32(sp)
    80000de6:	ec56                	sd	s5,24(sp)
    80000de8:	e85a                	sd	s6,16(sp)
    80000dea:	e45e                	sd	s7,8(sp)
    80000dec:	e062                	sd	s8,0(sp)
    80000dee:	0880                	addi	s0,sp,80
    80000df0:	8b2a                	mv	s6,a0
    80000df2:	8c2e                	mv	s8,a1
    80000df4:	8a32                	mv	s4,a2
    80000df6:	89b6                	mv	s3,a3
  if((pte = cow_walk(pagetable, PGROUNDDOWN(dstva))) != 0){
    80000df8:	74fd                	lui	s1,0xfffff
    80000dfa:	8ced                	and	s1,s1,a1
    80000dfc:	85a6                	mv	a1,s1
    80000dfe:	00000097          	auipc	ra,0x0
    80000e02:	f9c080e7          	jalr	-100(ra) # 80000d9a <cow_walk>
    80000e06:	c929                	beqz	a0,80000e58 <copyout+0x80>
    fault_pa = PTE2PA(*pte);
    80000e08:	00053903          	ld	s2,0(a0)
    80000e0c:	00a95913          	srli	s2,s2,0xa
    80000e10:	0932                	slli	s2,s2,0xc
    char* child_pa = kalloc();
    80000e12:	fffff097          	auipc	ra,0xfffff
    80000e16:	454080e7          	jalr	1108(ra) # 80000266 <kalloc>
    80000e1a:	8aaa                	mv	s5,a0
    if(child_pa == 0){
    80000e1c:	c139                	beqz	a0,80000e62 <copyout+0x8a>
    memmove(child_pa, (char *)fault_pa, PGSIZE);
    80000e1e:	6605                	lui	a2,0x1
    80000e20:	85ca                	mv	a1,s2
    80000e22:	fffff097          	auipc	ra,0xfffff
    80000e26:	516080e7          	jalr	1302(ra) # 80000338 <memmove>
    uvmunmap(pagetable, PGROUNDDOWN(dstva), 1, 0);
    80000e2a:	4681                	li	a3,0
    80000e2c:	4605                	li	a2,1
    80000e2e:	85a6                	mv	a1,s1
    80000e30:	855a                	mv	a0,s6
    80000e32:	00000097          	auipc	ra,0x0
    80000e36:	a3c080e7          	jalr	-1476(ra) # 8000086e <uvmunmap>
    if(mappages(pagetable, PGROUNDDOWN(dstva), PGSIZE, (uint64)child_pa, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000e3a:	4779                	li	a4,30
    80000e3c:	86d6                	mv	a3,s5
    80000e3e:	6605                	lui	a2,0x1
    80000e40:	85a6                	mv	a1,s1
    80000e42:	855a                	mv	a0,s6
    80000e44:	00000097          	auipc	ra,0x0
    80000e48:	864080e7          	jalr	-1948(ra) # 800006a8 <mappages>
    80000e4c:	e50d                	bnez	a0,80000e76 <copyout+0x9e>
    kfree((void*)fault_pa);
    80000e4e:	854a                	mv	a0,s2
    80000e50:	fffff097          	auipc	ra,0xfffff
    80000e54:	2a2080e7          	jalr	674(ra) # 800000f2 <kfree>
  while(len > 0){
    80000e58:	06098963          	beqz	s3,80000eca <copyout+0xf2>
    va0 = PGROUNDDOWN(dstva);
    80000e5c:	7bfd                	lui	s7,0xfffff
    n = PGSIZE - (dstva - va0);
    80000e5e:	6a85                	lui	s5,0x1
    80000e60:	a099                	j	80000ea6 <copyout+0xce>
      printf("copyout: alloc physical memory failed");
    80000e62:	00007517          	auipc	a0,0x7
    80000e66:	2fe50513          	addi	a0,a0,766 # 80008160 <etext+0x160>
    80000e6a:	00005097          	auipc	ra,0x5
    80000e6e:	008080e7          	jalr	8(ra) # 80005e72 <printf>
      return -1;
    80000e72:	557d                	li	a0,-1
    80000e74:	a8b1                	j	80000ed0 <copyout+0xf8>
      kfree(child_pa);
    80000e76:	8556                	mv	a0,s5
    80000e78:	fffff097          	auipc	ra,0xfffff
    80000e7c:	27a080e7          	jalr	634(ra) # 800000f2 <kfree>
      return -1;
    80000e80:	557d                	li	a0,-1
    80000e82:	a0b9                	j	80000ed0 <copyout+0xf8>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000e84:	9562                	add	a0,a0,s8
    80000e86:	0004861b          	sext.w	a2,s1
    80000e8a:	85d2                	mv	a1,s4
    80000e8c:	41250533          	sub	a0,a0,s2
    80000e90:	fffff097          	auipc	ra,0xfffff
    80000e94:	4a8080e7          	jalr	1192(ra) # 80000338 <memmove>
    len -= n;
    80000e98:	409989b3          	sub	s3,s3,s1
    src += n;
    80000e9c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000e9e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ea2:	02098263          	beqz	s3,80000ec6 <copyout+0xee>
    va0 = PGROUNDDOWN(dstva);
    80000ea6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000eaa:	85ca                	mv	a1,s2
    80000eac:	855a                	mv	a0,s6
    80000eae:	fffff097          	auipc	ra,0xfffff
    80000eb2:	7b8080e7          	jalr	1976(ra) # 80000666 <walkaddr>
    if(pa0 == 0)
    80000eb6:	cd01                	beqz	a0,80000ece <copyout+0xf6>
    n = PGSIZE - (dstva - va0);
    80000eb8:	418904b3          	sub	s1,s2,s8
    80000ebc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000ebe:	fc99f3e3          	bgeu	s3,s1,80000e84 <copyout+0xac>
    80000ec2:	84ce                	mv	s1,s3
    80000ec4:	b7c1                	j	80000e84 <copyout+0xac>
  return 0;
    80000ec6:	4501                	li	a0,0
    80000ec8:	a021                	j	80000ed0 <copyout+0xf8>
    80000eca:	4501                	li	a0,0
    80000ecc:	a011                	j	80000ed0 <copyout+0xf8>
      return -1;
    80000ece:	557d                	li	a0,-1
}
    80000ed0:	60a6                	ld	ra,72(sp)
    80000ed2:	6406                	ld	s0,64(sp)
    80000ed4:	74e2                	ld	s1,56(sp)
    80000ed6:	7942                	ld	s2,48(sp)
    80000ed8:	79a2                	ld	s3,40(sp)
    80000eda:	7a02                	ld	s4,32(sp)
    80000edc:	6ae2                	ld	s5,24(sp)
    80000ede:	6b42                	ld	s6,16(sp)
    80000ee0:	6ba2                	ld	s7,8(sp)
    80000ee2:	6c02                	ld	s8,0(sp)
    80000ee4:	6161                	addi	sp,sp,80
    80000ee6:	8082                	ret

0000000080000ee8 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000ee8:	7139                	addi	sp,sp,-64
    80000eea:	fc06                	sd	ra,56(sp)
    80000eec:	f822                	sd	s0,48(sp)
    80000eee:	f426                	sd	s1,40(sp)
    80000ef0:	f04a                	sd	s2,32(sp)
    80000ef2:	ec4e                	sd	s3,24(sp)
    80000ef4:	e852                	sd	s4,16(sp)
    80000ef6:	e456                	sd	s5,8(sp)
    80000ef8:	e05a                	sd	s6,0(sp)
    80000efa:	0080                	addi	s0,sp,64
    80000efc:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000efe:	00228497          	auipc	s1,0x228
    80000f02:	59a48493          	addi	s1,s1,1434 # 80229498 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f06:	8b26                	mv	s6,s1
    80000f08:	00007a97          	auipc	s5,0x7
    80000f0c:	0f8a8a93          	addi	s5,s5,248 # 80008000 <etext>
    80000f10:	04000937          	lui	s2,0x4000
    80000f14:	197d                	addi	s2,s2,-1
    80000f16:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f18:	0022ea17          	auipc	s4,0x22e
    80000f1c:	f80a0a13          	addi	s4,s4,-128 # 8022ee98 <tickslock>
    char *pa = kalloc();
    80000f20:	fffff097          	auipc	ra,0xfffff
    80000f24:	346080e7          	jalr	838(ra) # 80000266 <kalloc>
    80000f28:	862a                	mv	a2,a0
    if(pa == 0)
    80000f2a:	c131                	beqz	a0,80000f6e <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000f2c:	416485b3          	sub	a1,s1,s6
    80000f30:	858d                	srai	a1,a1,0x3
    80000f32:	000ab783          	ld	a5,0(s5)
    80000f36:	02f585b3          	mul	a1,a1,a5
    80000f3a:	2585                	addiw	a1,a1,1
    80000f3c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f40:	4719                	li	a4,6
    80000f42:	6685                	lui	a3,0x1
    80000f44:	40b905b3          	sub	a1,s2,a1
    80000f48:	854e                	mv	a0,s3
    80000f4a:	fffff097          	auipc	ra,0xfffff
    80000f4e:	7fe080e7          	jalr	2046(ra) # 80000748 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f52:	16848493          	addi	s1,s1,360
    80000f56:	fd4495e3          	bne	s1,s4,80000f20 <proc_mapstacks+0x38>
  }
}
    80000f5a:	70e2                	ld	ra,56(sp)
    80000f5c:	7442                	ld	s0,48(sp)
    80000f5e:	74a2                	ld	s1,40(sp)
    80000f60:	7902                	ld	s2,32(sp)
    80000f62:	69e2                	ld	s3,24(sp)
    80000f64:	6a42                	ld	s4,16(sp)
    80000f66:	6aa2                	ld	s5,8(sp)
    80000f68:	6b02                	ld	s6,0(sp)
    80000f6a:	6121                	addi	sp,sp,64
    80000f6c:	8082                	ret
      panic("kalloc");
    80000f6e:	00007517          	auipc	a0,0x7
    80000f72:	21a50513          	addi	a0,a0,538 # 80008188 <etext+0x188>
    80000f76:	00005097          	auipc	ra,0x5
    80000f7a:	eb2080e7          	jalr	-334(ra) # 80005e28 <panic>

0000000080000f7e <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f7e:	7139                	addi	sp,sp,-64
    80000f80:	fc06                	sd	ra,56(sp)
    80000f82:	f822                	sd	s0,48(sp)
    80000f84:	f426                	sd	s1,40(sp)
    80000f86:	f04a                	sd	s2,32(sp)
    80000f88:	ec4e                	sd	s3,24(sp)
    80000f8a:	e852                	sd	s4,16(sp)
    80000f8c:	e456                	sd	s5,8(sp)
    80000f8e:	e05a                	sd	s6,0(sp)
    80000f90:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f92:	00007597          	auipc	a1,0x7
    80000f96:	1fe58593          	addi	a1,a1,510 # 80008190 <etext+0x190>
    80000f9a:	00228517          	auipc	a0,0x228
    80000f9e:	0ce50513          	addi	a0,a0,206 # 80229068 <pid_lock>
    80000fa2:	00005097          	auipc	ra,0x5
    80000fa6:	340080e7          	jalr	832(ra) # 800062e2 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000faa:	00007597          	auipc	a1,0x7
    80000fae:	1ee58593          	addi	a1,a1,494 # 80008198 <etext+0x198>
    80000fb2:	00228517          	auipc	a0,0x228
    80000fb6:	0ce50513          	addi	a0,a0,206 # 80229080 <wait_lock>
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	328080e7          	jalr	808(ra) # 800062e2 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc2:	00228497          	auipc	s1,0x228
    80000fc6:	4d648493          	addi	s1,s1,1238 # 80229498 <proc>
      initlock(&p->lock, "proc");
    80000fca:	00007b17          	auipc	s6,0x7
    80000fce:	1deb0b13          	addi	s6,s6,478 # 800081a8 <etext+0x1a8>
      p->kstack = KSTACK((int) (p - proc));
    80000fd2:	8aa6                	mv	s5,s1
    80000fd4:	00007a17          	auipc	s4,0x7
    80000fd8:	02ca0a13          	addi	s4,s4,44 # 80008000 <etext>
    80000fdc:	04000937          	lui	s2,0x4000
    80000fe0:	197d                	addi	s2,s2,-1
    80000fe2:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fe4:	0022e997          	auipc	s3,0x22e
    80000fe8:	eb498993          	addi	s3,s3,-332 # 8022ee98 <tickslock>
      initlock(&p->lock, "proc");
    80000fec:	85da                	mv	a1,s6
    80000fee:	8526                	mv	a0,s1
    80000ff0:	00005097          	auipc	ra,0x5
    80000ff4:	2f2080e7          	jalr	754(ra) # 800062e2 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ff8:	415487b3          	sub	a5,s1,s5
    80000ffc:	878d                	srai	a5,a5,0x3
    80000ffe:	000a3703          	ld	a4,0(s4)
    80001002:	02e787b3          	mul	a5,a5,a4
    80001006:	2785                	addiw	a5,a5,1
    80001008:	00d7979b          	slliw	a5,a5,0xd
    8000100c:	40f907b3          	sub	a5,s2,a5
    80001010:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001012:	16848493          	addi	s1,s1,360
    80001016:	fd349be3          	bne	s1,s3,80000fec <procinit+0x6e>
  }
}
    8000101a:	70e2                	ld	ra,56(sp)
    8000101c:	7442                	ld	s0,48(sp)
    8000101e:	74a2                	ld	s1,40(sp)
    80001020:	7902                	ld	s2,32(sp)
    80001022:	69e2                	ld	s3,24(sp)
    80001024:	6a42                	ld	s4,16(sp)
    80001026:	6aa2                	ld	s5,8(sp)
    80001028:	6b02                	ld	s6,0(sp)
    8000102a:	6121                	addi	sp,sp,64
    8000102c:	8082                	ret

000000008000102e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000102e:	1141                	addi	sp,sp,-16
    80001030:	e422                	sd	s0,8(sp)
    80001032:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001034:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001036:	2501                	sext.w	a0,a0
    80001038:	6422                	ld	s0,8(sp)
    8000103a:	0141                	addi	sp,sp,16
    8000103c:	8082                	ret

000000008000103e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    8000103e:	1141                	addi	sp,sp,-16
    80001040:	e422                	sd	s0,8(sp)
    80001042:	0800                	addi	s0,sp,16
    80001044:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001046:	2781                	sext.w	a5,a5
    80001048:	079e                	slli	a5,a5,0x7
  return c;
}
    8000104a:	00228517          	auipc	a0,0x228
    8000104e:	04e50513          	addi	a0,a0,78 # 80229098 <cpus>
    80001052:	953e                	add	a0,a0,a5
    80001054:	6422                	ld	s0,8(sp)
    80001056:	0141                	addi	sp,sp,16
    80001058:	8082                	ret

000000008000105a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    8000105a:	1101                	addi	sp,sp,-32
    8000105c:	ec06                	sd	ra,24(sp)
    8000105e:	e822                	sd	s0,16(sp)
    80001060:	e426                	sd	s1,8(sp)
    80001062:	1000                	addi	s0,sp,32
  push_off();
    80001064:	00005097          	auipc	ra,0x5
    80001068:	2c2080e7          	jalr	706(ra) # 80006326 <push_off>
    8000106c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000106e:	2781                	sext.w	a5,a5
    80001070:	079e                	slli	a5,a5,0x7
    80001072:	00228717          	auipc	a4,0x228
    80001076:	ff670713          	addi	a4,a4,-10 # 80229068 <pid_lock>
    8000107a:	97ba                	add	a5,a5,a4
    8000107c:	7b84                	ld	s1,48(a5)
  pop_off();
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	348080e7          	jalr	840(ra) # 800063c6 <pop_off>
  return p;
}
    80001086:	8526                	mv	a0,s1
    80001088:	60e2                	ld	ra,24(sp)
    8000108a:	6442                	ld	s0,16(sp)
    8000108c:	64a2                	ld	s1,8(sp)
    8000108e:	6105                	addi	sp,sp,32
    80001090:	8082                	ret

0000000080001092 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001092:	1141                	addi	sp,sp,-16
    80001094:	e406                	sd	ra,8(sp)
    80001096:	e022                	sd	s0,0(sp)
    80001098:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	fc0080e7          	jalr	-64(ra) # 8000105a <myproc>
    800010a2:	00005097          	auipc	ra,0x5
    800010a6:	384080e7          	jalr	900(ra) # 80006426 <release>

  if (first) {
    800010aa:	00007797          	auipc	a5,0x7
    800010ae:	7d67a783          	lw	a5,2006(a5) # 80008880 <first.1683>
    800010b2:	eb89                	bnez	a5,800010c4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800010b4:	00001097          	auipc	ra,0x1
    800010b8:	c0a080e7          	jalr	-1014(ra) # 80001cbe <usertrapret>
}
    800010bc:	60a2                	ld	ra,8(sp)
    800010be:	6402                	ld	s0,0(sp)
    800010c0:	0141                	addi	sp,sp,16
    800010c2:	8082                	ret
    first = 0;
    800010c4:	00007797          	auipc	a5,0x7
    800010c8:	7a07ae23          	sw	zero,1980(a5) # 80008880 <first.1683>
    fsinit(ROOTDEV);
    800010cc:	4505                	li	a0,1
    800010ce:	00002097          	auipc	ra,0x2
    800010d2:	a34080e7          	jalr	-1484(ra) # 80002b02 <fsinit>
    800010d6:	bff9                	j	800010b4 <forkret+0x22>

00000000800010d8 <allocpid>:
allocpid() {
    800010d8:	1101                	addi	sp,sp,-32
    800010da:	ec06                	sd	ra,24(sp)
    800010dc:	e822                	sd	s0,16(sp)
    800010de:	e426                	sd	s1,8(sp)
    800010e0:	e04a                	sd	s2,0(sp)
    800010e2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800010e4:	00228917          	auipc	s2,0x228
    800010e8:	f8490913          	addi	s2,s2,-124 # 80229068 <pid_lock>
    800010ec:	854a                	mv	a0,s2
    800010ee:	00005097          	auipc	ra,0x5
    800010f2:	284080e7          	jalr	644(ra) # 80006372 <acquire>
  pid = nextpid;
    800010f6:	00007797          	auipc	a5,0x7
    800010fa:	78e78793          	addi	a5,a5,1934 # 80008884 <nextpid>
    800010fe:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001100:	0014871b          	addiw	a4,s1,1
    80001104:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001106:	854a                	mv	a0,s2
    80001108:	00005097          	auipc	ra,0x5
    8000110c:	31e080e7          	jalr	798(ra) # 80006426 <release>
}
    80001110:	8526                	mv	a0,s1
    80001112:	60e2                	ld	ra,24(sp)
    80001114:	6442                	ld	s0,16(sp)
    80001116:	64a2                	ld	s1,8(sp)
    80001118:	6902                	ld	s2,0(sp)
    8000111a:	6105                	addi	sp,sp,32
    8000111c:	8082                	ret

000000008000111e <proc_pagetable>:
{
    8000111e:	1101                	addi	sp,sp,-32
    80001120:	ec06                	sd	ra,24(sp)
    80001122:	e822                	sd	s0,16(sp)
    80001124:	e426                	sd	s1,8(sp)
    80001126:	e04a                	sd	s2,0(sp)
    80001128:	1000                	addi	s0,sp,32
    8000112a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000112c:	00000097          	auipc	ra,0x0
    80001130:	806080e7          	jalr	-2042(ra) # 80000932 <uvmcreate>
    80001134:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001136:	c121                	beqz	a0,80001176 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001138:	4729                	li	a4,10
    8000113a:	00006697          	auipc	a3,0x6
    8000113e:	ec668693          	addi	a3,a3,-314 # 80007000 <_trampoline>
    80001142:	6605                	lui	a2,0x1
    80001144:	040005b7          	lui	a1,0x4000
    80001148:	15fd                	addi	a1,a1,-1
    8000114a:	05b2                	slli	a1,a1,0xc
    8000114c:	fffff097          	auipc	ra,0xfffff
    80001150:	55c080e7          	jalr	1372(ra) # 800006a8 <mappages>
    80001154:	02054863          	bltz	a0,80001184 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001158:	4719                	li	a4,6
    8000115a:	05893683          	ld	a3,88(s2)
    8000115e:	6605                	lui	a2,0x1
    80001160:	020005b7          	lui	a1,0x2000
    80001164:	15fd                	addi	a1,a1,-1
    80001166:	05b6                	slli	a1,a1,0xd
    80001168:	8526                	mv	a0,s1
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	53e080e7          	jalr	1342(ra) # 800006a8 <mappages>
    80001172:	02054163          	bltz	a0,80001194 <proc_pagetable+0x76>
}
    80001176:	8526                	mv	a0,s1
    80001178:	60e2                	ld	ra,24(sp)
    8000117a:	6442                	ld	s0,16(sp)
    8000117c:	64a2                	ld	s1,8(sp)
    8000117e:	6902                	ld	s2,0(sp)
    80001180:	6105                	addi	sp,sp,32
    80001182:	8082                	ret
    uvmfree(pagetable, 0);
    80001184:	4581                	li	a1,0
    80001186:	8526                	mv	a0,s1
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	9a6080e7          	jalr	-1626(ra) # 80000b2e <uvmfree>
    return 0;
    80001190:	4481                	li	s1,0
    80001192:	b7d5                	j	80001176 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001194:	4681                	li	a3,0
    80001196:	4605                	li	a2,1
    80001198:	040005b7          	lui	a1,0x4000
    8000119c:	15fd                	addi	a1,a1,-1
    8000119e:	05b2                	slli	a1,a1,0xc
    800011a0:	8526                	mv	a0,s1
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	6cc080e7          	jalr	1740(ra) # 8000086e <uvmunmap>
    uvmfree(pagetable, 0);
    800011aa:	4581                	li	a1,0
    800011ac:	8526                	mv	a0,s1
    800011ae:	00000097          	auipc	ra,0x0
    800011b2:	980080e7          	jalr	-1664(ra) # 80000b2e <uvmfree>
    return 0;
    800011b6:	4481                	li	s1,0
    800011b8:	bf7d                	j	80001176 <proc_pagetable+0x58>

00000000800011ba <proc_freepagetable>:
{
    800011ba:	1101                	addi	sp,sp,-32
    800011bc:	ec06                	sd	ra,24(sp)
    800011be:	e822                	sd	s0,16(sp)
    800011c0:	e426                	sd	s1,8(sp)
    800011c2:	e04a                	sd	s2,0(sp)
    800011c4:	1000                	addi	s0,sp,32
    800011c6:	84aa                	mv	s1,a0
    800011c8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011ca:	4681                	li	a3,0
    800011cc:	4605                	li	a2,1
    800011ce:	040005b7          	lui	a1,0x4000
    800011d2:	15fd                	addi	a1,a1,-1
    800011d4:	05b2                	slli	a1,a1,0xc
    800011d6:	fffff097          	auipc	ra,0xfffff
    800011da:	698080e7          	jalr	1688(ra) # 8000086e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011de:	4681                	li	a3,0
    800011e0:	4605                	li	a2,1
    800011e2:	020005b7          	lui	a1,0x2000
    800011e6:	15fd                	addi	a1,a1,-1
    800011e8:	05b6                	slli	a1,a1,0xd
    800011ea:	8526                	mv	a0,s1
    800011ec:	fffff097          	auipc	ra,0xfffff
    800011f0:	682080e7          	jalr	1666(ra) # 8000086e <uvmunmap>
  uvmfree(pagetable, sz);
    800011f4:	85ca                	mv	a1,s2
    800011f6:	8526                	mv	a0,s1
    800011f8:	00000097          	auipc	ra,0x0
    800011fc:	936080e7          	jalr	-1738(ra) # 80000b2e <uvmfree>
}
    80001200:	60e2                	ld	ra,24(sp)
    80001202:	6442                	ld	s0,16(sp)
    80001204:	64a2                	ld	s1,8(sp)
    80001206:	6902                	ld	s2,0(sp)
    80001208:	6105                	addi	sp,sp,32
    8000120a:	8082                	ret

000000008000120c <freeproc>:
{
    8000120c:	1101                	addi	sp,sp,-32
    8000120e:	ec06                	sd	ra,24(sp)
    80001210:	e822                	sd	s0,16(sp)
    80001212:	e426                	sd	s1,8(sp)
    80001214:	1000                	addi	s0,sp,32
    80001216:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001218:	6d28                	ld	a0,88(a0)
    8000121a:	c509                	beqz	a0,80001224 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000121c:	fffff097          	auipc	ra,0xfffff
    80001220:	ed6080e7          	jalr	-298(ra) # 800000f2 <kfree>
  p->trapframe = 0;
    80001224:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001228:	68a8                	ld	a0,80(s1)
    8000122a:	c511                	beqz	a0,80001236 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000122c:	64ac                	ld	a1,72(s1)
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	f8c080e7          	jalr	-116(ra) # 800011ba <proc_freepagetable>
  p->pagetable = 0;
    80001236:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000123a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000123e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001242:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001246:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000124a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000124e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001252:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001256:	0004ac23          	sw	zero,24(s1)
}
    8000125a:	60e2                	ld	ra,24(sp)
    8000125c:	6442                	ld	s0,16(sp)
    8000125e:	64a2                	ld	s1,8(sp)
    80001260:	6105                	addi	sp,sp,32
    80001262:	8082                	ret

0000000080001264 <allocproc>:
{
    80001264:	1101                	addi	sp,sp,-32
    80001266:	ec06                	sd	ra,24(sp)
    80001268:	e822                	sd	s0,16(sp)
    8000126a:	e426                	sd	s1,8(sp)
    8000126c:	e04a                	sd	s2,0(sp)
    8000126e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001270:	00228497          	auipc	s1,0x228
    80001274:	22848493          	addi	s1,s1,552 # 80229498 <proc>
    80001278:	0022e917          	auipc	s2,0x22e
    8000127c:	c2090913          	addi	s2,s2,-992 # 8022ee98 <tickslock>
    acquire(&p->lock);
    80001280:	8526                	mv	a0,s1
    80001282:	00005097          	auipc	ra,0x5
    80001286:	0f0080e7          	jalr	240(ra) # 80006372 <acquire>
    if(p->state == UNUSED) {
    8000128a:	4c9c                	lw	a5,24(s1)
    8000128c:	cf81                	beqz	a5,800012a4 <allocproc+0x40>
      release(&p->lock);
    8000128e:	8526                	mv	a0,s1
    80001290:	00005097          	auipc	ra,0x5
    80001294:	196080e7          	jalr	406(ra) # 80006426 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001298:	16848493          	addi	s1,s1,360
    8000129c:	ff2492e3          	bne	s1,s2,80001280 <allocproc+0x1c>
  return 0;
    800012a0:	4481                	li	s1,0
    800012a2:	a889                	j	800012f4 <allocproc+0x90>
  p->pid = allocpid();
    800012a4:	00000097          	auipc	ra,0x0
    800012a8:	e34080e7          	jalr	-460(ra) # 800010d8 <allocpid>
    800012ac:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012ae:	4785                	li	a5,1
    800012b0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012b2:	fffff097          	auipc	ra,0xfffff
    800012b6:	fb4080e7          	jalr	-76(ra) # 80000266 <kalloc>
    800012ba:	892a                	mv	s2,a0
    800012bc:	eca8                	sd	a0,88(s1)
    800012be:	c131                	beqz	a0,80001302 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012c0:	8526                	mv	a0,s1
    800012c2:	00000097          	auipc	ra,0x0
    800012c6:	e5c080e7          	jalr	-420(ra) # 8000111e <proc_pagetable>
    800012ca:	892a                	mv	s2,a0
    800012cc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012ce:	c531                	beqz	a0,8000131a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800012d0:	07000613          	li	a2,112
    800012d4:	4581                	li	a1,0
    800012d6:	06048513          	addi	a0,s1,96
    800012da:	fffff097          	auipc	ra,0xfffff
    800012de:	ffe080e7          	jalr	-2(ra) # 800002d8 <memset>
  p->context.ra = (uint64)forkret;
    800012e2:	00000797          	auipc	a5,0x0
    800012e6:	db078793          	addi	a5,a5,-592 # 80001092 <forkret>
    800012ea:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012ec:	60bc                	ld	a5,64(s1)
    800012ee:	6705                	lui	a4,0x1
    800012f0:	97ba                	add	a5,a5,a4
    800012f2:	f4bc                	sd	a5,104(s1)
}
    800012f4:	8526                	mv	a0,s1
    800012f6:	60e2                	ld	ra,24(sp)
    800012f8:	6442                	ld	s0,16(sp)
    800012fa:	64a2                	ld	s1,8(sp)
    800012fc:	6902                	ld	s2,0(sp)
    800012fe:	6105                	addi	sp,sp,32
    80001300:	8082                	ret
    freeproc(p);
    80001302:	8526                	mv	a0,s1
    80001304:	00000097          	auipc	ra,0x0
    80001308:	f08080e7          	jalr	-248(ra) # 8000120c <freeproc>
    release(&p->lock);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	118080e7          	jalr	280(ra) # 80006426 <release>
    return 0;
    80001316:	84ca                	mv	s1,s2
    80001318:	bff1                	j	800012f4 <allocproc+0x90>
    freeproc(p);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00000097          	auipc	ra,0x0
    80001320:	ef0080e7          	jalr	-272(ra) # 8000120c <freeproc>
    release(&p->lock);
    80001324:	8526                	mv	a0,s1
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	100080e7          	jalr	256(ra) # 80006426 <release>
    return 0;
    8000132e:	84ca                	mv	s1,s2
    80001330:	b7d1                	j	800012f4 <allocproc+0x90>

0000000080001332 <userinit>:
{
    80001332:	1101                	addi	sp,sp,-32
    80001334:	ec06                	sd	ra,24(sp)
    80001336:	e822                	sd	s0,16(sp)
    80001338:	e426                	sd	s1,8(sp)
    8000133a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	f28080e7          	jalr	-216(ra) # 80001264 <allocproc>
    80001344:	84aa                	mv	s1,a0
  initproc = p;
    80001346:	00008797          	auipc	a5,0x8
    8000134a:	cca7b523          	sd	a0,-822(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000134e:	03400613          	li	a2,52
    80001352:	00007597          	auipc	a1,0x7
    80001356:	53e58593          	addi	a1,a1,1342 # 80008890 <initcode>
    8000135a:	6928                	ld	a0,80(a0)
    8000135c:	fffff097          	auipc	ra,0xfffff
    80001360:	604080e7          	jalr	1540(ra) # 80000960 <uvminit>
  p->sz = PGSIZE;
    80001364:	6785                	lui	a5,0x1
    80001366:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001368:	6cb8                	ld	a4,88(s1)
    8000136a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000136e:	6cb8                	ld	a4,88(s1)
    80001370:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001372:	4641                	li	a2,16
    80001374:	00007597          	auipc	a1,0x7
    80001378:	e3c58593          	addi	a1,a1,-452 # 800081b0 <etext+0x1b0>
    8000137c:	15848513          	addi	a0,s1,344
    80001380:	fffff097          	auipc	ra,0xfffff
    80001384:	0aa080e7          	jalr	170(ra) # 8000042a <safestrcpy>
  p->cwd = namei("/");
    80001388:	00007517          	auipc	a0,0x7
    8000138c:	e3850513          	addi	a0,a0,-456 # 800081c0 <etext+0x1c0>
    80001390:	00002097          	auipc	ra,0x2
    80001394:	1a0080e7          	jalr	416(ra) # 80003530 <namei>
    80001398:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000139c:	478d                	li	a5,3
    8000139e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013a0:	8526                	mv	a0,s1
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	084080e7          	jalr	132(ra) # 80006426 <release>
}
    800013aa:	60e2                	ld	ra,24(sp)
    800013ac:	6442                	ld	s0,16(sp)
    800013ae:	64a2                	ld	s1,8(sp)
    800013b0:	6105                	addi	sp,sp,32
    800013b2:	8082                	ret

00000000800013b4 <growproc>:
{
    800013b4:	1101                	addi	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	e04a                	sd	s2,0(sp)
    800013be:	1000                	addi	s0,sp,32
    800013c0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800013c2:	00000097          	auipc	ra,0x0
    800013c6:	c98080e7          	jalr	-872(ra) # 8000105a <myproc>
    800013ca:	892a                	mv	s2,a0
  sz = p->sz;
    800013cc:	652c                	ld	a1,72(a0)
    800013ce:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800013d2:	00904f63          	bgtz	s1,800013f0 <growproc+0x3c>
  } else if(n < 0){
    800013d6:	0204cc63          	bltz	s1,8000140e <growproc+0x5a>
  p->sz = sz;
    800013da:	1602                	slli	a2,a2,0x20
    800013dc:	9201                	srli	a2,a2,0x20
    800013de:	04c93423          	sd	a2,72(s2)
  return 0;
    800013e2:	4501                	li	a0,0
}
    800013e4:	60e2                	ld	ra,24(sp)
    800013e6:	6442                	ld	s0,16(sp)
    800013e8:	64a2                	ld	s1,8(sp)
    800013ea:	6902                	ld	s2,0(sp)
    800013ec:	6105                	addi	sp,sp,32
    800013ee:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013f0:	9e25                	addw	a2,a2,s1
    800013f2:	1602                	slli	a2,a2,0x20
    800013f4:	9201                	srli	a2,a2,0x20
    800013f6:	1582                	slli	a1,a1,0x20
    800013f8:	9181                	srli	a1,a1,0x20
    800013fa:	6928                	ld	a0,80(a0)
    800013fc:	fffff097          	auipc	ra,0xfffff
    80001400:	61e080e7          	jalr	1566(ra) # 80000a1a <uvmalloc>
    80001404:	0005061b          	sext.w	a2,a0
    80001408:	fa69                	bnez	a2,800013da <growproc+0x26>
      return -1;
    8000140a:	557d                	li	a0,-1
    8000140c:	bfe1                	j	800013e4 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000140e:	9e25                	addw	a2,a2,s1
    80001410:	1602                	slli	a2,a2,0x20
    80001412:	9201                	srli	a2,a2,0x20
    80001414:	1582                	slli	a1,a1,0x20
    80001416:	9181                	srli	a1,a1,0x20
    80001418:	6928                	ld	a0,80(a0)
    8000141a:	fffff097          	auipc	ra,0xfffff
    8000141e:	5b8080e7          	jalr	1464(ra) # 800009d2 <uvmdealloc>
    80001422:	0005061b          	sext.w	a2,a0
    80001426:	bf55                	j	800013da <growproc+0x26>

0000000080001428 <fork>:
{
    80001428:	7179                	addi	sp,sp,-48
    8000142a:	f406                	sd	ra,40(sp)
    8000142c:	f022                	sd	s0,32(sp)
    8000142e:	ec26                	sd	s1,24(sp)
    80001430:	e84a                	sd	s2,16(sp)
    80001432:	e44e                	sd	s3,8(sp)
    80001434:	e052                	sd	s4,0(sp)
    80001436:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001438:	00000097          	auipc	ra,0x0
    8000143c:	c22080e7          	jalr	-990(ra) # 8000105a <myproc>
    80001440:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001442:	00000097          	auipc	ra,0x0
    80001446:	e22080e7          	jalr	-478(ra) # 80001264 <allocproc>
    8000144a:	10050b63          	beqz	a0,80001560 <fork+0x138>
    8000144e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001450:	04893603          	ld	a2,72(s2)
    80001454:	692c                	ld	a1,80(a0)
    80001456:	05093503          	ld	a0,80(s2)
    8000145a:	fffff097          	auipc	ra,0xfffff
    8000145e:	70c080e7          	jalr	1804(ra) # 80000b66 <uvmcopy>
    80001462:	04054663          	bltz	a0,800014ae <fork+0x86>
  np->sz = p->sz;
    80001466:	04893783          	ld	a5,72(s2)
    8000146a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000146e:	05893683          	ld	a3,88(s2)
    80001472:	87b6                	mv	a5,a3
    80001474:	0589b703          	ld	a4,88(s3)
    80001478:	12068693          	addi	a3,a3,288
    8000147c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001480:	6788                	ld	a0,8(a5)
    80001482:	6b8c                	ld	a1,16(a5)
    80001484:	6f90                	ld	a2,24(a5)
    80001486:	01073023          	sd	a6,0(a4)
    8000148a:	e708                	sd	a0,8(a4)
    8000148c:	eb0c                	sd	a1,16(a4)
    8000148e:	ef10                	sd	a2,24(a4)
    80001490:	02078793          	addi	a5,a5,32
    80001494:	02070713          	addi	a4,a4,32
    80001498:	fed792e3          	bne	a5,a3,8000147c <fork+0x54>
  np->trapframe->a0 = 0;
    8000149c:	0589b783          	ld	a5,88(s3)
    800014a0:	0607b823          	sd	zero,112(a5)
    800014a4:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800014a8:	15000a13          	li	s4,336
    800014ac:	a03d                	j	800014da <fork+0xb2>
    freeproc(np);
    800014ae:	854e                	mv	a0,s3
    800014b0:	00000097          	auipc	ra,0x0
    800014b4:	d5c080e7          	jalr	-676(ra) # 8000120c <freeproc>
    release(&np->lock);
    800014b8:	854e                	mv	a0,s3
    800014ba:	00005097          	auipc	ra,0x5
    800014be:	f6c080e7          	jalr	-148(ra) # 80006426 <release>
    return -1;
    800014c2:	5a7d                	li	s4,-1
    800014c4:	a069                	j	8000154e <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800014c6:	00002097          	auipc	ra,0x2
    800014ca:	700080e7          	jalr	1792(ra) # 80003bc6 <filedup>
    800014ce:	009987b3          	add	a5,s3,s1
    800014d2:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800014d4:	04a1                	addi	s1,s1,8
    800014d6:	01448763          	beq	s1,s4,800014e4 <fork+0xbc>
    if(p->ofile[i])
    800014da:	009907b3          	add	a5,s2,s1
    800014de:	6388                	ld	a0,0(a5)
    800014e0:	f17d                	bnez	a0,800014c6 <fork+0x9e>
    800014e2:	bfcd                	j	800014d4 <fork+0xac>
  np->cwd = idup(p->cwd);
    800014e4:	15093503          	ld	a0,336(s2)
    800014e8:	00002097          	auipc	ra,0x2
    800014ec:	854080e7          	jalr	-1964(ra) # 80002d3c <idup>
    800014f0:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014f4:	4641                	li	a2,16
    800014f6:	15890593          	addi	a1,s2,344
    800014fa:	15898513          	addi	a0,s3,344
    800014fe:	fffff097          	auipc	ra,0xfffff
    80001502:	f2c080e7          	jalr	-212(ra) # 8000042a <safestrcpy>
  pid = np->pid;
    80001506:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000150a:	854e                	mv	a0,s3
    8000150c:	00005097          	auipc	ra,0x5
    80001510:	f1a080e7          	jalr	-230(ra) # 80006426 <release>
  acquire(&wait_lock);
    80001514:	00228497          	auipc	s1,0x228
    80001518:	b6c48493          	addi	s1,s1,-1172 # 80229080 <wait_lock>
    8000151c:	8526                	mv	a0,s1
    8000151e:	00005097          	auipc	ra,0x5
    80001522:	e54080e7          	jalr	-428(ra) # 80006372 <acquire>
  np->parent = p;
    80001526:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000152a:	8526                	mv	a0,s1
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	efa080e7          	jalr	-262(ra) # 80006426 <release>
  acquire(&np->lock);
    80001534:	854e                	mv	a0,s3
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	e3c080e7          	jalr	-452(ra) # 80006372 <acquire>
  np->state = RUNNABLE;
    8000153e:	478d                	li	a5,3
    80001540:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001544:	854e                	mv	a0,s3
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	ee0080e7          	jalr	-288(ra) # 80006426 <release>
}
    8000154e:	8552                	mv	a0,s4
    80001550:	70a2                	ld	ra,40(sp)
    80001552:	7402                	ld	s0,32(sp)
    80001554:	64e2                	ld	s1,24(sp)
    80001556:	6942                	ld	s2,16(sp)
    80001558:	69a2                	ld	s3,8(sp)
    8000155a:	6a02                	ld	s4,0(sp)
    8000155c:	6145                	addi	sp,sp,48
    8000155e:	8082                	ret
    return -1;
    80001560:	5a7d                	li	s4,-1
    80001562:	b7f5                	j	8000154e <fork+0x126>

0000000080001564 <scheduler>:
{
    80001564:	7139                	addi	sp,sp,-64
    80001566:	fc06                	sd	ra,56(sp)
    80001568:	f822                	sd	s0,48(sp)
    8000156a:	f426                	sd	s1,40(sp)
    8000156c:	f04a                	sd	s2,32(sp)
    8000156e:	ec4e                	sd	s3,24(sp)
    80001570:	e852                	sd	s4,16(sp)
    80001572:	e456                	sd	s5,8(sp)
    80001574:	e05a                	sd	s6,0(sp)
    80001576:	0080                	addi	s0,sp,64
    80001578:	8792                	mv	a5,tp
  int id = r_tp();
    8000157a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000157c:	00779a93          	slli	s5,a5,0x7
    80001580:	00228717          	auipc	a4,0x228
    80001584:	ae870713          	addi	a4,a4,-1304 # 80229068 <pid_lock>
    80001588:	9756                	add	a4,a4,s5
    8000158a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000158e:	00228717          	auipc	a4,0x228
    80001592:	b1270713          	addi	a4,a4,-1262 # 802290a0 <cpus+0x8>
    80001596:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001598:	498d                	li	s3,3
        p->state = RUNNING;
    8000159a:	4b11                	li	s6,4
        c->proc = p;
    8000159c:	079e                	slli	a5,a5,0x7
    8000159e:	00228a17          	auipc	s4,0x228
    800015a2:	acaa0a13          	addi	s4,s4,-1334 # 80229068 <pid_lock>
    800015a6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015a8:	0022e917          	auipc	s2,0x22e
    800015ac:	8f090913          	addi	s2,s2,-1808 # 8022ee98 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015b0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015b4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015b8:	10079073          	csrw	sstatus,a5
    800015bc:	00228497          	auipc	s1,0x228
    800015c0:	edc48493          	addi	s1,s1,-292 # 80229498 <proc>
    800015c4:	a03d                	j	800015f2 <scheduler+0x8e>
        p->state = RUNNING;
    800015c6:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015ca:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015ce:	06048593          	addi	a1,s1,96
    800015d2:	8556                	mv	a0,s5
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	640080e7          	jalr	1600(ra) # 80001c14 <swtch>
        c->proc = 0;
    800015dc:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800015e0:	8526                	mv	a0,s1
    800015e2:	00005097          	auipc	ra,0x5
    800015e6:	e44080e7          	jalr	-444(ra) # 80006426 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ea:	16848493          	addi	s1,s1,360
    800015ee:	fd2481e3          	beq	s1,s2,800015b0 <scheduler+0x4c>
      acquire(&p->lock);
    800015f2:	8526                	mv	a0,s1
    800015f4:	00005097          	auipc	ra,0x5
    800015f8:	d7e080e7          	jalr	-642(ra) # 80006372 <acquire>
      if(p->state == RUNNABLE) {
    800015fc:	4c9c                	lw	a5,24(s1)
    800015fe:	ff3791e3          	bne	a5,s3,800015e0 <scheduler+0x7c>
    80001602:	b7d1                	j	800015c6 <scheduler+0x62>

0000000080001604 <sched>:
{
    80001604:	7179                	addi	sp,sp,-48
    80001606:	f406                	sd	ra,40(sp)
    80001608:	f022                	sd	s0,32(sp)
    8000160a:	ec26                	sd	s1,24(sp)
    8000160c:	e84a                	sd	s2,16(sp)
    8000160e:	e44e                	sd	s3,8(sp)
    80001610:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001612:	00000097          	auipc	ra,0x0
    80001616:	a48080e7          	jalr	-1464(ra) # 8000105a <myproc>
    8000161a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000161c:	00005097          	auipc	ra,0x5
    80001620:	cdc080e7          	jalr	-804(ra) # 800062f8 <holding>
    80001624:	c93d                	beqz	a0,8000169a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001626:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001628:	2781                	sext.w	a5,a5
    8000162a:	079e                	slli	a5,a5,0x7
    8000162c:	00228717          	auipc	a4,0x228
    80001630:	a3c70713          	addi	a4,a4,-1476 # 80229068 <pid_lock>
    80001634:	97ba                	add	a5,a5,a4
    80001636:	0a87a703          	lw	a4,168(a5)
    8000163a:	4785                	li	a5,1
    8000163c:	06f71763          	bne	a4,a5,800016aa <sched+0xa6>
  if(p->state == RUNNING)
    80001640:	4c98                	lw	a4,24(s1)
    80001642:	4791                	li	a5,4
    80001644:	06f70b63          	beq	a4,a5,800016ba <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001648:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000164c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000164e:	efb5                	bnez	a5,800016ca <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001650:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001652:	00228917          	auipc	s2,0x228
    80001656:	a1690913          	addi	s2,s2,-1514 # 80229068 <pid_lock>
    8000165a:	2781                	sext.w	a5,a5
    8000165c:	079e                	slli	a5,a5,0x7
    8000165e:	97ca                	add	a5,a5,s2
    80001660:	0ac7a983          	lw	s3,172(a5)
    80001664:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001666:	2781                	sext.w	a5,a5
    80001668:	079e                	slli	a5,a5,0x7
    8000166a:	00228597          	auipc	a1,0x228
    8000166e:	a3658593          	addi	a1,a1,-1482 # 802290a0 <cpus+0x8>
    80001672:	95be                	add	a1,a1,a5
    80001674:	06048513          	addi	a0,s1,96
    80001678:	00000097          	auipc	ra,0x0
    8000167c:	59c080e7          	jalr	1436(ra) # 80001c14 <swtch>
    80001680:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001682:	2781                	sext.w	a5,a5
    80001684:	079e                	slli	a5,a5,0x7
    80001686:	97ca                	add	a5,a5,s2
    80001688:	0b37a623          	sw	s3,172(a5)
}
    8000168c:	70a2                	ld	ra,40(sp)
    8000168e:	7402                	ld	s0,32(sp)
    80001690:	64e2                	ld	s1,24(sp)
    80001692:	6942                	ld	s2,16(sp)
    80001694:	69a2                	ld	s3,8(sp)
    80001696:	6145                	addi	sp,sp,48
    80001698:	8082                	ret
    panic("sched p->lock");
    8000169a:	00007517          	auipc	a0,0x7
    8000169e:	b2e50513          	addi	a0,a0,-1234 # 800081c8 <etext+0x1c8>
    800016a2:	00004097          	auipc	ra,0x4
    800016a6:	786080e7          	jalr	1926(ra) # 80005e28 <panic>
    panic("sched locks");
    800016aa:	00007517          	auipc	a0,0x7
    800016ae:	b2e50513          	addi	a0,a0,-1234 # 800081d8 <etext+0x1d8>
    800016b2:	00004097          	auipc	ra,0x4
    800016b6:	776080e7          	jalr	1910(ra) # 80005e28 <panic>
    panic("sched running");
    800016ba:	00007517          	auipc	a0,0x7
    800016be:	b2e50513          	addi	a0,a0,-1234 # 800081e8 <etext+0x1e8>
    800016c2:	00004097          	auipc	ra,0x4
    800016c6:	766080e7          	jalr	1894(ra) # 80005e28 <panic>
    panic("sched interruptible");
    800016ca:	00007517          	auipc	a0,0x7
    800016ce:	b2e50513          	addi	a0,a0,-1234 # 800081f8 <etext+0x1f8>
    800016d2:	00004097          	auipc	ra,0x4
    800016d6:	756080e7          	jalr	1878(ra) # 80005e28 <panic>

00000000800016da <yield>:
{
    800016da:	1101                	addi	sp,sp,-32
    800016dc:	ec06                	sd	ra,24(sp)
    800016de:	e822                	sd	s0,16(sp)
    800016e0:	e426                	sd	s1,8(sp)
    800016e2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016e4:	00000097          	auipc	ra,0x0
    800016e8:	976080e7          	jalr	-1674(ra) # 8000105a <myproc>
    800016ec:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016ee:	00005097          	auipc	ra,0x5
    800016f2:	c84080e7          	jalr	-892(ra) # 80006372 <acquire>
  p->state = RUNNABLE;
    800016f6:	478d                	li	a5,3
    800016f8:	cc9c                	sw	a5,24(s1)
  sched();
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	f0a080e7          	jalr	-246(ra) # 80001604 <sched>
  release(&p->lock);
    80001702:	8526                	mv	a0,s1
    80001704:	00005097          	auipc	ra,0x5
    80001708:	d22080e7          	jalr	-734(ra) # 80006426 <release>
}
    8000170c:	60e2                	ld	ra,24(sp)
    8000170e:	6442                	ld	s0,16(sp)
    80001710:	64a2                	ld	s1,8(sp)
    80001712:	6105                	addi	sp,sp,32
    80001714:	8082                	ret

0000000080001716 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001716:	7179                	addi	sp,sp,-48
    80001718:	f406                	sd	ra,40(sp)
    8000171a:	f022                	sd	s0,32(sp)
    8000171c:	ec26                	sd	s1,24(sp)
    8000171e:	e84a                	sd	s2,16(sp)
    80001720:	e44e                	sd	s3,8(sp)
    80001722:	1800                	addi	s0,sp,48
    80001724:	89aa                	mv	s3,a0
    80001726:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001728:	00000097          	auipc	ra,0x0
    8000172c:	932080e7          	jalr	-1742(ra) # 8000105a <myproc>
    80001730:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	c40080e7          	jalr	-960(ra) # 80006372 <acquire>
  release(lk);
    8000173a:	854a                	mv	a0,s2
    8000173c:	00005097          	auipc	ra,0x5
    80001740:	cea080e7          	jalr	-790(ra) # 80006426 <release>

  // Go to sleep.
  p->chan = chan;
    80001744:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001748:	4789                	li	a5,2
    8000174a:	cc9c                	sw	a5,24(s1)

  sched();
    8000174c:	00000097          	auipc	ra,0x0
    80001750:	eb8080e7          	jalr	-328(ra) # 80001604 <sched>

  // Tidy up.
  p->chan = 0;
    80001754:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001758:	8526                	mv	a0,s1
    8000175a:	00005097          	auipc	ra,0x5
    8000175e:	ccc080e7          	jalr	-820(ra) # 80006426 <release>
  acquire(lk);
    80001762:	854a                	mv	a0,s2
    80001764:	00005097          	auipc	ra,0x5
    80001768:	c0e080e7          	jalr	-1010(ra) # 80006372 <acquire>
}
    8000176c:	70a2                	ld	ra,40(sp)
    8000176e:	7402                	ld	s0,32(sp)
    80001770:	64e2                	ld	s1,24(sp)
    80001772:	6942                	ld	s2,16(sp)
    80001774:	69a2                	ld	s3,8(sp)
    80001776:	6145                	addi	sp,sp,48
    80001778:	8082                	ret

000000008000177a <wait>:
{
    8000177a:	715d                	addi	sp,sp,-80
    8000177c:	e486                	sd	ra,72(sp)
    8000177e:	e0a2                	sd	s0,64(sp)
    80001780:	fc26                	sd	s1,56(sp)
    80001782:	f84a                	sd	s2,48(sp)
    80001784:	f44e                	sd	s3,40(sp)
    80001786:	f052                	sd	s4,32(sp)
    80001788:	ec56                	sd	s5,24(sp)
    8000178a:	e85a                	sd	s6,16(sp)
    8000178c:	e45e                	sd	s7,8(sp)
    8000178e:	e062                	sd	s8,0(sp)
    80001790:	0880                	addi	s0,sp,80
    80001792:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001794:	00000097          	auipc	ra,0x0
    80001798:	8c6080e7          	jalr	-1850(ra) # 8000105a <myproc>
    8000179c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000179e:	00228517          	auipc	a0,0x228
    800017a2:	8e250513          	addi	a0,a0,-1822 # 80229080 <wait_lock>
    800017a6:	00005097          	auipc	ra,0x5
    800017aa:	bcc080e7          	jalr	-1076(ra) # 80006372 <acquire>
    havekids = 0;
    800017ae:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800017b0:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800017b2:	0022d997          	auipc	s3,0x22d
    800017b6:	6e698993          	addi	s3,s3,1766 # 8022ee98 <tickslock>
        havekids = 1;
    800017ba:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017bc:	00228c17          	auipc	s8,0x228
    800017c0:	8c4c0c13          	addi	s8,s8,-1852 # 80229080 <wait_lock>
    havekids = 0;
    800017c4:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800017c6:	00228497          	auipc	s1,0x228
    800017ca:	cd248493          	addi	s1,s1,-814 # 80229498 <proc>
    800017ce:	a0bd                	j	8000183c <wait+0xc2>
          pid = np->pid;
    800017d0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800017d4:	000b0e63          	beqz	s6,800017f0 <wait+0x76>
    800017d8:	4691                	li	a3,4
    800017da:	02c48613          	addi	a2,s1,44
    800017de:	85da                	mv	a1,s6
    800017e0:	05093503          	ld	a0,80(s2)
    800017e4:	fffff097          	auipc	ra,0xfffff
    800017e8:	5f4080e7          	jalr	1524(ra) # 80000dd8 <copyout>
    800017ec:	02054563          	bltz	a0,80001816 <wait+0x9c>
          freeproc(np);
    800017f0:	8526                	mv	a0,s1
    800017f2:	00000097          	auipc	ra,0x0
    800017f6:	a1a080e7          	jalr	-1510(ra) # 8000120c <freeproc>
          release(&np->lock);
    800017fa:	8526                	mv	a0,s1
    800017fc:	00005097          	auipc	ra,0x5
    80001800:	c2a080e7          	jalr	-982(ra) # 80006426 <release>
          release(&wait_lock);
    80001804:	00228517          	auipc	a0,0x228
    80001808:	87c50513          	addi	a0,a0,-1924 # 80229080 <wait_lock>
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	c1a080e7          	jalr	-998(ra) # 80006426 <release>
          return pid;
    80001814:	a09d                	j	8000187a <wait+0x100>
            release(&np->lock);
    80001816:	8526                	mv	a0,s1
    80001818:	00005097          	auipc	ra,0x5
    8000181c:	c0e080e7          	jalr	-1010(ra) # 80006426 <release>
            release(&wait_lock);
    80001820:	00228517          	auipc	a0,0x228
    80001824:	86050513          	addi	a0,a0,-1952 # 80229080 <wait_lock>
    80001828:	00005097          	auipc	ra,0x5
    8000182c:	bfe080e7          	jalr	-1026(ra) # 80006426 <release>
            return -1;
    80001830:	59fd                	li	s3,-1
    80001832:	a0a1                	j	8000187a <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001834:	16848493          	addi	s1,s1,360
    80001838:	03348463          	beq	s1,s3,80001860 <wait+0xe6>
      if(np->parent == p){
    8000183c:	7c9c                	ld	a5,56(s1)
    8000183e:	ff279be3          	bne	a5,s2,80001834 <wait+0xba>
        acquire(&np->lock);
    80001842:	8526                	mv	a0,s1
    80001844:	00005097          	auipc	ra,0x5
    80001848:	b2e080e7          	jalr	-1234(ra) # 80006372 <acquire>
        if(np->state == ZOMBIE){
    8000184c:	4c9c                	lw	a5,24(s1)
    8000184e:	f94781e3          	beq	a5,s4,800017d0 <wait+0x56>
        release(&np->lock);
    80001852:	8526                	mv	a0,s1
    80001854:	00005097          	auipc	ra,0x5
    80001858:	bd2080e7          	jalr	-1070(ra) # 80006426 <release>
        havekids = 1;
    8000185c:	8756                	mv	a4,s5
    8000185e:	bfd9                	j	80001834 <wait+0xba>
    if(!havekids || p->killed){
    80001860:	c701                	beqz	a4,80001868 <wait+0xee>
    80001862:	02892783          	lw	a5,40(s2)
    80001866:	c79d                	beqz	a5,80001894 <wait+0x11a>
      release(&wait_lock);
    80001868:	00228517          	auipc	a0,0x228
    8000186c:	81850513          	addi	a0,a0,-2024 # 80229080 <wait_lock>
    80001870:	00005097          	auipc	ra,0x5
    80001874:	bb6080e7          	jalr	-1098(ra) # 80006426 <release>
      return -1;
    80001878:	59fd                	li	s3,-1
}
    8000187a:	854e                	mv	a0,s3
    8000187c:	60a6                	ld	ra,72(sp)
    8000187e:	6406                	ld	s0,64(sp)
    80001880:	74e2                	ld	s1,56(sp)
    80001882:	7942                	ld	s2,48(sp)
    80001884:	79a2                	ld	s3,40(sp)
    80001886:	7a02                	ld	s4,32(sp)
    80001888:	6ae2                	ld	s5,24(sp)
    8000188a:	6b42                	ld	s6,16(sp)
    8000188c:	6ba2                	ld	s7,8(sp)
    8000188e:	6c02                	ld	s8,0(sp)
    80001890:	6161                	addi	sp,sp,80
    80001892:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001894:	85e2                	mv	a1,s8
    80001896:	854a                	mv	a0,s2
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	e7e080e7          	jalr	-386(ra) # 80001716 <sleep>
    havekids = 0;
    800018a0:	b715                	j	800017c4 <wait+0x4a>

00000000800018a2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800018a2:	7139                	addi	sp,sp,-64
    800018a4:	fc06                	sd	ra,56(sp)
    800018a6:	f822                	sd	s0,48(sp)
    800018a8:	f426                	sd	s1,40(sp)
    800018aa:	f04a                	sd	s2,32(sp)
    800018ac:	ec4e                	sd	s3,24(sp)
    800018ae:	e852                	sd	s4,16(sp)
    800018b0:	e456                	sd	s5,8(sp)
    800018b2:	0080                	addi	s0,sp,64
    800018b4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800018b6:	00228497          	auipc	s1,0x228
    800018ba:	be248493          	addi	s1,s1,-1054 # 80229498 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800018be:	4989                	li	s3,2
        p->state = RUNNABLE;
    800018c0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800018c2:	0022d917          	auipc	s2,0x22d
    800018c6:	5d690913          	addi	s2,s2,1494 # 8022ee98 <tickslock>
    800018ca:	a821                	j	800018e2 <wakeup+0x40>
        p->state = RUNNABLE;
    800018cc:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800018d0:	8526                	mv	a0,s1
    800018d2:	00005097          	auipc	ra,0x5
    800018d6:	b54080e7          	jalr	-1196(ra) # 80006426 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018da:	16848493          	addi	s1,s1,360
    800018de:	03248463          	beq	s1,s2,80001906 <wakeup+0x64>
    if(p != myproc()){
    800018e2:	fffff097          	auipc	ra,0xfffff
    800018e6:	778080e7          	jalr	1912(ra) # 8000105a <myproc>
    800018ea:	fea488e3          	beq	s1,a0,800018da <wakeup+0x38>
      acquire(&p->lock);
    800018ee:	8526                	mv	a0,s1
    800018f0:	00005097          	auipc	ra,0x5
    800018f4:	a82080e7          	jalr	-1406(ra) # 80006372 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018f8:	4c9c                	lw	a5,24(s1)
    800018fa:	fd379be3          	bne	a5,s3,800018d0 <wakeup+0x2e>
    800018fe:	709c                	ld	a5,32(s1)
    80001900:	fd4798e3          	bne	a5,s4,800018d0 <wakeup+0x2e>
    80001904:	b7e1                	j	800018cc <wakeup+0x2a>
    }
  }
}
    80001906:	70e2                	ld	ra,56(sp)
    80001908:	7442                	ld	s0,48(sp)
    8000190a:	74a2                	ld	s1,40(sp)
    8000190c:	7902                	ld	s2,32(sp)
    8000190e:	69e2                	ld	s3,24(sp)
    80001910:	6a42                	ld	s4,16(sp)
    80001912:	6aa2                	ld	s5,8(sp)
    80001914:	6121                	addi	sp,sp,64
    80001916:	8082                	ret

0000000080001918 <reparent>:
{
    80001918:	7179                	addi	sp,sp,-48
    8000191a:	f406                	sd	ra,40(sp)
    8000191c:	f022                	sd	s0,32(sp)
    8000191e:	ec26                	sd	s1,24(sp)
    80001920:	e84a                	sd	s2,16(sp)
    80001922:	e44e                	sd	s3,8(sp)
    80001924:	e052                	sd	s4,0(sp)
    80001926:	1800                	addi	s0,sp,48
    80001928:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000192a:	00228497          	auipc	s1,0x228
    8000192e:	b6e48493          	addi	s1,s1,-1170 # 80229498 <proc>
      pp->parent = initproc;
    80001932:	00007a17          	auipc	s4,0x7
    80001936:	6dea0a13          	addi	s4,s4,1758 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000193a:	0022d997          	auipc	s3,0x22d
    8000193e:	55e98993          	addi	s3,s3,1374 # 8022ee98 <tickslock>
    80001942:	a029                	j	8000194c <reparent+0x34>
    80001944:	16848493          	addi	s1,s1,360
    80001948:	01348d63          	beq	s1,s3,80001962 <reparent+0x4a>
    if(pp->parent == p){
    8000194c:	7c9c                	ld	a5,56(s1)
    8000194e:	ff279be3          	bne	a5,s2,80001944 <reparent+0x2c>
      pp->parent = initproc;
    80001952:	000a3503          	ld	a0,0(s4)
    80001956:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001958:	00000097          	auipc	ra,0x0
    8000195c:	f4a080e7          	jalr	-182(ra) # 800018a2 <wakeup>
    80001960:	b7d5                	j	80001944 <reparent+0x2c>
}
    80001962:	70a2                	ld	ra,40(sp)
    80001964:	7402                	ld	s0,32(sp)
    80001966:	64e2                	ld	s1,24(sp)
    80001968:	6942                	ld	s2,16(sp)
    8000196a:	69a2                	ld	s3,8(sp)
    8000196c:	6a02                	ld	s4,0(sp)
    8000196e:	6145                	addi	sp,sp,48
    80001970:	8082                	ret

0000000080001972 <exit>:
{
    80001972:	7179                	addi	sp,sp,-48
    80001974:	f406                	sd	ra,40(sp)
    80001976:	f022                	sd	s0,32(sp)
    80001978:	ec26                	sd	s1,24(sp)
    8000197a:	e84a                	sd	s2,16(sp)
    8000197c:	e44e                	sd	s3,8(sp)
    8000197e:	e052                	sd	s4,0(sp)
    80001980:	1800                	addi	s0,sp,48
    80001982:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	6d6080e7          	jalr	1750(ra) # 8000105a <myproc>
    8000198c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000198e:	00007797          	auipc	a5,0x7
    80001992:	6827b783          	ld	a5,1666(a5) # 80009010 <initproc>
    80001996:	0d050493          	addi	s1,a0,208
    8000199a:	15050913          	addi	s2,a0,336
    8000199e:	02a79363          	bne	a5,a0,800019c4 <exit+0x52>
    panic("init exiting");
    800019a2:	00007517          	auipc	a0,0x7
    800019a6:	86e50513          	addi	a0,a0,-1938 # 80008210 <etext+0x210>
    800019aa:	00004097          	auipc	ra,0x4
    800019ae:	47e080e7          	jalr	1150(ra) # 80005e28 <panic>
      fileclose(f);
    800019b2:	00002097          	auipc	ra,0x2
    800019b6:	266080e7          	jalr	614(ra) # 80003c18 <fileclose>
      p->ofile[fd] = 0;
    800019ba:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800019be:	04a1                	addi	s1,s1,8
    800019c0:	01248563          	beq	s1,s2,800019ca <exit+0x58>
    if(p->ofile[fd]){
    800019c4:	6088                	ld	a0,0(s1)
    800019c6:	f575                	bnez	a0,800019b2 <exit+0x40>
    800019c8:	bfdd                	j	800019be <exit+0x4c>
  begin_op();
    800019ca:	00002097          	auipc	ra,0x2
    800019ce:	d82080e7          	jalr	-638(ra) # 8000374c <begin_op>
  iput(p->cwd);
    800019d2:	1509b503          	ld	a0,336(s3)
    800019d6:	00001097          	auipc	ra,0x1
    800019da:	55e080e7          	jalr	1374(ra) # 80002f34 <iput>
  end_op();
    800019de:	00002097          	auipc	ra,0x2
    800019e2:	dee080e7          	jalr	-530(ra) # 800037cc <end_op>
  p->cwd = 0;
    800019e6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800019ea:	00227497          	auipc	s1,0x227
    800019ee:	69648493          	addi	s1,s1,1686 # 80229080 <wait_lock>
    800019f2:	8526                	mv	a0,s1
    800019f4:	00005097          	auipc	ra,0x5
    800019f8:	97e080e7          	jalr	-1666(ra) # 80006372 <acquire>
  reparent(p);
    800019fc:	854e                	mv	a0,s3
    800019fe:	00000097          	auipc	ra,0x0
    80001a02:	f1a080e7          	jalr	-230(ra) # 80001918 <reparent>
  wakeup(p->parent);
    80001a06:	0389b503          	ld	a0,56(s3)
    80001a0a:	00000097          	auipc	ra,0x0
    80001a0e:	e98080e7          	jalr	-360(ra) # 800018a2 <wakeup>
  acquire(&p->lock);
    80001a12:	854e                	mv	a0,s3
    80001a14:	00005097          	auipc	ra,0x5
    80001a18:	95e080e7          	jalr	-1698(ra) # 80006372 <acquire>
  p->xstate = status;
    80001a1c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a20:	4795                	li	a5,5
    80001a22:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a26:	8526                	mv	a0,s1
    80001a28:	00005097          	auipc	ra,0x5
    80001a2c:	9fe080e7          	jalr	-1538(ra) # 80006426 <release>
  sched();
    80001a30:	00000097          	auipc	ra,0x0
    80001a34:	bd4080e7          	jalr	-1068(ra) # 80001604 <sched>
  panic("zombie exit");
    80001a38:	00006517          	auipc	a0,0x6
    80001a3c:	7e850513          	addi	a0,a0,2024 # 80008220 <etext+0x220>
    80001a40:	00004097          	auipc	ra,0x4
    80001a44:	3e8080e7          	jalr	1000(ra) # 80005e28 <panic>

0000000080001a48 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a48:	7179                	addi	sp,sp,-48
    80001a4a:	f406                	sd	ra,40(sp)
    80001a4c:	f022                	sd	s0,32(sp)
    80001a4e:	ec26                	sd	s1,24(sp)
    80001a50:	e84a                	sd	s2,16(sp)
    80001a52:	e44e                	sd	s3,8(sp)
    80001a54:	1800                	addi	s0,sp,48
    80001a56:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a58:	00228497          	auipc	s1,0x228
    80001a5c:	a4048493          	addi	s1,s1,-1472 # 80229498 <proc>
    80001a60:	0022d997          	auipc	s3,0x22d
    80001a64:	43898993          	addi	s3,s3,1080 # 8022ee98 <tickslock>
    acquire(&p->lock);
    80001a68:	8526                	mv	a0,s1
    80001a6a:	00005097          	auipc	ra,0x5
    80001a6e:	908080e7          	jalr	-1784(ra) # 80006372 <acquire>
    if(p->pid == pid){
    80001a72:	589c                	lw	a5,48(s1)
    80001a74:	01278d63          	beq	a5,s2,80001a8e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	00005097          	auipc	ra,0x5
    80001a7e:	9ac080e7          	jalr	-1620(ra) # 80006426 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a82:	16848493          	addi	s1,s1,360
    80001a86:	ff3491e3          	bne	s1,s3,80001a68 <kill+0x20>
  }
  return -1;
    80001a8a:	557d                	li	a0,-1
    80001a8c:	a829                	j	80001aa6 <kill+0x5e>
      p->killed = 1;
    80001a8e:	4785                	li	a5,1
    80001a90:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a92:	4c98                	lw	a4,24(s1)
    80001a94:	4789                	li	a5,2
    80001a96:	00f70f63          	beq	a4,a5,80001ab4 <kill+0x6c>
      release(&p->lock);
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	00005097          	auipc	ra,0x5
    80001aa0:	98a080e7          	jalr	-1654(ra) # 80006426 <release>
      return 0;
    80001aa4:	4501                	li	a0,0
}
    80001aa6:	70a2                	ld	ra,40(sp)
    80001aa8:	7402                	ld	s0,32(sp)
    80001aaa:	64e2                	ld	s1,24(sp)
    80001aac:	6942                	ld	s2,16(sp)
    80001aae:	69a2                	ld	s3,8(sp)
    80001ab0:	6145                	addi	sp,sp,48
    80001ab2:	8082                	ret
        p->state = RUNNABLE;
    80001ab4:	478d                	li	a5,3
    80001ab6:	cc9c                	sw	a5,24(s1)
    80001ab8:	b7cd                	j	80001a9a <kill+0x52>

0000000080001aba <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001aba:	7179                	addi	sp,sp,-48
    80001abc:	f406                	sd	ra,40(sp)
    80001abe:	f022                	sd	s0,32(sp)
    80001ac0:	ec26                	sd	s1,24(sp)
    80001ac2:	e84a                	sd	s2,16(sp)
    80001ac4:	e44e                	sd	s3,8(sp)
    80001ac6:	e052                	sd	s4,0(sp)
    80001ac8:	1800                	addi	s0,sp,48
    80001aca:	84aa                	mv	s1,a0
    80001acc:	892e                	mv	s2,a1
    80001ace:	89b2                	mv	s3,a2
    80001ad0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ad2:	fffff097          	auipc	ra,0xfffff
    80001ad6:	588080e7          	jalr	1416(ra) # 8000105a <myproc>
  if(user_dst){
    80001ada:	c08d                	beqz	s1,80001afc <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001adc:	86d2                	mv	a3,s4
    80001ade:	864e                	mv	a2,s3
    80001ae0:	85ca                	mv	a1,s2
    80001ae2:	6928                	ld	a0,80(a0)
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	2f4080e7          	jalr	756(ra) # 80000dd8 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001aec:	70a2                	ld	ra,40(sp)
    80001aee:	7402                	ld	s0,32(sp)
    80001af0:	64e2                	ld	s1,24(sp)
    80001af2:	6942                	ld	s2,16(sp)
    80001af4:	69a2                	ld	s3,8(sp)
    80001af6:	6a02                	ld	s4,0(sp)
    80001af8:	6145                	addi	sp,sp,48
    80001afa:	8082                	ret
    memmove((char *)dst, src, len);
    80001afc:	000a061b          	sext.w	a2,s4
    80001b00:	85ce                	mv	a1,s3
    80001b02:	854a                	mv	a0,s2
    80001b04:	fffff097          	auipc	ra,0xfffff
    80001b08:	834080e7          	jalr	-1996(ra) # 80000338 <memmove>
    return 0;
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	bff9                	j	80001aec <either_copyout+0x32>

0000000080001b10 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b10:	7179                	addi	sp,sp,-48
    80001b12:	f406                	sd	ra,40(sp)
    80001b14:	f022                	sd	s0,32(sp)
    80001b16:	ec26                	sd	s1,24(sp)
    80001b18:	e84a                	sd	s2,16(sp)
    80001b1a:	e44e                	sd	s3,8(sp)
    80001b1c:	e052                	sd	s4,0(sp)
    80001b1e:	1800                	addi	s0,sp,48
    80001b20:	892a                	mv	s2,a0
    80001b22:	84ae                	mv	s1,a1
    80001b24:	89b2                	mv	s3,a2
    80001b26:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	532080e7          	jalr	1330(ra) # 8000105a <myproc>
  if(user_src){
    80001b30:	c08d                	beqz	s1,80001b52 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b32:	86d2                	mv	a3,s4
    80001b34:	864e                	mv	a2,s3
    80001b36:	85ca                	mv	a1,s2
    80001b38:	6928                	ld	a0,80(a0)
    80001b3a:	fffff097          	auipc	ra,0xfffff
    80001b3e:	120080e7          	jalr	288(ra) # 80000c5a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b42:	70a2                	ld	ra,40(sp)
    80001b44:	7402                	ld	s0,32(sp)
    80001b46:	64e2                	ld	s1,24(sp)
    80001b48:	6942                	ld	s2,16(sp)
    80001b4a:	69a2                	ld	s3,8(sp)
    80001b4c:	6a02                	ld	s4,0(sp)
    80001b4e:	6145                	addi	sp,sp,48
    80001b50:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b52:	000a061b          	sext.w	a2,s4
    80001b56:	85ce                	mv	a1,s3
    80001b58:	854a                	mv	a0,s2
    80001b5a:	ffffe097          	auipc	ra,0xffffe
    80001b5e:	7de080e7          	jalr	2014(ra) # 80000338 <memmove>
    return 0;
    80001b62:	8526                	mv	a0,s1
    80001b64:	bff9                	j	80001b42 <either_copyin+0x32>

0000000080001b66 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b66:	715d                	addi	sp,sp,-80
    80001b68:	e486                	sd	ra,72(sp)
    80001b6a:	e0a2                	sd	s0,64(sp)
    80001b6c:	fc26                	sd	s1,56(sp)
    80001b6e:	f84a                	sd	s2,48(sp)
    80001b70:	f44e                	sd	s3,40(sp)
    80001b72:	f052                	sd	s4,32(sp)
    80001b74:	ec56                	sd	s5,24(sp)
    80001b76:	e85a                	sd	s6,16(sp)
    80001b78:	e45e                	sd	s7,8(sp)
    80001b7a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b7c:	00006517          	auipc	a0,0x6
    80001b80:	4d450513          	addi	a0,a0,1236 # 80008050 <etext+0x50>
    80001b84:	00004097          	auipc	ra,0x4
    80001b88:	2ee080e7          	jalr	750(ra) # 80005e72 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b8c:	00228497          	auipc	s1,0x228
    80001b90:	a6448493          	addi	s1,s1,-1436 # 802295f0 <proc+0x158>
    80001b94:	0022d917          	auipc	s2,0x22d
    80001b98:	45c90913          	addi	s2,s2,1116 # 8022eff0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b9c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b9e:	00006997          	auipc	s3,0x6
    80001ba2:	69298993          	addi	s3,s3,1682 # 80008230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    80001ba6:	00006a97          	auipc	s5,0x6
    80001baa:	692a8a93          	addi	s5,s5,1682 # 80008238 <etext+0x238>
    printf("\n");
    80001bae:	00006a17          	auipc	s4,0x6
    80001bb2:	4a2a0a13          	addi	s4,s4,1186 # 80008050 <etext+0x50>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bb6:	00006b97          	auipc	s7,0x6
    80001bba:	6bab8b93          	addi	s7,s7,1722 # 80008270 <states.1720>
    80001bbe:	a00d                	j	80001be0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bc0:	ed86a583          	lw	a1,-296(a3)
    80001bc4:	8556                	mv	a0,s5
    80001bc6:	00004097          	auipc	ra,0x4
    80001bca:	2ac080e7          	jalr	684(ra) # 80005e72 <printf>
    printf("\n");
    80001bce:	8552                	mv	a0,s4
    80001bd0:	00004097          	auipc	ra,0x4
    80001bd4:	2a2080e7          	jalr	674(ra) # 80005e72 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bd8:	16848493          	addi	s1,s1,360
    80001bdc:	03248163          	beq	s1,s2,80001bfe <procdump+0x98>
    if(p->state == UNUSED)
    80001be0:	86a6                	mv	a3,s1
    80001be2:	ec04a783          	lw	a5,-320(s1)
    80001be6:	dbed                	beqz	a5,80001bd8 <procdump+0x72>
      state = "???";
    80001be8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bea:	fcfb6be3          	bltu	s6,a5,80001bc0 <procdump+0x5a>
    80001bee:	1782                	slli	a5,a5,0x20
    80001bf0:	9381                	srli	a5,a5,0x20
    80001bf2:	078e                	slli	a5,a5,0x3
    80001bf4:	97de                	add	a5,a5,s7
    80001bf6:	6390                	ld	a2,0(a5)
    80001bf8:	f661                	bnez	a2,80001bc0 <procdump+0x5a>
      state = "???";
    80001bfa:	864e                	mv	a2,s3
    80001bfc:	b7d1                	j	80001bc0 <procdump+0x5a>
  }
}
    80001bfe:	60a6                	ld	ra,72(sp)
    80001c00:	6406                	ld	s0,64(sp)
    80001c02:	74e2                	ld	s1,56(sp)
    80001c04:	7942                	ld	s2,48(sp)
    80001c06:	79a2                	ld	s3,40(sp)
    80001c08:	7a02                	ld	s4,32(sp)
    80001c0a:	6ae2                	ld	s5,24(sp)
    80001c0c:	6b42                	ld	s6,16(sp)
    80001c0e:	6ba2                	ld	s7,8(sp)
    80001c10:	6161                	addi	sp,sp,80
    80001c12:	8082                	ret

0000000080001c14 <swtch>:
    80001c14:	00153023          	sd	ra,0(a0)
    80001c18:	00253423          	sd	sp,8(a0)
    80001c1c:	e900                	sd	s0,16(a0)
    80001c1e:	ed04                	sd	s1,24(a0)
    80001c20:	03253023          	sd	s2,32(a0)
    80001c24:	03353423          	sd	s3,40(a0)
    80001c28:	03453823          	sd	s4,48(a0)
    80001c2c:	03553c23          	sd	s5,56(a0)
    80001c30:	05653023          	sd	s6,64(a0)
    80001c34:	05753423          	sd	s7,72(a0)
    80001c38:	05853823          	sd	s8,80(a0)
    80001c3c:	05953c23          	sd	s9,88(a0)
    80001c40:	07a53023          	sd	s10,96(a0)
    80001c44:	07b53423          	sd	s11,104(a0)
    80001c48:	0005b083          	ld	ra,0(a1)
    80001c4c:	0085b103          	ld	sp,8(a1)
    80001c50:	6980                	ld	s0,16(a1)
    80001c52:	6d84                	ld	s1,24(a1)
    80001c54:	0205b903          	ld	s2,32(a1)
    80001c58:	0285b983          	ld	s3,40(a1)
    80001c5c:	0305ba03          	ld	s4,48(a1)
    80001c60:	0385ba83          	ld	s5,56(a1)
    80001c64:	0405bb03          	ld	s6,64(a1)
    80001c68:	0485bb83          	ld	s7,72(a1)
    80001c6c:	0505bc03          	ld	s8,80(a1)
    80001c70:	0585bc83          	ld	s9,88(a1)
    80001c74:	0605bd03          	ld	s10,96(a1)
    80001c78:	0685bd83          	ld	s11,104(a1)
    80001c7c:	8082                	ret

0000000080001c7e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c7e:	1141                	addi	sp,sp,-16
    80001c80:	e406                	sd	ra,8(sp)
    80001c82:	e022                	sd	s0,0(sp)
    80001c84:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c86:	00006597          	auipc	a1,0x6
    80001c8a:	61a58593          	addi	a1,a1,1562 # 800082a0 <states.1720+0x30>
    80001c8e:	0022d517          	auipc	a0,0x22d
    80001c92:	20a50513          	addi	a0,a0,522 # 8022ee98 <tickslock>
    80001c96:	00004097          	auipc	ra,0x4
    80001c9a:	64c080e7          	jalr	1612(ra) # 800062e2 <initlock>
}
    80001c9e:	60a2                	ld	ra,8(sp)
    80001ca0:	6402                	ld	s0,0(sp)
    80001ca2:	0141                	addi	sp,sp,16
    80001ca4:	8082                	ret

0000000080001ca6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ca6:	1141                	addi	sp,sp,-16
    80001ca8:	e422                	sd	s0,8(sp)
    80001caa:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cac:	00003797          	auipc	a5,0x3
    80001cb0:	58478793          	addi	a5,a5,1412 # 80005230 <kernelvec>
    80001cb4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cb8:	6422                	ld	s0,8(sp)
    80001cba:	0141                	addi	sp,sp,16
    80001cbc:	8082                	ret

0000000080001cbe <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cbe:	1141                	addi	sp,sp,-16
    80001cc0:	e406                	sd	ra,8(sp)
    80001cc2:	e022                	sd	s0,0(sp)
    80001cc4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cc6:	fffff097          	auipc	ra,0xfffff
    80001cca:	394080e7          	jalr	916(ra) # 8000105a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cd2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001cd8:	00005617          	auipc	a2,0x5
    80001cdc:	32860613          	addi	a2,a2,808 # 80007000 <_trampoline>
    80001ce0:	00005697          	auipc	a3,0x5
    80001ce4:	32068693          	addi	a3,a3,800 # 80007000 <_trampoline>
    80001ce8:	8e91                	sub	a3,a3,a2
    80001cea:	040007b7          	lui	a5,0x4000
    80001cee:	17fd                	addi	a5,a5,-1
    80001cf0:	07b2                	slli	a5,a5,0xc
    80001cf2:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf4:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cf8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cfa:	180026f3          	csrr	a3,satp
    80001cfe:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d00:	6d38                	ld	a4,88(a0)
    80001d02:	6134                	ld	a3,64(a0)
    80001d04:	6585                	lui	a1,0x1
    80001d06:	96ae                	add	a3,a3,a1
    80001d08:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d0a:	6d38                	ld	a4,88(a0)
    80001d0c:	00000697          	auipc	a3,0x0
    80001d10:	13868693          	addi	a3,a3,312 # 80001e44 <usertrap>
    80001d14:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d16:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d18:	8692                	mv	a3,tp
    80001d1a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d20:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d24:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d28:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d2c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d2e:	6f18                	ld	a4,24(a4)
    80001d30:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d34:	692c                	ld	a1,80(a0)
    80001d36:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d38:	00005717          	auipc	a4,0x5
    80001d3c:	35870713          	addi	a4,a4,856 # 80007090 <userret>
    80001d40:	8f11                	sub	a4,a4,a2
    80001d42:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d44:	577d                	li	a4,-1
    80001d46:	177e                	slli	a4,a4,0x3f
    80001d48:	8dd9                	or	a1,a1,a4
    80001d4a:	02000537          	lui	a0,0x2000
    80001d4e:	157d                	addi	a0,a0,-1
    80001d50:	0536                	slli	a0,a0,0xd
    80001d52:	9782                	jalr	a5
}
    80001d54:	60a2                	ld	ra,8(sp)
    80001d56:	6402                	ld	s0,0(sp)
    80001d58:	0141                	addi	sp,sp,16
    80001d5a:	8082                	ret

0000000080001d5c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d5c:	1101                	addi	sp,sp,-32
    80001d5e:	ec06                	sd	ra,24(sp)
    80001d60:	e822                	sd	s0,16(sp)
    80001d62:	e426                	sd	s1,8(sp)
    80001d64:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d66:	0022d497          	auipc	s1,0x22d
    80001d6a:	13248493          	addi	s1,s1,306 # 8022ee98 <tickslock>
    80001d6e:	8526                	mv	a0,s1
    80001d70:	00004097          	auipc	ra,0x4
    80001d74:	602080e7          	jalr	1538(ra) # 80006372 <acquire>
  ticks++;
    80001d78:	00007517          	auipc	a0,0x7
    80001d7c:	2a050513          	addi	a0,a0,672 # 80009018 <ticks>
    80001d80:	411c                	lw	a5,0(a0)
    80001d82:	2785                	addiw	a5,a5,1
    80001d84:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	b1c080e7          	jalr	-1252(ra) # 800018a2 <wakeup>
  release(&tickslock);
    80001d8e:	8526                	mv	a0,s1
    80001d90:	00004097          	auipc	ra,0x4
    80001d94:	696080e7          	jalr	1686(ra) # 80006426 <release>
}
    80001d98:	60e2                	ld	ra,24(sp)
    80001d9a:	6442                	ld	s0,16(sp)
    80001d9c:	64a2                	ld	s1,8(sp)
    80001d9e:	6105                	addi	sp,sp,32
    80001da0:	8082                	ret

0000000080001da2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001da2:	1101                	addi	sp,sp,-32
    80001da4:	ec06                	sd	ra,24(sp)
    80001da6:	e822                	sd	s0,16(sp)
    80001da8:	e426                	sd	s1,8(sp)
    80001daa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dac:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001db0:	00074d63          	bltz	a4,80001dca <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001db4:	57fd                	li	a5,-1
    80001db6:	17fe                	slli	a5,a5,0x3f
    80001db8:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001dba:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dbc:	06f70363          	beq	a4,a5,80001e22 <devintr+0x80>
  }
}
    80001dc0:	60e2                	ld	ra,24(sp)
    80001dc2:	6442                	ld	s0,16(sp)
    80001dc4:	64a2                	ld	s1,8(sp)
    80001dc6:	6105                	addi	sp,sp,32
    80001dc8:	8082                	ret
     (scause & 0xff) == 9){
    80001dca:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001dce:	46a5                	li	a3,9
    80001dd0:	fed792e3          	bne	a5,a3,80001db4 <devintr+0x12>
    int irq = plic_claim();
    80001dd4:	00003097          	auipc	ra,0x3
    80001dd8:	564080e7          	jalr	1380(ra) # 80005338 <plic_claim>
    80001ddc:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dde:	47a9                	li	a5,10
    80001de0:	02f50763          	beq	a0,a5,80001e0e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001de4:	4785                	li	a5,1
    80001de6:	02f50963          	beq	a0,a5,80001e18 <devintr+0x76>
    return 1;
    80001dea:	4505                	li	a0,1
    } else if(irq){
    80001dec:	d8f1                	beqz	s1,80001dc0 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dee:	85a6                	mv	a1,s1
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	4b850513          	addi	a0,a0,1208 # 800082a8 <states.1720+0x38>
    80001df8:	00004097          	auipc	ra,0x4
    80001dfc:	07a080e7          	jalr	122(ra) # 80005e72 <printf>
      plic_complete(irq);
    80001e00:	8526                	mv	a0,s1
    80001e02:	00003097          	auipc	ra,0x3
    80001e06:	55a080e7          	jalr	1370(ra) # 8000535c <plic_complete>
    return 1;
    80001e0a:	4505                	li	a0,1
    80001e0c:	bf55                	j	80001dc0 <devintr+0x1e>
      uartintr();
    80001e0e:	00004097          	auipc	ra,0x4
    80001e12:	484080e7          	jalr	1156(ra) # 80006292 <uartintr>
    80001e16:	b7ed                	j	80001e00 <devintr+0x5e>
      virtio_disk_intr();
    80001e18:	00004097          	auipc	ra,0x4
    80001e1c:	a24080e7          	jalr	-1500(ra) # 8000583c <virtio_disk_intr>
    80001e20:	b7c5                	j	80001e00 <devintr+0x5e>
    if(cpuid() == 0){
    80001e22:	fffff097          	auipc	ra,0xfffff
    80001e26:	20c080e7          	jalr	524(ra) # 8000102e <cpuid>
    80001e2a:	c901                	beqz	a0,80001e3a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e2c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e30:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e32:	14479073          	csrw	sip,a5
    return 2;
    80001e36:	4509                	li	a0,2
    80001e38:	b761                	j	80001dc0 <devintr+0x1e>
      clockintr();
    80001e3a:	00000097          	auipc	ra,0x0
    80001e3e:	f22080e7          	jalr	-222(ra) # 80001d5c <clockintr>
    80001e42:	b7ed                	j	80001e2c <devintr+0x8a>

0000000080001e44 <usertrap>:
{
    80001e44:	7139                	addi	sp,sp,-64
    80001e46:	fc06                	sd	ra,56(sp)
    80001e48:	f822                	sd	s0,48(sp)
    80001e4a:	f426                	sd	s1,40(sp)
    80001e4c:	f04a                	sd	s2,32(sp)
    80001e4e:	ec4e                	sd	s3,24(sp)
    80001e50:	e852                	sd	s4,16(sp)
    80001e52:	e456                	sd	s5,8(sp)
    80001e54:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e56:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e5a:	1007f793          	andi	a5,a5,256
    80001e5e:	e7ad                	bnez	a5,80001ec8 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e60:	00003797          	auipc	a5,0x3
    80001e64:	3d078793          	addi	a5,a5,976 # 80005230 <kernelvec>
    80001e68:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	1ee080e7          	jalr	494(ra) # 8000105a <myproc>
    80001e74:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e76:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e78:	14102773          	csrr	a4,sepc
    80001e7c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e7e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e82:	47a1                	li	a5,8
    80001e84:	06f71063          	bne	a4,a5,80001ee4 <usertrap+0xa0>
    if(p->killed)
    80001e88:	551c                	lw	a5,40(a0)
    80001e8a:	e7b9                	bnez	a5,80001ed8 <usertrap+0x94>
    p->trapframe->epc += 4;
    80001e8c:	6cb8                	ld	a4,88(s1)
    80001e8e:	6f1c                	ld	a5,24(a4)
    80001e90:	0791                	addi	a5,a5,4
    80001e92:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e98:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e9c:	10079073          	csrw	sstatus,a5
    syscall();
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	3dc080e7          	jalr	988(ra) # 8000227c <syscall>
  if(p->killed)
    80001ea8:	549c                	lw	a5,40(s1)
    80001eaa:	16079a63          	bnez	a5,8000201e <usertrap+0x1da>
  usertrapret();
    80001eae:	00000097          	auipc	ra,0x0
    80001eb2:	e10080e7          	jalr	-496(ra) # 80001cbe <usertrapret>
}
    80001eb6:	70e2                	ld	ra,56(sp)
    80001eb8:	7442                	ld	s0,48(sp)
    80001eba:	74a2                	ld	s1,40(sp)
    80001ebc:	7902                	ld	s2,32(sp)
    80001ebe:	69e2                	ld	s3,24(sp)
    80001ec0:	6a42                	ld	s4,16(sp)
    80001ec2:	6aa2                	ld	s5,8(sp)
    80001ec4:	6121                	addi	sp,sp,64
    80001ec6:	8082                	ret
    panic("usertrap: not from user mode");
    80001ec8:	00006517          	auipc	a0,0x6
    80001ecc:	40050513          	addi	a0,a0,1024 # 800082c8 <states.1720+0x58>
    80001ed0:	00004097          	auipc	ra,0x4
    80001ed4:	f58080e7          	jalr	-168(ra) # 80005e28 <panic>
      exit(-1);
    80001ed8:	557d                	li	a0,-1
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	a98080e7          	jalr	-1384(ra) # 80001972 <exit>
    80001ee2:	b76d                	j	80001e8c <usertrap+0x48>
  } else if((which_dev = devintr()) != 0){
    80001ee4:	00000097          	auipc	ra,0x0
    80001ee8:	ebe080e7          	jalr	-322(ra) # 80001da2 <devintr>
    80001eec:	892a                	mv	s2,a0
    80001eee:	12051563          	bnez	a0,80002018 <usertrap+0x1d4>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ef2:	14202773          	csrr	a4,scause
  } else if(r_scause() == 13 || r_scause() == 15){
    80001ef6:	47b5                	li	a5,13
    80001ef8:	00f70763          	beq	a4,a5,80001f06 <usertrap+0xc2>
    80001efc:	14202773          	csrr	a4,scause
    80001f00:	47bd                	li	a5,15
    80001f02:	0ef71163          	bne	a4,a5,80001fe4 <usertrap+0x1a0>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f06:	14302a73          	csrr	s4,stval
    struct proc* p = myproc();
    80001f0a:	fffff097          	auipc	ra,0xfffff
    80001f0e:	150080e7          	jalr	336(ra) # 8000105a <myproc>
    80001f12:	8aaa                	mv	s5,a0
    if((pte = cow_walk(p->pagetable, PGROUNDDOWN(va))) == 0){
    80001f14:	77fd                	lui	a5,0xfffff
    80001f16:	00fa7a33          	and	s4,s4,a5
    80001f1a:	85d2                	mv	a1,s4
    80001f1c:	6928                	ld	a0,80(a0)
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	e7c080e7          	jalr	-388(ra) # 80000d9a <cow_walk>
    80001f26:	892a                	mv	s2,a0
    80001f28:	c51d                	beqz	a0,80001f56 <usertrap+0x112>
    fault_pa = PTE2PA(*pte);
    80001f2a:	00053983          	ld	s3,0(a0)
    80001f2e:	00a9d993          	srli	s3,s3,0xa
    80001f32:	09b2                	slli	s3,s3,0xc
    if(get_mem_count(fault_pa) == 1){
    80001f34:	854e                	mv	a0,s3
    80001f36:	ffffe097          	auipc	ra,0xffffe
    80001f3a:	0e6080e7          	jalr	230(ra) # 8000001c <get_mem_count>
    80001f3e:	4785                	li	a5,1
    80001f40:	02f51763          	bne	a0,a5,80001f6e <usertrap+0x12a>
      *pte &= ~PTE_RSW;
    80001f44:	00093783          	ld	a5,0(s2)
    80001f48:	eff7f793          	andi	a5,a5,-257
    80001f4c:	0047e793          	ori	a5,a5,4
    80001f50:	00f93023          	sd	a5,0(s2)
    80001f54:	bf91                	j	80001ea8 <usertrap+0x64>
      printf("usertrap: not cow page fault\n");
    80001f56:	00006517          	auipc	a0,0x6
    80001f5a:	39250513          	addi	a0,a0,914 # 800082e8 <states.1720+0x78>
    80001f5e:	00004097          	auipc	ra,0x4
    80001f62:	f14080e7          	jalr	-236(ra) # 80005e72 <printf>
      p->killed = 1;
    80001f66:	4785                	li	a5,1
    80001f68:	02faa423          	sw	a5,40(s5)
      goto end;
    80001f6c:	bf35                	j	80001ea8 <usertrap+0x64>
      char* child_pa = kalloc();
    80001f6e:	ffffe097          	auipc	ra,0xffffe
    80001f72:	2f8080e7          	jalr	760(ra) # 80000266 <kalloc>
    80001f76:	892a                	mv	s2,a0
      if(child_pa == 0){
    80001f78:	c129                	beqz	a0,80001fba <usertrap+0x176>
      memmove(child_pa, (char*)fault_pa, PGSIZE);
    80001f7a:	6605                	lui	a2,0x1
    80001f7c:	85ce                	mv	a1,s3
    80001f7e:	ffffe097          	auipc	ra,0xffffe
    80001f82:	3ba080e7          	jalr	954(ra) # 80000338 <memmove>
      uvmunmap(p->pagetable, PGROUNDDOWN(va), 1, 0);
    80001f86:	4681                	li	a3,0
    80001f88:	4605                	li	a2,1
    80001f8a:	85d2                	mv	a1,s4
    80001f8c:	050ab503          	ld	a0,80(s5)
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	8de080e7          	jalr	-1826(ra) # 8000086e <uvmunmap>
      if(mappages(p->pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)child_pa, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001f98:	4779                	li	a4,30
    80001f9a:	86ca                	mv	a3,s2
    80001f9c:	6605                	lui	a2,0x1
    80001f9e:	85d2                	mv	a1,s4
    80001fa0:	050ab503          	ld	a0,80(s5)
    80001fa4:	ffffe097          	auipc	ra,0xffffe
    80001fa8:	704080e7          	jalr	1796(ra) # 800006a8 <mappages>
    80001fac:	e11d                	bnez	a0,80001fd2 <usertrap+0x18e>
      kfree((void*)fault_pa);
    80001fae:	854e                	mv	a0,s3
    80001fb0:	ffffe097          	auipc	ra,0xffffe
    80001fb4:	142080e7          	jalr	322(ra) # 800000f2 <kfree>
    80001fb8:	bdc5                	j	80001ea8 <usertrap+0x64>
        printf("alloc physical memory failed");
    80001fba:	00006517          	auipc	a0,0x6
    80001fbe:	34e50513          	addi	a0,a0,846 # 80008308 <states.1720+0x98>
    80001fc2:	00004097          	auipc	ra,0x4
    80001fc6:	eb0080e7          	jalr	-336(ra) # 80005e72 <printf>
        p->killed = 1;
    80001fca:	4785                	li	a5,1
    80001fcc:	02faa423          	sw	a5,40(s5)
        goto end;
    80001fd0:	bde1                	j	80001ea8 <usertrap+0x64>
        kfree(child_pa);
    80001fd2:	854a                	mv	a0,s2
    80001fd4:	ffffe097          	auipc	ra,0xffffe
    80001fd8:	11e080e7          	jalr	286(ra) # 800000f2 <kfree>
        p->killed = 1;
    80001fdc:	4785                	li	a5,1
    80001fde:	02faa423          	sw	a5,40(s5)
        goto end;
    80001fe2:	b5d9                	j	80001ea8 <usertrap+0x64>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fe4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001fe8:	5890                	lw	a2,48(s1)
    80001fea:	00006517          	auipc	a0,0x6
    80001fee:	33e50513          	addi	a0,a0,830 # 80008328 <states.1720+0xb8>
    80001ff2:	00004097          	auipc	ra,0x4
    80001ff6:	e80080e7          	jalr	-384(ra) # 80005e72 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ffa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ffe:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002002:	00006517          	auipc	a0,0x6
    80002006:	35650513          	addi	a0,a0,854 # 80008358 <states.1720+0xe8>
    8000200a:	00004097          	auipc	ra,0x4
    8000200e:	e68080e7          	jalr	-408(ra) # 80005e72 <printf>
    p->killed = 1;
    80002012:	4785                	li	a5,1
    80002014:	d49c                	sw	a5,40(s1)
  if(p->killed)
    80002016:	a029                	j	80002020 <usertrap+0x1dc>
    80002018:	549c                	lw	a5,40(s1)
    8000201a:	cb81                	beqz	a5,8000202a <usertrap+0x1e6>
    8000201c:	a011                	j	80002020 <usertrap+0x1dc>
    8000201e:	4901                	li	s2,0
    exit(-1);
    80002020:	557d                	li	a0,-1
    80002022:	00000097          	auipc	ra,0x0
    80002026:	950080e7          	jalr	-1712(ra) # 80001972 <exit>
  if(which_dev == 2)
    8000202a:	4789                	li	a5,2
    8000202c:	e8f911e3          	bne	s2,a5,80001eae <usertrap+0x6a>
    yield();
    80002030:	fffff097          	auipc	ra,0xfffff
    80002034:	6aa080e7          	jalr	1706(ra) # 800016da <yield>
    80002038:	bd9d                	j	80001eae <usertrap+0x6a>

000000008000203a <kerneltrap>:
{
    8000203a:	7179                	addi	sp,sp,-48
    8000203c:	f406                	sd	ra,40(sp)
    8000203e:	f022                	sd	s0,32(sp)
    80002040:	ec26                	sd	s1,24(sp)
    80002042:	e84a                	sd	s2,16(sp)
    80002044:	e44e                	sd	s3,8(sp)
    80002046:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002048:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000204c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002050:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002054:	1004f793          	andi	a5,s1,256
    80002058:	cb85                	beqz	a5,80002088 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000205a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000205e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002060:	ef85                	bnez	a5,80002098 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002062:	00000097          	auipc	ra,0x0
    80002066:	d40080e7          	jalr	-704(ra) # 80001da2 <devintr>
    8000206a:	cd1d                	beqz	a0,800020a8 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000206c:	4789                	li	a5,2
    8000206e:	06f50a63          	beq	a0,a5,800020e2 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002072:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002076:	10049073          	csrw	sstatus,s1
}
    8000207a:	70a2                	ld	ra,40(sp)
    8000207c:	7402                	ld	s0,32(sp)
    8000207e:	64e2                	ld	s1,24(sp)
    80002080:	6942                	ld	s2,16(sp)
    80002082:	69a2                	ld	s3,8(sp)
    80002084:	6145                	addi	sp,sp,48
    80002086:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002088:	00006517          	auipc	a0,0x6
    8000208c:	2f050513          	addi	a0,a0,752 # 80008378 <states.1720+0x108>
    80002090:	00004097          	auipc	ra,0x4
    80002094:	d98080e7          	jalr	-616(ra) # 80005e28 <panic>
    panic("kerneltrap: interrupts enabled");
    80002098:	00006517          	auipc	a0,0x6
    8000209c:	30850513          	addi	a0,a0,776 # 800083a0 <states.1720+0x130>
    800020a0:	00004097          	auipc	ra,0x4
    800020a4:	d88080e7          	jalr	-632(ra) # 80005e28 <panic>
    printf("scause %p\n", scause);
    800020a8:	85ce                	mv	a1,s3
    800020aa:	00006517          	auipc	a0,0x6
    800020ae:	31650513          	addi	a0,a0,790 # 800083c0 <states.1720+0x150>
    800020b2:	00004097          	auipc	ra,0x4
    800020b6:	dc0080e7          	jalr	-576(ra) # 80005e72 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020ba:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020be:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020c2:	00006517          	auipc	a0,0x6
    800020c6:	30e50513          	addi	a0,a0,782 # 800083d0 <states.1720+0x160>
    800020ca:	00004097          	auipc	ra,0x4
    800020ce:	da8080e7          	jalr	-600(ra) # 80005e72 <printf>
    panic("kerneltrap");
    800020d2:	00006517          	auipc	a0,0x6
    800020d6:	31650513          	addi	a0,a0,790 # 800083e8 <states.1720+0x178>
    800020da:	00004097          	auipc	ra,0x4
    800020de:	d4e080e7          	jalr	-690(ra) # 80005e28 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020e2:	fffff097          	auipc	ra,0xfffff
    800020e6:	f78080e7          	jalr	-136(ra) # 8000105a <myproc>
    800020ea:	d541                	beqz	a0,80002072 <kerneltrap+0x38>
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	f6e080e7          	jalr	-146(ra) # 8000105a <myproc>
    800020f4:	4d18                	lw	a4,24(a0)
    800020f6:	4791                	li	a5,4
    800020f8:	f6f71de3          	bne	a4,a5,80002072 <kerneltrap+0x38>
    yield();
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	5de080e7          	jalr	1502(ra) # 800016da <yield>
    80002104:	b7bd                	j	80002072 <kerneltrap+0x38>

0000000080002106 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002106:	1101                	addi	sp,sp,-32
    80002108:	ec06                	sd	ra,24(sp)
    8000210a:	e822                	sd	s0,16(sp)
    8000210c:	e426                	sd	s1,8(sp)
    8000210e:	1000                	addi	s0,sp,32
    80002110:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	f48080e7          	jalr	-184(ra) # 8000105a <myproc>
  switch (n) {
    8000211a:	4795                	li	a5,5
    8000211c:	0497e163          	bltu	a5,s1,8000215e <argraw+0x58>
    80002120:	048a                	slli	s1,s1,0x2
    80002122:	00006717          	auipc	a4,0x6
    80002126:	2fe70713          	addi	a4,a4,766 # 80008420 <states.1720+0x1b0>
    8000212a:	94ba                	add	s1,s1,a4
    8000212c:	409c                	lw	a5,0(s1)
    8000212e:	97ba                	add	a5,a5,a4
    80002130:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002132:	6d3c                	ld	a5,88(a0)
    80002134:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002136:	60e2                	ld	ra,24(sp)
    80002138:	6442                	ld	s0,16(sp)
    8000213a:	64a2                	ld	s1,8(sp)
    8000213c:	6105                	addi	sp,sp,32
    8000213e:	8082                	ret
    return p->trapframe->a1;
    80002140:	6d3c                	ld	a5,88(a0)
    80002142:	7fa8                	ld	a0,120(a5)
    80002144:	bfcd                	j	80002136 <argraw+0x30>
    return p->trapframe->a2;
    80002146:	6d3c                	ld	a5,88(a0)
    80002148:	63c8                	ld	a0,128(a5)
    8000214a:	b7f5                	j	80002136 <argraw+0x30>
    return p->trapframe->a3;
    8000214c:	6d3c                	ld	a5,88(a0)
    8000214e:	67c8                	ld	a0,136(a5)
    80002150:	b7dd                	j	80002136 <argraw+0x30>
    return p->trapframe->a4;
    80002152:	6d3c                	ld	a5,88(a0)
    80002154:	6bc8                	ld	a0,144(a5)
    80002156:	b7c5                	j	80002136 <argraw+0x30>
    return p->trapframe->a5;
    80002158:	6d3c                	ld	a5,88(a0)
    8000215a:	6fc8                	ld	a0,152(a5)
    8000215c:	bfe9                	j	80002136 <argraw+0x30>
  panic("argraw");
    8000215e:	00006517          	auipc	a0,0x6
    80002162:	29a50513          	addi	a0,a0,666 # 800083f8 <states.1720+0x188>
    80002166:	00004097          	auipc	ra,0x4
    8000216a:	cc2080e7          	jalr	-830(ra) # 80005e28 <panic>

000000008000216e <fetchaddr>:
{
    8000216e:	1101                	addi	sp,sp,-32
    80002170:	ec06                	sd	ra,24(sp)
    80002172:	e822                	sd	s0,16(sp)
    80002174:	e426                	sd	s1,8(sp)
    80002176:	e04a                	sd	s2,0(sp)
    80002178:	1000                	addi	s0,sp,32
    8000217a:	84aa                	mv	s1,a0
    8000217c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	edc080e7          	jalr	-292(ra) # 8000105a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002186:	653c                	ld	a5,72(a0)
    80002188:	02f4f863          	bgeu	s1,a5,800021b8 <fetchaddr+0x4a>
    8000218c:	00848713          	addi	a4,s1,8
    80002190:	02e7e663          	bltu	a5,a4,800021bc <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002194:	46a1                	li	a3,8
    80002196:	8626                	mv	a2,s1
    80002198:	85ca                	mv	a1,s2
    8000219a:	6928                	ld	a0,80(a0)
    8000219c:	fffff097          	auipc	ra,0xfffff
    800021a0:	abe080e7          	jalr	-1346(ra) # 80000c5a <copyin>
    800021a4:	00a03533          	snez	a0,a0
    800021a8:	40a00533          	neg	a0,a0
}
    800021ac:	60e2                	ld	ra,24(sp)
    800021ae:	6442                	ld	s0,16(sp)
    800021b0:	64a2                	ld	s1,8(sp)
    800021b2:	6902                	ld	s2,0(sp)
    800021b4:	6105                	addi	sp,sp,32
    800021b6:	8082                	ret
    return -1;
    800021b8:	557d                	li	a0,-1
    800021ba:	bfcd                	j	800021ac <fetchaddr+0x3e>
    800021bc:	557d                	li	a0,-1
    800021be:	b7fd                	j	800021ac <fetchaddr+0x3e>

00000000800021c0 <fetchstr>:
{
    800021c0:	7179                	addi	sp,sp,-48
    800021c2:	f406                	sd	ra,40(sp)
    800021c4:	f022                	sd	s0,32(sp)
    800021c6:	ec26                	sd	s1,24(sp)
    800021c8:	e84a                	sd	s2,16(sp)
    800021ca:	e44e                	sd	s3,8(sp)
    800021cc:	1800                	addi	s0,sp,48
    800021ce:	892a                	mv	s2,a0
    800021d0:	84ae                	mv	s1,a1
    800021d2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	e86080e7          	jalr	-378(ra) # 8000105a <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800021dc:	86ce                	mv	a3,s3
    800021de:	864a                	mv	a2,s2
    800021e0:	85a6                	mv	a1,s1
    800021e2:	6928                	ld	a0,80(a0)
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	b02080e7          	jalr	-1278(ra) # 80000ce6 <copyinstr>
  if(err < 0)
    800021ec:	00054763          	bltz	a0,800021fa <fetchstr+0x3a>
  return strlen(buf);
    800021f0:	8526                	mv	a0,s1
    800021f2:	ffffe097          	auipc	ra,0xffffe
    800021f6:	26a080e7          	jalr	618(ra) # 8000045c <strlen>
}
    800021fa:	70a2                	ld	ra,40(sp)
    800021fc:	7402                	ld	s0,32(sp)
    800021fe:	64e2                	ld	s1,24(sp)
    80002200:	6942                	ld	s2,16(sp)
    80002202:	69a2                	ld	s3,8(sp)
    80002204:	6145                	addi	sp,sp,48
    80002206:	8082                	ret

0000000080002208 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002208:	1101                	addi	sp,sp,-32
    8000220a:	ec06                	sd	ra,24(sp)
    8000220c:	e822                	sd	s0,16(sp)
    8000220e:	e426                	sd	s1,8(sp)
    80002210:	1000                	addi	s0,sp,32
    80002212:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002214:	00000097          	auipc	ra,0x0
    80002218:	ef2080e7          	jalr	-270(ra) # 80002106 <argraw>
    8000221c:	c088                	sw	a0,0(s1)
  return 0;
}
    8000221e:	4501                	li	a0,0
    80002220:	60e2                	ld	ra,24(sp)
    80002222:	6442                	ld	s0,16(sp)
    80002224:	64a2                	ld	s1,8(sp)
    80002226:	6105                	addi	sp,sp,32
    80002228:	8082                	ret

000000008000222a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    8000222a:	1101                	addi	sp,sp,-32
    8000222c:	ec06                	sd	ra,24(sp)
    8000222e:	e822                	sd	s0,16(sp)
    80002230:	e426                	sd	s1,8(sp)
    80002232:	1000                	addi	s0,sp,32
    80002234:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002236:	00000097          	auipc	ra,0x0
    8000223a:	ed0080e7          	jalr	-304(ra) # 80002106 <argraw>
    8000223e:	e088                	sd	a0,0(s1)
  return 0;
}
    80002240:	4501                	li	a0,0
    80002242:	60e2                	ld	ra,24(sp)
    80002244:	6442                	ld	s0,16(sp)
    80002246:	64a2                	ld	s1,8(sp)
    80002248:	6105                	addi	sp,sp,32
    8000224a:	8082                	ret

000000008000224c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000224c:	1101                	addi	sp,sp,-32
    8000224e:	ec06                	sd	ra,24(sp)
    80002250:	e822                	sd	s0,16(sp)
    80002252:	e426                	sd	s1,8(sp)
    80002254:	e04a                	sd	s2,0(sp)
    80002256:	1000                	addi	s0,sp,32
    80002258:	84ae                	mv	s1,a1
    8000225a:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000225c:	00000097          	auipc	ra,0x0
    80002260:	eaa080e7          	jalr	-342(ra) # 80002106 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002264:	864a                	mv	a2,s2
    80002266:	85a6                	mv	a1,s1
    80002268:	00000097          	auipc	ra,0x0
    8000226c:	f58080e7          	jalr	-168(ra) # 800021c0 <fetchstr>
}
    80002270:	60e2                	ld	ra,24(sp)
    80002272:	6442                	ld	s0,16(sp)
    80002274:	64a2                	ld	s1,8(sp)
    80002276:	6902                	ld	s2,0(sp)
    80002278:	6105                	addi	sp,sp,32
    8000227a:	8082                	ret

000000008000227c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000227c:	1101                	addi	sp,sp,-32
    8000227e:	ec06                	sd	ra,24(sp)
    80002280:	e822                	sd	s0,16(sp)
    80002282:	e426                	sd	s1,8(sp)
    80002284:	e04a                	sd	s2,0(sp)
    80002286:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	dd2080e7          	jalr	-558(ra) # 8000105a <myproc>
    80002290:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002292:	05853903          	ld	s2,88(a0)
    80002296:	0a893783          	ld	a5,168(s2)
    8000229a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000229e:	37fd                	addiw	a5,a5,-1
    800022a0:	4751                	li	a4,20
    800022a2:	00f76f63          	bltu	a4,a5,800022c0 <syscall+0x44>
    800022a6:	00369713          	slli	a4,a3,0x3
    800022aa:	00006797          	auipc	a5,0x6
    800022ae:	18e78793          	addi	a5,a5,398 # 80008438 <syscalls>
    800022b2:	97ba                	add	a5,a5,a4
    800022b4:	639c                	ld	a5,0(a5)
    800022b6:	c789                	beqz	a5,800022c0 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800022b8:	9782                	jalr	a5
    800022ba:	06a93823          	sd	a0,112(s2)
    800022be:	a839                	j	800022dc <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800022c0:	15848613          	addi	a2,s1,344
    800022c4:	588c                	lw	a1,48(s1)
    800022c6:	00006517          	auipc	a0,0x6
    800022ca:	13a50513          	addi	a0,a0,314 # 80008400 <states.1720+0x190>
    800022ce:	00004097          	auipc	ra,0x4
    800022d2:	ba4080e7          	jalr	-1116(ra) # 80005e72 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022d6:	6cbc                	ld	a5,88(s1)
    800022d8:	577d                	li	a4,-1
    800022da:	fbb8                	sd	a4,112(a5)
  }
}
    800022dc:	60e2                	ld	ra,24(sp)
    800022de:	6442                	ld	s0,16(sp)
    800022e0:	64a2                	ld	s1,8(sp)
    800022e2:	6902                	ld	s2,0(sp)
    800022e4:	6105                	addi	sp,sp,32
    800022e6:	8082                	ret

00000000800022e8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800022e8:	1101                	addi	sp,sp,-32
    800022ea:	ec06                	sd	ra,24(sp)
    800022ec:	e822                	sd	s0,16(sp)
    800022ee:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800022f0:	fec40593          	addi	a1,s0,-20
    800022f4:	4501                	li	a0,0
    800022f6:	00000097          	auipc	ra,0x0
    800022fa:	f12080e7          	jalr	-238(ra) # 80002208 <argint>
    return -1;
    800022fe:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002300:	00054963          	bltz	a0,80002312 <sys_exit+0x2a>
  exit(n);
    80002304:	fec42503          	lw	a0,-20(s0)
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	66a080e7          	jalr	1642(ra) # 80001972 <exit>
  return 0;  // not reached
    80002310:	4781                	li	a5,0
}
    80002312:	853e                	mv	a0,a5
    80002314:	60e2                	ld	ra,24(sp)
    80002316:	6442                	ld	s0,16(sp)
    80002318:	6105                	addi	sp,sp,32
    8000231a:	8082                	ret

000000008000231c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000231c:	1141                	addi	sp,sp,-16
    8000231e:	e406                	sd	ra,8(sp)
    80002320:	e022                	sd	s0,0(sp)
    80002322:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002324:	fffff097          	auipc	ra,0xfffff
    80002328:	d36080e7          	jalr	-714(ra) # 8000105a <myproc>
}
    8000232c:	5908                	lw	a0,48(a0)
    8000232e:	60a2                	ld	ra,8(sp)
    80002330:	6402                	ld	s0,0(sp)
    80002332:	0141                	addi	sp,sp,16
    80002334:	8082                	ret

0000000080002336 <sys_fork>:

uint64
sys_fork(void)
{
    80002336:	1141                	addi	sp,sp,-16
    80002338:	e406                	sd	ra,8(sp)
    8000233a:	e022                	sd	s0,0(sp)
    8000233c:	0800                	addi	s0,sp,16
  return fork();
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	0ea080e7          	jalr	234(ra) # 80001428 <fork>
}
    80002346:	60a2                	ld	ra,8(sp)
    80002348:	6402                	ld	s0,0(sp)
    8000234a:	0141                	addi	sp,sp,16
    8000234c:	8082                	ret

000000008000234e <sys_wait>:

uint64
sys_wait(void)
{
    8000234e:	1101                	addi	sp,sp,-32
    80002350:	ec06                	sd	ra,24(sp)
    80002352:	e822                	sd	s0,16(sp)
    80002354:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002356:	fe840593          	addi	a1,s0,-24
    8000235a:	4501                	li	a0,0
    8000235c:	00000097          	auipc	ra,0x0
    80002360:	ece080e7          	jalr	-306(ra) # 8000222a <argaddr>
    80002364:	87aa                	mv	a5,a0
    return -1;
    80002366:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002368:	0007c863          	bltz	a5,80002378 <sys_wait+0x2a>
  return wait(p);
    8000236c:	fe843503          	ld	a0,-24(s0)
    80002370:	fffff097          	auipc	ra,0xfffff
    80002374:	40a080e7          	jalr	1034(ra) # 8000177a <wait>
}
    80002378:	60e2                	ld	ra,24(sp)
    8000237a:	6442                	ld	s0,16(sp)
    8000237c:	6105                	addi	sp,sp,32
    8000237e:	8082                	ret

0000000080002380 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002380:	7179                	addi	sp,sp,-48
    80002382:	f406                	sd	ra,40(sp)
    80002384:	f022                	sd	s0,32(sp)
    80002386:	ec26                	sd	s1,24(sp)
    80002388:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000238a:	fdc40593          	addi	a1,s0,-36
    8000238e:	4501                	li	a0,0
    80002390:	00000097          	auipc	ra,0x0
    80002394:	e78080e7          	jalr	-392(ra) # 80002208 <argint>
    80002398:	87aa                	mv	a5,a0
    return -1;
    8000239a:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000239c:	0207c063          	bltz	a5,800023bc <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	cba080e7          	jalr	-838(ra) # 8000105a <myproc>
    800023a8:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800023aa:	fdc42503          	lw	a0,-36(s0)
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	006080e7          	jalr	6(ra) # 800013b4 <growproc>
    800023b6:	00054863          	bltz	a0,800023c6 <sys_sbrk+0x46>
    return -1;
  return addr;
    800023ba:	8526                	mv	a0,s1
}
    800023bc:	70a2                	ld	ra,40(sp)
    800023be:	7402                	ld	s0,32(sp)
    800023c0:	64e2                	ld	s1,24(sp)
    800023c2:	6145                	addi	sp,sp,48
    800023c4:	8082                	ret
    return -1;
    800023c6:	557d                	li	a0,-1
    800023c8:	bfd5                	j	800023bc <sys_sbrk+0x3c>

00000000800023ca <sys_sleep>:

uint64
sys_sleep(void)
{
    800023ca:	7139                	addi	sp,sp,-64
    800023cc:	fc06                	sd	ra,56(sp)
    800023ce:	f822                	sd	s0,48(sp)
    800023d0:	f426                	sd	s1,40(sp)
    800023d2:	f04a                	sd	s2,32(sp)
    800023d4:	ec4e                	sd	s3,24(sp)
    800023d6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800023d8:	fcc40593          	addi	a1,s0,-52
    800023dc:	4501                	li	a0,0
    800023de:	00000097          	auipc	ra,0x0
    800023e2:	e2a080e7          	jalr	-470(ra) # 80002208 <argint>
    return -1;
    800023e6:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800023e8:	06054563          	bltz	a0,80002452 <sys_sleep+0x88>
  acquire(&tickslock);
    800023ec:	0022d517          	auipc	a0,0x22d
    800023f0:	aac50513          	addi	a0,a0,-1364 # 8022ee98 <tickslock>
    800023f4:	00004097          	auipc	ra,0x4
    800023f8:	f7e080e7          	jalr	-130(ra) # 80006372 <acquire>
  ticks0 = ticks;
    800023fc:	00007917          	auipc	s2,0x7
    80002400:	c1c92903          	lw	s2,-996(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002404:	fcc42783          	lw	a5,-52(s0)
    80002408:	cf85                	beqz	a5,80002440 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000240a:	0022d997          	auipc	s3,0x22d
    8000240e:	a8e98993          	addi	s3,s3,-1394 # 8022ee98 <tickslock>
    80002412:	00007497          	auipc	s1,0x7
    80002416:	c0648493          	addi	s1,s1,-1018 # 80009018 <ticks>
    if(myproc()->killed){
    8000241a:	fffff097          	auipc	ra,0xfffff
    8000241e:	c40080e7          	jalr	-960(ra) # 8000105a <myproc>
    80002422:	551c                	lw	a5,40(a0)
    80002424:	ef9d                	bnez	a5,80002462 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002426:	85ce                	mv	a1,s3
    80002428:	8526                	mv	a0,s1
    8000242a:	fffff097          	auipc	ra,0xfffff
    8000242e:	2ec080e7          	jalr	748(ra) # 80001716 <sleep>
  while(ticks - ticks0 < n){
    80002432:	409c                	lw	a5,0(s1)
    80002434:	412787bb          	subw	a5,a5,s2
    80002438:	fcc42703          	lw	a4,-52(s0)
    8000243c:	fce7efe3          	bltu	a5,a4,8000241a <sys_sleep+0x50>
  }
  release(&tickslock);
    80002440:	0022d517          	auipc	a0,0x22d
    80002444:	a5850513          	addi	a0,a0,-1448 # 8022ee98 <tickslock>
    80002448:	00004097          	auipc	ra,0x4
    8000244c:	fde080e7          	jalr	-34(ra) # 80006426 <release>
  return 0;
    80002450:	4781                	li	a5,0
}
    80002452:	853e                	mv	a0,a5
    80002454:	70e2                	ld	ra,56(sp)
    80002456:	7442                	ld	s0,48(sp)
    80002458:	74a2                	ld	s1,40(sp)
    8000245a:	7902                	ld	s2,32(sp)
    8000245c:	69e2                	ld	s3,24(sp)
    8000245e:	6121                	addi	sp,sp,64
    80002460:	8082                	ret
      release(&tickslock);
    80002462:	0022d517          	auipc	a0,0x22d
    80002466:	a3650513          	addi	a0,a0,-1482 # 8022ee98 <tickslock>
    8000246a:	00004097          	auipc	ra,0x4
    8000246e:	fbc080e7          	jalr	-68(ra) # 80006426 <release>
      return -1;
    80002472:	57fd                	li	a5,-1
    80002474:	bff9                	j	80002452 <sys_sleep+0x88>

0000000080002476 <sys_kill>:

uint64
sys_kill(void)
{
    80002476:	1101                	addi	sp,sp,-32
    80002478:	ec06                	sd	ra,24(sp)
    8000247a:	e822                	sd	s0,16(sp)
    8000247c:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000247e:	fec40593          	addi	a1,s0,-20
    80002482:	4501                	li	a0,0
    80002484:	00000097          	auipc	ra,0x0
    80002488:	d84080e7          	jalr	-636(ra) # 80002208 <argint>
    8000248c:	87aa                	mv	a5,a0
    return -1;
    8000248e:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002490:	0007c863          	bltz	a5,800024a0 <sys_kill+0x2a>
  return kill(pid);
    80002494:	fec42503          	lw	a0,-20(s0)
    80002498:	fffff097          	auipc	ra,0xfffff
    8000249c:	5b0080e7          	jalr	1456(ra) # 80001a48 <kill>
}
    800024a0:	60e2                	ld	ra,24(sp)
    800024a2:	6442                	ld	s0,16(sp)
    800024a4:	6105                	addi	sp,sp,32
    800024a6:	8082                	ret

00000000800024a8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024a8:	1101                	addi	sp,sp,-32
    800024aa:	ec06                	sd	ra,24(sp)
    800024ac:	e822                	sd	s0,16(sp)
    800024ae:	e426                	sd	s1,8(sp)
    800024b0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024b2:	0022d517          	auipc	a0,0x22d
    800024b6:	9e650513          	addi	a0,a0,-1562 # 8022ee98 <tickslock>
    800024ba:	00004097          	auipc	ra,0x4
    800024be:	eb8080e7          	jalr	-328(ra) # 80006372 <acquire>
  xticks = ticks;
    800024c2:	00007497          	auipc	s1,0x7
    800024c6:	b564a483          	lw	s1,-1194(s1) # 80009018 <ticks>
  release(&tickslock);
    800024ca:	0022d517          	auipc	a0,0x22d
    800024ce:	9ce50513          	addi	a0,a0,-1586 # 8022ee98 <tickslock>
    800024d2:	00004097          	auipc	ra,0x4
    800024d6:	f54080e7          	jalr	-172(ra) # 80006426 <release>
  return xticks;
}
    800024da:	02049513          	slli	a0,s1,0x20
    800024de:	9101                	srli	a0,a0,0x20
    800024e0:	60e2                	ld	ra,24(sp)
    800024e2:	6442                	ld	s0,16(sp)
    800024e4:	64a2                	ld	s1,8(sp)
    800024e6:	6105                	addi	sp,sp,32
    800024e8:	8082                	ret

00000000800024ea <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024ea:	7179                	addi	sp,sp,-48
    800024ec:	f406                	sd	ra,40(sp)
    800024ee:	f022                	sd	s0,32(sp)
    800024f0:	ec26                	sd	s1,24(sp)
    800024f2:	e84a                	sd	s2,16(sp)
    800024f4:	e44e                	sd	s3,8(sp)
    800024f6:	e052                	sd	s4,0(sp)
    800024f8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024fa:	00006597          	auipc	a1,0x6
    800024fe:	fee58593          	addi	a1,a1,-18 # 800084e8 <syscalls+0xb0>
    80002502:	0022d517          	auipc	a0,0x22d
    80002506:	9ae50513          	addi	a0,a0,-1618 # 8022eeb0 <bcache>
    8000250a:	00004097          	auipc	ra,0x4
    8000250e:	dd8080e7          	jalr	-552(ra) # 800062e2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002512:	00235797          	auipc	a5,0x235
    80002516:	99e78793          	addi	a5,a5,-1634 # 80236eb0 <bcache+0x8000>
    8000251a:	00235717          	auipc	a4,0x235
    8000251e:	bfe70713          	addi	a4,a4,-1026 # 80237118 <bcache+0x8268>
    80002522:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002526:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000252a:	0022d497          	auipc	s1,0x22d
    8000252e:	99e48493          	addi	s1,s1,-1634 # 8022eec8 <bcache+0x18>
    b->next = bcache.head.next;
    80002532:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002534:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002536:	00006a17          	auipc	s4,0x6
    8000253a:	fbaa0a13          	addi	s4,s4,-70 # 800084f0 <syscalls+0xb8>
    b->next = bcache.head.next;
    8000253e:	2b893783          	ld	a5,696(s2)
    80002542:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002544:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002548:	85d2                	mv	a1,s4
    8000254a:	01048513          	addi	a0,s1,16
    8000254e:	00001097          	auipc	ra,0x1
    80002552:	4bc080e7          	jalr	1212(ra) # 80003a0a <initsleeplock>
    bcache.head.next->prev = b;
    80002556:	2b893783          	ld	a5,696(s2)
    8000255a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000255c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002560:	45848493          	addi	s1,s1,1112
    80002564:	fd349de3          	bne	s1,s3,8000253e <binit+0x54>
  }
}
    80002568:	70a2                	ld	ra,40(sp)
    8000256a:	7402                	ld	s0,32(sp)
    8000256c:	64e2                	ld	s1,24(sp)
    8000256e:	6942                	ld	s2,16(sp)
    80002570:	69a2                	ld	s3,8(sp)
    80002572:	6a02                	ld	s4,0(sp)
    80002574:	6145                	addi	sp,sp,48
    80002576:	8082                	ret

0000000080002578 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002578:	7179                	addi	sp,sp,-48
    8000257a:	f406                	sd	ra,40(sp)
    8000257c:	f022                	sd	s0,32(sp)
    8000257e:	ec26                	sd	s1,24(sp)
    80002580:	e84a                	sd	s2,16(sp)
    80002582:	e44e                	sd	s3,8(sp)
    80002584:	1800                	addi	s0,sp,48
    80002586:	89aa                	mv	s3,a0
    80002588:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000258a:	0022d517          	auipc	a0,0x22d
    8000258e:	92650513          	addi	a0,a0,-1754 # 8022eeb0 <bcache>
    80002592:	00004097          	auipc	ra,0x4
    80002596:	de0080e7          	jalr	-544(ra) # 80006372 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000259a:	00235497          	auipc	s1,0x235
    8000259e:	bce4b483          	ld	s1,-1074(s1) # 80237168 <bcache+0x82b8>
    800025a2:	00235797          	auipc	a5,0x235
    800025a6:	b7678793          	addi	a5,a5,-1162 # 80237118 <bcache+0x8268>
    800025aa:	02f48f63          	beq	s1,a5,800025e8 <bread+0x70>
    800025ae:	873e                	mv	a4,a5
    800025b0:	a021                	j	800025b8 <bread+0x40>
    800025b2:	68a4                	ld	s1,80(s1)
    800025b4:	02e48a63          	beq	s1,a4,800025e8 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025b8:	449c                	lw	a5,8(s1)
    800025ba:	ff379ce3          	bne	a5,s3,800025b2 <bread+0x3a>
    800025be:	44dc                	lw	a5,12(s1)
    800025c0:	ff2799e3          	bne	a5,s2,800025b2 <bread+0x3a>
      b->refcnt++;
    800025c4:	40bc                	lw	a5,64(s1)
    800025c6:	2785                	addiw	a5,a5,1
    800025c8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025ca:	0022d517          	auipc	a0,0x22d
    800025ce:	8e650513          	addi	a0,a0,-1818 # 8022eeb0 <bcache>
    800025d2:	00004097          	auipc	ra,0x4
    800025d6:	e54080e7          	jalr	-428(ra) # 80006426 <release>
      acquiresleep(&b->lock);
    800025da:	01048513          	addi	a0,s1,16
    800025de:	00001097          	auipc	ra,0x1
    800025e2:	466080e7          	jalr	1126(ra) # 80003a44 <acquiresleep>
      return b;
    800025e6:	a8b9                	j	80002644 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025e8:	00235497          	auipc	s1,0x235
    800025ec:	b784b483          	ld	s1,-1160(s1) # 80237160 <bcache+0x82b0>
    800025f0:	00235797          	auipc	a5,0x235
    800025f4:	b2878793          	addi	a5,a5,-1240 # 80237118 <bcache+0x8268>
    800025f8:	00f48863          	beq	s1,a5,80002608 <bread+0x90>
    800025fc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025fe:	40bc                	lw	a5,64(s1)
    80002600:	cf81                	beqz	a5,80002618 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002602:	64a4                	ld	s1,72(s1)
    80002604:	fee49de3          	bne	s1,a4,800025fe <bread+0x86>
  panic("bget: no buffers");
    80002608:	00006517          	auipc	a0,0x6
    8000260c:	ef050513          	addi	a0,a0,-272 # 800084f8 <syscalls+0xc0>
    80002610:	00004097          	auipc	ra,0x4
    80002614:	818080e7          	jalr	-2024(ra) # 80005e28 <panic>
      b->dev = dev;
    80002618:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000261c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002620:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002624:	4785                	li	a5,1
    80002626:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002628:	0022d517          	auipc	a0,0x22d
    8000262c:	88850513          	addi	a0,a0,-1912 # 8022eeb0 <bcache>
    80002630:	00004097          	auipc	ra,0x4
    80002634:	df6080e7          	jalr	-522(ra) # 80006426 <release>
      acquiresleep(&b->lock);
    80002638:	01048513          	addi	a0,s1,16
    8000263c:	00001097          	auipc	ra,0x1
    80002640:	408080e7          	jalr	1032(ra) # 80003a44 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002644:	409c                	lw	a5,0(s1)
    80002646:	cb89                	beqz	a5,80002658 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002648:	8526                	mv	a0,s1
    8000264a:	70a2                	ld	ra,40(sp)
    8000264c:	7402                	ld	s0,32(sp)
    8000264e:	64e2                	ld	s1,24(sp)
    80002650:	6942                	ld	s2,16(sp)
    80002652:	69a2                	ld	s3,8(sp)
    80002654:	6145                	addi	sp,sp,48
    80002656:	8082                	ret
    virtio_disk_rw(b, 0);
    80002658:	4581                	li	a1,0
    8000265a:	8526                	mv	a0,s1
    8000265c:	00003097          	auipc	ra,0x3
    80002660:	f0a080e7          	jalr	-246(ra) # 80005566 <virtio_disk_rw>
    b->valid = 1;
    80002664:	4785                	li	a5,1
    80002666:	c09c                	sw	a5,0(s1)
  return b;
    80002668:	b7c5                	j	80002648 <bread+0xd0>

000000008000266a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000266a:	1101                	addi	sp,sp,-32
    8000266c:	ec06                	sd	ra,24(sp)
    8000266e:	e822                	sd	s0,16(sp)
    80002670:	e426                	sd	s1,8(sp)
    80002672:	1000                	addi	s0,sp,32
    80002674:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002676:	0541                	addi	a0,a0,16
    80002678:	00001097          	auipc	ra,0x1
    8000267c:	466080e7          	jalr	1126(ra) # 80003ade <holdingsleep>
    80002680:	cd01                	beqz	a0,80002698 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002682:	4585                	li	a1,1
    80002684:	8526                	mv	a0,s1
    80002686:	00003097          	auipc	ra,0x3
    8000268a:	ee0080e7          	jalr	-288(ra) # 80005566 <virtio_disk_rw>
}
    8000268e:	60e2                	ld	ra,24(sp)
    80002690:	6442                	ld	s0,16(sp)
    80002692:	64a2                	ld	s1,8(sp)
    80002694:	6105                	addi	sp,sp,32
    80002696:	8082                	ret
    panic("bwrite");
    80002698:	00006517          	auipc	a0,0x6
    8000269c:	e7850513          	addi	a0,a0,-392 # 80008510 <syscalls+0xd8>
    800026a0:	00003097          	auipc	ra,0x3
    800026a4:	788080e7          	jalr	1928(ra) # 80005e28 <panic>

00000000800026a8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026a8:	1101                	addi	sp,sp,-32
    800026aa:	ec06                	sd	ra,24(sp)
    800026ac:	e822                	sd	s0,16(sp)
    800026ae:	e426                	sd	s1,8(sp)
    800026b0:	e04a                	sd	s2,0(sp)
    800026b2:	1000                	addi	s0,sp,32
    800026b4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026b6:	01050913          	addi	s2,a0,16
    800026ba:	854a                	mv	a0,s2
    800026bc:	00001097          	auipc	ra,0x1
    800026c0:	422080e7          	jalr	1058(ra) # 80003ade <holdingsleep>
    800026c4:	c92d                	beqz	a0,80002736 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800026c6:	854a                	mv	a0,s2
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	3d2080e7          	jalr	978(ra) # 80003a9a <releasesleep>

  acquire(&bcache.lock);
    800026d0:	0022c517          	auipc	a0,0x22c
    800026d4:	7e050513          	addi	a0,a0,2016 # 8022eeb0 <bcache>
    800026d8:	00004097          	auipc	ra,0x4
    800026dc:	c9a080e7          	jalr	-870(ra) # 80006372 <acquire>
  b->refcnt--;
    800026e0:	40bc                	lw	a5,64(s1)
    800026e2:	37fd                	addiw	a5,a5,-1
    800026e4:	0007871b          	sext.w	a4,a5
    800026e8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026ea:	eb05                	bnez	a4,8000271a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026ec:	68bc                	ld	a5,80(s1)
    800026ee:	64b8                	ld	a4,72(s1)
    800026f0:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026f2:	64bc                	ld	a5,72(s1)
    800026f4:	68b8                	ld	a4,80(s1)
    800026f6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026f8:	00234797          	auipc	a5,0x234
    800026fc:	7b878793          	addi	a5,a5,1976 # 80236eb0 <bcache+0x8000>
    80002700:	2b87b703          	ld	a4,696(a5)
    80002704:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002706:	00235717          	auipc	a4,0x235
    8000270a:	a1270713          	addi	a4,a4,-1518 # 80237118 <bcache+0x8268>
    8000270e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002710:	2b87b703          	ld	a4,696(a5)
    80002714:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002716:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000271a:	0022c517          	auipc	a0,0x22c
    8000271e:	79650513          	addi	a0,a0,1942 # 8022eeb0 <bcache>
    80002722:	00004097          	auipc	ra,0x4
    80002726:	d04080e7          	jalr	-764(ra) # 80006426 <release>
}
    8000272a:	60e2                	ld	ra,24(sp)
    8000272c:	6442                	ld	s0,16(sp)
    8000272e:	64a2                	ld	s1,8(sp)
    80002730:	6902                	ld	s2,0(sp)
    80002732:	6105                	addi	sp,sp,32
    80002734:	8082                	ret
    panic("brelse");
    80002736:	00006517          	auipc	a0,0x6
    8000273a:	de250513          	addi	a0,a0,-542 # 80008518 <syscalls+0xe0>
    8000273e:	00003097          	auipc	ra,0x3
    80002742:	6ea080e7          	jalr	1770(ra) # 80005e28 <panic>

0000000080002746 <bpin>:

void
bpin(struct buf *b) {
    80002746:	1101                	addi	sp,sp,-32
    80002748:	ec06                	sd	ra,24(sp)
    8000274a:	e822                	sd	s0,16(sp)
    8000274c:	e426                	sd	s1,8(sp)
    8000274e:	1000                	addi	s0,sp,32
    80002750:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002752:	0022c517          	auipc	a0,0x22c
    80002756:	75e50513          	addi	a0,a0,1886 # 8022eeb0 <bcache>
    8000275a:	00004097          	auipc	ra,0x4
    8000275e:	c18080e7          	jalr	-1000(ra) # 80006372 <acquire>
  b->refcnt++;
    80002762:	40bc                	lw	a5,64(s1)
    80002764:	2785                	addiw	a5,a5,1
    80002766:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002768:	0022c517          	auipc	a0,0x22c
    8000276c:	74850513          	addi	a0,a0,1864 # 8022eeb0 <bcache>
    80002770:	00004097          	auipc	ra,0x4
    80002774:	cb6080e7          	jalr	-842(ra) # 80006426 <release>
}
    80002778:	60e2                	ld	ra,24(sp)
    8000277a:	6442                	ld	s0,16(sp)
    8000277c:	64a2                	ld	s1,8(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret

0000000080002782 <bunpin>:

void
bunpin(struct buf *b) {
    80002782:	1101                	addi	sp,sp,-32
    80002784:	ec06                	sd	ra,24(sp)
    80002786:	e822                	sd	s0,16(sp)
    80002788:	e426                	sd	s1,8(sp)
    8000278a:	1000                	addi	s0,sp,32
    8000278c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000278e:	0022c517          	auipc	a0,0x22c
    80002792:	72250513          	addi	a0,a0,1826 # 8022eeb0 <bcache>
    80002796:	00004097          	auipc	ra,0x4
    8000279a:	bdc080e7          	jalr	-1060(ra) # 80006372 <acquire>
  b->refcnt--;
    8000279e:	40bc                	lw	a5,64(s1)
    800027a0:	37fd                	addiw	a5,a5,-1
    800027a2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027a4:	0022c517          	auipc	a0,0x22c
    800027a8:	70c50513          	addi	a0,a0,1804 # 8022eeb0 <bcache>
    800027ac:	00004097          	auipc	ra,0x4
    800027b0:	c7a080e7          	jalr	-902(ra) # 80006426 <release>
}
    800027b4:	60e2                	ld	ra,24(sp)
    800027b6:	6442                	ld	s0,16(sp)
    800027b8:	64a2                	ld	s1,8(sp)
    800027ba:	6105                	addi	sp,sp,32
    800027bc:	8082                	ret

00000000800027be <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027be:	1101                	addi	sp,sp,-32
    800027c0:	ec06                	sd	ra,24(sp)
    800027c2:	e822                	sd	s0,16(sp)
    800027c4:	e426                	sd	s1,8(sp)
    800027c6:	e04a                	sd	s2,0(sp)
    800027c8:	1000                	addi	s0,sp,32
    800027ca:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027cc:	00d5d59b          	srliw	a1,a1,0xd
    800027d0:	00235797          	auipc	a5,0x235
    800027d4:	dbc7a783          	lw	a5,-580(a5) # 8023758c <sb+0x1c>
    800027d8:	9dbd                	addw	a1,a1,a5
    800027da:	00000097          	auipc	ra,0x0
    800027de:	d9e080e7          	jalr	-610(ra) # 80002578 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027e2:	0074f713          	andi	a4,s1,7
    800027e6:	4785                	li	a5,1
    800027e8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027ec:	14ce                	slli	s1,s1,0x33
    800027ee:	90d9                	srli	s1,s1,0x36
    800027f0:	00950733          	add	a4,a0,s1
    800027f4:	05874703          	lbu	a4,88(a4)
    800027f8:	00e7f6b3          	and	a3,a5,a4
    800027fc:	c69d                	beqz	a3,8000282a <bfree+0x6c>
    800027fe:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002800:	94aa                	add	s1,s1,a0
    80002802:	fff7c793          	not	a5,a5
    80002806:	8ff9                	and	a5,a5,a4
    80002808:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000280c:	00001097          	auipc	ra,0x1
    80002810:	118080e7          	jalr	280(ra) # 80003924 <log_write>
  brelse(bp);
    80002814:	854a                	mv	a0,s2
    80002816:	00000097          	auipc	ra,0x0
    8000281a:	e92080e7          	jalr	-366(ra) # 800026a8 <brelse>
}
    8000281e:	60e2                	ld	ra,24(sp)
    80002820:	6442                	ld	s0,16(sp)
    80002822:	64a2                	ld	s1,8(sp)
    80002824:	6902                	ld	s2,0(sp)
    80002826:	6105                	addi	sp,sp,32
    80002828:	8082                	ret
    panic("freeing free block");
    8000282a:	00006517          	auipc	a0,0x6
    8000282e:	cf650513          	addi	a0,a0,-778 # 80008520 <syscalls+0xe8>
    80002832:	00003097          	auipc	ra,0x3
    80002836:	5f6080e7          	jalr	1526(ra) # 80005e28 <panic>

000000008000283a <balloc>:
{
    8000283a:	711d                	addi	sp,sp,-96
    8000283c:	ec86                	sd	ra,88(sp)
    8000283e:	e8a2                	sd	s0,80(sp)
    80002840:	e4a6                	sd	s1,72(sp)
    80002842:	e0ca                	sd	s2,64(sp)
    80002844:	fc4e                	sd	s3,56(sp)
    80002846:	f852                	sd	s4,48(sp)
    80002848:	f456                	sd	s5,40(sp)
    8000284a:	f05a                	sd	s6,32(sp)
    8000284c:	ec5e                	sd	s7,24(sp)
    8000284e:	e862                	sd	s8,16(sp)
    80002850:	e466                	sd	s9,8(sp)
    80002852:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002854:	00235797          	auipc	a5,0x235
    80002858:	d207a783          	lw	a5,-736(a5) # 80237574 <sb+0x4>
    8000285c:	cbd1                	beqz	a5,800028f0 <balloc+0xb6>
    8000285e:	8baa                	mv	s7,a0
    80002860:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002862:	00235b17          	auipc	s6,0x235
    80002866:	d0eb0b13          	addi	s6,s6,-754 # 80237570 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000286a:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000286c:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000286e:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002870:	6c89                	lui	s9,0x2
    80002872:	a831                	j	8000288e <balloc+0x54>
    brelse(bp);
    80002874:	854a                	mv	a0,s2
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	e32080e7          	jalr	-462(ra) # 800026a8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000287e:	015c87bb          	addw	a5,s9,s5
    80002882:	00078a9b          	sext.w	s5,a5
    80002886:	004b2703          	lw	a4,4(s6)
    8000288a:	06eaf363          	bgeu	s5,a4,800028f0 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000288e:	41fad79b          	sraiw	a5,s5,0x1f
    80002892:	0137d79b          	srliw	a5,a5,0x13
    80002896:	015787bb          	addw	a5,a5,s5
    8000289a:	40d7d79b          	sraiw	a5,a5,0xd
    8000289e:	01cb2583          	lw	a1,28(s6)
    800028a2:	9dbd                	addw	a1,a1,a5
    800028a4:	855e                	mv	a0,s7
    800028a6:	00000097          	auipc	ra,0x0
    800028aa:	cd2080e7          	jalr	-814(ra) # 80002578 <bread>
    800028ae:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028b0:	004b2503          	lw	a0,4(s6)
    800028b4:	000a849b          	sext.w	s1,s5
    800028b8:	8662                	mv	a2,s8
    800028ba:	faa4fde3          	bgeu	s1,a0,80002874 <balloc+0x3a>
      m = 1 << (bi % 8);
    800028be:	41f6579b          	sraiw	a5,a2,0x1f
    800028c2:	01d7d69b          	srliw	a3,a5,0x1d
    800028c6:	00c6873b          	addw	a4,a3,a2
    800028ca:	00777793          	andi	a5,a4,7
    800028ce:	9f95                	subw	a5,a5,a3
    800028d0:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028d4:	4037571b          	sraiw	a4,a4,0x3
    800028d8:	00e906b3          	add	a3,s2,a4
    800028dc:	0586c683          	lbu	a3,88(a3)
    800028e0:	00d7f5b3          	and	a1,a5,a3
    800028e4:	cd91                	beqz	a1,80002900 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028e6:	2605                	addiw	a2,a2,1
    800028e8:	2485                	addiw	s1,s1,1
    800028ea:	fd4618e3          	bne	a2,s4,800028ba <balloc+0x80>
    800028ee:	b759                	j	80002874 <balloc+0x3a>
  panic("balloc: out of blocks");
    800028f0:	00006517          	auipc	a0,0x6
    800028f4:	c4850513          	addi	a0,a0,-952 # 80008538 <syscalls+0x100>
    800028f8:	00003097          	auipc	ra,0x3
    800028fc:	530080e7          	jalr	1328(ra) # 80005e28 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002900:	974a                	add	a4,a4,s2
    80002902:	8fd5                	or	a5,a5,a3
    80002904:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002908:	854a                	mv	a0,s2
    8000290a:	00001097          	auipc	ra,0x1
    8000290e:	01a080e7          	jalr	26(ra) # 80003924 <log_write>
        brelse(bp);
    80002912:	854a                	mv	a0,s2
    80002914:	00000097          	auipc	ra,0x0
    80002918:	d94080e7          	jalr	-620(ra) # 800026a8 <brelse>
  bp = bread(dev, bno);
    8000291c:	85a6                	mv	a1,s1
    8000291e:	855e                	mv	a0,s7
    80002920:	00000097          	auipc	ra,0x0
    80002924:	c58080e7          	jalr	-936(ra) # 80002578 <bread>
    80002928:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000292a:	40000613          	li	a2,1024
    8000292e:	4581                	li	a1,0
    80002930:	05850513          	addi	a0,a0,88
    80002934:	ffffe097          	auipc	ra,0xffffe
    80002938:	9a4080e7          	jalr	-1628(ra) # 800002d8 <memset>
  log_write(bp);
    8000293c:	854a                	mv	a0,s2
    8000293e:	00001097          	auipc	ra,0x1
    80002942:	fe6080e7          	jalr	-26(ra) # 80003924 <log_write>
  brelse(bp);
    80002946:	854a                	mv	a0,s2
    80002948:	00000097          	auipc	ra,0x0
    8000294c:	d60080e7          	jalr	-672(ra) # 800026a8 <brelse>
}
    80002950:	8526                	mv	a0,s1
    80002952:	60e6                	ld	ra,88(sp)
    80002954:	6446                	ld	s0,80(sp)
    80002956:	64a6                	ld	s1,72(sp)
    80002958:	6906                	ld	s2,64(sp)
    8000295a:	79e2                	ld	s3,56(sp)
    8000295c:	7a42                	ld	s4,48(sp)
    8000295e:	7aa2                	ld	s5,40(sp)
    80002960:	7b02                	ld	s6,32(sp)
    80002962:	6be2                	ld	s7,24(sp)
    80002964:	6c42                	ld	s8,16(sp)
    80002966:	6ca2                	ld	s9,8(sp)
    80002968:	6125                	addi	sp,sp,96
    8000296a:	8082                	ret

000000008000296c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000296c:	7179                	addi	sp,sp,-48
    8000296e:	f406                	sd	ra,40(sp)
    80002970:	f022                	sd	s0,32(sp)
    80002972:	ec26                	sd	s1,24(sp)
    80002974:	e84a                	sd	s2,16(sp)
    80002976:	e44e                	sd	s3,8(sp)
    80002978:	e052                	sd	s4,0(sp)
    8000297a:	1800                	addi	s0,sp,48
    8000297c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000297e:	47ad                	li	a5,11
    80002980:	04b7fe63          	bgeu	a5,a1,800029dc <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002984:	ff45849b          	addiw	s1,a1,-12
    80002988:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000298c:	0ff00793          	li	a5,255
    80002990:	0ae7e363          	bltu	a5,a4,80002a36 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002994:	08052583          	lw	a1,128(a0)
    80002998:	c5ad                	beqz	a1,80002a02 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000299a:	00092503          	lw	a0,0(s2)
    8000299e:	00000097          	auipc	ra,0x0
    800029a2:	bda080e7          	jalr	-1062(ra) # 80002578 <bread>
    800029a6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029a8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029ac:	02049593          	slli	a1,s1,0x20
    800029b0:	9181                	srli	a1,a1,0x20
    800029b2:	058a                	slli	a1,a1,0x2
    800029b4:	00b784b3          	add	s1,a5,a1
    800029b8:	0004a983          	lw	s3,0(s1)
    800029bc:	04098d63          	beqz	s3,80002a16 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029c0:	8552                	mv	a0,s4
    800029c2:	00000097          	auipc	ra,0x0
    800029c6:	ce6080e7          	jalr	-794(ra) # 800026a8 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029ca:	854e                	mv	a0,s3
    800029cc:	70a2                	ld	ra,40(sp)
    800029ce:	7402                	ld	s0,32(sp)
    800029d0:	64e2                	ld	s1,24(sp)
    800029d2:	6942                	ld	s2,16(sp)
    800029d4:	69a2                	ld	s3,8(sp)
    800029d6:	6a02                	ld	s4,0(sp)
    800029d8:	6145                	addi	sp,sp,48
    800029da:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029dc:	02059493          	slli	s1,a1,0x20
    800029e0:	9081                	srli	s1,s1,0x20
    800029e2:	048a                	slli	s1,s1,0x2
    800029e4:	94aa                	add	s1,s1,a0
    800029e6:	0504a983          	lw	s3,80(s1)
    800029ea:	fe0990e3          	bnez	s3,800029ca <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029ee:	4108                	lw	a0,0(a0)
    800029f0:	00000097          	auipc	ra,0x0
    800029f4:	e4a080e7          	jalr	-438(ra) # 8000283a <balloc>
    800029f8:	0005099b          	sext.w	s3,a0
    800029fc:	0534a823          	sw	s3,80(s1)
    80002a00:	b7e9                	j	800029ca <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a02:	4108                	lw	a0,0(a0)
    80002a04:	00000097          	auipc	ra,0x0
    80002a08:	e36080e7          	jalr	-458(ra) # 8000283a <balloc>
    80002a0c:	0005059b          	sext.w	a1,a0
    80002a10:	08b92023          	sw	a1,128(s2)
    80002a14:	b759                	j	8000299a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a16:	00092503          	lw	a0,0(s2)
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	e20080e7          	jalr	-480(ra) # 8000283a <balloc>
    80002a22:	0005099b          	sext.w	s3,a0
    80002a26:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a2a:	8552                	mv	a0,s4
    80002a2c:	00001097          	auipc	ra,0x1
    80002a30:	ef8080e7          	jalr	-264(ra) # 80003924 <log_write>
    80002a34:	b771                	j	800029c0 <bmap+0x54>
  panic("bmap: out of range");
    80002a36:	00006517          	auipc	a0,0x6
    80002a3a:	b1a50513          	addi	a0,a0,-1254 # 80008550 <syscalls+0x118>
    80002a3e:	00003097          	auipc	ra,0x3
    80002a42:	3ea080e7          	jalr	1002(ra) # 80005e28 <panic>

0000000080002a46 <iget>:
{
    80002a46:	7179                	addi	sp,sp,-48
    80002a48:	f406                	sd	ra,40(sp)
    80002a4a:	f022                	sd	s0,32(sp)
    80002a4c:	ec26                	sd	s1,24(sp)
    80002a4e:	e84a                	sd	s2,16(sp)
    80002a50:	e44e                	sd	s3,8(sp)
    80002a52:	e052                	sd	s4,0(sp)
    80002a54:	1800                	addi	s0,sp,48
    80002a56:	89aa                	mv	s3,a0
    80002a58:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a5a:	00235517          	auipc	a0,0x235
    80002a5e:	b3650513          	addi	a0,a0,-1226 # 80237590 <itable>
    80002a62:	00004097          	auipc	ra,0x4
    80002a66:	910080e7          	jalr	-1776(ra) # 80006372 <acquire>
  empty = 0;
    80002a6a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a6c:	00235497          	auipc	s1,0x235
    80002a70:	b3c48493          	addi	s1,s1,-1220 # 802375a8 <itable+0x18>
    80002a74:	00236697          	auipc	a3,0x236
    80002a78:	5c468693          	addi	a3,a3,1476 # 80239038 <log>
    80002a7c:	a039                	j	80002a8a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a7e:	02090b63          	beqz	s2,80002ab4 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a82:	08848493          	addi	s1,s1,136
    80002a86:	02d48a63          	beq	s1,a3,80002aba <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a8a:	449c                	lw	a5,8(s1)
    80002a8c:	fef059e3          	blez	a5,80002a7e <iget+0x38>
    80002a90:	4098                	lw	a4,0(s1)
    80002a92:	ff3716e3          	bne	a4,s3,80002a7e <iget+0x38>
    80002a96:	40d8                	lw	a4,4(s1)
    80002a98:	ff4713e3          	bne	a4,s4,80002a7e <iget+0x38>
      ip->ref++;
    80002a9c:	2785                	addiw	a5,a5,1
    80002a9e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002aa0:	00235517          	auipc	a0,0x235
    80002aa4:	af050513          	addi	a0,a0,-1296 # 80237590 <itable>
    80002aa8:	00004097          	auipc	ra,0x4
    80002aac:	97e080e7          	jalr	-1666(ra) # 80006426 <release>
      return ip;
    80002ab0:	8926                	mv	s2,s1
    80002ab2:	a03d                	j	80002ae0 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ab4:	f7f9                	bnez	a5,80002a82 <iget+0x3c>
    80002ab6:	8926                	mv	s2,s1
    80002ab8:	b7e9                	j	80002a82 <iget+0x3c>
  if(empty == 0)
    80002aba:	02090c63          	beqz	s2,80002af2 <iget+0xac>
  ip->dev = dev;
    80002abe:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ac2:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ac6:	4785                	li	a5,1
    80002ac8:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002acc:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ad0:	00235517          	auipc	a0,0x235
    80002ad4:	ac050513          	addi	a0,a0,-1344 # 80237590 <itable>
    80002ad8:	00004097          	auipc	ra,0x4
    80002adc:	94e080e7          	jalr	-1714(ra) # 80006426 <release>
}
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	70a2                	ld	ra,40(sp)
    80002ae4:	7402                	ld	s0,32(sp)
    80002ae6:	64e2                	ld	s1,24(sp)
    80002ae8:	6942                	ld	s2,16(sp)
    80002aea:	69a2                	ld	s3,8(sp)
    80002aec:	6a02                	ld	s4,0(sp)
    80002aee:	6145                	addi	sp,sp,48
    80002af0:	8082                	ret
    panic("iget: no inodes");
    80002af2:	00006517          	auipc	a0,0x6
    80002af6:	a7650513          	addi	a0,a0,-1418 # 80008568 <syscalls+0x130>
    80002afa:	00003097          	auipc	ra,0x3
    80002afe:	32e080e7          	jalr	814(ra) # 80005e28 <panic>

0000000080002b02 <fsinit>:
fsinit(int dev) {
    80002b02:	7179                	addi	sp,sp,-48
    80002b04:	f406                	sd	ra,40(sp)
    80002b06:	f022                	sd	s0,32(sp)
    80002b08:	ec26                	sd	s1,24(sp)
    80002b0a:	e84a                	sd	s2,16(sp)
    80002b0c:	e44e                	sd	s3,8(sp)
    80002b0e:	1800                	addi	s0,sp,48
    80002b10:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b12:	4585                	li	a1,1
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	a64080e7          	jalr	-1436(ra) # 80002578 <bread>
    80002b1c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b1e:	00235997          	auipc	s3,0x235
    80002b22:	a5298993          	addi	s3,s3,-1454 # 80237570 <sb>
    80002b26:	02000613          	li	a2,32
    80002b2a:	05850593          	addi	a1,a0,88
    80002b2e:	854e                	mv	a0,s3
    80002b30:	ffffe097          	auipc	ra,0xffffe
    80002b34:	808080e7          	jalr	-2040(ra) # 80000338 <memmove>
  brelse(bp);
    80002b38:	8526                	mv	a0,s1
    80002b3a:	00000097          	auipc	ra,0x0
    80002b3e:	b6e080e7          	jalr	-1170(ra) # 800026a8 <brelse>
  if(sb.magic != FSMAGIC)
    80002b42:	0009a703          	lw	a4,0(s3)
    80002b46:	102037b7          	lui	a5,0x10203
    80002b4a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b4e:	02f71263          	bne	a4,a5,80002b72 <fsinit+0x70>
  initlog(dev, &sb);
    80002b52:	00235597          	auipc	a1,0x235
    80002b56:	a1e58593          	addi	a1,a1,-1506 # 80237570 <sb>
    80002b5a:	854a                	mv	a0,s2
    80002b5c:	00001097          	auipc	ra,0x1
    80002b60:	b4c080e7          	jalr	-1204(ra) # 800036a8 <initlog>
}
    80002b64:	70a2                	ld	ra,40(sp)
    80002b66:	7402                	ld	s0,32(sp)
    80002b68:	64e2                	ld	s1,24(sp)
    80002b6a:	6942                	ld	s2,16(sp)
    80002b6c:	69a2                	ld	s3,8(sp)
    80002b6e:	6145                	addi	sp,sp,48
    80002b70:	8082                	ret
    panic("invalid file system");
    80002b72:	00006517          	auipc	a0,0x6
    80002b76:	a0650513          	addi	a0,a0,-1530 # 80008578 <syscalls+0x140>
    80002b7a:	00003097          	auipc	ra,0x3
    80002b7e:	2ae080e7          	jalr	686(ra) # 80005e28 <panic>

0000000080002b82 <iinit>:
{
    80002b82:	7179                	addi	sp,sp,-48
    80002b84:	f406                	sd	ra,40(sp)
    80002b86:	f022                	sd	s0,32(sp)
    80002b88:	ec26                	sd	s1,24(sp)
    80002b8a:	e84a                	sd	s2,16(sp)
    80002b8c:	e44e                	sd	s3,8(sp)
    80002b8e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b90:	00006597          	auipc	a1,0x6
    80002b94:	a0058593          	addi	a1,a1,-1536 # 80008590 <syscalls+0x158>
    80002b98:	00235517          	auipc	a0,0x235
    80002b9c:	9f850513          	addi	a0,a0,-1544 # 80237590 <itable>
    80002ba0:	00003097          	auipc	ra,0x3
    80002ba4:	742080e7          	jalr	1858(ra) # 800062e2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ba8:	00235497          	auipc	s1,0x235
    80002bac:	a1048493          	addi	s1,s1,-1520 # 802375b8 <itable+0x28>
    80002bb0:	00236997          	auipc	s3,0x236
    80002bb4:	49898993          	addi	s3,s3,1176 # 80239048 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002bb8:	00006917          	auipc	s2,0x6
    80002bbc:	9e090913          	addi	s2,s2,-1568 # 80008598 <syscalls+0x160>
    80002bc0:	85ca                	mv	a1,s2
    80002bc2:	8526                	mv	a0,s1
    80002bc4:	00001097          	auipc	ra,0x1
    80002bc8:	e46080e7          	jalr	-442(ra) # 80003a0a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bcc:	08848493          	addi	s1,s1,136
    80002bd0:	ff3498e3          	bne	s1,s3,80002bc0 <iinit+0x3e>
}
    80002bd4:	70a2                	ld	ra,40(sp)
    80002bd6:	7402                	ld	s0,32(sp)
    80002bd8:	64e2                	ld	s1,24(sp)
    80002bda:	6942                	ld	s2,16(sp)
    80002bdc:	69a2                	ld	s3,8(sp)
    80002bde:	6145                	addi	sp,sp,48
    80002be0:	8082                	ret

0000000080002be2 <ialloc>:
{
    80002be2:	715d                	addi	sp,sp,-80
    80002be4:	e486                	sd	ra,72(sp)
    80002be6:	e0a2                	sd	s0,64(sp)
    80002be8:	fc26                	sd	s1,56(sp)
    80002bea:	f84a                	sd	s2,48(sp)
    80002bec:	f44e                	sd	s3,40(sp)
    80002bee:	f052                	sd	s4,32(sp)
    80002bf0:	ec56                	sd	s5,24(sp)
    80002bf2:	e85a                	sd	s6,16(sp)
    80002bf4:	e45e                	sd	s7,8(sp)
    80002bf6:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bf8:	00235717          	auipc	a4,0x235
    80002bfc:	98472703          	lw	a4,-1660(a4) # 8023757c <sb+0xc>
    80002c00:	4785                	li	a5,1
    80002c02:	04e7fa63          	bgeu	a5,a4,80002c56 <ialloc+0x74>
    80002c06:	8aaa                	mv	s5,a0
    80002c08:	8bae                	mv	s7,a1
    80002c0a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c0c:	00235a17          	auipc	s4,0x235
    80002c10:	964a0a13          	addi	s4,s4,-1692 # 80237570 <sb>
    80002c14:	00048b1b          	sext.w	s6,s1
    80002c18:	0044d593          	srli	a1,s1,0x4
    80002c1c:	018a2783          	lw	a5,24(s4)
    80002c20:	9dbd                	addw	a1,a1,a5
    80002c22:	8556                	mv	a0,s5
    80002c24:	00000097          	auipc	ra,0x0
    80002c28:	954080e7          	jalr	-1708(ra) # 80002578 <bread>
    80002c2c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c2e:	05850993          	addi	s3,a0,88
    80002c32:	00f4f793          	andi	a5,s1,15
    80002c36:	079a                	slli	a5,a5,0x6
    80002c38:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c3a:	00099783          	lh	a5,0(s3)
    80002c3e:	c785                	beqz	a5,80002c66 <ialloc+0x84>
    brelse(bp);
    80002c40:	00000097          	auipc	ra,0x0
    80002c44:	a68080e7          	jalr	-1432(ra) # 800026a8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c48:	0485                	addi	s1,s1,1
    80002c4a:	00ca2703          	lw	a4,12(s4)
    80002c4e:	0004879b          	sext.w	a5,s1
    80002c52:	fce7e1e3          	bltu	a5,a4,80002c14 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002c56:	00006517          	auipc	a0,0x6
    80002c5a:	94a50513          	addi	a0,a0,-1718 # 800085a0 <syscalls+0x168>
    80002c5e:	00003097          	auipc	ra,0x3
    80002c62:	1ca080e7          	jalr	458(ra) # 80005e28 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c66:	04000613          	li	a2,64
    80002c6a:	4581                	li	a1,0
    80002c6c:	854e                	mv	a0,s3
    80002c6e:	ffffd097          	auipc	ra,0xffffd
    80002c72:	66a080e7          	jalr	1642(ra) # 800002d8 <memset>
      dip->type = type;
    80002c76:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c7a:	854a                	mv	a0,s2
    80002c7c:	00001097          	auipc	ra,0x1
    80002c80:	ca8080e7          	jalr	-856(ra) # 80003924 <log_write>
      brelse(bp);
    80002c84:	854a                	mv	a0,s2
    80002c86:	00000097          	auipc	ra,0x0
    80002c8a:	a22080e7          	jalr	-1502(ra) # 800026a8 <brelse>
      return iget(dev, inum);
    80002c8e:	85da                	mv	a1,s6
    80002c90:	8556                	mv	a0,s5
    80002c92:	00000097          	auipc	ra,0x0
    80002c96:	db4080e7          	jalr	-588(ra) # 80002a46 <iget>
}
    80002c9a:	60a6                	ld	ra,72(sp)
    80002c9c:	6406                	ld	s0,64(sp)
    80002c9e:	74e2                	ld	s1,56(sp)
    80002ca0:	7942                	ld	s2,48(sp)
    80002ca2:	79a2                	ld	s3,40(sp)
    80002ca4:	7a02                	ld	s4,32(sp)
    80002ca6:	6ae2                	ld	s5,24(sp)
    80002ca8:	6b42                	ld	s6,16(sp)
    80002caa:	6ba2                	ld	s7,8(sp)
    80002cac:	6161                	addi	sp,sp,80
    80002cae:	8082                	ret

0000000080002cb0 <iupdate>:
{
    80002cb0:	1101                	addi	sp,sp,-32
    80002cb2:	ec06                	sd	ra,24(sp)
    80002cb4:	e822                	sd	s0,16(sp)
    80002cb6:	e426                	sd	s1,8(sp)
    80002cb8:	e04a                	sd	s2,0(sp)
    80002cba:	1000                	addi	s0,sp,32
    80002cbc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cbe:	415c                	lw	a5,4(a0)
    80002cc0:	0047d79b          	srliw	a5,a5,0x4
    80002cc4:	00235597          	auipc	a1,0x235
    80002cc8:	8c45a583          	lw	a1,-1852(a1) # 80237588 <sb+0x18>
    80002ccc:	9dbd                	addw	a1,a1,a5
    80002cce:	4108                	lw	a0,0(a0)
    80002cd0:	00000097          	auipc	ra,0x0
    80002cd4:	8a8080e7          	jalr	-1880(ra) # 80002578 <bread>
    80002cd8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cda:	05850793          	addi	a5,a0,88
    80002cde:	40c8                	lw	a0,4(s1)
    80002ce0:	893d                	andi	a0,a0,15
    80002ce2:	051a                	slli	a0,a0,0x6
    80002ce4:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002ce6:	04449703          	lh	a4,68(s1)
    80002cea:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002cee:	04649703          	lh	a4,70(s1)
    80002cf2:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002cf6:	04849703          	lh	a4,72(s1)
    80002cfa:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002cfe:	04a49703          	lh	a4,74(s1)
    80002d02:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d06:	44f8                	lw	a4,76(s1)
    80002d08:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d0a:	03400613          	li	a2,52
    80002d0e:	05048593          	addi	a1,s1,80
    80002d12:	0531                	addi	a0,a0,12
    80002d14:	ffffd097          	auipc	ra,0xffffd
    80002d18:	624080e7          	jalr	1572(ra) # 80000338 <memmove>
  log_write(bp);
    80002d1c:	854a                	mv	a0,s2
    80002d1e:	00001097          	auipc	ra,0x1
    80002d22:	c06080e7          	jalr	-1018(ra) # 80003924 <log_write>
  brelse(bp);
    80002d26:	854a                	mv	a0,s2
    80002d28:	00000097          	auipc	ra,0x0
    80002d2c:	980080e7          	jalr	-1664(ra) # 800026a8 <brelse>
}
    80002d30:	60e2                	ld	ra,24(sp)
    80002d32:	6442                	ld	s0,16(sp)
    80002d34:	64a2                	ld	s1,8(sp)
    80002d36:	6902                	ld	s2,0(sp)
    80002d38:	6105                	addi	sp,sp,32
    80002d3a:	8082                	ret

0000000080002d3c <idup>:
{
    80002d3c:	1101                	addi	sp,sp,-32
    80002d3e:	ec06                	sd	ra,24(sp)
    80002d40:	e822                	sd	s0,16(sp)
    80002d42:	e426                	sd	s1,8(sp)
    80002d44:	1000                	addi	s0,sp,32
    80002d46:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d48:	00235517          	auipc	a0,0x235
    80002d4c:	84850513          	addi	a0,a0,-1976 # 80237590 <itable>
    80002d50:	00003097          	auipc	ra,0x3
    80002d54:	622080e7          	jalr	1570(ra) # 80006372 <acquire>
  ip->ref++;
    80002d58:	449c                	lw	a5,8(s1)
    80002d5a:	2785                	addiw	a5,a5,1
    80002d5c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d5e:	00235517          	auipc	a0,0x235
    80002d62:	83250513          	addi	a0,a0,-1998 # 80237590 <itable>
    80002d66:	00003097          	auipc	ra,0x3
    80002d6a:	6c0080e7          	jalr	1728(ra) # 80006426 <release>
}
    80002d6e:	8526                	mv	a0,s1
    80002d70:	60e2                	ld	ra,24(sp)
    80002d72:	6442                	ld	s0,16(sp)
    80002d74:	64a2                	ld	s1,8(sp)
    80002d76:	6105                	addi	sp,sp,32
    80002d78:	8082                	ret

0000000080002d7a <ilock>:
{
    80002d7a:	1101                	addi	sp,sp,-32
    80002d7c:	ec06                	sd	ra,24(sp)
    80002d7e:	e822                	sd	s0,16(sp)
    80002d80:	e426                	sd	s1,8(sp)
    80002d82:	e04a                	sd	s2,0(sp)
    80002d84:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d86:	c115                	beqz	a0,80002daa <ilock+0x30>
    80002d88:	84aa                	mv	s1,a0
    80002d8a:	451c                	lw	a5,8(a0)
    80002d8c:	00f05f63          	blez	a5,80002daa <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d90:	0541                	addi	a0,a0,16
    80002d92:	00001097          	auipc	ra,0x1
    80002d96:	cb2080e7          	jalr	-846(ra) # 80003a44 <acquiresleep>
  if(ip->valid == 0){
    80002d9a:	40bc                	lw	a5,64(s1)
    80002d9c:	cf99                	beqz	a5,80002dba <ilock+0x40>
}
    80002d9e:	60e2                	ld	ra,24(sp)
    80002da0:	6442                	ld	s0,16(sp)
    80002da2:	64a2                	ld	s1,8(sp)
    80002da4:	6902                	ld	s2,0(sp)
    80002da6:	6105                	addi	sp,sp,32
    80002da8:	8082                	ret
    panic("ilock");
    80002daa:	00006517          	auipc	a0,0x6
    80002dae:	80e50513          	addi	a0,a0,-2034 # 800085b8 <syscalls+0x180>
    80002db2:	00003097          	auipc	ra,0x3
    80002db6:	076080e7          	jalr	118(ra) # 80005e28 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dba:	40dc                	lw	a5,4(s1)
    80002dbc:	0047d79b          	srliw	a5,a5,0x4
    80002dc0:	00234597          	auipc	a1,0x234
    80002dc4:	7c85a583          	lw	a1,1992(a1) # 80237588 <sb+0x18>
    80002dc8:	9dbd                	addw	a1,a1,a5
    80002dca:	4088                	lw	a0,0(s1)
    80002dcc:	fffff097          	auipc	ra,0xfffff
    80002dd0:	7ac080e7          	jalr	1964(ra) # 80002578 <bread>
    80002dd4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dd6:	05850593          	addi	a1,a0,88
    80002dda:	40dc                	lw	a5,4(s1)
    80002ddc:	8bbd                	andi	a5,a5,15
    80002dde:	079a                	slli	a5,a5,0x6
    80002de0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002de2:	00059783          	lh	a5,0(a1)
    80002de6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dea:	00259783          	lh	a5,2(a1)
    80002dee:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002df2:	00459783          	lh	a5,4(a1)
    80002df6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dfa:	00659783          	lh	a5,6(a1)
    80002dfe:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e02:	459c                	lw	a5,8(a1)
    80002e04:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e06:	03400613          	li	a2,52
    80002e0a:	05b1                	addi	a1,a1,12
    80002e0c:	05048513          	addi	a0,s1,80
    80002e10:	ffffd097          	auipc	ra,0xffffd
    80002e14:	528080e7          	jalr	1320(ra) # 80000338 <memmove>
    brelse(bp);
    80002e18:	854a                	mv	a0,s2
    80002e1a:	00000097          	auipc	ra,0x0
    80002e1e:	88e080e7          	jalr	-1906(ra) # 800026a8 <brelse>
    ip->valid = 1;
    80002e22:	4785                	li	a5,1
    80002e24:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e26:	04449783          	lh	a5,68(s1)
    80002e2a:	fbb5                	bnez	a5,80002d9e <ilock+0x24>
      panic("ilock: no type");
    80002e2c:	00005517          	auipc	a0,0x5
    80002e30:	79450513          	addi	a0,a0,1940 # 800085c0 <syscalls+0x188>
    80002e34:	00003097          	auipc	ra,0x3
    80002e38:	ff4080e7          	jalr	-12(ra) # 80005e28 <panic>

0000000080002e3c <iunlock>:
{
    80002e3c:	1101                	addi	sp,sp,-32
    80002e3e:	ec06                	sd	ra,24(sp)
    80002e40:	e822                	sd	s0,16(sp)
    80002e42:	e426                	sd	s1,8(sp)
    80002e44:	e04a                	sd	s2,0(sp)
    80002e46:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e48:	c905                	beqz	a0,80002e78 <iunlock+0x3c>
    80002e4a:	84aa                	mv	s1,a0
    80002e4c:	01050913          	addi	s2,a0,16
    80002e50:	854a                	mv	a0,s2
    80002e52:	00001097          	auipc	ra,0x1
    80002e56:	c8c080e7          	jalr	-884(ra) # 80003ade <holdingsleep>
    80002e5a:	cd19                	beqz	a0,80002e78 <iunlock+0x3c>
    80002e5c:	449c                	lw	a5,8(s1)
    80002e5e:	00f05d63          	blez	a5,80002e78 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e62:	854a                	mv	a0,s2
    80002e64:	00001097          	auipc	ra,0x1
    80002e68:	c36080e7          	jalr	-970(ra) # 80003a9a <releasesleep>
}
    80002e6c:	60e2                	ld	ra,24(sp)
    80002e6e:	6442                	ld	s0,16(sp)
    80002e70:	64a2                	ld	s1,8(sp)
    80002e72:	6902                	ld	s2,0(sp)
    80002e74:	6105                	addi	sp,sp,32
    80002e76:	8082                	ret
    panic("iunlock");
    80002e78:	00005517          	auipc	a0,0x5
    80002e7c:	75850513          	addi	a0,a0,1880 # 800085d0 <syscalls+0x198>
    80002e80:	00003097          	auipc	ra,0x3
    80002e84:	fa8080e7          	jalr	-88(ra) # 80005e28 <panic>

0000000080002e88 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e88:	7179                	addi	sp,sp,-48
    80002e8a:	f406                	sd	ra,40(sp)
    80002e8c:	f022                	sd	s0,32(sp)
    80002e8e:	ec26                	sd	s1,24(sp)
    80002e90:	e84a                	sd	s2,16(sp)
    80002e92:	e44e                	sd	s3,8(sp)
    80002e94:	e052                	sd	s4,0(sp)
    80002e96:	1800                	addi	s0,sp,48
    80002e98:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e9a:	05050493          	addi	s1,a0,80
    80002e9e:	08050913          	addi	s2,a0,128
    80002ea2:	a021                	j	80002eaa <itrunc+0x22>
    80002ea4:	0491                	addi	s1,s1,4
    80002ea6:	01248d63          	beq	s1,s2,80002ec0 <itrunc+0x38>
    if(ip->addrs[i]){
    80002eaa:	408c                	lw	a1,0(s1)
    80002eac:	dde5                	beqz	a1,80002ea4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002eae:	0009a503          	lw	a0,0(s3)
    80002eb2:	00000097          	auipc	ra,0x0
    80002eb6:	90c080e7          	jalr	-1780(ra) # 800027be <bfree>
      ip->addrs[i] = 0;
    80002eba:	0004a023          	sw	zero,0(s1)
    80002ebe:	b7dd                	j	80002ea4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ec0:	0809a583          	lw	a1,128(s3)
    80002ec4:	e185                	bnez	a1,80002ee4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ec6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002eca:	854e                	mv	a0,s3
    80002ecc:	00000097          	auipc	ra,0x0
    80002ed0:	de4080e7          	jalr	-540(ra) # 80002cb0 <iupdate>
}
    80002ed4:	70a2                	ld	ra,40(sp)
    80002ed6:	7402                	ld	s0,32(sp)
    80002ed8:	64e2                	ld	s1,24(sp)
    80002eda:	6942                	ld	s2,16(sp)
    80002edc:	69a2                	ld	s3,8(sp)
    80002ede:	6a02                	ld	s4,0(sp)
    80002ee0:	6145                	addi	sp,sp,48
    80002ee2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ee4:	0009a503          	lw	a0,0(s3)
    80002ee8:	fffff097          	auipc	ra,0xfffff
    80002eec:	690080e7          	jalr	1680(ra) # 80002578 <bread>
    80002ef0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ef2:	05850493          	addi	s1,a0,88
    80002ef6:	45850913          	addi	s2,a0,1112
    80002efa:	a811                	j	80002f0e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002efc:	0009a503          	lw	a0,0(s3)
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	8be080e7          	jalr	-1858(ra) # 800027be <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002f08:	0491                	addi	s1,s1,4
    80002f0a:	01248563          	beq	s1,s2,80002f14 <itrunc+0x8c>
      if(a[j])
    80002f0e:	408c                	lw	a1,0(s1)
    80002f10:	dde5                	beqz	a1,80002f08 <itrunc+0x80>
    80002f12:	b7ed                	j	80002efc <itrunc+0x74>
    brelse(bp);
    80002f14:	8552                	mv	a0,s4
    80002f16:	fffff097          	auipc	ra,0xfffff
    80002f1a:	792080e7          	jalr	1938(ra) # 800026a8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f1e:	0809a583          	lw	a1,128(s3)
    80002f22:	0009a503          	lw	a0,0(s3)
    80002f26:	00000097          	auipc	ra,0x0
    80002f2a:	898080e7          	jalr	-1896(ra) # 800027be <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f2e:	0809a023          	sw	zero,128(s3)
    80002f32:	bf51                	j	80002ec6 <itrunc+0x3e>

0000000080002f34 <iput>:
{
    80002f34:	1101                	addi	sp,sp,-32
    80002f36:	ec06                	sd	ra,24(sp)
    80002f38:	e822                	sd	s0,16(sp)
    80002f3a:	e426                	sd	s1,8(sp)
    80002f3c:	e04a                	sd	s2,0(sp)
    80002f3e:	1000                	addi	s0,sp,32
    80002f40:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f42:	00234517          	auipc	a0,0x234
    80002f46:	64e50513          	addi	a0,a0,1614 # 80237590 <itable>
    80002f4a:	00003097          	auipc	ra,0x3
    80002f4e:	428080e7          	jalr	1064(ra) # 80006372 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f52:	4498                	lw	a4,8(s1)
    80002f54:	4785                	li	a5,1
    80002f56:	02f70363          	beq	a4,a5,80002f7c <iput+0x48>
  ip->ref--;
    80002f5a:	449c                	lw	a5,8(s1)
    80002f5c:	37fd                	addiw	a5,a5,-1
    80002f5e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f60:	00234517          	auipc	a0,0x234
    80002f64:	63050513          	addi	a0,a0,1584 # 80237590 <itable>
    80002f68:	00003097          	auipc	ra,0x3
    80002f6c:	4be080e7          	jalr	1214(ra) # 80006426 <release>
}
    80002f70:	60e2                	ld	ra,24(sp)
    80002f72:	6442                	ld	s0,16(sp)
    80002f74:	64a2                	ld	s1,8(sp)
    80002f76:	6902                	ld	s2,0(sp)
    80002f78:	6105                	addi	sp,sp,32
    80002f7a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f7c:	40bc                	lw	a5,64(s1)
    80002f7e:	dff1                	beqz	a5,80002f5a <iput+0x26>
    80002f80:	04a49783          	lh	a5,74(s1)
    80002f84:	fbf9                	bnez	a5,80002f5a <iput+0x26>
    acquiresleep(&ip->lock);
    80002f86:	01048913          	addi	s2,s1,16
    80002f8a:	854a                	mv	a0,s2
    80002f8c:	00001097          	auipc	ra,0x1
    80002f90:	ab8080e7          	jalr	-1352(ra) # 80003a44 <acquiresleep>
    release(&itable.lock);
    80002f94:	00234517          	auipc	a0,0x234
    80002f98:	5fc50513          	addi	a0,a0,1532 # 80237590 <itable>
    80002f9c:	00003097          	auipc	ra,0x3
    80002fa0:	48a080e7          	jalr	1162(ra) # 80006426 <release>
    itrunc(ip);
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	00000097          	auipc	ra,0x0
    80002faa:	ee2080e7          	jalr	-286(ra) # 80002e88 <itrunc>
    ip->type = 0;
    80002fae:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fb2:	8526                	mv	a0,s1
    80002fb4:	00000097          	auipc	ra,0x0
    80002fb8:	cfc080e7          	jalr	-772(ra) # 80002cb0 <iupdate>
    ip->valid = 0;
    80002fbc:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fc0:	854a                	mv	a0,s2
    80002fc2:	00001097          	auipc	ra,0x1
    80002fc6:	ad8080e7          	jalr	-1320(ra) # 80003a9a <releasesleep>
    acquire(&itable.lock);
    80002fca:	00234517          	auipc	a0,0x234
    80002fce:	5c650513          	addi	a0,a0,1478 # 80237590 <itable>
    80002fd2:	00003097          	auipc	ra,0x3
    80002fd6:	3a0080e7          	jalr	928(ra) # 80006372 <acquire>
    80002fda:	b741                	j	80002f5a <iput+0x26>

0000000080002fdc <iunlockput>:
{
    80002fdc:	1101                	addi	sp,sp,-32
    80002fde:	ec06                	sd	ra,24(sp)
    80002fe0:	e822                	sd	s0,16(sp)
    80002fe2:	e426                	sd	s1,8(sp)
    80002fe4:	1000                	addi	s0,sp,32
    80002fe6:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fe8:	00000097          	auipc	ra,0x0
    80002fec:	e54080e7          	jalr	-428(ra) # 80002e3c <iunlock>
  iput(ip);
    80002ff0:	8526                	mv	a0,s1
    80002ff2:	00000097          	auipc	ra,0x0
    80002ff6:	f42080e7          	jalr	-190(ra) # 80002f34 <iput>
}
    80002ffa:	60e2                	ld	ra,24(sp)
    80002ffc:	6442                	ld	s0,16(sp)
    80002ffe:	64a2                	ld	s1,8(sp)
    80003000:	6105                	addi	sp,sp,32
    80003002:	8082                	ret

0000000080003004 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003004:	1141                	addi	sp,sp,-16
    80003006:	e422                	sd	s0,8(sp)
    80003008:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000300a:	411c                	lw	a5,0(a0)
    8000300c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000300e:	415c                	lw	a5,4(a0)
    80003010:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003012:	04451783          	lh	a5,68(a0)
    80003016:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000301a:	04a51783          	lh	a5,74(a0)
    8000301e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003022:	04c56783          	lwu	a5,76(a0)
    80003026:	e99c                	sd	a5,16(a1)
}
    80003028:	6422                	ld	s0,8(sp)
    8000302a:	0141                	addi	sp,sp,16
    8000302c:	8082                	ret

000000008000302e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000302e:	457c                	lw	a5,76(a0)
    80003030:	0ed7e963          	bltu	a5,a3,80003122 <readi+0xf4>
{
    80003034:	7159                	addi	sp,sp,-112
    80003036:	f486                	sd	ra,104(sp)
    80003038:	f0a2                	sd	s0,96(sp)
    8000303a:	eca6                	sd	s1,88(sp)
    8000303c:	e8ca                	sd	s2,80(sp)
    8000303e:	e4ce                	sd	s3,72(sp)
    80003040:	e0d2                	sd	s4,64(sp)
    80003042:	fc56                	sd	s5,56(sp)
    80003044:	f85a                	sd	s6,48(sp)
    80003046:	f45e                	sd	s7,40(sp)
    80003048:	f062                	sd	s8,32(sp)
    8000304a:	ec66                	sd	s9,24(sp)
    8000304c:	e86a                	sd	s10,16(sp)
    8000304e:	e46e                	sd	s11,8(sp)
    80003050:	1880                	addi	s0,sp,112
    80003052:	8baa                	mv	s7,a0
    80003054:	8c2e                	mv	s8,a1
    80003056:	8ab2                	mv	s5,a2
    80003058:	84b6                	mv	s1,a3
    8000305a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000305c:	9f35                	addw	a4,a4,a3
    return 0;
    8000305e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003060:	0ad76063          	bltu	a4,a3,80003100 <readi+0xd2>
  if(off + n > ip->size)
    80003064:	00e7f463          	bgeu	a5,a4,8000306c <readi+0x3e>
    n = ip->size - off;
    80003068:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000306c:	0a0b0963          	beqz	s6,8000311e <readi+0xf0>
    80003070:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003072:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003076:	5cfd                	li	s9,-1
    80003078:	a82d                	j	800030b2 <readi+0x84>
    8000307a:	020a1d93          	slli	s11,s4,0x20
    8000307e:	020ddd93          	srli	s11,s11,0x20
    80003082:	05890613          	addi	a2,s2,88
    80003086:	86ee                	mv	a3,s11
    80003088:	963a                	add	a2,a2,a4
    8000308a:	85d6                	mv	a1,s5
    8000308c:	8562                	mv	a0,s8
    8000308e:	fffff097          	auipc	ra,0xfffff
    80003092:	a2c080e7          	jalr	-1492(ra) # 80001aba <either_copyout>
    80003096:	05950d63          	beq	a0,s9,800030f0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000309a:	854a                	mv	a0,s2
    8000309c:	fffff097          	auipc	ra,0xfffff
    800030a0:	60c080e7          	jalr	1548(ra) # 800026a8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030a4:	013a09bb          	addw	s3,s4,s3
    800030a8:	009a04bb          	addw	s1,s4,s1
    800030ac:	9aee                	add	s5,s5,s11
    800030ae:	0569f763          	bgeu	s3,s6,800030fc <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030b2:	000ba903          	lw	s2,0(s7)
    800030b6:	00a4d59b          	srliw	a1,s1,0xa
    800030ba:	855e                	mv	a0,s7
    800030bc:	00000097          	auipc	ra,0x0
    800030c0:	8b0080e7          	jalr	-1872(ra) # 8000296c <bmap>
    800030c4:	0005059b          	sext.w	a1,a0
    800030c8:	854a                	mv	a0,s2
    800030ca:	fffff097          	auipc	ra,0xfffff
    800030ce:	4ae080e7          	jalr	1198(ra) # 80002578 <bread>
    800030d2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030d4:	3ff4f713          	andi	a4,s1,1023
    800030d8:	40ed07bb          	subw	a5,s10,a4
    800030dc:	413b06bb          	subw	a3,s6,s3
    800030e0:	8a3e                	mv	s4,a5
    800030e2:	2781                	sext.w	a5,a5
    800030e4:	0006861b          	sext.w	a2,a3
    800030e8:	f8f679e3          	bgeu	a2,a5,8000307a <readi+0x4c>
    800030ec:	8a36                	mv	s4,a3
    800030ee:	b771                	j	8000307a <readi+0x4c>
      brelse(bp);
    800030f0:	854a                	mv	a0,s2
    800030f2:	fffff097          	auipc	ra,0xfffff
    800030f6:	5b6080e7          	jalr	1462(ra) # 800026a8 <brelse>
      tot = -1;
    800030fa:	59fd                	li	s3,-1
  }
  return tot;
    800030fc:	0009851b          	sext.w	a0,s3
}
    80003100:	70a6                	ld	ra,104(sp)
    80003102:	7406                	ld	s0,96(sp)
    80003104:	64e6                	ld	s1,88(sp)
    80003106:	6946                	ld	s2,80(sp)
    80003108:	69a6                	ld	s3,72(sp)
    8000310a:	6a06                	ld	s4,64(sp)
    8000310c:	7ae2                	ld	s5,56(sp)
    8000310e:	7b42                	ld	s6,48(sp)
    80003110:	7ba2                	ld	s7,40(sp)
    80003112:	7c02                	ld	s8,32(sp)
    80003114:	6ce2                	ld	s9,24(sp)
    80003116:	6d42                	ld	s10,16(sp)
    80003118:	6da2                	ld	s11,8(sp)
    8000311a:	6165                	addi	sp,sp,112
    8000311c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000311e:	89da                	mv	s3,s6
    80003120:	bff1                	j	800030fc <readi+0xce>
    return 0;
    80003122:	4501                	li	a0,0
}
    80003124:	8082                	ret

0000000080003126 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003126:	457c                	lw	a5,76(a0)
    80003128:	10d7e863          	bltu	a5,a3,80003238 <writei+0x112>
{
    8000312c:	7159                	addi	sp,sp,-112
    8000312e:	f486                	sd	ra,104(sp)
    80003130:	f0a2                	sd	s0,96(sp)
    80003132:	eca6                	sd	s1,88(sp)
    80003134:	e8ca                	sd	s2,80(sp)
    80003136:	e4ce                	sd	s3,72(sp)
    80003138:	e0d2                	sd	s4,64(sp)
    8000313a:	fc56                	sd	s5,56(sp)
    8000313c:	f85a                	sd	s6,48(sp)
    8000313e:	f45e                	sd	s7,40(sp)
    80003140:	f062                	sd	s8,32(sp)
    80003142:	ec66                	sd	s9,24(sp)
    80003144:	e86a                	sd	s10,16(sp)
    80003146:	e46e                	sd	s11,8(sp)
    80003148:	1880                	addi	s0,sp,112
    8000314a:	8b2a                	mv	s6,a0
    8000314c:	8c2e                	mv	s8,a1
    8000314e:	8ab2                	mv	s5,a2
    80003150:	8936                	mv	s2,a3
    80003152:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003154:	00e687bb          	addw	a5,a3,a4
    80003158:	0ed7e263          	bltu	a5,a3,8000323c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000315c:	00043737          	lui	a4,0x43
    80003160:	0ef76063          	bltu	a4,a5,80003240 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003164:	0c0b8863          	beqz	s7,80003234 <writei+0x10e>
    80003168:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000316a:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000316e:	5cfd                	li	s9,-1
    80003170:	a091                	j	800031b4 <writei+0x8e>
    80003172:	02099d93          	slli	s11,s3,0x20
    80003176:	020ddd93          	srli	s11,s11,0x20
    8000317a:	05848513          	addi	a0,s1,88
    8000317e:	86ee                	mv	a3,s11
    80003180:	8656                	mv	a2,s5
    80003182:	85e2                	mv	a1,s8
    80003184:	953a                	add	a0,a0,a4
    80003186:	fffff097          	auipc	ra,0xfffff
    8000318a:	98a080e7          	jalr	-1654(ra) # 80001b10 <either_copyin>
    8000318e:	07950263          	beq	a0,s9,800031f2 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003192:	8526                	mv	a0,s1
    80003194:	00000097          	auipc	ra,0x0
    80003198:	790080e7          	jalr	1936(ra) # 80003924 <log_write>
    brelse(bp);
    8000319c:	8526                	mv	a0,s1
    8000319e:	fffff097          	auipc	ra,0xfffff
    800031a2:	50a080e7          	jalr	1290(ra) # 800026a8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031a6:	01498a3b          	addw	s4,s3,s4
    800031aa:	0129893b          	addw	s2,s3,s2
    800031ae:	9aee                	add	s5,s5,s11
    800031b0:	057a7663          	bgeu	s4,s7,800031fc <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031b4:	000b2483          	lw	s1,0(s6)
    800031b8:	00a9559b          	srliw	a1,s2,0xa
    800031bc:	855a                	mv	a0,s6
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	7ae080e7          	jalr	1966(ra) # 8000296c <bmap>
    800031c6:	0005059b          	sext.w	a1,a0
    800031ca:	8526                	mv	a0,s1
    800031cc:	fffff097          	auipc	ra,0xfffff
    800031d0:	3ac080e7          	jalr	940(ra) # 80002578 <bread>
    800031d4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031d6:	3ff97713          	andi	a4,s2,1023
    800031da:	40ed07bb          	subw	a5,s10,a4
    800031de:	414b86bb          	subw	a3,s7,s4
    800031e2:	89be                	mv	s3,a5
    800031e4:	2781                	sext.w	a5,a5
    800031e6:	0006861b          	sext.w	a2,a3
    800031ea:	f8f674e3          	bgeu	a2,a5,80003172 <writei+0x4c>
    800031ee:	89b6                	mv	s3,a3
    800031f0:	b749                	j	80003172 <writei+0x4c>
      brelse(bp);
    800031f2:	8526                	mv	a0,s1
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	4b4080e7          	jalr	1204(ra) # 800026a8 <brelse>
  }

  if(off > ip->size)
    800031fc:	04cb2783          	lw	a5,76(s6)
    80003200:	0127f463          	bgeu	a5,s2,80003208 <writei+0xe2>
    ip->size = off;
    80003204:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003208:	855a                	mv	a0,s6
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	aa6080e7          	jalr	-1370(ra) # 80002cb0 <iupdate>

  return tot;
    80003212:	000a051b          	sext.w	a0,s4
}
    80003216:	70a6                	ld	ra,104(sp)
    80003218:	7406                	ld	s0,96(sp)
    8000321a:	64e6                	ld	s1,88(sp)
    8000321c:	6946                	ld	s2,80(sp)
    8000321e:	69a6                	ld	s3,72(sp)
    80003220:	6a06                	ld	s4,64(sp)
    80003222:	7ae2                	ld	s5,56(sp)
    80003224:	7b42                	ld	s6,48(sp)
    80003226:	7ba2                	ld	s7,40(sp)
    80003228:	7c02                	ld	s8,32(sp)
    8000322a:	6ce2                	ld	s9,24(sp)
    8000322c:	6d42                	ld	s10,16(sp)
    8000322e:	6da2                	ld	s11,8(sp)
    80003230:	6165                	addi	sp,sp,112
    80003232:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003234:	8a5e                	mv	s4,s7
    80003236:	bfc9                	j	80003208 <writei+0xe2>
    return -1;
    80003238:	557d                	li	a0,-1
}
    8000323a:	8082                	ret
    return -1;
    8000323c:	557d                	li	a0,-1
    8000323e:	bfe1                	j	80003216 <writei+0xf0>
    return -1;
    80003240:	557d                	li	a0,-1
    80003242:	bfd1                	j	80003216 <writei+0xf0>

0000000080003244 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003244:	1141                	addi	sp,sp,-16
    80003246:	e406                	sd	ra,8(sp)
    80003248:	e022                	sd	s0,0(sp)
    8000324a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000324c:	4639                	li	a2,14
    8000324e:	ffffd097          	auipc	ra,0xffffd
    80003252:	162080e7          	jalr	354(ra) # 800003b0 <strncmp>
}
    80003256:	60a2                	ld	ra,8(sp)
    80003258:	6402                	ld	s0,0(sp)
    8000325a:	0141                	addi	sp,sp,16
    8000325c:	8082                	ret

000000008000325e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000325e:	7139                	addi	sp,sp,-64
    80003260:	fc06                	sd	ra,56(sp)
    80003262:	f822                	sd	s0,48(sp)
    80003264:	f426                	sd	s1,40(sp)
    80003266:	f04a                	sd	s2,32(sp)
    80003268:	ec4e                	sd	s3,24(sp)
    8000326a:	e852                	sd	s4,16(sp)
    8000326c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000326e:	04451703          	lh	a4,68(a0)
    80003272:	4785                	li	a5,1
    80003274:	00f71a63          	bne	a4,a5,80003288 <dirlookup+0x2a>
    80003278:	892a                	mv	s2,a0
    8000327a:	89ae                	mv	s3,a1
    8000327c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000327e:	457c                	lw	a5,76(a0)
    80003280:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003282:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003284:	e79d                	bnez	a5,800032b2 <dirlookup+0x54>
    80003286:	a8a5                	j	800032fe <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003288:	00005517          	auipc	a0,0x5
    8000328c:	35050513          	addi	a0,a0,848 # 800085d8 <syscalls+0x1a0>
    80003290:	00003097          	auipc	ra,0x3
    80003294:	b98080e7          	jalr	-1128(ra) # 80005e28 <panic>
      panic("dirlookup read");
    80003298:	00005517          	auipc	a0,0x5
    8000329c:	35850513          	addi	a0,a0,856 # 800085f0 <syscalls+0x1b8>
    800032a0:	00003097          	auipc	ra,0x3
    800032a4:	b88080e7          	jalr	-1144(ra) # 80005e28 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a8:	24c1                	addiw	s1,s1,16
    800032aa:	04c92783          	lw	a5,76(s2)
    800032ae:	04f4f763          	bgeu	s1,a5,800032fc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032b2:	4741                	li	a4,16
    800032b4:	86a6                	mv	a3,s1
    800032b6:	fc040613          	addi	a2,s0,-64
    800032ba:	4581                	li	a1,0
    800032bc:	854a                	mv	a0,s2
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	d70080e7          	jalr	-656(ra) # 8000302e <readi>
    800032c6:	47c1                	li	a5,16
    800032c8:	fcf518e3          	bne	a0,a5,80003298 <dirlookup+0x3a>
    if(de.inum == 0)
    800032cc:	fc045783          	lhu	a5,-64(s0)
    800032d0:	dfe1                	beqz	a5,800032a8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032d2:	fc240593          	addi	a1,s0,-62
    800032d6:	854e                	mv	a0,s3
    800032d8:	00000097          	auipc	ra,0x0
    800032dc:	f6c080e7          	jalr	-148(ra) # 80003244 <namecmp>
    800032e0:	f561                	bnez	a0,800032a8 <dirlookup+0x4a>
      if(poff)
    800032e2:	000a0463          	beqz	s4,800032ea <dirlookup+0x8c>
        *poff = off;
    800032e6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032ea:	fc045583          	lhu	a1,-64(s0)
    800032ee:	00092503          	lw	a0,0(s2)
    800032f2:	fffff097          	auipc	ra,0xfffff
    800032f6:	754080e7          	jalr	1876(ra) # 80002a46 <iget>
    800032fa:	a011                	j	800032fe <dirlookup+0xa0>
  return 0;
    800032fc:	4501                	li	a0,0
}
    800032fe:	70e2                	ld	ra,56(sp)
    80003300:	7442                	ld	s0,48(sp)
    80003302:	74a2                	ld	s1,40(sp)
    80003304:	7902                	ld	s2,32(sp)
    80003306:	69e2                	ld	s3,24(sp)
    80003308:	6a42                	ld	s4,16(sp)
    8000330a:	6121                	addi	sp,sp,64
    8000330c:	8082                	ret

000000008000330e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000330e:	711d                	addi	sp,sp,-96
    80003310:	ec86                	sd	ra,88(sp)
    80003312:	e8a2                	sd	s0,80(sp)
    80003314:	e4a6                	sd	s1,72(sp)
    80003316:	e0ca                	sd	s2,64(sp)
    80003318:	fc4e                	sd	s3,56(sp)
    8000331a:	f852                	sd	s4,48(sp)
    8000331c:	f456                	sd	s5,40(sp)
    8000331e:	f05a                	sd	s6,32(sp)
    80003320:	ec5e                	sd	s7,24(sp)
    80003322:	e862                	sd	s8,16(sp)
    80003324:	e466                	sd	s9,8(sp)
    80003326:	1080                	addi	s0,sp,96
    80003328:	84aa                	mv	s1,a0
    8000332a:	8b2e                	mv	s6,a1
    8000332c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000332e:	00054703          	lbu	a4,0(a0)
    80003332:	02f00793          	li	a5,47
    80003336:	02f70363          	beq	a4,a5,8000335c <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000333a:	ffffe097          	auipc	ra,0xffffe
    8000333e:	d20080e7          	jalr	-736(ra) # 8000105a <myproc>
    80003342:	15053503          	ld	a0,336(a0)
    80003346:	00000097          	auipc	ra,0x0
    8000334a:	9f6080e7          	jalr	-1546(ra) # 80002d3c <idup>
    8000334e:	89aa                	mv	s3,a0
  while(*path == '/')
    80003350:	02f00913          	li	s2,47
  len = path - s;
    80003354:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003356:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003358:	4c05                	li	s8,1
    8000335a:	a865                	j	80003412 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000335c:	4585                	li	a1,1
    8000335e:	4505                	li	a0,1
    80003360:	fffff097          	auipc	ra,0xfffff
    80003364:	6e6080e7          	jalr	1766(ra) # 80002a46 <iget>
    80003368:	89aa                	mv	s3,a0
    8000336a:	b7dd                	j	80003350 <namex+0x42>
      iunlockput(ip);
    8000336c:	854e                	mv	a0,s3
    8000336e:	00000097          	auipc	ra,0x0
    80003372:	c6e080e7          	jalr	-914(ra) # 80002fdc <iunlockput>
      return 0;
    80003376:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003378:	854e                	mv	a0,s3
    8000337a:	60e6                	ld	ra,88(sp)
    8000337c:	6446                	ld	s0,80(sp)
    8000337e:	64a6                	ld	s1,72(sp)
    80003380:	6906                	ld	s2,64(sp)
    80003382:	79e2                	ld	s3,56(sp)
    80003384:	7a42                	ld	s4,48(sp)
    80003386:	7aa2                	ld	s5,40(sp)
    80003388:	7b02                	ld	s6,32(sp)
    8000338a:	6be2                	ld	s7,24(sp)
    8000338c:	6c42                	ld	s8,16(sp)
    8000338e:	6ca2                	ld	s9,8(sp)
    80003390:	6125                	addi	sp,sp,96
    80003392:	8082                	ret
      iunlock(ip);
    80003394:	854e                	mv	a0,s3
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	aa6080e7          	jalr	-1370(ra) # 80002e3c <iunlock>
      return ip;
    8000339e:	bfe9                	j	80003378 <namex+0x6a>
      iunlockput(ip);
    800033a0:	854e                	mv	a0,s3
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	c3a080e7          	jalr	-966(ra) # 80002fdc <iunlockput>
      return 0;
    800033aa:	89d2                	mv	s3,s4
    800033ac:	b7f1                	j	80003378 <namex+0x6a>
  len = path - s;
    800033ae:	40b48633          	sub	a2,s1,a1
    800033b2:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800033b6:	094cd463          	bge	s9,s4,8000343e <namex+0x130>
    memmove(name, s, DIRSIZ);
    800033ba:	4639                	li	a2,14
    800033bc:	8556                	mv	a0,s5
    800033be:	ffffd097          	auipc	ra,0xffffd
    800033c2:	f7a080e7          	jalr	-134(ra) # 80000338 <memmove>
  while(*path == '/')
    800033c6:	0004c783          	lbu	a5,0(s1)
    800033ca:	01279763          	bne	a5,s2,800033d8 <namex+0xca>
    path++;
    800033ce:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033d0:	0004c783          	lbu	a5,0(s1)
    800033d4:	ff278de3          	beq	a5,s2,800033ce <namex+0xc0>
    ilock(ip);
    800033d8:	854e                	mv	a0,s3
    800033da:	00000097          	auipc	ra,0x0
    800033de:	9a0080e7          	jalr	-1632(ra) # 80002d7a <ilock>
    if(ip->type != T_DIR){
    800033e2:	04499783          	lh	a5,68(s3)
    800033e6:	f98793e3          	bne	a5,s8,8000336c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033ea:	000b0563          	beqz	s6,800033f4 <namex+0xe6>
    800033ee:	0004c783          	lbu	a5,0(s1)
    800033f2:	d3cd                	beqz	a5,80003394 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033f4:	865e                	mv	a2,s7
    800033f6:	85d6                	mv	a1,s5
    800033f8:	854e                	mv	a0,s3
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	e64080e7          	jalr	-412(ra) # 8000325e <dirlookup>
    80003402:	8a2a                	mv	s4,a0
    80003404:	dd51                	beqz	a0,800033a0 <namex+0x92>
    iunlockput(ip);
    80003406:	854e                	mv	a0,s3
    80003408:	00000097          	auipc	ra,0x0
    8000340c:	bd4080e7          	jalr	-1068(ra) # 80002fdc <iunlockput>
    ip = next;
    80003410:	89d2                	mv	s3,s4
  while(*path == '/')
    80003412:	0004c783          	lbu	a5,0(s1)
    80003416:	05279763          	bne	a5,s2,80003464 <namex+0x156>
    path++;
    8000341a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000341c:	0004c783          	lbu	a5,0(s1)
    80003420:	ff278de3          	beq	a5,s2,8000341a <namex+0x10c>
  if(*path == 0)
    80003424:	c79d                	beqz	a5,80003452 <namex+0x144>
    path++;
    80003426:	85a6                	mv	a1,s1
  len = path - s;
    80003428:	8a5e                	mv	s4,s7
    8000342a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000342c:	01278963          	beq	a5,s2,8000343e <namex+0x130>
    80003430:	dfbd                	beqz	a5,800033ae <namex+0xa0>
    path++;
    80003432:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003434:	0004c783          	lbu	a5,0(s1)
    80003438:	ff279ce3          	bne	a5,s2,80003430 <namex+0x122>
    8000343c:	bf8d                	j	800033ae <namex+0xa0>
    memmove(name, s, len);
    8000343e:	2601                	sext.w	a2,a2
    80003440:	8556                	mv	a0,s5
    80003442:	ffffd097          	auipc	ra,0xffffd
    80003446:	ef6080e7          	jalr	-266(ra) # 80000338 <memmove>
    name[len] = 0;
    8000344a:	9a56                	add	s4,s4,s5
    8000344c:	000a0023          	sb	zero,0(s4)
    80003450:	bf9d                	j	800033c6 <namex+0xb8>
  if(nameiparent){
    80003452:	f20b03e3          	beqz	s6,80003378 <namex+0x6a>
    iput(ip);
    80003456:	854e                	mv	a0,s3
    80003458:	00000097          	auipc	ra,0x0
    8000345c:	adc080e7          	jalr	-1316(ra) # 80002f34 <iput>
    return 0;
    80003460:	4981                	li	s3,0
    80003462:	bf19                	j	80003378 <namex+0x6a>
  if(*path == 0)
    80003464:	d7fd                	beqz	a5,80003452 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003466:	0004c783          	lbu	a5,0(s1)
    8000346a:	85a6                	mv	a1,s1
    8000346c:	b7d1                	j	80003430 <namex+0x122>

000000008000346e <dirlink>:
{
    8000346e:	7139                	addi	sp,sp,-64
    80003470:	fc06                	sd	ra,56(sp)
    80003472:	f822                	sd	s0,48(sp)
    80003474:	f426                	sd	s1,40(sp)
    80003476:	f04a                	sd	s2,32(sp)
    80003478:	ec4e                	sd	s3,24(sp)
    8000347a:	e852                	sd	s4,16(sp)
    8000347c:	0080                	addi	s0,sp,64
    8000347e:	892a                	mv	s2,a0
    80003480:	8a2e                	mv	s4,a1
    80003482:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003484:	4601                	li	a2,0
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	dd8080e7          	jalr	-552(ra) # 8000325e <dirlookup>
    8000348e:	e93d                	bnez	a0,80003504 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003490:	04c92483          	lw	s1,76(s2)
    80003494:	c49d                	beqz	s1,800034c2 <dirlink+0x54>
    80003496:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003498:	4741                	li	a4,16
    8000349a:	86a6                	mv	a3,s1
    8000349c:	fc040613          	addi	a2,s0,-64
    800034a0:	4581                	li	a1,0
    800034a2:	854a                	mv	a0,s2
    800034a4:	00000097          	auipc	ra,0x0
    800034a8:	b8a080e7          	jalr	-1142(ra) # 8000302e <readi>
    800034ac:	47c1                	li	a5,16
    800034ae:	06f51163          	bne	a0,a5,80003510 <dirlink+0xa2>
    if(de.inum == 0)
    800034b2:	fc045783          	lhu	a5,-64(s0)
    800034b6:	c791                	beqz	a5,800034c2 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034b8:	24c1                	addiw	s1,s1,16
    800034ba:	04c92783          	lw	a5,76(s2)
    800034be:	fcf4ede3          	bltu	s1,a5,80003498 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034c2:	4639                	li	a2,14
    800034c4:	85d2                	mv	a1,s4
    800034c6:	fc240513          	addi	a0,s0,-62
    800034ca:	ffffd097          	auipc	ra,0xffffd
    800034ce:	f22080e7          	jalr	-222(ra) # 800003ec <strncpy>
  de.inum = inum;
    800034d2:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034d6:	4741                	li	a4,16
    800034d8:	86a6                	mv	a3,s1
    800034da:	fc040613          	addi	a2,s0,-64
    800034de:	4581                	li	a1,0
    800034e0:	854a                	mv	a0,s2
    800034e2:	00000097          	auipc	ra,0x0
    800034e6:	c44080e7          	jalr	-956(ra) # 80003126 <writei>
    800034ea:	872a                	mv	a4,a0
    800034ec:	47c1                	li	a5,16
  return 0;
    800034ee:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034f0:	02f71863          	bne	a4,a5,80003520 <dirlink+0xb2>
}
    800034f4:	70e2                	ld	ra,56(sp)
    800034f6:	7442                	ld	s0,48(sp)
    800034f8:	74a2                	ld	s1,40(sp)
    800034fa:	7902                	ld	s2,32(sp)
    800034fc:	69e2                	ld	s3,24(sp)
    800034fe:	6a42                	ld	s4,16(sp)
    80003500:	6121                	addi	sp,sp,64
    80003502:	8082                	ret
    iput(ip);
    80003504:	00000097          	auipc	ra,0x0
    80003508:	a30080e7          	jalr	-1488(ra) # 80002f34 <iput>
    return -1;
    8000350c:	557d                	li	a0,-1
    8000350e:	b7dd                	j	800034f4 <dirlink+0x86>
      panic("dirlink read");
    80003510:	00005517          	auipc	a0,0x5
    80003514:	0f050513          	addi	a0,a0,240 # 80008600 <syscalls+0x1c8>
    80003518:	00003097          	auipc	ra,0x3
    8000351c:	910080e7          	jalr	-1776(ra) # 80005e28 <panic>
    panic("dirlink");
    80003520:	00005517          	auipc	a0,0x5
    80003524:	1f050513          	addi	a0,a0,496 # 80008710 <syscalls+0x2d8>
    80003528:	00003097          	auipc	ra,0x3
    8000352c:	900080e7          	jalr	-1792(ra) # 80005e28 <panic>

0000000080003530 <namei>:

struct inode*
namei(char *path)
{
    80003530:	1101                	addi	sp,sp,-32
    80003532:	ec06                	sd	ra,24(sp)
    80003534:	e822                	sd	s0,16(sp)
    80003536:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003538:	fe040613          	addi	a2,s0,-32
    8000353c:	4581                	li	a1,0
    8000353e:	00000097          	auipc	ra,0x0
    80003542:	dd0080e7          	jalr	-560(ra) # 8000330e <namex>
}
    80003546:	60e2                	ld	ra,24(sp)
    80003548:	6442                	ld	s0,16(sp)
    8000354a:	6105                	addi	sp,sp,32
    8000354c:	8082                	ret

000000008000354e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000354e:	1141                	addi	sp,sp,-16
    80003550:	e406                	sd	ra,8(sp)
    80003552:	e022                	sd	s0,0(sp)
    80003554:	0800                	addi	s0,sp,16
    80003556:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003558:	4585                	li	a1,1
    8000355a:	00000097          	auipc	ra,0x0
    8000355e:	db4080e7          	jalr	-588(ra) # 8000330e <namex>
}
    80003562:	60a2                	ld	ra,8(sp)
    80003564:	6402                	ld	s0,0(sp)
    80003566:	0141                	addi	sp,sp,16
    80003568:	8082                	ret

000000008000356a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000356a:	1101                	addi	sp,sp,-32
    8000356c:	ec06                	sd	ra,24(sp)
    8000356e:	e822                	sd	s0,16(sp)
    80003570:	e426                	sd	s1,8(sp)
    80003572:	e04a                	sd	s2,0(sp)
    80003574:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003576:	00236917          	auipc	s2,0x236
    8000357a:	ac290913          	addi	s2,s2,-1342 # 80239038 <log>
    8000357e:	01892583          	lw	a1,24(s2)
    80003582:	02892503          	lw	a0,40(s2)
    80003586:	fffff097          	auipc	ra,0xfffff
    8000358a:	ff2080e7          	jalr	-14(ra) # 80002578 <bread>
    8000358e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003590:	02c92683          	lw	a3,44(s2)
    80003594:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003596:	02d05763          	blez	a3,800035c4 <write_head+0x5a>
    8000359a:	00236797          	auipc	a5,0x236
    8000359e:	ace78793          	addi	a5,a5,-1330 # 80239068 <log+0x30>
    800035a2:	05c50713          	addi	a4,a0,92
    800035a6:	36fd                	addiw	a3,a3,-1
    800035a8:	1682                	slli	a3,a3,0x20
    800035aa:	9281                	srli	a3,a3,0x20
    800035ac:	068a                	slli	a3,a3,0x2
    800035ae:	00236617          	auipc	a2,0x236
    800035b2:	abe60613          	addi	a2,a2,-1346 # 8023906c <log+0x34>
    800035b6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800035b8:	4390                	lw	a2,0(a5)
    800035ba:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035bc:	0791                	addi	a5,a5,4
    800035be:	0711                	addi	a4,a4,4
    800035c0:	fed79ce3          	bne	a5,a3,800035b8 <write_head+0x4e>
  }
  bwrite(buf);
    800035c4:	8526                	mv	a0,s1
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	0a4080e7          	jalr	164(ra) # 8000266a <bwrite>
  brelse(buf);
    800035ce:	8526                	mv	a0,s1
    800035d0:	fffff097          	auipc	ra,0xfffff
    800035d4:	0d8080e7          	jalr	216(ra) # 800026a8 <brelse>
}
    800035d8:	60e2                	ld	ra,24(sp)
    800035da:	6442                	ld	s0,16(sp)
    800035dc:	64a2                	ld	s1,8(sp)
    800035de:	6902                	ld	s2,0(sp)
    800035e0:	6105                	addi	sp,sp,32
    800035e2:	8082                	ret

00000000800035e4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035e4:	00236797          	auipc	a5,0x236
    800035e8:	a807a783          	lw	a5,-1408(a5) # 80239064 <log+0x2c>
    800035ec:	0af05d63          	blez	a5,800036a6 <install_trans+0xc2>
{
    800035f0:	7139                	addi	sp,sp,-64
    800035f2:	fc06                	sd	ra,56(sp)
    800035f4:	f822                	sd	s0,48(sp)
    800035f6:	f426                	sd	s1,40(sp)
    800035f8:	f04a                	sd	s2,32(sp)
    800035fa:	ec4e                	sd	s3,24(sp)
    800035fc:	e852                	sd	s4,16(sp)
    800035fe:	e456                	sd	s5,8(sp)
    80003600:	e05a                	sd	s6,0(sp)
    80003602:	0080                	addi	s0,sp,64
    80003604:	8b2a                	mv	s6,a0
    80003606:	00236a97          	auipc	s5,0x236
    8000360a:	a62a8a93          	addi	s5,s5,-1438 # 80239068 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000360e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003610:	00236997          	auipc	s3,0x236
    80003614:	a2898993          	addi	s3,s3,-1496 # 80239038 <log>
    80003618:	a035                	j	80003644 <install_trans+0x60>
      bunpin(dbuf);
    8000361a:	8526                	mv	a0,s1
    8000361c:	fffff097          	auipc	ra,0xfffff
    80003620:	166080e7          	jalr	358(ra) # 80002782 <bunpin>
    brelse(lbuf);
    80003624:	854a                	mv	a0,s2
    80003626:	fffff097          	auipc	ra,0xfffff
    8000362a:	082080e7          	jalr	130(ra) # 800026a8 <brelse>
    brelse(dbuf);
    8000362e:	8526                	mv	a0,s1
    80003630:	fffff097          	auipc	ra,0xfffff
    80003634:	078080e7          	jalr	120(ra) # 800026a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003638:	2a05                	addiw	s4,s4,1
    8000363a:	0a91                	addi	s5,s5,4
    8000363c:	02c9a783          	lw	a5,44(s3)
    80003640:	04fa5963          	bge	s4,a5,80003692 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003644:	0189a583          	lw	a1,24(s3)
    80003648:	014585bb          	addw	a1,a1,s4
    8000364c:	2585                	addiw	a1,a1,1
    8000364e:	0289a503          	lw	a0,40(s3)
    80003652:	fffff097          	auipc	ra,0xfffff
    80003656:	f26080e7          	jalr	-218(ra) # 80002578 <bread>
    8000365a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000365c:	000aa583          	lw	a1,0(s5)
    80003660:	0289a503          	lw	a0,40(s3)
    80003664:	fffff097          	auipc	ra,0xfffff
    80003668:	f14080e7          	jalr	-236(ra) # 80002578 <bread>
    8000366c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000366e:	40000613          	li	a2,1024
    80003672:	05890593          	addi	a1,s2,88
    80003676:	05850513          	addi	a0,a0,88
    8000367a:	ffffd097          	auipc	ra,0xffffd
    8000367e:	cbe080e7          	jalr	-834(ra) # 80000338 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003682:	8526                	mv	a0,s1
    80003684:	fffff097          	auipc	ra,0xfffff
    80003688:	fe6080e7          	jalr	-26(ra) # 8000266a <bwrite>
    if(recovering == 0)
    8000368c:	f80b1ce3          	bnez	s6,80003624 <install_trans+0x40>
    80003690:	b769                	j	8000361a <install_trans+0x36>
}
    80003692:	70e2                	ld	ra,56(sp)
    80003694:	7442                	ld	s0,48(sp)
    80003696:	74a2                	ld	s1,40(sp)
    80003698:	7902                	ld	s2,32(sp)
    8000369a:	69e2                	ld	s3,24(sp)
    8000369c:	6a42                	ld	s4,16(sp)
    8000369e:	6aa2                	ld	s5,8(sp)
    800036a0:	6b02                	ld	s6,0(sp)
    800036a2:	6121                	addi	sp,sp,64
    800036a4:	8082                	ret
    800036a6:	8082                	ret

00000000800036a8 <initlog>:
{
    800036a8:	7179                	addi	sp,sp,-48
    800036aa:	f406                	sd	ra,40(sp)
    800036ac:	f022                	sd	s0,32(sp)
    800036ae:	ec26                	sd	s1,24(sp)
    800036b0:	e84a                	sd	s2,16(sp)
    800036b2:	e44e                	sd	s3,8(sp)
    800036b4:	1800                	addi	s0,sp,48
    800036b6:	892a                	mv	s2,a0
    800036b8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036ba:	00236497          	auipc	s1,0x236
    800036be:	97e48493          	addi	s1,s1,-1666 # 80239038 <log>
    800036c2:	00005597          	auipc	a1,0x5
    800036c6:	f4e58593          	addi	a1,a1,-178 # 80008610 <syscalls+0x1d8>
    800036ca:	8526                	mv	a0,s1
    800036cc:	00003097          	auipc	ra,0x3
    800036d0:	c16080e7          	jalr	-1002(ra) # 800062e2 <initlock>
  log.start = sb->logstart;
    800036d4:	0149a583          	lw	a1,20(s3)
    800036d8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036da:	0109a783          	lw	a5,16(s3)
    800036de:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036e0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036e4:	854a                	mv	a0,s2
    800036e6:	fffff097          	auipc	ra,0xfffff
    800036ea:	e92080e7          	jalr	-366(ra) # 80002578 <bread>
  log.lh.n = lh->n;
    800036ee:	4d3c                	lw	a5,88(a0)
    800036f0:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036f2:	02f05563          	blez	a5,8000371c <initlog+0x74>
    800036f6:	05c50713          	addi	a4,a0,92
    800036fa:	00236697          	auipc	a3,0x236
    800036fe:	96e68693          	addi	a3,a3,-1682 # 80239068 <log+0x30>
    80003702:	37fd                	addiw	a5,a5,-1
    80003704:	1782                	slli	a5,a5,0x20
    80003706:	9381                	srli	a5,a5,0x20
    80003708:	078a                	slli	a5,a5,0x2
    8000370a:	06050613          	addi	a2,a0,96
    8000370e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003710:	4310                	lw	a2,0(a4)
    80003712:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003714:	0711                	addi	a4,a4,4
    80003716:	0691                	addi	a3,a3,4
    80003718:	fef71ce3          	bne	a4,a5,80003710 <initlog+0x68>
  brelse(buf);
    8000371c:	fffff097          	auipc	ra,0xfffff
    80003720:	f8c080e7          	jalr	-116(ra) # 800026a8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003724:	4505                	li	a0,1
    80003726:	00000097          	auipc	ra,0x0
    8000372a:	ebe080e7          	jalr	-322(ra) # 800035e4 <install_trans>
  log.lh.n = 0;
    8000372e:	00236797          	auipc	a5,0x236
    80003732:	9207ab23          	sw	zero,-1738(a5) # 80239064 <log+0x2c>
  write_head(); // clear the log
    80003736:	00000097          	auipc	ra,0x0
    8000373a:	e34080e7          	jalr	-460(ra) # 8000356a <write_head>
}
    8000373e:	70a2                	ld	ra,40(sp)
    80003740:	7402                	ld	s0,32(sp)
    80003742:	64e2                	ld	s1,24(sp)
    80003744:	6942                	ld	s2,16(sp)
    80003746:	69a2                	ld	s3,8(sp)
    80003748:	6145                	addi	sp,sp,48
    8000374a:	8082                	ret

000000008000374c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000374c:	1101                	addi	sp,sp,-32
    8000374e:	ec06                	sd	ra,24(sp)
    80003750:	e822                	sd	s0,16(sp)
    80003752:	e426                	sd	s1,8(sp)
    80003754:	e04a                	sd	s2,0(sp)
    80003756:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003758:	00236517          	auipc	a0,0x236
    8000375c:	8e050513          	addi	a0,a0,-1824 # 80239038 <log>
    80003760:	00003097          	auipc	ra,0x3
    80003764:	c12080e7          	jalr	-1006(ra) # 80006372 <acquire>
  while(1){
    if(log.committing){
    80003768:	00236497          	auipc	s1,0x236
    8000376c:	8d048493          	addi	s1,s1,-1840 # 80239038 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003770:	4979                	li	s2,30
    80003772:	a039                	j	80003780 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003774:	85a6                	mv	a1,s1
    80003776:	8526                	mv	a0,s1
    80003778:	ffffe097          	auipc	ra,0xffffe
    8000377c:	f9e080e7          	jalr	-98(ra) # 80001716 <sleep>
    if(log.committing){
    80003780:	50dc                	lw	a5,36(s1)
    80003782:	fbed                	bnez	a5,80003774 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003784:	509c                	lw	a5,32(s1)
    80003786:	0017871b          	addiw	a4,a5,1
    8000378a:	0007069b          	sext.w	a3,a4
    8000378e:	0027179b          	slliw	a5,a4,0x2
    80003792:	9fb9                	addw	a5,a5,a4
    80003794:	0017979b          	slliw	a5,a5,0x1
    80003798:	54d8                	lw	a4,44(s1)
    8000379a:	9fb9                	addw	a5,a5,a4
    8000379c:	00f95963          	bge	s2,a5,800037ae <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037a0:	85a6                	mv	a1,s1
    800037a2:	8526                	mv	a0,s1
    800037a4:	ffffe097          	auipc	ra,0xffffe
    800037a8:	f72080e7          	jalr	-142(ra) # 80001716 <sleep>
    800037ac:	bfd1                	j	80003780 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037ae:	00236517          	auipc	a0,0x236
    800037b2:	88a50513          	addi	a0,a0,-1910 # 80239038 <log>
    800037b6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800037b8:	00003097          	auipc	ra,0x3
    800037bc:	c6e080e7          	jalr	-914(ra) # 80006426 <release>
      break;
    }
  }
}
    800037c0:	60e2                	ld	ra,24(sp)
    800037c2:	6442                	ld	s0,16(sp)
    800037c4:	64a2                	ld	s1,8(sp)
    800037c6:	6902                	ld	s2,0(sp)
    800037c8:	6105                	addi	sp,sp,32
    800037ca:	8082                	ret

00000000800037cc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037cc:	7139                	addi	sp,sp,-64
    800037ce:	fc06                	sd	ra,56(sp)
    800037d0:	f822                	sd	s0,48(sp)
    800037d2:	f426                	sd	s1,40(sp)
    800037d4:	f04a                	sd	s2,32(sp)
    800037d6:	ec4e                	sd	s3,24(sp)
    800037d8:	e852                	sd	s4,16(sp)
    800037da:	e456                	sd	s5,8(sp)
    800037dc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037de:	00236497          	auipc	s1,0x236
    800037e2:	85a48493          	addi	s1,s1,-1958 # 80239038 <log>
    800037e6:	8526                	mv	a0,s1
    800037e8:	00003097          	auipc	ra,0x3
    800037ec:	b8a080e7          	jalr	-1142(ra) # 80006372 <acquire>
  log.outstanding -= 1;
    800037f0:	509c                	lw	a5,32(s1)
    800037f2:	37fd                	addiw	a5,a5,-1
    800037f4:	0007891b          	sext.w	s2,a5
    800037f8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037fa:	50dc                	lw	a5,36(s1)
    800037fc:	efb9                	bnez	a5,8000385a <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037fe:	06091663          	bnez	s2,8000386a <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003802:	00236497          	auipc	s1,0x236
    80003806:	83648493          	addi	s1,s1,-1994 # 80239038 <log>
    8000380a:	4785                	li	a5,1
    8000380c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000380e:	8526                	mv	a0,s1
    80003810:	00003097          	auipc	ra,0x3
    80003814:	c16080e7          	jalr	-1002(ra) # 80006426 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003818:	54dc                	lw	a5,44(s1)
    8000381a:	06f04763          	bgtz	a5,80003888 <end_op+0xbc>
    acquire(&log.lock);
    8000381e:	00236497          	auipc	s1,0x236
    80003822:	81a48493          	addi	s1,s1,-2022 # 80239038 <log>
    80003826:	8526                	mv	a0,s1
    80003828:	00003097          	auipc	ra,0x3
    8000382c:	b4a080e7          	jalr	-1206(ra) # 80006372 <acquire>
    log.committing = 0;
    80003830:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003834:	8526                	mv	a0,s1
    80003836:	ffffe097          	auipc	ra,0xffffe
    8000383a:	06c080e7          	jalr	108(ra) # 800018a2 <wakeup>
    release(&log.lock);
    8000383e:	8526                	mv	a0,s1
    80003840:	00003097          	auipc	ra,0x3
    80003844:	be6080e7          	jalr	-1050(ra) # 80006426 <release>
}
    80003848:	70e2                	ld	ra,56(sp)
    8000384a:	7442                	ld	s0,48(sp)
    8000384c:	74a2                	ld	s1,40(sp)
    8000384e:	7902                	ld	s2,32(sp)
    80003850:	69e2                	ld	s3,24(sp)
    80003852:	6a42                	ld	s4,16(sp)
    80003854:	6aa2                	ld	s5,8(sp)
    80003856:	6121                	addi	sp,sp,64
    80003858:	8082                	ret
    panic("log.committing");
    8000385a:	00005517          	auipc	a0,0x5
    8000385e:	dbe50513          	addi	a0,a0,-578 # 80008618 <syscalls+0x1e0>
    80003862:	00002097          	auipc	ra,0x2
    80003866:	5c6080e7          	jalr	1478(ra) # 80005e28 <panic>
    wakeup(&log);
    8000386a:	00235497          	auipc	s1,0x235
    8000386e:	7ce48493          	addi	s1,s1,1998 # 80239038 <log>
    80003872:	8526                	mv	a0,s1
    80003874:	ffffe097          	auipc	ra,0xffffe
    80003878:	02e080e7          	jalr	46(ra) # 800018a2 <wakeup>
  release(&log.lock);
    8000387c:	8526                	mv	a0,s1
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	ba8080e7          	jalr	-1112(ra) # 80006426 <release>
  if(do_commit){
    80003886:	b7c9                	j	80003848 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003888:	00235a97          	auipc	s5,0x235
    8000388c:	7e0a8a93          	addi	s5,s5,2016 # 80239068 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003890:	00235a17          	auipc	s4,0x235
    80003894:	7a8a0a13          	addi	s4,s4,1960 # 80239038 <log>
    80003898:	018a2583          	lw	a1,24(s4)
    8000389c:	012585bb          	addw	a1,a1,s2
    800038a0:	2585                	addiw	a1,a1,1
    800038a2:	028a2503          	lw	a0,40(s4)
    800038a6:	fffff097          	auipc	ra,0xfffff
    800038aa:	cd2080e7          	jalr	-814(ra) # 80002578 <bread>
    800038ae:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038b0:	000aa583          	lw	a1,0(s5)
    800038b4:	028a2503          	lw	a0,40(s4)
    800038b8:	fffff097          	auipc	ra,0xfffff
    800038bc:	cc0080e7          	jalr	-832(ra) # 80002578 <bread>
    800038c0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038c2:	40000613          	li	a2,1024
    800038c6:	05850593          	addi	a1,a0,88
    800038ca:	05848513          	addi	a0,s1,88
    800038ce:	ffffd097          	auipc	ra,0xffffd
    800038d2:	a6a080e7          	jalr	-1430(ra) # 80000338 <memmove>
    bwrite(to);  // write the log
    800038d6:	8526                	mv	a0,s1
    800038d8:	fffff097          	auipc	ra,0xfffff
    800038dc:	d92080e7          	jalr	-622(ra) # 8000266a <bwrite>
    brelse(from);
    800038e0:	854e                	mv	a0,s3
    800038e2:	fffff097          	auipc	ra,0xfffff
    800038e6:	dc6080e7          	jalr	-570(ra) # 800026a8 <brelse>
    brelse(to);
    800038ea:	8526                	mv	a0,s1
    800038ec:	fffff097          	auipc	ra,0xfffff
    800038f0:	dbc080e7          	jalr	-580(ra) # 800026a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038f4:	2905                	addiw	s2,s2,1
    800038f6:	0a91                	addi	s5,s5,4
    800038f8:	02ca2783          	lw	a5,44(s4)
    800038fc:	f8f94ee3          	blt	s2,a5,80003898 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003900:	00000097          	auipc	ra,0x0
    80003904:	c6a080e7          	jalr	-918(ra) # 8000356a <write_head>
    install_trans(0); // Now install writes to home locations
    80003908:	4501                	li	a0,0
    8000390a:	00000097          	auipc	ra,0x0
    8000390e:	cda080e7          	jalr	-806(ra) # 800035e4 <install_trans>
    log.lh.n = 0;
    80003912:	00235797          	auipc	a5,0x235
    80003916:	7407a923          	sw	zero,1874(a5) # 80239064 <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000391a:	00000097          	auipc	ra,0x0
    8000391e:	c50080e7          	jalr	-944(ra) # 8000356a <write_head>
    80003922:	bdf5                	j	8000381e <end_op+0x52>

0000000080003924 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003924:	1101                	addi	sp,sp,-32
    80003926:	ec06                	sd	ra,24(sp)
    80003928:	e822                	sd	s0,16(sp)
    8000392a:	e426                	sd	s1,8(sp)
    8000392c:	e04a                	sd	s2,0(sp)
    8000392e:	1000                	addi	s0,sp,32
    80003930:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003932:	00235917          	auipc	s2,0x235
    80003936:	70690913          	addi	s2,s2,1798 # 80239038 <log>
    8000393a:	854a                	mv	a0,s2
    8000393c:	00003097          	auipc	ra,0x3
    80003940:	a36080e7          	jalr	-1482(ra) # 80006372 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003944:	02c92603          	lw	a2,44(s2)
    80003948:	47f5                	li	a5,29
    8000394a:	06c7c563          	blt	a5,a2,800039b4 <log_write+0x90>
    8000394e:	00235797          	auipc	a5,0x235
    80003952:	7067a783          	lw	a5,1798(a5) # 80239054 <log+0x1c>
    80003956:	37fd                	addiw	a5,a5,-1
    80003958:	04f65e63          	bge	a2,a5,800039b4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000395c:	00235797          	auipc	a5,0x235
    80003960:	6fc7a783          	lw	a5,1788(a5) # 80239058 <log+0x20>
    80003964:	06f05063          	blez	a5,800039c4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003968:	4781                	li	a5,0
    8000396a:	06c05563          	blez	a2,800039d4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000396e:	44cc                	lw	a1,12(s1)
    80003970:	00235717          	auipc	a4,0x235
    80003974:	6f870713          	addi	a4,a4,1784 # 80239068 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003978:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000397a:	4314                	lw	a3,0(a4)
    8000397c:	04b68c63          	beq	a3,a1,800039d4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003980:	2785                	addiw	a5,a5,1
    80003982:	0711                	addi	a4,a4,4
    80003984:	fef61be3          	bne	a2,a5,8000397a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003988:	0621                	addi	a2,a2,8
    8000398a:	060a                	slli	a2,a2,0x2
    8000398c:	00235797          	auipc	a5,0x235
    80003990:	6ac78793          	addi	a5,a5,1708 # 80239038 <log>
    80003994:	963e                	add	a2,a2,a5
    80003996:	44dc                	lw	a5,12(s1)
    80003998:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000399a:	8526                	mv	a0,s1
    8000399c:	fffff097          	auipc	ra,0xfffff
    800039a0:	daa080e7          	jalr	-598(ra) # 80002746 <bpin>
    log.lh.n++;
    800039a4:	00235717          	auipc	a4,0x235
    800039a8:	69470713          	addi	a4,a4,1684 # 80239038 <log>
    800039ac:	575c                	lw	a5,44(a4)
    800039ae:	2785                	addiw	a5,a5,1
    800039b0:	d75c                	sw	a5,44(a4)
    800039b2:	a835                	j	800039ee <log_write+0xca>
    panic("too big a transaction");
    800039b4:	00005517          	auipc	a0,0x5
    800039b8:	c7450513          	addi	a0,a0,-908 # 80008628 <syscalls+0x1f0>
    800039bc:	00002097          	auipc	ra,0x2
    800039c0:	46c080e7          	jalr	1132(ra) # 80005e28 <panic>
    panic("log_write outside of trans");
    800039c4:	00005517          	auipc	a0,0x5
    800039c8:	c7c50513          	addi	a0,a0,-900 # 80008640 <syscalls+0x208>
    800039cc:	00002097          	auipc	ra,0x2
    800039d0:	45c080e7          	jalr	1116(ra) # 80005e28 <panic>
  log.lh.block[i] = b->blockno;
    800039d4:	00878713          	addi	a4,a5,8
    800039d8:	00271693          	slli	a3,a4,0x2
    800039dc:	00235717          	auipc	a4,0x235
    800039e0:	65c70713          	addi	a4,a4,1628 # 80239038 <log>
    800039e4:	9736                	add	a4,a4,a3
    800039e6:	44d4                	lw	a3,12(s1)
    800039e8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039ea:	faf608e3          	beq	a2,a5,8000399a <log_write+0x76>
  }
  release(&log.lock);
    800039ee:	00235517          	auipc	a0,0x235
    800039f2:	64a50513          	addi	a0,a0,1610 # 80239038 <log>
    800039f6:	00003097          	auipc	ra,0x3
    800039fa:	a30080e7          	jalr	-1488(ra) # 80006426 <release>
}
    800039fe:	60e2                	ld	ra,24(sp)
    80003a00:	6442                	ld	s0,16(sp)
    80003a02:	64a2                	ld	s1,8(sp)
    80003a04:	6902                	ld	s2,0(sp)
    80003a06:	6105                	addi	sp,sp,32
    80003a08:	8082                	ret

0000000080003a0a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a0a:	1101                	addi	sp,sp,-32
    80003a0c:	ec06                	sd	ra,24(sp)
    80003a0e:	e822                	sd	s0,16(sp)
    80003a10:	e426                	sd	s1,8(sp)
    80003a12:	e04a                	sd	s2,0(sp)
    80003a14:	1000                	addi	s0,sp,32
    80003a16:	84aa                	mv	s1,a0
    80003a18:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a1a:	00005597          	auipc	a1,0x5
    80003a1e:	c4658593          	addi	a1,a1,-954 # 80008660 <syscalls+0x228>
    80003a22:	0521                	addi	a0,a0,8
    80003a24:	00003097          	auipc	ra,0x3
    80003a28:	8be080e7          	jalr	-1858(ra) # 800062e2 <initlock>
  lk->name = name;
    80003a2c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a30:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a34:	0204a423          	sw	zero,40(s1)
}
    80003a38:	60e2                	ld	ra,24(sp)
    80003a3a:	6442                	ld	s0,16(sp)
    80003a3c:	64a2                	ld	s1,8(sp)
    80003a3e:	6902                	ld	s2,0(sp)
    80003a40:	6105                	addi	sp,sp,32
    80003a42:	8082                	ret

0000000080003a44 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a44:	1101                	addi	sp,sp,-32
    80003a46:	ec06                	sd	ra,24(sp)
    80003a48:	e822                	sd	s0,16(sp)
    80003a4a:	e426                	sd	s1,8(sp)
    80003a4c:	e04a                	sd	s2,0(sp)
    80003a4e:	1000                	addi	s0,sp,32
    80003a50:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a52:	00850913          	addi	s2,a0,8
    80003a56:	854a                	mv	a0,s2
    80003a58:	00003097          	auipc	ra,0x3
    80003a5c:	91a080e7          	jalr	-1766(ra) # 80006372 <acquire>
  while (lk->locked) {
    80003a60:	409c                	lw	a5,0(s1)
    80003a62:	cb89                	beqz	a5,80003a74 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a64:	85ca                	mv	a1,s2
    80003a66:	8526                	mv	a0,s1
    80003a68:	ffffe097          	auipc	ra,0xffffe
    80003a6c:	cae080e7          	jalr	-850(ra) # 80001716 <sleep>
  while (lk->locked) {
    80003a70:	409c                	lw	a5,0(s1)
    80003a72:	fbed                	bnez	a5,80003a64 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a74:	4785                	li	a5,1
    80003a76:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a78:	ffffd097          	auipc	ra,0xffffd
    80003a7c:	5e2080e7          	jalr	1506(ra) # 8000105a <myproc>
    80003a80:	591c                	lw	a5,48(a0)
    80003a82:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a84:	854a                	mv	a0,s2
    80003a86:	00003097          	auipc	ra,0x3
    80003a8a:	9a0080e7          	jalr	-1632(ra) # 80006426 <release>
}
    80003a8e:	60e2                	ld	ra,24(sp)
    80003a90:	6442                	ld	s0,16(sp)
    80003a92:	64a2                	ld	s1,8(sp)
    80003a94:	6902                	ld	s2,0(sp)
    80003a96:	6105                	addi	sp,sp,32
    80003a98:	8082                	ret

0000000080003a9a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a9a:	1101                	addi	sp,sp,-32
    80003a9c:	ec06                	sd	ra,24(sp)
    80003a9e:	e822                	sd	s0,16(sp)
    80003aa0:	e426                	sd	s1,8(sp)
    80003aa2:	e04a                	sd	s2,0(sp)
    80003aa4:	1000                	addi	s0,sp,32
    80003aa6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003aa8:	00850913          	addi	s2,a0,8
    80003aac:	854a                	mv	a0,s2
    80003aae:	00003097          	auipc	ra,0x3
    80003ab2:	8c4080e7          	jalr	-1852(ra) # 80006372 <acquire>
  lk->locked = 0;
    80003ab6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aba:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003abe:	8526                	mv	a0,s1
    80003ac0:	ffffe097          	auipc	ra,0xffffe
    80003ac4:	de2080e7          	jalr	-542(ra) # 800018a2 <wakeup>
  release(&lk->lk);
    80003ac8:	854a                	mv	a0,s2
    80003aca:	00003097          	auipc	ra,0x3
    80003ace:	95c080e7          	jalr	-1700(ra) # 80006426 <release>
}
    80003ad2:	60e2                	ld	ra,24(sp)
    80003ad4:	6442                	ld	s0,16(sp)
    80003ad6:	64a2                	ld	s1,8(sp)
    80003ad8:	6902                	ld	s2,0(sp)
    80003ada:	6105                	addi	sp,sp,32
    80003adc:	8082                	ret

0000000080003ade <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ade:	7179                	addi	sp,sp,-48
    80003ae0:	f406                	sd	ra,40(sp)
    80003ae2:	f022                	sd	s0,32(sp)
    80003ae4:	ec26                	sd	s1,24(sp)
    80003ae6:	e84a                	sd	s2,16(sp)
    80003ae8:	e44e                	sd	s3,8(sp)
    80003aea:	1800                	addi	s0,sp,48
    80003aec:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003aee:	00850913          	addi	s2,a0,8
    80003af2:	854a                	mv	a0,s2
    80003af4:	00003097          	auipc	ra,0x3
    80003af8:	87e080e7          	jalr	-1922(ra) # 80006372 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003afc:	409c                	lw	a5,0(s1)
    80003afe:	ef99                	bnez	a5,80003b1c <holdingsleep+0x3e>
    80003b00:	4481                	li	s1,0
  release(&lk->lk);
    80003b02:	854a                	mv	a0,s2
    80003b04:	00003097          	auipc	ra,0x3
    80003b08:	922080e7          	jalr	-1758(ra) # 80006426 <release>
  return r;
}
    80003b0c:	8526                	mv	a0,s1
    80003b0e:	70a2                	ld	ra,40(sp)
    80003b10:	7402                	ld	s0,32(sp)
    80003b12:	64e2                	ld	s1,24(sp)
    80003b14:	6942                	ld	s2,16(sp)
    80003b16:	69a2                	ld	s3,8(sp)
    80003b18:	6145                	addi	sp,sp,48
    80003b1a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b1c:	0284a983          	lw	s3,40(s1)
    80003b20:	ffffd097          	auipc	ra,0xffffd
    80003b24:	53a080e7          	jalr	1338(ra) # 8000105a <myproc>
    80003b28:	5904                	lw	s1,48(a0)
    80003b2a:	413484b3          	sub	s1,s1,s3
    80003b2e:	0014b493          	seqz	s1,s1
    80003b32:	bfc1                	j	80003b02 <holdingsleep+0x24>

0000000080003b34 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b34:	1141                	addi	sp,sp,-16
    80003b36:	e406                	sd	ra,8(sp)
    80003b38:	e022                	sd	s0,0(sp)
    80003b3a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b3c:	00005597          	auipc	a1,0x5
    80003b40:	b3458593          	addi	a1,a1,-1228 # 80008670 <syscalls+0x238>
    80003b44:	00235517          	auipc	a0,0x235
    80003b48:	63c50513          	addi	a0,a0,1596 # 80239180 <ftable>
    80003b4c:	00002097          	auipc	ra,0x2
    80003b50:	796080e7          	jalr	1942(ra) # 800062e2 <initlock>
}
    80003b54:	60a2                	ld	ra,8(sp)
    80003b56:	6402                	ld	s0,0(sp)
    80003b58:	0141                	addi	sp,sp,16
    80003b5a:	8082                	ret

0000000080003b5c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b5c:	1101                	addi	sp,sp,-32
    80003b5e:	ec06                	sd	ra,24(sp)
    80003b60:	e822                	sd	s0,16(sp)
    80003b62:	e426                	sd	s1,8(sp)
    80003b64:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b66:	00235517          	auipc	a0,0x235
    80003b6a:	61a50513          	addi	a0,a0,1562 # 80239180 <ftable>
    80003b6e:	00003097          	auipc	ra,0x3
    80003b72:	804080e7          	jalr	-2044(ra) # 80006372 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b76:	00235497          	auipc	s1,0x235
    80003b7a:	62248493          	addi	s1,s1,1570 # 80239198 <ftable+0x18>
    80003b7e:	00236717          	auipc	a4,0x236
    80003b82:	5ba70713          	addi	a4,a4,1466 # 8023a138 <ftable+0xfb8>
    if(f->ref == 0){
    80003b86:	40dc                	lw	a5,4(s1)
    80003b88:	cf99                	beqz	a5,80003ba6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b8a:	02848493          	addi	s1,s1,40
    80003b8e:	fee49ce3          	bne	s1,a4,80003b86 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b92:	00235517          	auipc	a0,0x235
    80003b96:	5ee50513          	addi	a0,a0,1518 # 80239180 <ftable>
    80003b9a:	00003097          	auipc	ra,0x3
    80003b9e:	88c080e7          	jalr	-1908(ra) # 80006426 <release>
  return 0;
    80003ba2:	4481                	li	s1,0
    80003ba4:	a819                	j	80003bba <filealloc+0x5e>
      f->ref = 1;
    80003ba6:	4785                	li	a5,1
    80003ba8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003baa:	00235517          	auipc	a0,0x235
    80003bae:	5d650513          	addi	a0,a0,1494 # 80239180 <ftable>
    80003bb2:	00003097          	auipc	ra,0x3
    80003bb6:	874080e7          	jalr	-1932(ra) # 80006426 <release>
}
    80003bba:	8526                	mv	a0,s1
    80003bbc:	60e2                	ld	ra,24(sp)
    80003bbe:	6442                	ld	s0,16(sp)
    80003bc0:	64a2                	ld	s1,8(sp)
    80003bc2:	6105                	addi	sp,sp,32
    80003bc4:	8082                	ret

0000000080003bc6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bc6:	1101                	addi	sp,sp,-32
    80003bc8:	ec06                	sd	ra,24(sp)
    80003bca:	e822                	sd	s0,16(sp)
    80003bcc:	e426                	sd	s1,8(sp)
    80003bce:	1000                	addi	s0,sp,32
    80003bd0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bd2:	00235517          	auipc	a0,0x235
    80003bd6:	5ae50513          	addi	a0,a0,1454 # 80239180 <ftable>
    80003bda:	00002097          	auipc	ra,0x2
    80003bde:	798080e7          	jalr	1944(ra) # 80006372 <acquire>
  if(f->ref < 1)
    80003be2:	40dc                	lw	a5,4(s1)
    80003be4:	02f05263          	blez	a5,80003c08 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003be8:	2785                	addiw	a5,a5,1
    80003bea:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bec:	00235517          	auipc	a0,0x235
    80003bf0:	59450513          	addi	a0,a0,1428 # 80239180 <ftable>
    80003bf4:	00003097          	auipc	ra,0x3
    80003bf8:	832080e7          	jalr	-1998(ra) # 80006426 <release>
  return f;
}
    80003bfc:	8526                	mv	a0,s1
    80003bfe:	60e2                	ld	ra,24(sp)
    80003c00:	6442                	ld	s0,16(sp)
    80003c02:	64a2                	ld	s1,8(sp)
    80003c04:	6105                	addi	sp,sp,32
    80003c06:	8082                	ret
    panic("filedup");
    80003c08:	00005517          	auipc	a0,0x5
    80003c0c:	a7050513          	addi	a0,a0,-1424 # 80008678 <syscalls+0x240>
    80003c10:	00002097          	auipc	ra,0x2
    80003c14:	218080e7          	jalr	536(ra) # 80005e28 <panic>

0000000080003c18 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c18:	7139                	addi	sp,sp,-64
    80003c1a:	fc06                	sd	ra,56(sp)
    80003c1c:	f822                	sd	s0,48(sp)
    80003c1e:	f426                	sd	s1,40(sp)
    80003c20:	f04a                	sd	s2,32(sp)
    80003c22:	ec4e                	sd	s3,24(sp)
    80003c24:	e852                	sd	s4,16(sp)
    80003c26:	e456                	sd	s5,8(sp)
    80003c28:	0080                	addi	s0,sp,64
    80003c2a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c2c:	00235517          	auipc	a0,0x235
    80003c30:	55450513          	addi	a0,a0,1364 # 80239180 <ftable>
    80003c34:	00002097          	auipc	ra,0x2
    80003c38:	73e080e7          	jalr	1854(ra) # 80006372 <acquire>
  if(f->ref < 1)
    80003c3c:	40dc                	lw	a5,4(s1)
    80003c3e:	06f05163          	blez	a5,80003ca0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c42:	37fd                	addiw	a5,a5,-1
    80003c44:	0007871b          	sext.w	a4,a5
    80003c48:	c0dc                	sw	a5,4(s1)
    80003c4a:	06e04363          	bgtz	a4,80003cb0 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c4e:	0004a903          	lw	s2,0(s1)
    80003c52:	0094ca83          	lbu	s5,9(s1)
    80003c56:	0104ba03          	ld	s4,16(s1)
    80003c5a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c5e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c62:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c66:	00235517          	auipc	a0,0x235
    80003c6a:	51a50513          	addi	a0,a0,1306 # 80239180 <ftable>
    80003c6e:	00002097          	auipc	ra,0x2
    80003c72:	7b8080e7          	jalr	1976(ra) # 80006426 <release>

  if(ff.type == FD_PIPE){
    80003c76:	4785                	li	a5,1
    80003c78:	04f90d63          	beq	s2,a5,80003cd2 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c7c:	3979                	addiw	s2,s2,-2
    80003c7e:	4785                	li	a5,1
    80003c80:	0527e063          	bltu	a5,s2,80003cc0 <fileclose+0xa8>
    begin_op();
    80003c84:	00000097          	auipc	ra,0x0
    80003c88:	ac8080e7          	jalr	-1336(ra) # 8000374c <begin_op>
    iput(ff.ip);
    80003c8c:	854e                	mv	a0,s3
    80003c8e:	fffff097          	auipc	ra,0xfffff
    80003c92:	2a6080e7          	jalr	678(ra) # 80002f34 <iput>
    end_op();
    80003c96:	00000097          	auipc	ra,0x0
    80003c9a:	b36080e7          	jalr	-1226(ra) # 800037cc <end_op>
    80003c9e:	a00d                	j	80003cc0 <fileclose+0xa8>
    panic("fileclose");
    80003ca0:	00005517          	auipc	a0,0x5
    80003ca4:	9e050513          	addi	a0,a0,-1568 # 80008680 <syscalls+0x248>
    80003ca8:	00002097          	auipc	ra,0x2
    80003cac:	180080e7          	jalr	384(ra) # 80005e28 <panic>
    release(&ftable.lock);
    80003cb0:	00235517          	auipc	a0,0x235
    80003cb4:	4d050513          	addi	a0,a0,1232 # 80239180 <ftable>
    80003cb8:	00002097          	auipc	ra,0x2
    80003cbc:	76e080e7          	jalr	1902(ra) # 80006426 <release>
  }
}
    80003cc0:	70e2                	ld	ra,56(sp)
    80003cc2:	7442                	ld	s0,48(sp)
    80003cc4:	74a2                	ld	s1,40(sp)
    80003cc6:	7902                	ld	s2,32(sp)
    80003cc8:	69e2                	ld	s3,24(sp)
    80003cca:	6a42                	ld	s4,16(sp)
    80003ccc:	6aa2                	ld	s5,8(sp)
    80003cce:	6121                	addi	sp,sp,64
    80003cd0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cd2:	85d6                	mv	a1,s5
    80003cd4:	8552                	mv	a0,s4
    80003cd6:	00000097          	auipc	ra,0x0
    80003cda:	34c080e7          	jalr	844(ra) # 80004022 <pipeclose>
    80003cde:	b7cd                	j	80003cc0 <fileclose+0xa8>

0000000080003ce0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ce0:	715d                	addi	sp,sp,-80
    80003ce2:	e486                	sd	ra,72(sp)
    80003ce4:	e0a2                	sd	s0,64(sp)
    80003ce6:	fc26                	sd	s1,56(sp)
    80003ce8:	f84a                	sd	s2,48(sp)
    80003cea:	f44e                	sd	s3,40(sp)
    80003cec:	0880                	addi	s0,sp,80
    80003cee:	84aa                	mv	s1,a0
    80003cf0:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cf2:	ffffd097          	auipc	ra,0xffffd
    80003cf6:	368080e7          	jalr	872(ra) # 8000105a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cfa:	409c                	lw	a5,0(s1)
    80003cfc:	37f9                	addiw	a5,a5,-2
    80003cfe:	4705                	li	a4,1
    80003d00:	04f76763          	bltu	a4,a5,80003d4e <filestat+0x6e>
    80003d04:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d06:	6c88                	ld	a0,24(s1)
    80003d08:	fffff097          	auipc	ra,0xfffff
    80003d0c:	072080e7          	jalr	114(ra) # 80002d7a <ilock>
    stati(f->ip, &st);
    80003d10:	fb840593          	addi	a1,s0,-72
    80003d14:	6c88                	ld	a0,24(s1)
    80003d16:	fffff097          	auipc	ra,0xfffff
    80003d1a:	2ee080e7          	jalr	750(ra) # 80003004 <stati>
    iunlock(f->ip);
    80003d1e:	6c88                	ld	a0,24(s1)
    80003d20:	fffff097          	auipc	ra,0xfffff
    80003d24:	11c080e7          	jalr	284(ra) # 80002e3c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d28:	46e1                	li	a3,24
    80003d2a:	fb840613          	addi	a2,s0,-72
    80003d2e:	85ce                	mv	a1,s3
    80003d30:	05093503          	ld	a0,80(s2)
    80003d34:	ffffd097          	auipc	ra,0xffffd
    80003d38:	0a4080e7          	jalr	164(ra) # 80000dd8 <copyout>
    80003d3c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d40:	60a6                	ld	ra,72(sp)
    80003d42:	6406                	ld	s0,64(sp)
    80003d44:	74e2                	ld	s1,56(sp)
    80003d46:	7942                	ld	s2,48(sp)
    80003d48:	79a2                	ld	s3,40(sp)
    80003d4a:	6161                	addi	sp,sp,80
    80003d4c:	8082                	ret
  return -1;
    80003d4e:	557d                	li	a0,-1
    80003d50:	bfc5                	j	80003d40 <filestat+0x60>

0000000080003d52 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d52:	7179                	addi	sp,sp,-48
    80003d54:	f406                	sd	ra,40(sp)
    80003d56:	f022                	sd	s0,32(sp)
    80003d58:	ec26                	sd	s1,24(sp)
    80003d5a:	e84a                	sd	s2,16(sp)
    80003d5c:	e44e                	sd	s3,8(sp)
    80003d5e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d60:	00854783          	lbu	a5,8(a0)
    80003d64:	c3d5                	beqz	a5,80003e08 <fileread+0xb6>
    80003d66:	84aa                	mv	s1,a0
    80003d68:	89ae                	mv	s3,a1
    80003d6a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d6c:	411c                	lw	a5,0(a0)
    80003d6e:	4705                	li	a4,1
    80003d70:	04e78963          	beq	a5,a4,80003dc2 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d74:	470d                	li	a4,3
    80003d76:	04e78d63          	beq	a5,a4,80003dd0 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d7a:	4709                	li	a4,2
    80003d7c:	06e79e63          	bne	a5,a4,80003df8 <fileread+0xa6>
    ilock(f->ip);
    80003d80:	6d08                	ld	a0,24(a0)
    80003d82:	fffff097          	auipc	ra,0xfffff
    80003d86:	ff8080e7          	jalr	-8(ra) # 80002d7a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d8a:	874a                	mv	a4,s2
    80003d8c:	5094                	lw	a3,32(s1)
    80003d8e:	864e                	mv	a2,s3
    80003d90:	4585                	li	a1,1
    80003d92:	6c88                	ld	a0,24(s1)
    80003d94:	fffff097          	auipc	ra,0xfffff
    80003d98:	29a080e7          	jalr	666(ra) # 8000302e <readi>
    80003d9c:	892a                	mv	s2,a0
    80003d9e:	00a05563          	blez	a0,80003da8 <fileread+0x56>
      f->off += r;
    80003da2:	509c                	lw	a5,32(s1)
    80003da4:	9fa9                	addw	a5,a5,a0
    80003da6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003da8:	6c88                	ld	a0,24(s1)
    80003daa:	fffff097          	auipc	ra,0xfffff
    80003dae:	092080e7          	jalr	146(ra) # 80002e3c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003db2:	854a                	mv	a0,s2
    80003db4:	70a2                	ld	ra,40(sp)
    80003db6:	7402                	ld	s0,32(sp)
    80003db8:	64e2                	ld	s1,24(sp)
    80003dba:	6942                	ld	s2,16(sp)
    80003dbc:	69a2                	ld	s3,8(sp)
    80003dbe:	6145                	addi	sp,sp,48
    80003dc0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003dc2:	6908                	ld	a0,16(a0)
    80003dc4:	00000097          	auipc	ra,0x0
    80003dc8:	3c8080e7          	jalr	968(ra) # 8000418c <piperead>
    80003dcc:	892a                	mv	s2,a0
    80003dce:	b7d5                	j	80003db2 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003dd0:	02451783          	lh	a5,36(a0)
    80003dd4:	03079693          	slli	a3,a5,0x30
    80003dd8:	92c1                	srli	a3,a3,0x30
    80003dda:	4725                	li	a4,9
    80003ddc:	02d76863          	bltu	a4,a3,80003e0c <fileread+0xba>
    80003de0:	0792                	slli	a5,a5,0x4
    80003de2:	00235717          	auipc	a4,0x235
    80003de6:	2fe70713          	addi	a4,a4,766 # 802390e0 <devsw>
    80003dea:	97ba                	add	a5,a5,a4
    80003dec:	639c                	ld	a5,0(a5)
    80003dee:	c38d                	beqz	a5,80003e10 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003df0:	4505                	li	a0,1
    80003df2:	9782                	jalr	a5
    80003df4:	892a                	mv	s2,a0
    80003df6:	bf75                	j	80003db2 <fileread+0x60>
    panic("fileread");
    80003df8:	00005517          	auipc	a0,0x5
    80003dfc:	89850513          	addi	a0,a0,-1896 # 80008690 <syscalls+0x258>
    80003e00:	00002097          	auipc	ra,0x2
    80003e04:	028080e7          	jalr	40(ra) # 80005e28 <panic>
    return -1;
    80003e08:	597d                	li	s2,-1
    80003e0a:	b765                	j	80003db2 <fileread+0x60>
      return -1;
    80003e0c:	597d                	li	s2,-1
    80003e0e:	b755                	j	80003db2 <fileread+0x60>
    80003e10:	597d                	li	s2,-1
    80003e12:	b745                	j	80003db2 <fileread+0x60>

0000000080003e14 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e14:	715d                	addi	sp,sp,-80
    80003e16:	e486                	sd	ra,72(sp)
    80003e18:	e0a2                	sd	s0,64(sp)
    80003e1a:	fc26                	sd	s1,56(sp)
    80003e1c:	f84a                	sd	s2,48(sp)
    80003e1e:	f44e                	sd	s3,40(sp)
    80003e20:	f052                	sd	s4,32(sp)
    80003e22:	ec56                	sd	s5,24(sp)
    80003e24:	e85a                	sd	s6,16(sp)
    80003e26:	e45e                	sd	s7,8(sp)
    80003e28:	e062                	sd	s8,0(sp)
    80003e2a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e2c:	00954783          	lbu	a5,9(a0)
    80003e30:	10078663          	beqz	a5,80003f3c <filewrite+0x128>
    80003e34:	892a                	mv	s2,a0
    80003e36:	8aae                	mv	s5,a1
    80003e38:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e3a:	411c                	lw	a5,0(a0)
    80003e3c:	4705                	li	a4,1
    80003e3e:	02e78263          	beq	a5,a4,80003e62 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e42:	470d                	li	a4,3
    80003e44:	02e78663          	beq	a5,a4,80003e70 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e48:	4709                	li	a4,2
    80003e4a:	0ee79163          	bne	a5,a4,80003f2c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e4e:	0ac05d63          	blez	a2,80003f08 <filewrite+0xf4>
    int i = 0;
    80003e52:	4981                	li	s3,0
    80003e54:	6b05                	lui	s6,0x1
    80003e56:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e5a:	6b85                	lui	s7,0x1
    80003e5c:	c00b8b9b          	addiw	s7,s7,-1024
    80003e60:	a861                	j	80003ef8 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e62:	6908                	ld	a0,16(a0)
    80003e64:	00000097          	auipc	ra,0x0
    80003e68:	22e080e7          	jalr	558(ra) # 80004092 <pipewrite>
    80003e6c:	8a2a                	mv	s4,a0
    80003e6e:	a045                	j	80003f0e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e70:	02451783          	lh	a5,36(a0)
    80003e74:	03079693          	slli	a3,a5,0x30
    80003e78:	92c1                	srli	a3,a3,0x30
    80003e7a:	4725                	li	a4,9
    80003e7c:	0cd76263          	bltu	a4,a3,80003f40 <filewrite+0x12c>
    80003e80:	0792                	slli	a5,a5,0x4
    80003e82:	00235717          	auipc	a4,0x235
    80003e86:	25e70713          	addi	a4,a4,606 # 802390e0 <devsw>
    80003e8a:	97ba                	add	a5,a5,a4
    80003e8c:	679c                	ld	a5,8(a5)
    80003e8e:	cbdd                	beqz	a5,80003f44 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e90:	4505                	li	a0,1
    80003e92:	9782                	jalr	a5
    80003e94:	8a2a                	mv	s4,a0
    80003e96:	a8a5                	j	80003f0e <filewrite+0xfa>
    80003e98:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e9c:	00000097          	auipc	ra,0x0
    80003ea0:	8b0080e7          	jalr	-1872(ra) # 8000374c <begin_op>
      ilock(f->ip);
    80003ea4:	01893503          	ld	a0,24(s2)
    80003ea8:	fffff097          	auipc	ra,0xfffff
    80003eac:	ed2080e7          	jalr	-302(ra) # 80002d7a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003eb0:	8762                	mv	a4,s8
    80003eb2:	02092683          	lw	a3,32(s2)
    80003eb6:	01598633          	add	a2,s3,s5
    80003eba:	4585                	li	a1,1
    80003ebc:	01893503          	ld	a0,24(s2)
    80003ec0:	fffff097          	auipc	ra,0xfffff
    80003ec4:	266080e7          	jalr	614(ra) # 80003126 <writei>
    80003ec8:	84aa                	mv	s1,a0
    80003eca:	00a05763          	blez	a0,80003ed8 <filewrite+0xc4>
        f->off += r;
    80003ece:	02092783          	lw	a5,32(s2)
    80003ed2:	9fa9                	addw	a5,a5,a0
    80003ed4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ed8:	01893503          	ld	a0,24(s2)
    80003edc:	fffff097          	auipc	ra,0xfffff
    80003ee0:	f60080e7          	jalr	-160(ra) # 80002e3c <iunlock>
      end_op();
    80003ee4:	00000097          	auipc	ra,0x0
    80003ee8:	8e8080e7          	jalr	-1816(ra) # 800037cc <end_op>

      if(r != n1){
    80003eec:	009c1f63          	bne	s8,s1,80003f0a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ef0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ef4:	0149db63          	bge	s3,s4,80003f0a <filewrite+0xf6>
      int n1 = n - i;
    80003ef8:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003efc:	84be                	mv	s1,a5
    80003efe:	2781                	sext.w	a5,a5
    80003f00:	f8fb5ce3          	bge	s6,a5,80003e98 <filewrite+0x84>
    80003f04:	84de                	mv	s1,s7
    80003f06:	bf49                	j	80003e98 <filewrite+0x84>
    int i = 0;
    80003f08:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f0a:	013a1f63          	bne	s4,s3,80003f28 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f0e:	8552                	mv	a0,s4
    80003f10:	60a6                	ld	ra,72(sp)
    80003f12:	6406                	ld	s0,64(sp)
    80003f14:	74e2                	ld	s1,56(sp)
    80003f16:	7942                	ld	s2,48(sp)
    80003f18:	79a2                	ld	s3,40(sp)
    80003f1a:	7a02                	ld	s4,32(sp)
    80003f1c:	6ae2                	ld	s5,24(sp)
    80003f1e:	6b42                	ld	s6,16(sp)
    80003f20:	6ba2                	ld	s7,8(sp)
    80003f22:	6c02                	ld	s8,0(sp)
    80003f24:	6161                	addi	sp,sp,80
    80003f26:	8082                	ret
    ret = (i == n ? n : -1);
    80003f28:	5a7d                	li	s4,-1
    80003f2a:	b7d5                	j	80003f0e <filewrite+0xfa>
    panic("filewrite");
    80003f2c:	00004517          	auipc	a0,0x4
    80003f30:	77450513          	addi	a0,a0,1908 # 800086a0 <syscalls+0x268>
    80003f34:	00002097          	auipc	ra,0x2
    80003f38:	ef4080e7          	jalr	-268(ra) # 80005e28 <panic>
    return -1;
    80003f3c:	5a7d                	li	s4,-1
    80003f3e:	bfc1                	j	80003f0e <filewrite+0xfa>
      return -1;
    80003f40:	5a7d                	li	s4,-1
    80003f42:	b7f1                	j	80003f0e <filewrite+0xfa>
    80003f44:	5a7d                	li	s4,-1
    80003f46:	b7e1                	j	80003f0e <filewrite+0xfa>

0000000080003f48 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f48:	7179                	addi	sp,sp,-48
    80003f4a:	f406                	sd	ra,40(sp)
    80003f4c:	f022                	sd	s0,32(sp)
    80003f4e:	ec26                	sd	s1,24(sp)
    80003f50:	e84a                	sd	s2,16(sp)
    80003f52:	e44e                	sd	s3,8(sp)
    80003f54:	e052                	sd	s4,0(sp)
    80003f56:	1800                	addi	s0,sp,48
    80003f58:	84aa                	mv	s1,a0
    80003f5a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f5c:	0005b023          	sd	zero,0(a1)
    80003f60:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f64:	00000097          	auipc	ra,0x0
    80003f68:	bf8080e7          	jalr	-1032(ra) # 80003b5c <filealloc>
    80003f6c:	e088                	sd	a0,0(s1)
    80003f6e:	c551                	beqz	a0,80003ffa <pipealloc+0xb2>
    80003f70:	00000097          	auipc	ra,0x0
    80003f74:	bec080e7          	jalr	-1044(ra) # 80003b5c <filealloc>
    80003f78:	00aa3023          	sd	a0,0(s4)
    80003f7c:	c92d                	beqz	a0,80003fee <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f7e:	ffffc097          	auipc	ra,0xffffc
    80003f82:	2e8080e7          	jalr	744(ra) # 80000266 <kalloc>
    80003f86:	892a                	mv	s2,a0
    80003f88:	c125                	beqz	a0,80003fe8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f8a:	4985                	li	s3,1
    80003f8c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f90:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f94:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f98:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f9c:	00004597          	auipc	a1,0x4
    80003fa0:	71458593          	addi	a1,a1,1812 # 800086b0 <syscalls+0x278>
    80003fa4:	00002097          	auipc	ra,0x2
    80003fa8:	33e080e7          	jalr	830(ra) # 800062e2 <initlock>
  (*f0)->type = FD_PIPE;
    80003fac:	609c                	ld	a5,0(s1)
    80003fae:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fb2:	609c                	ld	a5,0(s1)
    80003fb4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fb8:	609c                	ld	a5,0(s1)
    80003fba:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fbe:	609c                	ld	a5,0(s1)
    80003fc0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fc4:	000a3783          	ld	a5,0(s4)
    80003fc8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003fcc:	000a3783          	ld	a5,0(s4)
    80003fd0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fd4:	000a3783          	ld	a5,0(s4)
    80003fd8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003fdc:	000a3783          	ld	a5,0(s4)
    80003fe0:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fe4:	4501                	li	a0,0
    80003fe6:	a025                	j	8000400e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fe8:	6088                	ld	a0,0(s1)
    80003fea:	e501                	bnez	a0,80003ff2 <pipealloc+0xaa>
    80003fec:	a039                	j	80003ffa <pipealloc+0xb2>
    80003fee:	6088                	ld	a0,0(s1)
    80003ff0:	c51d                	beqz	a0,8000401e <pipealloc+0xd6>
    fileclose(*f0);
    80003ff2:	00000097          	auipc	ra,0x0
    80003ff6:	c26080e7          	jalr	-986(ra) # 80003c18 <fileclose>
  if(*f1)
    80003ffa:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ffe:	557d                	li	a0,-1
  if(*f1)
    80004000:	c799                	beqz	a5,8000400e <pipealloc+0xc6>
    fileclose(*f1);
    80004002:	853e                	mv	a0,a5
    80004004:	00000097          	auipc	ra,0x0
    80004008:	c14080e7          	jalr	-1004(ra) # 80003c18 <fileclose>
  return -1;
    8000400c:	557d                	li	a0,-1
}
    8000400e:	70a2                	ld	ra,40(sp)
    80004010:	7402                	ld	s0,32(sp)
    80004012:	64e2                	ld	s1,24(sp)
    80004014:	6942                	ld	s2,16(sp)
    80004016:	69a2                	ld	s3,8(sp)
    80004018:	6a02                	ld	s4,0(sp)
    8000401a:	6145                	addi	sp,sp,48
    8000401c:	8082                	ret
  return -1;
    8000401e:	557d                	li	a0,-1
    80004020:	b7fd                	j	8000400e <pipealloc+0xc6>

0000000080004022 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004022:	1101                	addi	sp,sp,-32
    80004024:	ec06                	sd	ra,24(sp)
    80004026:	e822                	sd	s0,16(sp)
    80004028:	e426                	sd	s1,8(sp)
    8000402a:	e04a                	sd	s2,0(sp)
    8000402c:	1000                	addi	s0,sp,32
    8000402e:	84aa                	mv	s1,a0
    80004030:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004032:	00002097          	auipc	ra,0x2
    80004036:	340080e7          	jalr	832(ra) # 80006372 <acquire>
  if(writable){
    8000403a:	02090d63          	beqz	s2,80004074 <pipeclose+0x52>
    pi->writeopen = 0;
    8000403e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004042:	21848513          	addi	a0,s1,536
    80004046:	ffffe097          	auipc	ra,0xffffe
    8000404a:	85c080e7          	jalr	-1956(ra) # 800018a2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000404e:	2204b783          	ld	a5,544(s1)
    80004052:	eb95                	bnez	a5,80004086 <pipeclose+0x64>
    release(&pi->lock);
    80004054:	8526                	mv	a0,s1
    80004056:	00002097          	auipc	ra,0x2
    8000405a:	3d0080e7          	jalr	976(ra) # 80006426 <release>
    kfree((char*)pi);
    8000405e:	8526                	mv	a0,s1
    80004060:	ffffc097          	auipc	ra,0xffffc
    80004064:	092080e7          	jalr	146(ra) # 800000f2 <kfree>
  } else
    release(&pi->lock);
}
    80004068:	60e2                	ld	ra,24(sp)
    8000406a:	6442                	ld	s0,16(sp)
    8000406c:	64a2                	ld	s1,8(sp)
    8000406e:	6902                	ld	s2,0(sp)
    80004070:	6105                	addi	sp,sp,32
    80004072:	8082                	ret
    pi->readopen = 0;
    80004074:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004078:	21c48513          	addi	a0,s1,540
    8000407c:	ffffe097          	auipc	ra,0xffffe
    80004080:	826080e7          	jalr	-2010(ra) # 800018a2 <wakeup>
    80004084:	b7e9                	j	8000404e <pipeclose+0x2c>
    release(&pi->lock);
    80004086:	8526                	mv	a0,s1
    80004088:	00002097          	auipc	ra,0x2
    8000408c:	39e080e7          	jalr	926(ra) # 80006426 <release>
}
    80004090:	bfe1                	j	80004068 <pipeclose+0x46>

0000000080004092 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004092:	7159                	addi	sp,sp,-112
    80004094:	f486                	sd	ra,104(sp)
    80004096:	f0a2                	sd	s0,96(sp)
    80004098:	eca6                	sd	s1,88(sp)
    8000409a:	e8ca                	sd	s2,80(sp)
    8000409c:	e4ce                	sd	s3,72(sp)
    8000409e:	e0d2                	sd	s4,64(sp)
    800040a0:	fc56                	sd	s5,56(sp)
    800040a2:	f85a                	sd	s6,48(sp)
    800040a4:	f45e                	sd	s7,40(sp)
    800040a6:	f062                	sd	s8,32(sp)
    800040a8:	ec66                	sd	s9,24(sp)
    800040aa:	1880                	addi	s0,sp,112
    800040ac:	84aa                	mv	s1,a0
    800040ae:	8aae                	mv	s5,a1
    800040b0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	fa8080e7          	jalr	-88(ra) # 8000105a <myproc>
    800040ba:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040bc:	8526                	mv	a0,s1
    800040be:	00002097          	auipc	ra,0x2
    800040c2:	2b4080e7          	jalr	692(ra) # 80006372 <acquire>
  while(i < n){
    800040c6:	0d405163          	blez	s4,80004188 <pipewrite+0xf6>
    800040ca:	8ba6                	mv	s7,s1
  int i = 0;
    800040cc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040ce:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040d0:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040d4:	21c48c13          	addi	s8,s1,540
    800040d8:	a08d                	j	8000413a <pipewrite+0xa8>
      release(&pi->lock);
    800040da:	8526                	mv	a0,s1
    800040dc:	00002097          	auipc	ra,0x2
    800040e0:	34a080e7          	jalr	842(ra) # 80006426 <release>
      return -1;
    800040e4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040e6:	854a                	mv	a0,s2
    800040e8:	70a6                	ld	ra,104(sp)
    800040ea:	7406                	ld	s0,96(sp)
    800040ec:	64e6                	ld	s1,88(sp)
    800040ee:	6946                	ld	s2,80(sp)
    800040f0:	69a6                	ld	s3,72(sp)
    800040f2:	6a06                	ld	s4,64(sp)
    800040f4:	7ae2                	ld	s5,56(sp)
    800040f6:	7b42                	ld	s6,48(sp)
    800040f8:	7ba2                	ld	s7,40(sp)
    800040fa:	7c02                	ld	s8,32(sp)
    800040fc:	6ce2                	ld	s9,24(sp)
    800040fe:	6165                	addi	sp,sp,112
    80004100:	8082                	ret
      wakeup(&pi->nread);
    80004102:	8566                	mv	a0,s9
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	79e080e7          	jalr	1950(ra) # 800018a2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000410c:	85de                	mv	a1,s7
    8000410e:	8562                	mv	a0,s8
    80004110:	ffffd097          	auipc	ra,0xffffd
    80004114:	606080e7          	jalr	1542(ra) # 80001716 <sleep>
    80004118:	a839                	j	80004136 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000411a:	21c4a783          	lw	a5,540(s1)
    8000411e:	0017871b          	addiw	a4,a5,1
    80004122:	20e4ae23          	sw	a4,540(s1)
    80004126:	1ff7f793          	andi	a5,a5,511
    8000412a:	97a6                	add	a5,a5,s1
    8000412c:	f9f44703          	lbu	a4,-97(s0)
    80004130:	00e78c23          	sb	a4,24(a5)
      i++;
    80004134:	2905                	addiw	s2,s2,1
  while(i < n){
    80004136:	03495d63          	bge	s2,s4,80004170 <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    8000413a:	2204a783          	lw	a5,544(s1)
    8000413e:	dfd1                	beqz	a5,800040da <pipewrite+0x48>
    80004140:	0289a783          	lw	a5,40(s3)
    80004144:	fbd9                	bnez	a5,800040da <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004146:	2184a783          	lw	a5,536(s1)
    8000414a:	21c4a703          	lw	a4,540(s1)
    8000414e:	2007879b          	addiw	a5,a5,512
    80004152:	faf708e3          	beq	a4,a5,80004102 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004156:	4685                	li	a3,1
    80004158:	01590633          	add	a2,s2,s5
    8000415c:	f9f40593          	addi	a1,s0,-97
    80004160:	0509b503          	ld	a0,80(s3)
    80004164:	ffffd097          	auipc	ra,0xffffd
    80004168:	af6080e7          	jalr	-1290(ra) # 80000c5a <copyin>
    8000416c:	fb6517e3          	bne	a0,s6,8000411a <pipewrite+0x88>
  wakeup(&pi->nread);
    80004170:	21848513          	addi	a0,s1,536
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	72e080e7          	jalr	1838(ra) # 800018a2 <wakeup>
  release(&pi->lock);
    8000417c:	8526                	mv	a0,s1
    8000417e:	00002097          	auipc	ra,0x2
    80004182:	2a8080e7          	jalr	680(ra) # 80006426 <release>
  return i;
    80004186:	b785                	j	800040e6 <pipewrite+0x54>
  int i = 0;
    80004188:	4901                	li	s2,0
    8000418a:	b7dd                	j	80004170 <pipewrite+0xde>

000000008000418c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000418c:	715d                	addi	sp,sp,-80
    8000418e:	e486                	sd	ra,72(sp)
    80004190:	e0a2                	sd	s0,64(sp)
    80004192:	fc26                	sd	s1,56(sp)
    80004194:	f84a                	sd	s2,48(sp)
    80004196:	f44e                	sd	s3,40(sp)
    80004198:	f052                	sd	s4,32(sp)
    8000419a:	ec56                	sd	s5,24(sp)
    8000419c:	e85a                	sd	s6,16(sp)
    8000419e:	0880                	addi	s0,sp,80
    800041a0:	84aa                	mv	s1,a0
    800041a2:	892e                	mv	s2,a1
    800041a4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041a6:	ffffd097          	auipc	ra,0xffffd
    800041aa:	eb4080e7          	jalr	-332(ra) # 8000105a <myproc>
    800041ae:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041b0:	8b26                	mv	s6,s1
    800041b2:	8526                	mv	a0,s1
    800041b4:	00002097          	auipc	ra,0x2
    800041b8:	1be080e7          	jalr	446(ra) # 80006372 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041bc:	2184a703          	lw	a4,536(s1)
    800041c0:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041c4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041c8:	02f71463          	bne	a4,a5,800041f0 <piperead+0x64>
    800041cc:	2244a783          	lw	a5,548(s1)
    800041d0:	c385                	beqz	a5,800041f0 <piperead+0x64>
    if(pr->killed){
    800041d2:	028a2783          	lw	a5,40(s4)
    800041d6:	ebc1                	bnez	a5,80004266 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041d8:	85da                	mv	a1,s6
    800041da:	854e                	mv	a0,s3
    800041dc:	ffffd097          	auipc	ra,0xffffd
    800041e0:	53a080e7          	jalr	1338(ra) # 80001716 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041e4:	2184a703          	lw	a4,536(s1)
    800041e8:	21c4a783          	lw	a5,540(s1)
    800041ec:	fef700e3          	beq	a4,a5,800041cc <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041f0:	09505263          	blez	s5,80004274 <piperead+0xe8>
    800041f4:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041f6:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800041f8:	2184a783          	lw	a5,536(s1)
    800041fc:	21c4a703          	lw	a4,540(s1)
    80004200:	02f70d63          	beq	a4,a5,8000423a <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004204:	0017871b          	addiw	a4,a5,1
    80004208:	20e4ac23          	sw	a4,536(s1)
    8000420c:	1ff7f793          	andi	a5,a5,511
    80004210:	97a6                	add	a5,a5,s1
    80004212:	0187c783          	lbu	a5,24(a5)
    80004216:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000421a:	4685                	li	a3,1
    8000421c:	fbf40613          	addi	a2,s0,-65
    80004220:	85ca                	mv	a1,s2
    80004222:	050a3503          	ld	a0,80(s4)
    80004226:	ffffd097          	auipc	ra,0xffffd
    8000422a:	bb2080e7          	jalr	-1102(ra) # 80000dd8 <copyout>
    8000422e:	01650663          	beq	a0,s6,8000423a <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004232:	2985                	addiw	s3,s3,1
    80004234:	0905                	addi	s2,s2,1
    80004236:	fd3a91e3          	bne	s5,s3,800041f8 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000423a:	21c48513          	addi	a0,s1,540
    8000423e:	ffffd097          	auipc	ra,0xffffd
    80004242:	664080e7          	jalr	1636(ra) # 800018a2 <wakeup>
  release(&pi->lock);
    80004246:	8526                	mv	a0,s1
    80004248:	00002097          	auipc	ra,0x2
    8000424c:	1de080e7          	jalr	478(ra) # 80006426 <release>
  return i;
}
    80004250:	854e                	mv	a0,s3
    80004252:	60a6                	ld	ra,72(sp)
    80004254:	6406                	ld	s0,64(sp)
    80004256:	74e2                	ld	s1,56(sp)
    80004258:	7942                	ld	s2,48(sp)
    8000425a:	79a2                	ld	s3,40(sp)
    8000425c:	7a02                	ld	s4,32(sp)
    8000425e:	6ae2                	ld	s5,24(sp)
    80004260:	6b42                	ld	s6,16(sp)
    80004262:	6161                	addi	sp,sp,80
    80004264:	8082                	ret
      release(&pi->lock);
    80004266:	8526                	mv	a0,s1
    80004268:	00002097          	auipc	ra,0x2
    8000426c:	1be080e7          	jalr	446(ra) # 80006426 <release>
      return -1;
    80004270:	59fd                	li	s3,-1
    80004272:	bff9                	j	80004250 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004274:	4981                	li	s3,0
    80004276:	b7d1                	j	8000423a <piperead+0xae>

0000000080004278 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004278:	df010113          	addi	sp,sp,-528
    8000427c:	20113423          	sd	ra,520(sp)
    80004280:	20813023          	sd	s0,512(sp)
    80004284:	ffa6                	sd	s1,504(sp)
    80004286:	fbca                	sd	s2,496(sp)
    80004288:	f7ce                	sd	s3,488(sp)
    8000428a:	f3d2                	sd	s4,480(sp)
    8000428c:	efd6                	sd	s5,472(sp)
    8000428e:	ebda                	sd	s6,464(sp)
    80004290:	e7de                	sd	s7,456(sp)
    80004292:	e3e2                	sd	s8,448(sp)
    80004294:	ff66                	sd	s9,440(sp)
    80004296:	fb6a                	sd	s10,432(sp)
    80004298:	f76e                	sd	s11,424(sp)
    8000429a:	0c00                	addi	s0,sp,528
    8000429c:	84aa                	mv	s1,a0
    8000429e:	dea43c23          	sd	a0,-520(s0)
    800042a2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042a6:	ffffd097          	auipc	ra,0xffffd
    800042aa:	db4080e7          	jalr	-588(ra) # 8000105a <myproc>
    800042ae:	892a                	mv	s2,a0

  begin_op();
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	49c080e7          	jalr	1180(ra) # 8000374c <begin_op>

  if((ip = namei(path)) == 0){
    800042b8:	8526                	mv	a0,s1
    800042ba:	fffff097          	auipc	ra,0xfffff
    800042be:	276080e7          	jalr	630(ra) # 80003530 <namei>
    800042c2:	c92d                	beqz	a0,80004334 <exec+0xbc>
    800042c4:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042c6:	fffff097          	auipc	ra,0xfffff
    800042ca:	ab4080e7          	jalr	-1356(ra) # 80002d7a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042ce:	04000713          	li	a4,64
    800042d2:	4681                	li	a3,0
    800042d4:	e5040613          	addi	a2,s0,-432
    800042d8:	4581                	li	a1,0
    800042da:	8526                	mv	a0,s1
    800042dc:	fffff097          	auipc	ra,0xfffff
    800042e0:	d52080e7          	jalr	-686(ra) # 8000302e <readi>
    800042e4:	04000793          	li	a5,64
    800042e8:	00f51a63          	bne	a0,a5,800042fc <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800042ec:	e5042703          	lw	a4,-432(s0)
    800042f0:	464c47b7          	lui	a5,0x464c4
    800042f4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042f8:	04f70463          	beq	a4,a5,80004340 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042fc:	8526                	mv	a0,s1
    800042fe:	fffff097          	auipc	ra,0xfffff
    80004302:	cde080e7          	jalr	-802(ra) # 80002fdc <iunlockput>
    end_op();
    80004306:	fffff097          	auipc	ra,0xfffff
    8000430a:	4c6080e7          	jalr	1222(ra) # 800037cc <end_op>
  }
  return -1;
    8000430e:	557d                	li	a0,-1
}
    80004310:	20813083          	ld	ra,520(sp)
    80004314:	20013403          	ld	s0,512(sp)
    80004318:	74fe                	ld	s1,504(sp)
    8000431a:	795e                	ld	s2,496(sp)
    8000431c:	79be                	ld	s3,488(sp)
    8000431e:	7a1e                	ld	s4,480(sp)
    80004320:	6afe                	ld	s5,472(sp)
    80004322:	6b5e                	ld	s6,464(sp)
    80004324:	6bbe                	ld	s7,456(sp)
    80004326:	6c1e                	ld	s8,448(sp)
    80004328:	7cfa                	ld	s9,440(sp)
    8000432a:	7d5a                	ld	s10,432(sp)
    8000432c:	7dba                	ld	s11,424(sp)
    8000432e:	21010113          	addi	sp,sp,528
    80004332:	8082                	ret
    end_op();
    80004334:	fffff097          	auipc	ra,0xfffff
    80004338:	498080e7          	jalr	1176(ra) # 800037cc <end_op>
    return -1;
    8000433c:	557d                	li	a0,-1
    8000433e:	bfc9                	j	80004310 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004340:	854a                	mv	a0,s2
    80004342:	ffffd097          	auipc	ra,0xffffd
    80004346:	ddc080e7          	jalr	-548(ra) # 8000111e <proc_pagetable>
    8000434a:	8baa                	mv	s7,a0
    8000434c:	d945                	beqz	a0,800042fc <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000434e:	e7042983          	lw	s3,-400(s0)
    80004352:	e8845783          	lhu	a5,-376(s0)
    80004356:	c7ad                	beqz	a5,800043c0 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004358:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000435a:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    8000435c:	6c85                	lui	s9,0x1
    8000435e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004362:	def43823          	sd	a5,-528(s0)
    80004366:	a42d                	j	80004590 <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004368:	00004517          	auipc	a0,0x4
    8000436c:	35050513          	addi	a0,a0,848 # 800086b8 <syscalls+0x280>
    80004370:	00002097          	auipc	ra,0x2
    80004374:	ab8080e7          	jalr	-1352(ra) # 80005e28 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004378:	8756                	mv	a4,s5
    8000437a:	012d86bb          	addw	a3,s11,s2
    8000437e:	4581                	li	a1,0
    80004380:	8526                	mv	a0,s1
    80004382:	fffff097          	auipc	ra,0xfffff
    80004386:	cac080e7          	jalr	-852(ra) # 8000302e <readi>
    8000438a:	2501                	sext.w	a0,a0
    8000438c:	1aaa9963          	bne	s5,a0,8000453e <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004390:	6785                	lui	a5,0x1
    80004392:	0127893b          	addw	s2,a5,s2
    80004396:	77fd                	lui	a5,0xfffff
    80004398:	01478a3b          	addw	s4,a5,s4
    8000439c:	1f897163          	bgeu	s2,s8,8000457e <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800043a0:	02091593          	slli	a1,s2,0x20
    800043a4:	9181                	srli	a1,a1,0x20
    800043a6:	95ea                	add	a1,a1,s10
    800043a8:	855e                	mv	a0,s7
    800043aa:	ffffc097          	auipc	ra,0xffffc
    800043ae:	2bc080e7          	jalr	700(ra) # 80000666 <walkaddr>
    800043b2:	862a                	mv	a2,a0
    if(pa == 0)
    800043b4:	d955                	beqz	a0,80004368 <exec+0xf0>
      n = PGSIZE;
    800043b6:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800043b8:	fd9a70e3          	bgeu	s4,s9,80004378 <exec+0x100>
      n = sz - i;
    800043bc:	8ad2                	mv	s5,s4
    800043be:	bf6d                	j	80004378 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043c0:	4901                	li	s2,0
  iunlockput(ip);
    800043c2:	8526                	mv	a0,s1
    800043c4:	fffff097          	auipc	ra,0xfffff
    800043c8:	c18080e7          	jalr	-1000(ra) # 80002fdc <iunlockput>
  end_op();
    800043cc:	fffff097          	auipc	ra,0xfffff
    800043d0:	400080e7          	jalr	1024(ra) # 800037cc <end_op>
  p = myproc();
    800043d4:	ffffd097          	auipc	ra,0xffffd
    800043d8:	c86080e7          	jalr	-890(ra) # 8000105a <myproc>
    800043dc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043de:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800043e2:	6785                	lui	a5,0x1
    800043e4:	17fd                	addi	a5,a5,-1
    800043e6:	993e                	add	s2,s2,a5
    800043e8:	757d                	lui	a0,0xfffff
    800043ea:	00a977b3          	and	a5,s2,a0
    800043ee:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800043f2:	6609                	lui	a2,0x2
    800043f4:	963e                	add	a2,a2,a5
    800043f6:	85be                	mv	a1,a5
    800043f8:	855e                	mv	a0,s7
    800043fa:	ffffc097          	auipc	ra,0xffffc
    800043fe:	620080e7          	jalr	1568(ra) # 80000a1a <uvmalloc>
    80004402:	8b2a                	mv	s6,a0
  ip = 0;
    80004404:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004406:	12050c63          	beqz	a0,8000453e <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000440a:	75f9                	lui	a1,0xffffe
    8000440c:	95aa                	add	a1,a1,a0
    8000440e:	855e                	mv	a0,s7
    80004410:	ffffd097          	auipc	ra,0xffffd
    80004414:	818080e7          	jalr	-2024(ra) # 80000c28 <uvmclear>
  stackbase = sp - PGSIZE;
    80004418:	7c7d                	lui	s8,0xfffff
    8000441a:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    8000441c:	e0043783          	ld	a5,-512(s0)
    80004420:	6388                	ld	a0,0(a5)
    80004422:	c535                	beqz	a0,8000448e <exec+0x216>
    80004424:	e9040993          	addi	s3,s0,-368
    80004428:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000442c:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000442e:	ffffc097          	auipc	ra,0xffffc
    80004432:	02e080e7          	jalr	46(ra) # 8000045c <strlen>
    80004436:	2505                	addiw	a0,a0,1
    80004438:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000443c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004440:	13896363          	bltu	s2,s8,80004566 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004444:	e0043d83          	ld	s11,-512(s0)
    80004448:	000dba03          	ld	s4,0(s11)
    8000444c:	8552                	mv	a0,s4
    8000444e:	ffffc097          	auipc	ra,0xffffc
    80004452:	00e080e7          	jalr	14(ra) # 8000045c <strlen>
    80004456:	0015069b          	addiw	a3,a0,1
    8000445a:	8652                	mv	a2,s4
    8000445c:	85ca                	mv	a1,s2
    8000445e:	855e                	mv	a0,s7
    80004460:	ffffd097          	auipc	ra,0xffffd
    80004464:	978080e7          	jalr	-1672(ra) # 80000dd8 <copyout>
    80004468:	10054363          	bltz	a0,8000456e <exec+0x2f6>
    ustack[argc] = sp;
    8000446c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004470:	0485                	addi	s1,s1,1
    80004472:	008d8793          	addi	a5,s11,8
    80004476:	e0f43023          	sd	a5,-512(s0)
    8000447a:	008db503          	ld	a0,8(s11)
    8000447e:	c911                	beqz	a0,80004492 <exec+0x21a>
    if(argc >= MAXARG)
    80004480:	09a1                	addi	s3,s3,8
    80004482:	fb3c96e3          	bne	s9,s3,8000442e <exec+0x1b6>
  sz = sz1;
    80004486:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000448a:	4481                	li	s1,0
    8000448c:	a84d                	j	8000453e <exec+0x2c6>
  sp = sz;
    8000448e:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004490:	4481                	li	s1,0
  ustack[argc] = 0;
    80004492:	00349793          	slli	a5,s1,0x3
    80004496:	f9040713          	addi	a4,s0,-112
    8000449a:	97ba                	add	a5,a5,a4
    8000449c:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800044a0:	00148693          	addi	a3,s1,1
    800044a4:	068e                	slli	a3,a3,0x3
    800044a6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044aa:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044ae:	01897663          	bgeu	s2,s8,800044ba <exec+0x242>
  sz = sz1;
    800044b2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044b6:	4481                	li	s1,0
    800044b8:	a059                	j	8000453e <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044ba:	e9040613          	addi	a2,s0,-368
    800044be:	85ca                	mv	a1,s2
    800044c0:	855e                	mv	a0,s7
    800044c2:	ffffd097          	auipc	ra,0xffffd
    800044c6:	916080e7          	jalr	-1770(ra) # 80000dd8 <copyout>
    800044ca:	0a054663          	bltz	a0,80004576 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800044ce:	058ab783          	ld	a5,88(s5)
    800044d2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044d6:	df843783          	ld	a5,-520(s0)
    800044da:	0007c703          	lbu	a4,0(a5)
    800044de:	cf11                	beqz	a4,800044fa <exec+0x282>
    800044e0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044e2:	02f00693          	li	a3,47
    800044e6:	a039                	j	800044f4 <exec+0x27c>
      last = s+1;
    800044e8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044ec:	0785                	addi	a5,a5,1
    800044ee:	fff7c703          	lbu	a4,-1(a5)
    800044f2:	c701                	beqz	a4,800044fa <exec+0x282>
    if(*s == '/')
    800044f4:	fed71ce3          	bne	a4,a3,800044ec <exec+0x274>
    800044f8:	bfc5                	j	800044e8 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    800044fa:	4641                	li	a2,16
    800044fc:	df843583          	ld	a1,-520(s0)
    80004500:	158a8513          	addi	a0,s5,344
    80004504:	ffffc097          	auipc	ra,0xffffc
    80004508:	f26080e7          	jalr	-218(ra) # 8000042a <safestrcpy>
  oldpagetable = p->pagetable;
    8000450c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004510:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004514:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004518:	058ab783          	ld	a5,88(s5)
    8000451c:	e6843703          	ld	a4,-408(s0)
    80004520:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004522:	058ab783          	ld	a5,88(s5)
    80004526:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000452a:	85ea                	mv	a1,s10
    8000452c:	ffffd097          	auipc	ra,0xffffd
    80004530:	c8e080e7          	jalr	-882(ra) # 800011ba <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004534:	0004851b          	sext.w	a0,s1
    80004538:	bbe1                	j	80004310 <exec+0x98>
    8000453a:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000453e:	e0843583          	ld	a1,-504(s0)
    80004542:	855e                	mv	a0,s7
    80004544:	ffffd097          	auipc	ra,0xffffd
    80004548:	c76080e7          	jalr	-906(ra) # 800011ba <proc_freepagetable>
  if(ip){
    8000454c:	da0498e3          	bnez	s1,800042fc <exec+0x84>
  return -1;
    80004550:	557d                	li	a0,-1
    80004552:	bb7d                	j	80004310 <exec+0x98>
    80004554:	e1243423          	sd	s2,-504(s0)
    80004558:	b7dd                	j	8000453e <exec+0x2c6>
    8000455a:	e1243423          	sd	s2,-504(s0)
    8000455e:	b7c5                	j	8000453e <exec+0x2c6>
    80004560:	e1243423          	sd	s2,-504(s0)
    80004564:	bfe9                	j	8000453e <exec+0x2c6>
  sz = sz1;
    80004566:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000456a:	4481                	li	s1,0
    8000456c:	bfc9                	j	8000453e <exec+0x2c6>
  sz = sz1;
    8000456e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004572:	4481                	li	s1,0
    80004574:	b7e9                	j	8000453e <exec+0x2c6>
  sz = sz1;
    80004576:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000457a:	4481                	li	s1,0
    8000457c:	b7c9                	j	8000453e <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000457e:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004582:	2b05                	addiw	s6,s6,1
    80004584:	0389899b          	addiw	s3,s3,56
    80004588:	e8845783          	lhu	a5,-376(s0)
    8000458c:	e2fb5be3          	bge	s6,a5,800043c2 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004590:	2981                	sext.w	s3,s3
    80004592:	03800713          	li	a4,56
    80004596:	86ce                	mv	a3,s3
    80004598:	e1840613          	addi	a2,s0,-488
    8000459c:	4581                	li	a1,0
    8000459e:	8526                	mv	a0,s1
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	a8e080e7          	jalr	-1394(ra) # 8000302e <readi>
    800045a8:	03800793          	li	a5,56
    800045ac:	f8f517e3          	bne	a0,a5,8000453a <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800045b0:	e1842783          	lw	a5,-488(s0)
    800045b4:	4705                	li	a4,1
    800045b6:	fce796e3          	bne	a5,a4,80004582 <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800045ba:	e4043603          	ld	a2,-448(s0)
    800045be:	e3843783          	ld	a5,-456(s0)
    800045c2:	f8f669e3          	bltu	a2,a5,80004554 <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045c6:	e2843783          	ld	a5,-472(s0)
    800045ca:	963e                	add	a2,a2,a5
    800045cc:	f8f667e3          	bltu	a2,a5,8000455a <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045d0:	85ca                	mv	a1,s2
    800045d2:	855e                	mv	a0,s7
    800045d4:	ffffc097          	auipc	ra,0xffffc
    800045d8:	446080e7          	jalr	1094(ra) # 80000a1a <uvmalloc>
    800045dc:	e0a43423          	sd	a0,-504(s0)
    800045e0:	d141                	beqz	a0,80004560 <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    800045e2:	e2843d03          	ld	s10,-472(s0)
    800045e6:	df043783          	ld	a5,-528(s0)
    800045ea:	00fd77b3          	and	a5,s10,a5
    800045ee:	fba1                	bnez	a5,8000453e <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045f0:	e2042d83          	lw	s11,-480(s0)
    800045f4:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800045f8:	f80c03e3          	beqz	s8,8000457e <exec+0x306>
    800045fc:	8a62                	mv	s4,s8
    800045fe:	4901                	li	s2,0
    80004600:	b345                	j	800043a0 <exec+0x128>

0000000080004602 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004602:	7179                	addi	sp,sp,-48
    80004604:	f406                	sd	ra,40(sp)
    80004606:	f022                	sd	s0,32(sp)
    80004608:	ec26                	sd	s1,24(sp)
    8000460a:	e84a                	sd	s2,16(sp)
    8000460c:	1800                	addi	s0,sp,48
    8000460e:	892e                	mv	s2,a1
    80004610:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004612:	fdc40593          	addi	a1,s0,-36
    80004616:	ffffe097          	auipc	ra,0xffffe
    8000461a:	bf2080e7          	jalr	-1038(ra) # 80002208 <argint>
    8000461e:	04054063          	bltz	a0,8000465e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004622:	fdc42703          	lw	a4,-36(s0)
    80004626:	47bd                	li	a5,15
    80004628:	02e7ed63          	bltu	a5,a4,80004662 <argfd+0x60>
    8000462c:	ffffd097          	auipc	ra,0xffffd
    80004630:	a2e080e7          	jalr	-1490(ra) # 8000105a <myproc>
    80004634:	fdc42703          	lw	a4,-36(s0)
    80004638:	01a70793          	addi	a5,a4,26
    8000463c:	078e                	slli	a5,a5,0x3
    8000463e:	953e                	add	a0,a0,a5
    80004640:	611c                	ld	a5,0(a0)
    80004642:	c395                	beqz	a5,80004666 <argfd+0x64>
    return -1;
  if(pfd)
    80004644:	00090463          	beqz	s2,8000464c <argfd+0x4a>
    *pfd = fd;
    80004648:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000464c:	4501                	li	a0,0
  if(pf)
    8000464e:	c091                	beqz	s1,80004652 <argfd+0x50>
    *pf = f;
    80004650:	e09c                	sd	a5,0(s1)
}
    80004652:	70a2                	ld	ra,40(sp)
    80004654:	7402                	ld	s0,32(sp)
    80004656:	64e2                	ld	s1,24(sp)
    80004658:	6942                	ld	s2,16(sp)
    8000465a:	6145                	addi	sp,sp,48
    8000465c:	8082                	ret
    return -1;
    8000465e:	557d                	li	a0,-1
    80004660:	bfcd                	j	80004652 <argfd+0x50>
    return -1;
    80004662:	557d                	li	a0,-1
    80004664:	b7fd                	j	80004652 <argfd+0x50>
    80004666:	557d                	li	a0,-1
    80004668:	b7ed                	j	80004652 <argfd+0x50>

000000008000466a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000466a:	1101                	addi	sp,sp,-32
    8000466c:	ec06                	sd	ra,24(sp)
    8000466e:	e822                	sd	s0,16(sp)
    80004670:	e426                	sd	s1,8(sp)
    80004672:	1000                	addi	s0,sp,32
    80004674:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004676:	ffffd097          	auipc	ra,0xffffd
    8000467a:	9e4080e7          	jalr	-1564(ra) # 8000105a <myproc>
    8000467e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004680:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7fdb8e90>
    80004684:	4501                	li	a0,0
    80004686:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004688:	6398                	ld	a4,0(a5)
    8000468a:	cb19                	beqz	a4,800046a0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000468c:	2505                	addiw	a0,a0,1
    8000468e:	07a1                	addi	a5,a5,8
    80004690:	fed51ce3          	bne	a0,a3,80004688 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004694:	557d                	li	a0,-1
}
    80004696:	60e2                	ld	ra,24(sp)
    80004698:	6442                	ld	s0,16(sp)
    8000469a:	64a2                	ld	s1,8(sp)
    8000469c:	6105                	addi	sp,sp,32
    8000469e:	8082                	ret
      p->ofile[fd] = f;
    800046a0:	01a50793          	addi	a5,a0,26
    800046a4:	078e                	slli	a5,a5,0x3
    800046a6:	963e                	add	a2,a2,a5
    800046a8:	e204                	sd	s1,0(a2)
      return fd;
    800046aa:	b7f5                	j	80004696 <fdalloc+0x2c>

00000000800046ac <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046ac:	715d                	addi	sp,sp,-80
    800046ae:	e486                	sd	ra,72(sp)
    800046b0:	e0a2                	sd	s0,64(sp)
    800046b2:	fc26                	sd	s1,56(sp)
    800046b4:	f84a                	sd	s2,48(sp)
    800046b6:	f44e                	sd	s3,40(sp)
    800046b8:	f052                	sd	s4,32(sp)
    800046ba:	ec56                	sd	s5,24(sp)
    800046bc:	0880                	addi	s0,sp,80
    800046be:	89ae                	mv	s3,a1
    800046c0:	8ab2                	mv	s5,a2
    800046c2:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046c4:	fb040593          	addi	a1,s0,-80
    800046c8:	fffff097          	auipc	ra,0xfffff
    800046cc:	e86080e7          	jalr	-378(ra) # 8000354e <nameiparent>
    800046d0:	892a                	mv	s2,a0
    800046d2:	12050f63          	beqz	a0,80004810 <create+0x164>
    return 0;

  ilock(dp);
    800046d6:	ffffe097          	auipc	ra,0xffffe
    800046da:	6a4080e7          	jalr	1700(ra) # 80002d7a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046de:	4601                	li	a2,0
    800046e0:	fb040593          	addi	a1,s0,-80
    800046e4:	854a                	mv	a0,s2
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	b78080e7          	jalr	-1160(ra) # 8000325e <dirlookup>
    800046ee:	84aa                	mv	s1,a0
    800046f0:	c921                	beqz	a0,80004740 <create+0x94>
    iunlockput(dp);
    800046f2:	854a                	mv	a0,s2
    800046f4:	fffff097          	auipc	ra,0xfffff
    800046f8:	8e8080e7          	jalr	-1816(ra) # 80002fdc <iunlockput>
    ilock(ip);
    800046fc:	8526                	mv	a0,s1
    800046fe:	ffffe097          	auipc	ra,0xffffe
    80004702:	67c080e7          	jalr	1660(ra) # 80002d7a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004706:	2981                	sext.w	s3,s3
    80004708:	4789                	li	a5,2
    8000470a:	02f99463          	bne	s3,a5,80004732 <create+0x86>
    8000470e:	0444d783          	lhu	a5,68(s1)
    80004712:	37f9                	addiw	a5,a5,-2
    80004714:	17c2                	slli	a5,a5,0x30
    80004716:	93c1                	srli	a5,a5,0x30
    80004718:	4705                	li	a4,1
    8000471a:	00f76c63          	bltu	a4,a5,80004732 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000471e:	8526                	mv	a0,s1
    80004720:	60a6                	ld	ra,72(sp)
    80004722:	6406                	ld	s0,64(sp)
    80004724:	74e2                	ld	s1,56(sp)
    80004726:	7942                	ld	s2,48(sp)
    80004728:	79a2                	ld	s3,40(sp)
    8000472a:	7a02                	ld	s4,32(sp)
    8000472c:	6ae2                	ld	s5,24(sp)
    8000472e:	6161                	addi	sp,sp,80
    80004730:	8082                	ret
    iunlockput(ip);
    80004732:	8526                	mv	a0,s1
    80004734:	fffff097          	auipc	ra,0xfffff
    80004738:	8a8080e7          	jalr	-1880(ra) # 80002fdc <iunlockput>
    return 0;
    8000473c:	4481                	li	s1,0
    8000473e:	b7c5                	j	8000471e <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004740:	85ce                	mv	a1,s3
    80004742:	00092503          	lw	a0,0(s2)
    80004746:	ffffe097          	auipc	ra,0xffffe
    8000474a:	49c080e7          	jalr	1180(ra) # 80002be2 <ialloc>
    8000474e:	84aa                	mv	s1,a0
    80004750:	c529                	beqz	a0,8000479a <create+0xee>
  ilock(ip);
    80004752:	ffffe097          	auipc	ra,0xffffe
    80004756:	628080e7          	jalr	1576(ra) # 80002d7a <ilock>
  ip->major = major;
    8000475a:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000475e:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004762:	4785                	li	a5,1
    80004764:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004768:	8526                	mv	a0,s1
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	546080e7          	jalr	1350(ra) # 80002cb0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004772:	2981                	sext.w	s3,s3
    80004774:	4785                	li	a5,1
    80004776:	02f98a63          	beq	s3,a5,800047aa <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    8000477a:	40d0                	lw	a2,4(s1)
    8000477c:	fb040593          	addi	a1,s0,-80
    80004780:	854a                	mv	a0,s2
    80004782:	fffff097          	auipc	ra,0xfffff
    80004786:	cec080e7          	jalr	-788(ra) # 8000346e <dirlink>
    8000478a:	06054b63          	bltz	a0,80004800 <create+0x154>
  iunlockput(dp);
    8000478e:	854a                	mv	a0,s2
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	84c080e7          	jalr	-1972(ra) # 80002fdc <iunlockput>
  return ip;
    80004798:	b759                	j	8000471e <create+0x72>
    panic("create: ialloc");
    8000479a:	00004517          	auipc	a0,0x4
    8000479e:	f3e50513          	addi	a0,a0,-194 # 800086d8 <syscalls+0x2a0>
    800047a2:	00001097          	auipc	ra,0x1
    800047a6:	686080e7          	jalr	1670(ra) # 80005e28 <panic>
    dp->nlink++;  // for ".."
    800047aa:	04a95783          	lhu	a5,74(s2)
    800047ae:	2785                	addiw	a5,a5,1
    800047b0:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800047b4:	854a                	mv	a0,s2
    800047b6:	ffffe097          	auipc	ra,0xffffe
    800047ba:	4fa080e7          	jalr	1274(ra) # 80002cb0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047be:	40d0                	lw	a2,4(s1)
    800047c0:	00004597          	auipc	a1,0x4
    800047c4:	f2858593          	addi	a1,a1,-216 # 800086e8 <syscalls+0x2b0>
    800047c8:	8526                	mv	a0,s1
    800047ca:	fffff097          	auipc	ra,0xfffff
    800047ce:	ca4080e7          	jalr	-860(ra) # 8000346e <dirlink>
    800047d2:	00054f63          	bltz	a0,800047f0 <create+0x144>
    800047d6:	00492603          	lw	a2,4(s2)
    800047da:	00004597          	auipc	a1,0x4
    800047de:	f1658593          	addi	a1,a1,-234 # 800086f0 <syscalls+0x2b8>
    800047e2:	8526                	mv	a0,s1
    800047e4:	fffff097          	auipc	ra,0xfffff
    800047e8:	c8a080e7          	jalr	-886(ra) # 8000346e <dirlink>
    800047ec:	f80557e3          	bgez	a0,8000477a <create+0xce>
      panic("create dots");
    800047f0:	00004517          	auipc	a0,0x4
    800047f4:	f0850513          	addi	a0,a0,-248 # 800086f8 <syscalls+0x2c0>
    800047f8:	00001097          	auipc	ra,0x1
    800047fc:	630080e7          	jalr	1584(ra) # 80005e28 <panic>
    panic("create: dirlink");
    80004800:	00004517          	auipc	a0,0x4
    80004804:	f0850513          	addi	a0,a0,-248 # 80008708 <syscalls+0x2d0>
    80004808:	00001097          	auipc	ra,0x1
    8000480c:	620080e7          	jalr	1568(ra) # 80005e28 <panic>
    return 0;
    80004810:	84aa                	mv	s1,a0
    80004812:	b731                	j	8000471e <create+0x72>

0000000080004814 <sys_dup>:
{
    80004814:	7179                	addi	sp,sp,-48
    80004816:	f406                	sd	ra,40(sp)
    80004818:	f022                	sd	s0,32(sp)
    8000481a:	ec26                	sd	s1,24(sp)
    8000481c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000481e:	fd840613          	addi	a2,s0,-40
    80004822:	4581                	li	a1,0
    80004824:	4501                	li	a0,0
    80004826:	00000097          	auipc	ra,0x0
    8000482a:	ddc080e7          	jalr	-548(ra) # 80004602 <argfd>
    return -1;
    8000482e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004830:	02054363          	bltz	a0,80004856 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004834:	fd843503          	ld	a0,-40(s0)
    80004838:	00000097          	auipc	ra,0x0
    8000483c:	e32080e7          	jalr	-462(ra) # 8000466a <fdalloc>
    80004840:	84aa                	mv	s1,a0
    return -1;
    80004842:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004844:	00054963          	bltz	a0,80004856 <sys_dup+0x42>
  filedup(f);
    80004848:	fd843503          	ld	a0,-40(s0)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	37a080e7          	jalr	890(ra) # 80003bc6 <filedup>
  return fd;
    80004854:	87a6                	mv	a5,s1
}
    80004856:	853e                	mv	a0,a5
    80004858:	70a2                	ld	ra,40(sp)
    8000485a:	7402                	ld	s0,32(sp)
    8000485c:	64e2                	ld	s1,24(sp)
    8000485e:	6145                	addi	sp,sp,48
    80004860:	8082                	ret

0000000080004862 <sys_read>:
{
    80004862:	7179                	addi	sp,sp,-48
    80004864:	f406                	sd	ra,40(sp)
    80004866:	f022                	sd	s0,32(sp)
    80004868:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000486a:	fe840613          	addi	a2,s0,-24
    8000486e:	4581                	li	a1,0
    80004870:	4501                	li	a0,0
    80004872:	00000097          	auipc	ra,0x0
    80004876:	d90080e7          	jalr	-624(ra) # 80004602 <argfd>
    return -1;
    8000487a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000487c:	04054163          	bltz	a0,800048be <sys_read+0x5c>
    80004880:	fe440593          	addi	a1,s0,-28
    80004884:	4509                	li	a0,2
    80004886:	ffffe097          	auipc	ra,0xffffe
    8000488a:	982080e7          	jalr	-1662(ra) # 80002208 <argint>
    return -1;
    8000488e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004890:	02054763          	bltz	a0,800048be <sys_read+0x5c>
    80004894:	fd840593          	addi	a1,s0,-40
    80004898:	4505                	li	a0,1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	990080e7          	jalr	-1648(ra) # 8000222a <argaddr>
    return -1;
    800048a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048a4:	00054d63          	bltz	a0,800048be <sys_read+0x5c>
  return fileread(f, p, n);
    800048a8:	fe442603          	lw	a2,-28(s0)
    800048ac:	fd843583          	ld	a1,-40(s0)
    800048b0:	fe843503          	ld	a0,-24(s0)
    800048b4:	fffff097          	auipc	ra,0xfffff
    800048b8:	49e080e7          	jalr	1182(ra) # 80003d52 <fileread>
    800048bc:	87aa                	mv	a5,a0
}
    800048be:	853e                	mv	a0,a5
    800048c0:	70a2                	ld	ra,40(sp)
    800048c2:	7402                	ld	s0,32(sp)
    800048c4:	6145                	addi	sp,sp,48
    800048c6:	8082                	ret

00000000800048c8 <sys_write>:
{
    800048c8:	7179                	addi	sp,sp,-48
    800048ca:	f406                	sd	ra,40(sp)
    800048cc:	f022                	sd	s0,32(sp)
    800048ce:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d0:	fe840613          	addi	a2,s0,-24
    800048d4:	4581                	li	a1,0
    800048d6:	4501                	li	a0,0
    800048d8:	00000097          	auipc	ra,0x0
    800048dc:	d2a080e7          	jalr	-726(ra) # 80004602 <argfd>
    return -1;
    800048e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048e2:	04054163          	bltz	a0,80004924 <sys_write+0x5c>
    800048e6:	fe440593          	addi	a1,s0,-28
    800048ea:	4509                	li	a0,2
    800048ec:	ffffe097          	auipc	ra,0xffffe
    800048f0:	91c080e7          	jalr	-1764(ra) # 80002208 <argint>
    return -1;
    800048f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048f6:	02054763          	bltz	a0,80004924 <sys_write+0x5c>
    800048fa:	fd840593          	addi	a1,s0,-40
    800048fe:	4505                	li	a0,1
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	92a080e7          	jalr	-1750(ra) # 8000222a <argaddr>
    return -1;
    80004908:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000490a:	00054d63          	bltz	a0,80004924 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000490e:	fe442603          	lw	a2,-28(s0)
    80004912:	fd843583          	ld	a1,-40(s0)
    80004916:	fe843503          	ld	a0,-24(s0)
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	4fa080e7          	jalr	1274(ra) # 80003e14 <filewrite>
    80004922:	87aa                	mv	a5,a0
}
    80004924:	853e                	mv	a0,a5
    80004926:	70a2                	ld	ra,40(sp)
    80004928:	7402                	ld	s0,32(sp)
    8000492a:	6145                	addi	sp,sp,48
    8000492c:	8082                	ret

000000008000492e <sys_close>:
{
    8000492e:	1101                	addi	sp,sp,-32
    80004930:	ec06                	sd	ra,24(sp)
    80004932:	e822                	sd	s0,16(sp)
    80004934:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004936:	fe040613          	addi	a2,s0,-32
    8000493a:	fec40593          	addi	a1,s0,-20
    8000493e:	4501                	li	a0,0
    80004940:	00000097          	auipc	ra,0x0
    80004944:	cc2080e7          	jalr	-830(ra) # 80004602 <argfd>
    return -1;
    80004948:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000494a:	02054463          	bltz	a0,80004972 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000494e:	ffffc097          	auipc	ra,0xffffc
    80004952:	70c080e7          	jalr	1804(ra) # 8000105a <myproc>
    80004956:	fec42783          	lw	a5,-20(s0)
    8000495a:	07e9                	addi	a5,a5,26
    8000495c:	078e                	slli	a5,a5,0x3
    8000495e:	97aa                	add	a5,a5,a0
    80004960:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004964:	fe043503          	ld	a0,-32(s0)
    80004968:	fffff097          	auipc	ra,0xfffff
    8000496c:	2b0080e7          	jalr	688(ra) # 80003c18 <fileclose>
  return 0;
    80004970:	4781                	li	a5,0
}
    80004972:	853e                	mv	a0,a5
    80004974:	60e2                	ld	ra,24(sp)
    80004976:	6442                	ld	s0,16(sp)
    80004978:	6105                	addi	sp,sp,32
    8000497a:	8082                	ret

000000008000497c <sys_fstat>:
{
    8000497c:	1101                	addi	sp,sp,-32
    8000497e:	ec06                	sd	ra,24(sp)
    80004980:	e822                	sd	s0,16(sp)
    80004982:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004984:	fe840613          	addi	a2,s0,-24
    80004988:	4581                	li	a1,0
    8000498a:	4501                	li	a0,0
    8000498c:	00000097          	auipc	ra,0x0
    80004990:	c76080e7          	jalr	-906(ra) # 80004602 <argfd>
    return -1;
    80004994:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004996:	02054563          	bltz	a0,800049c0 <sys_fstat+0x44>
    8000499a:	fe040593          	addi	a1,s0,-32
    8000499e:	4505                	li	a0,1
    800049a0:	ffffe097          	auipc	ra,0xffffe
    800049a4:	88a080e7          	jalr	-1910(ra) # 8000222a <argaddr>
    return -1;
    800049a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049aa:	00054b63          	bltz	a0,800049c0 <sys_fstat+0x44>
  return filestat(f, st);
    800049ae:	fe043583          	ld	a1,-32(s0)
    800049b2:	fe843503          	ld	a0,-24(s0)
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	32a080e7          	jalr	810(ra) # 80003ce0 <filestat>
    800049be:	87aa                	mv	a5,a0
}
    800049c0:	853e                	mv	a0,a5
    800049c2:	60e2                	ld	ra,24(sp)
    800049c4:	6442                	ld	s0,16(sp)
    800049c6:	6105                	addi	sp,sp,32
    800049c8:	8082                	ret

00000000800049ca <sys_link>:
{
    800049ca:	7169                	addi	sp,sp,-304
    800049cc:	f606                	sd	ra,296(sp)
    800049ce:	f222                	sd	s0,288(sp)
    800049d0:	ee26                	sd	s1,280(sp)
    800049d2:	ea4a                	sd	s2,272(sp)
    800049d4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049d6:	08000613          	li	a2,128
    800049da:	ed040593          	addi	a1,s0,-304
    800049de:	4501                	li	a0,0
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	86c080e7          	jalr	-1940(ra) # 8000224c <argstr>
    return -1;
    800049e8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049ea:	10054e63          	bltz	a0,80004b06 <sys_link+0x13c>
    800049ee:	08000613          	li	a2,128
    800049f2:	f5040593          	addi	a1,s0,-176
    800049f6:	4505                	li	a0,1
    800049f8:	ffffe097          	auipc	ra,0xffffe
    800049fc:	854080e7          	jalr	-1964(ra) # 8000224c <argstr>
    return -1;
    80004a00:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a02:	10054263          	bltz	a0,80004b06 <sys_link+0x13c>
  begin_op();
    80004a06:	fffff097          	auipc	ra,0xfffff
    80004a0a:	d46080e7          	jalr	-698(ra) # 8000374c <begin_op>
  if((ip = namei(old)) == 0){
    80004a0e:	ed040513          	addi	a0,s0,-304
    80004a12:	fffff097          	auipc	ra,0xfffff
    80004a16:	b1e080e7          	jalr	-1250(ra) # 80003530 <namei>
    80004a1a:	84aa                	mv	s1,a0
    80004a1c:	c551                	beqz	a0,80004aa8 <sys_link+0xde>
  ilock(ip);
    80004a1e:	ffffe097          	auipc	ra,0xffffe
    80004a22:	35c080e7          	jalr	860(ra) # 80002d7a <ilock>
  if(ip->type == T_DIR){
    80004a26:	04449703          	lh	a4,68(s1)
    80004a2a:	4785                	li	a5,1
    80004a2c:	08f70463          	beq	a4,a5,80004ab4 <sys_link+0xea>
  ip->nlink++;
    80004a30:	04a4d783          	lhu	a5,74(s1)
    80004a34:	2785                	addiw	a5,a5,1
    80004a36:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a3a:	8526                	mv	a0,s1
    80004a3c:	ffffe097          	auipc	ra,0xffffe
    80004a40:	274080e7          	jalr	628(ra) # 80002cb0 <iupdate>
  iunlock(ip);
    80004a44:	8526                	mv	a0,s1
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	3f6080e7          	jalr	1014(ra) # 80002e3c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a4e:	fd040593          	addi	a1,s0,-48
    80004a52:	f5040513          	addi	a0,s0,-176
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	af8080e7          	jalr	-1288(ra) # 8000354e <nameiparent>
    80004a5e:	892a                	mv	s2,a0
    80004a60:	c935                	beqz	a0,80004ad4 <sys_link+0x10a>
  ilock(dp);
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	318080e7          	jalr	792(ra) # 80002d7a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a6a:	00092703          	lw	a4,0(s2)
    80004a6e:	409c                	lw	a5,0(s1)
    80004a70:	04f71d63          	bne	a4,a5,80004aca <sys_link+0x100>
    80004a74:	40d0                	lw	a2,4(s1)
    80004a76:	fd040593          	addi	a1,s0,-48
    80004a7a:	854a                	mv	a0,s2
    80004a7c:	fffff097          	auipc	ra,0xfffff
    80004a80:	9f2080e7          	jalr	-1550(ra) # 8000346e <dirlink>
    80004a84:	04054363          	bltz	a0,80004aca <sys_link+0x100>
  iunlockput(dp);
    80004a88:	854a                	mv	a0,s2
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	552080e7          	jalr	1362(ra) # 80002fdc <iunlockput>
  iput(ip);
    80004a92:	8526                	mv	a0,s1
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	4a0080e7          	jalr	1184(ra) # 80002f34 <iput>
  end_op();
    80004a9c:	fffff097          	auipc	ra,0xfffff
    80004aa0:	d30080e7          	jalr	-720(ra) # 800037cc <end_op>
  return 0;
    80004aa4:	4781                	li	a5,0
    80004aa6:	a085                	j	80004b06 <sys_link+0x13c>
    end_op();
    80004aa8:	fffff097          	auipc	ra,0xfffff
    80004aac:	d24080e7          	jalr	-732(ra) # 800037cc <end_op>
    return -1;
    80004ab0:	57fd                	li	a5,-1
    80004ab2:	a891                	j	80004b06 <sys_link+0x13c>
    iunlockput(ip);
    80004ab4:	8526                	mv	a0,s1
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	526080e7          	jalr	1318(ra) # 80002fdc <iunlockput>
    end_op();
    80004abe:	fffff097          	auipc	ra,0xfffff
    80004ac2:	d0e080e7          	jalr	-754(ra) # 800037cc <end_op>
    return -1;
    80004ac6:	57fd                	li	a5,-1
    80004ac8:	a83d                	j	80004b06 <sys_link+0x13c>
    iunlockput(dp);
    80004aca:	854a                	mv	a0,s2
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	510080e7          	jalr	1296(ra) # 80002fdc <iunlockput>
  ilock(ip);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	2a4080e7          	jalr	676(ra) # 80002d7a <ilock>
  ip->nlink--;
    80004ade:	04a4d783          	lhu	a5,74(s1)
    80004ae2:	37fd                	addiw	a5,a5,-1
    80004ae4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ae8:	8526                	mv	a0,s1
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	1c6080e7          	jalr	454(ra) # 80002cb0 <iupdate>
  iunlockput(ip);
    80004af2:	8526                	mv	a0,s1
    80004af4:	ffffe097          	auipc	ra,0xffffe
    80004af8:	4e8080e7          	jalr	1256(ra) # 80002fdc <iunlockput>
  end_op();
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	cd0080e7          	jalr	-816(ra) # 800037cc <end_op>
  return -1;
    80004b04:	57fd                	li	a5,-1
}
    80004b06:	853e                	mv	a0,a5
    80004b08:	70b2                	ld	ra,296(sp)
    80004b0a:	7412                	ld	s0,288(sp)
    80004b0c:	64f2                	ld	s1,280(sp)
    80004b0e:	6952                	ld	s2,272(sp)
    80004b10:	6155                	addi	sp,sp,304
    80004b12:	8082                	ret

0000000080004b14 <sys_unlink>:
{
    80004b14:	7151                	addi	sp,sp,-240
    80004b16:	f586                	sd	ra,232(sp)
    80004b18:	f1a2                	sd	s0,224(sp)
    80004b1a:	eda6                	sd	s1,216(sp)
    80004b1c:	e9ca                	sd	s2,208(sp)
    80004b1e:	e5ce                	sd	s3,200(sp)
    80004b20:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b22:	08000613          	li	a2,128
    80004b26:	f3040593          	addi	a1,s0,-208
    80004b2a:	4501                	li	a0,0
    80004b2c:	ffffd097          	auipc	ra,0xffffd
    80004b30:	720080e7          	jalr	1824(ra) # 8000224c <argstr>
    80004b34:	18054163          	bltz	a0,80004cb6 <sys_unlink+0x1a2>
  begin_op();
    80004b38:	fffff097          	auipc	ra,0xfffff
    80004b3c:	c14080e7          	jalr	-1004(ra) # 8000374c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b40:	fb040593          	addi	a1,s0,-80
    80004b44:	f3040513          	addi	a0,s0,-208
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	a06080e7          	jalr	-1530(ra) # 8000354e <nameiparent>
    80004b50:	84aa                	mv	s1,a0
    80004b52:	c979                	beqz	a0,80004c28 <sys_unlink+0x114>
  ilock(dp);
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	226080e7          	jalr	550(ra) # 80002d7a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b5c:	00004597          	auipc	a1,0x4
    80004b60:	b8c58593          	addi	a1,a1,-1140 # 800086e8 <syscalls+0x2b0>
    80004b64:	fb040513          	addi	a0,s0,-80
    80004b68:	ffffe097          	auipc	ra,0xffffe
    80004b6c:	6dc080e7          	jalr	1756(ra) # 80003244 <namecmp>
    80004b70:	14050a63          	beqz	a0,80004cc4 <sys_unlink+0x1b0>
    80004b74:	00004597          	auipc	a1,0x4
    80004b78:	b7c58593          	addi	a1,a1,-1156 # 800086f0 <syscalls+0x2b8>
    80004b7c:	fb040513          	addi	a0,s0,-80
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	6c4080e7          	jalr	1732(ra) # 80003244 <namecmp>
    80004b88:	12050e63          	beqz	a0,80004cc4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b8c:	f2c40613          	addi	a2,s0,-212
    80004b90:	fb040593          	addi	a1,s0,-80
    80004b94:	8526                	mv	a0,s1
    80004b96:	ffffe097          	auipc	ra,0xffffe
    80004b9a:	6c8080e7          	jalr	1736(ra) # 8000325e <dirlookup>
    80004b9e:	892a                	mv	s2,a0
    80004ba0:	12050263          	beqz	a0,80004cc4 <sys_unlink+0x1b0>
  ilock(ip);
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	1d6080e7          	jalr	470(ra) # 80002d7a <ilock>
  if(ip->nlink < 1)
    80004bac:	04a91783          	lh	a5,74(s2)
    80004bb0:	08f05263          	blez	a5,80004c34 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bb4:	04491703          	lh	a4,68(s2)
    80004bb8:	4785                	li	a5,1
    80004bba:	08f70563          	beq	a4,a5,80004c44 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bbe:	4641                	li	a2,16
    80004bc0:	4581                	li	a1,0
    80004bc2:	fc040513          	addi	a0,s0,-64
    80004bc6:	ffffb097          	auipc	ra,0xffffb
    80004bca:	712080e7          	jalr	1810(ra) # 800002d8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bce:	4741                	li	a4,16
    80004bd0:	f2c42683          	lw	a3,-212(s0)
    80004bd4:	fc040613          	addi	a2,s0,-64
    80004bd8:	4581                	li	a1,0
    80004bda:	8526                	mv	a0,s1
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	54a080e7          	jalr	1354(ra) # 80003126 <writei>
    80004be4:	47c1                	li	a5,16
    80004be6:	0af51563          	bne	a0,a5,80004c90 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bea:	04491703          	lh	a4,68(s2)
    80004bee:	4785                	li	a5,1
    80004bf0:	0af70863          	beq	a4,a5,80004ca0 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	3e6080e7          	jalr	998(ra) # 80002fdc <iunlockput>
  ip->nlink--;
    80004bfe:	04a95783          	lhu	a5,74(s2)
    80004c02:	37fd                	addiw	a5,a5,-1
    80004c04:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c08:	854a                	mv	a0,s2
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	0a6080e7          	jalr	166(ra) # 80002cb0 <iupdate>
  iunlockput(ip);
    80004c12:	854a                	mv	a0,s2
    80004c14:	ffffe097          	auipc	ra,0xffffe
    80004c18:	3c8080e7          	jalr	968(ra) # 80002fdc <iunlockput>
  end_op();
    80004c1c:	fffff097          	auipc	ra,0xfffff
    80004c20:	bb0080e7          	jalr	-1104(ra) # 800037cc <end_op>
  return 0;
    80004c24:	4501                	li	a0,0
    80004c26:	a84d                	j	80004cd8 <sys_unlink+0x1c4>
    end_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	ba4080e7          	jalr	-1116(ra) # 800037cc <end_op>
    return -1;
    80004c30:	557d                	li	a0,-1
    80004c32:	a05d                	j	80004cd8 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c34:	00004517          	auipc	a0,0x4
    80004c38:	ae450513          	addi	a0,a0,-1308 # 80008718 <syscalls+0x2e0>
    80004c3c:	00001097          	auipc	ra,0x1
    80004c40:	1ec080e7          	jalr	492(ra) # 80005e28 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c44:	04c92703          	lw	a4,76(s2)
    80004c48:	02000793          	li	a5,32
    80004c4c:	f6e7f9e3          	bgeu	a5,a4,80004bbe <sys_unlink+0xaa>
    80004c50:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c54:	4741                	li	a4,16
    80004c56:	86ce                	mv	a3,s3
    80004c58:	f1840613          	addi	a2,s0,-232
    80004c5c:	4581                	li	a1,0
    80004c5e:	854a                	mv	a0,s2
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	3ce080e7          	jalr	974(ra) # 8000302e <readi>
    80004c68:	47c1                	li	a5,16
    80004c6a:	00f51b63          	bne	a0,a5,80004c80 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c6e:	f1845783          	lhu	a5,-232(s0)
    80004c72:	e7a1                	bnez	a5,80004cba <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c74:	29c1                	addiw	s3,s3,16
    80004c76:	04c92783          	lw	a5,76(s2)
    80004c7a:	fcf9ede3          	bltu	s3,a5,80004c54 <sys_unlink+0x140>
    80004c7e:	b781                	j	80004bbe <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c80:	00004517          	auipc	a0,0x4
    80004c84:	ab050513          	addi	a0,a0,-1360 # 80008730 <syscalls+0x2f8>
    80004c88:	00001097          	auipc	ra,0x1
    80004c8c:	1a0080e7          	jalr	416(ra) # 80005e28 <panic>
    panic("unlink: writei");
    80004c90:	00004517          	auipc	a0,0x4
    80004c94:	ab850513          	addi	a0,a0,-1352 # 80008748 <syscalls+0x310>
    80004c98:	00001097          	auipc	ra,0x1
    80004c9c:	190080e7          	jalr	400(ra) # 80005e28 <panic>
    dp->nlink--;
    80004ca0:	04a4d783          	lhu	a5,74(s1)
    80004ca4:	37fd                	addiw	a5,a5,-1
    80004ca6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004caa:	8526                	mv	a0,s1
    80004cac:	ffffe097          	auipc	ra,0xffffe
    80004cb0:	004080e7          	jalr	4(ra) # 80002cb0 <iupdate>
    80004cb4:	b781                	j	80004bf4 <sys_unlink+0xe0>
    return -1;
    80004cb6:	557d                	li	a0,-1
    80004cb8:	a005                	j	80004cd8 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cba:	854a                	mv	a0,s2
    80004cbc:	ffffe097          	auipc	ra,0xffffe
    80004cc0:	320080e7          	jalr	800(ra) # 80002fdc <iunlockput>
  iunlockput(dp);
    80004cc4:	8526                	mv	a0,s1
    80004cc6:	ffffe097          	auipc	ra,0xffffe
    80004cca:	316080e7          	jalr	790(ra) # 80002fdc <iunlockput>
  end_op();
    80004cce:	fffff097          	auipc	ra,0xfffff
    80004cd2:	afe080e7          	jalr	-1282(ra) # 800037cc <end_op>
  return -1;
    80004cd6:	557d                	li	a0,-1
}
    80004cd8:	70ae                	ld	ra,232(sp)
    80004cda:	740e                	ld	s0,224(sp)
    80004cdc:	64ee                	ld	s1,216(sp)
    80004cde:	694e                	ld	s2,208(sp)
    80004ce0:	69ae                	ld	s3,200(sp)
    80004ce2:	616d                	addi	sp,sp,240
    80004ce4:	8082                	ret

0000000080004ce6 <sys_open>:

uint64
sys_open(void)
{
    80004ce6:	7131                	addi	sp,sp,-192
    80004ce8:	fd06                	sd	ra,184(sp)
    80004cea:	f922                	sd	s0,176(sp)
    80004cec:	f526                	sd	s1,168(sp)
    80004cee:	f14a                	sd	s2,160(sp)
    80004cf0:	ed4e                	sd	s3,152(sp)
    80004cf2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004cf4:	08000613          	li	a2,128
    80004cf8:	f5040593          	addi	a1,s0,-176
    80004cfc:	4501                	li	a0,0
    80004cfe:	ffffd097          	auipc	ra,0xffffd
    80004d02:	54e080e7          	jalr	1358(ra) # 8000224c <argstr>
    return -1;
    80004d06:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d08:	0c054163          	bltz	a0,80004dca <sys_open+0xe4>
    80004d0c:	f4c40593          	addi	a1,s0,-180
    80004d10:	4505                	li	a0,1
    80004d12:	ffffd097          	auipc	ra,0xffffd
    80004d16:	4f6080e7          	jalr	1270(ra) # 80002208 <argint>
    80004d1a:	0a054863          	bltz	a0,80004dca <sys_open+0xe4>

  begin_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	a2e080e7          	jalr	-1490(ra) # 8000374c <begin_op>

  if(omode & O_CREATE){
    80004d26:	f4c42783          	lw	a5,-180(s0)
    80004d2a:	2007f793          	andi	a5,a5,512
    80004d2e:	cbdd                	beqz	a5,80004de4 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d30:	4681                	li	a3,0
    80004d32:	4601                	li	a2,0
    80004d34:	4589                	li	a1,2
    80004d36:	f5040513          	addi	a0,s0,-176
    80004d3a:	00000097          	auipc	ra,0x0
    80004d3e:	972080e7          	jalr	-1678(ra) # 800046ac <create>
    80004d42:	892a                	mv	s2,a0
    if(ip == 0){
    80004d44:	c959                	beqz	a0,80004dda <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d46:	04491703          	lh	a4,68(s2)
    80004d4a:	478d                	li	a5,3
    80004d4c:	00f71763          	bne	a4,a5,80004d5a <sys_open+0x74>
    80004d50:	04695703          	lhu	a4,70(s2)
    80004d54:	47a5                	li	a5,9
    80004d56:	0ce7ec63          	bltu	a5,a4,80004e2e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d5a:	fffff097          	auipc	ra,0xfffff
    80004d5e:	e02080e7          	jalr	-510(ra) # 80003b5c <filealloc>
    80004d62:	89aa                	mv	s3,a0
    80004d64:	10050263          	beqz	a0,80004e68 <sys_open+0x182>
    80004d68:	00000097          	auipc	ra,0x0
    80004d6c:	902080e7          	jalr	-1790(ra) # 8000466a <fdalloc>
    80004d70:	84aa                	mv	s1,a0
    80004d72:	0e054663          	bltz	a0,80004e5e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d76:	04491703          	lh	a4,68(s2)
    80004d7a:	478d                	li	a5,3
    80004d7c:	0cf70463          	beq	a4,a5,80004e44 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d80:	4789                	li	a5,2
    80004d82:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d86:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d8a:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d8e:	f4c42783          	lw	a5,-180(s0)
    80004d92:	0017c713          	xori	a4,a5,1
    80004d96:	8b05                	andi	a4,a4,1
    80004d98:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d9c:	0037f713          	andi	a4,a5,3
    80004da0:	00e03733          	snez	a4,a4
    80004da4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004da8:	4007f793          	andi	a5,a5,1024
    80004dac:	c791                	beqz	a5,80004db8 <sys_open+0xd2>
    80004dae:	04491703          	lh	a4,68(s2)
    80004db2:	4789                	li	a5,2
    80004db4:	08f70f63          	beq	a4,a5,80004e52 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004db8:	854a                	mv	a0,s2
    80004dba:	ffffe097          	auipc	ra,0xffffe
    80004dbe:	082080e7          	jalr	130(ra) # 80002e3c <iunlock>
  end_op();
    80004dc2:	fffff097          	auipc	ra,0xfffff
    80004dc6:	a0a080e7          	jalr	-1526(ra) # 800037cc <end_op>

  return fd;
}
    80004dca:	8526                	mv	a0,s1
    80004dcc:	70ea                	ld	ra,184(sp)
    80004dce:	744a                	ld	s0,176(sp)
    80004dd0:	74aa                	ld	s1,168(sp)
    80004dd2:	790a                	ld	s2,160(sp)
    80004dd4:	69ea                	ld	s3,152(sp)
    80004dd6:	6129                	addi	sp,sp,192
    80004dd8:	8082                	ret
      end_op();
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	9f2080e7          	jalr	-1550(ra) # 800037cc <end_op>
      return -1;
    80004de2:	b7e5                	j	80004dca <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004de4:	f5040513          	addi	a0,s0,-176
    80004de8:	ffffe097          	auipc	ra,0xffffe
    80004dec:	748080e7          	jalr	1864(ra) # 80003530 <namei>
    80004df0:	892a                	mv	s2,a0
    80004df2:	c905                	beqz	a0,80004e22 <sys_open+0x13c>
    ilock(ip);
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	f86080e7          	jalr	-122(ra) # 80002d7a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004dfc:	04491703          	lh	a4,68(s2)
    80004e00:	4785                	li	a5,1
    80004e02:	f4f712e3          	bne	a4,a5,80004d46 <sys_open+0x60>
    80004e06:	f4c42783          	lw	a5,-180(s0)
    80004e0a:	dba1                	beqz	a5,80004d5a <sys_open+0x74>
      iunlockput(ip);
    80004e0c:	854a                	mv	a0,s2
    80004e0e:	ffffe097          	auipc	ra,0xffffe
    80004e12:	1ce080e7          	jalr	462(ra) # 80002fdc <iunlockput>
      end_op();
    80004e16:	fffff097          	auipc	ra,0xfffff
    80004e1a:	9b6080e7          	jalr	-1610(ra) # 800037cc <end_op>
      return -1;
    80004e1e:	54fd                	li	s1,-1
    80004e20:	b76d                	j	80004dca <sys_open+0xe4>
      end_op();
    80004e22:	fffff097          	auipc	ra,0xfffff
    80004e26:	9aa080e7          	jalr	-1622(ra) # 800037cc <end_op>
      return -1;
    80004e2a:	54fd                	li	s1,-1
    80004e2c:	bf79                	j	80004dca <sys_open+0xe4>
    iunlockput(ip);
    80004e2e:	854a                	mv	a0,s2
    80004e30:	ffffe097          	auipc	ra,0xffffe
    80004e34:	1ac080e7          	jalr	428(ra) # 80002fdc <iunlockput>
    end_op();
    80004e38:	fffff097          	auipc	ra,0xfffff
    80004e3c:	994080e7          	jalr	-1644(ra) # 800037cc <end_op>
    return -1;
    80004e40:	54fd                	li	s1,-1
    80004e42:	b761                	j	80004dca <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e44:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e48:	04691783          	lh	a5,70(s2)
    80004e4c:	02f99223          	sh	a5,36(s3)
    80004e50:	bf2d                	j	80004d8a <sys_open+0xa4>
    itrunc(ip);
    80004e52:	854a                	mv	a0,s2
    80004e54:	ffffe097          	auipc	ra,0xffffe
    80004e58:	034080e7          	jalr	52(ra) # 80002e88 <itrunc>
    80004e5c:	bfb1                	j	80004db8 <sys_open+0xd2>
      fileclose(f);
    80004e5e:	854e                	mv	a0,s3
    80004e60:	fffff097          	auipc	ra,0xfffff
    80004e64:	db8080e7          	jalr	-584(ra) # 80003c18 <fileclose>
    iunlockput(ip);
    80004e68:	854a                	mv	a0,s2
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	172080e7          	jalr	370(ra) # 80002fdc <iunlockput>
    end_op();
    80004e72:	fffff097          	auipc	ra,0xfffff
    80004e76:	95a080e7          	jalr	-1702(ra) # 800037cc <end_op>
    return -1;
    80004e7a:	54fd                	li	s1,-1
    80004e7c:	b7b9                	j	80004dca <sys_open+0xe4>

0000000080004e7e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e7e:	7175                	addi	sp,sp,-144
    80004e80:	e506                	sd	ra,136(sp)
    80004e82:	e122                	sd	s0,128(sp)
    80004e84:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	8c6080e7          	jalr	-1850(ra) # 8000374c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e8e:	08000613          	li	a2,128
    80004e92:	f7040593          	addi	a1,s0,-144
    80004e96:	4501                	li	a0,0
    80004e98:	ffffd097          	auipc	ra,0xffffd
    80004e9c:	3b4080e7          	jalr	948(ra) # 8000224c <argstr>
    80004ea0:	02054963          	bltz	a0,80004ed2 <sys_mkdir+0x54>
    80004ea4:	4681                	li	a3,0
    80004ea6:	4601                	li	a2,0
    80004ea8:	4585                	li	a1,1
    80004eaa:	f7040513          	addi	a0,s0,-144
    80004eae:	fffff097          	auipc	ra,0xfffff
    80004eb2:	7fe080e7          	jalr	2046(ra) # 800046ac <create>
    80004eb6:	cd11                	beqz	a0,80004ed2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	124080e7          	jalr	292(ra) # 80002fdc <iunlockput>
  end_op();
    80004ec0:	fffff097          	auipc	ra,0xfffff
    80004ec4:	90c080e7          	jalr	-1780(ra) # 800037cc <end_op>
  return 0;
    80004ec8:	4501                	li	a0,0
}
    80004eca:	60aa                	ld	ra,136(sp)
    80004ecc:	640a                	ld	s0,128(sp)
    80004ece:	6149                	addi	sp,sp,144
    80004ed0:	8082                	ret
    end_op();
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	8fa080e7          	jalr	-1798(ra) # 800037cc <end_op>
    return -1;
    80004eda:	557d                	li	a0,-1
    80004edc:	b7fd                	j	80004eca <sys_mkdir+0x4c>

0000000080004ede <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ede:	7135                	addi	sp,sp,-160
    80004ee0:	ed06                	sd	ra,152(sp)
    80004ee2:	e922                	sd	s0,144(sp)
    80004ee4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ee6:	fffff097          	auipc	ra,0xfffff
    80004eea:	866080e7          	jalr	-1946(ra) # 8000374c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004eee:	08000613          	li	a2,128
    80004ef2:	f7040593          	addi	a1,s0,-144
    80004ef6:	4501                	li	a0,0
    80004ef8:	ffffd097          	auipc	ra,0xffffd
    80004efc:	354080e7          	jalr	852(ra) # 8000224c <argstr>
    80004f00:	04054a63          	bltz	a0,80004f54 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f04:	f6c40593          	addi	a1,s0,-148
    80004f08:	4505                	li	a0,1
    80004f0a:	ffffd097          	auipc	ra,0xffffd
    80004f0e:	2fe080e7          	jalr	766(ra) # 80002208 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f12:	04054163          	bltz	a0,80004f54 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f16:	f6840593          	addi	a1,s0,-152
    80004f1a:	4509                	li	a0,2
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	2ec080e7          	jalr	748(ra) # 80002208 <argint>
     argint(1, &major) < 0 ||
    80004f24:	02054863          	bltz	a0,80004f54 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f28:	f6841683          	lh	a3,-152(s0)
    80004f2c:	f6c41603          	lh	a2,-148(s0)
    80004f30:	458d                	li	a1,3
    80004f32:	f7040513          	addi	a0,s0,-144
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	776080e7          	jalr	1910(ra) # 800046ac <create>
     argint(2, &minor) < 0 ||
    80004f3e:	c919                	beqz	a0,80004f54 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	09c080e7          	jalr	156(ra) # 80002fdc <iunlockput>
  end_op();
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	884080e7          	jalr	-1916(ra) # 800037cc <end_op>
  return 0;
    80004f50:	4501                	li	a0,0
    80004f52:	a031                	j	80004f5e <sys_mknod+0x80>
    end_op();
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	878080e7          	jalr	-1928(ra) # 800037cc <end_op>
    return -1;
    80004f5c:	557d                	li	a0,-1
}
    80004f5e:	60ea                	ld	ra,152(sp)
    80004f60:	644a                	ld	s0,144(sp)
    80004f62:	610d                	addi	sp,sp,160
    80004f64:	8082                	ret

0000000080004f66 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f66:	7135                	addi	sp,sp,-160
    80004f68:	ed06                	sd	ra,152(sp)
    80004f6a:	e922                	sd	s0,144(sp)
    80004f6c:	e526                	sd	s1,136(sp)
    80004f6e:	e14a                	sd	s2,128(sp)
    80004f70:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	0e8080e7          	jalr	232(ra) # 8000105a <myproc>
    80004f7a:	892a                	mv	s2,a0
  
  begin_op();
    80004f7c:	ffffe097          	auipc	ra,0xffffe
    80004f80:	7d0080e7          	jalr	2000(ra) # 8000374c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f84:	08000613          	li	a2,128
    80004f88:	f6040593          	addi	a1,s0,-160
    80004f8c:	4501                	li	a0,0
    80004f8e:	ffffd097          	auipc	ra,0xffffd
    80004f92:	2be080e7          	jalr	702(ra) # 8000224c <argstr>
    80004f96:	04054b63          	bltz	a0,80004fec <sys_chdir+0x86>
    80004f9a:	f6040513          	addi	a0,s0,-160
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	592080e7          	jalr	1426(ra) # 80003530 <namei>
    80004fa6:	84aa                	mv	s1,a0
    80004fa8:	c131                	beqz	a0,80004fec <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004faa:	ffffe097          	auipc	ra,0xffffe
    80004fae:	dd0080e7          	jalr	-560(ra) # 80002d7a <ilock>
  if(ip->type != T_DIR){
    80004fb2:	04449703          	lh	a4,68(s1)
    80004fb6:	4785                	li	a5,1
    80004fb8:	04f71063          	bne	a4,a5,80004ff8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fbc:	8526                	mv	a0,s1
    80004fbe:	ffffe097          	auipc	ra,0xffffe
    80004fc2:	e7e080e7          	jalr	-386(ra) # 80002e3c <iunlock>
  iput(p->cwd);
    80004fc6:	15093503          	ld	a0,336(s2)
    80004fca:	ffffe097          	auipc	ra,0xffffe
    80004fce:	f6a080e7          	jalr	-150(ra) # 80002f34 <iput>
  end_op();
    80004fd2:	ffffe097          	auipc	ra,0xffffe
    80004fd6:	7fa080e7          	jalr	2042(ra) # 800037cc <end_op>
  p->cwd = ip;
    80004fda:	14993823          	sd	s1,336(s2)
  return 0;
    80004fde:	4501                	li	a0,0
}
    80004fe0:	60ea                	ld	ra,152(sp)
    80004fe2:	644a                	ld	s0,144(sp)
    80004fe4:	64aa                	ld	s1,136(sp)
    80004fe6:	690a                	ld	s2,128(sp)
    80004fe8:	610d                	addi	sp,sp,160
    80004fea:	8082                	ret
    end_op();
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	7e0080e7          	jalr	2016(ra) # 800037cc <end_op>
    return -1;
    80004ff4:	557d                	li	a0,-1
    80004ff6:	b7ed                	j	80004fe0 <sys_chdir+0x7a>
    iunlockput(ip);
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	ffffe097          	auipc	ra,0xffffe
    80004ffe:	fe2080e7          	jalr	-30(ra) # 80002fdc <iunlockput>
    end_op();
    80005002:	ffffe097          	auipc	ra,0xffffe
    80005006:	7ca080e7          	jalr	1994(ra) # 800037cc <end_op>
    return -1;
    8000500a:	557d                	li	a0,-1
    8000500c:	bfd1                	j	80004fe0 <sys_chdir+0x7a>

000000008000500e <sys_exec>:

uint64
sys_exec(void)
{
    8000500e:	7145                	addi	sp,sp,-464
    80005010:	e786                	sd	ra,456(sp)
    80005012:	e3a2                	sd	s0,448(sp)
    80005014:	ff26                	sd	s1,440(sp)
    80005016:	fb4a                	sd	s2,432(sp)
    80005018:	f74e                	sd	s3,424(sp)
    8000501a:	f352                	sd	s4,416(sp)
    8000501c:	ef56                	sd	s5,408(sp)
    8000501e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005020:	08000613          	li	a2,128
    80005024:	f4040593          	addi	a1,s0,-192
    80005028:	4501                	li	a0,0
    8000502a:	ffffd097          	auipc	ra,0xffffd
    8000502e:	222080e7          	jalr	546(ra) # 8000224c <argstr>
    return -1;
    80005032:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005034:	0c054a63          	bltz	a0,80005108 <sys_exec+0xfa>
    80005038:	e3840593          	addi	a1,s0,-456
    8000503c:	4505                	li	a0,1
    8000503e:	ffffd097          	auipc	ra,0xffffd
    80005042:	1ec080e7          	jalr	492(ra) # 8000222a <argaddr>
    80005046:	0c054163          	bltz	a0,80005108 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    8000504a:	10000613          	li	a2,256
    8000504e:	4581                	li	a1,0
    80005050:	e4040513          	addi	a0,s0,-448
    80005054:	ffffb097          	auipc	ra,0xffffb
    80005058:	284080e7          	jalr	644(ra) # 800002d8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000505c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005060:	89a6                	mv	s3,s1
    80005062:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005064:	02000a13          	li	s4,32
    80005068:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000506c:	00391513          	slli	a0,s2,0x3
    80005070:	e3040593          	addi	a1,s0,-464
    80005074:	e3843783          	ld	a5,-456(s0)
    80005078:	953e                	add	a0,a0,a5
    8000507a:	ffffd097          	auipc	ra,0xffffd
    8000507e:	0f4080e7          	jalr	244(ra) # 8000216e <fetchaddr>
    80005082:	02054a63          	bltz	a0,800050b6 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005086:	e3043783          	ld	a5,-464(s0)
    8000508a:	c3b9                	beqz	a5,800050d0 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000508c:	ffffb097          	auipc	ra,0xffffb
    80005090:	1da080e7          	jalr	474(ra) # 80000266 <kalloc>
    80005094:	85aa                	mv	a1,a0
    80005096:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000509a:	cd11                	beqz	a0,800050b6 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000509c:	6605                	lui	a2,0x1
    8000509e:	e3043503          	ld	a0,-464(s0)
    800050a2:	ffffd097          	auipc	ra,0xffffd
    800050a6:	11e080e7          	jalr	286(ra) # 800021c0 <fetchstr>
    800050aa:	00054663          	bltz	a0,800050b6 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800050ae:	0905                	addi	s2,s2,1
    800050b0:	09a1                	addi	s3,s3,8
    800050b2:	fb491be3          	bne	s2,s4,80005068 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b6:	10048913          	addi	s2,s1,256
    800050ba:	6088                	ld	a0,0(s1)
    800050bc:	c529                	beqz	a0,80005106 <sys_exec+0xf8>
    kfree(argv[i]);
    800050be:	ffffb097          	auipc	ra,0xffffb
    800050c2:	034080e7          	jalr	52(ra) # 800000f2 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c6:	04a1                	addi	s1,s1,8
    800050c8:	ff2499e3          	bne	s1,s2,800050ba <sys_exec+0xac>
  return -1;
    800050cc:	597d                	li	s2,-1
    800050ce:	a82d                	j	80005108 <sys_exec+0xfa>
      argv[i] = 0;
    800050d0:	0a8e                	slli	s5,s5,0x3
    800050d2:	fc040793          	addi	a5,s0,-64
    800050d6:	9abe                	add	s5,s5,a5
    800050d8:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050dc:	e4040593          	addi	a1,s0,-448
    800050e0:	f4040513          	addi	a0,s0,-192
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	194080e7          	jalr	404(ra) # 80004278 <exec>
    800050ec:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ee:	10048993          	addi	s3,s1,256
    800050f2:	6088                	ld	a0,0(s1)
    800050f4:	c911                	beqz	a0,80005108 <sys_exec+0xfa>
    kfree(argv[i]);
    800050f6:	ffffb097          	auipc	ra,0xffffb
    800050fa:	ffc080e7          	jalr	-4(ra) # 800000f2 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050fe:	04a1                	addi	s1,s1,8
    80005100:	ff3499e3          	bne	s1,s3,800050f2 <sys_exec+0xe4>
    80005104:	a011                	j	80005108 <sys_exec+0xfa>
  return -1;
    80005106:	597d                	li	s2,-1
}
    80005108:	854a                	mv	a0,s2
    8000510a:	60be                	ld	ra,456(sp)
    8000510c:	641e                	ld	s0,448(sp)
    8000510e:	74fa                	ld	s1,440(sp)
    80005110:	795a                	ld	s2,432(sp)
    80005112:	79ba                	ld	s3,424(sp)
    80005114:	7a1a                	ld	s4,416(sp)
    80005116:	6afa                	ld	s5,408(sp)
    80005118:	6179                	addi	sp,sp,464
    8000511a:	8082                	ret

000000008000511c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000511c:	7139                	addi	sp,sp,-64
    8000511e:	fc06                	sd	ra,56(sp)
    80005120:	f822                	sd	s0,48(sp)
    80005122:	f426                	sd	s1,40(sp)
    80005124:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005126:	ffffc097          	auipc	ra,0xffffc
    8000512a:	f34080e7          	jalr	-204(ra) # 8000105a <myproc>
    8000512e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005130:	fd840593          	addi	a1,s0,-40
    80005134:	4501                	li	a0,0
    80005136:	ffffd097          	auipc	ra,0xffffd
    8000513a:	0f4080e7          	jalr	244(ra) # 8000222a <argaddr>
    return -1;
    8000513e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005140:	0e054063          	bltz	a0,80005220 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005144:	fc840593          	addi	a1,s0,-56
    80005148:	fd040513          	addi	a0,s0,-48
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	dfc080e7          	jalr	-516(ra) # 80003f48 <pipealloc>
    return -1;
    80005154:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005156:	0c054563          	bltz	a0,80005220 <sys_pipe+0x104>
  fd0 = -1;
    8000515a:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000515e:	fd043503          	ld	a0,-48(s0)
    80005162:	fffff097          	auipc	ra,0xfffff
    80005166:	508080e7          	jalr	1288(ra) # 8000466a <fdalloc>
    8000516a:	fca42223          	sw	a0,-60(s0)
    8000516e:	08054c63          	bltz	a0,80005206 <sys_pipe+0xea>
    80005172:	fc843503          	ld	a0,-56(s0)
    80005176:	fffff097          	auipc	ra,0xfffff
    8000517a:	4f4080e7          	jalr	1268(ra) # 8000466a <fdalloc>
    8000517e:	fca42023          	sw	a0,-64(s0)
    80005182:	06054863          	bltz	a0,800051f2 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005186:	4691                	li	a3,4
    80005188:	fc440613          	addi	a2,s0,-60
    8000518c:	fd843583          	ld	a1,-40(s0)
    80005190:	68a8                	ld	a0,80(s1)
    80005192:	ffffc097          	auipc	ra,0xffffc
    80005196:	c46080e7          	jalr	-954(ra) # 80000dd8 <copyout>
    8000519a:	02054063          	bltz	a0,800051ba <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000519e:	4691                	li	a3,4
    800051a0:	fc040613          	addi	a2,s0,-64
    800051a4:	fd843583          	ld	a1,-40(s0)
    800051a8:	0591                	addi	a1,a1,4
    800051aa:	68a8                	ld	a0,80(s1)
    800051ac:	ffffc097          	auipc	ra,0xffffc
    800051b0:	c2c080e7          	jalr	-980(ra) # 80000dd8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051b4:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051b6:	06055563          	bgez	a0,80005220 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800051ba:	fc442783          	lw	a5,-60(s0)
    800051be:	07e9                	addi	a5,a5,26
    800051c0:	078e                	slli	a5,a5,0x3
    800051c2:	97a6                	add	a5,a5,s1
    800051c4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051c8:	fc042503          	lw	a0,-64(s0)
    800051cc:	0569                	addi	a0,a0,26
    800051ce:	050e                	slli	a0,a0,0x3
    800051d0:	9526                	add	a0,a0,s1
    800051d2:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800051d6:	fd043503          	ld	a0,-48(s0)
    800051da:	fffff097          	auipc	ra,0xfffff
    800051de:	a3e080e7          	jalr	-1474(ra) # 80003c18 <fileclose>
    fileclose(wf);
    800051e2:	fc843503          	ld	a0,-56(s0)
    800051e6:	fffff097          	auipc	ra,0xfffff
    800051ea:	a32080e7          	jalr	-1486(ra) # 80003c18 <fileclose>
    return -1;
    800051ee:	57fd                	li	a5,-1
    800051f0:	a805                	j	80005220 <sys_pipe+0x104>
    if(fd0 >= 0)
    800051f2:	fc442783          	lw	a5,-60(s0)
    800051f6:	0007c863          	bltz	a5,80005206 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800051fa:	01a78513          	addi	a0,a5,26
    800051fe:	050e                	slli	a0,a0,0x3
    80005200:	9526                	add	a0,a0,s1
    80005202:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005206:	fd043503          	ld	a0,-48(s0)
    8000520a:	fffff097          	auipc	ra,0xfffff
    8000520e:	a0e080e7          	jalr	-1522(ra) # 80003c18 <fileclose>
    fileclose(wf);
    80005212:	fc843503          	ld	a0,-56(s0)
    80005216:	fffff097          	auipc	ra,0xfffff
    8000521a:	a02080e7          	jalr	-1534(ra) # 80003c18 <fileclose>
    return -1;
    8000521e:	57fd                	li	a5,-1
}
    80005220:	853e                	mv	a0,a5
    80005222:	70e2                	ld	ra,56(sp)
    80005224:	7442                	ld	s0,48(sp)
    80005226:	74a2                	ld	s1,40(sp)
    80005228:	6121                	addi	sp,sp,64
    8000522a:	8082                	ret
    8000522c:	0000                	unimp
	...

0000000080005230 <kernelvec>:
    80005230:	7111                	addi	sp,sp,-256
    80005232:	e006                	sd	ra,0(sp)
    80005234:	e40a                	sd	sp,8(sp)
    80005236:	e80e                	sd	gp,16(sp)
    80005238:	ec12                	sd	tp,24(sp)
    8000523a:	f016                	sd	t0,32(sp)
    8000523c:	f41a                	sd	t1,40(sp)
    8000523e:	f81e                	sd	t2,48(sp)
    80005240:	fc22                	sd	s0,56(sp)
    80005242:	e0a6                	sd	s1,64(sp)
    80005244:	e4aa                	sd	a0,72(sp)
    80005246:	e8ae                	sd	a1,80(sp)
    80005248:	ecb2                	sd	a2,88(sp)
    8000524a:	f0b6                	sd	a3,96(sp)
    8000524c:	f4ba                	sd	a4,104(sp)
    8000524e:	f8be                	sd	a5,112(sp)
    80005250:	fcc2                	sd	a6,120(sp)
    80005252:	e146                	sd	a7,128(sp)
    80005254:	e54a                	sd	s2,136(sp)
    80005256:	e94e                	sd	s3,144(sp)
    80005258:	ed52                	sd	s4,152(sp)
    8000525a:	f156                	sd	s5,160(sp)
    8000525c:	f55a                	sd	s6,168(sp)
    8000525e:	f95e                	sd	s7,176(sp)
    80005260:	fd62                	sd	s8,184(sp)
    80005262:	e1e6                	sd	s9,192(sp)
    80005264:	e5ea                	sd	s10,200(sp)
    80005266:	e9ee                	sd	s11,208(sp)
    80005268:	edf2                	sd	t3,216(sp)
    8000526a:	f1f6                	sd	t4,224(sp)
    8000526c:	f5fa                	sd	t5,232(sp)
    8000526e:	f9fe                	sd	t6,240(sp)
    80005270:	dcbfc0ef          	jal	ra,8000203a <kerneltrap>
    80005274:	6082                	ld	ra,0(sp)
    80005276:	6122                	ld	sp,8(sp)
    80005278:	61c2                	ld	gp,16(sp)
    8000527a:	7282                	ld	t0,32(sp)
    8000527c:	7322                	ld	t1,40(sp)
    8000527e:	73c2                	ld	t2,48(sp)
    80005280:	7462                	ld	s0,56(sp)
    80005282:	6486                	ld	s1,64(sp)
    80005284:	6526                	ld	a0,72(sp)
    80005286:	65c6                	ld	a1,80(sp)
    80005288:	6666                	ld	a2,88(sp)
    8000528a:	7686                	ld	a3,96(sp)
    8000528c:	7726                	ld	a4,104(sp)
    8000528e:	77c6                	ld	a5,112(sp)
    80005290:	7866                	ld	a6,120(sp)
    80005292:	688a                	ld	a7,128(sp)
    80005294:	692a                	ld	s2,136(sp)
    80005296:	69ca                	ld	s3,144(sp)
    80005298:	6a6a                	ld	s4,152(sp)
    8000529a:	7a8a                	ld	s5,160(sp)
    8000529c:	7b2a                	ld	s6,168(sp)
    8000529e:	7bca                	ld	s7,176(sp)
    800052a0:	7c6a                	ld	s8,184(sp)
    800052a2:	6c8e                	ld	s9,192(sp)
    800052a4:	6d2e                	ld	s10,200(sp)
    800052a6:	6dce                	ld	s11,208(sp)
    800052a8:	6e6e                	ld	t3,216(sp)
    800052aa:	7e8e                	ld	t4,224(sp)
    800052ac:	7f2e                	ld	t5,232(sp)
    800052ae:	7fce                	ld	t6,240(sp)
    800052b0:	6111                	addi	sp,sp,256
    800052b2:	10200073          	sret
    800052b6:	00000013          	nop
    800052ba:	00000013          	nop
    800052be:	0001                	nop

00000000800052c0 <timervec>:
    800052c0:	34051573          	csrrw	a0,mscratch,a0
    800052c4:	e10c                	sd	a1,0(a0)
    800052c6:	e510                	sd	a2,8(a0)
    800052c8:	e914                	sd	a3,16(a0)
    800052ca:	6d0c                	ld	a1,24(a0)
    800052cc:	7110                	ld	a2,32(a0)
    800052ce:	6194                	ld	a3,0(a1)
    800052d0:	96b2                	add	a3,a3,a2
    800052d2:	e194                	sd	a3,0(a1)
    800052d4:	4589                	li	a1,2
    800052d6:	14459073          	csrw	sip,a1
    800052da:	6914                	ld	a3,16(a0)
    800052dc:	6510                	ld	a2,8(a0)
    800052de:	610c                	ld	a1,0(a0)
    800052e0:	34051573          	csrrw	a0,mscratch,a0
    800052e4:	30200073          	mret
	...

00000000800052ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ea:	1141                	addi	sp,sp,-16
    800052ec:	e422                	sd	s0,8(sp)
    800052ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052f0:	0c0007b7          	lui	a5,0xc000
    800052f4:	4705                	li	a4,1
    800052f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052f8:	c3d8                	sw	a4,4(a5)
}
    800052fa:	6422                	ld	s0,8(sp)
    800052fc:	0141                	addi	sp,sp,16
    800052fe:	8082                	ret

0000000080005300 <plicinithart>:

void
plicinithart(void)
{
    80005300:	1141                	addi	sp,sp,-16
    80005302:	e406                	sd	ra,8(sp)
    80005304:	e022                	sd	s0,0(sp)
    80005306:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	d26080e7          	jalr	-730(ra) # 8000102e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005310:	0085171b          	slliw	a4,a0,0x8
    80005314:	0c0027b7          	lui	a5,0xc002
    80005318:	97ba                	add	a5,a5,a4
    8000531a:	40200713          	li	a4,1026
    8000531e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005322:	00d5151b          	slliw	a0,a0,0xd
    80005326:	0c2017b7          	lui	a5,0xc201
    8000532a:	953e                	add	a0,a0,a5
    8000532c:	00052023          	sw	zero,0(a0)
}
    80005330:	60a2                	ld	ra,8(sp)
    80005332:	6402                	ld	s0,0(sp)
    80005334:	0141                	addi	sp,sp,16
    80005336:	8082                	ret

0000000080005338 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005338:	1141                	addi	sp,sp,-16
    8000533a:	e406                	sd	ra,8(sp)
    8000533c:	e022                	sd	s0,0(sp)
    8000533e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005340:	ffffc097          	auipc	ra,0xffffc
    80005344:	cee080e7          	jalr	-786(ra) # 8000102e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005348:	00d5179b          	slliw	a5,a0,0xd
    8000534c:	0c201537          	lui	a0,0xc201
    80005350:	953e                	add	a0,a0,a5
  return irq;
}
    80005352:	4148                	lw	a0,4(a0)
    80005354:	60a2                	ld	ra,8(sp)
    80005356:	6402                	ld	s0,0(sp)
    80005358:	0141                	addi	sp,sp,16
    8000535a:	8082                	ret

000000008000535c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000535c:	1101                	addi	sp,sp,-32
    8000535e:	ec06                	sd	ra,24(sp)
    80005360:	e822                	sd	s0,16(sp)
    80005362:	e426                	sd	s1,8(sp)
    80005364:	1000                	addi	s0,sp,32
    80005366:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	cc6080e7          	jalr	-826(ra) # 8000102e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005370:	00d5151b          	slliw	a0,a0,0xd
    80005374:	0c2017b7          	lui	a5,0xc201
    80005378:	97aa                	add	a5,a5,a0
    8000537a:	c3c4                	sw	s1,4(a5)
}
    8000537c:	60e2                	ld	ra,24(sp)
    8000537e:	6442                	ld	s0,16(sp)
    80005380:	64a2                	ld	s1,8(sp)
    80005382:	6105                	addi	sp,sp,32
    80005384:	8082                	ret

0000000080005386 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005386:	1141                	addi	sp,sp,-16
    80005388:	e406                	sd	ra,8(sp)
    8000538a:	e022                	sd	s0,0(sp)
    8000538c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000538e:	479d                	li	a5,7
    80005390:	06a7c963          	blt	a5,a0,80005402 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005394:	00236797          	auipc	a5,0x236
    80005398:	c6c78793          	addi	a5,a5,-916 # 8023b000 <disk>
    8000539c:	00a78733          	add	a4,a5,a0
    800053a0:	6789                	lui	a5,0x2
    800053a2:	97ba                	add	a5,a5,a4
    800053a4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800053a8:	e7ad                	bnez	a5,80005412 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053aa:	00451793          	slli	a5,a0,0x4
    800053ae:	00238717          	auipc	a4,0x238
    800053b2:	c5270713          	addi	a4,a4,-942 # 8023d000 <disk+0x2000>
    800053b6:	6314                	ld	a3,0(a4)
    800053b8:	96be                	add	a3,a3,a5
    800053ba:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053be:	6314                	ld	a3,0(a4)
    800053c0:	96be                	add	a3,a3,a5
    800053c2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800053c6:	6314                	ld	a3,0(a4)
    800053c8:	96be                	add	a3,a3,a5
    800053ca:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800053ce:	6318                	ld	a4,0(a4)
    800053d0:	97ba                	add	a5,a5,a4
    800053d2:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800053d6:	00236797          	auipc	a5,0x236
    800053da:	c2a78793          	addi	a5,a5,-982 # 8023b000 <disk>
    800053de:	97aa                	add	a5,a5,a0
    800053e0:	6509                	lui	a0,0x2
    800053e2:	953e                	add	a0,a0,a5
    800053e4:	4785                	li	a5,1
    800053e6:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800053ea:	00238517          	auipc	a0,0x238
    800053ee:	c2e50513          	addi	a0,a0,-978 # 8023d018 <disk+0x2018>
    800053f2:	ffffc097          	auipc	ra,0xffffc
    800053f6:	4b0080e7          	jalr	1200(ra) # 800018a2 <wakeup>
}
    800053fa:	60a2                	ld	ra,8(sp)
    800053fc:	6402                	ld	s0,0(sp)
    800053fe:	0141                	addi	sp,sp,16
    80005400:	8082                	ret
    panic("free_desc 1");
    80005402:	00003517          	auipc	a0,0x3
    80005406:	35650513          	addi	a0,a0,854 # 80008758 <syscalls+0x320>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	a1e080e7          	jalr	-1506(ra) # 80005e28 <panic>
    panic("free_desc 2");
    80005412:	00003517          	auipc	a0,0x3
    80005416:	35650513          	addi	a0,a0,854 # 80008768 <syscalls+0x330>
    8000541a:	00001097          	auipc	ra,0x1
    8000541e:	a0e080e7          	jalr	-1522(ra) # 80005e28 <panic>

0000000080005422 <virtio_disk_init>:
{
    80005422:	1101                	addi	sp,sp,-32
    80005424:	ec06                	sd	ra,24(sp)
    80005426:	e822                	sd	s0,16(sp)
    80005428:	e426                	sd	s1,8(sp)
    8000542a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000542c:	00003597          	auipc	a1,0x3
    80005430:	34c58593          	addi	a1,a1,844 # 80008778 <syscalls+0x340>
    80005434:	00238517          	auipc	a0,0x238
    80005438:	cf450513          	addi	a0,a0,-780 # 8023d128 <disk+0x2128>
    8000543c:	00001097          	auipc	ra,0x1
    80005440:	ea6080e7          	jalr	-346(ra) # 800062e2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005444:	100017b7          	lui	a5,0x10001
    80005448:	4398                	lw	a4,0(a5)
    8000544a:	2701                	sext.w	a4,a4
    8000544c:	747277b7          	lui	a5,0x74727
    80005450:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005454:	0ef71163          	bne	a4,a5,80005536 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005458:	100017b7          	lui	a5,0x10001
    8000545c:	43dc                	lw	a5,4(a5)
    8000545e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005460:	4705                	li	a4,1
    80005462:	0ce79a63          	bne	a5,a4,80005536 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005466:	100017b7          	lui	a5,0x10001
    8000546a:	479c                	lw	a5,8(a5)
    8000546c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000546e:	4709                	li	a4,2
    80005470:	0ce79363          	bne	a5,a4,80005536 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005474:	100017b7          	lui	a5,0x10001
    80005478:	47d8                	lw	a4,12(a5)
    8000547a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000547c:	554d47b7          	lui	a5,0x554d4
    80005480:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005484:	0af71963          	bne	a4,a5,80005536 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005488:	100017b7          	lui	a5,0x10001
    8000548c:	4705                	li	a4,1
    8000548e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005490:	470d                	li	a4,3
    80005492:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005494:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005496:	c7ffe737          	lui	a4,0xc7ffe
    8000549a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47db851f>
    8000549e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054a0:	2701                	sext.w	a4,a4
    800054a2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a4:	472d                	li	a4,11
    800054a6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a8:	473d                	li	a4,15
    800054aa:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800054ac:	6705                	lui	a4,0x1
    800054ae:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054b0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054b4:	5bdc                	lw	a5,52(a5)
    800054b6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054b8:	c7d9                	beqz	a5,80005546 <virtio_disk_init+0x124>
  if(max < NUM)
    800054ba:	471d                	li	a4,7
    800054bc:	08f77d63          	bgeu	a4,a5,80005556 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800054c0:	100014b7          	lui	s1,0x10001
    800054c4:	47a1                	li	a5,8
    800054c6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800054c8:	6609                	lui	a2,0x2
    800054ca:	4581                	li	a1,0
    800054cc:	00236517          	auipc	a0,0x236
    800054d0:	b3450513          	addi	a0,a0,-1228 # 8023b000 <disk>
    800054d4:	ffffb097          	auipc	ra,0xffffb
    800054d8:	e04080e7          	jalr	-508(ra) # 800002d8 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800054dc:	00236717          	auipc	a4,0x236
    800054e0:	b2470713          	addi	a4,a4,-1244 # 8023b000 <disk>
    800054e4:	00c75793          	srli	a5,a4,0xc
    800054e8:	2781                	sext.w	a5,a5
    800054ea:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    800054ec:	00238797          	auipc	a5,0x238
    800054f0:	b1478793          	addi	a5,a5,-1260 # 8023d000 <disk+0x2000>
    800054f4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800054f6:	00236717          	auipc	a4,0x236
    800054fa:	b8a70713          	addi	a4,a4,-1142 # 8023b080 <disk+0x80>
    800054fe:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005500:	00237717          	auipc	a4,0x237
    80005504:	b0070713          	addi	a4,a4,-1280 # 8023c000 <disk+0x1000>
    80005508:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000550a:	4705                	li	a4,1
    8000550c:	00e78c23          	sb	a4,24(a5)
    80005510:	00e78ca3          	sb	a4,25(a5)
    80005514:	00e78d23          	sb	a4,26(a5)
    80005518:	00e78da3          	sb	a4,27(a5)
    8000551c:	00e78e23          	sb	a4,28(a5)
    80005520:	00e78ea3          	sb	a4,29(a5)
    80005524:	00e78f23          	sb	a4,30(a5)
    80005528:	00e78fa3          	sb	a4,31(a5)
}
    8000552c:	60e2                	ld	ra,24(sp)
    8000552e:	6442                	ld	s0,16(sp)
    80005530:	64a2                	ld	s1,8(sp)
    80005532:	6105                	addi	sp,sp,32
    80005534:	8082                	ret
    panic("could not find virtio disk");
    80005536:	00003517          	auipc	a0,0x3
    8000553a:	25250513          	addi	a0,a0,594 # 80008788 <syscalls+0x350>
    8000553e:	00001097          	auipc	ra,0x1
    80005542:	8ea080e7          	jalr	-1814(ra) # 80005e28 <panic>
    panic("virtio disk has no queue 0");
    80005546:	00003517          	auipc	a0,0x3
    8000554a:	26250513          	addi	a0,a0,610 # 800087a8 <syscalls+0x370>
    8000554e:	00001097          	auipc	ra,0x1
    80005552:	8da080e7          	jalr	-1830(ra) # 80005e28 <panic>
    panic("virtio disk max queue too short");
    80005556:	00003517          	auipc	a0,0x3
    8000555a:	27250513          	addi	a0,a0,626 # 800087c8 <syscalls+0x390>
    8000555e:	00001097          	auipc	ra,0x1
    80005562:	8ca080e7          	jalr	-1846(ra) # 80005e28 <panic>

0000000080005566 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005566:	7159                	addi	sp,sp,-112
    80005568:	f486                	sd	ra,104(sp)
    8000556a:	f0a2                	sd	s0,96(sp)
    8000556c:	eca6                	sd	s1,88(sp)
    8000556e:	e8ca                	sd	s2,80(sp)
    80005570:	e4ce                	sd	s3,72(sp)
    80005572:	e0d2                	sd	s4,64(sp)
    80005574:	fc56                	sd	s5,56(sp)
    80005576:	f85a                	sd	s6,48(sp)
    80005578:	f45e                	sd	s7,40(sp)
    8000557a:	f062                	sd	s8,32(sp)
    8000557c:	ec66                	sd	s9,24(sp)
    8000557e:	e86a                	sd	s10,16(sp)
    80005580:	1880                	addi	s0,sp,112
    80005582:	892a                	mv	s2,a0
    80005584:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005586:	00c52c83          	lw	s9,12(a0)
    8000558a:	001c9c9b          	slliw	s9,s9,0x1
    8000558e:	1c82                	slli	s9,s9,0x20
    80005590:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005594:	00238517          	auipc	a0,0x238
    80005598:	b9450513          	addi	a0,a0,-1132 # 8023d128 <disk+0x2128>
    8000559c:	00001097          	auipc	ra,0x1
    800055a0:	dd6080e7          	jalr	-554(ra) # 80006372 <acquire>
  for(int i = 0; i < 3; i++){
    800055a4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800055a6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800055a8:	00236b97          	auipc	s7,0x236
    800055ac:	a58b8b93          	addi	s7,s7,-1448 # 8023b000 <disk>
    800055b0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800055b2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800055b4:	8a4e                	mv	s4,s3
    800055b6:	a051                	j	8000563a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800055b8:	00fb86b3          	add	a3,s7,a5
    800055bc:	96da                	add	a3,a3,s6
    800055be:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800055c2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800055c4:	0207c563          	bltz	a5,800055ee <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800055c8:	2485                	addiw	s1,s1,1
    800055ca:	0711                	addi	a4,a4,4
    800055cc:	25548063          	beq	s1,s5,8000580c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    800055d0:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800055d2:	00238697          	auipc	a3,0x238
    800055d6:	a4668693          	addi	a3,a3,-1466 # 8023d018 <disk+0x2018>
    800055da:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800055dc:	0006c583          	lbu	a1,0(a3)
    800055e0:	fde1                	bnez	a1,800055b8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    800055e2:	2785                	addiw	a5,a5,1
    800055e4:	0685                	addi	a3,a3,1
    800055e6:	ff879be3          	bne	a5,s8,800055dc <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    800055ea:	57fd                	li	a5,-1
    800055ec:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800055ee:	02905a63          	blez	s1,80005622 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    800055f2:	f9042503          	lw	a0,-112(s0)
    800055f6:	00000097          	auipc	ra,0x0
    800055fa:	d90080e7          	jalr	-624(ra) # 80005386 <free_desc>
      for(int j = 0; j < i; j++)
    800055fe:	4785                	li	a5,1
    80005600:	0297d163          	bge	a5,s1,80005622 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005604:	f9442503          	lw	a0,-108(s0)
    80005608:	00000097          	auipc	ra,0x0
    8000560c:	d7e080e7          	jalr	-642(ra) # 80005386 <free_desc>
      for(int j = 0; j < i; j++)
    80005610:	4789                	li	a5,2
    80005612:	0097d863          	bge	a5,s1,80005622 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005616:	f9842503          	lw	a0,-104(s0)
    8000561a:	00000097          	auipc	ra,0x0
    8000561e:	d6c080e7          	jalr	-660(ra) # 80005386 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005622:	00238597          	auipc	a1,0x238
    80005626:	b0658593          	addi	a1,a1,-1274 # 8023d128 <disk+0x2128>
    8000562a:	00238517          	auipc	a0,0x238
    8000562e:	9ee50513          	addi	a0,a0,-1554 # 8023d018 <disk+0x2018>
    80005632:	ffffc097          	auipc	ra,0xffffc
    80005636:	0e4080e7          	jalr	228(ra) # 80001716 <sleep>
  for(int i = 0; i < 3; i++){
    8000563a:	f9040713          	addi	a4,s0,-112
    8000563e:	84ce                	mv	s1,s3
    80005640:	bf41                	j	800055d0 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005642:	20058713          	addi	a4,a1,512
    80005646:	00471693          	slli	a3,a4,0x4
    8000564a:	00236717          	auipc	a4,0x236
    8000564e:	9b670713          	addi	a4,a4,-1610 # 8023b000 <disk>
    80005652:	9736                	add	a4,a4,a3
    80005654:	4685                	li	a3,1
    80005656:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000565a:	20058713          	addi	a4,a1,512
    8000565e:	00471693          	slli	a3,a4,0x4
    80005662:	00236717          	auipc	a4,0x236
    80005666:	99e70713          	addi	a4,a4,-1634 # 8023b000 <disk>
    8000566a:	9736                	add	a4,a4,a3
    8000566c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80005670:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005674:	7679                	lui	a2,0xffffe
    80005676:	963e                	add	a2,a2,a5
    80005678:	00238697          	auipc	a3,0x238
    8000567c:	98868693          	addi	a3,a3,-1656 # 8023d000 <disk+0x2000>
    80005680:	6298                	ld	a4,0(a3)
    80005682:	9732                	add	a4,a4,a2
    80005684:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005686:	6298                	ld	a4,0(a3)
    80005688:	9732                	add	a4,a4,a2
    8000568a:	4541                	li	a0,16
    8000568c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000568e:	6298                	ld	a4,0(a3)
    80005690:	9732                	add	a4,a4,a2
    80005692:	4505                	li	a0,1
    80005694:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005698:	f9442703          	lw	a4,-108(s0)
    8000569c:	6288                	ld	a0,0(a3)
    8000569e:	962a                	add	a2,a2,a0
    800056a0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7fdb7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800056a4:	0712                	slli	a4,a4,0x4
    800056a6:	6290                	ld	a2,0(a3)
    800056a8:	963a                	add	a2,a2,a4
    800056aa:	05890513          	addi	a0,s2,88
    800056ae:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800056b0:	6294                	ld	a3,0(a3)
    800056b2:	96ba                	add	a3,a3,a4
    800056b4:	40000613          	li	a2,1024
    800056b8:	c690                	sw	a2,8(a3)
  if(write)
    800056ba:	140d0063          	beqz	s10,800057fa <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800056be:	00238697          	auipc	a3,0x238
    800056c2:	9426b683          	ld	a3,-1726(a3) # 8023d000 <disk+0x2000>
    800056c6:	96ba                	add	a3,a3,a4
    800056c8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800056cc:	00236817          	auipc	a6,0x236
    800056d0:	93480813          	addi	a6,a6,-1740 # 8023b000 <disk>
    800056d4:	00238517          	auipc	a0,0x238
    800056d8:	92c50513          	addi	a0,a0,-1748 # 8023d000 <disk+0x2000>
    800056dc:	6114                	ld	a3,0(a0)
    800056de:	96ba                	add	a3,a3,a4
    800056e0:	00c6d603          	lhu	a2,12(a3)
    800056e4:	00166613          	ori	a2,a2,1
    800056e8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800056ec:	f9842683          	lw	a3,-104(s0)
    800056f0:	6110                	ld	a2,0(a0)
    800056f2:	9732                	add	a4,a4,a2
    800056f4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800056f8:	20058613          	addi	a2,a1,512
    800056fc:	0612                	slli	a2,a2,0x4
    800056fe:	9642                	add	a2,a2,a6
    80005700:	577d                	li	a4,-1
    80005702:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005706:	00469713          	slli	a4,a3,0x4
    8000570a:	6114                	ld	a3,0(a0)
    8000570c:	96ba                	add	a3,a3,a4
    8000570e:	03078793          	addi	a5,a5,48
    80005712:	97c2                	add	a5,a5,a6
    80005714:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005716:	611c                	ld	a5,0(a0)
    80005718:	97ba                	add	a5,a5,a4
    8000571a:	4685                	li	a3,1
    8000571c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000571e:	611c                	ld	a5,0(a0)
    80005720:	97ba                	add	a5,a5,a4
    80005722:	4809                	li	a6,2
    80005724:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005728:	611c                	ld	a5,0(a0)
    8000572a:	973e                	add	a4,a4,a5
    8000572c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005730:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005734:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005738:	6518                	ld	a4,8(a0)
    8000573a:	00275783          	lhu	a5,2(a4)
    8000573e:	8b9d                	andi	a5,a5,7
    80005740:	0786                	slli	a5,a5,0x1
    80005742:	97ba                	add	a5,a5,a4
    80005744:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005748:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000574c:	6518                	ld	a4,8(a0)
    8000574e:	00275783          	lhu	a5,2(a4)
    80005752:	2785                	addiw	a5,a5,1
    80005754:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005758:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000575c:	100017b7          	lui	a5,0x10001
    80005760:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005764:	00492703          	lw	a4,4(s2)
    80005768:	4785                	li	a5,1
    8000576a:	02f71163          	bne	a4,a5,8000578c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000576e:	00238997          	auipc	s3,0x238
    80005772:	9ba98993          	addi	s3,s3,-1606 # 8023d128 <disk+0x2128>
  while(b->disk == 1) {
    80005776:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005778:	85ce                	mv	a1,s3
    8000577a:	854a                	mv	a0,s2
    8000577c:	ffffc097          	auipc	ra,0xffffc
    80005780:	f9a080e7          	jalr	-102(ra) # 80001716 <sleep>
  while(b->disk == 1) {
    80005784:	00492783          	lw	a5,4(s2)
    80005788:	fe9788e3          	beq	a5,s1,80005778 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000578c:	f9042903          	lw	s2,-112(s0)
    80005790:	20090793          	addi	a5,s2,512
    80005794:	00479713          	slli	a4,a5,0x4
    80005798:	00236797          	auipc	a5,0x236
    8000579c:	86878793          	addi	a5,a5,-1944 # 8023b000 <disk>
    800057a0:	97ba                	add	a5,a5,a4
    800057a2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800057a6:	00238997          	auipc	s3,0x238
    800057aa:	85a98993          	addi	s3,s3,-1958 # 8023d000 <disk+0x2000>
    800057ae:	00491713          	slli	a4,s2,0x4
    800057b2:	0009b783          	ld	a5,0(s3)
    800057b6:	97ba                	add	a5,a5,a4
    800057b8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057bc:	854a                	mv	a0,s2
    800057be:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057c2:	00000097          	auipc	ra,0x0
    800057c6:	bc4080e7          	jalr	-1084(ra) # 80005386 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057ca:	8885                	andi	s1,s1,1
    800057cc:	f0ed                	bnez	s1,800057ae <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057ce:	00238517          	auipc	a0,0x238
    800057d2:	95a50513          	addi	a0,a0,-1702 # 8023d128 <disk+0x2128>
    800057d6:	00001097          	auipc	ra,0x1
    800057da:	c50080e7          	jalr	-944(ra) # 80006426 <release>
}
    800057de:	70a6                	ld	ra,104(sp)
    800057e0:	7406                	ld	s0,96(sp)
    800057e2:	64e6                	ld	s1,88(sp)
    800057e4:	6946                	ld	s2,80(sp)
    800057e6:	69a6                	ld	s3,72(sp)
    800057e8:	6a06                	ld	s4,64(sp)
    800057ea:	7ae2                	ld	s5,56(sp)
    800057ec:	7b42                	ld	s6,48(sp)
    800057ee:	7ba2                	ld	s7,40(sp)
    800057f0:	7c02                	ld	s8,32(sp)
    800057f2:	6ce2                	ld	s9,24(sp)
    800057f4:	6d42                	ld	s10,16(sp)
    800057f6:	6165                	addi	sp,sp,112
    800057f8:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800057fa:	00238697          	auipc	a3,0x238
    800057fe:	8066b683          	ld	a3,-2042(a3) # 8023d000 <disk+0x2000>
    80005802:	96ba                	add	a3,a3,a4
    80005804:	4609                	li	a2,2
    80005806:	00c69623          	sh	a2,12(a3)
    8000580a:	b5c9                	j	800056cc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000580c:	f9042583          	lw	a1,-112(s0)
    80005810:	20058793          	addi	a5,a1,512
    80005814:	0792                	slli	a5,a5,0x4
    80005816:	00236517          	auipc	a0,0x236
    8000581a:	89250513          	addi	a0,a0,-1902 # 8023b0a8 <disk+0xa8>
    8000581e:	953e                	add	a0,a0,a5
  if(write)
    80005820:	e20d11e3          	bnez	s10,80005642 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005824:	20058713          	addi	a4,a1,512
    80005828:	00471693          	slli	a3,a4,0x4
    8000582c:	00235717          	auipc	a4,0x235
    80005830:	7d470713          	addi	a4,a4,2004 # 8023b000 <disk>
    80005834:	9736                	add	a4,a4,a3
    80005836:	0a072423          	sw	zero,168(a4)
    8000583a:	b505                	j	8000565a <virtio_disk_rw+0xf4>

000000008000583c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000583c:	1101                	addi	sp,sp,-32
    8000583e:	ec06                	sd	ra,24(sp)
    80005840:	e822                	sd	s0,16(sp)
    80005842:	e426                	sd	s1,8(sp)
    80005844:	e04a                	sd	s2,0(sp)
    80005846:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005848:	00238517          	auipc	a0,0x238
    8000584c:	8e050513          	addi	a0,a0,-1824 # 8023d128 <disk+0x2128>
    80005850:	00001097          	auipc	ra,0x1
    80005854:	b22080e7          	jalr	-1246(ra) # 80006372 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005858:	10001737          	lui	a4,0x10001
    8000585c:	533c                	lw	a5,96(a4)
    8000585e:	8b8d                	andi	a5,a5,3
    80005860:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005862:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005866:	00237797          	auipc	a5,0x237
    8000586a:	79a78793          	addi	a5,a5,1946 # 8023d000 <disk+0x2000>
    8000586e:	6b94                	ld	a3,16(a5)
    80005870:	0207d703          	lhu	a4,32(a5)
    80005874:	0026d783          	lhu	a5,2(a3)
    80005878:	06f70163          	beq	a4,a5,800058da <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000587c:	00235917          	auipc	s2,0x235
    80005880:	78490913          	addi	s2,s2,1924 # 8023b000 <disk>
    80005884:	00237497          	auipc	s1,0x237
    80005888:	77c48493          	addi	s1,s1,1916 # 8023d000 <disk+0x2000>
    __sync_synchronize();
    8000588c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005890:	6898                	ld	a4,16(s1)
    80005892:	0204d783          	lhu	a5,32(s1)
    80005896:	8b9d                	andi	a5,a5,7
    80005898:	078e                	slli	a5,a5,0x3
    8000589a:	97ba                	add	a5,a5,a4
    8000589c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000589e:	20078713          	addi	a4,a5,512
    800058a2:	0712                	slli	a4,a4,0x4
    800058a4:	974a                	add	a4,a4,s2
    800058a6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800058aa:	e731                	bnez	a4,800058f6 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800058ac:	20078793          	addi	a5,a5,512
    800058b0:	0792                	slli	a5,a5,0x4
    800058b2:	97ca                	add	a5,a5,s2
    800058b4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800058b6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800058ba:	ffffc097          	auipc	ra,0xffffc
    800058be:	fe8080e7          	jalr	-24(ra) # 800018a2 <wakeup>

    disk.used_idx += 1;
    800058c2:	0204d783          	lhu	a5,32(s1)
    800058c6:	2785                	addiw	a5,a5,1
    800058c8:	17c2                	slli	a5,a5,0x30
    800058ca:	93c1                	srli	a5,a5,0x30
    800058cc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058d0:	6898                	ld	a4,16(s1)
    800058d2:	00275703          	lhu	a4,2(a4)
    800058d6:	faf71be3          	bne	a4,a5,8000588c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800058da:	00238517          	auipc	a0,0x238
    800058de:	84e50513          	addi	a0,a0,-1970 # 8023d128 <disk+0x2128>
    800058e2:	00001097          	auipc	ra,0x1
    800058e6:	b44080e7          	jalr	-1212(ra) # 80006426 <release>
}
    800058ea:	60e2                	ld	ra,24(sp)
    800058ec:	6442                	ld	s0,16(sp)
    800058ee:	64a2                	ld	s1,8(sp)
    800058f0:	6902                	ld	s2,0(sp)
    800058f2:	6105                	addi	sp,sp,32
    800058f4:	8082                	ret
      panic("virtio_disk_intr status");
    800058f6:	00003517          	auipc	a0,0x3
    800058fa:	ef250513          	addi	a0,a0,-270 # 800087e8 <syscalls+0x3b0>
    800058fe:	00000097          	auipc	ra,0x0
    80005902:	52a080e7          	jalr	1322(ra) # 80005e28 <panic>

0000000080005906 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005906:	1141                	addi	sp,sp,-16
    80005908:	e422                	sd	s0,8(sp)
    8000590a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000590c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005910:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005914:	0037979b          	slliw	a5,a5,0x3
    80005918:	02004737          	lui	a4,0x2004
    8000591c:	97ba                	add	a5,a5,a4
    8000591e:	0200c737          	lui	a4,0x200c
    80005922:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005926:	000f4637          	lui	a2,0xf4
    8000592a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000592e:	95b2                	add	a1,a1,a2
    80005930:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005932:	00269713          	slli	a4,a3,0x2
    80005936:	9736                	add	a4,a4,a3
    80005938:	00371693          	slli	a3,a4,0x3
    8000593c:	00238717          	auipc	a4,0x238
    80005940:	6c470713          	addi	a4,a4,1732 # 8023e000 <timer_scratch>
    80005944:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005946:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005948:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000594a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000594e:	00000797          	auipc	a5,0x0
    80005952:	97278793          	addi	a5,a5,-1678 # 800052c0 <timervec>
    80005956:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000595a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000595e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005962:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005966:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000596a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000596e:	30479073          	csrw	mie,a5
}
    80005972:	6422                	ld	s0,8(sp)
    80005974:	0141                	addi	sp,sp,16
    80005976:	8082                	ret

0000000080005978 <start>:
{
    80005978:	1141                	addi	sp,sp,-16
    8000597a:	e406                	sd	ra,8(sp)
    8000597c:	e022                	sd	s0,0(sp)
    8000597e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005980:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005984:	7779                	lui	a4,0xffffe
    80005986:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb85bf>
    8000598a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000598c:	6705                	lui	a4,0x1
    8000598e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005992:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005994:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005998:	ffffb797          	auipc	a5,0xffffb
    8000599c:	aee78793          	addi	a5,a5,-1298 # 80000486 <main>
    800059a0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059a4:	4781                	li	a5,0
    800059a6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059aa:	67c1                	lui	a5,0x10
    800059ac:	17fd                	addi	a5,a5,-1
    800059ae:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800059b2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800059b6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800059ba:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800059be:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800059c2:	57fd                	li	a5,-1
    800059c4:	83a9                	srli	a5,a5,0xa
    800059c6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800059ca:	47bd                	li	a5,15
    800059cc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059d0:	00000097          	auipc	ra,0x0
    800059d4:	f36080e7          	jalr	-202(ra) # 80005906 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059dc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059de:	823e                	mv	tp,a5
  asm volatile("mret");
    800059e0:	30200073          	mret
}
    800059e4:	60a2                	ld	ra,8(sp)
    800059e6:	6402                	ld	s0,0(sp)
    800059e8:	0141                	addi	sp,sp,16
    800059ea:	8082                	ret

00000000800059ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059ec:	715d                	addi	sp,sp,-80
    800059ee:	e486                	sd	ra,72(sp)
    800059f0:	e0a2                	sd	s0,64(sp)
    800059f2:	fc26                	sd	s1,56(sp)
    800059f4:	f84a                	sd	s2,48(sp)
    800059f6:	f44e                	sd	s3,40(sp)
    800059f8:	f052                	sd	s4,32(sp)
    800059fa:	ec56                	sd	s5,24(sp)
    800059fc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059fe:	04c05663          	blez	a2,80005a4a <consolewrite+0x5e>
    80005a02:	8a2a                	mv	s4,a0
    80005a04:	84ae                	mv	s1,a1
    80005a06:	89b2                	mv	s3,a2
    80005a08:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a0a:	5afd                	li	s5,-1
    80005a0c:	4685                	li	a3,1
    80005a0e:	8626                	mv	a2,s1
    80005a10:	85d2                	mv	a1,s4
    80005a12:	fbf40513          	addi	a0,s0,-65
    80005a16:	ffffc097          	auipc	ra,0xffffc
    80005a1a:	0fa080e7          	jalr	250(ra) # 80001b10 <either_copyin>
    80005a1e:	01550c63          	beq	a0,s5,80005a36 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a22:	fbf44503          	lbu	a0,-65(s0)
    80005a26:	00000097          	auipc	ra,0x0
    80005a2a:	78e080e7          	jalr	1934(ra) # 800061b4 <uartputc>
  for(i = 0; i < n; i++){
    80005a2e:	2905                	addiw	s2,s2,1
    80005a30:	0485                	addi	s1,s1,1
    80005a32:	fd299de3          	bne	s3,s2,80005a0c <consolewrite+0x20>
  }

  return i;
}
    80005a36:	854a                	mv	a0,s2
    80005a38:	60a6                	ld	ra,72(sp)
    80005a3a:	6406                	ld	s0,64(sp)
    80005a3c:	74e2                	ld	s1,56(sp)
    80005a3e:	7942                	ld	s2,48(sp)
    80005a40:	79a2                	ld	s3,40(sp)
    80005a42:	7a02                	ld	s4,32(sp)
    80005a44:	6ae2                	ld	s5,24(sp)
    80005a46:	6161                	addi	sp,sp,80
    80005a48:	8082                	ret
  for(i = 0; i < n; i++){
    80005a4a:	4901                	li	s2,0
    80005a4c:	b7ed                	j	80005a36 <consolewrite+0x4a>

0000000080005a4e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a4e:	7119                	addi	sp,sp,-128
    80005a50:	fc86                	sd	ra,120(sp)
    80005a52:	f8a2                	sd	s0,112(sp)
    80005a54:	f4a6                	sd	s1,104(sp)
    80005a56:	f0ca                	sd	s2,96(sp)
    80005a58:	ecce                	sd	s3,88(sp)
    80005a5a:	e8d2                	sd	s4,80(sp)
    80005a5c:	e4d6                	sd	s5,72(sp)
    80005a5e:	e0da                	sd	s6,64(sp)
    80005a60:	fc5e                	sd	s7,56(sp)
    80005a62:	f862                	sd	s8,48(sp)
    80005a64:	f466                	sd	s9,40(sp)
    80005a66:	f06a                	sd	s10,32(sp)
    80005a68:	ec6e                	sd	s11,24(sp)
    80005a6a:	0100                	addi	s0,sp,128
    80005a6c:	8b2a                	mv	s6,a0
    80005a6e:	8aae                	mv	s5,a1
    80005a70:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a72:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005a76:	00240517          	auipc	a0,0x240
    80005a7a:	6ca50513          	addi	a0,a0,1738 # 80246140 <cons>
    80005a7e:	00001097          	auipc	ra,0x1
    80005a82:	8f4080e7          	jalr	-1804(ra) # 80006372 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a86:	00240497          	auipc	s1,0x240
    80005a8a:	6ba48493          	addi	s1,s1,1722 # 80246140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a8e:	89a6                	mv	s3,s1
    80005a90:	00240917          	auipc	s2,0x240
    80005a94:	74890913          	addi	s2,s2,1864 # 802461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a98:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a9a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a9c:	4da9                	li	s11,10
  while(n > 0){
    80005a9e:	07405863          	blez	s4,80005b0e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005aa2:	0984a783          	lw	a5,152(s1)
    80005aa6:	09c4a703          	lw	a4,156(s1)
    80005aaa:	02f71463          	bne	a4,a5,80005ad2 <consoleread+0x84>
      if(myproc()->killed){
    80005aae:	ffffb097          	auipc	ra,0xffffb
    80005ab2:	5ac080e7          	jalr	1452(ra) # 8000105a <myproc>
    80005ab6:	551c                	lw	a5,40(a0)
    80005ab8:	e7b5                	bnez	a5,80005b24 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005aba:	85ce                	mv	a1,s3
    80005abc:	854a                	mv	a0,s2
    80005abe:	ffffc097          	auipc	ra,0xffffc
    80005ac2:	c58080e7          	jalr	-936(ra) # 80001716 <sleep>
    while(cons.r == cons.w){
    80005ac6:	0984a783          	lw	a5,152(s1)
    80005aca:	09c4a703          	lw	a4,156(s1)
    80005ace:	fef700e3          	beq	a4,a5,80005aae <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005ad2:	0017871b          	addiw	a4,a5,1
    80005ad6:	08e4ac23          	sw	a4,152(s1)
    80005ada:	07f7f713          	andi	a4,a5,127
    80005ade:	9726                	add	a4,a4,s1
    80005ae0:	01874703          	lbu	a4,24(a4)
    80005ae4:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005ae8:	079c0663          	beq	s8,s9,80005b54 <consoleread+0x106>
    cbuf = c;
    80005aec:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005af0:	4685                	li	a3,1
    80005af2:	f8f40613          	addi	a2,s0,-113
    80005af6:	85d6                	mv	a1,s5
    80005af8:	855a                	mv	a0,s6
    80005afa:	ffffc097          	auipc	ra,0xffffc
    80005afe:	fc0080e7          	jalr	-64(ra) # 80001aba <either_copyout>
    80005b02:	01a50663          	beq	a0,s10,80005b0e <consoleread+0xc0>
    dst++;
    80005b06:	0a85                	addi	s5,s5,1
    --n;
    80005b08:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b0a:	f9bc1ae3          	bne	s8,s11,80005a9e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b0e:	00240517          	auipc	a0,0x240
    80005b12:	63250513          	addi	a0,a0,1586 # 80246140 <cons>
    80005b16:	00001097          	auipc	ra,0x1
    80005b1a:	910080e7          	jalr	-1776(ra) # 80006426 <release>

  return target - n;
    80005b1e:	414b853b          	subw	a0,s7,s4
    80005b22:	a811                	j	80005b36 <consoleread+0xe8>
        release(&cons.lock);
    80005b24:	00240517          	auipc	a0,0x240
    80005b28:	61c50513          	addi	a0,a0,1564 # 80246140 <cons>
    80005b2c:	00001097          	auipc	ra,0x1
    80005b30:	8fa080e7          	jalr	-1798(ra) # 80006426 <release>
        return -1;
    80005b34:	557d                	li	a0,-1
}
    80005b36:	70e6                	ld	ra,120(sp)
    80005b38:	7446                	ld	s0,112(sp)
    80005b3a:	74a6                	ld	s1,104(sp)
    80005b3c:	7906                	ld	s2,96(sp)
    80005b3e:	69e6                	ld	s3,88(sp)
    80005b40:	6a46                	ld	s4,80(sp)
    80005b42:	6aa6                	ld	s5,72(sp)
    80005b44:	6b06                	ld	s6,64(sp)
    80005b46:	7be2                	ld	s7,56(sp)
    80005b48:	7c42                	ld	s8,48(sp)
    80005b4a:	7ca2                	ld	s9,40(sp)
    80005b4c:	7d02                	ld	s10,32(sp)
    80005b4e:	6de2                	ld	s11,24(sp)
    80005b50:	6109                	addi	sp,sp,128
    80005b52:	8082                	ret
      if(n < target){
    80005b54:	000a071b          	sext.w	a4,s4
    80005b58:	fb777be3          	bgeu	a4,s7,80005b0e <consoleread+0xc0>
        cons.r--;
    80005b5c:	00240717          	auipc	a4,0x240
    80005b60:	66f72e23          	sw	a5,1660(a4) # 802461d8 <cons+0x98>
    80005b64:	b76d                	j	80005b0e <consoleread+0xc0>

0000000080005b66 <consputc>:
{
    80005b66:	1141                	addi	sp,sp,-16
    80005b68:	e406                	sd	ra,8(sp)
    80005b6a:	e022                	sd	s0,0(sp)
    80005b6c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b6e:	10000793          	li	a5,256
    80005b72:	00f50a63          	beq	a0,a5,80005b86 <consputc+0x20>
    uartputc_sync(c);
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	564080e7          	jalr	1380(ra) # 800060da <uartputc_sync>
}
    80005b7e:	60a2                	ld	ra,8(sp)
    80005b80:	6402                	ld	s0,0(sp)
    80005b82:	0141                	addi	sp,sp,16
    80005b84:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b86:	4521                	li	a0,8
    80005b88:	00000097          	auipc	ra,0x0
    80005b8c:	552080e7          	jalr	1362(ra) # 800060da <uartputc_sync>
    80005b90:	02000513          	li	a0,32
    80005b94:	00000097          	auipc	ra,0x0
    80005b98:	546080e7          	jalr	1350(ra) # 800060da <uartputc_sync>
    80005b9c:	4521                	li	a0,8
    80005b9e:	00000097          	auipc	ra,0x0
    80005ba2:	53c080e7          	jalr	1340(ra) # 800060da <uartputc_sync>
    80005ba6:	bfe1                	j	80005b7e <consputc+0x18>

0000000080005ba8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ba8:	1101                	addi	sp,sp,-32
    80005baa:	ec06                	sd	ra,24(sp)
    80005bac:	e822                	sd	s0,16(sp)
    80005bae:	e426                	sd	s1,8(sp)
    80005bb0:	e04a                	sd	s2,0(sp)
    80005bb2:	1000                	addi	s0,sp,32
    80005bb4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005bb6:	00240517          	auipc	a0,0x240
    80005bba:	58a50513          	addi	a0,a0,1418 # 80246140 <cons>
    80005bbe:	00000097          	auipc	ra,0x0
    80005bc2:	7b4080e7          	jalr	1972(ra) # 80006372 <acquire>

  switch(c){
    80005bc6:	47d5                	li	a5,21
    80005bc8:	0af48663          	beq	s1,a5,80005c74 <consoleintr+0xcc>
    80005bcc:	0297ca63          	blt	a5,s1,80005c00 <consoleintr+0x58>
    80005bd0:	47a1                	li	a5,8
    80005bd2:	0ef48763          	beq	s1,a5,80005cc0 <consoleintr+0x118>
    80005bd6:	47c1                	li	a5,16
    80005bd8:	10f49a63          	bne	s1,a5,80005cec <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005bdc:	ffffc097          	auipc	ra,0xffffc
    80005be0:	f8a080e7          	jalr	-118(ra) # 80001b66 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005be4:	00240517          	auipc	a0,0x240
    80005be8:	55c50513          	addi	a0,a0,1372 # 80246140 <cons>
    80005bec:	00001097          	auipc	ra,0x1
    80005bf0:	83a080e7          	jalr	-1990(ra) # 80006426 <release>
}
    80005bf4:	60e2                	ld	ra,24(sp)
    80005bf6:	6442                	ld	s0,16(sp)
    80005bf8:	64a2                	ld	s1,8(sp)
    80005bfa:	6902                	ld	s2,0(sp)
    80005bfc:	6105                	addi	sp,sp,32
    80005bfe:	8082                	ret
  switch(c){
    80005c00:	07f00793          	li	a5,127
    80005c04:	0af48e63          	beq	s1,a5,80005cc0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c08:	00240717          	auipc	a4,0x240
    80005c0c:	53870713          	addi	a4,a4,1336 # 80246140 <cons>
    80005c10:	0a072783          	lw	a5,160(a4)
    80005c14:	09872703          	lw	a4,152(a4)
    80005c18:	9f99                	subw	a5,a5,a4
    80005c1a:	07f00713          	li	a4,127
    80005c1e:	fcf763e3          	bltu	a4,a5,80005be4 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c22:	47b5                	li	a5,13
    80005c24:	0cf48763          	beq	s1,a5,80005cf2 <consoleintr+0x14a>
      consputc(c);
    80005c28:	8526                	mv	a0,s1
    80005c2a:	00000097          	auipc	ra,0x0
    80005c2e:	f3c080e7          	jalr	-196(ra) # 80005b66 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c32:	00240797          	auipc	a5,0x240
    80005c36:	50e78793          	addi	a5,a5,1294 # 80246140 <cons>
    80005c3a:	0a07a703          	lw	a4,160(a5)
    80005c3e:	0017069b          	addiw	a3,a4,1
    80005c42:	0006861b          	sext.w	a2,a3
    80005c46:	0ad7a023          	sw	a3,160(a5)
    80005c4a:	07f77713          	andi	a4,a4,127
    80005c4e:	97ba                	add	a5,a5,a4
    80005c50:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005c54:	47a9                	li	a5,10
    80005c56:	0cf48563          	beq	s1,a5,80005d20 <consoleintr+0x178>
    80005c5a:	4791                	li	a5,4
    80005c5c:	0cf48263          	beq	s1,a5,80005d20 <consoleintr+0x178>
    80005c60:	00240797          	auipc	a5,0x240
    80005c64:	5787a783          	lw	a5,1400(a5) # 802461d8 <cons+0x98>
    80005c68:	0807879b          	addiw	a5,a5,128
    80005c6c:	f6f61ce3          	bne	a2,a5,80005be4 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c70:	863e                	mv	a2,a5
    80005c72:	a07d                	j	80005d20 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c74:	00240717          	auipc	a4,0x240
    80005c78:	4cc70713          	addi	a4,a4,1228 # 80246140 <cons>
    80005c7c:	0a072783          	lw	a5,160(a4)
    80005c80:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c84:	00240497          	auipc	s1,0x240
    80005c88:	4bc48493          	addi	s1,s1,1212 # 80246140 <cons>
    while(cons.e != cons.w &&
    80005c8c:	4929                	li	s2,10
    80005c8e:	f4f70be3          	beq	a4,a5,80005be4 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c92:	37fd                	addiw	a5,a5,-1
    80005c94:	07f7f713          	andi	a4,a5,127
    80005c98:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c9a:	01874703          	lbu	a4,24(a4)
    80005c9e:	f52703e3          	beq	a4,s2,80005be4 <consoleintr+0x3c>
      cons.e--;
    80005ca2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ca6:	10000513          	li	a0,256
    80005caa:	00000097          	auipc	ra,0x0
    80005cae:	ebc080e7          	jalr	-324(ra) # 80005b66 <consputc>
    while(cons.e != cons.w &&
    80005cb2:	0a04a783          	lw	a5,160(s1)
    80005cb6:	09c4a703          	lw	a4,156(s1)
    80005cba:	fcf71ce3          	bne	a4,a5,80005c92 <consoleintr+0xea>
    80005cbe:	b71d                	j	80005be4 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005cc0:	00240717          	auipc	a4,0x240
    80005cc4:	48070713          	addi	a4,a4,1152 # 80246140 <cons>
    80005cc8:	0a072783          	lw	a5,160(a4)
    80005ccc:	09c72703          	lw	a4,156(a4)
    80005cd0:	f0f70ae3          	beq	a4,a5,80005be4 <consoleintr+0x3c>
      cons.e--;
    80005cd4:	37fd                	addiw	a5,a5,-1
    80005cd6:	00240717          	auipc	a4,0x240
    80005cda:	50f72523          	sw	a5,1290(a4) # 802461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005cde:	10000513          	li	a0,256
    80005ce2:	00000097          	auipc	ra,0x0
    80005ce6:	e84080e7          	jalr	-380(ra) # 80005b66 <consputc>
    80005cea:	bded                	j	80005be4 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cec:	ee048ce3          	beqz	s1,80005be4 <consoleintr+0x3c>
    80005cf0:	bf21                	j	80005c08 <consoleintr+0x60>
      consputc(c);
    80005cf2:	4529                	li	a0,10
    80005cf4:	00000097          	auipc	ra,0x0
    80005cf8:	e72080e7          	jalr	-398(ra) # 80005b66 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005cfc:	00240797          	auipc	a5,0x240
    80005d00:	44478793          	addi	a5,a5,1092 # 80246140 <cons>
    80005d04:	0a07a703          	lw	a4,160(a5)
    80005d08:	0017069b          	addiw	a3,a4,1
    80005d0c:	0006861b          	sext.w	a2,a3
    80005d10:	0ad7a023          	sw	a3,160(a5)
    80005d14:	07f77713          	andi	a4,a4,127
    80005d18:	97ba                	add	a5,a5,a4
    80005d1a:	4729                	li	a4,10
    80005d1c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d20:	00240797          	auipc	a5,0x240
    80005d24:	4ac7ae23          	sw	a2,1212(a5) # 802461dc <cons+0x9c>
        wakeup(&cons.r);
    80005d28:	00240517          	auipc	a0,0x240
    80005d2c:	4b050513          	addi	a0,a0,1200 # 802461d8 <cons+0x98>
    80005d30:	ffffc097          	auipc	ra,0xffffc
    80005d34:	b72080e7          	jalr	-1166(ra) # 800018a2 <wakeup>
    80005d38:	b575                	j	80005be4 <consoleintr+0x3c>

0000000080005d3a <consoleinit>:

void
consoleinit(void)
{
    80005d3a:	1141                	addi	sp,sp,-16
    80005d3c:	e406                	sd	ra,8(sp)
    80005d3e:	e022                	sd	s0,0(sp)
    80005d40:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d42:	00003597          	auipc	a1,0x3
    80005d46:	abe58593          	addi	a1,a1,-1346 # 80008800 <syscalls+0x3c8>
    80005d4a:	00240517          	auipc	a0,0x240
    80005d4e:	3f650513          	addi	a0,a0,1014 # 80246140 <cons>
    80005d52:	00000097          	auipc	ra,0x0
    80005d56:	590080e7          	jalr	1424(ra) # 800062e2 <initlock>

  uartinit();
    80005d5a:	00000097          	auipc	ra,0x0
    80005d5e:	330080e7          	jalr	816(ra) # 8000608a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d62:	00233797          	auipc	a5,0x233
    80005d66:	37e78793          	addi	a5,a5,894 # 802390e0 <devsw>
    80005d6a:	00000717          	auipc	a4,0x0
    80005d6e:	ce470713          	addi	a4,a4,-796 # 80005a4e <consoleread>
    80005d72:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d74:	00000717          	auipc	a4,0x0
    80005d78:	c7870713          	addi	a4,a4,-904 # 800059ec <consolewrite>
    80005d7c:	ef98                	sd	a4,24(a5)
}
    80005d7e:	60a2                	ld	ra,8(sp)
    80005d80:	6402                	ld	s0,0(sp)
    80005d82:	0141                	addi	sp,sp,16
    80005d84:	8082                	ret

0000000080005d86 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d86:	7179                	addi	sp,sp,-48
    80005d88:	f406                	sd	ra,40(sp)
    80005d8a:	f022                	sd	s0,32(sp)
    80005d8c:	ec26                	sd	s1,24(sp)
    80005d8e:	e84a                	sd	s2,16(sp)
    80005d90:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d92:	c219                	beqz	a2,80005d98 <printint+0x12>
    80005d94:	08054663          	bltz	a0,80005e20 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d98:	2501                	sext.w	a0,a0
    80005d9a:	4881                	li	a7,0
    80005d9c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005da0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005da2:	2581                	sext.w	a1,a1
    80005da4:	00003617          	auipc	a2,0x3
    80005da8:	a8c60613          	addi	a2,a2,-1396 # 80008830 <digits>
    80005dac:	883a                	mv	a6,a4
    80005dae:	2705                	addiw	a4,a4,1
    80005db0:	02b577bb          	remuw	a5,a0,a1
    80005db4:	1782                	slli	a5,a5,0x20
    80005db6:	9381                	srli	a5,a5,0x20
    80005db8:	97b2                	add	a5,a5,a2
    80005dba:	0007c783          	lbu	a5,0(a5)
    80005dbe:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005dc2:	0005079b          	sext.w	a5,a0
    80005dc6:	02b5553b          	divuw	a0,a0,a1
    80005dca:	0685                	addi	a3,a3,1
    80005dcc:	feb7f0e3          	bgeu	a5,a1,80005dac <printint+0x26>

  if(sign)
    80005dd0:	00088b63          	beqz	a7,80005de6 <printint+0x60>
    buf[i++] = '-';
    80005dd4:	fe040793          	addi	a5,s0,-32
    80005dd8:	973e                	add	a4,a4,a5
    80005dda:	02d00793          	li	a5,45
    80005dde:	fef70823          	sb	a5,-16(a4)
    80005de2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005de6:	02e05763          	blez	a4,80005e14 <printint+0x8e>
    80005dea:	fd040793          	addi	a5,s0,-48
    80005dee:	00e784b3          	add	s1,a5,a4
    80005df2:	fff78913          	addi	s2,a5,-1
    80005df6:	993a                	add	s2,s2,a4
    80005df8:	377d                	addiw	a4,a4,-1
    80005dfa:	1702                	slli	a4,a4,0x20
    80005dfc:	9301                	srli	a4,a4,0x20
    80005dfe:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e02:	fff4c503          	lbu	a0,-1(s1)
    80005e06:	00000097          	auipc	ra,0x0
    80005e0a:	d60080e7          	jalr	-672(ra) # 80005b66 <consputc>
  while(--i >= 0)
    80005e0e:	14fd                	addi	s1,s1,-1
    80005e10:	ff2499e3          	bne	s1,s2,80005e02 <printint+0x7c>
}
    80005e14:	70a2                	ld	ra,40(sp)
    80005e16:	7402                	ld	s0,32(sp)
    80005e18:	64e2                	ld	s1,24(sp)
    80005e1a:	6942                	ld	s2,16(sp)
    80005e1c:	6145                	addi	sp,sp,48
    80005e1e:	8082                	ret
    x = -xx;
    80005e20:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e24:	4885                	li	a7,1
    x = -xx;
    80005e26:	bf9d                	j	80005d9c <printint+0x16>

0000000080005e28 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e28:	1101                	addi	sp,sp,-32
    80005e2a:	ec06                	sd	ra,24(sp)
    80005e2c:	e822                	sd	s0,16(sp)
    80005e2e:	e426                	sd	s1,8(sp)
    80005e30:	1000                	addi	s0,sp,32
    80005e32:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e34:	00240797          	auipc	a5,0x240
    80005e38:	3c07a623          	sw	zero,972(a5) # 80246200 <pr+0x18>
  printf("panic: ");
    80005e3c:	00003517          	auipc	a0,0x3
    80005e40:	9cc50513          	addi	a0,a0,-1588 # 80008808 <syscalls+0x3d0>
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	02e080e7          	jalr	46(ra) # 80005e72 <printf>
  printf(s);
    80005e4c:	8526                	mv	a0,s1
    80005e4e:	00000097          	auipc	ra,0x0
    80005e52:	024080e7          	jalr	36(ra) # 80005e72 <printf>
  printf("\n");
    80005e56:	00002517          	auipc	a0,0x2
    80005e5a:	1fa50513          	addi	a0,a0,506 # 80008050 <etext+0x50>
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	014080e7          	jalr	20(ra) # 80005e72 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e66:	4785                	li	a5,1
    80005e68:	00003717          	auipc	a4,0x3
    80005e6c:	1af72a23          	sw	a5,436(a4) # 8000901c <panicked>
  for(;;)
    80005e70:	a001                	j	80005e70 <panic+0x48>

0000000080005e72 <printf>:
{
    80005e72:	7131                	addi	sp,sp,-192
    80005e74:	fc86                	sd	ra,120(sp)
    80005e76:	f8a2                	sd	s0,112(sp)
    80005e78:	f4a6                	sd	s1,104(sp)
    80005e7a:	f0ca                	sd	s2,96(sp)
    80005e7c:	ecce                	sd	s3,88(sp)
    80005e7e:	e8d2                	sd	s4,80(sp)
    80005e80:	e4d6                	sd	s5,72(sp)
    80005e82:	e0da                	sd	s6,64(sp)
    80005e84:	fc5e                	sd	s7,56(sp)
    80005e86:	f862                	sd	s8,48(sp)
    80005e88:	f466                	sd	s9,40(sp)
    80005e8a:	f06a                	sd	s10,32(sp)
    80005e8c:	ec6e                	sd	s11,24(sp)
    80005e8e:	0100                	addi	s0,sp,128
    80005e90:	8a2a                	mv	s4,a0
    80005e92:	e40c                	sd	a1,8(s0)
    80005e94:	e810                	sd	a2,16(s0)
    80005e96:	ec14                	sd	a3,24(s0)
    80005e98:	f018                	sd	a4,32(s0)
    80005e9a:	f41c                	sd	a5,40(s0)
    80005e9c:	03043823          	sd	a6,48(s0)
    80005ea0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ea4:	00240d97          	auipc	s11,0x240
    80005ea8:	35cdad83          	lw	s11,860(s11) # 80246200 <pr+0x18>
  if(locking)
    80005eac:	020d9b63          	bnez	s11,80005ee2 <printf+0x70>
  if (fmt == 0)
    80005eb0:	040a0263          	beqz	s4,80005ef4 <printf+0x82>
  va_start(ap, fmt);
    80005eb4:	00840793          	addi	a5,s0,8
    80005eb8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ebc:	000a4503          	lbu	a0,0(s4)
    80005ec0:	16050263          	beqz	a0,80006024 <printf+0x1b2>
    80005ec4:	4481                	li	s1,0
    if(c != '%'){
    80005ec6:	02500a93          	li	s5,37
    switch(c){
    80005eca:	07000b13          	li	s6,112
  consputc('x');
    80005ece:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ed0:	00003b97          	auipc	s7,0x3
    80005ed4:	960b8b93          	addi	s7,s7,-1696 # 80008830 <digits>
    switch(c){
    80005ed8:	07300c93          	li	s9,115
    80005edc:	06400c13          	li	s8,100
    80005ee0:	a82d                	j	80005f1a <printf+0xa8>
    acquire(&pr.lock);
    80005ee2:	00240517          	auipc	a0,0x240
    80005ee6:	30650513          	addi	a0,a0,774 # 802461e8 <pr>
    80005eea:	00000097          	auipc	ra,0x0
    80005eee:	488080e7          	jalr	1160(ra) # 80006372 <acquire>
    80005ef2:	bf7d                	j	80005eb0 <printf+0x3e>
    panic("null fmt");
    80005ef4:	00003517          	auipc	a0,0x3
    80005ef8:	92450513          	addi	a0,a0,-1756 # 80008818 <syscalls+0x3e0>
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	f2c080e7          	jalr	-212(ra) # 80005e28 <panic>
      consputc(c);
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	c62080e7          	jalr	-926(ra) # 80005b66 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f0c:	2485                	addiw	s1,s1,1
    80005f0e:	009a07b3          	add	a5,s4,s1
    80005f12:	0007c503          	lbu	a0,0(a5)
    80005f16:	10050763          	beqz	a0,80006024 <printf+0x1b2>
    if(c != '%'){
    80005f1a:	ff5515e3          	bne	a0,s5,80005f04 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f1e:	2485                	addiw	s1,s1,1
    80005f20:	009a07b3          	add	a5,s4,s1
    80005f24:	0007c783          	lbu	a5,0(a5)
    80005f28:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f2c:	cfe5                	beqz	a5,80006024 <printf+0x1b2>
    switch(c){
    80005f2e:	05678a63          	beq	a5,s6,80005f82 <printf+0x110>
    80005f32:	02fb7663          	bgeu	s6,a5,80005f5e <printf+0xec>
    80005f36:	09978963          	beq	a5,s9,80005fc8 <printf+0x156>
    80005f3a:	07800713          	li	a4,120
    80005f3e:	0ce79863          	bne	a5,a4,8000600e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f42:	f8843783          	ld	a5,-120(s0)
    80005f46:	00878713          	addi	a4,a5,8
    80005f4a:	f8e43423          	sd	a4,-120(s0)
    80005f4e:	4605                	li	a2,1
    80005f50:	85ea                	mv	a1,s10
    80005f52:	4388                	lw	a0,0(a5)
    80005f54:	00000097          	auipc	ra,0x0
    80005f58:	e32080e7          	jalr	-462(ra) # 80005d86 <printint>
      break;
    80005f5c:	bf45                	j	80005f0c <printf+0x9a>
    switch(c){
    80005f5e:	0b578263          	beq	a5,s5,80006002 <printf+0x190>
    80005f62:	0b879663          	bne	a5,s8,8000600e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005f66:	f8843783          	ld	a5,-120(s0)
    80005f6a:	00878713          	addi	a4,a5,8
    80005f6e:	f8e43423          	sd	a4,-120(s0)
    80005f72:	4605                	li	a2,1
    80005f74:	45a9                	li	a1,10
    80005f76:	4388                	lw	a0,0(a5)
    80005f78:	00000097          	auipc	ra,0x0
    80005f7c:	e0e080e7          	jalr	-498(ra) # 80005d86 <printint>
      break;
    80005f80:	b771                	j	80005f0c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f82:	f8843783          	ld	a5,-120(s0)
    80005f86:	00878713          	addi	a4,a5,8
    80005f8a:	f8e43423          	sd	a4,-120(s0)
    80005f8e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f92:	03000513          	li	a0,48
    80005f96:	00000097          	auipc	ra,0x0
    80005f9a:	bd0080e7          	jalr	-1072(ra) # 80005b66 <consputc>
  consputc('x');
    80005f9e:	07800513          	li	a0,120
    80005fa2:	00000097          	auipc	ra,0x0
    80005fa6:	bc4080e7          	jalr	-1084(ra) # 80005b66 <consputc>
    80005faa:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fac:	03c9d793          	srli	a5,s3,0x3c
    80005fb0:	97de                	add	a5,a5,s7
    80005fb2:	0007c503          	lbu	a0,0(a5)
    80005fb6:	00000097          	auipc	ra,0x0
    80005fba:	bb0080e7          	jalr	-1104(ra) # 80005b66 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fbe:	0992                	slli	s3,s3,0x4
    80005fc0:	397d                	addiw	s2,s2,-1
    80005fc2:	fe0915e3          	bnez	s2,80005fac <printf+0x13a>
    80005fc6:	b799                	j	80005f0c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005fc8:	f8843783          	ld	a5,-120(s0)
    80005fcc:	00878713          	addi	a4,a5,8
    80005fd0:	f8e43423          	sd	a4,-120(s0)
    80005fd4:	0007b903          	ld	s2,0(a5)
    80005fd8:	00090e63          	beqz	s2,80005ff4 <printf+0x182>
      for(; *s; s++)
    80005fdc:	00094503          	lbu	a0,0(s2)
    80005fe0:	d515                	beqz	a0,80005f0c <printf+0x9a>
        consputc(*s);
    80005fe2:	00000097          	auipc	ra,0x0
    80005fe6:	b84080e7          	jalr	-1148(ra) # 80005b66 <consputc>
      for(; *s; s++)
    80005fea:	0905                	addi	s2,s2,1
    80005fec:	00094503          	lbu	a0,0(s2)
    80005ff0:	f96d                	bnez	a0,80005fe2 <printf+0x170>
    80005ff2:	bf29                	j	80005f0c <printf+0x9a>
        s = "(null)";
    80005ff4:	00003917          	auipc	s2,0x3
    80005ff8:	81c90913          	addi	s2,s2,-2020 # 80008810 <syscalls+0x3d8>
      for(; *s; s++)
    80005ffc:	02800513          	li	a0,40
    80006000:	b7cd                	j	80005fe2 <printf+0x170>
      consputc('%');
    80006002:	8556                	mv	a0,s5
    80006004:	00000097          	auipc	ra,0x0
    80006008:	b62080e7          	jalr	-1182(ra) # 80005b66 <consputc>
      break;
    8000600c:	b701                	j	80005f0c <printf+0x9a>
      consputc('%');
    8000600e:	8556                	mv	a0,s5
    80006010:	00000097          	auipc	ra,0x0
    80006014:	b56080e7          	jalr	-1194(ra) # 80005b66 <consputc>
      consputc(c);
    80006018:	854a                	mv	a0,s2
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	b4c080e7          	jalr	-1204(ra) # 80005b66 <consputc>
      break;
    80006022:	b5ed                	j	80005f0c <printf+0x9a>
  if(locking)
    80006024:	020d9163          	bnez	s11,80006046 <printf+0x1d4>
}
    80006028:	70e6                	ld	ra,120(sp)
    8000602a:	7446                	ld	s0,112(sp)
    8000602c:	74a6                	ld	s1,104(sp)
    8000602e:	7906                	ld	s2,96(sp)
    80006030:	69e6                	ld	s3,88(sp)
    80006032:	6a46                	ld	s4,80(sp)
    80006034:	6aa6                	ld	s5,72(sp)
    80006036:	6b06                	ld	s6,64(sp)
    80006038:	7be2                	ld	s7,56(sp)
    8000603a:	7c42                	ld	s8,48(sp)
    8000603c:	7ca2                	ld	s9,40(sp)
    8000603e:	7d02                	ld	s10,32(sp)
    80006040:	6de2                	ld	s11,24(sp)
    80006042:	6129                	addi	sp,sp,192
    80006044:	8082                	ret
    release(&pr.lock);
    80006046:	00240517          	auipc	a0,0x240
    8000604a:	1a250513          	addi	a0,a0,418 # 802461e8 <pr>
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	3d8080e7          	jalr	984(ra) # 80006426 <release>
}
    80006056:	bfc9                	j	80006028 <printf+0x1b6>

0000000080006058 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006058:	1101                	addi	sp,sp,-32
    8000605a:	ec06                	sd	ra,24(sp)
    8000605c:	e822                	sd	s0,16(sp)
    8000605e:	e426                	sd	s1,8(sp)
    80006060:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006062:	00240497          	auipc	s1,0x240
    80006066:	18648493          	addi	s1,s1,390 # 802461e8 <pr>
    8000606a:	00002597          	auipc	a1,0x2
    8000606e:	7be58593          	addi	a1,a1,1982 # 80008828 <syscalls+0x3f0>
    80006072:	8526                	mv	a0,s1
    80006074:	00000097          	auipc	ra,0x0
    80006078:	26e080e7          	jalr	622(ra) # 800062e2 <initlock>
  pr.locking = 1;
    8000607c:	4785                	li	a5,1
    8000607e:	cc9c                	sw	a5,24(s1)
}
    80006080:	60e2                	ld	ra,24(sp)
    80006082:	6442                	ld	s0,16(sp)
    80006084:	64a2                	ld	s1,8(sp)
    80006086:	6105                	addi	sp,sp,32
    80006088:	8082                	ret

000000008000608a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000608a:	1141                	addi	sp,sp,-16
    8000608c:	e406                	sd	ra,8(sp)
    8000608e:	e022                	sd	s0,0(sp)
    80006090:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006092:	100007b7          	lui	a5,0x10000
    80006096:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000609a:	f8000713          	li	a4,-128
    8000609e:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060a2:	470d                	li	a4,3
    800060a4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800060a8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800060ac:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800060b0:	469d                	li	a3,7
    800060b2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060b6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060ba:	00002597          	auipc	a1,0x2
    800060be:	78e58593          	addi	a1,a1,1934 # 80008848 <digits+0x18>
    800060c2:	00240517          	auipc	a0,0x240
    800060c6:	14650513          	addi	a0,a0,326 # 80246208 <uart_tx_lock>
    800060ca:	00000097          	auipc	ra,0x0
    800060ce:	218080e7          	jalr	536(ra) # 800062e2 <initlock>
}
    800060d2:	60a2                	ld	ra,8(sp)
    800060d4:	6402                	ld	s0,0(sp)
    800060d6:	0141                	addi	sp,sp,16
    800060d8:	8082                	ret

00000000800060da <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060da:	1101                	addi	sp,sp,-32
    800060dc:	ec06                	sd	ra,24(sp)
    800060de:	e822                	sd	s0,16(sp)
    800060e0:	e426                	sd	s1,8(sp)
    800060e2:	1000                	addi	s0,sp,32
    800060e4:	84aa                	mv	s1,a0
  push_off();
    800060e6:	00000097          	auipc	ra,0x0
    800060ea:	240080e7          	jalr	576(ra) # 80006326 <push_off>

  if(panicked){
    800060ee:	00003797          	auipc	a5,0x3
    800060f2:	f2e7a783          	lw	a5,-210(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060f6:	10000737          	lui	a4,0x10000
  if(panicked){
    800060fa:	c391                	beqz	a5,800060fe <uartputc_sync+0x24>
    for(;;)
    800060fc:	a001                	j	800060fc <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060fe:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006102:	0ff7f793          	andi	a5,a5,255
    80006106:	0207f793          	andi	a5,a5,32
    8000610a:	dbf5                	beqz	a5,800060fe <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000610c:	0ff4f793          	andi	a5,s1,255
    80006110:	10000737          	lui	a4,0x10000
    80006114:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006118:	00000097          	auipc	ra,0x0
    8000611c:	2ae080e7          	jalr	686(ra) # 800063c6 <pop_off>
}
    80006120:	60e2                	ld	ra,24(sp)
    80006122:	6442                	ld	s0,16(sp)
    80006124:	64a2                	ld	s1,8(sp)
    80006126:	6105                	addi	sp,sp,32
    80006128:	8082                	ret

000000008000612a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000612a:	00003717          	auipc	a4,0x3
    8000612e:	ef673703          	ld	a4,-266(a4) # 80009020 <uart_tx_r>
    80006132:	00003797          	auipc	a5,0x3
    80006136:	ef67b783          	ld	a5,-266(a5) # 80009028 <uart_tx_w>
    8000613a:	06e78c63          	beq	a5,a4,800061b2 <uartstart+0x88>
{
    8000613e:	7139                	addi	sp,sp,-64
    80006140:	fc06                	sd	ra,56(sp)
    80006142:	f822                	sd	s0,48(sp)
    80006144:	f426                	sd	s1,40(sp)
    80006146:	f04a                	sd	s2,32(sp)
    80006148:	ec4e                	sd	s3,24(sp)
    8000614a:	e852                	sd	s4,16(sp)
    8000614c:	e456                	sd	s5,8(sp)
    8000614e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006150:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006154:	00240a17          	auipc	s4,0x240
    80006158:	0b4a0a13          	addi	s4,s4,180 # 80246208 <uart_tx_lock>
    uart_tx_r += 1;
    8000615c:	00003497          	auipc	s1,0x3
    80006160:	ec448493          	addi	s1,s1,-316 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006164:	00003997          	auipc	s3,0x3
    80006168:	ec498993          	addi	s3,s3,-316 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000616c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006170:	0ff7f793          	andi	a5,a5,255
    80006174:	0207f793          	andi	a5,a5,32
    80006178:	c785                	beqz	a5,800061a0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000617a:	01f77793          	andi	a5,a4,31
    8000617e:	97d2                	add	a5,a5,s4
    80006180:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006184:	0705                	addi	a4,a4,1
    80006186:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006188:	8526                	mv	a0,s1
    8000618a:	ffffb097          	auipc	ra,0xffffb
    8000618e:	718080e7          	jalr	1816(ra) # 800018a2 <wakeup>
    
    WriteReg(THR, c);
    80006192:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006196:	6098                	ld	a4,0(s1)
    80006198:	0009b783          	ld	a5,0(s3)
    8000619c:	fce798e3          	bne	a5,a4,8000616c <uartstart+0x42>
  }
}
    800061a0:	70e2                	ld	ra,56(sp)
    800061a2:	7442                	ld	s0,48(sp)
    800061a4:	74a2                	ld	s1,40(sp)
    800061a6:	7902                	ld	s2,32(sp)
    800061a8:	69e2                	ld	s3,24(sp)
    800061aa:	6a42                	ld	s4,16(sp)
    800061ac:	6aa2                	ld	s5,8(sp)
    800061ae:	6121                	addi	sp,sp,64
    800061b0:	8082                	ret
    800061b2:	8082                	ret

00000000800061b4 <uartputc>:
{
    800061b4:	7179                	addi	sp,sp,-48
    800061b6:	f406                	sd	ra,40(sp)
    800061b8:	f022                	sd	s0,32(sp)
    800061ba:	ec26                	sd	s1,24(sp)
    800061bc:	e84a                	sd	s2,16(sp)
    800061be:	e44e                	sd	s3,8(sp)
    800061c0:	e052                	sd	s4,0(sp)
    800061c2:	1800                	addi	s0,sp,48
    800061c4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800061c6:	00240517          	auipc	a0,0x240
    800061ca:	04250513          	addi	a0,a0,66 # 80246208 <uart_tx_lock>
    800061ce:	00000097          	auipc	ra,0x0
    800061d2:	1a4080e7          	jalr	420(ra) # 80006372 <acquire>
  if(panicked){
    800061d6:	00003797          	auipc	a5,0x3
    800061da:	e467a783          	lw	a5,-442(a5) # 8000901c <panicked>
    800061de:	c391                	beqz	a5,800061e2 <uartputc+0x2e>
    for(;;)
    800061e0:	a001                	j	800061e0 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061e2:	00003797          	auipc	a5,0x3
    800061e6:	e467b783          	ld	a5,-442(a5) # 80009028 <uart_tx_w>
    800061ea:	00003717          	auipc	a4,0x3
    800061ee:	e3673703          	ld	a4,-458(a4) # 80009020 <uart_tx_r>
    800061f2:	02070713          	addi	a4,a4,32
    800061f6:	02f71b63          	bne	a4,a5,8000622c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061fa:	00240a17          	auipc	s4,0x240
    800061fe:	00ea0a13          	addi	s4,s4,14 # 80246208 <uart_tx_lock>
    80006202:	00003497          	auipc	s1,0x3
    80006206:	e1e48493          	addi	s1,s1,-482 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000620a:	00003917          	auipc	s2,0x3
    8000620e:	e1e90913          	addi	s2,s2,-482 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006212:	85d2                	mv	a1,s4
    80006214:	8526                	mv	a0,s1
    80006216:	ffffb097          	auipc	ra,0xffffb
    8000621a:	500080e7          	jalr	1280(ra) # 80001716 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000621e:	00093783          	ld	a5,0(s2)
    80006222:	6098                	ld	a4,0(s1)
    80006224:	02070713          	addi	a4,a4,32
    80006228:	fef705e3          	beq	a4,a5,80006212 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000622c:	00240497          	auipc	s1,0x240
    80006230:	fdc48493          	addi	s1,s1,-36 # 80246208 <uart_tx_lock>
    80006234:	01f7f713          	andi	a4,a5,31
    80006238:	9726                	add	a4,a4,s1
    8000623a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000623e:	0785                	addi	a5,a5,1
    80006240:	00003717          	auipc	a4,0x3
    80006244:	def73423          	sd	a5,-536(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006248:	00000097          	auipc	ra,0x0
    8000624c:	ee2080e7          	jalr	-286(ra) # 8000612a <uartstart>
      release(&uart_tx_lock);
    80006250:	8526                	mv	a0,s1
    80006252:	00000097          	auipc	ra,0x0
    80006256:	1d4080e7          	jalr	468(ra) # 80006426 <release>
}
    8000625a:	70a2                	ld	ra,40(sp)
    8000625c:	7402                	ld	s0,32(sp)
    8000625e:	64e2                	ld	s1,24(sp)
    80006260:	6942                	ld	s2,16(sp)
    80006262:	69a2                	ld	s3,8(sp)
    80006264:	6a02                	ld	s4,0(sp)
    80006266:	6145                	addi	sp,sp,48
    80006268:	8082                	ret

000000008000626a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000626a:	1141                	addi	sp,sp,-16
    8000626c:	e422                	sd	s0,8(sp)
    8000626e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006270:	100007b7          	lui	a5,0x10000
    80006274:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006278:	8b85                	andi	a5,a5,1
    8000627a:	cb91                	beqz	a5,8000628e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000627c:	100007b7          	lui	a5,0x10000
    80006280:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006284:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006288:	6422                	ld	s0,8(sp)
    8000628a:	0141                	addi	sp,sp,16
    8000628c:	8082                	ret
    return -1;
    8000628e:	557d                	li	a0,-1
    80006290:	bfe5                	j	80006288 <uartgetc+0x1e>

0000000080006292 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006292:	1101                	addi	sp,sp,-32
    80006294:	ec06                	sd	ra,24(sp)
    80006296:	e822                	sd	s0,16(sp)
    80006298:	e426                	sd	s1,8(sp)
    8000629a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000629c:	54fd                	li	s1,-1
    int c = uartgetc();
    8000629e:	00000097          	auipc	ra,0x0
    800062a2:	fcc080e7          	jalr	-52(ra) # 8000626a <uartgetc>
    if(c == -1)
    800062a6:	00950763          	beq	a0,s1,800062b4 <uartintr+0x22>
      break;
    consoleintr(c);
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	8fe080e7          	jalr	-1794(ra) # 80005ba8 <consoleintr>
  while(1){
    800062b2:	b7f5                	j	8000629e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062b4:	00240497          	auipc	s1,0x240
    800062b8:	f5448493          	addi	s1,s1,-172 # 80246208 <uart_tx_lock>
    800062bc:	8526                	mv	a0,s1
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	0b4080e7          	jalr	180(ra) # 80006372 <acquire>
  uartstart();
    800062c6:	00000097          	auipc	ra,0x0
    800062ca:	e64080e7          	jalr	-412(ra) # 8000612a <uartstart>
  release(&uart_tx_lock);
    800062ce:	8526                	mv	a0,s1
    800062d0:	00000097          	auipc	ra,0x0
    800062d4:	156080e7          	jalr	342(ra) # 80006426 <release>
}
    800062d8:	60e2                	ld	ra,24(sp)
    800062da:	6442                	ld	s0,16(sp)
    800062dc:	64a2                	ld	s1,8(sp)
    800062de:	6105                	addi	sp,sp,32
    800062e0:	8082                	ret

00000000800062e2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062e2:	1141                	addi	sp,sp,-16
    800062e4:	e422                	sd	s0,8(sp)
    800062e6:	0800                	addi	s0,sp,16
  lk->name = name;
    800062e8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062ea:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062ee:	00053823          	sd	zero,16(a0)
}
    800062f2:	6422                	ld	s0,8(sp)
    800062f4:	0141                	addi	sp,sp,16
    800062f6:	8082                	ret

00000000800062f8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062f8:	411c                	lw	a5,0(a0)
    800062fa:	e399                	bnez	a5,80006300 <holding+0x8>
    800062fc:	4501                	li	a0,0
  return r;
}
    800062fe:	8082                	ret
{
    80006300:	1101                	addi	sp,sp,-32
    80006302:	ec06                	sd	ra,24(sp)
    80006304:	e822                	sd	s0,16(sp)
    80006306:	e426                	sd	s1,8(sp)
    80006308:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000630a:	6904                	ld	s1,16(a0)
    8000630c:	ffffb097          	auipc	ra,0xffffb
    80006310:	d32080e7          	jalr	-718(ra) # 8000103e <mycpu>
    80006314:	40a48533          	sub	a0,s1,a0
    80006318:	00153513          	seqz	a0,a0
}
    8000631c:	60e2                	ld	ra,24(sp)
    8000631e:	6442                	ld	s0,16(sp)
    80006320:	64a2                	ld	s1,8(sp)
    80006322:	6105                	addi	sp,sp,32
    80006324:	8082                	ret

0000000080006326 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006326:	1101                	addi	sp,sp,-32
    80006328:	ec06                	sd	ra,24(sp)
    8000632a:	e822                	sd	s0,16(sp)
    8000632c:	e426                	sd	s1,8(sp)
    8000632e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006330:	100024f3          	csrr	s1,sstatus
    80006334:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006338:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000633a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000633e:	ffffb097          	auipc	ra,0xffffb
    80006342:	d00080e7          	jalr	-768(ra) # 8000103e <mycpu>
    80006346:	5d3c                	lw	a5,120(a0)
    80006348:	cf89                	beqz	a5,80006362 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000634a:	ffffb097          	auipc	ra,0xffffb
    8000634e:	cf4080e7          	jalr	-780(ra) # 8000103e <mycpu>
    80006352:	5d3c                	lw	a5,120(a0)
    80006354:	2785                	addiw	a5,a5,1
    80006356:	dd3c                	sw	a5,120(a0)
}
    80006358:	60e2                	ld	ra,24(sp)
    8000635a:	6442                	ld	s0,16(sp)
    8000635c:	64a2                	ld	s1,8(sp)
    8000635e:	6105                	addi	sp,sp,32
    80006360:	8082                	ret
    mycpu()->intena = old;
    80006362:	ffffb097          	auipc	ra,0xffffb
    80006366:	cdc080e7          	jalr	-804(ra) # 8000103e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000636a:	8085                	srli	s1,s1,0x1
    8000636c:	8885                	andi	s1,s1,1
    8000636e:	dd64                	sw	s1,124(a0)
    80006370:	bfe9                	j	8000634a <push_off+0x24>

0000000080006372 <acquire>:
{
    80006372:	1101                	addi	sp,sp,-32
    80006374:	ec06                	sd	ra,24(sp)
    80006376:	e822                	sd	s0,16(sp)
    80006378:	e426                	sd	s1,8(sp)
    8000637a:	1000                	addi	s0,sp,32
    8000637c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000637e:	00000097          	auipc	ra,0x0
    80006382:	fa8080e7          	jalr	-88(ra) # 80006326 <push_off>
  if(holding(lk))
    80006386:	8526                	mv	a0,s1
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	f70080e7          	jalr	-144(ra) # 800062f8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006390:	4705                	li	a4,1
  if(holding(lk))
    80006392:	e115                	bnez	a0,800063b6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006394:	87ba                	mv	a5,a4
    80006396:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000639a:	2781                	sext.w	a5,a5
    8000639c:	ffe5                	bnez	a5,80006394 <acquire+0x22>
  __sync_synchronize();
    8000639e:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063a2:	ffffb097          	auipc	ra,0xffffb
    800063a6:	c9c080e7          	jalr	-868(ra) # 8000103e <mycpu>
    800063aa:	e888                	sd	a0,16(s1)
}
    800063ac:	60e2                	ld	ra,24(sp)
    800063ae:	6442                	ld	s0,16(sp)
    800063b0:	64a2                	ld	s1,8(sp)
    800063b2:	6105                	addi	sp,sp,32
    800063b4:	8082                	ret
    panic("acquire");
    800063b6:	00002517          	auipc	a0,0x2
    800063ba:	49a50513          	addi	a0,a0,1178 # 80008850 <digits+0x20>
    800063be:	00000097          	auipc	ra,0x0
    800063c2:	a6a080e7          	jalr	-1430(ra) # 80005e28 <panic>

00000000800063c6 <pop_off>:

void
pop_off(void)
{
    800063c6:	1141                	addi	sp,sp,-16
    800063c8:	e406                	sd	ra,8(sp)
    800063ca:	e022                	sd	s0,0(sp)
    800063cc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063ce:	ffffb097          	auipc	ra,0xffffb
    800063d2:	c70080e7          	jalr	-912(ra) # 8000103e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063d6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063da:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063dc:	e78d                	bnez	a5,80006406 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063de:	5d3c                	lw	a5,120(a0)
    800063e0:	02f05b63          	blez	a5,80006416 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063e4:	37fd                	addiw	a5,a5,-1
    800063e6:	0007871b          	sext.w	a4,a5
    800063ea:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063ec:	eb09                	bnez	a4,800063fe <pop_off+0x38>
    800063ee:	5d7c                	lw	a5,124(a0)
    800063f0:	c799                	beqz	a5,800063fe <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063f2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063f6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063fa:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063fe:	60a2                	ld	ra,8(sp)
    80006400:	6402                	ld	s0,0(sp)
    80006402:	0141                	addi	sp,sp,16
    80006404:	8082                	ret
    panic("pop_off - interruptible");
    80006406:	00002517          	auipc	a0,0x2
    8000640a:	45250513          	addi	a0,a0,1106 # 80008858 <digits+0x28>
    8000640e:	00000097          	auipc	ra,0x0
    80006412:	a1a080e7          	jalr	-1510(ra) # 80005e28 <panic>
    panic("pop_off");
    80006416:	00002517          	auipc	a0,0x2
    8000641a:	45a50513          	addi	a0,a0,1114 # 80008870 <digits+0x40>
    8000641e:	00000097          	auipc	ra,0x0
    80006422:	a0a080e7          	jalr	-1526(ra) # 80005e28 <panic>

0000000080006426 <release>:
{
    80006426:	1101                	addi	sp,sp,-32
    80006428:	ec06                	sd	ra,24(sp)
    8000642a:	e822                	sd	s0,16(sp)
    8000642c:	e426                	sd	s1,8(sp)
    8000642e:	1000                	addi	s0,sp,32
    80006430:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006432:	00000097          	auipc	ra,0x0
    80006436:	ec6080e7          	jalr	-314(ra) # 800062f8 <holding>
    8000643a:	c115                	beqz	a0,8000645e <release+0x38>
  lk->cpu = 0;
    8000643c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006440:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006444:	0f50000f          	fence	iorw,ow
    80006448:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000644c:	00000097          	auipc	ra,0x0
    80006450:	f7a080e7          	jalr	-134(ra) # 800063c6 <pop_off>
}
    80006454:	60e2                	ld	ra,24(sp)
    80006456:	6442                	ld	s0,16(sp)
    80006458:	64a2                	ld	s1,8(sp)
    8000645a:	6105                	addi	sp,sp,32
    8000645c:	8082                	ret
    panic("release");
    8000645e:	00002517          	auipc	a0,0x2
    80006462:	41a50513          	addi	a0,a0,1050 # 80008878 <digits+0x48>
    80006466:	00000097          	auipc	ra,0x0
    8000646a:	9c2080e7          	jalr	-1598(ra) # 80005e28 <panic>
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
