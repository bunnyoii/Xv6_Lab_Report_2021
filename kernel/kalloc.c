// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
  char lockname[8];     // save lock's name - lab8-1
} kmems[NCPU];  // a free list and a lock per CPU - lab8-1


void
kinit()
{
  // init the kmem array - lab8-1
  int i;
  for (i = 0; i < NCPU; ++i) {
    snprintf(kmems[i].lockname, 8, "kmem_%d", i);    // the name of the lock
    initlock(&kmems[i].lock, kmems[i].lockname);
  }
//  initlock(&kmem.lock, "kmem");   // lab8-1
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;
  int c;    // cpuid - lab8-1

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  // get the current core number - lab8-1
  push_off();
  c = cpuid();
  pop_off();
  // free the page to the current cpu's freelist - lab8-1
  acquire(&kmems[c].lock);
  r->next = kmems[c].freelist;
  kmems[c].freelist = r;
  release(&kmems[c].lock);
}

// steal half page from other cpu's freelist - lab8-1
struct run *steal(int cpu_id) {
    int i;
    int c = cpu_id;
    struct run *fast, *slow, *head;
    // 若传递的cpuid和实际运行的cpuid出现不一致,则引发panic
    // 加入该判断以检查在kalloc()调用steal时CPU不会被切换
    if(cpu_id != cpuid()) {
      panic("steal");
    }    
    // 遍历其他NCPU-1个CPU的空闲物理页链表 
    for (i = 1; i < NCPU; ++i) {
        if (++c == NCPU) {
            c = 0;
        }
        acquire(&kmems[c].lock);
        // 若链表不为空
        if (kmems[c].freelist) {
            // 快慢双指针算法将链表一分为二
            slow = head = kmems[c].freelist;
            fast = slow->next;
            while (fast) {
                fast = fast->next;
                if (fast) {
                    slow = slow->next;
                    fast = fast->next;
                }
            }
            // 后半部分作为当前CPU的空闲链表
            kmems[c].freelist = slow->next;
            release(&kmems[c].lock);
            // 前半部分的链表结尾清空,由于该部分链表与其他链表不再关联,因此无需加锁
            slow->next = 0;
            // 返回前半部分的链表头
            return head;
        }
        release(&kmems[c].lock);
    }
    // 若其他CPU物理页均为空则返回空指针
    return 0;
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;
  // lab8-1
  int c;
  push_off();
  c = cpuid();
  pop_off();
  // get the page from the current cpu's freelist
  acquire(&kmems[c].lock);
  r = kmems[c].freelist;
  if(r)
    kmems[c].freelist = r->next;
  release(&kmems[c].lock);
  // steal page - lab8-1
  // 若当前CPU空闲物理页为空,且偷取到了物理页
  if(!r && (r = steal(c))) {
    // 加锁修改当前CPU空闲物理页链表
    acquire(&kmems[c].lock);
    kmems[c].freelist = r->next;
    release(&kmems[c].lock);
  }

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
