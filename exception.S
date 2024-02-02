#include "cpu.h"

.text
.arm

.global arm_undef_instruction
.global arm_software_interrupt
.global arm_prefetch_abort
.global arm_data_abort
.global arm_not_used
.global arm_irq
.global arm_fiq

.macro save_regs
	str lr, [sp, #-4]
	mrs lr, spsr
	str lr, [sp, #-8]
	str r1, [sp, #-12]
	str r0, [sp, #-16]
	mov r0, sp
	cps #0x13
	ldr r1, [r0, #-4]
	str r1, [sp, #-4]!
	ldr r1, [r0, #-8]
	str r1, [sp, #-(4 * 16)]
	ldr r1, [r0, #-12]
	ldr r0, [r0, #-16]
	stmdb sp, {r0 - r14}^
	sub sp, sp, #(4 * 16)
	ldr r4, [sp]
	and r0, r4, #0x1f
	cmp r0, #0x10
	beq 10f
	cmp r0, #0x13
	beq 11f
	b .
11:	add r1, sp, #(4 * 17)
	str r1, [sp, #(4 * 14)]
	str lr, [sp, #(4 * 15)]
10:	add r1, sp, #(4 * 17)
	str r1, [sp, #-4]!
	mov r0, sp
.endm

.macro restore_regs
	mov r12, sp
	ldr sp, [r12], #4
	ldr r1, [r12], #4
	msr spsr_cxsf, r1
	and r0, r1, #0x1f
	cmp r0, #0x10
	beq 20f
	cmp r0, #0x13
	beq 21f
	b .
20:	ldr lr, [r12, #(4 * 15)]
	ldmia r12, {r0 - r14}^
	movs pc, lr
21:	ldm r12, {r0 - r15}^
	mov r0, r0
.endm

arm_undef_instruction:
	sub lr, lr, #4
	save_regs
	bl arm32_do_undefined_instruction
	restore_regs
    b .

arm_software_interrupt:
	sub lr, lr, #4
	save_regs
	bl arm32_do_software_interrupt
	restore_regs
	b .

arm_prefetch_abort:
	sub lr, lr, #4
	save_regs
	bl arm32_do_prefetch_abort
	restore_regs
	b .

arm_data_abort:
	sub lr, lr, #8
	save_regs
	bl arm32_do_data_abort
	restore_regs
	b .

arm_not_used:
	b .

arm_irq:
	sub lr, lr, #4
	save_regs
	bl arm32_do_irq
	restore_regs
	b .

arm_fiq:
	sub lr, lr, #4
	save_regs
	bl arm32_do_irq
	restore_regs
	b .