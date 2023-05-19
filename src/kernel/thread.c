#include <onix/interrupt.h>
#include <onix/syscall.h>
#include <onix/debug.h>
#include <onix/task.h>
#include <onix/stdio.h>
#include <onix/arena.h>
#include <onix/stdlib.h>

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

    int status;
    while (true)
    {
        // test();
        // printf("init thread %d %d %d...\n", getpid(), getppid(), counter++);
        // pid_t pid = fork();

        // if(pid)
        // {
        //     printf("fork after parent %d %d %d\n", pid, getpid(), getppid());
        //     // sleep(1000);
        //     pid_t child = waitpid(pid, &status);
        //     printf("wait pid %d status %d %d\n", child, status, time());
        // }
        // else
        // {
        //     printf("fork after child %d %d %d\n", pid, getpid(), getppid());
        //     // sleep(1000);
        //     exit(0);
        // }
        sleep(1000);
        // printf("task is in user mode %d\n", counter++);
    }
}

void init_thread()
{
    char temp[100];
    task_to_user_mode(real_init_thread);
}

void test_thread()
{
    set_interrupt_state(true);
    u32 counter = 0;

    while(true)
    {
        test();
        // sleep(2000);
    }
}