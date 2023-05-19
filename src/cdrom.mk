include makefile

$(BUILD)/kernel.iso : $(BUILD)/kernel.bin $(SRC)/utils/grub.cfg

	grub-file --is-x86-multiboot2 $<

	mkdir -p $(BUILD)/iso/boot/grub

	cp $< $(BUILD)/iso/boot

	cp $(SRC)/utils/grub.cfg $(BUILD)/iso/boot/grub

	grub-mkrescue -o $@ $(BUILD)/iso

.PHONY: bochsb
bochsb: $(BUILD)/kernel.iso
	bochs -q -f ../bochs/bochsrc.grub -unlock

QEMU += -drive file=$(BUILD)/kernel.iso,media=cdrom

QEMU_CDROM:=-boot d

.PHONY: qemub
qemub: $(BUILD)/kernel.iso $(IMAGES)
	$(QEMU) $(QEMU_CDROM) \
	# $(QEMU_DEBUG)

.PHONY: cdrom
qemub: $(BUILD)/kernel.iso $(IMAGES)
	-