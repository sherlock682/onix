//基础的显卡驱动
#include <onix/console.h>
#include <onix/io.h>

#define CRT_ADDR_REG 0x3D4
#define CRT_DATA_REG 0x3D5

#define CRT_START_ADDR_H 0xC
#define CRT_START_ADDR_L 0xD
#define CRT_CURSOR_H 0xE
#define CRT_CURSOR_L 0xF

#define MEM_BASE 0xB8000
#define MEM_SIZE 0x4000
#define MEM_END (MEM_BASE + MEM_SIZE)
#define WIDTH 80
#define HEIGHT 25
#define ROW_SIZE (WIDTH * 2)
#define SCR_SIZE (ROW_SIZE * HEIGHT)

#define ASCII_NUL 0x00
#define ASCII_ENQ 0x05
#define ASCII_BEL 0x07
#define ASCII_BS 0x08
#define ASCII_HT 0x09
#define ASCII_LF 0x0A
#define ASCII_VT 0x0B
#define ASCII_FF 0x0C
#define ASCII_CR 0x0D
#define ASCII_DEL 0x7F

static u32 screen;//显示器开始的内存的位置

static u32 pos;//记录当前光标的位置坐标

static x, y;//当前光标的坐标

static u8 attr = 7;//字符样式

static u16 erase = 0x0720;//空格

//获得当前显示器的开始的光标位置
static void get_screen()
{
    outb(CRT_ADDR_REG, CRT_START_ADDR_H);//开始地址的高位置
    screen = inb(CRT_DATA_REG) << 8;     //开始地址高八位
    outb(CRT_ADDR_REG, CRT_START_ADDR_L);
    screen |= inb(CRT_DATA_REG);

    screen <<= 1;
    screen += MEM_BASE;
}

void console_clear();
void console_write(char *buf, u32 count);

void console_init(){
    get_screen();
}