#include <onix/interrupt.h>
#include <onix/syscall.h>
#include <onix/debug.h>
#include <onix/task.h>
#include <onix/stdio.h>
#include <onix/arena.h>
#include <onix/fs.h>

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

extern void osh_main();

static void real_init_thread()
{
    while (true)
    {
        u32 status;
        pid_t pid = fork();
        if(pid)
        {
            pid_t child = waitpid(pid, &status);
            printf("wait pid %d status %d %d\n", child, status, time());
        }
        else
        {
            osh_main();
        }
    }
}

extern void dev_init();

void init_thread()
{
    char temp[100];
    dev_init();
    task_to_user_mode(real_init_thread);
}

void test_thread()
{
    set_interrupt_state(true);
    // test();
    while (true)
    {
        sleep(10);
    }
}