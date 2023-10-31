/*declare constants for the multiboot header.*/
.set ALIGN,     1<<0
.set MEMINFO,   1<<1
.set FLAGS,     ALIGN | MEMINFO
.set MAGIC,    0x1BADB002
.set CHECKSUM, -(MAGIC + FLAGS)


/*multiboot header that declares the program as a kernel.*/
/*magic values documented in the multiboot standard*/
/*these values are searched for in the first 8 KiB of the kernel file*/
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/*the kernel is responsible for providing a stack
the following allocates a small stack of size 0x5000, that grows downwards
stack must be 16-byte aligned according to the system V ABI standard*/
.section .bss
.align 16
stack_bottom:
.skip 16384
stack_top:

/*the linker script for this project specifes _start as the entry point to the kernel
the bootloader will jump to this position once the kernel has been loaded
doesn't return as the bootloader is gone*/
.section .text
.global _start
.type _start, @function
_start:

    /*
    I am now loaded into 32-bit protected mode on a x86 machine
    there are not interrupts, paging, and the processor state is as defined in th e multiboot standard
    I have full control of the CPU
    The kernel can only make use of hardware and any code that is apart of itself
    no security restrictions, safegaurds, debugging mechanisms. only what I can provide.
    Everything that can be done, is what I provide
    */

    /*set up the stack in esp*/
    mov $stack_top, %esp

    /*
    next is when the processor must be initialized
    things like GDT and paging should be started
    */

    /*enter the high-level kernel. */
    call kernel_main

    /*
    At this point, the system as nothing more to do; so put the computer into an infinite loop
    1) use cli to disable interrupts
    2) wait for the next interupt with hlt(halt instruction) this will lock up computer as interrupts are disabled
    3) jump to the hlt instruction incase it ever does wake up
    */
    cli
1:  hlt
    jmp 1b

/*set size of the _start symbol*/
.size _start, . - _start
