# makefile
Makefile是一种文件，通常用于构建软件工程，特别是C或C++项目。它可以自动化构建过程，可以处理从源代码到可执行文件的整个构建过程。Makefile包含指示如何编译和链接源文件的规则。

Makefile通常包含以下几个部分：

1. 宏定义：使用变量来保存命令和文件路径等信息，方便在Makefile中引用。

2. 依赖关系：指定源文件和目标文件之间的依赖关系。Make程序根据这些依赖关系来判断哪些文件需要重新编译。

3. 目标规则：定义了如何生成目标文件。

4. 显式规则：定义了如何生成一个或多个目标文件。

5. 隐含规则：定义了如何生成一个或多个目标文件的默认规则。例如，当Make程序需要编译C文件时，它会自动使用C编译器进行编译

## makefile的基础语法
```makefile
target: dependencies
    command
```
其中，`target`是目标文件，`dependencies`是依赖的源文件，`command`是生成目标文件的命令。

构建目标，使用`make`指令

## 关于目前makefile文件的代码解析

**版本0.1**
```makefile
BUILD:=../build#构建输出目录为 `../build`
SRC:=.#源代码目录为当前目录

ENTRYPOINY:=0x10000#内核的入口地址为 0x10000

#源代码目录下的 `boot/*.asm` 文件编译成二进制文件，输出到 `$(BUILD)/boot` 目录中。
$(BUILD)/boot/%.bin: $(SRC)/boot/%.asm
	$(shell mkdir -p $(dir $@))
	nasm -f bin $< -o $@

#将源代码目录下的 `kernel/*.asm` 文件编译成 ELF 格式的目标文件，输出到 `$(BUILD)/kernel` 目录中
$(BUILD)/kernel/%.o: $(SRC)/kernel/%.asm
	$(shell mkdir -p $(dir $@))
	nasm -f elf32 $< -o $@
	
#将 '$(BUILD)/kernel/start.o' 目标文件链接成 '$(BUILD)/kernel.bin' 文件，同时设置入口地址为 'ENTRYPOINY' 定义的值
$(BUILD)/kernel.bin: $(BUILD)/kernel/start.o
	$(shell mkdir -p $(dir $@))
	ld -m elf_i386 -static $^ -o $@ -Ttext $(ENTRYPOINY)

#将 `$(BUILD)/kernel.bin` 文件转换为纯二进制格式的 `$(BUILD)/system.bin` 文件
$(BUILD)/system.bin: $(BUILD)/kernel.bin
	objcopy -O binary $< $@ 
    #`objcopy`是一个用于将目标文件中的一些数据复制到另一个文件中的工具。它可以复制符号表、重定位表等。

#生成内核符号表文件 '$(BUILD)/system.map'，便于调试
$(BUILD)/system.map: $(BUILD)/kernel.bin
	nm $< | sort > $@
    #`nm` 是 GNU Binutils 工具集提供的一个命令行工具，用于显示二进制文件（ELF 格式、COFF 格式等）的符号表
    #`sort` 命令用于将符号表中的符号按字典序排序

#生成一个虚拟硬盘镜像文件 `$(BUILD)/master.img`，并将编译好的引导程序和内核写入其中
$(BUILD)/master.img: $(BUILD)/boot/boot.bin \
	$(BUILD)/boot/loader.bin \
	$(BUILD)/system.bin \
	$(BUILD)/system.map \

	yes | bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat $@
	dd if=$(BUILD)/boot/boot.bin of=$@ bs=512 count=1 conv=notrunc
	dd if=$(BUILD)/boot/loader.bin of=$@ bs=512 count=4 seek=2 conv=notrunc
	dd if=$(BUILD)/system.bin of=$@ bs=512 count=200 seek=10 conv=notrunc

#定义了一个目标 ，并且目标依赖于后者文件或者命令
test:$(BUILD)/master.img

#伪目标
.PHONY: clean
clean:
	rm -rf $(BUILD)

.PHONY: bochs
bochs: $(BUILD)/master.img
	bochs -q
```

