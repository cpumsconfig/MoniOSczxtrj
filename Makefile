all : error

error:
	@echo "ERROR:禁止直接输入make命令，请输入make <数字>，比如make 1会指定编译boot1.asm"

# 数字1-9
0:
	nasm -o boot.bin boot.asm
1:
	nasm -o boot.bin boot1.asm
	nasm -o loader.bin loader.asm
	nasm -f elf -o kernel.o kernel.asm
	i686-elf-ld -s -o kernel.bin kernel.o
	dd if=/dev/zero of=disk.img bs=512 count=2880
	dd if=boot.bin of=disk.img bs=512 count=1
	edimg imgin:disk.img copy from:loader.bin to:@: copy from:kernel.bin to:@: imgout:disk.img

2:
	nasm -o boot.bin boot2.asm
3:
	nasm -o boot.bin boot3.asm
4:
	nasm -o boot.bin boot4.asm
5:
	nasm -o boot.bin boot5.asm
6:
	nasm -o boot.bin boot6.asm
7:
	nasm -o boot.bin boot7.asm
8:
	nasm -o boot.bin boot8.asm
9:
	nasm -o boot.bin boot9.asm
10:
	nasm -o boot.bin boot10.asm
11:
	nasm -o boot.bin boot11.asm
12:
	nasm -o boot.bin boot12.asm
13:
	nasm -o boot.bin boot13.asm
14:
	nasm -o boot.bin boot14.asm
15:
	nasm -o boot.bin boot15.asm
16:
	nasm -o boot.bin boot16.asm
17:
	nasm -o boot.bin boot17.asm
18:
	nasm -o boot.bin boot18.asm
19:
	nasm -o boot.bin boot19.asm
20:
	nasm -o boot.bin boot20.asm
21:
	nasm -o boot.bin boot21.asm
22:
	nasm -o boot.bin boot22.asm
23:
	nasm -o boot.bin boot23.asm
24:
	nasm -o boot.bin boot24.asm
25:
	nasm -o boot.bin boot25.asm
26:
	nasm -o boot.bin boot26.asm
27:
	nasm -o boot.bin boot27.asm
28:
	nasm -o boot.bin boot28.asm
29:
	nasm -o boot.bin boot29.asm
30:
	nasm -o boot.bin boot30.asm
31:
	nasm -o boot.bin boot31.asm
32:
	nasm -o boot.bin boot32.asm
33:
	nasm -o boot.bin boot33.asm
34:
	nasm -o boot.bin boot34.asm
35:
	nasm -o boot.bin boot35.asm
36:
	nasm -o boot.bin boot36.asm
37:
	nasm -o boot.bin boot37.asm	
38:
	nasm -o boot.bin boot38.asm
39:
	nasm -o boot.bin boot39.asm
40:
	nasm -o boot.bin boot40.asm
41:
	nasm -o boot.bin boot41.asm
42:
	nasm -o boot.bin boot42.asm
43:
	nasm -o boot.bin boot43.asm
44:
	nasm -o boot.bin boot44.asm

clean:
	rm -f boot.bin

run:
	qemu-system-i386 -fda boot.bin