CFLAGS:= -m32
CFLAGS+= -Qn
# CFLAGS+= -fno-builtin
# CFLAGS+= -nostdinc
CFLAGS+= -fno-pic
# CFLAGS+= -fno-pie
# CFLAGS+= -nostdlib
# CFLAGS+= -fno-stack-protector
# CFLAGS+= -fomit-frame-pointer
CFLAGS+= -mpreferred-stack-boundary=2
CFLAGS+= -fno-asynchronous-unwind-tables #不需要CFI
CFLAGS:=$(strip ${CFLAGS})


.PHONY:hello.s
hello.s:hello.c
	gcc $(CFLAGS) -S $< -o $@

.PHONY:params.s
params.s:params.c
	gcc $(CFLAGS) -S $< -o $@

.PHONY: clean
clean:
	rm -rf *.o
	rm -rf *.out
