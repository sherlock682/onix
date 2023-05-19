BUILD:=../build
SRC:=.

MULTIBOOT2:=0x10000
ENTRYPOINT:=$(shell python -c "print(f'0x{$(MULTIBOOT2) + 64:x}')")

CFLAGS:= -m32 					# 32 位的程序
CFLAGS+= -fno-builtin			# 不需要 gcc 内置函数
CFLAGS+= -nostdinc				# 不需要标准头文件
CFLAGS+= -fno-pic				# 不需要位置无关的代码  position independent code
CFLAGS+= -fno-pie				# 不需要位置无关的可执行程序 position independent executable
CFLAGS+= -nostdlib				# 不需要标准库
CFLAGS+= -fno-stack-protector	# 不需要栈保护

CFLAGS:=$(strip ${CFLAGS})

DEBUG:= -g
INCLUDE:= -I$(SRC)/include

$(BUILD)/boot/%.bin: $(SRC)/boot/%.asm
	$(shell mkdir -p $(dir $@))
	nasm -f bin $< -o $@

$(BUILD)/%.o: $(SRC)/%.asm 
	$(shell mkdir -p $(dir $@))
	nasm -gdwarf -f elf32 $(DEBUG) $< -o $@
	
$(BUILD)/%.o: $(SRC)/%.c
	$(shell mkdir -p $(dir $@))
	gcc $(CFLAGS) $(DEBUG) $(INCLUDE) -c $< -o $@

LDFLAGS:= -m elf_i386 \
		-static \
		-Ttext $(ENTRYPOINT)\
		--section-start=.multiboot2=$(MULTIBOOT2)
LDFLAGS:=$(strip ${LDFLAGS})

$(BUILD)/kernel.bin: \
	$(BUILD)/kernel/start.o \
	$(BUILD)/kernel/main.o \
	$(BUILD)/kernel/io.o \
	$(BUILD)/kernel/device.o \
	$(BUILD)/kernel/console.o \
	$(BUILD)/kernel/printk.o \
	$(BUILD)/kernel/assert.o \
	$(BUILD)/kernel/debug.o \
	$(BUILD)/kernel/global.o \
	$(BUILD)/kernel/task.o \
	$(BUILD)/kernel/mutex.o \
	$(BUILD)/kernel/gate.o \
	$(BUILD)/kernel/schedule.o \
	$(BUILD)/kernel/interrupt.o \
	$(BUILD)/kernel/handler.o \
	$(BUILD)/kernel/clock.o \
	$(BUILD)/kernel/time.o \
	$(BUILD)/kernel/rtc.o \
	$(BUILD)/kernel/memory.o \
	$(BUILD)/kernel/thread.o \
	$(BUILD)/kernel/keyboard.o \
	$(BUILD)/kernel/arena.o \
	$(BUILD)/kernel/ide.o \
	$(BUILD)/lib/bitmap.o \
	$(BUILD)/lib/string.o \
	$(BUILD)/lib/vsprintf.o \
	$(BUILD)/lib/stdlib.o \
	$(BUILD)/lib/syscall.o \
	$(BUILD)/lib/list.o \
	$(BUILD)/lib/fifo.o \
	$(BUILD)/lib/printf.o \

	$(shell mkdir -p $(dir $@))
	ld ${LDFLAGS} $^ -o $@

$(BUILD)/system.bin: $(BUILD)/kernel.bin
	objcopy -O binary $< $@

$(BUILD)/system.map: $(BUILD)/kernel.bin
	nm $< | sort > $@

$(BUILD)/master.img: $(BUILD)/boot/boot.bin \
	$(BUILD)/boot/loader.bin \
	$(BUILD)/system.bin \
	$(BUILD)/system.map \
	$(SRC)/utils/master.sfdisk \

	yes | bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat $@
	dd if=$(BUILD)/boot/boot.bin of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BUILD)/boot/loader.bin of=$@ bs=512 count=4 seek=2 conv=notrunc
	test -n "$$(find $(BUILD)/system.bin -size -100k)"    
	dd if=$(BUILD)/system.bin of=$@ bs=512 count=200 seek=10 conv=notrunc
	sfdisk $@ < $(SRC)/utils/master.sfdisk 

$(BUILD)/slave.img:
#创建一个32M的硬盘镜像
	yes | bximage -q -hd=32 -func=create -sectsize=512 -imgmode=flat $@

IMAGES:=$(BUILD)/master.img $(BUILD)/slave.img

image: $(IMAGES)

.PHONY: clean
clean:
	rm -rf $(BUILD)

.PHONY: bochs
bochs: $(IMAGES)
	bochs -q -f ../bochs/bochsrc

.PHONY: bochsg
bochsg: $(IMAGES)
	bochs-gdb -q -f ../bochs/bochsrc.gdb -unlock

QEMU:= qemu-system-i386 # 虚拟机
QEMU+= -m 32M # 内存
QEMU+= -audiodev pa,id=snd # 音频设备
QEMU+= -machine pcspk-audiodev=snd # pcspeaker 设备
QEMU+= -rtc base=localtime # 设备本地时间
QEMU+= -drive file=$(BUILD)/master.img,if=ide,index=0,media=disk,format=raw # 主硬盘
QEMU+= -drive file=$(BUILD)/slave.img,if=ide,index=1,media=disk,format=raw # 从硬盘

QEMU_DISK_BOOT:=-boot c

QEMU_DEBUG:= -s -S


.PHONY: qemu
qemu: $(IMAGES)
	$(QEMU) $(QEMU_DISK)
	

.PHONY: qemug
qemug: $(IMAGES)
	$(QEMU) $(QEMU_DISK) $(QEMU_DEBUG) 


$(BUILD)/master.vmdk:$(BUILD)/master.img
	qemu-img convert -pO vmdk $< $@

.PHONY:vmdk
vmdk:$(BUILD)/master.vmdk