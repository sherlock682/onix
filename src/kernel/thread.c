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

void test_recursion()
{
    char tmp[400];
    test_recursion();
}

static void real_init_thread()
{
    u32 counter = 0;

    char ch;
    while (true)
    {
        // test();
        printf("task is in user mode %d\n", counter++);
        BMB;
        test_recursion();
        sleep(100);
        // LOGK("%c\n",ch);
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
        LOGK("tesk task %d....\n", counters++);
        BMB;
        sleep(2000);
    }
}