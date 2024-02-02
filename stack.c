#include "stack.h"

__attribute__((section(".stack"))) unsigned char fiq_stack[FIQ_STACK_SIZE];
__attribute__((section(".stack"))) unsigned char irq_stack[IRQ_STACK_SIZE];
__attribute__((section(".stack"))) unsigned char abt_stack[ABT_STACK_SIZE];
__attribute__((section(".stack"))) unsigned char udf_stack[UDF_STACK_SIZE];
__attribute__((section(".stack"))) unsigned char svc_stack[UDF_STACK_SIZE];
__attribute__((section(".stack"))) unsigned char sys_stack[UDF_STACK_SIZE];
