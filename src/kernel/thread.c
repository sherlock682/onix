#include <onix/interrupt.h>
#include <onix/syscall.h>
#include <onix/debug.h>
#include <onix/task.h>
#include <onix/stdio.h>
#include <onix/arena.h>

#define LOGK(fmt, args...) DEBUGK(fmt, ##args)

void idle_thread()
{
    set_interrupt_state(true);
    u32 counter = 0;
    while(true)
    {
        // LOGK("idle task....%d\n", counter++);
        asm volatile("sti\n"   //开中断
                     "hlt\n"); //关闭CPU，等待外中断
        yield();
    }
}

static void real_init_thread()
{
    u32 counter = 0;
    while(true)
    {
        BMB;
        // asm volatile("in $0x92,%ax\n");
        sleep(100);
        // LOGK("%c\n",ch);
        // printk("task is in user mode %d\n", counter++);
        // printf("task is in user mode %d\n", counter++);
    }
}

void init_thread()
{
    // set_interrupt_state(true);
    char temp[100];
    task_to_user_mode(real_init_thread);
}

void test_thread()
{
    set_interrupt_state(true);
    u32 counters = 0;

    while(true)
    {
        // LOGK("tesk task %d....\n", counters++);
        // sleep(709);
        void *ptr = kmalloc(1200);
        LOGK("kmallocox%p....\n", ptr);
        kfree(ptr);

        ptr = kmalloc(1024);
        LOGK("kmallocox%p....\n", ptr);
        kfree(ptr);

        ptr = kmalloc(54);
        LOGK("kmallocox%p....\n", ptr);
        kfree(ptr);

        sleep(2000);
    }
}