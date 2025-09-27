BaseOfLoader            equ 0x9000 ; Loader的基址
OffsetOfLoader          equ 0x100  ; Loader的偏移

BaseOfLoaderPhyAddr     equ BaseOfLoader * 10h ; Loader被装载到的物理地址

BaseOfKernelFile            equ 0x8000 ; Kernel的基址
OffsetOfKernelFile          equ 0x0  ; Kernel的偏移

BaseOfKernelFilePhyAddr     equ BaseOfKernelFile * 10h ; Kernel被装载到的物理地址
KernelEntryPointPhyAddr     equ 0x100000 ; Kernel入口点，一定要与编译命令一致！！！