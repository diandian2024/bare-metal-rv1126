#include "cpu.h"
#include "stack.h"

.section .text
.arm

.global __start
.type __start, %function
__start:
    b   __reset
	ldr pc, =arm_undef_instruction
	ldr pc, =arm_software_interrupt
	ldr pc, =arm_prefetch_abort
	ldr pc, =arm_data_abort
	ldr pc, =arm_not_used
	ldr pc, =arm_irq
	ldr pc, =arm_fiq

__reset:
    /* relocate self */ 
	adr r0, __start  
	ldr r1, =__start
					
	cmp r0, r1
	beq relocate_complete
	
	ldr r2, =__bss_s__

cpy:
	ldr r3, [r0]
	add r0, r0, #4
	
	str r3, [r1]
	add r1, r1, #4

	cmp r1, r2      
	blo cpy

relocate_complete:
	/* Set vector base address register */
	ldr r0, =__start
	mcr p15, 0, r0, c12, c0, 0
	mrc p15, 0, r0, c1, c0, 0
	bic r0, #(1 << 13)
	mcr p15, 0, r0, c1, c0, 0    

    /* Enable neon/vfp unit */
	mrc p15, 0, r0, c1, c0, 2
	orr r0, r0, #(0xf << 20)
	mcr p15, 0, r0, c1, c0, 2
	isb
	mov r0, #0x40000000
	vmsr fpexc, r0

    /* Initialize stacks */
    ldr r5, =(fiq_stack + FIQ_STACK_SIZE)
    ldr r6, =(irq_stack + IRQ_STACK_SIZE)
    ldr r7, =(abt_stack + ABT_STACK_SIZE)
    ldr r8, =(udf_stack + UDF_STACK_SIZE)
    ldr r9, =(svc_stack + SVC_STACK_SIZE)
    ldr r10, =(sys_stack + SYS_STACK_SIZE)

    /* FIQ mode stack */
    msr CPSR_c, #(MODE_FIQ | I_BIT | F_BIT)
    mov sp, r5

    /* IRQ mode stack */
    msr CPSR_c, #(MODE_IRQ | I_BIT | F_BIT)
    mov sp, r6

    /* ABT mode stack */
    msr CPSR_c, #(MODE_ABT | I_BIT | F_BIT)
    mov sp, r7

    /* UND mode stack */
    msr CPSR_c, #(MODE_UND | I_BIT | F_BIT)
    mov sp, r8

    /* SYS mode stack */
    msr CPSR_c, #(MODE_SYS | I_BIT | F_BIT)
    mov sp, r10

    /* SVC mode stack */
    msr CPSR_c, #(MODE_SVC | I_BIT | F_BIT)
    mov sp, r9

    b pre_c


flag_1:
    movw r0, #0x0000
    movt r0, #0xff57
    mov r1, 0x3E
    str r1, [r0]
    bx lr
